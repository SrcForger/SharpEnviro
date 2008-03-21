unit uDebugList;

interface
uses
  Classes,
  jclIniFiles,
  ContNrs,
  SysUtils,
  dialogs,
  sharpapi,
  Forms;

type
  // "Private" Object, TDebugStore needs it...
  TInfo = class(TObject)
  private
    FErrorType: Integer;
    FModule: String;
    FMessageText: String;
    FDTLogged: TDateTime;


  public
    destructor Free;
    property DTLogged: TDateTime read FDTLogged Write FDTLogged;
    Property ErrorType: Integer read FErrorType Write FErrorType;
    property Module: String read FModule Write FModule;
    property MessageText: String read FMessageText Write FMessageText;
  end;

  TDebugStore = class(TObject)
  private
    FItems: TObjectList;
    FOnUpdate: TNotifyEvent;
    function GetCount: integer;
    function GetInfo(Index: integer): TInfo;
    function GetItems(Index: integer): string;
    procedure SetItems(Index: integer; const Value: string);

  public
    constructor Create;
    destructor Destroy; override;

    function Add(DTLogged: TDateTime; ErrorType: integer; Module: string;
      MessageText: string): TInfo;
    procedure Delete(Index: integer);

    property Count: integer read GetCount;
    property Items[Index: integer]: string read GetItems write SetItems;
      default;
    property Info[Index: integer]: TInfo read GetInfo;
    property OnUpdate : TNotifyEvent Read FOnUpdate Write FOnUpdate;
  end;

  Var
    DebugList: TDebugStore;

implementation

uses
  Main;

{ TDebugStore }

function TDebugStore.Add(DTLogged: TDateTime; ErrorType: integer; Module: string;
      MessageText: string): TInfo;
var
  errorstr:String;
begin
  // Draw the text
  case ErrorType of
    DMT_INFO: errorstr := 'INFO';
    DMT_STATUS: errorstr := 'STATUS';
    DMT_WARN: errorstr := 'WARN';
    DMT_ERROR: errorstr := 'ERROR';
    DMT_TRACE: errorstr := 'TRACE';
  end;

  if not (SharpConsoleWnd.IsModuleNotChecked(errorstr)) then
      if not (SharpConsoleWnd.IsModuleNotChecked(Module)) then
  begin
    Result := TInfo.Create;
    Result.DTLogged := DTLogged;
    Result.ErrorType := ErrorType;
    Result.Module := Module;
    Result.MessageText := MessageText;

    FItems.Add(Result);

    If Assigned(FOnUpdate) then
    FOnUpdate(Result);
  end;
end;

constructor TDebugStore.Create;
begin
  inherited Create;
  FItems := TObjectList.Create;
end;

procedure TDebugStore.Delete(Index: integer);
begin
  FItems.Delete(Index);
end;

destructor TDebugStore.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TDebugStore.GetCount: integer;
begin
  Result := FItems.Count;
end;

function TDebugStore.GetInfo(Index: integer): TInfo;
begin
  Result := (FItems[Index] as TInfo);
end;

function TDebugStore.GetItems(Index: integer): string;
begin
  //Result := Info[Index].DebugName;
end;

procedure TDebugStore.SetItems(Index: integer; const Value: string);
begin
  //Info[Index].DebugName := Value;
end;

{ TInfo }

{ TInfo }

destructor TInfo.Free;
begin

end;

initialization
  DebugList := TDebugStore.Create;
Finalization
  FreeAndNil(DebugList);

end.


