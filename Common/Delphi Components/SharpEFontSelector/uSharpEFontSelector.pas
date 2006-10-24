unit uSharpEFontSelector;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Buttons,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  SharpApi,
  GR32;

type
  TSEFBackgroundType = (sefbChecker,sefbBlack,sefbWhite);
type
  TSharpEFontProperties = class
  private
    FAlpha: Boolean;
    FShadow: Boolean;
    FBold: Boolean;
    FItalic: Boolean;
    FUnderline: Boolean;
    FShadowAlpha: Boolean;
    FAlphaValue: Integer;
    FShadowAlphaValue: Integer;
    FSize: Integer;
    FAAlevel: Integer;
    FName: string;
    FShadowColor: TColor;
    FColor: TColor;
  public
    property Name: string read FName write FName;
    property Color: TColor read FColor write FColor;
    property Bold: Boolean read FBold write FBold;
    property Italic: Boolean read FItalic write FItalic;
    property Underline: Boolean read FUnderline write FUnderline;
    property AALevel: Integer read FAAlevel write FAALevel;
    property Alpha: Boolean read FAlpha write FAlpha;
    property AlphaValue: Integer read FAlphaValue write FAlphaValue;
    property Size: Integer read FSize write FSize;
    property Shadow: Boolean read FShadow write FShadow;
    property ShadowColor: TColor read FShadowColor write FShadowColor;
    property ShadowAlpha: Boolean read FShadowAlpha write FShadowAlpha;
    property ShadowAlphaValue: Integer read FShadowAlphaValue write FShadowAlphaValue;
  end;

type
  TSharpEFontSelector = class(TCustomPanel)
  private
    FSbProperties: TSpeedButton;
    FFont: TSharpEFontProperties;
    FAlphaEnabled: Boolean;
    FShadowEnabled: Boolean;
    FBoldEnabled: Boolean;
    FItalicEnabled: Boolean;
    FUnderlineEnabled: Boolean;
    FEnabled: Boolean;
    FOnAfterDialog: TNotifyEvent;
    FFontBackground: TSEFBackgroundType;
    FFlat: Boolean;

    function CreateInitialControls: Boolean;
    function Execute: Boolean;

    procedure BtnPropertiesClick(Sender: TObject);
    procedure SetFont(const Value: TSharpEFontProperties);
    procedure SetEnabled(const Value: boolean); 
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  protected
  published
    property Owner;
    property Font: TSharpEFontProperties read FFont write SetFont;
    property FontBackground: TSEFBackgroundType read FFontBackground write FFontBackground;
    property ShadowEnabled: Boolean read FShadowEnabled write FShadowEnabled;
    property AlphaEnabled: Boolean read FAlphaEnabled write FAlphaEnabled;
    property BoldEnabled: Boolean read FBoldEnabled write FBoldEnabled;
    property ItalicEnabled: Boolean read FItalicEnabled write FItalicEnabled;
    property UnderlineEnabled: Boolean read FUnderlineEnabled write FUnderlineEnabled;
    property Color;
    property Enabled: boolean read FEnabled write SetEnabled;

    property OnAfterDialog: TNotifyEvent read FOnAfterDialog write FOnAfterDialog;
  end;

procedure Register;

implementation

uses
  JclFileUtils,
  uSharpEFontSelectorWnd,
  graphicsfx;

{ TSharpEFontSelector }

{$R SharpeFontSelectorBitmaps.res}

procedure Register;
begin
  RegisterComponents('SharpE', [TSharpEFontSelector]);
end;

procedure TSharpEFontSelector.BtnPropertiesClick(Sender: TObject);
begin
  if not (Assigned(frmFontSelector)) then
    frmFontSelector := TfrmFontSelector.Create(nil);
  try

    if Execute then begin
      with frmFontSelector do begin
        FFont.Name := cbxFontName.Text;
        FFont.Size := round(edtSize.Value);
        FFont.Alpha := chkAlpha.Checked;
        FFont.AlphaValue := gbFontAlpha.Position;
        FFont.Color := secFontColor.Color;
        FFont.ShadowColor := secShadowColor.Color;
        FFont.ShadowAlphaValue := gbShadowAlpha.Position;
        FFont.Shadow := chkShadow.Checked;

        FFont.Bold := chkBold.Checked;
        FFont.Italic := chkItalic.Checked;
        FFont.Underline := chkUnderline.Checked;
      end;

      Invalidate;
    end;

  finally
    FreeAndNil(frmFontSelector);

    if Assigned(OnAfterDialog) then
      FOnAfterDialog(Sender);
  end;
end;

constructor TSharpEFontSelector.Create(AOwner: TComponent);
begin
  inherited;
  Width := 145;
  Height := 21;
  BorderStyle := bsSingle;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BevelKind := bkNone;

  FFont := TSharpEFontProperties.Create;
  FFont.Name := 'Arial';
  FFont.Size := 12;
  FFont.ShadowColor := clGray;
  FFont.Shadow := True;
  FFont.ShadowAlpha := True;
  FFont.ShadowAlphaValue := 75;

  FEnabled := True;
  FBoldEnabled := True;
  FItalicEnabled := True;
  FFlat := False;
  UnderlineEnabled := True;
  AlphaEnabled := True;
  ShadowEnabled := True;

  CreateInitialControls;
end;

function TSharpEFontSelector.CreateInitialControls: Boolean;
var
  R: TRect;
  ButtonWidth: Integer;
begin
  Result := True;

  // Get Initial Values
  R := Rect(Self.Left, Self.Top, Self.Width, Self.Height);
  ButtonWidth := 15;

  FSbProperties := TSpeedButton.Create(Self);
  with FSbProperties do
  begin
    Parent := Self;
    Align := alRight;
    Width := ButtonWidth;
    Caption := '';
    Flat := True;
    Color := clWindow;
    ParentColor := True;
    OnClick := BtnPropertiesClick;
  end;

  FSbProperties.Glyph.LoadFromResourceName(HInstance,'FONTDROPLEFT_BMP');

end;

destructor TSharpEFontSelector.Destroy;
begin
  FFont.Free;
  inherited;
end;

function TSharpEFontSelector.Execute: Boolean;
var
  x: integer;

begin
    Result := False;
    
    // Initialise Font Selector Window
    with frmFontSelector do begin

      // Hide all checkboxes
      chkBold.Visible := False;
      chkItalic.Visible := False;
      chkUnderline.Visible := False;
      chkShadow.Visible := False;
      chkAlpha.Visible := False;

      x := 4;

      if FBoldEnabled then begin
        chkBold.Visible := True;
        chkBold.Left := x;
        x := x + chkBold.Width + 6;
      end;

      if FItalicEnabled then begin
        chkItalic.Visible := True;
        chkItalic.Left := x;
        x := x + chkItalic.Width + 6;
      end;

      if FUnderlineEnabled then begin
        chkUnderline.Visible := True;
        chkUnderline.Left := x;
        x := x + chkUnderline.Width + 6;
      end;

      if FShadowEnabled then begin
        chkShadow.Visible := True;
        chkShadow.Left := x;
        x := x + chkShadow.Width + 6;
      end;

      if FAlphaEnabled then begin
        chkAlpha.Visible := True;
        chkAlpha.Left := x;
      end;

      pnlAlphaProps.Visible := True;
      pnlShadowProps.Visible := True;
      pnlFontStyle.Height := 62;

      // Shadow Not Enabled
      if not (FShadowEnabled) then begin
        pnlShadowProps.Visible := False;
        pnlFontStyle.Height := pnlFontStyle.Height - pnlShadowProps.Height;
      end;

      // Alpha Not Enabled
      if not (FAlphaEnabled) then begin
        pnlAlphaProps.Visible := False;
        pnlFontStyle.Height := pnlFontStyle.Height - pnlAlphaProps.Height;
      end;

      secFontColor.BackgroundColor := AlterColor(FFont.Color, 100);
      imgFontPreview.Color := AlterColor(FFont.Color, 100);

      SelectFont(FFont.Name, True);
      edtSize.Value := FFont.Size;

      chkBold.Checked := FFont.Bold;
      chkUnderline.Checked := FFont.Underline;
      chkItalic.Checked := FFont.Italic;
      chkShadow.Checked := FFont.Shadow;
      chkAlpha.Checked := FFont.Alpha;

      if FFont.Alpha then
        gbFontAlpha.Position := FFont.FAlphaValue
      else
        gbFontAlpha.Position := 255;

      if FFont.Shadow then
        gbShadowAlpha.Position := FFont.FShadowAlphaValue
      else
        gbShadowAlpha.Position := 75;

      secFontColor.Color := FFont.Color;
      secShadowColor.Color := FFont.ShadowColor;

      case FFontBackground of
      sefbChecker: radBackCheck.Checked := True;
      sefbBlack: radBackBlack.Checked := True;
      sefbWhite: radBackWhite.Checked := True;
      end;

      UpdateFontPreview;

    end;

    case frmFontSelector.ShowModal of
      mrOk: Result := True;
      mrCancel: Result := False;
    end;
end;

procedure TSharpEFontSelector.Paint;
var
  MBmp: TBitmap32;
  R: TRect;
  NameLength, SizeLength: Integer;
  TopColor, BottomColor: TColor;
  AllowedLength: Integer;
  FontName: string;

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then
      TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then
      BottomColor := clBtnHighlight;
  end;
begin
  R := ClientRect;
  //R := Rect(ClientRect.Left,ClientRect.Top,ClientRect.Right-1,ClientRect.Bottom-1);

  mBmp := TBitmap32.Create;
  try
    mBmp.Height := ClientRect.Bottom;
    mBmp.Width := ClientRect.Right;
    MBmp.Clear(Color32(Color));
    //MBmp.Canvas.FrameRect(R);

    // Draw Bitmaps
    //DrawBitmap(3, 3, 'SCFONT_BMP', MBmp, clWhite);

    AllowedLength := FSbProperties.Left- 3;
    NameLength := MBmp.TextWidth(FFont.Name);
    SizeLength := MBmp.TextWidth(Format('[%d]', [FFont.size]));

    if (NameLength + SizeLength) > (AllowedLength) then begin
      NameLength := AllowedLength - SizeLength;
      FontName := PathCompactPath(Canvas.Handle, FFont.Name, NameLength, cpEnd);
    end
    else
      FontName := FFont.Name;

    if FEnabled then
      MBmp.RenderText(1, 1, Format('%s [%d]', [FontName, FFont.Size]), 0, Color32(clWindowText))
    else
      MBmp.RenderText(1, 1, Format('%s [%d]', [FontName, FFont.Size]), 0, Color32(clGrayText));

    if FSbProperties <> nil then
      FSbProperties.Enabled := FEnabled;

  finally
    Canvas.CopyRect(ClientRect, mBmp.canvas, ClientRect);
    mBmp.Free;

  end;
end;

procedure TSharpEFontSelector.SetFont(const Value: TSharpEFontProperties);
begin
  FFont := Value;
  Invalidate;
end;

procedure TSharpEFontSelector.SetEnabled(const Value: boolean);
begin
  FEnabled := Value;
  Invalidate;
end;

end.

 