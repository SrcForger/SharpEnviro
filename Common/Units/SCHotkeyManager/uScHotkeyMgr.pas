unit uScHotkeyMgr;

interface

{$WARN SYMBOL_DEPRECATED OFF}

uses
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Contnrs,
  Windows,
  SharpApi,
  VKToString;

const
  offset = 6789;

type
  TScModifier = set of (scmShift, scmAlt, scmCtrl, scmWin);
  TScHotkeyEvent = procedure(Sender:TObject;HotkeyID:Integer) of Object;

type
  TScHotkeyItem = class(TObject)
  private
    FEnabled: Boolean;
    FKey: string;
    FHotkeyUId: Integer;
    FModifiers: TScModifier;
    FConflict: Boolean;
    FCommand: string;
    FName: string;
    FID: Integer;
    procedure SetEnabled(const Value: Boolean);

  public
    property ID: Integer read FID Write FID;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Conflict: Boolean read FConflict write FConflict;
    property Name: string read FName write FName;
    property HotkeyUId: Integer read FHotkeyUId write FHotkeyUId;
    property Modifiers: TScModifier read FModifiers write FModifiers;
    property Key: string read FKey write FKey;
    property Command: string read FCommand write FCommand;
    constructor Create;
  end;

type
  TScHotkeyManager = class(TObject)
  private
    FItems: TObjectList;
    FOnAddItem: TNotifyEvent;
    FWMHandle: THandle;
    FOnHotkeyEvent: TScHotkeyEvent;
    function GetCount: integer;
    function GetInfo(Index: integer): TScHotkeyItem;
    function GetUniqueID(str: string): Integer;
    function GetModifierInt(Index: Integer): Integer; overload;
    function GetModifierInt(Modifier: TScModifier): integer; overload;
    function GetKey(Index: Integer): Integer; overload;
    function GetKey(key: string): integer; overload;
    procedure Debug(Text: string; DebugMessageType: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    function Add(Name, Command: string; Modifiers: TScModifier; Key: string): TScHotkeyItem;
    procedure Delete(Index: integer);
    procedure RegisterKey(Index: integer);
    procedure UnRegisterKey(Index: integer);

    property Count: integer read GetCount;
    property Info[Index: integer]: TScHotkeyItem read GetInfo;
    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
    property OnHotkeyEvent: TScHotkeyEvent read FOnHotkeyEvent write FOnHotkeyEvent;
    procedure WinProc(var Message: TMessage);

    function CheckHotkeyExists(Key: string; Modifier: TScModifier): boolean;
    procedure ConvertToKeyModifier(Str:String; var Modifier: TScModifier; var Key: string);
    function GetKeyModifierAsStr(Var Modifier: TScModifier; Var Key : String):String;
  end;

var
  ScHotkeyManager: TScHotkeyManager;

implementation

procedure TScHotkeyManager.Debug(Text: string; DebugMessageType: Integer);
begin
  SendDebugMessageEx('TScHotkeyManager', Pchar(Text), 0, DebugMessageType);
end;

{ TScHotkeyManager }

function TScHotkeyManager.Add(Name, Command: string; Modifiers: TScModifier; Key: string):
  TScHotkeyItem;
begin
  Result := TScHotkeyItem.Create;
  Result.ID := Self.Count;
  Result.Name := Name;
  Result.HotkeyUId := GetUniqueID(Name);
  Result.Enabled := False;
  Result.Key := Key;
  Result.modifiers := Modifiers;
  Result.Command := Command;

  FItems.Add(Result);

  if Assigned(FOnAddItem) then
    FOnAddItem(Result);
end;

function TScHotkeyManager.CheckHotkeyExists(Key: string;
  Modifier: TScModifier): boolean;
var
  i: integer;
  b: boolean;
  uid: integer;
begin
  // 1st check list
  b := false;
  for i := 0 to Self.Count - 1 do begin
    if (Info[i].FKey = Key) and (Info[i].FModifiers = Modifier) then begin
      b := true;
      break;
    end;

    // now check for system registration
    if b = true then begin
      uid := GetUniqueID('hotkeycheck');
      if RegisterHotKey(FWMHandle, uId, GetModifierInt(modifier), GetKey(Key)) then
        b := true
      else
        b := false;
      UnregisterHotKey(FWMHandle, uId);
    end;
  end;

  result := b;
end;

constructor TScHotkeyManager.Create;
begin
  inherited Create;

  // Allocate Hotkey Handle
  FWMHandle := AllocateHwnd(WinProc);
  FItems := TObjectList.Create;
end;

procedure TScHotkeyManager.Delete(Index: integer);
begin
  FItems.Delete(Index);
end;

destructor TScHotkeyManager.Destroy;
var
  i: integer;
begin
  DeallocateHWnd(FWMHandle);

  // Delete all atoms
  for i := 0 to self.count - 1 do
    UnRegisterKey(i);

  FItems.Free;

end;

function TScHotkeyManager.GetCount: integer;
begin
  Result := FItems.Count;
end;

function TScHotkeyManager.GetInfo(Index: integer): TScHotkeyItem;
begin
  Result := (FItems[Index] as TScHotkeyItem);
end;

function TScHotkeyManager.GetKey(Index: Integer): Integer;
var
  vkc: TVKToString;
begin
  vkc := TVKToString.Create;
  vkc.VKey := Info[index].FKey;
  Result := vkc.AsAscii;
end;

function TScHotkeyManager.GetModifierInt(Index: Integer): Integer;
var
  lModifier: uINT;
begin
  lModifier := 0;

  if scmShift in Info[index].Modifiers then
    lModifier := lModifier or MOD_SHIFT;
  if scmAlt in Info[index].Modifiers then
    lModifier := lModifier or MOD_ALT;
  if scmCtrl in Info[index].Modifiers then
    lModifier := lModifier or MOD_CONTROL;
  if scmWin in Info[index].Modifiers then
    lModifier := lModifier or MOD_WIN;

  Result := lModifier;
end;

function TScHotkeyManager.GetModifierInt(Modifier: TScModifier): integer;
var
  lModifier: uINT;
begin
  lModifier := 0;

  if scmShift in Modifier then
    lModifier := lModifier or MOD_SHIFT;
  if scmAlt in Modifier then
    lModifier := lModifier or MOD_ALT;
  if scmCtrl in Modifier then
    lModifier := lModifier or MOD_CONTROL;
  if scmWin in Modifier then
    lModifier := lModifier or MOD_WIN;

  Result := lModifier;
end;

function TScHotkeyManager.GetUniqueID(Str: string): Integer;
begin
  Result := GlobalAddAtom(pchar(str));
end;

procedure TScHotkeyManager.RegisterKey(Index: integer);
begin
  RegisterHotKey(FWMHandle, info[index].HotkeyUId, GetModifierInt(index), GetKey(index));
end;

procedure TScHotkeyManager.UnRegisterKey(Index: integer);
begin
  // Display Information about the Hotkey being unregistered
  Debug(Format('Unregister Key: %d [%s]',[Index,Info[Index].Command]),DMT_INFO);

  // Unregister Hotkey Api
  If UnRegisterHotKey(FWMHandle, Info[Index].HotkeyUId) = False then
    Debug(Format('Error Unregistering Hotkey: Error Code %d',[GetLastError]),DMT_ERROR);

  // Delete Atom
  SetLastError(ERROR_SUCCESS);
  GlobalDeleteAtom(info[index].HotkeyUId);
  If GetLastError <> ERROR_SUCCESS then
    Debug(Format('Error Deleting Atom: Error Code %d',[GetLastError]),DMT_ERROR);
end;

procedure TScHotkeyManager.WinProc(var Message: TMessage);
var
  id: integer;
  i: integer;
begin
  if Message.Msg = WM_HOTKEY then begin

    if Self.Count = 0 then
      exit;

    // get id
    id := Message.wParam;
    for i := 0 to Self.Count - 1 do
      if id = info[i].HotkeyUId then begin

        If Assigned(FOnHotkeyEvent) then
        FOnHotkeyEvent(self,i);

        break;
      end;
  end else Message.Result := DefWindowProc(FWMHandle,Message.Msg,Message.WParam,Message.LParam);
  inherited;
end;

function TScHotkeyManager.GetKey(key: string): integer;
var
  vkc: TVKToString;
begin
  vkc := TVKToString.Create;
  vkc.VKey := Key;
  Result := vkc.AsAscii;
end;

procedure TScHotkeyManager.ConvertToKeyModifier(Str: String;
  var Modifier: TScModifier; var Key: string);
var
  n:integer;
begin
  // Initialise
  Modifier := [];
  Key := '';
  str := UpperCase(str);

  // Check for alt modifier
  if Pos('ALT',str) <> 0 then Modifier := Modifier + [scmAlt];
  if Pos('WIN',str) <> 0 then Modifier := Modifier + [scmWin];
  if Pos('SHIFT',str) <> 0 then Modifier := Modifier + [scmShift];
  if Pos('CTRL',str) <> 0 then Modifier := Modifier + [scmCtrl];

  // Extract the Key
  n := pos('VK',Str);
  if n = 0 then n := pos('CCK',Str);
  Key := copy(str,n,length(str)-n+1);
end;

function TScHotkeyManager.GetKeyModifierAsStr(var Modifier: TScModifier;
  var Key: String): String;
var
  ModifierStr: String;
begin

  // Check for alt modifier
  ModifierStr := '';
  if scmAlt in Modifier then ModifierStr := ModifierStr + 'ALT,';
  if scmWin in Modifier then ModifierStr := ModifierStr + 'WIN,';
  if scmShift in Modifier then ModifierStr := ModifierStr + 'SHIFT,';
  if scmCtrl in Modifier then ModifierStr := ModifierStr + 'CTRL,';

  Result := Format('MOD: %s KEY: %s',[ModifierStr,Key]);
end;

{ TScHotkeyItem }

constructor TScHotkeyItem.Create;
begin
  FEnabled := False;
end;

procedure TScHotkeyItem.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
end;

end.

