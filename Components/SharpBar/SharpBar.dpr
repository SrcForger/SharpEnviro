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

{$R 'VersionInfo.res'}
{$R 'metadata.res'}
{$R *.res}

uses
//  VCLFixPack,
  Forms,
  Windows,
  SysUtils,
  Types,
  StrUtils,
  Graphics,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  SharpBarMainWnd in 'Forms\SharpBarMainWnd.pas' {SharpBarMainForm},
  JclSimpleXML,
  JclFileUtils,
  SharpEBar,
  SharpApi,
  ShellApi,
  MonitorList,
  BarHideWnd in 'Forms\BarHideWnd.pas' {BarHideForm},
  uSharpEModuleManager in 'uSharpEModuleManager.pas',
  uISharpESkin in '..\..\Common\Interfaces\uISharpESkin.pas',
  uISharpBar in '..\..\Common\Interfaces\uISharpBar.pas',
  uSharpBarInterface in 'uSharpBarInterface.pas',
  uSharpXMLUtils in '..\..\Common\Units\XML\uSharpXMLUtils.pas';

type
  TBarMutex = array of record
    name : string;
    mutex : THandle;
    timeout : integer;
  end;

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
  delbar : boolean;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  xml := TJclSimpleXMl.Create;
  try
    if FindFirst(Dir + '*',FADirectory,sr) = 0 then
    begin
      repeat
        delbar := False;
        if LoadXMLFromSharedFile(XML, Dir + sr.Name + '\Bar.xml',True) then
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
  lab : boolean;
  n : integer;
  IsInt : boolean;
  i : integer;
  modMutex : TBarMutex;
  monitorIndex : Integer;
  primarymon : boolean;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  i := 0;
  SetLength(modMutex, 0);

  xml := TJclSimpleXMl.Create;
  try
    lab := False;
    if FindFirst(Dir + '*',FADirectory,sr) = 0 then
    begin
      repeat
        IsInt := TryStrToInt(sr.Name,n);
        if IsInt then
        begin
          if LoadXMLFromSharedFile(xml,Dir + sr.Name + '\Bar.xml',True) then
          begin
            if xml.Root.Items.ItemNamed['Settings'] <> nil then
              if xml.Root.Items.ItemNamed['Settings'].Items.BoolValue('AutoStart',True) then
              begin
                // Do not start bars for monitors that are not present.
                monitorIndex := xml.Root.Items.ItemNamed['Settings'].Items.IntValue('MonitorIndex', -1);
                primarymon := xml.Root.Items.ItemNamed['Settings'].Items.BoolValue('PrimaryMonitor', True);
                if ((monitorIndex < 0) or (monitorIndex > MonList.MonitorCount - 1))  and (not primarymon) then
                  Continue;
                
                // check if this is bar is already running before deleting it
                handle := FindWindow(nil,PChar('SharpBar_'+ sr.Name));
                if handle = 0 then
                begin
                  if ShellExecute(0,
                                  nil,
                                  PChar(ExtractFileDir(Application.ExeName)+'\SharpBar.exe'),
                                  PChar(NO_LOAD_AUTO_START_BARS_PARAM + ' '
                                        + NO_REMOVE_EMPTY_BARS_PARAM + ' '
                                        + LOAD_BY_ID_PARAM+sr.Name),
                                  PChar(ExtractFilePath(Application.ExeName)),
                                  SW_SHOWNORMAL) > 32 then
                  //if SharpApi.SharpExecute('_nohist,' + ExtractFileDir(Application.ExeName)+'\SharpBar.exe '
                  //   + NO_LOAD_AUTO_START_BARS_PARAM + ' '
                  //   + NO_REMOVE_EMPTY_BARS_PARAM + ' '
                  //   + LOAD_BY_ID_PARAM+sr.Name) = HR_OK then
                  begin
                    lab := true;

                    // Wait for the bar to start
                    SetLength(modMutex, i + 1);
                    modMutex[i].timeout := 10000;
                    modMutex[i].name := 'SharpBar'+sr.Name;
                    i := i + 1;
					        end;
                end else lab := true; // an auto start bar is already running!
              end;
          end else SharpApi.SendDebugMessageEx('SharpBar',PChar('(LoadAutoStartBars): Error loading '+Dir + sr.Name + '\Bar.xml'), clred, DMT_ERROR);
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  finally
    xml.Free;
  end;

  // Wait for the bars to start
  for i := 0 to High(modMutex) do
  begin
    while modMutex[i].timeout > 0 do
    begin
      modMutex[i].mutex := OpenMutex(MUTEX_ALL_ACCESS, False, PChar('started_' + modMutex[i].name));
      if (modMutex[i].mutex = 0) then
      begin
        Sleep(100);
        modMutex[i].timeout := modMutex[i].timeout - 100;
        if modMutex[i].timeout <= 0 then
        begin
          SendDebugMessageEx('SharpBar', 'Timed out waiting for bar #' + IntToStr(i) + ' - ' + modMutex[i].name, 0, DMT_INFO);
          CloseHandle(modMutex[i].mutex);

          break;
        end;
      end else
      begin
        SendDebugMessageEx('SharpBar', 'Started bar #' + IntToStr(i) + ' - ' + modMutex[i].name, 0, DMT_TRACE);
        CloseHandle(modMutex[i].mutex);

        break;
      end;
    end;
  end;

  SetLength(modMutex, 0);

  result := lab;
end;

function MonitorForBarExists(ID : Integer) : Boolean;
var
  filename : string;
  xml : TJclSimpleXML;
  monitorIndex : Integer;
  primarymon : boolean;
begin
  Result := False;
  filename := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + IntToStr(ID) + '\Bar.xml';

  xml := TJclSimpleXMl.Create;
  try
    if LoadXMLFromSharedFile(xml,filename,true) then
    begin
      with xml.Root.Items do
      begin
        if ItemNamed['Settings'] <> nil then
        begin
          monitorIndex := ItemNamed['Settings'].Items.IntValue('MonitorIndex', -1);
          primarymon := ItemNamed['Settings'].Items.BoolValue('PrimaryMonitor', True);
          if ((monitorIndex > -1) and (monitorIndex < MonList.MonitorCount)) or primarymon then
            Result := True;
        end;
      end;
    end;
  finally
    xml.Free;
  end;
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
       begin
          ServiceDone('SharpBar');

          // Start Explorer
          SendMessage(FindWindow('Shell_TrayWnd', nil), WM_SHARPSTARTEXPLORER, 0, 0);

          halt;
       end;
    // no Bar was loaded create new one!
    ParamID := -1;
  end;

  // Do not start bars for monitors that are not present.
  if (ParamID > -1) and (not MonitorForBarExists(ParamID)) then
    Halt;

  Application.Initialize;
  Application.MainFormOnTaskbar := True; 
  Application.Title := 'SharpBar';
  Application.ModalPopupMode := pmAuto;
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
  SharpApi.SharpEBroadCast(WM_BARSTATUSCHANGED,0,SharpBarMainForm.BarID);

  if ParamID >= 0 then
    ServiceDone('SharpBar'+IntToStr(ParamID))
  else
    ServiceDone('SharpBar');
    
  Application.Run;
  SharpApi.SharpEBroadCast(WM_BARSTATUSCHANGED,1,SharpBarMainForm.BarID);
end.