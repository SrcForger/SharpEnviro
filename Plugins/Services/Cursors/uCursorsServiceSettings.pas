{
Source Name: uCursorsServiceSettings
Description: Settings class to load/save settings
Copyright (C) (2007) Martin Krämer (MartinKraemer@gmx.net)
              (2004) Pixol (Pixol@SharpE-Shell.org)
              (2004) Zack Cerza - zcerza@coe.neu.edu

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

unit uCursorsServiceSettings;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  // Standard
  SysUtils,
  Graphics,
  SharpThemeApiEx,

  // JVCL
  JclSimpleXml;

type
  TColorArray = array of integer;

  TCursorsSettings = class
  private
    FFileName: string;
    FCurrentSkin: string;
    FColors: TColorArray;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure Load;
    procedure Save;

    property FileName: string read FFileName write FFileName;
    property CurrentSkin: string read FCurrentSkin write FCurrentSkin;
    property Colors: TColorArray read FColors;
  end;

implementation

uses
  uCursorsServiceManager,
  SharpApi;

{ TCursorSettings }

constructor TCursorsSettings.Create;
begin
  inherited Create;

  FFileName := GetCurrentTheme.Info.Directory + '\Cursor.xml';

  setlength(FColors,4);
  // some default values;
  FColors[0] := clWhite;
  FColors[1] := clSilver;
  FColors[2] := clMaroon;
  FColors[3] := 1;


  if FileExists(FFileName) then
    Load
  else
    Save;
end;

destructor TCursorsSettings.Destroy;
begin
  setlength(FColors,0);
  
  Inherited Destroy;
end;

procedure TCursorsSettings.Load;
var
  xml: TJclSimpleXml;
  n: integer;
begin
  FFileName := GetCurrentTheme.Info.Directory + '\Cursor.xml';
  
  // Create and load XML file
  xml := TJclSimpleXml.Create;
  try
    try
      xml.LoadFromFile(FFileName);

      // Get the properties from the XML file
      with xml.Root.Items do
      begin
        FCurrentSkin := Value('CurrentSkin');
        for n := 0 to High(FColors) do
            FColors[n] := IntValue('Color' + inttostr(n),FColors[n]);
      end;

    except
      on E: Exception do begin
        Debug('Error While Loading settings', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);
      end;
    end;
  finally
    xml.Free;
  end;

end;

procedure TCursorsSettings.Save;
var
  xml: TJclSimpleXml;
  n : integer;
begin
  // Create and load XML file
  xml := TJclSimpleXml.Create;
  try
    try
      xml.Root.Name := 'SharpEThemeCursor';

      // Add the properties to the root node
      with xml.Root.Items do
      begin
        Add('CurrentSkin', FCurrentSkin);
        for n := 0 to High(FColors) do
            Add('Color' + inttostr(n),FColors[n]);
      end;

      xml.SaveToFile(FFileName);
    except
      on E: Exception do begin
        Debug('Error While Saving settings', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);
      end;
    end;
  finally
    xml.Free;
  end;

end;
end.

