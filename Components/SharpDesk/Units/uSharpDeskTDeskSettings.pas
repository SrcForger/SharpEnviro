{
Source Name: uSharpDeskTDeskSettings.pas
Description: TDeskSettings class
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

unit uSharpDeskTDeskSettings;

interface

uses Graphics,
     Windows,
     Sysutils,
     JclSimpleXML,
     SharpApi;

type
    TDeskSettings = class
                     private
                       XML : TJclSimpleXML;
                     public
                       Owner               : TObject;
                       CheckObjectPosition : boolean;
                       DragAndDrop         : boolean;
                       AdvancedCommands    : boolean;
                       AdvancedMM          : boolean;
                       WallpaperWatch      : boolean;
                       ScreenRotAdjust     : boolean;
                       ScreenSizeAdjust    : boolean;
                       SingleClick         : boolean;
                       Grid                : boolean;
                       GridX               : integer;
                       GridY               : integer;
                       SetObjectRolledOut  : boolean;
                       MenuFile            : String;
                       MenuFileShift       : String;
                       UseExplorerDesk     : boolean;
                       constructor Create(pOwner : TObject);
                       destructor Destroy; override;
                       procedure SaveSettings;
                       procedure ReloadSettings;
                       procedure CreateXMLFile;
                    end;



implementation


constructor TDeskSettings.Create(pOwner : TObject);
begin
  inherited Create;

  Owner := pOwner;
  CheckObjectPosition := True;
  DragAndDrop         := True;
  AdvancedCommands    := True;
  AdvancedMM          := True;
  SingleClick         := False;
  Grid                := True;
  SetObjectRolledOut  := True;
  WallpaperWatch      := True;
  ScreenRotAdjust     := True;
  ScreenSizeAdjust    := True;
  GridX               := 8;
  GridY               := 8;
  MenuFile            := 'Menu';
  MenuFileShift       := 'QuickLaunch';
  UseExplorerDesk     := False;
  XML := TJclSimpleXML.Create;
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
  with XML.Root.Items.ItemNamed['Settings'].Items do
  begin
    Add('DragAndDrop',DragAndDrop);
    Add('AdvancedCommands',AdvancedCommands);
    Add('AdvancedMemoryManagement',AdvancedMM);
    Add('SingleClick',SingleClick);
    Add('CheckObjectPosition',CheckObjectPosition);
    Add('SetObjectRolledOut',SetObjectRolledOut);
    Add('WallpaperWatch',WallpaperWatch);
    Add('ScreenRotAdjust',ScreenRotAdjust);
    Add('ScreenSizeAdjust',ScreenSizeAdjust);
    Add('MenuFile',MenuFile);
    Add('MenuFileShift',MenuFileShift);
    Add('UseExplorerDesk',UseExplorerDesk);
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
    DragAndDrop         := BoolValue('DragAndDrop',True);
    AdvancedCommands    := BoolValue('AdvancedCommands',True);
    AdvancedMM          := BoolValue('AdvancedMemoryManagement',True);
    SingleClick         := BoolValue('SingleClick',False);
    CheckObjectPosition := ItemNamed['CheckObjectPosition'].BoolValue;
    SetObjectRolledOut  := BoolValue('SetObjectRolledOut',True);
    WallpaperWatch      := BoolValue('WallpaperWatch',True);
    ScreenRotAdjust     := BoolValue('ScreenRotAdjust',True);
    ScreenSizeAdjust    := BoolValue('ScreenSizeAdjust',True);
    MenuFile            := Value('MenuFile','Menu');
    MenuFileShift       := Value('MenuFileShift','QuickLaunch');
    UseExplorerDesk     := BoolValue('UseExplorerDesk',False);
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
 