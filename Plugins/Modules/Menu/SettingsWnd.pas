{
Source Name: SettingsWnd.pas
Description: Menu Module - Settings Window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
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

unit SettingsWnd;

interface

uses
  Types, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, SharpDialogs,
  GR32_Image, SharpIconUtils, GR32, GR32_RangeBars;

type
  TSettingsForm = class(TForm)
    cb_labels: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Edit_caption: TEdit;
    Label4: TLabel;
    lb_barsize: TLabel;
    tb_size: TGaugeBar;
    Label1: TLabel;
    cb_menulist: TComboBox;
    cb_icon: TCheckBox;
    img_icon: TImage32;
    lb_icon: TLabel;
    edit_icon: TEdit;
    btn_selecticon: TButton;
    cb_specialskin: TCheckBox;
    procedure cb_iconClick(Sender: TObject);
    procedure cb_labelsClick(Sender: TObject);
    procedure btn_selecticonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tb_sizeChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    sMenu : String;
    procedure UpdateIcon;
  end;


implementation

uses SharpApi;

{$R *.dfm}

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  sMenu := cb_menulist.Text;
  self.ModalResult := mrOk;
end;

procedure TSettingsForm.Button2Click(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TSettingsForm.tb_sizeChange(Sender: TObject);
begin
  lb_barsize.Caption := inttostr(tb_size.Position) + 'px';
end;

procedure TSettingsForm.FormShow(Sender: TObject);
var
  sr : TSearchRec;
  Dir : String;
  s : string;
begin
  cb_menulist.Items.Clear;
  Dir := SharpApi.GetSharpeUserSettingsPath;
  if FindFirst(Dir + 'SharpMenu\*.xml',FAAnyFile,sr) = 0 then
  repeat
    s := sr.Name;
    setlength(s,length(s) - length(ExtractFileExt(s)));
    cb_menulist.Items.Add(s);
    if s = sMenu then cb_menulist.ItemIndex := cb_menulist.Items.Count - 1;
  until FindNext(sr) <> 0;
  FindClose(sr);

  if (cb_menulist.ItemIndex < 0) and (cb_menulist.Items.Count > 0) then
     cb_menulist.ItemIndex := 0;
end;

procedure TSettingsForm.UpdateIcon;
var
  Bmp : TBitmap32;
begin
  Bmp := TBitmap32.Create;
  try
    Bmp.DrawMode := dmBlend;
    Bmp.CombineMode := cmMerge;
    img_icon.Bitmap.SetSize(img_icon.Width,img_icon.Height);
    img_icon.Bitmap.Clear(color32(self.Color));
    if IconStringToIcon(edit_icon.Text,'',Bmp) then
       Bmp.DrawTo(img_icon.Bitmap,Rect(0,0,img_icon.Bitmap.Width,img_icon.Bitmap.Height));
  finally
    Bmp.Free;
  end;
end;

procedure TSettingsForm.btn_selecticonClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.IconDialog('',
                               [smiCustomIcon,smiSharpEIcon],
                               ClientToScreen(point(btn_selecticon.Left,btn_selecticon.Top)));
  if length(trim(s))>0 then
  begin
    edit_icon.Text := s;
    UpdateIcon;
  end;
end;

procedure TSettingsForm.cb_labelsClick(Sender: TObject);
begin
  edit_caption.Enabled := cb_labels.Checked; 
end;

procedure TSettingsForm.cb_iconClick(Sender: TObject);
begin
  edit_icon.Enabled := cb_icon.Checked;
  btn_selecticon.Enabled := cb_icon.Checked;
  lb_icon.Enabled := cb_icon.Checked;
  img_icon.Enabled := cb_icon.Checked;
end;

end.
