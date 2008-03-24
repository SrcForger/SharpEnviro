{
Source Name: BatteryMonitor.dpr
Description: SharpBar Module Main Project File
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

library Weather;



uses
  Windows,
  Controls,
  SysUtils,
  Forms,
  Classes,
  Contnrs,
  SharpESkinManager,
  SharpEBar,
  StdCtrls,
  SharpApi,
  uSharpBarApi,
  MouseTimer,
  gr32,
  MainWnd in 'MainWnd.pas' {MainForm},
  SettingsWnd in 'SettingsWnd.pas' {SettingsForm},
  uWeatherParser in '..\..\Objects\Weather\uWeatherParser.pas';

type
  TModule = class
            private
              FForm : TForm;
              FID   : integer;
              FPos  : integer;
              FBarWnd  : hWnd;
            public
              constructor Create(pID,pBarID : integer; pParent : hwnd); reintroduce;
              destructor Destroy; override;

              property ID   : integer read FID;
              property Pos  : integer read FPos write FPos;
              property Form : TForm   read FForm;
              property BarWnd : hWnd  read FBarWnd;
            end;

var
  ModuleList : TObjectList;
  MouseTimer : TMouseTimer;

{$R *.res}

function GetControlByHandle(AHandle: THandle): TWinControl;
begin
 Result := Pointer(GetProp( AHandle,
                            PChar( Format( 'Delphi%8.8x',
                                           [GetCurrentProcessID]))));
end;

constructor TModule.Create(pID,pBarID : integer; pParent : hwnd);
begin
  inherited Create;
  FID   := pID;
  FBarWnd := pParent;
  FForm := TMainForm.CreateParented(pParent);
  FForm.BorderStyle := bsNone;
  try
    FForm.Height := GetBarPluginHeight(FBarWnd);
  except
  end;
  FForm.ParentWindow := pParent;
  MouseTimer.AddWinControl(TMainForm(FForm));
  with FForm as TMainForm do
  begin
    ModuleID := pID;
    BarID    := pBarID;
    BarWnd   := FBarWnd;
    LoadSettings;
    ReAlignComponents(False);
    Show;
  end;
end;

destructor TModule.Destroy;
begin
  FForm.Free;
  FForm := nil;
  inherited Destroy;
end;

function CreateModule(ID : integer;
                      BarID : integer;
                      parent : hwnd) : hwnd;
var
  temp : TModule;
begin
  try
    if ModuleList = nil then
       ModuleList := TObjectList.Create;

    if MouseTimer = nil then
       MouseTimer := TMouseTimer.Create;

    temp := TModule.Create(ID,BarID,parent);
    ModuleList.Add(temp);
  except
    result := 0;
    exit;
  end;
  result := temp.Form.Handle;
end;

function CloseModule(ID : integer) : boolean;
var
  n : integer;
begin
  result := False;
  if ModuleList = nil then exit;

  try
    for n := 0 to ModuleList.Count - 1 do
        if TModule(ModuleList.Items[n]).ID = ID then
        begin
          MouseTimer.RemoveWinControl(TModule(ModuleList.Items[n]).Form);
          if MouseTimer.ControlList.Count = 0 then
             FreeAndNil(MouseTimer);
          ModuleList.Delete(n);
          result := True;
          exit;
        end;
  except
    result := False;
  end;
end;

procedure Refresh(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0  to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.Form).ReAlignComponents(True);
      end;
end;

procedure PosChanged(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0  to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.Form).UpdateBackground;
        TMainForm(temp.Form).Repaint;
        TMainForm(temp.Form).ReAlignComponents(True);
      end;
end;

procedure UpdateMessage(part : TSU_UPDATE_ENUM; param : integer);
const
  processed : TSU_UPDATES = [suSkinFileChanged,suBackground,suTheme,suSkin,
                             suScheme,suSkinFont];
var
  temp : TModule;
  n,i : integer;
begin
  if not (part in processed) then 
    exit;

  if ModuleList = nil then exit;

  for n := 0  to ModuleList.Count - 1 do
  begin
    temp := TModule(ModuleList.Items[n]);

    // Step1: check if height changed
    if [part] <= [suSkinFileChanged,suBackground,suTheme] then
    begin
      i := GetBarPluginHeight(temp.BarWnd);
      if temp.Form.Height <> i then
         temp.Form.Height := i;
    end;

     // Step2: check if skin or scheme changed
    if [part] <= [suScheme,suTheme] then
       TMainForm(temp.Form).SharpESkinManager1.UpdateScheme;
    if (part = suSkinFileChanged) then
       TMainForm(temp.Form).SharpESkinManager1.UpdateSkin;

    // Step3: update
    if [part] <= [suScheme,suBackground,suSkinFileChanged,suTheme] then
    begin
      TMainForm(temp.Form).UpdateBackground;
      if param <> -2 then
         TMainForm(temp.Form).Repaint;
      if [part] <= [suTheme,suSkinFileChanged] then
         TMainForm(temp.Form).ReAlignComponents(True);
    end;

    // Step4: Update if font changed
    if [part] <= [suSkinFont] then
      TMainForm(temp.Form).SharpESkinManager1.RefreshControls;
  end;
end;

procedure ShowSettingsWnd(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.FForm).Settings1Click(TMainForm(temp.FForm).Settings1);
      end;
end;

procedure SetSize(ID : integer; NewWidth : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.FForm).SetSize(NewWidth);
      end;
end;

function ModuleMessage(ID : integer; msg: string): integer;
var
  n : integer;
  temp : TModule;
begin
  result := 0;
  if ModuleList = nil then exit;
  if CompareText(msg,'MM_WEATHERUPDATE') <> 0 then exit;

  for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.FForm).WeatherParser.Update(TMainForm(temp.FForm).WeatherLocation);
        TMainForm(temp.FForm).ReAlignComponents(True);
      end;
end;

function GetMetaData(Preview : TBitmap32) : TMetaData;
begin
  with result do
  begin
    Name := 'Weather';
    Author := 'Martin Krämer <Martin@SharpEnviro.com>';
    Description := 'Displays current weather information';
    Version := '0.7.3.3';
    ExtraData := 'preview: false';
    DataType := tteModule;
  end;
end;

Exports
  CreateModule,
  CloseModule,
  Poschanged,
  Refresh,
  UpdateMessage,
  ShowSettingsWnd,
  SetSize,
  ModuleMessage,
  GetMetaData;


end.
