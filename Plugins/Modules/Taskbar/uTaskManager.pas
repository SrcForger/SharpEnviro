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
     Classes,
     SysUtils,
     Contnrs,
     Dialogs,
     uTaskItem,
     JclSysUtils,
     JclStrings;

type
  TTaskChangeEvent = procedure(pItem : TTaskItem; Index : integer) of object;
  TTaskExChangeEvent = procedure(pItem1,pItem2 : TTaskItem; I1,I2 : integer) of object;

  TSortType = (stCaption,stWndClass,stTime,stIcon);

  TTaskManager = class
                 protected
                 private
                   FEnabled        : Boolean;
                   FOnNewTask      : TTaskChangeEvent;
                   FOnRemoveTask   : TTaskChangeEvent;
                   FOnUpdateTask   : TTaskChangeEvent;
                   FOnActivateTask : TTaskChangeEvent;
                   FOnFlashTask    : TTaskChangeEvent;
                   FOnTaskExChange : TTaskExChangeEvent;
                   FItems          : TObjectList;
                   FSortTasks      : Boolean;
                   FSortType       : TSortType;
                   FLastActiveTask : hwnd;
                 public
                   procedure RemoveDeadTasks;
                   procedure AddTask(pHandle : hwnd);
                   procedure RemoveTask(pHandle : hwnd);
                   procedure UpdateTask(pHandle : hwnd);
                   procedure ActivateTask(pHandle : hwnd);
                   procedure FlashTask(pHandle : hwnd);
                   procedure DoSortTasks;
                   procedure ExChangeTasks(pItem1,pItem2 : TTaskItem);
                   procedure CompleteRefresh;
                   function GetCount : integer;
                   function GetItemByHandle(pHandle : hwnd) : TTaskItem;
                   function GetItemByIndex(Index : integer) : TTaskItem;
                   constructor Create; reintroduce;
                   destructor Destroy; override;

                   property Enabled        : boolean          read FEnabled write FEnabled;
                   property SortTasks      : boolean          read FSortTasks write FSortTasks;
                   property SortType       : TSortType        read FSortType write FSortType;
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
  FEnabled := False;
  FItems := TObjectList.Create;
  FItems.Clear;
  FSortTasks := True;
  FSortType  := stCaption;
  FLastActiveTask := 0;
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


procedure TTaskManager.RemoveDeadTasks;
var
  n : integer;
  pItem : TTaskItem;
  visible,minimized : boolean;
begin
  if FItems.Count = 0 then exit;

  for n := FItems.Count - 1 downto 0 do
  begin
    pItem := TTaskItem(FItems.Items[n]);
    visible := (GetWindowLong(pItem.Handle, GWL_STYLE) and WS_VISIBLE) = WS_VISIBLE;
    minimized := ((GetWindowLong(pItem.Handle, GWL_STYLE) and WS_MINIMIZE) = WS_MINIMIZE) or (IsIconic(pItem.Handle));
    if (not IsWindow(pItem.Handle)) or
       ((not visible) and (not minimized)) then
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
        pItem.UpdateFromHwnd;
        if Assigned(OnActivateTask) then FOnActivateTask(pItem,n);
        exit;
      end;
    end;

  // Windows which don't send a NewTask message will be added when they
  // send an activate message
  wndclass := GetWndClass(pHandle);
  if CompareText(wndclass,'ConsoleWindowClass') = 0 then  // cmd.exe
     AddTask(pHandle)
     else// Task wasn found, remove focus from any activated task
     if Assigned(OnActivateTask) then FOnActivateTask(nil,-1);
end;


procedure TTaskManager.CompleteRefresh;
var
  n : integer;
  pItem : TTaskItem;
begin
  if FItems.Count = 0 then exit;
  if not Assigned(FOnNewTask) then exit;

  for n := 0 to FItems.Count -1 do
  begin
    pItem := TTaskItem(FItems.Items[n]);
    FOnNewTask(pItem,n);
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
  pItem := TTaskItem.Create(pHandle);
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
      pItem.UpdateFromHwnd;
      if Assigned(FOnUpdateTask) then FOnUpdateTask(pItem,n);
    end;
  end;
  if FSortTasks then DoSortTasks;
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
  pItem1 : TTaskItem;
  n : integer;
  SList : TStringList;
  fixedcaption : String;
begin
  if FItems.Count = 0 then exit;

  case FSortType of
    stCaption,stWndClass,stTime,stIcon:
      begin
        SList := TStringList.Create;
        SList.Clear;
        for n := 0 to FItems.Count - 1 do
        begin
          pItem1 := TTaskItem(FItems.Items[n]);
          if FSortType = stCaption then fixedcaption := StrReplaceChar(pItem1.Caption,'=','-');
          case FSortType of
            stCaption:  SList.Add(fixedcaption+'='+inttostr(pItem1.Handle));
            stWndClass: SList.Add(pItem1.WndClass+'='+inttostr(pItem1.Handle));
            stTime:     SList.Add(inttostr(pItem1.TimeAdded)+'='+inttostr(pItem1.Handle));
            stIcon:     SList.AdD(inttostr(pItem1.Icon)+'='+inttostr(pItem1.Handle));
          end;
        end;
        SList.Sort;
        for n := 0 to SList.Count - 1 do
        begin
          pItem1 := GetItemByHandle(StrToInt64Def(SList.ValueFromIndex[n],-1));
          if pItem1 <> nil then
          begin
            ExChangeTasks(TTaskItem(FItems.Items[n]),pItem1);
          end;
        end;
        SList.Free;
      end;
    end;
end;

end.
