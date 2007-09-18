{
Source Name: uSharpDeskObjectSet.pas
Description: TObjectSet class
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

unit uSharpDeskObjectSet;

interface

uses Windows,
		 Contnrs,
     Classes,
		 Types,
     Dialogs,
     SysUtils,
     JvSimpleXML,
		 SharpApi,
     uSharpDeskObjectSetItem;

type
		 TObjectSet = class(TObjectList)
     private
     public
       constructor Create;
       destructor Destroy; override;
       procedure Load;
       procedure Save;
       function AddDesktopObject(pObjectID : integer;
                                 pObjectFile : String;
                                 pPos : TPoint;
                                 pLocked : boolean;
                                 pisWindow : boolean) : TObjectSetItem;
       function GenerateObjectID : integer;
     published
     end;

implementation

constructor TObjectSet.Create;
begin
  Inherited Create;
  OwnsObjects := True;
  Load;
end;

function TObjectSet.AddDesktopObject(pObjectID : integer;
                                     pObjectFile : String;
                                     pPos : TPoint;
                                     pLocked : boolean;
                                     pisWindow : boolean) : TObjectSetItem;
var
  tempSettings : TObjectSetItem;
begin
  tempSettings := TObjectSetItem.Create(self,
                                        pObjectID,
                                        pObjectFile,
                                        pPos,
                                        pLocked,
                                        pisWindow);
  self.Add(tempSettings);
  result := tempSettings;
end;


destructor TObjectSet.Destroy;
begin
  Inherited Destroy;
end;


function TObjectSet.GenerateObjectID: integer;
var
   n : integer;
   ID : String;
   done : boolean;
begin
  randomize;
  repeat
    done := True;
    ID:='';
    for n:= 0 to 6 do ID:=ID+inttostr(random(9)+1);
    for n:= 0 to Count - 1 do
      if TObjectSetItem(Items[n]).ObjectID = strtoint(ID) then
      begin
        done := False;
        break;
      end;
  until done;
  result := strtoint(ID);
end;

procedure TObjectSet.Load;
var
  n : integer;
  XML : TJvSimpleXML;
  FName : String;
begin
  Clear;

  FName := SharpApi.GetSharpeUserSettingsPath + 'SharpDesk\Objects.xml';
  XML := TJvSimpleXML.Create(nil);
  if FileExists(FName) then
  begin
    try
      XML.LoadFromFile(FName);
      for n := 0 to XML.Root.Items.Count - 1 do
        with XML.Root.Items.Item[n].Items do
        begin
          AddDesktopObject(IntValue('ID'),
                           Value('Object'),
                           Point(IntValue('PosX'),IntValue('PosY')),
                           BoolValue('Locked'),
                           BoolValue('isWindow',False));
        end;
    except

    end;
  end;
  XML.Free;
end;

procedure TObjectSet.Save;
var
  n : integer;
  XML : TJvSimpleXML;
  FName : String;
  setitem : TObjectSetItem;
begin
  FName := SharpApi.GetSharpeUserSettingsPath + 'SharpDesk\Objects.xml';
  XML := TJvSimpleXML.Create(nil);
  XML.Root.Name := 'SharpDeskObjectSet';
  for n := 0 to Count - 1 do
  begin
    setitem := TObjectSetItem(Items[n]);
    with XML.Root.Items.Add('Item').Items do
    begin
      Add('ID',setitem.ObjectID);
      Add('Object',setitem.ObjectFile);
      Add('PosX',setitem.Pos.X);
      Add('PosY',setitem.Pos.Y);
      Add('Locked',setitem.Locked);
      Add('isWindow',setitem.isWindow);
    end;
  end;
  XML.SaveToFile(FName + '~');
  if FileExists(FName) then
    DeleteFile(FName);
  RenameFile(FName + '~',FName);
  XML.Free;
end;

end.
