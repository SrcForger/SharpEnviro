unit uThemeListManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, shellapi, JclFileUtils, JclStrings,
    SharpEListBoxEx;

type
  TThemeListItem = Class
  private
    FAuthor: String;
    FName: String;
    FComment: String;
    FWebsite: String;
    FPreviewFileName: String;
    FTemplate: Pointer;
    FFileName: String;
    FIsReadOnly: Boolean;
    FRenamedName: String;
  public
    constructor Create(AName:String; AAuthor:String);
    property FileName: String read FFileName write FFileName;
    Property Name: String read FName write FName;
    Property RenamedName: String read FRenamedName write FRenamedName;
    Property Author: String read FAuthor write FAuthor;
    Property Comment: String read FComment write FComment;
    Property Website: String read FWebsite write FWebsite;
    Property PreviewFileName: String read FPreviewFileName write FPreviewFileName;
    property IsReadOnly: Boolean read FIsReadOnly write FIsReadOnly;

    Property Template: Pointer read FTemplate write FTemplate;
end;

  TThemeManager = Class
    private
      function CopyFolder(Asrc, ADest: String):Boolean;
    public
      procedure Add(AName, AAuthor, Awebsite:string;
        ATemplate: string=''; AReadOnly:Boolean=False);
      procedure Edit(AOldName, ANewName, AAuthor, AWebsite: String);
      procedure Delete(AName: String);
      procedure SetTheme(AName: String);
      Function GetDefaultTheme:string;

      procedure GetThemeList(AStringList:TStrings);
  End;

implementation

uses
  SharpApi, uThemeListWnd, JclSimpleXml;

{ TThemeListItem }

constructor TThemeListItem.Create(AName, AAuthor: String);
begin
  FAuthor := AAuthor;
  FName := AName;
  FTemplate := nil;
  FWebsite := '';
  FComment := '';
  FIsReadOnly := False;
end;

{ TThemeManager }

procedure TThemeManager.Add(AName, AAuthor, Awebsite:string;
  ATemplate: string=''; AReadOnly:Boolean=False);
var
  xml: TJvSimpleXml;
  sThemeDir: String;
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

    CopyFolder(sSrc,sDest);
  end;

  xml := TJvSimpleXML.Create(nil);
  xml.Root.Name := 'SharpETheme';
  Try
    with Xml.Root.items do begin
      Add('Name',AName);
      Add('Author',AAuthor);
      Add('Website',AWebsite);
      Add('ReadOnly',AReadOnly);
    end;
  Finally

    // create folder
    if Not(DirectoryExists(sThemeDir + AName)) then
      ForceDirectories(sThemeDir + AName);

    sDest := sThemeDir + AName+'\'+'Theme.xml';

    xml.SaveToFile(sDest);
    xml.Free;
  End;

  // just create a default skin file
  xml := TJvSimpleXML.Create(nil);
  xml.Root.Name := 'SharpEThemeSkin';
  xml.Root.Items.Add('Skin','BB2-Glass');

  sDest := sThemeDir + AName+'\'+'Skin.xml';

  xml.SaveToFile(sDest);
  xml.free;
end;

function TThemeManager.CopyFolder(Asrc, ADest: String): Boolean;
var
  i: Integer;
  sList: TStringList;
begin
  Result := True;

  ADest := PathAddSeparator(ADest);
  Asrc := PathAddSeparator(Asrc);
  ForceDirectories(ADest);

   sList := TStringList.Create;
   Try
    AdvBuildFileList(Asrc+'*.*',faAnyFile,sList,amAny,[flFullNames]);

    For i := 0 to Pred(sList.Count) do begin
      FileCopy(slist[i],ADest+ExtractFileName(sList[i]));
    end;

   Finally
    sList.Free;
   End;
end;

procedure TThemeManager.Delete(AName: String);
var
  sThemeDir: PAnsiChar;
  sSrc: PAnsiChar;
begin
  sThemeDir := PAnsiChar(GetSharpeUserSettingsPath + 'Themes\');
  sSrc := PAnsiChar(sThemeDir + AName);

  DeleteDirectory(sSrc,True);
end;

procedure TThemeManager.Edit(AOldName, ANewName, AAuthor, AWebsite: String);
var
  xml: TJvSimpleXml;
  sThemeDir, sName: String;
  sXml: string;
begin

  // Remove invalid chars
  sThemeDir := GetSharpeUserSettingsPath + 'Themes\';
  ANewName := trim(StrRemoveChars(ANewName,
      ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));

  // Rename
  if CompareText(AOldName, ANewName) <> 0 then begin

    CopyFolder(PathAddSeparator(sThemeDir)+AOldName,PathAddSeparator(sThemeDir)+ANewName);
    DeleteDirectory(PathAddSeparator(sThemeDir)+AOldName,True);
    sName := ANewName;
  end else
    sName := AOldName;

  // Get theme dir
  
  sXml := sThemeDir+sName+'\'+'theme.xml';

  xml := TJvSimpleXML.Create(nil);
  xml.LoadFromFile(sXml);
  Try
    with Xml.Root.items do begin

      ItemNamed['Name'].Value := sName;
      ItemNamed['Author'].Value := AAuthor;
      ItemNamed['Website'].Value := AWebsite;
    end;
  Finally
    xml.SaveToFile(sXml);
  End;
end;

function TThemeManager.GetDefaultTheme: string;
var
  xml:TJvSimpleXML;
  s: String;
begin
  Result := '';
  s := GetSharpeUserSettingsPath + 'SharpE.xml';
  xml := TJvSimpleXML.Create(nil);
  Try
      xml.LoadFromFile(s);
      Result := xml.Root.Items.Value('Theme','');

  Finally
    xml.Free;
  End;
end;


procedure TThemeManager.GetThemeList(AStringList: TStrings);
var
  sThemeDir, sPreview: string;
  xml: TJvSimpleXml;
  sList: TStringList;
  i: Integer;
  newItem: TThemeListItem;
begin
  sThemeDir := GetSharpeUserSettingsPath + 'Themes\*theme.xml';

  sList := TStringList.Create;
  Try
    AdvBuildFileList(sThemeDir,faDirectory,sList,amAny,[flRecursive,flFullNames]);
    sList.Sort;

    For i := 0 to Pred(sList.Count) do begin
      xml := TJvSimpleXML.Create(nil);
      Try
        xml.LoadFromFile(sList[i]);

        newItem := TThemeListItem.Create('','');
        newItem.FileName := SList[i];
        newItem.Name := XML.Root.Items.Value('Name','Invalid_Name');
        newItem.Author := XML.Root.Items.Value('Author','Invalid_Author');
        newItem.Comment := XML.Root.Items.Value('Comment','Invalid_Comment');
        newItem.Website := XML.Root.Items.Value('Website','Invalid_Website');
        newItem.IsReadOnly := XML.Root.Items.BoolValue('ReadOnly',false);

        sPreview := ExtractFilePath(SList[i]) + 'Preview.png';
        if FileExists(sPreview) then
          newItem.PreviewFileName := sPreview else
          newItem.PreviewFileName := '';

        AStringList.AddObject(newItem.Name,newItem);

      Finally
        xml.Free;
      End;
    end;
  Finally
    sList.Free;
  End;
end;

procedure TThemeManager.SetTheme(AName: String);
var
  xml:TJvSimpleXML;
  elem: TJvSimpleXMLElem;
  s, sDest, sThemeDir: String;
begin

  sThemeDir := GetSharpeUserSettingsPath + 'Themes\';
  sDest := GetSharpeUserSettingsPath + 'SharpE.xml';

  s := GetSharpeUserSettingsPath + 'SharpE.xml';
  xml := TJvSimpleXML.Create(nil);
  Try
    xml.LoadFromFile(sDest);
    elem := xml.Root.Items.ItemNamed['Theme'];

    if elem <> nil then
      elem.Value := AName else
      xml.Root.Items.Add('Theme',AName);

  Finally
    xml.SaveToFile(sDest);
    xml.Free;
  End;
end;

end.

