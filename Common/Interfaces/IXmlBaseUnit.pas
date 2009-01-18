{
Source Name: IXmlBaseUnit
Description: Interface for base xml accessing
Copyright (C) Lee Green ( lee@sharpenviro.com )

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

unit IXmlBaseUnit;

interface

uses
  Windows, Graphics, SysUtils, SharpApi, Controls, Forms, Classes, JclSimpleXml;

const
  IID_IXmlBase: TGUID = '{2A6E32B6-9DAA-400B-B464-A8EE353BE247}';

type
  IXmlBase = interface(IInterface)
  ['{2A6E32B6-9DAA-400B-B464-A8EE353BE247}']

  function GetXmlFilename : string; stdcall;
  procedure SetXmlFilename(value : string); stdcall;
  property XmlFilename : string read GetXmlFilename write SetXmlFilename;

  function GetXmlRoot : TJclSimpleXMLElemClassic; stdCall;
  procedure SetXmlRoot( value: TJclSimpleXMLElemClassic ); stdCall;
  property XmlRoot: TJclSimpleXMLElemClassic read GetXmlRoot write SetXmlRoot;

  function Load: boolean; stdCall;
  function Save: boolean; stdCall;
end;

type
  TInterfacedXmlBase = class(TInterfacedObject,IXmlBase)
  private
    FXmlFileName: String;
    FXml: TJclSimpleXML;
    FXmlRoot: TJclSimpleXMLElemClassic;
    function GetXmlFilename: string; stdcall;
    procedure SetXmlFilename(value: string); stdcall;
    function GetXmlRoot: TJclSimpleXMLElemClassic; stdCall;
    procedure SetXmlRoot(value: TJclSimpleXMLElemClassic); stdcall;
    procedure Debug( msg: string; msgType: integer ); overload;
    procedure Debug( msg: string ); overload;

    function LoadFile( fileName: String ): boolean;
    function FileValidPrecheck(fileName:string): boolean;
  public
    constructor Create(); reintroduce;
    destructor Destroy; override;
    function Load: boolean; stdcall;
    function Save: boolean; stdcall;
    property XmlFilename: string read GetXmlFilename write SetXmlFilename;
    property XmlRoot: TJclSimpleXMLElemClassic read GetXmlRoot;

end;

type
  TInterfacedXmlBaseList = class( TList )
  private
    FXml: TInterfacedXmlBase;
  public
    destructor Destroy; override;
    property Xml: TInterfacedXmlBase read FXml;
    constructor Create; reintroduce;

end;

implementation

{ TInterfacedXmlBase }

constructor TInterfacedXmlBase.Create;
begin
  inherited Create;
  
  FXml := TJclSimpleXML.Create;
end;

procedure TInterfacedXmlBase.Debug(msg: string; msgType: integer);
begin
  SharpApi.SendDebugMessageEx( 'XmlBase', pchar(msg), clBlack, msgType );
end;

procedure TInterfacedXmlBase.Debug(msg: string );
begin
  SharpApi.SendDebugMessageEx( 'XmlBase', pchar(msg), clBlack, DMT_INFO );
end;

destructor TInterfacedXmlBase.Destroy;
begin
  FXml.Free;

  inherited;
end;

function TInterfacedXmlBase.GetXmlFilename: string;
begin
  result := FXmlFileName;
end;

function TInterfacedXmlBase.GetXmlRoot: TJclSimpleXMLElemClassic;
begin
  result := nil;

  if FXml.Root <> nil then
    Result := FXml.Root;
end;

function TInterfacedXmlBase.Load : boolean;
var
  backupFile: string;
begin
  result := true;

  // Check for null xml
  if FXml = nil then begin
    FXml := TJclSimpleXML.Create;
  end else
    FXml.Root.Clear;

  if not (FileValidPrecheck(FXmlFileName)) then begin
    result := false;
    exit;
  end;

  if LoadFile(FXmlFileName) then begin
    FXmlRoot := FXml.Root;
  end
  else
  begin

    // Try loading an earlier backup
    backupFile := ExtractFilePath(FXmlFileName) + ExtractFileName(FXmlFileName)+'_bak';

    if not(fileExists(backupFile)) then begin

      Debug('Unable to find any backups for this file. Reverting file to defaults.',DMT_INFO);
      result := false;

    end else begin

      // We have daily backups! Let's try to restore one of them. For now one backup is saved.
      // More days could be added later

        if not(LoadFile(backupFile)) then begin
          Debug('Unable to load the backup. Reverting file to defaults.',DMT_INFO);
          DeleteFile(backupFile);
          result := false;
        end else begin
          Debug('Successfully loaded the backup file.',DMT_INFO);
          FXmlRoot := FXml.Root;

          // Delete the old file as it is invalid
          if not(DeleteFile(FXmlFileName)) then begin
            Debug('Unable to delete the old file, maybe you don''t have access rights?',DMT_ERROR);
            result := false;
            exit;
          end;

          // Save the backup file into it
          FXml.SaveToFile(FXmlFileName);
        end;

      end;

    end;
end;

function TInterfacedXmlBase.LoadFile(fileName: String): boolean;
begin
  Result := true;

  if not (FileValidPrecheck(fileName)) then begin
    result := false;
    exit;
  end;

  Try
    FXml.LoadFromFile(fileName);

    // Check for empty file, as sometimes the file can get wiped.
    if Length(FXml.Root.SaveToString()) = 0 then
      result := false;
  Except
    on E: Exception do begin
      Debug(format('Error loading file: %s',[fileName]),DMT_ERROR);
      Debug(E.Message, DMT_TRACE);
      result := false;
    end;
  end;
end;

function TInterfacedXmlBase.Save : boolean;
var
  backupFile:string;
begin
  Result := true;

  try
    if not DirectoryExists(ExtractFilePath(FXmlFileName)) then
      ForceDirectories(ExtractFilePath(FXmlFileName));

    FXml.SaveToFile(FXmlFileName);
  except
    on E: Exception do begin
      Debug(format('Error saving file: %s',[FXmlFileName]),DMT_ERROR);
      Debug(E.Message, DMT_TRACE);
      Result := false;
      Exit;
    end;
  end;

  backupFile := ExtractFilePath(FXmlFileName) + ExtractFileName(FXmlFileName)+'_bak';
  DeleteFile(backupFile);
  FXml.SaveToFile(backupFile);
end;

function TInterfacedXmlBase.FileValidPrecheck(fileName:string): boolean;
begin
  result := true;

  if (fileName = '') then
  begin
    Debug('The filename has not been set, unable to load file.');
    result := false;
  end;
  if (not (fileExists(fileName))) then
  begin
    Debug(Format('The filename: %s was not found.', [fileName]));
    result := false;
  end;
end;

procedure TInterfacedXmlBase.SetXmlFilename(value: string);
begin
  FXmlFileName := value;
end;

procedure TInterfacedXmlBase.SetXmlRoot(value: TJclSimpleXMLElemClassic);
begin
  FXmlRoot := value;
end;

{ IInterfacedXmlBaseList }

constructor TInterfacedXmlBaseList.Create;
begin
  inherited Create;
  FXml := TInterfacedXmlBase.Create;
end;

destructor TInterfacedXmlBaseList.Destroy;
begin
  FXml := nil;
  inherited;
end;

end.

