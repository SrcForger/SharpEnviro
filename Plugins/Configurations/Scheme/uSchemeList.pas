unit uSchemeList;

interface
uses
  // Standard
  Classes,
  ContNrs,
  SysUtils,
  Forms,
  dialogs,
  windows,

  // JCL
  jclIniFiles,
  JclSysInfo,
  JclSysUtils,
  JclFileUtils,
  JclStrings,
  SharpThemeApi,

  // JVCL
  JvSimpleXml,
  PngImageList,
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
    FColors: TObjectList;
    FAuthor: string;
    FName: string;
    FID: Integer;
    FDefaultItem: Boolean;
    FOwner: TObject;
    function GetSchemeColorItem(Index: integer): TSchemeColorItem;
    function GetTheme: String;
  public
    property Filename: string read FFilename write FFilename;
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property ID: Integer read FID write FID;
    property DefaultItem: Boolean read FDefaultItem write FDefaultItem;
    property Colors: TobjectList read FColors write FColors;
    property Owner: TObject read FOwner write fOwner;
    property Theme: String Read GetTheme;

    function Save: Boolean;
    property Color[Index: integer]: TSchemeColorItem read GetSchemeColorItem; default;
    function Count: Integer;
    function GetItemAsColorArray(AObjectList: TObjectList = nil): TSharpEColorSet;
    constructor Create(AOwner: TObject);
    destructor Destroy; override;

    procedure Assign(ADest: TobjectList); reintroduce;
    procedure LoadSkinColorDefaults(ATheme: string);
  end;

  TSchemeList = class
  private
    FItems: TObjectList;
    FTheme: String;
    function GetSchemeItem(Index: integer): TSchemeItem;
    procedure DeleteInvalidSchemes(ADirectory: string);

  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    function Add(AFilename: string): TSchemeItem; overload;
    //function Add(ASchemeName, AAuthor: string): TSchemeItem; overload;
    function Add(ASchemeItem: TSchemeItem): Integer; overload;
    function IndexOf(ASchemeItem: TSchemeItem): Integer;
    function IndexOfFileName(AFileName: string): Integer;
    function IndexOfSkinName(ASkinName: string): Integer;
    procedure Delete(ASchemeItem: TSchemeItem);
    function Count: Integer;

    procedure Load(ATheme: string);
    procedure Save; overload;
    procedure SaveDefault(ATheme, ASkinName, ASchemeName: string);
    function GetDefault(ATheme, ASkinName: string): string;

    property Theme: String read FTheme write FTheme;
    property Item[Index: integer]: TSchemeItem read GetSchemeItem; default;

    function GetSkinScheme(ATheme: string): string;
    function GetSkinSchemeDir(ATheme: String): String;
    function GetSkinName(ATheme: String): String;
    function GetSkinColorByTag(ATag: String):TSharpESkinColor;

  end;

implementation

{ TSchemeItem }

procedure TSchemeItem.Assign(ADest: TobjectList);
var
  i:Integer;
  tmp, new: TSchemeColorItem;
begin
  ADest.Clear;

  For i := 0 to Pred(FColors.Count) do begin
    tmp := TSchemeColorItem(FColors[i]);
    new := TSchemeColorItem.Create;
    new.Color := tmp.Color;
    new.Tag := tmp.Tag;
    new.UnparsedColor := tmp.UnparsedColor;
    ADest.Add(New)
  end;
end;

function TSchemeItem.Count: Integer;
begin
  Result := FColors.Count;
end;

constructor TSchemeItem.Create(AOwner:TObject);
begin
  FColors := TObjectList.Create;
  FDefaultItem := False;
  FID := -1;
  FFilename := '';
  FName := 'Untitled' + inttostr(Self.Count);
  FAuthor := 'Unknown';
  FOwner := AOwner;
end;

destructor TSchemeItem.Destroy;
begin

  if Assigned(FColors) then
    FColors.Free;

  inherited;
end;

function TSchemeItem.GetItemAsColorArray(AObjectList: TObjectList = nil): TSharpEColorSet;
var
  i: Integer;
  tmpList: TObjectList;
begin
  if AObjectList = nil then
    tmpList := FColors
  else
    tmpList := AObjectList;

  SetLength(Result, tmpList.Count);
  for i := 0 to Pred(tmpList.Count) do
    with Result[i] do
    begin
      Color := TSchemeColorItem(tmpList[i]).Color;
      Tag := TSchemeColorItem(tmpList[i]).Tag;

      schemetype := TSchemeList(FOwner).GetSkinColorByTag(Tag).schemetype;
    end;
end;

function TSchemeItem.GetSchemeColorItem(Index: integer): TSchemeColorItem;
begin
  Result := TSchemeColorItem(FColors[Index]);
end;

function TSchemeItem.GetTheme: String;
begin
  Result := TSchemeList(FOwner).Theme;
end;

procedure TSchemeItem.LoadSkinColorDefaults(ATheme: string);
var
  s: string;
  xml: TJvSimpleXml;
  i: Integer;
  tmpColor: TSchemeColorItem;
begin
  s := TSchemeList(FOwner).GetSkinScheme(ATheme);
  xml := TJvSimpleXML.Create(nil);
  try

    xml.LoadFromFile(s);
    Colors.Clear;

    for i := 0 to Pred(xml.Root.Items.Count) do
    begin

      tmpColor := TSchemeColorItem.Create;
      tmpColor.Tag := xml.Root.Items[i].Items.Value('Tag', '');
      tmpColor.Color := ParseColor(PChar(xml.Root.Items[i].Items.Value('Default', '0')));
      Colors.Add(tmpColor);
    end;
  finally
    xml.Free;
  end;
end;

function TSchemeItem.Save: Boolean;
var
  xml: TJvSimpleXML;
  i: Integer;
begin
  Result := True;
  xml := TJvSimpleXML.Create(nil);
  try
    xml.Root.Name := 'SharpESkinScheme';
    xml.Root.Items.Add('Info');
    with xml.Root.Items.ItemNamed['Info'] do
    begin
      Items.Add('Name', FName);
      Items.Add('Author', FAuthor);
    end;
    for i := 0 to Pred(FColors.Count) do
    begin
      with xml.Root.Items.Add('Item') do
      begin
        Items.Add('Tag', TSchemeColorItem(FColors[i]).Tag);
        if TSchemeColorItem(FColors[i]).UnparsedColor = '' then
          Items.Add('Color', TSchemeColorItem(FColors[i]).Color)
        else
          Items.Add('Color', TSchemeColorItem(FColors[i]).UnparsedColor);
      end;
    end;
  finally

    FFilename := TSchemeList(FOwner).GetSkinSchemeDir(Theme) + trim(StrRemoveChars(Self.Name,
      ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']) + '.xml');
    xml.SaveToFile(FFilename);
    xml.Free;
  end;
end;

function TSchemeList.GetSkinSchemeDir(ATheme: String): String;
var
  xml: TJvSimpleXml;
  sSkin, sFile: string;
begin
  Result := '';
  sFile := GetSharpeUserSettingsPath + 'Themes\' + ATheme + '\Skin.xml';

  if fileExists(sFile) then
  begin
    xml := TJvSimpleXML.Create(nil);
    try
      xml.LoadFromFile(sFile);
      sSkin := xml.Root.Items.Value('Skin');
      Result := GetSharpeDirectory+'Skins\' + sSkin + '\Schemes\';

    finally
      xml.Free;
    end;
  end;
end;
{ TSchemeList }

procedure TSchemeList.Load(ATheme: string);
var
  s: string;
  tmpStrl: TStringList;
  i: Integer;
begin
  s := getskinschemedir(ATheme);

  tmpStrl := TStringList.Create;
  try
    BuildFileList(s + '*.xml', faAnyFile, tmpStrl);

    for i := 0 to Pred(tmpStrl.Count) do
    begin
      Add(s + tmpStrl[i]);
    end;
  finally
    tmpStrl.Free;
  end;
end;

constructor TSchemeList.Create;
begin
  fItems := TObjectList.Create;
end;

function TSchemeList.Add(AFilename: string): TSchemeItem;
var
  xml: TJvSimpleXml;
  tmpColor: TSchemeColorItem;
  i: Integer;
  s: string;
begin
  Result := TSchemeItem.Create(Self);
  Result.Filename := AFilename;
  Result.ID := FItems.Count;
  Result.Colors := TObjectList.Create;

  xml := TJvSimpleXML.Create(nil);
  try

    xml.LoadFromFile(AFilename);

    for i := 0 to Pred(xml.Root.Items.Count) do
    begin

      if CompareText(xml.Root.Items.Item[i].Name,'Info') = 0 then
      begin
        Result.Author := xml.Root.Items[i].Items.Value('Author', 'Untitled');
        Result.Name := xml.Root.Items[i].Items.Value('Name', 'Unknown');

        if Result.Name = '' then
          Result.Name := 'Untitled' + IntToStr(i);

        If Result.Author = '' then
          Result.Author := 'Unknown';

        s := GetSkinScheme(FTheme);// GetSchemeName;
        if CompareText(s, Result.Name) = 0 then
          Result.DefaultItem := True;
      end
      else
      begin
        tmpColor := TSchemeColorItem.Create;
        tmpColor.Tag := xml.Root.Items[i].Items.Value('Tag', '');
        tmpColor.UnparsedColor := xml.Root.Items[i].Items.Value('Color', '');
        tmpColor.Color := ParseColor(PChar(xml.Root.Items[i].Items.Value('Color', '')));
        Result.Colors.Add(tmpColor);
      end;
    end;

  finally
    xml.Free;
    FItems.Add(Result);
  end;
end;

procedure TSchemeList.Save;
var
  i: Integer;
  sTmp: string;
begin
  // Backup existing schemes
  sTmp := GetSkinSchemeDir(FTheme);// GetSchemeDirectory;
  DeleteInvalidSchemes(sTmp);

  // Save new schemes
  for i := 0 to Pred(FItems.Count) do
  begin
    TSchemeItem(FItems[i]).Save;
  end;
end;

procedure TSchemeList.DeleteInvalidSchemes(ADirectory: string);
var
  files: TStringList;
  i: Integer;
begin
  files := TStringList.Create;
  try
    BuildFileList(GetSkinSchemeDir(FTheme) + '*.xml', faAnyFile, files);
    for i := 0 to Pred(files.Count) do
      if IndexOfFileName(files[i]) = -1 then
        SysUtils.DeleteFile(GetSkinSchemeDir(FTheme) + files[i]);
  finally
    files.Free;
  end;

end;

function TSchemeList.GetSchemeItem(Index: integer): TSchemeItem;
begin
  Result := TSchemeItem(FItems[Index]);
end;

destructor TSchemeList.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TSchemeList.Count: Integer;
begin
  Result := FItems.Count;
end;

procedure TSchemeList.Clear;
begin
  FItems.Clear;
end;

function TSchemeList.IndexOf(ASchemeItem: TSchemeItem): Integer;
var
  n: Integer;
begin
  Result := -1;
  n := FItems.IndexOf(ASchemeItem);
  if n <> -1 then
    Result := n;
end;

procedure TSchemeList.Delete(ASchemeItem: TSchemeItem);
var
  n: Integer;
begin
  n := FItems.IndexOf(ASchemeItem);
  if n <> -1 then
    FItems.Delete(n);
end;

procedure TSchemeList.SaveDefault(ATheme, ASkinName, ASchemeName: string);
var
  xml: TJvSimpleXML;
  s: string;
begin
  xml := TJvSimpleXML.Create(nil);
  try
    s := GetSharpeUserSettingsPath + 'Themes\' + ATheme + '\' + 'Scheme.xml';
    forcedirectories(ExtractFilePath(s));

    xml.Root.Clear;
    xml.Root.Name := 'SharpEThemeScheme';
    xml.Root.Items.Add('Scheme', ASchemeName);
    xml.SaveToFile(s);
  finally
    xml.Free;
  end;
end;

function TSchemeList.GetDefault(ATheme, ASkinName: string): string;
var
  xml: TJvSimpleXML;
  s: string;
begin
  Result := '';
  xml := TJvSimpleXML.Create(nil);
  try
    s := GetSharpeUserSettingsPath + 'Themes\' + ATheme + '\' + 'Scheme.xml';

    if fileExists(s) then
    begin
      xml.LoadFromFile(s);
      Result := xml.Root.Items.Value('Scheme', 'Default');
    end;
  finally
    xml.Free;
  end;
end;

function TSchemeList.IndexOfFileName(AFileName: string): Integer;
var
  n: Integer;
begin
  Result := -1;
  for n := 0 to Pred(FItems.Count) do
    if CompareText(ExtractFileName(TSchemeItem(FItems[n]).Filename), AFileName) = 0 then
    begin
      Result := n;
      break
    end;
end;

function TSchemeList.IndexOfSkinName(ASkinName: string): Integer;
var
  n: Integer;
begin
  Result := -1;
  for n := 0 to Pred(FItems.Count) do
    if CompareText(TSchemeItem(FItems[n]).Name, ASkinName) = 0 then
    begin
      Result := n;
      break
    end;
end;

function TSchemeList.Add(ASchemeItem: TSchemeItem): Integer;
begin
  Result := FItems.Add(ASchemeItem);
end;

function TSchemeList.GetSkinScheme(ATheme: string): string;
var
  xml: TJvSimpleXml;
  sSkin, sFile: string;
begin
  Result := '';
  sFile := GetSharpeUserSettingsPath + 'Themes\' + ATheme + '\Skin.xml';

  if fileExists(sFile) then
  begin
    xml := TJvSimpleXML.Create(nil);
    try
      xml.LoadFromFile(sFile);
      sSkin := xml.Root.Items.Value('Skin');
      Result := GetSharpeDirectory+'Skins\' + sSkin + '\Scheme.xml';

    finally
      xml.Free;
    end;
  end;
end;

function TSchemeList.GetSkinName(ATheme: String): String;
var
  xml: TJvSimpleXml;
  sSkin, sFile: string;
begin
  Result := '';
  sFile := GetSharpeUserSettingsPath + 'Themes\' + ATheme + '\Skin.xml';

  if fileExists(sFile) then
  begin
    xml := TJvSimpleXML.Create(nil);
    try
      xml.LoadFromFile(sFile);
      sSkin := xml.Root.Items.Value('Skin');
      Result := sSkin;

    finally
      xml.Free;
    end;
  end;
end;

function TSchemeList.GetSkinColorByTag(ATag: String): TSharpESkinColor;
var
  sSchemeFile:String;
  xml:TJvSimpleXML;
  s: String;
  i: Integer;
begin

  sSchemeFile := GetSkinScheme(FTheme);
  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(sSchemeFile);
    For i := 0 to Pred(xml.Root.Items.Count) do begin

      if CompareText(xml.Root.Items.Item[i].Items.Value('Tag'),ATag) = 0 then begin
        Result.Name := xml.Root.Items.Item[i].Items.Value('Name');
        Result.Tag := xml.Root.Items.Item[i].Items.Value('Tag');
        Result.Info := xml.Root.Items.Item[i].Items.Value('Info');
        Result.Color := xml.Root.Items.Item[i].Items.IntValue('Default');
        s := xml.Root.Items.Item[i].Items.Value('Type');
        if s <> '' then begin
          if CompareText(s,'integer') = 0 then
            Result.schemetype := stInteger else
          if CompareText(s,'bool') = 0 then
            Result.schemetype := stBoolean else
        end else
          Result.schemetype := stColor;
      end;
    end;
  finally
    xml.Free;
  end;
end;

end.

