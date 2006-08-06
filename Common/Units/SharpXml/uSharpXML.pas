unit uSharpXML;

interface

uses
  Classes, SysUtils, Dialogs, JvSimpleXML, uStringUtils;

type
  TSharpXML = class(TJvSimpleXML)
  public
    constructor Create; overload;
    constructor Create(XMLSource: string); overload;
    constructor CreateFromFile(Filename: string);

    function FindElem(Path: string; Create: boolean = false): TJvSimpleXMLElem;
    function ReadString(Path: string; Default: string = ''): string;
    function ReadInteger(Path: string; Default: integer = -1): integer;
    procedure WriteString(Path, Value: string);
    procedure WriteInteger(Path: string; Value: integer);
  end;

implementation

constructor TSharpXML.Create;
begin
  inherited Create(nil);
end;

constructor TSharpXML.Create(XMLSource: string);
begin
  Create;
  LoadFromString(XMLSource);
end;

constructor TSharpXML.CreateFromFile(Filename: string);
begin
  Create;
  LoadFromFile(Filename);
end;



function TSharpXML.FindElem(Path: string; Create: boolean = false): TJvSimpleXMLElem;
var
  Elem          : TJvSimpleXMLElem;
  Continue      : boolean;
  PathList      : TStringArray;
  PathIndex     : integer;
begin
  Elem := Root;
  Continue := true;

  PathList := Explode('/', LowerCase(Path + '/'));
  PathIndex := 0;

  if LowerCase(elem.Name) = PathList[0] then
    repeat
      Inc(PathIndex);
      elem := elem.Items.ItemNamed[PathList[PathIndex]];
      if elem <> nil then
        Result := elem
      else if Create and (PathIndex < Length(PathList)-1) then begin
        //elem := TJvSimpleXMLElemClassic.Create(Result);
        //elem.Name := PathList[PathIndex];
        elem := Result.Items.Add(PathList[PathIndex], '');
        Result := elem;
      end;
    until elem = nil;

  if PathIndex < Length(PathList)-1 then
    Result := nil;
end;

function TSharpXML.ReadString(Path: string; Default: string = ''): string;
var
  Elem          : TJvSimpleXMLElem;
begin
  Elem := FindElem(Path);
  if Elem <> nil then
    Result := Elem.Value
  else
    Result := Default;
end;

function TSharpXML.ReadInteger(Path: string; Default: integer = -1): integer;
var
  Elem          : TJvSimpleXMLElem;
begin
  Elem := FindElem(Path);
  if Elem <> nil then
    Result := Elem.IntValue
  else
    Result := Default;
end;

procedure TSharpXML.WriteString(Path, Value: string);
var
  Elem          : TJvSimpleXMLElem;
begin
  Elem := FindElem(Path, True);
  if Elem <> nil then
    Elem.Value := Value
  else
    ShowMessage('WARNING: Elem not created ' + Path + ' = ' + Copy(Value,1,10));
end;

procedure TSharpXML.WriteInteger(Path: string; Value: integer);
var
  Elem          : TJvSimpleXMLElem;
begin
  Elem := FindElem(Path, True);
  if Elem <> nil then
    Elem.IntValue := Value
  else
    ShowMessage('WARNING: Elem not created ' + Path + ' = ' + IntToStr(Value));
end;

end.
