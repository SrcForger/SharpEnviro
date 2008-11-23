{
Source Name: uHotkeyServiceEditWnd
Description: Hotkey Item Edit Window
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

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
  SharpEHotkeyEdit,

  // JCL
  jclStrings,
  SharpDialogs,
  SharpApi,
  SharpCenterApi,

  // PNG Image
  pngimage,
  JvComponentBase,
  PngImageList,
  PngBitBtn,
  JvExStdCtrls,
  PngSpeedButton,
  uHotkeyServiceList,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TfrmEditWnd = class(TForm)
    edName: TLabeledEdit;
    edCommand: TLabeledEdit;
    edHotkey: TSharpEHotkeyEdit;
    Button1: TPngSpeedButton;
    Label1: TLabel;
    procedure edHotkeyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpdateEditState(Sender: TObject);
    procedure cmdbrowseclick(Sender: TObject);

  private
    { Private declarations }
    FItemEdit: ThotkeyItem;
    FUpdating: Boolean;
    FPluginHost: TInterfacedSharpCenterHostBase;
  public
    { Public declarations }
    SelectedText: string;
    procedure Init;
    procedure Save;

    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
    property ItemEdit: ThotkeyItem read FItemEdit write FItemEdit;
  end;

var
  frmEditWnd: TfrmEditWnd;
  DelimitedList: WideString;
  SelectedItem, SelectedGroup: Integer;

const
  piFile = 0;
  piAction = 1;

implementation

uses
  uItemsWnd,
  SharpEListBoxEx;

{$R *.dfm}

procedure TfrmEditWnd.cmdbrowseclick(Sender: TObject);
begin
  edCommand.Text := SharpDialogs.TargetDialog(STI_ALL_TARGETS, Mouse.CursorPos);
end;

procedure TfrmEditWnd.Init;
var
  tmpItem: TSharpEListItem;
  tmpHotkey: THotkeyItem;
begin
  FUpdating := True;
  try

    case FPluginHost.EditMode of
      sceAdd: begin
          edName.Text := '';
          edCommand.Text := '';
          edHotkey.Text := '';

          FItemEdit := nil;
        end;
      sceEdit: begin

          if frmItemsWnd.lbHotkeys.SelectedItem = nil then
            exit;

          tmpItem := frmItemsWnd.lbHotkeys.SelectedItem;
          tmpHotkey := THotkeyItem(tmpItem.Data);
          FItemEdit := tmpHotkey;

          edName.Text := tmpHotkey.Name;
          edCommand.Text := tmpHotkey.Command;
          edHotkey.Text := tmpHotkey.Hotkey;
        end;
    end;

  finally
    FUpdating := False;
  end;
end;

procedure TfrmEditWnd.Save;
var
  tmpItem: TSharpEListItem;
  tmpHotkey: THotkeyItem;
begin
  case FPluginHost.EditMode of
    sceAdd: begin
        FHotkeyList.AddItem(edHotkey.Text, edCommand.Text, edName.Text);


        frmItemsWnd.RefreshHotkeys;
        FHotkeyList.Save;
      end;
    sceEdit: begin
        tmpItem := frmItemsWnd.lbHotkeys.Item[frmItemsWnd.lbHotkeys.ItemIndex];
        tmpHotkey := THotkeyItem(tmpItem.Data);
        tmpHotkey.Name := edName.Text;
        tmpHotkey.Hotkey := edHotkey.Text;
        tmpHotkey.Command := edCommand.Text;

        frmItemsWnd.RefreshHotkeys;
        FHotkeyList.Save;
      end;
  end;

  FPluginHost.Refresh;
end;

procedure TfrmEditWnd.UpdateEditState(Sender: TObject);
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

