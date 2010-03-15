{
Source Name: MainWnd.pas
Description: TaskBar Module Main Form
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

unit MainWnd;

interface

uses
  Types, Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, JclSimpleXML, SharpApi, Menus,
  Math, Contnrs, SharpETaskItem, MonitorList, uVistaFuncs, dwmapi,
  SharpEBaseControls, SharpECustomSkinSettings, uTaskManager, uTaskItem,
  DateUtils, GR32, GR32_PNG, SharpIconUtils, SharpEButton, JvComponentBase,
  JvDragDrop, VWMFunctions,Commctrl,TaskFilterList,SWCmdList, SharpTypes,
  uISharpBarModule, uSystemFuncs, uTaskPreviewWnd;


type
  TColorRec = packed record
                b,g,r,a: Byte;
              end;
  TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
  PColorArray = ^TColorArray;
  THSLColor = record
                Hue, Saturation, Lightness : Integer;
              end;

  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    ses_maxall: TSharpEButton;
    ses_minall: TSharpEButton;
    DDHandler: TJvDragDrop;
    DropTarget: TJvDropTarget;
    Timer1: TTimer;
    PreviewCheckTimer: TTimer;
    ses_togall: TSharpEButton;
    procedure DropTargetDragOver(Sender: TJvDropTarget;
      var Effect: TJvDropEffect);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ses_maxallClick(Sender: TObject);
    procedure ses_minallClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PreviewCheckTimerTimer(Sender: TObject);
    procedure ses_MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ses_togallClick(Sender: TObject);
    procedure ses_MouseEnter(Sender: TObject);
    procedure ses_MouseLeave(Sender: TObject);
  protected
  private
    FMoveToVWMIcon : TBitmap;
    sWidth      : integer;
    sMaxWidth   : integer;
    sAutoHeight : integer;
    sCurrentWidth : integer;
    sSpacing    : integer;
    sState      : TSharpETaskItemStates;
    sSort       : boolean;
    sSortType   : TSharpeTaskManagerSortType;
    sDebug      : boolean;
    sMiddleClose : boolean;
    sMaxAllButton : boolean;
    sMinAllButton : boolean;
    sTogAllButton : boolean;
    sShowAppBarWindows : boolean;
    sIFilter,sEFilter : Boolean;
    sIGlobalFilters : array of String;
    sIFilters,sEFilters,sFilters : TFilterItemList;
    sTaskPreview : boolean;
    FLocked : boolean;
    FSpecialButtonWidth : integer;
    FDminA,FDmaxA : TBitmap32; // default min/max all images
    FCustomSkinSettings: TSharpECustomSkinSettings;
    FTipWnd : hwnd;
    FLastDragItem : TSharpETaskItem; // Only a pointer, don't free it...
    FLastDragMinimized : Boolean;
    FMoveItem : TSharpETaskItem;
    FHasMoved : boolean;
    FRefreshOnNextMouseMove : boolean;
    FPreviewWnd : TTaskPreviewWnd;
    FPreviewWndHandle : hwnd;
    function IsOnCurrentMonitor(pItem : TTaskItem) : Boolean;
    procedure WMNotify(var msg: TWMNotify); message WM_NOTIFY;
    procedure WMCommand(var msg: TMessage); message WM_COMMAND;
    procedure WMShellHook(var msg : TMessage); message WM_SHARPSHELLMESSAGE;
    procedure WMCopyData(var msg : TMessage); message WM_COPYDATA;
    procedure WMTaskVWMChange(var msg : TMessage); message WM_TASKVWMCHANGE;
  public
    TM: TTaskManager;
    IList: TObjectList;
    mInterface : ISharpBarModule;
    CurrentVWM : integer;
    function FindAppBars : THandleArray;
    procedure UpdateSize;
    procedure UpdateComponentSkins;
    procedure InitHook;
    procedure CalculateItemWidth(ItemCount : integer);
    procedure AlignTaskComponents;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean = True);
    procedure NewTask(pItem : TTaskItem; Index : integer);
    procedure RemoveTask(pItem : TTaskItem; Index : integer);
    procedure UpdateTask(pItem : TTaskItem; Index : integer);
    procedure ActivateTask(pItem : TTaskItem; Index : integer);
    procedure FlashTask(pItem : TTaskItem; Index : integer);
    procedure TaskExchange(pItem1,pItem2 : TTaskItem; n,i : integer);
    procedure SharpETaskItemClick(Sender: TObject);
    procedure OnTaskItemMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OnTaskItemMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure OnTaskItemMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure OnDragEventEnter(Sender: TJvDropTarget; var Effect: TJvDropEffect);
    procedure DisplaySystemMenu(pHandle : hwnd);
    procedure GetSpacing;
    procedure CompleteRefresh;
    function CheckFilter(pItem : TTaskItem) : boolean;
    procedure CheckFilterAll;
    procedure LoadGlobalFilters;
    procedure LoadFilterSettingsFromXML;
    constructor CreateParented(ParentWindow : hwnd);
    procedure AlignSpecialButtons;
    procedure UpdateCustomSettings;
    procedure RepaintComponents;

    procedure DebugOutPutInfo(msg : String);
    procedure DebugOutPutError(msg : String);
  end;


implementation

uses
  ToolTipApi,IXMLBaseUnit,GR32Utils;

var
  SysMenuHandle : hwnd;

{$R icons.res}
{$R *.dfm}

procedure TMainForm.DebugOutPutInfo(msg : String);
begin
  if not sDebug then exit;
  SharpApi.SendDebugMessageEx('Module|Taskbar',PChar(msg),0,DMT_INFO);
end;

procedure TMainForm.DebugOutPutError(msg : String);
begin
  if not sDebug then exit;
  SharpApi.SendDebugMessageEx('Module|Taskbar',PChar(msg),clMaroon,DMT_ERROR);
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TMainForm.RepaintComponents;
var
  n : integer;
begin
  for n := 0 to IList.Count - 1 do
      TSharpETaskItem(IList.Items[n]).Repaint;
  ses_minall.Repaint;
  ses_maxall.Repaint;
  ses_togall.Repaint;
end;

procedure TMainForm.UpdateComponentSkins;
var
  n : integer;
begin
  ses_maxall.SkinManager := mInterface.SkinInterface.SkinManager;
  ses_minall.SkinManager := mInterface.SkinInterface.SkinManager;
  ses_togall.SkinManager := mInterface.SkinInterface.SkinManager;

  for n := 0 to IList.Count - 1 do
    TSharpETaskItem(IList.Items[n]).SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure LoadTogAll(var ses_togall : TSharpEButton);
var
  TempBmp : TBitmap32;
  ResStream : TResourceStream;
  Alpha : Boolean;
begin
  // Default Toggle All icon
  TempBmp := TBitmap32.Create;
  TempBmp.Clear(color32(0,0,0,0));
  ResStream := TResourceStream.Create(HInstance, 'togallicon', RT_RCDATA);

  try
    LoadBitmap32FromPng(TempBmp,ResStream,Alpha);
    ses_togall.Glyph32.Assign(TempBmp);
  finally
    TempBmp.Free;
    ResStream.Free;
  end;
end;

procedure TMainForm.UpdateCustomSettings;
var
  dir : String;
  b : boolean;
begin
  DebugOutPutInfo('TMainForm.UpdatecustomSettings (Procedure)');

  FCustomSkinSettings.LoadFromXML('');
  try
    with FCustomSkinSettings.xml.Items do
    begin
      if ItemNamed['taskbar'] <> nil then
      begin
        with FCustomSkinSettings.xml.Items.ItemNamed['taskbar'] do
        begin
          {$WARNINGS OFF}
          dir := IncludeTrailingBackSlash(FCustomSkinSettings.Path);
          {$WARNINGS ON}
          if (items.ItemNamed['minallicon'] <> nil) and FileExists(dir + items.Value('minallicon')) then
          begin
            try
              GR32_PNG.LoadBitmap32FromPNG(ses_minall.Glyph32,dir + items.Value('minallicon'),b);
            except
              ses_minall.Glyph32.Assign(FDminA);
            end;
          end else ses_minall.Glyph32.Assign(FDminA);
          if (items.ItemNamed['maxallicon'] <> nil) and  FileExists(dir + Items.Value('maxallicon')) then
          begin
            try
              GR32_PNG.LoadBitmap32FromPNG(ses_maxall.Glyph32,dir + items.Value('maxallicon'),b);
            except
              ses_maxall.Glyph32.Assign(FDmaxA);
            end;
          end else ses_maxall.Glyph32.Assign(FDmaxA);
          if (items.ItemNamed['togallicon'] <> nil) and FileExists(dir + Items.Value('togallicon')) then
          begin
            try
              GR32_PNG.LoadBitmap32FromPNG(ses_togall.Glyph32,dir + items.Value('togallicon'),b);
            except
              LoadTogAll(ses_togall);
            end;
          end else LoadTogAll(ses_togall);
        end;
      end else
      begin
        ses_minall.Glyph32.Assign(FDminA);
        ses_maxall.Glyph32.Assign(FDmaxA);
        LoadTogAll(ses_togall);
      end;
    end;
  except
    ses_minall.Glyph32.Assign(FDminA);
    ses_maxall.Glyph32.Assign(FDmaxA);
    LoadTogAll(ses_togall);
  end;
end;

constructor TMainForm.CreateParented(ParentWindow : hwnd);
begin
  DebugOutPutInfo('TMainForm.CreateParented (constructor)');
  Inherited CreateParented(ParentWindow);
  sIFilters := TFilterItemList.Create;
  sEFilters := TFilterItemList.Create;
  sFilters := TFilterItemList.Create;
end;

procedure TMainForm.WMTaskVWMChange(var msg : TMessage);
var
  pItem : TTaskItem;
begin
  pItem := TM.GetItemByHandle(Cardinal(msg.WParam));
  if pItem <> nil then
  begin
    pItem.LastVWM := msg.LParam;
    TM.UpdateTask(pItem.Handle);
  end;
end;

procedure TMainForm.WMNotify(var msg: TWMNotify);
begin
  if Msg.NMHdr.code = TTN_SHOW then
  begin
    SetWindowPos(Msg.NMHdr.hwndFrom, HWND_TOPMOST, 0, 0, 0, 0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    Msg.result := 1;
    exit;
  end else Msg.result := 0;
end;

procedure TMainForm.WMCommand(var msg: TMessage);
var
  VWMCount : integer;
  VWMIndex : integer;
  TaskItem : TTaskItem;
  wnd : hwnd;
begin
  DebugOutPutInfo('TMainForm.WMCommand (Message Procedure)');
  PostMessage(SysMenuHandle, WM_SYSCOMMAND, msg.wparam, msg.lparam);

  VWMCount := GetVWMCount;
  if msg.WParam > 512 then // Pin to appbar message
  begin
    wnd := msg.WParam - 512;
    if IsWindow(wnd) then
      PostMessage(wnd,WM_ADDAPPBARTASK,sysMenuHandle,0);
  end else
  if VWMCount > 0 then
    if (msg.WParam >= 256) and (msg.WParam <= 256 + VWMCount) then
    begin
      TaskItem := TM.GetItemByHandle(SysMenuHandle);
      if TaskItem <> nil then
        TaskItem.LastVWM := msg.WParam - 256 + 1;

      if not IsIconic(SysMenuHandle) then
      begin
        VWMIndex := GetCurrentVWM;
        VWMMoveWindotToVWM(msg.WParam - 256 + 1,VWMIndex,VWMCount,SysMenuHandle);
      end;

      PostMessage(GetShellTaskMgrWindow,WM_TASKVWMCHANGE,Integer(SysMenuHandle),msg.WParam - 256 + 1);      

      if not CheckFilter(taskitem) then
      begin
        taskitem.Used := False;
        RemoveTask(taskitem,-1);
      end else taskitem.Used := True;
    end;

  inherited;
end;

procedure TMainForm.GetSpacing;
begin
  DebugOutPutInfo('TMainForm.GetSpacing (Procedure)');
  if mInterface.SkinInterface.SkinManager.Skin.TaskItem = nil then exit;
  try
    case sState of
      tisCompact: sSpacing := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Compact.Spacing;
      tisMini: sSpacing := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Mini.Spacing;
    else sSpacing := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Full.Spacing;
    end;
  except
    sSpacing := 2;
  end;

  try
    case sState of
      tisCompact: sMaxWidth := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Compact.Dimension.X;
      tisMini: sMaxWidth := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Mini.Dimension.X;
      else sMaxWidth := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Full.Dimension.X;
    end;
  except
    sMaxWidth := 128;
  end;

  try
    case sState of
      tisCompact: sAutoHeight := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Compact.Dimension.Y;
      tisMini   : sAutoHeight := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Mini.Dimension.Y;
      else sAutoHeight := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Full.Dimension.Y;
    end;
  except
    sAutoHeight := Height - 2;
  end;

  if (sAutoHeight > Height) or (sAutoHeight <=0) then
     sAutoHeight := Height;
  if sMaxWidth <= 0 then sMaxWidth := 128;
end;

procedure TMainForm.OnDragEventEnter(Sender: TJvDropTarget; var Effect: TJvDropEffect);
var
  pitem : TTaskItem;
begin
  pitem := TM.GetItemByHandle(TSharpETaskItem(Sender.Control).Handle);
  if pitem <> nil then
     pitem.Restore; 
end;

procedure TMainForm.AlignSpecialButtons;
var
  n : integer;
begin
  DebugOutPutInfo('TMainForm.AlignSpecialButtons (Procedure)');
  n := 1;
  if sMinAllButton then
  begin
    ses_minall.visible := True;
    ses_minall.Left := n;
    ses_minall.UpdateSkin;
    ses_minall.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;
    if ses_minall.Glyph32 <> nil then
      ses_minall.Width := ses_minall.Width + ses_minall.GetIconWidth;
    ses_minall.Width := ses_minall.Width - 4;
    n := n + ses_minall.Width + 2;
  end else ses_minall.Visible := False;
  if sMaxAllButton then
  begin
    ses_maxall.Visible := True;
    ses_maxall.Left := n;
    ses_maxall.UpdateSkin;    
    ses_maxall.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;
    if ses_maxall.Glyph32 <> nil then
      ses_maxall.Width := ses_maxall.Width + ses_maxall.GetIconWidth;
    n := n + ses_maxall.Width + 2;
    ses_maxall.Width := ses_maxall.Width - 4;
  end else ses_maxall.Visible := False;

  if sTogAllButton then
  begin
    ses_togall.Visible := True;
    ses_togall.Left := n;
    ses_togall.UpdateSkin;
    ses_togall.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;
    if ses_togall.Glyph32 <> nil then
      ses_togall.Width := ses_togall.Width + ses_togall.GetIconWidth;
    n := n + ses_togall.Width + 2;
    ses_togall.Width := ses_togall.Width - 4;
  end else ses_togall.Visible := False;

  FSpecialButtonWidth := n + 4;

  // Update Tooltips
  if sMinAllButton then
  begin
    if ses_minall.tag = 0 then
      ToolTipApi.AddToolTip(FTipWnd,self,1,ses_minall.BoundsRect,'Minimize All Windows')
    else ToolTipApi.UpdateToolTipRect(FTipWnd,self,1,ses_minall.BoundsRect);
    ses_minall.Tag := 1;
  end else
  begin
    ToolTipApi.DeleteToolTip(FTipWnd,self,1);
    ses_minall.Tag := 0;
  end;
  if sMaxAllButton then
  begin
    if ses_maxall.tag = 0 then
      ToolTipApi.AddToolTip(FTipWnd,self,2,ses_maxall.BoundsRect,'Restore All Windows')
    else ToolTipApi.UpdateToolTipRect(FTipWnd,self,2,ses_maxall.BoundsRect);
    ses_maxall.Tag := 1;
  end else
  begin
    ToolTipApi.DeleteToolTip(FTipWnd,self,2);
    ses_maxall.Tag := 0;
  end;
  if sTogAllButton then
  begin
    if ses_togall.tag = 0 then
      ToolTipApi.AddToolTip(FTipWnd,self,3,ses_togall.BoundsRect,'Toggle All Windows')
    else ToolTipApi.UpdateToolTipRect(FTipWnd,self,3,ses_togall.BoundsRect);
    ses_togall.Tag := 1;
  end else
  begin
    ToolTipApi.DeleteToolTip(FTipWnd,self,3);
    ses_togall.Tag := 0;
  end;
end;

function TMainForm.FindAppBars : THandleArray;
type
  PParam = ^TParam;
  TParam = record
    wndlist: THandleArray;
  end;
  
var
  List : TStringList;
  EnumParam : TParam;
  ha : THandleArray;
  n : integer;
  s : String;

  function GetCaption(handle : hwnd): String;
  var
    buf: array[0..2048] of wchar;
  begin
    GetWindowTextW(handle,@buf,sizeof(buf));
    result := buf;
  end;

  function EnumThreadWindowsProc(Wnd: hwnd; param: lParam): boolean; export; stdcall;
  begin
    if CompareText(GetCaption(wnd),'ApplicationBar') = 0 then
    with PParam(Param)^ do
    begin
      setlength(wndlist,length(wndlist)+1);
      wndlist[High(wndlist)] := wnd;
    end;
    result := true;
  end;
  
begin
  ha := FindAllWindows('TSharpBarMainForm');

  setlength(EnumParam.wndlist,0);
  for n := High(ha) downto 0 do
  begin
    if not (ha[n] = Handle) then
      EnumChildWindows(ha[n],@EnumThreadWindowsProc,Integer(@EnumParam));
  end;

  setlength(result,length(EnumParam.Wndlist));
  for n := 0 to High(EnumParam.Wndlist) do
    result[n] := EnumParam.WndList[n];
  setlength(EnumParam.wndlist,0);

  // add modules from the modules bar
  // For some reason EnumChildWindows doesn't work on there
  List := TStringList.Create;
  s := mInterface.BarInterface.GetModuleWindows('ApplicationBar.dll');
  List.CommaText := s;
  for n := 0 to List.Count - 1 do
  begin
    setlength(result,length(result) + 1);
    result[High(result)] := strtoint(List[n]);
  end;
  List.Free;
end;

function GetPositionString(wnd : hwnd) : String;
var
  Mon : TMonitor;
  R : TRect;
  P : TPoint;
begin
  result := '';
  GetWindowRect(wnd,R);
  P := Point(R.Left + (R.Right - R.Left) div 2, R.Top + (R.Bottom - R.Top) div 2);
  Mon := Screen.MonitorFromWindow(wnd);
  if not Mon.Primary then
    result := result + 'Monitor:' + inttostr(Mon.MonitorNum)+'| ';
  if P.Y > Mon.Top + Mon.Height div 2 then
    result := result + 'Bottom'
  else result := result + 'Top';
  result := result + ',';
  if P.X > Mon.Left + Mon.Width div 2 then
    result := result + 'Right'
  else result := result + 'Left';
end;

procedure TMainForm.DisplaySystemMenu(pHandle : hwnd);
var
  cp: TPoint;
  AppMenu: hMenu;
  MenuItemInfo: TMenuItemInfo;
  n : integer;
  AppBarMenu : hMenu;
  VWMMenu : hMenu;
  VWMCount : integer;
  AppBars : THandleArray;
  pItem : TTaskItem;
begin
  DebugOutPutInfo('TMainForm.DisplaySystemMenu (Procedure)');
  if not (isWindow(pHandle)) then
    exit;

  SysMenuHandle := pHandle;
  GetCursorPos(cp);
  AppMenu := GetSystemMenu(pHandle, False);
  if not IsMenu(AppMenu) then
  begin
    GetSystemMenu(pHandle, True);
    AppMenu := GetSystemMenu(pHandle, False);
  end;

  if IsIconic(pHandle) then
  begin
    EnableMenuItem(AppMenu, SC_Restore,  mf_bycommand or mf_enabled);
    EnableMenuItem(AppMenu, SC_Move,     mf_bycommand or mf_grayed);
    EnableMenuItem(AppMenu, SC_Size,     mf_bycommand or mf_grayed);
    EnableMenuItem(AppMenu, SC_Minimize, mf_bycommand or mf_grayed);
  end else
  if IsZoomed(pHandle) then
  begin
    EnableMenuItem(AppMenu, SC_Restore,  mf_bycommand or mf_enabled);
    EnableMenuItem(AppMenu, SC_Move,     mf_bycommand or mf_grayed);
    EnableMenuItem(AppMenu, SC_Size,     mf_bycommand or mf_grayed);
    EnableMenuItem(AppMenu, SC_Maximize, mf_bycommand or mf_grayed);
  end else
  begin
    EnableMenuItem(AppMenu, SC_Restore,  mf_bycommand or mf_grayed);
    EnableMenuItem(AppMenu, SC_Move,     mf_bycommand or mf_enabled);
    EnableMenuItem(AppMenu, SC_Size,     mf_bycommand or mf_enabled);
    EnableMenuItem(AppMenu, SC_Minimize, mf_bycommand or mf_enabled);
  end;

  AppBars := FindAppBars;
  AppBarMenu := 0;
  if length(AppBars)>0 then
  begin
    { Add a seperator }
    FillChar(MenuItemInfo, SizeOf(MenuItemInfo), #0);
    MenuItemInfo.cbSize := 44; //SizeOf(MenuItemInfo);
    MenuItemInfo.fMask := MIIM_CHECKMARKS or MIIM_DATA or
      MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE;
    MenuItemInfo.fType := MFT_SEPARATOR;
    MenuItemInfo.wID := $EFFF;
    InsertMenuItem(AppMenu, DWORD(0), True, MenuItemInfo);

    { Add Pin to App Bar Item}
    FillChar(MenuItemInfo, SizeOf(MenuItemInfo), #0);
    MenuItemInfo.cbSize := 44; //SizeOf(MenuItemInfo);
    MenuItemInfo.fMask := MIIM_DATA or
      MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE;
    MenuItemInfo.fType := MFT_STRING;
    MenuItemInfo.dwTypeData := 'Pin to Application Bar';
    AppBarMenu := CreateMenu;
    MenuItemInfo.hSubMenu := AppBarMenu;
    MenuItemInfo.wID := $EFFF;
    InsertMenuItem(AppMenu, DWORD(0), True, MenuItemInfo);

    for n := 0 to High(AppBars) do
    begin
      FillChar(MenuItemInfo, SizeOf(MenuItemInfo), #0);
      MenuItemInfo.cbSize := 44; //SizeOf(MenuItemInfo);
      MenuItemInfo.fMask := MIIM_CHECKMARKS or MIIM_DATA or
        MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE;
      MenuItemInfo.fType := MFT_STRING;
      MenuItemInfo.dwTypeData := PChar('Application bar at ' + GetPositionString(AppBars[n]));
      MenuItemInfo.wID := 512 + AppBars[n];
      InsertMenuItem(AppBarMenu, DWORD(0), True, MenuItemInfo);
    end;    
  end;

  VWMMenu := 0;
  VWMCount := GetVWMCount;
  if (GetVWMCount > 0) then //and (not IsIconic(pHandle)) then
  begin
   { Add a seperator }
   if AppBarMenu = 0 then
   begin
     FillChar(MenuItemInfo, SizeOf(MenuItemInfo), #0);
     MenuItemInfo.cbSize := 44; //SizeOf(MenuItemInfo);
     MenuItemInfo.fMask := MIIM_CHECKMARKS or MIIM_DATA or
       MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE;
     MenuItemInfo.fType := MFT_SEPARATOR;
     MenuItemInfo.wID := $EFFF;
     InsertMenuItem(AppMenu, DWORD(0), True, MenuItemInfo);
   end;

   { Add a VWM Item}
   FillChar(MenuItemInfo, SizeOf(MenuItemInfo), #0);
   MenuItemInfo.cbSize := 44; //SizeOf(MenuItemInfo);
   MenuItemInfo.fMask := MIIM_DATA or
     MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE;
   MenuItemInfo.fType := MFT_STRING;
   MenuItemInfo.dwTypeData := 'Move to VWM';
   VWMMenu := CreateMenu;
   MenuItemInfo.hSubMenu := VWMMenu;
   MenuItemInfo.wID := $EFFF;
 //  MenuItemInfo.hbmpItem := FMoveToVWMIcon.Handle;
   InsertMenuItem(AppMenu, DWORD(0), True, MenuItemInfo);

   pItem := TM.GetItemByHandle(pHandle);

   for n := VWMCount - 1 downto 0 do
   begin
     FillChar(MenuItemInfo, SizeOf(MenuItemInfo), #0);
     MenuItemInfo.cbSize := 44; //SizeOf(MenuItemInfo);
     MenuItemInfo.fMask := MIIM_CHECKMARKS or MIIM_DATA or
       MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE;
     MenuItemInfo.fType := MFT_STRING;
     MenuItemInfo.dwTypeData := PChar(inttostr(n + 1));
     MenuItemInfo.wID := 256 + n;
     if pItem <> nil then
       if pItem.LastVWM = n + 1 then
         MenuItemInfo.fState := 1;

     InsertMenuItem(VWMMenu, DWORD(0), True, MenuItemInfo);
   end;
  end;

  SendMessage(pHandle, WM_INITMENUPOPUP, AppMenu, MAKELPARAM(0, 1));
  SendMessage(pHandle, WM_INITMENU, AppMenu, 0);
  TrackPopupMenu(AppMenu, tpm_leftalign or tpm_leftbutton, cp.x, cp.y, 0, Handle, nil);
  
  if VWMMenu <> 0 then
    DeleteMenu(AppMenu,0,MF_BYPOSITION);
  if AppBarMenu <> 0 then
    DeleteMenu(AppMenu,0,MF_BYPOSITION);
  if (VWMMenu <> 0) or (AppBarMenu <> 0) then // Delete Seperator
    DeleteMenu(AppMenu,0,MF_BYPOSITION);
  setlength(AppBars,0);
end;

procedure TMainForm.OnTaskItemMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  FHasMoved := False;
  if not sSort then
    FMoveItem := TSharpETaskItem(Sender);
end;

procedure TMainForm.OnTaskItemMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  CursorPos,CPos : TPoint;
  n : integer;
  item : TSharpETaskItem;
  item1,item2 : TTaskItem;
  pos : TPoint;
  size : integer;
  popupdown : boolean;
  R : TRect;
  Animate : boolean;
begin
  if (FMoveItem = nil) then
  begin
    if (IList.Count > 0) and (FRefreshOnNextMouseMove) then
    begin
      FRefreshOnNextMouseMove := False;
      TSharpETaskItem(IList[IList.Count - 1]).UpdateSkin;
      TSharpETaskItem(IList[IList.Count - 1]).Repaint;
    end;

    if (not sTaskPreview) or (not DwmCompositionEnabled) then
    begin
      ToolTipApi.EnableToolTip(FTipWnd);
      Exit;
    end;

    ToolTipApi.DisableToolTip(FTipWnd);

    if GetCursorPosSecure(cursorPos) then
      CPos := ScreenToClient(cursorPos)
    else exit;  

    // find the item which over which the cursor is
    for n := 0 to IList.Count - 1 do
    begin
      item := TSharpETaskItem(IList.Items[n]);
      if (CPos.X > item.Left) and (CPos.X < item.left + item.Width) then
      begin
        Animate := True;
        if FPreviewWnd <> nil then
        begin
          if FPreviewWnd.TaskWnd <> item.Handle then
          begin
            FPreviewWnd.Free;
            FPreviewWnd := nil;
            Animate := False;
          end else exit;
        end;

        // FPreviewWndHandle <> means that the window has been closed by a click on the task item
        // only display again when the item changed
        if FPreviewWndHandle = item.Handle then
          exit;          
        FPreviewWndHandle := 0;
        
        popupdown := (ClientToScreen(Point(0,0)).y < Monitor.Top + Monitor.Height div 2);

        size := round(Monitor.Width / mInterface.SkinInterface.SkinManager.Skin.TaskPreview.Dimension.X);
        GetWindowRect(mInterface.BarInterface.BarWnd,R);
        pos := ClientToScreen(Point(item.Left + item.Width div 2 - size div 2,0));
        // Do not allow the preview to appear off the left side of the monitor.
        if pos.X < Monitor.Left then
          pos.X := Monitor.Left;
        // Do not allow the preview to appear off the right side of the monitor.
        if pos.X + size > Monitor.Left + Monitor.Width then
          pos.X := Monitor.Left + Monitor.Width - size;
        if popupdown then
          pos.y := R.Bottom
        else pos.y := R.Top;
        FPreviewWnd := TTaskPreviewWnd.Create(item.handle, 
                                              popupdown,
                                              pos.x,
                                              pos.y,
                                              size,
                                              mInterface.SkinInterface.SkinManager,
                                              item.Caption,
                                              Animate,
                                              False);
        PreviewCheckTimer.Enabled := True;
      end;
    end;
    exit;
  end;

  if GetCursorPosSecure(cursorPos) then
    CPos := ScreenToClient(cursorPos)
  else exit;  

  for n := 0 to IList.Count - 1 do
  begin
    item := TSharpETaskItem(IList.Items[n]);
    if (CPos.X > item.Left) and (CPos.X < item.left + item.Width) then
      if item <> FMoveItem then
      begin
        FHasMoved := True;
      //  i := FMoveItem.Left;
    //    FMoveItem.Left := item.Left;
  //      item.left := i;
//        IList.Exchange(n,IList.IndexOf(FMoveItem));
        item1 := TM.GetItemByHandle(FMoveItem.Handle);
        item2 := TM.GetItemByHandle(item.Handle);
        TM.ExChangeTasks(item1,item2);
        exit;
      end;
  end;
end;

procedure TMainForm.OnTaskItemMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  DebugOutPutInfo('TMainForm.OnTaskItemMouseUp (Procedure)');

  FMoveItem := nil;

  if (Sender = nil) or (FHasMoved) then
    exit;

  if not (Sender is TSharpETaskItem) then exit;
  
  case Button of
    mbRight: DisplaySystemMenu(TSharpETaskItem(Sender).Handle);
    mbMiddle: if sMiddleClose then
    begin
      //PostMessage(TSharpETaskItem(Sender).Handle, WM_CLOSE, 0, 0);
      //PostThreadMessage(GetWindowThreadProcessID(TSharpETaskItem(Sender).Handle, nil), WM_QUIT, 0, 0);
      SendMessage(TSharpeTaskItem(Sender).Handle, WM_SYSCOMMAND, SC_CLOSE, 0);
    end;
  end;
end;

procedure TMainForm.PreviewCheckTimerTimer(Sender: TObject);
var
  CPos,cursorPos : TPoint;
begin
  if GetCursorPosSecure(cursorPos) then
    CPos := ScreenToClient(cursorPos)
  else exit;  

  if not PointInRect(CPos,Rect(-10,-10,Width+10,Height+10)) then
  begin
    PreviewCheckTimer.Enabled := False;
    if FPreviewWnd <> nil then
    begin
      FPreviewWnd.HideWindow(True); 
      FPreviewWnd.Free;
      FPreviewWnd := nil;
    end;
    FPreviewWndHandle := 0;    
  end;  
end;

procedure TMainForm.LoadFilterSettingsFromXML;
begin
  DebugOutPutInfo('TMainForm.LoadFilterSettingsFromXML (Procedure)');
  sIFilters.Clear;
  sEFilters.Clear;
  sFilters.Load;
end;

procedure TMainForm.LoadGlobalFilters;
var
  n,i : integer;
  XML : TInterfacedXmlBase;
begin
  setlength(sIGlobalFilters,0);

  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\ApplicationBar\Apps.xml';

  if XML.Load then
    for n := 0 to XML.XmlRoot.Items.Count - 1 do
      for i := 0 to XML.XmlRoot.Items.Item[n].Items.Count - 1 do
      begin
        setlength(sIGlobalFilters,length(sIGlobalFilters) + 1);
        sIGlobalFilters[High(sIGlobalFilters)] := ExtractFileName(XML.XmlRoot.Items.Item[n].Items.Item[i].Value);
      end;

  XML.Free;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
  n,i : integer;
  newitem : TFilterItem;
  SList : TStringList;
begin
  DebugOutPutInfo('TMainForm.LoadSettings (Procedure)');
  sState     := tisFull;
  sWidth     := 100;
  sMaxwidth  := 128;
  sSpacing   := 2;
  sSort      := False;
  sDebug     := False;
  sEFilter   := True;
  sIFilter   := True;
  sMiddleClose := True;
  sShowAppBarWindows := False;
  sTaskPreview := True;

  LoadFilterSettingsFromXML;

  XML := TJclSimpleXML.Create;
  SList := TSTringList.Create;
  try
    XML.LoadFromFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      sState := TSharpETaskItemStates(IntValue('State',0));
      sSort := BoolValue('Sort',False);
      sSortType := TSharpeTaskManagerSortType(IntValue('SortType',0));
      sMinAllButton := BoolValue('MinAllButton',False);
      sMaxAllButton := BoolValue('MaxAllButton',False);
      sTogAllButton := BoolValue('TogAllButton',False);
      sIFilter := BoolValue('FilterTasks',True);
      sEFilter := BoolValue('FilterTasks',True);
      sDebug   := BoolValue('Debug',False);
      sMiddleClose := BoolValue('MiddleClose',True);
      sShowAppBarWindows := BoolValue('AppBarWindow',False);
      sTaskPreview := BoolValue('TaskPreview',True);
      if ItemNamed['IFilters'] <> nil then
      begin
        SList.Clear;
        SList.CommaText := ItemNamed['IFilters'].Value;
        for n := 0 to SList.Count - 1 do
        begin
          for i := sFilters.Count - 1 downto 0 do
            if CompareText(sFilters.Item[i].Name,SList[n]) = 0 then
            begin
              newitem := TFilterItem.Create;
              newitem.Assign(sFilters.Item[i]);
              sIFilters.AddItem(newitem);
              break;
            end;
        end;
      end;
      if ItemNamed['EFilters'] <> nil then
      begin
        SList.Clear;      
        SList.CommaText := ItemNamed['EFilters'].Value;
        for n := 0 to SList.Count - 1 do
        begin
          for i := sFilters.Count - 1 downto 0 do
            if CompareText(sFilters.Item[i].Name,SList[n]) = 0 then
            begin
              newitem := TFilterItem.Create;
              newitem.Assign(sFilters.Item[i]);
              sEFilters.AddItem(newitem);
              break;
            end;
        end;
      end;
    end;
  XML.Free;
  Slist.Free;
  
  if sEFilters.Count = 0 then sEFilter := False;
  if sIFilters.Count = 0 then sIFilter := False;

  UpdateCustomSettings;

  TM.SortTasks := sSort;
  TM.SortType := sSortType;

  FLocked := True;

  AlignSpecialButtons;
  GetSpacing;
  if TM.SortTasks then TM.DoSortTasks;
  CompleteRefresh;

  FLocked := False;
end;

procedure TMainForm.CompleteRefresh;
var
  n : integer;
begin
  FMoveItem := nil;

  DebugOutPutInfo('TMainForm.CompleteRefresh (Procedure)');
  for n := IList.Count - 1 downto 0 do
     ToolTipApi.DeleteToolTip(FTipWnd,Self,TSharpETaskItem(IList[n]).Handle);
  FLocked := True;
  IList.Clear;
  TM.CompleteRefresh;
  FLocked := False;
  RealignComponents(True);
  AlignTaskComponents;
end;

procedure TMainForm.UpdateSize;
begin
  DebugOutPutInfo('TMainForm.UpdateSize (Procedure)');

  if IList.Count <= 0 then
    exit;

  CalculateItemWidth(IList.Count);
  AlignTaskComponents;
  Repaint;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean = True);
var
  newWidth : integer;
begin
  DebugOutPutInfo('TMainForm.ReAlignComponents (Procedure)');
  GetSpacing;
  if IList.Count <=0 then
  begin
    mInterface.MinSize := 1;
    mInterface.MaxSize := 1;
    if BroadCast then
      mInterface.BarInterface.UpdateModuleSize;
    exit;
  end;

  AlignSpecialButtons;
  NewWidth := Max(FSpecialButtonWidth + IList.Count * sMaxWidth + (IList.Count - 1) * sSpacing,1);

  if sState = tisMini then mInterface.MinSize := Max(FSpecialButtonWidth + IList.Count * sMaxWidth + (IList.Count - 1) * sSpacing,1)
     else mInterface.MinSize := Max(FSpecialButtonWidth + IList.Count * 16 + (IList.Count - 1) * sSpacing,1);

  mInterface.MaxSize := NewWidth;
  if (newWidth <> Width) and BroadCast then
    mInterface.BarInterface.UpdateModuleSize;
end;


procedure TMainForm.CalculateItemWidth(ItemCount : integer);
var
  n : integer;
  FreeSpace : integer;
  pItem : TSharpETaskItem;
begin
  DebugOutPutInfo('TMainForm.CalculateItemWidth (Procedure)');
  for n := IList.Count - 1 downto 0 do
    if IList.Items[n] <> nil then
    begin
      pItem := TSharpETaskItem(IList.Items[n]);
      pItem.State := sState;
    end;
  FreeSpace := Width - FSpecialButtonWidth;
  if ItemCount = 0 then sCurrentWidth := 16
     else sCurrentWidth := Max(Min((FreeSpace - ItemCount*sSpacing) div ItemCount,sMaxWidth),16);
end;

procedure LockWindow(const Handle: HWND); 
begin 
  SendMessage(Handle, WM_SETREDRAW, 0, 0); 
end; 

procedure UnlockWindow(const Handle: HWND); 
begin 
  SendMessage(Handle, WM_SETREDRAW, 1, 0); 
  RedrawWindow(Handle, nil, 0,
    RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
end;

procedure TMainForm.AlignTaskComponents;
var
  n : integer;
  pTaskItem : TSharpETaskItem;
begin
  LockWindow(Handle);
  DebugOutPutInfo('TMainForm.AlignTaskComponents (Procedure)');
  for n := IList.Count - 1 downto 0 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    if pTaskItem <> nil then
    begin
      if not pTaskItem.Visible then
        pTaskItem.Visible := True;
      if sCurrentWidth < sMaxWidth then
      begin
        pTaskItem.AutoSize := False;
        pTaskItem.Left := FSpecialButtonWidth + n*sCurrentWidth + n*sSpacing;
        pTaskItem.Width := sCurrentWidth;
        pTaskItem.Height := sAutoHeight;
      end else
      begin
        pTaskItem.Left := FSpecialButtonWidth + n*sMaxWidth + n*sSpacing;
        pTaskItem.AutoSize := True;
      end;
      ToolTipApi.UpdateToolTipRect(FTipWnd,Self,pTaskItem.Handle,
                                   Rect(pTaskItem.Left,pTaskItem.Top,
                                        pTaskItem.Left + pTaskItem.Width,
                                        pTaskItem.Top + pTaskItem.Height));
    end;
  end;
  UnlockWindow(Handle);
end;

procedure UpdateIcon(var pTaskItem : TSharpETaskItem; pItem : TTaskItem);
var
  bmp : TBitmap32;
begin
  if (pTaskItem = nil) or (pItem = nil) then exit;

  if (pTaskItem = nil) or (pItem = nil) then exit;
  bmp := TBitmap32.Create;
  try
    IconToImage(bmp,pItem.Icon);
    if (bmp.Width <> 0) and (bmp.Height <> 0) then
    begin
      pTaskItem.Glyph32.Assign(bmp);
      pTaskItem.CalculateGlyphColor;
    end;
  except
  end;
  bmp.Free;
end;

procedure TMainForm.CheckFilterAll;
var
  n,i : integer;
  pTaskItem : TSharpETaskItem;
  pItem : TTaskItem;
  changed : boolean;
begin
  DebugOutPutInfo('TMainForm.CheckFilterAll (Procedure)');
  if (sIFilter = False) and (sEFilter = False) and (sShowAppBarWindows) then exit;

  changed := False;
  FLocked := True;

  // remove tasks
  for i := TM.GetCount - 1 downto 0  do
  begin
    pItem := TM.GetItemByIndex(i);
    if pItem <> nil then
    begin
      for n := IList.Count - 1 downto 0 do
          if TSharpETaskItem(IList.Items[n]).Handle = pItem.Handle then
          begin
            pTaskItem := TSharpETaskItem(IList.Items[n]);
            if not CheckFilter(pItem) then
            begin
              pItem.Used := False;
              RemoveTask(TM.GetItemByHandle(pTaskItem.Handle),0);
              changed := True;
            end else pItem.Used := True;
            break;
          end;
    end;
  end;

  // add new tasks
  for i := 0 to TM.GetCount - 1  do
  begin
    pItem := TM.GetItemByIndex(i);
    if pItem <> nil then
    begin
      pTaskItem := nil;
      for n := 0 to IList.Count - 1 do
          if TSharpETaskItem(IList.Items[n]).Handle = pItem.Handle then
          begin
            pTaskItem := TSharpETaskItem(IList.Items[n]);
            break;
          end;

      if pTaskItem = nil then
         if CheckFilter(pItem) then
         begin
           pItem.Used := True;
           NewTask(pItem,i);
           changed := True;
        end else pItem.Used := False;
    end;
  end;

  FLocked := False;

  if changed then
  begin
    RealignComponents(True);
    AlignTaskComponents;
  end;
end;

function TMainForm.CheckFilter(pItem : TTaskItem) : boolean;
var
  n : integer;
  include : Boolean;
begin
  if pItem = nil then
  begin
    result := false;
    exit;
  end;

//  DebugOutPutInfo('TMainForm.CheckFilter (Procedure)');
  if (sIFilter = False) and (sEFilter = False) and (sShowAppBarWindows) then
  begin
    result := true;
    exit;
  end;

  // Check global app bar filters
  if not sShowAppBarWindows then
    for n := 0 to High(sIGlobalFilters) do
      if CompareText(sIGlobalFilters[n],pItem.FileName) = 0 then
      begin
        result := False;
        exit;
      end;

  Result := True;
  include := False;
  
  if sIFilter then
  begin
    for n:=0 to sIFilters.Count - 1 do
    begin
      case sIFilters[n].FilterType of
        fteSWCmd:
          include := (TSWCmdEnum(pItem.Placement.showCmd) in sIFilters[n].SWCmds);
        fteWindow:
          include := (CompareText(pItem.WndClass,sIFilters[n].WndClassName) = 0);
        fteProcess:
          include := (CompareText(pItem.FileName,sIFilters[n].FileName) = 0);
        fteCurrentMonitor:
          include := IsOnCurrentMonitor(pItem);
        fteCurrentVWM:
          include := (CurrentVWM = pItem.LastVWM);
        fteMinimised:
          include := IsIconic(pItem.Handle);
      end;
      if include then break;
    end;
  end;

  // task is supposed to be included...
  if include then Exit;

  if sEFilter then
  begin
    for n:=0 to sEFilters.Count - 1 do
    begin
      case sEFilters[n].FilterType of
        fteSWCmd:
          Result := not (TSWCmdEnum(pItem.Placement.showCmd) in sEFilters[n].SWCmds);
        fteWindow:
          Result := not (CompareText(pItem.WndClass,sEFilters[n].WndClassName) = 0);
        fteProcess:
          Result := not (CompareText(pItem.FileName,sEFilters[n].FileName) = 0);
        fteCurrentMonitor:
          Result := not IsOnCurrentMonitor(pItem);
        fteCurrentVWM:
          Result := (CurrentVWM <> pItem.LastVWM);
        fteMinimised:
          Result := not IsIconic(pItem.Handle);
      end;
      if not Result then Break;
    end;
  end;
end;

function TMainForm.IsOnCurrentMonitor(pItem : TTaskItem) : Boolean;
const
  MonRectOffset = 32;
var
  R : TRect;
  Mon : TMonitorItem;
  MonRect : TRect;
begin
  Result := False;

  Mon := MonList.MonitorFromWindow(mInterface.BarInterface.BarWnd);

  MonRect := Mon.BoundsRect;
  MonRect.Left := MonRect.Left + MonRectOffset;
  MonRect.Top := MonRect.Top + MonRectOffset;
  MonRect.Right := MonRect.Right - MonRectOffset;
  MonRect.Bottom := MonRect.Bottom - MonRectOffset;

  if IsIconic(pItem.Handle) and (pItem.LastVWM = CurrentVWM) then
  begin
    // Minimized windows are always moved off screen so check that
    // the we are in the right VWM and use its restored position.
    R := pItem.Placement.rcNormalPosition;
  end
  else
    GetWindowRect(pItem.Handle,R);

  if PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-R.Top) div 2), MonRect)
    or PointInRect(Point(R.Left, R.Top), MonRect)
    or PointInRect(Point(R.Left, R.Bottom), MonRect)
    or PointInRect(Point(R.Right, R.Top), MonRect)
    or PointInRect(Point(R.Right, R.Bottom), MonRect) then
    Result := True;
end;

procedure TMainForm.FlashTask(pItem : TTaskItem; Index : integer);
var
  n : integer;
  pTaskItem : TSharpETaskItem;
begin
  DebugOutPutInfo('TMainForm.FlashTask (Procedure)');
  if pItem = nil then exit;

  for n := 0 to IList.Count - 1 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    if pTaskItem <> nil then
       if pTaskItem.Handle = pItem.Handle then
       begin
         if pTaskItem.Down then exit;
         pTaskItem.Flashing := True;
         exit;
       end;
  end;
end;

procedure TMainForm.ActivateTask(pItem : TTaskItem; Index : integer);
var
  n : integer;
  pTaskItem : TSharpETaskItem;
begin
  DebugOutPutInfo('TMainForm.ActivateTask (Procedure)');
  if (pItem = nil) and (Index = - 1) then
  begin
    for n := IList.Count - 1 downto 0 do
    begin
      pTaskItem := TSharpETaskItem(IList.Items[n]);
      if pTaskItem <> nil then
         if pTaskItem.Down then
         begin
           pTaskItem.Down := False;
         end;
    end;
    exit;
  end;

  if pItem = nil then exit;

  pTaskItem := nil;
  CheckFilterAll;

  TM.LastActiveTask := pItem.Handle;
  for n := IList.Count - 1 downto 0 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    if pTaskItem <> nil then
    begin
      if (pItem.Handle <> pTaskItem.Handle) and (pTaskItem.Down) then
      begin
         pTaskItem.Down := False
      end
      else if pItem.Handle = pTaskItem.Handle then
      begin
        pTaskItem.Down := True;
        if pTaskItem.Flashing then pTaskItem.Flashing := False;
        UpdateIcon(pTaskItem,pItem);
        pTaskItem.Repaint;
      end;
    end;
  end;
end;

procedure TMainForm.NewTask(pItem : TTaskItem; Index : integer);
var
  pTaskItem : TSharpETaskItem;
  n: Integer;
begin
  DebugOutPutInfo('TMainForm.NewTask (Procedure)');
  if pItem = nil then exit;

  for n := 0 to IList.Count - 1 do
    if TSharpETaskItem(IList.Items[n]).tag = integer(pItem) then
      exit;

  if not CheckFilter(pItem) then
  begin
    pItem.Used := False;
    exit;
  end else pItem.Used := True;
  pTaskItem := TSharpETaskItem.Create(self);
  CalculateItemWidth(IList.Count + 1);

  IList.Add(pTaskItem);
  pTaskItem.SkinManager := mInterface.SkinInterface.SkinManager;
  pTaskItem.Width := sCurrentWidth;
  pTaskItem.Parent := self;
  pTaskItem.Left := Width;
  pTaskItem.AutoPosition := True;
  pTaskItem.Margin := 0;
  pTaskItem.Flashing := False;
  pTaskItem.Caption := pItem.Caption;
  pTaskItem.Handle := pItem.Handle;
  pTaskItem.State := sState;
  pTaskItem.Tag := integer(pItem);
  UpdateIcon(pTaskItem,pItem);
  pTaskItem.OnClick := SharpETaskItemClick;
  pTaskItem.OnDblClick := SharpETaskItemClick;
  pTaskItem.OnMouseUp := OnTaskItemMouseUp;
  pTaskItem.OnMouseDown := OnTaskItemMouseDown;
  pTaskItem.OnMouseMove := OnTaskItemMouseMove;
  ToolTipApi.AddToolTip(FTipWnd,Self,pTaskItem.Handle,
                        Rect(pTaskItem.Left,pTaskItem.Top,
                             pTaskItem.Left + pTaskItem.Width,
                             pTaskItem.Top + pTaskItem.Height),
                             pTaskItem.Caption);
  if not FLocked then
  begin
    ReAlignComponents(True);
    AlignTaskComponents;
  end;

  FRefreshOnNextMouseMove := True;
end;

procedure TMainForm.TaskExchange(pItem1,pItem2 : TTaskItem; n,i : integer);
var
  index1,index2 : integer;
begin
  DebugOutPutInfo('TMainForm.TaskExchange (Procedure)');
  if (pItem1 = nil) or (pItem2 = nil) then exit;

  index1 := -1;
  index2 := -1;
  for n:= 0 to IList.Count - 1 do
  begin
    if TSharpETaskItem(IList.Items[n]).Handle = pItem1.Handle then index1 := n;
    if TSharpETaskItem(IList.Items[n]).Handle = pItem2.Handle then index2 := n;
    if (index1 <> -1) and (index2 <> -1) then break;
  end;
  if ((index1 = - 1) or (index2 = -1))
     or ((index1 = index2)) then exit;
  IList.Exchange(index1,index2);
  AlignTaskComponents;
  TSharpETaskItem(IList.Items[index1]).Repaint;
  TSharpETaskItem(IList.Items[index2]).Repaint;  
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  SharpApi.RequestWindowList(Handle);
end;

procedure TMainForm.RemoveTask(pItem : TTaskItem; Index : integer);
var
  n : integer;
begin
  DebugOutPutInfo('TMainForm.RemoveTask (Procedure)');
  if pItem = nil then exit;

  for n := IList.Count - 1 downto 0 do
    if TSharpETaskItem(IList.Items[n]).Handle = pItem.Handle then
    begin
      if TSharpETaskItem(IList.Items[n]) = FMoveItem then
        FMoveItem := nil;
      ToolTipApi.DeleteToolTip(FTipWnd,Self,TSharpETaskItem(IList.Items[n]).Handle);
      IList.Delete(n);
    end;
  CalculateItemWidth(IList.Count);
  if not FLocked then
  begin
    ReAlignComponents(True);
    AlignTaskComponents;
  end;

  FRefreshOnNextMouseMove := False;
end;

procedure TMainForm.UpdateTask(pItem : TTaskItem; Index : integer);
var
  pTaskItem : TSharpETaskItem;
  n : integer;
begin
  DebugOutPutInfo('TMainForm.UpdateTask (Procedure)');
  if pItem = nil then exit;

  CheckFilterAll;
  pTaskItem := nil;
  for n := 0 to IList.Count - 1 do
    if TSharpETaskItem(IList.Items[n]).Handle = pItem.Handle then
    begin
      pTaskItem := TSharpETaskItem(IList.Items[n]);
      break;
    end;

  if pTaskItem = nil then exit;

  UpdateIcon(pTaskItem,pItem);
  pTaskItem.Caption := pItem.Caption;
  ToolTipApi.UpdateToolTipText(FTipWnd,Self,pTaskItem.Handle,pTaskItem.Caption);

  AlignTaskComponents;
end;

procedure TMainForm.SharpETaskItemClick(Sender: TObject);
var
  pItem : TTaskItem;
begin
  DebugOutPutInfo('TMainForm.SharpETaskItemClick (Procedure)');
  if (Sender = nil) or (FHasMoved) then exit;

  if not (Sender is TSharpETaskItem) then exit;
  pItem := TM.GetItemByHandle(TSharpETaskItem(Sender).Handle);

  if pItem <> nil then
  begin
    FPreviewWndHandle := pItem.Handle;
    if FPreviewWnd <> nil then
    begin
      FPreviewWnd.HideWindow(True);
      FPreviewWnd.Free;
      FPreviewWnd := nil;
    end;
    pItem.UpdateVisibleState;
    if (not pItem.Visible) or (TM.LastActiveTask <> TSharpETaskItem(Sender).Handle) then
    begin
      pItem.Restore;
    end else
    begin
      TSharpETaskItem(Sender).Down := False;
      pItem.Minimize;
    end;
  end;
end;

procedure TMainForm.WMCopyData(var msg : TMessage);
var
  ms : TMemoryStream;
  cds : PCopyDataStruct;
begin
  cds := PCopyDataStruct(msg.lParam);
  if msg.WParam = WM_REQUESTWNDLIST then
  begin
    ms := TMemoryStream.Create;
    ms.Write(cds^.lpData^,cds^.cbData);
    ms.Position := 0;
    TM.LoadFromStream(ms,cds.dwData);
    ms.Free;
    msg.result := 1;
    CompleteRefresh;
    if TM.SortTasks then TM.DoSortTasks;
  end;
end;

procedure TMainForm.WMShellHook(var msg : TMessage);
begin
  msg.Result := 0;
  if TM = nil then
    exit;

  DebugOutPutInfo('TMainForm.WMShellHook (Message Procedure)');
  if Cardinal(msg.LParam) = Handle then exit;

  try // fix for a very rare list index out of bounds error caused by
      // wnd proc hooks of JVCL components
    TM.HandleShellMessage(msg.WParam,Cardinal(msg.LParam));
  except
  end;

  if (msg.wparam = HSHELL_WINDOWACTIVATED) or
    (msg.wparam = HSHELL_WINDOWACTIVATED + 32768) then
    FLastDragItem := nil;
end;

procedure TMainForm.InitHook;
begin
  DebugOutPutInfo('TMainForm.InitHook (Procedure)');
  SharpApi.RegisterShellHookReceiver(Handle);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  CurrentVWM := SharpApi.GetCurrentVWM;

  FMoveToVWMIcon := TBitmap.Create;
  FMoveToVWMIcon.LoadFromResourceName(hInstance,'movetovwm');

  FTipWnd := ToolTipApi.RegisterToolTip(self);

  DebugOutPutInfo('TMainForm.FormCreate (Procedure)');
  FCustomSkinSettings := TSharpECustomSkinSettings.Create;
  DoubleBuffered := True;

  FDminA := TBitmap32.Create;
  FDmaxA := TBitmap32.Create;

  SaveAssign(ses_minall.Glyph32,FDminA);
  SaveAssign(ses_maxall.Glyph32,FDmaxA);

  FRefreshOnNextMouseMove := False;

  sIFilter := False;
  sEFilter := False;
  sMinAllButton := False;
  sMaxAllButton := False;
  sTogAllButton := False;
  sMaxwidth  := 128;
  IList := TObjectList.Create(True);
  IList.Clear;
  TM := TTaskManager.Create;
  TM.Enabled := True;
  TM.OnNewTask := NewTask;
  TM.OnRemoveTask := RemoveTask;
  TM.OnUpdateTask := UpdateTask;
  TM.OnActivateTask := ActivateTask;
  TM.OnFlashTask    := FlashTask;
  TM.OnTaskExchange := TaskExChange;

  FLocked := True;
  FLocked := False;
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if FTipWnd <> 0 then
     DestroyWindow(FTipWnd); 

  DebugOutPutInfo('TMainForm.FormDestroy (Procedure)');
  FCustomSkinSettings.Free;
  FDminA.Free;
  FDmaxA.Free;
  FMoveToVWMIcon.Free;
  TM.Free;
  IList.Clear;
  IList.Free;
  UnRegisterShellHookReceiver(Handle);
  sIFilters.Free;
  sEFilters.Free;
  sFilters.Free;
  setlength(sIGlobalFilters,0);
end;

procedure TMainForm.ses_minallClick(Sender: TObject);
begin
  DebugOutPutInfo('TMainForm.ses_minallClick (Procedure)');
  FLocked := True;

  SharpApi.SharpExecute('!MinimizeAll');

  FLocked := False;
  RealignComponents(True);
end;

procedure TMainForm.ses_MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FPreviewWnd <> nil then
  begin
    FPreviewWnd.Free;
    FPreviewWnd := nil;
  end;
end;

procedure TMainForm.ses_MouseEnter(Sender: TObject);
begin
  ToolTipApi.EnableToolTip(FTipWnd);
end;

procedure TMainForm.ses_MouseLeave(Sender: TObject);
begin
  ToolTipApi.DisableToolTip(FTipWnd);
end;

procedure TMainForm.ses_togallClick(Sender: TObject);
begin
  SharpApi.SharpExecute('!ToggleAll');
end;

procedure TMainForm.ses_maxallClick(Sender: TObject);
begin
  DebugOutPutInfo('TMainForm.ses_maxallClick (Procedure)');
  FLocked := True;

  SharpApi.SharpExecute('!RestoreAll');

  FLocked := False;
  RealignComponents(True);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  DropTarget.Control := self;
end;

procedure TMainForm.DropTargetDragOver(Sender: TJvDropTarget;
  var Effect: TJvDropEffect);
var
  p : TPoint;
  n : integer;
  pItem : TSharpETaskItem;
  ptmitem,ptmitemold : TTaskItem;
begin
  p := ScreenToClient(Mouse.CursorPos);
  for n := 0 to IList.Count - 1 do
  begin
    pItem := TSharpETaskItem(IList.Items[n]);
    if PointInRect(p,Rect(pItem.Left,pItem.Top,pItem.Left + pItem.Width,pItem.Top + pItem.Height)) then
    begin
      if pItem <> FLastDragItem then
      begin
        ptmitem := TM.GetItemByHandle(pItem.Handle);
        if ptmitem <> nil then
        begin
          if (FLastDragMinimized) and (FLastDragItem <> nil) then
          begin
            ptmitemold := TM.GetItemByHandle(FLastDragItem.Handle);
            if ptmitemold <> nil then
               ptmitemold.Minimize;
          end;
          FLastDragMinimized := IsIconic(ptmitem.Handle);
          ptmitem.Restore;
          FLastDragItem := pItem;
        end;
      end;
      exit;
    end;
  end;
end;

end.
