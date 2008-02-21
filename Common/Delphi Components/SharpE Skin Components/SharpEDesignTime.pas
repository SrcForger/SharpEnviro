{
Source Name: SharpEDesignTime.pas
Description:
Copyright (C) Malx (Malx@techie.com)

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
  SharpEScheme,
  SharpEProgressBar,
  SharpEBar,
  SharpEMiniThrobber,
  SharpEListBox,
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
  RegisterComponents('SharpE_Skin', [TSharpESkinManager]);
  RegisterComponents('SharpE_Skin', [TSharpEScheme]);
  RegisterComponents('SharpE_Skin', [TSharpESkin]);
  RegisterComponents('SharpE_Skin', [TSharpEBar]);
  RegisterComponents('SharpE_Skin', [TSharpEButton]);
  RegisterComponents('SharpE_Skin', [TSharpEProgressBar]);
  RegisterComponents('SharpE_Skin', [TSharpEMiniThrobber]);
  RegisterComponents('SharpE_Skin', [TSharpEEdit]);
  RegisterComponents('SharpE_Skin', [TSharpETaskItem]);
  RegisterComponents('SharpE_Skin', [TSharpESkinLabel]);
  RegisterComponents('SharpE_Skin', [TSharpEListBox]);

  RegisterPropertyEditor(TypeInfo(TXmlFileName), TSharpESkin, 'XmlFilename',
    TXmlFileNameProperty);
  RegisterPropertyEditor(TypeInfo(TSkinName), TSharpESkin, 'Skin',
    TFileNameProperty);
  RegisterPropertyEditor(TypeInfo(TGlyph32FileName), TSharpEButton,
    'Glyph32FileName',
    TBitmap32FileNameProperty);

end;

end.
