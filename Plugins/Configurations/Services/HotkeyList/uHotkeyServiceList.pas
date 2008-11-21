{
Source Name: uHotkeyServiceStore
Description: Hotkey Xml Storage Class
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

unit uHotkeyServiceList;
interface
uses

  // Standard
  Classes,
  ContNrs,
  SysUtils,
  dialogs,
  Forms,
  IXmlBaseUnit,

  // JVCL
  JclSimpleXml;

type
  THotkeyItem = class(TObject)
  private
    FCommand: string;
    FHotkey: string;
    FName: string;
  public
    property Command: string read FCommand write FCommand;
    property Hotkey: string read Fhotkey write Fhotkey;
    property Name: string read FName write FName;
  end;

  THotkeyList = class(TInterfacedXmlBaseList)
  private
    FFileName: string;
    function GetItem(Index: integer): THotkeyItem;
  public
    constructor Create;

    function AddItem(Hotkey, Command, Name: String): THotkeyItem;
    procedure Delete(AItem:  THotkeyItem);
    function IndexOfName(AName: String):Integer;
    function IndexOfHotkey(AHotkey: String):Integer;
    function IndexOfHotkeyItem(AHotkeyItem: THotkeyItem):Integer;

    property Filename: string read FFileName write FFileName;

    property HotkeyItem[Index: integer]: THotkeyItem read GetItem;

    procedure Load; overload;
    procedure Save; overload;
    procedure Load(XmlFile: string); overload;
    procedure Save(XmlFile: string); overload;
    procedure Sort;

  end;

  function CustomSort(AItem1, AItem2:Pointer):Integer;

implementation

uses
  uHotkeyServiceGeneral,
  SharpApi;

{ THotkeyList }

function CustomSort(AItem1, AItem2:Pointer):Integer;
var
  tmp1,tmp2: THotkeyItem;
begin
  tmp1 := THotkeyItem(AItem1);
  tmp2 := THotkeyItem(AItem2);
  Result := CompareText(tmp1.Name,tmp2.Name);
end;

function THotkeyList.AddItem(Hotkey, Command, Name: String): THotkeyItem;
begin
  Result := THotkeyItem.Create;
  Result.Hotkey := Hotkey;
  Result.Command := Command;
  Result.Name := Name;
  Add(Result);
end;

constructor THotkeyList.Create;
begin
  Inherited Create;
end;

function THotkeyList.GetItem(Index: integer): THotkeyItem;
begin
  Result := nil;

  if ( ( Index >= 0 ) and ( Index < Self.Count )) then
    Result := THotkeyItem(Items[Index]);
end;

procedure THotkeyList.Load;
begin
  Load(FFileName);
end;

procedure THotkeyList.Save;
begin
  Save(FFileName);
end;

procedure THotkeyList.Load(XmlFile: string);
var
  i: Integer;
  nodes: TJclSimpleXMLElems;

begin
  Debug(Format('Loading File: %s',[XmlFile]), DMT_INFO);

  Xml.XmlFilename := XmlFile;
  if Xml.Load then begin
    for i := 0 to Pred(xml.XmlRoot.Items.Count) do begin
      nodes := Xml.XmlRoot.Items.Item[i].Items;

      Self.AddItem( nodes.Value('Hotkey'),nodes.Value('Command'),nodes.Value('Name'));

    end;
  end;
end;

procedure THotkeyList.Save(XmlFile: string);
var
  i: Integer;
  node: TJclSimpleXMLElemClassic;
begin

  Xml.XmlRoot.Clear;
  Xml.XmlRoot.Name := 'Hotkeys';
  with Xml.XmlRoot do begin

    for i := 0 to pred(self.Count) do begin

      node := Xml.XmlRoot.Items.Add('Hotkey');
      with node.Items do begin
        Add('Name', HotkeyItem[i].Name);
        Add('Hotkey', HotkeyItem[i].Hotkey);
        Add('Command', HotkeyItem[i].Command);
      end;
    end;

    Xml.Save;
  end;
end;

procedure THotkeyList.Delete(AItem: THotkeyItem);
var
  n:Integer;
begin
  n := IndexOf(AItem);
  if n <> -1 then
    TList(Self).Delete(n);
end;

procedure THotkeyList.Sort;
begin
  TList(self).Sort(CustomSort);
end;

function THotkeyList.IndexOfName(AName: String): Integer;
var
  tmp: THotkeyItem;
  i:Integer;
begin
  Result := -1;
  For i := 0 to Pred(Count) do begin
    tmp := THotkeyItem(Items[i]);
    if CompareText(tmp.Name,AName) = 0 then begin
      Result := i;
      break;
    end;
  end;
end;

function THotkeyList.IndexOfHotkey(AHotkey: String): Integer;
var
  tmp: THotkeyItem;
  i:Integer;
begin
  Result := -1;
  For i := 0 to Pred(Count) do begin
    tmp := THotkeyItem(Items[i]);
    if CompareText(tmp.Hotkey,AHotkey) = 0 then begin
      Result := i;
      break;
    end;
  end;
end;

function THotkeyList.IndexOfHotkeyItem(AHotkeyItem: THotkeyItem): Integer;
begin
  Result := IndexOf(AHotkeyItem);
end;

{ THotkeyItem }

end.




