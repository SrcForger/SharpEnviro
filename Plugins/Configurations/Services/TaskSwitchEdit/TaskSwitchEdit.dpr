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
  uEditWnd in 'uEditWnd.pas' {frmEdit},
  uTaskswitchUtility in '..\TaskswitchList\uTaskswitchUtility.pas';

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin)
  private
  public
    constructor Create(APluginHost: TInterfacedSharpCenterHostBase);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Load;

    function GetPluginDescriptionText: string; override; stdcall;
    function GetPluginName: string; override; stdcall;
    procedure Refresh; override; stdcall;

  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmEdit);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: string;
begin
  Result := Format('Editing Task Action: "%s"', [PluginHost.PluginId]);
end;

function TSharpCenterPlugin.GetPluginName: string;
begin
  Result := 'Options';
end;

procedure TSharpCenterPlugin.Load;
var
  tmp: TTaskSwitchItem;
  n, i, index: Integer;
  includeList, excludeList: TStringList;
begin
  frmEdit.TaskSwitchList.Load;
  with frmEdit do begin

    Updating := true;
    try
      n := frmEdit.TaskSwitchList.IndexOfName(PluginHost.PluginId);
      if n = -1 then exit;

      tmp := TaskSwitchList.Items[n];
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
      Updating := false;
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

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmEdit);
end;

procedure TSharpCenterPlugin.Save;
var
  tmp: TTaskSwitchItem;
  n, i, index: Integer;
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
    Version := '0.7.6.0';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suTaskFilter)]);
  end;
end;

function InitPluginInterface(APluginHost: TInterfacedSharpCenterHostBase): ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.

