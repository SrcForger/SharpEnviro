{
Source Name: Settings Wnd
Description: drive object settings window
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

unit DriveObjectSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, CommCtrl, Controls, Forms,
  Dialogs, StdCtrls, SharpApi, SharpFX, ComCtrls,
  pngimage, ExtCtrls, GR32, GR32_PNG, GR32_Image, ImgList,GR32_Layers,
  Menus, FileCtrl, JvSimpleXML,
  Tabs, SharpDeskApi, ShellApi,
  SharpGraphicsUtils,
  uSharpDeskTDeskSettings,
  uSharpDeskDebugging,
  uSharpDeskDesktopPanelList,
  uSharpDeskDesktopPanel,
  uSharpDeskFunctions,
  uDriveObjectLayer,
  DriveObjectXMLSettings,
  Buttons,
  SharpEColorPicker,
  SharpEFontSelector,
  mlinewnd,
  GR32_Resamplers;

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
    Label1: TLabel;
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
    GroupBox5: TGroupBox;
    lb_bgcolor: TLabel;
    lb_bgbordercolor: TLabel;
    ts_bgnone: TTabSheet;
    Label7: TLabel;
    GroupBox6: TGroupBox;
    Label4: TLabel;
    GroupBox9: TGroupBox;
    cb_32: TRadioButton;
    cb_48: TRadioButton;
    cb_64: TRadioButton;
    cb_csize: TRadioButton;
    edit_csize: TEdit;
    GroupBox7: TGroupBox;
    cb_blend: TCheckBox;
    tb_blend: TTrackBar;
    cb_AlphaBlend: TCheckBox;
    tb_alpha: TTrackBar;
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
    DriveBox: TComboBox;
    cb_Meter: TCheckBox;
    tab_meter: TTabSheet;
    GroupBox8: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    rg_meteralign: TRadioGroup;
    GroupBox12: TGroupBox;
    Label9: TLabel;
    tb_leftoffset: TTrackBar;
    Label10: TLabel;
    tb_topoffset: TTrackBar;
    Label11: TLabel;
    tb_rightoffset: TTrackBar;
    Label12: TLabel;
    tb_bottomoffset: TTrackBar;
    meterpreview: TImage32;
    scb_bgstart: TSharpEColorPicker;
    scb_fgstart: TSharpEColorPicker;
    scb_border: TSharpEColorPicker;
    cp_bgborder: TSharpEColorPicker;
    cp_bgcolor: TSharpEColorPicker;
    cp_cblend: TSharpEColorPicker;
    cb_diskdata: TCheckBox;
    GroupBox13: TGroupBox;
    cb_iconspacing: TCheckBox;
    tb_iconspacing: TTrackBar;
    tb_iconoffset: TTrackBar;
    cb_iconoffset: TCheckBox;
    Label13: TLabel;
    scb_bgend: TSharpEColorPicker;
    scb_fgend: TSharpEColorPicker;
    Label14: TLabel;
    tab_driveltter: TTabSheet;
    GroupBox14: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    scb_lgstart: TSharpEColorPicker;
    scb_lgend: TSharpEColorPicker;
    GroupBox15: TGroupBox;
    cb_driveletter: TCheckBox;
    GroupBox16: TGroupBox;
    cb_dltrans: TCheckBox;
    tb_dltrans: TTrackBar;
    Label17: TLabel;
    btn_font: TBitBtn;
    Label18: TLabel;
    FontDialog1: TFontDialog;
    prev1: TImage32;
    Label19: TLabel;
    scb_lgborder: TSharpEColorPicker;
    Label20: TLabel;
    Shape1: TShape;
    scb_bgblending: TSharpEColorPicker;
    cb_bgblending: TCheckBox;
    Label21: TLabel;
    TabSheet3: TTabSheet;
    Panel4: TPanel;
    cb_themesettingsC: TCheckBox;
    GroupBox17: TGroupBox;
    cb_caption: TCheckBox;
    GroupBox18: TGroupBox;
    lb_calign: TLabel;
    cb_shadow: TCheckBox;
    cb_cfont: TCheckBox;
    customfont: TSharpEFontSelector;
    dp_calign: TComboBox;
    GroupBox19: TGroupBox;
    btn_mline: TSpeedButton;
    cb_mline: TCheckBox;
    edit_caption: TEdit;
    lb_meterleft: TLabel;
    lb_metertop: TLabel;
    lb_meterright: TLabel;
    lb_meterbottom: TLabel;

    procedure FormShow(Sender: TObject);
    procedure cb_blendClick(Sender: TObject);
    procedure tb_blendChange(Sender: TObject);
    procedure tb_alphaChange(Sender: TObject);
    procedure cb_AlphaBlendClick(Sender: TObject);
    procedure cp_cblendClick(Sender: TObject);
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
    procedure edit_csizeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SharpEIcon1Click(Sender: TObject);
    procedure CustomIcon1Click(Sender: TObject);
    procedure ShellIcon1Click(Sender: TObject);
    procedure btn_selecticonClick(Sender: TObject);
    procedure tb_leftoffsetChange(Sender: TObject);
    procedure tb_topoffsetChange(Sender: TObject);
    procedure tb_rightoffsetChange(Sender: TObject);
    procedure tb_bottomoffsetChange(Sender: TObject);
    procedure rg_meteralignClick(Sender: TObject);
    procedure cb_MeterClick(Sender: TObject);
    procedure tab_meterShow(Sender: TObject);
    procedure cb_iconoffsetClick(Sender: TObject);
    procedure cb_iconspacingClick(Sender: TObject);
    procedure tb_iconoffsetChange(Sender: TObject);
    procedure tb_iconspacingChange(Sender: TObject);
    procedure cb_dltransClick(Sender: TObject);
    procedure tb_dltransChange(Sender: TObject);
    procedure tab_driveltterShow(Sender: TObject);
    procedure scb_lgstartColorClick(Sender: TObject; Color: TColor);
    procedure scb_lgendColorClick(Sender: TObject; Color: TColor);
    procedure scb_lgborderColorClick(Sender: TObject; Color: TColor);
    procedure cb_driveletterClick(Sender: TObject);
    procedure btn_fontClick(Sender: TObject);
    procedure scb_bgstartColorClick(Sender: TObject; Color: TColor);
    procedure scb_bgendColorClick(Sender: TObject; Color: TColor);
    procedure scb_fgstartColorClick(Sender: TObject; Color: TColor);
    procedure scb_fgendColorClick(Sender: TObject; Color: TColor);
    procedure scb_borderColorClick(Sender: TObject; Color: TColor);
    procedure cb_bgblendingClick(Sender: TObject);
    procedure scb_bgblendingColorClick(Sender: TObject; Color: TColor);
    procedure btn_mlineClick(Sender: TObject);
    procedure cb_cfontClick(Sender: TObject);
    procedure cb_mlineClick(Sender: TObject);
    procedure cb_captionClick(Sender: TObject);
  private
    procedure MenuOnClick(Sender : TObject);
  public
    OSettings : TXMLSettings;
    ObjectID : integer;
    MouseIsDown_AlphaBlend : Boolean;
    StartX : Integer;
    cs : TColorScheme;
    ThemeIconList : TStringList;
    PanelList : TDesktopPanelList;
    TempDriveObjectLayer : TDriveLayer;
    procedure SaveSettings(SaveToFile : boolean);
    procedure LoadSettings;
    procedure PaintPanels;
    procedure RenderMeter;
    procedure RenderDriveLetter;
    procedure LoadCustomIcon(FileName : String);
    procedure SyncBars(pChecked : boolean; pPosition : integer);
    procedure BuildDriveList;
  end;



     
implementation

{$R *.dfm}

function DriveExists(DriveByte: Byte): Boolean;
begin
  Result := GetLogicalDrives and (1 shl DriveByte) <> 0;
end;

function DriveType(DriveByte: Byte): String;
begin
  case GetDriveType(PChar(Chr(DriveByte + Ord('A')) + ':\')) of 
    DRIVE_UNKNOWN: Result := 'Unknown';
    DRIVE_NO_ROOT_DIR: Result := 'NO ROOT DIR';
    DRIVE_REMOVABLE: Result := 'Removeable Drive';
    DRIVE_FIXED: Result := 'Hard Drive';
    DRIVE_REMOTE: Result := 'Network Drive';
    DRIVE_CDROM: Result := 'CD-ROM/DVD'; 
    DRIVE_RAMDISK: Result := 'RAM Disk'; 
  else 
    Result := 'anderer Laufwerkstyp';
  end;
end;

procedure VGradient(Bmp : TBitmap32; color1,color2 : TColor; Rect : TRect);
var
   nR,nG,nB : real;
   sR,sG,sB : integer;
   eR,eG,eB : integer;
   y : integer;
begin
     sR := GetRValue(color1);
     sG := GetGValue(color1);
     sB := GetBValue(color1);
     eR := GetRValue(color2);
     eG := GetGValue(color2);
     eB := GetBValue(color2);
     nR:=(eR-sR)/(Rect.Bottom-Rect.Top);
     nG:=(eG-sG)/(Rect.Bottom-Rect.Top);
     nB:=(eB-sB)/(Rect.Bottom-Rect.Top);
     for y:=0 to Rect.Bottom-Rect.Top do
         Bmp.HorzLineS(Rect.Left,y+Rect.Top,Rect.Right,
                       color32(sr+round(nr*y),sg+round(ng*y),sb+round(nb*y),255));
end;


// ######################################


procedure HGradient(Bmp : TBitmap32; color1,color2 : TColor; Rect : TRect);
var
   nR,nG,nB : real;
   sR,sG,sB : integer;
   eR,eG,eB : integer;
   x : integer;
begin
     sR := GetRValue(color1);
     sG := GetGValue(color1);
     sB := GetBValue(color1);
     eR := GetRValue(color2);
     eG := GetGValue(color2);
     eB := GetBValue(color2);
     nR:=(eR-sR)/(Rect.Right-Rect.Left);
     nG:=(eG-sG)/(Rect.Right-Rect.Left);
     nB:=(eB-sB)/(Rect.Right-Rect.Left);
     for x:=0 to Rect.Right-Rect.Left do
         Bmp.VertLineS(x+Rect.Left,Rect.Top,Rect.Bottom,
                       color32(sr+round(nr*x),sg+round(ng*x),sb+round(nb*x),255));
end;

procedure TSettingsWnd.RenderDriveLetter;
var
 w,h : integer;
 LetterBitmap : TBitmap32;
begin
  prev1.Bitmap.SetSize(prev1.Width,prev1.Height);
  prev1.Bitmap.Clear(color32(prev1.color));

  LetterBitmap := TBitmap32.Create;
  LetterBitmap.DrawMode := dmBlend;
  with LetterBitmap do
  begin
    if cb_dltrans.Checked then MasterAlpha := tb_dltrans.Position
       else MasterAlpha := 255;
    Font := btn_font.Font;
    SetSize(TextHeight(DriveBox.Text[2])+1,
            TextHeight(DriveBox.Text[2])+1);
    Clear(color32(scb_lgborder.Color));            
    VGradient(LetterBitmap,scb_lgstart.Color,scb_lgend.Color,
              Rect(1,1,Width-2,Height-2));
    RenderText(Width div 2 - TextWidth(DriveBox.Text[2]) div 2,
               Height div 2 - TextHeight(DriveBox.Text[2]) div 2 ,
               DriveBox.Text[2],0,color32(Font.Color));
    DrawTo(prev1.Bitmap,prev1.Bitmap.width div 2 - Width div 2, prev1.Bitmap.Height div 2 - Height div 2);
  end;
  LetterBitmap.Free;
end;

procedure TSettingsWnd.RenderMeter;
var
 x,y : integer;
 w,h : integer;
 L : TFloatRect;
begin
  if TempDriveObjectLayer = nil then exit;
  SaveSettings(False);
  TempDriveObjectLayer.LoadSettings;
  L := TBitmapLayer(meterpreview.Layers.Items[0]).Location;
  w := round(L.Right-L.Left);
  h := round(L.Bottom-L.Top);
 { case rg_meteralign.ItemIndex of
    0 : begin
          x := meterpreview.Width div 2 - w div 2;
          y := meterpreview.Height - h div 2;
        end;
    1 : begin
          x := meterpreview.Width - w div 2;
          y := meterpreview.Height div 2 - h div 2;
        end;
    2 : begin
          x := meterpreview.Width div 2 - w div 2;
          y := 0  - h div 2;
        end;
    3 : begin
          x := 0 - w div 2;
          y := meterpreview.Height div 2 - h div 2;
        end;
  end;    }
  x := 2;
  y := 2;
  L.Left := x;
  L.Top := y;
  L.Right := x + w;
  L.Bottom := y + h;
  TBitmapLayer(meterpreview.Layers.Items[0]).Location := L;  
end;

procedure TSettingsWnd.BuildDriveList;
var
  i : integer;
begin
  DriveBox.Clear;
  for i := 0 to 25 do if DriveExists(i) then
      DriveBox.Items.Add('['+Chr(i + Ord('A')) + ':] - ' + DriveType(i));
end;


procedure TSettingsWnd.PaintPanels;
var
  n : integer;
  DP : TDesktopPanel;
  Bmp : TBitmap32;
begin
  bgList.Bitmap.SetSize((PanelList.Width + 12)* PanelList.Count,PanelList.Heigh+12);
  bgList.Bitmap.Clear(color32(bgList.Color));
  for n := 0 to PanelList.Count - 1 do
  begin
    DP := TDesktopPanel(PanelList.Items[n]);
    DP.Paint;
    if cb_bgblending.Checked then
       BlendImageA(DP.Bitmap,scb_bgblending.color, 255);    
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
   w,h : integer;
   x,y : integer;
   wIcon : TIcon;
   TempIcon : HIcon;
   s,s2 : String;
   MenuItem : TMenuItem;
   p : PChar;
   Settings : TXMLSettings;
   L : TFloatRect;
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
    n := ThemeIconList.IndexOfName('icon.drive.hd');
    if (n <> -1) and (n <= IconPopup.Items.Count-1) then
       IconPopup.Items.Items[n].OnClick(IconPopup.Items.Items[n])
       else IconPopup.Items.Items[0].OnClick(IconPopup.Items.Items[0]);
    cb_48.Checked:=True;
    rb_bg1.Checked := True;
    rb_bg1.OnClick(rb_bg1);
    if DriveBox.Items.Count>1 then
       DriveBox.ItemIndex := 1
       else DriveBox.ItemIndex := 0;
    TempObjectSettings := TObjectSettings.Create;
    TempObjectSettings.XML.Root.Items.ItemNamed['ObjectSettings'].Items.Add(inttostr(1),'0');
    SaveSettings(False);
    TempDriveObjectLayer:= TDriveLayer.create(meterpreview, 1, DeskSettings,ThemeSettings,TempObjectSettings);
    TempDriveObjectLayer.Tag:=1;
    L := TBitmapLayer(meterpreview.Layers.Items[0]).Location;
    L.Left := L.Left + 8;
    L.Top := L.Top + 8;
    L.Right := L.Right + 8;
    L.Bottom := L.Bottom + 8;
    TBitmapLayer(meterpreview.Layers.Items[0]).Location := L;
    cb_themesettingsA.OnClick(self);
    exit;
  end;

  Settings := TXMLSettings.Create(ObjectID,nil);
  Settings.LoadSettings;

  cb_bgblending.Checked := Settings.BGTHBlend;
  scb_bgblending.Color  := Settings.BGTHBlendColor;  

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
  cb_caption.Checked := Settings.ShowCaption;

  if length(Settings.Target)>1 then Settings.Target := Settings.Target[1];  

  DriveBox.Clear;
  for I := 0 to 25 do if DriveExists(i) then
  begin
     DriveBox.Items.Add('['+Chr(I + Ord('A')) + ':] - ' + DriveType(i));
     if Chr(I + Ord('A')) = Settings.Target then DriveBox.ItemIndex := DriveBox.Items.Count-1;
  end;
  if DriveBox.ItemIndex = -1 then DriveBox.ItemIndex := 0;

  cb_iconshadow.Checked     := Settings.UseIconShadow;
  cb_AlphaBlend.Checked     := Settings.AlphaBlend;
  tb_Alpha.Position         := Settings.AlphaValue;
  cb_themesettingsA.Checked := Settings.UseThemeSettings;

  rg_meteralign.ItemIndex   := Settings.MeterAlign;
  scb_bgstart.Color         := Settings.MBGStart;
  scb_bgend.Color           := Settings.MBGEnd;
  scb_fgstart.Color         := Settings.MFGStart;
  scb_fgend.Color           := Settings.MFGEnd;
  scb_border.Color          := Settings.MBorder;
  cb_meter.Checked          := Settings.DisplayMeter;
  cb_DiskData.Checked       := Settings.DiskData;  

  cp_bgcolor.Color         := Settings.BGColor;
  cp_bgborder.Color        := Settings.BGBorderColor;
  SyncBars(Settings.BGTrans,Settings.BGTransValue);
  cb_bgthickness.Checked   := Settings.BGThickness;
  tb_bgthickness.Position  := Settings.BGThicknessValue;
  cb_bgthickness.OnClick(cb_bgthickness);

  cb_driveletter.Checked   := Settings.DriveLetter;
  scb_lgstart.Color        := Settings.LGStart;
  scb_lgend.Color          := Settings.LGEnd;  

  cb_iconoffset.Checked    := Settings.IconOffset;
  tb_iconoffset.Position   := Settings.IconOffsetValue;
  cb_iconspacing.Checked   := Settings.IconSpacing;
  tb_iconspacing.Position  := Settings.IconSpacingValue;
  cb_iconoffset.OnClick(cb_iconoffset);
  cb_iconspacing.OnClick(cb_iconspacing);  

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
  tb_leftoffset.Position   := Settings.MLeftOffset;
  tb_Topoffset.Position    := Settings.MTopOffset;
  tb_Rightoffset.Position  := Settings.MRightOffset;
  tb_Bottomoffset.Position := Settings.MBottomOffset;

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

  tb_dltrans.Position      := Settings.DLAlphaValue;
  cb_dltrans.Checked       := Settings.DLAlpha;
  scb_lgborder.Color       := Settings.LGBorder;
  btn_font.Font.Name       := Settings.DLFontName;
  btn_font.Font.Color      := Settings.DLFontColor;
  btn_font.Font.Size       := Settings.DLFontSize;
  btn_font.Font.Style      := [];
  if Settings.DLFontBold then
     btn_font.Font.Style := btn_font.Font.Style + [fsBold];
  if Settings.DLFontItalic then
     btn_font.Font.Style := btn_font.Font.Style + [fsItalic];
  if Settings.DLFontUnderline then
     btn_font.Font.Style := btn_font.Font.Style + [fsUnderline];          

  cb_themesettingsA.OnClick(cb_themesettingsA);
  cb_driveletter.OnClick(cb_driveletter);  
  
  DebugFree(Settings);
  
  TempObjectSettings := TObjectSettings.Create;
  TempObjectSettings.XML.Root.Items.ItemNamed['ObjectSettings'].Items.Add(inttostr(1),'0');
  SaveSettings(False);
  TempDriveObjectLayer:= TDriveLayer.create(meterpreview, 1, DeskSettings,ThemeSettings,TempObjectSettings);
  TempDriveObjectLayer.Tag:=1;
end;



procedure TSettingsWnd.SaveSettings(SaveToFile : boolean);
var
   n,i : integer;
   IconFile : string;
   Settings : TXMLSettings;
   tempOID : integer;
begin
 { if pObjectSettings=TempObjectSettings then
  begin
    tempOID := ObjectID;
    ObjectID := 1;
  end else if ObjectID=0 then exit;  }
  cs := LoadColorScheme;

  if SaveToFile then
  begin
    Settings := TXMLSettings.Create(ObjectId, nil);
  end else Settings := OSettings;

  if cb_64.Checked then Settings.Size := '64'
     else if cb_48.Checked then Settings.Size := '48'
       else if cb_32.Checked then Settings.Size := '32'
             else if cb_csize.Checked then Settings.Size := edit_csize.Text
                  else Settings.Size:='48';

  Settings.BGTHBlend        := cb_bgblending.Checked;
  Settings.BGTHBLendColor   := scb_bgblending.Color;                  
  Settings.UseThemeSettings := cb_themesettingsA.checked;
  Settings.Target           := DriveBox.Text[2];
  Settings.Caption          := edit_caption.Text;
  Settings.ShowCaption      := cb_caption.Checked;

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
  Settings.DisplayMeter     := cb_meter.Checked;
  Settings.MeterAlign       := rg_meteralign.ItemIndex;

  Settings.MBGStart         := scb_bgstart.Color;
  Settings.MBGEnd           := scb_bgend.Color;
  Settings.MFGStart         := scb_fgstart.Color;
  Settings.MFGEnd           := scb_fgend.Color;
  Settings.MBorder          := scb_border.Color;
  Settings.MLeftOffset      := tb_leftoffset.Position;
  Settings.MTopOffset       := tb_Topoffset.Position;
  Settings.MRightOffset     := tb_Rightoffset.Position;
  Settings.MBottomOffset    := tb_Bottomoffset.Position;
  Settings.DiskData         := cb_DiskData.Checked;
  Settings.DriveLetter      := cb_driveletter.Checked;
  Settings.LGStart          := scb_lgstart.Color;
  Settings.LGEnd            := scb_lgend.Color;

  Settings.DLAlphaValue     := tb_dltrans.Position;
  Settings.DLAlpha          := cb_dltrans.Checked;
  Settings.LGBorder         := scb_lgborder.Color;
  Settings.DLFontName       := btn_font.Font.Name;
  Settings.DLFontColor      := btn_font.Font.Color;
  Settings.DLFontSize       := btn_font.Font.Size;
  if fsBold in btn_font.Font.Style then Settings.DLFontBold := True
     else Settings.DLFontBold := False;
  if fsItalic in btn_font.Font.Style then Settings.DLFontItalic := True
     else Settings.DLFontItalic := False;
  if fsUnderline in btn_font.Font.Style then Settings.DLFontUnderline := True
     else Settings.DLFontUnderline := False;          


   Settings.Shadow          := cb_shadow.Checked;     

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
  if SaveToFile then DebugFree(Settings);
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

procedure TSettingsWnd.cp_cblendClick(Sender: TObject);
begin
  RenderMeter;
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
  OSettings.Free;
  IconList.Clear;
  IconPopup.Items.Clear;
  ThemeIconList.Free;
  PanelList.Clear;
  PanelList.Free;
  PanelList := nil;
  TempDriveObjectLayer.Free;
  TempObjectSettings.Free;
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
  BuildDriveList;
  OSettings := TXMLSettings.Create(1,nil);
  PanelList := TDesktopPanelList.create(52,52);
  PanelList.LoadFromDirectory(GetSharpeDirectory + 'Images\Panels\');
  cb_themesettingsA.OnClick(cb_themesettingsA);
  meterpreview.Bitmap.SetSize(meterpreview.Width,meterpreview.Height);
  meterpreview.Bitmap.Clear(color32(0,0,0,255));
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
     cb_bgthickness.Caption := 'Border Thickness: ' + inttostr(tb_bgthickness.Position)
     else cb_bgthickness.Caption := 'Border Thickness: disabled';
end;

procedure TSettingsWnd.tb_bgthicknessChange(Sender: TObject);
begin
  cb_bgthickness.Caption := 'Thickness: ' + inttostr(tb_bgthickness.Position)
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
//  s := edit_target.Text;
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

procedure TSettingsWnd.tb_leftoffsetChange(Sender: TObject);
begin
  RenderMeter;
  lb_meterleft.Caption := inttostr(tb_leftoffset.Position);
end;

procedure TSettingsWnd.tb_topoffsetChange(Sender: TObject);
begin
  RenderMeter;
  lb_metertop.Caption := inttostr(tb_topoffset.Position);
end;

procedure TSettingsWnd.tb_rightoffsetChange(Sender: TObject);
begin
  RenderMeter;
  lb_meterright.Caption := inttostr(tb_rightoffset.Position);
end;

procedure TSettingsWnd.tb_bottomoffsetChange(Sender: TObject);
begin
  RenderMeter;
  lb_meterbottom.Caption := inttostr(tb_bottomoffset.Position);
end;

procedure TSettingsWnd.rg_meteralignClick(Sender: TObject);
begin
  RenderMeter;
end;

procedure TSettingsWnd.cb_MeterClick(Sender: TObject);
begin
  RenderMeter;
  cb_caption.OnClick(cb_caption);
end;

procedure TSettingsWnd.tab_meterShow(Sender: TObject);
begin
  RenderMeter;
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

procedure TSettingsWnd.tb_iconoffsetChange(Sender: TObject);
begin
  cb_iconoffset.OnClick(cb_iconoffset);
end;

procedure TSettingsWnd.tb_iconspacingChange(Sender: TObject);
begin
  cb_iconspacing.OnClick(cb_iconspacing);
end;

procedure TSettingsWnd.cb_dltransClick(Sender: TObject);
begin
  if tb_dltrans.Max = 0 then exit;
  tb_dltrans.Enabled := cb_dltrans.Checked;
  if cb_dltrans.Checked then
     cb_dltrans.Caption := 'Visbility: ' + inttostr(round((tb_dltrans.Position*100) / tb_dltrans.Max))+'%'
     else cb_dltrans.Caption := 'Visbility: disabled';
  RenderDriveLetter;     
end;

procedure TSettingsWnd.tb_dltransChange(Sender: TObject);
begin
  cb_dltrans.OnClick(cb_dltrans);
end;

procedure TSettingsWnd.tab_driveltterShow(Sender: TObject);
begin
  RenderDriveLetter;
end;

procedure TSettingsWnd.scb_lgstartColorClick(Sender: TObject;
  Color: TColor; ColType: TClickedColorID);
begin
  RenderDriveLetter;
end;

procedure TSettingsWnd.scb_lgendColorClick(Sender: TObject; Color: TColor;
  ColType: TClickedColorID);
begin
  RenderDriveLetter;
end;

procedure TSettingsWnd.scb_lgborderColorClick(Sender: TObject;
  Color: TColor; ColType: TClickedColorID);
begin
  RenderDriveLetter;
end;

procedure TSettingsWnd.cb_driveletterClick(Sender: TObject);
begin
  RenderDriveLetter;
  GroupBox16.Visible := cb_driveletter.Checked;
  GroupBox14.Visible := cb_driveletter.Checked;  
end;

procedure TSettingsWnd.btn_fontClick(Sender: TObject);
begin
  FontDialog1.Font. Name := btn_font.Font.Name;
  FontDialog1.Font.Style := btn_font.Font.Style;
  FontDialog1.Font.Color := btn_font.Font.Color;
  FontDialog1.Font.Size  := btn_font.Font.Size;

  if FontDialog1.Execute then
  begin
    btn_font.Font.Name  := FontDialog1.Font.Name;
    btn_font.Font.Style := FontDialog1.Font.Style;
    btn_font.Font.Color := FontDialog1.Font.Color;
    btn_font.Font.Size  := FontDialog1.Font.Size;
  end;
  RenderDriveLetter;
end;

procedure TSettingsWnd.scb_bgstartColorClick(Sender: TObject;
  Color: TColor; ColType: TClickedColorID);
begin
  RenderMeter;
end;

procedure TSettingsWnd.scb_bgendColorClick(Sender: TObject; Color: TColor;
  ColType: TClickedColorID);
begin
  RenderMeter;
end;

procedure TSettingsWnd.scb_fgstartColorClick(Sender: TObject;
  Color: TColor; ColType: TClickedColorID);
begin
  RenderMeter;
end;

procedure TSettingsWnd.scb_fgendColorClick(Sender: TObject; Color: TColor;
  ColType: TClickedColorID);
begin
  RenderMeter;
end;

procedure TSettingsWnd.scb_borderColorClick(Sender: TObject; Color: TColor;
  ColType: TClickedColorID);
begin
  RenderMeter;
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

procedure TSettingsWnd.cb_cfontClick(Sender: TObject);
begin
  if not cb_cfont.Enabled then customfont.Enabled := False
     else customfont.Enabled := cb_cfont.Checked;
   if cb_themesettingsA.Checked then cb_shadow.enabled := false
     else cb_shadow.Enabled := not cb_cfont.Checked;
end;

procedure TSettingsWnd.cb_mlineClick(Sender: TObject);
begin
  edit_caption.Enabled := not cb_mline.Checked;
  btn_mline.Enabled := cb_mline.Checked;
end;

procedure TSettingsWnd.cb_captionClick(Sender: TObject);
var
  b : boolean;
begin
  if cb_themesettingsA.Checked then b := False
     else b := cb_caption.Checked;
 // groupBox19.Enabled    := b;
  if (DeskSettings<> nil) and (cb_themesettingsA.Checked) then
  begin
    cb_shadow.Enabled    := False;
    cb_cfont.Enabled     := False;
    if DeskSettings.Theme.DeskDisplayCaption then
    begin
    //  groupbox18.Enabled   := True;
      cb_mline.Enabled     := True;
      edit_caption.Enabled := True;
      btn_mline.Enabled    := True;
      dp_calign.Enabled    := True;
      lb_calign.Enabled    := True;
    end else
    begin
      //groupbox12.Enabled   := False;
      cb_mline.Enabled     := False;
      edit_caption.Enabled := False;
      btn_mline.Enabled    := False;
      dp_calign.Enabled    := False;
      lb_calign.Enabled    := False;
    end;
  end else
  begin
   // groupbox18.Enabled   := b;
    cb_shadow.Enabled    := b;
    cb_cfont.Enabled     := b;
    cb_mline.Enabled     := b;
    edit_caption.Enabled := b;
    btn_mline.Enabled    := b;
    if cb_diskdata.Checked then b := True;
    dp_calign.Enabled    := b;
    lb_calign.Enabled    := b;    
  end;
  cb_cfont.OnClick(cb_cfont);
  //lb_calign.Enabled    := b;
  //dp_calign.Enabled    := b;
end;

end.
