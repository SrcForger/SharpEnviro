{
Source Name: MainWnd.pas
Description: Button Module - Main Window
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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, SharpEButton, SharpESkinManager, 
  JvSimpleXML, SharpApi, Menus, Math, ShellApi, Registry,
  GR32, GR32_PNG, Types, ImgList, SharpEBaseControls,
  uSharpEMenuWnd, uSharpEMenu, uSharpEMenuSettings, uSharpEMenuItem;


type
  TMediaPlayerType = (mptFoobar,mptWinamp,mptMPC,mptQCD,mptWMP,mptVLC);

  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    btn_pselect: TSharpEButton;
    btn_next: TSharpEButton;
    btn_prev: TSharpEButton;
    btn_pause: TSharpEButton;
    btn_stop: TSharpEButton;
    btn_play: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
    procedure btn_prevClick(Sender: TObject);
    procedure btn_stopClick(Sender: TObject);
    procedure btn_pauseClick(Sender: TObject);
    procedure btn_playClick(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure btn_pselectMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnFooClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure mnMPCClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure mnQCDClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure mnVLCClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure mnAMPClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure mnWMPClick(pItem : TSharpEMenuItem; var CanClose : boolean);
  protected
  private
    sPlayer     : TMediaPlayerType;
    sPlayerFile : String;
    sPSelect    : Boolean;
    FIconFoobar : TBitmap32;
    FIconWinAmp : TBitmap32;
    FIconMPC    : TBitmap32;
    FIconQCD    : TBitmap32;
    FIconWMP    : TBitmap32;
    FIconVLC    : TBitmap32;
    Background  : TBitmap32;
    sWinAmpPath : String;
    sMPCPath    : String;
    sQCDPath    : String;
    sWMPPath    : String;
    sVLCPath    : String;
    procedure WMExecAction(var msg : TMessage); message WM_SHARPEACTIONMESSAGE;
    function GetStartPlayer(Root : HKEY; Key : String; Value : String) : String;
  public
    ModuleID : integer;
    BarWnd : hWnd;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(BroadCast : boolean);
    procedure UpdatePSelectIcon;
    procedure InitDefaultImages;
    procedure UpdateBackground(new : integer = -1);
    procedure UpdateActions;
  end;

const

      {WinAmp API}
  WM_WA_IPC     = WM_USER;
  IPC_PLAYFILE  = 100;
  IPC_DELETE    = 101;
  IPC_STARTPLAY = 102;
  IPC_ISPLAYING = 104;

  WINAMP_BUTTON1 = 40044;
  WINAMP_BUTTON2 = 40045;
  WINAMP_BUTTON3 = 40046;
  WINAMP_BUTTON4 = 40047;
  WINAMP_BUTTON5 = 40048;


   {Media Player Classic API}
  MEDIA_PLAY          = 887;
  MEDIA_PLAY_PAUSE    = 889;
  MEDIA_STOP          = 890;
  MEDIA_NEXTTRACK     = 921;
  MEDIA_PREVIOUSTRACK = 920;

         {QCD API}
  QCD_COMMAND_TRKBWD = 40012;
  QCD_COMMAND_TRKFWD = 40013;
  QCD_COMMAND_STOP	 = 40014;
  QCD_COMMAND_PAUSE	 = 40015;
  QCD_COMMAND_PLAY   = 40016;

    {Windows Media Player API}
  WMP_VOLUME_MUTE         = $80000;
  WMP_VOLUME_DOWN         = $90000;
  WMP_VOLUME_UP           = $a0000;
  WMP_MEDIA_NEXTTRACK     = $B0000;
  WMP_MEDIA_PREVIOUSTRACK = $C0000;
  WMP_MEDIA_STOP          = $D0000;
  WMP_MEDIA_PLAY_PAUSE    = $E0000;

         {VLC API}
  VLC_PLAY_PAUSE = 7109;
  VLC_STOP       = 13003;
  VLC_PREV       = 13013;
  VLC_NEXT       = 13014;


implementation


uses SettingsWnd,
     PlayerSelectWnd,
     uSharpBarAPI;

{$R *.dfm}
{$R playerglyphs.res}

procedure TMainForm.InitDefaultImages;
var
  ResStream : TResourceStream;
  b : boolean;
begin
  try
    ResStream := TResourceStream.Create(HInstance, 'foobar', RT_RCDATA);
    try
      LoadBitmap32FromPng(FIconFoobar,ResStream,b);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'mpc', RT_RCDATA);
    try
      LoadBitmap32FromPng(FIconMPC,ResStream,b);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'winamp', RT_RCDATA);
    try
      LoadBitmap32FromPng(FIconWinamp,ResStream,b);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'qcd', RT_RCDATA);
    try
      LoadBitmap32FromPng(FIconQCD,ResStream,b);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'wmp', RT_RCDATA);
    try
      LoadBitmap32FromPng(FIconWMP,ResStream,b);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'vlc', RT_RCDATA);
    try
      LoadBitmap32FromPng(FIconVLC,ResStream,b);
    finally
      ResStream.Free;
    end;
  except
  end;
end;

function TMainForm.GetStartPlayer(Root : HKEY; Key : String; Value : String) : String;
var
  Reg : TRegistry;
  PlayerPath : String;
  PlayerSelectForm: TPlayerSelectForm;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := Root;
  Reg.Access := KEY_READ;
  PlayerPath := '';
  if Reg.OpenKey(Key,False) then
  begin
    PlayerPath := Reg.ReadString(Value);
    Reg.CloseKey;
  end;
  if not FileExists(PlayerPath) then
  begin
    PlayerSelectForm := TPlayerSelectForm.Create(self);
    if PlayerSelectForm.ShowModal = mrOk then
       PlayerPath := PlayerSelectForm.edit_player.Text
       else PlayerPath := '';
    PlayerSelectForm.Free;
  end;
  result := PlayerPath;
  SharpApi.SharpExecute('_nohist,' + PlayerPath);
end;

procedure TMainForm.UpdatePSelectIcon;
begin
  case sPlayer of
    mptFoobar : btn_pselect.Glyph32.Assign(FIconFoobar);
    mptMPC    : btn_pselect.Glyph32.Assign(FIconMPC);
    mptWinAmp : btn_pselect.Glyph32.Assign(FIconWinAmp);
    mptQCD    : btn_pselect.Glyph32.Assign(FIconQCD);
    mptWMP    : btn_pselect.Glyph32.Assign(FIconWMP);
    mptVLC    : btn_pselect.Glyph32.Assign(FIconVLC);
  end;
  btn_pselect.Repaint;
end;

function GetVLCHandle : hwnd;
begin
  result :=  FindWindow('wxWindowClassNR', nil);
  if result = 0 then result := Findwindow(nil,'VCL media player');
end;

function GetWMPHandle : hwnd;
begin
  result := FindWindow('WMPlayerApp', nil);
  result := FindWindowEx(result, 0, 'WMPAppHost', 'WMPAppHost');
  if result = 0 then result := Findwindow(nil,'Windows Media Player');
end;

function GetQCDHandle : hwnd;
begin
  result := FindWindow('PlayerCanvas', nil);
end;

function GetMPCHandle : hwnd;
begin
  result := FindWindow('MediaPlayerClassicW',nil);
  if result = 0 then result := FindWindow(nil,'Media Player Classic');
end;

function GetWinAmpHandle : hwnd;
begin
  result := FindWindow('Winamp v1.x',nil);
  if result = 0 then result := FindWindow(nil,'Winamp 5.03');
end;

procedure TMainForm.SaveSettings;
var
  item : TJvSimpleXMLElem;
  XML : TJvSimpleXML;
  Dir : String;
  FName : String;
begin
  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    clear;
    case sPlayer of
      mptFooBar : Add('Player','mptFooBar');
      mptWinAmp : Add('Player','mptWinAmp');
      mptMPC    : Add('Player','mptMPC');
      mptQCD    : Add('Player','mptQCD');
      mptWMP    : Add('Player','mptWMP');
      mptVLC    : Add('Player','mptVLC');
    end;
    Add('PlayerFile',sPlayerFile);
    Add('QuickPlayerSelect',sPSelect);
  end;
  uSharpBarAPI.SaveXMLFile(BarWnd);

  XML := TJvSimpleXMl.Create(nil);
  XML.Root.Name := 'MediaControllerPlayers';
  XML.Root.Items.Add('WinAmpPath',sWinAmpPath);
  XML.Root.Items.Add('MPCPath',sMPCPath);
  XML.Root.Items.Add('QCDPath',sQCDPath);
  XML.Root.Items.Add('WMPPath',sWMPPath);
  XML.Root.Items.Add('VLCPath',sVLCPath);
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Module Settings\';
  FName := Dir + 'MediaPlayers.xml';
  if not DirectoryExists(Dir) then
     ForceDirectories(Dir);
  XML.SaveToFile(FName + '~');
  if FileExists(FName) then
     DeleteFile(FName);
  RenameFile(FName + '~',FName);
  XML.Free;
end;

procedure TMainForm.UpdateActions;
begin
  SharpApi.RegisterActionEx('!MC-Play','Modules',Handle,1);
  SharpApi.RegisterActionEx('!MC-Pause','Modules',Handle,2);
  SharpApi.RegisterActionEx('!MC-Stop','Modules',Handle,3);
  SharpApi.RegisterActionEx('!MC-Prev','Modules',Handle,4);
  SharpApi.RegisterActionEx('!MC-Next','Modules',Handle,5);
end;

procedure TMainForm.WMExecAction(var msg : TMessage);
begin
  case msg.LParam of
    1: btn_play.OnClick(btn_play);
    2: btn_pause.OnClick(btn_pause);
    3: btn_stop.OnClick(btn_stop);
    4: btn_prev.OnClick(btn_prev);
    5: btn_next.OnClick(btn_next);
  end;
end;

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
  s : String;
  XML : TJvSimpleXML;
  Dir : String;
  FName : String;
begin
  UpdateActions;

  sPlayer     := mptWMP;
  sPlayerFile := '-1';
  sPSelect    := True;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then
  with item.Items do
  begin
    s := LowerCase(Value('Player','mptFooBar'));
    if         s = 'mptwinamp' then sPlayer := mptWinAmp
       else if s = 'mptmpc' then sPlayer := mptMPC
       else if s = 'mptqcd' then sPlayer := mptQCD
       else if s = 'mptwmp' then sPlayer := mptWMP
       else if s = 'mptvlc' then sPlayer := mptVLC
       else sPlayer := mptFoobar;
    sPlayerFile := Value('PlayerFile','-1');
    sPSelect    := BoolValue('QuickPlayerSelect',True);
  end;

  if sPlayerFile = '-1' then
     sPlayerFile := GetFooPathFromRegistry;

  UpdatePSelectIcon;

  sWinAmpPath := '';
  sMPCPath := '';
  sQCDPath := '';
  sWMPPath := '';
  sVLCPath := '';

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Module Settings\';
  FName := Dir + 'MediaPlayers.xml';
  if FileExists(FName) then
  begin
    XML := TJvSimpleXML.Create(nil);
    try
      XML.LoadFromFile(FName);
      sWinAmpPath := XML.Root.Items.Value('WinAmpPath');
      sMPCPath    := XML.Root.Items.Value('MPCPath');
      sQCDPath    := XML.Root.Items.Value('QCDPath');
      sWMPPath    := XML.Root.Items.Value('WMPPath');
      sVLCPath    := XML.Root.Items.Value('VLCPath');
    finally
      XML.Free;
    end;
  end;
end;

procedure TMainForm.UpdateBackground(new : integer = -1);
begin
  if (new <> -1) then
     Background.SetSize(new,Height)
     else if (Width <> Background.Width) then
              Background.Setsize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background,self,Background.Width);
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
  NewWidth := Max(1,NewWidth);

  UpdateBackground(NewWidth);

  Width := NewWidth;
end;

procedure TMainForm.ReAlignComponents;
var
  newWidth : integer;
  i : integer;
begin
  btn_play.Width    := btn_play.Height;
  btn_pause.Width   := btn_pause.Height;
  btn_stop.Width    := btn_stop.Height;
  btn_prev.Width    := btn_prev.Height;
  btn_next.Width    := btn_next.Height;
  btn_pselect.Width := btn_pselect.Height;

  btn_play.Left := 2;
  btn_pause.Left := btn_play.Left + btn_play.Width + 1;
  btn_stop.Left := btn_pause.Left + btn_pause.Width + 1;
  btn_prev.Left := btn_stop.Left + btn_stop.Width + 3;
  btn_next.Left := btn_prev.Left + btn_prev.Width + 1;
  i := 0;

  if sPSelect then
  begin
    i := 3 + btn_pselect.Width;
    btn_pselect.Left := btn_next.Left + btn_next.Width + 3;
    btn_pselect.Visible := True;
  end else btn_pselect.Visible := False;

  newWidth := btn_next.Left + btn_next.Width + i + 2;
  Tag := NewWidth;
  Hint := inttostr(NewWidth);
  if newWidth <> Width then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
begin
  try
    SettingsForm := TSettingsForm.Create(application.MainForm);
    case sPlayer of
      mptFooBar: SettingsForm.cb_foobar.Checked := True;
      mptWinAmp: SettingsForm.cb_winamp.Checked := True;
      mptMPC   : SettingsForm.cb_mpc.Checked    := True;
      mptQCD   : SettingsForm.cb_qcd.Checked    := True;
      mptWMP   : SettingsForm.cb_wmp.Checked    := True;
      mptVLC   : SettingsForm.cb_vlc.Checked    := True;
    end;
    SettingsForm.edit_foopath.Text := sPlayerFile;
    SettingsForm.cb_pselect.Checked := sPSelect;

    if SettingsForm.ShowModal = mrOk then
    begin
      if SettingsForm.cb_winamp.Checked then sPlayer := mptWinAmp
         else if SettingsForm.cb_mpc.Checked then sPlayer := mptMPC
         else if SettingsForm.cb_qcd.Checked then sPlayer := mptQCD
         else if SettingsForm.cb_wmp.Checked then sPlayer := mptWMP
         else if SettingsForm.cb_vlc.Checked then sPlayer := mptVLC
         else sPlayer := mptFooBar;
      sPlayerFile := SettingsForm.edit_foopath.Text;
      sPSelect := SettingsForm.cb_pselect.Checked;

      SaveSettings;
    end;
    ReAlignComponents(True);
    UpdatePSelectIcon;
  finally
    FreeAndNil(SettingsForm);
  end;
end;


//#############################
//            PLAY
//#############################
procedure TMainForm.btn_playClick(Sender: TObject);
var
  wnd : hwnd;
begin
  case sPlayer of
    mptFooBar: Shellapi.ShellExecute(Handle, nil, pChar(sPlayerFile),pChar('/play'),pChar(ExtractFileDir(sPlayerFile)),SW_SHOWNORMAL);
    mptWinamp: begin
                 wnd := GetWinampHandle;
                 if wnd = 0 then
                 begin
                   if FileExists(sWinAmpPath) then
                      SharpApi.SharpExecute('_nohist,' + sWinAmpPath)
                      else
                      begin
                        sWinAmpPath := GetStartPlayer(HKEY_LOCAL_MACHINE,'.','.');
                        SaveSettings;
                      end;
                 end else SendMessage(wnd,WM_COMMAND,WINAMP_BUTTON2,0);
               end;
    mptMPC   : begin
                 wnd := GetMPCHandle;
                 if wnd = 0 then
                 begin
                   if FileExists(sMPCPath) then
                      SharpApi.SharpExecute('_nohist,' + sMPCPath)
                      else
                      begin
                        sMPCPath := GetStartPlayer(HKEY_LOCAL_MACHINE,'SOFTWARE\Gabest\Media Player Classic','ExePath');
                        SaveSettings;
                      end;
                 end else SendMessage(wnd,WM_COMMAND,MEDIA_PLAY,0);
               end;
    mptQCD   : begin
                 wnd := GetQCDHandle;
                 if wnd = 0 then
                 begin
                   if FileExists(sQCDPath) then
                      SharpApi.SharpExecute('_nohist,' + sQCDPath)
                      else
                      begin
                        sQCDPath := GetStartPlayer(HKEY_LOCAL_MACHINE,'.','.');
                        SaveSettings;
                      end;
                 end else SendMessage(wnd,WM_COMMAND,QCD_COMMAND_PLAY,0);
               end;
    mptWMP   : begin
                 wnd := GetWMPHandle;
                 if wnd = 0 then
                 begin
                   if FileExists(sWmpPath) then
                      SharpApi.SharpExecute('_nohist,' + sWmpPath)
                      else
                      begin
                        sWMPPath := GetStartPlayer(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Multimedia\WMPlayer','Player.Path');
                        SaveSettings;
                      end;
                 end else SendMessage(wnd,WM_APPCOMMAND,0,WMP_MEDIA_PLAY_PAUSE);
               end;
    mptVLC   : begin
                 wnd := GetVLCHandle;
                 if wnd = 0 then
                 begin
                   if FileExists(sVLCPath) then
                      SharpApi.SharpExecute('_nohist,' + sVLCPath)
                      else
                      begin
                        sVLCPath := GetStartPlayer(HKEY_LOCAL_MACHINE,'.','.');
                        SaveSettings;
                      end;
                 end else SendMessage(wnd,WM_COMMAND,VLC_PLAY_PAUSE,0);
               end;
  end;
end;


//#############################
//            PAUSE
//#############################
procedure TMainForm.btn_pauseClick(Sender: TObject);
var
  wnd : hwnd;
begin
  case sPlayer of
    mptFooBar: Shellapi.ShellExecute(Handle, nil, pChar(sPlayerFile),pChar('/pause'),pChar(ExtractFileDir(sPlayerFile)),SW_SHOWNORMAL);
    mptWinamp: begin
                 wnd := GetWinampHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,WINAMP_BUTTON3,0);
               end;
    mptMPC   : begin
                 wnd := GetMPCHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,MEDIA_PLAY_PAUSE,0);
               end;
    mptQCD   : begin
                 wnd := GetQCDHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,QCD_COMMAND_PAUSE,0);
               end;
    mptWMP   : begin
                 wnd := GetWMPHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_APPCOMMAND,0,WMP_MEDIA_PLAY_PAUSE);
               end;
    mptVLC   : begin
                 wnd := GetVLCHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,VLC_PLAY_PAUSE,0);
               end;
  end;
end;


//#############################
//            STOP
//#############################
procedure TMainForm.btn_stopClick(Sender: TObject);
var
  wnd : hwnd;
begin
  case sPlayer of
    mptFooBar: Shellapi.ShellExecute(Handle, nil, pChar(sPlayerFile),pChar('/stop'),pChar(ExtractFileDir(sPlayerFile)),SW_SHOWNORMAL);
    mptWinamp: begin
                 wnd := GetWinampHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,WINAMP_BUTTON4,0);
               end;
    mptMPC   : begin
                 wnd := GetMPCHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,MEDIA_STOP,0);
               end;
    mptQCD   : begin
                 wnd := GetQCDHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,QCD_COMMAND_STOP,0);
               end;
    mptWMP   : begin
                 wnd := GetWMPHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_APPCOMMAND,0,WMP_MEDIA_STOP);
               end;
    mptVLC   : begin
                 wnd := GetVLCHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,VLC_STOP,0);
               end;
  end;
end;


//#############################
//       PREVIOUS TRACK
//#############################
procedure TMainForm.btn_prevClick(Sender: TObject);
var
  wnd : hwnd;
begin
  case sPlayer of
    mptFooBar: Shellapi.ShellExecute(Handle, nil, pChar(sPlayerFile),pChar('/prev'),pChar(ExtractFileDir(sPlayerFile)),SW_SHOWNORMAL);
    mptWinamp: begin
                 wnd := GetWinampHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,WINAMP_BUTTON1,0);
               end;
    mptMPC   : begin
                 wnd := GetMPCHandle;
                 if wnd <> 0 then
                 begin
                   SendMessage(wnd,WM_COMMAND,MEDIA_STOP,0);
                   SendMessage(wnd,WM_COMMAND,MEDIA_PREVIOUSTRACK,0);
                   SendMessage(wnd,WM_COMMAND,MEDIA_PLAY,0);
                 end;
               end;
    mptQCD   : begin
                 wnd := GetQCDHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,QCD_COMMAND_TRKBWD,0);
               end;
    mptWMP   : begin
                 wnd := GetWMPHandle;
                 if wnd <> 0 then
                 begin
                   SendMessage(wnd,WM_APPCOMMAND,0,WMP_MEDIA_STOP);
                   SendMessage(wnd,WM_APPCOMMAND,0,WMP_MEDIA_PREVIOUSTRACK);
                   SendMessage(wnd,WM_APPCOMMAND,0,WMP_MEDIA_PLAY_PAUSE);
                 end;
               end;
    mptVLC   : begin
                 wnd := GetVLCHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,VLC_PREV,0);
               end;
  end;
end;


//#############################
//        NEXT TRACK
//#############################
procedure TMainForm.btn_nextClick(Sender: TObject);
var
  wnd : hwnd;
begin
  case sPlayer of
    mptFooBar: Shellapi.ShellExecute(Handle, nil, pChar(sPlayerFile),pChar('/next'),pChar(ExtractFileDir(sPlayerFile)),SW_SHOWNORMAL);
    mptWinamp: begin
                 wnd := GetWinampHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,WINAMP_BUTTON5,0);
               end;
    mptMPC   : begin
                 wnd := GetMPCHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,MEDIA_NEXTTRACK,0);
               end;
    mptQCD   : begin
                 wnd := GetQCDHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,QCD_COMMAND_TRKFWD,0);
               end;
    mptWMP   : begin
                 wnd := GetWMPHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_APPCOMMAND,0,WMP_MEDIA_NEXTTRACK);
               end;
    mptVLC   : begin
                 wnd := GetVLCHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,VLC_NEXT,0);
               end;
  end;
end;

procedure TMainForm.btn_pselectMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  sr : TSearchRec;
  Dir : String;
  s : string;
  p : TPoint;
  mn : TSharpEMenu;
  ms : TSharpEMenuSettings;
  wnd : TSharpEMenuWnd;
begin
  if Button = mbLeft then
  begin
    ms := TSharpEMenuSettings.Create;
    ms.LoadFromXML;
    ms.CacheIcons := False;
    ms.WrapMenu := False;

    mn := TSharpEMenu.Create(SharpESkinManager1,ms);
    ms.Free;

    TSharpEMenuItem(mn.AddCustomItem('Foobar2000','Foobar',FIconFoobar)).OnClick := mnFooClick;
    TSharpEMenuItem(mn.AddCustomItem('Media Player Classic','MPC',FIconMPC)).OnClick := mnMPCClick;
    TSharpEMenuItem(mn.AddCustomItem('Quintessential Player','QCD',FIconQCD)).OnClick := mnQCDClick;
    TSharpEMenuItem(mn.AddCustomItem('VLC Media Player','VLC',FIconVLC)).OnClick := mnVLCClick;
    TSharpEMenuItem(mn.AddCustomItem('WinAmp','WinAmp',FIconWinAmp)).OnClick := mnAMPClick;
    TSharpEMenuItem(mn.AddCustomItem('Windows Media Player','WMP',FIconWMP)).OnClick := mnWMPClick;

    //mn.AddSeparatorItem(False);
    mn.RenderBackground(0,0);

    wnd := TSharpEMenuWnd.Create(self,mn);
    wnd.FreeMenu := True; // menu will free itself when closed

    p := ClientToScreen(Point(btn_pselect.Left + btn_pselect.Width div 2, self.Height + self.Top));
    p.x := p.x + SharpESkinManager1.Skin.MenuSkin.SkinDim.XAsInt - mn.Background.Width div 2;
    if p.x < Monitor.Left then
       p.x := Monitor.Left;
    if p.x + mn.Background.Width  > Monitor.Left + Monitor.Width then
       p.x := Monitor.Left + Monitor.Width - mn.Background.Width;
    wnd.Left := p.x;
    if p.Y < Monitor.Top + Monitor.Height div 2 then
       wnd.Top := p.y + SharpESkinManager1.Skin.MenuSkin.SkinDim.YAsInt
       else wnd.Top := p.y - Top - Height - mn.Background.Height - SharpESkinManager1.Skin.MenuSkin.SkinDim.YAsInt;
    wnd.Show;
  end;

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  Background  := TBitmap32.Create;
  FIconFoobar := TBitmap32.Create;
  FIconWinAmp := TBitmap32.Create;
  FIconMPC    := TBitmap32.Create;
  FIconQCD    := TBitmap32.Create;
  FIconWMP    := TBitmap32.Create;
  FIconVLC    := TBitmap32.Create;

  InitDefaultImages;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SharpApi.UnRegisterAction('!MC-Play');
  SharpApi.UnRegisterAction('!MC-Pause');
  SharpApi.UnRegisterAction('!MC-Stop');
  SharpApi.UnRegisterAction('!MC-Prev');
  SharpApi.UnRegisterAction('!MC-Next');

  Background.Free;
  FIconFoobar.Free;
  FIconWinAmp.Free;
  FIconMPC.Free;
  FIconQCD.Free;
  FIconWMP.Free;
  FIconVLC.Free;

  if SharpEMenuPopups <> nil then
     FreeAndNil(SharpEMenuPopups);  
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Background.DrawTo(Canvas.Handle,0,0);
end;

procedure TMainForm.mnFooClick(pItem : TSharpEMenuItem; var CanClose : boolean);
begin
  sPlayer := mptFooBar;
  SaveSettings;
  UpdatePSelectIcon;
  CanClose := True;
end;

procedure TMainForm.mnMPCClick(pItem : TSharpEMenuItem; var CanClose : boolean);
begin
  sPlayer := mptMPC;
  SaveSettings;
  UpdatePSelectIcon;
  CanClose := True;
end;

procedure TMainForm.mnQCDClick(pItem : TSharpEMenuItem; var CanClose : boolean);
begin
  sPlayer := mptQCD;
  SaveSettings;
  UpdatePSelectIcon;
  CanClose := True;
end;

procedure TMainForm.mnVLCClick(pItem : TSharpEMenuItem; var CanClose : boolean);
begin
  sPlayer := mptVLC;
  SaveSettings;
  UpdatePSelectIcon;
  CanClose := True;
end;

procedure TMainForm.mnAMPClick(pItem : TSharpEMenuItem; var CanClose : boolean);
begin
  sPlayer := mptWinAmp;
  SaveSettings;
  UpdatePSelectIcon;
  CanClose := True;
end;

procedure TMainForm.mnWMPClick(pItem : TSharpEMenuItem; var CanClose : boolean);
begin
  sPlayer := mptWMP;
  SaveSettings;
  UpdatePSelectIcon;
  CanClose := True;
end;

end.
