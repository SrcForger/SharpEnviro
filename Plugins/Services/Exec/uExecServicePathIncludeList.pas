{Source Name: uExecServicePathIncludeList
Description: Path Inclusions List
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

unit uExecServicePathIncludeList;

interface
uses
  // Standard
  Classes,
  ContNrs,
  SysUtils,
  Forms,
  dialogs,
  windows,

  // JCL
  jclIniFiles,
  JclSysInfo,

  // JVCL
  JvSimpleXml;

type
  // "Private" Object, TPathIncludeList needs it...
  TPathIncludeItem = class(TObject)
  private
    FRemovePath: Boolean;
    FRemoveExtension: Boolean;
    FPath: string;
    FWildCard: string;
  public
    property Path: string read FPath write FPath;
    property WildCard: string read FWildCard write FWildCard;
    property RemoveExtension: Boolean read FRemoveExtension write
      FRemoveExtension;
    property RemovePath: Boolean read FRemovePath write FRemovePath;
  end;

  TPathIncludeList = class(TObject)
  private
    FOnAddItem: TNotifyEvent;
    FFileName: string;
    function GeTPathIncludeItem(Index: integer): TPathIncludeItem;
  public
    Items:TObjectList;
    constructor Create(FileName: string);
    destructor Destroy; override;

    function Add(Path, WildCard: string; RemoveExtension, RemovePath: Boolean):
      TPathIncludeItem;

    procedure Load; overload;
    procedure Save; overload;
    procedure Load(FileName: string); overload;
    procedure Save(FileName: string); overload;

    property Item[Index: integer]: TPathIncludeItem read GeTPathIncludeItem; default;

    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
    property FileName: string read FFileName write FFileName;

  end;

procedure Debug(Text: string; DebugType: Integer);

implementation

uses
  SharpApi;

{ TPathIncludeList }

procedure Debug(Text: string; DebugType: Integer);
begin
  SendDebugMessageEx('Exec Service', Pchar(Text), 0, DebugType);
end;

function TPathIncludeList.Add(Path, WildCard: string; RemoveExtension,
  RemovePath: Boolean): TPathIncludeItem;

begin
  Result := TPathIncludeItem.Create;
  Result.Path := Path;
  Result.WildCard := WildCard;
  Result.RemoveExtension := RemoveExtension;
  Result.RemovePath := RemovePath;
  Items.Add(Result);

  if Assigned(FOnAddItem) then
    FOnAddItem(Result);
end;

constructor TPathIncludeList.Create(FileName: string);
begin
  inherited Create;
  FFileName := FileName;
  Items := TObjectList.Create;

  if FileExists(FileName) then
    Load
  else begin
    Add(GetWindowsFolder, '*.exe', False, True);
    Add(GetWindowsSystemFolder, '*.exe', False, True);
    Add(ExtractFilePath(Application.exename), '*.exe', False, True);
    Save;
  end;
end;

destructor TPathIncludeList.Destroy;
begin
  Items.Free;
  inherited;
end;

function TPathIncludeList.GeTPathIncludeItem(Index: integer): TPathIncludeItem;
begin
  Result := (Items[Index] as TPathIncludeItem);
end;

procedure TPathIncludeList.Save(FileName: string);
var
  i: Integer;
  Xml: TjvSimpleXml;
begin
  DeleteFile(Pchar(FileName));
  Xml := TJvSimpleXml.Create(nil);

  try
    try
      Xml.Root.Name := 'PathInclude';
      xml.Root.Properties.Add('ItemCount', Items.Count);

      for i := 0 to Items.Count - 1 do begin
        Xml.Root.Items.Add(Format('PathInclude%d', [i]));
        Xml.Root.Items.Item[i].Items.Add('Path',
          Self[i].Path);
        Xml.Root.Items.Item[i].Items.Add('WildCard',
          Self[i].WildCard);
        Xml.Root.Items.Item[i].Items.Add('RemoveExtension',
          Self[i].RemoveExtension);
        Xml.Root.Items.Item[i].Items.Add('RemovePath',
          Self[i].RemovePath);
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

procedure TPathIncludeList.Save;
begin
  Save(FFileName);
end;

procedure TPathIncludeList.Load;
begin
  Load(FFileName);
end;

procedure TPathIncludeList.Load(FileName: string);
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

      if xml.Root.Name <> 'PathInclude' then begin
        sMsg := 'Invalid Path Inclusion File' + #13;
        Debug(sMsg, DMT_ERROR);

        sMsg := sMsg + Format('Expected "%s" found "%s"',['PathInclude',xml.Root.Name]);
        MessageDlg(sMsg, mtError, [mbOK], 0);

        exit;
      end;

      Itemcount := xml.Root.Properties.Item[0].IntValue;
      for Loop := 0 to itemcount - 1 do begin
        prop := 'PathInclude' + inttostr(loop);

        with xml.Root.Items do begin

          self.Add(
            ItemNamed['PathInclude' +
            inttostr(loop)].Items.Value('Path', ''),
              ItemNamed['PathInclude' +
            inttostr(loop)].Items.Value('WildCard', ''),
              ItemNamed['PathInclude' +
            inttostr(loop)].Items.BoolValue('RemoveExtension', false),
              ItemNamed['PathInclude' +
            inttostr(loop)].Items.BoolValue('RemovePath', false));
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





