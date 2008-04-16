{
Source Name: SystemActions.dpr
Description: System Actions Service library file
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

library SystemActions;

uses
  windows,
  SysUtils,
  Messages,
  Classes,
  SharpApi,
  uShutdown,
  JCLLocales;

type
  TActionEvent = Class(Tobject)
  Procedure MessageHandler(var msg: TMessage);
  end;

var
  AE:TActionEvent;
  h:THandle;
  LocalsList : TJclKeyboardLayoutList;

{$E ser}

{$R *.RES}

function SwitchToThisWindow(Wnd : hwnd; fAltTab : boolean) : boolean; stdcall; external 'user32.dll';

procedure RegisterKeyBoardLocals;
var
  n : integer;
begin
  if LocalsList.Count <= 1 then
    exit;

  for n := 0 to LocalsList.Count - 1 do
    RegisterActionEx(PChar('!KL'+LocalsList[n].DisplayName),'Keyboard Layouts',h,100+n);
end;

procedure UnRegisterKeyBoardLocals;
var
  n : integer;
begin
  if LocalsList.Count <= 1 then
    exit;

  for n := 0 to LocalsList.Count - 1 do
    UnRegisterAction(PChar('!KL'+LocalsList[n].DisplayName));    
end;

procedure RegisterActions;
begin
  RegisterActionEx('!Restart', 'Shutdown', h, 1);
  RegisterActionEx('!Shutdown', 'Shutdown', h, 2);
  RegisterActionEx('!Logout', 'Shutdown', h, 3);
  RegisterActionEx('!Hibernate', 'Shutdown', h, 4);
  RegisterActionEx('!SwitchUser/LockStation', 'Shutdown', h, 5);
  RegisterActionEx('!MinimizeAll', 'Window Management', h, 6);
  RegisterActionEx('!RestoreAll', 'Window Management', h, 7);
  RegisterActionEx('!ToggleAllBars', 'SharpBar', h, 8);
  RegisterKeyBoardLocals;
end;

// Service is started
function Start(owner: hwnd): hwnd;
begin
  Result := owner;

  ae := TActionEvent.Create;
  h := allocatehwnd(Ae.MessageHandler);

  LocalsList := TJclKeyboardLayoutList.Create;
  LocalsList.Refresh;

  RegisterActions;
  ServiceDone('System Actions');
end;

// Service is stopped
procedure Stop;
begin
  DeallocateHWnd(h);
  AE.Free;

  LocalsList.Free;

  UnRegisterKeyBoardLocals;
  UnRegisterAction('!Restart');
  UnRegisterAction('!Shutdown');
  UnRegisterAction('!Logout');
  UnRegisterAction('!Hibernate');
  UnRegisterAction('!SwitchUser/LockStation');
  UnRegisterAction('!MinimizeAll');
  UnRegisterAction('!RestoreAll');
  UnRegisterAction('!ToggleAllBars');
end;

{ TActionEvent }

procedure TActionEvent.MessageHandler(var msg: TMessage);
type
  PParam = ^TParam;
  TParam = record
    wndlist: array of hwnd;
  end;
  THandleArray = array of HWND;
var
  EnumParam : TParam;

  function EnumWindowsProc(Wnd: HWND; LParam: LPARAM): BOOL; stdcall;
  begin
    if (GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) and
       ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
       ((GetWindowLong(Wnd, GWL_HWNDPARENT) = 0) or
       (GetWindowLong(Wnd, GWL_HWNDPARENT) = Integer(GetDesktopWindow))) and
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0))  then
       with PParam(LParam)^ do
       begin
        setlength(wndlist,length(wndlist)+1);
        wndlist[high(wndlist)] := wnd;
       end;
    result := True;
  end;

  function FindAllWindows(const WindowClass: string): THandleArray;
  type
    PParam = ^TParam;
    TParam = record
      ClassName: string;
      Res: THandleArray;
    end;
  var
    Rec: TParam;

    function GetWndClass(pHandle: hwnd): string;
    var
      buf: array[0..254] of Char;
    begin
      GetClassName(pHandle, buf, SizeOf(buf));
      result := buf;
    end;

    function _EnumProc(_hWnd: HWND; _LParam: LPARAM): LongBool; stdcall;
    begin
      with TParam(PParam(_LParam)^) do
      begin
        if (CompareText(GetWndClass(_hWnd), ClassName) = 0) then
        begin
          SetLength(Res, Length(Res) + 1);
          Res[Length(Res) - 1] := _hWnd;
        end;
        Result := True;
      end;
    end;

  begin
    try
      Rec.ClassName := WindowClass;
      SetLength(Rec.Res, 0);
      EnumWindows(@_EnumProc, Integer(@Rec));
    except
      SetLength(Rec.Res, 0);
    end;
    Result := Rec.Res;
  end;

var
  ShutDown : TSEShutdown;
  dmsg : String;
  n,k : integer;
  BarList : THandleArray;
  BarHidden : boolean;
begin
  if msg.Msg = WM_INPUTLANGCHANGE then
  begin
    UnRegisterKeyBoardLocals;
    LocalsList.Refresh;
    RegisterKeyBoardLocals;
  end
  else if msg.Msg = WM_SHARPEUPDATEACTIONS then
    RegisterActions
  else if msg.Msg = WM_SHARPEACTIONMESSAGE then
  begin
    // shutdown?
    if (Msg.LParam >= 1) and (Msg.LParam <=4) then
    begin
      ShutDown := TSEShutDown.Create;
      try
        case Msg.LParam of
          1: begin
               ShutDown.ActionType := sdReboot;
               dmsg := 'Reboot';
             end;
          2: begin
               ShutDown.ActionType := sdPowerOff;
               dmsg := 'Shutdown';
             end;
          3: begin
               ShutDown.ActionType := sdLogOff;
               dmsg := 'Logout';
             end;
          4: begin
               ShutDown.ActionType := sdHibernate;
               dmsg := 'Hibernate';
             end;
        end;
        ShutDown.Force := True;       
        if MessageBox(FindWindow('TSharpCoreMainWnd',nil),
                      PChar('Do you really want to ' + dmsg + ' your Computer now?'),
                      PChar('Confirm ' + dmsg),MB_YESNO) = ID_YES then
           ShutDown.Execute;
      finally
        ShutDown.Free;
      end;
      exit;
    end;

    if (Msg.LParam = 6) or (Msg.LParam = 7) then
    begin
      setlength(EnumParam.wndlist,0);
      EnumWindows(@EnumWindowsProc, Integer(@EnumParam));
    end;

    // Keyboard Lacout Changed?
    if (Msg.LParam >= 100) then
    begin
      n := Msg.LParam - 100;
      k := 0;
      if n <= LocalsList.Count - 1 then
      begin
        SystemParametersInfo(SPI_SETDEFAULTINPUTLANG, k, @LocalsList.Items[n].Layout, SPIF_SENDCHANGE or SPIF_UPDATEINIFILE);
        PostMessage(HWND_BROADCAST,WM_INPUTLANGCHANGEREQUEST,0,LocalsList.Items[n].Layout);
      end;
      exit;
    end;

  case Msg.LParam of
      5: begin
           // Lock Work Station / Switch User;
           LockWorkStation;
         end;
      6: begin
           // Minimize All Windows
           for n := 0 to High(EnumParam.Wndlist) do
               CloseWindow(EnumParam.WndList[n]);
         end;
      7: begin
           // Restore All Windows
           for n := 0 to High(EnumParam.WndList) do
               if IsIconic(EnumParam.WndList[n]) then ShowWindow(EnumParam.WndList[n], SW_Restore)
                  else SwitchToThisWindow(EnumParam.WndList[n],True);
         end;
      8: begin
           // Toggle (Show/Hide) all bars
           BarList := FindAllWindows('TSharpBarMainForm');
           BarHidden := False;
           for n  := 0 to High(BarList) do
               if not IsWindowVisible(BarList[n]) then
               begin
                 BarHidden := True;
                 break;
               end;
           setlength(BarList,0);
           if BarHidden then
              SharpApi.SharpEBroadCast(WM_SHOWBAR,0,0)
              else SharpApi.SharpEBroadCast(WM_HIDEBAR,0,0);
           SharpApi.ServiceMsg('DeskArea','Update');
         end;
    end;
    setlength(EnumParam.wndlist,0);
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'System Actions';
    Description := 'Adds a set of actions for system use (shutdown, reboot, etc.)';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteService;
    ExtraData := 'priority: 40| delay: 0';
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop,
  GetMetaData;

begin
end.


