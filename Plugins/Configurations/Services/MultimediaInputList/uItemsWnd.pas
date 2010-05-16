{
Source Name: uItemsWnd.pas
Description: Media Commands Configuration Window
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

unit uItemsWnd;

interface

uses
  // Standard
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Graphics,
  Menus,

  // Project
  PngImageList, SharpCenterThemeApi, uAppCommandList, 
  SharpEListBoxEx, SharpApi, SharpCenterApi, ImgList, ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TfrmItemsWnd = class(TForm)
    imlList: TPngImageList;
    lbAppCommands: TSharpEListBoxEx;

    procedure FormShow(Sender: TObject);
    procedure lbAppCommandsResize(Sender: TObject);
    procedure lbAppCommandsClickItem(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem);
    procedure lbAppCommandsGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbAppCommandsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure FormCreate(Sender: TObject);
    procedure lbAppCommandsGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure FormDestroy(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;
    FAppCmdList : TAppCommandList;
    function CtrlDown: Boolean;
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshAppCommandList;

    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
    property AppCmdList: TAppCommandList read FAppCmdList;
  end;

var
  frmItemsWnd: TfrmItemsWnd;
  ItemSelectedID: Integer = -1;

const
  colName = 0;
  colDelete = 1;
  iidxDelete = 0;

implementation

uses
  uEditWnd;

{$R *.dfm}

procedure TfrmItemsWnd.FormCreate(Sender: TObject);
begin
  lbAppCommands.DoubleBuffered := True;
  FAppCmdList := TAppCommandList.Create;
end;

procedure TfrmItemsWnd.FormDestroy(Sender: TObject);
begin
  FAppCmdList.Free;
end;

procedure TfrmItemsWnd.FormShow(Sender: TObject);
begin
  RefreshAppCommandList;
end;

procedure TfrmItemsWnd.RefreshAppCommandList;
var
  i: Integer;
  tmpItem: TSharpEListItem;
  sName: string;
begin
  sName := '';
  if lbAppCommands.ItemIndex <> -1 then begin
    sName := TAppCommandItem(lbAppCommands.SelectedItem.Data).Name;
  end;

  LockWindowUpdate(Self.Handle);
  Try
    lbAppCommands.Clear;

    for i := 0 to FAppCmdList.Items.Count - 1 do
      if TAppCommandItem(FAppCmdList.Items[i]).Action <> acaNothing then
      begin
        tmpItem := lbAppCommands.AddItem('');
        tmpItem.AddSubItem('');
        tmpItem.AddSubItem('');
        tmpItem.Data := FAppCmdList.Items[i];
      end;

    if sName <> '' then
    begin
      for i := 0 to lbAppCommands.Count -1 do
      begin
        if sName = TAppCommandItem(lbAppCommands.Item[i].Data).Name then
        begin
          lbAppCommands.ItemIndex := i;
          break;
        end;
      end;
    end
    else if lbAppCommands.Count <> 0 then
      lbAppCommands.ItemIndex := 0;
  Finally
    LockWindowUpdate(0);
  End;

  FPluginHost.SetEditTabsVisibility(lbAppCommands.ItemIndex,lbAppCommands.Count);
  FPluginHost.Refresh;
end;

function TfrmItemsWnd.CtrlDown: Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_CONTROL] and 128) <> 0);
end;

procedure TfrmItemsWnd.lbAppCommandsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp: TAppCommandItem;
  bDelete: Boolean;
begin
  tmp := TAppCommandItem(AItem.Data);
  if tmp = nil then
    exit;

  case ACol of
    colDelete:
      begin
        bDelete := True;
        if not (CtrlDown) then
          if (MessageDlg(Format('Are you sure you want to delete: %s?', [tmp.Name]), mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
            bDelete := False;

        if bDelete then
        begin
          tmp.Action := acaNothing;
          RefreshAppCommandList;
          FAppCmdList.SaveSettings;
        end;

      end;
  end;

  if frmEditWnd <> nil then
    frmEditWnd.Init;

  FPluginHost.SetEditTabsVisibility(lbAppCommands.ItemIndex,lbAppCommands.Count);
  FPluginHost.Refresh;
end;

procedure TfrmItemsWnd.lbAppCommandsGetCellCursor(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol >= colDelete then
    ACursor := crHandPoint;
end;

procedure TfrmItemsWnd.lbAppCommandsGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
begin
  if ACol = colName then
    AImageIndex := 2
  else if ACol = colDelete then
    AImageIndex := iidxDelete;
end;

procedure TfrmItemsWnd.lbAppCommandsGetCellText(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AColText: string);
var
  tmpItemData: TAppCommandItem;
  s:String;
  colItemTxt, colDescTxt, colBtnTxt: TColor;
begin

  tmpItemData := TAppCommandItem(AItem.Data);
  if tmpItemData = nil then
    exit;

  case ACol of
    colName: begin
      s := tmpItemData.Name;
      if s = '' then s := '*Untitled';

      AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

      AColText := format('<font color="%s"><b>%s</b> - <font color="%s">%s %s',[ColorToString(colItemTxt),s,ColorToString(colDescTxt),FAppCmdList.ActionToString(tmpItemData.Action),tmpItemData.ActionStr]);
    end;
  end;
end;

procedure TfrmItemsWnd.lbAppCommandsResize(Sender: TObject);
begin
  Self.Height := lbAppCommands.Height;
end;

end.

