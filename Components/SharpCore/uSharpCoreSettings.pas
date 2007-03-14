{
Source Name: uSharpCoreSettings
Description: A class to handle the loading and saving of settings
Copyright (C) Lee Green

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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
unit uSharpCoreSettings;

interface
uses
  windows,
  Classes,
  ContNrs,
  messages,
  SysUtils,
  JvSimpleXml,
  dialogs,
  graphics,
  Forms,
  uSharpCoreServiceMan,
  uSharpCoreServiceList,
  SharpApi;

type
  TCompSettings = class
  private
    FShellCheck: Boolean;
    FShowSplash: Boolean;
    FFileName: string;
  public
    constructor Create(Value: string);
    procedure New(filename: string); overload;

    procedure Load(filename: string); overload;
    procedure Save(filename: string); overload;
    procedure Load; overload;
    procedure Save; overload;
    procedure New; overload;

  published
    property FileName: string read FFileName write FFileName;
    property ShellCheck: boolean read FShellCheck write FShellCheck;
    property ShowSplash: boolean read FShowSplash write FShowSplash;

  end;

type
  TServiceSetting = class
  private
    fAuthor: string;
    fCopyright: string;
    fDescription: string;
    fServiceVer: string;
    fserviceType: TServiceType;
    frunatstart: string;
    FUserPath, FGlobalPath: string;
  public
    constructor Create(servicename: string);
    procedure LoadGlobal;
    procedure LoadUser;
    procedure SaveUser;
    procedure SaveGlobal;
  published
    property Author: string read fAuthor write fAuthor;
    property Description: string read fDescription write fDescription;
    property Copyright: string read fCopyright write fCopyright;
    property serviceVer: string read fservicever write fservicever;
    property serviceType: TServiceType read fserviceType write fServiceType;
    property RunAtStart: string read frunatstart write frunatstart;
  end;

var
  CompSettings: TCompSettings;

implementation

uses
  uSharpCoreHelperMethods;

constructor TCompSettings.Create(Value: string);
begin
  if Value <> '' then
    FFileName := Value;

  if FileExists(value) then
    Load
  else begin
    New;
    Load;
  end;
end;

procedure TCompSettings.Load(filename: string);
var
  xml: TjvSimpleXml;
begin
  // Create and load XML file
  xml := TJvSimpleXml.Create(application.MainForm);
  try
    DInfo('Loading Component Settings ' + filename);

    xml.LoadFromFile(filename);

    // Get the properties from the XML file
    with xml.Root.Items.ItemNamed['Main'].Items do begin
      FShellCheck := strtobool(Value('ShellCheck'));
      FShowSplash := strtobool(Value('ShowSplash'));
      DTrace(Format('Properties Loaded: ShellCheck:%s - ShowSplash:%s',
        [booltostr(FShellCheck), booltostr(FShowSplash)]));
    end;

    // Loaded Correctly
    DInfo('All Settings Loaded OK');
    xml.Free;
  except
    DError('Error loading component settings');
    if assigned(xml) then
      xml.Free;
    Exit;
  end;

end;

procedure TCompSettings.Load;
begin
  Load(FFileName);
end;

procedure TCompSettings.New(filename: string);
var
  xml: TjvSimpleXml;
begin
  xml := TJvSimpleXml.Create(application.MainForm);
  try
    // Delete file and set up XML
    DeleteFile(filename);
    ForceDirectories(ExtractFilePath(filename));

    xml.Root.Name := 'SharpCore';
    xml.Root.Properties.Add('Version', '0.5.0.0');

    // Add the properties to the root node
    xml.root.Items.Add('Main');
    with xml.Root.Items.ItemNamed['Main'].items do begin
      Add('ShellCheck', '-1');
      Add('ShowSplash', '-1');
    end;

    // Save and Free
    xml.SaveToFile(filename);
    xml.Free;
    DInfo('Settings file created');
  except
    DError('Error loading component settings');
    if assigned(xml) then
      xml.Free;
    Exit;
  end;
end;

procedure TCompSettings.New;
begin
  New(FFileName);
end;

procedure TCompSettings.Save;
begin
  Save(FFileName);
end;

procedure TCompSettings.Save(filename: string);
var
  xml: TjvSimpleXml;
begin
  xml := TJvSimpleXml.Create(application.MainForm);
  try

    // Delete file and set up XML
    DeleteFile(filename);

    xml.Root.Name := 'SharpCore';
    xml.Root.Properties.Add('Version', '0.5.0.0');

    // Add the properties to the root node
    xml.root.Items.Add('Main');
    with xml.Root.Items.ItemNamed['Main'].items do begin
      if CompSettings.FShellCheck then
        Add('ShellCheck', '-1')
      else
        Add('ShellCheck', '0');

      if CompSettings.FShowSplash then
        Add('ShowSplash', '-1')
      else
        Add('ShowSplash', '0');
    end;

    // Save and Free
    xml.SaveToFile(filename);
    xml.Free;
    DInfo('Settings file updated');
  except
    DError('Error updating settings');
    if assigned(xml) then
      xml.Free;
    Exit;
  end;
end;

constructor TServiceSetting.Create(servicename: string);
var
  tmp: string;
begin

  // Default Vals
  fAuthor := '';
  fCopyright := '';
  fDescription := '';
  fServiceVer := '';
  fserviceType := stAlways;

  // user
  FUserPath := GetSharpeUserSettingsPath + format('%s\%s\%s', ['SharpCore\Services', servicename,
    'uscf.xml']);
  if FileExists(FUserPath) then
    LoadUser
  else begin
    SaveUser;
    LoadUser;
  end;

  // global
  tmp := GetSharpeGlobalSettingsPath;
  FGlobalPath := tmp + format('%s\%s\%s', ['SharpCore\Services',
    servicename, 'gscf.xml']);
  if FileExists(FGlobalPath) then
    LoadGlobal
  else begin
    SaveGlobal;
    LoadGlobal;
  end;
end;

procedure TServiceSetting.LoadGlobal;
var
  xml: TjvSimpleXml;
begin

  xml := TJvSimpleXml.Create(application.MainForm);

  try
    xml.LoadFromFile(FGlobalPath);

    with xml.Root.Items.ItemNamed['serviceid'].Items do begin
      FAuthor := Value('Author');
      FCopyright := Value('Copyright');
      FDescription := Value('Description');
    end;
  finally
    xml.Free;
  end;
end;

procedure TServiceSetting.LoadUser;
var
  xml: TjvSimpleXml;
begin

  xml := TJvSimpleXml.Create(application.MainForm);

  try
    xml.LoadFromFile(FUserPath);

    {main configuration}
    with xml.Root.Items.ItemNamed['userspec'].Items do begin
      FServiceType := TServiceType(StrToInt(Value('ServiceType')));
    end;
  finally
    xml.Free;
  end;
end;

procedure TServiceSetting.SaveGlobal;
var
  xml: TjvSimpleXml;
begin

  DInfo('Creating Configuration: ' + FGlobalPath);
  DeleteFile(FGlobalPath);
  xml := TJvSimpleXml.Create(nil);

  try
    xml.Root.Name := 'SharpCore';

    xml.root.Items.Add('serviceid');
    with xml.Root.Items.ItemNamed['serviceid'].items do begin
      Add('Author', '');
      Add('Copyright', '');
      Add('Description', '');
      {Add('ServiceType', Integer(stAlways)); }
    end;

    ForceDirectories(ExtractFilePath(FGlobalPath));
    xml.SaveToFile(FGlobalPath);

  finally
    xml.Free;
  end;

end;

procedure TServiceSetting.SaveUser;
var
  xml: TjvSimpleXml;
begin

  DInfo('Creating Configuration: ' + FUserPath);
  DeleteFile(FUserPath);
  xml := TJvSimpleXml.Create(nil);

  try
    xml.Root.Name := 'SharpCore';

    xml.root.Items.Add('userspec');
    with xml.Root.Items.ItemNamed['userspec'].items do begin
      Add('ServiceType', Integer(stAlways));
    end;

    ForceDirectories(ExtractFilePath(FUserPath));
    xml.SaveToFile(FUserPath);

  finally
    xml.Free;
  end;

end;

end.

