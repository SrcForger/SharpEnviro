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
  SharpThemeApi,
  JvSimpleXml,
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
  public

    procedure Delete(ASchemeItem: TSchemeItem);
    procedure Copy(ASchemeItem: TSchemeItem; var ACopyName:String);
    procedure Save(AName: String; AAuthor: String;AOriginalScheme:String='');
    property PluginID: string read FPluginID write FPluginID;
    procedure GetSchemeList(APluginID: String; AStringList: TStrings);
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
  sSkinDir, sCopyName, sScheme: string;
  sSchemeDir: string;
  xml: TJvSimpleXML;
  n, n2:Integer;
begin

  sSkinDir := GetSharpeDirectory + 'skins';
  sSchemeDir := Format('%s\%s\schemes\', [sSkinDir, XmlGetSkin(FPluginID)]);
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
  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(sFilename);
    if xml.Root.Items.ItemNamed['info'] <> nil then
      xml.Root.Items.ItemNamed['info'].Items.ItemNamed['name'].Value := sCopyName;
  finally
    xml.SaveToFile(sFilename);
    xml.Free;

    ACopyName := sCopyName;
  end;

end;

procedure TSchemeManager.Delete(ASchemeItem: TSchemeItem);
var
  sFilename: string;
  sSkinDir, sDeleteName: string;
  sSchemeDir: string;
begin

  sSkinDir := GetSharpeDirectory + 'skins';
  sSchemeDir := Format('%s\%s\schemes\', [sSkinDir, XmlGetSkin(FPluginID)]);
  sDeleteName := ASchemeItem.Name;
  sFilename := sSchemeDir + sDeleteName + '.xml';

  FileDelete(sFilename, True);
end;

procedure TSchemeManager.Save(AName, AAuthor: String;AOriginalScheme:String='');
var
  colors: TSharpEColorSet;
  sName: String;
begin

  // Get defaults
  if AOriginalScheme = '' then
    XmlGetThemeScheme(XmlGetSkin(FPluginID),colors) else
    XmlGetThemeScheme(FPluginId,AOriginalScheme,colors);

  // Save
  sName := trim(StrRemoveChars(AName, ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));
  XmlSetThemeScheme(FPluginID,sName,colors,AAuthor);
end;

procedure TSchemeManager.GetSchemeList(APluginID: String; AStringList: TStrings);
var
  s, sSchemeDir, sSkinDir, sXmlSearch: string;
  xml: TJvSimpleXml;
  sList: TStringList;
  i, j: Integer;
  newItem: TSchemeItem;
begin
  sSkinDir := GetSharpeDirectory + 'skins';
  sSchemeDir := Format('%s\%s\schemes\', [sSkinDir, XmlGetSkin(APluginID)]);
  sXmlSearch := sSchemeDir + '*.xml';

  sList := TStringList.Create;
  try
    AdvBuildFileList(sXmlSearch, faDirectory, sList, amAny, [flRecursive, flFullNames]);
    sList.Sort;

    for i := 0 to Pred(sList.Count) do begin
      xml := TJvSimpleXML.Create(nil);
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

            s := XmlGetScheme(FPluginID);
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

