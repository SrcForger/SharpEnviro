{
Source Name: uSharpEDesktopItem.pas
Description: TSharpEDesktopItem class
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

unit uSharpEDesktopItem;

interface

uses Windows,Classes,SysUtils,GR32,GR32_Layers;

type
  TSharpEDesktopItemTypes = (dtShellLink,dtFile,dtDirectory);

  TSharpEDesktopItem = class
  private
    FFileName   : String;
    FBaseDir    : String;
    FWorkDir    : String;
    FTarget     : String;
    FCaption    : String;
    FIcon       : TBitmap32;
    FLastChange : TDateTime;
    FHasChanged : boolean;
    FType       : TSharpEDesktopItemTypes;
    FLayer      : TCustomLayer;
    FIsInGrid   : Boolean;
    procedure UpdateDirectory;
    procedure UpdateShellLink;
    procedure UpdateFile;
    function GetHasLayer : boolean;
  public
    procedure UpdateFromFile;
    
    constructor Create(pFileName : String); reintroduce;
    destructor Destroy; override;
  published
    property Caption  : String read FCaption;
    property FileName : String read FFileName;
    property LastChange : TDateTime read FLastChange;
    property IsInGrid : boolean read FIsInGrid write FIsInGrid;
    property HasChanged : boolean read FHasChanged write FHasChanged;
    property HasLayer : boolean read GetHasLayer;
    property Layer : TCustomLayer read FLayer write FLayer;
    property Icon : TBitmap32 read FIcon;
    property ItemType : TSharpEDesktopItemTypes read FType;
  end;

implementation

uses JclFileUtils,
     SharpIconUtils,
     uExecServiceExtractShortcut;

constructor TSharpEDesktopItem.Create(pFileName : String);
var
  Ext : String;
begin
  inherited Create;

  FIcon := TBitmap32.Create;

  FLayer := nil;
  FFileName := pFileName;
  FHasChanged := True;
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
  FreeAndNil(FIcon);

  inherited Destroy;
end;

function TSharpEDesktopItem.GetHasLayer : boolean;
begin
  result := Assigned(FLayer);
end;

procedure TSharpEDesktopItem.UpdateDirectory;
begin
  FTarget := IncludeTrailingBackSlash(FFileName);
  FWorkDir := FTarget;
  FCaption := PathExtractPathDepth(FTarget,1);
end;

procedure TSharpEDesktopItem.UpdateShellLink;
var
  link : TLinkParams;
begin
  ResolveLink(FFileName,link);
  FTarget  := link.Target;
  if IsDirectory(FTarget) then
  begin
    FType := dtDirectory;
    UpdateDirectory;
    exit;
  end else FType := dtShellLink;
  FWorkDir := link.WorkDir;
  FCaption := ExtractFileName(FFileName);
end;

procedure TSharpEDesktopItem.UpdateFile;
begin
  FTarget := FFileName;
  FWorkDir := ExtractFileDir(FFileName);
  FCaption := ExtractFileName(FTarget);
end;

procedure TSharpEDesktopItem.UpdateFromFile;
begin
  GetFileLastWrite(FFileName,FLastChange);
  
  case FType of
    dtDirectory : UpdateDirectory;
    dtShellLink : UpdateShellLink;
    else UpdateFile;
  end;

  extrShellIcon(FIcon,FFileName);
end;

end.
