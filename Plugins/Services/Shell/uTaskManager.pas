{
Source Name: uTaskManager.pas
Description: TaskManager class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit uTaskManager;

interface

uses Windows,
     Messages,
     Classes,
     SysUtils,
     Contnrs,
     uTaskItem,
     SharpTypes,
     JclSysUtils,
     JclStrings;

type
  TTaskChangeEvent = procedure(pItem : TTaskItem; Index : integer) of object;
  TTaskExChangeEvent = procedure(pItem1,pItem2 : TTaskItem; I1,I2 : integer) of object;

  TTaskManager = class
                 protected
                 private
                   FEnabled        : Boolean;
                   FListMode       : Boolean;
                   FOnNewTask      : TTaskChangeEvent;
                   FOnRemoveTask   : TTaskChangeEvent;
                   FOnUpdateTask   : TTaskChangeEvent;
                   FOnActivateTask : TTaskChangeEvent;
                   FOnFlashTask    : TTaskChangeEvent;
                   FOnTaskExChange : TTaskExChangeEvent;
                   FItems          : TObjectList;
                   FSortTasks      : Boolean;
                   FSortType       : TSharpeTaskManagerSortType;
                   FLastActiveTask : hwnd;
                 public
                   procedure RemoveDeadTasks;
                   procedure AddTask(pHandle : hwnd);
                   procedure RemoveTask(pHandle : hwnd);
                   procedure UpdateTask(pHandle : hwnd);
                   procedure ActivateTask(pHandle : hwnd);
                   procedure FlashTask(pHandle : hwnd);
                   procedure GetMinRect;
                   procedure DoSortTasks;
                   procedure ExChangeTasks(pItem1,pItem2 : TTaskItem);
                   procedure ResetVMWs;
                   procedure CompleteRefresh;
                   procedure HandleShellMessage(wparam,lparam : Cardinal);
                   procedure SaveToStream(Stream : TStream);
                   procedure LoadFromStream(Stream : TStream; pCount : integer);
                   procedure InitList;                   
                   function GetCount : integer;
                   function GetItemByHandle(pHandle : hwnd) : TTaskItem;
                   function GetItemByIndex(Index : integer) : TTaskItem;
                   constructor Create; reintroduce;
                   destructor Destroy; override;

                   property Enabled        : boolean          read FEnabled write FEnabled;
                   property ListMode       : boolean          read FListMode write FListMode;
                   property SortTasks      : boolean          read FSortTasks write FSortTasks;
                   property SortType       : TSharpeTaskManagerSortType read FSortType write FSortType;
                   property OnNewTask      : TTaskChangeEvent read FOnNewTask write FOnNewTask;
                   property OnRemoveTask   : TTaskChangeEvent read FOnRemoveTask write FOnRemoveTask;
                   property OnUpdateTask   : TTaskChangeEvent read FOnUpdateTask write FOnUpdateTask;
                   property OnActivateTask : TTaskChangeEvent read FOnActivateTask write FOnActivateTask;
                   property OnFlashTask    : TTaskChangeEvent read FOnFlashTask write FOnFlashTask;
                   property OnTaskExchange : TTaskExChangeEvent read FOnTaskExChange write FOnTaskExChange;
                   property ItemCount      : integer          read GetCount;
                   property LastActiveTask : hwnd             read FLastActiveTask write FLastActiveTask;
                 end;

implementation

function GetWndClass(pHandle : hwnd) : String;
var
  buf: array [0..254] of Char;
begin
  GetClassName(pHandle, buf, SizeOf(buf));
  result := buf;
end;

constructor TTaskManager.Create;
begin
  inherited Create;
  FItems := TObjectList.Create(True);
  FItems.Clear;
  FSortTasks := False;
  FSortType  := stCaption;
  FLastActiveTask := 0;
  FEnabled := False;
  FListMode := False;
end;

destructor TTaskManager.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

function TTaskManager.GetCount : integer;
begin
  result := FItems.Count;
end;

function TTaskManager.GetItemByIndex(Index : integer) : TTaskItem;
begin
  result := nil;
  if (Index > FItems.Count - 1) or (Index < 0) then exit;
  try
    result := TTaskItem(FItems.Items[Index]);
  except
    result := nil;
  end;
end;


procedure TTaskManager.GetMinRect;
var
  pItem : TTaskItem;
  n : integer;
begin
  if FItems.Count = 0 then exit;
  if not FEnabled then exit;

  RemoveDeadTasks;
  for n := 0 to FItems.Count - 1 do
  begin
    pItem := TTaskItem(FItems.Items[n]);
    if pItem.Handle = FLastActiveTask then
    begin
      if not FListMode then
        pItem.UpdateFromHwnd
      else pItem.UpdateNonCriticalFromHwnd;
      if Assigned(FOnUpdateTask) then FOnUpdateTask(pItem,n);
    end;
  end;
  if FSortTasks then DoSortTasks;
end;

procedure TTaskManager.HandleShellMessage(wparam,lparam : Cardinal);
begin
 case WParam of
   HSHELL_WINDOWCREATED : AddTask(LParam);
   HSHELL_REDRAW : UpdateTask(LParam);
   HSHELL_REDRAW + 32768 : FlashTask(LParam);
   HSHELL_WINDOWDESTROYED : RemoveTask(LParam);
   HSHELL_WINDOWACTIVATED : ActivateTask(LParam);
   HSHELL_WINDOWACTIVATED + 32768 : ActivateTask(LParam);
   HSHELL_GETMINRECT      : GetMinRect;
  end;
end;

procedure TTaskManager.InitList;
type
  PParam = ^TParam;
  TParam = record
    wndlist: array of hwnd;
  end;
var
  EnumParam : TParam;
  n : integer;

  function EnumWindowsProc(Wnd: HWND; LParam: LPARAM): BOOL; stdcall;
  begin
    if ((GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) or
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_APPWINDOW <> 0)) and
       ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
       (GetWindowLong(Wnd, GWL_STYLE) and WS_CHILD = 0) and
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0))
       and ((GetWindowLong(Wnd, GWL_STYLE) and DS_3DLOOK = 0)
        and (GetWindowLong(Wnd, GWL_STYLE) and DS_FIXEDSYS = 0)
        or (GetWindowLong(Wnd, GWL_STYLE) and WS_VISIBLE <> 0)) then
      with PParam(LParam)^ do
      begin
       setlength(wndlist,length(wndlist)+1);
       wndlist[high(wndlist)] := wnd;
      end;
    result := True;
  end;
begin
  setlength(EnumParam.wndlist,0);
  EnumWindows(@EnumWindowsProc, Integer(@EnumParam));
  for n := 0 to High(EnumParam.wndlist) do
    AddTask(EnumParam.wndlist[n]);
  setlength(EnumParam.wndlist,0);
end;

procedure TTaskManager.LoadFromStream(Stream: TStream; pCount : integer);
var
  pItem : TTaskItem;
  n : integer;
  Handle : hwnd;
  TimeAdded : Int64;
  LastVWM : integer;
begin
  FItems.Clear;
  for n := 0 to pCount - 1 do
  begin
    Stream.ReadBuffer(Handle,sizeof(Handle));
    Stream.ReadBuffer(TimeAdded,sizeof(TimeAdded));
    Stream.ReadBuffer(LastVWM,sizeof(LastVWM));
    if GetItemByHandle(Handle) = nil then
    begin
      pItem := TTaskItem.Create(Handle,FListMode);
      pItem.TimeAdded := TimeAdded;
      pItem.LastVWM := LastVWM;
      FITems.Add(pItem);
    end;
  end;
end;

procedure TTaskManager.RemoveDeadTasks;
var
  n : integer;
  pItem : TTaskItem;
begin
  if FItems.Count = 0 then exit;

  for n := FItems.Count - 1 downto 0 do
  begin
    pItem := TTaskItem(FItems.Items[n]);
    if (not IsWindow(pItem.Handle)) then
    begin
      FItems.Extract(pItem);
      if Assigned(OnRemoveTask) then OnRemoveTask(pItem,n);
      pItem.Free;
    end;
  end;
end;

procedure TTaskManager.FlashTask(pHandle : hwnd);
var
  pItem : TTaskItem;
  n : integer;
begin
  if FItems.Count = 0 then exit;
  if not FEnabled then exit;

  RemoveDeadTasks;
  for n := 0 to FItems.Count -1 do
  begin
    pItem := TTaskItem(FItems.Items[n]);
    if pItem.Handle = pHandle then
    begin
      if Assigned(OnFlashTask) then FOnFlashTask(pItem,n);
      exit;
    end;
  end;
end;

procedure TTaskManager.ActivateTask(pHandle : hwnd);
var
  pItem : TTaskItem;
  n : integer;
  wndclass : String;
begin
  if not FEnabled then exit;

  RemoveDeadTasks;
  if FItems.Count > 0 then
    for n := 0 to FItems.Count -1 do
    begin
      pItem := TTaskItem(FItems.Items[n]);
      if pItem.Handle = pHandle then
      begin
        FLastActiveTask := pHandle;
        if not FListMode then        
          pItem.UpdateFromHwnd
        else pItem.UpdateNonCriticalFromHwnd;
        if Assigned(OnActivateTask) then FOnActivateTask(pItem,n);
        exit;
      end;
    end;

  // Windows which don't send a NewTask message will be added when they
  // send an activate message
  wndclass := GetWndClass(pHandle);
  if (CompareText(wndclass,'ConsoleWindowClass') = 0) // cmd.exe
    or (CompareText(wndclass,'PuTTYConfigBox') = 0) then // Putty.exe
  begin
     FLastActiveTask := pHandle;
     AddTask(pHandle)
  end else// Task wasn found, remove focus from any activated task
   if Assigned(OnActivateTask) then FOnActivateTask(nil,-1);
end;


procedure TTaskManager.CompleteRefresh;
var
  n : integer;
  pItem : TTaskItem;
begin
  if FItems.Count = 0 then exit;
  if not Assigned(FOnNewTask) then exit;

  for n := 0 to FItems.Count - 1 do
  begin
    if n <= FItems.Count - 1 then
    begin
      pItem := TTaskItem(FItems.Items[n]);
      FOnNewTask(pItem,n);
    end;
  end;
end;

procedure TTaskManager.AddTask(pHandle : hwnd);
var
  pItem : TTaskItem;
begin
  if not FEnabled then exit;

  RemoveDeadTasks;
  if not IsWindow(pHandle) then exit;
  if GetItemByHandle(pHandle) <> nil then exit; // item already exists
  pItem := TTaskItem.Create(pHandle,FListMode);
  if not FListMode then 
    pItem.UpdateCaption;
  FItems.Add(pItem);
  if Assigned(OnNewTask) then FOnNewTask(pItem, FItems.Count -1);
  if FSortTasks then DoSortTasks;
end;

procedure TTaskManager.RemoveTask(pHandle : hwnd);
var
  pItem : TTaskItem;
  n : integer;
begin
  if FItems.Count = 0 then exit;
  if not FEnabled then exit;

  for n := FItems.Count - 1 downto 0 do
  begin
    pItem := TTaskItem(FItems.Items[n]);
    if pItem.Handle = pHandle then
    begin
      // call the onremove event before actually removing the item
      // this makes it possible for the application to use the still existing
      // TTaskItem to gather informations about which window will be removed
      FItems.Extract(pItem);
      if Assigned(OnRemoveTask) then OnRemoveTask(pItem,n);
      pItem.Free;
      exit;
    end;
  end;
  RemoveDeadTasks;
end;

procedure TTaskManager.ResetVMWs;
var
  n : integer;
  pItem : TTaskItem;
begin
  if FItems.Count = 0 then exit;

  for n := FItems.Count - 1 downto 0 do
  begin
    pItem := TTaskItem(FItems.Items[n]);
    pItem.LastVWM := 1;
  end;
end;

procedure TTaskManager.SaveToStream(Stream: TStream);
var
  pItem : TTaskItem;
  n : integer;
begin
  for n := 0 to FItems.Count - 1 do
  begin
    pItem := TTaskItem(FItems.Items[n]);
    Stream.WriteBuffer(pItem.Handle,sizeof(pItem.Handle));
    Stream.WriteBuffer(pItem.TimeAdded,sizeof(pItem.TimeAdded));
    Stream.WriteBuffer(pItem.LastVWM,sizeof(pItem.LastVWM));
  end;
end;

procedure TTaskManager.UpdateTask(pHandle : hwnd);
var
  pItem : TTaskItem;
  n : integer;
begin
  if FItems.Count = 0 then exit;
  if not FEnabled then exit;

  RemoveDeadTasks;
  for n := 0 to FItems.Count - 1 do
  begin
    pItem := TTaskItem(FItems.Items[n]);
    if pItem.Handle = pHandle then
    begin
      if not FListMode then     
        pItem.UpdateFromHwnd
      else pItem.UpdateNonCriticalFromHwnd;
      if FSortTasks then DoSortTasks;      
      if Assigned(FOnUpdateTask) then FOnUpdateTask(pItem,n);
    end;
  end;
end;

function TTaskManager.GetItemByHandle(pHandle : hwnd) : TTaskItem;
var
  n : integer;
  pItem : TTaskItem;
begin
  if FItems.Count > 0 then
    for n := 0 to FItems.Count - 1 do
    begin
      pItem := TTaskItem(FItems.Items[n]);
      if pItem.Handle = pHandle then
      begin
        result := pItem;
        exit;
      end;
    end;
  result := nil;
end;

procedure TTaskManager.ExChangeTasks(pItem1,pItem2 : TTaskItem);
var
  n,i : integer;
begin
  if pItem1 = pItem2 then exit;
  n := FItems.IndexOf(pItem1);
  i := FItems.IndexOf(pItem2);
  if (n < 0) or (i < 0) then exit;
  if Assigned(FOnTaskExchange) then FOnTaskExchange(pItem1,pItem2,n,i);
  FItems.Exchange(n,i);
end;

procedure TTaskManager.DoSortTasks;
var
  pItem1,pItem2 : TTaskItem;
  n,i,c : integer;
  SList : TStringList;
  fixedcaption : String;
begin
  if FListMode then exit;
  if FItems.Count = 0 then exit;

  case FSortType of
    stCaption,stWndClass,stTime,stIcon:
      begin
        SList := TStringList.Create;
        SList.Clear;
        for n := 0 to FItems.Count - 1 do
        begin
          pItem1 := TTaskItem(FItems.Items[n]);
          if pItem1.Used then
          begin
            if FSortType = stCaption then
              fixedcaption := StrReplaceChar(pItem1.Caption,'=','-');
            case FSortType of
              stCaption:  SList.Add(fixedcaption+'='+inttostr(pItem1.Handle));
              stWndClass: SList.Add(pItem1.WndClass+'='+inttostr(pItem1.Handle));
              stTime:     SList.Add(inttostr(pItem1.TimeAdded)+'='+inttostr(pItem1.Handle));
              stIcon:     SList.AdD(inttostr(pItem1.Icon)+'='+inttostr(pItem1.Handle));
            end;
          end;
        end;
        SList.Sort;
        for n := 0 to SList.Count - 1 do
        begin
          pItem1 := GetItemByHandle(StrToInt64Def(SList.ValueFromIndex[n],-1));
          pItem2 := nil;
          c := - 1;
          for i := 0 to FItems.Count - 1 do
          begin
            if TTaskItem(FITems.Items[i]).Used then
              c := c + 1;
            if c = n then
            begin
              pItem2 := TTaskItem(FItems.Items[i]);
              break;
            end;
          end;

          if (pItem1 <> nil) and (pItem2 <> nil) then
            ExChangeTasks(pItem2,pItem1);
        end;
        SList.Free;
      end;
    end;
end;

end.
