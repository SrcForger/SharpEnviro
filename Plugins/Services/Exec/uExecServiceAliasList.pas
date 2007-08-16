{Source Name: uExecServiceAliasList
Description: Exec Service Alias List List
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

unit uExecServiceAliasList;

interface
uses
  // Standard
  Classes,
  ContNrs,
  SysUtils,
  dialogs,
  Forms,
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
  public
    Items: TObjectList;
    constructor Create(FileName: string);
    destructor Destroy; override;

    function Add(AliasName, AliasValue: string; AElevate:Boolean=False): TAliasListItem;

    procedure Load; overload;
    procedure Save; overload;
    procedure Load(FileName: string); overload;
    procedure Save(FileName: string); overload;

    property Item[Index: integer]: TAliasListItem read GeTAliasListItem; default;

    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
    property FileName: string read FFileName write FFileName;
  end;

procedure Debug(Text: string; DebugType: Integer);

implementation

uses
  SharpApi;

{ TAliasList }

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
  Items.Add(Result);

  if Assigned(FOnAddItem) then
    FOnAddItem(Result);
end;

constructor TAliasList.Create(FileName: string);
begin
  inherited Create;
  FFileName := FileName;
  Items := TObjectList.Create;

  if FileExists(FileName) then
    Load
  else begin
    Add('Notepad', 'Notepad.exe');
    Save;
  end;
end;

destructor TAliasList.Destroy;
begin
  Items.Free;
  inherited;
end;

function TAliasList.GeTAliasListItem(Index: integer): TAliasListItem;
begin
  Result := (Items[Index] as TAliasListItem);
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
      xml.Root.Properties.Add('ItemCount', Items.count);

      for i := 0 to Items.Count - 1 do begin
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






