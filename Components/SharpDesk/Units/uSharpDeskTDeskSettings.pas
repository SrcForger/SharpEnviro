{
Source Name: uSharpDeskTDeskSettings.pas
Description: TDeskSettings class
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

unit uSharpDeskTDeskSettings;

interface

uses Graphics,
     Windows,
     Sysutils,
     Forms,
     JvSimpleXML,
     SharpApi,
     uSharpDeskTThemeSettings,
     uSharpDeskSharpETheme,
     uSharpDeskObjectSet;

type                  
    TDeskSettings = class
                     private
                       XML : TJvSimpleXML;
                     public
                       Owner               : TObject;
                       Theme               : TSharpETheme;
                       ThemeID             : integer;
                       CheckObjectPosition : boolean;
                       DragAndDrop         : boolean;
                       AdvancedCommands    : boolean;
                       AdvancedMM          : boolean;
                       Tooltips            : boolean;
                       SingleClick         : boolean;
                       Grid                : boolean;
                       GridX               : integer;
                       GridY               : integer;
                       SetObjectRolledOut  : boolean;
                       TerminalMode        : boolean;
                       SharpMenu           : boolean;
                       ObjectMenu          : boolean;
                       ThemeLoading        : boolean;
                       ObjectMove          : boolean;
                       ExitDesk            : boolean;   
                       constructor Create(pOwner : TObject);
                       destructor Destroy; override;
                       procedure SaveSettings;
                       procedure ReloadSettings;
                       procedure CreateXMLFile;
                     published
                    end;



implementation


constructor TDeskSettings.Create(pOwner : TObject);
begin
  inherited Create;

  Owner := pOwner;
  Theme := nil;
  ThemeID := 0;
  CheckObjectPosition := True;
  DragAndDrop         := True;
  AdvancedCommands    := True;
  AdvancedMM          := True;
  SingleClick         := False;
  Tooltips            := True;
  Grid                := True;
  SetObjectRolledOut  := True;
  GridX               := 8;
  GridY               := 8;
  TerminalMode        := False;
  SharpMenu           := True;
  ObjectMenu          := True;
  ThemeLoading        := True;
  ObjectMove          := True;
  ExitDesk            := True;
  XML := TJvSimpleXML.Create(nil);
  ReloadSettings;
end;

destructor TDeskSettings.Destroy;
begin
  XML.Free;
  inherited Destroy;
end;

procedure TDeskSettings.CreateXMLFile;
var
   n : integer;
   newFile : String;
   FileName : String;
begin
  FileName := GetSharpeUserSettingsPath + 'SharpDesk\Settings.xml';
  if FileExists(FileName) then
  begin
    n := 1;
    while FileExists(FileName + 'backup#' + inttostr(n)) do n := n + 1;
    NewFile := FileName + 'backup#' + inttostr(n);
    CopyFile(PChar(FileName),PChar(NewFile),True);
    SharpApi.SendDebugMessageEx('SharpDesk',PChar('Old file backup :' + NewFile),clblue,DMT_INFO);
  end;
  ForceDirectories(ExtractFileDir(FileName));
  XML.Root.Clear;
  XML.Root.Name := 'SharpDesk';
  SaveSettings;
  ReLoadSettings;
end;

procedure TDeskSettings.SaveSettings;
begin
  XML.Root.Items.Clear;
  XML.Root.Items.Add('Settings');
  XML.Root.Items.Add('Grid');
  XML.Root.Items.Add('Terminal');
  with XML.Root.Items.ItemNamed['Settings'].Items do
  begin
    if Theme<>nil then Add('Theme',Theme.ThemeID)
       else Add('Theme',ThemeID);
    Add('DragAndDrop',DragAndDrop);
    Add('AdvancedCommands',AdvancedCommands);
    Add('AdvancedMemoryManagement',AdvancedMM);
    Add('SingleClick',SingleClick);
    Add('CheckObjectPosition',CheckObjectPosition);
    Add('Tooltips',Tooltips);
    Add('SetObjectRolledOut',SetObjectRolledOut);
  end;
  with XML.Root.Items.ItemNamed['Terminal'].Items do
  begin
    Add('TerminalMode',TerminalMode);
    Add('SharpMenu',SharpMenu);
    Add('ObjectMenu',ObjectMenu);
    Add('ThemeLoading',ThemeLoading);
    Add('ObjectMove',ObjectMove);
    Add('ExitDesk',ExitDesk);
  end;
  with XML.Root.Items.ItemNamed['Grid'].Items do
  begin
    Add('UseGrid',Grid);
    Add('GridX',GridX);
    Add('GridY',GridY);
  end;
  XML.SaveToFile(GetSharpeUserSettingsPath + 'SharpDesk\Settings.xml');
end;

procedure TDeskSettings.ReloadSettings;
var
   FileName : String;
begin
  FileName :=  GetSharpeUserSettingsPath + 'SharpDesk\Settings.xml';
  try
    XML.LoadFromFile(FileName);
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(Format('Error While Loading "%s"', [FileName])), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
      CreateXMLFile;
      try
        XML.LoadFromFile(FileName);
      except
        exit;
      end;
    end;
  end;

  XML.Options :=[sxoAutoCreate,sxoAutoIndent];
  with XML.Root.Items.ItemNamed['Settings'].Items do
  begin
    ThemeID             := IntValue('Theme',0);
    DragAndDrop         := BoolValue('DragAndDrop',True);
    AdvancedCommands    := BoolValue('AdvancedCommands',True);
    AdvancedMM          := BoolValue('AdvancedMemoryManagement',True);
    SingleClick         := BoolValue('SingleClick',False);
    CheckObjectPosition := ItemNamed['CheckObjectPosition'].BoolValue;
    Tooltips            := BoolValue('Tooltips',True);
    SetObjectRolledOut  := BoolValue('SetObjectRolledOut',True); 
  end;
  with XML.Root.Items.ItemNamed['Terminal'].Items do
  begin
    TerminalMode := BoolValue('TerminalMode',False);
    SharpMenu    := BoolValue('SharpMenu',True);
    ObjectMenu   := BoolValue('ObjectMenu',True);
    ThemeLoading := BoolValue('ThemeLoading',True);
    ObjectMove   := BoolValue('ObjectMove',True);
     ExitDesk    := BoolValue('ExitDesk',True);
  end;
  with XML.Root.Items.ItemNamed['Grid'].Items do
  begin
    Grid := BoolValue('UseGrid',True);
    GridX := IntValue('GridX',5);
    GridY := IntValue('GridY',5);
  end;
    XML.Options :=[sxoAutoIndent];
end;



end.
 