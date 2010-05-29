{Source Name: uExecServiceRecentItemList
Description: Recent Items List
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

unit uExecServiceRecentItemList;

interface

uses
  // Standard
  Classes,
  Graphics,
  ContNrs,
  SysUtils,
  windows,

  // JCL
  jclIniFiles,

  // JVCL
  JclSimpleXml,

  // SharpE
  uSharpXMLUtils,
  SharpApi;

type
  // "Private" Object, TAliasList needs it...
  TRecentItemsItem = class(TObject)
  private
    FValue: string;
  public
    property Value: string read FValue write FValue;
  end;

  TRecentItemsList = class(TObject)
  private
    FFileName: string;
    function GeTRecentItemsItem(Index: integer): TRecentItemsItem;
  public
    Items: TObjectList;
    constructor Create(FileName: string);
    destructor Destroy; override;

    function Add(Value: string): TRecentItemsItem;

    procedure Load; overload;
    procedure Save; overload;
    procedure Load(FileName: string); overload;
    procedure Save(FileName: string); overload;

    property Item[Index: integer]: TRecentItemsItem read GeTRecentItemsItem; default;
    property FileName: string read FFileName write FFileName;
  end;

var
  TmpRI: TRecentItemsList;


implementation

{uses
  SharpApi;}

const
  RecentItemCount = 50;

{$WARNINGS OFF}
function TRecentItemsList.Add(Value: string): TRecentItemsItem;
var
  i: integer;
begin
  // Exclusions
  if (Pos('sharp', lowercase(value)) <> 0) or (Value = '') then
    exit;

  // Search for existing item
  for i := 0 to Items.Count - 1 do begin
    if lowercase(Self[i].Value) = lowercase(Value) then begin
      Items.Delete(i);
      Break;
    end;
  end;

  Result := TRecentItemsItem.Create;
  Result.Value := Lowercase(Value);
  Items.Add(Result);

  if Items.Count > 50 then
    Items.Delete(0);

end;
{$WARNINGS ON}

constructor TRecentItemsList.Create(FileName: string);
begin
  inherited Create;
  FFileName := FileName;
  Items := TObjectList.Create;

  if FileExists(FileName) then
    Load
  else begin
    Save;
  end;
end;

destructor TRecentItemsList.Destroy;
begin
  Items.Free;
  inherited;
end;

function TRecentItemsList.GeTRecentItemsItem(Index: integer): TRecentItemsItem;
begin
  Result := (Items[Index] as TRecentItemsItem);
end;

procedure TRecentItemsList.Load;
begin
  Load(FFileName);
end;

procedure TRecentItemsList.Load(FileName: string);
var
  n: Integer;
  xml: TJclSimpleXml;
begin
  xml := TJclSimpleXml.Create;
  if LoadXMLFromSharedFile(xml,filename,true) then
  begin
    for n := 0 to xml.root.items.count - 1 do
      self.Add(xml.root.Items.item[n].Value);
  end else SharpApi.SendDebugMessageEx('Exec Service',PChar('Error Loading Recent Item List from ' + Filename), clred, DMT_ERROR);
  xml.Free;
end;

procedure TRecentItemsList.Save(FileName: string);
var
  i: Integer;
  Xml: TJclSimpleXml;
begin
  Xml := TJclSimpleXml.Create;
  Xml.Root.Name := 'RecentItemList';

  for i := 0 to Items.Count - 1 do
    Xml.Root.Items.Add('RecentItem',Self[i].Value);

  if not SaveXMLToSharedFile(Xml,Filename,True) then
    SharpApi.SendDebugMessageEx('Exec Service',PChar('Error Saving Recent Item List to ' + Filename), clred, DMT_ERROR);

  Xml.Free;
end;

procedure TRecentItemsList.Save;
begin
  Save(FFileName);
end;

end.





