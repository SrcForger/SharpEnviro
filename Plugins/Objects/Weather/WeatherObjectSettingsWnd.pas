{
Source Name: SettingsWndUnit
Description: Settings window ot the weather object.
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

unit WeatherObjectSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SharpApi, SharpFX, ComCtrls,
  pngimage, ExtCtrls, GR32, GR32_Image, JvSimpleXML, Tabs,
  Menus, Buttons, ToolWin, StdActns, ImgList,
  uSharpDeskTDeskSettings,
  uSharpDeskTThemeSettings,
  uSharpDeskTObjectSettings,
  WeatherObjectXMLSettings, uSharpeColorBox, uSharpEFontSelector;

type
  TSettingsWnd = class(TForm)
    OpenIconDialog: TOpenDialog;
    Panel1: TPanel;
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
    SelectColorDialog: TColorDialog;
    Panel2: TPanel;
    cb_themesettings: TCheckBox;
    PageControl1: TPageControl;
    tab_weather: TTabSheet;
    Tab_Effects: TTabSheet;
    Label1: TLabel;
    pop_add: TPopupMenu;
    GlobalValues1: TMenuItem;
    Location1: TMenuItem;
    Name1: TMenuItem;
    Long1: TMenuItem;
    Latitute1: TMenuItem;
    imeZone1: TMenuItem;
    Sundata1: TMenuItem;
    SunSet1: TMenuItem;
    SunRise1: TMenuItem;
    Units1: TMenuItem;
    emperature1: TMenuItem;
    Distance1: TMenuItem;
    Speed1: TMenuItem;
    Pressure1: TMenuItem;
    UnitOfPrecip1: TMenuItem;
    CurrentCondition1: TMenuItem;
    emperature2: TMenuItem;
    Wind1: TMenuItem;
    Value1: TMenuItem;
    FeelsLikeTemperature1: TMenuItem;
    Speed2: TMenuItem;
    MaxSpeed1: TMenuItem;
    DirectionText1: TMenuItem;
    DirectionDegr1: TMenuItem;
    BarometerPressure1: TMenuItem;
    CurrentPressure1: TMenuItem;
    RaisorFallText1: TMenuItem;
    UV1: TMenuItem;
    Value2: TMenuItem;
    UVValueText1: TMenuItem;
    Moon1: TMenuItem;
    IconCode1: TMenuItem;
    MoonText1: TMenuItem;
    Visibility1: TMenuItem;
    Dewpoint1: TMenuItem;
    LastUpdate1: TMenuItem;
    Humidity1: TMenuItem;
    Iconnotimplemented1: TMenuItem;
    N2: TMenuItem;
    ConditionText1: TMenuItem;
    ObservationStation1: TMenuItem;
    ImageList1: TImageList;
    tab_custom: TTabSheet;
    Label3: TLabel;
    lb_status: TLabel;
    GroupBox2: TGroupBox;
    FontDialog1: TFontDialog;
    cb_textshadow: TCheckBox;
    tb_spacing: TTrackBar;
    lb_spacing: TLabel;
    GroupBox7: TGroupBox;
    cb_blend: TCheckBox;
    tb_blend: TTrackBar;
    cb_AlphaBlend: TCheckBox;
    tb_alpha: TTrackBar;
    GroupBox6: TGroupBox;
    Label4: TLabel;
    cp_cblend: TSharpEColorBox;
    GroupBox1: TGroupBox;
    rb_default: TRadioButton;
    rb_custom: TRadioButton;
    Panel4: TPanel;
    PageControl2: TPageControl;
    tab_wfCustom: TTabSheet;
    Label2: TLabel;
    Panel3: TPanel;
    memo_custom: TMemo;
    tab_wfDefault: TTabSheet;
    cb_location: TCheckBox;
    cb_detloc: TCheckBox;
    cb_condition: TCheckBox;
    cb_temperature: TCheckBox;
    cb_wind: TCheckBox;
    cb_icon: TCheckBox;
    customfont: TSharpEFontSelector;
    cb_cfont: TCheckBox;
    Forecast1: TMenuItem;
    Day11: TMenuItem;
    N3: TMenuItem;
    LastUpdate2: TMenuItem;
    DayName1: TMenuItem;
    Date1: TMenuItem;
    imeSunset1: TMenuItem;
    SunRise2: TMenuItem;
    HighestTemperature1: TMenuItem;
    LowestTemperature1: TMenuItem;
    DayIcon1: TMenuItem;
    Condition1: TMenuItem;
    WIND2: TMenuItem;
    Humidity2: TMenuItem;
    Day1: TMenuItem;
    Day2: TMenuItem;
    Humidity3: TMenuItem;
    Icon1: TMenuItem;
    Condition2: TMenuItem;
    N4: TMenuItem;
    precipitation1: TMenuItem;
    Precipitation2: TMenuItem;
    DirectionDegr2: TMenuItem;
    DirectionText2: TMenuItem;
    MaxSpeed2: TMenuItem;
    Speed3: TMenuItem;
    Wind4: TMenuItem;
    Speed4: TMenuItem;
    MaxSpeed3: TMenuItem;
    DirectionText3: TMenuItem;
    DirectionDegr3: TMenuItem;
    rb_wskin: TRadioButton;
    tab_wfwskin: TTabSheet;
    lb_skinlist: TListBox;
    skinpreview: TImage32;
    lb_skinaut: TLabel;
    toolbar_memo: TToolBar;
    Action1: TToolButton;
    FileOpen1: TToolButton;
    FileSaveAs1: TToolButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label5: TLabel;
    dd_location: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure hrobberBack1AdvancedDrawItem(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
    procedure N1AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; State: TOwnerDrawState);
    procedure cb_blendClick(Sender: TObject);
    procedure cb_AlphaBlendClick(Sender: TObject);
    procedure tb_blendChange(Sender: TObject);
    procedure tb_alphaChange(Sender: TObject);
    procedure cb_themesettingsClick(Sender: TObject);
    procedure cb_locationClick(Sender: TObject);
    procedure rb_customClick(Sender: TObject);
    procedure rb_defaultClick(Sender: TObject);
    procedure Name1Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FileOpen1Accept(Sender: TObject);
    procedure FileSaveAs1Accept(Sender: TObject);
    procedure tb_spacingChange(Sender: TObject);
    procedure tab_wfCustomShow(Sender: TObject);
    procedure cb_cfontClick(Sender: TObject);
    procedure rb_wskinClick(Sender: TObject);
    procedure lb_skinlistClick(Sender: TObject);
  private
  public
    DeskSettings   : TDeskSettings;
    ObjectSettings : TObjectSettings;
    ThemeSettings  : TThemeSettings;  
    ObjectID : integer;
    MouseIsDown_AlphaBlend : Boolean;
    StartX : Integer;
    procedure SaveSettings;
    procedure LoadSettings;
    procedure UpdateRadioButton;
  end;


const
     DESK_SETTINGS = 'Settings\SharpDesk\SharpDesk.xml';
     THEME_SETTINGS = 'Settings\SharpDesk\Themes.xml';
     OBJECT_SETTINGS = 'Settings\SharpDesk\Objects.xml';


var
  cs : TColorSchemeEx;

implementation

{$R *.dfm}


procedure TSettingsWnd.LoadSettings();
var
   Settings : TXMLSettings;
   sr : TSearchRec;
   s : string;
   XML : TJvSimpleXML;
   n : integer;
begin
  lb_skinlist.Clear;
  if FindFirst(SharpApi.GetSharpeGlobalSettingsPath + 'SharpDesk\Objects\Weather\*.xml',faAnyFile	,sr)=0 then
  begin
    repeat
      s := sr.Name;
      setlength(s,length(s)-4);
      lb_skinlist.Items.Add(s);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  if lb_skinlist.Count>0 then
     lb_skinlist.ItemIndex := 0;
     lb_skinlist.OnClick(lb_skinlist);

  if ObjectID=0 then
  begin
    cb_themesettings.OnClick(self);
    UpdateRadioButton;
    if length(trim(dd_location.text)) = 0 then
       if dd_location.Items.Count >0 then
          dd_location.ItemIndex := 0;
    exit;
  end;

  Settings := TXMLSettings.Create(ObjectID,nil);
  Settings.LoadSettings;

  cb_cfont.Checked                 := Settings.CustomFont;
  cb_cfont.OnClick(cb_cfont);
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

  cb_icon.Checked          := Settings.DisplayIcon;
  cb_location.Checked      := Settings.Location;
  cb_detloc.Checked        := Settings.DetailedLocation;
  cb_wind.Checked          := Settings.Wind;
  cb_condition.Checked     := Settings.Condition;
  cb_temperature.Checked   := Settings.Temperature;

  cb_alphablend.Checked    := Settings.AlphaBlend;
  cb_blend.Checked         := Settings.ColorBlend;
  cb_themesettings.Checked := Settings.UseThemeSettings;

  cp_cblend.Color   := Settings.BlendColor;
  tb_blend.Position := Settings.BlendValue;

  rb_custom.Checked := Settings.CustomFormat;
  memo_custom.Lines.CommaText := Settings.CustomData;

  rb_wskin.Checked := Settings.WeatherSkin;

  if lb_skinlist.Items.IndexOf(Settings.WeatkerSkinFile) > lb_skinlist.Items.Count then
     lb_skinlist.ItemIndex := -1
     else lb_skinlist.ItemIndex := lb_skinlist.Items.IndexOf(Settings.WeatkerSkinFile);
  lb_skinlist.OnClick(lb_skinlist);     

  tb_Alpha.Position := Settings.AlphaValue;
  cb_themesettings.OnClick(self);

  cb_TextShadow.Checked := Settings.TextShadow;
  tb_spacing.Position   := Settings.Spacing;
  tb_spacing.OnChange(tb_spacing);

  cb_detloc.Enabled := cb_location.Checked;
  UpdateRadioButton;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(GetSharpEUserSettingsPath+'SharpCore\Services\Weather\weatherlist.xml');
    for n := 0 to XML.Root.Items.Count - 1 do
        if XML.Root.Items.Item[n].Properties.Value('LocationID') = Settings.WeatherLocation then
    begin
      dd_location.ItemIndex := dd_location.Items.IndexOf(XML.Root.Items.Item[n].Properties.Value('Location'));
      break;
    end;
  except
  end;
  if length(trim(dd_location.text)) = 0 then
     if dd_location.Items.Count >0 then
        dd_location.ItemIndex := 0;
  XML.Free;

  Settings.Free;
end;


procedure TSettingsWnd.SaveSettings();
var
   Locked,Delete,ClickTopMost : boolean;
   n,i : integer;
   Settings : TXMLSettings;
   XML : TJvSimpleXML;
begin
  if ObjectID=0 then exit;

  Settings := TXMLSettings.Create(ObjectID,nil);

  Settings.AlphaBlend       := cb_alphablend.Checked;
  Settings.ColorBlend       := cb_blend.Checked;
  Settings.UseThemeSettings := cb_themesettings.Checked;
  Settings.BlendColor       := cp_cblend.Color;
  Settings.BlendValue       := tb_blend.position;
  Settings.AlphaValue       := tb_alpha.position;

  Settings.TextShadow       := cb_TextShadow.Checked;
  Settings.DisplayIcon      := cb_icon.Checked;     
  Settings.Spacing          := tb_spacing.Position;

  Settings.Location         := cb_location.Checked;
  Settings.DetailedLocation := cb_detloc.Checked;
  Settings.Wind             := cb_wind.Checked;
  Settings.Condition        := cb_condition.Checked;
  Settings.Temperature      := cb_temperature.Checked;

  Settings.CustomFormat     := rb_custom.Checked;
  Settings.CustomData       := memo_custom.Lines.CommaText;

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
  Settings.WeatherSkin      := rb_wskin.Checked;
  Settings.WeatkerSkinFile  := lb_skinlist.Items[lb_skinlist.itemindex];

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(GetSharpEUserSettingsPath+'SharpCore\Services\Weather\weatherlist.xml');
    for n := 0 to XML.Root.Items.Count - 1 do
        if XML.Root.Items.Item[n].Properties.Value('Location') = dd_location.Text then
    begin
      Settings.WeatherLocation := XML.Root.Items.Item[n].Properties.Value('LocationID');
      break;
    end;
  except
  end;
  XML.Free;

  Settings.SaveSettings(True);
  Settings.Free;
  ObjectSettings.SaveObjectSettings;
end;

procedure TSettingsWnd.hrobberBack1AdvancedDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
var
   Caption : String;
   dColor : TColor;
begin
     cs := LoadColorSchemeEx;
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

procedure TSettingsWnd.cb_blendClick(Sender: TObject);
begin
  if tb_blend.Max = 0 then exit;
  tb_blend.Enabled := cb_blend.Checked;
  if cb_blend.Checked then
     cb_blend.Caption := 'Color Blend Icon: ' + inttostr(round((tb_blend.Position*100) / tb_blend.Max))+'%'
     else cb_blend.Caption := 'Color Blend Icon: disabled';
end;

procedure TSettingsWnd.cb_AlphaBlendClick(Sender: TObject);
begin
  if tb_alpha.Max = 0 then exit;
  tb_alpha.Enabled := cb_alphablend.Checked;
  if cb_alphablend.Checked then
     cb_alphablend.Caption := 'Visibility: ' + inttostr(round((tb_alpha.Position*100) / tb_alpha.Max))+'%'
     else cb_alphablend.Caption := 'Visibility: disabled';
end;

procedure TSettingsWnd.tb_blendChange(Sender: TObject);
begin
  cb_blend.OnClick(cb_blend);
end;

procedure TSettingsWnd.tb_alphaChange(Sender: TObject);
begin
  cb_alphablend.OnClick(cb_alphablend);
end;

procedure TSettingsWnd.cb_themesettingsClick(Sender: TObject);
var
   b : boolean;
begin
  b := not cb_themesettings.checked;
  cb_textshadow.Enabled := b;
  tb_alpha.Enabled := b;
  cb_blend.Enabled := b;
  cb_AlphaBlend.Enabled := b;
  customfont.Enabled := b;
  cb_cfont.Enabled := b;
  cb_AlphaBlend.OnClick(self);
  cb_blend.OnClick(self);
  cb_cfont.OnClick(self);
end;

procedure TSettingsWnd.cb_locationClick(Sender: TObject);
begin
  cb_detloc.Enabled := cb_location.Checked;
end;

procedure TSettingsWnd.UpdateRadioButton;
var
  b : boolean;
begin
  case SharpApi.IsServiceStarted('Weather') of
    MR_STARTED : begin
                   lb_status.Caption := 'running';
                   lb_status.Font.Color := clgreen;
                 end;
    MR_STOPPED : begin
                   lb_status.Caption := 'stopped';
                   lb_status.Font.Color := clmaroon;
                 end;
    else begin
           lb_status.Caption := 'unknown reply';
           lb_status.Font.Color := clmaroon;
         end;
  end;
  b := rb_custom.checked;
  tab_weather.TabVisible := True;
  tab_effects.TabVisible := True;
  tab_custom.TabVisible  := True;
  toolbar_memo.Enabled   := b;
  memo_custom.enabled    := b;
  Action1.Enabled        := b;
  FileOpen1.Enabled      := b;
  FileSaveAs1.Enabled    := b;
  if rb_wskin.Checked then pagecontrol2.ActivePage := tab_wfwskin
     else if b then pagecontrol2.ActivePage := tab_wfcustom
           else pagecontrol2.ActivePage := tab_wfdefault;
  cb_location.enabled    := not b;
  cb_detloc.enabled      := not b;
  cb_wind.enabled        := not b;
  cb_condition.enabled   := not b;
  cb_temperature.enabled := not b;
end;

procedure TSettingsWnd.rb_customClick(Sender: TObject);
begin
  UpdateRadioButton;
end;

procedure TSettingsWnd.rb_defaultClick(Sender: TObject);
begin
  UpdateRadioButton;
end;

procedure TSettingsWnd.Name1Click(Sender: TObject);
begin
//  memo_custom.Lines.Append(TMenuItem(Sender).Hint);
  memo_custom.Lines.Append(TMenuItem(Sender).Hint);
end;

procedure TSettingsWnd.Action1Execute(Sender: TObject);
begin
  pop_add.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TSettingsWnd.FileOpen1Accept(Sender: TObject);
begin
  try
    ForceDirectories(SharpApi.GetSharpeUserSettingsPath + 'SharpDesk\Objects\Weather\');
    OpenDialog1.InitialDir := SharpApi.GetSharpeUserSettingsPath + 'SharpDesk\Objects\Weather';
    if OpenDialog1.Execute then
       Memo_custom.Lines.LoadFromFile(OpenDialog1.FileName);
  except
  end;
end;

procedure TSettingsWnd.FileSaveAs1Accept(Sender: TObject);
begin
  try
    ForceDirectories(SharpApi.GetSharpeUserSettingsPath + 'SharpDesk\Objects\Weather\');
    SaveDialog1.InitialDir := SharpApi.GetSharpeUserSettingsPath + 'SharpDesk\Objects\Weather';
    if SaveDialog1.Execute then
    Memo_custom.Lines.SaveToFile(SaveDialog1.FileName+'.sweather');
  except
  end;
end;

procedure TSettingsWnd.tb_spacingChange(Sender: TObject);
begin
  lb_spacing.Caption := 'Line spacing (in px): ' + inttostr(tb_spacing.position);
end;

procedure TSettingsWnd.tab_wfCustomShow(Sender: TObject);
begin
  if memo_custom.Lines.Count = 0 then
  begin
    memo_custom.Lines.Add('{#ICON#}{#}');
    memo_custom.Lines.Add('{#}{#LOCATION#} ({#LATITUE#},{#LONGITUDE#})');
    memo_custom.Lines.Add('{#}Temperature: {#TEMPERATURE#}°{#UNITTEMP#}');
    memo_custom.Lines.Add('{#}Wind Speed: {#WINDSPEED#} ({#UNITSPEED#})');
    memo_custom.Lines.Add('{#}Condition: {#CONDITION#}');
  end;
end;

procedure TSettingsWnd.cb_cfontClick(Sender: TObject);
begin
  customfont.Enabled := cb_cfont.Checked;
  if cb_themesettings.Checked then cb_textshadow.enabled := false
     else cb_textshadow.Enabled := not cb_cfont.Checked;
end;

procedure TSettingsWnd.rb_wskinClick(Sender: TObject);
begin
  UpdateRadioButton;
  if (lb_skinlist.Itemindex = -1) and (lb_skinlist.Count > 0) then
     lb_skinlist.ItemIndex := 0;
  lb_skinlist.OnClick(lb_skinlist);
end;

procedure TSettingsWnd.lb_skinlistClick(Sender: TObject);
var
  xml : TJvSimpleXML;
begin
  if lb_skinlist.ItemIndex = -1 then exit;
  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(SharpApi.GetSharpeGlobalSettingsPath + 'SharpDesk\Objects\Weather\' + lb_skinlist.Items[lb_skinlist.Itemindex]+'.xml');
    skinpreview.Bitmap.LoadFromFile(SharpApi.GetSharpeGlobalSettingsPath + 'SharpDesk\Objects\Weather\' + xml.Root.Items.Value('preview',''));
    lb_skinaut.Caption := 'Skin created by ' + xml.Root.Items.Value('author','(someone)');
  except
    skinpreview.Bitmap.SetSize(skinpreview.Width,skinpreview.Height);
    skinpreview.Bitmap.Clear(clBlack32);
    skinpreview.Bitmap.RenderText(skinpreview.Width div 2 - skinpreview.Bitmap.Textwidth('No Preview') div 2,
                                  skinpreview.Height div 2 - skinpreview.Bitmap.TextHeight('No Preview') div 2,
                                  'No Preview',0,clWhite32);
  end;
  XML.free;
end;

procedure TSettingsWnd.FormCreate(Sender: TObject);
var
  XML : TJvsimpleXML;
  n : integer;
begin
  XML := TJvSimpleXML.Create(nil);
  dd_location.Items.Clear;
  try
    XML.LoadFromFile(GetSharpEUserSettingsPath+'SharpCore\Services\Weather\weatherlist.xml');
    for n := 0 to XML.Root.Items.Count - 1 do
        dd_location.Items.Add(XML.Root.Items.Item[n].Properties.Value('Location','error loading location data'));
  except
    dd_location.Items.Clear;
  end;
  if dd_location.Items.Count = 0 then
     dd_location.Items.Add('no location found');
  XML.Free;
end;

end.
