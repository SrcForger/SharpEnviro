{
Source Name: Settings Wnd
Description: Text object settings window
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

unit TextObjectSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, CommCtrl, Controls, Forms,
  Dialogs, StdCtrls, SharpApi, SharpFX, ComCtrls,
  pngimage, ExtCtrls, GR32, GR32_PNG, GR32_Image, ImgList,
  Menus, FileCtrl, JvSimpleXML,
  Tabs, SharpDeskApi, ShellApi,
  uSharpDeskTThemeSettings,
  uSharpDeskTObjectSettings,
  uSharpDeskTDeskSettings,
  uSharpDeskDebugging,
  uSharpDeskDesktopPanelList,
  uSharpDeskDesktopPanel,
  uSharpDeskFunctions,
  TextObjectXMLSettings, Buttons, uSharpeColorBox;

type
  TSettingsWnd = class(TForm)
    OpenIconDialog: TOpenDialog;
    PageControl1: TPageControl;
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
    cb_shadow: TCheckBox;
    Panel3: TPanel;
    cb_themesettingsA: TCheckBox;
    Panel2: TPanel;
    cb_themesettingsB: TCheckBox;
    PopupMenu1: TPopupMenu;
    CustomIcon1: TMenuItem;
    ShellIcon1: TMenuItem;
    SharpEIcon1: TMenuItem;
    GroupBox5: TGroupBox;
    lb_bgcolor: TLabel;
    lb_bgbordercolor: TLabel;
    cp_bgborder: TSharpEColorBox;
    cp_bgcolor: TSharpEColorBox;
    cp_cblend: TSharpEColorBox;
    GroupBox8: TGroupBox;
    text: TMemo;
    Label1: TLabel;
    cb_bgblending: TCheckBox;
    scb_bgblending: TSharpEColorBox;
    Label5: TLabel;

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
    procedure cb_bgblendingClick(Sender: TObject);
    procedure scb_bgblendingColorClick(Sender: TObject; Color: TColor;
      ColType: TClickedColorID);
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


  cs := LoadColorScheme;
  cp_cblend.Color := cs.Throbberback;
  if ObjectID=0 then
  begin
    rb_bg1.Checked := True;
    rb_bg1.OnClick(rb_bg1);
    exit;
  end;

  Settings := TXMLSettings.Create(ObjectID,nil);
  Settings.LoadSettings;

  cb_bgblending.Checked := Settings.BGTHBlend;
  scb_bgblending.Color  := Settings.BGTHBlendColor;

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

  Text.Lines.CommaText           := Settings.Text;

  cb_AlphaBlend.Checked     := Settings.AlphaBlend;
  tb_Alpha.Position         := Settings.AlphaValue;
  cb_themesettingsA.Checked := Settings.UseThemeSettings;

  cp_bgcolor.Color         := Settings.BGColor;
  cp_bgborder.Color        := Settings.BGBorderColor;
  SyncBars(Settings.BGTrans,Settings.BGTransValue);
  cb_bgthickness.Checked   := Settings.BGThickness;
  tb_bgthickness.Position  := Settings.BGThicknessValue;
  cb_bgthickness.OnClick(cb_bgthickness);

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

  Settings.BGTHBlend        := cb_bgblending.Checked;
  Settings.BGTHBLendColor   := scb_bgblending.Color;          
  Settings.UseThemeSettings := cb_themesettingsA.checked;
  Settings.AlphaBlend       := cb_AlphaBlend.Checked;
  Settings.AlphaValue       := tb_alpha.position;
  Settings.BlendColor       := cp_cblend.Color;
  Settings.ColorBlend       := cb_blend.checked;
  Settings.BlendValue       := tb_blend.position;
  Settings.BGColor          := cp_bgcolor.Color;
  Settings.BGBorderColor    := cp_bgborder.Color;
  Settings.BGThicknessValue := tb_bgthickness.Position;
  Settings.BGThickness      := cb_bgthickness.Checked;
  Settings.BGTransValue     := tb_bgtransA.Position;
  Settings.BGTrans          := cb_bgtransA.Checked;
  Settings.Text             := Text.Lines.CommaText;
  Settings.Shadow           := cb_shadow.Checked;

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

procedure TSettingsWnd.cb_themesettingsAClick(Sender: TObject);
var
   b : boolean;
begin
  b := not TCheckBox(Sender).Checked;
  cb_themesettingsA.Checked := not b;
  cb_themesettingsB.Checked := not b;
  cb_shadow.Enabled := b;  
  cb_blend.Enabled := b;
  tb_blend.Enabled := b;
  cb_AlphaBlend.Enabled := b;
  tb_alpha.Enabled := b;
  cb_alphablend.OnClick(self);
  cb_blend.OnClick(self);
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
          Caption := 'Transparency: disabled'
           else Caption := 'Transparency: ' + inttostr(round((pPosition*100) / tb_bgtransA.Max))+'%'
  end;
  with cb_bgtransB do
  begin
    Checked := pChecked;
    if tb_bgtransA.Max >0 then
       if not pChecked then
          Caption := 'Transparency: disabled'
          else Caption := 'Transparency: ' + inttostr(round((pPosition*100) / tb_bgtransA.Max))+'%'
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

procedure TSettingsWnd.LoadCustomIcon(FileName : String);
begin
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

end.
