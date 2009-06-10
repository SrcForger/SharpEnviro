{
Source Name: uEditWnd.pas
Description: <Type> Items Edit window
Copyright (C) <Author> (<Email>)

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
  // Standard
  Windows,
  Messages,
  SysUtils,
  Forms,
  Variants,
  Classes,
  ImgList,
  Controls,
  Graphics,

  // SharpE
  SharpApi,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,

  // Jedi
  JvExControls,
  JvComponentBase,
  JclSysInfo,

  // PngImage
  PngImageList, Buttons, PngSpeedButton, StdCtrls, ExtCtrls, SharpEListBoxEx, uAppBarList, SharpDialogs,
  Menus, Dialogs;

type
  TfrmEdit = class(TForm)
    edName: TLabeledEdit;
    edCommand: TLabeledEdit;
    btnCommandBrowse: TPngSpeedButton;
    edIcon: TLabeledEdit;
    btnIconBrowse: TPngSpeedButton;
    targetPopup: TPopupMenu;
    File1: TMenuItem;
    RunningProcess1: TMenuItem;
    Open1: TMenuItem;
    ilWndClass: TPngImageList;
    OpenApplication: TOpenDialog;

    procedure UpdateEditState(Sender: TObject);
    procedure btnCommandBrowseClick(Sender: TObject);
    procedure btnIconBrowseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EnumWindowsPopupClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
  private
    { Private declarations }
    FUpdating: Boolean;
    FItemEdit: TAppBarItem;
    FPluginHost: ISharpCenterHost;
    procedure BuildWindowList;    
  public
    { Public declarations }
    
    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
    property ItemEdit: TAppBarItem read FItemEdit write FItemEdit;
    procedure Init;
    procedure Save;
  end;

var
  frmEdit: TfrmEdit;

implementation

uses
  uListWnd;

{$R *.dfm}

procedure TfrmEdit.Init;
var
  tmpItem: TSharpEListItem;
  tmp: TAppBarItem;
begin
  FUpdating := True;
  try

    case FPluginHost.EditMode of
      sceAdd: begin
          edName.Text := '';
          edCommand.Text := '';
          edIcon.Text := 'shell:icon';
        end;
      sceEdit: begin
          if frmList.lbItems.SelectedItem = nil then
            exit;

          tmpItem := frmList.lbItems.SelectedItem;
          tmp := TAppBarItem(tmpItem.Data);
          FItemEdit := tmp;

          edName.Text := tmp.Name;
          edCommand.Text := tmp.Command;
          edIcon.Text := tmp.Icon;
          edName.SetFocus;
        end;
    end;

  finally
    FUpdating := False;
  end;
end;

procedure TfrmEdit.Open1Click(Sender: TObject);
begin
  if OpenApplication.Execute then
    if FileExists(OpenApplication.FileName) then
      edCommand.Text := OpenApplication.FileName;
end;

procedure TfrmEdit.btnCommandBrowseClick(Sender: TObject);
begin
  BuildWindowList;
end;

procedure TfrmEdit.btnIconBrowseClick(Sender: TObject);
var
  s: string;
begin
  s := SharpDialogs.IconDialog(edIcon.Text,
    SMI_ALL_ICONS,
    ClientToScreen(point(btnIconBrowse.Left, btnIconBrowse.Top)));
  if length(trim(s)) > 0 then
  begin
    edIcon.Text := s;
  end;
end;

function GetWndClass(wnd: hwnd): string;
var
  buf: array[0..127] of Char;
begin
  GetClassName(wnd, buf, SizeOf(buf));
  result := buf;
end;

function GetCaption(wnd: hwnd): string;
var
  buf: array[0..1024] of char;
begin
  GetWindowText(wnd, @buf, sizeof(buf));
  result := buf;
end;

function GetIcon(wnd: hwnd): hicon;
const
  ICON_SMALL2 = 2;
var
  newicon: hicon;
begin
  newicon := 0;

  SendMessageTimeout(wnd, WM_GETICON, ICON_SMALL, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK, 50, DWORD(newicon));
  if newicon = 0 then newicon := HICON(GetClassLong(wnd, GCL_HICONSM));
  if newicon = 0 then SendMessageTimeout(wnd, WM_GETICON, ICON_SMALL2, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK, 50, DWORD(newicon));
  result := newicon;
end;

procedure TfrmEdit.EnumWindowsPopupClick(Sender: TObject);
begin
  if not (Sender is TMenuItem) then exit;
  frmEdit.edCommand.Text := GetProcessNameFromWnd(TMenuItem(Sender).Tag);
end;

procedure TfrmEdit.BuildWindowList;

  function EnumWindowsProc(wnd: HWND; lparam: LPARAM): bool; stdcall;
  var
    item: TMenuItem;
    tempIcon: TIcon;
    icon : hIcon;
    validicon : boolean;
    sWndClass, sCaption, sProcName, s: string;
  begin
    if (GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) and
      ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
      (GetWindowLong(Wnd, GWL_STYLE) and WS_CHILD = 0) and
      (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0)) then
    begin
      item := TMenuItem.Create(frmEdit.RunningProcess1);
      item.Tag := wnd;

{$REGION 'GetWndClass'}
      sWndClass := '';
      s := GetWndClass(wnd);
      if s <> '' then begin
        if length(s) > 30 then begin
          SetLength(s, 27);
          s := s + '...';
        end;
        sWndClass := Format('%s -', [s]);
      end;
{$ENDREGION}

{$REGION 'GetCaption'}
      sCaption := '';
      s := GetCaption(wnd);
      if s <> '' then begin
        if length(s) > 30 then begin
          SetLength(s, 27);
          s := s + '...';
        end;
        sCaption := Format(' (%s)', [s]);
      end;
{$ENDREGION}

{$REGION 'GetProcessName'}
      sProcName := '';
      s := ExtractFileName(GetProcessNameFromWnd(wnd));
      if s <> '' then begin
        if length(s) > 30 then begin
          SetLength(s, 27);
          s := s + '...';
        end;
        sProcName := Format(' [%s]', [s]);
      end;
{$ENDREGION}

      item.Caption := Format('%s%s%s', [sWndClass, sCaption, sProcName]);
      item.ImageIndex := frmEdit.ilWndClass.Count;
      item.OnClick := EnumWindowsPopupClick;
      frmEdit.RunningProcess1.add(item);
      validicon := True;
      tempIcon := TIcon.Create;
      try
        icon := GetIcon(wnd);
        if icon <> 0 then
          tempIcon.Handle := icon
        else validicon := False;
        if validicon then
          validicon := (tempIcon.Width <= 16) and (tempIcon.Width > 0);
        if validicon then
          frmEdit.ilWndClass.AddIcon(tempIcon)
        else item.ImageIndex := 3;
      finally
        tempIcon.Free;
      end;
    end;
    result := True;
  end;

var
  n : integer;

begin
  for n := ilWndClass.Count - 1 downto 4 do
    ilWndClass.Delete(n);
  RunningProcess1.clear;
  EnumWindows(@EnumWindowsProc, 0);
  targetPopup.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  FItemEdit := TAppBarItem.Create('','','');
end;

procedure TfrmEdit.FormShow(Sender: TObject);
begin
  Self.DoubleBuffered := True;
end;

procedure TfrmEdit.Save;
var
  tmpItem: TSharpEListItem;
  tmp: TAppBarItem;
begin

  case PluginHost.EditMode of
    sceAdd: begin
        frmList.Items.AddButtonItem(edName.Text, edCommand.Text, edIcon.Text);
        FPluginHost.Save;
        BroadcastGlobalUpdateMessage(suTaskAppBarFilters, 0, True);
      end;
    sceEdit: begin
        tmpItem := frmList.lbItems.SelectedItem;
        tmp := TAppBarItem(tmpItem.Data);
        tmp.Name := edName.Text;
        tmp.Command := edCommand.Text;
        tmp.Icon := edIcon.Text;
        FPluginHost.Save;
        BroadcastGlobalUpdateMessage(suTaskAppBarFilters, 0, True);
      end;
  end;

  LockWindowUpdate(frmList.Handle);
  try
    frmList.RenderItems;
  finally
    LockWindowUpdate(0);
  end;

  FPluginHost.Refresh;
end;

procedure TfrmEdit.UpdateEditState(Sender: TObject);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

end.

