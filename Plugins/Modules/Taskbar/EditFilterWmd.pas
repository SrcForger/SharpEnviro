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
  Menus, ImgList, JvSimpleXML, SharpApi;

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
    rb_filename: TRadioButton;
    edit_filename: TEdit;
    btn_find2: TButton;
    btn_cancel: TButton;
    btn_ok: TButton;
    btn_examplefilters: TButton;
    examplefilterpopup: TPopupMenu;
    VisibleTasksonly1: TMenuItem;
    MinimizedTasjs1: TMenuItem;
    ExplorerWindows1: TMenuItem;
    rb_monvwm: TRadioButton;
    rb_notmonvwm: TRadioButton;
    procedure btn_examplefiltersClick(Sender: TObject);
    procedure ExplorerWindows1Click(Sender: TObject);
    procedure MinimizedTasjs1Click(Sender: TObject);
    procedure VisibleTasksonly1Click(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rb_classnameClick(Sender: TObject);
    procedure rb_showstateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_find1Click(Sender: TObject);
    procedure PopupItemOnClick(Sender : TObject);
    procedure UpdateStates;
    procedure LoadFromXML(FilterName : String);
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


procedure TEditFilterForm.LoadFromXML(FilterName : String);
var
  XML : TJvSimpleXML;
  i,n : integer;
  fn : string;
begin
  fn := SharpApi.GetSharpeGlobalSettingsPath + 'SharpBar\Module Settings\TaskBar\';
  ForceDirectories(fn);
  fn := fn + 'Filters.xml';
  if not FileExists(fn) then exit;

  XML := TJvSimpleXMl.Create(nil);
  try
    XML.LoadFromFile(fn);
    for n := 0 to XML.Root.Items.Count - 1 do
    with XML.Root.Items.Item[n].Items do
    begin
      if Value('Name','') = FilterName then
      begin
        edit_name.Text := Value('Name','');
        edit_name.Hint := FilterName;
        edit_filename.Text := Value('FileName','');
        edit_classname.Text := Value('WndClassName','');
        i := IntValue('FilterType',2);
        case i of
          0: rb_showstate.Checked := True;
          1: rb_classname.Checked := True;
          3: rb_monvwm.Checked    := True;
          4: rb_notmonvwm.Checked := True;
          else rb_filename.Checked := True;
        end;
        for i := 0 to clb_showstates.Count - 1 do
            if BoolValue('SW_'+inttostr(i),False) then
               clb_showstates.Checked[i] := True
               else clb_showstates.Checked[i] := False;
        break;
      end;
    end;
  except
  end;
  XML.Free;
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
        tempIcon := TIcon.Create;
        try
          tempIcon.Handle := GetIcon(wnd);
          EditFilterForm.wndcimages.AddIcon(tempIcon);
        finally
          tempIcon.Free;
        end;
    end;
    result := True;
  end;

begin
  wndclasspopup.Tag := TButton(Sender).Tag;
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
  case wndclasspopup.Tag of
    0: edit_classname.Text := GetWndClass(TMenuItem(Sender).Tag);
    1: edit_filename.Text := ExtractFileName(GetProcessNameFromWnd(TMenuItem(Sender).Tag));
  end;
end;

procedure TEditFilterForm.rb_showstateClick(Sender: TObject);
begin
  UpdateStates;
end;

procedure TEditFilterForm.UpdateStates;
begin
  clb_showstates.Enabled := False;
  edit_classname.Enabled := False;
  edit_filename.Enabled  := False;
  btn_find1.Enabled      := False;
  btn_find2.Enabled      := False;
  if rb_showstate.Checked then clb_showstates.Enabled := True
     else if rb_classname.Checked then
     begin
       edit_classname.Enabled := True;
       btn_find1.Enabled := True;
     end
     else if rb_filename.Checked then
     begin
       edit_filename.Enabled := True;
       btn_find2.Enabled := True;
     end;
end;

procedure TEditFilterForm.rb_classnameClick(Sender: TObject);
begin
  UpdateStates;
end;

procedure TEditFilterForm.FormShow(Sender: TObject);
begin
  UpdateStates;
end;

procedure TEditFilterForm.btn_cancelClick(Sender: TObject);
begin
  Modalresult := mrCancel;
end;

procedure TEditFilterForm.btn_okClick(Sender: TObject);
var
  XML : TJvSimpleXML;
  i,n : integer;
  fn : string;
begin
  if length(trim(edit_name.Text))<=0 then
  begin
    showmessage('please enter a valid name first');
    exit;
  end;

  fn := SharpApi.GetSharpeGlobalSettingsPath + 'SharpBar\Module Settings\TaskBar\';
  ForceDirectories(fn);
  fn := fn + 'Filters.xml';

  XML := TJvSimpleXMl.Create(nil);
  try
    if FileExists(fn) then XML.LoadFromFile(fn)
    else
    begin
      XML.Root.Clear;
      XML.Root.Name := 'Filters';
    end;
    for n := XML.Root.Items.Count - 1 downto 0 do
        if XML.Root.Items.Item[n].Items.Value('Name','') = edit_name.Text then
           XML.Root.Items.Delete(n);
    if edit_name.Text <> edit_name.Hint then
    for n := XML.Root.Items.Count - 1 downto 0 do
        if XML.Root.Items.Item[n].Items.Value('Name','') = edit_name.Hint then
           XML.Root.Items.Delete(n);

    with XML.Root.Items.Add('Filter').Items do
    begin
      Add('Name',edit_name.Text);
      Add('FileName',edit_filename.Text);
      Add('WndClassName',edit_classname.Text);
      if rb_showstate.Checked then i := 0
         else if rb_classname.Checked then i := 1
              else if rb_monvwm.Checked then i := 3
                   else if rb_notmonvwm.Checked then i := 4
                        else i := 2;
      Add('FilterType',i);

      for i := 0 to clb_showstates.Count - 1 do
          Add('SW_'+inttostr(i), clb_showstates.Checked[i]);
    end;
    XML.SaveToFile(fn);
  except
  end;
  XML.Free;
  
  Modalresult := mrOk;
end;

procedure TEditFilterForm.VisibleTasksonly1Click(Sender: TObject);
var
  n : integer;
begin
  edit_name.Text := 'Visible';
  edit_filename.Text := '';
  edit_classname.Text := '';
  rb_showstate.Checked := True;
  for n := 0 to clb_showstates.Count-1 do
      clb_showstates.Checked[n] := False;
  clb_showstates.Checked[1] := True;
  clb_showstates.Checked[3] := True;
  clb_showstates.Checked[5] := True;
  clb_showstates.Checked[8] := True;
  clb_showstates.Checked[9] := True;
  clb_showstates.Checked[10] := True;

  UpdateStates;
end;

procedure TEditFilterForm.MinimizedTasjs1Click(Sender: TObject);
var
  n : integer;
begin
  edit_name.Text := 'Minimized';
  edit_filename.Text := '';
  edit_classname.Text := '';
  rb_showstate.Checked := True;
  for n := 0 to clb_showstates.Count-1 do
      clb_showstates.Checked[n] := False;
  clb_showstates.Checked[2] := True;
  clb_showstates.Checked[6] := True;
  clb_showstates.Checked[7] := True;

  UpdateStates;
end;

procedure TEditFilterForm.ExplorerWindows1Click(Sender: TObject);
var
  n : integer;
begin
  rb_filename.Checked := True;
  edit_name.Text := 'Explorer Windows';
  edit_filename.Text := 'Explorer.exe';
  clb_showstates.enabled := True;
  for n := 0 to clb_showstates.Count-1 do
      clb_showstates.Checked[n] := False;

  UpdateStates;
end;

procedure TEditFilterForm.btn_examplefiltersClick(Sender: TObject);
begin
  examplefilterpopup.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

end.
