{
Source Name: uSettingsWnd
Description: Configuration window for Scheme Settings
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
unit uSchemeListWnd;

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
  Spin,
  ComCtrls,
  pngimage,
  Mask,
  ContNrs,
  GR32_Image,
  uEditSchemeWnd,
  JclGraphUtils,
  SharpApi, SharpThemeApi, ImgList, SharpEListBoxEx, PngImageList,
  JvSimpleXML, uSchemeList, BarPreview, Gr32;

type
  TARGB = packed record b, g, r, a: Byte
  end;

type
  TfrmSchemeList = class(TForm)
    Label3: TLabel;
    lbSchemeList: TSharpEListBoxEx;
    imlCol1: TPngImageList;
    imlCol2: TPngImageList;
    bmlMain: TBitmap32List;
    procedure lbSchemeListClickItem(AText: string; AItem, ACol: Integer);

    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //procedure lbSchemeListDrawItem(Control: TWinControl; Index: Integer;
    //  Rect: TRect; State: TOwnerDrawState);
    procedure chkCpuEnableClick(Sender: TObject);
  private
    { Private declarations }
    FInitialising: Boolean;
    FTheme: string;
    FDefault: string;
    FSchemeItems: TSchemeList;
    procedure CreateSchemeBitmap(ASchemeColors: TobjectList; var ABitmap:
      TBitmap);
    procedure CreateColumns;

    function SaveBitmap32ToPNG(bm32: TBitmap32; paletted, transparent: Boolean;
      bgcolor: TColor;
      CompressionLevel: Integer = 9;
      InterlaceMethod: TInterlaceMethod = imNone): tPNGObject;
  public
    property SchemeItems: TSchemeList read FSchemeItems write FSchemeItems;
    procedure CreatePreviewBitmap(var ABmp: TBitmap32);

    { Public declarations }
    procedure InitialiseSettings(APluginID: string);
    procedure BuildSchemeList(APluginID: string);
    procedure DeleteScheme;
    procedure AddScheme;

    procedure UpdateEditTabs;

    function SaveSchemes: Boolean;

    property Theme: string read FTheme write FTheme;

  end;

var
  frmSchemeList: TfrmSchemeList;

implementation

uses
  uSEListboxPainter,
  JclStrings,
  SharpFx;

{$R *.dfm}

procedure TfrmSchemeList.UpdateEditTabs;

  procedure BC(AEnabled:Boolean; AButton:Integer);
  begin
    if AEnabled then
    SharpCenterBroadCast( SCM_SET_BUTTON_ENABLED, AButton) else
    SharpCenterBroadCast( SCM_SET_BUTTON_DISABLED, AButton);
  end;

begin
  if lbSchemeList.Count = 0 then
  begin
    BC(False, SCB_EDIT_TAB);
    BC(False, SCB_DEL_TAB);

    if FSchemeItems.GetSkinValid(FTheme) then
      BC(True, SCB_ADD_TAB) else
      BC(False, SCB_ADD_TAB);

    lbSchemeList.AddItem('There is no skin defined, please launch the skin configuration first.',2);
    lbSchemeList.Enabled := False;
  end
  else
  begin
    BC(True, SCB_ADD_TAB);
    BC(True, SCB_EDIT_TAB);
    BC(True, SCB_DEL_TAB);
    lbSchemeList.Enabled := True;
  end;
end;

procedure TfrmSchemeList.CreatePreviewBitmap(var ABmp: TBitmap32);
var
  bmp: TBitmap32;
  bmpTint: TBitmap32;
  y, x: Integer;
  c: TColor;
  cx, cy: Integer;
  tmpSchemeItem: TSchemeItem;
begin
  bmp := TBitmap32.Create;

  try
    if (frmEditScheme <> nil) then
      tmpSchemeItem := frmEditScheme.SchemeItem
    else
      tmpSchemeItem :=
        TSchemeItem(lbSchemeList.Item[lbSchemeList.ItemIndex].Data);

    BarPreview.CreateBarPreview(bmp, FSchemeItems.GetSkinName(FTheme),
      tmpSchemeItem.GetItemAsColorArray(tmpSchemeItem.Colors), 200);

    bmp.DrawMode := dmBlend;
    bmp.savetofile('e:\test.bmp');

    cx := (ABmp.Width div 2) - (bmp.Width div 2);
    cy := (ABmp.Height div 2) - (bmp.Height div 2);

    bmp.DrawTo(ABmp, cX, CY);
  finally
    bmp.Free;
  end;
end;

function TfrmSchemeList.SaveBitmap32ToPNG(bm32: TBitmap32; paletted,
  transparent: Boolean;
  bgcolor: TColor;
  CompressionLevel: Integer = 9;
  InterlaceMethod: TInterlaceMethod = imNone): tPNGObject;
var
  bm: TBitmap;
  png: TPngObject;
  TRNS: TCHUNKtRNS;
  p: pngimage.PByteArray;
  x, y: Integer;
begin
  try
    png := TPngObject.Create;
    bm := TBitmap.Create;
    try
      bm.Assign(bm32);
      if paletted then
        bm.PixelFormat := pf8bit; // force paletted on
      //TBitmap, transparent for the web must be 8 bit
      png.InterlaceMethod := InterlaceMethod;
      png.CompressionLevel := CompressionLevel;
      png.Assign(bm); //Convert data into png
    finally
      FreeAndNil(bm);
    end;
    if transparent then
    begin
      if png.Header.ColorType in [COLOR_PALETTE] then
      begin
        if (png.Chunks.ItemFromClass(TChunktRNS) = nil) then
          png.CreateAlpha;
        TRNS := png.Chunks.ItemFromClass(TChunktRNS) as TChunktRNS;
        if Assigned(TRNS) then
          TRNS.TransparentColor := bgcolor;
      end;
      if png.Header.ColorType in [COLOR_RGB, COLOR_GRAYSCALE] then
        png.CreateAlpha;
      if png.Header.ColorType in [COLOR_RGBALPHA, COLOR_GRAYSCALEALPHA] then
      begin
        for y := 0 to png.Header.Height - 1 do
        begin
          p := png.AlphaScanline[y];
          for x := 0 to png.Header.Width - 1 do
            p[x] :=
              TARGB(bm32.Pixel[x, y]).a;
        end;
      end;
    end;
  finally
    Result := png;
  end;
end;

procedure TfrmSchemeList.DeleteScheme;
var
  Index, n: Integer;
  tmpItem: TSchemeItem;
  bDefault: Boolean;
begin
  Index := lbSchemeList.ItemIndex;
  if Index = -1 then
    exit;

  bDefault := False;
  tmpItem := TSchemeItem(lbSchemeList.Item[Index].Data);
  if tmpItem.Name = FDefault then
    bDefault := True;
  FSchemeItems.Delete(tmpItem);

  if bDefault then
    FDefault := '';

  BuildSchemeList(FTheme);

  SharpCenterBroadCast( SCM_EVT_UPDATE_SETTINGS, 1);
  SharpCenterBroadCast( SCM_EVT_UPDATE_PREVIEW, 1);
end;

procedure TfrmSchemeList.BuildSchemeList(APluginID: string);
var
  sr: TSearchRec;
  dir: string;
  XML: TJvSimpleXML;
  Item: TListItem;
  bmp32: Tbitmap32;
  bmp: TBitmap;
  n, w, i, iSel: integer;
  png: TPngImageCollectionItem;
  tmpItem: TSharpEListItem;
begin
  iSel := lbSchemeList.ItemIndex;
  if iSel = -1 then
    iSel := 0;

  LockWindowUpdate(lbSchemeList.Handle);
  Screen.Cursor := crHourGlass;
  try
    imlCol1.PngImages.Clear;
    lbSchemeList.Items.Clear;

    for i := 0 to Pred(FSchemeItems.Count) do
    begin

      Bmp := TBitmap.Create;
      Bmp32 := TBitmap32.Create;
      try
        {CreateSchemeBitmap(FSchemeItems[i].Colors, Bmp);

        if lbSchemeList.Column[0].Images.Width <> Bmp.Width then
          lbSchemeList.Column[0].Images.Width := Bmp.Width;

        if lbSchemeList.Column[0].Images.Height <> Bmp.Height then
          lbSchemeList.Column[0].Images.Height := Bmp.Height;

        n := lbSchemeList.Column[0].Images.AddMasked(Bmp, clWhite); }

        tmpItem := lbSchemeList.AddItem(FSchemeItems[i].Name, 1);
        tmpItem.AddSubItem(FSchemeItems[i].Author, -1);

        if CompareText(FDefault, FSchemeItems[i].Name) = 0 then
          tmpItem.AddSubItem('', 0)
        else
          tmpItem.AddSubItem('', -1);

        tmpItem.Data := FSchemeItems[i];

      finally
        Bmp.Free;
        bmp32.Free;
      end;
    end;
  finally
    LockWindowUpdate(0);
    lbSchemeList.ItemIndex := iSel;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmSchemeList.InitialiseSettings(APluginID: string);
begin
  FInitialising := True;
  FTheme := APluginID;
  FDefault := FSchemeItems.GetDefault(FTheme, GetSkinName);

  // Get FTheme info
  FSchemeItems.Theme := FTheme;
  FSchemeItems.Load(FTheme);

  BuildSchemeList(FTheme);
  UpdateEditTabs;

  // Hide Deletr Tab - Not Implemented
  SharpCenterBroadCast(SCM_SET_BUTTON_DISABLED,SCB_DEL_TAB);
end;

procedure TfrmSchemeList.chkCpuEnableClick(Sender: TObject);
begin
  //PrismSettings.EnableCpuOptim := chkCpuEnable.Checked;
  //InitialiseSettings;
end;

procedure TfrmSchemeList.FormCreate(Sender: TObject);
begin
  FSchemeItems := TSchemeList.Create;
  Self.DoubleBuffered := True;
  lbSchemeList.DoubleBuffered := True;
  CreateColumns;
end;

procedure TfrmSchemeList.FormDestroy(Sender: TObject);
begin
  FSchemeItems.Free;
end;

procedure TfrmSchemeList.CreateSchemeBitmap(ASchemeColors: TobjectList;
  var ABitmap: TBitmap);
var
  x, n, i: Integer;
  r: TRect;
  tmpColor: TSchemeColorItem;
begin
  try
    x := 0;
    ABitmap.Height := 20;
    ABitmap.Width := 18 * ASchemeColors.Count;
    ABitmap.Canvas.Brush.Color := clWindow;
    ABitmap.Canvas.FillRect(Rect(0, 0, ABitmap.Width, ABitmap.Height));

    for i := 0 to Pred(ASchemeColors.Count) do
    begin
      tmpColor := TSchemeColorItem(ASchemeColors[i]);
      r := Rect(x, 2, x + 16, 18);

      ABitmap.Canvas.Brush.Color := tmpColor.Color;

      ABitmap.Canvas.Pen.Color := Darker(tmpColor.Color, 20);
      ABitmap.Canvas.RoundRect(r.Left, r.Top, r.Right, r.Bottom, 0, 0);
      //ABitmap.Canvas.Rectangle(r);
      Inc(x, 18);
    end;

  finally

  end;
end;

procedure TfrmSchemeList.AddScheme;
var
  tmpItem: TSchemeItem;
  tmpCol: TSchemeColorItem;
  tmpList: TObjectList;
  Index, i: Integer;
begin

  { tmpItem := TSchemeItem.Create(FSchemeItems);
   tmpItem.Name := 'Untitled';
   tmpItem.Author := 'Anon';
   tmpItem.LoadSkinColorDefaults(FTheme);

   try

     frmEditScheme.Colors := tmpItem.Colors;
     frmEditScheme.SchemeName := tmpItem.Name;
     frmEditScheme.Author := tmpItem.Author;
     frmEditScheme.SchemeItem := tmpItem;
     frmEditScheme.SkinName := FSchemeItems.GetSkinName(FTheme);
     frmEditScheme.Edit := False;

     if frmEditScheme.ShowModal = mrOk then
     begin
       tmpItem.Name := frmEditScheme.EdtSkinName.Text;
       tmpItem.Author := frmEditScheme.EdtAuthor.Text;
       tmpItem.FileName := GetSchemeDirectory + trim(StrRemoveChars(tmpItem.Name,
         ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':'])) + '.xml';

       SchemeItems.Add(tmpItem);

       SharpCenterBroadCast( SCM_EVT_UPDATE_SETTINGS, 1);
       SharpCenterBroadCast( SCM_EVT_UPDATE_PREVIEW, 1);
     end;

   finally
     FreeAndNil(frmEditScheme);
     BuildSchemeList(FTheme);
   end;    }
end;

function TfrmSchemeList.SaveSchemes: Boolean;
var
  tmp: TSchemeItem;
  sDefault: string;
begin
  tmp := TSchemeItem(frmSchemeList.lbSchemeList.
    Item[frmSchemeList.lbSchemeList.ItemIndex].Data);
  sDefault := tmp.Name;

  FSchemeItems.Save;
  FSchemeItems.SaveDefault(FTheme, GetSkinName, sDefault);

  BuildSchemeList(FTheme);
  Result := True;
end;

procedure TfrmSchemeList.CreateColumns;
begin

  lbSchemeList.ItemOffset := Point(0, 0);
  lbSchemeList.ItemHeight := 22;

  with lbSchemeList.AddColumn('Scheme') do
  begin
    Width := lbSchemeList.Width - 150;
    Images := imlCol2;
    VAlign := taVerticalCenter;
  end;
  with lbSchemeList.AddColumn('Author') do
  begin
    Width := 100;
    HAlign := taRightJustify;
    VAlign := taVerticalCenter;
  end;
  with lbSchemeList.AddColumn('Default') do
  begin
    Width := 50;
    Images := imlCol2;
    HAlign := taLeftJustify;
    VAlign := taVerticalCenter;
  end;
end;

procedure TfrmSchemeList.FormResize(Sender: TObject);
var
  n: Integer;
  pct: Double;

const
  Col1 = 150;
  Col2 = 100;
  Col3 = 30;
begin
  if assigned(lbSchemeList) then

    if FSchemeItems.Count > 0 then begin
    if lbSchemeList.ColumnCount = 3 then
    begin

      n := lbSchemeList.Width div 20;

      pct := lbSchemeList.Width / 280;

      lbSchemeList.Column[0].Width := round(pct * Col1);
      lbSchemeList.Column[1].Width := round(pct * Col2);
      lbSchemeList.Column[2].Width := round(pct * Col3);
    end;
    end else begin
      lbSchemeList.Column[0].Width := lbSchemeList.Width;
      lbSchemeList.Column[1].Width := 0;
      lbSchemeList.Column[2].Width := 0;
    end;
end;

procedure TfrmSchemeList.lbSchemeListClickItem(AText: string; AItem,
  ACol: Integer);
begin
  SharpCenterBroadCast( SCM_EVT_UPDATE_PREVIEW, 0);
  SharpCenterBroadCast(SCM_SET_SETTINGS_CHANGED, 0);


  if frmEditScheme <> nil then
  begin
    if frmEditScheme.Edit then
    begin
      frmEditScheme.InitUI(sceEdit);
    end;
  end;

  lbSchemeList.Update;
end;

end.

