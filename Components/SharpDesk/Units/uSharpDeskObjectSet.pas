{
Source Name: uSharpDeskObjectSet.pas
Description: TObjectSet class
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
     uSharpDeskObjectSetList,
     uSharpDeskObjectSetItem;

type
		 TObjectSet = class(TObjectList)
     private
			 FSetID    : integer;
       FName     : String;
       FSetList  : TObjectSetList;
       FThemeList : TStringList;
     public
       constructor Create(pID : integer; pName : String; parent : TObjectSetList);
       destructor Destroy; override;
       procedure Load;
       procedure Clear; override;
       function AddDesktopObject(pObjectID : integer;
                                 pObjectFile : String;
                                 pPos : TPoint;
                                 pLocked : boolean;
                                 pisWindow : boolean) : TObjectSetItem;
     published           
       property Name  : String read FName write FName;
       property SetID : integer read FSetID;
       property ThemeList : TStringList read FThemeList;
     end;

implementation

constructor TObjectSet.Create(pID : integer; pName : String; parent : TObjectSetList);
begin
  Inherited Create;
  FSetID   := pID;
  FName    := pName;
  FSetList := parent;
  FThemeList := TStringList.Create;
  FThemeList.Clear;
  OwnsObjects := False;  
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
	Clear;
  FreeAndNil(FThemeList);
  Inherited Destroy;
end;

procedure TObjectSet.Load;
var
   n : integer;
begin
  Clear;
  for n:= 0 to FSetList.XML.Root.Items.ItemNamed['Objects'].Items.ItemNamed[inttostr(FSetID)].Items.Count - 1 do
      with FSetList.XML.Root.Items.ItemNamed['Objects'].Items.ItemNamed[inttostr(FSetID)].Items.Item[n] do
           AddDesktopObject(strtoint(Name),
                            Items.Value('Object'),
                            Point(Items.IntValue('PosX'),Items.IntValue('PosY')),
                            Items.BoolValue('Locked'),
                            Items.BoolValue('isWindow',False));
      
end;

procedure TObjectSet.Clear;
begin
  Inherited Clear;
end;

end.
