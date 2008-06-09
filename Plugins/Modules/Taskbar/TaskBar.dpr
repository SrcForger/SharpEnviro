{
Source Name: TaskBar.dpr
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

library TaskBar;



uses
  Windows,
  Controls,
  SysUtils,
  Forms,
  Classes,
  Messages,
  Contnrs,
  SharpESkinManager,
  SharpEBar,
  StdCtrls,
  gr32,
  MainWnd in 'MainWnd.pas' {MainForm},
  MouseTimer in '..\..\..\Common\Units\MouseTimer\MouseTimer.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  ToolTipApi in '..\..\..\Common\Units\ToolTipApi\ToolTipApi.pas',
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  VWMFunctions in '..\..\..\Common\Units\VWM\VWMFunctions.pas',
  uSystemFuncs in '..\..\..\Common\Units\SystemFuncs\uSystemFuncs.pas',
  uTaskItem in '..\..\Services\Shell\uTaskItem.pas',
  uTaskManager in '..\..\Services\Shell\uTaskManager.pas',
  SWCmdList in '..\..\..\Common\Units\TaskFilterList\SWCmdList.pas',
  TaskFilterList in '..\..\..\Common\Units\TaskFilterList\TaskFilterList.pas';

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

procedure DebugOutputInfo(msg : String);
begin
end;


function GetControlByHandle(AHandle: THandle): TWinControl;
begin
 Result := Pointer(GetProp( AHandle,
                            PChar( Format( 'Delphi%8.8x',
                                           [GetCurrentProcessID]))));
end;

constructor TModule.Create(pID,pBarID : integer; pParent : hwnd);
var
  i : integer;
begin
  inherited Create;
  FID   := pID;
  FBarWnd := pParent;
  try
    i := GetBarPluginHeight(FBarWnd);
  except
    i := 16;
  end;
  FForm := TMainForm.CreateParented(pParent,ID,pBarID,FBarWnd,i);
  FForm.BorderStyle := bsNone;
  FForm.ParentWindow := pParent;
  FForm.Height := i;
  MouseTimer.AddWinControl(TMainForm(FForm));
  with FForm as TMainForm do
  begin
    MTimer := MouseTimer;
    ModuleID := pID;
    BarID    := pBarID;
    BarWnd   := FBarWnd;
    RealignComponents(False);
    Show;
    TMainForm(FForm).CompleteRefresh;
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
  if ModuleList = nil then
  begin
    result := False;
    exit;
  end;

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
        TMainForm(temp.Form).RepaintComponents;
      end;
end;

procedure UpdateMessage(part : TSU_UPDATE_ENUM; param : integer);
const
  processed : TSU_UPDATES = [suSkinFileChanged,suBackground,suTheme,suSkin,
                             suScheme,suSkinFont,suModule,suTaskFilter];
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

    if (part = suTaskFilter) then
    begin
      TMainForm(temp.Form).LoadSettings;
      break;
    end;

    if (part = suModule) and (temp.ID = param) then
    begin
      TMainForm(temp.Form).LoadSettings;
      TMainForm(temp.Form).ReAlignComponents(True);
      break;
    end;

    // Step1: check if height changed
    if [part] <= [suSkinFileChanged,suBackground,suTheme] then
    begin
      i := GetBarPluginHeight(temp.BarWnd);
      if temp.Form.Height <> i then
         temp.Form.Height := i;
    end;

     // Step2: check if skin or scheme changed
    if [part] <= [suScheme,suTheme] then
        TMainForm(temp.Form).SystemSkinManager.UpdateScheme;
    if (part = suSkinFileChanged) then
    begin
      TMainForm(temp.Form).SystemSkinManager.UpdateSkin;
      TMainForm(temp.Form).UpdateCustomSettings;
    end;

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
      TMainForm(temp.Form).SystemSkinManager.RefreshControls;
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

procedure InitModule(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.FForm).InitHook;
      end;
end;

function ModuleMessage(ID : integer; msg: string): integer;
var
  n : integer;
  temp : TModule;

begin
  result := 0;
  if ModuleList = nil then exit;

  if CompareText(msg,'MM_SHELLHOOKWINDOWCREATED') = 0 then
  begin
    for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        SharpApi.RegisterShellHookReceiver(temp.Form.Handle);
      end;
  end
  else if CompareText(msg,'MM_VWMUPDATESETTINGS') = 0 then
  begin
    for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.Form).CurrentVWM := 1;
        TMainForm(temp.Form).TM.ResetVMWs;
        TMainForm(temp.Form).CompleteRefresh;
      end;
  end
  else if CompareText(msg,'MM_VWMDESKTOPCHANGED') = 0 then
  begin
    for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.Form).CurrentVWM := SharpApi.GetCurrentVWM;
        TMainForm(temp.Form).CheckFilterAll;
      end;
  end;
end;

function GetMetaData(Preview : TBitmap32) : TMetaData;
begin
  with result do
  begin
    Name := 'Taskbar';
    Author := 'Martin Krämer <Martin@SharpEnviro.com>';
    Description := 'Displays a task list';
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
  SetSize,
  InitModule,
  ModuleMessage,
  GetMetaData;

begin

end.
