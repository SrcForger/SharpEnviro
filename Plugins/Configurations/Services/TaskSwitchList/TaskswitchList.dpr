{
Source Name: Taskswitch.dll
Description: List of taskwitch configurations
Copyright (C) Lee Green <lee@sharpenviro.com>

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
library TaskswitchList;

uses
  ShareMem,
  windows,
  sysutils,
  sharpapi,
  classes,
  sharpcenterapi,
  graphics,
  variants,
  uVistaFuncs,
  JvValidators,
  forms,
  GR32,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uListWnd in 'uListWnd.pas' {frmList},
  uEditWnd in 'uEditWnd.pas' {frmEdit},
  uTaskswitchUtility in 'uTaskswitchUtility.pas';

{$R 'VersionInfo.res'}
{$R *.RES}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit,
    ISharpCenterPluginValidation )
  private
    procedure ValidateNameExists(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
    procedure ValidateActionExists(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    procedure SetupValidators; stdcall;
    procedure Save; override; stdCall;

  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmList);
  FreeAndNil(frmEdit);
end;

procedure TSharpCenterPlugin.CloseEdit(AApply: Boolean);
begin
  if AApply then
    frmEdit.Save;

  FreeAndNil(frmEdit);
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
  if frmEdit = nil then frmEdit := TfrmEdit.Create(nil);
  frmEdit.PluginHost := Self.PluginHost;
  uVistaFuncs.SetVistaFonts(frmEdit);

  result := PluginHost.OpenEdit(frmEdit);
  frmEdit.Init;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToForms(frmList,frmEdit,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
begin
  inherited;
  frmList.TaskSwitchList.Save;
end;

procedure TSharpCenterPlugin.SetupValidators;
var
  tmp: TJvCustomValidator;
begin
  // Can not leave fields blank
  PluginHost.AddRequiredFieldValidator( frmEdit.edName,'Please enter a name for this task switch configuration','Text');
  PluginHost.AddRequiredFieldValidator( frmEdit.edAction,'Please enter an action command','Text');

  // Validator for checking duplicates
  tmp := PluginHost.AddCustomValidator( frmEdit.edName,'There is already a task switch configuration with this name','Text');
  tmp.OnValidate := ValidateNameExists;

  tmp := PluginHost.AddCustomValidator( frmEdit.edAction,'There is already an action command defined with this id','Text');
  tmp.OnValidate := ValidateActionExists;
end;

procedure TSharpCenterPlugin.ValidateActionExists(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  s: string;
  idx: Integer;
begin
  Valid := True;

  s := '';
  if ValueToValidate <> null then
    s := VarToStr(ValueToValidate);

  if s = '' then begin
    Valid := False;
    Exit;
  end;

  idx := frmList.TaskSwitchList.IndexOfAction(s);

  if (idx <> -1) then begin

    if frmEdit.ItemEdit <> nil then
      if frmEdit.ItemEdit.Action = s then
        exit;

    Valid := False;
  end;
end;

procedure TSharpCenterPlugin.ValidateNameExists(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  s: string;
  idx: Integer;
begin
  Valid := True;

  s := '';
  if ValueToValidate <> null then
    s := VarToStr(ValueToValidate);

  if s = '' then begin
    Valid := False;
    Exit;
  end;

  idx := frmList.TaskSwitchList.IndexOfName(s);

  if (idx <> -1) then begin

    if frmEdit.ItemEdit <> nil then
      if frmEdit.ItemEdit.Name = s then
        exit;

    Valid := False;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'TaskSwitch List';
    Description := 'Task Switch List Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.8.0.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suTaskFilterActions)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with result do
  begin
    Name := 'Tasks';
    Description := 'Create task switch configurations.';
    Status := '';
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

