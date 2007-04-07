{
Source Name: TrayManager.pas
Description: TrayManager class
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpe-shell.org

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

unit TrayManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Contnrs, SharpApi, DateUtils, 
  winver,declaration;

type
  TTrayIcon = class
  private
  public
    data : TNotifyIconDataV6;
    hidden : boolean;
    shared : boolean;
    valid  : boolean;
    orig_icon : hicon;
    display : TTrayIcon;
  end;

  TTrayMessageWnd = class(TForm)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
  private
    FWndList : TStringList;
    FWarmup : boolean;
    FWarmupstart : int64;
    function FindTrayIcon(pData : TNotifyIconDataV6) : TTrayIcon;
    procedure ResetIcon(pItem : TTrayIcon);
    procedure ResetSharing(pItem : TTrayIcon);
    procedure RemoveTrayIcon(pItem : TTrayIcon);
    procedure ModifyTrayIcon(pItem : TTrayIcon; pData : TNotifyIconDataV6; Hidden,Shared,AM : boolean);
    procedure CheckForDeadIcons;
    procedure IncomingTrayMsg(var Msg: TMessage); message WM_COPYDATA;
    procedure IncomingRegisterMessage(var Msg: TMessage); message WM_REGISTERWITHTRAY;
    procedure IncomingUnregisterMessage(var Msg: TMessage); message WM_UNREGISTERWITHTRAY;
    procedure BroadCastTrayMessage(pItem: TTrayIcon; action : integer);
    procedure BroadCastAllToOne(wnd : hwnd);
  public
    FIcons : TObjectList;
  end;

var
  TrayMessageWnd: TTrayMessageWnd;

implementation

{$R *.dfm}

function SendMiniConsoleMsg(msg: pChar): hresult;
type 
  PConsoleMsg = ^TConsoleMsg;
  TConsoleMsg = record
    module: string[255];
    msg: string[255];
  end;
var
  wnd: hwnd;
  cds: TCopyDataStruct;
  cmsg: TConsoleMsg;
begin
  try
    cmsg.msg := msg;
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TConsoleMsg);
      lpData := @cmsg;
    end;

    wnd := FindWindow('TMiniConsoleWnd', nil);
    if wnd <> 0 then
    begin
      SendMessage(wnd, WM_COPYDATA, 0, cardinal(@cds));
      Result := HR_OK;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

procedure TTrayMessageWnd.CreateParams(var Params: TCreateParams);
begin
  //The secret of a traymanager, Use "Shell_TrayWnd" as WinClassName
  try
    inherited;// CreateParams(Params);
    with Params do
    begin
      Params.WinClassName := 'Shell_TrayWnd';
      ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
      Style := WS_POPUP or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
    end;
  except
  end;
end;

procedure TTrayMessageWnd.IncomingRegisterMessage(var Msg: TMessage);
begin
  if FWndList.IndexOf(inttostr(msg.WParam)) = -1 then
  begin
    FWndList.Add(inttostr(msg.WParam));
    // Broadcast all icons to the new tray client
    BroadCastAllToOne(msg.WParam);
    // make all non shell service icons to update
    PostMessage(HWND_BROADCAST, RegisterWindowMessage('TaskbarCreated'), 0, 0);
  end;
end;

procedure TTrayMessageWnd.IncomingUnregisterMessage(var Msg: TMessage);
var
  n : integer;
begin
  n := FWndList.IndexOf(inttostr(msg.WParam));
  if n > 0 then FWndList.Delete(n);
end;

procedure TTrayMessageWnd.CheckForDeadIcons;
var
  pItem : TTrayIcon;
  n : integer;
begin
  if FIcons.Count = 0 then exit;

  for n := FIcons.Count - 1 downto 0 do
  begin
    pItem := TTrayIcon(FIcons.Items[n]);
    if not IsWindow(pItem.data.Wnd) then
    begin
      BroadCastTrayMessage(pItem,2);
      reseticon(pItem);
      FIcons.Remove(pItem);
    end;
  end;
end;

procedure TTrayMessageWnd.BroadCastAllToOne(wnd : hwnd);
var
  n : integer;
  cds: TCopyDataStruct;
  pItem : TTrayIcon;
begin
  if not IsWindow(wnd) then exit;

  CheckForDeadIcons;

  if FIcons.Count = 0 then exit;

  for n := 0 to FIcons.Count -1 do
  begin
    pItem := TTrayIcon(FIcons.Items[n]);
    if pItem.valid then
    begin
      with cds do
      begin
        dwData := 1;
        cbData := SizeOf(TNotifyIconDataV6);
        lpData := @pItem.data;
      end;
    end;

    // forward the tray message
    SendMessage(wnd,WM_COPYDATA,0,Cardinal(@cds));
  end;
end;

procedure TTrayMessageWnd.BroadCastTrayMessage(pItem: TTrayIcon; action : integer);
var
  n : integer;
  wnd : hwnd;
  cds: TCopyDataStruct;
begin
  // no tray registered -> exit
  if FWndList.Count = 0 then exit;

  n := FWndList.Count -1;
  while n>=0 do
  begin
    try
      wnd := strtoint(FWndList[n]);
    except
      wnd := 0;
    end;

    // window doesn't exist anymore -> delete it
    if not IsWindow(wnd) then
    begin
      FWndList.Delete(n);
      n := n - 1;
      Continue;
    end;

    with cds do
    begin
      // action:
      // 1 = add/modify
      // 2 = delete
      dwData := action;
      cbData := SizeOf(TNotifyIconDataV6);
      lpData := @pItem.data;
    end;

    // forward the tray message
    SendMessage(wnd,WM_COPYDATA,0,Cardinal(@cds));
    n := n -1;
  end;
end;

procedure TTrayMessageWnd.FormCreate(Sender: TObject);
begin
  FWarmup := False;
  FWarmupstart := DateTimeToUnix(Now);

  FIcons := TObjectList.Create;
  FIcons.OwnsObjects := True;
  FIcons.Clear;
  FWndList := TStringList.Create;
  FWndList.Duplicates := dupIgnore;
  FWndList.Clear;

  left := -200;
  top := -200;
  Width := 1;
  Height := 1;
  Setwindowlong(handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
  PostMessage(HWND_BROADCAST, RegisterWindowMessage('TaskbarCreated'), 0, 0);
end;

procedure TTrayMessageWnd.ResetIcon(pItem : TTrayIcon);
begin
  if ((not pItem.shared) and (pItem.Data.Icon <> 0)) then
     DestroyIcon(pItem.data.Icon);
     
  pItem.display := nil;
  pItem.orig_icon := 0;
  pItem.data.Icon := 0;
  pItem.valid := False;
end;

procedure TTrayMessageWnd.ResetSharing(pItem : TTrayIcon);
var
  n : integer;
  tempItem : TTrayIcon;
begin
  for n := 0 to FIcons.Count - 1 do
  begin
    tempItem := TTrayIcon(FIcons.Items[n]);
    if tempItem.display = pItem then
       resetIcon(tempItem);
  end;
end;

function TTrayMessageWnd.FindTrayIcon(pData : TNotifyIconDataV6) : TTrayIcon;
var
  n : integer;
  pItem : TTrayIcon;
begin
  for n := 0 to FIcons.Count - 1 do
  begin
    pItem := TTrayIcon(FIcons.Items[n]);
    if (pItem.data.Wnd = pData.Wnd) and
       (pItem.data.uID = pData.uID) then
    begin
      result := pItem;
      exit;
    end;
  end;
  result := nil;
end;

procedure TTrayMessageWnd.RemoveTrayIcon(pItem : TTrayIcon);
begin
  if pItem.valid then
  begin
    BroadCastTrayMessage(pItem,2);
  end;

  if pItem.hidden then
     resetsharing(pItem);

  reseticon(pItem);
  FIcons.Extract(pItem);
  pItem.Free;
end;

procedure TTrayMessageWnd.ModifyTrayIcon(pItem : TTrayIcon; pData : TNotifyIconDataV6; Hidden,Shared,AM : boolean);
var
  msg : String;
  n : integer;
  tempItem : TTrayIcon;
  foundshared : boolean;
begin
  msg := 'TRAYICON_MODIFIED';
  if (pItem = nil) and ((AM=False) and Shared) then exit;

  if pItem = nil then
  begin
    if AM = False then exit;
    pItem := TTrayIcon.Create;
    pItem.data.Wnd := pData.Wnd;
    pItem.data.uID := pdata.uID;
    FIcons.Add(pItem);
    msg := 'TRAYICON_ADDED';
  end;
  pItem.data.uFlags := pData.uFlags;
  pItem.data.cbSize := pData.cbSize;

  if (pData.uFlags and NIF_MESSAGE) = NIF_MESSAGE then
     pItem.data.uCallbackMessage := pData.uCallbackMessage;

  if (pData.uFlags and NIF_TIP) = NIF_TIP then
  begin
    pItem.data.szTip := pData.szTip;
  end else
  if (pData.uFlags and NIF_INFO) = NIF_INFO then
  begin
    pItem.data.szInfo := pData.szInfo;
    pItem.data.szInfoTitle := pData.szInfoTitle;
    pItem.data.dwInfoFlags := pData.dwInfoFlags;
  end;
  pItem.data.Union.uTimeout := pData.Union.uTimeout;
  pItem.data.Union.uVersion := pData.Union.uVersion;

  foundshared := False;
  if (pData.uFlags and NIF_ICON) = NIF_ICON then
  begin
    ResetIcon(pItem);
    if pData.Icon <> 0 then
    begin
      if Shared then
      begin
     //     pItem.shared := True;
        for n := FIcons.Count - 1 downto 0  do
        begin
          tempItem := TTrayIcon(FIcons.Items[n]);
          if (tempItem <> pItem) and
             (tempItem.hidden) and
             (not tempItem.shared) and
             (tempItem.data.Wnd = pData.Wnd) and
             (tempItem.orig_icon = pData.Icon) and
             (tempItem.data.Icon <> 0) then
          begin
            ResetSharing(tempItem);
            pItem.display := tempItem;
            pItem.data.Icon := tempItem.data.Icon;
            pItem.shared := True;
            foundshared := true;
            break;
          end;
        end;
      end;
      if not foundshared then
      begin
        pItem.data.Icon := CopyIcon(pData.Icon);
        pItem.shared := False;
      end;
      pItem.orig_icon := pData.Icon;
      pItem.hidden := hidden;
      if hidden = false then pItem.valid := true
         else pItem.valid := false;
    end;

{    if pItem.data.Icon = 0 then
    begin
      RemoveTrayIcon(pItem);
      exit;
    end;}
  end;

  if pItem.valid then
     BroadCastTrayMessage(pItem,1)
     else BroadCastTrayMessage(pItem,2);
end;

procedure TTrayMessageWnd.IncomingTrayMsg(var Msg: TMessage);
var
  TrayCmd: integer;
  Icondata: TNotifyIconDataV6;
  data: pCopyDataStruct;
  hidden : boolean;
  shared : boolean;
  state  : integer;
  statemask : integer;
  pItem : TTrayIcon;
  s1,s2,s3,s4,s5,s6,s7,s8,s9 : string;
  e : boolean;
begin
  try
    Data := pCopyDataStruct(Msg.LParam);
    if Data.dwData = 1 then
    begin
    
      if FWarmup then
      begin
        if DateTimeToUnix(Now) - FWarmupStart > 5 then
           FWarmup := False
        else
        begin
          msg.result := 0;
          exit;
        end;
      end;

      TrayCmd := pINT(PCHAR(Data.lpdata) + 4)^;
      Icondata := pNotifyIconDataV6(PCHAR(Data.lpdata) + 8)^;
      hidden := false;
      shared := false;
      state := 0;
      statemask := 0;
      if (IconData.uFlags and NIF_STATE) = NIF_STATE then
      begin
        state := IconData.dwState;
        statemask := IconData.dwStateMask;


        if (state and statemask and NIS_HIDDEN) <> 0 then
           hidden := True;
        if (statemask and state and NIS_SHAREDICON) <> 0 then
           shared := True;
      end;

      pItem := FindTrayIcon(IconData);

      s1 := inttostr(state);
      s2 := inttostr(statemask);
      s3 := IconData.szTip;
      s7 := IconData.szInfoTitle;
      s5 := BoolToStr(hidden);
      s6 := BoolToStr(shared);
      s8 := 'Wnd: ' + inttostr(IconData.Wnd) + ' | uID' + inttostr(IconData.uID);
      if pItem = nil then s9 := 'nil'
         else s9 := inttostr(pItem.data.uid);
      case TrayCmd of
        NIM_ADD: s4:= 'ADD';
        NIM_MODIFY: s4 := 'MODIFY';
        NIM_DELETE: s4 := 'DELETE';
        NIM_SETFOCUS : s4 := 'SETFOCUS';
        NIM_SETVERSION : s4 := 'SETVERSION';
      end;
      if (s3 <> 'Kerio Personal Firewall - Aktiviert') and (IconData.Wnd <> 0) then
      SendMiniConsoleMsg(PChar('TRAY: ' + 'State: ' + s1 +
                                       ' | statemask: ' +  s2 +
                                       ' | Cmd: ' + s4 +
                                       ' | Hidden: ' + s5 +
                                       ' | Shared: ' + s6 +
                                       ' | Title: ' + s3+IconData.szInfoTitle+
                                       ' | Callback: ' + inttostr(IconData.uCallbackMessage)+
                                       ' | Version: ' + inttostr(IconData.Union.uVersion)+
                                       ' | ' + s8+
                                       ' | pItem:' + s9 ));

      // Network Icons fix
      // ~~~~~~~~~~~~~~~~~
      // having a W-LAN looking for a connection at the time the shell services
      // are started is making windows to send an ADD message for two shared icons
      // one with ID 0 and ID 1... the funny thing is that you are only
      // supposed to have the icon with ID 1 and you are only receiving a DELETE
      // message for the Icon with ID 1 later... so we have to make sure to
      // delete the Icon with ID 0 when the second icon is added...
   {   if (IconData.uID = 1) and (Shared) then
      begin
        for n := 0 to FIcons.Count - 1 do
        begin
          tempItem := TTrayIcon(FIcons.Items[n]);
          if (tempItem.data.Wnd = IconData.Wnd) and
             (tempItem.data.uID = 0) then
          begin
            self.RemoveTrayIcon(tempItem);
            break;
          end;
        end;
      end;  }
      e := True;

      if (IconData.uID = 1) and (Shared) then e := False;

      if e then
      begin
        case TrayCmd of
          NIM_ADD: begin
                     if hidden then e := False
                        else if pItem = nil then ModifyTrayIcon(pItem,IconData,False,False,True)
                        else e := False;
                   end;
          NIM_MODIFY,NIM_SETVERSION: begin
                        if (pItem = nil) and (IconData.Icon <> 0) and (not shared) and
                           ((IconData.uFlags and NIF_ICON) = NIF_ICON) and
                           ((IconData.uFlags and NIF_MESSAGE) = NIF_MESSAGE) and
                           ((IconData.uFlags and NIF_TIP) = NIF_TIP) then
                           ModifyTrayIcon(pItem,IconData,False,False,True)
                           else if (hidden) and (pItem<>nil) then RemoveTrayIcon(pItem)
                           else if (pItem <> nil) then ModifyTrayIcon(pItem,IconData,False,False,True)
                           else e := False;
                      end;
         NIM_DELETE: begin
                        if (pItem <> nil) then RemoveTrayIcon(pItem)
                            else e := False;
                      end;
        end;
      end;
      if e then msg.Result := -1
         else msg.Result := 0;
    end else msg.Result := DefWindowProc(Handle, Msg.Msg, Msg.WParam, Msg.LParam);
  except
    msg.Result := DefWindowProc(Handle, Msg.Msg, Msg.WParam, Msg.LParam);
  end;
end;

procedure TTrayMessageWnd.FormDestroy(Sender: TObject);
begin
  FWndList.Free;
  FWndList := nil;
  FIcons.Clear;
  FIcons.Free;
end;

end.
