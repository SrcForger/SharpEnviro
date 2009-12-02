{
Source Name: SharpBar.dpr
Description: SharpBar Application File
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

program SharpBar;

uses
  Forms,
  Windows,
  SysUtils,
  Types,
  StrUtils,
  Graphics,
  SharpBarMainWnd in 'Forms\SharpBarMainWnd.pas' {SharpBarMainForm},
  JclSimpleXML,
  JclFileUtils,
  SharpEBar,
  SharpApi,
  MonitorList,
  BarHideWnd in 'Forms\BarHideWnd.pas' {BarHideForm},
  uSharpEModuleManager in 'uSharpEModuleManager.pas',
  uISharpESkin in '..\..\Common\Interfaces\uISharpESkin.pas',
  uISharpBar in '..\..\Common\Interfaces\uISharpBar.pas',
  uSharpBarInterface in 'uSharpBarInterface.pas';

{$R *.res}
{$R metadata.res}

const
 NO_REMOVE_EMPTY_BARS_PARAM = '-noREB';
 NO_LOAD_AUTO_START_BARS_PARAM = '-noLASB';
 LOAD_BY_ID_PARAM = '-load:';
 X_POS = '-x:';
 Y_POS = '-y:';

// check the settings file and find + delete all bars which have
// no modules in the list and which are not running at the moment
// result = False --- on Error
function RemoveEmptyBars : boolean;
var
  Dir : String;
  xml : TJclSimpleXML;
  handle  : THandle;
  sr : TSearchRec;
  fileloaded : boolean;
  delbar : boolean;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  xml := TJclSimpleXMl.Create;
  try
    if FindFirst(Dir + '*',FADirectory,sr) = 0 then
    begin
      repeat
        if FileCheck(Dir + sr.Name + '\Bar.xml',True) then
        begin
          fileloaded := False;
          try
            xml.LoadFromFile(Dir + sr.Name + '\Bar.xml');
            fileloaded := True;
          except
            on E: Exception do
            begin
              SharpApi.SendDebugMessageEx('SharpBar',PChar('(RemoveEmptyBars): Error loading '+Dir + sr.Name + '\Bar.xml'), clred, DMT_ERROR);
              SharpApi.SendDebugMessageEx('SharpBar',PChar(E.Message),clblue, DMT_TRACE);
            end;
          end;
          delbar := False;
          if fileloaded then
          begin
            if xml.Root.Items.ItemNamed['Modules'] <> nil then
            begin
              if xml.Root.Items.ItemNamed['Modules'].Items.Count = 0 then
                delbar := True
            end else delbar := True;
            if delbar then
            begin
              // check if this is bar is already running before deleting it
              handle := FindWindow(nil,PChar('SharpBar_'+sr.Name));
              if handle = 0 then
                DeleteDirectory(Dir + sr.Name,True);
            end;
          end;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  finally
    xml.Free;
  end;
  result := True;
end;

function CheckIfValidBar(ID : integer) : boolean;
var
  Dir : String;
  sr : TSearchRec;
  CompareID : integer;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  if FindFirst(Dir + '*',FADirectory,sr) = 0 then
  repeat
    if TryStrToInt(sr.Name,CompareID) then
      if CompareID = ID then
      begin
        result := True;
        exit;
      end;
  until FindNext(sr) <> 0;
  FindClose(sr);
  
  result := False;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

// starts all bars which are set to AutoStart = True;
function LoadAutoStartBars : boolean;
var
  Dir : String;
  xml : TJclSimpleXML;
  handle  : THandle;
  sr : TSearchRec;
  fileloaded : boolean;
  lab : boolean;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  xml := TJclSimpleXMl.Create;
  try
    lab := False;
    if FindFirst(Dir + '*',FADirectory,sr) = 0 then
    begin
      repeat
        if FileCheck(Dir + sr.Name + '\Bar.xml',True) then
        begin
          fileloaded := False;
          try
            xml.LoadFromFile(Dir + sr.Name + '\Bar.xml');
            fileloaded := True;
          except
            on E: Exception do
            begin
              SharpApi.SendDebugMessageEx('SharpBar',PChar('(LoadAutoStartBars): Error loading '+Dir + sr.Name + '\Bar.xml'), clred, DMT_ERROR);
              SharpApi.SendDebugMessageEx('SharpBar',PChar(E.Message),clblue, DMT_TRACE);
            end;
          end;
          if fileloaded then
          begin
            if xml.Root.Items.ItemNamed['Settings'] <> nil then
              if xml.Root.Items.ItemNamed['Settings'].Items.BoolValue('AutoStart',True) then
              begin
                // check if this is bar is already running before deleting it
                handle := FindWindow(nil,PChar('SharpBar_'+ sr.Name));
                if handle = 0 then
                begin
                  if SharpApi.SharpExecute('_nohist,' + ExtractFileDir(Application.ExeName)+'\SharpBar.exe '
                     + NO_LOAD_AUTO_START_BARS_PARAM + ' '
                     + NO_REMOVE_EMPTY_BARS_PARAM + ' '
                     + LOAD_BY_ID_PARAM+sr.Name) = HR_OK then lab := true;
                  sleep(500);
                end else lab := true; // an auto start bar is already running!
                end;
              end;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  finally
    xml.Free;
  end;

  result := lab;
end;

var
  ParamID : integer;
  ParamString : string;
  ps : string;
  n : integer;
  x,y : integer;
  noREB,noLASB : boolean;
  Mon : TMonitorItem;
begin
  // Possible exec Params
  // SharpBar.exe -noLASB  ::: no LoadAutoStartBars
  // SharpBar.exe -noREB   ::: disable RemoveEmptyBars check
  // SharpBar.exe -load:-1 ::: create a new and empty bar
  // SharpBar.exe -load:ID ::: load the bar with BarID = ID
  // SharpBar.exe          ::: no param --- start all bars with autostart = true

  noREB := False;
  noLASB := False;
  setlength(ParamString,0);

  x := -1;
  y := -1;

  // Check all exec params
  for n := 0 to ParamCount do
  begin
    ps := ParamStr(n);
    setlength(ps,6);
    if CompareText(ps,LOAD_BY_ID_PARAM) = 0 then
    begin
      ps := RightStr(ParamStr(n),length(paramStr(n))-length(LOAD_BY_ID_PARAM));
      ParamString := ps;
    end else
        if CompareText(ParamStr(n),NO_REMOVE_EMPTY_BARS_PARAM) = 0 then noREB := True
        else
        if CompareText(ParamStr(n),NO_LOAD_AUTO_START_BARS_PARAM) = 0 then noLASB := True
        else
        begin
          ps := ParamStr(n);
          setlength(ps,3);
          if CompareText(ps,X_POS) = 0 then
          begin
            ps := RightStr(ParamStr(n),length(paramStr(n))-length(X_POS));
            if trystrtoint(ps,x) then
               x := StrToInt(ps)
               else x := 0;
          end
          else
          if CompareText(ps,Y_POS) = 0 then
          begin
            ps := RightStr(ParamStr(n),length(paramStr(n))-length(Y_POS));
            if trystrtoint(ps,y) then
               y := StrToInt(ps)
               else y := 0;
          end;
        end;
   end;

  // Check the xml file and remove bars without any modules
  if not noREB then RemoveEmptyBars;

  // Set BarID to -1 --- this will tell TSharpBarMainForm to create a new bar
  // if there is no param given

  // Check given exec ID params if this bar is supposed to be empty or
  // if it should be an already existing bar
  if length(trim(ParamString))>0 then
  begin
    // there is a param - now check if it's a valid integer value which
    // could be used as bar ID
    ParamID := StrToIntDef(ParamString,-1);
    if not CheckIfValidBar(ParamID) then ParamID := -1;
  end else
  begin
    // no param given!
    // parse the xml settings and start all bars which are set to
    // autostart = true
    if not noLASB then
       if LoadAutoStartBars then
          halt;
    // no Bar was loaded create new one!
    ParamID := -1;
  end;

  Application.Initialize;
  Application.Title := 'SharpBar';
  mfParamID := ParamID;
  Application.CreateForm(TSharpBarMainForm, SharpBarMainForm);
  SharpBarMainForm.InitBar;
  if (x <> - 1) and (y <> - 1) then
     for n := 0 to MonList.MonitorCount - 1 do
     begin
       Mon := MonList.Monitors[n];
       if PointInRect(Point(x,y),Mon.BoundsRect) then
       begin
         if y > Mon.Top + Mon.Height div 2 then SharpBarMainForm.SharpEBar.VertPos := vpBottom
            else SharpBarMainForm.SharpEBar.VertPos := vpTop;
         if x < Mon.Left + Mon.Width div 2 - 25 then SharpBarMainForm.SharpEBar.HorizPos := hpLeft
         else if x > Mon.Left + Mon.Width div 2 + 25 then SharpBarMainForm.SharpEBar.HorizPos := hpRight
         else if x < Mon.Left + Mon.Width div 2 - 50 then SharpBarMainForm.SharpEBar.HorizPos := hpMiddle;
         break;
       end;
    end;
  SharpBarMainForm.Startup := False;
  SharpBarMainForm.Show;
  ServiceDone('SharpBar');
  SharpApi.SharpEBroadCast(WM_BARSTATUSCHANGED,0,SharpBarMainForm.BarID);
  Application.Run;
  SharpApi.SharpEBroadCast(WM_BARSTATUSCHANGED,1,SharpBarMainForm.BarID);  
end.
