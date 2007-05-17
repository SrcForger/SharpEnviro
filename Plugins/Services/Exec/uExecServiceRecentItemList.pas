{Source Name: uExecServiceRecentItemList
Description: Recent Items List
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

unit uExecServiceRecentItemList;

interface

uses
  // Standard
  Classes,
  ContNrs,
  SysUtils,
  windows,

  // JCL
  jclIniFiles,

  // JVCL
  JvSimpleXml;

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

procedure Debug(Text: string; DebugType: Integer);

implementation

{uses
  SharpApi;}

const
  RecentItemCount = 50;

procedure Debug(Text: string; DebugType: Integer);
begin
  //SendDebugMessageEx('Exec Service', Pchar(Text), 0, DebugType);
end;

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
  ItemCount, Loop: Integer;
  xml: TjvSimpleXml;
  prop: string;
  sMsg: String;
begin

  xml := TJvSimpleXml.Create(nil);

  try
    try
      xml.LoadFromFile(FileName);

      if xml.Root.Name <> 'RecentItemList' then begin
        sMsg := 'Invalid RecentItemList File' + #13;
        //Debug(sMsg, DMT_ERROR);

//        sMsg := sMsg + Format('Expected "%s" found "%s"',['RecentItemList',xml.Root.Name]);
//        MessageDlg(sMsg, mtError, [mbOK], 0);

        // Save empty and reload
        exit;
      end;

      Itemcount := xml.Root.Properties.Item[0].IntValue;
      for Loop := 0 to itemcount - 1 do begin
        prop := 'RI' + inttostr(loop);

        with xml.Root.Items do begin

          self.Add(
            ItemNamed['RI' + inttostr(loop)].Items.Value('Value', ''));
        end;
      end;
    except

      on E: Exception do begin
        //Debug('Error While Loading Xml File', DMT_ERROR);
        //Debug(E.Message, DMT_TRACE);

        // Create New
        Save;
      end;
    end;
  finally
    xml.Free;
  end;
end;

procedure TRecentItemsList.Save(FileName: string);
var
  i: Integer;
  Xml: TjvSimpleXml;
begin
  DeleteFile(pchar(FileName));
  Xml := TJvSimpleXml.Create(nil);

  try
    try
      Xml.Root.Name := 'RecentItemList';
      xml.Root.Properties.Add('ItemCount', Items.count);

      for i := 0 to Items.Count - 1 do begin
        Xml.Root.Items.Add(Format('RI%d', [i]));
        Xml.Root.Items.Item[i].Items.Add('Value', Self[i].Value);
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

procedure TRecentItemsList.Save;
begin
  Save(FFileName);
end;

end.





