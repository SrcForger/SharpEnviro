{
Source Name: ApplicationBar.dpr
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

library ApplicationBar;

uses
  Windows,
  Controls,
  SysUtils,
  Forms,
  Classes,
  Contnrs,
  Graphics,
  StdCtrls,
  JclSimpleXML,
  SharpApi,
  Gr32,
  IXmlBaseUnit,
  uISharpBarModule,
  uISharpESkin,
  uISharpBar,
  uInterfacedSharpBarModuleBase,
  MonitorList,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  MainWnd in 'MainWnd.pas' {MainForm},
  ToolTipApi in '..\..\..\Common\Units\ToolTipApi\ToolTipApi.pas',
  SharpFileUtils in '..\..\..\Common\Units\SharpFileUtils\SharpFileUtils.pas',
  uTaskPreviewWnd in '..\Taskbar\uTaskPreviewWnd.pas';

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
  end;

{$R *.res}

{ TInterfacedSharpBarModule }

function TInterfacedSharpBarModule.CloseModule: HRESULT;
var
  XML : TInterfacedXmlBase;
  n : integer;
begin
  try
    SharpApi.UnRegisterShellHookReceiver(Form.Handle);
    Form.Free;
    Form := nil;

    XML := TInterfacedXMLBase.Create;
    XML.XmlFilename := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\ApplicationBar\Apps.xml';

    if XML.Load then
      for n := 0 to XML.XmlRoot.Items.Count - 1 do
        if XML.XmlRoot.Items.Item[n].Properties.IntValue('ID',-1) = ID then
        begin
          XML.XmlRoot.Items.DeletE(n);
          break;
        end;
    XML.Save;

    XML.Free;

    SharpApi.BroadCastGlobalUpdateMessage(suTaskAppBarFilters);    
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
    TMainForm(Form).RealignComponents;
    SharpApi.RegisterShellHookReceiver(Form.Handle);
    TMainForm(Form).UpdateGlobalFilterList(True);
    TMainForm(Form).CheckList;
    TMainForm(Form).TaskManager.Enabled := True;
    SharpApi.RequestWindowList(TMainForm(Form).Handle);
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
    TMainForm(Form).CheckList;
  end
  else if CompareText(msg,'MM_VWMDESKTOPCHANGED') = 0 then
  begin
    TMainForm(Form).CurrentVWM := SharpApi.GetCurrentVWM;
    TMainForm(Form).CheckList
  end;
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
    TMainForm(Form).UpdateGlobalFilterList(False);
    TMainForm(Form).CheckList;
  end;

  if [part] <= [suTheme,suSkinFileChanged] then
    TMainForm(Form).ReAlignComponents;

  if [part] <= [suTheme,suIconSet] then
    TMainForm(Form).RefreshIcons;

end;

function GetMetaData(Preview : TBitmap32) : TMetaData;
begin
  with result do
  begin
    Name := 'Application Bar';
    Author := 'Martin Krämer <Martin@SharpEnviro.com>';
    Description := 'Displays/Starts applications and monitors their running state';
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
