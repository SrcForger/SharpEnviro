unit SharpECenterHeader;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, uVistaFuncs;

type
  TCustomSharpECenterHeader = class(TCustomPanel)
    private
      titleLabel: TLabel;
      descriptionLabel: TLabel;
      shp: TShape;
      FTitle: string;
      FDescription: string;
      procedure SetDescription(const Value: string);
      procedure SetTitle(const Value: string);
    function GetDescriptionColor: TColor;
    function GetTitleColor: TColor;
    procedure SetDescriptionColor(const Value: TColor);
    procedure SetTitleColor(const Value: TColor);
    public
      constructor Create(AOwner: TComponent); override;
      procedure BeforeDestruction; override;
    published
      property Title: string read FTitle write SetTitle;
      property Description: string read FDescription write SetDescription;
      property TitleColor: TColor read GetTitleColor write SetTitleColor;
      property DescriptionColor: TColor read GetDescriptionColor write SetDescriptionColor;

      property Visible;
  end;

  TSharpECenterHeader = class(TCustomSharpECenterHeader)
    published
      property Title;
      property Description;
      property Align;
      property Margins;
      property AlignWithMargins;
      property Visible;
      property Color;
  end;

  procedure Register;

implementation

{ TCustomSharpECenterHeader }

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpECenterHeader]);
end;

procedure TCustomSharpECenterHeader.BeforeDestruction;
begin
  inherited BeforeDestruction;

  titleLabel.Free;
  descriptionLabel.Free;
  shp.Free;
end;

constructor TCustomSharpECenterHeader.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  Self.AutoSize := True;
  Self.AlignWithMargins := True;
  Self.BevelInner := bvNone;
  Self.BevelOuter := bvNone;
  Self.DoubleBuffered := true;

  titleLabel := TLabel.Create(Self);
  with titleLabel do begin
    Parent := Self;
    ParentFont := True;
    Caption := '';
    Align := alTop;
    Margins.Left := 0;
    Margins.Top := 0;
    Margins.Right := 0;
    Margins.Bottom := 2;
    AlignWithMargins := True;
  end;

  shp := TShape.Create(Self);
  with shp do begin
    Parent := self;
    Height := 1;
    Align := alTop;
    AlignWithMargins := True;
    Margins.Left := 0;
    Margins.Top := 0;
    Margins.Right := 10;
    Margins.Bottom := 2;
  end;

  descriptionLabel := TLabel.Create(Self);
  with descriptionLabel do begin
    Parent := Self;
    ParentFont := True;
    Caption := '';
    Align := alTop;
    AlignWithMargins := True;
    Margins.Left := 0;
    Margins.Top := 0;
    Margins.Right := 10;
    Margins.Bottom := 0;
    EllipsisPosition := epEndEllipsis;
    WordWrap := True;
    Layout := tlCenter;
    Font.Color := clRed;
    ShowHint := true;
  end;

  SetVistaFonts(TCustomForm(self));

end;

function TCustomSharpECenterHeader.GetDescriptionColor: TColor;
begin
  Result := descriptionLabel.Font.Color;
end;

function TCustomSharpECenterHeader.GetTitleColor: TColor;
begin
  Result := titleLabel.Font.Color;
end;

procedure TCustomSharpECenterHeader.SetDescription(const Value: string);
begin
  FDescription := Value;
  descriptionLabel.Caption := FDescription;
  descriptionLabel.Hint := FDescription;
end;

procedure TCustomSharpECenterHeader.SetDescriptionColor(const Value: TColor);
begin
  descriptionLabel.Font.Color := Value;
end;

procedure TCustomSharpECenterHeader.SetTitle(const Value: string);
begin
  FTitle := Value;
  titleLabel.Caption := FTitle;
end;

procedure TCustomSharpECenterHeader.SetTitleColor(const Value: TColor);
begin
  titleLabel.Font.Color := Value;
  shp.Pen.Color := Value;
  shp.Brush.Color := Value;
end;

end.
