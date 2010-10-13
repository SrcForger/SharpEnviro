{
Source Name: TaskSwitchEdit.dpr
Description: TaskModule Config
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

library TaskSwitchEdit;
uses
//  VCLFixPack,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  JclFileUtils,
  Jclstrings,
  GR32,
  GR32_Image,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpApi,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uEditWnd in 'uEditWnd.pas' {frmEdit},
  uTaskswitchUtility in '..\TaskswitchList\uTaskswitchUtility.pas';

{$E .dll}

{$R 'VersionInfo.res'}
{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin)
  private
  public
    constructor Create(APluginHost: ISharpCenterHost);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Load;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;

  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmEdit);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

procedure TSharpCenterPlugin.Load;
var
  tmp: TTaskSwitchItem;
  n, i, index: Integer;
  includeList, excludeList: TStringList;
begin
  frmEdit.TaskSwitchList.Load;
  with frmEdit do begin

    IsUpdating := true;
    try
      n := frmEdit.TaskSwitchList.IndexOfName(PluginHost.PluginId);
      if n = -1 then exit;

      tmp := TaskSwitchList.Items[n];
      chkMouse.Checked := tmp.MouseAction;
      chkAppBars.Checked := tmp.ShowAppBar;
      chkPreview.Checked := tmp.Preview;
      chkGui.Checked := tmp.Gui;
      chkFilter.Checked := ((tmp.IncludeFilters <> '') or (tmp.ExcludeFilters <> ''));
      lbItems.Visible := chkFilter.Checked;
      if tmp.CycleForward then cbCycle.ItemIndex := 0 else cbCycle.ItemIndex := 1;

      // Include/Exclude Filters
      includeList := TStringList.Create;
      excludeList := TStringList.Create;
      try
        StrTokenToStrings(tmp.IncludeFilters, ',', includeList);
        StrTokenToStrings(tmp.ExcludeFilters, ',', excludeList);

        // include checks
        for i := 0 to Pred(includeList.Count) do begin
          index := lbItems.Items.IndexOf(StrRemoveChars(includeList[i], ['"']));
          if index <> -1 then
            lbItems.Item[index].SubItemChecked[1] := true;
        end;

        // exclude checks
        for i := 0 to Pred(excludeList.Count) do begin
          index := lbItems.Items.IndexOf(StrRemoveChars(excludeList[i], ['"']));
          if index <> -1 then
            lbItems.Item[index].SubItemChecked[2] := true;
        end;

      finally
        includeList.Free;
        excludeList.Free;
      end;

    finally
      UpdateSize;
      IsUpdating := false;
    end;

  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmEdit = nil then frmEdit := TfrmEdit.Create(nil);
  uVistaFuncs.SetVistaFonts(frmEdit);

  frmEdit.PluginHost := PluginHost;

  result := PluginHost.Open(frmEdit);
  Load;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmEdit,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  tmp: TTaskSwitchItem;
  n, i : Integer;
  includeList, excludeList: TStringList;
begin
  inherited;

  with frmEdit do begin
    n := frmEdit.TaskSwitchList.IndexOfName(PluginHost.PluginId);
    if n = -1 then exit;

    tmp := TaskSwitchList.Items[n];

    tmp.CycleForward := false;
    if cbCycle.ItemIndex = 0 then tmp.CycleForward := true;

    tmp.Gui := chkGui.Checked;
    tmp.Preview := chkPreview.Checked;
    tmp.MouseAction := chkMouse.Checked;
    tmp.ShowAppBar := chkAppBars.Checked;

    includeList := TStringList.Create;
    excludeList := TStringList.Create;
    try

      // Include/Exclude Filters
      for i := 0 to Pred(lbItems.Count) do begin
        if lbItems.Item[i].SubItemChecked[1] then
          includeList.Add(lbItems.Item[i].Caption) else
          if lbItems.Item[i].SubItemChecked[2] then
            excludeList.Add(lbItems.Item[i].Caption);
      end;

      tmp.IncludeFilters := includeList.DelimitedText;
      tmp.ExcludeFilters := excludeList.DelimitedText;

    finally
      includeList.Free;
      excludeList.Free;
    end;

    TaskSwitchList.Save;
  end;

end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Taskswitch Edit';
    Description := 'Taskswitch Edit Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.8.0.0';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suTaskFilterActions)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with result do
  begin
    Name := 'Options';
    Description := Format('Editing Task Action: "%s"', [PluginID]);
    Status := '';
  end;
end;

function InitPluginInterface(APluginHost: ISharpCenterHost): ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData;

begin
end.

