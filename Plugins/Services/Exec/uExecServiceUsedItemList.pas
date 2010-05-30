{Source Name: uExecServiceRecentItemList
Description: Used Items List
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

unit uExecServiceUsedItemList;

interface

uses
  // Standard
  Classes,
  Graphics,
  ContNrs,
  SysUtils,
  math,
  dateutils,
  Windows,

  // JCL
  jclIniFiles,

  // JVCL
  JclSimpleXml,
  SharpApi,
  uSharpXMLUtils;

type
  // "Private" Object, TAliasList needs it...
  TUsedItemsItem = class(TObject)
  private
    FOpenCount: Integer;
    FLastUsed: TDateTime;
    FValue: string;
  public
    property Value: string read FValue write FValue;
    property LastUsed: TDateTime read FLastUsed write FLastUsed;
    property OpenCount: Integer read FOpenCount write FOpenCount;
  end;

  TUsedItemsList = class(TObject)
  private
    FFileName: string;

    function GeTUsedItemsItem(Index: integer): TUsedItemsItem;
    function Add(Value: string; LastUsed: TDateTime; Count: Integer): TUsedItemsItem;
      overload;

  public
    Items: TObjectList;
    constructor Create(FileName: string);
    destructor Destroy; override;

    function Add(Value: string): TUsedItemsItem; overload;
    procedure Load; overload;
    procedure Save; overload;
    procedure Load(FileName: string); overload;
    procedure Save(FileName: string); overload;

    property Item[Index: integer]: TUsedItemsItem read GeTUsedItemsItem; default;

    property FileName: string read FFileName write FFileName;
    procedure Sort;
  end;

var
  TmpMui: TUsedItemsList;

function CompareNames(Item1, Item2: Pointer): Integer;

implementation

{ TUsedItemsList }

{$WARNINGS OFF}
function TUsedItemsList.Add(Value: string): TUsedItemsItem;
var
  i: integer;

begin
  // Exclusions
  if (Pos('sharp', lowercase(ExtractFileName(Value))) <> 0) or (Value = '')  then
    exit;

  // First search if existing item already exists
  for i := 0 to Items.Count - 1 do begin
    if lowercase(Value) = lowercase(Self[i].Value) then begin
      Self[i].FLastUsed := now;
      Self[i].FOpenCount := Self[i].FOpenCount + 1;
      exit;
    end;
  end;

  Result := TUsedItemsItem.Create;
  Result.Value := lowercase(Value);
  Result.LastUsed := now;
  Result.OpenCount := 1;
  Items.Add(Result);

end;
{$WARNINGS ON}

function TUsedItemsList.Add(Value: string; LastUsed: TDateTime;
  Count: Integer): TUsedItemsItem;
begin
  Result := TUsedItemsItem.Create;
  Result.Value := Value;
  Result.LastUsed := LastUsed;
  Result.OpenCount := Count;
  Items.Add(Result);
end;

function CompareNames(Item1, Item2: Pointer): Integer;
begin
  if TUsedItemsItem(Item1).OpenCount = TUsedItemsItem(Item2).OpenCount then begin
    result := CompareDate(TUsedItemsItem(Item1).LastUsed, TUsedItemsItem(Item1).LastUsed);
  end
  else begin
    if TUsedItemsItem(Item1).OpenCount > TUsedItemsItem(Item2).OpenCount then
      result := -1
    else
      result := 1;

  end;
end;

constructor TUsedItemsList.Create(FileName: string);
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

destructor TUsedItemsList.Destroy;
begin
  Items.Free;
  inherited;
end;

function TUsedItemsList.GeTUsedItemsItem(Index: integer): TUsedItemsItem;
begin
  Result := (Items[Index] as TUsedItemsItem);
end;

procedure TUsedItemsList.Load;
begin
  Load(FFileName);
end;

procedure TUsedItemsList.Load(FileName: string);
var
  n: Integer;
  xml: TJclSimpleXml;

  Val: string;
  str: string;
  Last: TDateTime;
  Count: integer;
begin
  xml := TJclSimpleXml.Create;
  if LoadXMLFromSharedFile(Xml,FileName,true) then
  begin
    ShortDateFormat := 'dd/mm/yyyy';
    DateSeparator := '/';

    for n := 0 to xml.Root.Items.Count - 1 do
      with xml.Root.Items.item[n] do
      begin
        Val := Properties.Value('Value','');
        str := Properties.Value('LastUsed', '');
        Last := StrtoDateTime(str);
        Count := StrToInt(Properties.Value('Count', ''));

        self.Add(Val,
                 Last,
                 Count);
      end;
  end else SharpApi.SendDebugMessageEx('Exec Service',PChar('Error Loading Most Used Item List from ' + Filename), clred, DMT_ERROR);
  xml.Free;
end;

procedure TUsedItemsList.Save(FileName: string);
var
  i: Integer;
  Xml: TJclSimpleXml;
begin
  DeleteFile(pchar(FileName));
  Xml := TJclSimpleXml.Create;
  Xml.Root.Name := 'MUItemList';

  for i := 0 to Items.Count - 1 do
    with Xml.Root.Items.Add(Format('MUI%d', [i])) do
    begin
      Properties.Add('Value', Self[i].Value);
      Properties.Add('LastUsed', FormatDateTime('dd/mm/yyyy hh:nn:ss', Self[i].LastUsed));
      Properties.Add('Count', IntToStr(Self[i].OpenCount));
    end;

  if not SaveXMLToSharedFile(Xml,FileName,True) then
    SharpApi.SendDebugMessageEx('Exec Service',PChar('Error Saving Most Used Item List to ' + Filename), clred, DMT_ERROR);
  Xml.Free;
end;

procedure TUsedItemsList.Save;
begin
  Save(FFileName);
end;

procedure TUsedItemsList.Sort;
begin
  Items.Sort(@CompareNames);
end;

end.






