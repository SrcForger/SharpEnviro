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
  SysUtils,
  Forms,
  Classes,
  Contnrs,
  Graphics,
  uISharpBarModule,
  uISharpESkin,
  uISharpBar,
  dialogs,
  GR32,
  {$IFDEF DEBUG}DebugDialog,{$ENDIF}
  MainWnd in 'MainWnd.pas' {MainForm},
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpDeskFunctions in '..\..\..\Components\SharpDesk\Units\uSharpDeskFunctions.pas',
  adCpuUsage in '..\..\..\Common\3rd party\adCpuUsage\adCpuUsage.pas',
  cpuUsage in 'cpuUsage.pas',
  uInterfacedSharpBarModuleBase in '..\..\..\Components\SharpBar\uInterfacedSharpBarModuleBase.pas';

type
  TInterfacedSharpBarModule = class(TInterfacedSharpBarModuleBase)
    private
    public
      cpuusage : TCPUUsage;
      constructor Create(pID,pBarID : integer; pBarWnd : hwnd); override;

      function CloseModule : HRESULT; override;
      function SetTopHeight(Top,Height : integer) : HRESULT; override;
      function UpdateMessage(part : TSU_UPDATE_ENUM; param : integer) : HRESULT; override;
      function InitModule : HRESULT; override;

      procedure SetSkinInterface(Value : ISharpESkinInterface); override;
      procedure SetSize(Value : integer); override;
      procedure SetLeft(Value : integer); override;
  end;

var
  CurrentCPUUsage : TCPUUsage;
  
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
  ModuleName := 'CPU Monitor Module';

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
    TMainForm(Form).cpuusage := cpuusage;
    TMainForm(Form).LoadSettings;
    cpuusage.Forms.Add(Form);
    TMainForm(Form).RealignComponents;
    cpuusage.UpdateTimer.Enabled := True;    
  end;
end;

procedure TInterfacedSharpBarModule.SetSkinInterface(Value: ISharpESkinInterface);
begin
  inherited SetSkinInterface(Value);

  if Form <> nil then
    TMainForm(Form).UpdateComponentSkins;
end;

procedure TInterfacedSharpBarModule.SetLeft(Value: integer);
begin
  inherited SetLeft(Value);

  if Form <> nil then
    TMainForm(Form).UpdateGraph;
end;

procedure TInterfacedSharpBarModule.SetSize(Value: integer);
begin
  inherited SetSize(Value);

  TMainForm(Form).ReAlignComponents;
end;

function TInterfacedSharpBarModule.SetTopHeight(Top, Height: integer): HRESULT;
begin
  result := inherited SetTopHeight(Top, Height);

  if Form <> nil then
  begin
    TMainForm(Form).cpuusage := cpuusage;
    if Initialized then
    begin
      TMainForm(Form).RealignComponents;
      TMainForm(Form).UpdateGraph;
    end;
  end;
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
  end;

  if [part] <= [suSkinFileChanged] then
    TMainForm(Form).LoadSettings;

  if [part] <= [suTheme,suScheme,suSkinFileChanged] then
    TMainForm(Form).ReAlignComponents;

  if [part] <= [suBackground] then
    TMainForm(Form).UpdateGraph;
end;

function GetMetaData(Preview : TBitmap32) : TMetaData;
begin
  with result do
  begin
    Name := 'CPU Monitor';
    Author := 'Martin Krämer <Martin@SharpEnviro.com>';
    Description := 'Displays a graph showing CPU usage';
    Version := '0.7.6.5';
    ExtraData := 'preview: false';
    DataType := tteModule;
  end;
end;

function CreateModule(ID,BarID : integer; BarWnd : hwnd) : IInterface;
var
  temp : TInterfacedSharpBarModule;
begin
  temp := TInterfacedSharpBarModule.Create(ID,BarID,BarWnd);
  temp.cpuusage := CurrentCPUUsage;
  result := temp;
end;

procedure EntryPointProc(Reason: Integer);
begin
  case reason of
    DLL_PROCESS_ATTACH:
      CurrentCPUUsage := TCPUUsage.Create;

    DLL_PROCESS_DETACH:
      CurrentCPUUsage.Free;
  end;
end;

Exports
  CreateModule,
  GetMetaData;

begin
  DllProc := @EntryPointProc;
  EntryPointProc(DLL_PROCESS_ATTACH);
end.
