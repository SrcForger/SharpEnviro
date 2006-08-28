unit uSharpCoreServiceList;

interface
uses
  // Standard
  Classes,
  ContNrs,
  SysUtils,
  dialogs,
  Forms,

  // JCL
  jclIniFiles,

  // JVCL
  JvSimpleXml,

  // Program
  uSharpCorePluginMethods;

type
  TServiceType = (stOnce, stNever, stAlways);
  TServicestatus = (ssStarted, ssStopped, ssDisabled, ssInit);

type
  // "Private" Object, TServiceStore needs it...
  TInfo = class(TObject)
  private
    FID: Integer;
    FName: string;

    FAuthor: string;
    FDescription: string;
    FFileName: string;
    FVersion: string;
    FRunAtStart: string;
    FConfigDisabled: Boolean;
    FServType: TServiceType;
    FStatus: TServiceStatus;

    FDllProcess: TSharpService;
    FInfoDisabled: Boolean;

  public
    destructor Destroy; override;
    property ID: Integer read FID write FID;
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property Description: string read FDescription write FDescription;
    property FileName: string read FFileName write FFileName;
    property Version: string read FVersion write FVersion;

    property SrvType: TServiceType read FServType write FServType;
    property Status: TServiceStatus read FStatus write FStatus;
    property ConfigDisabled: Boolean read FConfigDisabled write FConfigDisabled;
    property InfoDisabled: Boolean read FInfoDisabled write FInfoDisabled;
    property RunAtStart: string read FRunAtStart write FRunAtStart;
    property DllProcess: TSharpService read FDllProcess write FDllProcess;
  end;

  TServiceStore = class(TObject)
  private
    FItems: TList;
    FOnAddItem: TNotifyEvent;
    FOnInfo: TNotifyEvent;

    function GetCount: integer;
    function GetInfo(Index: integer): TInfo;

  public
    constructor Create;
    destructor Destroy; override;

    function Add(ID: Integer; Name: string; Author: string; Description: string;
      Filename: string; Version: string; SrvType: TServiceType; Status:
      TServiceStatus; InfoDisabled, ConfigDisabled: Boolean; RunAtStart: string;
      DllProcess:
      TSharpService): TInfo;
    procedure Delete(Index: integer);
    procedure SaveSettings(Index: Integer);
    procedure Clear;
    function FindObject(AID:Integer):TInfo;
    property Count: integer read GetCount;

    property Info[Index: integer]: TInfo read GetInfo;

    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
    property OnInfo: TNotifyEvent read FOnInfo write FOnInfo;
    property Items: TList read FItems write FItems;
    
  end;

implementation

uses
  uSharpCoreHelperMethods;

{ TServiceStore }

function TServiceStore.Add(ID: Integer; Name, Author, Description,
  Filename, Version: string; SrvType: TServiceType; Status: TServiceStatus;
  InfoDisabled, ConfigDisabled: Boolean; RunAtStart: string; DllProcess:
  TSharpService):
  TInfo;
begin
  Result := TInfo.Create;
  Result.ID := ID;
  Result.Name := Name;
  Result.Author := Author;
  Result.Description := Description;
  Result.FileName := FileName;
  Result.Version := Version;
  Result.SrvType := SrvType;
  Result.Status := Status;
  Result.InfoDisabled := InfoDisabled;
  Result.ConfigDisabled := ConfigDisabled;
  Result.RunAtStart := RunAtStart;
  Result.DllProcess := DllProcess;
  FItems.Add(Result);

  if Assigned(FOnAddItem) then
    FOnAddItem(Result);
end;

procedure TServiceStore.Clear;
var
  i:Integer;
begin
  for i := 0 to Pred(Self.Count) do
    Self.Info[i].Free;

  Self.Items.Clear;
end;

constructor TServiceStore.Create;
begin
  inherited Create;
  FItems := TList.Create;
end;

procedure TServiceStore.Delete(Index: integer);
begin
  FItems.Delete(Index);
end;

destructor TServiceStore.Destroy;
var
  i:Integer;
begin
  for i := 0 to Pred(FItems.Count) do
    TInfo(FItems.Items[i]).Free;

  Fitems.Clear;
  FItems.Free;
  inherited;
end;

function TServiceStore.FindObject(AID: Integer): TInfo;
var
  i:integer;
begin
  Result := nil;
  For i := 0 to Pred(Fitems.Count) do
    if TInfo(FItems[i]).ID = AID then begin
      Result := TInfo(FItems[i]);
      Break;
    end;
end;

function TServiceStore.GetCount: integer;
begin
  Result := 0;
  Try
  if assigned(FItems) then
    Result := FItems.Count;
  Except
  End;
end;

function TServiceStore.GetInfo(Index: integer): TInfo;
begin
  Result := TInfo(FItems[Index]);
end;

procedure TServiceStore.SaveSettings(Index: Integer);
var
  xml: TjvSimpleXml;
  ConfigFile: string;
begin
  ConfigFile :=
    ServiceSettingsUserPath(info[index].FFileName);

  DeleteFile(ConfigFile);
  xml := TJvSimpleXml.Create(nil);

  try
    xml.Root.Name := 'SharpCore';

    xml.root.Items.Add('userspec');
    with xml.Root.Items.ItemNamed['userspec'].items do begin
      Add('ServiceType', Integer(info[index].FServType));
    end;

    ForceDirectories(ExtractFilePath(ConfigFile));
    xml.SaveToFile(ConfigFile);

  finally
    xml.Free;
  end;

end;

{ TInfo }

destructor TInfo.Destroy;
begin
  UnLoadService(@dllprocess);
end;

end.

