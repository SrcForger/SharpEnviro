{
Source Name: uSharpDeskObjectSetList.pas
Description: TObjectSetList class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
 - OS : Windows 2000 or higher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uSharpDeskObjectSetList;

interface

uses Windows,
     Graphics,
		 Contnrs,
		 Types,
     SysUtils,
     JvSimpleXML,
     SharpThemeApi,
		 SharpApi;

type
		 TObjectSetList = class(TObjectList)
     private
       FXML : TJvSimpleXML;
       FFileName : String;
     public
       constructor Create(pFileName : String);
       destructor Destroy; override;
       procedure SaveSettings;
       procedure CreateXMLFile;
       procedure LoadFromFile;
       procedure Clear; override;
       function GetSetByID(pID : integer) : TObject;
       function GetSetItemByID (pID : integer) : TObject;
       function GenerateObjectID : integer;
       procedure AddObjectSet(pName,pThemeList : String);
       procedure DeleteSet(pID : integer);
     published
       property FileName : String read FFileName;
       property XML : TJvSimpleXML read FXML;
     end;


implementation

uses uSharpDeskObjectSet,
     uSharpDeskObjectSetItem;


constructor TObjectSetList.Create(pFileName : String);
begin
  OwnsObjects := False;
  FXML := TJvSimpleXML.Create(nil);
  FFileName := pFileName;
  LoadFromFile;
end;

destructor TObjectSetList.Destroy;
begin
  Clear;
  Inherited Destroy;
end;

procedure TObjectSetList.CreateXMLFile;
var
   XML : TJvSimpleXML;
   NewFile : String;
   n : integer;
begin
  SharpApi.SendDebugMessageEx('ObjectSetList',PChar('Creating new settings file :' + FFileName),clblue,DMT_STATUS);
  if FileExists(FFileName) then
  begin
    n := 1;
    while FileExists(FFileName + 'backup#' + inttostr(n)) do n := n + 1;
    NewFile := FFileName + 'backup#' + inttostr(n);
    CopyFile(PChar(FileName),PChar(NewFile),True);
    SharpApi.SendDebugMessageEx('ObjectSetList',PChar('Old file backup :' + NewFile),clblue,DMT_INFO);
  end;

  ForceDirectories(ExtractFileDir(FFileName));
  XML := TJvSimpleXML.Create(nil);
  try
    XML.Root.Name := 'ObjectSets';
    with XML.Root.Items.Add('SetList').Items.Add('1').Items do
    begin
      Add('Name','Default');
      Add('Themes',SharpThemeApi.GetThemeName);
    end;
    XML.Root.Items.Add('Objects').Items.Add('1');
    XML.SaveToFile(FFileName);
  finally
    XML.Free;
  end;
end;

function TObjectSetList.GenerateObjectID : integer;
var
   n,i : integer;
   ID : String;
   done : boolean;
begin
  Result := 0;
  randomize;
  if Count = 0 then exit;
  repeat
    done := True;
    ID:='';
    for n:=0 to 6 do ID:=ID+inttostr(random(9)+1);
    for n:= 0 to Count - 1 do
        begin
          for i := 0 to TObjectSet(Items[n]).Count - 1 do
              if TObjectSetItem(TObjectSet(Items[n]).Items[i]).ObjectID = strtoint(ID) then
              begin
                done := False;
                break;
              end;
          if not done then break;
        end;
  until done;
  result := strtoint(ID);
end;

procedure TObjectSetList.SaveSettings;
var
   n,i : integer;
   tempObjectSet : TObjectSet;
   tempSettings : TObjectSetItem;
begin
  FXML.Root.Clear;
  with FXML.Root.Items.Add('SetList').Items do
       for n := 0 to self.Count - 1 do
           with Add(inttostr(TObjectSet(Items[n]).SetID)).Items do
           begin
             Add('Name',TObjectSet(Items[n]).Name);
             Add('Themes',TObjectSet(Items[n]).ThemeList.CommaText);
           end;
           
  FXML.Root.Items.Add('Objects');
  for n := 0 to Count -1 do
  begin
    tempObjectSet := TObjectSet(Items[n]);
    with FXML.Root.Items.ItemNamed['Objects'].Items.Add(inttostr(tempObjectSet.SetID)).Items do
    for i := 0 to tempObjectSet.Count - 1 do
        begin
          tempSettings := TObjectSetItem(tempObjectSet.Items[i]);
          with Add(inttostr(tempSettings.ObjectID)).Items do
          begin
            Add('Locked',tempSettings.Locked);
            Add('Object',tempSettings.ObjectFile);
            Add('PosX',tempSettings.Pos.X);
            Add('PosY',tempSettings.Pos.Y);
            Add('isWindow',tempsettings.isWindow);
          end;
        end;
  end;
  FXML.SaveToFile(FFileName + '~');
  if FileExists(FFileName) then DeleteFile(FFileName);
  RenameFile(FFileName + '~',FFileName);
end;


function TObjectSetList.GetSetItemByID (pID : integer) : TObject;
var
  n,i : integer;
  ObjectSet : TObjectSet;
begin
  for n := 0 to Count - 1 do
  begin
    ObjectSet := TObjectset(Items[n]);
    for i := 0 to ObjectSet.Count - 1 do
        if TObjectSetItem(ObjectSet.Items[i]).ObjectID = pID then
        begin
          result := TObjectSetItem(ObjectSet.Items[i]);
          exit;
        end;
  end;
  result := nil;
end;

function TObjectSetList.GetSetByID(pID : integer) : TObject;
var
   n : integer;
begin
  for n := 0 to Count - 1 do
      if TObjectSet(Items[n]).SetID = pID then
         begin
           result := TObjectSet(Items[n]);
           exit;
         end;
  result := nil;
end;

procedure TObjectSetList.LoadFromFile;
var
   n : integer;
   oset : TObjectSet;
begin
  Clear;
  try
    SharpApi.SendDebugMessageEx('SharpDesk','Loading object set informations',clblack,DMT_INFO);
    FXML.LoadFromFile(FFileName);
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(Format('Error While Loading "%s"', [FFileName])), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
      CreateXMLFile;
      try
        FXML.LoadFromFile(FFileName);
      except
        exit;
      end;
    end;
  end;
  for n:= 0 to FXML.Root.Items.ItemNamed['SetList'].Items.Count - 1 do
  begin
    if strtoint(FXML.Root.Items.ItemNamed['SetList'].Items.Item[n].Name) = 0 then
    begin
      oset := TObjectSet.Create(strtoint(FXML.Root.Items.ItemNamed['SetList'].Items.Item[n].Name),
                                FXML.Root.Items.ItemNamed['SetList'].Items.Item[n].Items.Value('Name','#'),
                                self);
      oset.ThemeList.CommaText := FXML.Root.Items.ItemNamed['SetList'].Items.Item[n].Items.Value('Themes','#');
      Add(oset);
    end;
  end;
  if Count = 0 then
  begin
    oset := TObjectSet.Create(0,'Default',self);
    oset.ThemeList.CommaText := '0';
    Add(oset);
  end;
end;

procedure TObjectSetList.Clear;
var
   n : integer;
begin
  for n := 0 to Count - 1 do
      if Items[n] <> nil then
      begin
        TObjectSet(Items[n]).Clear;
      end;
  Inherited Clear;
end;

procedure TObjectSetList.AddObjectSet(pName,pThemeList : String);
var
   n : integer;
   newID : integer;
   oset : TObjectSet;
begin
  newID := 1;
  for n := 0 to count - 1 do
  begin
    if TObjectSet(Items[n]).Name = pName then exit;
    if newID <= TObjectSet(Items[n]).SetID then
       newID := TObjectSet(Items[n]).SetID + 1;
  end;
  with FXML.Root.Items.ItemNamed['SetList'].Items.Add(inttostr(NewID)).Items do
  begin
    Add('Name',pName);
    Add('Themes',pThemeList);
  end;
  FXML.Root.Items.ItemNamed['Objects'].Items.Add(inttostr(NewID));
  oset := TObjectSet.Create(newID,pName,self);
  oset.ThemeList.CommaText := pThemeList;
  Add(oset);
end;

procedure TObjectSetList.DeleteSet(pID : integer);
var
   ObjectSet : TObjectSet;
begin
  ObjectSet := TObjectSet(GetSetByID(pID));
  Items[IndexOf(ObjectSet)] := nil;
  if ObjectSet <> nil then
  begin
    ObjectSet.Clear;
    FreeAndNil(ObjectSet);
  end;
  Pack;
end;

end.
