{
Source Name: uSharpDeskObjectSetItem.pas
Description: TDeskObjectSetItem class
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
     published
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
