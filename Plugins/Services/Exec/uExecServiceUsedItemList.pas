{Source Name: uExecServiceRecentItemList
Description: Used Items List
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 6
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

unit uExecServiceUsedItemList;

interface

uses
  // Standard
  Classes,
  ContNrs,
  SysUtils,
  math,
  dateutils,
  Windows,

  // JCL
  jclIniFiles,

  // JVCL
  JvSimpleXml;

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

procedure Debug(Text: string; DebugType: Integer);
function CompareNames(Item1, Item2: Pointer): Integer;

implementation

{uses
  SharpApi;}

procedure Debug(Text: string; DebugType: Integer);
begin
  //SendDebugMessageEx('Exec Service', Pchar(Text), 0, DebugType);
end;
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
  ItemCount, Loop: Integer;
  xml: TjvSimpleXml;
  prop: string;
  sMsg: String;
begin

  xml := TJvSimpleXml.Create(nil);

  try
    try
      xml.LoadFromFile(FileName);

      if xml.Root.Name <> 'MUItemList' then begin
        sMsg := 'Invalid MUItemList File' + #13;
        //Debug(sMsg, DMT_ERROR);

        //sMsg := sMsg + Format('Expected "%s" found "%s"',['MUItemList',xml.Root.Name]);
        //MessageDlg(sMsg, mtError, [mbOK], 0);

        // Save empty and reload
        exit;
      end;

      Itemcount := xml.Root.Properties.Item[0].IntValue;
      for Loop := 0 to itemcount - 1 do begin
        prop := 'MUI' + inttostr(loop);

        with xml.Root.Items do begin

          self.Add(ItemNamed['MUI' + inttostr(loop)].Properties.Value('Value',
            ''),
            StrtoDateTime(ItemNamed['MUI' +
            inttostr(loop)].Properties.Value('LastUsed', '')),
              StrToInt(ItemNamed['MUI' +
            inttostr(loop)].Properties.Value('Count', '')
              ));
        end;
      end;
    except

      on E: Exception do begin
        //Debug('Error While Loading Xml File', DMT_ERROR);
        //Debug(E.Message, DMT_TRACE);

        // Create new file
        Save;
      end;
    end;
  finally
    xml.Free;
  end;
end;

procedure TUsedItemsList.Save(FileName: string);
var
  i: Integer;
  Xml: TjvSimpleXml;
begin
  DeleteFile(pchar(FileName));
  Xml := TJvSimpleXml.Create(nil);

  try
    try
      Xml.Root.Name := 'MUItemList';
      xml.Root.Properties.Add('ItemCount', Items.count);

      for i := 0 to Items.Count - 1 do begin
        Xml.Root.Items.Add(Format('MUI%d', [i]));
        Xml.Root.Items.Item[i].Properties.Add('Value', Self[i].Value);
        Xml.Root.Items.Item[i].Properties.Add('LastUsed',
          FormatDateTime('dd/mm/yyyy hh:nn:ss', Self[i].LastUsed));
        Xml.Root.Items.Item[i].Properties.Add('Count',
          IntToStr(Self[i].OpenCount));
      end;

      Xml.SaveToFile(FileName);
    except
      on E: Exception do begin
        //Debug('Error While Saving Xml File', DMT_ERROR);
        //Debug(E.Message, DMT_TRACE);
      end;
    end;

  finally
    Xml.Free;
  end;
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






