{
Source Name: EditFilterWnd.dpr
Description: ---
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

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

unit EditFilterWmd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, JvExExtCtrls, JvComponent, CheckLst,
  Menus, ImgList;

type
  TEditFilterForm = class(TForm)
    rb_showstate: TRadioButton;
    edit_name: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    clb_showstates: TCheckListBox;
    rb_classname: TRadioButton;
    edit_classname: TEdit;
    btn_find1: TButton;
    wndclasspopup: TPopupMenu;
    wndcimages: TImageList;
    procedure rb_classnameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rb_showstateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_find1Click(Sender: TObject);
    procedure PopupItemOnClick(Sender : TObject);
    procedure UpdateStates;
  private
  public
  end;

var
  EditFilterForm: TEditFilterForm;

implementation

uses JclSysInfo;

{$R *.dfm}

  function GetWndClass(wnd : hwnd) : string;
  var
    buf: array [0..127] of Char;
  begin
    GetClassName(wnd, buf, SizeOf(buf));
    result := buf;
  end;

  function GetCaption(wnd : hwnd) : string;
  var
    buf:Array[0..1024] of char;
  begin
    GetWindowText(wnd,@buf,sizeof(buf));
    result := buf;
  end;

  function GetIcon(wnd : hwnd) : hicon;
  const
    ICON_SMALL2 = 2;
  var
    newicon : hicon;
  begin
    newicon := 0;

    SendMessageTimeout(wnd, WM_GETICON, ICON_BIG, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK, 50, DWORD(newicon));
    if newicon = 0 then SendMessageTimeout(wnd, WM_GETICON, ICON_SMALL, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK, 50, DWORD(newicon));
    if newicon = 0 then newicon := HICON(GetClassLong(wnd, GCL_HICON));
    if newicon = 0 then newicon := HICON(GetClassLong(wnd, GCL_HICONSM));
    if newicon = 0 then SendMessageTimeout(wnd, WM_QUERYDRAGICON, 0, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK, 50, DWORD(newicon));
    if newicon = 0 then SendMessageTimeout(wnd, WM_GETICON, ICON_SMALL2, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK, 50, DWORD(newicon));
    result := newicon;
  end;

procedure TEditFilterForm.btn_find1Click(Sender: TObject);

  function EnumWindowsProc(Wnd: HWND; LParam: LPARAM): BOOL; stdcall;
  var
    item : TMenuItem;
    tempIcon : TIcon;
    s1,s2,s3 : string;
  begin
    if (GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) and
       ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
       ((GetWindowLong(Wnd, GWL_HWNDPARENT) = 0) or
       (GetWindowLong(Wnd, GWL_HWNDPARENT) = GetDesktopWindow)) and
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0))  then
    begin
        item := TMenuItem.Create(EditFilterForm.wndclasspopup);
        item.Tag := wnd;
        s1 := GetWndClass(wnd);
        s2 := GetCaption(wnd);
        s3 := GetProcessNameFromWnd(wnd);
        if length(s1)>64 then
        begin
          setlength(s1,61);
          s1 := s1 + '...';
        end;
        if length(s2)>128 then
        begin
          setlength(s2,125);
          s1 := s1 + '...';
        end;
        if length(s3)>128 then
        begin
          setlength(s3,125);
          s1 := s1 + '...';
        end;
        item.Caption := s1 + ' (' + s2 + ') (' + s3 + ')';
        item.ImageIndex := EditFilterForm.wndclasspopup.Items.Count;
        item.OnClick := EditFilterForm.PopupItemOnClick;
        EditFilterForm.wndclasspopup.Items.add(item);
        try
          tempIcon := TIcon.Create;
          tempIcon.Handle := GetIcon(wnd);
          EditFilterForm.wndcimages.AddIcon(tempIcon);
        finally
          tempIcon.Free;
        end;
    end;
    result := True;
  end;

begin
  wndcimages.Clear;
  wndclasspopup.items.clear;
  EnumWindows(@EnumWindowsProc, 0);
  wndclasspopup.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TEditFilterForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  wndcimages.Clear;
  wndclasspopup.items.clear;
end;

procedure TEditFilterForm.PopupItemOnClick(Sender : TObject);
begin
  if not (Sender is TMenuItem) then exit;
  edit_classname.Text := GetWndClass(TMenuItem(Sender).Tag);
end;

procedure TEditFilterForm.rb_showstateClick(Sender: TObject);
begin
  UpdateStates;
end;

procedure TEditFilterForm.FormCreate(Sender: TObject);
begin
  UpdateStates;
end;

procedure TEditFilterForm.UpdateStates;
begin
  clb_showstates.Enabled := False;
  edit_classname.Enabled := False;
  btn_find1.Enabled      := False;
  if rb_showstate.Checked then clb_showstates.Enabled := True
     else if rb_classname.Checked then
     begin
       edit_classname.Enabled := True;
       btn_find1.Enabled := True;
     end;
end;

procedure TEditFilterForm.rb_classnameClick(Sender: TObject);
begin
  UpdateStates;
end;

end.
