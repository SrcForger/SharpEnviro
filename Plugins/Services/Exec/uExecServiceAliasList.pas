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

  // JCL
  jclIniFiles,
  // JVCL
  JvSimpleXml;

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

  TAliasList = class(TObject)
  private
    FOnAddItem: TNotifyEvent;
    FFileName: string;
    function GeTAliasListItem(Index: integer): TAliasListItem;
    function GetCount: Integer;
  public
    FItems: TObjectList;
    constructor Create(FileName: string);
    destructor Destroy; override;

    function Add(AliasName, AliasValue: string; AElevate:Boolean=False): TAliasListItem;

    procedure Load; overload;
    procedure Save; overload;
    procedure Load(FileName: string); overload;
    procedure Save(FileName: string); overload;
    function Delete(AItem: TAliasListItem):Boolean; overload;
    
    procedure Sort;

    property Count: Integer read GetCount;
    property Item[Index: integer]: TAliasListItem read GeTAliasListItem; default;

    property Items: TObjectList read FItems write FItems;
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

function TAliasList.Add(AliasName, AliasValue: string;
  AElevate:Boolean=False): TAliasListItem;
begin
  Result := TAliasListItem.Create;
  Result.AliasName := AliasName;
  Result.AliasValue := AliasValue;
  Result.Elevate := AElevate;
  FItems.Add(Result);

  if Assigned(FOnAddItem) then
    FOnAddItem(Result);
end;

constructor TAliasList.Create(FileName: string);
begin
  inherited Create;
  FFileName := FileName;
  FItems := TObjectList.Create;

  if FileExists(FileName) then
    Load
  else begin
    Add('Notepad', 'Notepad.exe');
    Save;
  end;
end;

function TAliasList.Delete(AItem: TAliasListItem): Boolean;
var
  i:Integer;
begin
  Result := False;

  i := FItems.IndexOf(AItem);
  if i <> -1 then begin
    FItems.Delete(i);
    Result := True;
  end;

end;

destructor TAliasList.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TAliasList.GeTAliasListItem(Index: integer): TAliasListItem;
begin
  Result := (FItems[Index] as TAliasListItem);
end;

function TAliasList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TAliasList.IndexOfName(AName: String): Integer;
var
  tmp: TAliasListItem;
  i:Integer;
begin
  Result := -1;
  For i := 0 to Pred(FItems.Count) do begin
    tmp := TAliasListItem(FItems[i]);
    if CompareText(tmp.AliasName,AName) = 0 then begin
      Result := i;
      break;
    end;
  end;
end;

procedure TAliasList.Save(FileName: string);
var
  i: Integer;
  Xml: TjvSimpleXml;
begin
  DeleteFile(pchar(FileName));
  Xml := TJvSimpleXml.Create(nil);

  try
    try
      Xml.Root.Name := 'Aliases';
      xml.Root.Properties.Add('ItemCount', FItems.count);

      for i := 0 to FItems.Count - 1 do begin
        Xml.Root.Items.Add(Format('Alias%d', [i]));
        Xml.Root.Items.Item[i].Items.Add('AliasName', Self[i].AliasName);
        Xml.Root.Items.Item[i].Items.Add('AliasValue', Self[i].AliasValue);
        Xml.Root.Items.Item[i].Items.Add('Elevate', Self[i].Elevate);
      end;

      Xml.SaveToFile(FileName);
    except
      on E: Exception do begin
        Debug('Error While Saving Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);
      end;
    end;

  finally
    Xml.Free;
  end;
end;

procedure TAliasList.Sort;
begin
  FItems.Sort(CustomSort);
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
  ItemCount, Loop: Integer;
  xml: TjvSimpleXml;
  prop: string;
  sMsg: String;
begin

  xml := TJvSimpleXml.Create(nil);

  try
    try
      xml.LoadFromFile(FileName);

      if xml.Root.Name <> 'Aliases' then begin
        sMsg := 'Invalid Aliases File' + #13;
        Debug(sMsg, DMT_ERROR);

        sMsg := sMsg + Format('Expected "%s" found "%s"',['Aliases',xml.Root.Name]);
        MessageDlg(sMsg, mtError, [mbOK], 0);

        // Save empty and reload
        exit;
      end;

      Itemcount := xml.Root.Properties.Item[0].IntValue;
      for Loop := 0 to itemcount - 1 do begin
        prop := 'Alias' + inttostr(loop);

        with xml.Root.Items do begin

          if ItemNamed[prop] <> nil then
            self.Add(
              ItemNamed[prop].Items.Value('AliasName', ''),
              ItemNamed[prop].Items.Value('AliasValue', ''),
              ItemNamed[prop].Items.BoolValue('Elevate', False) );
        end;
      end;
    except

      on E: Exception do begin
        Debug('Error While Loading Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);

        Save;
      end;
    end;
  finally
    xml.Free;
  end;
end;

end.






