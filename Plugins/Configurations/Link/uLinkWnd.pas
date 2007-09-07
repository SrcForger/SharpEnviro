{
Source Name: uLinkWnd.pas
Description: Link Object Settings Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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

unit uLinkWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, uSEListboxPainter, JclFileUtils,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit, SharpEUIC,
  SharpEFontSelectorFontList, JvPageList, JvExControls, SharpEPageControl,
  ComCtrls, Mask, JvExMask, JvToolEdit, SharpEColorEditorEx,
  SharpDialogs, SharpERoundPanel, SharpIconUtils;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmLink = class(TForm)
    plMain: TJvPageList;
    pagLink: TJvStandardPage;
    Label9: TLabel;
    Label5: TLabel;
    Target: TJvFilenameEdit;
    pn_caption: TPanel;
    cb_caption: TCheckBox;
    Label1: TLabel;
    spc: TSharpEPageControl;
    pl: TJvPageList;
    pagesingle: TJvStandardPage;
    pagemulti: TJvStandardPage;
    edit_caption: TEdit;
    memo_caption: TMemo;
    Panel2: TPanel;
    cb_calign: TComboBox;
    Label3: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label4: TLabel;
    Icon: TJvFilenameEdit;
    SharpERoundPanel1: TSharpERoundPanel;
    IconPreview: TImage32;
    procedure FormCreate(Sender: TObject);
    procedure TargetButtonClick(Sender: TObject);
    procedure spcTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);
    procedure IconButtonClick(Sender: TObject);
    procedure TargetBeforeDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure cb_captionClick(Sender: TObject);
    procedure IconBeforeDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure TargetChange(Sender: TObject);
    procedure cb_calignChange(Sender: TObject);
    procedure IconChange(Sender: TObject);
    procedure edit_captionChange(Sender: TObject);
    procedure memo_captionChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure UpdateSettings;
    procedure UpdateIcon;
  public
    sObjectID: string;
  end;

var
  frmLink: TfrmLink;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmLink.cb_calignChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmLink.cb_captionClick(Sender: TObject);
begin
  if cb_caption.Checked then
    pn_caption.Height := 227
    else pn_caption.Height := 51;

  UpdateSettings;
end;

procedure TfrmLink.edit_captionChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmLink.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmLink.FormShow(Sender: TObject);
begin
  UpdateIcon;
  cb_caption.OnClick(cb_caption);
  Label5.Font.Color := clGrayText;
  Label1.Font.Color := clGrayText;
  Label4.Font.Color := clGrayText;
end;

procedure TfrmLink.IconBeforeDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
begin
  AAction := False;
end;

procedure TfrmLink.IconButtonClick(Sender: TObject);
var
  s : String;
begin
  s := SharpDialogs.IconDialog(Target.Text,SMI_ALL_ICONS,Mouse.CursorPos);
  if length(trim(s)) > 0 then
  begin
    Icon.Text := s;
    UpdateIcon;
  end;
end;

procedure TfrmLink.IconChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmLink.memo_captionChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmLink.spcTabChange(ASender: TObject; const ATabIndex: Integer;
  var AChange: Boolean);
begin
  pl.ActivePageIndex := ATabIndex;
  if pl.ActivePageIndex = 1 then
    memo_caption.lines.CommaText := edit_caption.Text
    else edit_caption.Text := memo_caption.Lines.CommaText;
  UpdateSettings;    
  AChange := True;
end;

procedure TfrmLink.TargetBeforeDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
begin
  AAction := False;
end;

procedure TfrmLink.TargetButtonClick(Sender: TObject);
var
  s : String;
begin
  s := SharpDialogs.TargetDialog(STI_ALL_TARGETS,Mouse.CursorPos);
  if length(trim(s)) > 0 then
    Target.Text := s;
end;

procedure TfrmLink.TargetChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmLink.UpdateIcon;
var
  Bmp : TBitmap32;
begin
  Bmp := TBitmap32.Create;
  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;
  SharpIconUtils.IconStringToIcon(Icon.Text,Target.Text,Bmp,32);
  IconPreview.Bitmap.SetSize(32,32);
  IconPreview.Bitmap.Clear(color32(IconPreview.Color));
  Bmp.DrawTo(IconPreview.Bitmap,Rect(0,0,32,32));
  Bmp.Free;
end;

procedure TfrmLink.UpdateSettings;
begin
  if Visible then
    SharpCenterApi.CenterDefineSettingsChanged;
end;

end.

