unit uThemeListManager;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  JvSimpleXml,
  shellapi,
  JclFileUtils,
  JclStrings,
  SharpEListBoxEx,
  SharpThemeApi;

type
  TThemeListItem = class
  private
    FThemeInfo: TThemeInfo;
    function GetAuthor: string;
    function GetComment: string;
    function GetFilename: string;
    function GetName: string;
    function GetPreview: string;
    function GetReadOnly: boolean;
    function GetWebsite: string;
    procedure SetAuthor(const Value: string);
    procedure SetComment(const Value: string);
    procedure SetFilename(const Value: string);
    procedure SetName(const Value: string);
    procedure SetPreview(const Value: string);
    procedure SetReadOnly(const Value: boolean);
    procedure SetWebsite(const Value: string);
  public
    constructor Create(AThemeInfo: TThemeInfo);

    property Name: string read GetName write SetName;
    property Author: string read GetAuthor write SetAuthor;
    property Comment: string read GetComment write SetComment;
    property Website: string read GetWebsite write SetWebsite;

    property Filename: string read GetFilename write SetFilename;
    property Preview: string read GetPreview write SetPreview;
    property Readonly: boolean read GetReadOnly write SetReadOnly;
  end;

  TThemeManager = class
  private
    function CopyFolder(Asrc, ADest: string): Boolean;
  public
    procedure Add(AName, AAuthor, Awebsite: string;
      ATemplate: string = ''; AReadOnly: Boolean = False);
    procedure Edit(AOldName, ANewName, AAuthor, AWebsite: string);
    procedure Delete(AName: string);
    procedure SetTheme(AName: string);
    function GetDefaultTheme: string;

  end;

implementation

uses
  SharpApi,
  uThemeListWnd,
  JclSimpleXml;

{ TThemeManager }

procedure TThemeManager.Add(AName, AAuthor, Awebsite: string;
  ATemplate: string = ''; AReadOnly: Boolean = False);
var
  xml: TJvSimpleXml;
  sThemeDir: string;
  sSrc: string;
  sDest: string;
begin
  // Get theme dir
  AName := trim(StrRemoveChars(AName,
    ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));

  sThemeDir := GetSharpeUserSettingsPath + 'Themes\';

  // Check template
  if ATemplate <> '' then begin
    sSrc := sThemeDir + ATemplate;
    sDest := sThemeDir + AName;

    CopyFolder(sSrc, sDest);
  end;

  xml := TJvSimpleXML.Create(nil);
  xml.Root.Name := 'SharpETheme';
  try
    with Xml.Root.items do begin
      Add('Name', AName);
      Add('Author', AAuthor);
      Add('Website', AWebsite);
      Add('ReadOnly', AReadOnly);
    end;
  finally

    // create folder
    if not (DirectoryExists(sThemeDir + AName)) then
      ForceDirectories(sThemeDir + AName);

    sDest := sThemeDir + AName + '\' + 'Theme.xml';

    xml.SaveToFile(sDest);
    xml.Free;
  end;

  // just create a default skin file
  xml := TJvSimpleXML.Create(nil);
  xml.Root.Name := 'SharpEThemeSkin';
  xml.Root.Items.Add('Skin', 'BB2-Glass');

  sDest := sThemeDir + AName + '\' + 'Skin.xml';

  xml.SaveToFile(sDest);
  xml.free;
end;

function TThemeManager.CopyFolder(Asrc, ADest: string): Boolean;
var
  i: Integer;
  sList: TStringList;
begin
  Result := True;

  ADest := PathAddSeparator(ADest);
  Asrc := PathAddSeparator(Asrc);
  ForceDirectories(ADest);

  sList := TStringList.Create;
  try
    AdvBuildFileList(Asrc + '*.*', faAnyFile, sList, amAny, [flFullNames]);

    for i := 0 to Pred(sList.Count) do begin
      FileCopy(slist[i], ADest + ExtractFileName(sList[i]));
    end;

  finally
    sList.Free;
  end;
end;

procedure TThemeManager.Delete(AName: string);
var
  sThemeDir: PAnsiChar;
  sSrc: PAnsiChar;
begin
  sThemeDir := PAnsiChar(GetSharpeUserSettingsPath + 'Themes\');
  sSrc := PAnsiChar(sThemeDir + AName);

  DeleteDirectory(sSrc, True);
end;

procedure TThemeManager.Edit(AOldName, ANewName, AAuthor, AWebsite: string);
var
  xml: TJvSimpleXml;
  sThemeDir, sName: string;
  sXml: string;
begin

  // Remove invalid chars
  sThemeDir := GetSharpeUserSettingsPath + 'Themes\';
  ANewName := trim(StrRemoveChars(ANewName,
    ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));

  // Rename
  if CompareText(AOldName, ANewName) <> 0 then begin

    CopyFolder(PathAddSeparator(sThemeDir) + AOldName, PathAddSeparator(sThemeDir) + ANewName);
    DeleteDirectory(PathAddSeparator(sThemeDir) + AOldName, True);
    sName := ANewName;
  end
  else
    sName := AOldName;

  // Get theme dir

  sXml := sThemeDir + sName + '\' + 'theme.xml';

  xml := TJvSimpleXML.Create(nil);
  xml.LoadFromFile(sXml);
  try
    with Xml.Root.items do begin

      ItemNamed['Name'].Value := sName;
      ItemNamed['Author'].Value := AAuthor;
      ItemNamed['Website'].Value := AWebsite;
    end;
  finally
    xml.SaveToFile(sXml);
  end;
end;

function TThemeManager.GetDefaultTheme: string;
var
  xml: TJvSimpleXML;
  s: string;
begin
  Result := '';
  s := GetSharpeUserSettingsPath + 'SharpE.xml';
  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(s);
    Result := xml.Root.Items.Value('Theme', '');

  finally
    xml.Free;
  end;
end;

procedure TThemeManager.SetTheme(AName: string);
var
  xml: TJvSimpleXML;
  elem: TJvSimpleXMLElem;
  s, sDest, sThemeDir: string;
begin

  sThemeDir := GetSharpeUserSettingsPath + 'Themes\';
  sDest := GetSharpeUserSettingsPath + 'SharpE.xml';

  s := GetSharpeUserSettingsPath + 'SharpE.xml';
  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(sDest);
    elem := xml.Root.Items.ItemNamed['Theme'];

    if elem <> nil then
      elem.Value := AName
    else
      xml.Root.Items.Add('Theme', AName);

  finally
    xml.SaveToFile(sDest);
    xml.Free;
  end;
end;

{ TThemeListItem }

constructor TThemeListItem.Create(AThemeInfo: TThemeInfo);
begin
  FThemeInfo := AThemeInfo;
end;

function TThemeListItem.GetAuthor: string;
begin
  Result := FThemeInfo.Author;
end;

function TThemeListItem.GetComment: string;
begin
  Result := FThemeInfo.Comment;
end;

function TThemeListItem.GetFilename: string;
begin
  Result := FThemeInfo.Filename;
end;

function TThemeListItem.GetName: string;
begin
  Result := FThemeInfo.Name;
end;

function TThemeListItem.GetPreview: string;
begin
  Result := FThemeInfo.Preview;
end;

function TThemeListItem.GetReadOnly: boolean;
begin
  Result := FThemeInfo.Readonly;
end;

function TThemeListItem.GetWebsite: string;
begin
  Result := FThemeInfo.Website
end;

procedure TThemeListItem.SetAuthor(const Value: string);
begin
  FThemeInfo.Author := Value;
end;

procedure TThemeListItem.SetComment(const Value: string);
begin
  FThemeInfo.Comment := Value;
end;

procedure TThemeListItem.SetFilename(const Value: string);
begin
  FThemeInfo.Filename := Value;
end;

procedure TThemeListItem.SetName(const Value: string);
begin
  FThemeInfo.Name := Value;
end;

procedure TThemeListItem.SetPreview(const Value: string);
begin
  FThemeInfo.Preview := Value;
end;

procedure TThemeListItem.SetReadOnly(const Value: boolean);
begin
  FThemeInfo.Readonly := Value;
end;

procedure TThemeListItem.SetWebsite(const Value: string);
begin
  FThemeInfo.Website := Value;
end;

end.

