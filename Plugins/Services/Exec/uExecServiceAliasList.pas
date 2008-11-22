{Source Name: uExecServiceAliasList
Description: Exec Service Alias List List
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

unit uExecServiceAliasList;

interface
uses
  // Standard
  Classes,
  ContNrs,
  SysUtils,
  dialogs,
  windows,

  JclSimpleXml, IXmlBaseUnit;

type
  // "Private" Object, TAliasList needs it...
  TAliasListItem = class(TObject)
  private
    FAliasName: string;
    FAliasValue: string;
    FElevate: boolean;
  public
    property AliasName: string read FAliasName write FAliasName;
    property AliasValue: string read FAliasValue write FAliasValue;
    property Elevate: boolean read FElevate write FElevate;
  end;

  TAliasList = class(TInterfacedXmlBaseList)
  private
    FOnAddItem: TNotifyEvent;
    FFileName: string;
    function GetItem(Index: integer): TAliasListItem;
  public

    function AddItem(AliasName, AliasValue: string; AElevate:Boolean=False): TAliasListItem;

    procedure Load; overload;
    procedure Save; overload;
    procedure Load(FileName: string); overload;
    procedure Save(FileName: string); overload;
    function Delete(AItem: TAliasListItem):Boolean; overload;

    procedure Sort;
    property AliasItem[Index: integer]: TAliasListItem read GetItem; default;

    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
    property FileName: string read FFileName write FFileName;
    function IndexOfName(AName: String):Integer;
  end;

procedure Debug(Text: string; DebugType: Integer);
function CustomSort(AItem1, AItem2:Pointer):Integer;

implementation

uses
  SharpApi;

{ TAliasList }

function CustomSort(AItem1, AItem2:Pointer):Integer;
var
  tmp1,tmp2: TAliasListItem;
begin
  tmp1 := TAliasListItem(AItem1);
  tmp2 := TAliasListItem(AItem2);
  Result := CompareText(tmp1.AliasName,tmp2.AliasName);
end;

procedure Debug(Text: string; DebugType: Integer);
begin
  SendDebugMessageEx('Exec Service', Pchar(Text), 0, DebugType);
end;

function TAliasList.AddItem(AliasName, AliasValue: string;
  AElevate:Boolean=False): TAliasListItem;
begin
  Result := TAliasListItem.Create;
  Result.AliasName := AliasName;
  Result.AliasValue := AliasValue;
  Result.Elevate := AElevate;
  Add(Result);

  if Assigned(FOnAddItem) then
    FOnAddItem(Result);
end;

function TAliasList.Delete(AItem: TAliasListItem): Boolean;
var
  i:Integer;
begin
  Result := False;

  i := IndexOf(AItem);
  if i <> -1 then begin
    Delete(i);
    Result := True;
  end;

end;

function TAliasList.GetItem(Index: integer): TAliasListItem;
begin
  result := nil;
  
  if ((Index < Count) and (Index >= 0)) then
    Result := TAliasListItem(Items[index]);
end;

function TAliasList.IndexOfName(AName: String): Integer;
var
  tmp: TAliasListItem;
  i:Integer;
begin
  Result := -1;
  For i := 0 to Pred(Count) do begin
    tmp := TAliasListItem(Items[i]);
    if CompareText(tmp.AliasName,AName) = 0 then begin
      Result := i;
      break;
    end;
  end;
end;

procedure TAliasList.Save(FileName: string);
var
  i: Integer;
  node: TJclSimpleXMLElemClassic;
begin

  Xml.XmlRoot.Clear;
  Xml.XmlRoot.Name := 'Aliases';
  with Xml.XmlRoot do begin

    for i := 0 to pred(self.Count) do begin

      node := Xml.XmlRoot.Items.Add('Alias');
      with node.Items do begin
        Add('AliasName', AliasItem[i].AliasName);
        Add('AliasValue', AliasItem[i].AliasValue);
        Add('Elevate', AliasItem[i].Elevate);
      end;
    end;

    Xml.Save;
  end;
end;

procedure TAliasList.Sort;
begin
  TList(Self).Sort(CustomSort);
end;

procedure TAliasList.Save;
begin
  Save(FFileName);
end;

procedure TAliasList.Load;
begin
  Load(FFileName);
end;

procedure TAliasList.Load(FileName: string);
var
  i: Integer;
  nodes: TJclSimpleXMLElems;
begin
  Xml.XmlFilename := FileName;
  if Xml.Load then begin
    for i := 0 to Pred(xml.XmlRoot.Items.Count) do begin
      nodes := Xml.XmlRoot.Items.Item[i].Items;

      Self.AddItem( nodes.Value('AliasName'),nodes.Value('AliasValue'),nodes.BoolValue('Elevate'));

    end;
  end;
end;

end.






