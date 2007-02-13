{
Source Name: uSharpEDesktopItem.pas
Description: TSharpEDesktopItem class
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

unit uSharpEDesktopItem;

interface

uses Windows,Classes,SysUtils;

type
  TSharpEDesktopItemTypes = (dtShellLink,dtFile,dtDirectory);

  TSharpEDesktopItem = class
  private
    FFileName   : String;
    FBaseDir    : String;
    FWorkDir    : String;
    FTarget     : String;
    FLastChange : TDateTime;
    FType       : TSharpEDesktopItemTypes;
    FIsInGrid   : Boolean;
    procedure UpdateDirectory;
    procedure UpdateShellLink;
    procedure UpdateFile;
  public
    procedure UpdateFromFile;
    
    constructor Create(pFileName : String); reintroduce;
    destructor Destroy; override;
  published
    property FileName : String read FFileName;
    property LastChange : TDateTime read FLastChange;
    property IsInGrid : boolean read FIsInGrid write FIsInGrid;
  end;

implementation

uses JclFileUtils,
     uExecServiceExtractShortcut;

constructor TSharpEDesktopItem.Create(pFileName : String);
var
  Ext : String;
begin
  inherited Create;

  FFileName := pFileName;
  FBaseDir  := IncludeTrailingBackSlash(ExtractFileDir(FFileName));
  FIsInGrid := False;
  FLastChange := 0;
  
  Ext := ExtractFileExt(FFileName);
  if IsDirectory(FFileName) then FType := dtDirectory
  else if CompareText(Ext,'.lnk') = 0 then FType := dtShellLink
  else FType := dtFile;

  UpdateFromFile;
end;

destructor TSharpEDesktopItem.Destroy;
begin
  inherited Destroy;
end;

procedure TSharpEDesktopItem.UpdateDirectory;
begin
  FTarget := IncludeTrailingBackSlash(FFileName);
  FWorkDir := FTarget;
end;

procedure TSharpEDesktopItem.UpdateShellLink;
var
  link : TLinkParams;
begin
  ResolveLink(FFileName,link);
  FTarget  := link.Target;
  FWorkDir := link.WorkDir;
end;

procedure TSharpEDesktopItem.UpdateFile;
begin
  FTarget := FFileName;
  FWorkDir := ExtractFileDir(FFileName);
end;

procedure TSharpEDesktopItem.UpdateFromFile;
begin
  GetFileLastWrite(FFileName,FLastChange);
  
  case FType of
    dtDirectory : UpdateDirectory;
    dtShellLink : UpdateShellLink;
    else UpdateFile;
  end;
end;

end.
