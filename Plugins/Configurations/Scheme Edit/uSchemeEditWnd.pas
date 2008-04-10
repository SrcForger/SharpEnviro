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
unit uSchemeEditWnd;

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
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  pngimage,
  Mask,
  ContNrs,
  GR32_Image,
  SharpApi,
  SharpCenterApi,
  SharpThemeApi,
  SharpEListBoxEx,
  PngImageList,
  JvSimpleXML,
  BarPreview,
  Gr32,
  ImgList, SharpESwatchManager, SharpEColorEditorEx, SharpEColorEditor;

type
  TfrmSchemeEdit = class(TForm)
    cexScheme: TSharpEColorEditorEx;
    smScheme: TSharpESwatchManager;
    tmrRender: TTimer;
    tmrPreview: TTimer;

    procedure RenderScheme;
    procedure tmrRenderTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cexSchemeChangeColor(ASender: TObject; AValue: Integer);
    procedure cexSchemeUiChange(Sender: TObject);
    procedure tmrPreviewTimer(Sender: TObject);
  private
    FTheme: string;
    FScheme: string;
  public

    Colors: TSharpEColorSet;
    procedure CreatePreviewBitmap(var ABmp: TBitmap32);
    property Theme: string read FTheme write FTheme;
    property Scheme: string read FScheme write FScheme;
  end;

var
  frmSchemeEdit: TfrmSchemeEdit;

implementation

uses
  JclStrings,
  SharpFx;

{$R *.dfm}

procedure TfrmSchemeEdit.cexSchemeChangeColor(ASender: TObject;
  AValue: Integer);
begin

  if TSharpEColorEditorExItem(ASender).ValueEditorType = vetColor then
    Colors[TSharpEColorEditorExItem(ASender).Tag].Color := AValue
  else
    Colors[TSharpEColorEditorExItem(ASender).Tag].Color := AValue;

  tmrPreview.Enabled := True;
end;

procedure TfrmSchemeEdit.cexSchemeUiChange(Sender: TObject);
begin
  CenterDefineSettingsChanged;
end;

procedure TfrmSchemeEdit.CreatePreviewBitmap(var ABmp: TBitmap32);
var
  bmp: TBitmap32;
begin
  if FScheme = '' then begin
    ABmp.SetSize(0, 0);
    exit;
  end;

  bmp := TBitmap32.Create;
  try

    BarPreview.CreateBarPreview(bmp, FTheme, XmlGetSkin(FTheme),
      Colors, ABmp.Width, true);

    ABmp.SetSize(bmp.Width, bmp.height);
    Bmp.DrawTo(ABmp);
  finally
    bmp.Free;
  end;
end;

procedure TfrmSchemeEdit.FormShow(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  Self.ParentBackground := False;
  cexScheme.DoubleBuffered := True;

  tmrRender.Enabled := True;
end;

procedure TfrmSchemeEdit.RenderScheme;
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
    for i := 0 to high(Colors) do begin
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
  CenterUpdateSize;
{$ENDREGION}

end;

procedure TfrmSchemeEdit.tmrPreviewTimer(Sender: TObject);
begin
  tmrPreview.Enabled := false;
  CenterUpdatePreview;

end;

procedure TfrmSchemeEdit.tmrRenderTimer(Sender: TObject);
begin
  tmrRender.Enabled := false;
  RenderScheme;
end;

end.

