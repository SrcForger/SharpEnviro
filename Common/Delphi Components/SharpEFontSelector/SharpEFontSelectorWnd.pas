unit SharpEFontSelectorWnd;

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
  SharpeColorPicker,
  ExtCtrls,
  SharpApi,
  GR32_RangeBars,
  GR32,
  GR32_Image,
  Spin,
  graphicsfx,
  Menus, ImgList,SharpEFontSelectorFontList;

type
  TDeskFont = record
    Name: string;
    Color: integer;
    Bold: boolean;
    Italic: boolean;
    Underline: boolean;
    AALevel: integer;
    Alpha: integer;
    Size: integer;
    ShadowColor: integer;
    ShadowAlpha: boolean;
    ShadowAlphaValue: integer;
    Shadow: boolean;
  end;

type
  TfrmFontSelector = class(TForm)
    pnlMain: TPanel;
    pnlFonts: TPanel;
    lblFontName: TLabel;
    lblSize: TLabel;
    cbxFontName: TComboBox;
    pnlFontPreview: TPanel;
    imgFontPreview: TImage32;
    pnlFontStyle: TPanel;
    chkBold: TCheckBox;
    chkUnderline: TCheckBox;
    chkItalic: TCheckBox;
    chkShadow: TCheckBox;
    btnOk: TButton;
    btnCancel: TButton;
    chkAlpha: TCheckBox;
    pnlAlphaProps: TPanel;
    gbFontAlpha: TGaugeBar;
    pnlShadowProps: TPanel;
    gbShadowAlpha: TGaugeBar;
    Panel1: TPanel;
    Image2: TImage;
    Label2: TLabel;
    Panel2: TPanel;
    edtSize: TSpinEdit;
    mnuFontPreview: TPopupMenu;
    miGrid: TMenuItem;
    miWhite: TMenuItem;
    miBlack: TMenuItem;
    Panel3: TPanel;
    radBackWhite: TRadioButton;
    radBackCheck: TRadioButton;
    radBackBlack: TRadioButton;
    imlFontIcons: TImageList;
    secFontColor: TSharpEColorPicker;
    secShadowColor: TSharpEColorPicker;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

    procedure secFontColorColorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StateChange(Sender: TObject);
    procedure gbFontAlphaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure gbShadowAlphaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure gbShadowAlphaChange(Sender: TObject);
    procedure gbFontAlphaChange(Sender: TObject);
    procedure JvXPToolButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MoveForm(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbxFontNameDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FFontList:TFontList;
    procedure RefreshFontList;
    //procedure Render
  public
    { Public declarations }
    procedure UpdateFontPreview;
    procedure SelectFont(FontName: string; BuildFonts: Boolean = False);
  end;

  // SharpDesk API
  function RenderText(dst: TBitmap32;
  Font: TDeskFont;
  Text: TStringList;
  Align: integer;
  Spacing: integer): boolean;
  function GetTextSize(Bmp: TBitmap32; pSList: TStringList): TPoint;
  procedure CreateDropShadow(Bmp : TBitmap32; StartX, StartY, sAlpha, color :integer);

  // MultiMon
  function GetCurrentMonitor : integer;
  function PointInRect(P : TPoint; Rect : TRect) : boolean;

var
  frmFontSelector: TfrmFontSelector;

implementation

uses

  SharpEFontSelector;

{$R *.dfm}

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

function GetCurrentMonitor : integer;
var
  n : integer;
  CPos : TPoint;
begin
  CPos := Mouse.Cursorpos;
  for n := 0 to Screen.MonitorCount - 1 do
      if PointInRect(CPos,Screen.Monitors[n].BoundsRect) then
      begin
        result := n;
        exit;
      end;
  // something went wrong and the cursor isn't in any monitor
  result := 0;
end;

procedure CreateDropShadow(Bmp : TBitmap32; StartX, StartY, sAlpha, color :integer);
var
   P: PColor32;
   X,Y,alpha : integer;
   pass : Array of Array of integer;
begin
  sAlpha := 255 - SAlpha;
  with Bmp do
  begin
    setlength(pass,width,height);

    P := PixelPtr[0, 0];
    inc(P,(starty-1)*width+startx);
    for Y := starty to Height - 1 do
    begin
      for X := startx to Width- 1 do
      begin
        alpha := (P^ shr 24);
        if (alpha <> 0) then pass[X,Y] := sAlpha
            else if (X>1) and (Y>1) then
            begin
              pass[X,Y] := round((pass[X-1,Y] + pass[X,Y-1])/2) - 20;
              if pass[X,Y] > sAlpha-1 then pass[X,Y] := sAlpha;
              if pass[X,Y] < 0 then pass[X,Y] := 0;
              P^ := color32(GetRValue(Color),GetGValue(Color),GetBValue(Color),pass[X,Y]);
            end;
        inc(P); // proceed to the next pixel
      end;
      inc(P,startx);
    end;
  end;
end;

function GetTextSize(Bmp: TBitmap32; pSList: TStringList): TPoint;
var
  n: integer;
  w, h: integer;
  nw, nh: integer;
begin
  w := 0;
  h := 0;
  for n := 0 to pSList.Count - 1 do begin
    nw := Bmp.TextWidth(pSList[n]);
    nh := Bmp.TextHeight(pSList[n]);
    if nw > w then
      w := nw;
    h := h + nh;
  end;
  result := Point(w, h);
end;

function RenderText(dst: TBitmap32;
  Font: TDeskFont;
  Text: TStringList;
  Align: integer;
  Spacing: integer): boolean;
var
  p: TPoint;
  n: integer;
  eh: integer;
begin
  if (dst = nil) or (Text = nil) then begin
    RenderText := False;
    exit;
  end;

  dst.Font.Name := Font.Name;
  dst.Font.Color := Font.Color;
  dst.Font.Size := Font.Size;
  dst.Font.Style := [];
  if Font.Bold then
    dst.Font.Style := dst.Font.Style + [fsBold];
  if Font.Italic then
    dst.Font.Style := dst.Font.Style + [fsItalic];
  if Font.Underline then
    dst.Font.Style := dst.Font.Style + [fsUnderline];
  p := GetTextSize(dst, Text);
  p.y := p.y + Text.Count * Spacing;
  eh := dst.TextHeight('SHARPE-WQGgYyqQ') + Spacing;
  dst.SetSize(p.x + 8, p.y + 4);
  dst.Clear(color32(0, 0, 0, 0));
  for n := 0 to Text.Count - 1 do begin
    case Align of
      -1: dst.RenderText(4, n * eh, Text[n], Font.AALevel, color32(Font.Color));
      1: dst.RenderText(dst.Width - 4 - dst.TextWidth(Text[n]), n * eh, Text[n], Font.AALevel,
          color32(Font.Color));
    else
      dst.RenderText(dst.Width div 2 - dst.TextWidth(Text[n]) div 2, n * eh, Text[n], Font.AALevel,
        color32(Font.Color));
    end;
  end;

  if Font.Shadow then
    CreateDropShadow(dst, 0, 1, Font.ShadowAlphaValue, Font.ShadowColor);

  dst.MasterAlpha := Font.Alpha;
  RenderText := True;
end;

procedure TfrmFontSelector.btnOkClick(Sender: TObject);
begin
  ModalResult := MrOk;
end;

procedure TfrmFontSelector.btnCancelClick(Sender: TObject);
begin
  ModalResult := MrCancel;
end;

procedure TfrmFontSelector.secFontColorColorClick(Sender: TObject);
begin
  UpdateFontPreview;
end;

procedure TfrmFontSelector.RefreshFontList;
var
  fi: TFontInfo;
  i: integer;
  DuplicateCheck: Integer;
begin
  FFontList.List.Clear;

  cbxFontName.Items.Clear;
  //cbxFontName.Sorted := True;
  try
    FFontList.RefreshFontInfo;
    for i := 0 To pred(FFontList.List.Count) do begin
      fi := TFontInfo(FFontList.List.Objects[i]);
      DuplicateCheck := cbxFontName.Items.IndexOf(fi.FullName);

      if DuplicateCheck = -1 then
      cbxFontName.Items.Add(FFontList.List.Strings[i]);
    end;
  finally
    cbxFontName.ItemIndex := 0;
  end;

  gbShadowAlphaChange(nil);
  gbFontAlphaChange(nil);
end;

procedure TfrmFontSelector.UpdateFontPreview;
var
  bmp: TBitmap32;
  afont: TDeskFont;
  text: TStringlist;
  x, y: integer;
  c: TColor;
begin
  text := TStringList.Create;
  bmp := TBitmap32.Create;
  try

    afont.Bold := chkBold.Checked;
    afont.Italic := chkItalic.Checked;
    afont.Underline := chkUnderline.Checked;
    afont.Shadow := chkShadow.Checked;
    secFontColor.BackgroundColor := clWindow;

    if chkAlpha.Checked then
      afont.Alpha := gbFontAlpha.Position
    else
      afont.Alpha := 255;

    pnlAlphaProps.Visible := True;
    pnlShadowProps.Visible := True;
    pnlFontStyle.Height := 62;

    // Shadow Not Enabled
    if not(chkShadow.Checked) or not(chkShadow.Visible) then begin
      pnlShadowProps.Visible := False;
      pnlFontStyle.Height := pnlFontStyle.Height - pnlShadowProps.Height;
    end;

    // Alpha Not Enabled
    if not (chkAlpha.Checked) then begin
      pnlAlphaProps.Visible := False;
      pnlFontStyle.Height := pnlFontStyle.Height - pnlAlphaProps.Height;
    end;

    afont.Name := cbxFontName.Text;
    afont.Size := round(edtSize.Value);
    afont.ShadowAlphaValue := 255 - gbShadowAlpha.Position;
    afont.ShadowAlpha := chkShadow.Checked;
    afont.ShadowColor := secShadowColor.Color;
    afont.Color := secFontColor.Color;
    afont.AALevel := 0;

    text.Add('#Environment');
    bmp.SetSize(imgFontPreview.Width + 64, imgFontPreview.Height + 64);

    if radBackWhite.Checked then
      bmp.Clear(color32(clwhite))
    else if radBackBlack.Checked then
      bmp.Clear(color32(clBlack)) else
    begin

    
    for y := 0 to (imgFontPreview.Height - 2) div 12 + 1 do
      for x := 0 to (imgFontPreview.Width - 2) div 12 + 1 do begin
        if (x mod 2) - (y mod 2) = 0 then
          c := darker(clWhite,15)
        else
          c := darker(clWhite,10);
        bmp.FillRect(x * 12, y * 12, x * 12 + 12, y * 12 + 12, color32(c));
      end;
    end;

    imgFontPreview.Bitmap.SetSize(imgFontPreview.Width, imgFontPreview.Height);
    bmp.DrawTo(imgFontPreview.Bitmap, 0, 0);
    renderText(Bmp, afont, text, 0, 0);
    bmp.DrawMode := dmBlend;
    bmp.CombineMode := cmMerge;
    bmp.DrawTo(imgFontPreview.Bitmap, imgFontPreview.Width div 2 - Bmp.Width div 2,
      imgFontPreview.Height div 2 - Bmp.Height div 2);
  finally
    text.Free;
    if bmp <> nil then
      bmp.Free;
  end;

end;

procedure TfrmFontSelector.Button1Click(Sender: TObject);
begin
  UpdateFontPreview;
end;

procedure TfrmFontSelector.StateChange(Sender: TObject);
begin
  UpdateFontPreview;

end;

procedure TfrmFontSelector.SelectFont(FontName: string; BuildFonts: Boolean);
var
  i: integer;
begin
  if BuildFonts then
    RefreshFontList;

  for i := 0 to pred(cbxFontName.Items.Count) do begin
    if lowercase(FontName) = lowercase(cbxFontName.Items[i]) then begin
      cbxFontName.ItemIndex := i;
      UpdateFontPreview;
      exit;
    end;
  end;
end;

procedure TfrmFontSelector.gbFontAlphaMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  UpdateFontPreview;

end;

procedure TfrmFontSelector.gbShadowAlphaMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  UpdateFontPreview;
end;

procedure TfrmFontSelector.gbShadowAlphaChange(Sender: TObject);
begin
  with gbShadowAlpha do begin
    pnlShadowProps.Caption := Format('Shadow Visibility: %d%%', [round((Position * 100) / Max)]);
  end;
end;

procedure TfrmFontSelector.gbFontAlphaChange(Sender: TObject);
begin
  with gbFontAlpha do begin
    pnlAlphaProps.Caption := Format('Font Visibility: %d%%', [round((Position * 100) / Max)]);
  end;
end;

procedure TfrmFontSelector.JvXPToolButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmFontSelector.FormCreate(Sender: TObject);
begin
  pnlFontStyle.DoubleBuffered := True;
  pnlAlphaProps.DoubleBuffered := True;
  pnlShadowProps.DoubleBuffered := True;

  FFontList := TFontList.Create;
end;

procedure TfrmFontSelector.MoveForm(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = $F012;
begin
  ReleaseCapture;
  (Self as TControl).Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
end;

procedure TfrmFontSelector.cbxFontNameDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  fi:TFontInfo;
  imageindex:Integer;
  itemindex: integer;
  textheight: Integer;
begin
  cbxFontName.canvas.fillrect(rect);

  itemindex := FFontList.List.IndexOf(cbxFontName.Items.Strings[index]);
  fi := TFontInfo(FFontList.List.Objects[itemindex]);

  imageindex := -1;
  case fi.FontType of
    ftTrueType : imageindex := 0;
    ftRaster : imageindex := 1;
    ftDevice : imageindex := 2;
  end;

  imlFontIcons.Draw(cbxFontName.Canvas,rect.left,rect.top,imageindex);

  cbxFontName.Canvas.Font.Name := fi.ShortName;
  textheight := cbxFontName.Canvas.TextHeight(fi.FullName);

  if textheight > cbxFontName.ItemHeight then
  cbxFontName.Canvas.Font.Name := 'Arial';

  cbxFontName.canvas.textout(rect.left+imlFontIcons.width+2,rect.top,
                          fi.FullName);
end;


procedure TfrmFontSelector.FormDestroy(Sender: TObject);
begin
  if Assigned(FFontList) Then
  FFontList.Free;
end;

procedure TfrmFontSelector.FormShow(Sender: TObject);
Var
  N: integer;
begin
  // Set Position
    n := GetCurrentMonitor;
    frmFontSelector.Left:=Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - frmFontSelector.Width div 2;
    frmFontSelector.top:=Screen.Monitors[n].Top + Screen.Monitors[n].Height div 2 - frmFontSelector.Height div 2;
end;

end.

