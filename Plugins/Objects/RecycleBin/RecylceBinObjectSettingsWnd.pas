{
Source Name: Settings Wnd
Description: Link object settings window
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

unit RecylceBinObjectSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, CommCtrl, Controls, Forms,
  Dialogs, StdCtrls, SharpApi, ComCtrls, ExtCtrls, Buttons, Types,
  SharpDeskApi, SharpDialogs,
  uSharpDeskDebugging,
  uSharpDeskFunctions,
  RecycleBinObjectXMLSettings,
  mlinewnd,
  SharpThemeApiEx, GR32,
  SharpIconUtils, GR32_Image, Menus;

type
  TSettingsWnd = class(TForm)
    Panel1: TPanel;
    GroupBox8: TGroupBox;
    btn_mline: TSpeedButton;
    lb_calign: TLabel;
    cb_mline: TCheckBox;
    edit_caption: TEdit;
    dp_calign: TComboBox;
    GroupBox11: TGroupBox;
    Label2: TLabel;
    btn_selecticon: TSpeedButton;
    edit_icon: TEdit;
    img_icon: TImage32;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    edit_icon2: TEdit;
    img_icon2: TImage32;
    cb_data: TCheckBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure btn_selecticonClick(Sender: TObject);
    procedure btn_mlineClick(Sender: TObject);
    procedure cb_mlineClick(Sender: TObject);
  private
  public
    ObjectID : integer;
    procedure SaveSettings;
    procedure LoadSettings;
    procedure UpdateIcon;
  end;



     
implementation


{$R *.dfm}

procedure TSettingsWnd.UpdateIcon;
var
  Bmp : TBitmap32;
begin
  Bmp := TBitmap32.Create;
  try
    Bmp.DrawMode := dmBlend;
    Bmp.CombineMode := cmMerge;
    img_icon.Bitmap.SetSize(img_icon.Width,img_icon.Height);
    img_icon.Bitmap.Clear(color32(self.Color));
    if IconStringToIcon(edit_icon.Text,'',Bmp,img_icon.Width) then
       Bmp.DrawTo(img_icon.Bitmap,Rect(0,0,img_icon.Bitmap.Width,img_icon.Bitmap.Height));
    img_icon2.Bitmap.SetSize(img_icon2.Width,img_icon2.Height);
    img_icon2.Bitmap.Clear(color32(self.Color));
    if IconStringToIcon(edit_icon2.Text,'',Bmp,img_icon2.Width) then
       Bmp.DrawTo(img_icon2.Bitmap,Rect(0,0,img_icon2.Bitmap.Width,img_icon2.Bitmap.Height));
  finally
    Bmp.Free;
  end;
end;

procedure TSettingsWnd.LoadSettings();
var
  Settings : TRecycleXMLSettings;
begin
  if ObjectID=0 then
  begin
    UpdateIcon;
    exit;
  end;

  Settings := TRecycleXMLSettings.Create(ObjectID,nil,'RecycleBin');
  Settings.LoadSettings;

  Edit_Caption.Text := Settings.Caption;

  edit_icon.Text  := Settings.Icon;
  edit_icon2.Text := Settings.Icon2;
  cb_data.Checked := Settings.ShowData;
  UpdateIcon;

  dp_calign.ItemIndex := Settings.CaptionAlign;
  cb_mline.Checked    := Settings.MLineCaption;

  cb_mline.OnClick(cb_mline);

  DebugFree(Settings);
end;



procedure TSettingsWnd.SaveSettings();
var
   Settings : TRecycleXMLSettings;
begin
  if ObjectID=0 then exit;

  Settings := TRecycleXMLSettings.Create(ObjectID,nil,'RecycleBin');
  Settings.LoadSettings;

  Settings.Caption      := edit_caption.Text;
  Settings.Icon         := edit_icon.text;
  Settings.Icon2        := edit_icon2.text;
  Settings.CaptionAlign := dp_calign.ItemIndex;
  Settings.MLineCaption := cb_mline.Checked;
  Settings.ShowData     := cb_data.Checked;

  Settings.SaveSettings(True);
  DebugFree(Settings);
end;

procedure TSettingsWnd.btn_selecticonClick(Sender: TObject);
var
  s : String;
begin
  s := SharpDialogs.IconDialog('',
                               [smiCustomIcon,smiSharpEIcon],
                               GroupBox11.ClientToScreen(point(btn_selecticon.Left,btn_selecticon.Top)));
  if length(trim(s))>0 then
  begin
    edit_icon.Text := s;
    UpdateIcon;
  end;
end;

procedure TSettingsWnd.btn_mlineClick(Sender: TObject);
var
  mlinewnd : TMlineForm;
  p : TPoint;
begin
  try
    mlinewnd := TMlineForm.Create(self);
    mlinewnd.Memo1.Lines.Delimiter := ' ';
    p := self.ClientToScreen(point(0,0));
    mlinewnd.Left := p.x + self.Width div 2 - mlinewnd.Width div 2;
    mlinewnd.top := p.y + self.Width div 2 - mlinewnd.Height div 2;
    mlinewnd.Memo1.Lines.DelimitedText := edit_caption.Text;
    if mlinewnd.ShowModal = mrOk then
    begin
      edit_caption.Text := mlinewnd.Memo1.Lines.DelimitedText;
    end;
  finally
    FreeAndNil(mlinewnd);
  end;
end;

procedure TSettingsWnd.cb_mlineClick(Sender: TObject);
begin
  edit_caption.Enabled := not cb_mline.Checked;
  btn_mline.Enabled := cb_mline.Checked;
end;

procedure TSettingsWnd.SpeedButton1Click(Sender: TObject);
var
  s : String;
begin
  s := SharpDialogs.IconDialog('',
                               [smiCustomIcon,smiSharpEIcon],
                               GroupBox1.ClientToScreen(point(btn_selecticon.Left,btn_selecticon.Top)));
  if length(trim(s))>0 then
  begin
    edit_icon2.Text := s;
    UpdateIcon;
  end;

end;

end.
