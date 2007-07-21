{
Source Name: uSharpCoreMainWnd
Description: Main application window unit
Copyright (C) Lee Green

Dependencies: JCL, CoolTray

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
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
unit uSharpCoreMainWnd;

interface

uses
  // Standard Delphi
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  shellapi,
  ComCtrls,
  Menus,
  StdCtrls,
  ExtCtrls,
  ImgList,
  ToolWin,
  Buttons,

  // Jedi
  JclFileUtils,

  // SharpE
  SharpAPI,

  // Program Units
  uSharpCoreServiceList,
  pngimage,
  AppEvnts, PngImageList, SharpESkinManager, XPMan, JvComponentBase, JvTrayIcon;

type
  TSharpCoreMainWnd = class(TForm)
    mnuTray: TPopupMenu;
    ExitSharpCore1: TMenuItem;
    ViewServiceManager1: TMenuItem;
    N1: TMenuItem;
    Panel1: TPanel;
    Panel3: TPanel;
    sbList: TScrollBox;
    Settings1: TMenuItem;
    miCheckShell: TMenuItem;
    miDisplayLogo: TMenuItem;
    SetshelltoExplorer1: TMenuItem;
    mnuServices: TPopupMenu;
    miEnDisService: TMenuItem;
    N2: TMenuItem;
    SendCMsg1: TMenuItem;
    miStartupOpt: TMenuItem;
    miRunOnce: TMenuItem;
    miRunAlways: TMenuItem;
    ImageList1: TImageList;
    SeperateExplorerProcessADMIN1: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    N5: TMenuItem;
    SharpeShellorg1: TMenuItem;
    SubmitBug1: TMenuItem;
    imlTray: TImageList;
    Online1: TMenuItem;
    Sourceforge1: TMenuItem;
    PngImageList1: TPngImageList;
    N3: TMenuItem;
    ShutdownSharpEcloseallcomponents1: TMenuItem;
    XPManifest1: TXPManifest;
    trayicon: TJvTrayIcon;
    procedure ShutdownSharpEcloseallcomponents1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ExitSharpCore1Click(Sender: TObject);
    procedure ViewServiceManager1Click(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure StartupOptions(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);

    procedure sbListMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sbListMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure SetshelltoExplorer1Click(Sender: TObject);
    procedure mnuTrayPopup(Sender: TObject);
    procedure miCheckShellClick(Sender: TObject);
    procedure miDisplayLogoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miEnDisServiceClick(Sender: TObject);
    procedure SendCMsg1Click(Sender: TObject);
    procedure FreeAllBeforeExit;
    procedure SeperateExplorerProcessADMIN1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure SharpeShellorg1Click(Sender: TObject);
    procedure SubmitBug1Click(Sender: TObject);
    procedure Sourceforge1Click(Sender: TObject);
    procedure trayiconDblClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure trayiconMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    procedure CloseCore(var Msg: TMessage); message WM_APP + 1;
    procedure GetCopyData(var Msg: TMessage); message wm_CopyData;
    procedure ActionMsg(var Msg: TMessage); message WM_SHARPEACTIONMESSAGE;
    procedure ActionUpdateMsg(var Msg: TMessage); message
      WM_SHARPEUPDATEACTIONS;
    procedure BeforeShutDown(var Msg: TMessage); message wm_queryendsession;
    procedure ReloadServiceSettings(var Msg: TMessage); message WM_SHARPCENTERMESSAGE;
    procedure SharpTerminate(var Msg: TMessage); message WM_SHARPTERMINATE;
  public

  end;

var
  SharpCoreMainWnd: TSharpCoreMainWnd;
  magicDWord: DWord = $49474541;
  lastselected: integer;
  org: tpoint;
  xx, yy: Integer;

type
  TMsgData = record
    Command: string[255];
    Parameters: string[255];
  end;
  pMsgData = ^TMsgData;

function SwitchToThisWindow(Wnd : hwnd; fAltTab : boolean) : boolean; stdcall; external 'user32.dll';

implementation

uses
  uSharpCoreServiceMan,
  uSharpCoreStrings,
  uSharpCoreImplementer,
  uSharpCoreHelperMethods,
  uSharpCoreSettings,
  uSharpCoreShutdown;

{$R *.dfm}

procedure TSharpCoreMainWnd.SharpTerminate(var Msg: TMessage);
begin
  FreeAllBeforeExit;

  Application.Terminate;
end;

procedure TSharpCoreMainWnd.CloseCore(var Msg: TMessage);
begin
  FreeAllBeforeExit;

  Application.Terminate;
end;

procedure TSharpCoreMainWnd.ExitSharpCore1Click(Sender: TObject);
begin
  FreeAllBeforeExit;

  // Terminate the Application
  Application.Terminate;
end;

procedure TSharpCoreMainWnd.ViewServiceManager1Click(Sender: TObject);
begin
  // Show Service Manager
  SharpCoreMainWnd.Show;
end;

procedure TSharpCoreMainWnd.GetCopyData(var Msg: TMessage);
var
  ManagerCmd, Parameters: string;
  CurrentService: string;
  filename: string;
  i: integer;
  msgdata: TMsgData;
  SResult: Integer;
  position: integer;
  tName, tCmd: string;
begin
  with ServiceManager do begin
    if not (Assigned(ServiceList)) then
      exit;

    // Tiny delay
    trayicon.IconIndex := 1;

    // Extract the Message Data
    msgdata := pMsgData(PCopyDataStruct(msg.lParam)^.lpData)^;

    try

      // Extract the manager Cmd to use

      ManagerCmd := lowercase(msgdata.Command);
      Parameters := msgdata.Parameters;

      for i := 0 to Pred(ServiceList.Count) do begin

        // Start
        if ManagerCmd = '_servicestart' then begin
          CurrentService :=
            lowercase(extractfilename(PathRemoveExtension(ServiceList.Info[i].Name)));
          if CurrentService = lowercase(Parameters) then begin

            filename := SharpCoreServicePath + parameters +
              ServiceManager.ServiceExt;
            SResult := ServiceManager.Start(filename, false);
            if SResult = MR_Ok then
              ServiceList.Info[i].Status := ssStarted
            else
              Msg.Result := SResult;

            ServiceManager.UpdateServicesView(sbList);
          end;
        end;

        // Stop
        if ManagerCmd = '_servicestop' then begin
          CurrentService :=
            lowercase(extractfilename(PathRemoveExtension(ServiceList.Info[i].Name)));
          if CurrentService = lowercase(Parameters) then begin

            filename := SharpCoreServicePath + parameters +
              ServiceManager.ServiceExt;

            SResult := ServiceManager.unload(filename);
            if SResult = MR_STOPPED then
              ServiceList.Info[i].Status := ssStopped
            else
              Msg.Result := SResult;

            ServiceManager.UpdateServicesView(sbList);
          end;
        end;

        // Stop
        if ManagerCmd = '_isstarted' then begin
          CurrentService :=
            lowercase(extractfilename(PathRemoveExtension(ServiceList.Info[i].Name)));
          if CurrentService = lowercase(Parameters) then begin
            if ServiceList.Info[i].Status = ssStopped then
              msg.Result := MR_STOPPED
            else
              Msg.Result := MR_STARTED;
            exit;
          end;
        end;

        // msg
        if ManagerCmd = '_servicemsg' then begin

          // extract the parameters
          position := pos('.', parameters);
          tName := copy(Parameters, 1, position - 1);
          tCmd := copy(Parameters, position + 1, length(parameters) - position +
            1);

          CurrentService :=
            lowercase(extractfilename(PathRemoveExtension(ServiceList.Info[i].Name)));
          if CurrentService = lowercase(tName) then begin

            if ServiceList.Info[i].Status = ssStarted then begin
              SResult := ServiceManager.SendMsg(CurrentService, tCmd);
              Msg.Result := SResult;
              Exit;
            end
            else begin
              Msg.Result := MR_ERRORSTARTING;
              Exit;
            end;
          end;
        end;
      end;
    finally
      sleep(5);
      trayicon.IconIndex := 0;
    end;
  end;
end;

procedure TSharpCoreMainWnd.FormCreate(Sender: TObject);
begin
  KeyPreview := True;
  sbList.DoubleBuffered := True;

  SetWindowLong(Application.Handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW or
    WS_EX_TOPMOST);
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW or WS_EX_TOPMOST);

end;

procedure TSharpCoreMainWnd.StartupOptions(Sender: TObject);
var
  s: string;
begin
  with ServiceManager do begin
    s := ServiceList.Info[ItemSelectedID].FileName;
    SetStartupType(s, TMenuitem(sender).Tag);

    TMenuItem(Sender).Checked := true;
    UpdateServicesView(sbList);
  end;
end;

procedure TSharpCoreMainWnd.FormClose(Sender: TObject; var Action:
  TCloseAction);
begin
  Action := caNone;
  Hide;
end;

procedure TSharpCoreMainWnd.FormResize(Sender: TObject);
begin
  ServiceManager.UpdateServicesView(SharpCoreMainWnd.sbList);
end;

procedure TSharpCoreMainWnd.sbListMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  sbList.VertScrollBar.Position := sbList.VertScrollBar.Position + 25;
end;

procedure TSharpCoreMainWnd.sbListMouseWheelUp(Sender: TObject; Shift:
  TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  sbList.VertScrollBar.Position := sbList.VertScrollBar.Position - 25;
end;

procedure TSharpCoreMainWnd.SetshelltoExplorer1Click(Sender: TObject);
begin
  if MessageDlg(rsRevertShellExplorer, mtInformation, mbYesNoCancel, 0) =
    mrYes then begin
    SCI.ShellMgr.WriteExplorer;
    MessageDlg(rsExplorerRestored, mtInformation, [mbyes, mbno], 0);
    Application.Terminate;
  end;
end;

procedure TSharpCoreMainWnd.mnuTrayPopup(Sender: TObject);
begin
  miCheckShell.Checked := CompSettings.ShellCheck;
  miDisplayLogo.Checked := CompSettings.ShowSplash;
end;

procedure TSharpCoreMainWnd.miCheckShellClick(Sender: TObject);
begin
  CompSettings.ShellCheck := not (TMenuItem(Sender).Checked);
  CompSettings.Save;
end;

procedure TSharpCoreMainWnd.miDisplayLogoClick(Sender: TObject);
begin
  CompSettings.ShowSplash := not (TMenuItem(Sender).Checked);
  CompSettings.Save;
end;

procedure TSharpCoreMainWnd.ActionMsg(var Msg: TMessage);
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
       (GetWindowLong(Wnd, GWL_HWNDPARENT) = GetDesktopWindow)) and
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
      with PParam(_LParam)^ do
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
  ShutDown : TScShutDown;
  dmsg : String;
  n : integer;
  BarList : THandleArray;
  BarHidden : boolean;
begin
  // shutdown?
  if (Msg.LParam >= 1) and (Msg.LParam <=4) then
  begin
    ShutDown := TScShutDown.Create(nil);
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
      if MessageBox(Handle,
                    PChar('Do you really want to ' + dmsg + ' your Computer now?'),
                    PChar('Confirm ' + dmsg),MB_YESNO) = ID_YES then
         ShutDown.Execute;
    finally
      ShutDown.Free;
    end;
    exit;
  end;

  if (Msg.LParam = 5) or (Msg.LParam = 6) then
  begin
    setlength(EnumParam.wndlist,0);
    EnumWindows(@EnumWindowsProc, Integer(@EnumParam));
  end;

  case Msg.LParam of
    0: begin
         // Show/Hide Manager
         SharpCoreMainWnd.Visible := not (SharpCoreMainWnd.Visible);
       end;
    5: begin
         // Minimize All Windows
         for n := 0 to High(EnumParam.Wndlist) do
             CloseWindow(EnumParam.WndList[n]);
       end;
    6: begin
         // Restore All Windows
         for n := 0 to High(EnumParam.WndList) do
             if IsIconic(EnumParam.WndList[n]) then ShowWindow(EnumParam.WndList[n], SW_Restore)
                else SwitchToThisWindow(EnumParam.WndList[n],True);
       end;
    7: begin
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

procedure TSharpCoreMainWnd.ActionUpdateMsg(var Msg: TMessage);
begin
  RegisterActionEx('!ToggleServiceManager', 'SharpCore', SharpCoreMainWnd.Handle, 0);
  RegisterActionEx('!Restart', 'Shutdown', SharpCoreMainWnd.Handle, 1);
  RegisterActionEx('!Shutdown', 'Shutdown', SharpCoreMainWnd.Handle, 2);
  RegisterActionEx('!Logout', 'Shutdown', SharpCoreMainWnd.Handle, 3);
  RegisterActionEx('!Hibernate', 'Shutdown', SharpCoreMainWnd.Handle, 4);
  RegisterActionEx('!MinimizeAll', 'Tasks', SharpCoreMainWnd.Handle, 5);
  RegisterActionEx('!RestoreAll', 'Tasks', SharpCoreMainWnd.Handle, 6);
  RegisterActionEx('!ToggleAllBars', 'SharpBar', SharpCoreMainWnd.Handle, 7);
end;

var
  h: HICON;

procedure TSharpCoreMainWnd.FormShow(Sender: TObject);
begin
  sbList.DoubleBuffered := True;
  Panel1.DoubleBuffered := True;
  Panel3.DoubleBuffered := True;

end;

procedure TSharpCoreMainWnd.BeforeShutDown(var Msg: TMessage);
begin
  Msg.Result := 1;

  try
    FreeAllBeforeExit;
  finally
    Msg.Result := -1;
  end;
end;

procedure TSharpCoreMainWnd.miEnDisServiceClick(Sender: TObject);
var
  sname: string;
  st: Integer;
  sid: Integer;
begin
  sid := ServiceManager.ItemSelectedID;
  with ServiceManager, ServiceList.Info[sid] do begin
    sname := FileName;
    if SrvType = stNever then
      st := 1 //stRunAlways
    else
      st := 2; //stDontRun

    SetStartupType(sname, st);
    UpdateServicesView(sbList);
  end;
end;

procedure TSharpCoreMainWnd.SendCMsg1Click(Sender: TObject);
var
  sname: string;
  msg: string;
begin
  with ServiceManager do begin
    sname := ServiceList.Info[ItemSelectedID].Name;
    msg := InputBox('SharpCore Message', 'Enter Command', '');
    if msg <> '' then
      SendMsg(sname, msg);
  end;
end;

procedure TSharpCoreMainWnd.FreeAllBeforeExit;
begin
  DInfo('FreeAllBeforeExit');

  // Attempt to unload all loaded services
  DInfo('Close and Free Services');
  ServiceManager.UnInitialiseServices;

  // Free Classes
  try
    compsettings.free;
    ServiceManager.free;
  except
    DInfo('Problem freeing components, ' + inttostr(error));
  end;
end;

procedure TSharpCoreMainWnd.SeperateExplorerProcessADMIN1Click(Sender: TObject);
begin
  SCI.ApplySep;
end;

procedure TSharpCoreMainWnd.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Self.Hide;
end;

procedure TSharpCoreMainWnd.ApplicationEventsMinimize(Sender: TObject);
begin
  Self.Hide;
end;

procedure TSharpCoreMainWnd.SharpeShellorg1Click(Sender: TObject);
begin
  SharpExecute('http://www.sharpe-shell.org');
end;

procedure TSharpCoreMainWnd.SubmitBug1Click(Sender: TObject);
begin
  SharpExecute('http://trac.sharpe-shell.org/index.fcgi/report');
end;

procedure TSharpCoreMainWnd.trayiconDblClick(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SharpCoreMainWnd.Show;
end;

procedure TSharpCoreMainWnd.trayiconMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
     mnuTray.Popup(x,y);
end;

procedure TSharpCoreMainWnd.Sourceforge1Click(Sender: TObject);
begin
  SharpExecute('http://sourceforge.net/projects/sharpe/');
end;

procedure TSharpCoreMainWnd.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  sFn: string;
begin
  sFn := SharpCoreSettingsPath + 'ServiceList.xml';
  DeleteFile(sFn);
end;

procedure TSharpCoreMainWnd.ReloadServiceSettings(var Msg: TMessage);
var
  tmpInfo: TInfo;
begin
  if Msg.WParam = SCM_EVT_UPDATE_SETTINGS then begin
  with ServiceManager do begin
    case Msg.LParam of
      SCU_SHARPCORE: ; // reload sharpcore settings
      SCU_SERVICE: begin
          tmpInfo := ServiceList.FindObject(Msg.LParam);

          if tmpInfo.Status = ssStarted then

            if @tmpInfo.DllProcess <> nil then
              tmpInfo.DllProcess.Reload;

        end;
    end;
  end;
  end;
end;

procedure TSharpCoreMainWnd.FormDestroy(Sender: TObject);
begin
  trayicon.Free;
end;

procedure TSharpCoreMainWnd.ShutdownSharpEcloseallcomponents1Click(
  Sender: TObject);
begin
  SharpApi.CloseComponent('SharpBar');
  SharpApi.SharpEBroadCast(WM_SHARPTERMINATE,0,0);
end;

initialization
  h := LoadCursor(0, IDC_HAND);
  if h <> 0 then begin
    Screen.Cursors[crHandPoint] := h;
    // you can put here as many replacements as you want
  end;
end.

