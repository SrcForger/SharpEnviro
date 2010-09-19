{
Source Name: ButtonBarModule.dpr
Description: ButtonBarModule List Config
Copyright (C) Lee Green (lee@sharpenviro.com)

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

library ButtonBarList;
uses
//  VCLFixPack,
  Windows,
  Messages,
  SysUtils,
  Forms,
  Variants,
  Classes,
  ImgList,
  Controls,
  Graphics,
  uVistaFuncs,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  SharpCenterApi,
  SharpApi,
  jvValidators,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uListWnd in 'uListWnd.pas' {frmList},
  uEditWnd in 'uEditWnd.pas' {frmEdit},
  uButtonBarList in 'uButtonBarList.pas';

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit,
    ISharpCenterPluginValidation )
  private
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;
    procedure Save; override; stdCall;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    procedure SetupValidators; stdcall;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmList);
  FreeAndNil(FrmEdit);
end;

procedure TSharpCenterPlugin.CloseEdit(AApply: Boolean);
begin
  if AApply then
    FrmEdit.Save;

  FreeAndNil(FrmEdit);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmList = nil then frmList := TfrmList.Create(nil);
  uVistaFuncs.SetVistaFonts(frmList);

  frmList.PluginHost := PluginHost;
  result := PluginHost.Open(frmList);
end;

function TSharpCenterPlugin.OpenEdit: Cardinal;
begin
  if FrmEdit = nil then FrmEdit := TFrmEdit.Create(nil);
  FrmEdit.PluginHost := Self.PluginHost;
  uVistaFuncs.SetVistaFonts(FrmEdit);

  result := PluginHost.OpenEdit(FrmEdit);
  FrmEdit.Init;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToForms(frmList,FrmEdit,AEditing,Theme);
  frmList.UpdateImages;
end;

procedure TSharpCenterPlugin.Save;
begin
  frmList.Items.Save;
    
  BroadcastGlobalUpdateMessage(suModule, 0, True);
end;

procedure TSharpCenterPlugin.SetupValidators;
begin
  // Can not leave fields blank
  PluginHost.AddRequiredFieldValidator( FrmEdit.edName,'Please enter a name for the button','Text');
  PluginHost.AddRequiredFieldValidator( FrmEdit.edCommand,'Please enter a command to execute when clicked','Text');
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Button Bar list';
    Description := 'Button Bar List Edit Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.8.0.0';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suModule)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
var
  items : TButtonBarList;
  barID, moduleID : String;
begin
  with Result do
  begin
    Name := 'Buttons';
    Description := 'Create and manage items for the Button Bar module';
  	Status := '';

    barID := copy(pluginID, 0, pos(':',pluginID)-1);
    moduleID := copy(pluginID, pos(':',pluginID)+1, length(pluginID) - pos(':',pluginID));

    items := TButtonBarList.Create;
    items.Filename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
    try
      items.load;
      Status := inttostr(items.Count);
    finally
      items.free;
    end;
  end;
end;

function InitPluginInterface( APluginHost: ISharpCenterHost ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData;

begin
end.

//function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
//var
//  pluginId: string;
//  barId: string;
//  moduleId: string;
//begin
//  {$REGION 'Form Creation'}
//    if frmList = nil then
//        frmList := TfrmList.Create(nil);
//      frmList.ParentWindow := aowner;
//      frmList.Left := 0;
//      frmList.Top := 0;
//      frmList.BorderStyle := bsNone;
//      frmList.Show;
//      uVistaFuncs.SetVistaFonts(frmList);
//  {$ENDREGION}
//
//  {$REGION 'Get plugin and module id'}
//      pluginId := APluginID;
//      barId := copy(pluginId, 0, pos(':',pluginId)-1);
//      moduleId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));
//
//      barId := copy(pluginId, 0, pos(':',pluginId)-1);
//      moduleId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));
//      //barId := '11823732';
//      //moduleId := '4619264';
//
//      frmList.BarId := StrToInt( barId );
//      frmList.ModuleId := StrToInt( moduleId );
//  {$ENDREGION}
//
//  frmList.RenderItems;
//  result := frmList.Handle;
//end;
//
//function Close: boolean;
//begin
//  result := True;
//  try
//    frmList.Close;
//    frmList.Free;
//    frmList := nil;
//  except
//    result := False;
//  end;
//end;
//
//
//procedure SetText(const APluginID: string; var AName: string; var AStatus: string;
//  var ADescription: string);
//var
//  items: TButtonBarList;
//  pluginId: string;
//  barId: string;
//  moduleId: string;
//begin
//  AName := 'Buttons';
//  ADescription := 'Create and manage items for the button bar module';
//
//  {$REGION 'Get plugin and module id'}
//      pluginId := APluginID;
//      barId := copy(pluginId, 0, pos(':',pluginId)-1);
//      moduleId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));
//
//      barId := copy(pluginId, 0, pos(':',pluginId)-1);
//      moduleId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));
//  {$ENDREGION}
//
//  items := TButtonBarList.Create;
//  items.BarId := strToInt(barId);
//  items.ModuleId := strToInt(moduleId);
//  try
//    items.load;
//    AStatus := inttostr(items.Count);
//  finally
//    items.free;
//  end;
//end;

//
//
//exports
//  Open,
//  Close,
//  SetText,
//  GetMetaData,
//  OpenEdit,
//  CloseEdit,
//  GetCenterTheme,
//  GetCenterScheme;
//
//begin
//end.





