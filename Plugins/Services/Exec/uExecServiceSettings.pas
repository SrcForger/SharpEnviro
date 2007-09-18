{Source Name: uExecServiceSettings
Description: Exec Settings Class
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

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

unit uExecServiceSettings;

interface
uses
  // Standard
  Classes,
  ContNrs,
  messages,
  SysUtils,
  dialogs,
  graphics,
  Forms,
  windows,

  // JVCL
  JvSimpleXml,

  // Common
  SharpApi;

type
  TExecSettings = class
  private
    FAltExplorer: string;
    FFileName: string;
  public
    procedure Execute(FileName: string); overload;
    procedure Execute; overload;
    procedure Load(filename: string); overload;
    procedure Load; overload;
    procedure New(filename: string);
    procedure Save(filename: string); overload;
    procedure Save; overload;
    constructor Create(FileName: string);
  published
    property AltExplorer: string read FAltExplorer write FAltExplorer;
    property FileName: string read FFileName write FFileName;
  end;

  procedure Debug(Text: string; DebugType: Integer);

implementation

procedure Debug(Text: string; DebugType: Integer);
begin
  SendDebugMessageEx('Exec Service', Pchar(Text), 0, DebugType);
end;

procedure TExecSettings.Execute(FileName: string);
var
  tmp: string;
begin
  tmp := FileName;

  // Load or Create Settings File
  if FileExists(tmp) then
    Load(tmp)
  else begin
    ForceDirectories(ExtractFilePath(tmp));
    New(tmp);
    Load(tmp);
  end;
end;

constructor TExecSettings.Create(FileName: string);
begin
  FFileName := FileName;
  Execute(FileName);
end;

procedure TExecSettings.Execute;
begin
  Execute(FFileName);
end;

procedure TExecSettings.Load(filename: string);
var
  xml: TjvSimpleXml;
begin
  // Create and load XML file
  xml := TJvSimpleXml.Create(nil);
  try
    try
      Debug('Load Exec Settings ' + filename, DMT_INFO);
      xml.LoadFromFile(filename);

      // Get the properties from the XML file
      with xml.Root.Items.ItemNamed['Main'].Items do begin
        FAltExplorer := Value('AltExplorer');
      end;

    except
      on E: Exception do begin
        Debug(Format('Error While Loading "%s"', [FileName]), DMT_ERROR);
        Debug(E.Message, DMT_TRACE);
      end;
    end;
  finally
    xml.Free;
  end;

end;

procedure TExecSettings.New(filename: string);
var
  xml: TjvSimpleXml;
begin
  xml := TJvSimpleXml.Create(nil);
  try
    try
      // Delete file and set up XML
      Debug('Create Exec Settings ' + filename, DMT_INFO);
      DeleteFile(pchar(filename));
      
      xml.Root.Name := 'ExecService';

      // Add the properties to the root node
      xml.root.Items.Add('Main');
      with xml.Root.Items.ItemNamed['Main'].items do begin
        Add('AltExplorer', '');
      end;

      // Save and Free
      xml.SaveToFile(filename);
    except
      on E: Exception do begin
        Debug('Error While Creating Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);
      end;
    end;
  finally
    xml.free;
  end;
end;

procedure TExecSettings.Save(filename: string);
var
  xml: TjvSimpleXml;
begin
  xml := TJvSimpleXml.Create(nil);
  try
    try

      // Delete file and set up XML
      Debug('Save Exec Settings ' + filename, DMT_INFO);
      DeleteFile(pchar(filename));

      xml.Root.Name := 'SharpCore';
      xml.Root.Properties.Add('Version', '0.5.0.0');

      // Add the properties to the root node
      xml.root.Items.Add('Main');
      with xml.Root.Items.ItemNamed['Main'].items do begin
        Add('AltExplorer', '-1');
      end;

      // Save and Free
      xml.SaveToFile(filename);

    except
      on E: Exception do begin
        Debug('Error While Saving Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);
      end;
    end;
  finally
    xml.free;
  end;
end;

procedure TExecSettings.Save;
begin
  Save(FileName);
end;

procedure TExecSettings.Load;
begin
  Load(Filename);
end;

end.

