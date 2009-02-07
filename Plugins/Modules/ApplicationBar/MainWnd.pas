{
Source Name: MainWnd.pas
Description: Application Bar Module - Main Window
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
  Dialogs, Menus, Math, GR32, ToolTipApi, ShellApi, CommCtrl,
  JclSimpleXML,
  SharpCenterApi,
  SharpApi,
  SharpEBaseControls,
  SharpEButton,
  SharpTypes,
  SharpETaskItem,
  uISharpBarModule,
  JclSysUtils,
  JclSysInfo,
  uSharpEMenu,
  uSharpEMenuWnd,
  uSharpEMenuSettings,
  uSharpEMenuItem,  
  SharpIconUtils, ImgList, PngImageList, ExtCtrls;


type
  TButtonRecord = record
                    btn: TSharpETaskItem;
                    target: String;
                    exename: String;
                    icon: String;
                    caption: String;
                    wnd : hwnd;
                  end;

  TMainForm = class(TForm)
    sb_config: TSharpEButton;
    ButtonPopup: TPopupMenu;
    Delete1: TMenuItem;
    PngImageList1: TPngImageList;
    CheckTimer: TTimer;
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
    procedure CheckTimerTimer(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    sState       : TSharpETaskItemStates;
    sAutoWidth   : integer;
    sAutoHeight  : integer;
    sShowLabel   : boolean;
    FButtonSpacing : integer;
    sShowIcon    : boolean;
    FButtonList  : array of TButtonRecord;
    FHintWnd     : hwnd; 
    movebutton   : TSharpETaskItem;
    hasmoved     : boolean;
    FLastActiveTask : hwnd;
    FLastMenu    : TSharpEMenuWnd;
    FLastButton  : TButtonRecord;
    procedure ClearButtons;
    procedure UpdateButtonStatus(wnd : hwnd; create : boolean);
    function GetButtonItem(pButton : TSharpETaskItem) : TButtonRecord;
    procedure AddButton(pTarget,pIcon,pCaption : String; Index : integer = -1);
    procedure UpdateButtons;
    procedure WMNotify(var msg : TWMNotify); message WM_NOTIFY;
    procedure WMDropFiles(var msg: TMessage); message WM_DROPFILES;
    procedure WMShellHook(var msg : TMessage); message WM_SHARPSHELLMESSAGE;
    procedure mnOnClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure mnMouseUp(pItem : TSharpEMenuItem; Button: TMouseButton; Shift: TShiftState);
  public
    mInterface : ISharpBarModule;
    procedure BuildAndShowMenu(btn : TButtonRecord);
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : Boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure RefreshIcons;
    procedure SaveSettings;
    procedure CheckList;
    procedure UpdateGlobalFilterList(Broadcast : Boolean);
  end;

function SwitchToThisWindow(Wnd : hwnd; fAltTab : boolean) : boolean; stdcall; external 'user32.dll';

implementation

uses
  IXmlBaseUnit;

{$R *.dfm}

procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := params.ExStyle or WS_EX_ACCEPTFILES;
end;

procedure TMainForm.Delete1Click(Sender: TObject);
var
  dbtn : TSharpETaskItem;
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
  
  ToolTipApi.DeleteToolTip(FHintWnd,self,startindex);
  dbtnwidth := FButtonList[startindex].btn.Width + FButtonSpacing;
  FButtonList[startindex].btn.Free;
  for n := startindex to High(FButtonList)-1 do
  begin
    ToolTipApi.DeleteToolTip(FHintWnd,self,n+1);
    with FButtonList[n] do
    begin
      btn := FButtonList[n+1].btn;
      btn.Left := FButtonList[n].btn.Left - dbtnwidth;
      target := FButtonList[n+1].target;
      caption := FButtonList[n+1].caption;
      exename := FButtonList[n+1].exename;
      icon := FButtonList[n+1].icon;
      ToolTipApi.AddToolTip(FHintWnd,self,n,
                            Rect(btn.left,btn.top,btn.Left + btn.Width,btn.Top + btn.Height),
                            Caption);        
    end;
  end;
  setlength(FButtonList,length(FButtonList)-1);
  SaveSettings;
  RealignComponents(True);
  UpdateGlobalFilterList(True);
  CheckList;
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
 
procedure TMainForm.WMShellHook(var msg: TMessage);
begin
 case msg.WParam of
   HSHELL_WINDOWCREATED : UpdateButtonStatus(msg.LParam,true);
//   HSHELL_REDRAW : UpdateTask(LParam);
//   HSHELL_REDRAW + 32768 : FlashTask(LParam);
   HSHELL_WINDOWDESTROYED : UpdateButtonStatus(msg.LParam,false);
   HSHELL_WINDOWACTIVATED : if msg.LParam <> 0 then FLastActiveTask := msg.LParam;
   HSHELL_WINDOWACTIVATED + 32768 : if msg.LParam <> 0 then FLastActiveTask := msg.LParam;
//   HSHELL_GETMINRECT      : GetMinRect;
  end;
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
     AddButton(pcFileName,'shell:icon',ExtractFileName(pcFileName),index);
     StrDispose(pcFileName);
  end;
  DragFinish(Msg.wParam);
  sb_config.Left := -200;  
  UpdateButtons;
  SaveSettings;
  RealignComponents(True);
  UpdateGlobalFilterList(True);
  CheckList;
end;

procedure TMainForm.CheckList;
type
  TData = record
    wnd : hwnd;
    filename : String;
  end;

  PParam = ^TParam;
  TParam = record
    wndlist: array of TData;
  end;
var
  EnumParam : TParam;
  n,i: integer;
  processname, filename : string;
  count : integer;

  function EnumWindowsProc(Wnd: HWND; LParam: LPARAM): BOOL; stdcall;
  begin
    if ((GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) or
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_APPWINDOW <> 0)) and
       ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
       (GetWindowLong(Wnd, GWL_STYLE) and WS_CHILD = 0) and
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0))
       and ((GetWindowLong(Wnd, GWL_STYLE) and DS_3DLOOK = 0)
        and (GetWindowLong(Wnd, GWL_STYLE) and DS_FIXEDSYS = 0)
        or (GetWindowLong(Wnd, GWL_STYLE) and WS_VISIBLE <> 0)) then
      with PParam(LParam)^ do
      begin
        setlength(wndlist,length(wndlist)+1);
        wndlist[high(wndlist)].wnd := wnd;
      end;
    result := True;
  end;
begin
  setlength(EnumParam.wndlist,0);
  EnumWindows(@EnumWindowsProc, Integer(@EnumParam));
  for n := 0 to High(EnumParam.wndlist) do
  begin
    processname := GetProcessNameFromWnd(EnumParam.wndlist[n].wnd);
    filename := LowerCase(ExtractFileName(processname));
    EnumParam.wndlist[n].filename := filename;
  end;
  for n := 0 to High(FButtonList) do
  begin
    count := 0;
    for i := 0 to High(EnumParam.wndlist) do
      if CompareText(FButtonList[n].exename,EnumParam.wndlist[i].filename) = 0 then
      begin
        count := count + 1;
        FButtonList[n].wnd := EnumParam.wndlist[i].wnd;
      end;
    FButtonList[n].btn.Down := (count > 0);
    FButtonList[n].btn.Tag := count;
    if count = 0 then
      FButtonList[n].wnd := 0;
  end;
  setlength(EnumParam.wndlist,0);
end;

procedure TMainForm.ClearButtons;
var
  n : integer;
begin
  MoveButton := nil;
  for n := 0 to High(FButtonList) do
  begin
    FButtonList[n].btn.Free;
    ToolTipApi.DeleteToolTip(FHintWnd,self,n);
  end;
  setlength(FButtonList,0);
end;

procedure TMainForm.AddButton(pTarget,pIcon,pCaption : String; Index : integer = -1);
var
  n : integer;
begin
  setlength(FButtonList,length(FButtonList)+1);
  if (Index < Low(FButtonList)) or (Index > High(FButtonList)) then
    Index := High(FButtonList)
    else for n := High(FButtonList) downto Index + 1 do
      begin
        ToolTipApi.DeleteToolTip(FHintWnd,self,n-1);
        with FButtonList[n] do
        begin
          btn := FButtonList[n-1].btn;
          target := FButtonList[n-1].target;
          caption := FButtonList[n-1].caption;
          exename := FButtonList[n-1].exename;
          icon := FButtonList[n-1].icon;
          ToolTipApi.AddToolTip(FHintWnd,self,n,
                                Rect(btn.left,btn.top,btn.Left + btn.Width,btn.Top + btn.Height),
                                Caption);
        end;
      end;
  with FButtonList[Index] do
  begin
    btn := TSharpETaskItem.Create(self);
    btn.State := sState; 
    btn.PopUpMenu := ButtonPopup;
    btn.Visible := False;
    btn.Parent := self;
    btn.Height := Height;
    btn.SkinManager := mInterface.SkinInterface.SkinManager;
    btn.AutoPosition := True;
    btn.AutoSize := False;
    btn.Height := sAutoHeight;
    btn.Hint := pTarget;
    btn.Width := sAutoWidth;
    btn.left := FButtonSpacing + High(FButtonList)*FButtonSpacing + High(FButtonList)*sAutoWidth;
    btn.OnMouseUp := btnMouseUp;
    btn.OnMouseDown := btnMouseDown;
    btn.OnMouseMove := btnMouseMove;
    ToolTipApi.AddToolTip(FHintWnd,self,High(FButtonList),
                          Rect(btn.left,btn.top,btn.Left + btn.Width,btn.Top + btn.Height),
                          pCaption);

    caption := pCaption;
    target := pTarget;
    icon := pIcon;
    exename := ExtractFileName(target);

    if sShowLabel then
      btn.Caption := pCaption
    else
      btn.Caption := '';

    if sShowIcon then
    begin
      if not IconStringToIcon(pIcon,pTarget,btn.Glyph32) then
         btn.Glyph32.SetSize(0,0)
    end else btn.Glyph32.SetSize(0,0);
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
        if not IconStringToIcon(Icon,Target,btn.Glyph32) then
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
  XML.Root.Name := 'AppBarModuleSettings';
  with XML.Root.Items do
  begin
    Add('State',Integer(sState));
    with Add('Apps').Items do
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
  XML.SaveToFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
  XML.Free;
end;

procedure TMainForm.sb_configClick(Sender: TObject);
var
  cfile : String;
begin
  cfile := SharpApi.GetCenterDirectory + '_Modules\ApplicationBar.con';

  if FileExists(cfile) then
    SharpCenterApi.CenterCommand(sccLoadSetting,
      PChar(cfile),
      PChar(inttostr(mInterface.BarInterface.BarID) + ':' + inttostr(mInterface.ID)));
end;

procedure TMainForm.UpdateButtons;
var
  n : integer;
begin
  for n := 0 to High(FButtonList) do
      with FButtonList[n] do
      begin
        btn.Height := sAutoHeight;
        btn.Width := sAutoWidth;
        btn.Left := FButtonSpacing + n*FButtonSpacing + n*sAutoWidth;
        if btn.Left + btn.Width < Width then
           btn.Visible := True
           else btn.Visible := False;
        ToolTipApi.UpdateToolTipRect(FHintWnd,self,n,
                                     Rect(btn.left,btn.top,btn.Left + btn.Width,btn.Top + btn.Height));
      end;
end;

procedure TMainForm.UpdateButtonStatus(wnd: hwnd; create: boolean);
var
  processname,filename : String;
  n : integer;
begin
  processname := GetProcessNameFromWnd(wnd);
  filename := LowerCase(ExtractFileName(processname));
  for n := 0 to High(FButtonList) do
    if CompareText(FButtonList[n].exename, filename) = 0 then
    begin
      if create then
        FButtonList[n].btn.Tag := FButtonList[n].btn.Tag + 1
      else FButtonList[n].btn.Tag := FButtonList[n].btn.Tag - 1;
      if FButtonList[n].btn.Tag < 0 then
        FButtonList[n].btn.Tag := 0;
      FButtonList[n].btn.down := (FButtonList[n].btn.Tag > 0);
      if FButtonList[n].btn.Tag > 0 then
        FButtonList[n].wnd := wnd
      else FButtonList[n].wnd := 0;
    end;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
  n : integer;
begin
  ClearButtons;

  sShowLabel   := False;
  sShowIcon    := True;
  FButtonSpacing := 2;
  sState       := tisCompact;

  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      sState := TSharpETaskItemStates(IntValue('State',2));
      if ItemNamed['Apps'] <> nil then
      with ItemNamed['Apps'].Items do
           for n := 0 to Count - 1 do
               AddButton(Item[n].Items.Value('Target','C:\'),
                         Item[n].Items.Value('Icon','shell:icon'),
                         Item[n].Items.Value('Caption','C:\'));
    end;
  XML.Free;

  CheckList;
end;

procedure TMainForm.mnMouseUp(pItem: TSharpEMenuItem; Button: TMouseButton;
  Shift: TShiftState);
var
  wnd : hwnd;
  menu : TSharpEMenu;
  h : integer;
begin
  if pItem = nil then exit;

  if (Button = mbMiddle) then
  begin
    wnd := pItem.PropList.GetInt('wnd');
    h := FLastMenu.Height;
    menu := TSharpEMenu(pItem.OwnerMenu);
    menu.Items.Remove(pItem);
    if menu.Items.Count > 0 then
    begin
      FLastMenu.FreeMenu := False;
      FLastMenu.Visible := False;
      menu.RenderBackground(FLastMenu.Left,FLastMenu.Top);
      menu.RenderNormalMenu;
      menu.RenderTo(FLastMenu.Picture);
      FLastMenu.PreMul(FLastMenu.Picture);
      FLastMenu.DrawWindow;
      if FLastMenu.Top > FLastMenu.Monitor.Top + FLastMenu.Monitor.Height div 2 then
        FLastMenu.Top := FLastMenu.Top + (h - FLastMenu.Height);
      FLastMenu.Visible := True;
      FLastMenu.FreeMenu := True;
    end else FreeAndNil(FLastMenu);

    PostMessage(wnd, WM_CLOSE, 0, 0);
    PostThreadMessage(GetWindowThreadProcessID(wnd, nil), WM_QUIT, 0, 0);

    if FLastMenu = nil then
      if FLastButton.btn <> nil then
      begin
        FLastButton.btn.Down := False;
        FLastButton.btn.Tag := 0;
      end;
  end;
end;

procedure TMainForm.mnOnClick(pItem: TSharpEMenuItem; var CanClose: boolean);
begin
  CanClose := True;

  if pItem = nil then
    exit;

  SwitchToThisWindow(pItem.PropList.GetInt('wnd'), True);
end;

procedure TMainForm.UpdateSize;
begin
  UpdateButtons;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean = True);
var
  newWidth : integer;
  n : integer;
begin
  self.Caption := 'ApplicationBar (' + inttostr(length(FButtonList)) + ')';

  case sState of
    tisCompact: sAutoHeight := mInterface.SkinInterface.SkinManager.Skin.TaskItemSkin.Compact.SkinDim.HeightAsInt;
    tisMini   : sAutoHeight := mInterface.SkinInterface.SkinManager.Skin.TaskItemSkin.Mini.SkinDim.HeightAsInt;
    else sAutoHeight := mInterface.SkinInterface.SkinManager.Skin.TaskItemSkin.Full.SkinDim.HeightAsInt;
  end;
  case sState of
    tisCompact: sAutoWidth := mInterface.SkinInterface.SkinManager.Skin.TaskItemSkin.Compact.SkinDim.WidthAsInt;
    tisMini   : sAutoWidth := mInterface.SkinInterface.SkinManager.Skin.TaskItemSkin.Mini.SkinDim.WidthAsInt;
    else sAutoWidth := mInterface.SkinInterface.SkinManager.Skin.TaskItemSkin.Full.SkinDim.WidthAsInt;
  end;

  sb_config.Visible := (length(FButtonList) = 0);
  if sb_config.Visible then
  begin
    sb_config.Left := 2;
    newWidth := sb_config.Left + sb_config.Width + 2
  end
  else newWidth := FButtonSpacing + High(FButtonList)*FButtonSpacing + length(FButtonList)*sAutoWidth + FButtonSpacing;
  
  for n := 0 to High(FButtonList) do
    if FButtonList[n].btn.Height <> sAutoHeight then
    begin
      FButtonList[n].btn.Height := sAutoHeight;
      FButtonList[n].btn.UpdateSkin;
    end;

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateButtons;
end;

procedure TMainForm.UpdateComponentSkins;
var
  n : integer;
begin
  sb_config.SkinManager := mInterface.SkinInterface.SkinManager;
  for n := 0 to High(FButtonList) do
    FButtonList[n].btn.SkinManager := mInterface.SkinInterface.SkinManager;
end;


procedure TMainForm.UpdateGlobalFilterList(Broadcast : Boolean);
var
  XML : TInterfacedXmlBase;
  XMLItem : TJclSimpleXMLElem;
  n : integer;
begin
  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\ApplicationBar\Apps.xml';

  XMLItem := nil;
  if XML.Load then
    for n := 0 to XML.XmlRoot.Items.Count - 1 do
      if XML.XmlRoot.Items.Item[n].Properties.IntValue('ID',-1) = mInterface.ID then
      begin
        XMLItem := XML.XmlRoot.Items.Item[n];
        break;
      end;
  if XMLItem = nil then
  begin
    XMLItem := XML.XmlRoot.Items.Add('Module');
    XMLItem.Properties.Add('ID',mInterface.ID);
  end;

  XML.XmlRoot.Name := 'ApplicationBarItems';
  XMLItem.Items.Clear;
  for n := 0 to High(FButtonList) do
    with XMLItem.Items do
    begin
      Add('Application',FButtonList[n].target);
    end;
  XML.Save;

  XML.Free;

  if BroadCast then
    SharpApi.BroadCastGlobalUpdateMessage(suTaskAppBarFilters);
end;

procedure TMainForm.btnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MoveButton := TSharpETaskItem(Sender);
  hasmoved := False;
end;

procedure TMainForm.btnMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  cButton : TSharpETaskItem;
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
      ToolTipApi.DeleteToolTip(FHintWnd,self,MoveButtonIndex);
      ToolTipApi.DeleteToolTip(FHintWnd,self,cButtonIndex);
      ToolTipApi.AddToolTip(FHintWnd,self,MoveButtonIndex,
                            Rect(cButton.left,cButton.top,cButton.Left + cButton.Width,cButton.Top + cButton.Height),
                            FButtonList[MoveButtonIndex].caption);
      ToolTipApi.AddToolTip(FHintWnd,self,cButtonIndex,
                            Rect(MoveButton.left,MoveButton.top,MoveButton.Left + MoveButton.Width,MoveButton.Top + MoveButton.Height),
                            FButtonList[cButtonIndex].caption);
    end;
  end;
end;

procedure TMainForm.btnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  BtnItem : TButtonRecord;
begin
  MoveButton := nil;
  BtnItem := GetButtonItem(TSharpETaskItem(Sender));
  if BtnItem.Btn <> nil then
  begin
    if (Button = mbLeft) and (not hasmoved) then
    begin
      if BtnItem.Btn.Down then
      begin
        if BtnItem.Btn.Tag > 1 then
          BuildAndShowMenu(BtnItem)
        else begin
          if IsIconic(BtnItem.wnd) or (FLastActiveTask <> BtnItem.wnd) then
            SwitchToThisWindow(BtnItem.wnd,True)
          else PostMessage(BtnItem.wnd,WM_SYSCOMMAND,SC_MINIMIZE,0);
        end;
      end else SharpApi.SharpExecute(BtnItem.target);
    end else if (Button = mbMiddle) and (not hasmoved) then
      SharpApi.SharpExecute(BtnItem.target);
    if hasmoved then
      SaveSettings;
  end;
end;

procedure TMainForm.BuildAndShowMenu(btn: TButtonRecord);
type
  PParam = ^TParam;
  TParam = record
    wndlist: array of hwnd;
  end;

var
  processname, filename : String;
  p : TPoint;
  mn : TSharpEMenu;
  ms : TSharpEMenuSettings;
  wnd : TSharpEMenuWnd;
  EnumParam : TParam;
  n: integer;
  item : TSharpEMenuItem;
  R : TRect;

  function GetCaption(handle : hwnd) : String;
  var
    buf: array[0..2048] of wchar;
  begin
    GetWindowTextW(handle,@buf,sizeof(buf));
    result := buf;
  end;

  function EnumWindowsProc(Wnd: HWND; LParam: LPARAM): BOOL; stdcall;
  begin
    if ((GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) or
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_APPWINDOW <> 0)) and
       ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
       (GetWindowLong(Wnd, GWL_STYLE) and WS_CHILD = 0) and
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0))
       and ((GetWindowLong(Wnd, GWL_STYLE) and DS_3DLOOK = 0)
        and (GetWindowLong(Wnd, GWL_STYLE) and DS_FIXEDSYS = 0)
        or (GetWindowLong(Wnd, GWL_STYLE) and WS_VISIBLE <> 0)) then
      with PParam(LParam)^ do
      begin
        setlength(wndlist,length(wndlist)+1);
        wndlist[high(wndlist)] := wnd;
      end;
    result := True;
  end;

begin
  setlength(EnumParam.wndlist,0);
  EnumWindows(@EnumWindowsProc, Integer(@EnumParam));

  ms := TSharpEMenuSettings.Create;
  ms.LoadFromXML;

  mn := TSharpEMenu.Create(mInterface.SkinInterface.SkinManager,ms);
  ms.Free;

 // mn.AddLinkItem('Close All','','customicon:edititem',FMenuIcon1,false);
//  mn.AddSeparatorItem(False);

  for n := 0 to High(EnumParam.wndlist) do
  begin
    processname := GetProcessNameFromWnd(EnumParam.wndlist[n]);
    filename := LowerCase(ExtractFileName(processname));
    if CompareText(filename,btn.exename) = 0 then
    begin
      item := TSharpEMenuItem(mn.AddCustomItem(GetCaption(EnumParam.wndlist[n]),btn.target,btn.btn.Glyph32));
      item.OnClick := mnOnClick;
      item.OnMouseUp := mnMouseUp;
      item.PropList.Add('wnd',EnumParam.wndlist[n]);
    end;
  //    mn.AddLinkItem(GetCaption(EnumParam.wndlist[n]),btn.target,'shell:icon',False);
  end;

  mn.RenderBackground(0,0);

  wnd := TSharpEMenuWnd.Create(self,mn);
  wnd.FreeMenu := True; // menu will free itself when closed
  FLastMenu := wnd;
  FLastButton := Btn;

  GetWindowRect(mInterface.BarInterface.BarWnd,R);
  p := ClientToScreen(Point(Btn.Btn.Left + Btn.Btn.Width div 2, self.Height + self.Top));
  p.y := R.Top;
  p.x := p.x + mInterface.SkinInterface.SkinManager.Skin.MenuSkin.SkinDim.XAsInt - mn.Background.Width div 2;
  if p.x < Monitor.Left then
    p.x := Monitor.Left;
  if p.x + mn.Background.Width  > Monitor.Left + Monitor.Width then
    p.x := Monitor.Left + Monitor.Width - mn.Background.Width;
  wnd.Left := p.x;
  if p.Y < Monitor.Top + Monitor.Height div 2 then
    wnd.Top := R.Bottom + mInterface.SkinInterface.SkinManager.Skin.MenuSkin.SkinDim.YAsInt
  else begin
    wnd.Top := R.Top - wnd.Picture.Height - mInterface.SkinInterface.SkinManager.Skin.MenuSkin.SkinDim.YAsInt;
  end;
  wnd.Show;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  MoveButton := nil;
  DoubleBuffered := True;
  FHintWnd := ToolTipApi.RegisterToolTip(self);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if FHintWnd <> 0 then
     DestroyWindow(FHintWnd);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  if mInterface <> nil then
     mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

function TMainForm.GetButtonItem(pButton: TSharpETaskItem): TButtonRecord;
var
  n : integer;
begin
  for n := 0 to High(FButtonList) do
    if FButtonList[n].btn = pButton then
    begin
      result := FButtonList[n];
      exit;
    end;
    
  result.btn := nil;
end;

procedure TMainForm.CheckTimerTimer(Sender: TObject);
begin
  CheckList;
end;

end.
