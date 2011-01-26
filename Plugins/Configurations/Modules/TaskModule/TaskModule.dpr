{
Source Name: TaskModule.dpr
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

library TaskModule;
uses
  ShareMem,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  JclFileUtils,
  JclStrings,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  SharpTypes,
  TaskFilterList,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uEditWnd in 'uEditWnd.pas' {frmEdit};

{$E .dll}
         
{$R 'VersionInfo.res'}
{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    barID : string;
    moduleID : string;
    procedure Load;
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdCall;
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  PluginHost.GetBarModuleIdFromPluginId(barID, moduleID);
end;

procedure TSharpCenterPlugin.Load;
var
  sortTasks: boolean;
  includeList, excludeList: TStringList;
  state, index, i: Integer;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmEdit do
    begin
      // State
      state := IntValue('State', 0);
      case state of
        integer(tisCompact): cbStyle.ItemIndex := 1; // sState := tisCompact;
        integer(tisMini): cbStyle.ItemIndex := 2;
      else cbStyle.ItemIndex := 0;
      end;

      // Sort type
      sortTasks := BoolValue('Sort', False);
      if not (sortTasks) then cbSortMode.ItemIndex := 0 else begin
        case TSharpeTaskManagerSortType(IntValue('SortType', 0)) of
          stWndClass: cbSortMode.ItemIndex := 2;
          stTime: cbSortMode.ItemIndex := 3;
          stIcon: cbSortMode.ItemIndex := 4;
        else cbSortMode.ItemIndex := 1;
        end;
      end;

      // Task Previews
      chkTaskPreviews.Checked := BoolValue('TaskPreview',True);

      // App Bar Windows
      chkAppBar.Checked := BoolValue('AppBarWindow', False);

      // Buttons
      chkMinimiseBtn.Checked := BoolValue('MinAllButton', False);
      chkRestoreBtn.Checked := BoolValue('MaxAllButton', False);
      chckToggleBtn.Checked := BoolValue('TogAllButton', False);
      chkFilterTasks.Checked := BoolValue('FilterTasks', False);
      chkMiddleClose.Checked := BoolValue('MiddleClose', True);
      lbItems.Visible := chkFilterTasks.Checked;
      lbItemsResize(nil);

      // Include/Exclude Filters
      includeList := TStringList.Create;
      excludeList := TStringList.Create;

      try
        StrTokenToStrings(Value('IFilters', ''), ',', includeList);
        StrTokenToStrings(Value('EFilters', ''), ',', excludeList);

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
    end;
  end;
 end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmEdit = nil then frmEdit := TfrmEdit.Create(nil);
  frmEdit.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmEdit);

  Load;
  result := PluginHost.Open(frmEdit);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmEdit);
end;

procedure TSharpCenterPlugin.Save;
var
  i: Integer;
  includeList, excludeList: TStringList;
  tmp: TFilterItem;
begin
  PluginHost.Xml.XmlRoot.Name := 'TaskBarModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmEdit do
  begin
    // Clear the list so we don't get duplicates.
    Clear;

    // State
    case cbStyle.ItemIndex of
      0: Add('State', integer(tisFull));
      2: Add('State', integer(tisMini));
    else Add('State', integer(tisCompact));
    end;

    // Sort?
    if cbSortMode.ItemIndex = 0 then
      Add('Sort', False) else
      Add('Sort', True);

    // Sort type
    case cbSortMode.ItemIndex of
      1: Add('SortType', Integer(stCaption));
      2: Add('SortType', Integer(stWndClass));
      3: Add('SortType', Integer(stTime));
      4: Add('SortType', Integer(stIcon));
    end;

    // TaskPreview
    Add('TaskPreview',chkTaskPreviews.Checked);

    // App Bar Windows
    Add('AppBarWindow', chkAppBar.Checked);

    // Buttons
    Add('MinAllButton', chkMinimiseBtn.Checked);
    Add('MaxAllButton', chkRestoreBtn.Checked);
    Add('TogAllButton', chckToggleBtn.Checked);
    Add('FilterTasks', chkFilterTasks.Checked);
    Add('MiddleClose', chkMiddleClose.Checked);

    includeList := TStringList.Create;
    excludeList := TStringList.Create;

    try
      // Include/Exclude Filters
      for i := 0 to Pred(lbItems.Count) do begin

        tmp := TFilterItem(lbItems.Item[i].Data);
        if lbItems.Item[i].SubItemChecked[1] then begin


          includeList.Add(tmp.Name)
        end
        else if lbItems.Item[i].SubItemChecked[2] then begin
            excludeList.Add(tmp.Name);
        end;
      end;

      Add('IFilters', includeList.DelimitedText);
      Add('EFilters', excludeList.DelimitedText);

    finally
      includeList.Free;
      excludeList.Free;
    end;
  end;

  PluginHost.Xml.Save;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Task Module';
    Description := 'Task Module Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.8.0.0';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suTaskFilter)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with Result do
  begin
	Name := 'Task Module';
    Description := 'Configure the Task module';
	Status := '';
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmEdit,AEditing,Theme);
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

