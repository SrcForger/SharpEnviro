{
Source Name: uSettingsWnd
Description: Configuration window for Scheme Settings
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
unit uEditWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  StdCtrls,
  ExtCtrls,
  pngimage,
  GR32_Image,
  SharpApi,
  SharpCenterApi,
  SharpThemeApiEx,
  SharpEListBoxEx,
  PngImageList,
  JclSimpleXML,
  uThemeConsts,
  uISharpETheme,
  BarPreview,
  Gr32,
  ImgList, SharpESwatchManager, SharpEColorEditorEx, SharpEColorEditor, ISharpCenterHostUnit;

type
  TfrmEditWnd = class(TForm)
    cexScheme: TSharpEColorEditorEx;
    smScheme: TSharpESwatchManager;
    tmrPreview: TTimer;
    pnlScheme: TPanel;

    procedure RenderScheme;

    procedure FormShow(Sender: TObject);
    procedure cexSchemeChangeColor(ASender: TObject; AValue: Integer);
    procedure cexSchemeUiChange(Sender: TObject);
    procedure tmrPreviewTimer(Sender: TObject);
    procedure cexSchemeExpandCollapse(ASender: TObject);
  private
    FTheme: ISharpETheme;
    FScheme: string;
    FPluginHost: ISharpCenterHost;
  public
    Colors: TSharpEColorSet;
    procedure CreatePreviewBitmap(var ABmp: TBitmap32);
    property Theme: ISharpETheme read FTheme write FTheme;
    property Scheme: string read FScheme write FScheme;

    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
  end;

var
  frmEditWnd: TfrmEditWnd;

implementation

uses
  JclStrings,
  SharpFx;

{$R *.dfm}

procedure TfrmEditWnd.cexSchemeChangeColor(ASender: TObject;
  AValue: Integer);
begin

  if TSharpEColorEditorExItem(ASender).ValueEditorType = vetColor then
    Colors[TSharpEColorEditorExItem(ASender).Tag].Color := AValue
  else
    Colors[TSharpEColorEditorExItem(ASender).Tag].Color := AValue;

  tmrPreview.Enabled := True;
end;

procedure TfrmEditWnd.cexSchemeExpandCollapse(ASender: TObject);
begin
  Self.Height := pnlScheme.Height + 50;

  FPluginHost.Refresh(rtSize);
end;

procedure TfrmEditWnd.cexSchemeUiChange(Sender: TObject);
begin
  FPluginHost.SetSettingsChanged;
end;

procedure TfrmEditWnd.CreatePreviewBitmap(var ABmp: TBitmap32);
var
  bmp: TBitmap32;
begin
  if FScheme = '' then begin
    ABmp.SetSize(0, 0);
    exit;
  end;

  bmp := TBitmap32.Create;
  try

    BarPreview.CreateBarPreview(bmp, FTheme.Info.Name, FTheme.Skin.Name,
      FScheme,150,Colors, true);

    ABmp.SetSize(bmp.Width, bmp.height);
    Bmp.DrawTo(ABmp);
  finally
    bmp.Free;
  end;
end;

procedure TfrmEditWnd.FormShow(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  cexScheme.DoubleBuffered := True;
  Self.ParentBackground := False;
  RenderScheme;
end;

procedure TfrmEditWnd.RenderScheme;
var
  color: TSharpESkinColor;
  item: TSharpEColorEditorExItem;
  i, h: Integer;
begin

  if FScheme = '' then exit;

  // Populate
  cexScheme.BeginUpdate;
  cexScheme.Items.Clear;
  try
    for i := 0 to high(Colors) do
      if Colors[i].SchemeType <> stDynamic then
      begin
        color := Colors[i];
        item := TSharpEColorEditorExItem.Create(cexScheme.Items);

        item.Title := color.Name;
        item.ColorCode := color.Color;
        item.Tag := i;

        if color.schemetype = stInteger then
          item.ValueEditorType := vetValue
        else
          item.ValueEditorType := vetColor;

        item.Value := color.Color;
        item.Description := color.Info + ':';
        item.ValueText := color.Name;
      end;
  finally
    cexScheme.EndUpdate;
  end;

{$REGION 'Update Size'}
  h := 0;
  if high(Colors) <> 0 then
    h := cexScheme.Items.Item[0].ColorEditor.CollapseHeight * high(Colors)
      + cexScheme.Items.Item[0].ColorEditor.ExpandedHeight;

  cexScheme.Height := h + 10;
  self.Height := h + 10;
  PluginHost.Refresh;
{$ENDREGION}

end;

procedure TfrmEditWnd.tmrPreviewTimer(Sender: TObject);
begin
  tmrPreview.Enabled := false;
  PluginHost.Refresh(rtPreview);

end;

end.

