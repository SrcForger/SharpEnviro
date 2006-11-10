unit SharpEDesignTime;

interface

{$IFDEF VER130} // Delphi 5
{$DEFINE mc_LT_D6} // Less than Delphi 6, "mc" is used to help avoid conflicts
{$ENDIF}

uses{$IFDEF  mc_LT_D6}
  DsgnIntf,
{$ENDIF}
{$IFNDEF mc_LT_D6}
  DesignIntf,
  DesignWindows,
  DesignEditors,
{$ENDIF}
  Classes,
  Dialogs,
  Graphics,
  SysUtils;
type
  TXmlFileNameProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TFileNameProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TBitmap32FileNameProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

procedure Register;
implementation
uses
  SharpESkin,
  SharpEButton,
  SharpESkinManager,
  SharpEForm,
  SharpEScheme,
  SharpEPanel,
  SharpEProgressBar,
  SharpEBar,
  SharpECheckBOx,
  SharpEMiniThrobber,
  SharpELabel,
  SharpERadioBox,
  SharpEImage32,
  SharpEEdit,
  SharpETaskItem,
  SharpESkinLabel;

  //***************************************
//* TXmlFileNameProperty
//***************************************

procedure TXmlFileNameProperty.Edit;
begin
  with TOpenDialog.Create(nil) do
  try
    Title := 'Choose xml skin template';
    Filter := 'Skin files (*.xml)|*.xml';
    FileName := GetStrValue;
    if Execute then
      SetStrValue(FileName);
  finally
    Free;
  end;
end;

function TXmlFileNameProperty.GetValue: string;
var name: string;
begin
  name := GetStrValue;
  if name <> '' then
  begin
    Result := name;
  end
  else
    result := '(none)';
end;

procedure TXmlFileNameProperty.SetValue(const Value: string);
begin
  SetStrValue(Value);
end;

function TXmlFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TBitmap32FileNameProperty.Edit;
begin
  with TOpenDialog.Create(nil) do
  try
    Title := 'Choose Png Image';
    Filter := GraphicFilter(TGraphic);
    FileName := GetStrValue;
    if Execute then
      SetStrValue(FileName);
  finally
    Free;
  end;
end;

function TBitmap32FileNameProperty.GetValue: string;
var name: string;
begin
  name := GetStrValue;
  if (name <> '') then
  begin
    Result := name;
  end
  else
    result := '(none)';
end;

procedure TBitmap32FileNameProperty.SetValue(const Value: string);
begin
  SetStrValue(Value);
end;

function TBitmap32FileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

  //***************************************
//* TFileNameProperty
//***************************************

procedure TFileNameProperty.Edit;
begin
  with TOpenDialog.Create(nil) do
  try
    Title := 'Choose skin';
    Filter := 'Skin files (*.skin)|*.SKIN';
    FileName := GetStrValue;
    if Execute then
      SetStrValue(FileName);
  finally
    Free;
  end;
end;

function TFileNameProperty.GetValue: string;
var name: string;
  I: integer;
begin
  name := GetStrValue;
  if name <> '' then
  begin
    name := ExtractFileName(name);
    I := LastDelimiter('.', name);
    if (I > 1) then
      name := Copy(name, 0, I - 1);
    result := '(' + name + ')';
  end
  else
    result := '(none)';
end;

procedure TFileNameProperty.SetValue(const Value: string);
begin
  SetStrValue(Value);
end;

function TFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure Register;
begin
  RegisterComponents('SharpE', [TSharpESkinManager]);
  RegisterComponents('SharpE', [TSharpEScheme]);
  RegisterComponents('SharpE', [TSharpESkin]);
  RegisterComponents('SharpE', [TSharpEForm]);
  RegisterComponents('SharpE', [TSharpEBar]);
  RegisterComponents('SharpE', [TSharpEButton]);
  RegisterComponents('SharpE', [TSharpECheckBox]);
  RegisterComponents('SharpE', [TSharpEProgressBar]);
  RegisterComponents('SharpE', [TSharpEPanel]);
  RegisterComponents('SharpE', [TSharpELabel]);
  RegisterComponents('SharpE', [TSharpERadioBox]);
  RegisterComponents('SharpE', [TSharpEMiniThrobber]);
  RegisterComponents('SharpE', [TSharpEImage32]);
  RegisterComponents('SharpE', [TSharpEEdit]);
  RegisterComponents('SharpE', [TSharpETaskItem]);
  RegisterComponents('SharpE', [TSharpESkinLabel]);

  RegisterPropertyEditor(TypeInfo(TXmlFileName), TSharpESkin, 'XmlFilename',
    TXmlFileNameProperty);
  RegisterPropertyEditor(TypeInfo(TSkinName), TSharpESkin, 'Skin',
    TFileNameProperty);
  RegisterPropertyEditor(TypeInfo(TGlyph32FileName), TSharpEPanel,
    'Glyph32FileName',
    TBitmap32FileNameProperty);
  RegisterPropertyEditor(TypeInfo(TGlyph32FileName), TSharpEImage32,
    'Glyph32FileName',
    TBitmap32FileNameProperty);
  RegisterPropertyEditor(TypeInfo(TGlyph32FileName), TSharpEButton,
    'Glyph32FileName',
    TBitmap32FileNameProperty);

end;

end.
