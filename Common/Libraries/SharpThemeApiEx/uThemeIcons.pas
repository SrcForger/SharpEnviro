{
Source Name: uThemeIcons.pas
Description: TThemeIcons class implementing IThemeIcons Interface
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit uThemeIcons;

interface

uses
  SharpApi, uThemeConsts, uIThemeIcons, uThemeInfo;

type
  TThemeIcons = class(TInterfacedObject, IThemeIcons)
  private
    FDirectoryDefault : String;
    FDirectoryIconSet : String;
    FDirectoryBase    : String;

    FName      : String;
    FInfo      : TThemeIconSetInfo;
    FIcons     : TSharpEIconSet;
    FThemeInfo : TThemeInfo;
    procedure SetDefaults;
    procedure UpdateDirectory;
    function GetIconIndexByTag(pTag : String) : integer;    
  public
    LastUpdate : Int64;
    constructor Create(pThemeInfo : TThemeInfo); reintroduce;
    destructor Destroy; override;

    // IThemeInfoInterface
    procedure LoadIcons; stdcall;
    procedure LoadFromFile; stdcall;
    procedure SaveToFile; stdcall;

    function GetName : String; stdcall;
    procedure SetName(Value : String); stdcall;
    property Name : String read GetName write SetName;

    function GetDirectory : String; stdcall;
    property Directory : String read GetDirectory;

    function GetInfo: TThemeIconSetInfo; stdcall;
    property Info : TThemeIconSetInfo read GetInfo;

    function GetIcons : TSharpEIconSet; stdcall;
    property Icons : TSharpEIconSet read GetIcons;    

    procedure SetInfo(pAuthor, pWebsite : String);

    function GetIconCount: integer; stdcall;
    function GetIconByIndex(pIndex: integer): TSharpEIcon; stdcall;
    function GetIconByTag(pTag: String): TSharpEIcon; stdcall;
    function IsIconInIconSet(pTag: String): boolean; stdcall;
  end;

implementation

uses
  SysUtils, DateUtils, IXmlBaseUnit;

{ TThemeIcons }

constructor TThemeIcons.Create(pThemeInfo : TThemeInfo);
begin
  Inherited Create;

  FThemeInfo := pThemeInfo;
  
  LoadFromFile;
end;

destructor TThemeIcons.Destroy;
begin
  SetLength(FIcons,0);

  inherited Destroy;
end;

function TThemeIcons.GetDirectory: String;
begin
  result := FDirectoryBase;
end;

function TThemeIcons.GetIconByIndex(pIndex: integer): TSharpEIcon;
begin
  if pIndex > GetIconCount - 1 then
  begin
    result.FileName := '';
    result.Tag := '';
    exit;
  end;

  result.FileName := FIcons[pIndex].FileName;
  result.Tag := FIcons[pIndex].Tag;
end;

function TThemeIcons.GetIconByTag(pTag: String): TSharpEIcon;
var
  n: integer;
begin
  for n := 0 to GetIconCount - 1 do
    if CompareText(FIcons[n].Tag,pTag) = 0 then
    begin
      result.FileName := FIcons[n].FileName;
      result.Tag := FIcons[n].Tag;
      exit;
    end;

  result.FileName := '';
  result.Tag := '';
end;

function TThemeIcons.GetIconCount: integer;
begin
  result := length(FIcons);
end;

function TThemeIcons.GetIconIndexByTag(pTag: String): integer;
var
  n : integer;
begin
  result := -1;
  for n := 0 to GetIconCount - 1 do
    if CompareText(Icons[n].Tag,pTag) = 0 then
    begin
      result := n;
      exit;
    end;
end;

function TThemeIcons.GetIcons: TSharpEIconSet;
begin
  result := FIcons;
end;

function TThemeIcons.GetInfo: TThemeIconSetInfo;
begin
  result := FInfo;
end;

function TThemeIcons.GetName: String;
begin
  result := FName;
end;

function TThemeIcons.IsIconInIconSet(pTag: String): boolean;
var
  n: integer;
begin
  result := False;
  for n := 0 to GetIconCount - 1 do
    if CompareText(Icons[n].Tag,pTag) = 0 then
    begin
      result := True;
      exit;
    end;
end;

procedure TThemeIcons.LoadFromFile;
var
  XML : TInterfacedXmlBase;
  fileloaded : boolean;
begin
  SetDefaults;

  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_ICONSET_FILE;
  if XML.Load then
  begin
    fileloaded := True;
    with XML.XmlRoot.Items do
    begin
      FName := Value('Name',DEFAULT_ICONSET);
    end
  end else fileloaded := False;
  XML.Free;

  if not fileloaded then
    SaveToFile;

  UpdateDirectory;
  LoadIcons;

  LastUpdate := DateTimeToUnix(Now());
end;

procedure TThemeIcons.LoadIcons;
var
  XML : TInterfacedXmlBase;
  n,i: integer;
  tmpName : String;
begin
  SetLength(FIcons,0);

  // Load Global Default Icons
  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := FDirectoryBase + FDirectoryDefault + 'DefaultIconSet.xml';
  if XML.Load then
  begin
    with XML.XmlRoot.Items do
      if ItemNamed['Icons'] <> nil then
        with ItemNamed['Icons'].Items do
        begin
          for n := 0 to Count - 1 do
          begin
            SetLength(FIcons,length(FIcons)+1);
            FIcons[High(FIcons)].Tag      := Item[n].Items.Value('Name', '');
            FIcons[High(FIcons)].FileName := FDirectoryDefault + Item[n].Items.Value('File', '');
          end;
        end;
  end;
  XML.Free;

  // Load the actual icon set
  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := FDirectoryBase + FDirectoryIconSet + 'IconSet.xml';
  if XML.Load then
  begin
    with XML.XmlRoot.Items, FInfo do
    begin
      Author := Value('Author', '');
      Website := Value('Website', '');
      if ItemNamed['Icons'] <> nil then
        with ItemNamed['Icons'].Items do
        begin
          for n := 0 to Count - 1 do
          begin
            tmpName := Item[n].Items.Value('Name', '');
            if length(trim(tmpName)) > 0 then
            begin
              if IsIconInIconSet(tmpName) then
              begin
                i := GetIconIndexByTag(tmpName);
                if i > -1 then
                  FIcons[i].FileName := FDirectoryIconSet + Item[n].Items.Value('File', '');
              end else
              begin
                SetLength(FIcons,length(FIcons)+1);
                FIcons[High(FIcons)].Tag      := tmpName;
                FIcons[High(FIcons)].FileName := FDirectoryIconSet + Item[n].Items.Value('File', '');
              end;
            end;
          end;
        end;
    end
  end;
  XML.Free;
end;

procedure TThemeIcons.SaveToFile;
var
  XML : TInterfacedXmlBase;
begin
  UpdateDirectory;

  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_ICONSET_FILE;

  XML.XmlRoot.Name := 'SharpEThemeIconSet';
  with XML.XmlRoot.Items do
  begin
    Add('Name',FName);
  end;
  XML.Save;

  XML.Free;
end;

procedure TThemeIcons.SetDefaults;
begin
  LastUpdate := 0;
  FName := 'Default';
  with FInfo do
  begin
    Author  := '';
    Website := '';
  end;
  SetLength(FIcons, 0);
  UpdateDirectory;
end;

procedure TThemeIcons.SetInfo(pAuthor, pWebsite: String);
begin
  with FInfo do
  begin
    Author  := pAuthor;
    Website := pWebsite;
  end;
end;

procedure TThemeIcons.SetName(Value: String);
begin
  FName := Value;
  UpdateDirectory;
end;

procedure TThemeIcons.UpdateDirectory;
begin
  FDirectoryBase    := SharpApi.GetSharpeDirectory + ICONS_DIR + '\';
  FDirectoryIconSet := FName + '\';
  FDirectoryDefault := ICONS_DEFAULT_DIR + '\'
end;

end.
