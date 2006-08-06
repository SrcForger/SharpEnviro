unit uStringUtils;

interface

type
  TStringArray = array of String;


function StripNotAlphaNumeric(s: String): String;
function StripHTML(s: String): String;
function Implode(const cSeparator: String; const cArray: TStringArray): String;
function Explode(const cSeparator, vString: String): TStringArray;


implementation

function StripNotAlphaNumeric(s: String): String;
var
  i             : Integer;
  c             : Integer;
begin
  result := '';
  for i := 1 to Length(s) do
  begin
    c := Ord(s[i]);
        // A-Z                      // a-z
    if ((c >= 65) and (c <= 90)) or ((c >= 97) and (c <= 122)) or
        // 0-9
       ((c >= 48) and (c <= 57)) then
      Result := Result + Chr(c);
  end;
end;

function StripHTML(s: String): String;
var
  i             : Integer;
  bInTag        : Boolean;
  sTagName      : String;
begin

  bInTag := False;
  Result := '';
  sTagName := '';

  for i := 1 to Length(s) do
  begin
    case s[i] of
      '<': begin
        bInTag := True;
        sTagName := '';
      end;
      '>': begin
        bInTag := False;
        if sTagName = 'p' then
          Result := Result + Chr(13) + Chr(10) + Chr(13) + Chr(10);
      end;
      else
        if not bInTag then
          Result := Result + s[i]
        else if (s[i] <> ' ') and (s[i] <> '/') then
          sTagName := sTagName + s[i];
    end;
  end;
end;

(*

Implode and Explode courtesy of Jan Christian Meyer [Hazard]
http://www.swissdelphicenter.ch/torry/showcode.php?id=1326

*)

function Implode(const cSeparator: String; const cArray: TStringArray): String;
var
  i             : Integer;
begin
  Result := '';
  for i := 0 to Length(cArray) -1 do begin
    Result := Result + cSeparator + cArray[i];
  end;
  System.Delete(Result, 1, Length(cSeparator));
end;

function Explode(const cSeparator, vString: String): TStringArray;
var
  i: Integer;
  S: String;
begin
  S := vString;
  SetLength(Result, 0);
  i := 0;
  while Pos(cSeparator, S) > 0 do begin
    SetLength(Result, Length(Result) +1);
    Result[i] := Copy(S, 1, Pos(cSeparator, S) -1);
    Inc(i);
    S := Copy(S, Pos(cSeparator, S) + Length(cSeparator), Length(S));
  end;
  SetLength(Result, Length(Result) +1);
  Result[i] := Copy(S, 1, Length(S));
end;

end.
