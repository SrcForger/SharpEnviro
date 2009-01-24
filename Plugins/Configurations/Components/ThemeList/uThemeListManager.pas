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
  JclSimpleXml,
  JvSimpleXml,
  shellapi,
  JclFileUtils,
  JclStrings,

  SharpThemeApiEx,
  uISharpETheme,
  uThemeConsts,
  IXmlBaseUnit;

type
  TThemeListItemClass = class
  private
    FThemeInfo: TThemeListItem;
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
    constructor Create(AThemeInfo: TThemeListItem);

    property Name: string read GetName write SetName;
    property Author: string read GetAuthor write SetAuthor;
    property Comment: string read GetComment write SetComment;
    property Website: string read GetWebsite write SetWebsite;

    property Filename: string read GetFilename write SetFilename;
    property Preview: string read GetPreview write SetPreview;
    property Readonly: boolean read GetReadOnly write SetReadOnly;
  end;

  TThemeManager = class(TInterfacedXmlBase)
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
  uThemeListWnd;

{ TThemeManager }

procedure TThemeManager.Add(AName, AAuthor, Awebsite: string;
  ATemplate: string = ''; AReadOnly: Boolean = False);
var
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

  XmlRoot.Clear;
  XmlRoot.Name := 'SharpETheme';
  try
    with XmlRoot.items do begin
      Add('Name', AName);
      Add('Author', AAuthor);
      Add('Website', AWebsite);
      Add('ReadOnly', AReadOnly);
    end;
  finally

    XmlFilename := sThemeDir + AName + '\' + 'Theme.xml';
    Save;
  end;

  // just create a default skin file
  if ATemplate = '' then begin

    XmlRoot.Clear;
    XmlRoot.Name := 'SharpEThemeSkin';
    xmlRoot.Items.Add('Skin', 'BB2-Glass');

    XmlFilename := sThemeDir + AName + '\' + 'Skin.xml';
    Save;
  end;
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
  sThemeDir, sName: string;
  Theme : ISharpETheme;
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
  XmlFilename := sThemeDir + sName + '\' + 'theme.xml';
  Load;

  try
    with XmlRoot.items do begin

      ItemNamed['Name'].Value := sName;
      ItemNamed['Author'].Value := AAuthor;
      ItemNamed['Website'].Value := AWebsite;
    end;

  Theme := GetCurrentTheme;
  // Rename theme if default
  if Theme.Info.Name = AOldName then
    Theme.SetCurrentTheme(sName);

  finally
    Save;
  end;

end;

function TThemeManager.GetDefaultTheme: string;
begin
  Result := '';

  XmlFilename := GetSharpeUserSettingsPath + 'SharpE.xml';
  Load;
  Result := xmlRoot.Items.Value('Theme', '');
end;

procedure TThemeManager.SetTheme(AName: string);
var
  elem: TJvSimpleXMLElem;
  s, sDest, sThemeDir: string;
begin
  sThemeDir := GetSharpeUserSettingsPath + 'Themes\';
  sDest := GetSharpeUserSettingsPath + 'SharpE.xml';

  s := GetSharpeUserSettingsPath + 'SharpE.xml';

  XmlFilename := sDest;
  Load;
  elem := xmlRoot.Items.ItemNamed['Theme'];

  if elem <> nil then
    elem.Value := AName
  else
    xmlRoot.Items.Add('Theme', AName);

  Save;
end;

{ TThemeListItemClass }

constructor TThemeListItemClass.Create(AThemeInfo: TThemeListItem);
begin
  FThemeInfo := AThemeInfo;
end;

function TThemeListItemClass.GetAuthor: string;
begin
  Result := FThemeInfo.Author;
end;

function TThemeListItemClass.GetComment: string;
begin
  Result := FThemeInfo.Comment;
end;

function TThemeListItemClass.GetFilename: string;
begin
  Result := FThemeInfo.Filename;
end;

function TThemeListItemClass.GetName: string;
begin
  Result := FThemeInfo.Name;
end;

function TThemeListItemClass.GetPreview: string;
begin
  Result := FThemeInfo.Preview;
end;

function TThemeListItemClass.GetReadOnly: boolean;
begin
  Result := FThemeInfo.Readonly;
end;

function TThemeListItemClass.GetWebsite: string;
begin
  Result := FThemeInfo.Website
end;

procedure TThemeListItemClass.SetAuthor(const Value: string);
begin
  FThemeInfo.Author := Value;
end;

procedure TThemeListItemClass.SetComment(const Value: string);
begin
  FThemeInfo.Comment := Value;
end;

procedure TThemeListItemClass.SetFilename(const Value: string);
begin
  FThemeInfo.Filename := Value;
end;

procedure TThemeListItemClass.SetName(const Value: string);
begin
  FThemeInfo.Name := Value;
end;

procedure TThemeListItemClass.SetPreview(const Value: string);
begin
  FThemeInfo.Preview := Value;
end;

procedure TThemeListItemClass.SetReadOnly(const Value: boolean);
begin
  FThemeInfo.Readonly := Value;
end;

procedure TThemeListItemClass.SetWebsite(const Value: string);
begin
  FThemeInfo.Website := Value;
end;

end.

