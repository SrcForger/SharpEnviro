{
Source Name: SettingsWnd.pas
Description: ButtonBar Module - Settings Window
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Types,
  Forms, Dialogs, StdCtrls, ComCtrls, GR32_RangeBars, SharpApi, SharpDialogs,
  GR32_Image, SharpIconUtils, GR32, ImgList;

type
  TSettingsForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    lb_barsize: TLabel;
    tb_size: TGaugeBar;
    cb_labels: TCheckBox;
    cb_icon: TCheckBox;
    Label1: TLabel;
    iml: TImageList;
    buttons: TListView;
    btn_new: TButton;
    btn_edit: TButton;
    btn_delete: TButton;
    btn_up: TButton;
    btn_down: TButton;
    procedure btn_downClick(Sender: TObject);
    procedure btn_upClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure btn_newClick(Sender: TObject);
    procedure tb_sizeChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    function GetImage(pTarget,pIcon : String) : TBitmap;
  public
    procedure AddButton(pTarget, pCaption, pIcon : String);
  end;


implementation

{$R *.dfm}

uses ButtonAddWnd;



procedure TSettingsForm.Button1Click(Sender: TObject);
begin
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

procedure TSettingsForm.btn_newClick(Sender: TObject);
var
  addwnd : TButtonAddForm;
begin
  addwnd := TButtonAddForm.Create(self);
  addwnd.ActionStr := 'C:\';
  addwnd.edit_action.Text := 'C:\';
  addwnd.UpdateIcon;

  if addwnd.ShowModal = mrOk then
     AddButton(addwnd.edit_action.Text,addwnd.Edit_caption.Text,addwnd.edit_icon.Text);

  addwnd.Free;
end;

function TSettingsForm.GetImage(pTarget,pIcon : String) : TBitmap;
var
  BGBmp,Bmp : TBitmap32;
begin
  result := TBitmap.Create;
  result.Canvas.Brush.Color := clWindow;
  result.Width := iml.Width;
  result.Height := iml.Height;
  result.Canvas.FillRect(result.Canvas.ClipRect);
  BGBmp := TBitmap32.Create;
  Bmp := TBitmap32.Create;
  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;
  IconStringToIcon(pIcon,pTarget,Bmp);
  BGBmp.SetSize(Bmp.Width,Bmp.Height);
  BGBmp.Clear(color32(clWindow));
  Bmp.DrawTo(BGBmp);
  BGBmp.DrawTo(result.Canvas.Handle,Rect(0,0,result.Width,result.Height),Rect(0,0,Bmp.Width,Bmp.Height));
end;

procedure TSettingsForm.AddButton(pTarget, pCaption, pIcon : String);
var
  oBmp : TBitmap;
  LItem : TListItem;
begin
  oBmp := GetImage(pTarget,pIcon);
  iml.Add(oBmp,nil);
  oBmp.Free;

  LItem := Buttons.Items.Add;
  LItem.Caption := pCaption;
  LItem.ImageIndex := iml.Count - 1;
  LItem.SubItems.Add(pTarget);
  LItem.SubItems.Add(pIcon);
end;

procedure TSettingsForm.btn_editClick(Sender: TObject);
var
  addwnd : TButtonAddForm;
  LItem : TListItem;
  oBmp : TBitmap;
begin
  LItem := Buttons.Selected;
  if Litem = nil then exit;
  addwnd := TButtonAddForm.Create(self);
  addwnd.ActionStr := LItem.SubItems[0];
  addwnd.edit_action.Text := LItem.SubItems[0];
  addwnd.Edit_caption.Text := LItem.Caption;
  addwnd.edit_icon.Text := LItem.SubItems[1];
  addwnd.UpdateIcon;

  if addwnd.ShowModal = mrOk then
  begin
    oBmp := GetImage(addwnd.edit_action.Text,addwnd.edit_icon.Text);
    iml.Replace(LItem.ImageIndex,oBmp,nil);
    oBmp.Free;

    LItem.Caption := addwnd.Edit_caption.Text;
    LItem.SubItems.Clear;
    LItem.SubItems.Add(addwnd.edit_action.Text);
    LItem.SubItems.Add(addwnd.edit_icon.Text);
  end;

  addwnd.Free;
end;

procedure TSettingsForm.btn_deleteClick(Sender: TObject);
begin
  if Buttons.Selected = nil then exit;
  Buttons.DeleteSelected;
end;

// Source:
// http://www.delphi-library.de/viewtopic.php?t=50284&start=0&postdays=0&postorder=asc
procedure MoveLVItem(LV: TListView;Direction: TSearchDirection);
var
  aItem,
  NextItem,
  TmpItem : TListItem;
begin 
  with LV do 
  begin 
   if IsEditing or not Assigned(ItemFocused) then 
      exit;//raus wenn Item editiert wird oder kein Item selektiert ist 
    aItem := ItemFocused; 
    case Direction of 
      sdAbove : if aItem.Index = 0 then 
                  exit;//Erstes Item ist markiert > raus 
      sdBelow : if aItem.Index = Items.Count-1 then 
                  exit;//Letztes Item ist markiert > raus 
    end; 
    NextItem := GetNextItem(aItem,Direction,[isNone]); 
    Items.BeginUpdate; 
    try 
      TmpItem := TListItem.Create(Items); 
      TmpItem.Assign(NextItem); 
      NextItem.Assign(aItem); 
      aItem.Assign(TmpItem); 
      aItem.Selected := NextItem.Selected; 
      TmpItem.Free; 
      NextItem.MakeVisible(True); 
      ItemFocused := NextItem; 
      Selected := NextItem; 
    finally 
      Items.EndUpdate; 
    end; 
  end; 
end;

procedure TSettingsForm.btn_upClick(Sender: TObject);
begin
  MoveLVItem(Buttons,sdAbove);
end;

procedure TSettingsForm.btn_downClick(Sender: TObject);
begin
  MoveLVItem(Buttons,sdBelow);
end;

end.
