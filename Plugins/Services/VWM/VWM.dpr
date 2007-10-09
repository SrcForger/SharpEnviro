{
Source Name: VWM.service                                   
Description: Virtual Window Manager Service                                            
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
                                                                     
library VWM;                                                
                                                                     
uses
  Windows,
  Classes,
  Messages,
  Math,
  SharpAPI,
  SharpCenterApi,
  SysUtils,
  JclSimpleXML,
  VWMFunctions in '..\..\..\Common\Units\VWM\VWMFunctions.pas',
  uSystemFuncs in '..\..\..\Common\Units\SystemFuncs\uSystemFuncs.pas';

{$E ser}
                                                                     
{$R *.res}


type
  TActionEvent = Class(TObject)
    procedure MessageHandler(var Message: TMessage);
  end;

var
  VWMMsgWndClass: TWndClass = (
    style: 0;
    lpfnWndProc: @DefWindowProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'SharpE_VWM');

const
  VWMStartMessage = 5;

var
  ActionEvent: TActionEvent;
  Handle: THandle;
  CurrentDesktop : integer;
  VWMCount : integer;
  sFocusTopMost : boolean;
  sFollowFocus : boolean;

procedure AllocateMsgWnd;
var
  TempClass: TWndClass;
  ClassRegistered: Boolean;
begin
  VWMMsgWndClass.hInstance := HInstance;
{$IFDEF PIC}
  UtilWindowClass.lpfnWndProc := @DefWindowProc;
{$ENDIF}
  ClassRegistered := GetClassInfo(HInstance, VWMMsgWndClass.lpszClassName,TempClass);
  if not ClassRegistered or (TempClass.lpfnWndProc <> @DefWindowProc) then
  begin
    if ClassRegistered then
      Windows.UnregisterClass(VWMMsgWndClass.lpszClassName, HInstance);
    Windows.RegisterClass(VWMMsgWndClass);
  end;
  Handle := CreateWindowEx(WS_EX_TOOLWINDOW, VWMMsgWndClass.lpszClassName,
                            '', WS_POPUP {+ 0}, 0, 0, 0, 0, 0, 0, HInstance, nil);
  SetWindowLong(Handle, GWL_WNDPROC, Longint(MakeObjectInstance(ActionEvent.MessageHandler)));
end;

procedure DeAllocateMsgWnd;
var
  Instance: Pointer;
begin
  Instance := Pointer(GetWindowLong(Handle, GWL_WNDPROC));
  DestroyWindow(Handle);
  if Instance <> @DefWindowProc then FreeObjectInstance(Instance);
end;

procedure LoadVWMSettings;
var
  XML : TJclSimpleXML;
  Dir : String;
  FName : String;
  fileloaded : boolean;
begin
  VWMCount := 4;
  SharpApi.UnRegisterShellHookReceiver(Handle);
  sFocusTopMost := False;
  sFollowFocus := False;
  Dir := GetSharpeUserSettingsPath + 'SharpCore\Services\';
  FName := Dir + 'VWM.xml';
  if FileExists(FName) then
  begin
    XML := TJclSimpleXML.Create;
    try
      XML.LoadFromFile(FName);
      fileloaded := True;
    except
      fileloaded := False;
    end;
    if FileLoaded then
    begin
      VWMCount := XML.Root.Items.IntValue('VWMCount',VWMCount);
      VWMCount := Max(2,Min(VWMCount,12));
      sFocusTopMost := XML.Root.Items.BoolValue('FocusTopMost',sFocusTopMost);
      sFollowFocus := XML.Root.Items.BoolValue('FollowFocus',sFollowFocus);
    end;
    XML.Free;
  end;
  if sFollowFocus then
    SharpApi.RegisterShellHookReceiver(Handle);
end;

procedure RegisterSharpEActions;
var
  n : integer;
begin
  // Register Actions
  SharpApi.RegisterActionEx('!AllToOneVWM','VWM',handle,0);
  SharpApi.RegisterActionEx('!NextVWM','VWM',handle,1);
  SharpApi.RegisterActionEx('!PreviousVWM','VWM',handle,2);

  for n := 0 to VWMCount - 1 do
    SharpApi.RegisterActionEx(PChar('!SwitchToVWM(' + inttostr(n+1) + ')'),
                              'VWM',
                              handle,
                              VWMStartMessage + n);
end;
                                                                     
procedure UnregisterSharpEActions;
var
  n : integer;
begin                                                                
  // Unregister Actions
  SharpApi.UnRegisterAction('!AllToOneVWM');
  SharpApi.UnRegisterAction('!NextVWM');
  SharpApi.UnRegisterAction('!PreviousVWM');

  for n := 0 to VWMCount - 1 do
    SharpApi.UnRegisterAction(PCHar('!SwitchToVWM(' + inttostr(n+1) + ')'));
end;
                                                                     
procedure TActionEvent.MessageHandler(var Message: TMessage);
var
  newdesk : integer;
  changed : boolean;
  wnd : hwnd;
begin
  changed := False;
  // Message Handlers
  case Message.Msg of
    WM_SHARPEACTIONMESSAGE:
      begin
        case Message.lparam of
          0: begin // !AllToOneVWM
               VWMFunctions.VWMMoveAllToOne; // has to be called two times ...
               VWMFunctions.VWMMoveAllToOne; // ... reason ... unknown =)
               Changed := True;
             end;
          1: begin // !NextVWM
               newdesk := CurrentDesktop + 1;
               if newdesk > VWMCount then
                newdesk := 1;
               VWMFunctions.VWMSwitchDesk(CurrentDesktop,newdesk,sFocusTopMost);
               CurrentDesktop := newdesk;
               Changed := True;
             end;
          2: begin // !NextVWM
               newdesk := CurrentDesktop - 1;
               if newdesk < 1 then
                newdesk := VWMCount;
               VWMFunctions.VWMSwitchDesk(CurrentDesktop,newdesk,sFocusTopMost);
               CurrentDesktop := newdesk;
               Changed := True;
             end;
          else
          begin
            if (Message.lparam >= VWMStartMessage)
               and (Message.lparam < VWMStartMessage + VWMCount) then
            begin
              VWMFunctions.VWMSwitchDesk(CurrentDesktop,Message.lparam - VWMStartMessage + 1,sFocusTopMost);
              CurrentDesktop := Message.lparam - VWMStartMessage + 1;
              Changed := True;
            end;
          end;
        end;
      end;
    WM_SHARPEUPDATEACTIONS:
      begin
        RegisterSharpEActions;
      end;
    WM_VWMSWITCHDESKTOP:
      begin
        if (Message.lparam > 0)
           and (Message.lparam <= VWMCount) then
        begin
          VWMFunctions.VWMSwitchDesk(CurrentDesktop,Message.lparam,sFocusTopMost);
          CurrentDesktop := Message.lparam;
          Changed := True;
          Message.Result := CurrentDesktop;
        end else Message.Result := 0;
      end;
    WM_VWMGETDESKCOUNT:
      begin
        Message.result := VWMCount;
      end;
    WM_VWMGETCURRENTDESK:
      begin
        Message.result := CurrentDesktop;
      end;
    WM_SHARPEUPDATESETTINGS:
    begin
      if Message.wparam = Integer(suVWM) then
      begin
        VWMFunctions.VWMMoveAllToOne; // has to be called two times ...
        VWMFunctions.VWMMoveAllToOne; // ... reason ... unknown =)
        LoadVWMSettings;
        SharpApi.SharpEBroadCast(WM_VWMUPDATESETTINGS,0,0);
      end;
    end;
    WM_DISPLAYCHANGE:
    begin
      VWMFunctions.VWMMoveAllToOne; // has to be called two times ...
      VWMFunctions.VWMMoveAllToOne; // ... reason ... unknown =)
      SharpApi.SharpEBroadCast(WM_VWMUPDATESETTINGS,0,0);
    end;
    WM_SHARPSHELLMESSAGE:
    begin
      if sFollowFocus then
      begin
       wnd := Message.lparam;
       case Message.WParam of
          HSHELL_WINDOWACTIVATED,HSHELL_WINDOWACTIVATED + 32768:
          begin
            if (GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) and
               ((IsWindowVisible(Wnd) and not IsIconic(wnd)) and
               ((GetWindowLong(Wnd, GWL_HWNDPARENT) = 0) or
               (GetWindowLong(Wnd, GWL_HWNDPARENT) = Integer(GetDesktopWindow))) and
               (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0))  then
            begin
              newdesk := VWMFunctions.VWMGetWindowVWM(CurrentDesktop,VWMCount,wnd);
              if  newdesk <> CurrentDesktop then
              begin
                VWMFunctions.VWMSwitchDesk(CurrentDesktop,NewDesk,False);
                CurrentDesktop := NewDesk;
                Changed := True;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  if Changed then
    SharpApi.SharpEBroadCast(WM_VWMDESKTOPCHANGED,CurrentDesktop,0);
end;
                                                                     
// Service is started                                                
function Start(Owner: HWND): HWND;                                   
begin
  ActionEvent := TActionEvent.Create;
  AllocateMsgWnd;

  LoadVWMSettings;
  CurrentDesktop := 1;
  VWMFunctions.VWMMoveAllToOne; // has to be called two times ...
  VWMFunctions.VWMMoveAllToOne; // ... reason ... unknown =)

  Result := Owner;
  // Register Actions
  RegisterSharpEActions;

  SharpApi.SharpEBroadCast(WM_VWMUPDATESETTINGS,0,0);
end;                                                                 
                                                                     
// Service is stopped
procedure Stop;                                                      
begin
  VWMFunctions.VWMMoveAllToOne; // has to be called two times ...
  VWMFunctions.VWMMoveAllToOne; // ... reason ... unknown =)

  // Unregister Actions                                              
  UnregisterSharpEActions;                                                      
  DeAllocateMsgWnd;                                            
  ActionEvent.Free;

  VWMCount := 0;
  SharpApi.SharpEBroadCast(WM_VWMUPDATESETTINGS,0,0);
end;                                                                 
                                                                     
// Service receives a message                                        
function SCMsg(msg: string): Integer;                                
begin                                                                
  Result := HInstance;                                               
end;                                                                 
                                                                     
//Ordinary Dll code, tells delphi what functions to export.          
exports                                                              
  Start,                                                             
  Stop,                                                              
  SCMsg;                                                             
                                                                     
begin                                                                
end.
