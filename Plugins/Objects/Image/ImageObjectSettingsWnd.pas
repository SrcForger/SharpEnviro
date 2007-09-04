{
Source Name: SettingsWndUnit
Description: Settings window ot the image object.
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

unit ImageObjectSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SharpApi, SharpFX, ComCtrls,
  pngimage, ExtCtrls, GR32, GR32_Image, JvSimpleXML, Tabs,
  Menus,TypInfo, 
  uSharpDeskTDeskSettings,
  uSharpDeskTThemeSettings,
  uSharpDeskTObjectSettings,
  ImageObjectXMLSettings, uSharpeColorBox, IdBaseComponent, IdHTTP;

type
  TSettingsWnd = class(TForm)
    OpenIconDialog: TOpenDialog;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
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
    lb_size: TLabel;
    tb_size: TTrackBar;
    GroupBox7: TGroupBox;
    cb_blend: TCheckBox;
    tb_blend: TTrackBar;
    cb_AlphaBlend: TCheckBox;
    tb_alpha: TTrackBar;
    GroupBox6: TGroupBox;
    Label4: TLabel;
    Panel3: TPanel;
    cb_themesettings: TCheckBox;
    rb_file: TRadioButton;
    rb_url: TRadioButton;
    pg_iconsource: TPageControl;
    tab_file: TTabSheet;
    lb_width: TLabel;
    Label2: TLabel;
    Edit_IconPath: TEdit;
    lb_height: TLabel;
    btn_loadIcon: TButton;
    Label3: TLabel;
    tab_url: TTabSheet;
    Label5: TLabel;
    edit_url: TEdit;
    btn_testurl: TButton;
    Label6: TLabel;
    ddb_refresh: TComboBox;
    procedure btn_loadIconClick(Sender: TObject);
    procedure hrobberBack1AdvancedDrawItem(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
    procedure N1AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; State: TOwnerDrawState);
    procedure cb_blendClick(Sender: TObject);
    procedure cb_AlphaBlendClick(Sender: TObject);
    procedure tb_blendChange(Sender: TObject);
    procedure tb_alphaChange(Sender: TObject);
    procedure cb_themesettingsClick(Sender: TObject);
    procedure tb_sizeChange(Sender: TObject);
    procedure rb_fileClick(Sender: TObject);
    procedure rb_urlClick(Sender: TObject);
    procedure btn_testurlClick(Sender: TObject);
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
  end;


const
     DESK_SETTINGS = 'Settings\SharpDesk\SharpDesk.xml';
     THEME_SETTINGS = 'Settings\SharpDesk\Themes.xml';
     OBJECT_SETTINGS = 'Settings\SharpDesk\Objects.xml';


var
  cs : TColorScheme;

implementation

{$R *.dfm}


procedure TSettingsWnd.LoadSettings();
var
   Picture : TBitmap32;
   Settings : TXMLSettings;
begin
     if ObjectID=0 then
     begin
          cb_themesettings.OnClick(self);
          exit;
     end;

     Settings := TXMLSettings.Create(ObjectID,nil);
     Settings.LoadSettings;

     rb_url.Checked        := Settings.ftURL;
     if rb_url.Checked then edit_url.Text := Settings.IconFile
        else edit_IconPath.Text := Settings.IconFile;
     if rb_url.Checked then rb_url.OnClick(rb_url)
        else rb_file.OnClick(rb_file);
     cb_alphablend.Checked := Settings.AlphaBlend;
     cb_blend.Checked      := Settings.ColorBlend;
     cb_themesettings.Checked := Settings.UseThemeSettings;
     if FileExists(Edit_IconPath.Text) then
     begin
          Picture:=TBitmap32.Create;
          Picture.LoadFromFile(Edit_IconPath.Text);
          lb_width.Caption:='Width : '+inttostr(Picture.Width);
          lb_height.Caption:='Height : '+inttostr(Picture.Height);
          Picture.Free;
     end;
     cp_cblend.Color   := Settings.BlendColor;
     tb_blend.Position := Settings.BlendValue;
     ddb_refresh.ItemIndex := ddb_refresh.Items.IndexOf(inttostr(Settings.URLRefresh));

     tb_size.Position := Settings.Size;

     tb_Alpha.Position := Settings.AlphaValue;
     cb_themesettings.OnClick(self);

     Settings.Free;
end;


procedure TSettingsWnd.SaveSettings();
var
   Locked,Delete,ClickTopMost : boolean;
   n,i : integer;
   Settings : TXMLSettings;
begin
  if ObjectID=0 then exit;

  Settings := TXMLSettings.Create(ObjectID,nil);

  Settings.AlphaBlend       := cb_alphablend.Checked;
  Settings.ColorBlend       := cb_blend.Checked;
  Settings.UseThemeSettings := cb_themesettings.Checked;
  Settings.BlendColor       := cp_cblend.Color;
  Settings.BlendValue       := tb_blend.position;
  Settings.Size             := tb_size.Position;
  Settings.AlphaValue       := tb_alpha.position;
  Settings.ftURL            := rb_url.Checked;
  if rb_url.Checked then Settings.IconFile := edit_url.Text
     else Settings.IconFile := edit_IconPath.Text;

  Settings.URLRefresh := strtoint(ddb_refresh.Text);

  Settings.SaveSettings(True);
  Settings.Free;
  ObjectSettings.SaveObjectSettings;
end;

procedure TSettingsWnd.btn_loadIconClick(Sender: TObject);
var
   Picture : TBitmap32;
begin
     if OpenIconDialog.Execute then
     begin
          Edit_IconPath.Text:=OpenIconDialog.FileName;
          Picture:=TBitmap32.Create;
          Picture.LoadFromFile(OpenIconDialog.FileName);
          lb_width.Caption:='Width : '+inttostr(Picture.Width);
          lb_height.Caption:='Height : '+inttostr(Picture.Height);
          Picture.Free;
     end;
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
     Label4.Enabled := b;
     tb_alpha.Enabled := b;
     cb_AlphaBlend.Enabled := b;
     tb_blend.Enabled := b;
     cb_blend.Enabled := b;
     cp_cblend.enabled:= b;
     cb_AlphaBlend.OnClick(self);
     cb_blend.OnClick(self);
end;

procedure TSettingsWnd.tb_sizeChange(Sender: TObject);
begin
     lb_size.Caption := 'Size : ' +inttostr(round((tb_size.Position*400) / tb_size.Max))+'%';
end;

procedure TSettingsWnd.rb_fileClick(Sender: TObject);
begin
  pg_iconsource.ActivePage := tab_file;
end;

procedure TSettingsWnd.rb_urlClick(Sender: TObject);
begin
  pg_iconsource.ActivePage := tab_url;
end;

procedure SaveObjectToXML(pXMLElem : TJvSimpleXMLElem; pobject : TObject);
var
  Count : integer;
  List  : TPropList;
  n     : integer;
  obj   : TObject;
begin
  Count := GetPropList(pobject.classinfo, tkAny, @List);
  for n:= 0 to Count-1 do
  begin
    case List[n].PropType^.Kind of
      tkEnumeration : pXMLElem.Items.Add(List[n].Name,GetEnumProp(pobject,List[n]));
      tkSet     : pXMLElem.Items.Add(List[n].Name,GetSetProp(pobject,List[n]));
      tkInteger : pXMLElem.Items.Add(List[n].Name,GetOrdProp(pobject,List[n]));
      tkInt64   : pXMLElem.Items.Add(List[n].Name,GetInt64Prop(pobject,List[n]));
      tkString  : pXMLElem.Items.Add(List[n].Name,GetStrProp(pobject,List[n]));
      tkWChar,tkLString,tkWString : pXMLElem.Items.Add(List[n].Name,GetWideStrProp(pobject,List[n]));
      tkClass :
        begin
          pXMLElem.Items.Add(List[n].Name,'');
          obj := GetObjectProp(pobject,List[n].Name,GetObjectPropClass(pobject,List[n]));
          if obj<>nil then SaveObjectToXml(pXMLElem.Items.Add(List[n].Name),obj);
        end;
    end;
  end;
end;


procedure TSettingsWnd.btn_testurlClick(Sender: TObject);
var
  idHTTP : TIdHTTP;
  FileStream : TFileStream;
  Dir : string;
  MimeList: TStringList;
begin
  MimeList := TStringList.Create;
  MimeList.Clear;
  MimeList.Add('image/jpeg');
  MimeList.Add('image/png');
  MimeList.Add('image/bmp');
  Dir := SharpApi.GetSharpeUserSettingsPath+'\SharpDesk\Objects\Image\';
  ForceDirectories(Dir);
  try
    DeleteFile(Dir+'settingstest.temp');
  except
  end;
  idHTTP := TidHTTP.Create(nil);
  idHTTP.ConnectTimeout := 10000;
  idHTTP.Request.Accept := 'image/jpeg,image/png,image/bmp';
  idHTTP.HandleRedirects := True;
  try
    idHTTP.Head(edit_url.Text);
  except
  end;
  if MimeList.IndexOf(idHttp.Response.ContentType)<>-1 then
     showmessage('URL seems to be valid')
     else showmessage('Invalid file type or host unreachable'+#10#13+'HTTP Response : '+idHttp.ResponseText);

  idHTTP.Disconnect;
  idHTTP.Free;
  MimeList.Free;
end;

end.
