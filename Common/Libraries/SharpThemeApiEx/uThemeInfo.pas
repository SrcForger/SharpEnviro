{
Source Name: uThemeInfo.pas
Description: TThemeInfo class implementing IThemeInfo Interface
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

unit uThemeInfo;

interface

uses
  SharpApi, uThemeConsts, uIThemeInfo;

type
  TThemeInfo = class(TInterfacedObject, IThemeInfo)
  private
    FName : String;
    FDirectory : String;
    FInfo : TThemeInfoAdditional;
    procedure SetDefaults;
    procedure UpdateDirectory;
  public
    LastUpdate : Int64;
    constructor Create(Name : String); reintroduce;
    destructor Destroy; override;
    
    // IThemeInfoInterface
    function GetName : String; stdcall;
    procedure SetName(Value : String); stdcall;
    property Name : String read GetName write SetName;

    function GetDirectory : String; stdcall;
    property Directory : String read GetDirectory;

    function GetInfo: TThemeInfoAdditional; stdcall;
    property Info : TThemeInfoAdditional read GetInfo;

    procedure SetInfo(pAuthor, pWebsite, pComment : String);

    procedure SaveToFile; stdcall;
    procedure LoadFromFile; stdcall;    
  end;

implementation

uses
  SysUtils, DateUtils, JclSimpleXML,
  IXmlBaseUnit;

{ TThemeInfo }

constructor TThemeInfo.Create(Name: String);
begin
  inherited Create;
  SharpApi.SendDebugMessage('ThemeAPI','TThemeInfo.Create', 0);    

  FName := Name;
  
  LoadFromFile;
end;

destructor TThemeInfo.Destroy;
begin
  SharpApi.SendDebugMessage('ThemeAPI','TThemeInfo.Destroy', 0);
  inherited;
end;

function TThemeInfo.GetDirectory: String;
begin
  result := FDirectory;
end;

function TThemeInfo.GetInfo: TThemeInfoAdditional;
begin
  result := FInfo;
end;

function TThemeInfo.GetName: String;
begin
  result := FName;
end;

procedure TThemeInfo.LoadFromFile;
var
  XML : IXmlBase;
  fileloaded : boolean;
begin
  SetDefaults;
  UpdateDirectory;

  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FDirectory + '\' + THEME_INFO_FILE;
  if XML.Load then
  begin
    fileloaded := True;
    with XML.XmlRoot.Items, FInfo do
    begin
      Author  := Value('Author',Author);
      Website := Value('Website',Website);
      Comment := Value('Info',Comment);
    end
  end else fileloaded := False;
  XML := nil;

  if not fileloaded then
    SaveToFile;

  LastUpdate := DateTimeToUnix(Now());
end;

procedure TThemeInfo.SaveToFile;
var
  XML : IXmlBase;
begin
  UpdateDirectory;

  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FDirectory + '\' + THEME_INFO_FILE;

  XML.XmlRoot.Name := 'SharpETheme';
  with XML.XmlRoot.Items, FInfo do
  begin
    Add('Name',FName);
    Add('Author',Author);
    Add('Website',Website);
    Add('Info',Comment);
  end;
  XML.Save;

  XML := nil;
end;

procedure TThemeInfo.SetDefaults;
begin
  if length(trim(FName)) = 0 then
    FName := DEFAULT_THEME;
    
  UpdateDirectory;
  LastUpdate := 0;

  with FInfo do
  begin
    Author  := '';
    Website := '';
    Comment := '';
  end;
end;

procedure TThemeInfo.SetInfo(pAuthor, pWebsite, pComment: String);
begin
  with FInfo do
  begin
    Author  := pAuthor;
    Website := pWebsite;
    Comment := pComment;
  end;
end;

procedure TThemeInfo.SetName(Value: String);
begin
  if length(trim(Value)) <> 0 then
  begin
    FName := Value;
    UpdateDirectory;
  end;
end;

procedure TThemeInfo.UpdateDirectory;
begin
  FDirectory  := SharpApi.GetSharpeUserSettingsPath + THEME_DIR + '\' + FName;
end;

end.
