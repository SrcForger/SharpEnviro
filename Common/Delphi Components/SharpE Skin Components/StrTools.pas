
(********************************************************)
(*                                                      *)
(*      Object Modeler Class Library                    *)
(*                                                      *)
(*      Open Source Released 2000                       *)
(*                                                      *)
(********************************************************)

unit StrTools;

interface

uses
  Windows, SysUtils, Classes, Math, TypInfo, ActiveX;

const
   Alpha = ['A'..'Z', 'a'..'z'];
   Numeric = ['0'..'9'];
   AlphaNumeric = Alpha + Numeric;

{ The AdvanceToken function does a case insensitive search of Buffer for
  SearchStr, and returns True if a match is found. Buffer is modified to
  point to the character after the match. }

function AdvanceToken(var Buffer: PChar; const SearchStr: string): Boolean;

{ The GetComponentName function returns the name of the Component parameter. If
  the component has no name, the function creates a unique name. }

function GetComponentName(Component: TComponent): string;

{ The GetComponentPath function returns a string that represents the ownership
  of the Component parameter. }

function GetComponentPath(Component: TComponent): string;

{ The MaskConvert function returns a formated string from Source as defined by
  Mask. Any characters in Source that don't match the Mask string are replaced
  with DefaultChar.  Mask can contain the following special characters:

    'C' Filters source string for the first occurance of an Alpha character
    'D' Filters source string for the first occurance of an Numeric character
    '?' Accepts any character

   For example:
     MaskConvert('1235551212', '(DDD) DDD-DDDDD', '0') returns '(123) 555-1212'
     MaskConvert('(123) 555-1212', 'DDDDDDDDDDD', '0') returns '1235551212' }

function MaskConvert(const Source: string; const Mask: string; DefaultChar: Char): string;

{ The SearchAndReplace procedure performs a case-sensitive search for SearchStr
  and calls ReplaceFunc for each a match found. If ReplaceFunc returns True then
  SearchStr is replaced with S. }

type
  TReplaceFunc = function (var S: string): Boolean;

procedure SearchAndReplace(Strings: TStrings; const SearchStr: string; ReplaceFunc: TReplaceFunc);

{ The StrPad procedure copies Source string into the Dest buffer, aligning it
  left or right and filling any extra bytes with the Pad character. }

type
  TPadAlign = (paLeft, paRight);

procedure StrPad(const Source: string; Dest: PChar; Size: Integer;
  PadAlign: TPadAlign; Pad: Char);

{ The TrimSeparator function returns a copy of S from the character after the
  Separator parameter to the end of the string. }

function TrimSeparator(const S: string; Separator: Char): string;

{ TComplexField class }

type
  EComplexFieldError = class(Exception);

  TComplexField = class
  private
    FData: string;
    function GetCount: Integer;
    function GetItem(Index: Integer): string;
    procedure SetItem(Index: Integer; const Value: string);
  public
    function IndexOf(const S: string): Integer;
    property Count: Integer read GetCount;
    property Data: string read FData write FData;
    property Item[index: Integer]: string read GetItem write SetItem; default;
  end;

{ TEnumString class }

  TEnumString = class(TInterfacedObject, IEnumString)
  private
    FStrings: TStrings;
    FIndex: Integer;
  protected
    { IEnumString }
    function Next(celt: Longint; out elt;
      pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumString): HResult; stdcall;
  public
    constructor Create(Strings: TStrings);
  end;

implementation

uses
  StrConst;

function AdvanceToken(var Buffer: PChar; const SearchStr: string): Boolean;
var
  Token: PChar;
begin
  Token := PChar(SearchStr);
  while Buffer^ <> #0 do
  begin
    if UpCase(Buffer^) = Token^ then
      Inc(Token)
    else if Token <> PChar(SearchStr) then
    begin
      Token := PChar(SearchStr);
      if UpCase(Buffer^) = Token^ then
        Inc(Token);
    end;
    Inc(Buffer);
    if Token^ = #0 then
      Break;
  end;
  Result := Token^ = #0;
end;

function GetComponentName(Component: TComponent): string;
var
  S: string;
  I: Integer;
begin
  Result := Component.Name;
  if Result = '' then
  begin
    S := Component.ClassName;
    I := 1;
    if Component.Owner <> nil then
      while Component.Owner.FindComponent(PChar(@S[2]) + IntToStr(I)) <> nil do
        Inc(I);
    Result := PChar(@S[2]) + IntToStr(I);
  end;
end;

function GetComponentPath(Component: TComponent): string;
var
  S: string;
begin
  if Component <> nil then
  begin
    S := GetComponentPath(Component.Owner);
    if S <> '' then
      Result := S + DotSep + GetComponentName(Component)
    else
      Result := S + GetComponentName(Component);
  end
  else
    Result := '';
end;

function MaskConvert(const Source: string; const Mask: string; DefaultChar: Char): string;
var
  P: PChar;
  I: Integer;

  procedure DefaultAction;
  begin
    if UpCase(Mask[I]) in ['C', 'D', '?'] then
      Result := Result + DefaultChar
    else
      Result := Result + Mask[I];
  end;

begin
  P := PChar(Source);
  Result := '';
  for I := 1 to Length(Mask) do
  if P^ <> #0 then
  begin
    case UpCase(Mask[I]) of
      'C':
      begin
        while (P^ <> #0) and (not (P^ in Alpha)) do
          Inc(P);
        if P^ <> #0 then
          Result := Result + P^
        else
        begin
          DefaultAction;
          Continue;
        end;
      end;
      'D':
      begin
        while (P^ <> #0) and (not (P^ in Numeric)) do
          Inc(P);
        if P^ <> #0 then
          Result := Result + P^
        else
        begin
          DefaultAction;
          Continue;
        end;
      end;
      '?':
        Result := Result + P^
      else
      begin
        Result := Result + Mask[I];
        Continue;
      end;
    end;
    Inc(P);
  end
  else
    DefaultAction;
end;

procedure SearchAndReplace(Strings: TStrings; const SearchStr: string; ReplaceFunc: TReplaceFunc);
var
  ReplaceStr: string;
  Buffer: string;
  Match: Integer;
  I: Integer;
begin
  ReplaceStr := '';
  Strings.BeginUpdate;
  try
    for I := 0 to Strings.Count - 1 do
    begin
      Buffer := Strings[I];
      Match := Pos(SearchStr, Buffer);
      while (Match > 0) and ReplaceFunc(ReplaceStr) do
      begin
        Buffer := Copy(Buffer, 1, Match-1) + ReplaceStr + Copy(Buffer, Match + Length(SearchStr), Length(Buffer));
        Match := Pos(SearchStr, Buffer);
      end;
      Strings[I] := Buffer;
    end;
  finally
    Strings.EndUpdate;
  end;
end;

procedure StrPad(const Source: string; Dest: PChar; Size: Integer; PadAlign: TPadAlign; Pad: Char);
begin
  FillMemory(Dest, Size, Byte(Pad));
  if PadAlign = paRight then
    Inc(Dest, Size - MinIntValue([Length(Source), Size]));
  CopyMemory(Dest, Pointer(Source), MinIntValue([Length(Source), Size]));
end;

function TrimSeparator(const S: string; Separator: Char): string;
var
  P: PChar;
begin
  Result := '';
  if S <> '' then
  begin
    P := PChar(S);
    while (P^ <> #0) and (P^ <> Separator) do
      Inc(P);
    if P^ <> #0 then
      Inc(P);
    Result := P;
  end;
end;

{ TComplexField }

const
  ComplexCharacters = AlphaNumeric;
  ComplexSeparators = [#1..#255] - ComplexCharacters;

function TComplexField.GetCount: Integer;
var
  P: PChar;
begin
  Result := 0;
  if FData <> '' then
  begin
    P := PChar(FData);
    while P^ <> #0 do
    begin
      while P^ in ComplexSeparators do
        Inc(P);
      if P^ in ComplexCharacters then
        Inc(Result);
      while P^ in ComplexCharacters do
        Inc(P);
    end;
  end;
end;

function TComplexField.IndexOf(const S: string): Integer;
var
  TempStr: string;
  I: Integer;
begin
  Result := -1;
  TempStr := UpperCase(S);
  for I := 0 to Count - 1 do
    if TempStr = UpperCase(Item[I]) then
    begin
      Result := I;
      Break;
    end;
end;

function TComplexField.GetItem(Index: Integer): string;
var
  StartPos: PChar;
  P: PChar;
  I: Integer;
begin
  Result := '';
  if (Index < 0) or (Index > Count - 1) then
    raise EComplexFieldError.Create(SRangeIndexError);
  P := PChar(FData);
  I := 0;
  while P^ <> #0 do
  begin
    while P^ in ComplexSeparators do
      Inc(P);
    StartPos := P;
    if P^ in ComplexCharacters then
    begin
      while P^ in ComplexCharacters do
        Inc(P);
      if I = Index then
      begin
        SetString(Result, StartPos, P - StartPos);
        Break;
      end;
      Inc(I);
    end;
  end;
end;

procedure TComplexField.SetItem(Index: Integer; const Value: string);
var
  P: PChar;
  StartPos: PChar;
  I: Integer;
begin
  if (Index < 0) or (Index > Count - 1) then
    raise EComplexFieldError.Create(SRangeIndexError);
  P := PChar(FData);
  StartPos := P;
  I := -1;
  while P^ <> #0 do
  begin
    while P^ in ComplexSeparators do
      Inc(P);
    StartPos := P;
    while P^ in ComplexCharacters do
      Inc(P);
    Inc(I);
    if I = Index then
      Break;
  end;
  FData := Copy(FData, 1, StartPos - PChar(FData)) + Value  +
    Copy(FData, P - PChar(FData) + 1, Length(FData));
end;

{ TEnumString }

constructor TEnumString.Create(Strings: TStrings);
begin
  inherited Create;
  FStrings := Strings;
end;

{ TEnumString.IEnumString }

function TEnumString.Next(celt: Longint;
  out elt; pceltFetched: PLongint): HResult;
var
  I: Integer;
begin
  I := 0;
  while (I < celt) and (FIndex < FStrings.Count) do
  begin
    TPointerList(elt)[I] := PWideChar(WideString(FStrings[FIndex]));
    Inc(I);
    Inc(FIndex);
  end;
  if pceltFetched <> nil then pceltFetched^ := I;
  if I = celt then Result := S_OK else Result := S_FALSE;
end;


function TEnumString.Skip(celt: Longint): HResult;
begin
  if (FIndex + celt) <= FStrings.Count then
  begin
    Inc(FIndex, celt);
    Result := S_OK;
  end
  else
  begin
    FIndex := FStrings.Count;
    Result := S_FALSE;
  end;
end;

function TEnumString.Reset: HResult;
begin
  FIndex := 0;
  Result := S_OK;
end;

function TEnumString.Clone(out enm: IEnumString): HResult;
begin
  try
    enm := TEnumString.Create(FStrings);
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

end.
