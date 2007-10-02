{
Source Name: uSharpDeskObjectSetItem.pas
Description: TDeskObjectSetItem class
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

unit uSharpDeskObjectSetItem;

interface

uses Windows,
		 Contnrs,
		 Types,
     Dialogs,
     SysUtils,
     JvSimpleXML,
		 SharpApi;

type
		 TObjectSetItem = class
     private
       FOwner      : TObject;
       FObjectID   : integer;
       FLocked     : boolean;
       FisWindow   : boolean;
       FPos		     : TPoint;
       FObjectFile : String;
     public
       constructor Create(pOwner : TObject;
                          pObjectID : integer;
                          pObjectFile : String;
                          pPos : TPoint;
                          pLocked : boolean;
                          pisWindow : boolean);

       property Owner      : TObject read FOwner      write FOwner;
       property Locked     : boolean read FLocked     write FLocked;
       property Pos        : TPoint  read FPos        write FPos;
       property ObjectID   : integer read FObjectID;
       property ObjectFile : String  read FObjectFile;
       property isWindow   : boolean read FisWindow   write FisWindow;                          
     end;

implementation

constructor TObjectSetItem.Create(pOwner : TObject; pObjectID : integer; pObjectFile : String; pPos : TPoint; pLocked : boolean; pisWindow : boolean);
begin
  Inherited Create;
  FOwner := pOwner;
  FObjectID := pObjectID;
  FObjectFile := pObjectFile;
  FPos := pPos;
  FLocked := pLocked;
  FisWindow := pisWindow;
end;

end.
