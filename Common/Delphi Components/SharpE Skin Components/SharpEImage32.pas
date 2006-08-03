unit SharpEImage32;

interface

uses
  SysUtils,
  Classes,
  Types,
  Windows,
  Graphics,
  Controls,
  GR32_Image,
  Buttons;

type
  TGlyph32FileName = string;
type
  TSharpEImage32 = class(TImage32)
  private
    { Private declarations }
    FText: string;
    FAlignment: TAlignment;
    procedure SetText(const Value: string);
    procedure SetAlignment(Value: TAlignment);
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Font;
    property Text: string read FText write SetText;
    property Alignment: TAlignment read FAlignment write SetAlignment;
  end;

implementation

procedure TSharpEImage32.SetAlignment(Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TSharpEImage32.Paint;
var
  Rect, RRect: TRect;
  lh: integer;
  Flags: Longint;
const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
  VerticalAlignments: array[TVerticalAlignment] of Longint = (DT_TOP, DT_BOTTOM,
    DT_VCENTER);
begin
  inherited;
  Rect := Self.ClientRect;
  RRect := Rect;

  with Canvas do
  begin
    Font := Self.Font;
    Rect := RRect;

    SetBkMode(Canvas.Handle, TRANSPARENT);
    Flags := DT_EXPANDTABS or DT_WORDBREAK or alignments[FAlignment] or
      DT_CALCRECT;
    DrawText(Handle, PChar(FText), -1, Rect, Flags);
    lh := Rect.Bottom - Rect.Top; //height of text
    if lh < (RRect.Bottom - RRect.Top) then
      RRect.Top := ((RRect.Bottom - RRect.Top) div 2) - (lh div 2);
    Flags := DT_EXPANDTABS or DT_WORDBREAK or alignments[FAlignment];
    Flags := DrawTextBiDiModeFlags(Flags);
    DrawText(Handle, PChar(FText), -1, RRect, Flags);
  end;

end;

procedure TSharpEImage32.SetText(const Value: string);
begin
  FText := Value;
  Invalidate;
end;

constructor TSharpEImage32.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TSharpEImage32.Destroy;
begin
  inherited;
end;

end.
