unit uSchemeList;

interface
uses
  Classes,
  ContNrs,
  SysUtils,
  Forms,
  windows,
  JclFileUtils,
  JclStrings,
  SharpThemeApiEx,
  uISharpETheme,
  uThemeConsts,
  JclSimpleXml,
  SharpFileUtils,
  SharpApi,
  graphics;

type
  TSchemeColorItem = class(TObject)
  private
    FColor: TColor;
    FTag: string;
    FUnparsedColor: string;
    FData: Pointer;
  public
    property Tag: string read FTag write FTag;
    property Color: TColor read FColor write FColor;
    property UnparsedColor: string read FUnparsedColor write FUnparsedColor;

    property Data: Pointer read FData write FData;
  end;

  TSchemeItem = class(TPersistent)
  private
    FFilename: string;
    FAuthor: string;
    FName: string;
    FID: Integer;
    FDefaultItem: Boolean;
    FOwner: TObject;

  public
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property ID: Integer read FID write FID;
    property DefaultItem: Boolean read FDefaultItem write FDefaultItem;
    property Owner: TObject read FOwner write fOwner;

    constructor Create(AOwner: TObject);
  end;

  TSchemeManager = class
  private
    FPluginID: string;
    FTheme: ISharpETheme;
  public

    procedure Delete(ASchemeItem: TSchemeItem);
    procedure Copy(ASchemeItem: TSchemeItem; var ACopyName:String);
    procedure Save(AName: String; AAuthor: String;AOriginalScheme:String='');
    property PluginID: string read FPluginID write FPluginID;
    property Theme: ISharpETheme read FTheme write FTheme;
    procedure GetSchemeList(APluginID: String; AStringList: TStrings);

    function XmlGetSchemeListAsCommaText: string;    
  end;

var
  FSchemeManager: TSchemeManager;

implementation

{ TSchemeItem }

constructor TSchemeItem.Create(AOwner: TObject);
begin
  FDefaultItem := False;
  FID := -1;
  FFilename := '';
  FAuthor := 'Unknown';
  FOwner := AOwner;
end;

{ TSchemeManager }

procedure TSchemeManager.Copy(ASchemeItem: TSchemeItem; var ACopyName:String);
var
  sFilename, s: string;
  sCopyName, sScheme: string;
  sSchemeDir: string;
  xml: TJclSimpleXML;
  n, n2:Integer;
begin

  sSchemeDir := FTheme.Scheme.Directory;
  sScheme := sSchemeDir + ASchemeItem.Name + '.xml';
  sCopyName := ASchemeItem.Name;

  // If already copy, remove copy symbol
  n := pos(')',sCopyName);
  if n <> 0 then begin

    n2 := n;
    repeat
      s := sCopyName[n2];
      n2 := n2 - 1;
    until ((n2 <= 1) or (s = '(')) ;

    if n2 > 1 then
      sCopyName := System.Copy(sCopyName,1,n2-1);
  end;

  n := 0;
  s := sCopyName;
  repeat
    s := format('%s (%d)',[sCopyName,n]);
    sFilename := sSchemeDir + s + '.xml';
    inc(n);
  until not (fileExists(sFilename));
  sCopyName := s;

  FileCopy(sScheme, sFilename, False);
  xml := TJclSimpleXML.Create;
  try
    xml.LoadFromFile(sFilename);
    if xml.Root.Items.ItemNamed['info'] <> nil then
      xml.Root.Items.ItemNamed['info'].Items.ItemNamed['name'].Value := sCopyName;
    xml.SaveToFile(sFileName);
  finally
    xml.Free;

    ACopyName := sCopyName;
  end;

end;

procedure TSchemeManager.Delete(ASchemeItem: TSchemeItem);
var
  sFilename: string;
  sDeleteName: string;
  sSchemeDir: string;
begin
  sSchemeDir := Theme.Scheme.Directory;
  sDeleteName := ASchemeItem.Name;
  sFilename := sSchemeDir + sDeleteName + '.xml';

  FileDelete(sFilename, True);
end;

procedure TSchemeManager.Save(AName, AAuthor: String;AOriginalScheme:String='');
var
  XML : TJclSimpleXML;
  sName: String;
  sScheme,sFileName : String;
begin
  // Save
  sName := trim(StrRemoveChars(AName, ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));

  if AOriginalScheme <> '' then
  begin
    sFilename := Theme.Scheme.Directory + sName + '.xml';
    sScheme := Theme.Scheme.Directory + AOriginalScheme + '.xml';
    FileCopy(sScheme, sFilename, False);

    XML := TJclSimpleXML.Create;
    try
      XML.LoadFromFile(sFilename);
      if XML.Root.Items.ItemNamed['Info'] <> nil then
        XML.Root.Items.ItemNamed['Info'].Clear
      else XML.Root.Items.Add('Info');
      with XML.Root.Items.ItemNamed['Info'].Items do
      begin
        Add('Name',sName);
        Add('Author',AAuthor);
      end;
      XML.SaveToFile(sFilename);
    finally
      XML.Free;
    end;
  end else
  begin
    sFilename := Theme.Scheme.Directory + sName + '.xml';

    XML := TJclSimpleXML.Create;
    try
    XML.Root.Name := 'SharpESkinScheme';
    with XML.Root.Items.Add('Info').Items do
    begin
      Add('Name',sName);
      Add('Author', AAuthor);
    end;
    XML.SaveToFile(sFilename);
    finally
      XML.Free;
    end;
  end;
end;

function TSchemeManager.XmlGetSchemeListAsCommaText: string;
var
  sSchemeDir: string;
  tmpStringList: TStringList;
begin
  sSchemeDir := Theme.Scheme.Directory;

  tmpStringList := TStringList.Create;
  try
    SharpFileUtils.FindFiles(tmpStringList, sSchemeDir, '*.xml');
    tmpStringList.Sort;
    result := tmpStringList.CommaText;
  finally
    tmpStringList.Free;
  end;
end;


procedure TSchemeManager.GetSchemeList(APluginID: String; AStringList: TStrings);
var
  s, sSchemeDir, sXmlSearch: string;
  xml: TJclSimpleXml;
  sList: TStringList;
  i, j: Integer;
  newItem: TSchemeItem;
begin
  sSchemeDir := Theme.Scheme.Directory;
  sXmlSearch := sSchemeDir + '*.xml';

  sList := TStringList.Create;
  try
    sList.CommaText := XmlGetSchemeListAsCommaText;
    sList.Sort;

    for i := 0 to Pred(sList.Count) do begin
      xml := TJclSimpleXML.Create;
      try
        xml.LoadFromFile(sList[i]);

        newItem := TSchemeItem.Create(nil);

        for j := 0 to Pred(xml.Root.Items.Count) do begin
          if CompareText(xml.Root.Items.Item[j].Name, 'Info') = 0 then begin
            newItem.Author := xml.Root.Items[j].Items.Value('Author', 'Untitled');
            newItem.Name := xml.Root.Items[j].Items.Value('Name', 'Unknown');

            if newItem.Name = '' then
              newItem.Name := 'Untitled' + IntToStr(j);

            if newItem.Author = '' then
              newItem.Author := 'Unknown';

            s := Theme.Scheme.Name;
            if CompareText(s, newItem.Name) = 0 then
              newItem.DefaultItem := True;
          end;
        end;

        AStringList.AddObject(newItem.Name, newItem);

      finally
        xml.Free;
      end;
    end;
  finally
    sList.Free;
  end;
end;

end.

