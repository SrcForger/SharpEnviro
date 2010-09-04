{
Source Name: MainWnd.pas
Description: Button Module - Main Window
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
  Dialogs, Menus, Math, GR32, ToolTipApi, ShellApi, CommCtrl, Types,
  JclSimpleXML,
  JclSysInfo,
  SharpCenterApi,
  SharpApi,
  SharpEBaseControls,
  SharpEButton,
  SharpFileUtils,
  uISharpBarModule,
  uVistaFuncs,
  uKnownFolders,
  uSharpEMenuItem,
  SharpIconUtils,
  ImgList,
  PngImageList;


type
  TButtonRecord = record
                    btn: TSharpEButton;
                    target: String;
                    icon: String;
                    caption: String;
                  end;

  TMainForm = class(TForm)
    sb_config: TSharpEButton;
    ButtonPopup: TPopupMenu;
    Delete1: TMenuItem;
    PngImageList1: TPngImageList;
    sb_btnlist: TSharpEButton;
    N1: TMenuItem;
    LaunchElevated1: TMenuItem;
    Launch1: TMenuItem;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);       
    procedure btnMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);         
    procedure sb_configClick(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure sb_btnlistMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnOnClick(pItem : TSharpEMenuItem; pMenuWnd : TObject; var CanClose : boolean);
    procedure mnOnConfigClick(pItem : TSharpEMenuItem; pMenuWnd : TObject; var CanClose : boolean);
    procedure LaunchElevated1Click(Sender: TObject);
    procedure Launch1Click(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    sShowLabel   : boolean;
    FButtonSpacing : integer;
    sShowIcon    : boolean;
    sFirstLaunch : boolean;
    FButtonList  : array of TButtonRecord;
    FHintWnd     : hwnd; 
    movebutton   : TSharpEButton;
    hasmoved     : boolean;
    requestedWidth : integer;
    tooltips     : array of integer;
    procedure ClearButtons;
    procedure AddButton(pTarget, pIcon : string); overload;
    procedure AddButton(pTarget,pIcon,pCaption : String; Index : integer = -1); overload;
    function UpdateButtons(newWidth : integer) : integer;
    procedure WMNotify(var msg : TWMNotify); message WM_NOTIFY;
    procedure WMDropFiles(var msg: TMessage); message WM_DROPFILES;
    function GetButtonIndex(pButton : TSharpEButton) : Integer;    
  public
    mInterface : ISharpBarModule;
    procedure LoadIcons;
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : Boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize(Value : integer);
    procedure RefreshIcons;
    procedure UpdateToolTips;
    procedure SaveSettings;
    function ImportQuickLaunchItems : boolean;
  end;


implementation

uses
  GR32_PNG,
  uSharpXMLUtils,
  uSharpEMenuWnd,
  uSharpEMenu,
  uSharpEMenuSettings;

{$R *.dfm}

procedure TMainForm.Launch1Click(Sender: TObject);
var
  BtnItem : TButtonRecord;
begin
  MoveButton := nil;
  BtnItem := FButtonList[ButtonPopup.Tag];
  SharpExecute(BtnItem.target);
  if hasmoved then
    SaveSettings;
end;

procedure TMainForm.LaunchElevated1Click(Sender: TObject);
var
  BtnItem : TButtonRecord;
begin
  MoveButton := nil;
  BtnItem := FButtonList[ButtonPopup.Tag];
  SharpExecute('_elevate,' + BtnItem.target);
  if hasmoved then
    SaveSettings;
end;

procedure TMainForm.LoadIcons;
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
  ResIDSuffix : String;
begin
  if mInterface = nil then
    exit;
  if mInterface.SkinInterface = nil then
    exit;

  TempBmp := TBitmap32.Create;
  if mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y <= 16 then
  begin
    TempBmp.SetSize(16,16);
    ResIDSuffix := '16';
  end else
  begin
    TempBmp.SetSize(32,32);
    ResIDSuffix := '32';
  end;

  TempBmp.Clear(color32(0,0,0,0));
  try
    ResStream := TResourceStream.Create(HInstance, 'listadd'+ResIDSuffix, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      sb_config.Glyph32.Assign(TempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  TempBmp.Clear(color32(0,0,0,0));
  try
    ResStream := TResourceStream.Create(HInstance, 'btnlist'+ResIDSuffix, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      sb_btnlist.Glyph32.Assign(TempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;  

  TempBmp.Free;

  sb_config.Glyph32.DrawMode := dmBlend;
  sb_config.Glyph32.CombineMode := cmMerge;
  sb_btnlist.Glyph32.DrawMode := dmBlend;
  sb_btnlist.Glyph32.CombineMode := cmMerge;
end;

procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := params.ExStyle or WS_EX_ACCEPTFILES;
end;

procedure TMainForm.Delete1Click(Sender: TObject);
var
  dbtn : TSharpEButton;
  n : integer;
  startindex : integer;
  dbtnwidth : integer;
  p : TPoint;
begin
  p := ScreenToClient(ButtonPopup.PopupPoint);
  dbtn := nil;
  startindex := -1;
  for n := 0 to High(FButtonList) do
    if (p.x > FButtonList[n].btn.Left)
      and (p.x < FButtonList[n].btn.Left + FButtonList[n].btn.Width) then
    begin
      dbtn := FButtonList[n].btn;
      startindex := n;
      break;
    end;

  if dbtn = nil then
    exit;

  dbtnwidth := FButtonList[startindex].btn.Width + FButtonSpacing;
  FButtonList[startindex].btn.Free;
  for n := startindex to High(FButtonList)-1 do
  begin
    with FButtonList[n] do
    begin
      btn := FButtonList[n+1].btn;
      btn.Left := FButtonList[n].btn.Left - dbtnwidth;
      target := FButtonList[n+1].target;
      caption := FButtonList[n+1].caption;
      icon := FButtonList[n+1].icon;
    end;
  end;
  setlength(FButtonList,length(FButtonList)-1);
  SaveSettings;
  RealignComponents(True);
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

procedure TMainForm.WMDropFiles(var msg: TMessage);
var
  pcFileName: PChar;
  i, iSize, iFileCount: integer;
  p : TPoint;
  n : integer;
  index : integer;
begin
  index := High(FButtonList) + 1;
  p := ScreenToClient(Mouse.CursorPos);
  for n := 0 to High(FButtonList) do
   if p.x < FButtonList[n].btn.Left then
   begin
     index := n - 1;
     break;
   end;

  pcFileName := '';
  iFileCount := DragQueryFile(Msg.wParam, $FFFFFFFF, pcFileName, 255);
  for i := 0 to iFileCount - 1 do
  begin
     iSize := DragQueryFile(Msg.wParam, i, nil, 0) + 1;
     pcFileName := StrAlloc(iSize);
     DragQueryFile(Msg.wParam, i, pcFileName, iSize);
     AddButton(pcFileName,'shell:icon',GetFileDescription(pcFileName),index);
     StrDispose(pcFileName);
  end;
  DragFinish(Msg.wParam);
  sb_config.Visible := False;  
  UpdateButtons(Width);
  SaveSettings;
  RealignComponents(True);
end;

procedure TMainForm.ClearButtons;
var
  n : integer;
begin
  MoveButton := nil;
  for n := 0 to High(FButtonList) do
    FButtonList[n].btn.Free;
  setlength(FButtonList,0);
  UpdateToolTips;
end;

procedure TMainForm.AddButton(pTarget: string; pIcon: string);
begin
  AddButton(pTarget, pIcon, GetFileDescription(pTarget));
end;

procedure TMainForm.AddButton(pTarget,pIcon,pCaption : String; Index : integer = -1);
var
  n : integer;
  btnLeft : Integer;
begin
  setlength(FButtonList,length(FButtonList)+1);
  if (Index < Low(FButtonList)) or (Index > High(FButtonList)) then
    Index := High(FButtonList)
    else for n := High(FButtonList) downto Index + 1 do
      begin
        with FButtonList[n] do
        begin
          btn := FButtonList[n-1].btn;
          target := FButtonList[n-1].target;
          caption := FButtonList[n-1].caption;
          icon := FButtonList[n-1].icon;
        end;
      end;

  btnLeft := FButtonSpacing;
  if Index > 0 then
    // If this is not the 1st button added then align the new button
    // to the right side of the previous button with some spacing.
    btnLeft := FButtonList[Index - 1].btn.Left + FButtonList[Index - 1].btn.Width + FButtonSpacing;

  with FButtonList[Index] do
  begin
    btn := TSharpEButton.Create(self);
    btn.PopUpMenu := ButtonPopup;
    btn.Visible := False;
    btn.AutoPosition := True;
    btn.AutoSize := True;
    btn.Hint := pTarget;
    btn.Parent := self;
    btn.Left := btnLeft;
    btn.OnMouseUp := btnMouseUp;
    btn.OnMouseDown := btnMouseDown;
    btn.OnMouseMove := btnMouseMove;
    btn.SkinManager := mInterface.SkinInterface.SkinManager;

    caption := pCaption;
    target := pTarget;
    icon := pIcon;

    if sShowLabel then
      btn.Caption := pCaption
    else
      btn.Caption := '';

    if sShowIcon then
    begin
      if not IconStringToIcon(pIcon,pTarget,btn.Glyph32,32) then
         btn.Glyph32.SetSize(0,0)
    end else btn.Glyph32.SetSize(0,0);

    btn.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;
    
    if sShowIcon and sShowLabel then
      btn.Width := btn.Width + btn.GetIconWidth + btn.GetTextWidth
    else if sShowIcon then
      btn.Width := btn.Width + btn.GetIconWidth
    else if sShowLabel then
      btn.Width := btn.Width + btn.GetTextWidth;

    if btn.Width < Height then
      btn.Width := Height;
  end;
end;

procedure TMainForm.RefreshIcons;
var
  n : integer;
begin
  if not sShowIcon then exit;

  for n := 0 to High(FButtonList) do
      with FButtonList[n] do
      begin
        if not IconStringToIcon(Icon,Target,btn.Glyph32,32) then
          btn.Glyph32.SetSize(0,0);
        btn.Repaint;
      end;
end;

procedure TMainForm.SaveSettings;
var
  XML : TJclSimpleXML;
  n : integer;
begin
  XML := TJclSimpleXMl.Create;
  XML.Root.Name := 'ButtonBarModuleSettings';
  with XML.Root.Items do
  begin
    Add('ShowCaption',sShowLabel);
    Add('ShowIcon',sShowIcon);
    Add('FirstLaunch',sFirstLaunch);
    with Add('Buttons').Items do
    begin
      for n := 0 to High(FButtonList) do
        with FButtonList[n] do
          with Add('item').Items do
          begin
            Add('Target',Target);
            Add('Icon',Icon);
            Add('Caption',Caption);
          end;
    end;
  end;
  if not SaveXMLToSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    SharpApi.SendDebugMessageEx('ButtonBar',PChar('Failed to save settings to File: ' + mInterface.BarInterface.GetModuleXMLFile(mInterface.ID)),clred,DMT_ERROR);
  XML.Free;
end;

procedure TMainForm.sb_btnlistMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  mn : TSharpEMenu;
  ms : TSharpEMenuSettings;
  wnd : TSharpEMenuWnd;
  n : integer;
  R : TRect;
begin
  if Button = mbLeft then
  begin
    if length(FButtonList) = 0 then
      exit;

    ms := TSharpEMenuSettings.Create;
    ms.LoadFromXML;
    ms.CacheIcons := False;
    ms.WrapMenu := False;
    ms.MultiThreading := False;

    mn := TSharpEMenu.Create(mInterface.SkinInterface.SkinManager,ms);
    ms.Free;

    for n := 0 to High(FButtonList) do
    begin
      if not FButtonList[n].btn.Visible then
      with TSharpEMenuItem(mn.AddCustomItem(FButtonList[n].caption,FButtonList[n].caption,FButtonList[n].btn.Glyph32)) do
      begin
        OnClick := mnOnClick;
        PropList.Add('Target',FButtonList[n].target);
      end;
    end;
    mn.AddSeparatorItem(False);
    with TSharpEMenuItem(mn.AddCustomItem('Configure','icon:special:config',sb_btnlist.Glyph32)) do
      OnClick := mnOnConfigClick;

    mn.RenderBackground(0,0);

    wnd := TSharpEMenuWnd.Create(self,mn);
    wnd.FreeMenu := True; // menu will free itself when closed

    GetWindowRect(mInterface.BarInterface.BarWnd,R);
    p := ClientToScreen(Point(sb_btnlist.Left + sb_btnlist.Width div 2, self.Height + self.Top));
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

procedure TMainForm.sb_configClick(Sender: TObject);
var
  cfile : String;
begin
  cfile := SharpApi.GetCenterDirectory + '_Modules\ButtonBar.con';

  if FileExists(cfile) then
    SharpCenterApi.CenterCommand(sccLoadSetting,
      PChar(cfile),
      PChar(inttostr(mInterface.BarInterface.BarID) + ':' + inttostr(mInterface.ID)));
end;

function TMainForm.UpdateButtons(newWidth : integer) : integer;
var
  n : integer;
  btnLeft : Integer;
  firstInv : boolean;
  firstInvIndex : Integer;
  iWidth : integer;
begin
  if sb_config.Visible then
  begin
    sb_config.SkinManager := mInterface.SkinInterface.SkinManager;
    sb_config.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod +
                       sb_config.GetIconWidth;// + sb_config.GetTextWidth;
  end;

  firstInv := False;
  firstInvIndex := 0;
  iWidth := 0;
  btnLeft := FButtonSpacing;
  for n := 0 to High(FButtonList) do
      with FButtonList[n] do
      begin
        btn.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;

        if sShowIcon and sShowLabel then
          btn.Width := btn.Width + btn.GetIconWidth + btn.GetTextWidth
        else if sShowIcon then
          btn.Width := btn.Width + btn.GetIconWidth
        else if sShowLabel then
          btn.Width := btn.Width + btn.GetTextWidth;

        if btn.Width < Height then
          btn.Width := Height;
          
        if n > 0 then
          // If this is not the 1st button then align the button
          // to the right side of the previous button with some spacing.
          btnLeft := FButtonList[n - 1].btn.Left + FButtonList[n - 1].btn.Width + FButtonSpacing;
             
        btn.Left := btnLeft;
        if btn.Left + btn.Width < newWidth then
           btn.Visible := True
        else begin
          if not firstInv then
          begin
            firstInv := True;
            firstInvIndex := n;
          end;
          btn.Visible := False;
        end;
        
        if btn.Visible then
          iWidth := btn.Left + btn.Width + FButtonSpacing;
      end;

  if firstInv then
  begin
    if firstInvIndex > 0 then
    begin
      FButtonList[firstInvIndex-1].btn.Visible := False;
      sb_btnlist.Visible := True;
      sb_btnlist.SkinManager := mInterface.SkinInterface.SkinManager;
      sb_btnlist.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod +
                          sb_btnlist.GetIconWidth;
      sb_btnlist.Left := FButtonList[firstInvIndex-1].btn.Left;
      
      iWidth := iWidth - FButtonList[firstInvIndex-1].btn.Width;
      iWidth := iWidth + sb_btnlist.Width;
    end else sb_btnlist.Visible := False;
  end else sb_btnlist.Visible := False;

  if sb_config.Visible then
    iWidth := iWidth + sb_config.Width + sb_config.Left + FButtonSpacing;

  result := iWidth;

  UpdateToolTips;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  n : integer;
begin
  ClearButtons;

  sShowLabel   := False;
  sShowIcon    := True;
  sFirstLaunch := True;
  FButtonSpacing := 2;

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    with xml.Root.Items do
    begin
      sShowLabel   := BoolValue('ShowCaption',False);
      sShowIcon    := BoolValue('ShowIcon',sShowIcon);
      sFirstLaunch := BoolValue('FirstLaunch',sFirstLaunch);
      if ItemNamed['Buttons'] <> nil then
      with ItemNamed['Buttons'].Items do
           for n := 0 to Count - 1 do
               AddButton(Item[n].Items.Value('Target','C:\'),
                         Item[n].Items.Value('Icon','shell:icon'),
                         Item[n].Items.Value('Caption','C:\'));
    end;
  XML.Free;

  if sFirstLaunch then
  begin
    ImportQuickLaunchItems;
    sFirstLaunch := False;
    if length(FButtonList) = 0 then // Add Some Default Items
    begin
      AddButton('%windir%\System32\mspaint.exe', 'shell:icon');
      AddButton('%windir%\System32\cmd.exe', 'shell:icon');
    end;
    SaveSettings;
    RealignComponents(True);
  end;
end;

procedure TMainForm.mnOnClick(pItem: TSharpEMenuItem; pMenuWnd: TObject;
  var CanClose: boolean);
var
  ActionStr : String;
begin
  if pItem = nil then
    exit;
  ActionStr := pItem.PropList.GetString('Target');
  if UPPERCASE(ActionStr) = '!SHOWMENU' then SetForegroundWindow(FindWindow(nil,'SharpMenuWMForm'));
    SharpApi.SharpExecute(ActionStr);

  CanClose := True;
end;

procedure TMainForm.mnOnConfigClick(pItem: TSharpEMenuItem; pMenuWnd: TObject;
  var CanClose: boolean);
begin
  sb_config.OnClick(nil);
  CanClose := True;
end;

procedure TMainForm.UpdateSize(Value : integer);
begin
  LoadIcons;
  Width := UpdateButtons(Value);
end;

procedure TMainForm.UpdateToolTips;
var
  n : integer;
  btn : TSharpEButton;
begin
  for n := 0 to High(tooltips) do
    ToolTipApi.DeleteToolTip(FHintWnd,self,tooltips[n]);
  setlength(tooltips,0);

  for n := 0 to High(FButtonList) do
  begin
    btn := FButtonList[n].btn;
    if btn.Visible then
    begin
      ToolTipApi.AddToolTip(FHintWnd,self,n,
                            Rect(btn.left,btn.top,btn.Left + btn.Width,btn.Top + btn.Height),
                            FButtonList[n].Caption);
      setlength(tooltips,length(tooltips)+1);
      tooltips[High(tooltips)] := n;
    end;
  end;

  if sb_btnlist.Visible then
  begin
    ToolTipApi.AddToolTip(FHintWnd,self,High(FButtonList)+1,
                          Rect(sb_btnlist.left,sb_btnlist.top,sb_btnlist.Left + sb_btnlist.Width,sb_btnlist.Top + sb_btnlist.Height),
                          'View all items');
    setlength(tooltips,length(tooltips)+1);
    tooltips[High(tooltips)] := High(FButtonList)+1;
  end;

  if sb_config.Visible then
  begin
    ToolTipApi.AddToolTip(FHintWnd,self,High(FButtonList)+2,
                          Rect(sb_config.left,sb_config.top,sb_config.Left + sb_config.Width,sb_config.Top + sb_config.Height),
                          'Add items');
    setlength(tooltips,length(tooltips)+2);
    tooltips[High(tooltips)] := High(FButtonList)+1;
  end;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean = True);
var
  newWidth : integer;
  minWidth : integer;
begin
  self.Caption := 'ButtonBar (' + inttostr(length(FButtonList)) + ')';

  sb_config.Visible := (length(FButtonList) = 0);
  if sb_config.Visible then
  begin
    sb_config.SkinManager := mInterface.SkinInterface.SkinManager;
    sb_config.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod +
                       sb_config.GetIconWidth;// + sb_config.GetTextWidth;
    newWidth := FButtonSpacing + sb_config.Left + sb_config.Width + FButtonSpacing;
    minWidth := newWidth;
  end
  else begin
    minWidth := 2 * FButtonSpacing + FButtonList[0].btn.Width;
    newWidth := FButtonSpacing + FButtonList[High(FButtonList)].btn.Left + FButtonList[High(FButtonList)].btn.Width + FButtonSpacing;
  end;

  mInterface.MinSize := minWidth;
  mInterface.MaxSize := newWidth;
  requestedWidth := newWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize(Width);
end;

procedure TMainForm.UpdateComponentSkins;
var
  n : integer;
begin
  sb_config.SkinManager := mInterface.SkinInterface.SkinManager;
  sb_btnlist.SkinManager := mInterface.SkinInterface.SkinManager;
  for n := 0 to High(FButtonList) do
    FButtonList[n].btn.SkinManager := mInterface.SkinInterface.SkinManager;
end;


procedure TMainForm.btnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MoveButton := TSharpEButton(Sender);
  hasmoved := False;
end;

procedure TMainForm.btnMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  cButton : TSharpEButton;
  cButtonIndex : integer;
  p : TPoint;
  n : integer;
  cPos : integer;
  temp : TButtonRecord;
  MoveButtonIndex : integer;
begin
  if MoveButton = nil then
    exit;

  cButton := nil;
  cButtonIndex := -1;
  p := ScreenToClient(Mouse.CursorPos);
  for n := 0 to High(FButtonList) do
    if (p.x > FButtonList[n].btn.Left)
      and (p.x < FButtonList[n].btn.Left + FButtonList[n].btn.Width) then
    begin
      cButton := FButtonList[n].btn;
      cButtonIndex := n;
      break;
    end;

  if cButton = nil then
    exit;

  if cButton <> MoveButton then
  begin
    MoveButtonIndex := -1;
    for n := 0 to High(FButtonList) do
      if MoveButton = FButtonList[n].btn then
      begin
        MoveButtonIndex := n;
        break;
      end;
    if MoveButtonIndex <> -1 then
    begin
      hasmoved := True;               
      cPos := FButtonList[cButtonIndex].btn.left;
      temp := FButtonList[cButtonIndex];
      temp.btn.Left := FButtonList[MoveButtonIndex].btn.Left;
      FButtonList[MoveButtonIndex].btn.Left := CPos;
      FButtonList[cButtonIndex] := FButtonList[MoveButtonIndex];
      FButtonList[MoveButtonIndex] := temp;
      UpdateToolTips;
    end;
  end;
end;

procedure TMainForm.btnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ActionStr : String;
begin
  MoveButton := nil;
  if (Button = mbRight) then
    ButtonPopup.Tag := GetButtonIndex(TSharpEButton(Sender));
  if (Button = mbLeft) and (not hasmoved) then
  begin
    ActionStr := TSharpEButton(Sender).Hint;
    if UPPERCASE(ActionStr) = '!SHOWMENU' then SetForegroundWindow(FindWindow(nil,'SharpMenuWMForm'));
    SharpApi.SharpExecute(ActionStr);
  end;
  if hasmoved then
    SaveSettings;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  setlength(tooltips,0);
  sb_btnlist.Visible := False;
  MoveButton := nil;
  DoubleBuffered := True;
  FHintWnd := ToolTipApi.RegisterToolTip(self);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  n : integer;
begin
  for n := 0 to High(tooltips) do
    ToolTipApi.DeleteToolTip(FHintWnd,self,tooltips[n]);     

  if FHintWnd <> 0 then
     DestroyWindow(FHintWnd);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  if mInterface <> nil then
     mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

function TMainForm.ImportQuickLaunchItems : boolean;
var
  Dir : String;
  SList : TStringList;
  n,i : integer;
  found : boolean;
  addcount : integer;
begin
  {$WARNINGS OFF}
  if IsWindows7 or IsWindowsVista then
  begin
    Dir := uKnownFolders.GetKnownFolderPath(FOLDERID_Quicklaunch);
    Dir := IncludeTrailingBackSlash(Dir);
  end
  else begin
    Dir := JclSysInfo.GetAppdataFolder;
    Dir := IncludeTrailingBackSlash(Dir);
    Dir := Dir + 'Microsoft\Internet Explorer\Quick Launch\';
  end;
  {$WARNINGS ON}
  SList := TStringList.Create;
  SList.Clear;
  GetExecuteableFilesFromDir(SList,Dir);
  addcount := 0;
  for n := 0 to SList.Count - 1 do
  begin
    found := False;
    for i := 0 to High(FButtonList) do // Check if it already is added
      if CompareText(FButtonList[i].target,SList[n]) = 0 then
      begin
        found := True;
        break;
      end;
    if not found then // Add It
    begin
      AddButton(SList[n],'shell:icon');
      addcount := addcount + 1;
    end;
  end;
  SList.Free;
  result := (addcount > 0);
end;

function TMainForm.GetButtonIndex(pButton : TSharpEButton) : integer;
var
  n : integer;
begin
  for n := 0 to High(FButtonList) do
    if FButtonList[n].btn = pButton then
    begin
      result := n;
      exit;
    end;

  result := -1;
end;

end.
