unit SWCmdList;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Contnrs,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls;

type
  TSWCmdEnum = (wscSW_Hide, wscSW_ShowNormal, wscSW_ShowMinimized,
    wscSW_ShowMaximized, wscSW_ShowNoActivate, wscSW_Show, wscSW_Minimize,
      wscSW_ShowMinNoActive, wscSW_ShowNA, wscSW_Restore, wscSW_ShowDefault,
        wscSW_ForceMinimize);
  TSWCmdEnums = set of TSWCmdEnum;


  TSWCmdItem = Class(TPersistent)
  private
    FEnabled: Boolean;
    FSWCmd: TSWCmdEnum;
    function GetText: String;
    function GetXmlText: string;
  published
    property Enabled: Boolean read FEnabled write FEnabled;
    Property Text: String read GetText;
    Property XmlText: string read GetXmlText;
    Property SWCmd: TSWCmdEnum read FSWCmd write FSWCmd;
    constructor Create(ASWCmd: TSWCmdEnum);
  End;

  TWindowShowCommandList = Class(TObjectList)
  private
    function GetItem(Index: Integer): TSWCmdItem;
    procedure SetItem(Index: Integer; const Value: TSWCmdItem);
  public
    procedure AddItems;
    function EnumCount: Integer;
    property Item[Index: Integer] : TSWCmdItem
             read GetItem write SetItem; Default;
  End;

implementation

{ TWindowShowCommandItem }

constructor TSWCmdItem.Create(
  ASWCmd: TSWCmdEnum);
begin
  FSWCmd := ASWCmd;
  FEnabled := False;
end;

function TSWCmdItem.GetText: String;
begin
  case FSWCmd of
    wscSW_Hide: Result := 'SW_HIDE';
    wscSW_ShowNormal: Result := 'SW_SHOWNORMAL, SW_NORMAL';
    wscSW_ShowMinimized: Result := 'SW_SHOWMINIMIZED';
    wscSW_ShowMaximized: Result := 'SW_MAXIMIZED, SW_MAXIMIZE';
    wscSW_ShowNoActivate: Result := 'SW_SHOWNOACTIVATE';
    wscSW_Show: Result := 'SW_SHOW';
    wscSW_Minimize: Result := 'SW_MINIMIZE';
    wscSW_ShowMinNoActive: Result := 'SW_SHOWMINNOACTIVE';
    wscSW_ShowNA: Result := 'SW_SHOWNA';
    wscSW_Restore: Result := 'SW_RESTORE';
    wscSW_ShowDefault: Result := 'SW_SHOWDEFAULT';
    wscSW_ForceMinimize: Result := 'SW_FORCEMINIMIZE, SW_MAX';
  end;

end;

function TSWCmdItem.GetXmlText: string;
begin
  case FSWCmd of
    wscSW_Hide: Result := 'SW_HIDE';
    wscSW_ShowNormal: Result := 'SW_SHOWNORMAL';
    wscSW_ShowMinimized: Result := 'SW_SHOWMINIMIZED';
    wscSW_ShowMaximized: Result := 'SW_MAXIMIZED';
    wscSW_ShowNoActivate: Result := 'SW_SHOWNOACTIVATE';
    wscSW_Show: Result := 'SW_SHOW';
    wscSW_Minimize: Result := 'SW_MINIMIZE';
    wscSW_ShowMinNoActive: Result := 'SW_SHOWMINNOACTIVE';
    wscSW_ShowNA: Result := 'SW_SHOWNA';
    wscSW_Restore: Result := 'SW_RESTORE';
    wscSW_ShowDefault: Result := 'SW_SHOWDEFAULT';
    wscSW_ForceMinimize: Result := 'SW_FORCEMINIMIZE';
  end;

end;

{ TWindowShowCommandList }

procedure TWindowShowCommandList.AddItems;
var
  i:Integer;
begin
  Clear;

  for i := 0 to EnumCount do begin
    Add(TSWCmdItem.Create(TSWCmdEnum(i)));
  end;

end;

function TWindowShowCommandList.EnumCount: Integer;
 Var
   count: Integer;
   enum : TSWCmdEnum;
 Begin
   count := 0;
   for enum := Low(TSWCmdEnum) to High(TSWCmdEnum) Do
      Inc(count);

   Result := count;
end;

function TWindowShowCommandList.GetItem(Index: Integer): TSWCmdItem;
begin
  if Index < Count then
    Result := TSWCmdItem(Items[Index])
  else Result := nil;
end;

procedure TWindowShowCommandList.SetItem(Index: Integer;
  const Value: TSWCmdItem);
begin
  if Index < Count then
    Items[Index] := Value;
end;

end.
