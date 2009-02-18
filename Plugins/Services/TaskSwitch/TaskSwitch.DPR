{
Source Name: Switcher.dpr
Description: SystemTray service library file
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

library TaskSwitch;

uses
  windows,
  Messages,
  SysUtils,
  Classes,
  Forms,
  SharpApi,
  JvSimpleXML,
  JclSysUtils,
  JclSysInfo,
  uISharpESkin,
  Dialogs,
  uTaskSwitchGUI in 'uTaskSwitchGUI.pas',
  uTaskSwitchWnd in 'Forms\uTaskSwitchWnd.pas' {TaskSwitchWnd},
  uTaskItem in '..\Shell\uTaskItem.pas',
  uTaskManager in '..\Shell\uTaskManager.pas',
  SWCmdList in '..\..\..\Common\Units\TaskFilterList\SWCmdList.pas',
  TaskFilterList in '..\..\..\Common\Units\TaskFilterList\TaskFilterList.pas';

type
  TActionEvent = Class(Tobject)
  Procedure MessageHandler(var Message: TMessage);
  end;

  TTaskAction = record
                  Name : String;
                  Action : String;
                  CForward : Boolean;
                  UseGUI   : Boolean;
                  Preview : Boolean;
                  IFilters : array of String;
                  EFilters : array of String;
                end;

  TWindowItem = record
                  wnd : hwnd;
                  vwm : integer;
                end;
  TWindowArray = array of TWindowItem;

var
  AE:TActionEvent;
  h:THandle;
  SkinInterface : ISharpESkin;
  Filters : TFilterItemList;
  Actions : array of TTaskAction;
  TaskManager : TTaskManager;
  MessageReceived : boolean;


{$R *.RES}


function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure ClearActions;
var
  n : integer;
begin
  for n := 0 to High(Actions) do
  begin
    setlength(Actions[n].IFilters,0);
    setlength(Actions[n].EFilters,0);
  end;
  setlength(Actions,0);
end;

procedure RegisterActions;
var
  n : integer;
begin
  for n := 0 to High(Actions) do
    with Actions[n] do
      SharpApi.RegisterActionEx(PChar(Action),PChar('Window Management'),h,n);
end;

procedure UnregisterActions;
var
  n : integer;
begin
  for n := 0 to High(Actions) do
    with Actions[n] do
      SharpApi.UnRegisterAction(PChar(Action));
end;

function GetFilter(pName : String) : TFilterItem;
var
  n : integer;
begin
  for n := 0 to Filters.Count - 1 do    
    if CompareText(Filters[n].Name,pName) = 0 then
    begin
      result := Filters[n];
      exit;
    end;
  result := nil;
end;

function GetWndClass(wnd : hwnd) : String;
var
  buf: array [0..254] of Char;
begin
  GetClassName(wnd, buf, SizeOf(buf));
  result := buf;
end;

function GetFileName(wnd : hwnd) : String;
var
  path : String;
begin
  path := GetProcessNameFromWnd(wnd);
  result := LowerCase(ExtractFileName(path));
end;

function GetShowCmd(wnd : hwnd) : integer;
var
  pl : TWindowPlacement;
begin
  if IsWindow(wnd) then
  begin
    pl.length := SizeOf(TWindowPlacement);
    GetWindowPlacement(wnd, @pl);
    result := pl.showCmd;
  end else result := -1;
end;

function CheckFilter(wnd : hwnd; TA : TTaskAction; currentvwm,vwm : integer) : boolean;
var
  n : integer;
  R : TRect;
  Mon : TMonitor;
  nm : boolean;
  CF : TFilterItem;
  WndShowCmd : integer;
  WndClassName : String;
  WndFileName : String;
begin
  if wnd = 0 then
  begin
    result := false;
    exit;
  end;
  WndShowCmd := GetShowCmd(wnd);
  WndClassName := GetWndClass(wnd);
  WndFileName := GetFileName(wnd);

  result := true;
  nm := False;
  if length(TA.IFilters) > 0 then
  begin
    for n:=0 to High(TA.IFilters) do
    begin
      CF := GetFilter(TA.IFilters[n]);
      if CF <> nil then
        case CF.FilterType of
          fteSWCmd: if TSWCmdEnum(WndShowCmd) in CF.SWCmds then nm := True;
          fteWindow: if CompareText(WndClassName,CF.WndClassName) = 0 then nm := True;
          fteProcess: if CompareText(WndFileName,CF.FileName) = 0 then nm := True;
          fteCurrentMonitor: begin
               Mon := Screen.MonitorFromWindow(wnd);
               GetWindowRect(wnd,R);
               if PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-R.Top) div 2), Mon.BoundsRect)
                  or PointInRect(Point(R.Left, R.Top), Mon.BoundsRect)
                  or PointInRect(Point(R.Left, R.Bottom), Mon.BoundsRect)
                  or PointInRect(Point(R.Right, R.Top), Mon.BoundsRect)
                  or PointInRect(Point(R.Right, R.Bottom), Mon.BoundsRect) then
                 nm := True;
             end;
          fteCurrentVWM: begin
               nm := (CurrentVWM = vwm);
             end;
          fteMinimised: begin
               nm := IsIconic(wnd);
             end;
        end;
      if nm then break;
    end;
  end;

  // task is supposed to be included...
  if nm then exit;

  if length(TA.EFilters) > 0 then
  begin
    for n:=0 to High(TA.EFilters) do
    begin
      CF := GetFilter(TA.EFilters[n]);
      if CF <> nil then
        case CF.FilterType of
          fteSWCmd: if TSWCmdEnum(WndShowCmd) in CF.SWCmds then result := false;
          fteWindow: if CompareText(WndClassName,CF.WndClassName) = 0 then result := false;
          fteProcess: if CompareText(WndFileName,CF.FileName) = 0 then result := false;
          fteCurrentMonitor: begin
               Mon := Screen.MonitorFromWindow(wnd);
               GetWindowRect(wnd,R);
               if PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-R.Top) div 2), Mon.BoundsRect)
                  or PointInRect(Point(R.Left, R.Top), Mon.BoundsRect)
                  or PointInRect(Point(R.Left, R.Bottom), Mon.BoundsRect)
                  or PointInRect(Point(R.Right, R.Top), Mon.BoundsRect)
                  or PointInRect(Point(R.Right, R.Bottom), Mon.BoundsRect) then
                 result := false;
             end;
          fteCurrentVWM: begin
               result := (CurrentVWM <> vwm)
             end;
          fteMinimised: begin
               result := not IsIconic(wnd);
             end;
        end;
    end;
  end;
end;

procedure CycleWindows(ActionIndex : integer);
type
  PParam = ^TParam;
  TParam = record
    wndlist: TWindowArray;
    ac : TTaskAction;
  end;
var
  EnumParam : TParam;
  wnd : hwnd;
  n : integer;
  stime : Int64;
  pItem : TTaskItem;
  deskwnd : hwnd;
  currentvwm,vwm : integer;
begin
  EnumParam.ac := Actions[ActionIndex];

  if (EnumParam.ac.UseGUI) and (TSGUI.WndVisible) then
  begin
    // update the already existing gui
    if EnumParam.ac.CForward then TSGUI.Index := TSGUI.Index + 1
      else TSGUI.Index := TSGUI.Index - 1;
    TSGUI.UpdateHighlight;
    exit;
  end;

  // update the task list of the TaskManager class,
  // and wait for it to be done
  stime := GetTickCount;
  MessageReceived := False;
  if SharpApi.RequestWindowList(h) then
    while (not MessageReceived) and (GetTickCount - stime < 5000) do
      Application.ProcessMessages;

  currentvwm := SharpApi.GetCurrentVWM;
  setlength(EnumParam.wndlist,0);
  wnd := GetTopWindow(0);//GetNextWindow(FindWindow('TSharpDeskMainForm',nil),GW_HWNDPREV);
  while wnd <> 0 do
  begin
    if ((GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) or
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_APPWINDOW <> 0)) and
       ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
       (GetWindowLong(Wnd, GWL_STYLE) and WS_CHILD = 0) and
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0)) then
//       (GetWindowLong(wnd, GWL_EXSTYLE) and WS_EX_TOPMOST = 0) then
       with EnumParam do
       begin
         pItem := TaskManager.GetItemByHandle(wnd);
         if pItem <> nil then
         begin
           vwm := pItem.LastVWM;
//         else vwm := currentvwm;
           if CheckFilter(wnd,ac,currentvwm,vwm) then
           begin
             setlength(wndlist,length(wndlist)+1);
             wndlist[high(wndlist)].wnd := wnd;
             wndlist[high(wndlist)].vwm := vwm;
           end;
         end;
       end;
    wnd := GetNextWindow(wnd,GW_HWNDNEXT);           
  end;

  if length(EnumParam.wndlist) > 0 then
  with EnumParam do
  begin
    if ac.UseGUI then
    begin
      // gui usage
      if not TSGUI.WndVisible then
      begin
        // show new gui
        setlength(TSGUI.wndlist,length(wndlist));
        for n := 0 to High(wndlist) do
          TSGUI.wndlist[n] := wndlist[n].wnd;
        TSGUI.ShowPreview := ac.Preview;
        TSGUI.Index := 1;
        TSGUI.ShowWindow;
      end;
    end else
    begin
      // life action
      if length(EnumParam.wndlist) > 1 then
      begin
        if Actions[ActionIndex].CForward then
        begin
          if IsIconic(wndlist[1].wnd) then
            ShowWindow(wndlist[1].wnd,SW_RESTORE)
            else
            begin
              ForceForegroundWindow(wndlist[1].wnd);
              SetWindowPos(wndlist[0].wnd,wndlist[High(wndlist)].wnd,0,0,0,0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
              deskwnd := FindWindow('TSharpDeskMainForm',nil);
              if deskwnd <> 0 then
                SetWindowPos(deskwnd,HWND_BOTTOM,0,0,0,0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
            end;
        end else
        begin
          if IsIconic(wndlist[1].wnd) then
            ShowWindow(wndlist[1].wnd,SW_RESTORE)
          else
          begin
            ForceForegroundWindow(wndlist[High(wndlist)].wnd);
          end;
        end;
    end;
    end;
  end;

  setlength(EnumParam.wndlist,0);
end;

procedure LoadActionsFromXML;
var
  XML : TJvSimpleXML;
  n : integer;
  fn : String;
  i : integer;
begin
  ClearActions;
  fn := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\TaskSwitch\';
  fn := fn + 'actions.xml';
  if not FileExists(fn) then
    exit;

  XML := TJvSimpleXMl.Create(nil);
  try
    XML.LoadFromFile(fn);
    for n := 0 to XML.Root.Items.Count - 1 do
    begin
      setlength(Actions,length(Actions) + 1);
      with XML.Root.Items.Item[n].Items do
        with Actions[High(Actions)] do
        begin
          Name := Value('Name','');
          Action := Value('Action','');
          UseGUI := BoolValue('UseGui',False);
          CForward := BoolValue('CForward',True);
          Preview := BoolValue('Preview',True);
          setlength(IFilters,0);
          setlength(EFilters,0);
          if ItemNamed['IFilters'] <> nil then
            for i := 0 to ItemNamed['IFilters'].Items.Count - 1 do
            begin
              setlength(IFilters,length(IFilters) + 1);
              IFilters[High(IFilters)] := ItemNamed['IFilters'].Items.Item[i].Value;
            end;
          if ItemNamed['EFilters'] <> nil then
            for i := 0 to ItemNamed['EFilters'].Items.Count - 1 do
            begin
              setlength(EFilters,length(EFilters) + 1);
              EFilters[High(EFilters)] := ItemNamed['EFilters'].Items.Item[i].Value;
            end;
        end;
    end;
  except
  end;
  XML.Free;
end;

procedure Stop;
begin
  Classes.DeallocateHWnd(h);
  AE.Free;
  TSGUI.Free;
  TaskManager.Free;

  UnregisterActions;
  ClearActions;

  Filters.Free;
end;

function StartEx(owner: hwnd; pSkinInterface : ISharpESkin): hwnd;
begin
  Result := owner;

  SkinInterface := pSkinInterface;

  Filters := TFilterItemList.Create;
  Filters.Load;

  TaskManager := TTaskManager.Create;  
  TSGUI := TTSGUI.Create(SkinInterface);

  ae := TActionEvent.Create;
  h := Classes.Allocatehwnd(Ae.MessageHandler);

  LoadActionsFromXML;
  RegisterActions;
  ServiceDone('Task Switch');
end;

procedure TActionEvent.MessageHandler(var Message: TMessage);
var
  ms : TMemoryStream;
  cds : PCopyDataStruct;
begin
  if message.Msg = WM_COPYDATA then
  begin
    cds := PCopyDataStruct(message.lParam);
    if message.WParam = WM_REQUESTWNDLIST then
    begin
      MessageReceived := True;
      ms := TMemoryStream.Create;
      ms.Write(cds^.lpData^,cds^.cbData);
      ms.Position := 0;
      TaskManager.LoadFromStream(ms,cds.dwData);
      ms.Free;
      message.result := 1;
    end;
  end else
  if message.Msg = WM_SHARPEACTIONMESSAGE then
  begin
    if (Message.LParam >= 0) and (Message.LParam <= High(Actions)) then
      CycleWindows(Message.LParam);
  end else
  if Message.Msg = WM_SHARPEUPDATESETTINGS then
  begin
    if Message.WParam = Integer(suTaskFilter) then
      Filters.Load
    else if Message.WParam = Integer(suTaskFilterActions) then
    begin
      LoadActionsFromXML;
      RegisterActions;
    end;
  end else
  if Message.Msg = WM_SHARPEUPDATEACTIONS then
    RegisterActions
  else Message.Result := DefWindowProc(h,Message.Msg,Message.WParam,Message.LParam);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Task Switch';
    Description := 'Replaces the standard alt-tab dialog';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteService;
    ExtraData := 'priority: 150| delay: 0';
  end;
end;

exports
  StartEx,
  Stop,
  GetMetaData;

begin
end.


