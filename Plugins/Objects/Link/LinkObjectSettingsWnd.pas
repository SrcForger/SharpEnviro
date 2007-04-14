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
  Dialogs, StdCtrls, SharpApi, SharpFX, ComCtrls,
  pngimage, ExtCtrls, GR32, GR32_PNG, GR32_Image, ImgList,
  Menus, JvSimpleXML, uSharpeColorBox, Buttons,
  Tabs, SharpDeskApi, ShellApi, SharpDialogs,
  uSharpDeskTThemeSettings,
  uSharpDeskTObjectSettings,
  uSharpDeskDebugging,
  uSharpDeskDesktopPanelList,
  uSharpDeskDesktopPanel,
  uSharpDeskFunctions,
  LinkObjectXMLSettings,
  mlinewnd, uSharpEFontSelector,
  SharpThemeApi,
  SharpIconUtils,
  GR32_Resamplers;

type
  TScrollImgView32 = class(TImgView32)
                     private
                     protected
                     public
                     end;

  TSettingsWnd = class(TForm)
    OpenIconDialog: TOpenDialog;
    pagecontrol1: TPageControl;
    tab_general: TTabSheet;
    SelectColorDialog: TColorDialog;
    ColorPopup: TPopupMenu;
    hrobberBack1: TMenuItem;
    hrobberBottom1: TMenuItem;
    hrobberTop1: TMenuItem;
    WorkAreaBack1: TMenuItem;
    WorkAreaBottom1: TMenuItem;
    WorkAreaTop1: TMenuItem;
    N1: TMenuItem;
    Customcolor1: TMenuItem;
    Pickcolor1: TMenuItem;
    Panel1: TPanel;
    TabSheet2: TTabSheet;
    IconList: TImageList;
    TabSheet1: TTabSheet;
    OpenFileDialog: TOpenDialog;
    GroupBox6: TGroupBox;
    Label4: TLabel;
    GroupBox7: TGroupBox;
    cb_blend: TCheckBox;
    tb_blend: TTrackBar;
    cb_AlphaBlend: TCheckBox;
    tb_alpha: TTrackBar;
    GroupBox10: TGroupBox;
    cb_iconshadow: TCheckBox;
    GroupBox11: TGroupBox;
    edit_icon: TEdit;
    Label2: TLabel;
    btn_selecticon: TSpeedButton;
    PopupMenu1: TPopupMenu;
    CustomIcon1: TMenuItem;
    ShellIcon1: TMenuItem;
    SharpEIcon1: TMenuItem;
    img_icon: TImage32;
    GroupBox9: TGroupBox;
    cb_32: TRadioButton;
    cb_48: TRadioButton;
    cb_64: TRadioButton;
    cb_csize: TRadioButton;
    edit_csize: TEdit;
    GroupBox13: TGroupBox;
    cb_iconspacing: TCheckBox;
    tb_iconspacing: TTrackBar;
    tb_iconoffset: TTrackBar;
    cb_iconoffset: TCheckBox;
    cp_cblend: TSharpEColorBox;
    tab_caption: TTabSheet;
    GroupBox8: TGroupBox;
    cb_mline: TCheckBox;
    edit_caption: TEdit;
    btn_mline: TSpeedButton;
    GroupBox12: TGroupBox;
    GroupBox14: TGroupBox;
    cb_caption: TCheckBox;
    cb_shadow: TCheckBox;
    cb_cfont: TCheckBox;
    customfont: TSharpEFontSelector;
    lb_calign: TLabel;
    dp_calign: TComboBox;
    GroupBox15: TGroupBox;
    edit_target: TEdit;
    btn_targetselect: TSpeedButton;

    procedure FormShow(Sender: TObject);
    procedure cb_blendClick(Sender: TObject);
    procedure tb_blendChange(Sender: TObject);
    procedure tb_alphaChange(Sender: TObject);
    procedure cb_AlphaBlendClick(Sender: TObject);
    procedure hrobberBack1AdvancedDrawItem(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
    procedure N1AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; State: TOwnerDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure cb_csizeClick(Sender: TObject);
    procedure cb_32Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_targetselectClick(Sender: TObject);
    procedure edit_csizeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_selecticonClick(Sender: TObject);
    procedure tb_iconoffsetChange(Sender: TObject);
    procedure tb_iconspacingChange(Sender: TObject);
    procedure cb_iconoffsetClick(Sender: TObject);
    procedure cb_iconspacingClick(Sender: TObject);
    procedure cb_bgblendingClick(Sender: TObject);
    procedure scb_bgblendingColorClick(Sender: TObject; Color: TColor);
    procedure cb_captionClick(Sender: TObject);
    procedure btn_mlineClick(Sender: TObject);
    procedure cb_mlineClick(Sender: TObject);
    procedure cb_cfontClick(Sender: TObject);
  private
    procedure MenuOnClick(Sender : TObject);
  public
    ObjectID : integer;
    MouseIsDown_AlphaBlend : Boolean;
    StartX : Integer;
    cs : TColorScheme;
    PanelList : TDesktopPanelList;
    procedure SaveSettings;
    procedure LoadSettings;
    procedure PaintPanels;
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
    if IconStringToIcon(edit_icon.Text,'',Bmp) then
       Bmp.DrawTo(img_icon.Bitmap,Rect(0,0,img_icon.Bitmap.Width,img_icon.Bitmap.Height));
  finally
    Bmp.Free;
  end;
end;

procedure TSettingsWnd.PaintPanels;
begin

end;


procedure TSettingsWnd.LoadSettings();
var
   n,i : integer;
   wIcon : TIcon;
   TempIcon : HIcon;
   s,s2 : String;
   MenuItem : TMenuItem;
   p : PChar;
   Settings : TXMLSettings;
begin
  cs := LoadColorScheme;
  cp_cblend.Color := cs.Throbberback;
  if ObjectID=0 then
  begin
    cb_48.Checked:=True;
    exit;
  end;

  Settings := TXMLSettings.Create(ObjectID,nil);
  Settings.LoadSettings;

  Edit_target.Text  := Settings.Target;
  Edit_Caption.Text := Settings.Caption;
  if Settings.Size = '64' then cb_64.checked := true
     else if Settings.Size = '32' then cb_32.checked := true
          else if Settings.Size = '48' then cb_48.checked := true
               else begin
                      cb_csize.Checked := true;
                      edit_csize.Text  := Settings.Size;
                    end;

  edit_icon.Text := Settings.IconFile;
  UpdateIcon;

  cp_cblend.Color   := Settings.BlendColor;
  tb_blend.Position := Settings.BlendValue;
  cb_blend.Checked  := Settings.ColorBlend;

  cb_shadow.Checked := Settings.Shadow;
  if not cb_shadow.Checked then cb_shadow.Enabled:=False
     else cb_shadow.Enabled:=True;

  cb_caption.Checked := Settings.ShowCaption;
  if not cb_caption.Checked then cb_shadow.Enabled:=False
     else cb_shadow.Enabled:=True;

  cb_iconshadow.Checked     := Settings.UseIconShadow;
  cb_AlphaBlend.Checked     := Settings.AlphaBlend;
  tb_Alpha.Position         := Settings.AlphaValue;

  cb_iconoffset.Checked    := Settings.IconOffset;
  tb_iconoffset.Position   := Settings.IconOffsetValue;
  cb_iconspacing.Checked   := Settings.IconSpacing;
  tb_iconspacing.Position  := Settings.IconSpacingValue;
  cb_iconoffset.OnClick(cb_iconoffset);
  cb_iconspacing.OnClick(cb_iconspacing);

  dp_calign.ItemIndex       := Settings.CaptionAlign;
  cb_mline.Checked                 := Settings.MLineCaption;
  cb_cfont.Checked                 := Settings.CustomFont;
  customfont.Font.Name             := Settings.FontName;
  customfont.Font.Size             := Settings.FontSize;
  customfont.Font.Color            := Settings.FontColor;
  customfont.Font.Bold             := Settings.FontBold;
  customfont.Font.Italic           := Settings.FontItalic;
  customfont.Font.Underline        := Settings.FontUnderline;
  customfont.Font.Shadow           := Settings.FontShadow;
  customfont.Font.ShadowAlphaValue := 255-Settings.FontShadowValue;
  customfont.Font.ShadowColor      := Settings.FontShadowColor;
  customfont.Font.AlphaValue       := Settings.FontAlphaValue;
  customfont.Font.Alpha            := Settings.FontAlpha;

  cb_mline.OnClick(cb_mline);
  
  DebugFree(Settings);
end;



procedure TSettingsWnd.SaveSettings();
var
   IconFile : string;
   Settings : TXMLSettings;
begin
  if ObjectID=0 then exit;
  cs := LoadColorScheme;

  Settings := TXMLSettings.Create(ObjectID,nil);

  if cb_64.Checked then Settings.Size := '64'
     else if cb_48.Checked then Settings.Size := '48'
       else if cb_32.Checked then Settings.Size := '32'
             else if cb_csize.Checked then Settings.Size := edit_csize.Text
                  else Settings.Size:='48';

  Settings.Target           := edit_target.Text;
  Settings.Caption          := edit_caption.Text;
  Settings.ShowCaption      := cb_caption.Checked;
  if (not cb_caption.Checked) or (not cb_Shadow.Checked) then Settings.Shadow := False
     else if cb_Shadow.Checked then Settings.Shadow := True;
  Settings.IconFile         := edit_icon.text;
  Settings.AlphaBlend       := cb_AlphaBlend.Checked;
  Settings.AlphaValue       := tb_alpha.position;
  Settings.BlendColor       := cp_cblend.Color;
  Settings.ColorBlend       := cb_blend.checked;
  Settings.BlendValue       := tb_blend.position;
  Settings.UseIconShadow    := cb_iconshadow.Checked;

  Settings.IconOffset       := cb_iconoffset.Checked;
  Settings.IconOffsetValue  := tb_iconoffset.Position;
  Settings.IconSpacing      := cb_iconspacing.Checked;
  Settings.IconSpacingValue := tb_iconspacing.Position;

  Settings.CaptionAlign     := dp_calign.ItemIndex;
  Settings.MLineCaption     := cb_mline.Checked;
  Settings.CustomFont       := cb_cfont.Checked;
  Settings.FontName         := customfont.Font.Name;
  Settings.FontSize         := customfont.Font.Size;
  Settings.FontColor        := customfont.Font.Color;
  Settings.FontBold         := customfont.Font.Bold;
  Settings.FontItalic       := customfont.Font.Italic;
  Settings.FontUnderline    := customfont.Font.Underline;
  Settings.FontShadow       := customfont.Font.Shadow;
  Settings.FontShadowValue  := 255-customfont.Font.ShadowAlphaValue;
  Settings.FontShadowColor  := customfont.Font.ShadowColor;
  Settings.FontAlphaValue   := customfont.Font.AlphaValue;
  Settings.FontAlpha        := customfont.Font.Alpha;

  Settings.SaveSettings(True);
  DebugFree(Settings);
end;


procedure TSettingsWnd.FormShow(Sender: TObject);
begin
     cs:=LoadColorScheme;
end;

procedure TSettingsWnd.cb_blendClick(Sender: TObject);
begin
  if tb_blend.Max = 0 then exit;
  tb_blend.Enabled := cb_blend.Checked;
  if cb_blend.Checked then
     cb_blend.Caption := 'Color Blend Icon: ' + inttostr(round((tb_blend.Position*100) / tb_blend.Max))+'%'
     else cb_blend.Caption := 'Color Blend Icon: disabled';
end;

procedure TSettingsWnd.tb_blendChange(Sender: TObject);
begin
  cb_blend.OnClick(cb_blend);
end;

procedure TSettingsWnd.tb_alphaChange(Sender: TObject);
begin
  cb_alphablend.OnClick(cb_alphablend);
end;

procedure TSettingsWnd.cb_AlphaBlendClick(Sender: TObject);
begin
  if tb_alpha.Max = 0 then exit;
  tb_alpha.Enabled := cb_alphablend.Checked;
  if cb_alphablend.Checked then
     cb_alphablend.Caption := 'Visibility: ' + inttostr(round((tb_alpha.Position*100) / tb_alpha.Max))+'%'
     else cb_alphablend.Caption := 'Visibility: disabled';
end;

procedure TSettingsWnd.hrobberBack1AdvancedDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
var
   Caption : String;
   dColor : TColor;
begin
     cs := LoadColorScheme;
     with ACanvas do
     begin
          font.Name := 'Small Fonts';
          font.Size := 7;
          font.Style := [];
          if not (odSelected in State) then font.Color := clMenuText
             else font.Color := clHighlightText;
          Caption := TMenuItem(Sender).Hint;
          case ColorPopup.Items.IndexOf(TMenuItem(Sender)) of
           0 : dcolor := cs.Throbberback;
           1 : dcolor := cs.Throbberdark;
           2 : dcolor := cs.Throbberlight;
           3 : dcolor := cs.WorkAreaback;
           4 : dcolor := cs.WorkAreadark;
           5 : dcolor := cs.WorkArealight;
           7 : dcolor := clgray;
           else dcolor := clgray;
          end;
          if not (odSelected in State) then Brush.Color := clBtnFace
             else Brush.Color := clHighlight;
          FillRect(ARect);
          Brush.Color := dcolor;
          Pen.Color := clBlack;
          Rectangle(ARect.Left+1,ARect.Top+1,ARect.Left+16,ARect.Bottom -2);
          if not (odSelected in State) then Brush.Color := clBtnFace
             else Brush.Color := clHighlight;
          TextOut(ARect.Left+18,ARect.Top+3, Caption);
     end;
end;

procedure TSettingsWnd.N1AdvancedDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
begin
     with ACanvas do
     begin
          Pen.Color := clBtnShadow;
          MoveTo(ARect.Left,ARect.Top+2);
          LineTo(ARect.Right,ARect.Top+2);
          Pen.Color := clBtnHighlight;
          MoveTo(ARect.Left,ARect.Top+3);
          LineTo(ARect.Right,ARect.Top+3);
     end;
end;

procedure TSettingsWnd.MenuOnClick(Sender : TObject);
begin

end;

procedure TSettingsWnd.FormDestroy(Sender: TObject);
begin
  PanelList.Clear;
  PanelList.Free;
  PanelList := nil;
end;

procedure TSettingsWnd.cb_csizeClick(Sender: TObject);
begin
  edit_csize.Enabled := True;
end;

procedure TSettingsWnd.cb_32Click(Sender: TObject);
begin
  edit_csize.Enabled := False;
end;

procedure TSettingsWnd.FormCreate(Sender: TObject);
begin
  PanelList := TDesktopPanelList.create(52,52);
  PanelList.LoadFromDirectory(GetSharpeDirectory + 'Images\Panels\');
end;

procedure TSettingsWnd.btn_targetselectClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.TargetDialog(STI_ALL_TARGETS,
                                 GroupBox15.ClientToScreen(point(btn_targetselect.Left,btn_targetselect.Top)));
  if length(trim(s))>0 then edit_target.Text := s;
end;

procedure TSettingsWnd.edit_csizeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  n : integer;
begin
  for n := 0 to 9 do
      if (Key = Ord('1')+n) or (Key<49) then exit;
  edit_csize.Undo;
end;

procedure TSettingsWnd.btn_selecticonClick(Sender: TObject);
var
  p : TPoint;
  s : String;
begin
  s := SharpDialogs.IconDialog(edit_target.Text,
                               SMI_ALL_ICONS,
                               ClientToScreen(point(btn_selecticon.Left,btn_selecticon.Top)));
  if length(trim(s))>0 then
  begin
    edit_icon.Text := s;
    UpdateIcon;
  end;
end;

procedure TSettingsWnd.tb_iconoffsetChange(Sender: TObject);
begin
  cb_iconoffset.OnClick(cb_iconoffset);
end;

procedure TSettingsWnd.tb_iconspacingChange(Sender: TObject);
begin
  cb_iconspacing.OnClick(cb_iconspacing);
end;

procedure TSettingsWnd.cb_iconoffsetClick(Sender: TObject);
begin
  tb_iconoffset.Enabled := cb_iconoffset.Checked;
  if cb_iconoffset.Checked then
     cb_iconoffset.Caption := 'Horizontal(x) offset: ' + inttostr(tb_iconoffset.Position)
     else cb_iconoffset.Caption := 'Horizontal(x) offset: disabled';
end;

procedure TSettingsWnd.cb_iconspacingClick(Sender: TObject);
begin
  tb_iconspacing.Enabled := cb_iconspacing.Checked;
  if cb_iconspacing.Checked then
     cb_iconspacing.Caption := 'Icon <=> Caption spacing:  ' + inttostr(tb_iconspacing.Position)
     else cb_iconspacing.Caption := 'Icon <=> Caption spacing:  disabled';
end;

procedure TSettingsWnd.cb_bgblendingClick(Sender: TObject);
begin
  PaintPanels;
end;

procedure TSettingsWnd.scb_bgblendingColorClick(Sender: TObject; Color: TColor);
begin
  PaintPanels;
end;

procedure TSettingsWnd.cb_captionClick(Sender: TObject);
var
  b : boolean;
begin
  b := cb_caption.Checked;
  dp_calign.Enabled    := b;
  lb_calign.Enabled    := b;
  //groupBox8.Enabled    := b;
  begin
   // groupbox12.Enabled   := b;
    cb_mline.Enabled     := b;
    edit_caption.Enabled := b;
    btn_mline.Enabled    := b;
    cb_cfont.Enabled     := b;    
  end;
  cb_cfont.OnClick(cb_cfont);
  //lb_calign.Enabled    := b;
  //dp_calign.Enabled    := b;
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

procedure TSettingsWnd.cb_cfontClick(Sender: TObject);
begin
  if not cb_cfont.Enabled then customfont.Enabled := False
     else customfont.Enabled := cb_cfont.Checked;
  cb_shadow.Enabled := not cb_cfont.Checked;
end;

end.
