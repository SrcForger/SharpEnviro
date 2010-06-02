{
Source Name: VWM.dpr
Description: VWM Module Main Project File
Copyright (C) Author <E-Mail>

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

library VWM;

uses
  VCLFixPack,
  Windows,
  Controls,
  SysUtils,
  Forms,
  Classes,
  Graphics,
  Contnrs,
  SharpApi,
  MonitorList,
  uISharpBarModule,
  uISharpESkin,
  uISharpBar,
  uInterfacedSharpBarModuleBase,
  gr32,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  MainWnd in 'MainWnd.pas' {MainForm},
  VWMFunctions in '..\..\..\Common\Units\VWM\VWMFunctions.pas',
  SharpGraphicsUtils in '..\..\..\Common\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas',
  uSystemFuncs in '..\..\..\Common\Units\SystemFuncs\uSystemFuncs.pas';

type
  TInterfacedSharpBarModule = class(TInterfacedSharpBarModuleBase)
    private
    public
      constructor Create(pID,pBarID : integer; pBarWnd : hwnd); override;

      function CloseModule : HRESULT; override;
      function SetTopHeight(Top,Height : integer) : HRESULT; override;
      function UpdateMessage(part : TSU_UPDATE_ENUM; param : integer) : HRESULT; override;
      function InitModule : HRESULT; override;
      function ModuleMessage(msg: string) : HRESULT; override;      

      procedure SetSize(Value : integer); override;
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
  ModuleName := 'VWM Module';

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
    TMainForm(Form).RealignComponents;
    RegisterShellHookReceiver(Form.Handle);
    TMainForm(Form).UpdateTimer.Enabled := True;
  end;
end;

function TInterfacedSharpBarModule.ModuleMessage(msg: string): HRESULT;
begin
  result := inherited ModuleMessage(msg);

  if CompareText(msg,'MM_DISPLAYCHANGE') = 0 then
    MonList.GetMonitors
  else if CompareText(msg,'MM_SHELLHOOKWINDOWCREATED') = 0 then
    SharpApi.RegisterShellHookReceiver(Form.Handle)
  else if (CompareText(msg,'MM_VWMDESKTOPCHANGED') = 0) and (Initialized) then
  begin
    TMainForm(Form).UpdateVWMSettings;
    TMainForm(Form).DrawVWM;
    TMainForm(Form).DrawVWMToForm;
  end else if (CompareText(msg,'MM_VWMUPDATESETTINGS') = 0) and (Initialized) then
  begin
    TMainForm(Form).UpdateVWMSettings;
    TMainForm(Form).ReAlignComponents;
    TMainForm(Form).DrawVWM;
    TMainForm(Form).DrawVWMToForm;
  end;
end;

procedure TInterfacedSharpBarModule.SetSize(Value: integer);
begin
  inherited SetSize(Value);

  TMainForm(Form).UpdateSize;
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
                             suScheme,suIconSet,suSkinFont,suModule];
begin
  result := inherited UpdateMessage(part,param);

  if not (Initialized) then
    exit;

  if not (part in processed) then
    exit;  

  if (part = suModule) and (ID  = param) then
  begin
    TMainForm(Form).LoadSettings;
    TMainForm(Form).ReAlignComponents;
    TMainForm(Form).DrawVWM;
    TMainForm(Form).DrawVWMToForm;
  end;

  if [part] <= [suScheme,suSkin,suTheme,suSkinFileChanged] then
    TMainForm(Form).UpdateColors;
        
  if [part] <= [suTheme,suSkinFileChanged] then
    TMainForm(Form).ReAlignComponents;
end;

function GetMetaData(Preview : TBitmap32) : TMetaData;
begin
  with result do
  begin
    Name := 'VWM';
    Author := 'Martin Krämer <Martin@SharpEnviro.com>';
    Description := 'Displays a Virtual Window Manager';
    Version := '0.7.6.5';
    ExtraData := 'preview: false';
    DataType := tteModule;
  end;
end;

function CreateModule(ID,BarID : integer; BarWnd : hwnd) : IInterface;
begin
  result := TInterfacedSharpBarModule.Create(ID,BarID,BarWnd);
end;


Exports
  CreateModule,
  GetMetaData;


begin
end.
