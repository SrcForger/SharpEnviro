{
Source Name: uPrismSettings
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
unit uPrismSettings;

interface
uses
  Classes,
  ContNrs,
  messages,
  SysUtils,
  JvSimpleXml,
  dialogs,
  graphics,
  Forms,
  SharpApi;

type
  TPrismSettings = class
  private
    FEnableMemOptim: Boolean;

    FFileName: string;
    FWndLeft: Integer;
    FWndTop: Integer;

    FMemLowThreshold: Integer;
    FMemEventInterval: Integer;

  public
    procedure Execute(FileName: string); overload;
    procedure Execute; overload;
    procedure Load(filename: string); overload;
    procedure Load; overload;
    procedure Save(filename: string); overload;
    procedure Save; overload;
    constructor Create(FileName: string);
  published
    // Mem optimiser
    property EnableMemOptim: Boolean read FEnableMemOptim write FEnableMemOptim;
    property MemEventInterval: Integer read FMemEventInterval Write FMemEventInterval;
    property MemLowThreshold: Integer read FMemLowThreshold Write FMemLowThreshold;

    // other properties
    property FileName: string read FFileName write FFileName;
    property WndLeft: Integer read FWndLeft write FWndLeft;
    property WndTop: Integer read FWndTop write FWndTop;
  end;

procedure Debug(Text: string; DebugType: Integer);

var
  PrismSettings: TPrismSettings;

implementation

procedure Debug(Text: string; DebugType: Integer);
begin
  SendDebugMessageEx('Prism Service', Pchar(Text), 0, DebugType);
end;

procedure TPrismSettings.Execute(FileName: string);
var
  tmp: string;
begin
  tmp := FileName;

  // Load or Create Settings File
  if FileExists(tmp) then
    Load(tmp)
  else begin
    ForceDirectories(ExtractFilePath(tmp));
    Save(tmp);
    Load(tmp);
  end;
end;

constructor TPrismSettings.Create(FileName: string);
begin
  FFileName := FileName;
  FEnableMemOptim := True;
  FMemLowThreshold := 15;
  FMemEventInterval := 30000;

  Execute(FileName);
end;

procedure TPrismSettings.Execute;
begin
  Execute(FFileName);
end;

procedure TPrismSettings.Load(filename: string);
var
  xml: TjvSimpleXml;
begin
  // Create and load XML file
  xml := TJvSimpleXml.Create(application.MainForm);
  try
    try
      Debug('Load Prism Settings ' + filename, DMT_INFO);
      xml.LoadFromFile(filename);

      // Get the properties from the XML file
      with xml.Root.Items.ItemNamed['Main'].Items do begin

        // Mem Optimiser
        FEnableMemOptim := BoolValue('EnableMemOptim', True);
        FMemEventInterval := IntValue('MemEventInterval',60000);
        FMemLowThreshold := IntValue('MemLowThreshold',15);

        // Other
        FWndLeft := IntValue('WndLeft', 0);
        FWndTop := IntValue('WndTop', 0);
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

procedure TPrismSettings.Save(filename: string);
var
  xml: TjvSimpleXml;
begin
  xml := TJvSimpleXml.Create(application.MainForm);
  try
    try

      // Delete file and set up XML
      Debug('Save Prism Settings ' + filename, DMT_INFO);
      xml.Root.Name := 'PrismService';

      // Add the properties to the root node
      xml.root.Items.Add('Main');
      with xml.Root.Items.ItemNamed['Main'].items do begin

        // Mem Optimiser
        Add('EnableMemOptim', FEnableMemOptim);
        Add('MemEventInterval',FMemEventInterval);
        Add('MemLowThreshold',FMemLowThreshold);

        // Other
        Add('WndLeft', FWndLeft);
        Add('WndTop', FWndTop);
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

procedure TPrismSettings.Save;
begin
  Save(FileName);
end;

procedure TPrismSettings.Load;
begin
  Load(Filename);
end;

end.

