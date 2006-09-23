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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32_Image, SharpEBaseControls, SharpEButton,
  SharpESkinManager, SharpEScheme, SharpESkin, ExtCtrls, SharpEProgressBar,
  JvSimpleXML, SharpApi, Jclsysinfo, Menus, Math,
  ShellApi, ImgList, GR32, GR32_PNG;


type
  TMediaPlayerType = (mptFoobar,mptWinamp,mptMPC,mptQCD,mptWMP,mptVLC);

  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    btn_play: TSharpEButton;
    btn_stop: TSharpEButton;
    btn_pause: TSharpEButton;
    btn_prev: TSharpEButton;
    btn_next: TSharpEButton;
    btn_pselect: TSharpEButton;
    playerpopup: TPopupMenu;
    Foobar20001: TMenuItem;
    Winamp1: TMenuItem;
    MediaPlayerClassic1: TMenuItem;
    ImageList1: TImageList;
    QCD1: TMenuItem;
    WindowsMediaPlayer1: TMenuItem;
    VLCMediaPlayer1: TMenuItem;
    procedure VLCMediaPlayer1Click(Sender: TObject);
    procedure WindowsMediaPlayer1Click(Sender: TObject);
    procedure QCD1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Winamp1Click(Sender: TObject);
    procedure MediaPlayerClassic1Click(Sender: TObject);
    procedure Foobar20001Click(Sender: TObject);
    procedure btn_pselectClick(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
    procedure btn_prevClick(Sender: TObject);
    procedure btn_stopClick(Sender: TObject);
    procedure btn_pauseClick(Sender: TObject);
    procedure btn_playClick(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
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
  public
    ModuleID : integer;
    BarWnd : hWnd;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(BroadCast : boolean);
    procedure UpdatePSelectIcon;
    procedure InitDefaultImages;
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
     uSharpBarAPI;

{$R *.dfm}
{$R glyphs.res}

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
end;

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
  s : String;
begin
  sPlayer     := mptWinAmp;
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
  UpdatePSelectIcon;
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
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
    SettingsForm := TSettingsForm.Create(nil);
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
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,WINAMP_BUTTON2,0);
               end;
    mptMPC   : begin
                 wnd := GetMPCHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,MEDIA_PLAY,0);
               end;
    mptQCD   : begin
                 wnd := GetQCDHandle;
                 if wnd <> 0 then SendMessage(wnd,WM_COMMAND,QCD_COMMAND_PLAY,0);
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

procedure TMainForm.btn_pselectClick(Sender: TObject);
var
  p : TPoint;
begin
  p := ClientToScreen(Point(btn_pselect.Left, btn_pselect.Top + btn_pselect.Height));
  playerpopup.Popup(p.x,p.y);
end;

procedure TMainForm.Foobar20001Click(Sender: TObject);
begin
  sPlayer := mptFoobar;
  SaveSettings;
  UpdatePSelectIcon;
end;

procedure TMainForm.MediaPlayerClassic1Click(Sender: TObject);
begin
  sPlayer := mptMPC;
  SaveSettings;
  UpdatePSelectIcon;
end;

procedure TMainForm.Winamp1Click(Sender: TObject);
begin
  sPlayer := mptWinAmp;
  SaveSettings;
  UpdatePSelectIcon;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
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
 FIconFoobar.Free;
 FIconWinAmp.Free;
 FIconMPC.Free;
 FIconQCD.Free;
 FIconWMP.Free;
 FIconVLC.Free;
end;

procedure TMainForm.QCD1Click(Sender: TObject);
begin
  sPlayer := mptQCD;
  SaveSettings;
  UpdatePSelectIcon;
end;

procedure TMainForm.WindowsMediaPlayer1Click(Sender: TObject);
begin
  sPlayer := mptWMP;
  SaveSettings;
  UpdatePSelectIcon;
end;

procedure TMainForm.VLCMediaPlayer1Click(Sender: TObject);
begin
  sPlayer := mptVLC;
  SaveSettings;
  UpdatePSelectIcon;
end;

end.
