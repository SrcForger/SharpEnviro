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
  JvPageList, JvExControls, ComCtrls, Mask, SharpECenterHeader, JvExStdCtrls,
  JvRadioButton, JvXPCore, JvXPCheckCtrls, uSharpBarAPI;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmClock = class(TForm)
    PopupMenu1: TPopupMenu;
    N213046HHMMSS3: TMenuItem;
    N213046HHMMSS1: TMenuItem;
    N213046HHMMSS2: TMenuItem;
    N21304619062006HHMMSSDDMMYYYY1: TMenuItem;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    pnlTop: TPanel;
    lblTop: TLabel;
    edTop: TEdit;
    btnTop: TButton;
    pnlBottom: TPanel;
    lblBottom: TLabel;
    edBottom: TEdit;
    btnBottom: TButton;
    Panel1: TPanel;
    cboSize: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N213046HHMMSS3Click(Sender: TObject);
    procedure btnTopClick(Sender: TObject);
    procedure btnBottomClick(Sender: TObject);
    procedure UpdateSettingsEvent(Sender: TObject);
  private
    procedure UpdateSettings;
    procedure UpdateBottomEdit;
  public
    ModuleID: string;
    BarID : string;
    
    procedure Save;
    procedure Load;
  end;

var
  frmClock: TfrmClock;

const
  Small = 0;
  Medium = 1;
  Large = 2;
  Automatic = 3;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmClock.btnBottomClick(Sender: TObject);
begin
  PopUpMenu1.PopupComponent := edBottom;
  PopUpMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TfrmClock.btnTopClick(Sender: TObject);
begin
  PopUpMenu1.PopupComponent := edTop;
  PopUpMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TfrmClock.UpdateSettingsEvent(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmClock.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmClock.FormShow(Sender: TObject);
begin
  UpdateBottomEdit;
end;

procedure TfrmClock.Load;
var
  xml: TJvSimpleXML;
  loaded: boolean;
  style: Integer;
begin
  xml := TJvSimpleXML.Create(nil);
  loaded := False;
  try
    xml.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(BarID),strtoint(ModuleID)));
    loaded := True;
  except
  end;

  if loaded then
    with xml.Root.Items, frmClock do
    begin

      style := IntValue('Style',0);
      if style < 3 then
        cboSize.ItemIndex := style;

      edTop.Text := Value('Format','HH:MM:SS');
      edBottom.Text := Value('BottomFormat','DD.MM.YYYY');

      if (length(edBottom.Text) > 0) then
        cboSize.ItemIndex := 3;
    end;
  xml.Free;
end;

procedure TfrmClock.N213046HHMMSS3Click(Sender: TObject);
begin
  if PopUpMenu1.PopupComponent is TEdit then
     TEdit(PopUpMenu1.PopupComponent).Text := TMenuItem(Sender).Hint;
  UpdateSettings;     
end;

procedure TfrmClock.Save;
var
  xml : TJvSimpleXML;
  i : integer;
begin
  if frmClock = nil then
    exit;

  xml := TJvSimpleXML.Create(nil);
  try
  xml.Root.Name := 'ClockModuleSettings';
  with XML.Root.Items, frmClock do
  begin

    i := 1;
    if cboSize.ItemIndex <> Automatic then begin
      i := cboSize.ItemIndex;
    Add('Style',i);
    Add('Format',edTop.Text);

    if cboSize.ItemIndex = Automatic then
      Add('BottomFormat',edBottom.Text)
    else Add('BottomFormat','');

  end;
  xml.SaveToFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmClock.BarID),strtoint(frmClock.ModuleID)));
  end;
  finally
    xml.Free;
  end;
end;

procedure TfrmClock.UpdateSettings;
begin
  if Visible then
    SharpCenterApi.CenterDefineSettingsChanged;

  UpdateBottomEdit;
end;

procedure TfrmClock.UpdateBottomEdit;
begin
  pnlBottom.Visible := cboSize.ItemIndex = Automatic;
  CenterUpdateSize;
end;

end.

