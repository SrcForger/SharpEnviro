{
Source Name: uHotkeyServiceEditWnd
Description: Hotkey Item Edit Window
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uHotkeyServiceItemEditWnd;

interface

uses
  // Standard
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  Buttons,
  ComCtrls,
  jpeg,
  ImgList,

  // JVCL
  JvTabBar,
  JvPageList,
  JvExControls,
  JvComponent,

  // Project
  uScHotkeyEdit,

  // JCL
  jclStrings,

  // PNG Image
  pngimage;

type
  TFrmHotkeyEdit = class(TForm)
    dlgOpenFile: TOpenDialog;
    pnl1: TPanel;
    plCommandTypes: TJvPageList;
    pagCommand: TJvStandardPage;
    pagActions: TJvStandardPage;
    Label5: TLabel;
    edtCommand: TEdit;
    cmdBrowse: TButton;
    tbHotkeyType: TJvTabBar;
    Panel1: TPanel;
    cmdAddEdit: TButton;
    cmdCancel: TButton;
    lvActionItems: TListView;
    lvSections: TListView;
    JvModernTabBarPainter1: TJvModernTabBarPainter;
    imlList: TImageList;
    Image2: TImage;
    hkeCommand: TScHotkeyEdit;
    Label1: TLabel;
    Panel2: TPanel;
    hkeAction: TScHotkeyEdit;
    lblActionAssign: TLabel;
    lblSelectAction: TLabel;
    tmrUpdateDlg: TTimer;
    Image1: TImage;

    procedure cmdbrowseclick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdAddEditClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbHotkeyTypeTabSelected(Sender: TObject; Item: TJvTabBarItem);
    procedure lvSectionsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure hkeActionChange(Sender: TObject);
    procedure hkeCommandChange(Sender: TObject);
    procedure lvActionItemsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure tmrUpdateDlgTimer(Sender: TObject);
    procedure FormHide(Sender: TObject);

    procedure RefreshActionGroups;
    procedure RefreshGroupItems(var GroupItem: TListItem);
    procedure SelectItem(ItemText: string);
  private
    { Private declarations }

  public
    { Public declarations }
    SelectedText: string;
  end;

var
  FrmHotkeyEdit: TFrmHotkeyEdit;
  DelimitedList: WideString;
  SelectedItem, SelectedGroup: Integer;

const
  piFile = 0;
  piAction = 1;

implementation

uses
  uHotkeyServiceItemListWnd,
  SharpApi;

{$R *.dfm}

procedure TFrmHotkeyEdit.cmdbrowseclick(Sender: TObject);
begin
  dlgOpenfile.InitialDir := ExtractFileDir(edtCommand.Text);
  if dlgOpenFile.Execute then begin
    edtCommand.Text := dlgopenfile.FileName;
  end;
end;

procedure TFrmHotkeyEdit.cmdCancelClick(Sender: TObject);
begin
  FrmHotkeyEdit.modalresult := -1;
end;

procedure TFrmHotkeyEdit.cmdAddEditClick(Sender: TObject);
begin
  //if (editHotkey.Text = '') or (editCommand.Text = '') then
  //  exit;
end;

procedure TFrmHotkeyEdit.FormShow(Sender: TObject);
begin
  RefreshActionGroups;
  tmrUpdateDlg.Enabled := True;
end;

procedure TFrmHotkeyEdit.tbHotkeyTypeTabSelected(Sender: TObject;
  Item: TJvTabBarItem);
var
  id: integer;
begin
  id := Item.Tag;
  plCommandTypes.ActivePageIndex := id;
end;

procedure TFrmHotkeyEdit.lvSectionsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
    RefreshGroupItems(Item);
end;

procedure TFrmHotkeyEdit.hkeActionChange(Sender: TObject);
begin
  hkeCommand.Text := TScHotkeyEdit(Sender).Text;
end;

procedure TFrmHotkeyEdit.hkeCommandChange(Sender: TObject);
begin
  hkeAction.Text := TScHotkeyEdit(Sender).Text;
end;

procedure TFrmHotkeyEdit.lvActionItemsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then begin
    lblActionAssign.Caption := Format('Assign Action: %s to Hotkey:', [Item.Caption]);
    SelectedItem := Item.Index;
    SelectedGroup := lvSections.ItemIndex;
  end;
end;

procedure TFrmHotkeyEdit.tmrUpdateDlgTimer(Sender: TObject);
begin
  if lvActionItems.SelCount = 0 then begin
    hkeAction.Visible := False;
    lblActionAssign.Visible := False;
    lblSelectAction.Visible := True;
  end
  else begin
    hkeAction.Visible := True;
    lblActionAssign.Visible := True;
    lblSelectAction.Visible := False;
  end;

end;

procedure TFrmHotkeyEdit.RefreshActionGroups;
var
  tmp: Widestring;
  strl: TStringList;
  i: integer;
  NewItem: TListItem;
  Sections: TStringList;
  tokens: TStringList;
  SectionName: string;
begin
  tmp := GetDelimitedActionList;
  Strl := TStringList.Create;
  Sections := TStringList.Create;
  Sections.Sorted := True;
  Sections.Duplicates := dupIgnore;
  Tokens := TStringlist.Create;

  Strl.CommaText := tmp;
  try
    lvSections.items.Clear;
    Newitem := lvSections.Items.Add;
    NewItem.Caption := 'All Actions';
    NewItem.ImageIndex := 0;

    // Add Groups
    for i := 0 to strl.Count - 1 do begin
      StrTokenToStrings(strl.Strings[i], '=', tokens);
      SectionName := tokens[0];

      if Sections.IndexOf(Sectionname) = -1 then begin
        Sections.Add(SectionName);

        Newitem := lvSections.Items.Add;
        NewItem.Caption := SectionName;
        NewItem.ImageIndex := 0;
      end;
    end;
  finally
    Strl.Free;
    Sections.Free;
    Tokens.Free;
    lvSections.ItemIndex := 0;
  end;
end;

procedure TFrmHotkeyEdit.RefreshGroupItems(var GroupItem: TListItem);
var
  tmp: Widestring;
  strl: TStringList;
  i: integer;
  NewItem: TListItem;
  Actions: TStringList;
  tokens: TStringList;
  ActionName, SectionName: string;
begin
  tmp := GetDelimitedActionList;
  Strl := TStringList.Create;
  Actions := TStringList.Create;
  SectionName := GroupItem.Caption;

  Tokens := TStringlist.Create;

  Strl.CommaText := tmp;
  try
    lvActionItems.items.Clear;

    // Add Groups
    for i := 0 to strl.Count - 1 do begin
      StrTokenToStrings(strl.Strings[i], '=', tokens);
      ActionName := tokens[1];

      if (tokens[0] = SectionName) or (SectionName = 'All Actions') then begin
        if Actions.IndexOf(ActionName) = -1 then begin
          Newitem := lvActionItems.Items.Add;
          Newitem.Caption := ActionName;
          NewItem.ImageIndex := 5;
          Actions.Add(ActionName);
        end;
      end;
    end;

    // Select it
    for i := 0 to lvActionItems.Items.Count - 1 do begin
      if SelectedText = lvActionItems.Items.Item[i].Caption then begin
        lvActionItems.ItemIndex := i;
        lvActionItems.Items.Item[i].MakeVisible(false);
        exit;
      end;
    end;

    if strl.Count <> 0 then begin
      lvActionItems.ItemIndex := 0;
      tbHotkeyType.Tabs[1].Enabled := True;
    end else begin
      tbHotkeyType.Tabs[1].Enabled := False;
    end;
  finally
    Strl.Free;
    Tokens.Free;
    Actions.Free;
  end;
end;

procedure TFrmHotkeyEdit.FormHide(Sender: TObject);
begin
  tmrUpdateDlg.Enabled := False;
end;

procedure TFrmHotkeyEdit.SelectItem(ItemText: string);
var
  i: integer;
begin
  for i := 0 to lvActionItems.Items.Count - 1 do begin
    if lowercase(ItemText) = LowerCase(lvActionItems.Items.Item[i].Caption) then begin
      lvActionItems.ItemIndex := i;
      exit;
    end;
  end;
end;

end.

