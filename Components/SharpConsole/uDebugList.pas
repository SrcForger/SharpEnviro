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
  TDebugItem = class(TObject)
  private
    FErrorType: Integer;
    FModule: String;
    FMessageText: String;
    FDTLogged: TDateTime;
  public
    property DTLogged: TDateTime read FDTLogged Write FDTLogged;
    Property ErrorType: Integer read FErrorType Write FErrorType;
    property Module: String read FModule Write FModule;
    property MessageText: String read FMessageText Write FMessageText;
  end;

  TDebugList = class(TObjectList)
  private
    FOnUpdate: TNotifyEvent;
    function GetItem(Index: integer): TDebugItem;
    procedure SetItem(Index: integer; const AItem: TDebugItem);

  public
    constructor Create;

    function Add(DTLogged: TDateTime; ErrorType: integer; Module: string;
      MessageText: string): TDebugItem; overload;

    property Item[Index: integer]: TDebugItem read GetItem write SetItem;
      default;
    property OnUpdate : TNotifyEvent Read FOnUpdate Write FOnUpdate;
  end;

implementation

uses
  Main;

{ TDebugStore }

function TDebugList.Add(DTLogged: TDateTime; ErrorType: integer; Module: string;
      MessageText: string): TDebugItem;
var
  errorstr:String;
begin
  Result := nil;
  
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
    Result := TDebugItem.Create;
    Result.DTLogged := DTLogged;
    Result.ErrorType := ErrorType;
    Result.Module := Module;
    Result.MessageText := MessageText;

    Add(Result);

    If Assigned(FOnUpdate) then
    FOnUpdate(Result);
  end;
end;

constructor TDebugList.Create;
begin
  inherited Create;
end;

function TDebugList.GetItem(Index: integer): TDebugItem;
begin
  Result := TDebugItem(Items[Index]);
end;

procedure TDebugList.SetItem(Index: integer; const AItem: TDebugItem);
begin
  Items[Index] := AItem;
end;

end.


