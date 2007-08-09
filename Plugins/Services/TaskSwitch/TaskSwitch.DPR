{
Source Name: Switcher.dpr
Description: SystemTray service library file
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.SharpE-Shell.org

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
  Dialogs,
  uTaskSwitchGUI in 'uTaskSwitchGUI.pas',
  uTaskSwitchWnd in 'Forms\uTaskSwitchWnd.pas' {TaskSwitchWnd};

type
  TActionEvent = Class(Tobject)
  Procedure MessageHandler(var Message: TMessage);
  end;

  TTaskFilter = record
                  FilterStates : Set of Byte;
                  FilterClass : String;
                  FilterFile  : String;
                  FilterType  : integer;
                  FilterName  : String;
                end;

  TTaskAction = record
                  Name : String;
                  Action : String;
                  CForward : Boolean;
                  UseGUI   : Boolean; 
                  IFilters : array of String;
                  EFilters : array of String;
                end;

  THandleArray = array of hwnd;

var
  AE:TActionEvent;
  h:THandle;
  Filters : array of TTaskFilter;
  Actions : array of TTaskAction;


{$E ser}

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

function GetFilter(pName : String) : TTaskFilter;
var
  n : integer;
begin
  for n := 0 to High(Filters) do    
    if CompareText(Filters[n].FilterName,pName) = 0 then
    begin
      result := Filters[n];
      exit;
    end;
  result.FilterType := -1;
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

function CheckFilter(wnd : hwnd; TA : TTaskAction) : boolean;
var
  n : integer;
  R : TRect;
  Mon : TMonitor;
  nm : boolean;
  CF : TTaskFilter;
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
      case CF.FilterType of
        0: if WndShowCmd in CF.FilterStates then
              nm := True;
        1: if WndClassName = CF.FilterClass then
              nm := True;
        2: if WndFileName = CF.FilterFile then
              nm := True;
        3: begin
             Mon := Screen.MonitorFromWindow(wnd);
             GetWindowRect(wnd,R);
             if (PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-R.Top) div 2), Mon.BoundsRect))
                or (PointInRect(Point(R.Left, R.Top), Mon.BoundsRect))
                or (PointInRect(Point(R.Right, R.Bottom), Mon.BoundsRect)) then
                   nm := True
           end;
        4: begin
             Mon := Screen.MonitorFromWindow(wnd);
             GetWindowRect(wnd,R);
             if not (PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-R.Top) div 2), Mon.BoundsRect))
                and not (PointInRect(Point(R.Left, R.Top), Mon.BoundsRect))
                and not (PointInRect(Point(R.Right, R.Bottom), Mon.BoundsRect)) then
                   nm := True
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
      case CF.FilterType of
        0: if WndShowCmd in CF.FilterStates then result := false;
        1: if WndClassName = CF.FilterClass then result := false;
        2: if WndFileName = CF.FilterFile then result := false;
        3: begin
             Mon := Screen.MonitorFromWindow(wnd);
             GetWindowRect(wnd,R);
             if (PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-R.Top) div 2), Mon.BoundsRect))
                or (PointInRect(Point(R.Left, R.Top), Mon.BoundsRect))
                or (PointInRect(Point(R.Right, R.Bottom), Mon.BoundsRect)) then result := false;
           end;
        4: begin
             Mon := Screen.MonitorFromWindow(wnd);
             GetWindowRect(wnd,R);
             if not (PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-R.Top) div 2), Mon.BoundsRect))
                and not (PointInRect(Point(R.Left, R.Top), Mon.BoundsRect))
                and not (PointInRect(Point(R.Right, R.Bottom), Mon.BoundsRect)) then result := false;
           end;
      end;
    end;
  end;
end;

procedure CycleWindows(ActionIndex : integer);
type
  PParam = ^TParam;
  TParam = record
    wndlist: THandleArray;
    ac : TTaskAction;
  end;
var
  EnumParam : TParam;

  function EnumWindowsProc(Wnd: HWND; LParam: LPARAM): BOOL; stdcall;
  begin
    if (GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) and
       ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
       ((GetWindowLong(Wnd, GWL_HWNDPARENT) = 0) or
       (GetWindowLong(Wnd, GWL_HWNDPARENT) = GetDesktopWindow)) and
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0)) and
       (GetWindowLong(wnd, GWL_EXSTYLE) and WS_EX_TOPMOST = 0) then
       with PParam(LParam)^ do
       begin
         if CheckFilter(wnd,ac) then
         begin
           setlength(wndlist,length(wndlist)+1);
           wndlist[high(wndlist)] := wnd;
         end;
       end;
    result := True;
  end;

var
  wnd : hwnd;
  n : integer;

begin
  EnumParam.ac := Actions[ActionIndex];
  setlength(EnumParam.wndlist,0);
  //EnumWindows(@EnumWindowsProc, Integer(@EnumParam));
  wnd := GetTopWindow(0);//GetNextWindow(FindWindow('TSharpDeskMainForm',nil),GW_HWNDPREV);
  while wnd <> 0 do
  begin
    if (GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) and
       ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
       ((GetWindowLong(Wnd, GWL_HWNDPARENT) = 0) or
       (GetWindowLong(Wnd, GWL_HWNDPARENT) = GetDesktopWindow)) and
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0)) and
       (GetWindowLong(wnd, GWL_EXSTYLE) and WS_EX_TOPMOST = 0)  then
       with EnumParam do
       begin
         if CheckFilter(wnd,ac) then
         begin
           setlength(wndlist,length(wndlist)+1);
           wndlist[high(wndlist)] := wnd;
         end;
       end;
    wnd := GetNextWindow(wnd,GW_HWNDNEXT);           
  end;

  if length(EnumParam.wndlist) > 1 then
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
          TSGUI.wndlist[n] := wndlist[n];
        TSGUI.Index := 0;
        TSGUI.ShowWindow;
      end else
      begin
        // update the already existing gui
        if ac.CForward then TSGUI.Index := TSGUI.Index + 1
          else TSGUI.Index := TSGUI.Index - 1;
        TSGUI.UpdateHighlight;
      end;
    end else
    begin
      // life action
      if Actions[ActionIndex].CForward then
      begin
        if IsIconic(wndlist[1]) then
          ShowWindow(wndlist[1],SW_RESTORE)
          else
          begin
            ForceForegroundWindow(wndlist[1]);
            SetWindowPos(wndlist[0],wndlist[High(wndlist)],0,0,0,0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
          end;
      end else
      begin
        if IsIconic(wndlist[1]) then
          ShowWindow(wndlist[1],SW_RESTORE)
          else
          begin
            ForceForegroundWindow(wndlist[High(wndlist)]);
          end;
      end;
    end;
  end;

  setlength(EnumParam.wndlist,0);
end;

procedure LoadFilterFromXML(var filter : TTaskFilter; XML : TJvSimpleXMLElem);
var
  n : integer;
begin
  filter.FilterType := XML.Items.IntValue('FilterType',2);
  filter.FilterClass := XML.Items.Value('WndClassName');
  filter.FilterFile  := LowerCase(XML.Items.Value('FileName'));
  filter.FilterName := XML.Items.Value('Name','-1');
  filter.FilterStates := [];
  for n := 0 to 10 do
      if XML.Items.BoolValue('SW_'+inttostr(n),False) then filter.FilterStates := filter.FilterStates + [n];
end;

procedure LoadFilterSettingsFromXML;
var
  XML : TJvSimpleXML;
  i : integer;
  fn : string;
begin
  setlength(Filters,0);
  fn := SharpApi.GetSharpeGlobalSettingsPath + 'SharpBar\Module Settings\TaskBar\';
  fn := fn + 'Filters.xml';
  if not FileExists(fn) then
     exit;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(fn);
    for i := 0 to XML.Root.Items.Count - 1 do
    begin
      setlength(Filters,length(Filters)+1);
      LoadFilterFromXML(Filters[High(Filters)],XML.Root.Items.Item[i]);
    end;
  except
  end;
  XML.Free;
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
  DeallocateHWnd(h);
  AE.Free;
  TSGUI.Free;

  UnregisterActions;
  ClearActions;

  setlength(Filters,0);
end;

function Start(owner: hwnd): hwnd;
begin
  Result := owner;

  TSGUI := TTSGUI.Create;

  ae := TActionEvent.Create;
  h := allocatehwnd(Ae.MessageHandler);

  LoadFilterSettingsFromXML;
  LoadActionsFromXML;
  RegisterActions;
end;

procedure TActionEvent.MessageHandler(var Message: TMessage);
begin
  if message.Msg = WM_SHARPEACTIONMESSAGE then
  begin
    if (Message.LParam >= 0) and (Message.LParam <= High(Actions)) then
      CycleWindows(Message.LParam);    
  end;

  if Message.Msg = WM_SHARPEUPDATEACTIONS then
    RegisterActions;
end;

exports
  Start,
  Stop;

end.


