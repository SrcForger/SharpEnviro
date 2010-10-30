{
Source Name: MainWnd
Description: SystemTray Module - Main Window
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32_Image, SharpEBaseControls, SharpEButton,
  JclWideStrings, JclSimpleXML, SharpApi, Menus, GR32_Layers, Types, JclSysInfo,
  TrayIconsManager, Math, GR32, SharpECustomSkinSettings, SharpESkinLabel,
  ToolTipApi,Commctrl, uISharpBarModule, SharpIconUtils, GR32_PNG,
  uSharpEMenu, uSharpEMenuWnd, uSharpEMenuSettings, uSharpEMenuItem, pngimage,
  ExtCtrls, StrUtils;


type
  TMainForm = class(TForm)
    lb_servicenotrunning: TSharpESkinLabel;
    ShowHideButton: TSharpEButton;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnOnClick(pItem: TSharpEMenuItem; pMenuWnd : TObject; var CanClose: boolean);
    procedure ShowHideButtonClick(Sender: TObject);
  protected
  private
    sEnableIconHiding   : Boolean;
    sShowBackground     : Boolean;
    sBackgroundColor    : integer;
    sBackgroundColorStr : String;
    sBackgroundAlpha    : integer;
    sShowBorder         : Boolean;
    sBorderColor        : integer;
    sBorderColorStr     : String;
    sBorderAlpha        : integer;
    sColorBlend         : Boolean;
    sBlendColor         : integer;
    sBlendColorStr      : String;
    sBlendAlpha         : integer;
    sIconAlpha          : integer;
    sIconAutoSize       : Boolean;
    cwidth              : integer;
    doubleclick         : boolean;
    refreshed           : boolean;
    FCustomSkinSettings : TSharpECustomSkinSettings;
    procedure CMMOUSELEAVE(var msg : TMessage); message CM_MOUSELEAVE;
    procedure WMNotify(var msg : TWMNotify); message WM_NOTIFY;

    procedure LoadIcons;
  public
    FTrayClient : TTrayClient;
    Buffer     : TBitmap32;
    mInterface : ISharpBarModule;
    procedure ShowHideMenu;
    procedure RepaintIcons(pRepaint : boolean = True);
    procedure LoadSettings;
    procedure SaveSettings;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
  end;


implementation

uses SharpThemeApiEx,
     uSharpXMLUtils,
     uTypes;

type
  TTrayWnd = class
             public
               Wnd : TMainForm;
               TipWnd : hwnd;
             end;

{$R *.dfm}

function Li2Double(x: LARGE_INTEGER): Double;
begin
  Result := x.HighPart * 4.294967296E9 + x.LowPart
end;

procedure TMainForm.UpdateComponentSkins;
begin
  lb_servicenotrunning.SkinManager := mInterface.SkinInterface.SkinManager;
  ShowHideButton.SkinManager    := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.mnOnClick(pItem: TSharpEMenuItem; pMenuWnd : TObject; var CanClose: boolean);
var
  n : integer;
  TrayItem : TTrayItem;
  menu : TSharpEMenu;
  menuWnd : TSharpEMenuWnd;
begin
  CanClose := False;

  if pItem = nil then
    exit;

  TrayItem := nil;
  for n := 0 to FTrayClient.Items.Count - 1 do
  begin
    TrayItem := TTrayItem(FTrayClient.Items.Items[n]);
    if (TrayItem.Wnd = pItem.PropList.GetInt('Wnd'))
      and (TrayItem.UID = pItem.PropList.GetInt('uID')) then
        break;
        
    TrayItem := nil;
  end;
  
  if TrayItem <> nil then
  begin
    menu := TSharpEMenu(pItem.OwnerMenu);
    menuwnd := TSharpEMenuWnd(pMenuWnd);

    if pItem.PropList.GetBool('Hide') then
    begin
      FTrayClient.HiddenList.Add(GetProcessNameFromWnd(TrayItem.Wnd) + ':' + inttostr(TrayItem.UID));
      TrayItem.HiddenByClient := True;
      TSharpEMenu(pItem.OwnerMenu).Items.Extract(pItem);
      menu.Items.Insert(menu.items.count,pItem);      
      //TSharpEMenu(TSharpEMenuItem(TSharpEMenu(TSharpEMenu(pItem.OwnerMenu).ParentMenuItem.OwnerMenu).Items.Items[1]).SubMenu).Items.Add(pItem);
      //pItem.OwnerMenu := TSharpEMenu(TSharpEMenuItem(TSharpEMenu(TSharpEMenu(pItem.OwnerMenu).ParentMenuItem.OwnerMenu).Items.Items[1]).SubMenu);
      pItem.PropList.Add('Hide',False);
    end else
    begin
      n := FTrayClient.HiddenList.IndexOf(GetProcessNameFromWnd(TrayItem.Wnd) + ':' + inttostr(TrayItem.UID));
      if n >= 0 then
        FTrayClient.HiddenList.Delete(n);
      TrayItem.HiddenByClient := False;
      TSharpEMenu(pItem.OwnerMenu).Items.Extract(pItem);
      for n := menu.items.Count - 1 downto 0 do
        if TSharpEMenuItem(menu.items.items[n]).ItemType = mtLabel then
        begin
          menu.Items.Insert(n-1,pItem);
          break;
        end;
        
      //TSharpEMenu(TSharpEMenuItem(TSharpEMenu(TSharpEMenu(pItem.OwnerMenu).ParentMenuItem.OwnerMenu).Items.Items[0]).SubMenu).Items.Add(pItem);
      //pItem.OwnerMenu := TSharpEMenu(TSharpEMenuItem(TSharpEMenu(TSharpEMenu(pItem.OwnerMenu).ParentMenuItem.OwnerMenu).Items.Items[0]).SubMenu);
      pItem.PropList.Add('Hide',True);
    end;
    FTrayClient.UpdateHiddenStatus;
    FTrayClient.UpdateTrayIcons;
    FTrayClient.RenderIcons;

    // If the bar is not full screen then it will resize when you hide/unhide icons
    // which causes the menu to deactivate and lose focus.
    menuWnd.IgnoreNextKillFocus := True;
    menuwnd.IgnoreNextDeactivate := True;

    RealignComponents;

    // After the bar is done realigning ensure we set focus back to the menu.
    if not menuWnd.Focused then
      menuWnd.SetFocus;
    // Ensure this is disabled as focus is not lost when the bar is full screen.
    menuWnd.IgnoreNextKillFocus := False;

    menuwnd.IgnoreNextDeactivate := True;
    menu.RenderBackground(menuwnd.Left,menuwnd.Top,false,menu.SpecialBackgroundSource);
    menu.RenderNormalMenu;
    menu.RenderTo(menuwnd.Picture);
    menuwnd.PreMul(menuwnd.Picture);
    menuwnd.DrawWindow;

    SaveSettings;
  end;
end;

procedure TMainForm.SaveSettings;
var
  XML : TJclSimpleXML;
  n : integer;
begin
  XML := TJclSimpleXML.Create;
  if not LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
  begin
    XML.Root.Clear;
    XML.Root.Name := 'SystemTrayModuleSettings';
  end;
  with xml.Root.Items do
  begin
    if (ItemNamed['Hidden'] = nil) then
      Add('Hidden');
    with ItemNamed['Hidden'].Items do
    begin
      Clear;
      for n := 0 to FTrayClient.HiddenList.Count - 1 do
        Add('item',FTrayClient.HiddenList[n]);
    end;
  end;
  if not SaveXMLToSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    SharpApi.SendDebugMessageEx('SystemTray',PChar('Failed to Save Settings to File: ' + mInterface.BarInterface.GetModuleXMLFile(mInterface.ID)), clred, DMT_ERROR);
end;

procedure TMainForm.ShowHideButtonClick(Sender: TObject);
begin
  ShowHideMenu;
end;

procedure TMainForm.ShowHideMenu;
var
  p : TPoint;
  mn : TSharpEMenu;
  ms : TSharpEMenuSettings;
  wnd : TSharpEMenuWnd;
  n: integer;
  item : TSharpEMenuItem;
  R : TRect;
  Bmp : TBitmap32;
  TrayItem : TTrayItem;
  s : String;
begin
  if FindWindow('TSharpEMenuWnd',nil) <> 0 then
    exit;

  ms := TSharpEMenuSettings.Create;
  ms.LoadFromXML;
  ms.WrapMenu := False;
  ms.UseGenericIcons := False;
  ms.CacheIcons := False;
  ms.MultiThreading := False;

  mn := TSharpEMenu.Create(mInterface.SkinInterface.SkinManager,ms);
  ms.Free;

  SharpEMenuIcons.Items.Clear;

  Bmp := TBitmap32.Create;

  mn.AddLabelItem('Visible Icons',False);
  for n := 0 to FTrayClient.Items.Count - 1 do
  begin
    TrayItem := TTrayItem(FTrayClient.Items.Items[n]);
    if IsWindow(TrayItem.wnd) then
    begin
      IconToImage(Bmp,TrayItem.Icon);
      s := StringReplace(TrayItem.FTip, sLineBreak, ', ', [rfReplaceAll, rfIgnoreCase]);
      { + ' (' + ExtractFileName(GetProcessNameFromWnd(TrayItem.Wnd)) + ')'}
      if not TrayItem.HiddenByClient then
      begin
        item := TSharpEMenuItem(mn.AddCustomItem(s,'customicon:'+inttostr(n),Bmp));
        item.PropList.Add('wnd',TrayItem.wnd);
        item.PropList.Add('uID',TrayItem.UID);
        item.PropList.Add('Hide',not TrayItem.HiddenByClient);
        item.OnClick := mnOnClick;
      end;
    end;
  end;
  mn.AddSeparatorItem(False);
  mn.AddLabelItem('Hidden Icons',False);
  for n := 0 to FTrayClient.Items.Count - 1 do
  begin
    TrayItem := TTrayItem(FTrayClient.Items.Items[n]);
    if IsWindow(TrayItem.wnd) then
    begin
      IconToImage(Bmp,TrayItem.Icon);
      s := TrayItem.FTip;
      { + ' (' + ExtractFileName(GetProcessNameFromWnd(TrayItem.Wnd)) + ')'}
      if TrayItem.HiddenByClient then
      begin
        item := TSharpEMenuItem(mn.AddCustomItem(s,'customicon:'+inttostr(n),Bmp));
        item.PropList.Add('wnd',TrayItem.wnd);
        item.PropList.Add('uID',TrayItem.UID);
        item.PropList.Add('Hide',not TrayItem.HiddenByClient);
        item.OnClick := mnOnClick;
      end;
    end;
  end;  

  Bmp.Free;

  mn.RenderBackground(0,0);  

  wnd := TSharpEMenuWnd.Create(self,mn);
  wnd.FreeMenu := True; // menu will free itself when closed

  GetWindowRect(mInterface.BarInterface.BarWnd,R);
  p := ClientToScreen(Point(0, self.Height + self.Top));
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
    wnd.Top := R.Top - wnd.Picture.Height - mInterface.SkinInterface.SkinManager.Skin.Menu.LocationOffset.Y;
  end;
  if wnd.Top < Monitor.Top then
  begin
    if wnd.Picture.Height > Monitor.Height then
      wnd.Height := Monitor.Height;
    wnd.Top := 0;
  end;
  wnd.Show;
end;

procedure TMainForm.CMMOUSELEAVE(var msg : TMessage);
begin
  FTrayClient.PerformIconAction(0,0,0,0,0,WM_MOUSELEAVE,self);
end;

procedure TMainForm.WMNotify(var msg : TWMNotify);
var
  result : boolean;
  n : integer;
  s : String;
  ws : WideString;
begin
  if Msg.NMHdr.code = TTN_SHOW then
  begin
    SetWindowPos(Msg.NMHdr.hwndFrom, HWND_TOPMOST, 0, 0, 0, 0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    msg.result := 1;
    exit;
  end;

  Result := (Msg.NMHdr.code = TTN_NEEDTEXT);
  if (FTrayClient.TipForm = self) and (FTrayClient.TipWnd = Msg.NMHdr.hwndFrom) then
    Result := Result and True;

  if result then msg.result := 1
     else msg.result := 0;

  if result then
  begin
    SendMessage(Msg.NMHdr.hwndFrom, TTM_SETMAXTIPWIDTH, 0, 512);

    if FTrayClient.LastTipItem = nil then exit;

    if Msg.NMHdr.code = TTN_NEEDTEXTA then
    begin
      with PNMTTDispInfoA(Msg.NMHdr)^ do
      begin
        s := FTrayClient.LastTipItem.FTip;
        if length(s) > 80 then
           lpszText := PAnsiChar(s)
           else for n := 0 to length(s)-1 do
                szText[n] := Char(FTrayClient.LastTipItem.FTip[n]);
        hinst := 0;
      end;
    end
    else
      with PNMTTDispInfoW(Msg.NMHdr)^ do
      begin
        ws := FTrayClient.LastTipItem.FTip;
        if length(ws) > 80 then
           lpszText := PWideChar(ws)
           else for n := 0 to length(s)-1 do
            szText[n] := FTrayClient.LastTipItem.FTip[n];
        hinst := 0;
      end;
  end;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  skin : String;
  n : integer;
begin
  // Load Skin custom settings as default
  sShowBackground     := False;
  sBackgroundColor    := 0;
  sBackgroundColorStr := '0';
  sBackgroundAlpha    := 255;
  sShowBorder         := False;
  sBorderColor        := clwhite;
  sBorderColorStr     := 'clwhite';
  sBorderAlpha        := 255;
  sColorBlend         := False;
  sBlendColor         := clwhite;
  sBlendColorStr      := 'clwhite';
  sBlendAlpha         := 255;
  sIconAlpha          := 255;
  sEnableIconHiding   := True;
  sIconAutoSize       := False;
  FCustomSkinSettings.LoadFromXML('');
  try
    with FCustomSkinSettings.xml.Items do
    begin
      if ItemNamed['systemtray'] <> nil then
        with ItemNamed['systemtray'].Items do
        begin
          sShowBackground     := BoolValue('showbackground',False);
          sBackgroundColorStr := Value('backgroundcolor','0');
          sBackgroundAlpha    := IntValue('backgroundalpha',255);
          sShowBorder         := BoolValue('showborder',False);
          sBorderColorStr     := Value('bordercolor','clwhite');
          sBorderAlpha        := IntValue('borderalpha',255);
          sColorBlend         := BoolValue('colorblend',false);
          sBlendColorStr      := Value('blendcolor','clwhite');
          sBlendAlpha         := IntValue('blendalpha',0);
          sIconAlpha          := IntValue('iconalpha',255);
         end;
    end;
  except
  end;

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
  begin  
    with xml.Root.Items do
    begin
      skin := GetCurrentTheme.Skin.Name;
      skin := StringReplace(skin,' ','_',[rfReplaceAll]);

      FTrayClient.HiddenList.Clear;

      sIconAutoSize := BoolValue('IconAutoSize', sIconAutoSize);
      sEnableIconHiding   := BoolValue('iconhiding', True);
      if (ItemNamed['Hidden'] <> nil) and (sEnableIconHiding) then
        with ItemNamed['Hidden'].Items do
        for n := 0 to Count - 1 do
          FTrayClient.HiddenList.Add(Item[n].Value);
      FTrayClient.UpdateHiddenStatus;

      if ItemNamed['skin'] <> nil then
         if ItemNamed['skin'].Items.ItemNamed[skin] <> nil then
            with ItemNamed['skin'].Items.ItemNamed[skin].Items do
            begin
              sShowBackground     := BoolValue('ShowBackground',sShowBackground);
              sBackgroundColorStr := Value('BackgroundColor',sBackgroundColorStr);
              sBackgroundAlpha    := IntValue('BackgroundAlpha',sBackgroundAlpha);
              sShowBorder         := BoolValue('ShowBorder',sShowBorder);
              sBorderColorStr     := Value('BorderColor',sBorderColorStr);
              sBorderAlpha        := IntValue('BorderAlpha',sBorderAlpha);
              sColorBlend         := BoolValue('ColorBlend',sColorBlend);
              sBlendColorStr      := Value('BlendColor',sBlendColorStr);
              sBlendAlpha         := IntValue('BlendAlpha',sBlendAlpha);
              sIconAlpha          := IntValue('IconAlpha',sIconAlpha);
            end;
    end;
  end;
  XML.Free;
  if not sEnableIconHiding then
  begin
    ShowHideButton.Width := 0;
    ShowHideButton.Visible := False;
    ShowHideButton.Enabled := False;

    FTrayClient.ArrowWidth := ShowHideButton.Width;
    FTrayClient.ArrowHeight := ShowHideButton.Height;
  end;
  FTrayClient.IconAutoSize := sIconAutoSize;
  FTrayClient.UpdateTrayIcons;
end;

procedure TMainForm.LoadIcons;
var
  size : integer;
  TempBmp : TBitmap32;
  rc : TRect;
begin
  if mInterface = nil then
      exit;
  if mInterface.SkinInterface = nil then
    exit;

  size := 16{mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y};
  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(size,size);

  TempBmp.Clear(color32(0,0,0,0));

  // Change arrow depending on what position the bar has
  GetWindowRect(mInterface.BarInterface.BarWnd, rc);
  if rc.Top <= 0 then
    IconStringToIcon('icon.tray.arrow.down', '', TempBmp, size)
  else
    IconStringToIcon('icon.tray.arrow.up', '', TempBmp, size);

  ShowHideButton.Glyph32.Clear(color32(0,0,0,0));
  ShowHideButton.Glyph32.SetSize(16, mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y);
  TempBmp.DrawTo(ShowHideButton.Glyph32, 0, 1 + (ShowHideButton.Height - TempBmp.Height) div 2);
  ShowHideButton.UpdateSkin;

  TempBmp.Free;
end;

procedure TMainForm.ReAlignComponents;
var
 newwidth : integer;
begin
  if (sEnableIconHiding) and (not lb_servicenotrunning.visible) then
  begin
    ShowHideButton.Width := 16;
    ShowHideButton.Visible := True;
    ShowHideButton.Enabled := True;

    LoadIcons;
  end;

  if lb_servicenotrunning.visible then
  begin
    ShowHideButton.Width := 0;
    ShowHideButton.Visible := False;
    ShowHideButton.Enabled := False;

    FTrayClient.ArrowWidth := ShowHideButton.Width;
    FTrayClient.ArrowHeight := ShowHideButton.Height;

    lb_servicenotrunning.UpdateSkin;
    lb_servicenotrunning.UpdateAutoPosition;
    newWidth := lb_servicenotrunning.TextWidth+8;
    lb_servicenotrunning.Left := 2;
  end else
  begin
    if FTrayClient <> nil then
    begin
      sBackGroundColor := mInterface.SkinInterface.SkinManager.ParseColor(sBackGroundColorStr);
      sBorderColor     := mInterface.SkinInterface.SkinManager.ParseColor(sBorderColorStr);
      sBlendColor      := mInterface.SkinInterface.SkinManager.ParseColor(sBlendColorStr);

      FTrayClient.ArrowWidth := ShowHideButton.Width;
      FTrayClient.ArrowHeight := ShowHideButton.Height;

      FTrayClient.TopOffset       := (Height - FTrayClient.IconSize) div 2;
      FTrayClient.BackGroundColor := sBackGroundColor;
      FTrayClient.DrawBackground  := sShowBackground;
      FTrayClient.BackgroundAlpha := sBackgroundAlpha;
      FTrayClient.BorderColor     := sBorderColor;
      FTrayClient.DrawBorder      := sShowBorder;
      FTrayClient.BorderAlpha     := sBorderAlpha;
      FTrayClient.ColorBlend      := sColorBlend;
      FTrayClient.BlendColor      := sBlendColor;
      FTrayClient.BlendAlpha      := sBlendAlpha;
      FTrayClient.IconAlpha       := sIconAlpha;
      FTrayClient.IconAutoSize    := sIconAutoSize;
      if sIconAutoSize then
        FTrayClient.IconSize := Height - 6;
      FTrayClient.RenderIcons;
      NewWidth := FTrayClient.Bitmap.Width + ShowHideButton.Width;
      begin
        cwidth := Width;
      end;
    end else NewWidth := 64;
  end;

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TMainForm.RepaintIcons(pRepaint : boolean = True); 
begin
  Buffer.Assign(mInterface.Background);
  if FTrayClient = nil then
    exit;
    
  FTrayClient.Bitmap.DrawMode := dmBlend;
  FTrayClient.Bitmap.DrawTo(Buffer,ShowHideButton.Width,Height div 2 - FTrayClient.Bitmap.Height div 2);

  //ShowHideButton.Glyph32.DrawTo(Buffer, 0, 0);

  if pRepaint then
     Repaint;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  FCustomSkinSettings := TSharpECustomSkinSettings.Create;

  Buffer := TBitmap32.Create;
  Buffer.DrawMode := dmBlend;
  Buffer.CombineMode := cmMerge;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FCustomSkinSettings);
  Buffer.Free;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Buffer.DrawTo(Canvas.Handle,0,0);
end;

procedure TMainForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  modx : integer;
begin
  if lb_servicenotrunning.Visible then
    exit;

  p := ClientToScreen(point(x,y));
  modx := x - ShowHideButton.Width;

  if ssDouble in Shift then
  begin
    doubleclick := True;
    case Button of
      mbRight: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_RBUTTONDBLCLK,self);
      mbMiddle: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_MBUTTONDBLCLK,self);
      mbLeft: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_LBUTTONDBLCLK,self);
    end;
  end else
  begin
    case Button of
      mbRight: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_RBUTTONDOWN,self);
      mbMiddle: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_MBUTTONDOWN,self);
      mbLeft: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_LBUTTONDOWN,self);
    end;
  end;
end;

procedure TMainForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  modx : integer;
begin
  if lb_servicenotrunning.Visible then
    exit;

  if doubleclick then
  begin
    doubleclick := False;
    exit;
  end;

  p := ClientToScreen(point(x,y));
  modx := x - ShowHideButton.Width;

  case Button of
    mbRight:  FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_RBUTTONUP,self);
    mbMiddle: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_MBUTTONUP,self);
    mbLeft:   FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_LBUTTONUP,self);
  end;
end;

procedure TMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  p : TPoint;
  modx : integer;
begin
  if lb_servicenotrunning.Visible then
    exit;

  if refreshed then
  begin
    refreshed := False;
    exit;
  end;

  p := ClientToScreen(point(x,y));
  modx := x - ShowHideButton.Width;
  FTrayClient.PerformIconAction(modx,y,p.x + ShowHideButton.Width,p.y,0,WM_MOUSEMOVE,self);
end;

end.
