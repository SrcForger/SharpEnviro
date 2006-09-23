unit SharpECustomSkinSettings;

interface

uses JvSimpleXML,SysUtils, SharpApi;

type
   TSharpECustomSkinSettings = class
  private
    FXML : TJvSimpleXML;
    FPath : String;
    function GetXMLElem : TJvSimpleXMLElem;
  public
    procedure LoadFromXML(ppath: string);
    procedure Clear;
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property xml : TJvSimpleXMLElem read GetXMLElem;
    property Path : String read FPath;
  end;

implementation

function TSharpECustomSkinSettings.GetXMLElem : TJvSimpleXMLElem;
begin
  result :=  FXML.Root;
end;

procedure TSharpECustomSkinSettings.LoadFromXML(ppath: string);
var
  dir : String;
  fn : String;
begin
  Clear;
  dir := ppath;
  if FileExists(dir + 'custom.xml') then fn := dir + 'custom.xml'
     else
     begin
       {$WARNINGS OFF}
       dir := IncludeTrailingBackSlash(ExtractFileDir(SharpApi.GetCurrentSkinFile));
       {$WARNINGS ON}
       if FileExists(dir + 'custom.xml') then fn := dir + 'custom.xml'
          else exit;
     end;

  try
    FXML.LoadFromFile(fn);
    FPath := dir;
  except
    Clear;
  end;
end;

procedure TSharpECustomSkinSettings.Clear;
begin
  FXML.Root.Items.Clear;
  FPath := '';
end;

constructor TSharpECustomSkinSettings.Create;
begin
  inherited Create;
  FXML := TJvSimpleXML.Create(nil);
  Clear;
end;

destructor TSharpECustomSkinSettings.Destroy;
begin
  FXML.Free;
  Inherited Destroy;
end;

end.
