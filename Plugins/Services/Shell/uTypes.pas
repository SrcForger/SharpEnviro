{
Source Name: declaration
Description: Tray constants
Copyright (C) Malx (Malx@techie.com)

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
unit uTypes;

interface

uses
  Windows,
  commctrl;

{
Informations on the whole structure and handling of the Shell_NotifyIcon
messgages (flags, etc.) can be found here:
http://msdn.microsoft.com/en-us/library/ms538121.aspx
http://msdn.microsoft.com/en-us/library/bb762159.aspx
}

type
  ArrayWideChar64 = array[0..63] of WideChar;
  ArrayWideChar256 = array[0..255] of WideChar;
  ArrayWideChar128 = array[0..127] of WideChar;
  ArrayWideChar = array[0..127] of WideChar; //<5 gives [0..64]

  pDispInfo = ^tagNMTTDISPINFO;

  TAppBarDataV2 = record
    cbSize : DWord;
    Wnd : HWND;
    uCallBackMessage : UINT;
    uEdge : UINT;
    rc : TRECT;
    lparam : LPARAM;
    dw64BitAlign : DWORD;
  end;

  TAppBarDataV1 = record
    cbSize : DWord;
    Wnd : HWND;
    uCallBackMessage : UINT;
    uEdge : UINT;
    rc : TRECT;
    lparam : LPARAM;
  end;

  pAppBarDataV2 = ^TAppBarDataV2;  
  pAppBarDataV1 = ^TAppBarDataV1;

  TAppBarMsgDataV2 = record
    abd : TAppBarDataV2;
    dwMessage : DWORD;
    hSharedMemory : HWND;
    dwSourceProcessID : DWORD;
    dw64BitAlign : DWORD;
  end;

  TAppBarMsgDataV1 = record
    abd : TAppBarDataV1;
    dwMessage : DWORD;
    hSharedMemory : HWND;
    dwSourceProcessID : DWORD;
  end;

  pAppBarMsgDataV2 = ^TAppBarMsgDataV2;
  pAppBarMsgDataV1 = ^TAppBarMsgDataV1;


  TNotifyIconIdentifierMsg = record
    dwMagic : DWORD;
    dwMessage : DWORD;
    cbSize : DWORD;
    cbPadding : DWORD;
    Wnd : HWND;
    uID : UINT;
    guidItem: TGUID;
  end;

  pNotifyIconIdentifierMsg = ^TNotifyIconIdentifierMsg;

  TNotifyIconDataV7 = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    Icon: HICON;
    szTip: ArrayWideChar128; //<5 gives [0..64]
    //Version 5
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: ArrayWideChar256;

    //This two below should be Uninon?
    Union: record
      case Integer of
        0: (uTimeout: UINT);
        1: (uVersion: UINT);
    end;

    szInfoTitle: ArrayWideChar64;
    dwInfoFlags: DWORD;
    // Windows 7 only
    guidItem: TGUID;
    // Vista and higher
    hBalloonIcon : HICON;
  end;

  TNotifyIconDataV6 = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    Icon: HICON;
    szTip: ArrayWideChar128; //<5 gives [0..64]
    //Version 5
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: ArrayWideChar256;

    //This two below should be Uninon?
    Union: record
      case Integer of
        0: (uTimeout: UINT);
        1: (uVersion: UINT);
    end;

    szInfoTitle: ArrayWideChar64;
    dwInfoFlags: DWORD;
    //Version 6
    guidItem: TGUID;
  end;

  TNotifyIconDataV5 = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    Icon: HICON;
    szTip: array[0..127] of WideChar; //<5 gives [0..64]
    //Version 5
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..255] of WideChar;

    //This two below should be Uninon?
    Union: record
      case Integer of
        0: (uTimeout: UINT);
        1: (uVersion: UINT);
    end;

    szInfoTitle: array[0..63] of WideChar;
    dwInfoFlags: DWORD;
  end;

  TNotifyIconDataV4 = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    Icon: HICON;
    szTip: array[0..63] of WideChar;
  end;

  pNotifyIconDataV7 = ^TNotifyIconDataV7;
  pNotifyIconDataV6 = ^TNotifyIconDataV6;
  pNotifyIconDataV5 = ^TNotifyIconDataV5;
  pNotifyIconDataV4 = ^TNotifyIconDataV4;

  pList = ^List;
  List = record
    tipId: LongInt;
    uIdAsInt: Integer;
    visible: Boolean;
    shared: Boolean;
    data: TNotifyIconDataV6;
    next: pList;
  end;

  invisibleList = ^invList;
  invList = record
    name, wndclass: string[100];
    altid: integer;
    next: invisibleList;
  end;
  Tinv = record
    name, wndclass: string[100];
    id: integer;
  end;
  TinvFile = file of Tinv;

const
  ABM_SETSTATE = 10; 

  SH_APPBAR_DATA     = 0;
  SH_TRAY_DATA       = 1;
  SH_LOADPROC_DATA   = 2;
  SH_ICON_IDENTIFIER = 3;

  NOTIFYICON_VERSION = 3;
  NOTIFYICON_VERSION_4 = 4;

  //version >= 5.00
  NIN_SELECT = ($0400 + 0);
  NINF_KEY = $1;
  NIN_KEYSELECT = (NIN_SELECT or NINF_KEY);
  //version >= 5.01
  NIN_BALLOONSHOW = $0400 + 2;
  NIN_BALLOONHIDE = $0400 + 3;
  NIN_BALLOONTIMEOUT = $0400 + 4;
  NIN_BALLOONUSERCLICK = $0400 + 5;
  NIN_POPUPOPEN  = $0400 + 6;
  NIN_POPUPCLOSE = $0400 + 7;

  NIF_REALTIME   = $00000040;
  NIF_SHOWTIP    = $00000080;

  NIM_ADD = $00000000;
  NIM_MODIFY = $00000001;
  NIM_DELETE = $00000002;
  //version >= 5.00
  NIM_SETFOCUS = $00000003;
  NIM_SETVERSION = $00000004;

  NIF_MESSAGE = $00000001;
  NIF_ICON = $00000002;
  NIF_TIP = $00000004;
  //version >= 5.00
  NIF_STATE = $00000008;
  NIF_INFO = $00000010;
  //version >= 6.00
  NIF_GUID = $00000020;

  //version >= 5.00
  NIS_HIDDEN = $00000001;
  NIS_SHAREDICON = $00000002;

  NIIF_NONE = $00000000;
  NIIF_INFO = $00000001;
  NIIF_WARNING = $00000002;
  NIIF_ERROR = $00000003;
  NIIF_ICON_MASK = $0000000F;
  //version >= 5.01
  NIIF_NOSOUND = $00000010;

  TTS_BALLOON = $40;
  TTS_NOANIMATE = $10;
  TTS_NOFADE = $20;
  TTS_CLOSE = $80;
  TTN_GETDISPINFOA = (TTN_FIRST - 0);
  TTN_GETDISPINFOW = (TTN_FIRST - 10);
  TTN_SHOW = (TTN_FIRST - 1);
  TTN_POP = (TTN_FIRST - 2);
  TTN_LINKCLICK = (TTN_FIRST - 3);

var
  tinfo: toolinfo;
  tclockinfo: toolinfo;

implementation

end.

