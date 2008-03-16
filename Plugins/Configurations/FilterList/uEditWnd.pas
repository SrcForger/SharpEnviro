{
Source Name: uEditWnd.pas
Description: Filter list edit window
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
  // Standard
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Contnrs,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  Buttons,
  ImgList,
  Menus,

  // JVCL
  JvExControls,

  // JCL
  jclStrings,
  SharpApi,
  SharpCenterApi,

  SharpEListBox,
  SharpEListBoxEx,

  // PNG Image
  pngimage,
  JvComponentBase,
  TranComp,
  JvLabel,
  PngImageList,
  JclSysInfo,
  PngBitBtn,
  JvExStdCtrls,
  PngSpeedButton,
  JvErrorIndicator,
  JvValidators, JvPageList, SharpERoundPanel, ComCtrls, JvExComCtrls, JvComCtrls;

type

  TfrmEdit = class(TForm)
    vals: TJvValidators;
    valName: TJvRequiredFieldValidator;
    pilError: TPngImageList;
    errorinc: TJvErrorIndicator;
    valNameExists: TJvCustomValidator;
    edName: TLabeledEdit;
    cbFilterBy: TComboBox;
    JvLabel1: TJvLabel;
    pnlContainer: TSharpERoundPanel;
    pcEdit: TPageControl;
    tabEditSearch: TTabSheet;
    btnSubmenuTargetBrowse: TButton;
    edSubmenuTarget: TLabeledEdit;
    tabSelect: TTabSheet;
    tabWindowCommand: TTabSheet;
    lbSwCommands: TSharpEListBoxEx;
    rbMinimisedTasks: TRadioButton;
    rbCurrentMonitor: TRadioButton;
    rbCurrentVWM: TRadioButton;
    mnuWndClass: TPopupMenu;
    ilWndClass: TImageList;
    rbProcess: TRadioButton;
    rbWindow: TRadioButton;

    procedure valNameExistsValidate(Sender: TObject;
      ValueToValidate: Variant; var Valid: Boolean);
    procedure edHotkeyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpdateEditState(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbSwCommandsGetCellCursor(Sender: TObject;
      const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
    procedure btnSubmenuTargetBrowseClick(Sender: TObject);
    procedure cbFilterBySelect(Sender: TObject);
    procedure lbSwCommandsClickCheck(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AChecked: Boolean);
    procedure rbProcessClick(Sender: TObject);

  private
    { Private declarations }
    FUpdating: Boolean;
    FEditMode: TSCE_EDITMODE_ENUM;

    procedure EnumerateWindows;
    procedure EnumerateShowCommands;
    procedure EnumWindowsPopupClick(Sender: TObject);
  public
    { Public declarations }
    SelectedText: string;
    procedure InitUi(AEditMode: TSCE_EDITMODE_ENUM; AChangePage: Boolean = False);
    function ValidateEdit(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
    procedure ClearValidation;
    function Save(AApply: Boolean; AEditMode: TSCE_EDITMODE_ENUM): Boolean;

    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
  end;

var
  frmEdit: TfrmEdit;

implementation

uses
  uListWnd, SWCmdList, TaskfilterList;

{$R *.dfm}

procedure TfrmEdit.InitUi(AEditMode: TSCE_EDITMODE_ENUM;
  AChangePage: Boolean = False);
var
  tmpItem: TSharpEListItem;
  tmpFilter: TFilterItem;
  tmpSWCmd: TSWCmdItem;
  i: Integer;
begin
  FUpdating := True;
  try

    case AEditMode of
      sceAdd: begin
          edName.Text := '';
          cbFilterBy.Enabled := True;
          cbFilterBy.ItemIndex := 0;

          EnumerateShowCommands;
          tabWindowCommand.Show;

        end;
      sceEdit: begin

          if frmList.lbItems.SelectedItem = nil then
            exit;

          tmpItem := frmList.lbItems.SelectedItem;
          tmpFilter := TFilterItem(tmpItem.Data);
          edName.Text := tmpFilter.Name;

          case tmpFilter.FilterType of
            fteSWCmd: begin

                EnumerateShowCommands;
                for i := 0 to Pred(lbSwCommands.Count) do begin
                  tmpItem := lbSwCommands.Item[i];
                  tmpSWCmd := TSWCmdItem(tmpItem.Data);
                  if tmpSWCmd.SWCmd in tmpFilter.SWCmds then
                    tmpItem.Checked := True;
                end;

                cbFilterBy.ItemIndex := 0;
                tabWindowCommand.Show;
              end;
            fteWindow: begin
                EnumerateShowCommands;
                rbWindow.Checked := True;
                edSubmenuTarget.Text := tmpFilter.WndClassName;
                cbFilterBy.ItemIndex := 1;
                tabEditSearch.Show;
              end;
            fteProcess: begin
                EnumerateShowCommands;
                rbProcess.Checked := True;
                edSubmenuTarget.Text := tmpFilter.FileName;
                cbFilterBy.ItemIndex := 1;
                tabEditSearch.Show;
              end;
            fteCurrentMonitor,
              fteCurrentVWM,
              fteMinimised: begin
                EnumerateShowCommands;
                if tmpFilter.CurrentMonitor then rbCurrentMonitor.Checked := True
                else if tmpFilter.CurrentVWM then rbCurrentVWM.Checked := True
                else if tmpFilter.Minimised then rbMinimisedTasks.Checked := True;
                cbFilterBy.ItemIndex := 2;
                tabSelect.Show;
              end;
          end;
        end;
    end;

  finally
    FUpdating := False;
  end;
end;

function TfrmEdit.ValidateEdit(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
begin
  Result := False;

  case AEditMode of
    sceAdd, sceEdit: begin

        errorinc.BeginUpdate;
        try
          errorinc.ClearErrors;
          vals.ValidationSummary := nil;

          Result := vals.Validate;
        finally
          errorinc.EndUpdate;
        end;
      end;
    sceDelete: Result := True;
  end;
end;

function TfrmEdit.Save(AApply: Boolean;
  AEditMode: TSCE_EDITMODE_ENUM): Boolean;
var
  tmpItem: TSharpEListItem;
  tmpFilter: TFilterItem;
  tmpSWCmd: TSWCmdItem;
  swCmds: TSWCmdEnums;
  sNewFile, sOldFile, sMenuDir: string;
  i: Integer;
begin
  Result := false;
  if not (AApply) then
    Exit;

  with frmList.FilterItemList do begin
    case AEditMode of
      sceAdd: begin

          if tabWindowCommand.Visible then begin

            swCmds := [];
            for i := 0 to Pred(lbSwCommands.Count) do begin
              tmpItem := TSharpEListItem(lbSwCommands.Item[i]);
              tmpSWCmd := TSWCmdItem(tmpItem.Data);

              if tmpItem.Checked then
                Include(swCmds, tmpSWCmd.SWCmd);

            end;
            AddSWCommands(edName.Text, swCmds);

          end else if tabEditSearch.Visible then begin

            if rbProcess.Checked then
              AddFilename(edName.Text, edSubmenuTarget.Text) else
              AddWndClass(edName.Text, edSubmenuTarget.Text);

          end else if tabSelect.Visible then begin

            if rbCurrentMonitor.Checked then
              AddCurrentMonitor(edName.Text, True)
            else if rbCurrentVWM.Checked then
              AddCurrentVWM(edName.Text, True)
            else if rbMinimisedTasks.Checked then
              AddMinimised(edName.Text, True);

          end;

          frmList.FilterItemList.Save;
          Result := True;
        end;
      sceEdit: begin

          tmpItem := frmList.lbItems.SelectedItem;
          tmpFilter := TFilterItem(tmpItem.Data);
          tmpFilter.Name := edName.Text;

          if tabWindowCommand.Visible then begin

            tmpFilter.SWCmds := [];
            for i := 0 to Pred(lbSwCommands.Count) do begin
              tmpItem := TSharpEListItem(lbSwCommands.Item[i]);
              tmpSWCmd := TSWCmdItem(tmpItem.Data);

              if tmpItem.Checked then
                Include(swCmds, tmpSWCmd.SWCmd);

            end;
            tmpFilter.SWCmds := swCmds;
            tmpFilter.FilterType := fteSWCmd;

          end else if tabEditSearch.Visible then begin

            if rbProcess.Checked then begin
              tmpFilter.FileName := edSubmenuTarget.Text;
              tmpFilter.FilterType := fteProcess;
            end else begin
              tmpFilter.WndClassName := edSubmenuTarget.Text;
              tmpFilter.FilterType := fteWindow;
            end;

          end else if tabSelect.Visible then begin

            if rbCurrentMonitor.Checked then begin
              AddCurrentMonitor(edName.Text, True);
              tmpFilter.FilterType := fteCurrentMonitor;
            end
            else if rbCurrentVWM.Checked then begin
              AddCurrentVWM(edName.Text, True);
              tmpFilter.FilterType := fteCurrentVWM;
            end
            else if rbMinimisedTasks.Checked then begin
              AddMinimised(edName.Text, True);
              tmpFilter.FilterType := fteMinimised;
            end;

          end;

          frmList.FilterItemList.Save;
          Result := True;
        end;
    end;

    frmList.RenderItems;
    CenterUpdateConfigFull;
  end;
end;

procedure TfrmEdit.lbSwCommandsClickCheck(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AChecked: Boolean);
begin
  UpdateEditState(nil);
end;

procedure TfrmEdit.lbSwCommandsGetCellCursor(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
begin

  case ACol of
    0, 2, 4: ACursor := crHandPoint;
  end;
end;

procedure TfrmEdit.rbProcessClick(Sender: TObject);
begin
  edSubmenuTarget.Text := '';
  UpdateEditState(nil);
end;

procedure TfrmEdit.UpdateEditState(Sender: TObject);
begin
  if not (FUpdating) then
    CenterDefineEditState(True);
end;

procedure TfrmEdit.btnSubmenuTargetBrowseClick(Sender: TObject);
begin
  EnumerateWindows;
end;

procedure TfrmEdit.cbFilterBySelect(Sender: TObject);
begin
  case cbFilterBy.ItemIndex of
    0: tabWindowCommand.Show;
    1: tabEditSearch.Show;
    2: tabSelect.Show;
  end;
end;

procedure TfrmEdit.ClearValidation;
begin
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TfrmEdit.edHotkeyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateEditState(nil);
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

  SendMessageTimeout(wnd, WM_GETICON, ICON_BIG, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK, 50, DWORD(newicon));
  if newicon = 0 then SendMessageTimeout(wnd, WM_GETICON, ICON_SMALL, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK, 50, DWORD(newicon));
  if newicon = 0 then newicon := HICON(GetClassLong(wnd, GCL_HICON));
  if newicon = 0 then newicon := HICON(GetClassLong(wnd, GCL_HICONSM));
  if newicon = 0 then SendMessageTimeout(wnd, WM_QUERYDRAGICON, 0, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK, 50, DWORD(newicon));
  if newicon = 0 then SendMessageTimeout(wnd, WM_GETICON, ICON_SMALL2, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK, 50, DWORD(newicon));
  result := newicon;
end;

procedure TfrmEdit.EnumerateShowCommands;
var
  tmpLi: TSharpEListItem;
  tmpList: TWindowShowCommandList;
  tmpItem: TSWCmdItem;
  i, col: Integer;
begin
  tmpList := TWindowShowCommandList.Create;
  try
    tmpList.AddItems;
    lbSwCommands.Items.Clear;

    for i := 0 to Pred(tmpList.EnumCount) do begin
      tmpLi := lbSwCommands.AddItem('', tmpList[i].Enabled);
      tmpLi.AddSubItem(tmpList[i].Text);
      tmpLi.Data := tmpList.Item[i];
    end;

  finally
    //tmpList.Free;
  end;
end;

procedure TfrmEdit.EnumerateWindows;

  function EnumWindowsProc(wnd: HWND; lparam: LPARAM): bool; stdcall;
  var
    item: TMenuItem;
    tempIcon: TIcon;
    sWndClass, sCaption, sProcName, s: string;
  begin
    if (GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) and
      ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
      (GetWindowLong(Wnd, GWL_STYLE) and WS_CHILD = 0) and
      (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0)) then
    begin
      item := TMenuItem.Create(frmEdit.mnuWndClass);
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
      item.ImageIndex := frmEdit.mnuWndClass.Items.Count;
      item.OnClick := EnumWindowsPopupClick;
      frmEdit.mnuWndClass.Items.add(item);
      tempIcon := TIcon.Create;
      try
        tempIcon.Handle := GetIcon(wnd);
        frmEdit.ilWndClass.AddIcon(tempIcon);
      finally
        tempIcon.Free;
      end;
    end;
    result := True;
  end;

begin
  ilWndClass.Clear;
  mnuWndClass.items.clear;
  EnumWindows(@EnumWindowsProc, 0);
  mnuWndClass.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TfrmEdit.EnumWindowsPopupClick(Sender: TObject);
begin
  if not (Sender is TMenuItem) then exit;
  if not (frmEdit.rbProcess.Checked) then
    frmEdit.edSubmenuTarget.Text := GetWndClass(TMenuItem(Sender).Tag) else
    frmEdit.edSubmenuTarget.Text := ExtractFileName(GetProcessNameFromWnd(TMenuItem(Sender).Tag));
end;

procedure TfrmEdit.FormShow(Sender: TObject);
begin
  tabWindowCommand.Show;
end;

procedure TfrmEdit.valNameExistsValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  bExistsName: Boolean;
  sName, sMenuDir: string;

  tmpItem: TSharpEListItem;
  tmpMenuItem: TFilterItem;
begin
  sName := trim(StrRemoveChars(ValueToValidate,
    ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));
  sMenuDir := GetSharpeUserSettingsPath + 'SharpMenu\';

  bExistsName := FileExists(sMenuDir + sName + '.xml');
  if (FEditMode = sceEdit) then begin
    tmpItem := frmList.lbItems.SelectedItem;
    tmpMenuItem := TFilterItem(tmpItem.Data);

    if (CompareText(edName.Text, tmpMenuItem.Name) = 0) then
      bExistsName := False;
  end;

  Valid := not (bExistsName);
end;

end.

