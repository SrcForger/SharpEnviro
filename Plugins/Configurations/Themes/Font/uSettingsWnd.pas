{
Source Name: uSettingsWnd.pas
Description: Settings Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit uSettingsWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Math,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  JvSimpleXml,
  JclFileUtils,
  ImgList,
  PngImageList,
  SharpEListBox,
  SharpEListBoxEx,
  GR32,
  GR32_PNG,
  SharpApi,
  ExtCtrls,
  Menus,
  JclStrings,
  GR32_Image,
  SharpEGaugeBoxEdit,
  SharpEUIC,
  SharpEFontSelectorFontList,
  JvPageList,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  JvExControls, SharpECenterHeader, JvXPCore, JvXPCheckCtrls, pngimage, Buttons,
  PngSpeedButton;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmSettingsWnd = class(TForm)
    Panel1: TPanel;
    plMain: TJvPageList;
    pagFont: TJvStandardPage;
    pagFontShadow: TJvStandardPage;
    uicFontSize: TSharpEUIC;
    sgbFontSize: TSharpeGaugeBox;
    uicFontType: TSharpEUIC;
    cboFontName: TComboBox;
    uicAlpha: TSharpEUIC;
    sgbFontVisibility: TSharpeGaugeBox;
    uicShadow: TSharpEUIC;
    textpanel: TPanel;
    uicShadowType: TSharpEUIC;
    cboShadowType: TComboBox;
    uicShadowAlpha: TSharpEUIC;
    sgbShadowAlpha: TSharpeGaugeBox;
    uicBold: TSharpEUIC;
    uicItalic: TSharpEUIC;
    uicUnderline: TSharpEUIC;
    uicCleartype: TSharpEUIC;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader11: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    SharpECenterHeader3: TSharpECenterHeader;
    SharpECenterHeader13: TSharpECenterHeader;
    SharpECenterHeader5: TSharpECenterHeader;
    SharpECenterHeader6: TSharpECenterHeader;
    chkCleartype: TJvXPCheckbox;
    chkItalic: TJvXPCheckbox;
    chkUnderline: TJvXPCheckbox;
    chkBold: TJvXPCheckbox;
    chkShadow: TJvXPCheckbox;
    imlFontIcons: TPngImageList;
    Panel2: TPanel;
    Image1: TImage;
    Label1: TLabel;
    btnRevert: TPngSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SgbUicValueChanged(Sender: TObject; Value: Integer);
    procedure cboFontNameDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure controlUicValueChanged(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UIC_Reset(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRevertClick(Sender: TObject);
  private
    FFontList: TFontList;
    FPluginHost: TInterfacedSharpCenterHostBase;
    FIsUpdating: boolean;
    function GetChangedControlCount: integer;
    procedure UpdateSettingsChanged;
  public
    procedure RefreshFontList;

    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;
    property IsUpdating: boolean read FIsUpdating write FIsUpdating;
  end;

var
  frmSettingsWnd: TfrmSettingsWnd;

implementation

uses SharpThemeApi;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmSettingsWnd.RefreshFontList;
var
  fi: TFontInfo;
  i: integer;
  DuplicateCheck: Integer;
begin
  cboFontName.Items.Clear;
  try
    for i := 0 to pred(FFontList.List.Count) do begin
      fi := TFontInfo(FFontList.List.Objects[i]);
      DuplicateCheck := cboFontName.Items.IndexOf(fi.FullName);

      if DuplicateCheck = -1 then
        cboFontName.Items.AddObject(FFontList.List.Strings[i], fi);
    end;
  finally
    cboFontName.ItemIndex := cboFontName.Items.IndexOf('Arial');
  end;
end;

procedure TfrmSettingsWnd.SgbUicValueChanged(Sender: TObject; Value: Integer);
begin
  controlUICValueChanged(Sender);
end;

procedure TfrmSettingsWnd.UIC_Reset(Sender: TObject);
begin
  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.btnRevertClick(Sender: TObject);
var
  i:Integer;
begin

  for i := 0 to Pred(Self.ComponentCount) do begin
    if Self.Components[i].ClassNameIs('TSharpEUIC') then begin
      TSharpEUIC(Self.Components[i]).Reset;
    end;
  end;

  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.controlUicValueChanged(Sender: TObject);
var
  uic: TSharpEUIC;
  i:Integer;
begin
  if FIsUpdating then exit;

  // Get the uic
  uic := nil;
  for i := 0 to pred(ComponentCount) do begin
    if Components[i].ClassNameIs( 'TSharpEUIC' ) then begin
      uic := TSharpEUIC(Components[i]);

      if uic.MonitorControl = TComponent(sender) then
        break else
        uic := nil;
    end;
  end;

  if uic <> nil then begin
    uic.UpdateStatus;
    UpdateSettingsChanged;
  end;

end;

procedure TfrmSettingsWnd.cboFontNameDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  fi: TFontInfo;
  imageindex: integer;
  textheight: integer;
begin
  cboFontName.canvas.fillrect(rect);
  fi := TFontInfo(cboFontName.Items.Objects[Index]);

  imageindex := -1;
  case fi.FontType of
    ftTrueType: imageindex := 0;
  end;

  imlFontIcons.Draw(cboFontName.Canvas, rect.left, rect.top+1, imageindex);

  cboFontName.Canvas.Font.Name := fi.ShortName;
  textheight := cboFontName.Canvas.TextHeight(fi.FullName);

  if textheight > cboFontName.ItemHeight then
    cboFontName.Canvas.Font.Name := 'Arial';

  cboFontName.canvas.textout(rect.left + imlFontIcons.width + 2, rect.top, fi.FullName);
end;

procedure TfrmSettingsWnd.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
  FFontList := TFontList.Create;
  FFontList.RefreshFontInfo;
  RefreshFontList;
end;

procedure TfrmSettingsWnd.FormDestroy(Sender: TObject);
begin
  FFontList.Free;
end;

procedure TfrmSettingsWnd.FormShow(Sender: TObject);
begin
  textpanel.Visible := chkShadow.Checked;
end;

function TfrmSettingsWnd.GetChangedControlCount: integer;
var
  i:Integer;
begin
  result := 0;
  for i := 0 to Pred(Self.ComponentCount) do begin
    if Self.Components[i].ClassNameIs('TSharpEUIC') then begin
      if TSharpEUIC(Self.Components[i]).HasChanged then
        Inc(Result);
    end;
  end;
end;

procedure TfrmSettingsWnd.UpdateSettingsChanged;
begin
  PluginHost.SetSettingsChanged;
  PluginHost.Refresh;

  btnRevert.Visible := (GetChangedControlCount <> 0);
  textpanel.Visible := chkShadow.Checked;
end;

end.

