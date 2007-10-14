{
Source Name: uClockWnd.pas
Description: Clock Module Settings Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit uClockWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, JclFileUtils,
  ImgList, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit,
  JvPageList, JvExControls, ComCtrls, Mask;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmClock = class(TForm)
    plMain: TJvPageList;
    pagNotes: TJvStandardPage;
    Label3: TLabel;
    lbSize: TLabel;
    rbLarge: TRadioButton;
    rbMedium: TRadioButton;
    rbSmall: TRadioButton;
    cbTwoLine: TCheckBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    EditTwoLine: TEdit;
    btnTwoLine: TButton;
    Panel2: TPanel;
    EditSingleLine: TEdit;
    Button2: TButton;
    lbTwoLine: TLabel;
    PopupMenu1: TPopupMenu;
    N213046HHMMSS3: TMenuItem;
    N213046HHMMSS1: TMenuItem;
    N213046HHMMSS2: TMenuItem;
    N21304619062006HHMMSSDDMMYYYY1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cb_alwaysontopClick(Sender: TObject);
    procedure rb_textClick(Sender: TObject);
    procedure cb_iconClick(Sender: TObject);
    procedure cbTwoLineClick(Sender: TObject);
    procedure N213046HHMMSS3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnTwoLineClick(Sender: TObject);
    procedure rbLargeClick(Sender: TObject);
  private
    procedure UpdateSettings;
  public
    sModuleID: string;
    sBarID : string;
  end;

var
  frmClock: TfrmClock;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmClock.btnTwoLineClick(Sender: TObject);
begin
  PopUpMenu1.PopupComponent := EditTwoLine;
  PopUpMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TfrmClock.Button2Click(Sender: TObject);
begin
  PopUpMenu1.PopupComponent := EditSingleLine;
  PopUpMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TfrmClock.cbTwoLineClick(Sender: TObject);
begin
  UpdateSettings;
  EditTwoLine.Enabled := cbTwoLine.Checked;
  rbLarge.Enabled := not cbTwoLine.Checked;
  rbSmall.Enabled := not cbTwoLine.Checked;
  rbMedium.Enabled := not cbTwoLine.Checked;
  lbSize.Enabled := not cbTwoLine.Checked;
  lbTwoLine.Enabled := cbTwoLine.Checked;
  btnTwoLine.Enabled := cbTwoLine.Checked;  
end;

procedure TfrmClock.cb_alwaysontopClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmClock.cb_iconClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmClock.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmClock.FormShow(Sender: TObject);
begin
  cbTwoLine.OnClick(cbTwoLine);
  Label2.Font.Color := clGrayText;
  lbSize.Font.Color := clGrayText;
  lbTwoLine.Font.Color := clGrayText;
  Label5.Font.Color := clGrayText;
end;

procedure TfrmClock.N213046HHMMSS3Click(Sender: TObject);
begin
  if PopUpMenu1.PopupComponent is TEdit then
     TEdit(PopUpMenu1.PopupComponent).Text := TMenuItem(Sender).Hint;
  UpdateSettings;     
end;

procedure TfrmClock.rbLargeClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmClock.rb_textClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmClock.UpdateSettings;
begin
  if Visible then
    SharpCenterApi.CenterDefineSettingsChanged;
end;

end.

