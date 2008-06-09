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
  SharpEListBoxEx, TaskFilterList, ExtCtrls, JclSimpleXml, JclStrings;

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

  TfrmEdit = class(TForm)
    lbItems: TSharpEListBoxEx;
    pilListBox: TPngImageList;
    pnlOptions: TPanel;
    Label3: TLabel;
    lblTaskOptionsDec: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    chkMinimiseBtn: TCheckBox;
    chkRestoreBtn: TCheckBox;
    cbStyle: TComboBox;
    Label2: TLabel;
    Label6: TLabel;
    cbSortMode: TComboBox;
    Label4: TLabel;
    lblFilterDesc: TLabel;
    lblButtonsDesc: TLabel;
    chkFilterTasks: TCheckBox;
    chkMiddleClose: TCheckBox;
    procedure lbItemsResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
    procedure chkFilterTasksClick(Sender: TObject);
    procedure SettingsChange(Sender: TObject);
  private
    FTaskFilterList: TFilterItemList;
    FModuleId: string;
    FBarId: string;
    FUpdating: boolean;
  public
    procedure RenderItems;
    property BarId: string read FBarId write FBarId;
    property ModuleId: string read FModuleId write FModuleId;

    procedure LoadSettings;
    procedure SaveSettings;
  end;

var
  frmEdit: TfrmEdit;

const
  colName = 0;

implementation

uses SharpThemeApi, SharpCenterApi, uSharpBarAPI, SharpESkin;

{$R *.dfm}

procedure TfrmEdit.SettingsChange(Sender: TObject);
begin
  if not (FUpdating) then
    CenterDefineSettingsChanged;
end;

procedure TfrmEdit.chkFilterTasksClick(Sender: TObject);
begin
  if not (FUpdating) then
    CenterDefineSettingsChanged;

  lbItems.Visible := chkFilterTasks.Checked;
  CenterUpdateSize;
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  lbItems.DoubleBuffered := True;
  lblTaskOptionsDec.Font.Color := clGrayText;
  lblFilterDesc.Font.Color := clGrayText;
  lblButtonsDesc.Font.Color := clGrayText;

  FTaskFilterList := TFilterItemList.Create;
  RenderItems;
end;

procedure TfrmEdit.FormDestroy(Sender: TObject);
begin
  FTaskFilterList.Free;
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

  if not (FUpdating) then
    CenterDefineSettingsChanged;
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

  CenterUpdateConfigFull;
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
  tmpItemData: TItemData;
begin

  tmpItemData := TItemData(AItem.Data);
  if tmpItemData = nil then
    exit;

  case ACol of
    colName: ;
  end;

end;

procedure TfrmEdit.lbItemsResize(Sender: TObject);
begin
  if lbItems.Visible then
    Self.Height := lbItems.Height + pnlOptions.Height else
    Self.Height := pnlOptions.Height;
end;

procedure TfrmEdit.LoadSettings;
var
  xml: TJclSimpleXML;
  fileloaded: boolean;
  state, index, i: Integer;
  sortTasks: boolean;

  includeList, excludeList: TStringList;
begin
  xml := TJclSimpleXML.Create;
  FUpdating := True;
  try
    fileloaded := False;
    try
      XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(StrToInt(FBarId), StrToInt(FModuleId)));
      fileloaded := True;
    except
    end;

    if fileloaded then
      with xml.Root.Items do
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

        // Buttons
        chkMinimiseBtn.Checked := BoolValue('MinAllButton', False);
        chkRestoreBtn.Checked := BoolValue('MaxAllButton', False);
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

  finally
    XML.Free;
    FUpdating := False;
  end;

end;

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

  CenterUpdateEditTabs(lbItems.Count, lbItems.ItemIndex);
  CenterUpdateConfigFull;
end;

procedure TfrmEdit.SaveSettings;
var
  xml: TJclSimpleXML;
  i: Integer;
  includeList, excludeList: TStringList;
begin
  xml := TJclSimpleXML.Create;
  try
    xml.Root.Name := 'TaskBarModuleSettings';
    with xml.Root.Items do
    begin

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

      // Buttons
      Add('MinAllButton', chkMinimiseBtn.Checked);
      Add('MaxAllButton', chkRestoreBtn.Checked);
      Add('FilterTasks', chkFilterTasks.Checked);
      Add('MiddleClose', chkMiddleClose.Checked);

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

        Add('IFilters', includeList.DelimitedText);
        Add('EFilters', excludeList.DelimitedText);

      finally
        includeList.Free;
        excludeList.Free;
      end;
    end;

  finally
    XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(StrToInt(FBarId), StrToInt(FModuleId)));
    XML.Free;
  end;

end;

{ TItemData }

constructor TItemData.Create(AName: string; AId: Integer);
begin
  FName := AName;
  FId := AId;
end;

end.

