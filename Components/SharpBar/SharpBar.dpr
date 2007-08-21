{
Source Name: SharpBar.dpr
Description: SharpBar Application File
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

program SharpBar;

uses
  Forms,
  Windows,
  Dialogs,
  SysUtils,
  Types,
  StrUtils,
  SharpBarMainWnd in 'Forms\SharpBarMainWnd.pas' {SharpBarMainForm},
  uSharpEModuleManager in 'uSharpEModuleManager.pas',
  uSharpBarAPI in 'uSharpBarAPI.pas',
  JvSimpleXML,
  SharpEBar,
  SharpApi,
  PluginManagerWnd in 'Forms\PluginManagerWnd.pas' {PluginManagerForm},
  AddPluginWnd in 'Forms\AddPluginWnd.pas' {AddPluginForm},
  BarHideWnd in 'Forms\BarHideWnd.pas' {BarHideForm};

{$R *.res}

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
  xml : TJvSimpleXML;
  n : integer;
  BarID : integer;
  handle  : THandle;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';

  if not FileExists(Dir + 'bars.xml') then
  begin
    result := False;
    exit;
  end else
  begin
    xml := TJvSimpleXMl.Create(nil);
    try
      xml.LoadFromFile(Dir + 'bars.xml');
      with xml.root.items.ItemNamed['bars'] do
      begin
        for n := Items.Count - 1 downto 0 do
        begin
          if Items.Item[n].Items.ItemNamed['Modules'] <> nil then
             if Items.Item[n].Items.ItemNamed['Modules'].Items.Count > 0  then
                Continue;
          BarID := Items.Item[n].Items.IntValue('ID',-1);
          // check if a bar with this ID is running
          handle := FindWindow(nil,PChar('SharpBar_'+inttostr(BarID)));
          if handle = 0 then
          begin
            // delete the bar settings
            Items.Delete(n);
            DeleteFile(Dir + 'Module Settings\' + inttostr(BarID)+'.xml');
          end;
        end;
      end;
      xml.SaveToFile(Dir + 'bars.xml~');
      if FileExists(Dir + 'bars.xml') then
         DeleteFile(Dir + 'bars.xml');
      RenameFile(Dir + 'bars.xml~',Dir + 'bars.xml');
    except
      xml.free;
      result := False;
      exit;
    end;
    result := True;
  end;
end;

function CheckIfValidBar(ID : integer) : boolean;
var
  Dir : String;
  xml : TJvSimpleXML;
  n   : integer;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';
  if not FileExistS(Dir + 'bars.xml') then
  begin
    result := false;
    exit;
  end;

  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(Dir + 'bars.xml');
    with xml.root.items.ItemNamed['bars'] do
    begin
      for n := 0 to Items.Count - 1 do
          if Items.Item[n].Items.IntValue('ID') = ID then
          begin
            result := true;
            xml.free;
            exit;
          end;
    end;
  except
  end;
  result := false;
  xml.free;
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
  xml : TJvSimpleXML;
  n,BarID : integer;
  lab     : boolean; // loaded any bar
  handle  : THandle;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';

  lab := false;

  if not FileExists(Dir + 'bars.xml') then
     lab := False
     else
  begin
    xml := TJvSimpleXMl.Create(nil);
    try
      xml.LoadFromFile(Dir + 'bars.xml');
      with xml.root.items.ItemNamed['bars'] do
      begin
        for n := 0 to Items.Count - 1 do
            if Items.Item[n].Items.ItemNamed['Settings'].Items.BoolValue('AutoStart',True) then
            with Items.Item[n].Items do
            begin
              BarID := IntValue('ID',-1);
              // check if a bar with this ID is already running
              handle := FindWindow(nil,PChar('SharpBar_'+inttostr(BarID)));
              if handle = 0 then
              begin
                if SharpApi.SharpExecute('_nohist,' + ExtractFileDir(Application.ExeName)+'\SharpBar.exe '
                   + NO_LOAD_AUTO_START_BARS_PARAM + ' '
                   + NO_REMOVE_EMPTY_BARS_PARAM + ' '
                   + LOAD_BY_ID_PARAM+inttostr(BarID)) = HR_OK then lab := true;
                sleep(500);
              end else lab := true; // an auto start bar is already running!
            end;
      end;
    except
      lab := false;
    end;
    xml.free;
  end;

  if not lab then
  begin
    // no bar was loaded!
    // return false and make the app continue creating a new bar
    result := false;
  end else result := True;
end;

var
  ParamID : integer;
  ParamString : string;
  ps : string;
  n : integer;
  x,y : integer;
  noREB,noLASB : boolean;
  Mon : TMonitor;
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
    try
      ParamID := strtoint(ParamString);
      if not CheckIfValidBar(ParamID) then ParamID := -1;
    except
      ParamID := -1;
    end;
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
     for n := 0 to Screen.MonitorCount - 1 do
     begin
       Mon := Screen.Monitors[n];
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
  Application.Run;
end.
