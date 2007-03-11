{
Source Name: SettingsWnd.pas
Description: ButtonBar Module - Add Button Settings Window
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


unit ButtonAddWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32_Image, StdCtrls, Types, SharpDialogs, SharpIconUtils, GR32;

type
  TButtonAddForm = class(TForm)
    Label1: TLabel;
    lb_icon: TLabel;
    edit_action: TEdit;
    btn_open: TButton;
    img_icon: TImage32;
    edit_icon: TEdit;
    btn_selecticon: TButton;
    Edit_caption: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure btn_selecticonClick(Sender: TObject);
    procedure btn_openClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    ActionStr : String;
    procedure UpdateIcon;
  end;


implementation

{$R *.dfm}

procedure TButtonAddForm.UpdateIcon;
var
  Bmp : TBitmap32;
begin
  Bmp := TBitmap32.Create;
  try
    Bmp.DrawMode := dmBlend;
    Bmp.CombineMode := cmMerge;
    img_icon.Bitmap.SetSize(img_icon.Width,img_icon.Height);
    img_icon.Bitmap.Clear(color32(self.Color));
    if IconStringToIcon(edit_icon.Text,edit_action.Text,Bmp) then
       Bmp.DrawTo(img_icon.Bitmap,Rect(0,0,img_icon.Bitmap.Width,img_icon.Bitmap.Height));
  finally
    Bmp.Free;
  end;
end;

procedure TButtonAddForm.Button1Click(Sender: TObject);
begin
  ActionStr := edit_action.Text;
  self.ModalResult := mrOk;
end;

procedure TButtonAddForm.Button2Click(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TButtonAddForm.btn_openClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.TargetDialog(STI_ALL_TARGETS,
                                 ClientToScreen(point(btn_open.Left,btn_open.Top)));
  if length(trim(s))>0 then
  begin
    edit_action.Text := s;
    UpdateIcon;
  end;
end;

procedure TButtonAddForm.btn_selecticonClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.IconDialog(edit_action.Text,
                               SMI_ALL_ICONS,
                               ClientToScreen(point(btn_selecticon.Left,btn_selecticon.Top)));
  if length(trim(s))>0 then
  begin
    edit_icon.Text := s;
    UpdateIcon;
  end;
end;

end.
