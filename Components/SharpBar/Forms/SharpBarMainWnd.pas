{
Source Name: SharpBarMainWnd.pas
Description: SharpBar Main Form 
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

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

unit SharpBarMainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpESkinManager, SharpEScheme, SharpEBaseControls, SharpESkin,
  Menus, StdCtrls, JvSimpleXML, SharpApi, ShellHook,
  uSharpEModuleManager, SharpEButton, DateUtils, ExtCtrls,
  ImgList, PngImageList, XPMan, SharpEBar, AppEvnts;

type
  TSharpBarMainForm = class(TForm)
    PopupMenu1: TPopupMenu;
    Position1: TMenuItem;
    AutoPos1: TMenuItem;
    Bottom1: TMenuItem;
    N1: TMenuItem;
    Left1: TMenuItem;
    Right2: TMenuItem;
    Middle1: TMenuItem;
    N2: TMenuItem;
    Monitor1: TMenuItem;
    N3: TMenuItem;
    ExitMn: TMenuItem;
    FullScreen1: TMenuItem;
    N4: TMenuItem;
    PluginManager1: TMenuItem;
    PngImageList1: TPngImageList;
    Settings1: TMenuItem;
    AutoStart1: TMenuItem;
    XPManifest1: TXPManifest;
    ThrobberPopUp: TPopupMenu;
    Information1: TMenuItem;
    N5: TMenuItem;
    Delete1: TMenuItem;
    Move1: TMenuItem;
    Left2: TMenuItem;
    Right1: TMenuItem;
    CreateNewBar1: TMenuItem;
    OutofallRightModules1: TMenuItem;
    AllModulestotheLeft1: TMenuItem;
    Settings: TMenuItem;
    DisableBarHiding1: TMenuItem;
    SharpEBar1: TSharpEBar;
    SkinManager: TSharpESkinManager;
    ApplicationEvents1: TApplicationEvents;
    BarManagment1: TMenuItem;
    CreateemptySharpBar1: TMenuItem;
    BlendInTimer: TTimer;
    BlendOutTimer: TTimer;
    DelayTimer1: TTimer;
    DelayTimer2: TTimer;
    procedure DelayTimer2Timer(Sender: TObject);
    procedure DelayTimer1Timer(Sender: TObject);
    procedure BlendOutTimerTimer(Sender: TObject);
    procedure BlendInTimerTimer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CreateemptySharpBar1Click(Sender: TObject);
    procedure SkinManagerSkinChanged(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure DisableBarHiding1Click(Sender: TObject);
    procedure Right1Click(Sender: TObject);
    procedure Left2Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure SettingsClick(Sender: TObject);
    procedure Information1Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SharpEBar1ThrobberMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SharpEBar1ThrobberMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SharpEBar1ThrobberMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure AutoStart1Click(Sender: TObject);
    procedure PluginManager1Click(Sender: TObject);
    procedure SharpEBar1ResetSize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FullScreen1Click(Sender: TObject);
    procedure ExitMnClick(Sender: TObject);
    procedure Right2Click(Sender: TObject);
    procedure Middle1Click(Sender: TObject);
    procedure Left1Click(Sender: TObject);
    procedure Bottom1Click(Sender: TObject);
    procedure AutoPos1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OnMonitorPopupItemClick(Sender : TObject);
  private
    { Private-Deklarationen }
    FBarID : integer;
    FShellHookList : TStringList;
    FThemeUpdating : Boolean;
    FStartup : Boolean;
    FBarLock : Boolean;
    procedure CreateNewBar;
    procedure LoadBarModules(XMLElem : TJvSimpleXMlElem);

    // theme update;
    procedure WMThemeUpdateStart(var msg : TMessage); message WM_THEMELOADINGSTART;
    procedure WMThemeUpdateEnd(var msg : TMessage); message WM_THEMELOADINGEND;

    // shell hooks
    procedure WMRegisterShellHook(var msg : TMessage); message WM_REGISTERSHELLHOOK;
    procedure WMUnregisterShellHook(var msg : TMessage); message WM_UNREGISTERSHELLHOOK;
    procedure WMShellHook(var msg : TMessage); message WM_SHELLHOOK;

    //Modules (uSharpBarAPI.pas)
    procedure WMLockBarWindow(var msg : TMessage); message WM_LOCKBARWINDOW;
    procedure WMUnlockBarWindow(var msg : TMessage); message WM_UNLOCKBARWINDOW;

    procedure WMGetFreeBarSpace(var msg : TMessage); message WM_GETFREEBARSPACE;
    procedure WMSaveXMLFile(var msg : TMessage); message WM_SAVEXMLFILE;
    procedure WMGetXMLHandle(var msg : TMessage); message WM_GETXMLHANDLE;
    procedure WMGetBGHandle(var msg : TMessage); message WM_GETBACKGROUNDHANDLE;
    procedure WMGetBarHeight(var msg : TMessage); message WM_GETBARHEIGHT;

    procedure WMDisplayChange(var msg : TMessage); message WM_DISPLAYCHANGE;
    procedure WMUpdateBarWidth(var msg : TMessage); message WM_UPDATEBARWIDTH;
    procedure WMGetCopyData(var msg: TMessage); message WM_COPYDATA;
    procedure WMSharpEThemeUpdate(var msg : TMessage); message WM_SHARPETHEMEUPDATE;
    procedure WMSchemeUpdate(var msg : TMessage); message WM_SHARPEUPDATESETTINGS;
  //  procedure WMSystemSkinUpdate(var msg : TMessage); message WM_SYSTEMSKINUPDATE;

    procedure OnBarPositionUpdate(Sender : TObject);
  public
    procedure LoadBarFromID(ID : integer);
    procedure LoadModuleSettings;
    procedure SaveBarSettings;
  end;

const
  Debug = True;
  DebugLevel = 3;

var
  SharpBarMainForm: TSharpBarMainForm;
//  SharpESkin : TSharpESkin;
//  SharpEScheme : TSharpEScheme;
  ModuleManager : TModuleManager;
  ModuleSettings : TJvSimpleXML;
  BarMove : boolean;
  BarMovePoint : TPoint;

implementation

uses PluginManagerWnd,
     SharpEMiniThrobber,
     BarHideWnd,
     AddPluginWnd;

{$R *.dfm}

function GetControlByHandle(AHandle: THandle): TWinControl;
begin
 Result := Pointer(GetProp( AHandle,
                            PChar( Format( 'Delphi%8.8x',
                                           [GetCurrentProcessID]))));
end;

procedure DebugOutput(Msg : String; Level,msgtype : integer);
begin
  if (Debug) and (Level<=DebugLevel) then SharpAPI.SendDebugMessageEx('SharpBar',PChar(Msg),clBlack,msgtype);
end;

procedure dllcallback(handle : hwnd);
begin
end;


procedure LockWindow(const Handle: HWND);
begin
  SendMessage(Handle, WM_SETREDRAW, 0, 0);
end;

procedure UnlockWindow(const Handle: HWND);
begin
  SendMessage(Handle, WM_SETREDRAW, 1, 0);
  RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
end;

// ************************
// Window Message handlers
// ************************

{procedure TSharpBarMainForm.WMSystemSkinUpdate(var msg : TMessage);
begin
  ModuleManager.UpdateModuleSkins;
  ModuleManager.FixModulePositions;
end;
        }


procedure TSharpBarMainForm.WMLockBarWindow(var msg : TMessage);
begin
  if FStartup then exit;
  if FBarLock then exit;
  
  LockWindow(Handle);
end;

procedure TSharpBarMainForm.WMUnlockBarWindow(var msg : TMessage);
begin
  if FStartup then exit;
  if FBarLock then exit;
  
  UnLockWindow(Handle);
  SendMessage(SharpEBar1.abackground.handle, WM_SETREDRAW, 1, 0);
  RedrawWindow(SharpEBar1.abackground.handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
end;

procedure TSharpBarMainForm.WMThemeUpdateStart(var msg : TMessage);
begin
  FBarLock := True;
  LockWindow(Handle);
  FThemeUpdating := True;
  //LockWindowUpdate(Application.Handle);
  BlendInTimer.Enabled := False;
  BlendOutTimer.Tag := BlendInTimer.Tag;
  BlendOutTimer.Enabled := True;
end;

procedure TSharpBarMainForm.WMThemeUpdateEnd(var msg : TMessage);
begin
  FThemeUpdating := False;
  LoadSharpEScheme(SkinManager.Scheme);
  SharpEBar1.UpdateSkin;
  SharpEBar1.Throbber.UpdateSkin;
  SharpEbar1.Throbber.Repaint;
  ModuleManager.UpdateModuleSkins;
  ModuleManager.FixModulePositions;
  ModuleManager.RefreshMiniThrobbers;

  FBarLock := False;
  RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
  DelayTimer1.Enabled := True;
//  DelayTimer2.Enabled := True;
end;

procedure TSharpBarMainForm.WMShellHook(var msg : TMessage);
var
  n : integer;
begin
  // bar received a shell hook, forward it to all registered modules

  try
    for n := 0 to FShellHookList.Count -1 do
    begin
      PostMessage(strtoint(FShellHookList[n]),WM_ShellHook,msg.WParam,msg.LParam);
    end;
  except
  end;
end;

procedure TSharpBarMainForm.WMRegisterShellHook(var msg : TMessage);
var
  n : integer;
  Module : TModule;
begin
  for n := 0 to ModuleManager.Modules.Count - 1 do
  begin
    Module := TModule(ModuleManager.Modules.Items[n]);
    if Module.ID = msg.WParam then
       FShellHookList.Add(inttostr(Module.Handle));
  end;

  if FShellHookList.Count = 1 then
  begin
    // first module requestion a shell hook -> register the global hook
    SHSetMainHandle(self.handle);
    SHSetCallBack(@dllcallback);
    SHSetHook;
  end;
end;

procedure TSharpBarMainForm.WMUnregisterShellHook(var msg : TMessage);
begin
  FShellHookList.Delete(FShellHookList.IndexOf(inttostr(msg.WParam)));

  if FShellHookList.Count = 0 then
  begin
    SHUnsetHook;
  end;
end;


procedure TSharpBarMainForm.WMGetFreeBarSpace(var msg : TMessage);
begin
  msg.Result := ModuleManager.GetFreeBarSpace;
end;

procedure TSharpBarMainForm.WMDisplayChange(var msg : TMessage);
begin
  if BarHideForm.Visible then
  begin
    if SharpEBar1.SpecialHideForm then BarHideForm.UpdateStatus
       else BarHideForm.Close;
  end;
  SharpEBar1.UpdatePosition;
  ModuleManager.BroadCastModuleRefresh;
  ModuleManager.FixModulePositions;
end;

procedure TSharpBarMainForm.WMSchemeUpdate(var msg : TMessage);
begin
  if FThemeUpdating then exit;

  if not FStartup then LockWindow(Handle);
  FBarLock := True;
  LoadSharpEScheme(SkinManager.Scheme);
  SharpEBar1.UpdateSkin;
  SharpEBar1.Throbber.UpdateSkin;
  SharpEbar1.Throbber.Repaint;
  ModuleManager.UpdateModuleSkins;
  ModuleManager.FixModulePositions;
  ModuleManager.RefreshMiniThrobbers;
  FBarLock := False;
  UnLockWindow(Handle);
end;

procedure TSharpBarMainForm.WMSaveXMLFile(var msg : TMessage);
begin
  ModuleSettings.SaveToFile(ModuleSettings.FileName);
end;

procedure TSharpBarMainForm.WMGetXMLHandle(var msg : TMessage);
begin
  msg.Result := integer(@ModuleSettings);
end;

procedure TSharpBarMainForm.WMGetBGHandle(var msg : TMessage);
begin
  msg.result := integer(@SharpEBar1.skin);
end;

procedure TSharpBarMainForm.WMGetBarHeight(var msg : TMessage);
begin
  try
    msg.Result := strtoint(SkinManager.Skin.BarSkin.SkinDim.Height) -
                  strtoint(SkinManager.Skin.BarSkin.PAYoffset.X) -
                  strtoint(SkinManager.Skin.BarSkin.PAYoffset.Y);
  except
    msg.Result := 30;
  end;
end;


procedure TSharpBarMainForm.WMSharpEThemeUpdate(var msg : TMessage);
begin
  if FThemeUpdating then exit;
  if not FStartup then LockWindow(Handle);
  FThemeUpdating := True;
  if not FStartup then exit;

  LoadSharpEScheme(SkinManager.Scheme);
  SharpEBar1.UpdateSkin;
  SharpEBar1.Throbber.UpdateSkin;
  SharpEbar1.Throbber.Repaint;
  ModuleManager.UpdateModuleSkins;
  ModuleManager.BroadCastModuleRefresh;
  ModuleManager.ReCalculateModuleSize;
  ModuleManager.RefreshMiniThrobbers;
end;

procedure TSharpBarMainForm.WMGetCopyData(var msg: TMessage);
var
  pParams: string;
  pID    : integer;
  msgdata: TMsgData;
begin
  DebugOutput('WM_CopyData',2,1);
  // Extract the Message Data
  msgdata := pMsgData(PCopyDataStruct(msg.lParam)^.lpData)^;
  try
    pID := strtoint(lowercase(msgdata.Command));
  except
    exit;
  end;
  pParams := msgdata.Parameters;

  ModuleManager.SendPluginMessage(pID,pParams);
end;

procedure TSharpBarMainForm.WMUpdateBarWidth(var msg : TMessage);
begin
  if FThemeUpdating then exit;

  DebugOutput('WM_UpdateBarWidth',2,1);
  if not FStartup then LockWindow(Handle);
  try
    ModuleManager.ReCalculateModuleSize;
//    ModuleManager.BroadCastModuleRefresh;
    ModuleManager.FixModulePositions;
    ModuleManager.RefreshMiniThrobbers;
  finally
    if not FStartup then UnLockwindow(Handle);
  end;
end;

// ***********************


procedure TSharpBarMainForm.LoadModuleSettings;
// Load the module settings file for this bar
// User\{}\SharpBar\Module Settings\BarID.xml
var
  Dir : String;
  i : integer;
begin
  DebugOutput('Loading Module Settings',1,1);
  if FBarID <= 0 then
  begin
    DebugOutput('No Valid Bar ID given. Aborting module settings loading!',1,3);
    // Not initalized... No valid Bar ID!
    exit;
  end;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Module Settings\';
  // Check if Bar Module settings file already exists - if not create a new file
  if (not FileExists(Dir + inttostr(FBarID)+'.xml')) then
  begin
    ModuleSettings.Root.Clear;
    ModuleSettings.Root.Name := 'SharpBarModules';
    ForceDirectories(Dir);
    ModuleSettings.SaveToFile(Dir + inttostr(FBarID)+'.xml');
    // Set FileName property and load file!
    ModuleSettings.FileName := Dir + inttostr(FBarID)+'.xml';
  end;

  begin
    try
      DebugOutput('Loading file '+Dir + inttostr(FBarID)+'.xml',2,1);
      // Set FileName property and load file!
      ModuleSettings.FileName := Dir + inttostr(FBarID)+'.xml';
    except
      DebugOutput('Error while loading or parsing the xml file',1,3);
      // error while loading or parsing the xml file
      // create backup and reset file
      i := DateTimeToUnix(now());
      if CopyFile(PChar(Dir + inttostr(FBarID)+'.xml'),PChar(Dir + inttostr(FBarID)+'.xml#Backup#'+inttostr(i)),True) = null then
      begin
        ShowMessage('Error Loading the Module Settings for Bar ID [' + inttostr(FBarID) + ']!' + #10#13 +
                    'Creating a Backup failed...');
      end else
      begin
        ShowMessage('Error Loading the Module Settings for Bar ID [' + inttostr(FBarID) + ']!' + #10#13 +
                    'Backup Created to: '+ #10#13 +
                    Dir + inttostr(FBarID)+'.xml#Backup#'+inttostr(i));
      end;
      ModuleSettings.Root.Clear;
      ModuleSettings.Root.Name := 'SharpBarModules';
      ForceDirectories(Dir);
      ModuleSettings.SaveToFile(Dir + inttostr(FBarID)+'.xml');
    end;
  end;
  ModuleManager.ReCalculateModuleSize;
end;

procedure TSharpBarMainForm.LoadBarModules(XMLElem : TJvSimpleXMlElem);
var
  n : integer;
begin
  if XMlElem = nil then exit;
  DebugOutput('Loading Bar Modules',1,1);

  LoadModuleSettings;
  ModuleManager.UnloadModules;
  if XMLElem.Items.ItemNamed['Modules'] <> nil then
     with XMlElem.Items.ItemNamed['Modules'] do
     begin
       for n := 0 to Items.Count-1 do
       begin
         DebugOutput('Loading: '+Items.Item[n].Items.Value('Module','')
                     +' ID:'+Items.Item[n].Items.Value('ID','-1')
                     +' Position:' +Items.Item[n].Items.Value('Position','-1'),2,1);
         ModuleManager.LoadModule(Items.Item[n].Items.IntValue('ID',-1),
                                  Items.Item[n].Items.Value('Module',''),
                                  Items.Item[n].Items.IntValue('Position',-1));
       end;
     end;
  ModuleManager.ReCalculateModuleSize;
end;

procedure TSharpBarMainForm.SaveBarSettings;
var
  xml : TJvSimpleXML;
  Dir : String;
  n,i   : integer;
  tempModule : TModule;
begin
  DebugOutput('Saving Bar Settings',1,1);
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';
  xml := TJvSimpleXMl.Create(nil);
  try
    xml.LoadFromFile(Dir + 'bars.xml');
    with xml.root.items.ItemNamed['bars'] do
    begin
      for n := 0 to Items.Count - 1 do
          if Items.Item[n].Items.IntValue('ID',0) = FBarID then
          begin
            // Save the Bar Settings
            Items.Item[n].Items.ItemNamed['Settings'].Items.Clear;
            with Items.Item[n].Items.ItemNamed['Settings'] do
            begin
              Items.Add('AutoPosition',SharpEBar1.AutoPosition);
              Items.Add('PrimaryMonitor',SharpEBar1.PrimaryMonitor);
              Items.Add('MonitorIndex',SharpEBar1.MonitorIndex);
              Items.Add('HorizPos',HorizPosToInt(SharpEBar1.HorizPos));
              Items.Add('VertPos',VertPosToInt(SharpEbar1.VertPos));
              Items.Add('AutoStart',SharpEbar1.AutoStart);
              Items.Add('ShowThrobber',SharpEBar1.ShowThrobber);
              Items.Add('DisableHideBar',SharpEBar1.DisableHideBar);
            end;
            // Save the Module List
            Items.Item[n].Items.ItemNamed['Modules'].Items.Clear;
            with Items.Item[n].Items.ItemNamed['Modules'] do
            begin
              for i := 0 to ModuleManager.Modules.Count -1 do
              begin
                tempModule := TModule(ModuleManager.Modules.Items[i]);
                with Items.Add('Item') do
                begin
                  Items.Add('ID',tempModule.ID);
                  Items.Add('Position',tempModule.Position);
                  Items.Add('Module',ExtractFileName(tempModule.ModuleFile.FileName));
                end;
              end;
            end;
          end;
    end;
  except
    DebugOutput('Error while saving bar settings',1,3);
    xml.free;
    showmessage('Error while saving bar settings');
    exit;
  end;
  ForceDirectories(Dir);
  xml.SaveToFile(Dir + 'bars.xml');
  xml.Free;
end;

procedure TSharpBarMainForm.CreateNewBar;
var
  xml : TJvSimpleXML;
  Dir : String;
  n   : integer;
  NewID : String;
  b   : boolean;
begin
  DebugOutput('Creating New Bar',1,1);
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';
  xml := TJvSimpleXMl.Create(nil);

  // Check if SharpBar settings file already exists - if not create a new file
  if (not FileExists(Dir + 'bars.xml')) then
  begin
    ForceDirectories(Dir);
    xml.Root.Name := 'SharpEBarSettings';
    xml.Root.Items.Add('bars');
    ForceDirectories(Dir);
    xml.SaveToFile(Dir + 'bars.xml');
  end;
  try
    xml.LoadFromFile(Dir + 'bars.xml');

    // Generate a new unique bar ID and make sure that there is no other
    // bar with the same ID 
    repeat
      NewID := '';
      for n := 1 to 8 do NewID := NewID + inttostr(random(9)+1);

      b := False;
      with xml.root.items.ItemNamed['bars'] do
      begin
        for n := 0 to Items.Count - 1 do
            if Items.Item[n].Items.Value('ID','0') = NewID then
            begin
              b := True;
              break;
            end;
      end;
    until not b;
    FBarID := strtoint(NewID);

    with xml.Root.Items.ItemNamed['bars'].Items.Add('Item') do
    begin
      Items.Add('ID',NewID);
      Items.Add('Settings');
      Items.Add('Modules');
    end;
  except
    // PANIC : something went wrong!!!!!
    // we now might have a bar without any place to store the settings
    // not good!
    // can't think of anything good what to do now... 
    // let's just give an error and terminate the app =)
    DebugOutput('FATAL ERROR: Unable to register new bar settings!',1,3);
    xml.Free;
    ShowMessage('Unable to register the new bar settings.' + #10#13 +
                'This Bar is going to be closed!');
    Application.Terminate;
    exit;
  end;
  ForceDirectories(Dir);
  xml.SaveToFile(Dir + 'bars.xml');
  xml.Free;
  // New bar is now loaded!
  // Set window caption to SharpBar_ID
  self.Caption := 'SharpBar_' + inttostr(FBarID);

  LoadModuleSettings;
end;

procedure TSharpBarMainForm.LoadBarFromID(ID : integer);
var
  xml : TJvSimpleXML;
  Dir : String;
  i,n   : integer;
  handle : THandle;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';

  FBarID := -1;

  // Check if the settings file exists!
  if (not FileExists(Dir + 'bars.xml')) or (ID = -1) then
  begin
    // No settings file == fist launch, no other bars!
    // Create new bar!
    FBarID := -1;
    CreateNewBar;
    exit;
  end;

  // There is a settings file and we have a Bar ID,
  // So let's check if the bar with this ID is already running
  // Bar Window Title : SharpBar_ID
  handle := FindWindow(nil,PChar('SharpBar_'+inttostr(ID)));
  if handle <> 0 then
  begin
    // A bar with this ID is already running!
    // Terminate App - we don't want to have two instances of one bar.
    // (would have ID == -1 if it was supposed to be a new and empty bar)
    Application.Terminate;
    exit;
  end;

  // Find and load settings!
  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(Dir + 'bars.xml');
    with xml.root.items.ItemNamed['bars'] do
    begin
      for n := 0 to Items.Count - 1 do
          if Items.Item[n].Items.IntValue('ID',0) = ID then
          with Items.Item[n].Items.ItemNamed['Settings'] do
          begin
            // This is the bar with the ID we want to load
            SharpEBar1.AutoPosition   := Items.BoolValue('AutoPosition',True);
            SharpEBar1.PrimaryMonitor := Items.BoolValue('PrimaryMonitor',True);
            SharpEBar1.MonitorIndex   := Items.IntValue('MonitorIndex',0);
            SharpEBar1.HorizPos       := IntToHorizPos(Items.IntValue('HorizPos',0));
            SharpEBar1.VertPos        := IntToVertPos(Items.IntValue('VertPos',0));
            SharpEBar1.AutoStart      := Items.BoolValue('AutoStart',True);
            SharpEBar1.ShowThrobber   := Items.BoolValue('ShowThrobber',True);
            SharpEBar1.DisableHideBar := Items.BoolValue('DisableHideBar',False);
            // Set Main Window Title to SharpBar_ID!
            // The bar with the given ID is now loaded =)
            FBarID := ID;
            self.Caption := 'SharpBar_' + inttostr(ID);
            i := n;
            break;
          end;
    end;
  except
    xml.free;
    FBarID := -1;
    CreateNewBar;
    exit;
  end;

  // ID given, but bar doesn't exist
  // create new bar
  if FBarID = -1 then
  begin
    CreateNewBar;
    exit;
  end;

  try
    LoadBarModules(xml.root.items.ItemNamed['bars'].Items.Item[i]);
  except
  end;
  xml.free;
end;

procedure TSharpBarMainForm.FormCreate(Sender: TObject);
begin
  FStartup := True;
  FBarLock := False;

  FShellHookList := TStringList.Create;
  FShellHookList.Clear;
  
  DebugOutput('Creating Main Form',1,1);
  DebugOutput('Creating Scheme and Skin classes',2,1);
//  SharpEScheme := TSharpEScheme.Create(self);
//  SharpESkin := TSharpESkin.Create(self);
  DebugOutput('Creating SkinManager',2,1);
//  SkinManager := TSharpESkinManager.CreateRuntime(self,nil,nil);
  SkinManager.SkinSource := ssSystem;
  SkinManager.SchemeSource := ssSystem;
//  SharpEBar1 := TSharpEBar.CreateRuntime(self,SkinManager);
//  SharpEBar1 := TSharpEBar.CreateRuntime(self,SkinManager);
  //SharpEBar1.SkinManager := SkinManager;

  randomize;
  // Initialize module settings xml handler
  // The Pointer to this class will be given to the Module Manager
  // NEVER free the ModuleSettings var after this point!
  ModuleSettings := TJvSimpleXML.Create(nil);

  // Load Scheme into the Skin Manager
//  LoadSharpEScheme(SkinManager.Scheme);

  // Load and Update the Skin
//  SharpESkinManager1.Skin.LoadFromXmlFile('skin\Classic\skin.xml');
//  DebugOutput('Loading Skin from XML',2,1);
//  SkinManager.Skin.LoadFromXmlFile(SharpAPI.GetCurrentSkinFile);
//  DebugOutput('Updating Bar Skin',2,1);

  // Create and Initialize the module manager
  // (Make sure the Skin Manager and Module Settings are ready before doing this!)
  DebugOutput('Creating Module Manager',2,1);
  ModuleManager := TModuleManager.Create(self.Handle, SkinManager, SharpEBar1, ModuleSettings);
  ModuleManager.ThrobberMenu := ThrobberPopUp;
  DebugOutput('Loading Modules from Directory: '+ExtractFileDir(Application.ExeName) + '\Modules\',2,1);
  ModuleManager.LoadFromDirectory(ExtractFileDir(Application.ExeName) + '\Modules\');

  SharpEBar1.UpdateSkin;
  SharpEBar1.Throbber.UpdateSkin;

  ModuleManager.UpdateModuleSkins;
  ModuleManager.FixModulePositions;
  ModuleManager.RefreshMiniThrobbers;

  // VWM Compatible | Taskhide | Alt+f4 lock
  DebugOutput('Setting Form properties',2,1);
  SetWindowLong(Handle, GWL_USERDATA, magicDWord);
  Setwindowlong(Application.handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
  SetWindowPos(application.handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  ShowWindow(Application.Handle, SW_HIDE);

  KeyPreview := true;

  SharpEBar1.onPositionUpdate := OnBarPositionUpdate;

  BarHideForm := TBarHideForm.Create(self);

  DelayTimer2.Enabled := True;
end;

procedure TSharpBarMainForm.AutoPos1Click(Sender: TObject);
begin
  SharpEBar1.VertPos := vpTop;
  SharpEBar1.UpdateSkin;
  ModuleManager.UpdateModuleSkins;
  ModuleManager.FixModulePositions;
  ModuleManager.RefreshMiniThrobbers;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.Bottom1Click(Sender: TObject);
begin
  SharpEBar1.VertPos := vpBottom;
  SharpEBar1.UpdateSkin;
  ModuleManager.UpdateModuleSkins;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.Left1Click(Sender: TObject);
begin
  SharpEBar1.HorizPos := hpLeft;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.Middle1Click(Sender: TObject);
begin
  SharpEBar1.HorizPos := hpMiddle;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.Right2Click(Sender: TObject);
begin
  SharpEBar1.HorizPos := hpRight;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.OnMonitorPopupItemClick(Sender : TObject);
var
  index : integer;
begin
  try
    index := strtoint(TMenuItem(Sender).Hint);
  except
    index := 0;
  end;
  if index > Screen.MonitorCount -1 then exit;
  if Screen.Monitors[index] = Screen.PrimaryMonitor then
     SharpEBar1.PrimaryMonitor := True
     else
     begin
       SharpEbar1.PrimaryMonitor := False;
       SharpEBar1.MonitorIndex := index;
     end;
end;

procedure TSharpBarMainForm.ExitMnClick(Sender: TObject);
begin
  SaveBarSettings;
  Application.Terminate;
end;

procedure TSharpBarMainForm.FullScreen1Click(Sender: TObject);
begin
  SharpEBar1.HorizPos := hpFull;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.PopupMenu1Popup(Sender: TObject);
var
  n : integer;
  item : TMenuItem;
begin
  Monitor1.Clear;
  for n := 0 to Screen.MonitorCount-1 do
  begin
    item := TMenuItem.Create(Monitor1);
    if Screen.Monitors[n] = Screen.PrimaryMonitor then
       item.Caption := inttostr(n) + ' (primary)'
       else item.Caption := inttostr(n);
    item.Hint := inttostr(n);
    item.ImageIndex := 14;
    item.OnClick := OnMonitorPopupItemClick;
    Monitor1.Add(item);
  end;
  AutoStart1.Checked := SharpEBar1.AutoStart;
  DisableBarHiding1.Checked := SharpEBar1.DisableHideBar;
end;

procedure TSharpBarMainForm.FormDestroy(Sender: TObject);
begin
  if BarHideForm <> nil then FreeAndNil(BarHideForm);
  if AddPluginForm <> nil then FreeAndNil(AddPluginForm);
  if PluginManagerForm <> nil then FreeAndNil(PluginManagerForm);

  // check if shell hook functions have been used for any module
  if FShellHookList.Count > 0 then SHUnSetHook;
  FShellHookList.Clear;
  FShellHookList.Free;

  // We want to produce good code, so let's free stuff before the app is closed ;)
  ForceDirectories(ExtractFileDir(ModuleSettings.FileName));
  SaveBarSettings;
  ModuleSettings.SaveToFile(ModuleSettings.FileName);
  ModuleManager.Free;
 // ModuleSettings.Free;
  //ModuleSettings := nil;
end;

procedure TSharpBarMainForm.SharpEBar1ResetSize(Sender: TObject);
begin
  ModuleManager.FixModulePositions;
end;

procedure TSharpBarMainForm.PluginManager1Click(Sender: TObject);
begin
  if PluginManagerForm = nil then PluginManagerForm := TPluginManagerForm.Create(self);
  PluginManagerForm.Showmodal;
end;

procedure TSharpBarMainForm.AutoStart1Click(Sender: TObject);
begin
  AutoStart1.Checked := not AutoStart1.Checked;
  SharpEBar1.AutoStart := AutoStart1.Checked;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.FormShow(Sender: TObject);
begin
  if ModuleManager.Modules.Count = 0 then
     SharpEBar1.ShowThrobber := True;
  SharpEBar1.Throbber.Repaint;
  ShowWindow(application.Handle, SW_HIDE);
  if BarHideForm <> nil then BarHideForm.UpdateStatus;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TSharpBarMainForm.SharpEBar1ThrobberMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  n : integer;
  P : TPoint;
  Mon : integer;
  R : TRect;
  oVP : TSharpEBarVertPos;
  oHP : TSharpEBarHorizPos;
begin
  if FThemeUpdating then exit;

  if Shift = [ssLeft] then
  begin
    if not BarMove then
    begin
      // Make sure the mouse was moved more than a few pixels before starting the move bar code
      if (abs(BarMovePoint.X - X) > 64)
         or (abs(BarMovePoint.Y - Y) > 64) then
         BarMove := True
         else exit;
    end;
    if BarMove then
    begin
      oVP := SharpEBar1.VertPos;
      oHP := SharpEBar1.HorizPos;
      for n := 0 to Screen.MonitorCount - 1 do
      begin
        if Screen.Monitors[n] = Screen.PrimaryMonitor then
           Mon := -1 else Mon := n;
        P := Mouse.CursorPos;

        // Special Movement Code if Full Align
        if SharpEBar1.HorizPos = hpFull then
        begin
          // Top
          R.Left   := Screen.Monitors[n].Left;
          R.Right  := R.Left + Screen.Monitors[n].Width;
          R.Top    := Screen.Monitors[n].Top;
          R.Bottom := R.Top + 64;
          if PointInRect(P,R) then
          begin
            if Mon = -1 then SharpEBar1.PrimaryMonitor := True
               else
               begin
                 SharpEBar1.PrimaryMonitor := False;
                 SharpEBar1.MonitorIndex := Mon;
               end;
          SharpEBar1.HorizPos     := hpFull;
          SharpEBar1.VertPos      := vpTop;
          end;

          // Bottom
          R.Top    := Screen.Monitors[n].Top + Screen.Monitors[n].Height - 64;
          R.Bottom := R.Top + 64;
          if PointInRect(P,R) then
          begin
            if Mon = -1 then SharpEBar1.PrimaryMonitor := True
               else
               begin
                 SharpEBar1.PrimaryMonitor := False;
                 SharpEBar1.MonitorIndex := Mon;
               end;
          SharpEBar1.HorizPos     := hpFull;
          SharpEBar1.VertPos      := vpBottom;
          end;
          Continue;
        end;

        // Compact Movement Code
        // Top Left
        R.Left  := Screen.Monitors[n].Left;
        R.Top   := Screen.Monitors[n].Top;
        R.Right := R.Left + 256;
        R.Bottom := R.Top + 64;
        if PointInRect(P,R) then
        begin
          if Mon = -1 then SharpEBar1.PrimaryMonitor := True
             else
             begin
               SharpEBar1.PrimaryMonitor := False;
               SharpEBar1.MonitorIndex := Mon;
             end;
          SharpEBar1.HorizPos     := hpLeft;
          SharpEBar1.VertPos      := vpTop;
        end;

        // Top Middle
        R.Left  := Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - 128;
        R.Top   := Screen.Monitors[n].Top;
        R.Right := R.Left + 128;
        R.Bottom := R.Top + 64;
        if PointInRect(P,R) then
        begin
          if Mon = -1 then SharpEBar1.PrimaryMonitor := True
             else
             begin
               SharpEBar1.PrimaryMonitor := False;
               SharpEBar1.MonitorIndex := Mon;
             end;
          SharpEBar1.HorizPos     := hpMiddle;
          SharpEBar1.VertPos      := vpTop;
        end;

        // Top Right
        R.Left  := Screen.Monitors[n].Left + Screen.Monitors[n].Width - 256;
        R.Top   := Screen.Monitors[n].Top;
        R.Right := R.Left + 256;
        R.Bottom := R.Top + 64;
        if PointInRect(P,R) then
        begin
          if Mon = -1 then SharpEBar1.PrimaryMonitor := True
             else
             begin
               SharpEBar1.PrimaryMonitor := False;
               SharpEBar1.MonitorIndex := Mon;
             end;
          SharpEBar1.HorizPos     := hpRight;
          SharpEBar1.VertPos      := vpTop;
        end;

        // Bottom Left
        R.Left  := Screen.Monitors[n].Left;
        R.Top   := Screen.Monitors[n].Top + Screen.Monitors[n].Height - 64;
        R.Right := R.Left + 256;
        R.Bottom := R.Top + 64;
        if PointInRect(P,R) then
        begin
          if Mon = -1 then SharpEBar1.PrimaryMonitor := True
             else
             begin
               SharpEBar1.PrimaryMonitor := False;
               SharpEBar1.MonitorIndex := Mon;
             end;
          SharpEBar1.HorizPos     := hpLeft;
          SharpEBar1.VertPos      := vpBottom;
        end;

        // Bottom Middle
        R.Left  := Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - 128;
        R.Top   := Screen.Monitors[n].Top + Screen.Monitors[n].Height - 64;
        R.Right := R.Left + 128;
        R.Bottom := R.Top + 64;
        if PointInRect(P,R) then
        begin
          if Mon = -1 then SharpEBar1.PrimaryMonitor := True
             else
             begin
               SharpEBar1.PrimaryMonitor := False;
               SharpEBar1.MonitorIndex := Mon;
             end;
          SharpEBar1.HorizPos     := hpMiddle;
          SharpEBar1.VertPos      := vpBottom;
        end;

        // Bottom Right
        R.Left  := Screen.Monitors[n].Left + Screen.Monitors[n].Width - 256;
        R.Top   := Screen.Monitors[n].Top + Screen.Monitors[n].Height - 64;
        R.Right := R.Left + 256;
        R.Bottom := R.Top + 64;
        if PointInRect(P,R) then
        begin
          if Mon = -1 then SharpEBar1.PrimaryMonitor := True
             else
             begin
               SharpEBar1.PrimaryMonitor := False;
               SharpEBar1.MonitorIndex := Mon;
             end;
          SharpEBar1.HorizPos     := hpRight;
          SharpEBar1.VertPos      := vpBottom;
        end;
      end;
      if oVP <> SharpEBar1.VertPos then
      begin
        SharpEBar1.UpdateSkin;
        ModuleManager.UpdateModuleSkins;
        ModuleManager.FixModulePositions;
      end;
      if oHP <> SharpEBar1.HorizPos then
         ModuleManager.FixModulePositions;
    end;
    if BarHideForm <> nil then BarHideForm.UpdateStatus;
  end;
end;

procedure TSharpBarMainForm.SharpEBar1ThrobberMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (not BarMove) then PopUpMenu1.Popup(Left,Top);
  BarMove := False;
end;

procedure TSharpBarMainForm.SharpEBar1ThrobberMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     BarMovePoint := Point(X,Y)
     else BarMove := False;
end;

procedure TSharpBarMainForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FThemeUpdating then exit;

  if Button = mbRight then
     if (Y=Height-1) and (SharpEBar1.VertPos = vpBottom)
        or (Y=0) and (SharpEBar1.VertPos = vpTop) then
     begin
       if ModuleManager.Modules.Count = 0 then
       begin
         SharpEBar1.ShowThrobber := True;
         exit;
       end;
       SharpEBar1.ShowThrobber := not SharpEBar1.ShowThrobber;
       ModuleManager.FixModulePositions;
       if SharpEBar1.ShowThrobber then SharpEBar1.Throbber.Repaint;
     end;
  if (Button = mbLeft) and (not SharpEBar1.DisableHideBar) then
  begin
    BarHideForm.Color := SkinManager.Scheme.Throbberback;
    if (Y=Height-1)  and (SharpEbar1.VertPos = vpBottom) then
    begin
      BarHideForm.Left := Left;
      BarHideForm.Width := Width;
      BarHideForm.Height := 1;
      BarHideForm.Top := Top + Height -1;
      SharpBarMainForm.Hide;
      BarHideForm.Show;
    end
    else if (Y=0) and (SharpEBar1.VertPos = vpTop) then
    begin
      BarHideForm.Left := Left;
      BarHideForm.Width := Width;
      BarHideForm.Height := 1;
      BarHideForm.Top := Top;
      SharpBarMainForm.Hide;
      BarHideForm.Show;
    end;
  end;
end;

procedure TSharpBarMainForm.Information1Click(Sender: TObject);
begin
  Showmessage('Someone should create a nice Informations Dialog!');
end;

procedure TSharpBarMainForm.SettingsClick(Sender: TObject);
var
  mThrobber : TSharpEMiniThrobber;
  tempModule : TModule;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then exit;
  tempModule := ModuleManager.GetModule(mThrobber.Tag);
  if tempModule = nil then exit;
  if @tempModule.ModuleFile.DllShowSettingsWnd <> nil then
     tempModule.ModuleFile.DllShowSettingsWnd(tempModule.ID);
end;

procedure TSharpBarMainForm.Delete1Click(Sender: TObject);
var
  mThrobber : TSharpEMiniThrobber;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then exit;
  ModuleManager.Delete(mThrobber.Tag);
  SaveBarSettings;
  ModuleManager.ReCalculateModuleSize;
end;

procedure TSharpBarMainForm.Left2Click(Sender: TObject);
var
  mThrobber : TSharpEMiniThrobber;
  tempModule : TModule;
  ri : integer;
  index : integer;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then exit;
  tempModule := ModuleManager.GetModule(mThrobber.Tag);
  if tempModule = nil then exit;
  ri := ModuleManager.GetFirstRModuleIndex;
  index := ModuleManager.Modules.IndexOf(tempModule);
  if (ri = index) and (SharpEbar1.HorizPos <> hpFull) then
     ModuleManager.MoveModule(index,-1);
  ModuleManager.MoveModule(index,-1);
  ModuleManager.SortModulesByPosition;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.Right1Click(Sender: TObject);
var
  mThrobber : TSharpEMiniThrobber;
  tempModule : TModule;
  ri,index : integer;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then exit;
  tempModule := ModuleManager.GetModule(mThrobber.Tag);
  if tempModule = nil then exit;
  ri := ModuleManager.GetFirstRModuleIndex;
  index := ModuleManager.Modules.IndexOf(tempModule);
  if (ri = index+1) and (SharpEbar1.HorizPos <> hpFull) then
     ModuleManager.MoveModule(index,1);
  ModuleManager.MoveModule(index,1);
  ModuleManager.SortModulesByPosition;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.DisableBarHiding1Click(Sender: TObject);
begin
  DisableBarHiding1.Checked := not DisableBarHiding1.Checked;
  SharpEBar1.DisableHideBar := DisableBarHiding1.Checked;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.ApplicationEvents1Activate(Sender: TObject);
begin
  if FThemeUpdating then exit;

  if ApplicationEvents1.Tag = 0 then
  begin
    ModuleManager.UpdateModuleSkins;
    ModuleManager.FixModulePositions;
    ModuleManager.RefreshMiniThrobbers;
    ApplicationEvents1.Tag := 1;
  end;
  if BlendInTimer.Tag <> 255 then
  begin
    FStartup := False;
    UnlockWindow(Handle);
    SetLayeredWindowAttributes(Handle, RGB(255,0,254), 1, LWA_COLORKEY or LWA_ALPHA);
    SharpEBar1.abackground.Alpha := 1;
    Application.ShowMainForm := True;
    Show;
    BlendInTimer.Enabled := True;
  end;
end;

procedure TSharpBarMainForm.SkinManagerSkinChanged(Sender: TObject);
begin
//  if FThemeUpdating then exit;

  if ModuleManager = nil then exit;

  ModuleManager.UpdateModuleSkins;
  ModuleManager.FixModulePositions;
  if FThemeUpdating then exit;
  SharpEBar1.UpdateSkin;
  SharpEBar1.Throbber.UpdateSkin;
  SharpEbar1.Throbber.Repaint;
  ModuleManager.RefreshMiniThrobbers;
end;

procedure TSharpBarMainForm.CreateemptySharpBar1Click(Sender: TObject);
begin
  SharpApi.SharpExecute('SharpBar.exe -load:-1');
end;

procedure TSharpBarMainForm.FormResize(Sender: TObject);
begin
  if BarHideForm <> nil then BarHideForm.UpdateStatus;
end;

procedure TSharpBarMainForm.FormHide(Sender: TObject);
begin
  if BarHideForm <> nil then BarHideForm.UpdateStatus;
end;

procedure TSharpBarMainForm.OnBarPositionUpdate(Sender : TObject);
begin
  if BarHideForm <> nil then BarHideForm.UpdateStatus;
end;

procedure TSharpBarMainForm.BlendInTimerTimer(Sender: TObject);
var
  msg : TMessage;
begin
  BlendInTimer.Tag := BlendInTimer.Tag + 40;
  if BlendInTimer.Tag >= 255 then
  begin
    BlendInTimer.Tag := 255;
    BlendInTimer.Enabled := False;
    WMUnlockBarWindow(msg);
  end;
  SetLayeredWindowAttributes(Handle, RGB(255,0,254), BlendInTimer.Tag, LWA_COLORKEY or LWA_ALPHA);
  SharpEBar1.abackground.Alpha := BlendInTimer.Tag;
end;

procedure TSharpBarMainForm.BlendOutTimerTimer(Sender: TObject);
begin
  BlendOutTimer.Tag := BlendOutTimer.Tag - 400;
  if BlendOutTimer.Tag <= 0 then
  begin
    BlendOutTimer.Tag := 0;
    BlendOutTimer.Enabled := False;
  end;
  SetLayeredWindowAttributes(Handle, RGB(255,0,254), BlendOutTimer.Tag, LWA_COLORKEY or LWA_ALPHA);
  SharpEBar1.abackground.Alpha := BlendOutTimer.Tag;
end;

procedure TSharpBarMainForm.DelayTimer1Timer(Sender: TObject);
begin
  DelayTimer1.Enabled := False;

  BlendOutTimer.Enabled := False;
  BlendInTimer.Tag := BlendOutTimer.Tag;
  BlendInTimer.Enabled := True;
end;

procedure TSharpBarMainForm.DelayTimer2Timer(Sender: TObject);
begin
  if (FStartup) or (not Visible) then
  begin
    FStartup := False;
    UnlockWindow(Handle);
    SetLayeredWindowAttributes(Handle, RGB(255,0,254), 1, LWA_COLORKEY or LWA_ALPHA);
    SharpEBar1.abackground.Alpha := 1;
    Application.ShowMainForm := True;
    Show;
    BlendInTimer.Enabled := True;
  end;

  DelayTimer2.Enabled := False;
end;

end.
