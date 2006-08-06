unit uConfigListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, SharpApi, uSEListboxPainter, JclFileUtils,
  uSharpCenterSectionList, uSharpCenterCommon;

type
  TfrmConfigListWnd = class(TForm)
    ListBox1: TListBox;
    procedure FormShow(Sender: TObject);
  private
    FLoadedThemeID: string;
    FLoadedThemeSets: string;
  private
    { Private declarations }
    function GetLoadedThemeID: string;
    function GetSetsForLoadedThemeID(AThemeID: string): string;
    procedure GetAvailableObjects(var AStringList: TStringList);
    property LoadedThemeID: string read FLoadedThemeID write FLoadedThemeID;
    property LoadedThemeSets: string read FLoadedThemeSets write
      FLoadedThemeSets;
  public
    { Public declarations }
    Procedure PopulateList;
    Procedure PopulateObjectTypes(var AList:TSectionObjectList);
  end;

var
  frmConfigListWnd: TfrmConfigListWnd;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

function TfrmConfigListWnd.GetLoadedThemeID: string;
var
  xml: TJvSimpleXML;
  fn: string;
begin
  Result := '';
  xml := TJvSimpleXML.Create(nil);
  try
    fn := GetSharpeUserSettingsPath + 'SharpDesk\Settings.xml';
    if fileexists(fn) then begin
      xml.LoadFromFile(fn);
      with xml.Root.Items.ItemNamed['Settings'] do begin
        Result := items.ItemNamed['Theme'].Value;
      end;
    end;
  finally
    xml.Free;
  end;
end;

function TfrmConfigListWnd.GetSetsForLoadedThemeID(AThemeID: string): string;
var
  xml: TJvSimpleXML;
  fn: string;
begin
  Result := '';
  xml := TJvSimpleXML.Create(nil);
  try
    fn := GetSharpeGlobalSettingsPath + 'SharpTheme\Themes.xml';
    if fileexists(fn) then begin
      xml.LoadFromFile(fn);
      with xml.Root.Items.ItemNamed['Themes'] do begin
        Result :=
          items.ItemNamed[FLoadedThemeID].Items.ItemNamed['ObjectSet'].Value;
      end;
    end;
  finally
    xml.Free;
  end;
end;

procedure TfrmConfigListWnd.GetAvailableObjects(var AStringList: TStringList);
var
  Strl: TStringList;
  Xml: tjvsimplexml;
  i, n: Integer;
  fn: string;
  ID, ObjectName: string;
begin
  if not (Assigned(AStringList)) then
    exit;

  AStringList.Clear;
  Strl := TStringList.Create;
  Xml := TJvSimpleXML.Create(nil);
  try
    Strl.CommaText := FLoadedThemeSets;
    for i := 0 to Pred(Strl.Count) do begin
      fn := GetSharpeUserSettingsPath + 'SharpDesk\Sets.xml';
      if fileexists(fn) then begin
        xml.LoadFromFile(fn);

        with xml.root.Items.ItemNamed['Objects'].Items.ItemNamed[Strl[i]] do
          begin
          for n := 0 to Pred(Items.Count) do begin
            ID := Items.Item[n].Items.Parent.Name;
            ObjectName := Items.Item[n].Items.ItemNamed['Object'].Value;

            AStringList.Add(Format('%s=%s', [ObjectName, ID]));
          end;
        end;
      end;
    end;

  finally
    Strl.Free;
    Xml.Free;
  end;
end;

procedure TfrmConfigListWnd.FormShow(Sender: TObject);
begin
  FLoadedThemeID := GetLoadedThemeID;
  FLoadedThemeSets := GetSetsForLoadedThemeID(FLoadedThemeID);
end;

procedure TfrmConfigListWnd.PopulateList;
begin
  //uSEListboxPainter
end;

procedure TfrmConfigListWnd.PopulateObjectTypes(var AList:TSectionObjectList);
var
  objects, files: TStringList;
  dir, s, sThemesDir, sModulesDir, sObjectsDir:String;
  i, j, n: integer;
begin
  LoadCenterDefines(sThemesDir,sModulesDir,sObjectsDir);

  objects := TStringList.Create;
  files := TStringList.Create;
  try
    GetAvailableObjects(objects);
    dir := GetSharpeDirectory + 'Objects\';
    BuildFileList(dir + '*.object', faAnyFile, files);

    for i := 0 to Pred(Files.Count) do begin
      if objects.IndexOfName(files[i]) <> -1 then begin

        // How many types?
        n := 0;
        for j := 0 to Pred(objects.Count) do
          if CompareStr(objects.Names[j], files[i]) = 0 then
            inc(n);

        s := sObjectsDir + '\' + PathRemoveExtension(files[i])+'.png';
        AList.Add(PathRemoveExtension(files[i]),nil,s,IntToStr(n));
      end;

    end;

  finally
    objects.Free;
    files.Free;
  end;
end;

end.
