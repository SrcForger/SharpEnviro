{
Source Name: uEditWnd.pas
Description: Options Window
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

unit uEditWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Contnrs,
  Graphics,
  Controls,
  Forms,
  StdCtrls,
  ImgList,
  PngImageList,
  SharpTypes,
  SharpEListBoxEx,
  ExtCtrls,
  TaskFilterList,
  JclSimpleXml,
  JclStrings,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uTaskSwitchUtility, SharpECenterHeader, JvExControls, JvXPCore, JvXPCheckCtrls;

type
  TItemData = class
  private
    FName: string;
    FId: Integer;

  public
    property Name: string read FName write FName;
    property Id: Integer read FId write FId;
    constructor Create(AName: string; AId: Integer);
  end;

  TSortType = (stNone, stCaption, stWndClass, stTimeAdded, stIcon);

  TfrmEdit = class(TForm)
    lbItems: TSharpEListBoxEx;
    pilListBox: TPngImageList;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    Panel1: TPanel;
    Label6: TLabel;
    cbCycle: TComboBox;
    Panel3: TPanel;
    chkPreview: TJvXPCheckbox;
    chkGui: TJvXPCheckbox;
    SharpECenterHeader3: TSharpECenterHeader;
    chkFilter: TCheckBox;
    pilDefault: TPngImageList;
    procedure lbItemsResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbItemsGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbItemsClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbItemsGetCellColor(Sender: TObject; const AItem: TSharpEListItem;
      var AColor: TColor);
    procedure lbItemsClickCheck(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AChecked: Boolean);
    procedure chkFilterClick(Sender: TObject);
    procedure SettingsChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FTaskFilterList: TFilterItemList;
    FUpdating: boolean;
    FPluginHost: TInterfacedSharpCenterHostBase;
    FTaskSwitchList: TTaskSwitchItemList;
    
  public
    procedure RenderItems;
    procedure UpdateSize;

    property Updating: boolean read FUpdating write FUpdating;
    property TaskSwitchList: TTaskSwitchItemList read FTaskSwitchList write FTaskSwitchList;
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmEdit: TfrmEdit;

const
  colName = 0;
  iidxCopy = 0;
  iidxDelete = 1;
  iidxCommand = 2;
  iidxWindows = 3;
  iidxSystem = 4;

implementation

uses
  SharpThemeApiEx,
  SharpApi;

{$R *.dfm}

procedure TfrmEdit.SettingsChange(Sender: TObject);
begin
  if not (FUpdating) then
    FPluginHost.SetSettingsChanged;
end;

procedure TfrmEdit.chkFilterClick(Sender: TObject);
begin
  SettingsChange(nil);

  lbItems.Visible := chkFilter.Checked;
  UpdateSize;
  FPluginHost.Refresh;
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  FTaskSwitchList := TTaskSwitchItemList.Create;
  FTaskFilterList := TFilterItemList.Create;
end;

procedure TfrmEdit.FormDestroy(Sender: TObject);
begin
  FTaskFilterList.Free;
  FTaskSwitchList.Free;
end;

procedure TfrmEdit.FormResize(Sender: TObject);
begin
  UpdateSize;
end;

procedure TfrmEdit.FormShow(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  lbItems.DoubleBuffered := True;
  RenderItems;
end;

procedure TfrmEdit.lbItemsClickCheck(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AChecked: Boolean);
begin
  if ACol = 1 then begin
    if AItem.SubItemChecked[2] then
      AItem.SubItemChecked[2] := False;
  end else begin
    if AItem.SubItemChecked[1] then
      AItem.SubItemChecked[1] := False;
  end;

  SettingsChange(nil);
end;

procedure TfrmEdit.lbItemsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpItemData: TItemData;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin

  tmpItemData := TItemData(AItem.Data);
  if tmpItemData = nil then
    exit;

  case ACol of
    colName: //Click Event;
  end;

  FPluginHost.Refresh;
end;

procedure TfrmEdit.lbItemsGetCellColor(Sender: TObject;
  const AItem: TSharpEListItem; var AColor: TColor);
begin
  if AItem.SubItemChecked[1] then AColor := $00E6FBE9;
  if AItem.SubItemChecked[2] then AColor := $00E8E1FF;
end;

procedure TfrmEdit.lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol > 0 then
    ACursor := crHandPoint;
end;

procedure TfrmEdit.lbItemsGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
var
  tmpfilter: TFilterItem;
begin
  tmpfilter := TFilterItem(AItem.Data);

  case tmpfilter.FilterType of
        fteSWCmd: AImageIndex := iidxCommand;
        fteWindow,fteProcess : AImageIndex := iidxWindows;
        else
          AImageIndex := iidxSystem;
      end;
end;

procedure TfrmEdit.lbItemsResize(Sender: TObject);
begin
  UpdateSize;
end;

//procedure TfrmEdit.LoadSettings;
//var
//  xml: TJclSimpleXML;
//  fileloaded, direction: boolean;
//  index, i: Integer;
//  fileName: string;
//  includeList, excludeList: TStringList;
//begin
//  xml := TJclSimpleXML.Create;
//  FUpdating := True;
//  try
//    fileloaded := False;
//    try
//      fileName := GetSharpeUserSettingsPath + 'SharpCore\Services\TaskSwitch\' + 'Actions' + '.xml';
//      XML.LoadFromFile(fileName);
//      fileloaded := True;
//    except
//    end;
//
//    if fileloaded then
//      with xml.Root.Items do
//      begin
//
//        // Direction
//        direction := BoolValue('CForward', true);
//        if direction then
//          cbDirection.ItemIndex := 0 else
//          cbDirection.ItemIndex := 1;
//
//        // Gui options
//        chkUseTaskSwitch.Checked := BoolValue('UseGui', False);
//        chkRenderPreview.Checked := BoolValue('Preview', False);
//        chkFilterTasks.Checked := BoolValue('FilterTasks', False);
//        lbItems.Visible := chkFilterTasks.Checked;
//        lbItemsResize(nil);
//
//        // Include/Exclude Filters
//        includeList := TStringList.Create;
//        excludeList := TStringList.Create;
//        try
//          StrTokenToStrings(Value('IFilters', ''), ',', includeList);
//          StrTokenToStrings(Value('EFilters', ''), ',', excludeList);
//
//          // include checks
//          for i := 0 to Pred(includeList.Count) do begin
//            index := lbItems.Items.IndexOf(StrRemoveChars(includeList[i], ['"']));
//            if index <> -1 then
//              lbItems.Item[index].SubItemChecked[1] := true;
//          end;
//
//          // exclude checks
//          for i := 0 to Pred(excludeList.Count) do begin
//            index := lbItems.Items.IndexOf(StrRemoveChars(excludeList[i], ['"']));
//            if index <> -1 then
//              lbItems.Item[index].SubItemChecked[2] := true;
//          end;
//
//        finally
//          includeList.Free;
//          excludeList.Free;
//        end;
//      end;
//
//  finally
//    XML.Free;
//    FUpdating := False;
//  end;
//
//end;

procedure TfrmEdit.RenderItems;
var
  newItem: TSharpEListItem;
  i: Integer;
  tmpItemData: TFilterItem;
begin

  LockWindowUpdate(Self.Handle);
  try

    lbItems.Clear;
    FTaskFilterList.Load;

    for i := 0 to FTaskFilterList.Count - 1 do begin

      tmpItemData := TFilterItem(FTaskFilterList[i]);

      newItem := lbItems.AddItem(tmpItemData.Name);
      newItem.Data := tmpItemData;
      newItem.AddSubItem('Include', False);
      newItem.AddSubItem('Exclude', False);

    end;
  finally
    LockWindowUpdate(0);
  end;

  lbItems.ItemIndex := -1;

  FPluginHost.SetEditTabsVisibility(lbItems.ItemIndex,lbItems.Count);
  FPluginHost.Refresh;
end;

//procedure TfrmEdit.SaveSettings;
//var
//  xml: TJclSimpleXML;
//  i: Integer;
//  fileName: string;
//  includeList, excludeList: TStringList;
//begin
//  xml := TJclSimpleXML.Create;
//  try
//    xml.Root.Name := 'TaskBarModuleSettings';
//    with xml.Root.Items do
//    begin
//
//      // Direction
//      case cbDirection.ItemIndex of
//        0: Add('CForward', True);
//        1: Add('CForward', False);
//      end;
//
//      // Gui
//      Add('UseGui', chkUseTaskSwitch.Checked);
//      Add('Preview', chkRenderPreview.Checked);
//      Add('FilterTasks', chkFilterTasks.Checked);
//
//      includeList := TStringList.Create;
//      excludeList := TStringList.Create;
//      try
//
//        // Include/Exclude Filters
//        for i := 0 to Pred(lbItems.Count) do begin
//          if lbItems.Item[i].SubItemChecked[1] then
//            includeList.Add(lbItems.Item[i].Caption) else
//            if lbItems.Item[i].SubItemChecked[2] then
//              excludeList.Add(lbItems.Item[i].Caption);
//        end;
//
//        Add('IFilters', includeList.DelimitedText);
//        Add('EFilters', excludeList.DelimitedText);
//
//      finally
//        includeList.Free;
//        excludeList.Free;
//      end;
//    end;
//
//  finally
//    fileName := GetSharpeUserSettingsPath + 'SharpCore\Services\TaskSwitch\' + FPluginId + '.xml';
//    XML.SaveToFile(fileName);
//    XML.Free;
//  end;
//
//end;

{ TItemData }

constructor TItemData.Create(AName: string; AId: Integer);
begin
  FName := AName;
  FId := AId;
end;

procedure TfrmEdit.UpdateSize;
begin
  if lbItems.Visible then
    Self.Height := lbItems.Height + chkFilter.Top + 50
  else
    Self.Height := chkFilter.Top + 50;
end;

end.

