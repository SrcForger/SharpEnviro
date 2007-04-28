{
Source Name: SharpECustomSkinSettings
Description: custom skin settings usage unit
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
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

unit SharpECustomSkinSettings;

interface

uses JvSimpleXML,SysUtils, SharpApi, SharpThemeApi;

type
   TSharpECustomSkinSettings = class
  private
    FXML : TJvSimpleXML;
    FPath : String;
    function GetXMLElem : TJvSimpleXMLElem;
  public
    procedure LoadFromXML(ppath: string);
    procedure Clear;
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property xml : TJvSimpleXMLElem read GetXMLElem;
    property Path : String read FPath;
  end;

implementation

function TSharpECustomSkinSettings.GetXMLElem : TJvSimpleXMLElem;
begin
  result :=  FXML.Root;
end;

procedure TSharpECustomSkinSettings.LoadFromXML(ppath: string);
var
  dir : String;
  fn : String;
begin
  Clear;
  dir := ppath;
  if FileExists(dir + 'custom.xml') then fn := dir + 'custom.xml'
     else
     begin
       {$WARNINGS OFF}
       dir := SharpThemeApi.GetSkinDirectory;
       {$WARNINGS ON}
       if FileExists(dir + 'custom.xml') then fn := dir + 'custom.xml'
          else exit;
     end;

  try
    FXML.LoadFromFile(fn);
    FPath := dir;
  except
    Clear;
  end;
end;

procedure TSharpECustomSkinSettings.Clear;
begin
  FXML.Root.Items.Clear;
  FPath := '';
end;

constructor TSharpECustomSkinSettings.Create;
begin
  inherited Create;
  FXML := TJvSimpleXML.Create(nil);
  Clear;
end;

destructor TSharpECustomSkinSettings.Destroy;
begin
  FXML.Free;
  Inherited Destroy;
end;

end.
