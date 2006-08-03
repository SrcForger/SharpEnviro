{
Source Name: uSharpDeskTObjectSettings.pas
Description: TObjectSettings class
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

unit uSharpDeskTObjectSettings;

interface

uses Windows,
     Graphics,
     Sysutils,
     Forms,
     JvSimpleXML,
     SharpApi;

type

    TObjectSettings = class
                         private
                         public
                           XML : TJvSimpleXML;
                           constructor Create;
                           destructor Destroy; override;
                           procedure SaveObjectSettings;
                           procedure ReloadObjectSettings;
                           procedure CreateXMLFile;
                         published
                         end;


implementation


constructor TObjectSettings.Create;
var
   FileName : String;
begin
  FileName := GetSharpeGlobalSettingsPath + 'SharpDesk\Objects.xml';
  XML := TJvSimpleXML.Create(nil);
  XML.Options := [sxoAutoIndent];
  try
    XML.LoadFromFile(FileName);
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('ObjectControler',PChar(Format('Error While Loading "%s"', [FileName])), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('Objectcontroler',PChar(E.Message),clblue, DMT_TRACE);
      CreateXMLFile;
      try
        XML.LoadFromFile(FileName);
      except
        exit;
      end;
    end;
  end;
end;


destructor TObjectSettings.Destroy;
begin
  XML.Free;
  XML := nil;
end;

procedure TObjectSettings.ReloadObjectSettings;
begin
  XML.LoadFromFile(GetSharpeGlobalSettingsPath + 'SharpDesk\Objects.xml');
end;

procedure TObjectSettings.SaveObjectSettings;
begin
  XML.SaveToFile(GetSharpeGlobalSettingsPath + 'SharpDesk\Objects.xml');
end;

procedure TObjectSettings.CreateXMLFile;
var
   n : integer;
   newFile : String;
   FileName : String;
begin
  FileName := GetSharpeUserSettingsPath + 'SharpDesk\Sets.xml';
  if FileExists(FileName) then
  begin
    n := 1;
    while FileExists(FileName + '.backup#' + inttostr(n)) do n := n + 1;
    NewFile := FileName + '.backup#' + inttostr(n);
    CopyFile(PChar(FileName),PChar(NewFile),True);
    SharpApi.SendDebugMessageEx('SharpDesk',PChar('Old file backup :' + NewFile),clblue,DMT_INFO);
  end;

  FileName := GetSharpeGlobalSettingsPath + 'SharpDesk\Objects.xml';
  if FileExists(FileName) then
  begin
    n := 1;
    while FileExists(FileName + '.backup#' + inttostr(n)) do n := n + 1;
    NewFile := FileName + '.backup#' + inttostr(n);
    CopyFile(PChar(FileName),PChar(NewFile),True);
    SharpApi.SendDebugMessageEx('SharpDesk',PChar('Old file backup :' + NewFile),clblue,DMT_INFO);
  end;
  ForceDirectories(ExtractFileDir(FileName));
  XML.Root.Clear;
  XML.Root.Name := 'SharpDesk';
  XML.Root.Items.Add('ObjectSettings');
  SaveObjectSettings;
end;



end.
