{
Source Name: MainWnd.pas
Description: Button Module - Main Window
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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
  Windows, Messages, SysUtils, Classes, Controls, Forms, Graphics,
  Dialogs, StdCtrls, SharpEButton, SharpApi, Menus, Math,
  ShellApi, MediaPlayerList, GR32, GR32_PNG, Types, SharpEBaseControls, ExtCtrls,
  Registry, uSharpEMenuWnd, uSharpEMenu, uSharpEMenuSettings, uSharpEMenuItem,
  uISharpBarModule, SharpIconUtils;


type
  TControlCommandType = (cctPlay,cctPause,cctStop,cctNext,cctPrev);

  TMainForm = class(TForm)
    btn_next: TSharpEButton;
    btn_prev: TSharpEButton;
    btn_pause: TSharpEButton;
    btn_stop: TSharpEButton;
    btn_play: TSharpEButton;
    btn_pselect: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_prevClick(Sender: TObject);
    procedure btn_stopClick(Sender: TObject);
    procedure btn_pauseClick(Sender: TObject);
    procedure btn_playClick(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
    procedure mnOnClick(pItem : TSharpEMenuItem; pMenuWnd : TObject; var CanClose : boolean);
    procedure btn_pselectMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  protected
  private
    FMPlayers : TMediaPlayerList;
    procedure WMExecAction(var msg : TMessage); message WM_SHARPEACTIONMESSAGE;
    procedure SendAppCommand(pType : TControlCommandType);
    function GetStartPlayer(Root : HKEY; Key : String; Value : String) : String;
  public
    sPlayer : String;
    sPSelect : Boolean;
    mInterface : ISharpBarModule;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure UpdateSharpEActions;
    procedure UpdateSelectIcon;
    procedure LoadIcons;
  end;

var
 WM_SHELLHOOK : integer;

implementation


uses
  JclSimpleXML,
  PlayerSelectWnd,
  uSharpXMLUtils;

{$R *.dfm}
{$R MPGlyphs.res}

function TMainForm.GetStartPlayer(Root : HKEY; Key : String; Value : String) : String;
var
  Reg : TRegistry;
  PlayerPath : String;
//  PlayerSelectForm: TPlayerSelectForm;
  selectedFile : String;
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
    if PromptForFileName(selectedFile,'Applications (*.exe)|*.exe','','Select the location of the media player', '', False) then
      PlayerPath := selectedFile
    else PlayerPath := '';
//    PlayerSelectForm := TPlayerSelectForm.Create(self);
//    if PlayerSelectForm.ShowModal = mrOk then
    //   PlayerPath := PlayerSelectForm.edit_player.Text
  //     else PlayerPath := '';
//    PlayerSelectForm.Show;
//    PlayerSelectForm.Free;
  end;
  result := PlayerPath;
  SharpApi.SharpExecute('_nohist,' + PlayerPath);
end;

procedure TMainForm.UpdateComponentSkins;
begin
  btn_next.SkinManager    := mInterface.SkinInterface.SkinManager;
  btn_prev.SkinManager    := mInterface.SkinInterface.SkinManager;
  btn_pause.SkinManager   := mInterface.SkinInterface.SkinManager;
  btn_stop.SkinManager    := mInterface.SkinInterface.SkinManager;
  btn_play.SkinManager    := mInterface.SkinInterface.SkinManager;
  btn_pselect.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.UpdateSelectIcon;
var
  mitem : TMediaPlayerItem;
begin
  mitem := FMPlayers.GetItem(sPlayer);
  if mitem <> nil then
  begin
    btn_pselect.Glyph32.Assign(mitem.Icon);
    btn_pselect.UpdateSkin;
  end;
end;

procedure TMainForm.UpdateSharpEActions;
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

procedure TMainForm.SaveSettings;
var
  XML : TJclSimpleXML;
  Dir : String;
  FName : String;
  n : integer;
  mitem : TMediaPlayerItem;
begin
  XML := TJclSimpleXML.Create;
  XML.Root.Name := 'MediaControllerModuleSettings';
  with XML.Root.Items do
  begin
    Add('Player',sPlayer);
    AdD('PSelect',sPSelect);
  end;
  if not SaveXMLToSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    SharpApi.SendDebugMessageEx('MediaController',PChar('Failed to Save Settings to File: '+ mInterface.BarInterface.GetModuleXMLFile(mInterface.ID)),clred,DMT_ERROR);
  XML.Free;

  XML := TJclSimpleXML.Create;
  XML.Root.Name := 'MediaControllerPlayers';
  for n := 0 to FMPlayers.Items.Count - 1 do
    with XML.Root.Items.Add('Item').Items do
    begin
      mitem := TMediaPlayerItem(FMPlayers.Items[n]);
      Add('Name',mitem.Name);
      Add('Path',mitem.PlayerPath);
    end;
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Module Settings\';
  FName := Dir + 'MediaPlayers.xml';
  if not DirectoryExists(Dir) then
    ForceDirectories(Dir);
  if not SaveXMLToSharedFile(XML,FName,True) then
    SharpApi.SendDebugMessageEx('MediaController',PChar('Failed to save Media Player Settings to File: ' + FName),clred,DMT_ERROR);
  XML.Free;
end;

procedure TMainForm.LoadIcons;
var
  TempBmp : TBitmap32;
  size : integer;
begin
  if mInterface = nil then
    exit;
  if mInterface.SkinInterface = nil then
    exit;

  size := GetNearestIconSize(mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y);
  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(size,size);

  TempBmp.Clear(color32(0,0,0,0));
  IconStringToIcon('icon.mediaplayer.pause', '', TempBmp, size);
  btn_pause.Glyph32.Assign(TempBmp);
  btn_pause.UpdateSkin;

  TempBmp.Clear(color32(0,0,0,0));
  IconStringToIcon('icon.mediaplayer.play', '', TempBmp, size);
  btn_play.Glyph32.Assign(tempBmp);
  btn_play.UpdateSkin;

  TempBmp.Clear(color32(0,0,0,0));
  IconStringToIcon('icon.mediaplayer.stop', '', TempBmp, size);
  btn_stop.Glyph32.Assign(tempBmp);
  btn_stop.UpdateSkin;

  TempBmp.Clear(color32(0,0,0,0));
  IconStringToIcon('icon.mediaplayer.previous', '', TempBmp, size);
  btn_prev.Glyph32.Assign(tempBmp);
  btn_prev.UpdateSkin;

  TempBmp.Clear(color32(0,0,0,0));
  IconStringToIcon('icon.mediaplayer.next', '', TempBmp, size);
  btn_next.Glyph32.Assign(tempBmp);
  btn_next.UpdateSkin;

  TempBmp.Free;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  mitem : TMediaPlayerItem;
  n : integer;
begin
  sPlayer := 'Windows Media Player';
  sPSelect := True;

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    with XML.Root.Items do
    begin
      sPlayer := Value('Player',sPlayer);
      sPSelect := BoolValue('PSelect',sPSelect);
    end;
  XML.Free;

  // temporary override... remove when settings window is done!
  sPSelect := True;

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Module Settings\MediaPlayers.xml',True) then
    with XML.Root.Items do
    begin
      for n := 0 to Count - 1 do
      with XML.Root.Items.Item[n].Items do
      begin
        mitem := FMPlayers.GetItem(Value('Name','###error###'));
        if mitem <> nil then
          mitem.PlayerPath := Value('Path','');
      end;
    end;
  XML.Free;

  UpdateActions;
  UpdateSelectIcon;
end;

procedure TMainForm.mnOnClick(pItem: TSharpEMenuItem; pMenuWnd : TObject; var CanClose: boolean);
var
  mitem : TMediaPlayerItem;
begin
  CanClose := True;

  if pItem = nil then
    exit;

  mitem := FMPlayers.GetItem(pItem.Caption);
  if mitem <> nil then
  begin
    sPlayer := mitem.Name;
    UpdateSelectIcon;
  end;
  SaveSettings;
end;

procedure TMainForm.ReAlignComponents;
var
  newWidth : integer;
  i : integer;
  buttonwidth : integer;
begin
  LoadIcons;
  //buttonwidth := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;
  buttonwidth := btn_play.GetIconWidth + 6;
  //buttonwidth := buttonwidth - 4;
  btn_play.Width    := buttonwidth;
  btn_pause.Width   := buttonwidth;
  btn_stop.Width    := buttonwidth;
  btn_prev.Width    := buttonwidth;
  btn_next.Width    := buttonwidth;
  btn_pselect.Width := buttonwidth;

  btn_play.Left := 2;
  btn_pause.Left := btn_play.Left + btn_play.Width;
  btn_stop.Left := btn_pause.Left + btn_pause.Width;
  btn_prev.Left := btn_stop.Left + btn_stop.Width;
  btn_next.Left := btn_prev.Left + btn_prev.Width;
  i := 0;

  if sPSelect then
  begin
    i := btn_pselect.Width;
    btn_pselect.Left := btn_next.Left + btn_next.Width;
    btn_pselect.Visible := True;
  end else btn_pselect.Visible := False;

  newWidth := btn_next.Left + btn_next.Width + i + 2;
  
  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize;
end;

procedure TMainForm.SendAppCommand(pType : TControlCommandType);
var
  wnd : hwnd;
  mitem : TMediaPlayerItem;
  param : word;
  sparam : string;
begin
  mitem := FMPlayers.GetItem(sPlayer);
  if mitem <> nil then
  begin
    wnd := FMPlayers.GetPlayerHandle(sPlayer);

    if (mitem.AppCommand) and (mitem.PlayerPath <> '') then
    begin
      case pType of
        cctPlay  : sparam := mitem.cmdPlay;
        cctPause : sparam := mitem.cmdPause;
        cctStop  : sparam := mitem.cmdStop;
        cctNext  : sparam := mitem.cmdNext;
        cctPrev  : sparam := mitem.cmdPrev;
        else sparam := '';
      end;

      if sparam <> '' then
        SharpExecute(mitem.PlayerPath + ' ' + sparam);
    end else if wnd <> 0 then
    begin
      case pType of
        cctPlay  : param := mitem.btnPlay;
        cctPause : param := mitem.btnPause;
        cctStop  : param := mitem.btnStop;
        cctNext  : param := mitem.btnNext;
        cctPrev  : param := mitem.btnPrev;
        else param := 0;
      end;

      if(mitem.Command <> -1) then
      begin
        SendMessage(wnd,mitem.Command,param,0);
      end else
      begin
        case mitem.MessageType of
          smtAppCommand: SendMessage(wnd,WM_APPCOMMAND,0,MakeLParam(0,param));
          smtCommand: SendMessage(wnd,WM_COMMAND,param,0);
          smtKey:
          begin
            SendMessage(wnd, WM_KEYDOWN, VkKeyScan(Chr(param)), 0);
            SendMessage(wnd, WM_CHAR, VkKeyScan(Chr(param)), 0);
            SendMessage(wnd, WM_KEYUP, VkKeyScan(Chr(param)), 0);
          end;
        end;
      end;
    end else
    begin
      if FileExists(mitem.PlayerPath) then
        SharpApi.SharpExecute('_nohist,' + mitem.PlayerPath)
      else begin
        mitem.PlayerPath := GetStartPlayer(HKEY_LOCAL_MACHINE,mItem.RegPath,mItem.RegValue);
        SaveSettings;
      end;
    end;
  end;
end;

//#############################
//            PLAY
//#############################
procedure TMainForm.btn_playClick(Sender: TObject);
begin
  SendAppCommand(cctPlay);
end;

//#############################
//        NEXT TRACK
//#############################
procedure TMainForm.btn_nextClick(Sender: TObject);
begin
  SendAppCommand(cctNext);
end;

//#############################
//            PAUSE
//#############################
procedure TMainForm.btn_pauseClick(Sender: TObject);
begin
  SendAppCommand(cctPause);
end;

//#############################
//            STOP
//#############################
procedure TMainForm.btn_stopClick(Sender: TObject);
begin
  SendAppCommand(cctStop);
end;

//#############################
//       PREVIOUS TRACK
//#############################
procedure TMainForm.btn_prevClick(Sender: TObject);
begin
  SendAppCommand(cctPrev);
end;

procedure TMainForm.btn_pselectMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  mn : TSharpEMenu;
  ms : TSharpEMenuSettings;
  wnd : TSharpEMenuWnd;
  n : integer;
  R : TRect;
  mitem : TMediaPlayerItem;
begin
  if Button = mbLeft then
  begin
    if FMPlayers.Items.Count = 0 then
      exit;

    ms := TSharpEMenuSettings.Create;
    ms.LoadFromXML;
    ms.CacheIcons := False;
    ms.WrapMenu := False;
    ms.MultiThreading := False;

    mn := TSharpEMenu.Create(mInterface.SkinInterface.SkinManager,ms);
    ms.Free;

    for n := 0 to FMPlayers.Items.Count - 1 do
    begin
      mitem := TMediaPlayerItem(FMPlayers.Items[n]);
      TSharpEMenuItem(mn.AddCustomItem(mitem.Name,mitem.Name,mitem.Icon)).OnClick := mnOnClick;
    end;

    //mn.AddSeparatorItem(False);
    mn.RenderBackground(0,0);

    wnd := TSharpEMenuWnd.Create(self,mn);
    wnd.FreeMenu := True; // menu will free itself when closed

    GetWindowRect(mInterface.BarInterface.BarWnd,R);
    p := ClientToScreen(Point(btn_pselect.Left + btn_pselect.Width div 2, self.Height + self.Top));
    p.y := R.Top;
    p.x := p.x + mInterface.SkinInterface.SkinManager.Skin.Menu.LocationOffset.X - mn.Background.Width div 2;
    if p.x < Monitor.Left then
      p.x := Monitor.Left;
    if p.x + mn.Background.Width  > Monitor.Left + Monitor.Width then
      p.x := Monitor.Left + Monitor.Width - mn.Background.Width;
    wnd.Left := p.x;
    if p.Y < Monitor.Top + Monitor.Height div 2 then
      wnd.Top := R.Bottom + mInterface.SkinInterface.SkinManager.Skin.Menu.LocationOffset.Y
    else begin
      wnd.Top := R.Top - wnd.Picture.Height - mInterface.SkinInterface.SkinManager.Skin.Menu.GetLocationOffset.Y;
    end;
    wnd.show;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FMPlayers := TMediaPlayerList.Create;

  WM_SHELLHOOK := RegisterWindowMessage('SHELLHOOK');
  DoubleBuffered := True;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FMPlayers.Free;

  SharpApi.UnRegisterAction('!MC-Play');
  SharpApi.UnRegisterAction('!MC-Pause');
  SharpApi.UnRegisterAction('!MC-Stop');
  SharpApi.UnRegisterAction('!MC-Prev');
  SharpApi.UnRegisterAction('!MC-Next');

  if SharpEMenuPopups <> nil then
    FreeAndNil(SharpEMenuPopups);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

end.
