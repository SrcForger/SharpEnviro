{
Source Name: uHotkeyServiceStore
Description: Hotkey Xml Storage Class
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

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

unit uHotkeyServiceList;
interface
uses

  // Standard
  Classes,
  ContNrs,
  SysUtils,
  dialogs,
  Forms,

  // JVCL
  JvSimpleXml;

type
  THotkeyItem = class(TObject)
  private
    FCommand: string;
    FHotkey: string;
    FIsAction: Boolean;
  public
    property Command: string read FCommand write FCommand;
    property Hotkey: string read Fhotkey write Fhotkey;
    property IsAction: Boolean read FIsAction write FIsAction;
  end;

  THotkeyList = class(TObject)
  private
    FItems: TObjectList;
    FFileName: string;
    function GetCount: integer;
    function GetInfo(Index: integer): THotkeyItem;
  public
    constructor Create(FileName: string);
    destructor Destroy; override;

    function Add(Hotkey, Command: string; IsAction: Boolean): THotkeyItem;
    procedure Delete(Index: integer); overload;
    procedure Delete(AItem:  THotkeyItem); overload;

    property Count: integer read GetCount;
    property Filename: string read FFileName write FFileName;

    property HotkeyItem[Index: integer]: THotkeyItem read GetInfo;
    property Items: TObjectList read FItems write FItems;

    procedure Load; overload;
    procedure Save; overload;
    procedure Load(XmlFile: string); overload;
    procedure Save(XmlFile: string); overload;

  end;

implementation

uses
  uHotkeyServiceGeneral,
  SharpApi;

{ THotkeyList }

function THotkeyList.Add(Hotkey, Command: string; IsAction: Boolean): THotkeyItem;
begin
  Result := THotkeyItem.Create;
  Result.Hotkey := Hotkey;
  Result.Command := Command;
  Result.IsAction := IsAction;
  FItems.Add(Result);
end;

constructor THotkeyList.Create(FileName: string);
begin
  FFileName := FileName;
  Debug('THotkeyList Constructor', DMT_INFO);

  // Create Object List
  FItems := TObjectList.Create;

  // Load Xml List
  if FileExists(FileName) then
    Load
  else
    Save;

  Inherited Create;
end;

procedure THotkeyList.Delete(Index: integer);
begin
  FItems.Delete(Index);
end;

destructor THotkeyList.Destroy;
begin
  FItems.Free;
  inherited;
end;

function THotkeyList.GetCount: integer;
begin
  Result := FItems.Count;
end;

function THotkeyList.GetInfo(Index: integer): THotkeyItem;
begin
  Result := (FItems[Index] as THotkeyItem);
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
  ItemCount, Loop: Integer;
  xml: TjvSimpleXml;
  prop: string;

begin
  Debug(Format('Loading File: %s',[XmlFile]), DMT_INFO);

  Xml := TJvSimpleXml.Create(Nil);

  try
    try
      xml.LoadFromFile(Xmlfile);

      Itemcount := xml.Root.Properties.Item[0].IntValue;
      for Loop := 0 to itemcount - 1 do begin
        prop := 'hotkey' + inttostr(loop);

        with xml.Root.Items do begin

          self.Add(
            ItemNamed['hotkey' + inttostr(loop)].Items.Value('Hotkey', ''),
            ItemNamed['hotkey' + inttostr(loop)].Items.Value('Command', ''),
            ItemNamed['hotkey' + inttostr(loop)].Items.BoolValue('IsAction', False)
            );
        end;
      end;
    except

      on E: Exception do begin
        Debug('Error While Loading Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);
      end;
    end;
  finally
    xml.Free;
  end;
end;

procedure THotkeyList.Save(XmlFile: string);
var
  Loop: Integer;
  xml: TjvSimpleXml;
begin
  Debug(Format('Saving File: %s',[XmlFile]), DMT_INFO);

  xml := TJvSimpleXml.Create(nil);
  try
    try
      xml.Root.Name := 'Hotkeys';
      xml.Root.Properties.Add('ItemCount', self.count);

      for loop := 0 to self.Count - 1 do begin
        xml.Root.Items.Add('Hotkey' + IntToStr(Loop));
        xml.Root.Items.Item[loop].Items.Add('Hotkey', Self.HotkeyItem[loop].Hotkey);
        xml.Root.Items.Item[loop].Items.Add('Command', Self.HotkeyItem[loop].Command);
        xml.Root.Items.Item[loop].Items.Add('IsAction', Self.HotkeyItem[loop].IsAction);
      end;

      forcedirectories(extractfilepath(xmlfile));
      xml.SaveToFile(Xmlfile);
    except
      on E: Exception do begin
        Debug('Error While Saving Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);
      end;
    end;

  finally
    xml.Free;
  end;
end;

procedure THotkeyList.Delete(AItem: THotkeyItem);
var
  n:Integer;
begin
  n := FItems.IndexOf(AItem);
  if n <> -1 then
    FItems.Delete(n);
end;

{ THotkeyItem }

end.




