{
Source Name: uSharpDeskObjectFileList
Description: TObjectFileList class
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

unit uSharpDeskObjectFileList;

interface

uses Windows,
     Contnrs,
     SysUtils,
     Graphics,
     Dialogs,
     gr32,
     gr32_layers,
     gr32_image,
     SharpApi,
     uSharpDeskObjectFile,
     uSharpDeskObjectSet;

type

    TObjectFileList = class(TObjectList)
    private
      FImage : TImage32;
      FDirectory : String;
      FExtension : String;
      FOwner : TObject;
    public
      constructor Create(pOwner : TObject; pDirectory,pExtension : String; pImage : TImage32);
      procedure LoadFromDirectory(pDirectory : String);
      procedure UnLoadAll;
      procedure ReLoadAllObjects;
      procedure RefreshDirectory;
      function GetByObjectFile(pFile : String) : TObjectFile;
    published
      property Directory     : String read FDirectory;
      property FileExtension : String read FExtension write FExtension;
      property Owner         : TObject read FOwner;
    end;


implementation

uses uSharpDeskObjectSetItem,
     uSharpDeskDesktopObject;

constructor TObjectFileList.Create(pOwner : TObject; pDirectory,pExtension : String; pImage : TImage32);
begin
  Inherited Create;
  FOwner := pOwner;
  FImage := pImage;
  FExtension := pExtension;
  LoadFromDirectory(pDirectory);
end;


function TObjectFileList.GetByObjectFile(pFile : String) : TObjectFile;
var
   n : integer;
begin
  for n := 0 to Count - 1 do
      if TObjectFile(Items[n]).FileName = pFile then
      begin
        result := TObjectFile(Items[n]);
        exit;
      end;
  result := nil;    
end;



procedure TObjectFileList.LoadFromDirectory(pDirectory : String);
var
	sr : TSearchRec;
begin
  FDirectory := pDirectory;
	Clear;
  pDirectory := ExcludeTrailingBackSlash(pDirectory);
  if not DirectoryExists(pDirectory) then exit;

  if FindFirst(pDirectory+'\*'+FExtension, faAnyFile , sr) = 0 then
  repeat
    if ExtractFileExt(sr.Name) = FExtension then
       if self.GetByObjectFile(sr.Name) = nil then Add(TObjectFile.Create(self,pDirectory+'\'+sr.Name));
  until FindNext(sr) <> 0;
  FindClose(sr);
end;


procedure TObjectFileList.UnLoadAll;
var
	n : integer;
begin
	for n:=0 to Count - 1 do
  	TObjectFile(Items[n]).Unload;
end;

procedure TObjectFileList.ReLoadAllObjects;
var
  n : integer;
begin
	for n:=0 to Count - 1 do
  	TObjectFile(Items[n]).Load;
end;

procedure TObjectFileList.RefreshDirectory;
begin
  LoadFromDirectory(FDirectory);
end;

end.
