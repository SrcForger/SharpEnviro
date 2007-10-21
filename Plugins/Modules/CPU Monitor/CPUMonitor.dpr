{
Source Name: CPUMonitor.dpr
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

library CPUMonitor;



uses
  Windows,
  Controls,
  Dialogs,
  SysUtils,
  Forms,
  Classes,
  Contnrs,
  SharpESkinManager,
  SharpEBar,
  StdCtrls,
  JvSimpleXML,
  SharpCenterApi,
  gr32,
  MainWnd in 'MainWnd.pas' {MainForm},
  SettingsWnd in 'SettingsWnd.pas' {SettingsForm},
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  MouseTimer in '..\..\..\Common\Units\MouseTimer\MouseTimer.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpDeskFunctions in '..\..\..\Components\SharpDesk\Units\uSharpDeskFunctions.pas',
  adCpuUsage in '..\..\..\Common\3rd party\adCpuUsage\adCpuUsage.pas',
  cpuUsage in 'cpuUsage.pas';

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
  CurrentCPUUsage : TCPUUsage;
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
    cpuusage := CurrentCPUUsage;
    ModuleID := pID;
    BarID := pBarID;
    BarWnd   := FBarWnd;
    LoadSettings;
    CurrentCPUUsage.Forms.Add(FForm);
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

    if CurrentCPUUsage = nil then
       CurrentCPUUsage := TCPUUsage.Create;

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
          if ModuleList.Count = 0 then
             FreeAndNil(CurrentCPUUsage);
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
        TMainForm(temp.Form).ReAlignComponents(False);
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
      end;
end;

procedure UpdateMessage(part : TSU_UPDATE_ENUM; param : integer);
const
  processed : TSU_UPDATES = [suSkinFileChanged,suBackground,suTheme,suSkin,
                             suScheme];
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
        TMainForm(temp.Form).SkinManager.UpdateScheme;
    if (part = suSkinFileChanged) then
       TMainForm(temp.Form).SkinManager.UpdateSkin;
    if [part] <= [suScheme,suTheme,suSkinFileChanged] then
       TMainForm(temp.Form).LoadSettings;

    // Step3: update
    if [part] <= [suScheme,suBackground,suSkinFileChanged,suTheme] then
    begin
      TMainForm(temp.Form).UpdateBackground;
      TMainForm(temp.Form).UpdateGraph;
      if param <> -2 then
         TMainForm(temp.Form).Repaint;
      if [part] <= [suTheme,suSkinFileChanged] then
         TMainForm(temp.Form).ReAlignComponents((part = suSkinFileChanged));
    end;
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

function GetMetaData(Preview : TBitmap32) : TMetaData;
begin
  with result do
  begin
    Name := 'CPU Monitor';
    Author := 'Martin Krämer <Martin@SharpEnviro.com>';
    Description := 'Displays a graph showing CPU usage';
    Version := '0.7.3.3';
    ExtraData := 'preview: false';
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
  GetMetaData;


end.
