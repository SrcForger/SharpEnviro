
unit TextConverterUnit; {ver 1.2}
interface
{Translate a string in Ventura format into HTML format.}
function VenturaToHTML(const s: string): string;
{HTLM to ASCII, very rudimentary}
function HTMLtoASCII(const text: string): string;
{all ascii chars are converter to the most similar 7 bit equivalent.}
function ASCIIto7Bit(const s: string): string;
{letters to uppercase, separators to space and insert space
between numbers and letters}
function uniformText(const text: string): string;
{remove all tags enclosed by '<' '>' from the string.}
function RemoveTags(const s: string): string;
implementation
uses
  SysUtils;
const
  newLine = #13#10;
  CharSet1: array[32..222] of string = (
    ' ', '!', '"', { 032 - 034 }
    '#', '§', '%', '&', 'Ç', { 035 - 039 }
    '(', ')', '*', '+', ',', { 040 - 044 }
    '-', '.', '/', '0', '1', { 045 - 049 }
    '2', '3', '4', '5', '6', { 050 - 054 }
    '7', '8', '9', ':', ';', { 055 - 059 }
    '<', '=', '>', '?', '@', { 060 - 064 }
    'A', 'B', 'C', 'D', 'E', { 065 - 069 }
    'F', 'G', 'H', 'I', 'J', { 070 - 074 }
    'K', 'L', 'M', 'N', 'O', { 075 - 079 }
    'P', 'Q', 'R', 'S', 'T', { 080 - 084 }
    'U', 'V', 'W', 'X', 'Y', { 085 - 089 }
    'Z', '|', '\', '|', '^', { 090 - 094 }
    '_', '"', 'a', 'b', 'c', { 095 - 099 }
    'd', 'e', 'f', 'g', 'h', { 100 - 104 }
    'i', 'j', 'k', 'l', 'm', { 105 - 109 }
    'n', 'o', 'p', 'q', 'r', { 110 - 114 }
    's', 't', 'u', 'v', 'w', { 115 - 119 }
    'x', 'y', 'z', '{', '|', { 120 - 124 }
    '}', 'ò', ' ', '«', '¸', { 125 - 129 }
    'È', '‚', '‰', '‡', 'Â', { 130 - 134 }
    'Á', 'Í', 'Î', 'Ë', 'Ô', { 135 - 139 }
    'Ó', 'Ï', 'ƒ', '≈', '…', { 140 - 145 }
    'Ê', '∆', 'ˆ', 'Ù', 'Ú', { 146 - 149 }
    '˚', '˘', 'ˇ', '÷', '‹', { 150 - 154 }
    '¢', '£', '•', '???', 'É', { 155 - 159 }
    '·', 'Ì', 'Û', '˙', 'Ò', { 160 - 164 }
    '—', '™', '∫', 'ø', 'ì', { 165 - 169 }
    'î', '<', '>', '°', '´', { 170 - 174 }
    'ª', '„', 'ı', 'ÿ', '¯', { 175 - 179 }
    'ú', 'å', '¿', '√', '’', { 180 - 184 }
    'ß', 'á', 'Ü', '∂', '©', { 185 - 189 }
    'Æ', 'ô', ',,', '...', '%0', { 190 - 194 }
    'ï', 'ñ', 'ó', '∞', '¡', { 195 - 199 }
    '¬', '»', ' ', 'À', 'Ã', { 200 - 204 }
    'Õ', 'Œ', 'œ', '“', '”', { 205 - 209 }
    '‘', 'S', '&s', 'Ÿ', '⁄', { 210 - 214 }
    '€', 'ü', '?', { 215 - 217 }
    '⁄', '€', '‹', '›', 'ﬁ'); { 218 - 222 }
  CharSet2: array[32..217] of Char = (
    ' ', '!', #34, '#', '$', '%', '&', '''', '(', ')', '*', '+', ',', '-', '.',
      '/', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>', '?', '@', 'A', 'B',
      'C', 'D', 'E', 'F',
    'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U',
      'V', 'W', 'X', 'Y',
    'Z', '[', '\', ']', '^', '_', '''', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
      'i', 'j', 'k', 'l',
    'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '{',
      '|', '}', '~', ' ',
    '«', '°', '¢', '£', '§', '•', '¶', 'Á', 'ß', '®', '©', '´', '¨', '≠', 'Æ',
      'Ø', '∞', '±', '≤',
    '≥', '¥', 'µ', '∂', '∑', '∏', 'π', '∫', 'ª', 'º', 'Ω', 'æ', 'ø', '¿', '¡',
      '¬', '√', 'ƒ', '≈',
    '∆', '∫', 'ø', 'ì', 'î', 'ë', 'í', '°', '´', 'ª', '„', 'ı', '“', '”', '‘',
      'å', '¿', '√', '’',
    'ß', 'á', 'Ü', '∂', '©', 'Æ', 'ô', 'Ñ', 'Ö', '‚', '„', '‰', 'ó', '∞', '¿',
      '¬', '…', ' ', 'À',
    'Ã', 'Õ', 'Œ', 'œ', '“', '”', '‘', 'ä', 'ö', 'Ÿ', '€', '‹', '›', 'ﬂ');
  ANSIToHTMLMap: array['ô'..'ˇ'] of string = (
    'ô', 'ö', 'õ', 'ú', 'ù', 'û', 'ü',
    ' ', '°', '¢', '£', '§', { 160 - 164 }
    '•', '¶', 'ß', '®', '©', { 165 - 169 }
    '™', '´', '¨', '≠', 'Æ', { 170 - 174 }
    'Ø', '∞', '±', '≤', '≥', { 175 - 179 }
    '¥', 'µ', '∂', '∑', '∏', { 180 - 184 }
    'π', '∫', 'ª', 'º', 'Ω', { 185 - 189 }
    'æ', 'ø', '¿', '¡', '¬', { 190 - 194 }
    '√', 'ƒ', '≈', '∆', '«', { 195 - 199 }
    '»', '…', ' ', 'À', 'Ã', { 200 - 204 }
    'Õ', 'Œ', 'œ', '–', '—', { 205 - 209 }
    '“', '”', '‘', '’', '÷', { 210 - 214 }
    '◊', 'ÿ', 'Ÿ', '⁄', '€', { 215 - 219 }
    '®', '›', 'ﬁ', 'ﬂ', '‡', { 220 - 224 }
    '·', '‚', '„', '‰', 'Â', { 225 - 229 }
    'Ê', 'Á', 'Ë', 'È', 'Í', { 230 - 234 }
    'Î', 'Ï', 'Ì', 'Ó', 'Ô', { 235 - 239 }
    '', 'Ò', 'Ú', 'Û', 'Ù', { 240 - 244 }
    'ı', 'ˆ', '˜', '¯', '˘', { 245 - 249 }
    '˙', '˚', '¸', '˝', '˛', { 250 - 254 }
    'ˇ' { 255 }
    );
  ANSITo7Bit: array['ô'..'ˇ'] of string = (
    '(TM)', ' ', ' ', 'oe', '', 'z', 'Y',
    ' ', 'i', 'C', 'L', '$', { 160 - 164 }
    'Y', ' ', ' ', ' ', '(C)', { 165 - 169 }
    'a', '<<', ' ', '-', '(R)', { 170 - 174 }
    '-', '''', '+-', '2', '3', { 175 - 179 }
    'a', 'u', ' ', '.', 'c;', { 180 - 184 }
    '1;', 'o', '>>', '1/4', '1/2', { 185 - 189 }
    '3/4;', ' ', 'A', 'A', 'A', { 190 - 194 }
    'A', 'A', 'A', 'AE', 'C', { 195 - 199 }
    'E', 'E', 'E', 'E', 'I', { 200 - 204 }
    'I', 'I', 'I', 'D', 'N', { 205 - 209 }
    'O', 'O', 'O', 'O', 'O', { 210 - 214 }
    'x', 'O', 'U', 'U', 'U', { 215 - 219 }
    'U', 'Y', 'P', 'B', 'a', { 220 - 224 }
    'a', 'a', 'a', 'a', 'a', { 225 - 229 }
    'ae', 'c', 'e', 'e', 'e', { 230 - 234 }
    'e', 'i', 'i', 'i', 'i', { 235 - 239 }
    'o', 'n', 'o', 'o', 'o', { 240 - 244 }
    'o', 'o', '%', 'o', 'u', { 245 - 249 }
    'u', 'u', 'u', 'y', 'p', { 250 - 254 }
    'y' { 255 }
    );

function isAlpha(const c: char): boolean;
begin
  Result := c in ['a'..'z', 'Ò', 'A'..'Z', '—'];
end;

function isNumeric(const c: char): boolean;
begin
  Result := c in ['0'..'9'];
end;

function isAlphaNumeric(const c: char): boolean;
begin
  Result := isAlpha(c) or isNumeric(c);
end;
{remove all tags enclosed by '<' '>' from the string.}

function RemoveTags(const s: string): string;
var
  i: Integer;
  InTag: Boolean;
  L: Integer;
  tag: string;
begin
  Result := '';
  InTag := False;
  tag := '';
  L := Length(s);
  for i := 1 to L do
  begin
    if s[i] = '<' then
      inTag := True;
    if inTag then
      tag := tag + s[i]
    else if not (s[i] in [#10, #13]) then
      Result := Result + s[i];
    if s[i] = '>' then
    begin
      {tag replaces}
      tag := uppercase(tag);
      if (tag = '</TD>') then {P, TD}
        Result := Result + ' ';
      if (tag = '</P>') or (tag = '<BR>') or (tag = '</TR>') or
        (tag = '<LI>') or (tag = '</OL>') or (tag = '</UL>') or
        (StrLComp(Pchar(tag), '</H*>', 3) = 0) then {BR, H*, TR, LI}
        Result := Result + newLine;
      tag := '';
      inTag := False;
    end;
  end;
end;

function VenturaToHTML(const s: string): string;
var
  i: Integer;
  InTag: Boolean;
  Normalize, Number: string;
  Code: Integer;
  CharSet: Integer;
  L: Integer;
begin
  Result := '';
  Normalize := '';
  i := 1;
  InTag := False;
  CharSet := 1;
  L := Length(s);
  while i <= L do
  begin
    if s[i] = '<' then
      InTag := True
    else if s[i] = '>' then
    begin
      InTag := False;
      if i < L then
        if s[i + 1] in ['0'..'9'] then
          Result := Result + ' ';
    end
    else if (not InTag) then
      if s[i] in ['ô'..'ˇ'] then
        Result := Result + ANSIToHTMLMap[s[i]]
      else
      begin
        if s[i] = #13 then
          Result := Result + '<P>' + #13
        else
          Result := Result + s[i];
      end
    else
    begin
      case s[i] of
        'S': ;
        'b', 'B',
          'x', 'X':
          begin
            Result := Result + '<B>';
            Normalize := '</B>' + Normalize;
          end;
        'i', 'I':
          begin
            Result := Result + '<I>';
            Normalize := '</I>' + Normalize;
          end;
        'd', 'D':
          begin
            Number := Copy(s, i, 5);
            if Number = 'DJ255' then
              Inc(i, 4);
            Result := Result + Normalize;
            Normalize := '';
          end;
        'm', 'M':
          begin
            Number := Copy(s, i, 7);
            if Number = 'MSJ243>' then
            begin
              Inc(i, 5);
              Result := Result + '<SUP>';
              Normalize := '</SUP>' + Normalize;
            end;
          end;
        'v', 'V':
          begin
            Result := Result + '<SUB>';
            Normalize := '</SUB>' + Normalize;
          end;
        '^':
          begin
            Result := Result + '<SUP>';
            Normalize := '</SUP>' + Normalize;
          end;
        'R':
          begin
            Result := Result + '<P>';
          end;
        'T':
          begin
            { TO DO: Process hyperlink. }
          end;
        'J':
          begin
            Inc(i);
            Number := Copy(s, i, 3);
            if Number = '243' then
            begin
              Result := Result + '<SUP>';
              Normalize := '</SUP>' + Normalize;
            end
            else
            begin
              Result := Result + Normalize;
              if CharSet = 1 then
                Result := Result + '<FONT NAME=Verdana, Times New Roman>'
              else
                Result := Result + '<FONT NAME=Symbol>';
              Normalize := '</FONT>';
            end;
          end;
        'F':
          begin
            Inc(i);
            Number := Copy(s, i, 3);
            Inc(i, 2);
            if Number = '128' then
            begin
              CharSet := 2;
              Result := Result + '<FONT NAME=Symbol>';
            end
            else
            begin
              CharSet := 1;
              Result := Result + '<FONT NAME=Verdana, Times New Roman>'
            end;
            Normalize := '</FONT>' + Normalize;
          end;
        'P':
          begin
            Number := Copy(s, i, 3);
            Result := Result + '<FONT SIZE=' + Number + '>';
            Normalize := '</FONT>' + Normalize;
            Inc(i, 2);
          end;
        'H':
          begin
            Number := Copy(s, i, 4);
            Inc(i, 3);
            if Number = 'HIDE' then
              break;
          end;
        '$':
          begin
            Inc(i);
            Number := Copy(s, i, 4);
            if Number = 'E1/2' then
              Result := Result + 'Ω'
            else if Number = 'E1/4' then
              Result := Result + 'º'
            else if Number = 'E3/4' then
              Result := Result + 'æ';
            Inc(i, 3);
          end;
        '0'..'9':
          begin
            Number := '';
            while s[i] in ['0'..'9'] do
            begin
              Number := Number + s[i];
              Inc(i);
            end;
            Dec(i);
            Code := StrToInt(Number);
            if CharSet = 2 then
            begin
              if (Code > 31) and (Code < 217) then
              begin
                case Code of
                  032: Result := Result + ' ';
                  033: Result := Result + '°';
                  034: Result := Result + '"'; { Should be inverted. ?}
                  035: Result := Result + '#';
                  036: Result := Result + '$'; { Should be inverted. ?}
                  037: Result := Result + '%';
                  038: Result := Result + '&';
                  039: Result := Result + '''';
                    040: Result := Result + '(';
                  041: Result := Result + ')';
                  042: Result := Result + '*';
                  043: Result := Result + '+';
                  044: Result := Result + ',';
                  045: Result := Result + 'ó';
                  046..057: Result := Result + Char(Code);
                  058: Result := Result + ':';
                  059: Result := Result + ';';
                  060: Result := Result + '<';
                  061: Result := Result + '=';
                  062: Result := Result + '>';
                  063: Result := Result + '?';
                  064: Result := Result + '@';
                  065, 066: Result := Result + Char(Code);
                  067: Result := Result + '?';
                  068: Result := Result + '?';
                  069: Result := Result + 'E';
                  070: Result := Result + '?';
                  071: Result := Result + 'G';
                  072: Result := Result + '?';
                  073: Result := Result + '?';
                  074: Result := Result + 'J';
                  075: Result := Result + '?';
                  076: Result := Result + '?';
                  077: Result := Result + '?';
                  078: Result := Result + '?';
                  079: Result := Result + '?';
                  080: Result := Result + '?';
                  081: Result := Result + 'T';
                  082: Result := Result + '?';
                  083: Result := Result + 'S';
                  084: Result := Result + '?';
                  085: Result := Result + '?';
                  086: Result := Result + 'V';
                end;
              end;
            end
            else
            begin
              if Code in [33..222] then
                Result := Result + CharSet1[Code]
              else
                Result := Result + Char(Code);
            end;
          end;
      end;
    end;
    Inc(i);
  end;
  Result := Result + Normalize;
end;
{gives the ascii symbol for a & tag}

function HTMLSymbolToASCII(const s: string): string;
var
  i: char;
begin
  Result := ' ';
  for i := LOW(ANSIToHTMLMap) to HIGH(ANSItoHTMLMap) do
  begin
    if CompareStr(ANSItoHTMLMap[i], s) = 0 then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function HTMLtoASCII(const text: string): string;
var
  inTag: boolean;
  L, i: integer;
  s, Tag: string;
begin
  {remove tags}
  s := RemoveTags(text);
  {process symbols}
  Result := '';
  InTag := False;
  L := Length(s);
  for i := 1 to L do
  begin
    if s[i] = '&' then
    begin
      inTag := True;
      Tag := '';
    end;
    if not inTag then
      Result := Result + s[i]
    else
      Tag := Tag + s[i];
    if s[i] = ';' then
    begin
      inTag := False;
      Result := Result + HTMLSymbolToASCII(tag);
    end;
  end;
end;

function ASCIIto7Bit(const s: string): string;
var
  i: integeR;
begin
  Result := '';
  for i := 1 to length(s) do
  begin
    if s[i] > 'ô' then
      result := result + ANSITo7Bit[s[i]]
    else
      result := result + s[i];
  end;
end;

function uniformText(const text: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to length(text) do
  begin
    if (i > 1) and (isAlpha(text[i - 1]) and isNumeric(text[i])) or
      (isNumeric(text[i - 1]) and isAlpha(text[i])) then
      Result := Result + ' ';
    if isAlphanumeric(text[i]) then
      result := result + AnsiUppercase(text[i])
    else
      result := result + ' ';
  end;
end;
end.

