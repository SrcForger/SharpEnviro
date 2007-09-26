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

  public
    property Filename: string read FFilename write FFilename;
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property ID: Integer read FID write FID;
    property DefaultItem: Boolean read FDefaultItem write FDefaultItem;
    property Colors: TobjectList read FColors write FColors;
    property Owner: TObject read FOwner write fOwner;

    property Color[Index: integer]: TSchemeColorItem read GetSchemeColorItem; default;
    function Count: Integer;
    function GetItemAsColorArray(AObjectList: TObjectList = nil): TSharpEColorSet;
    constructor Create(AOwner: TObject);
    destructor Destroy; override;

    procedure Assign(ADest: TobjectList); reintroduce;
    function LoadSkinColorDefaults(ATheme: string): Boolean;

    function Save:boolean;
  end;

  TSchemeList = class
  private
    FItems: TObjectList;
    FTheme: string;
    function GetSchemeItem(Index: integer): TSchemeItem;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    function Add(ASchemeItem: TSchemeItem): Integer; overload;
    procedure Delete(ASchemeItem: TSchemeItem);

  end;

  TSchemeManager = class
  private
    FTheme: string;
    FDefaultScheme: string;
    function GetSkinScheme: string;

  public

    procedure Edit(AName, ASchemeItem: TSchemeItem);
    procedure Delete(AName: string);
    procedure SetDefaultScheme(AName: string);

    procedure Copy(ASchemeItem: TSchemeItem);

    function GetDefaultScheme: string;
    function GetSkinColorByTag(ATag: string): TSharpESkinColor;
    procedure GetSchemeList(AStringList: TStrings);
    function GetSkinValid: Boolean;
    function GetSkinSchemeDir(ATheme: string): string;
    function GetSkinName: string;

    property Theme: string read FTheme write FTheme;
    property DefaultScheme: string read GetDefaultScheme write FDefaultScheme;

    

  end;

  var
    FSchemeManager:TSchemeManager;

implementation

{ TSchemeItem }

procedure TSchemeItem.Assign(ADest: TobjectList);
var
  i: Integer;
  tmp, new: TSchemeColorItem;
begin
  ADest.Clear;

  for i := 0 to Pred(FColors.Count) do begin
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

constructor TSchemeItem.Create(AOwner: TObject);
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

function TSchemeITem.GetItemAsColorArray(AObjectList: TObjectList = nil): TSharpEColorSet;
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

      schemetype := FSchemeManager.GetSkinColorByTag(Tag).schemetype;
    end;
end;

function TSchemeItem.GetSchemeColorItem(Index: integer): TSchemeColorItem;
begin
  Result := TSchemeColorItem(FColors[Index]);
end;

function TSchemeItem.LoadSkinColorDefaults(ATheme: string):Boolean;
var
  s: string;
  xml: TJvSimpleXml;
  i: Integer;
  tmpColor: TSchemeColorItem;
begin
  Result := False;
  s := FSchemeManager.GetSkinScheme;
  if s = '' then exit;

  xml := TJvSimpleXML.Create(nil);
  try

    xml.LoadFromFile(s);
    Colors.Clear;
    Result := True;

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
  FileDelete(Filename,False);

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

    FFilename := FSchemeManager.GetSkinSchemeDir(FSchemeManager.Theme) + trim(StrRemoveChars(Self.Name,
      ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']) + '.xml');
    xml.SaveToFile(FFilename);
    xml.Free;
  end;
end;

function TSchemeManager.GetSkinSchemeDir(ATheme: string): string;
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
      Result := GetSharpeDirectory + 'Skins\' + sSkin + '\Schemes\';

    finally
      xml.Free;
    end;
  end;
end;

constructor TSchemeList.Create;
begin
  fItems := TObjectList.Create;
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

procedure TSchemeList.Clear;
begin
  FItems.Clear;
end;

procedure TSchemeList.Delete(ASchemeItem: TSchemeItem);
var
  n: Integer;
begin
  n := FItems.IndexOf(ASchemeItem);
  if n <> -1 then
    FItems.Delete(n);
end;

function TSchemeList.Add(ASchemeItem: TSchemeItem): Integer;
begin
  Result := FItems.Add(ASchemeItem);
end;

function TSchemeManager.GetSkinScheme: string;
var
  xml: TJvSimpleXml;
  sSkin, sFile: string;
begin
  Result := '';
  sFile := GetSharpeUserSettingsPath + 'Themes\' + FTheme + '\Skin.xml';

  if fileExists(sFile) then
  begin
    xml := TJvSimpleXML.Create(nil);
    try
      xml.LoadFromFile(sFile);
      sSkin := xml.Root.Items.Value('Skin');

      if sSkin <> '' then
        Result := GetSharpeDirectory + 'Skins\' + sSkin + '\Scheme.xml';

    finally
      xml.Free;
    end;
  end;
end;

function TSchemeManager.GetSkinName: string;
var
  xml: TJvSimpleXml;
  sSkin, sFile: string;
begin
  Result := '';
  sFile := GetSharpeUserSettingsPath + 'Themes\' + FTheme + '\Skin.xml';

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

function TSchemeManager.GetSkinColorByTag(ATag: string): TSharpESkinColor;
var
  sSchemeFile: string;
  xml: TJvSimpleXML;
  s: string;
  i: Integer;
begin

  sSchemeFile := GetSkinScheme;
  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(sSchemeFile);
    for i := 0 to Pred(xml.Root.Items.Count) do begin

      if CompareText(xml.Root.Items.Item[i].Items.Value('Tag'), ATag) = 0 then begin
        Result.Name := xml.Root.Items.Item[i].Items.Value('Name');
        Result.Tag := xml.Root.Items.Item[i].Items.Value('Tag');
        Result.Info := xml.Root.Items.Item[i].Items.Value('Info');
        Result.Color := xml.Root.Items.Item[i].Items.IntValue('Default');
        s := xml.Root.Items.Item[i].Items.Value('Type');
        if s <> '' then begin
          if CompareText(s, 'integer') = 0 then
            Result.schemetype := stInteger else
            if CompareText(s, 'bool') = 0 then
              Result.schemetype := stBoolean else
        end else
          Result.schemetype := stColor;
      end;
    end;
  finally
    xml.Free;
  end;
end;

function TSchemeManager.GetSkinValid: Boolean;
begin
  Result := not (GetSkinScheme = '');
end;

{ TSchemeManager }

procedure TSchemeManager.Copy(ASchemeItem: TSchemeItem);
var
  sFilename: String;
  sSkinDir, sCopyName: string;
  sSchemeDir: string;
  xml: TJvSimpleXML;
begin

  sSkinDir := GetSharpeDirectory + 'skins';
  sSchemeDir := Format('%s\%s\schemes\', [sSkinDir, GetSkinName]);
  sCopyName := ASchemeItem.Name;
  repeat
    sCopyName := sCopyName +'_'+'copy';
    sFilename := sSchemeDir + sCopyName + '.xml';
  until Not(fileExists(sFilename));

  FileCopy(ASchemeItem.Filename,sFilename,False);
  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(sFilename);
    if xml.Root.Items.ItemNamed['info'] <> nil then
      xml.Root.Items.ItemNamed['info'].Items.ItemNamed['name'].Value := sCopyName;
  finally
    xml.SaveToFile(sFilename);
    xml.Free;
  end;

end;

procedure TSchemeManager.Delete(AName: string);
begin

end;

procedure TSchemeManager.Edit(AName, ASchemeItem: TSchemeItem);
begin

end;

function TSchemeManager.GetDefaultScheme: string;
var
  xml: TJvSimpleXml;
  sScheme, sFile: string;
begin
  if FDefaultScheme = '' then begin

    sFile := GetSharpeUserSettingsPath + 'Themes\' + FTheme + '\Scheme.xml';

    if fileExists(sFile) then
    begin
      xml := TJvSimpleXML.Create(nil);
      try
        xml.LoadFromFile(sFile);
        sScheme := xml.Root.Items.Value('Scheme', '');
        Result := sScheme;

      finally
        xml.Free;
        FDefaultScheme := Result;
      end;
    end;
  end else
    Result := FDefaultScheme;
end;

procedure TSchemeManager.GetSchemeList(AStringList: TStrings);
var
  s, sSchemeDir, sSkinDir, sXmlSearch, sPreview: string;
  xml: TJvSimpleXml;
  sList: TStringList;
  i, j: Integer;
  newItem: TSchemeItem;
  newColItem: TSchemeColorItem;
begin
  sSkinDir := GetSharpeDirectory + 'skins';
  sSchemeDir := Format('%s\%s\schemes\', [sSkinDir, GetSkinName]);
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
        newItem.FileName := sList[i];

        for j := 0 to Pred(xml.Root.Items.Count) do begin
          if CompareText(xml.Root.Items.Item[j].Name, 'Info') = 0 then
          begin
            newItem.Author := xml.Root.Items[j].Items.Value('Author', 'Untitled');
            newItem.Name := xml.Root.Items[j].Items.Value('Name', 'Unknown');

            if newItem.Name = '' then
              newItem.Name := 'Untitled' + IntToStr(j);

            if newItem.Author = '' then
              newItem.Author := 'Unknown';

            s := GetSkinScheme;
            if CompareText(s, newItem.Name) = 0 then
              newItem.DefaultItem := True;
          end
          else
          begin
            newColItem := TSchemeColorItem.Create;
            newColItem.Tag := xml.Root.Items[j].Items.Value('Tag', '');
            newColItem.UnparsedColor := xml.Root.Items[j].Items.Value('Color', '');
            newColItem.Color := ParseColor(PChar(xml.Root.Items[j].Items.Value('Color', '')));
            newItem.Colors.Add(newColItem);
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

procedure TSchemeManager.SetDefaultScheme(AName: string);
var
  xml: TJvSimpleXML;
  s: string;
begin
  xml := TJvSimpleXML.Create(nil);
  try
    s := GetSharpeUserSettingsPath + 'Themes\' + FTheme + '\' + 'Scheme.xml';
    forcedirectories(ExtractFilePath(s));

    xml.Root.Clear;
    xml.Root.Name := 'SharpEThemeScheme';
    xml.Root.Items.Add('Scheme', AName);
    xml.SaveToFile(s);
  finally
    xml.Free;
  end;
end;

end.

