{
Source Name: uThemeList.pas
Description: TThemeList Class
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

unit uThemeList;

interface

uses
  uThemeConsts, uIThemeList;

type
  TThemeList = class(TInterfacedObject, IThemeList)
  private
    FThemes: TThemeListItemSet;
    procedure SetDefaults;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    function GetThemes: TThemeListItemSet; stdcall;
    property Themes : TThemeListItemSet read GetThemes;

    procedure UpdateThemeList; stdcall;
    function GetThemeCount : integer; stdcall;
  end;

implementation

uses
  SysUtils, JclSimpleXML, SharpApi;

{ TThemeList }

constructor TThemeList.Create;
begin
  inherited Create;

  UpdateThemeList;
end;

destructor TThemeList.Destroy;
begin
  setlength(FThemes,0);

  inherited Destroy;
end;

function TThemeList.GetThemeCount: integer;
begin
  result := length(FThemes);
end;

function TThemeList.GetThemes: TThemeListItemSet;
begin
  result := FThemes;
end;

procedure TThemeList.SetDefaults;
begin
  setlength(FThemes,0);
end;

procedure TThemeList.UpdateThemeList;
var
  SR: TSearchRec;
  sThemeDir, sThemeFile, sPreview: string;
  XML: TJclSimpleXml;
  fileloaded : boolean;
begin
  SetDefaults;

  sThemeDir := GetSharpeUserSettingsPath + THEME_DIR + '\';

  XML := TJclSimpleXML.Create;
  if FindFirst(sThemeDir + '*.*',faDirectory  ,sr) = 0 then
  repeat
    sThemeFile := sThemeDir + sr.Name + '\Theme.xml';
    if FileExists(sThemeFile) then
    begin
      fileloaded := False;
      try
        XML.LoadFromFile(sThemeFile);
        fileloaded := True;
      except
      end;
      if fileloaded then
      begin
        setlength(FThemes,length(FThemes)+1);
        with FThemes[High(FThemes)] do
        begin
          Name     := XML.Root.Items.Value('Name', 'Invalid_Name');
          Author   := XML.Root.Items.Value('Author', 'Invalid_Author');
          Comment  := XML.Root.Items.Value('Info', 'Invalid_Comment');
          Website  := XML.Root.Items.Value('Website', 'Invalid_Website');
          ReadOnly := XML.Root.Items.BoolValue('ReadOnly', false);

          FileName := sThemeFile;
          sPreview := ExtractFilePath(FileName) + 'Preview.png';
          if FileExists(sPreview) then
            Preview := sPreview
          else Preview := '';
        end;
      end;
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
  XML.Free;
end;


end.
