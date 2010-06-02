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
  VCLFixPack,
  Windows,
  Controls,
  SysUtils,
  Forms,
  Classes,
  Messages,
  Contnrs,
  StdCtrls,
  graphics,
  gr32,
  MonitorList,
  uISharpBarModule,
  uISharpESkin,
  uISharpBar,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  MainWnd in 'MainWnd.pas' {MainForm},
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  ToolTipApi in '..\..\..\Common\Units\ToolTipApi\ToolTipApi.pas',
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  VWMFunctions in '..\..\..\Common\Units\VWM\VWMFunctions.pas',
  uSystemFuncs in '..\..\..\Common\Units\SystemFuncs\uSystemFuncs.pas',
  uTaskItem in '..\..\Services\Shell\uTaskItem.pas',
  uTaskManager in '..\..\Services\Shell\uTaskManager.pas',
  SWCmdList in '..\..\..\Common\Units\TaskFilterList\SWCmdList.pas',
  TaskFilterList in '..\..\..\Common\Units\TaskFilterList\TaskFilterList.pas',
  uInterfacedSharpBarModuleBase in '..\..\..\Components\SharpBar\uInterfacedSharpBarModuleBase.pas',
  GR32Utils in '..\..\..\Common\Units\GR32Utils\GR32Utils.pas',
  uTaskPreviewWnd in 'uTaskPreviewWnd.pas';

type
  TInterfacedSharpBarModule = class(TInterfacedSharpBarModuleBase)
    private
    public
      constructor Create(pID,pBarID : integer; pBarWnd : hwnd); override;

      function CloseModule : HRESULT; override;
      function SetTopHeight(Top,Height : integer) : HRESULT; override;
      function UpdateMessage(part : TSU_UPDATE_ENUM; param : integer) : HRESULT; override;
      function InitModule : HRESULT; override;
      function ModuleMessage(msg : String) : HRESULT; override;

      procedure SetSkinInterface(Value : ISharpESkinInterface); override;
      procedure SetSize(Value : integer); override;
      procedure SetLeft(Value : integer); override;
  end;

{$R *.res}

{ TInterfacedSharpBarModule }

function TInterfacedSharpBarModule.CloseModule: HRESULT;
begin
  try
    Form.Free;
    Form := nil;
    result := S_OK;
  except
    on E:Exception do
    begin
      result := E_FAIL;
      SharpApi.SendDebugMessageEx(PChar(ModuleName),PChar('Error in CloseModule('
        + inttostr(ID) + '):' + E.Message),clred,DMT_ERROR);
    end;
  end;
end;

constructor TInterfacedSharpBarModule.Create(pID, pBarID: integer;
  pBarWnd: hwnd);
begin
  inherited Create(pID, pBarID, pBarWnd);
  ModuleName := 'Button Module';

  try
    Form := TMainForm.CreateParented(BarWnd);
    Form.BorderStyle := bsNone;
    TMainForm(Form).mInterface := self;
    Form.ParentWindow := BarWnd;
  except
    on E:Exception do
    begin
      SharpApi.SendDebugMessageEx(PChar(ModuleName),PChar('Error in CreateModule('
        + inttostr(ID) + '):' + E.Message),clred,DMT_ERROR);
      exit;
    end;
  end;
end;

function TInterfacedSharpBarModule.InitModule: HRESULT;
begin
  result := inherited InitModule;

  if Form <> nil then
  begin
    TMainForm(Form).LoadSettings;
    TMainForm(Form).LoadGlobalFilters;
    TMainForm(Form).RealignComponents;
    TMainForm(Form).CompleteRefresh;
    TMainForm(Form).InitHook;    
  end;
end;

function TInterfacedSharpBarModule.ModuleMessage(msg: String): HRESULT;
begin
  result := Inherited ModuleMessage(msg);

  if not (Initialized) then
    exit;

  if CompareText(msg,'MM_DISPLAYCHANGE') = 0 then
    MonList.GetMonitors
  else if CompareText(msg,'MM_SHELLHOOKWINDOWCREATED') = 0 then
    SharpApi.RegisterShellHookReceiver(Form.Handle)
  else if CompareText(msg,'MM_VWMUPDATESETTINGS') = 0 then
  begin
    TMainForm(Form).CurrentVWM := 1;
    TMainForm(Form).TM.ResetVMWs;
    TMainForm(Form).CompleteRefresh;
  end
  else if CompareText(msg,'MM_VWMDESKTOPCHANGED') = 0 then
  begin
    TMainForm(Form).CurrentVWM := SharpApi.GetCurrentVWM;
    TMainForm(Form).CheckFilterAll;
  end;
end;

procedure TInterfacedSharpBarModule.SetLeft(Value: integer);
begin
  inherited SetLeft(Value);

  TMainForm(Form).RepaintComponents;
end;

procedure TInterfacedSharpBarModule.SetSize(Value: integer);
begin
  inherited SetSize(Value);

  TMainForm(Form).UpdateSize;
end;

procedure TInterfacedSharpBarModule.SetSkinInterface(Value: ISharpESkinInterface);
begin
  inherited SetSkinInterface(Value);

  if Form <> nil then
    TMainForm(Form).UpdateComponentSkins;
end;

function TInterfacedSharpBarModule.SetTopHeight(Top, Height: integer): HRESULT;
begin
  result := inherited SetTopHeight(Top, Height);

  if (Form <> nil) and (Initialized) then
    TMainForm(Form).RealignComponents(False);
end;

function TInterfacedSharpBarModule.UpdateMessage(part: TSU_UPDATE_ENUM;
  param: integer): HRESULT;
const
  processed : TSU_UPDATES = [suSkinFileChanged,suBackground,suTheme,suSkin,
                             suScheme,suIconSet,suSkinFont,suModule,suTaskFilter,
                             suTaskAppBarFilters];
begin
  result := inherited UpdateMessage(part,param);

  if not (Initialized) then
    exit;

  if not (part in processed) then
    exit;  

  if (part = suTaskFilter) then
    TMainForm(Form).LoadSettings;

  if (part = suTaskAppBarFilters) then
  begin
    TMainForm(Form).LoadGlobalFilters;
    TMainForm(Form).CheckFilterAll;
  end;

  if (part = suModule) and (ID  = param) then
  begin
    TMainForm(Form).LoadSettings;
    TMainForm(Form).ReAlignComponents;
  end;

  if [part] <= [suTheme,suSkinFileChanged] then
    TMainForm(Form).ReAlignComponents;

  if (part = suSkinFileChanged) then
    TMainForm(Form).UpdateCustomSettings;
end;


function CreateModule(ID,BarID : integer; BarWnd : hwnd) : IInterface;
begin
  result := TInterfacedSharpBarModule.Create(ID,BarID,BarWnd);
end;

function GetMetaData(Preview : TBitmap32) : TMetaData;
begin
  with result do
  begin
    Name := 'Taskbar';
    Author := 'Martin Krämer <Martin@SharpEnviro.com>';
    Description := 'Displays a task list';
    Version := '0.7.6.5';
    ExtraData := 'preview: false';
    DataType := tteModule;
  end;
end;


Exports
  CreateModule,
  GetMetaData;


begin
end.

