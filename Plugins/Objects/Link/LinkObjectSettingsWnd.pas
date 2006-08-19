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
  Menus, FileCtrl, JvSimpleXML, ActiveX, ShlObj, uSharpeColorBox, Buttons,
  Tabs, SharpDeskApi, ShellApi,
  uSharpDeskTThemeSettings,
  uSharpDeskTObjectSettings,
  uSharpDeskTDeskSettings,
  uSharpDeskDebugging,
  uSharpDeskDesktopPanelList,
  uSharpDeskDesktopPanel,
  uSharpDeskFunctions,
  LinkObjectXMLSettings,
  mlinewnd, uSharpEFontSelector,
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
    IconPopup: TPopupMenu;
    TabSheet1: TTabSheet;
    OpenFileDialog: TOpenDialog;
    tab_background: TTabSheet;
    GroupBox1: TGroupBox;
    rb_bg1: TRadioButton;
    rb_bg2: TRadioButton;
    rb_bg3: TRadioButton;
    pc_bg: TPageControl;
    ts_bgskin: TTabSheet;
    ts_themed: TTabSheet;            
    GroupBox3: TGroupBox;
    bglist: TImgView32;
    GroupBox2: TGroupBox;
    cb_bgtransB: TCheckBox;
    tb_bgtransB: TTrackBar;
    GroupBox4: TGroupBox;
    cb_bgtransA: TCheckBox;
    tb_bgtransA: TTrackBar;
    tb_bgthickness: TTrackBar;
    cb_bgthickness: TCheckBox;
    ts_bgnone: TTabSheet;
    Label7: TLabel;
    GroupBox6: TGroupBox;
    Label4: TLabel;
    GroupBox7: TGroupBox;
    cb_blend: TCheckBox;
    tb_blend: TTrackBar;
    cb_AlphaBlend: TCheckBox;
    tb_alpha: TTrackBar;
    targetpopup: TPopupMenu;
    File1: TMenuItem;
    Folder1: TMenuItem;
    popupiconlist: TImageList;
    GroupBox10: TGroupBox;
    cb_iconshadow: TCheckBox;
    Panel3: TPanel;
    cb_themesettingsA: TCheckBox;
    Panel2: TPanel;
    cb_themesettingsB: TCheckBox;
    GroupBox11: TGroupBox;
    edit_icon: TEdit;
    Label2: TLabel;
    btn_selecticon: TSpeedButton;
    PopupMenu1: TPopupMenu;
    CustomIcon1: TMenuItem;
    ShellIcon1: TMenuItem;
    SharpEIcon1: TMenuItem;
    Icon: TImage32;
    GroupBox5: TGroupBox;
    lb_bgcolor: TLabel;
    lb_bgbordercolor: TLabel;
    cp_bgborder: TSharpEColorBox;
    cp_bgcolor: TSharpEColorBox;
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
    scb_bgblending: TSharpEColorBox;
    cb_bgblending: TCheckBox;
    Label5: TLabel;
    S1: TMenuItem;
    shellConnectionsFolder1: TMenuItem;
    shellRecycleBinFolder1: TMenuItem;
    shellPrintersFolder1: TMenuItem;
    shellControlPanelFolder1: TMenuItem;
    shellInternetFolder1: TMenuItem;
    shellDriveFolder1: TMenuItem;
    shellNetworkFolder1: TMenuItem;
    shellCommonAdministrativeTools1: TMenuItem;
    shellAdministrativeTools1: TMenuItem;
    shellSystemX861: TMenuItem;
    shellMyPictures2: TMenuItem;
    shellMyMusic1: TMenuItem;
    shellProfile1: TMenuItem;
    shellCommonProgramFiles1: TMenuItem;
    shellProgramFiles1: TMenuItem;
    shellSystem1: TMenuItem;
    shellWindows1: TMenuItem;
    shellHistory1: TMenuItem;
    shellCookies1: TMenuItem;
    shellLocalAppData1: TMenuItem;
    shellAppData1: TMenuItem;
    shellCommonDocuments1: TMenuItem;
    shellCommonTemplates1: TMenuItem;
    shellCommonAppData1: TMenuItem;
    shellCommonFavorites1: TMenuItem;
    shellCommonDesktop1: TMenuItem;
    shellCommonMenu1: TMenuItem;
    shellCommonPrograms1: TMenuItem;
    shellCommonStartup1: TMenuItem;
    shellTemplates1: TMenuItem;
    shellPrintHood1: TMenuItem;
    shellNetHood1: TMenuItem;
    shellFavorites1: TMenuItem;
    shellPersonal1: TMenuItem;
    shellSendTo1: TMenuItem;
    shellRecent1: TMenuItem;
    shellMenu1: TMenuItem;
    shellPrograms1: TMenuItem;
    shellStartup1: TMenuItem;
    shellDesktop1: TMenuItem;
    shellFonts1: TMenuItem;
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
    Panel4: TPanel;
    cb_themesettingsC: TCheckBox;

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
    procedure cb_themesettingsAClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rb_bg1Click(Sender: TObject);
    procedure rb_bg2Click(Sender: TObject);
    procedure tab_backgroundShow(Sender: TObject);
    procedure rb_bg3Click(Sender: TObject);
    procedure bglistClick(Sender: TObject);
    procedure tb_bgtransBChange(Sender: TObject);
    procedure cb_bgtransBClick(Sender: TObject);
    procedure cb_bgtransAClick(Sender: TObject);
    procedure tb_bgtransAChange(Sender: TObject);
    procedure cb_bgthicknessClick(Sender: TObject);
    procedure tb_bgthicknessChange(Sender: TObject);
    procedure btn_targetselectClick(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure Folder1Click(Sender: TObject);
    procedure edit_csizeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SharpEIcon1Click(Sender: TObject);
    procedure CustomIcon1Click(Sender: TObject);
    procedure ShellIcon1Click(Sender: TObject);
    procedure btn_selecticonClick(Sender: TObject);
    procedure tb_iconoffsetChange(Sender: TObject);
    procedure tb_iconspacingChange(Sender: TObject);
    procedure cb_iconoffsetClick(Sender: TObject);
    procedure cb_iconspacingClick(Sender: TObject);
    procedure cb_bgblendingClick(Sender: TObject);
    procedure scb_bgblendingColorClick(Sender: TObject; Color: TColor;
      ColType: TClickedColorID);
    procedure shellAdministrativeTools1Click(Sender: TObject);
    procedure cb_captionClick(Sender: TObject);
    procedure btn_mlineClick(Sender: TObject);
    procedure cb_mlineClick(Sender: TObject);
    procedure cb_cfontClick(Sender: TObject);
  private
    procedure MenuOnClick(Sender : TObject);
  public
    DeskSettings   : TDeskSettings;
    ObjectSettings : TObjectSettings;
    ThemeSettings  : TThemeSettings;
    ObjectID : integer;
    MouseIsDown_AlphaBlend : Boolean;
    StartX : Integer;
    cs : TColorScheme;
    ThemeIconList : TStringList;
    PanelList : TDesktopPanelList;
    procedure SaveSettings;
    procedure LoadSettings;
    procedure PaintPanels;
    procedure LoadCustomIcon(FileName : String);
    procedure SyncBars(pChecked : boolean; pPosition : integer);
  end;



     
implementation

uses LinkObjectFolderWnd;

{$R *.dfm}


procedure TSettingsWnd.PaintPanels;
var
  n : integer;
  DP : TDesktopPanel;
  Bmp : TBitmap32;
begin
  bgList.Bitmap.SetSize((PanelList.Width + 12)* (PanelList.Count),PanelList.Heigh+12);
  bgList.Bitmap.Clear(color32(bgList.Color));
  for n := 0 to PanelList.Count - 1 do
  begin
    DP := TDesktopPanel(PanelList.Items[n]);
    DP.Paint;
    if cb_bgblending.Checked then
       SharpDeskApi.BlendImage(DP.Bitmap,scb_bgblending.color);
    if n = bgList.Tag then
    begin
     bgList.Bitmap.FillRectTS(Rect(n*(DP.Width+6)+6-2,6-2,n*(DP.Width+6)+6+DP.Width+2,6+DP.Height+2),
                              color32(128,32,32,255));
    end;
    DP.Bitmap.DrawTo(bgList.Bitmap,n*(DP.Width+6)+6,6);
  end;
  if not rb_bg3.checked then
     bgList.Bitmap.FillRectTS(bgList.Bitmap.Canvas.ClipRect,color32(196,196,196,128));
  bgList.Repaint;
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
  ThemeIconList := TStringList.Create;
  try
     p := GetIconList(DeskSettings.Theme.IconSet);
     ThemeIconList.CommaText := p;
     releasebuffer(p);
  except
    releasebuffer(p);
    ThemeIconList.Clear;
  end;

  try
     s := ExtractFileDir(Application.ExeName)+'\Icons\'+DeskSettings.Theme.IconSet+'\IconSet.xml';
     if not FileExists(s) then exit;

     IconList.Clear;
     IconList.BkColor := Icon.color;

     for n:=0 to ThemeIconList.Count -1 do
     begin
           s2 := ExtractFilePath(s) + ThemeIconList.Values[ThemeIconList.Names[n]];
           if FileExists(s2) then
           begin
                wIcon := TIcon.Create;
                TempIcon := loadimage(0,pchar(s2),IMAGE_ICON,32,32,LR_DEFAULTSIZE or LR_LOADFROMFILE);
                if TempIcon = 0 then wIcon.LoadFromFile(s2)
                   else wIcon.Handle := TempIcon;
                IconList.AddIcon(wIcon);
                if TempIcon<>0 then
                begin
                     wIcon.ReleaseHandle;
                     DestroyIcon(TempIcon);
                     TempIcon := 0;
                end;
                wIcon.Free;
           end;
     end;

     IconPopup.Items.Clear;
     i := -1;
     for n:=0 to IconList.Count-1 do
     begin
          i:=i+1;
          MenuItem := TMenuItem.Create(IconPopup.Items);
          MenuItem.Caption :='';
          MenuItem.ImageIndex := n;
          MenuItem.OnClick := MenuOnClick;
          if i=8 then
          begin
               MenuItem.Break := mbBreak;
               i:=0;
          end;
          IconPopup.Items.Add(MenuItem);
          if MenuItem.ImageIndex = 0 then MenuItem.OnClick(MenuItem);
     end;
  except
       IconList.Clear;
  end;

  cs := LoadColorScheme;
  cp_cblend.Color := cs.Throbberback;
  if ObjectID=0 then
  begin
       cb_48.Checked:=True;
       rb_bg1.Checked := True;
       rb_bg1.OnClick(rb_bg1);
       cb_themesettingsA.OnClick(cb_themesettingsA);
       exit;
  end;

  Settings := TXMLSettings.Create(ObjectID,nil);
  Settings.LoadSettings;

  cb_bgblending.Checked := Settings.BGTHBlend;
  scb_bgblending.Color  := Settings.BGTHBlendColor;

  Edit_target.Text  := Settings.Target;
  Edit_Caption.Text := Settings.Caption;
  if Settings.Size = '64' then cb_64.checked := true
     else if Settings.Size = '32' then cb_32.checked := true
          else if Settings.Size = '48' then cb_48.checked := true
               else begin
                      cb_csize.Checked := true;
                      edit_csize.Text  := Settings.Size;
                    end;

  if Settings.IconFile='-2' then
  begin
    Icon.Tag := -2;
    ShellIcon1.Click;
  end else
  begin
    n := ThemeIconList.IndexOfName(Settings.IconFile);
    if (n <> -1) and (n <= IconPopup.Items.Count-1) then
       IconPopup.Items.Items[n].OnClick(IconPopup.Items.Items[n])
       else if FileExists(Settings.IconFile) then
       begin
         Icon.Hint := Settings.IconFile;
         Icon.Tag := -1;
         LoadCustomIcon(Icon.Hint)
       end else IconPopup.Items.Items[0].OnClick(IconPopup.Items.Items[0]);
  end;

  bglist.Tag := 0;
  for n := 0 to PanelList.Count - 1 do
      if TDesktopPanel(PanelList.Items[n]).PanelName  = Settings.BGSkin then
      begin
        bglist.Tag := n;
        break;
      end;
  if bglist.Tag = -1 then
  begin
    bgList.Tag := 0;
    Settings.BGType := 0;
  end;
      
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
  cb_themesettingsA.Checked := Settings.UseThemeSettings;

  cp_bgcolor.Color         := Settings.BGColor;
  cp_bgborder.Color        := Settings.BGBorderColor;
  SyncBars(Settings.BGTrans,Settings.BGTransValue);
  cb_bgthickness.Checked   := Settings.BGThickness;
  tb_bgthickness.Position  := Settings.BGThicknessValue;
  cb_bgthickness.OnClick(cb_bgthickness);

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

  case Settings.BGType of
    0 : begin
          rb_bg1.Checked := True;
          rb_bg1.OnClick(rb_bg1);
        end;
    1 : begin
          rb_bg2.Checked := True;
          rb_bg2.OnClick(rb_bg2);
        end;
    2 : begin
          rb_bg3.Checked := True;
          rb_bg3.OnClick(rb_bg3);
        end;
    else begin
           rb_bg1.Checked := True;
           rb_bg1.OnClick(rb_bg1);
         end;
  end;

  cb_themesettingsA.OnClick(cb_themesettingsA);
  cb_mline.OnClick(cb_mline);  
  
  DebugFree(Settings);
end;



procedure TSettingsWnd.SaveSettings();
var
   n,i : integer;
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

  Settings.BGTHBlend        := cb_bgblending.Checked;
  Settings.BGTHBLendColor   := scb_bgblending.Color;
  Settings.UseThemeSettings := cb_themesettingsA.checked;
  Settings.Target           := edit_target.Text;
  Settings.Caption          := edit_caption.Text;
  Settings.ShowCaption      := cb_caption.Checked;
  if (not cb_caption.Checked) or (not cb_Shadow.Checked) then Settings.Shadow := False
     else if cb_Shadow.Checked then Settings.Shadow := True;
  if Icon.Tag<>-1 then
  begin
       if Icon.Tag=-2 then Iconfile := '-2'
          else IconFile := ThemeIconList.Names[Icon.Tag]
  end else IconFile := Icon.Hint;

  Settings.IconFile         := IconFile;
  Settings.AlphaBlend       := cb_AlphaBlend.Checked;
  Settings.AlphaValue       := tb_alpha.position;
  Settings.BlendColor       := cp_cblend.Color;
  Settings.ColorBlend       := cb_blend.checked;
  Settings.BlendValue       := tb_blend.position;
  Settings.UseIconShadow    := cb_iconshadow.Checked;
  Settings.BGColor          := cp_bgcolor.Color;
  Settings.BGBorderColor    := cp_bgborder.Color;
  Settings.BGThicknessValue := tb_bgthickness.Position;
  Settings.BGThickness      := cb_bgthickness.Checked;
  Settings.BGTransValue     := tb_bgtransA.Position;
  Settings.BGTrans          := cb_bgtransA.Checked;

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

  if bglist.Tag < PanelList.Count then
     Settings.BGSkin := TDesktopPanel(PanelList[bgList.Tag]).PanelName
     else Settings.BGSkin := '';

  if rb_bg3.Checked then Settings.BGType := 2
     else if rb_bg2.Checked then Settings.BGType := 1
          else Settings.BGType := 0;

  Settings.SaveSettings(True);
  ObjectSettings.SaveObjectSettings;
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
  Icon.Bitmap.SetSize(32,32);
  Icon.Bitmap.Clear(color32(Icon.Color));
  IconList.Draw(Icon.Bitmap.Canvas,0,0,TMenuItem(Sender).ImageIndex);
  Icon.Tag := TMenuItem(Sender).ImageIndex;
  edit_icon.Text := ThemeIconList.Names[Icon.Tag]
end;

procedure TSettingsWnd.FormDestroy(Sender: TObject);
begin
  IconList.Clear;
  IconPopup.Items.Clear;
  ThemeIconList.Free;
  PanelList.Clear;
  PanelList.Free;
  PanelList := nil;
end;

procedure TSettingsWnd.cb_csizeClick(Sender: TObject);
begin
  if Icon.Tag=-2 then
  begin
    cb_32.Checked := True;
    exit;
  end;
  edit_csize.Enabled := True;
end;

procedure TSettingsWnd.cb_32Click(Sender: TObject);
begin
  edit_csize.Enabled := False;
  if Icon.Tag=-2 then cb_32.Checked := True;
end;

procedure TSettingsWnd.cb_themesettingsAClick(Sender: TObject);
var
   b : boolean;
begin
  b := not TCheckBox(Sender).Checked;
  cb_themesettingsA.Checked := not b;
  cb_themesettingsB.Checked := not b;
  cb_themesettingsC.Checked := not b;  
  cb_iconshadow.Enabled := b;
  cb_caption.Enabled := b;
  cb_shadow.Enabled := b;
  cb_blend.Enabled := b;
  tb_blend.Enabled := b;
  cb_AlphaBlend.Enabled := b;
  tb_alpha.Enabled := b;
  if (TCheckBox(Sender).Checked) and (DeskSettings<>nil) then
  begin
    if DeskSettings.Theme.DeskDisplayCaption then
    begin
      dp_calign.Enabled := True;
      lb_calign.Enabled := True;
    end else
    begin
      dp_calign.Enabled := False;
      lb_calign.Enabled := False;
    end;
  end else
  begin
    if cb_caption.Enabled then
    begin
      dp_calign.Enabled := cb_caption.Checked;
      lb_calign.Enabled := cb_caption.Checked;
    end else
    begin
      dp_calign.Enabled := False;
      lb_calign.Enabled := False;
    end;
  end;
  cb_alphablend.OnClick(self);
  cb_blend.OnClick(self);
  cb_caption.OnClick(self);
  cb_cfont.OnClick(self);
  cb_mline.OnClick(cb_mline);
end;

procedure TSettingsWnd.FormCreate(Sender: TObject);
begin
  PanelList := TDesktopPanelList.create(52,52);
  PanelList.LoadFromDirectory(GetSharpeDirectory + 'Images\Panels\');
  cb_themesettingsA.OnClick(cb_themesettingsA);
end;

procedure TSettingsWnd.rb_bg1Click(Sender: TObject);
begin
  pc_bg.ActivePage := ts_bgnone;
end;

procedure TSettingsWnd.rb_bg2Click(Sender: TObject);
begin
  pc_bg.ActivePage := ts_themed;
end;

procedure TSettingsWnd.tab_backgroundShow(Sender: TObject);
begin
  PaintPanels;
end;

procedure TSettingsWnd.rb_bg3Click(Sender: TObject);
begin
  pc_bg.ActivePage := ts_bgskin;
  PaintPanels;
end;

procedure TSettingsWnd.bglistClick(Sender: TObject);
var
 p  : TPoint;
 n  : integer;
 DP : TDesktopPanel;
begin
  if not rb_bg3.Checked then exit;
  p := bglist.ScreenToClient(Mouse.CursorPos);
  p.X := p.x + abs(round(bglist.OffsetHorz));
  for n := 0 to PanelList.Count - 1 do
  begin
    DP := TDesktopPanel(PanelList.Items[0]);
    if PointInRect(p,Rect(n*(DP.Width+6)+6,6,n*(DP.Width+6)+6+DP.Width,6+DP.Height)) then
    begin
      bglist.Tag := n;
      PaintPanels;
      exit;
    end;
  end;
end;

procedure TSettingsWnd.SyncBars(pChecked : boolean; pPosition : integer);
begin
  with tb_bgtransA do
  begin
    Position := pPosition;
    Enabled := pChecked;
  end;
  with tb_bgtransB do
  begin
    Position := pPosition;
    Enabled := pChecked;
  end;  
  with cb_bgtransA do
  begin
    Checked := pChecked;
    if tb_bgtransA.Max >0 then
       if not pChecked then
          Caption := 'Visibility: disabled'
           else Caption := 'Visibility: ' + inttostr(round((pPosition*100) / tb_bgtransA.Max))+'%'
  end;
  with cb_bgtransB do
  begin
    Checked := pChecked;
    if tb_bgtransA.Max >0 then
       if not pChecked then
          Caption := 'Visibility: disabled'
          else Caption := 'Visibility: ' + inttostr(round((pPosition*100) / tb_bgtransA.Max))+'%'
  end;
end;

procedure TSettingsWnd.tb_bgtransBChange(Sender: TObject);
begin
  SyncBars(cb_bgtransB.Checked,tb_bgTransB.Position);
end;

procedure TSettingsWnd.cb_bgtransBClick(Sender: TObject);
begin
  SyncBars(cb_bgtransB.Checked,tb_bgTransB.Position);
end;

procedure TSettingsWnd.cb_bgtransAClick(Sender: TObject);
begin
  SyncBars(cb_bgtransA.Checked,tb_bgTransA.Position);
end;

procedure TSettingsWnd.tb_bgtransAChange(Sender: TObject);
begin
  SyncBars(cb_bgtransA.Checked,tb_bgTransA.Position);
end;

procedure TSettingsWnd.cb_bgthicknessClick(Sender: TObject);
begin
  tb_bgthickness.Enabled := cb_bgthickness.Checked;
  if cb_bgthickness.Checked then
     cb_bgthickness.Caption := 'Thickness: ' + inttostr(tb_bgthickness.Position)
     else cb_bgthickness.Caption := 'Thickness: disabled';
end;

procedure TSettingsWnd.tb_bgthicknessChange(Sender: TObject);
begin
  cb_bgthickness.Caption := 'Thickness: ' + inttostr(tb_bgthickness.Position)
end;

procedure TSettingsWnd.btn_targetselectClick(Sender: TObject);
var
  p : TPoint;
begin
  p := self.ClientToScreen(point(btn_targetselect.left,btn_targetselect.Top));
  btn_targetselect.PopupMenu.Popup(p.x-8,p.y+40);
end;

procedure TSettingsWnd.File1Click(Sender: TObject);
var
  filename : string;
  fileExt : string;
  I: Integer;
begin
  if OpenFileDialog.Execute then
  begin
    Edit_target.Text:=OpenFileDialog.FileName;
    if Icon.Tag = -2 then ShellIcon1.Click;
    Filename:=ExtractFileName(edit_target.Text);
    FileExt := ExtractFileExt(FileName);
    if FileExt <> '' then
    begin
      I := LastDelimiter('.' + PathDelim + DriveDelim,Filename);
      if (I = 0) or (FileName[I] <> '.') then I := MaxInt;
      Edit_Caption.Text := Copy(FileName, 1, I - 1);
    end else Edit_Caption.Text := filename;
  end;
end;

procedure TSettingsWnd.Folder1Click(Sender: TObject);
var
  pidl, pidlSelected: PItemIDList;
  bi: TBrowseInfo;
  szDirName: array [0..260] of AnsiChar;
begin
  {Get the root PIDL of the network neighborhood tree}
  if SHGetSpecialFolderLocation(Handle, CSIDL_DESKTOP, pidl) = NOERROR then
  begin
    {Populate a BROWSEINFO structure}
    bi.hwndOwner := Handle;
    bi.pidlRoot := pidl;
    bi.pszDisplayName := szDirName;
    bi.lpszTitle := 'Select directory';
    bi.ulFlags := BIF_RETURNONLYFSDIRS;
    bi.lpfn := nil;
    bi.lParam := 0;
    bi.iImage := - 1;
    {Display the "Browse For Folder" dialog box}
    pidlSelected := SHBrowseForFolder(bi);
    {NULL indicates that Cancel was selected from the dialog box}
    if pidlSelected <> nil then
    begin
      SHGetPathFromIDList(pidlSelected, szDirName);
      edit_target.Text:=szDirName;
      {Release the PIDL of the computer name}
      CoTaskMemFree(pidlSelected);
    end;
    {Release the PIDL of the network neighborhood tree}
    CoTaskMemFree(pidl);
  end;
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

procedure TSettingsWnd.SharpEIcon1Click(Sender: TObject);
var
  p : TPoint;
begin
  p := self.ClientToScreen(point(btn_selecticon.left,btn_selecticon.top));
  IconPopup.Popup(p.x-8,p.y+48);
end;

procedure TSettingsWnd.LoadCustomIcon(FileName : String);
var
  Bmp : TBitmap32;
  b : boolean;
begin
  if (not cb_48.Checked) and (not cb_32.Checked)
      and (not cb_64.Checked) and (not cb_csize.Checked) then cb_48.Checked:=True;
  Bmp := TBitmap32.Create;
  Bmp.SetSize(32,32);
  Bmp.Clear(color32(Icon.Color));
  if Lowercase(ExtractFileExt(FileName)) = '.png' then
     gr32_png.LoadBitmap32FromPNG(Bmp,FileName,b)
     else Bmp.LoadFromFile(FileName);
  Icon.Bitmap.SetSize(32,32);
  Icon.Bitmap.Clear(color32(Icon.Color));
  TLinearResampler.Create(Bmp);
  Bmp.DrawTo(Icon.Bitmap,Icon.Bitmap.canvas.cliprect);
  Icon.Hint := FileName;
  Icon.Tag := -1;
  edit_icon.Text := FileName;
  Bmp.Free;
end;

procedure TSettingsWnd.CustomIcon1Click(Sender: TObject);
begin
  if OpenIconDialog.Execute then
     LoadCustomIcon(OpenIconDialog.FileName)
end;

procedure TSettingsWnd.ShellIcon1Click(Sender: TObject);
var
  s : String;
  wicon : HIcon;
  ImageListHandle: THandle;
  dicon : TIcon;
  FileInfo : SHFILEINFO;
  tempBmp : TBitmap;
begin
  s := edit_target.Text;
  cb_32.Checked := True;
  edit_icon.Text := 'shell.icon';

  tempBmp := TBitmap.Create;
  with tempBmp do
  begin
    Width  := 32;
    Height := 32;
    Canvas.Brush.Color := Icon.Color;
    Canvas.FillRect(Canvas.ClipRect);
  end;

  if (FileExists(s)) and (ExtractFileExt(s)='.exe') then
  begin
    dicon := TIcon.Create;
    wicon := ExtractIcon(hInstance,PChar(s), 0);
    dicon.Handle := wicon;
    tempBmp.Canvas.Draw(0,0,dicon);
    Icon.Tag:=-2;
    if wicon<>0 then
    begin
      dicon.ReleaseHandle;
      DestroyIcon(wicon);
    end;
    dIcon.Free;
  end else
  begin
    ImageListHandle := SHGetFileInfo( pChar(s), 0, FileInfo, sizeof( SHFILEINFO ),
                                      SHGFI_ICON or SHGFI_SHELLICONSIZE);
    dicon := TIcon.Create;
    dicon.Handle := FileInfo.hIcon;
    if dicon.Handle <> 0 then
    begin
      tempBmp.Canvas.Draw(0,0,dicon);
      Icon.Tag := -2;
      dIcon.ReleaseHandle;
    end else
    begin
      IconList.Draw(tempBmp.Canvas,0,0,0);
      Icon.Tag := 0;
    end;
    FreeAndNil(dIcon);
    DestroyIcon(FileInfo.hIcon);
    ImageList_Destroy(ImageListHandle);
  end;

  Icon.Bitmap.SetSize(32,32);
  Icon.Bitmap.Clear(color32(Icon.Color));
  Icon.Bitmap.Draw(rect(0,0,32,32),rect(0,0,32,32),tempBmp.Canvas.Handle);
  tempBmp.Free;
end;

procedure TSettingsWnd.btn_selecticonClick(Sender: TObject);
var
  p : TPoint;
begin
  p := self.ClientToScreen(point(btn_selecticon.left,btn_selecticon.Top));
  btn_selecticon.PopupMenu.Popup(p.x-8,p.y+48);
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

procedure TSettingsWnd.scb_bgblendingColorClick(Sender: TObject;
  Color: TColor; ColType: TClickedColorID);
begin
  PaintPanels;
end;

procedure TSettingsWnd.shellAdministrativeTools1Click(Sender: TObject);
begin
  edit_target.Text := TMenuItem(Sender).Caption;
end;

procedure TSettingsWnd.cb_captionClick(Sender: TObject);
var
  b : boolean;
begin
  if cb_themesettingsA.Checked then b := False
     else b := cb_caption.Checked;
  dp_calign.Enabled    := b;
  lb_calign.Enabled    := b;
  //groupBox8.Enabled    := b;
  if (DeskSettings<> nil) and (cb_themesettingsA.Checked) then
  begin
    cb_shadow.Enabled    := False;
    cb_cfont.Enabled     := False;  
    if DeskSettings.Theme.DeskDisplayCaption then
    begin
   //   groupbox12.Enabled   := True;
      cb_mline.Enabled     := True;
      edit_caption.Enabled := True;
      btn_mline.Enabled    := True;
      dp_calign.Enabled    := True;
      lb_calign.Enabled    := True;
    end else
    begin
    //  groupbox12.Enabled   := False;
      cb_mline.Enabled     := False;
      edit_caption.Enabled := False;
      btn_mline.Enabled    := False;
      dp_calign.Enabled    := False;
      lb_calign.Enabled    := False;
    end;
  end else
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
    mlinewnd.Free;
    mlinewnd := nil;
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
  if cb_themesettingsA.Checked then cb_shadow.enabled := false
     else cb_shadow.Enabled := not cb_cfont.Checked;
end;

end.
