{
Source Name: uEditWnd.pas
Description: Media Command List Edit Window
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
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  Buttons,
  ImgList,

  // Project
  uAppCommandList,

  // JCL
  jclStrings,
  SharpDialogs,
  SharpApi,
  SharpCenterApi,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit, PngSpeedButton;

type
  TfrmEditWnd = class(TForm)
    coboAction: TComboBox;
    Label2: TLabel;
    coboCommand: TComboBox;
    Label1: TLabel;
    Label3: TLabel;
    edExecute: TEdit;
    cbDisableWMC: TCheckBox;
    btnBrowse: TButton;
    procedure edHotkeyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpdateEditState(Sender: TObject);
    procedure cmdbrowseclick(Sender: TObject);
    procedure coboCommandChange(Sender: TObject);
    procedure coboActionChange(Sender: TObject);
    procedure edExecuteChange(Sender: TObject);
    procedure cbDisableWMCClick(Sender: TObject);

  private
    { Private declarations }
    FItemEdit: TAppCommandItem;
    FUpdating: Boolean;
    FPluginHost: ISharpCenterHost;
  public
    { Public declarations }
    procedure Init;
    procedure Save;
    procedure UpdateUI;

    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
    property ItemEdit: TAppCommandItem read FItemEdit write FItemEdit;
  end;

var
  frmEditWnd: TfrmEditWnd;

implementation

uses
  uItemsWnd,
  SharpEListBoxEx;

{$R *.dfm}

procedure TfrmEditWnd.cbDisableWMCClick(Sender: TObject);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true; 
end;

procedure TfrmEditWnd.cmdbrowseclick(Sender: TObject);
begin
  edExecute.Text := SharpDialogs.TargetDialog(STI_ALL_TARGETS, Mouse.CursorPos);
end;

procedure TfrmEditWnd.Init;
var
  tmpItem: TSharpEListItem;
  tmp: TAppCommandItem;
  n,i : integer;
  found : boolean;
begin
  FUpdating := True;

  coboCommand.Clear;
  for n := 0 to frmItemsWnd.AppCmdList.Items.Count - 1 do
  begin
    found := False;
    for i := 0 to frmItemsWnd.lbAppCommands.Count - 1 do
      if frmItemsWnd.lbAppCommands.Item[i].Data = frmItemsWnd.AppCmdList.Items.Items[n] then
      begin
        found := True;
        break;
      end;
    if not found then
      coboCommand.Items.AddObject(TAppCommandItem(frmItemsWnd.AppCmdList.Items.Items[n]).Name,frmItemsWnd.AppCmdList.Items.Items[n]);
  end;

  try
    case FPluginHost.EditMode of
      sceAdd:
        begin
          if coboCommand.Items.Count > 0 then
            coboCommand.ItemIndex := 0;
          coboAction.ItemIndex := 0;
          edExecute.Text := '';
          cbDisableWMC.Checked := False;
          coboCommand.Enabled := True;

          FItemEdit := nil;
        end;
      sceEdit:
      begin
        if frmItemsWnd.lbAppCommands.SelectedItem = nil then
          exit;

        tmpItem := frmItemsWnd.lbAppCommands.SelectedItem;
        tmp := TAppCommandItem(tmpItem.Data);
        FItemEdit := tmp;

        coboCommand.Clear;
        coboCommand.Items.Add(tmp.Name);
        coboCommand.ItemIndex := 0;
        coboCommand.Enabled := False;
        coboAction.ItemIndex := Integer(tmp.Action) - 1;
        edExecute.Text := tmp.ActionStr;
        cbDisableWMC.Checked := tmp.DisableWMC;
      end;
    end;
  finally
    UpdateUI;  
    FUpdating := False;
  end;
end;

procedure TfrmEditWnd.Save;
var
  tmp: TAppCommandItem;
begin
  case FPluginHost.EditMode of
    sceAdd:
      begin
        tmp := TAppCommandItem(coboCommand.Items.Objects[coboCommand.ItemIndex]);
        if tmp <> nil then
        begin
          tmp.Action := TAppCommandAction(coboAction.ItemIndex + 1);
          if tmp.Action = acaSharpExecute then
            tmp.ActionStr := edExecute.Text;
          tmp.DisableWMC := cbDisableWMC.Checked;
        end;

        frmItemsWnd.RefreshAppCommandList;
        frmItemsWnd.AppCmdList.SaveSettings;
        FPluginHost.Save;
      end;
    sceEdit:
      begin
        if FItemEdit <> nil then
        begin
          FItemEdit.Action := TAppCommandAction(coboAction.ItemIndex + 1);
          if FItemEdit.Action = acaSharpExecute then
            FItemEdit.ActionStr := edExecute.Text;
          FItemEdit.DisableWMC := cbDisableWMC.Checked;
        end;

        frmItemsWnd.RefreshAppCommandList;
        frmItemsWnd.AppCmdList.SaveSettings;
        FPluginHost.Save;
      end;
  end;

  FPluginHost.Refresh;
end;

procedure TfrmEditWnd.UpdateEditState(Sender: TObject);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEditWnd.UpdateUI;
begin
  edExecute.Enabled := (coboAction.ItemIndex = 1);
  btnBrowse.Enabled := (coboAction.ItemIndex = 1);
end;

procedure TfrmEditWnd.coboActionChange(Sender: TObject);
begin
  if not (FUpdating) then
  begin
    FPluginHost.Editing := true;
    UpdateUI;
  end;
end;

procedure TfrmEditWnd.coboCommandChange(Sender: TObject);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEditWnd.edExecuteChange(Sender: TObject);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true; 
end;

procedure TfrmEditWnd.edHotkeyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateEditState(nil);
end;



end.

