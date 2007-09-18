{Source Name: uExecServicePathIncludeList
Description: Path Inclusions List
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

  TPathIncludeItem = class(TObject)
  private
    FRemovePath: Boolean;
    FRemoveExtension: Boolean;
    FPath: string;
    FWildCard: string;
    FInternal: Boolean;
  public
    property Path: string read FPath write FPath;
    property WildCard: string read FWildCard write FWildCard;
    property RemoveExtension: Boolean read FRemoveExtension write
      FRemoveExtension;
    property RemovePath: Boolean read FRemovePath write FRemovePath;
    property Internal: Boolean read FInternal write FInternal;
  end;

  TPathIncludeList = class(TObject)
  private
    FOnAddItem: TNotifyEvent;
    FFileName: string;
    function GetPathIncludeItem(AIndex: integer): TPathIncludeItem;
    procedure AddInternals;
  public
    FItems: TObjectList;

    constructor Create(AFileName: string);
    destructor Destroy; override;

    function Add(APath, AWildCard: string; ARemoveExtension, ARemovePath:
      Boolean;
      AInternal: Boolean = False): TPathIncludeItem;

    procedure Load; overload;
    procedure Save; overload;
    procedure Load(AFileName: string); overload;
    procedure Save(AFileName: string); overload;

    property Items: TObjectList read FItems write FItems;
    property Item[AIndex: integer]: TPathIncludeItem read GetPathIncludeItem;
    default;

    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
    property FileName: string read FFileName write FFileName;

  end;

procedure Debug(AText: string; ADebugType: Integer);

implementation

uses
  SharpApi;

{ TPathIncludeList }

procedure Debug(AText: string; ADebugType: Integer);
begin
  SendDebugMessageEx('Exec Service', Pchar(AText), 0, ADebugType);
end;

function TPathIncludeList.Add(APath, AWildCard: string; ARemoveExtension,
  ARemovePath: Boolean; AInternal: Boolean = False): TPathIncludeItem;
var
  i: Integer;
  bAdd: Boolean;
begin
  bAdd := True;
  Result := nil;

  // Check for duplicates, update existing
  for i := 0 to Pred(FItems.Count) do
  begin
    if ((CompareText(Item[i].Path, APath) = 0) and
      (CompareText(Item[i].WildCard, APath) = 0) and
      (Item[i].RemovePath = ARemovePath) and
      (Item[i].RemoveExtension = ARemoveExtension) and not (AInternal)) then
    begin
      Result := item[i];
      bAdd := False;
      break;
    end;
  end;

  if bAdd then
    Result := TPathIncludeItem.Create;

  with Result do
  begin
    Path := APath;
    WildCard := AWildCard;
    RemoveExtension := ARemoveExtension;
    RemovePath := ARemovePath;
    Internal := AInternal;
  end;

  if bAdd then
    FItems.Add(Result);

  if Assigned(FOnAddItem) then
    FOnAddItem(Result);
end;

constructor TPathIncludeList.Create(AFileName: string);
var
  i: Integer;
  bSave: Boolean;
begin
  inherited Create;
  FFileName := AFileName;
  FItems := TObjectList.Create;
  bSave := False;

  // Load Internals
  AddInternals;

  if FileExists(AFileName) then
  begin

    Load;
    try
      for i := Pred(FItems.Count) downto 0 do
      begin
        if (DirectoryExists(Item[i].Path) = False) then
        begin
          FItems.Delete(FItems.IndexOf(item[i]));
          bSave := True;
        end;
      end;
    finally
      if bSave then
        Save;
    end;
  end
  else
    Save;
end;

destructor TPathIncludeList.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TPathIncludeList.GeTPathIncludeItem(AIndex: integer): TPathIncludeItem;
begin
  Result := (FItems[AIndex] as TPathIncludeItem);
end;

procedure TPathIncludeList.Save(AFileName: string);
var
  i: Integer;
  Xml: TjvSimpleXml;
begin
  DeleteFile(Pchar(AFileName));
  Xml := TJvSimpleXml.Create(nil);

  try
    try
      Xml.Root.Name := 'PathInclude';
      xml.Root.Properties.Add('ItemCount', FItems.Count);

      for i := 0 to FItems.Count - 1 do
      begin
        if Item[i].Internal = False then
        begin

          Xml.Root.Items.Add(Format('PathInclude%d', [i]));
          Xml.Root.Items.Item[i].Items.Add('Path',
            Item[i].Path);
          Xml.Root.Items.Item[i].Items.Add('WildCard',
            Item[i].WildCard);
          Xml.Root.Items.Item[i].Items.Add('RemoveExtension',
            Item[i].RemoveExtension);
          Xml.Root.Items.Item[i].Items.Add('RemovePath',
            Item[i].RemovePath);
        end;
      end;

      Xml.SaveToFile(FileName);
    except
      on E: Exception do
      begin
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

procedure TPathIncludeList.Load(AFileName: string);
var
  ItemCount, Loop: Integer;
  xml: TjvSimpleXml;
  prop: string;
  sMsg: string;
begin

  xml := TJvSimpleXml.Create(nil);

  try
    try
      xml.LoadFromFile(FileName);

      if xml.Root.Name <> 'PathInclude' then
      begin
        sMsg := 'Invalid Path Inclusion File' + #13;
        Debug(sMsg, DMT_ERROR);

        sMsg := sMsg + Format('Expected "%s" found "%s"', ['PathInclude',
          xml.Root.Name]);
        MessageDlg(sMsg, mtError, [mbOK], 0);

        exit;
      end;

      Itemcount := xml.Root.Properties.Item[0].IntValue;
      for Loop := 0 to itemcount - 1 do
      begin
        prop := 'PathInclude' + inttostr(loop);

        if xml.Root.Items.ItemNamed[prop] <> nil then

          with xml.Root.Items.ItemNamed[prop].Items do
          begin

            Self.Add(
              Value('Path', ''),
              Value('WildCard', ''),
              BoolValue('RemoveExtension', false),
              BoolValue('RemovePath', false));
          end;
      end;
    except

      on E: Exception do
      begin
        Debug('Error While Loading Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);

        Save;
      end;
    end;
  finally
    xml.Free;
  end;
end;

procedure TPathIncludeList.AddInternals;
begin
  Add(GetWindowsFolder, '*.exe', False, True, True);
  Add(GetWindowsSystemFolder, '*.exe', False, True, True);
  Add(GetSharpeDirectory, '*.exe', False, True, True);
end;

end.

