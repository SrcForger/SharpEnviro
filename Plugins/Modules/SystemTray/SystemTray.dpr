{
Source Name: SystemTray.dpr
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

library SystemTray;

{$R 'res\trayicons.res' 'res\trayicons.rc'}
{$R *.res}

uses
//  VCLFixPack,
  Windows,
  Controls,
  SysUtils,
  ExtCtrls,
  Forms,
  Classes,
  Contnrs,
  Types,
  GR32,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  MainWnd in 'MainWnd.pas' {MainForm},
  TrayIconsManager in 'TrayIconsManager.pas',
  winver in 'winver.pas',
  DateUtils,
  uISharpBarModule,
  uISharpESkin,
  uISharpBar,
  Graphics,
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  ToolTipApi in '..\..\..\Common\Units\ToolTipApi\ToolTipApi.pas',
  SharpGraphicsUtils in '..\..\..\Common\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas',
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  declaration in '..\..\Services\Shell\declaration.pas',
  uInterfacedSharpBarModuleBase in '..\..\..\Components\SharpBar\uInterfacedSharpBarModuleBase.pas';

type
  TInterfacedSharpBarModule = class(TInterfacedSharpBarModuleBase)
    private
      FUpdateTimer : TTimer;
      FTrayClient : TTrayClient;
      Flastrepaint : integer;
      FServiceCheck : integer;
      FServiceRunning : boolean;
      procedure OnUpdateTimer(Sender : TObject);
    public
      constructor Create(pID,pBarID : integer; pBarWnd : hwnd); override;

      function CloseModule : HRESULT; override;
      function SetTopHeight(Top,Height : integer) : HRESULT; override;
      function UpdateMessage(part : TSU_UPDATE_ENUM; param : integer) : HRESULT; override;
      function InitModule : HRESULT; override;

      procedure SetSkinInterface(Value : ISharpESkinInterface); override;
      procedure SetSize(Value : integer); override;
      procedure SetLeft(Value : integer); override;      
  end;

{ TInterfacedSharpBarModule }

function TInterfacedSharpBarModule.CloseModule: HRESULT;
begin
  try
    FUpdateTimer.Free;
    FUpdateTimer := nil;

    FTrayClient.Free;
    FTrayClient := nil;

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

procedure TInterfacedSharpBarModule.OnUpdateTimer(SEnder : TObject);
var
  tempForm : TMainForm;
  hr : hresult;
begin
  FServiceCheck := FServiceCheck + 1;
  if FServiceCheck >= 20 then
  begin
    hr := SharpApi.IsServiceStarted('Shell');
    if hr <> MR_STARTED then
    begin
      FTrayClient.ClearTrayIcons;
      if FServiceRunning then
        Flastrepaint := -1;      
      FServiceRunning := False;
    end
    else
    begin
      if not FServiceRunning then
        Flastrepaint := -1;
      FServiceRunning := True;
    end;
    FServiceCheck := 0;
  end;

  if (DateTimeToUnix(now) - FTrayClient.LastMessage) >= 5 then
  begin
    FTrayClient.RegisterWithTray;
    FServiceCheck := 15;
  end;

  if FTrayClient.RepaintHash <> Flastrepaint then
  begin
    tempForm := TMainForm(Form);
    tempForm.lb_servicenotrunning.Visible := not FServiceRunning;
    tempForm.ReAlignComponents;
    if FServiceRunning then
      tempForm.RepaintIcons;
  end;
  Flastrepaint := FTrayClient.RepaintHash;
end;

constructor TInterfacedSharpBarModule.Create(pID, pBarID: integer;
  pBarWnd: hwnd);
begin
  inherited Create(pID, pBarID, pBarWnd);
  ModuleName := 'System Tray Module';

  try
    Form := TMainForm.CreateParented(BarWnd);
    Form.BorderStyle := bsNone;
    Form.ParentWindow := BarWnd;    

    FTrayClient := TTrayClient.Create;
    FTrayClient.InitToolTips(Form);
    FTrayClient.BackGroundColor := color32(0,0,0,0);
    FUpdateTimer := TTimer.Create(nil);
    FUpdateTimer.OnTimer := OnUpdateTimer;
    FUpdateTimer.Interval := 100;
    FUpdateTimer.Enabled := True;
    FServiceCheck := 15;
    FServicerunning := true;

    TMainForm(Form).mInterface := self;
    TMainForm(Form).FTrayClient := FTrayClient;

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
    FTrayClient.ScreenPos := TMainForm(Form).ClientToScreen(
                               Point(TMainForm(Form).Left,
                               TMainForm(Form).Top));
    TMainForm(Form).FTrayClient.RenderIcons;
  end;
end;

procedure TInterfacedSharpBarModule.SetLeft(Value: integer);
begin
  inherited SetLeft(Value);

  if TMainForm(Form) <> nil then
  begin               
    FTrayClient.ScreenPos := TMainForm(Form).ClientToScreen(
                                 Point(TMainForm(Form).Left,
                                 TMainForm(Form).Top));
    TMainForm(Form).RepaintIcons;

    Flastrepaint := -1;
    FUpdateTimer.OnTimer(FUpdateTimer);

    FTrayClient.PositionTrayWindow(Form.ParentWindow,Form.Handle);
  end;
end;

procedure TInterfacedSharpBarModule.SetSkinInterface(Value : ISharpESkinInterface);
begin
  Inherited SetSkinInterface(Value);

  if Form <> nil then
    TMainForm(Form).UpdateComponentSkins;
end;

procedure TInterfacedSharpBarModule.SetSize(Value: integer);
begin
  inherited SetSize(Value);

  FTrayClient.RenderIcons;
  TMainForm(Form).RepaintIcons;
end;

function TInterfacedSharpBarModule.SetTopHeight(Top, Height: integer): HRESULT;
begin
  result := inherited SetTopHeight(Top, Height);

  if Form <> nil then
  begin
    if Initialized then
      TMainForm(Form).RealignComponents;
      
    if Height < 20 then
      FTrayClient.IconSize := Height - 4
    else FTrayClient.IconSize := 16;
    FTrayClient.TopOffset := (Height - FTrayClient.IconSize) div 2;
    FTrayClient.RenderIcons;
    FTrayClient.UpdateTrayIcons;

    if Initialized then
      TMainForm(Form).RepaintIcons;
  end;
end;

function TInterfacedSharpBarModule.UpdateMessage(part: TSU_UPDATE_ENUM;
  param: integer): HRESULT;
const
  processed : TSU_UPDATES = [suSkinFileChanged,suBackground,suTheme,suSkin,
                             suScheme,suModule,suSkinFont];
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

  if [part] <= [suTheme,suSkinFileChanged,suScheme] then
    TMainForm(Form).ReAlignComponents;

  if [part] <= [suBackground] then
    TMainForm(Form).RepaintIcons;
end;

function GetMetaData(Preview : TBitmap32) : TMetaData;
begin
  with result do
  begin
    Name := 'System Tray';
    Author := 'Martin Krämer <Martin@SharpEnviro.com>';
    Description := 'Displays all system tray icons.';
    Version := '0.7.6.5';
    ExtraData := 'preview: False';
    DataType := tteModule;
  end;
end;

function CreateModule(ID,BarID : integer; BarWnd : hwnd) : IInterface;
begin
  Result := TInterfacedSharpBarModule.Create(ID,BarID,BarWnd);
end;

Exports
  CreateModule,
  GetMetaData;

begin
end.
