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
  Classes, SharpApi, uThemeConsts, uIThemeIcons, uThemeInfo;

type
  TThemeIcons = class(TInterfacedObject, IThemeIcons)
  private
    FDirectoryDefault : String;
    FDirectoryIconSet : String;
    FDirectoryBase    : String;

    FIcons : TSharpEIcons;

    FName      : String;
    FInfo      : TThemeIconSetInfo;
    FThemeInfo : TThemeInfo;
    procedure SetDefaults;
    procedure UpdateDirectory;
    procedure SortByName;
    procedure ResetIcons;
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

    procedure SetInfo(pAuthor, pWebsite, pComment : String);

    function GetIcons : TSharpEIcons; stdcall;
    property Icons : TSharpEIcons read GetIcons;

    procedure GetIconsFromDir(var pIcons : TSharpEIcons; pDirectory : String); stdcall;

    function GetIconCount: integer; stdcall;

    function GetIconByTag(pTag: String): TSharpEIcon; stdcall;
    function GetIconFileSizedByTag(pTag: String; pTargetSize : integer): String; stdcall;
    function GetIconFileSizesByIndex(pIndex: integer; pTargetSize : integer): String; stdcall;
    function GetIconIndexByTag(pTag : String) : integer; stdcall;     
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
  ResetIcons;

  inherited Destroy;
end;

function TThemeIcons.GetDirectory: String;
begin
  result := FDirectoryBase;
end;


function TThemeIcons.GetIconByTag(pTag: String): TSharpEIcon;
var
  index : integer;
begin
  index := GetIconIndexByTag(pTag);
  if index <> -1 then
    result := FIcons[index]
  else begin
    result.Tag := '';
    setlength(result.Sizes,1);
    result.Sizes[0] := 0;
  end;
end;

function TThemeIcons.GetIconCount: integer;
begin
  result := length(FIcons);
end;

function TThemeIcons.GetIconIndexByTag(pTag: String): integer;
var
  n : integer;
begin
  for n := 0 to High(FIcons) do
    if CompareText(FIcons[n].Tag,pTag) = 0 then
    begin
      result := n;
      exit;
    end;
  result := - 1;
end;

function TThemeIcons.GetIcons: TSharpEIcons;
begin
  result := FIcons;
end;

procedure FindAllIconsInDir(SList : TStringList; Dir : String);
var
  sr : TSearchRec;
  s : String;
begin
  {$WARNINGS OFF} Dir := IncludeTrailingBackslash(Dir); {$WARNINGS ON}
  SList.Clear;
  if FindFirst(Dir + '*.png',faDirectory  ,sr) = 0 then
  repeat
    if FileExists(Dir + sr.Name) then
    begin
      s := sr.Name;
      setlength(s,length(s) - length(ExtractFileExt(s)));
      SList.Add(s);
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
end;

function IsSizeInIcon(Icon : TSharpEIcon; Size : integer) : boolean;
var
  n : integer;
begin
  for n := 0 to High(Icon.Sizes) do
    if Icon.Sizes[n] = Size then
    begin
      result := True;
      exit;
    end;
  result := False;    
end;

procedure MergeLists(var Dst : TSharpEIcons; Src : TStringList; Size : integer);
var
  n,i : integer;
  found : boolean;
begin
  for n := 0 to Src.Count - 1 do
  begin
    found := False;
    // check if each new icon is already in the Dst List
    for i := 0 to High(Dst) do
      if CompareText(Dst[i].Tag,Src[n]) = 0 then
      begin
        // If icon is already in the list check if the size already exists
        if not IsSizeInIcon(Dst[i],Size) then
        begin
          // icon isnt in the list with this size, add the size to the icon
          setlength(Dst[i].Sizes,length(Dst[i].Sizes) + 1);
          Dst[i].Sizes[High(Dst[i].Sizes)] := Size;
        end;
        found := True;
      end;
    // Icon isn't in Dst List, add it with the given size
    if not found then
    begin
      setlength(Dst,length(Dst) + 1);
      Dst[High(Dst)].Tag := Src[n];
      setlength(Dst[High(Dst)].Sizes, length(Dst[High(Dst)].Sizes) + 1);
      Dst[High(Dst)].Sizes[High(Dst[High(Dst)].Sizes)] := Size;
    end;
  end;
end;


procedure TThemeIcons.GetIconsFromDir(var pIcons: TSharpEIcons; pDirectory: String);
var
  XML : IXmlBase;
  n: integer;
  Sizes : array of integer;
  List : TStringList;
  Dir : String;
begin
  {$WARNINGS OFF}pDirectory := IncludeTrailingBackSlash(pDirectory);{$WARNINGS ON}

  // Load Global Default Icon Sizes
  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FDirectoryBase + FDirectoryDefault + 'DefaultIconSet.xml';
  List := TStringList.Create;
  setlength(Sizes,0);
  if XML.Load then
  begin
    with XML.XmlRoot.Items do
      if ItemNamed['IconSizes'] <> nil then
        with ItemNamed['IconSizes'].Items do
        begin
          for n := 0 to Count - 1 do
          begin
            SetLength(Sizes,length(Sizes)+1);
            Sizes[High(Sizes)] := Item[n].Properties.IntValue('Size',-1)
          end;
        end;
  end;
  XML := nil;

  for n := 0 to High(Sizes) do
  begin
    Dir := FDirectoryBase + FDirectoryDefault + inttostr(Sizes[n]) + '\';
    if DirectoryExists(Dir) then
    begin
      FindAllIconsInDir(List,Dir);
      MergeLists(pIcons,List,Sizes[n]);
    end;
  end;

  // Load the actual icon set
  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := pDirectory + 'IconSet.xml';
  setlength(Sizes,0);
  if XML.Load then
  begin
    with XML.XmlRoot.Items, FInfo do
    begin
      Author := Value('Author', '');
      Website := Value('Website', '');
      Comment := Value('Comment', '');
      if ItemNamed['IconSizes'] <> nil then
        with ItemNamed['IconSizes'].Items do
          for n := 0 to Count - 1 do
          begin
            SetLength(Sizes,length(Sizes)+1);
            Sizes[High(Sizes)] := Item[n].Properties.IntValue('Size',-1)
          end;
    end
  end;
  XML := nil;

  for n := 0 to High(Sizes) do
  begin
    Dir := FDirectoryBase + FDirectoryIconSet + inttostr(Sizes[n]) + '\';
    if DirectoryExists(Dir) then
    begin
      FindAllIconsInDir(List,Dir);
      MergeLists(pIcons,List,Sizes[n]);
    end;
  end;

  List.Free;
end;

function TThemeIcons.GetIconFileSizedByTag(pTag: String; pTargetSize: integer): String;
var
  index : integer;
begin
  result := '';

  index := GetIconIndexByTag(pTag);
  if index <> -1 then
    result := GetIconFileSizesByIndex(index,pTargetSize);
end;

function TThemeIcons.GetIconFileSizesByIndex(pIndex: integer; pTargetSize: integer): String;
var
  n : integer;
  nearestsize : integer;
  icon : TSharpEIcon;
  s : String;
begin
  result := '';

  if (pIndex < 0) or (pIndex > High(FIcons)) then
    exit;
  
  icon := FIcons[pIndex];
  nearestsize := 0;
  for n := 0 to High(icon.sizes) do
  begin
    if (icon.sizes[n] > nearestsize) and (nearestsize < pTargetSize) then
      nearestsize := icon.sizes[n];
    if nearestsize >= pTargetSize then
      break;
  end; 
  s := FDirectoryBase + FDirectoryIconSet + inttostr(nearestsize) + '\' + icon.Tag + '.png';
  if FileExists(s) then
    result := s
  else result := FDirectoryBase + FDirectoryDefault + inttostr(nearestsize) + '\' + icon.Tag + '.png';
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
  for n := 0 to High(FIcons) do
    if CompareText(FIcons[n].Tag,pTag) = 0 then
    begin
      result := True;
      exit;
    end;
end;

procedure TThemeIcons.LoadFromFile;
var
  XMLI : IXmlBase;
  fileloaded : boolean;
begin
  SetDefaults;

  XMLI := TInterfacedXMLBase.Create(True);
  XMLI.XmlFilename := FThemeInfo.Directory + '\' + THEME_ICONSET_FILE;
  if XMLI.Load then
  begin
    fileloaded := True;
    with XMLI.XmlRoot.Items do
    begin
      FName := Value('Name',DEFAULT_ICONSET);
    end
  end else fileloaded := False;
  XMLI := nil;

  if not fileloaded then
    SaveToFile;

  UpdateDirectory;
  LoadIcons;

  LastUpdate := DateTimeToUnix(Now());
end;

procedure TThemeIcons.LoadIcons;
begin
  ResetIcons;
  GetIconsFromDir(FIcons,FDirectoryBase + FDirectoryIconSet);
  SortByName;
end;

procedure TThemeIcons.ResetIcons;
var
  n : integer;
begin
  for n := 0 to High(FIcons) do
    setlength(FIcons[n].Sizes,0);
  setlength(FIcons,0);
end;

procedure TThemeIcons.SaveToFile;
var
  XML : IXmlBase;
begin
  UpdateDirectory;

  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_ICONSET_FILE;

  XML.XmlRoot.Name := 'SharpEThemeIconSet';
  with XML.XmlRoot.Items do
  begin
    Add('Name',FName);
  end;
  XML.Save;

  XML := nil;
end;

procedure TThemeIcons.SetDefaults;
begin
  LastUpdate := 0;
  FName := 'Default';
  with FInfo do
  begin
    Author  := '';
    Website := '';
    Comment := '';
  end;
  ResetIcons;
  UpdateDirectory;
end;

procedure TThemeIcons.SetInfo(pAuthor, pWebsite, pComment : String);
begin
  with FInfo do
  begin
    Author  := pAuthor;
    Website := pWebsite;
    Comment := pComment;
  end;
end;

procedure TThemeIcons.SetName(Value: String);
begin
  FName := Value;
  UpdateDirectory;
end;

procedure TThemeIcons.SortByName;

  procedure SwapValues(i,j : integer);
  var
    tmp : TSharpEIcon;
  begin
    tmp := FIcons[i];
    FIcons[i] := FIcons[j];
    FIcons[j] := tmp;
  end;

var
  n,k : integer;
begin
  for n := High(FIcons) downto 0 do
    for k := 0 to n - 1 do
      if CompareText(FIcons[n].Tag,FIcons[k].Tag) < 0 then
        SwapValues(n,k);
end;

procedure TThemeIcons.UpdateDirectory;
begin
  FDirectoryBase    := SharpApi.GetSharpeDirectory + ICONS_DIR + '\';
  FDirectoryIconSet := FName + '\';
  FDirectoryDefault := ICONS_DEFAULT_DIR + '\'
end;

end.
