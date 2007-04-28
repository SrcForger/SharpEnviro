{
Source Name: Settings Wnd
Description: Link object settings window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005
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

unit LinkObjectSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, CommCtrl, Controls, Forms,
  Dialogs, StdCtrls, SharpApi, ComCtrls, ExtCtrls, Buttons, Types,
  SharpDeskApi, SharpDialogs,
  uSharpDeskDebugging,
  uSharpDeskFunctions,
  LinkObjectXMLSettings,
  mlinewnd,
  SharpThemeApi, GR32,
  SharpIconUtils, GR32_Image, Menus;

type
  TSettingsWnd = class(TForm)
    Panel1: TPanel;
    GroupBox15: TGroupBox;
    btn_targetselect: TSpeedButton;
    edit_target: TEdit;
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
    procedure btn_targetselectClick(Sender: TObject);
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
    if IconStringToIcon(edit_icon.Text,edit_target.Text,Bmp,img_icon.Width) then
       Bmp.DrawTo(img_icon.Bitmap,Rect(0,0,img_icon.Bitmap.Width,img_icon.Bitmap.Height));
  finally
    Bmp.Free;
  end;
end;

procedure TSettingsWnd.LoadSettings();
var
  Settings : TLinkXMLSettings;
begin
  if ObjectID=0 then
     exit;

  Settings := TLinkXMLSettings.Create(ObjectID,nil,'Link');
  Settings.LoadSettings;

  Edit_target.Text  := Settings.Target;
  Edit_Caption.Text := Settings.Caption;

  edit_icon.Text := Settings.Icon;
  UpdateIcon;

  dp_calign.ItemIndex := Settings.CaptionAlign;
  cb_mline.Checked    := Settings.MLineCaption;

  cb_mline.OnClick(cb_mline);
  
  DebugFree(Settings);
end;



procedure TSettingsWnd.SaveSettings();
var
   Settings : TLinkXMLSettings;
begin
  if ObjectID=0 then exit;

  Settings := TLinkXMLSettings.Create(ObjectID,nil,'Link');
  Settings.LoadSettings;

  Settings.Target       := edit_target.Text;
  Settings.Caption      := edit_caption.Text;
  Settings.Icon         := edit_icon.text;
  Settings.CaptionAlign := dp_calign.ItemIndex;
  Settings.MLineCaption := cb_mline.Checked;

  Settings.SaveSettings(True);
  DebugFree(Settings);
end;

procedure TSettingsWnd.btn_targetselectClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.TargetDialog(STI_ALL_TARGETS,
                                 GroupBox15.ClientToScreen(point(btn_targetselect.Left,btn_targetselect.Top)));
  if length(trim(s))>0 then edit_target.Text := s;
end;

procedure TSettingsWnd.btn_selecticonClick(Sender: TObject);
var
  s : String;
begin
  s := SharpDialogs.IconDialog(edit_target.Text,
                               SMI_ALL_ICONS,
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
    p := self.ClientToScreen(point(0,0));
    mlinewnd.Left := p.x + self.Width div 2 - mlinewnd.Width div 2;
    mlinewnd.top := p.y + self.Width div 2 - mlinewnd.Height div 2;
    mlinewnd.Memo1.Lines.CommaText := edit_caption.Text;
    if mlinewnd.ShowModal = mrOk then
    begin
      edit_caption.Text := mlinewnd.Memo1.Lines.CommaText;
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

end.
