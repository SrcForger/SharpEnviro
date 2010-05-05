{
Source Name: uTThemeScheme.pas
Description: TThemeScheme class implementing IThemeScheme Interface
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

unit uThemeScheme;

interface

uses
  SharpApi, uThemeConsts, uThemeInfo, uThemeSkin, uIThemeScheme;

type
  TThemeScheme = class(TInterfacedObject, IThemeScheme)
  private
    FThemeInfo : TThemeInfo;
    FThemeSkin : TThemeSkin;
    FName      : String;
    FDirectory : String;
    FColors    : TSharpEColorSet;
    procedure SetDefaults;
    procedure LoadNameAndDefaults; stdcall;    
  public
    LastUpdate : Int64;
    constructor Create(pThemeInfo : TThemeInfo; pThemeSkin : TThemeSkin); reintroduce;
    destructor Destroy; override;

    // IThemeScheme Interface
    procedure SaveToFile; stdcall;
    procedure LoadFromFile; stdcall;
    procedure LoadCustomScheme; stdcall;

    function GetName : String; stdcall;
    procedure SetName(Value : String); stdcall;
    property Name : String read GetName write SetName;

    function GetDirectory : String; stdcall;
    property Directory : String read GetDirectory;

    function GetColors : TSharpEColorSet; stdcall;
    property Colors : TSharpEColorSet read GetColors;    

    function ParseColor(pSrc : String) : integer; stdcall;
    function SchemeCodeToColor(pCode: integer): integer; stdcall;
    function GetColorByTag(pTag: String): TSharpESkinColor; stdcall;
    function GetColorIndexByTag(pTag: String): Integer; stdcall;
    function GetColorByIndex(pIndex: integer): TSharpESkinColor; stdcall;
    function GetColorCount: Integer; stdcall;
  end;

implementation

uses
  Windows, SysUtils, Graphics, JclStrings, Classes, GR32, IXmlBaseUnit;

{ TThemeScheme }

constructor TThemeScheme.Create(pThemeInfo : TThemeInfo; pThemeSkin : TThemeSkin);
begin
  inherited Create;
  SharpApi.SendDebugMessage('ThemeAPI','TThemeScheme.Create', 0);

  FThemeInfo := pThemeInfo;
  FThemeSkin := pThemeSkin;

  LoadFromFile;
end;

destructor TThemeScheme.Destroy;
begin
  SharpApi.SendDebugMessage('ThemeAPI','TThemeScheme.Destroy', 0);
  SetLength(FColors,0);
  inherited;
end;

function TThemeScheme.GetColorCount: Integer;
begin
  result := length(FColors);
end;

function TThemeScheme.GetColorByIndex(pIndex: integer): TSharpESkinColor;
begin
  if pIndex > GetColorCount - 1 then
  begin
    result.Name := '';
    result.Tag := '';
    result.Info := '';
    result.Color := 0;
    result.schemetype := stColor;
    exit;
  end;

  result.Name := FColors[pIndex].Name;
  result.Tag := FColors[pIndex].Tag;
  result.Info := FColors[pIndex].Info;
  result.Color := FColors[pIndex].Color;
  result.schemetype := FColors[pIndex].SchemeType;
end;

function TThemeScheme.GetColorIndexByTag(pTag: String): Integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to GetColorCount - 1 do
  begin
    if CompareText(FColors[i].Tag, pTag) = 0 then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function TThemeScheme.GetColors: TSharpEColorSet;
begin
  result := FColors;
end;

function TThemeScheme.GetDirectory: String;
begin
  result := FDirectory;
end;

function TThemeScheme.GetName: String;
begin
  result := FName;
end;

function TThemeScheme.GetColorByTag(pTag: String): TSharpESkinColor;
var
  i: integer;
begin
  // default values
  result.Name := '';
  result.Tag := '';
  result.Info := '';
  result.Color := 0;
  result.SchemeType := stColor;

  for i := 0 to GetColorCount - 1 do
  begin
    if CompareText(FColors[i].Tag, pTag) = 0 then
    begin
      result.Name := FColors[i].Name;
      result.Tag := FColors[i].Tag;
      result.Info := FColors[i].Info;
      result.Color := FColors[i].Color;
      result.SchemeType := FColors[i].SchemeType;
      exit;
    end;
  end;
end;

procedure TThemeScheme.LoadCustomScheme;
var
  XML : IXmlBase;
  n : integer;
  s : String;
  tempColor : String;
  Index : integer;
begin
  // Load custom Scheme
  XML := TInterfacedXMLBase.Create(True);
  FDirectory := FThemeSkin.Directory + SKINS_SCHEME_DIRECTORY + '\';
  XML.XmlFilename := FDirectory + FName + '.xml';
  if XML.Load then
  begin
    for n := 0 to XML.XmlRoot.Items.Count - 1 do
      with XML.XmlRoot.Items.Item[n].Items do
      begin
        s := Value('Tag', '');
        Index := GetColorIndexByTag(s);
        if Index >= 0 then
        begin
          tempColor := Value('Color', inttostr(FColors[Index].Color));
          FColors[Index].Color := ParseColor(tempColor);
        end;
      end;
  end;
  XML := nil;
end;

procedure TThemeScheme.LoadFromFile;
begin
  SetDefaults;

  LoadNameAndDefaults;
  LoadCustomScheme;
end;

procedure TThemeScheme.LoadNameAndDefaults;
var
  XML : IXmlBase;
  fileloaded : boolean;
  n : integer;
  s : String;
begin
  // Get the Scheme Name
  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_SCHEME_FILE;
  if XML.Load then
  begin
    fileloaded := True;
    with XML.XmlRoot.Items do
    begin
      FName := Value('Scheme', 'Default');
    end
  end else fileloaded := False;
  XML := nil;

  if not fileloaded then
    SaveToFile;

  // Load Colors, Tags and Default colors of the Skins Scheme
  SetLength(FColors,0);
  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FThemeSkin.Directory + SKINS_SCHEME_FILE;
  if XML.Load then
  begin
    for n := 0 to XML.XmlRoot.Items.Count - 1 do
      with XML.XmlRoot.Items.Item[n].Items do
      begin
        SetLength(FColors,Length(FColors)+1);
        FColors[High(FColors)].Name := Value('Name', '');
        FColors[High(FColors)].Tag := Value('Tag', '');
        FColors[High(FColors)].Info := Value('Info', '');
        FColors[High(FColors)].Color := ParseColor(Value('Default', '0'));
        s := Value('Type', 'color');
        if CompareText(s, 'boolean') = 0 then
          FColors[High(FColors)].SchemeType := stBoolean
        else if CompareText(s, 'integer') = 0 then
          FColors[High(FColors)].SchemeType := stInteger
        else if CompareText(s, 'dynamic') = 0 then
          FColors[High(FColors)].SchemeType := stDynamic
        else
          FColors[High(FColors)].SchemeType := stColor;
      end;
  end;
  XML := nil;
end;

function TThemeScheme.SchemeCodeToColor(pCode: integer): integer;
begin
  result := -1;
  if pCode < 0 then
  begin
    if abs(pCode) <= length(FColors) then
      result := FColors[abs(pCode) - 1].Color;
  end else result := pCode;
end;

function TThemeScheme.ParseColor(pSrc: String): Integer;
var
  iStart, iEnd: Integer;
  h, s, l: double;
  sColorType, sParam: string;
  strlTokens: TStringList;
  bIdent: Boolean;
  r, g, b: byte;
  c: Integer;
  col: Integer;
  col32: TColor32;
  n: integer;
  sIdent: string;

  function CMYKtoColor(C, M, Y, K: integer): TColor;
  var
    R, G, B: integer;
  begin
    R := 255 - Round(2.55 * (C + K));
    if R < 0 then
      R := 0;
    G := 255 - Round(2.55 * (M + K));
    if G < 0 then
      G := 0;
    B := 255 - Round(2.55 * (Y + K));
    if B < 0 then
      B := 0;
    Result := RGB(R, G, B);
  end;

  function HSVtoRGB(H, S, V: Integer): TColor;
  var
    ht, d, t1, t2, t3: Integer;
    R, G, B: Word;
  begin
    s := s * 255 div 100;
    v := v * 255 div 100;

    if S = 0 then begin
      R := V;
      G := V;
      B := V;
    end
    else begin
      ht := H * 6;
      d := ht mod 360;

      t1 := round(V * (255 - S) / 255);
      t2 := round(V * (255 - S * d / 360) / 255);
      t3 := round(V * (255 - S * (360 - d) / 360) / 255);

      case ht div 360 of
        0: begin
            R := V;
            G := t3;
            B := t1;
          end;
        1: begin
            R := t2;
            G := V;
            B := t1;
          end;
        2: begin
            R := t1;
            G := V;
            B := t3;
          end;
        3: begin
            R := t1;
            G := t2;
            B := V;
          end;
        4: begin
            R := t3;
            G := t1;
            B := V;
          end;
      else begin
          R := V;
          G := t1;
          B := t2;
        end;
      end;
    end;
    Result := RGB(R, G, B);
  end;

begin
  result := -1;

  // Which colour type are we using? RGB, CMY, CMYK, HSV, HSL, LAB
  iStart := Pos('(', pSrc);
  iEnd := Pos(')', pSrc);

  for n := 0 to High(FColors) do
    if CompareText(Colors[n].Tag,pSrc) = 0 then
    begin
      result := Colors[n].Color;
      exit;
    end;

  if (iStart = 0) or (iEnd = 0) then begin
    // try to convert
    if TryStrToInt(pSrc, n) then
    begin
      result := SchemeCodeToColor(n);
      exit;
    end
    else begin
      sIdent := pSrc;
      bIdent := IdentToColor(sIdent, col);
      if bIdent then
        result := StringToColor(pSrc)
      else
        result := -1;
      exit;
    end;
  end;

  sColorType := Copy(pSrc, 1, iStart - 1);
  sParam := Copy(pSrc, iStart + 1, iEnd - iStart - 1);

  // RGB
  if CompareText(sColorType, 'rgb') = 0 then begin
    strlTokens := TStringList.Create;
    try
      StrTokenToStrings(sParam, ',', strlTokens);
      if strlTokens.Count <> 3 then
        exit;

      Result := RGB(StrToInt(StrlTokens[0]), StrToInt(StrlTokens[1]),
        StrToInt(StrlTokens[2]));

      exit;

    finally
      strlTokens.Free;
    end;
  end
  else if CompareText(sColorType, 'cmyk') = 0 then begin
    strlTokens := TStringList.Create;
    try
      StrTokenToStrings(sParam, ',', strlTokens);
      if strlTokens.Count <> 4 then
        exit;

      Result := CMYKtoColor(StrToInt(StrlTokens[0]), StrToInt(StrlTokens[1]),
        StrToInt(StrlTokens[2]), StrToInt(StrlTokens[3]));

      exit;

    finally
      strlTokens.Free;
    end;
  end;

  // HSV
  if CompareText(sColorType, 'hsv') = 0 then begin
    strlTokens := TStringList.Create;
    try
      StrTokenToStrings(sParam, ',', strlTokens);
      if strlTokens.Count <> 3 then
        exit;

      Result := HSVtoRGB(strtoint(StrlTokens[0]), strtoint(StrlTokens[1]),
        strtoint(StrlTokens[2]));

      exit;

    finally
      strlTokens.Free;
    end;
  end;
  // HSL
  if CompareText(sColorType, 'hsl') = 0 then begin
    strlTokens := TStringList.Create;
    try
      StrTokenToStrings(sParam, ',', strlTokens);
      if strlTokens.Count <> 3 then
        exit;

      h := StrToFloat(StrlTokens[0]) / 255;
      s := StrToFloat(StrlTokens[1]) / 255;
      l := StrToFloat(StrlTokens[2]) / 255;

      col32 := HSLtoRGB(h, s, l);
      Color32ToRGB(col32, r, g, b);
      Result := RGB(r, g, b);
      exit;

    finally
      strlTokens.Free;
    end;
  end;
  // HEX
  if CompareText(sColorType, 'hex') = 0 then begin
    Result := stringtocolor('$' + sParam);
    c := ColorToRGB(Result);
    c := (c and $FF) shl 16 + // Red
    (c and $FF00) + // Green
    (c and $FF0000) shr 16; // Blue

    Result := c;
  end;
  // COLOR
  if CompareText(sColorType, 'color') = 0 then begin
    Result := stringtocolor(sParam);
  end;

end;

procedure TThemeScheme.SaveToFile;
var
  XML : IXMlBase;
begin
  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_SCHEME_FILE;

  XML.XmlRoot.Name := 'SharpEThemeScheme';
  with XML.XmlRoot.Items do
  begin
    Add('Scheme',FName);
  end;
  XML.Save;

  XML := nil;
end;

procedure TThemeScheme.SetDefaults;
begin
  FName := 'Default';
  FDirectory := FThemeSkin.Directory + SKINS_SCHEME_DIRECTORY + '\';
  LastUpdate := 0;
  SetLength(FColors,0);
end;

procedure TThemeScheme.SetName(Value: String);
begin
  if CompareText(FName,Value) <> 0 then
    FName := Value;
end;

end.
