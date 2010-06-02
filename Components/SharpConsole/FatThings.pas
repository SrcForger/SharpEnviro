
//***********************************************************************
//**
//** File:		TFatMemo
//**
//** Description:       Memo with Color coding, embedded bitmaps, links
//**                    Orginal by Gasper Kozak (see below). Greatly improved
//**                    (Fixed a lot of bugs, added some feutures)
//**
//**
//** Author:		Malx (Malx@techie.com)
//**
//** Created:		2000-06-12
//**
//** Modified:    *  2001-09-09   Fixed Hints to show instant when you
//**                              move mouse over link."Mailto:" links only
//**                              shows first part in the hint, not subject and so on.
//**
//***********************************************************************
{ ******************************************************************************

  TFatMemo component by Gasper Kozak (gasper.kozak@email.si)
  Ideas and bug reports are most welcome!

  LEGAL INFORMATION.
    The component is FREE FOR USE in ANY kind of projects. You are allowed
    to modify the source at will under condition you leave (this) original
    comment intact.

  FEATURES.
    - Color coding, embedded bitmaps, links
    - Automatic copy-to-clipboard when user presses and drags left mouse button
    - Easy to irc color coding interface

  DOES NOT FEATURE.
    - Editing the text in the window. This feature will never be implemented.



  VERSIONS.
    THIS
      0.95, November 23rd
        NEW THINGS
          colored selection
          vertical scrollbar. Horizontal scrollbar will probably be added some
          time in the future, but it's currently too buggy to be functional

        NEW PROPERTIES
          ScrollBarVert : boolean
            these two properties enable/disable scrollbar in window
          StickText : (stBottom, stNone, stTop)
            replaces FixedBottomLine; if set to stBottom, the text is always
            shown last-line-at-bottom, if it is set to stTop, the test is always
            shown first-line-at-top, otherwise its shown TopIndex-line-at-top

        NEW EVENTS
          OnScrollHoriz, OnScrollVert
            these two events are triggered when corresponding scrollbar is moved

    PREVIOUS
      0.91, May 15th


  KNOWN ISSUES.
    - Slow paint on large window and lots of text

  STATEMENT.
    I do not promise any support or new versions of this component.
    But check www.delphipages.com anyway :)

****************************************************************************** }


  
unit FatThings;

interface

uses Classes, Windows, Graphics, Controls, ExtCtrls,Messages, SysUtils,
  ShellApi, StdCtrls,Forms;

type
  TFatMemo  = class;
  TFatLines = class;
  TFatLine  = class;

  TDrawFlag = (dfDontDraw, dfWordWrap, dfStretchImages, dfAlignMiddle, dfAlignBottom);
  TDrawFlags = set of TDrawFlag;

  TPartType = (ptNone, ptText, ptColor, ptStyle, ptBitmap);

  TDrawInfo = record
    FontColor, BackColor: TColor;
    Style: TFontStyles;
    Canvas: TCanvas;
    Left, Top, LineHeight: Integer;
    Borders: TRect;
    Flags: TDrawFlags;
  end;

  TFatPart = class
  private
    FLine: TFatLine;
    FLink: String;
    FType: TPartType;
    FFontColor, FBackColor: TColor;
    FVisible: Boolean;
    FStyle: TFontStyles;
    FBitmap: TBitmap;
    FOnChange: TNotifyEvent;
    FText: String;
    FUpdateCount: Integer;

    FLastDrawDim: TRect;
    FDrawInfo: TDrawInfo;

    FMouseOver: Boolean;
    CharX, CharY, CharIndex, FWidth, FHeight: Integer;
    FCharRect: TRect;

    procedure NotifyChanged;
    procedure Clear;
  protected
    function GetIndex: Integer;
    procedure SetFontColor(Value: TColor);
    procedure SetBackColor(Value: TColor);
    procedure SetBitmap(Value: TBitmap);
    procedure SetText(Value: String);
    procedure SetLink(Value: String);
    procedure SetStyle(Value: TFontStyles);
    procedure SetVisible(Value: Boolean);

    procedure SetUpdating(Value: Boolean);
    function GetUpdating: Boolean;
  public
    constructor Create(ALine: TFatLine);
    destructor Destroy; override;
    procedure Assign(Source: TFatPart);
    procedure Delete;

    function IsLink: Boolean;
    procedure DoMouseEnter;
    procedure DoMouseMove(X, Y: Integer);
    procedure DoMouseExit;

    procedure RemoveLink(const ALink: String);

    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);

    procedure PaintTo(Canvas: TCanvas; var Left, Top: Integer; const LineHeight: Integer; Borders: TRect; Flags: TDrawFlags);
    procedure Repaint;
    function Size: Integer;

    function PointInside(X, Y: Integer): Boolean;
    function PointOverChar(X, Y: Integer; var CharRect: TRect): Integer;

    property Updating: Boolean read GetUpdating write SetUpdating;
    property MouseOver: Boolean read FMouseOver;
    property Index: Integer read GetIndex;
    property FontColor: TColor read FFontColor write SetFontColor;
    property BackColor: TColor read FBackColor write SetBackColor;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property Text: String read FText write SetText;
    property Link: String read FLink write SetLink;
    property Style: TFontStyles read FStyle write SetStyle;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property PartType: TPartType read FType;
    property Visible: Boolean read FVisible write SetVisible;

    property DrawInfo: TDrawInfo read FDrawInfo;
    property LastDrawDim: TRect read FLastDrawDim;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TFatLine = class
  private
    FParts: TList;
    FLines: TFatLines;
    FWidth: Integer;
    FOnChange: TNotifyEvent;
    FMouseOver: Boolean;

    FLastDrawDim: TRect;
    FDrawInfo: TDrawInfo;
    FUpdateCount: Integer;

    procedure NotifyChanged;
    procedure PartChanged(Sender: TObject);
  protected
    function GetIndex: Integer;
    function GetPart(Index: Integer): TFatPart;
    function GetHeight: Integer;
    procedure SetPart(Index: Integer; Value: TFatPart);

    function GetAsText: String;
    procedure SetAsText(Value: String);
    procedure SetUpdating(Value: Boolean);
    function GetUpdating: Boolean;
  public
    constructor Create(ALines: TFatLines);
    destructor Destroy; override;
    procedure Assign(Source: TFatLine);
    procedure Clear;

    function Add: TFatPart;
    function Insert(Index: Integer): TFatPart;
    procedure Delete(Index: Integer);
    function Count: Integer;
    function Size: Integer;
    function PreSize: Integer;

    function PointInside(X, Y: Integer): Boolean;

    procedure DoMouseEnter;
    procedure DoMouseMove(X, Y: Integer);
    procedure DoMouseExit;
    function FindPartAtPos(X, Y: Integer): TFatPart;
    procedure RemoveLinks(const Link: String);
    procedure GetOrigColors(const Index: Integer; var OrigBColor, OrigFColor: TColor);

    procedure PaintTo(Canvas: TCanvas; var Left, Top: Integer; const LineHeight: Integer; Borders: TRect; Flags: TDrawFlags);
    procedure Repaint;

    property Updating: Boolean read GetUpdating write SetUpdating;
    property MouseOver: Boolean read FMouseOver;
    property Parts[Index: Integer]: TFatPart read GetPart write SetPart;
    property Index: Integer read GetIndex;
    property Width: Integer read FWidth;
    property Height: Integer read GetHeight;
    property AsText: String read GetAsText write SetAsText;
    property LastDrawDim: TRect read FLastDrawDim;
    property DrawInfo: TDrawInfo read FDrawInfo;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TFatLines = class
  private
    FItems: TList;
    FMemo: TFatMemo;
    FOnChange: TNotifyEvent;

    procedure NotifyChanged;
    procedure LineChanged(Sender: TObject);
  protected
    function GetItem(Index: Integer): TFatLine;
    procedure SetItem(Index: Integer; Value: TFatLine);
  public
    constructor Create(AMemo: TFatMemo);
    destructor Destroy; override;
    procedure Assign(Source: TFatLines);
    procedure Clear;
    procedure Delete(Index: Integer);
    function Count: Integer;
    function AddNew: TFatLine;
    function InsertNew(Index: Integer): TFatLine;
    function Add(S: String): Integer;
    function AddLineWithIrcTags(S: String): Integer;
    procedure RemoveLinks(const Link: String);

    function HeightLines: Integer;
    function Height: Integer;

    property Memo: TFatMemo read FMemo write FMemo;
    property Items[Index: Integer]: TFatLine read GetItem write SetItem; default;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TFormBorderStyle = (bsNone, bsSingle, bsSizeable, bsDialog, bsToolWindow, bsSizeToolWin);

  TBorderStyle = bsNone..bsSingle;

  TOnLinkClick = procedure(Sender: TObject; Link: String) of object;

  TSelPos = record
    LineIdx, PartIdx, CharIdx: Integer;
    Pos: TPoint;
  end;

  TStickText = (stTop, stNone, stBottom);

  TFatMemo = class(TCustomControl)
  private
    FBarVert, FBarHoriz: TScrollBar;
    FBorderStyle: TBorderStyle;
    FColor: TColor;
    FLineHeight, FTopIndex: Integer;
    FStickText: TStickText;
    FLines: TFatLines;
    FOverPart: TFatPart;
    FOverLine: TFatLine;
    FDrawFlags: TDrawFlags;
    FMousePos: TPoint;
    FSelecting: Boolean;
    FSelStart, FSelEnd: TSelPos;
    FAdjusting, FClick: Boolean;
    FClear,Faddline   : Boolean;
    FOnChange: TNotifyEvent;
    FOnMouseIn, FOnMouseOut: TNotifyEvent;
    FOnLinkClick: TOnLinkClick;
    FOnScrollVert, FOnScrollHoriz: TNotifyEvent;
  protected
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetColor(Value: TColor);
    function GetBarVert: Boolean;
    procedure SetBarVert(const Value: Boolean);
    function GetBarHoriz: Boolean;
    procedure SetBarHoriz(const Value: Boolean);

    procedure SetTopIndex(Value: Integer);
    procedure SetLineHeight(Value: Integer);
    procedure SetDrawFlags(Value: TDrawFlags);
    procedure SetStickText(Value: TStickText);
    procedure RemoveLinks(const Link: String);

    procedure BarVertChanged(Sender: TObject);
    procedure BarHorizChanged(Sender: TObject);
    procedure LinesChanged(Sender: TObject);
    function FindLineAtPos(X, Y: Integer): TFatLine;

    procedure CMMouseEnter(var M: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var M: TMessage); message CM_MOUSELEAVE;
    procedure GetOverInfo(X, Y: Integer);
  public
     FMaxLines : integer;
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    procedure PaintTo(Canvas: TCanvas; const BlindDraw, OverDraw: Boolean);
    destructor Destroy; override;


    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Click; override;
    property Selecting: Boolean read FSelecting;
    property addline: Boolean read Faddline write Faddline;
    property Lines: TFatLines read FLines write FLines;
    property OverLine: TFatLine read FOverLine;
    property OverPart: TFatPart read FOverPart;
    property SelStart: TSelPos read FSelStart;
    property SelEnd: TSelPos read FSelEnd;

    property BarVert: TScrollBar read FBarVert;
    property BarHoriz: TScrollBar read FBarHoriz;
  published
    property Align;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property Hint;
    property ClientWidth;
    property ClientHeight;
    property MaxLines:integer read FMaxLines write FMaxLines default 100;
    property Color: TColor read FColor write SetColor;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle;
    property TopIndex: Integer read FTopIndex write SetTopIndex;
    property LineHeight: Integer read FLineHeight write SetLineHeight;
    property DrawFlags: TDrawFlags read FDrawFlags write SetDrawFlags;
    property StickText: TStickText read FStickText write SetStickText;
    property PopupMenu;
    property OnLinkClick: TOnLinkClick read FOnLinkClick write FOnLinkClick;
    property OnMouseIn: TNotifyEvent read FOnMouseIn write FOnMouseIn;
    property OnMouseOut: TNotifyEvent read FOnMouseOut write FOnMouseOut;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property ScrollBarVert: Boolean read GetBarVert write SetBarVert;
    property ScrollBarHoriz: Boolean read GetBarHoriz write SetBarHoriz;

    property OnScrollVert: TNotifyEvent read FOnScrollVert write FOnScrollVert;
    property OnScrollHoriz: TNotifyEvent read FOnScrollHoriz write FOnScrollHoriz;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
    property OnDblClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp; 
  end;



function PointInDrawDim(P: TPoint; DrawDim: TRect; LineHeight: Integer; Borders: TRect): Boolean;

procedure Register;

implementation
uses main;
const
  CalText     = 'C|M´';
procedure Register;
begin
  RegisterComponents('Fat', [TFatMemo]);
end;

function PointInDrawDim(P: TPoint; DrawDim: TRect; LineHeight: Integer; Borders: TRect): Boolean;
begin
  Result := False;

  if NOT PtInRect(Borders, P) then
    Exit;

  if NOT ((P.y >= DrawDim.Top) and (P.y < DrawDim.Bottom)) then
    Exit;

  if P.x >= DrawDim.Left then
    begin
      if P.x < DrawDim.Right then
        begin
          Result := True;
        end else
          Result := P.y < DrawDim.Bottom - LineHeight;
    end else
    begin
      if P.x <= DrawDim.Right then
        begin
          Result := P.y >= DrawDim.Top + LineHeight;
        end else
          Result := (P.y < DrawDim.Bottom - LineHeight) and (P.y > DrawDim.Top + LineHeight);
    end;
end;


constructor TFatPart.Create(ALine: TFatLine);
begin
  inherited Create;

  FLine := ALine;
  FUpdateCount := 0;
  FVisible := True;
  Clear;
end;

procedure TFatPart.Clear;
begin
  FType := ptNone;
  FText := '';
  FStyle := [];
  FBitmap := NIL;
  FLink := '';
  FFontColor := clNone;
  FBackColor := clNone;
end;

destructor TFatPart.Destroy;
begin
  inherited;
end;

procedure TFatPart.Assign(Source: TFatPart);
begin
  FText := Source.Text;
  FStyle := Source.Style;
  FBitmap := Source.Bitmap;
  FFontColor := Source.FontColor;
  FBackColor := Source.BackColor;
  FType := Source.FType;

  NotifyChanged;
end;

function TFatPart.IsLink: Boolean;
begin
  Result := FLink <> '';
end;

procedure TFatPart.NotifyChanged;
begin
  if Assigned(FOnChange) and NOT Updating then
    FOnChange(Self);
end;

function TFatPart.GetIndex: Integer;
begin
  Result := FLine.FParts.IndexOf(Self);
end;

procedure TFatPart.Delete;
begin
  FLine.Delete(Index);
end;

procedure TFatPart.SetFontColor(Value: TColor);
var PrevBackColor: TColor;
begin
  if (FFontColor <> Value) or (PartType <> ptColor) then
    begin
      PrevBackColor := FBackColor;
      Clear;
      FBackColor := PrevBackColor;

      FFontColor := Value;
      FType := ptColor;

      NotifyChanged;
    end;
end;

procedure TFatPart.SetBackColor(Value: TColor);
var PrevFontColor: TColor;
begin
  if (FBackColor <> Value) or (PartType <> ptColor) then
    begin
      PrevFontColor := FFontColor;
      Clear;
      FFontColor := PrevFontColor;

      FBackColor := Value;
      FType := ptColor;

      NotifyChanged;
    end;
end;

procedure TFatPart.SetBitmap(Value: TBitmap);
begin
  if (FBitmap <> Value) or (PartType <> ptBitmap) then
    begin
      FBitmap := Value;
      FType := ptBitmap;

      NotifyChanged;
    end;
end;

procedure TFatPart.SetLink(Value: String);
begin
  if FLink <> Value then
    begin
      FLink := Value;
      NotifyChanged;
    end;
end;

procedure TFatPart.SetText(Value: String);
begin
  if (FText <> Value) or (PartType <> ptText) then
    begin
      Clear;
      FType := ptText;
      FText := Value;
      NotifyChanged;
    end;
end;

procedure TFatPart.SetStyle(Value: TFontStyles);
begin
  if (FStyle <> Value) or (PartType <> ptStyle) then
    begin
      Clear;
      FType := ptStyle;
      FStyle := Value;
      NotifyChanged;
    end;
end;

procedure TFatPart.SetVisible(Value: Boolean);
begin
  if (FVisible <> Value) and (PartType in [ptText, ptBitmap]) then
    begin
      FVisible := Value;
      NotifyChanged;
    end;
end;

procedure TFatPart.SetUpdating(Value: Boolean);
var PrevUpdateCount: Integer;
begin
  PrevUpdateCount := FUpdateCount;

  if Value then
    Inc(FUpdateCount) else
    if FUpdateCount > 0 then
    Dec(FUpdateCount);

  if PrevUpdateCount <> FUpdateCount then
    NotifyChanged;
end;

function TFatPart.GetUpdating: Boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TFatPart.DoMouseEnter;
var point : TPoint;
    temp  : string;
      i   : integer;
begin
  FMouseOver := True;

  if IsLink then
    begin
      FLine.FLines.FMemo.Cursor := crHandPoint;
      SharpConsoleWnd.textmemo.SetFocus;
      i := 1;
      temp := '';
      while (i <= length(Flink)) and (Flink[i] <> '?') do begin
        temp := temp + Flink[i];
        inc(i);
      end;
      SharpConsoleWnd.textmemo.hint := Temp;
      SharpConsoleWnd.textmemo.ShowHint := true;
      getcursorpos(point);
      application.ActivateHint(point);
     end;


end;

procedure TFatPart.DoMouseMove(X, Y: Integer);
begin
   
end;

procedure SaveBitmapToStream(Bitmap: TBitmap; Stream: TStream);
var S: TStream;
  Size: Integer;
begin
  S := TMemoryStream.Create;
  try
    Bitmap.SaveToStream(S);
    Size := S.Size;
    S.Seek(0, soFromBeginning);

    Stream.Write(Size, SizeOf(Integer));
    Stream.CopyFrom(S, Size);
  finally
    S.Free;
  end;
end;

procedure LoadBitmapFromStream(Bitmap: TBitmap; Stream: TStream);
var S: TStream;
  Size: Integer;
begin
  Stream.Read(Size, SizeOf(Integer));
  S := TMemoryStream.Create;
  try
    Bitmap.SaveToStream(S);
    Size := S.Size;
    S.Seek(0, soFromBeginning);

    Stream.Write(Size, SizeOf(Integer));
    Stream.CopyFrom(S, Size);
  finally
    S.Free;
  end;
end;

function ReadStringFromStream(Stream: TStream; var S: String): Integer;
var Len: Byte;
begin
  try
    with Stream do
      begin
        Read(Len, 1);
        Seek( - 1, soFromCurrent);
        Read(S, Len + 1);
      end;
    Result := Len;
  except
    Result := 0;
  end;
end;

function WriteStringToStream(Stream: TStream; S: String): Integer;
var Len: Byte;
begin
  try
    Len := Length(S);
    with Stream do
      begin
        Write(S, Len + 1);
      end;
    Result := Len;
  except
    Result := 0;
  end;
end;

procedure TFatPart.SaveToStream(S: TStream);
begin
  S.Write(FType, SizeOf(TPartType));
  case FType of
    ptText:
      begin
        S.Write(Text, Length(Text) + 1);
        S.Write(Link, Length(Link) + 1);
      end;
    ptColor:
      begin
        S.Write(FFontColor, SizeOf(TColor));
        S.Write(FBackColor, SizeOf(TColor));
      end;
    ptStyle:
      begin
        S.Write(FStyle, SizeOf(TFontStyles));
      end;
    ptBitmap:
      begin
      end;
    ptNone:
      begin
      end;
  end;
end;

procedure TFatPart.LoadFromStream(S: TStream);
begin
end;

procedure TFatPart.RemoveLink(const ALink: String);
begin
  if IsLink and ((UpperCase(ALink) = UpperCase(Link)) or (ALink = '')) then
    begin
      if Bitmap <> NIL then
        FType := ptBitmap else
      if Text <> '' then
        FType := ptText else
        FType := ptNone;

      Link := '';
    end;
end;

procedure TFatPart.DoMouseExit;
begin
  try
  FMouseOver := False;

  if IsLink then
    begin
      FLine.FLines.FMemo.Cursor := crDefault;
      SharpConsoleWnd.textmemo.hint := '';
      application.HideHint;
    end;
  except
  end;
end;

function TFatPart.PointInside(X, Y: Integer): Boolean;
begin
  if (LastDrawDim.Left = LastDrawDim.Right) and
    (LastDrawDim.Top + DrawInfo.LineHeight = LastDrawDim.Bottom) then
    Result := False else
    Result := PointInDrawDim(Point(X, Y), LastDrawDim, DrawInfo.LineHeight, DrawInfo.Borders);
end;

function TFatPart.PointOverChar(X, Y: Integer; var CharRect: TRect): Integer;
var ALeft, ATop: Integer;
begin
  Result := 0;
  if PartType in [ptNone, ptColor, ptStyle, ptBitmap] then
    Exit;

  with DrawInfo do
    begin
      ALeft := Left;
      ATop := Top;
      with Canvas do
        begin
          Font.Color := FontColor;
          Brush.Color := BackColor;
          Font.Style := Style;
        end;

      CharX := X;
      CharY := Y;

      Flags := Flags + [dfDontDraw];
      PaintTo(Canvas, ALeft, ATop, LineHeight, Borders, Flags);
      Flags := Flags - [dfDontDraw];

      Result := CharIndex;
      CharRect := FCharRect;
    end;
end;

function TFatPart.Size: Integer;
begin
  case PartType of
    ptText: Result := Length(FText);
    else Result := 0;
  end;
end;

procedure TFatPart.Repaint;
var ALeft, ATop: Integer;
begin
  with DrawInfo do
    begin
      ALeft := Left;
      ATop := Top;
      with Canvas do
        begin
          Font.Color := FontColor;
          Brush.Color := BackColor;
          Font.Style := Style;
        end;

      PaintTo(Canvas, ALeft, ATop, LineHeight, Borders, Flags);
    end;
end;

function PaintTextSimple(Text: String; Canvas: TCanvas; var Left, Top: Integer;
  const LineHeight: Integer; const Borders: TRect; const Flags: TDrawFlags; var DrawDim: TRect;
  const X, Y, SStart, SEnd: Integer; var CharRect: TRect; const OrigBCol, OrigFCol: TColor): Integer;
var FWidth, FTextHeight, DrawTop, DrawBottom: Integer;
  DrawRect: TRect;
  Len, I: Integer;
  S1, S2, S3: String;
  R1, R2, R3: TRect;
begin
  Result := 0;
  if Text = '' then
    Exit;

  FWidth := Canvas.TextWidth(Text);
  FTextHeight := Canvas.TextHeight(CalText);

  if dfAlignBottom in Flags then
    DrawTop := Top + LineHeight - FTextHeight else
  if dfAlignMiddle in Flags then
    DrawTop := (Top + LineHeight div 2) - (FTextHeight div 2) else
    DrawTop := Top;

  DrawBottom := DrawTop + FTextHeight;
  DrawRect := Rect(Left, DrawTop, Left + FWidth, DrawBottom);
  IntersectRect(DrawRect, DrawRect, Borders);
  if NOT (dfDontDraw in Flags) then
    begin
      if (SStart = 0) and (SEnd = 0) then
        Canvas.TextRect(DrawRect, Left, DrawTop, Text) else
        begin
          S1 := Copy(Text, 1, SStart - 1);
          R1 := DrawRect;
          R1.Right := R1.Left + Canvas.TextWidth(S1);

          S2 := Copy(Text, SStart, SEnd - SStart + 1);
          R2 := DrawRect;
          R2.Left := R1.Right;
          R2.Right := R2.Left + Canvas.TextWidth(S2);

          S3 := Copy(Text, SEnd + 1, Length(Text));
          R3 := DrawRect;
          R3.Left := R2.Right;
          R3.Right := R3.Left + Canvas.TextWidth(S3);

          if S1 <> '' then
            Canvas.TextRect(R1, Left, DrawTop, S1);

          Canvas.Brush.Color := clBlack;
          Canvas.Font.Color := clWhite;

          if S2 <> '' then
            Canvas.TextRect(R2, Left + Canvas.TextWidth(S1), DrawTop, S2);

          Canvas.Brush.Color := OrigBCol;
          Canvas.Font.Color := OrigFCol;

          if S3 <> '' then
            Canvas.TextRect(R3, Left + Canvas.TextWidth(S1) + Canvas.TextWidth(S2), DrawTop, S3);
        end;
    end;

  if (X <> 0) and (Y <> 0) then
    begin
      Len := Length(Text);
      for I := 1 to Len do
        if (Left + Canvas.TextWidth(Copy(Text, 1, I)) > X) and (Y >= DrawTop) and (Y < DrawBottom) then
          begin
            CharRect := Rect(
              Left + Canvas.TextWidth(Copy(Text, 1, I - 1)),
              DrawTop,
              Canvas.TextWidth(Copy(Text, 1, I)),
              DrawBottom);

            Result := I;
            Break;
          end;
    end;

  DrawDim.Left := Left;
  Left := Left + FWidth;
  DrawDim.Top := DrawTop;
  DrawDim.Bottom := DrawBottom;
  DrawDim.Right := Left;
end;

const
  WrapChars = ' ,.!?\|/;:';

function FindWrapCharBackward(const S: String): Integer;
var Allc, Ic, All, I, P: Integer;
  Z: String;
begin
  Result := 0;
  All := Length(S);
  if All = 0 then
    Exit;

  Z := '';
  for I := 1 to All do
    Z := S[I] + Z;

  Allc := Length(WrapChars);
  for Ic := 1 to Allc do
    begin
      P := Pos(WrapChars[Ic], Z);
      if P > 0 then
        begin
          Result := Length(S) - P + 1;
          Exit;
        end;
    end;
end;

function FindWrapCharForward(const S: String): Integer;
var Allc, Ic, All, P: Integer;
begin
  Result := 0;
  All := Length(S);
  if All = 0 then
    Exit;

  Allc := Length(WrapChars);
  for Ic := 1 to Allc do
    begin
      P := Pos(WrapChars[Ic], S);
      if P > 0 then
        begin
          Result := Length(S) - P + 1;
          Exit;
        end;
    end;
end;

function PaintTextWrap(Text: String; Canvas: TCanvas; var Left, Top: Integer;
  const LineHeight: Integer; const Borders: TRect; const Flags: TDrawFlags; var DrawDim: TRect;
  const X, Y, SelStart, SelEnd: Integer; var CharRect: TRect; const OrigBCol, OrigFCol: TColor): Integer;
var
  Cnt, I, All, SmallCharIdx, CharIdx: Integer;
  AllText, TextFit: String;
  GotCharIdx, Wrap: Boolean;
  R: TRect;
begin
  Result := 0;

  AllText := Text;
  if Text = '' then
    Exit;

  Cnt := 1;
  CharIdx := 0;
  GotCharIdx := False;

  repeat
    All := Length(AllText);
    if All = 0 then
      Exit;

    Wrap := False;
    I := 1;
    repeat
      TextFit := Copy(AllText, 1, I);

      if Left + Canvas.TextWidth(TextFit) > Borders.Right then
        begin
          Wrap := True;
          Dec(I);
        end else
        Inc(I);
    until (I > All) or Wrap;

    if Wrap then
      begin
        if I = 0 then
          begin
            Left := Borders.Left;
            Top := Top + LineHeight;
            Continue;
          end;

        TextFit := Copy(AllText, 1, I);
      end;

    SmallCharIdx := PaintTextSimple(TextFit, Canvas, Left, Top, LineHeight, Borders, Flags, R,
      X, Y, SelStart, SelEnd, CharRect, OrigBCol, OrigFCol);
    if (X <> 0) and (Y <> 0) and NOT GotCharIdx then
      begin
        if SmallCharIdx = 0 then
          CharIdx := CharIdx + Length(TextFit) else
          begin
            CharIdx := CharIdx + SmallCharIdx;
            Result := CharIdx;
            GotCharIdx := True;
          end;
      end;

    if Cnt = 1 then
      begin
        DrawDim.Left := R.Left;
        DrawDim.Top := R.Top;
      end else
      begin
        DrawDim.Right := R.Right;
        DrawDim.Bottom := R.Bottom;
      end;

    Delete(AllText, 1, Length(TextFit));

    if AllText <> '' then
      begin
        Left := Borders.Left;
        Top := Top + LineHeight;
      end;

    Inc(Cnt);
  until TextFit = '';
end;

procedure TFatPart.PaintTo(Canvas: TCanvas; var Left, Top: Integer; const LineHeight: Integer; Borders: TRect; Flags: TDrawFlags);
var DrawRect: TRect;
  I, SStart, SEnd, DrawTop, DrawBottom: Integer;
  Memo: TFatMemo;
  Selected: Boolean;
  OrigBCol, OrigFCol: TColor;
begin
  FDrawInfo.FontColor := Canvas.Font.Color;
  FDrawInfo.BackColor := Canvas.Brush.Color;
  FDrawInfo.Style := Canvas.Font.Style;
  FDrawInfo.Canvas := Canvas;
  FDrawInfo.Left := Left;
  FDrawInfo.Top := Top;
  FDrawInfo.LineHeight := LineHeight;
  FDrawInfo.Borders := Borders;
  FDrawInfo.Flags := Flags;

  FLastDrawDim := Rect(Left, Top, Left, Top + LineHeight);

  case FType of
    ptNone: Exit;
    ptText:
      begin
        FWidth := Canvas.TextWidth(Text);
        FHeight := Canvas.TextHeight(Text);

        if NOT FVisible then
          Flags := Flags + [dfDontDraw];

        Selected := False;
        Memo := FLine.FLines.Memo;
        if Size > 0 then
          for I := 1 to Size do
            begin
              Selected := false;
              if Selected then
                Break;
            end;

        if Selected then
          begin
            if (Memo.SelStart.LineIdx = FLine.Index) and (Memo.SelStart.PartIdx = Index) then
              SStart := Memo.SelStart.CharIdx else
              SStart := 1;

            if (Memo.SelEnd.LineIdx = FLine.Index) and (Memo.SelEnd.PartIdx = Index) then
              SEnd := Memo.SelEnd.CharIdx else
              SEnd := Size;
          end else
          begin
            SStart := 0;
            SEnd := 0;
          end;

        FLine.GetOrigColors(Index, OrigBCol, OrigFCol);
        if (dfWordWrap in Flags) and (Left + FWidth > Borders.Right) then
          CharIndex := PaintTextWrap(Text, Canvas, Left, Top, LineHeight, Borders,
            Flags, FLastDrawDim, CharX, CharY, SStart, SEnd, FCharRect, OrigBCol, OrigFCol) else
          CharIndex := PaintTextSimple(Text, Canvas, Left, Top, LineHeight, Borders,
            Flags, FLastDrawDim, CharX, CharY, SStart, SEnd, FCharRect, OrigBCol, OrigFCol);
      end;
    ptColor:
      begin
        if NOT (dfDontDraw in Flags) then
          begin
            if FontColor <> clNone then
              Canvas.Font.Color := FontColor;

            if BackColor <> clNone then
              Canvas.Brush.Color := BackColor;
          end;

        FWidth := 0;
        FHeight := 0;
      end;
    ptStyle:
      begin
        if NOT (dfDontDraw in Flags) then
          Canvas.Font.Style := Style;

        FWidth := 0;
        FHeight := 0;
      end;
    ptBitmap:
      begin
        if FBitmap = NIL then
          Exit;

        FWidth := FBitmap.Width;
        FHeight := FBitmap.Height;

        if NOT (dfDontDraw in Flags) then
          begin
            if (dfWordWrap in Flags) and (Left + FWidth > Borders.Right) then
              begin
                Top := Top + LineHeight;
                Left := Borders.Left;
                FLastDrawDim := Rect(Left, Top, Left, Top + LineHeight);
              end;

            if NOT (dfStretchImages in Flags) then
              begin
                if dfAlignBottom in Flags then
                  DrawTop := Top + LineHeight - Bitmap.Height else
                if dfAlignMiddle in Flags then
                  DrawTop := (Top + LineHeight div 2) - (FHeight div 2) else
                  DrawTop := Top;

                DrawBottom := DrawTop + FHeight;
                DrawRect := Rect(Left, DrawTop, Left + FWidth, DrawBottom);
              end else
              begin
                DrawRect := Rect(Left, Top+1, Left + FWidth, Top + LineHeight+1);

                DrawTop := DrawRect.Top;
                DrawBottom := DrawRect.Bottom;
              end;

            IntersectRect(DrawRect, DrawRect, Borders);
            if FVisible then
              Canvas.StretchDraw(DrawRect, Bitmap);

            FLastDrawDim.Top := DrawTop;
            FLastDrawDim.Bottom := DrawBottom;
            FLastDrawDim.Right := FLastDrawDim.Right + FWidth;
            Left := Left + FWidth;
          end;
      end;
  end;
end;






constructor TFatLine.Create(ALines: TFatLines);
begin
  inherited Create;

  FUpdateCount := 0;
  FParts := TList.Create;
  FLines := ALines;
end;

destructor TFatLine.Destroy;
begin
  Clear;
  FParts.Free;

  inherited;
end;

procedure TFatLine.Clear;
var All, I: Integer;
begin
  updating := true;
  All := FParts.Count;
  if All = 0 then
    Exit;

  for I := All - 1 downto 0 do
    Delete(I);

  FWidth := 0;
  updating := false;
end;

procedure TFatLine.PartChanged(Sender: TObject);
begin
  NotifyChanged;
end;

procedure TFatLine.NotifyChanged;
begin
  if Assigned(FOnChange) and NOT Updating then
    FOnChange(Self);
end;

function TFatLine.GetUpdating: Boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TFatLine.SetUpdating(Value: Boolean);
var PrevUpdateCount: Integer;
begin
  PrevUpdateCount := FUpdateCount;

  if Value then
    Inc(FUpdateCount) else
    if FUpdateCount > 0 then
    Dec(FUpdateCount);

  if PrevUpdateCount <> FUpdateCount then
    NotifyChanged;
end;

procedure TFatLine.Assign(Source: TFatLine);
var All, I: Integer;
begin
  Clear;

  All := Source.Count;
  for I := 0 to All - 1 do
    Add.Assign(Source.Parts[I]);
end;

function TFatLine.Count: Integer;
begin
  Result := FParts.Count;
end;

function TFatLine.GetPart(Index: Integer): TFatPart;
begin
  Result := TFatPart(FParts[Index]);
end;

procedure TFatLine.SetPart(Index: Integer; Value: TFatPart);
begin
  FParts[Index] := Value;
end;

function TFatLine.GetAsText: String;
var All, I: Integer;
begin
  Result := '';
  All := Count;
  if All = 0 then
    Exit;

  for I := 0 to All - 1 do
    Result := Result + Parts[I].Text;
end;



procedure TFatLine.SetAsText(Value: String);
begin
  Clear;
  Add.Text := Value;
end;

function TFatLine.PreSize: Integer;
var I: Integer;
begin
  Result := 0;
  if (FLines.Count = 0) or (Index = 0) then
    Exit;

  for I := 0 to Index - 1 do
    Result := Result + FLines[I].Size;
end;

function TFatLine.Size: Integer;
var I: Integer;
begin
  Result := 0;
  if Count = 0 then
    Exit;

  for I := 0 to Count - 1 do
    Result := Result + Parts[I].Size;
end;

function TFatLine.Add: TFatPart;
begin
  Result := TFatPart.Create(Self);
  Result.OnChange := PartChanged;
  FParts.Add(Result);

  NotifyChanged;
end;

function TFatLine.Insert(Index: Integer): TFatPart;
begin
  Result := TFatPart.Create(Self);
  FParts.Insert(Index, Result);

  NotifyChanged;
end;

function TFatLine.GetHeight: Integer;
begin
  Result := LastDrawDim.Bottom - LastDrawDim.Top;
end;

procedure TFatLine.Delete(Index: Integer);
var Part: TFatPart;
begin
  Part := Parts[Index];
  Part.Updating := True;
  Part.Free;

  FParts.Delete(Index);

  NotifyChanged;
end;

function TFatLine.PointInside(X, Y: Integer): Boolean;
begin
  if (LastDrawDim.Left = LastDrawDim.Right) and
    (LastDrawDim.Top + DrawInfo.LineHeight = LastDrawDim.Bottom) then
    Result := False else
    Result := PointInDrawDim(Point(X, Y), LastDrawDim, DrawInfo.LineHeight, DrawInfo.Borders);
end;

procedure TFatLine.DoMouseEnter;
begin
  FMouseOver := True;
end;

procedure TFatLine.DoMouseMove(X, Y: Integer);
begin
end;

procedure TFatLine.DoMouseExit;
begin
  FMouseOver := False;
end;

procedure TFatLine.Repaint;
var ALeft, ATop: Integer;
begin
  with DrawInfo do
    begin
      ALeft := Left;
      ATop := Top;

      with Canvas do
        begin
          Font.Color := FontColor;
          Brush.Color := BackColor;
          Font.Style := Style;
        end;

      PaintTo(Canvas, ALeft, ATop, LineHeight, Borders, Flags);
    end;
end;

procedure TFatLine.PaintTo(Canvas: TCanvas; var Left, Top: Integer; const LineHeight: Integer; Borders: TRect; Flags: TDrawFlags);
var All, I, PrevLeft, PrevTop: Integer;
begin
  FDrawInfo.FontColor := Canvas.Font.Color;
  FDrawInfo.BackColor := Canvas.Brush.Color;
  FDrawInfo.Style := Canvas.Font.Style;
  FDrawInfo.Canvas := Canvas;
  FDrawInfo.Left := Left;
  FDrawInfo.Top := Top;
  FDrawInfo.LineHeight := LineHeight;
  FDrawInfo.Borders := Borders;
  FDrawInfo.Flags := Flags;

  PrevLeft := Left;
  PrevTop := Top;

  FWidth := 0;
  All := FParts.Count;
  for I := 0 to All - 1 do
    begin
      Parts[I].PaintTo(Canvas, Left, Top, LineHeight, Borders, Flags);
      FWidth := FWidth + Parts[I].Width;
    end;

  FLastDrawDim := Rect(PrevLeft, PrevTop, Left, Top + LineHeight);
  Top := Top + LineHeight;
end;

function TFatLine.GetIndex: Integer;
begin
  Result := FLines.FItems.IndexOf(Self);
end;

procedure TFatLine.RemoveLinks(const Link: String);
var All, I: Integer;
begin
  All := Count;
  if All <= 0 then
    Exit;

  for I := 0 to All - 1 do
    Parts[I].RemoveLink(Link);
end;

procedure TFatLine.GetOrigColors(const Index: Integer; var OrigBColor, OrigFColor: TColor);
var I: Integer;
  C1, C2: Boolean;
begin
  OrigBColor := FDrawInfo.BackColor;
  OrigFColor := FDrawInfo.FontColor;
  if (Index <= 0) or (Index >= Count) then
    Exit;

  C1 := False;
  C2 := False;
  I := Index;
  repeat
    if Parts[I].PartType = ptColor then
      begin
        if Parts[I].BackColor <> clNone then
          begin
            OrigBColor := Parts[I].BackColor;
            C1 := True;
          end;

        if Parts[I].FontColor <> clNone then
          begin
            OrigFColor := Parts[I].FontColor;
            C2 := True;
          end;

        if C1 and C2 then
          Break;
      end;
    Dec(I);
  until I < 0;
end;

function TFatLine.FindPartAtPos(X, Y: Integer): TFatPart;
var All, I: Integer;
begin
  Result := NIL;

  All := Count;
  if (NOT PointInside(X, Y)) or (All <= 0) then
    Exit;

  for I := All - 1 downto 0 do
    if Parts[I].PointInside(X, Y) then
      begin
        Result := Parts[I];
        Exit;
      end;
end;





constructor TFatLines.Create(AMemo: TFatMemo);
begin
  inherited Create;

  FItems := TList.Create;
  FMemo := AMemo;
end;

destructor TFatLines.Destroy;
begin
  Clear;
  FItems.Free;

  inherited;
end;

procedure TFatLines.Clear;
var All, I: Integer;
   R : Trect;
begin
  Fmemo.FClear := true;
  All := FItems.Count;
  if All = 0 then begin
    FMemo.FClear := false;
    Exit;
  end;
  for I := All - 1 downto 0 do
    Delete(I);
  FMemo.FClear := false;
  Fmemo.FBarVert.Max := 0;
  Fmemo.FBarVert.Position := 0;
  fmemo.FTopIndex := 0;

   R := Fmemo.ClientRect;

  if Fmemo.FBarVert.Visible then
    R.Right := Fmemo.FBarVert.Left - 1;

  if Fmemo.FBarHoriz.Visible then
    R.Bottom := Fmemo.FBarHoriz.Top - 1;

  // Border
  if FMemo.BorderStyle = bsSingle then
    begin
      Frame3D(Fmemo.Canvas, R, clBtnShadow, clWindow, 1);
      Frame3D(Fmemo.Canvas, R, clWindowText, clBtnFace, 1);
    end;

    // Background color
     with Fmemo.Canvas do
     begin
       Brush.Color := Fmemo.Color;
       FillRect(R);
     end;
end;

procedure TFatLines.LineChanged(Sender: TObject);
begin
  if Count > Fmemo.FMaxLines then
    begin
      Delete(0);
      Exit;
    end;

  NotifyChanged;
end;

procedure TFatLines.NotifyChanged;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TFatLines.Assign(Source: TFatLines);
var All, I: Integer;
begin
  Clear;

  All := Source.Count;
  for I := 0 to All - 1 do
    AddNew.Assign(Source.Items[I]);
end;

function TFatLines.GetItem(Index: Integer): TFatLine;
begin
  Result := TFatLine(FItems[Index]);
end;

procedure TFatLines.SetItem(Index: Integer; Value: TFatLine);
begin
  TFatLine(FItems[Index]).Assign(Value);
end;

function TFatLines.Count: Integer;
begin
  Result := FItems.Count;
end;

procedure TFatLines.Delete(Index: Integer);
var Line: TFatLine;
begin
  Line := FItems[Index];
  Line.Updating := True;
  Line.Free;

  FItems.Delete(Index);

  NotifyChanged;
end;

function TFatLines.AddLineWithIrcTags(S: String): Integer;
var Line: TFatLine;
begin
  Line := AddNew;
  Line.Updating := True;
  Result := Line.Index;
  Line.Updating := False;
end;

function TFatLines.AddNew: TFatLine;
begin
  Result := TFatLine.Create(Self);
  Result.OnChange := LineChanged;
  FItems.Add(Result);

  NotifyChanged;
end;

function TFatLines.InsertNew(Index: Integer): TFatLine;
begin
  Result := TFatLine.Create(Self);
  Result.OnChange := LineChanged;
  FItems.Insert(Index, Result);

  NotifyChanged;
end;

function TFatLines.Add(S: String): Integer;
begin
  with AddNew do
    begin
      AsText := S;
      Result := Index;
    end;
end;

procedure TFatLines.RemoveLinks(const Link: String);
var All, I: Integer;
begin
  All := Count;
  if All <= 0 then
    Exit;

  for I := 0 to All - 1 do
    Items[I].RemoveLinks(Link);
end;

function TFatLines.HeightLines: Integer;
var R, Hg, Cnt: Integer;
begin
  if Count > 0 then
    Result := Count - 1 else
    Result := 0;
    
  Exit;
  
  R := 0;
  if Count > 0 then
    begin
      Hg := Height;
      Cnt := Count;
      R := Hg div Cnt;
    end;

  Result := R;
end;

function TFatLines.Height: Integer;
var I, R, Hg: Integer;
begin
  R := 0;
  if Count >0 then
    for I := 0 to Count - 1 do
      begin
        Hg := Items[I].Height;
        R := R + Hg;
      end;

  Result := R;
end;





constructor TFatMemo.Create(AOwner: TComponent);
begin
  inherited;

  Width := 150;
  Height := 100;
  ControlStyle := [csOpaque, csCaptureMouse, csClickEvents, csSetCaption, csDoubleClicks];
  FBorderStyle := bsSingle;
  FColor := clWindow;

  FBarVert := TScrollBar.Create(Self);
  with FBarVert do
    begin
      Max := 0;
      Min := 0;
      Position := 0;
      Parent := Self;
      Align := alRight;
      Kind := sbVertical;
      OnChange := BarVertChanged;
    end;

  FBarHoriz := TScrollBar.Create(Self);
  with FBarHoriz do
    begin
      Max := 0;
      Min := 0;
      Position := 0;
      Parent := Self;
      Align := alBottom;
      Kind := sbHorizontal;
      OnChange := BarHorizChanged;
      Visible := False;
    end;

  if (AOwner is TWinControl) and (Parent = NIL) then
    Parent := TWinControl(AOwner);
  FLines := TFatLines.Create(Self);
  FLines.OnChange := LinesChanged;
  FClear := false;
 
  ParentFont := True;
end;

destructor TFatMemo.Destroy;
begin
  FBarVert.Free;
  FBarHoriz.Free;
  FLines.Free;

  inherited;
end;

procedure TFatMemo.PaintTo(Canvas: TCanvas; const BlindDraw, OverDraw: Boolean);
var R: TRect;
  LinesHi, LinesLo, NewLineHeight,
  I, All, ALeft, AWidth, ATop, AHeight: Integer;
  Flags: TDrawFlags;
  bitmap : Tbitmap;
begin

  if FClear then exit;
  if BlindDraw then
    Flags := FDrawFlags + [dfDontDraw] else
    Flags := FDrawFlags;

  R := ClientRect;

  if FBarVert.Visible then
    R.Right := FBarVert.Left - 1;

  if FBarHoriz.Visible then
    R.Bottom := FBarHoriz.Top - 1;

  NewLineHeight := Canvas.TextHeight(CalText);
  if LineHeight < NewLineHeight then
    LineHeight := NewLineHeight;

  ALeft := R.Left+5 + FBarHoriz.Position;
  Aleft := R.Left+3;
  ATop := R.Top+4;
  AHeight := FLines.HeightLines - (R.Bottom - R.Top-1) div LineHeight;

  if AHeight >= 0 then begin
    if FbarVert.max <> (Aheight+1) then begin
      FBarVert.Max := AHeight+1;
      exit;
    end;
  end
  else begin
    if  FBarVert.Max <> 0 then begin
      FBarVert.Max := 0;
      exit;
    end;
  end;
  Awidth := 0;
  bitmap := Tbitmap.create;
  for I := 0 to Lines.Count - 1 do
    if Lines[I].Width > AWidth then
          AWidth := Lines[I].Width;
   if (Awidth+10 < width) and faddline then bitmap.Width := Awidth+10
   else                     
    bitmap.Width := width-17;

  bitmap.Height := height;

  // Border
  if BorderStyle = bsSingle then
    begin
      Frame3D(bitmap.Canvas, R, clBtnShadow, clWindow, 1);
      Frame3D(bitmap.Canvas, R, clWindowText, clBtnFace, 1);
    end;

  // Background color
  with bitmap.Canvas do
    begin
      Brush.Color := Color;
      if OverDraw then
        FillRect(R);
    end;

  InflateRect(R, - 3, - 4);

  All := Lines.Count;


 if (All = 0) then //or (TopIndex >= Lines.Count) then
 begin
   Topindex := 0;
   canvas.Draw(0,0,bitmap);
   bitmap.Free;
   FBarVert.Max := 0;
   FBarHoriz.Max := 0;
   exit;
  end;

//  AWidth := R.Right - R.Left;

  if StickText = stBottom then
    begin
      LinesHi := Lines.Count-(FBarVert.Max-TopIndex)-1; 

      I := LinesHi;
      ATop := R.Bottom;
      repeat
        bitmap.Canvas.Font.Assign(Font);
        bitmap.Canvas.Brush.Color := Color;

        AHeight := Lines[I].Height;
        ATop := ATop - AHeight;
        //PrevTop := ATop;
        Lines[I].PaintTo(bitmap.Canvas, ALeft, ATop, LineHeight, R, Flags);
        ATop := ATop - Lines[I].Height;

        ALeft := R.Left;
        Dec(I);
      until (I < 0) or (ATop < R.Top);

     // FAdjusting := True;
    //  FBarVert.Position := FBarVert.Max;
    //  FAdjusting := False;
    end else
    begin
      LinesLo := TopIndex;

      I := LinesLo;
      repeat
        bitmap.Canvas.Font.Assign(Font);
        bitmap.Canvas.Brush.Color := Color;

        Lines[I].PaintTo(bitmap.Canvas, ALeft, ATop, LineHeight, R, Flags);
        ALeft := R.Left;
        Inc(I);
      until (I >= All) or (ATop > R.Bottom);
    end;
  canvas.Draw(0,0,bitmap);
  bitmap.Free;

end;

procedure TFatMemo.Paint;
begin
  try
    PaintTo(Canvas, False, True);
  finally
    inherited;
  end;  
end;

procedure TFatMemo.BarVertChanged(Sender: TObject);
begin
  TopIndex := FBarVert.Position;
  if Assigned(FOnScrollVert) then
    FOnScrollVert(Self);
end;

procedure TFatMemo.BarHorizChanged(Sender: TObject);
begin

end;

procedure TFatMemo.LinesChanged(Sender: TObject);
begin
 try
  Paint;
 finally
  if Assigned(FOnChange) then
    FOnChange(Self);
 end;   
end;

procedure TFatMemo.SetColor(Value: TColor);
begin
  if Value <> FColor then
    begin
      FColor := Value;
      Paint;
    end;
end;

procedure TFatMemo.SetBorderStyle(Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
    begin
      FBorderStyle := Value;
      Paint;
    end;
end;

function TFatMemo.GetBarVert: Boolean;
begin
  Result := FBarVert.Visible;
end;

procedure TFatMemo.SetBarVert(const Value: Boolean);
begin
  FBarVert.Visible := Value;
end;

function TFatMemo.GetBarHoriz: Boolean;
begin
  Result := False; //FBarHoriz.Visible;
end;

procedure TFatMemo.SetBarHoriz(const Value: Boolean);
begin
  FBarHoriz.Visible := False;
end;

procedure TFatMemo.SetTopIndex(Value: Integer);
begin
  if (FTopIndex <> Value) and (Value >= 0) and (Value < FLines.Count) and NOT FAdjusting then
    begin
      FTopIndex := Value;
      Paint;
  //    else fPaintorder := false;
    end;
end;

procedure TFatMemo.SetStickText(Value: TStickText);
begin
  if FStickText <> Value then
    begin
      FStickText := Value;
      PaintTo(Canvas, False, True);
    end;
end;

procedure TFatMemo.SetDrawFlags(Value: TDrawFlags);
begin
  if FDrawFlags <> Value then
    begin
      FDrawFlags := Value;
      PaintTo(Canvas, True, True);
    end;
end;

procedure TFatMemo.SetLineHeight(Value: Integer);
begin
  if (FLineHeight <> Value) and (Value > 0) then
    begin
      FLineHeight := Value;
      Paint;
    end;
end;


procedure TFatMemo.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  GetOverInfo(X, Y);
   inherited;
end;

procedure TFatMemo.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
end;

procedure TFatMemo.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  FMousePos := Point(X, Y);
  GetOverInfo(X, Y);
  inherited;
end;

procedure TFatMemo.CMMouseEnter(var M: TMessage);
begin
  inherited;

  Cursor := crDefault;
  MouseMove([], 0, 0);

  if Assigned(FOnMouseIn) then
    FOnMouseIn(Self);
end;

procedure TFatMemo.CMMouseLeave(var M: TMessage);
begin
  inherited;

  MouseMove([], 0, 0);
  Cursor := crDefault;

  if Assigned(FOnMouseOut) then
    FOnMouseOut(Self);
end;

procedure TFatMemo.GetOverInfo(X, Y: Integer);
var FNewOverLine: TFatLine;
  FNewOverPart: TFatPart;
begin

  FNewOverLine := FindLineAtPos(X, Y);
  if FNewOverLine <> NIL then
    begin
      if FNewOverLine <> FOverLine then
        begin
          if FOverLine <> NIL then
            FOverLine.DoMouseExit;

          FOverLine := FNewOverLine;
          FOverLine.DoMouseEnter;
        end;

      FNewOverPart := FOverLine.FindPartAtPos(X, Y);
      if FNewOverPart <> NIL then
        begin
          if FNewOverPart <> FOverPart then
            begin
              if FOverPart <> NIL then
                FOverPart.DoMouseExit;

              FOverPart := FNewOverPart;
              FOverPart.DoMouseEnter;
            end;
        end else
        begin
          Cursor := crDefault;
          if FOverPart <> NIL then
            begin
              FOverPart.DoMouseExit;
              FOverPart := NIL;
            end;
        end;
    end else
    begin
      Cursor := crDefault;

      if FOverPart <> NIL then
        begin
          FOverPart.DoMouseExit;
          FOverPart := NIL;
        end;

      if FOverLine <> NIL then
        begin
          FOverLine.DoMouseExit;
          FOverLine := NIL;
        end;
    end;
end;

function TFatMemo.FindLineAtPos(X, Y: Integer): TFatLine;
var All, I: Integer;
begin
  Result := NIL;
  All := Lines.Count;
  if All <= 0 then
    Exit;

  for I := (All-(FBarVert.Max-FBarVert.position)) - 1 downto 0 do
    if Lines[I].PointInside(X, Y) then
      begin
        Result := Lines[I];
        Exit;
      end;
end;

procedure TFatMemo.RemoveLinks(const Link: String);
begin
  Lines.RemoveLinks(Link);
  MouseMove([], FMousePos.X, FMousePos.Y);
  Paint;
end;

procedure TFatMemo.Click;
var Link: String;
begin
 // if NOT FClick then
  //  Exit;

  FClick := False;

  if (FOverPart <> NIL) and FOverPart.IsLink then
    begin
      Link := FOverPart.Link;
      if Assigned(FOnLinkClick) then
          FOnLinkClick(Self, Link);
    end else
    inherited;
    paint;
end;



end.


