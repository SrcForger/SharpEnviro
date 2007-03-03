unit uThemeListManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, shellapi, JclFileUtils, JclStrings;

type
  TThemeListItem = Class
  private
    FAuthor: String;
    FName: String;
    FComment: String;
    FWebsite: String;
    FPreviewFileName: String;
    FTemplate: Pointer;
    FDeleted: Boolean;
    FFileName: String;
  public
    constructor Create(AName:String; AAuthor:String);
    property FileName: String read FFileName write FFileName;
    Property Name: String read FName write FName;
    Property Author: String read FAuthor write FAuthor;
    Property Comment: String read FComment write FComment;
    Property Website: String read FWebsite write FWebsite;
    Property PreviewFileName: String read FPreviewFileName write FPreviewFileName;

    Property Deleted: Boolean read FDeleted write FDeleted;
    Property Template: Pointer read FTemplate write FTemplate;
end;

type
  TThemeList = Class
  private
    FList: TList;
    function GetItem(Index: Integer): TThemeListItem;
    procedure SetItem(Index: Integer; const Value: TThemeListItem);

    function RenameFolder(Asrc, ADest: String):Boolean;
    function CopyFolder(Asrc, ADest: String):Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    Function Add: TThemeListItem; overload;
    Function Add(AName: String; AAuthor: String; AComment:String='';
      AWebSite:String=''):TThemeListItem; overload;

    Procedure Delete(AItem:TThemeListItem);
    function IndexOf(AItem:TThemeListItem):Integer;
    function IndexOfThemeName(AThemeName:String):Integer;

    Procedure Clear;

    function Count:Integer;
    Function GetDefaultThemeIdx: Integer;

    procedure Load(AThemeDir: String); overload;
    procedure Load; overload;

    procedure Save(AThemeDir: String); overload;
    procedure Save; overload;

    property Item[Index: Integer]: TThemeListItem read GetItem write SetItem; default;

    procedure GetThemeList(AStringList:TStrings);
  end;

implementation

uses
  SharpApi;

{ TThemeList }

function TThemeList.Add(AName, AAuthor, AComment,
  AWebSite: String): TThemeListItem;
begin
  Result := TThemeListItem.Create(AName, AAuthor);
  Result.Comment := AComment;
  Result.Website := AWebSite;

  FList.Add(Result);
end;

function TThemeList.Add: TThemeListItem;
begin
  Result := TThemeListItem.Create('','');
  FList.Add(Result);
end;

procedure TThemeList.Clear;
begin
  FList.Clear;
end;

function TThemeList.CopyFolder(Asrc, ADest: String): Boolean;
var
  f: TSearchRec;
  Dir: string;
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

function TThemeList.Count:Integer;
begin
  Result := FList.Count;
end;

constructor TThemeList.Create;
begin
  inherited;

  FList := TList.Create;
end;

procedure TThemeList.Delete(AItem: TThemeListItem);
begin
  FList.Delete(IndexOf(AItem));
end;

destructor TThemeList.Destroy;
begin
  inherited;

  FList.Free;
end;

function TThemeList.GetDefaultThemeIdx: Integer;
var
  xml:TJvSimpleXML;
  sThemeName, s: String;
begin
  Result := -1;
  if Self.Count = 0 then exit;

  s := GetSharpeUserSettingsPath + 'SharpE.xml';
  xml := TJvSimpleXML.Create(nil);
  Try
      xml.LoadFromFile(s);
      sThemeName := xml.Root.Items.Value('Theme','');
      Result := IndexOfThemeName(sThemeName);

    Finally
      xml.Free;
    End;
end;

function TThemeList.GetItem(Index: Integer): TThemeListItem;
begin
  Result := FList.Items[Index];
end;

procedure TThemeList.GetThemeList(AStringList: TStrings);
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

function TThemeList.IndexOf(AItem: TThemeListItem): Integer;
begin
  Result := FList.IndexOf(AItem);
end;

function TThemeList.IndexOfThemeName(AThemeName: String): Integer;
var
  i:Integer;
  tmp: TThemeListItem;
begin
  Result := -1;
  for i := 0 to Pred(Count) do begin
    tmp := Item[i];
    if CompareText(tmp.Name,AThemeName) = 0 then begin
      result := i;
      exit;
    end;
  end;
end;

procedure TThemeList.Load;
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

    For i := 0 to Pred(sList.Count) do begin
      xml := TJvSimpleXML.Create(nil);
      Try
        xml.LoadFromFile(sList[i]);

        newItem := Add;
        newItem.FileName := sList[i];
        newItem.Name := XML.Root.Items.Value('Name','Invalid_Name');
        newItem.Author := XML.Root.Items.Value('Author','Invalid_Author');
        newItem.Comment := XML.Root.Items.Value('Comment','Invalid_Comment');
        newItem.Website := XML.Root.Items.Value('Website','Invalid_Website');

        sPreview := ExtractFilePath(SList[i]) + 'Preview.png';
        if FileExists(sPreview) then
          newItem.PreviewFileName := sPreview else
          newItem.PreviewFileName := '';


      Finally
        xml.Free;
      End;
    end;
  Finally
    sList.Free;
  End;
end;

procedure TThemeList.Load(AThemeDir: String);
begin

end;

function TThemeList.RenameFolder(Asrc, ADest: String): Boolean;
var
  shellinfo : TShFileOpStruct;
begin
  with shellinfo do
  begin
    wnd    := 0;
    wFunc  := FO_RENAME;
    pFrom  := PChar(PathRemoveSeparator(Asrc));
    pTo    := PChar(PathRemoveSeparator(ADest));
    fFlags := FOF_FILESONLY or FOF_ALLOWUNDO or FOF_SILENT or FOF_NOCONFIRMATION;
  end;
  SHFileOperation(shellinfo);
end;

procedure TThemeList.Save;
var
  sThemeDir, sSrc, sDest: string;
  xml: TJvSimpleXml;
  i: Integer;
  sValidFolder: String;

  tmpItem: TThemeListItem;
begin
  sThemeDir := GetSharpeUserSettingsPath + 'Themes\';

  // Create and delete items
  For i := Pred(Count) downto 0 do begin

    // Create Items
    if Item[i].Template <> nil then begin

      tmpItem := Item[i];
      sSrc := sThemeDir + TThemeListItem(tmpItem.Template).Name;
      sDest := sThemeDir + tmpItem.Name;

      CopyFolder(sSrc,sDest);
    end

    // Delete items
    else if Item[i].Deleted then begin

      tmpItem := Item[i];
      sSrc := sThemeDir + tmpItem.Name;
      DeleteDirectory(sSrc,True);
      Delete(tmpItem);
    end;
  end;

  // Save everything!
  For i := 0 to Pred(Count) do begin
    tmpItem := Item[i];

    xml := TJvSimpleXML.Create(nil);
    xml.Root.Name := 'SharpETheme';
      Try
        with Xml.Root.items do begin
          Add('Name',tmpItem.Name);
          Add('Author',tmpItem.Author);
          Add('Comment',tmpItem.Comment);
          Add('Website',tmpItem.Website)
        end;


      Finally

        // create folder
        if Not(DirectoryExists(extractfilepath(tmpitem.FileName))) then
          ForceDirectories(extractfilepath(tmpitem.FileName));

        // rename
        RenameFolder(extractfilepath(tmpitem.FileName),sThemeDir+tmpItem.Name+'\');
        sDest := sThemeDir+tmpItem.Name+'\'+'Theme.xml';

        xml.SaveToFile(sDest);

        xml.Free;
      End;

  end;

end;

procedure TThemeList.Save(AThemeDir: String);
begin

end;

procedure TThemeList.SetItem(Index: Integer; const Value: TThemeListItem);
begin
  FList.Items[Index] := Value;
end;

{ TThemeListItem }

constructor TThemeListItem.Create(AName, AAuthor: String);
begin
  FAuthor := AAuthor;
  FName := AName;
  FDeleted := False;
  FTemplate := nil;
  FWebsite := '';
  FComment := '';
end;

end.
