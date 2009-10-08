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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Contnrs,
  Dialogs, Menus, Math, GR32, ToolTipApi, ShellApi, CommCtrl, dwmapi,
  SharpFileUtils,
  JclSimpleXML,
  SharpCenterApi,
  SharpApi,
  SharpEBaseControls,
  SharpEButton,
  SharpTypes,
  SharpETaskItem,
  uISharpBarModule,
  ISharpESkinComponents,
  JclSysUtils,
  JclSysInfo,
  uSharpEMenu,
  uSharpEMenuWnd,
  uSharpEMenuSettings,
  uSharpEMenuItem,
  uTaskManager,
  uTaskItem,
  uTaskPreviewWnd,
  VWMFunctions,
  MonitorList,
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
    PreviewCheckTimer: TTimer;
    mnPopupSep1: TMenuItem;
    mnPopupCloseAll: TMenuItem;
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
    procedure PreviewCheckTimerTimer(Sender: TObject);
    procedure mnPopupCloseAllClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    sState       : TSharpETaskItemStates;
    sAutoWidth   : integer;
    sAutoHeight  : integer;
    sMonitorOnly : boolean;
    sVWMOnly     : boolean;
    sTaskPreview : boolean;
    sTPLockKey   : integer;
    FButtonSpacing : integer;
    sCountOverlay : boolean;
    FButtonList  : array of TButtonRecord;
    FHintWnd     : hwnd; 
    movebutton   : TSharpETaskItem;
    hasmoved     : boolean;
    FLastMenu    : TSharpEMenuWnd;
    FLastButton  : TButtonRecord;
    FTM          : TTaskManager;
    FPreviewWnds : TObjectList;
    FPreviewButton : TSharpETaskItem;
    FRefreshOnNextMouseMove : boolean;
    function CheckWindow(wnd : hwnd) : boolean;
    procedure OnNewTask(pItem : TTaskItem; Index : integer);
    procedure OnRemoveTask(pItem : TTaskItem; Index : integer);
    procedure OnUpdateTask(pItem : TTaskItem; Index : integer);
    procedure OnFlaskTask(pItem : TTaskItem; Index : integer);
    procedure OnActivateTask(pItem : TTaskItem; Index : integer);
    procedure OnPreviewClick(Sender : TObject);
    procedure ClearButtons;
    procedure UpdateButtonIcon(Btn : TButtonRecord);
    function GetButtonIndex(pButton : TSharpETaskItem) : integer;
    function GetButtonItem(pButton : TSharpETaskItem) : TButtonRecord;
    procedure AddButton(pTarget,pIcon,pCaption : String; Index : integer = -1);
    procedure UpdateButtons;
    procedure WMNotify(var msg : TWMNotify); message WM_NOTIFY;
    procedure WMDropFiles(var msg: TMessage); message WM_DROPFILES;
    procedure WMShellHook(var msg : TMessage); message WM_SHARPSHELLMESSAGE;
    procedure WMCopyData(var msg : TMessage); message WM_COPYDATA;
    procedure WMAddAppBarTask(var msg : TMessage); message WM_ADDAPPBARTASK;
    procedure WMCommand(var msg: TMessage); message WM_COMMAND;    
    procedure mnOnClick(pItem : TSharpEMenuItem; pMenuWnd : TObject; var CanClose : boolean);
    procedure mnMouseUp(pItem : TSharpEMenuItem; Button: TMouseButton; Shift: TShiftState);
    procedure DisplaySystemMenu(pBtn : TButtonRecord);    
  public
    mInterface : ISharpBarModule;
    CurrentVWM   : integer;    
    procedure BuildAndShowMenu(btn : TButtonRecord);
    procedure LoadIcons;
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : Boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure RefreshIcons;
    procedure SaveSettings;
    procedure CheckList;
    procedure UpdateGlobalFilterList(Broadcast : Boolean);
    property TaskManager : TTaskManager read FTM;
  end;

function SwitchToThisWindow(Wnd : hwnd; fAltTab : boolean) : boolean; stdcall; external 'user32.dll';

implementation

uses
  IXmlBaseUnit, SharpESkinPart, GR32_PNG;


var
  SysMenuButton : TButtonRecord;  

{$R *.dfm}
{$R appbarglyphs.res}

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

  TempBmp.Free;

  sb_config.Glyph32.DrawMode := dmBlend;
  sb_config.Glyph32.CombineMode := cmMerge;
  sb_config.Glyph32.DrawMode := dmBlend;
  sb_config.Glyph32.CombineMode := cmMerge;
end;

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
  FPreviewWnds.Clear;
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
    HSHELL_WINDOWCREATED : FTM.HandleShellMessage(msg.WParam,msg.LParam);
    HSHELL_REDRAW : FTM.HandleShellMessage(msg.WParam,msg.LParam);
    HSHELL_REDRAW + 32768 : FTM.HandleShellMessage(msg.WParam,msg.LParam);
    HSHELL_WINDOWDESTROYED : FTM.HandleShellMessage(msg.WParam,msg.LParam);
    HSHELL_WINDOWACTIVATED : FTM.HandleShellMessage(msg.WParam,msg.LParam);
    HSHELL_WINDOWACTIVATED + 32768 : FTM.HandleShellMessage(msg.WParam,msg.LParam);
    HSHELL_GETMINRECT      : FTM.HandleShellMessage(msg.WParam,msg.LParam);
  end;
end;

procedure TMainForm.WMAddAppBarTask(var msg: TMessage);
var
  FilePath,FileName : String;
begin
  if IsWindow(msg.wparam) then
  begin
    FilePath := GetProcessNameFromWnd(msg.wparam);
    FileName := LowerCase(ExtractFileName(FilePath));
    AddButton(FilePath,'shell:icon',FileName,Length(FButtonList));

    sb_config.Visible := False;
    UpdateButtons;
    SaveSettings;
    RealignComponents(True);
    UpdateGlobalFilterList(True);
    CheckList;
    exit;         
  end;
end;

procedure TMainForm.WMCommand(var msg: TMessage);
var
  VWMCount : integer;
  VWMIndex : integer;
  TaskItem : TTaskItem;
  n : integer;
  startindex : integer;
  dbtnwidth : integer;  
begin
  if SysMenuButton.btn = nil then
    exit;

  PostMessage(SysMenuButton.wnd, WM_SYSCOMMAND, msg.wparam, msg.lparam);

  VWMCount := GetVWMCount;
  if msg.WParam = $EFFF then // Remove From Appbar message
  begin
    startindex := -1;
    for n := 0 to High(FButtonList) do
    if FButtonList[n].btn = SysMenuButton.btn then    
    begin
      startindex := n;
      break;
    end;

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
  end else
  if VWMCount > 0 then
    if (msg.WParam >= 256) and (msg.WParam <= 256 + VWMCount) then
    begin
      TaskItem := FTM.GetItemByHandle(SysMenuButton.wnd);
      if TaskItem <> nil then
        TaskItem.LastVWM := msg.WParam - 256 + 1;

      if not IsIconic(SysMenuButton.wnd) then
      begin
        VWMIndex := GetCurrentVWM;
        VWMMoveWindotToVWM(msg.WParam - 256 + 1,VWMIndex,VWMCount,SysMenuButton.wnd);
      end;

      PostMessage(GetShellTaskMgrWindow,WM_TASKVWMCHANGE,Integer(SysMenuButton.wnd),msg.WParam - 256 + 1);      
      taskitem.Used := True;
    end;

  inherited;
end;

procedure TMainForm.WMCopyData(var msg: TMessage);
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
    FTM.LoadFromStream(ms,cds.dwData);
    ms.Free;
    msg.result := 1;
    CheckList;
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
  sb_config.Visible := False;
  UpdateButtons;
  SaveSettings;
  RealignComponents(True);
  UpdateGlobalFilterList(True);
  CheckList;
end;

procedure TMainForm.CheckList;
var
  n,i: integer;
  count : integer;
  oldcount : integer;
  Item : TTaskItem;
begin
  for n := 0 to High(FButtonList) do
  begin
    count := 0;
    for i := 0 to FTM.ItemCount - 1 do
    begin
      Item := TTaskItem(FTM.GetItemByIndex(i));
      if Item <> nil then
        if CompareText(FButtonList[n].exename,Item.FileName) = 0 then
        begin
          if CheckWindow(Item.Handle) then
          begin
            count := count + 1;
            FButtonList[n].wnd := Item.Handle;
          end else FButtonList[n].btn.Down := False;
        end;
    end;
    FButtonList[n].btn.Special := (count > 0);
    oldcount := FButtonList[n].btn.Tag;
    FButtonList[n].btn.Tag := count;
    if count = 0 then
      FButtonList[n].wnd := 0;
    if oldcount <> count then
      UpdateButtonIcon(FButtonList[n]);
  end;
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

procedure TMainForm.mnPopupCloseAllClick(Sender: TObject);
var
  n : integer;
  wndlist : array of hwnd;
  TaskItem : TTaskItem;
  ButtonIndex : integer;
begin
  ButtonIndex := ButtonPopup.Tag;
  if (ButtonIndex > High(FButtonList)) or (ButtonIndex < 0) then
    exit;

  setlength(wndlist,0);
  for n := 0 to FTM.ItemCount - 1 do
  begin
    TaskItem := TTaskItem(FTM.GetItemByIndex(n));
    if TaskItem <> nil then
      if CompareText(TaskItem.FileName,FButtonList[ButtonIndex].exename) = 0 then
      begin
        setlength(wndlist,length(wndlist)+1);
        wndlist[High(wndlist)] := TaskItem.Handle;
      end;
  end;

  for n := 0 to High(wndlist) do
  begin
    PostMessage(wndlist[n], WM_CLOSE, 0, 0);
    PostThreadMessage(GetWindowThreadProcessID(wndlist[n], nil), WM_QUIT, 0, 0);
  end;

  setlength(wndlist,0);
  FPreviewWnds.Clear;  
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
    if not FileExists(pTarget) then
      pTarget := FindFilePath(pTarget);

    btn := TSharpETaskItem.Create(self);
    btn.UseSpecial := True;
    btn.State := sState; 
    btn.PopUpMenu := nil;
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

    btn.Caption := pCaption;

    if not IconStringToIcon(pIcon,pTarget,btn.Glyph32,32) then
       btn.Glyph32.SetSize(0,0);
    btn.CalculateGlyphColor;
  end;
  
  FRefreshOnNextMouseMove := True;
end;

procedure TMainForm.RefreshIcons;
var
  n : integer;
begin
  for n := 0 to High(FButtonList) do
      with FButtonList[n] do
      begin
        if not IconStringToIcon(Icon,Target,btn.Glyph32,32) then
          btn.Glyph32.SetSize(0,0);
        btn.CalculateGlyphColor;
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
    Add('CountOverlay',sCountOverlay);
    Add('VWMOnly',sVWMOnly);
    Add('MonitorOnly',sMonitorOnly);
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

procedure TMainForm.UpdateButtonIcon(Btn: TButtonRecord);
var
  Bmp : TBitmap32;
  x,y : integer;
  n : integer;
  currentstate : ISharpETaskItemStateSkin;
  SkinText : ISharpESkinText;
  s : string;
  p : TPoint;
begin
  if not sCountOverlay then
    exit;

  if Btn.Btn.Tag <= 1 then
  begin
    Btn.Btn.Overlay.SetSize(0,0);
    Btn.btn.Repaint;
    exit;
  end;

  Bmp := TBitmap32.Create;
  Bmp.SetSize(sAutoWidth,sAutoHeight);
  Bmp.Clear(color32(0,0,0,0));
  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;

  case sState of
    tisCompact: currentstate := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Compact;
    tisMini   : currentstate := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Mini;
    else currentstate := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Full;
  end;

  if currentstate.HasOverlay then
  begin
    SkinText := currentstate.OverlayText.CreateThemedSkinText;
    SkinText.AssignFontTo(bmp.Font,mInterface.SkinInterface.SkinManager.Scheme);
    p := SkinText.GetXY(Rect(0,0,0,0),Rect(0,0,Bmp.Width,Bmp.Height),Rect(0,0,0,0));
    s := inttostr(Btn.Btn.Tag);
    SkinText.RenderTo(Bmp,p.x,p.y,s,mInterface.SkinInterface.SkinManager.Scheme);
    SkinText := nil;
  end else
  begin
    x := 3;
    y := 3;
    for n := 1 to Btn.Btn.Tag do
    begin
      Bmp.FrameRectTS(x,y,x+4,y+4,Color32(0,0,0,196));
      Bmp.FillRectT(x+1,y+1,x+3,y+3,color32(255,255,255,196));
      y := y + 5;
      if y > sAutoHeight - 8 then
      begin
        y := 3;
        x := x + 5;
      end;
      if x > sAutoWidth - 8 then
        break;
    end;
  end;

  Btn.Btn.Overlay.Assign(Bmp);
  Btn.Btn.OverlayPos := Point(1,1);
  Bmp.Free;  

  Btn.btn.Repaint;
end;

procedure TMainForm.UpdateButtons;
var
  n : integer;
begin
  if sb_config.Visible then
  begin
    sb_config.SkinManager := mInterface.SkinInterface.SkinManager;
    sb_config.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod +
      sb_config.GetIconWidth + sb_config.GetTextWidth;
  end;
  
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

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
  n : integer;
begin
  ClearButtons;

  FButtonSpacing := 2;
  sState       := tisCompact;
  sCountOverlay := True;
  sVWMOnly     := False;
  sMonitorOnly := False;
  sTaskPreview := True;
  sTPLockKey := 1; // (Shift)

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
      sCountOverlay := BoolValue('CountOverlay',True);
      sVWMOnly := BoolValue('VWMOnly',sVWMOnly);
      sMonitorOnly := BoolValue('MonitorOnly',sMonitorOnly);
      sTaskPreview := BoolValue('TaskPreview',sTaskPreview);
      sTPLockKey   := IntValue('TPLockKey',sTPLockKey);
      if ItemNamed['Apps'] <> nil then
      with ItemNamed['Apps'].Items do
           for n := 0 to Count - 1 do
               AddButton(Item[n].Items.Value('Target','C:\'),
                         Item[n].Items.Value('Icon','shell:icon'),
                         Item[n].Items.Value('Caption','C:\'));
    end;
  XML.Free;

  if not DwmCompositionEnabled then
    sTaskPreview := False;  
end;

procedure TMainForm.DisplaySystemMenu(pBtn : TButtonRecord);
var
  cp: TPoint;
  AppMenu: hMenu;
  MenuItemInfo: TMenuItemInfo;
  n : integer;
  VWMMenu : hMenu;
  VWMCount : integer;
  pItem : TTaskItem;
begin
  if not (isWindow(pBtn.wnd)) then
    exit;

  SysMenuButton := pBtn;
  GetCursorPos(cp);
  AppMenu := GetSystemMenu(pBtn.wnd, False);
  if not IsMenu(AppMenu) then
  begin
    GetSystemMenu(pBtn.wnd, True);
    AppMenu := GetSystemMenu(pBtn.wnd, False);
  end;

  if IsIconic(pBtn.wnd) then
  begin
    EnableMenuItem(AppMenu, SC_Restore,  mf_bycommand or mf_enabled);
    EnableMenuItem(AppMenu, SC_Move,     mf_bycommand or mf_grayed);
    EnableMenuItem(AppMenu, SC_Size,     mf_bycommand or mf_grayed);
    EnableMenuItem(AppMenu, SC_Minimize, mf_bycommand or mf_grayed);
  end else
  if IsZoomed(pBtn.wnd) then
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

  { Add a seperator }
  FillChar(MenuItemInfo, SizeOf(MenuItemInfo), #0);
  MenuItemInfo.cbSize := 44; //SizeOf(MenuItemInfo);
  MenuItemInfo.fMask := MIIM_CHECKMARKS or MIIM_DATA or
    MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE;
  MenuItemInfo.fType := MFT_SEPARATOR;
  MenuItemInfo.wID := $EFFF;
  InsertMenuItem(AppMenu, DWORD(0), True, MenuItemInfo);

  { Add Remove From App Bar Item}
  FillChar(MenuItemInfo, SizeOf(MenuItemInfo), #0);
  MenuItemInfo.cbSize := 44; //SizeOf(MenuItemInfo);
  MenuItemInfo.fMask := MIIM_DATA or
    MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE;
  MenuItemInfo.fType := MFT_STRING;
  MenuItemInfo.dwTypeData := 'Remove from Application Bar';
  MenuItemInfo.wID := $EFFF;
  InsertMenuItem(AppMenu, DWORD(0), True, MenuItemInfo);

  VWMMenu := 0;
  VWMCount := GetVWMCount;
  if (GetVWMCount > 0) then
  begin
   { Add a VWM Item}
   FillChar(MenuItemInfo, SizeOf(MenuItemInfo), #0);
   MenuItemInfo.cbSize := 44; //SizeOf(MenuItemInfo);
   MenuItemInfo.fMask := MIIM_DATA or
     MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE;
   MenuItemInfo.fType := MFT_STRING;
   MenuItemInfo.dwTypeData := 'Move to VWM';
   VWMMenu := CreateMenu;
   MenuItemInfo.hSubMenu := VWMMenu;
   MenuItemInfo.wID := 512;
 //  MenuItemInfo.hbmpItem := FMoveToVWMIcon.Handle;
   InsertMenuItem(AppMenu, DWORD(0), True, MenuItemInfo);

   pItem := FTM.GetItemByHandle(pBtn.wnd);
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

  SendMessage(pBtn.wnd, WM_INITMENUPOPUP, AppMenu, MAKELPARAM(0, 1));
  SendMessage(pBtn.wnd, WM_INITMENU, AppMenu, 0);
  TrackPopupMenu(AppMenu, tpm_leftalign or tpm_leftbutton, cp.x, cp.y, 0, Handle, nil);
  
  if VWMMenu <> 0 then
    DeleteMenu(AppMenu,0,MF_BYPOSITION);
  DeleteMenu(AppMenu,0,MF_BYPOSITION);
  DeleteMenu(AppMenu,0,MF_BYPOSITION);
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
      FLastButton.btn.Tag := FLastButton.btn.Tag - 1;
    end else FreeAndNil(FLastMenu);

    PostMessage(wnd, WM_CLOSE, 0, 0);
    PostThreadMessage(GetWindowThreadProcessID(wnd, nil), WM_QUIT, 0, 0);

    if FLastMenu = nil then
      if FLastButton.btn <> nil then
      begin
        FLastButton.btn.Special := False;
        FLastButton.btn.Tag := 0;
      end;
    UpdateButtonIcon(FLastButton);
  end;
end;

procedure TMainForm.mnOnClick(pItem: TSharpEMenuItem; pMenuWnd : TObject; var CanClose: boolean);
begin
  CanClose := True;

  if pItem = nil then
    exit;

  SwitchToThisWindow(pItem.PropList.GetInt('wnd'), True);
end;

procedure TMainForm.OnActivateTask(pItem: TTaskItem; Index: integer);
var
  n,i : integer;
  isItem : boolean;
  TaskItem : TTaskItem;
begin
  if pItem = nil then exit;

  for n := 0 to High(FButtonList) do
  begin
    IsItem := False;
    if FButtonList[n].btn.UseSpecial then
      FButtonList[n].btn.Down := False;
      
    if FButtonList[n].btn.Tag > 1 then
    begin
      // go through associated window list
      for i := 0 to FTM.ItemCount - 1 do
      begin
        TaskItem := TTaskItem(FTM.GetItemByIndex(i));
        if TaskItem <> nil then
          if (CompareText(TaskItem.FileName,FButtonList[n].exename) = 0)
            and (pItem.Handle = TaskItem.Handle) then
          begin
            isItem := True;
            break;
          end;
      end;
    end else isItem := (FButtonList[n].wnd = pItem.Handle);

    if IsItem then    
    begin
      if FButtonList[n].btn.UseSpecial then
        FButtonList[n].btn.Down := True;
      FButtonList[n].btn.Repaint;
      if FButtonList[n].btn.Flashing then
      begin
        FButtonList[n].btn.Flashing := False;
        FButtonList[n].btn.Repaint;
      end;
    end;
  end;
end;

procedure TMainForm.OnFlaskTask(pItem: TTaskItem; Index: integer);
var
  n : integer;
begin
  for n := 0 to High(FButtonList) do
    if FButtonList[n].wnd = pItem.Handle then
      FButtonList[n].btn.Flashing := True;
end;

procedure TMainForm.OnNewTask(pItem: TTaskItem; Index: integer);
var
  n : integer;
  s : String;
begin
  for n := 0 to High(FButtonList) do
  begin
    if CompareText(pItem.FileName, FButtonList[n].exename) = 0 then
    begin
      if CheckWindow(pItem.Handle) then
      begin
        FButtonList[n].btn.Tag := FButtonList[n].btn.Tag + 1;
        if FButtonList[n].btn.Tag >= 1 then
          FButtonList[n].btn.Special := True;
        if FButtonList[n].btn.Tag > 1 then
          UpdateButtonIcon(FButtonList[n]);

        if FButtonList[n].btn.Tag > 1 then
        begin
          s := FButtonList[n].exename;
          setlength(s,length(s) - length(ExtractFileExt(s)));
          FButtonList[n].btn.Caption := s;
        end else FButtonList[n].btn.Caption := pItem.Caption;
      end;
    end;
  end;
end;

procedure TMainForm.OnPreviewClick(Sender: TObject);
begin
  FPreviewWnds.Clear;
end;

procedure TMainForm.OnRemoveTask(pItem: TTaskItem; Index: integer);
var
  n : integer;
  s : String;
  PreviewItem : TTaskPreviewWnd;
begin
  for n := 0 to High(FButtonList) do
  begin
    if CompareText(pItem.FileName, FButtonList[n].exename) = 0 then
    begin
      if CheckWindow(pItem.Handle) then
      begin
        FButtonList[n].btn.Tag := FButtonList[n].btn.Tag - 1;
        if FButtonList[n].btn.Tag <= 0 then
        begin
          FButtonList[n].btn.Tag := 0;
          FButtonList[n].btn.Down := False;          
          FButtonList[n].btn.Special := False;
        end else UpdateButtonIcon(FButtonList[n]);

        if FButtonList[n].btn.Tag > 1 then
        begin
          s := FButtonList[n].exename;
          setlength(s,length(s) - length(ExtractFileExt(s)));
          FButtonList[n].btn.Caption := s;
        end else FButtonList[n].btn.Caption := pItem.Caption;
      end;
    end;
  end;
  for n := 0 to FPreviewWnds.Count - 1 do
  begin
    PreviewItem := TTaskPreviewWnd(FPreviewWnds.Items[n]);
    if PreviewItem.Wnd = pItem.Handle then
      PreviewItem.HideWindow(True);
  end;
end;

procedure TMainForm.OnUpdateTask(pItem: TTaskItem; Index: integer);
var
  n : integer;
  s : String;
begin
  for n := 0 to High(FButtonList) do
  begin
    if CompareText(pItem.FileName, FButtonList[n].exename) = 0 then
    begin
      if CheckWindow(pItem.Handle) then
      begin
        if FButtonList[n].btn.Tag > 1 then
        begin
          s := FButtonList[n].exename;
          setlength(s,length(s) - length(ExtractFileExt(s)));
          FButtonList[n].btn.Caption := s;
        end else FButtonList[n].btn.Caption := pItem.Caption;
      end;
    end;
  end;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TMainForm.PreviewCheckTimerTimer(Sender: TObject);
var
  CPos,cursorPos : TPoint;
  n : integer;
  R : TRect;
  item : TTaskPreviewWnd;
  valid : boolean;
  KS: TKeyboardState;
  SS: TShiftState;
  LockKey : integer;
begin
  if GetCursorPosSecure(cursorPos) then
    CPos := ScreenToClient(cursorPos)
  else exit;

  GetKeyboardState(KS);
  SS := KeyboardStateToShiftState(KS);
  case sTPLockKey of
    0: LockKey := VK_CONTROL;
    else LockKey := VK_SHIFT;
  end;
  if (GetAsyncKeyState(LockKey) <> 0) then
    exit;

  if not PointInRect(CPos,Rect(-5,-5,Width+5,Height+5)) then
  begin
    if FPreviewWnds.Count > 0 then
    begin
      valid := False;
      for n := 0 to FPreviewWnds.Count - 1 do
      begin
        item := TTaskPreviewWnd(FPreviewWnds.Items[n]);       
        GetWindowRect(item.Wnd,R);
        if PointInRect(cursorPos,Rect(R.Left-5,R.Top-5,R.Right+5,R.Bottom+5))
          and IsWindowVisible(item.Wnd) then
        begin
          valid := True;
          break;
        end;         
      end;
      if (not valid) or (FPreviewWnds.Count = 1) then
      begin
        if FPreviewWnds.Count = 1 then
          TTaskPreviewWnd(FPreviewWnds.Items[0]).HideWindow(True);
        PreviewCheckTimer.Enabled := False;
        FPreviewWnds.Clear;
        FPreviewButton := nil;
      end;
    end else
    begin
      PreviewCheckTimer.Enabled := False;
      FPreviewButton := nil;
    end;
  end;
end;

procedure TMainForm.UpdateSize;
begin
  LoadIcons;
  UpdateButtons;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean = True);
var
  newWidth : integer;
  n : integer;
  hasspecial : boolean;
begin
  self.Caption := 'ApplicationBar';

  case sState of
    tisCompact: hasspecial := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Compact.HasSpecial;
    tisMini   : hasspecial := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Mini.HasSpecial;
    else hasspecial := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Full.HasSpecial;
  end;  
  case sState of
    tisCompact: sAutoHeight := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Compact.Dimension.Y;
    tisMini   : sAutoHeight := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Mini.Dimension.Y;
    else sAutoHeight := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Full.Dimension.Y;
  end;
  case sState of
    tisCompact: sAutoWidth := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Compact.Dimension.X;
    tisMini   : sAutoWidth := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Mini.Dimension.X;
    else sAutoWidth := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Full.Dimension.X;
  end;

  if not sTaskPreview then
    ToolTipApi.EnableToolTip(FHintWnd)
  else ToolTipApi.DisableToolTip(FHintWnd);

  sb_config.Visible := (length(FButtonList) = 0);
  if sb_config.Visible then
  begin
    sb_config.SkinManager := mInterface.SkinInterface.SkinManager;
    sb_config.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod +
      sb_config.GetIconWidth + sb_config.GetTextWidth;
    newWidth := sb_config.Left + sb_config.Width + FButtonSpacing;
  end
  else newWidth := FButtonSpacing + High(FButtonList)*FButtonSpacing + length(FButtonList)*sAutoWidth + FButtonSpacing;
  
  for n := 0 to High(FButtonList) do
  begin
    if FButtonList[n].btn.Height <> sAutoHeight then
    begin
      FButtonList[n].btn.Height := sAutoHeight;
      FButtonList[n].btn.UpdateSkin;
    end;
    FButtonList[n].btn.UseSpecial := hasspecial;
    UpdateButtonIcon(FButtonList[n]);
  end;

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize;
end;

procedure TMainForm.UpdateComponentSkins;
var
  n : integer;
begin
  sb_config.SkinManager := mInterface.SkinInterface.SkinManager;
  for n := 0 to High(FButtonList) do
    FButtonList[n].btn.SkinManager := mInterface.SkinInterface.SkinManager;

  case sState of
    tisCompact: sAutoHeight := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Compact.Dimension.Y;
    tisMini   : sAutoHeight := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Mini.Dimension.Y;
    else sAutoHeight := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Full.Dimension.Y;
  end;
  case sState of
    tisCompact: sAutoWidth := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Compact.Dimension.X;
    tisMini   : sAutoWidth := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Mini.Dimension.X;
    else sAutoWidth := mInterface.SkinInterface.SkinManager.Skin.TaskItem.Full.Dimension.X;
  end;   
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
  p,cursorPos : TPoint;
  n : integer;
  cPos : integer;
  temp : TButtonRecord;
  MoveButtonIndex : integer;
  Animate : boolean;
  popupdown : boolean;
  size : real;
  xpos,ypos : real;
  pos : TPoint;
  R : TRect;
  TaskItem : TTaskItem;
  wndlist : TObjectList;
  perline : integer;
  count : integer;
  item : TTaskPreviewWnd;
begin
  cButton := nil;
  cButtonIndex := -1;

  if GetCursorPosSecure(cursorPos) then
    p := ScreenToClient(cursorPos)
  else exit;

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

  if MoveButton = nil then
  begin
    if FRefreshOnNextMouseMove then
    begin
      FRefreshOnNextMouseMove := False;
      for n := 0 to High(FButtonList) do
      begin
        FButtonList[n].btn.UpdateSkin;
        FButtonList[n].btn.Repaint;
      end;
    end;

    if (not sTaskPreview) then
      exit;
    if FPreviewButton = cButton then
      exit;
      
    if FPreviewWnds.Count > 0 then
    begin
      FPreviewWnds.Clear;
      Animate := False;
    end else Animate := True;

    // app not running, exit
    if (cButton.Tag <= 0) then
    begin
      FPreviewButton := nil;
      exit;
    end;

    FPreviewButton := cButton;

    popupdown := (ClientToScreen(Point(0,0)).y < Monitor.Top + Monitor.Height div 2);

    perline := mInterface.SkinInterface.SkinManager.Skin.TaskPreview.Dimension.X;
    size := Monitor.Width / perline;
    GetWindowRect(mInterface.BarInterface.BarWnd,R);

    // go through associated window list
    wndlist := TObjectList.Create(False);
    for n := 0 to FTM.ItemCount - 1 do
    begin
      TaskItem := TTaskItem(FTM.GetItemByIndex(n));
      if TaskItem <> nil then
        if CompareText(TaskItem.FileName,FButtonList[cButtonIndex].exename) = 0 then
          WndList.Add(TaskItem);
    end;

    if wndlist.count > 0 then
    begin
      if wndlist.count > perline then
        count := perline
      else count := wndlist.count;
      if count > 1 then
        Animate := False;      

      pos := ClientToScreen(Point(cButton.Left + cButton.Width div 2,0));
      xpos := pos.X - (count * size) / 2;
      if xpos < Monitor.Left then
        xpos := Monitor.Left;
      if popupdown then
        ypos := R.Bottom
      else ypos := R.Top;

      // first line
      xpos := xpos - size;
      for n := 0 to count - 1 do
      begin
        TaskItem := TTaskItem(wndlist.Items[n]);
        xpos := xpos + size;
        item := TTaskPreviewWnd.Create(TaskItem.handle,
                                       popupdown,
                                       round(xpos),
                                       round(ypos),
                                       round(xpos) - round(xpos - size),
                                       mInterface.SkinInterface.SkinManager,
                                       TaskItem.Caption,
                                       Animate,
                                       (wndlist.Count > 1));
        item.LockKey := sTPLockKey;
        item.OnPreviewClick := OnPreviewClick;                                                
        FPreviewWnds.Add(item);
      end;
      if count < wndlist.Count then
        for n := count to wndlist.Count - 1 do
        begin
          TaskItem := TTaskItem(wndlist.Items[n]);
          GetWindowRect(TTaskPreviewWnd(FPreviewWnds.Items[FPreviewWnds.Count - perline]).Wnd,R);
          xpos := R.Left;
          if popupdown then
            ypos := R.Bottom
          else ypos := R.Top;

          item := TTaskPreviewWnd.Create(TaskItem.handle,
                                         popupdown,
                                         round(xpos),
                                         round(ypos),
                                         round(xpos) - round(xpos - size),
                                         mInterface.SkinInterface.SkinManager,
                                         TaskItem.Caption,
                                         Animate,
                                         (wndlist.Count > 1));
          item.LockKey := sTPLockKey;
          item.OnPreviewClick := OnPreviewClick;
          FPreviewWnds.Add(item);
        end;          

      PreviewCheckTimer.Enabled := True;
    end;
    wndlist.Free;

    exit;
  end;

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
  wascleared : boolean;
begin
  MoveButton := nil;
  BtnItem := GetButtonItem(TSharpETaskItem(Sender));
  if BtnItem.Btn <> nil then
  begin
    if (Button = mbRight) then
    begin
      if (BtnItem.Btn.Tag = 1) then
        DisplaySystemMenu(BtnItem)
      else begin
        ButtonPopup.Tag := GetButtonIndex(BtnItem.btn);
        mnPopupSep1.Visible := (BtnItem.btn.Tag > 0);
        mnPopupCloseAll.Visible := (BtnItem.btn.Tag > 0);
        ButtonPopup.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y)
      end;
    end else
    if (Button = mbLeft) and (not hasmoved) then
    begin
      if (BtnItem.Btn.Special) or (BtnItem.btn.Down and not BtnItem.btn.UseSpecial) then
      begin
        if (BtnItem.Btn.Tag > 1) and (FPreviewWnds.Count = 0) and (not sTaskPreview) then
          BuildAndShowMenu(BtnItem)
        else begin
          if (FPreviewWnds.Count > 0) then
          begin
            FPreviewWnds.Clear;
            wascleared := True;
          end else wascleared := False;
          if (BtnItem.Btn.Tag > 1) then begin
            if not wascleared then
              FPreviewButton := nil;
              BtnItem.btn.OnMouseMove(Sender,Shift,X,Y);
            exit;
          end;

          if IsIconic(BtnItem.wnd) or (FTM.LastActiveTask <> BtnItem.wnd) then
            SwitchToThisWindow(BtnItem.wnd,True)
          else PostMessage(BtnItem.wnd,WM_SYSCOMMAND,SC_MINIMIZE,0);
        end;
      end else SharpApi.SharpExecute(BtnItem.target);
    end else if (Button = mbMiddle) and (not hasmoved) then
    begin
      SharpApi.SharpExecute(BtnItem.target);
      if (FPreviewWnds.Count > 0) then
        FPreviewWnds.Clear;
    end;
    if hasmoved then
      SaveSettings;
  end;
end;

procedure TMainForm.BuildAndShowMenu(btn: TButtonRecord);
var
  p : TPoint;
  mn : TSharpEMenu;
  ms : TSharpEMenuSettings;
  wnd : TSharpEMenuWnd;
  n: integer;
  item : TSharpEMenuItem;
  R : TRect;
  Bmp : TBitmap32;
  TaskItem : TTaskItem;

begin
  ms := TSharpEMenuSettings.Create;
  ms.LoadFromXML;

  mn := TSharpEMenu.Create(mInterface.SkinInterface.SkinManager,ms);
  ms.Free;

 // mn.AddLinkItem('Close All','','customicon:edititem',FMenuIcon1,false);
//  mn.AddSeparatorItem(False);

  for n := 0 to FTM.ItemCount - 1 do
  begin
    TaskItem := TTaskItem(FTM.GetItemByIndex(n));
    if TaskItem <> nil then
    begin
      if CompareText(TaskItem.FileName,btn.exename) = 0 then
      begin
        Bmp := TBitmap32.Create;
        if TaskItem.Icon = 0 then
          Bmp.Assign(btn.btn.Glyph32)
        else IconToImage(Bmp,TaskItem.Icon);
        item := TSharpEMenuItem(mn.AddCustomItem(TaskItem.Caption,'customicon:'+inttostr(n),Bmp));
        Bmp.Free;
        item.OnClick := mnOnClick;
        item.OnMouseUp := mnMouseUp;
        item.PropList.Add('wnd',TaskItem.Handle);
      end;
    end;
  end;

  mn.RenderBackground(0,0);

  wnd := TSharpEMenuWnd.Create(self,mn);
  wnd.FreeMenu := True; // menu will free itself when closed
  FLastMenu := wnd;
  FLastButton := Btn;

  GetWindowRect(mInterface.BarInterface.BarWnd,R);
  p := ClientToScreen(Point(Btn.Btn.Left + Btn.Btn.Width div 2, self.Height + self.Top));
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
  wnd.Show;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  CurrentVWM := SharpApi.GetCurrentVWM;

  FPreviewWnds := TObjectList.Create(True);

  FTM := TTaskManager.Create;
  FTM.OnNewTask := OnNewTask;
  FTM.OnRemoveTask := OnRemoveTask;
  FTM.OnUpdateTask := OnUpdateTask;
  FTM.OnFlashTask := OnFlaskTask;
  FTM.OnActivateTask := OnActivateTask;

  MoveButton := nil;
  DoubleBuffered := True;
  FHintWnd := ToolTipApi.RegisterToolTip(self);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FPreviewWnds.Free;
  FPreviewWnds := nil;
  FPreviewButton := nil;
  
  if FHintWnd <> 0 then
     DestroyWindow(FHintWnd);
     
  FTM.Enabled := False;
  FTM.Free;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  if mInterface <> nil then
     mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

function TMainForm.GetButtonIndex(pButton : TSharpETaskItem) : integer;
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

function TMainForm.CheckWindow(wnd: hwnd): boolean;
const
  MonRectOffset = 32;
var
  pItem : TTaskItem;
  Mon : TMonitorItem;
  R : TRect;
  MonRect : TRect;
begin
  result := True;
  if (not sVWMOnly) and (not sMonitorOnly) then
    exit;

  pItem := FTM.GetItemByHandle(wnd);
  if pItem <> nil then
  begin
    if sVWMOnly then
      result := (CurrentVWM = pItem.LastVWM);
    if sMonitorOnly then
    begin
      Mon := MonList.MonitorFromWindow(mInterface.BarInterface.BarWnd);
      MonRect := Mon.BoundsRect;
      MonRect.Left := MonRect.Left + MonRectOffset;
      MonRect.Top := MonRect.Top + MonRectOffset;
      MonRect.Right := MonRect.Right - MonRectOffset;
      MonRect.Bottom := MonRect.Bottom - MonRectOffset;
      GetWindowRect(pItem.Handle,R);
      if not (PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-R.Top) div 2), MonRect)
        or PointInRect(Point(R.Left, R.Top), MonRect)
        or PointInRect(Point(R.Left, R.Bottom), MonRect)
        or PointInRect(Point(R.Right, R.Top), MonRect)
        or PointInRect(Point(R.Right, R.Bottom), MonRect)) then
          result := False;
      end;
    end;
end;

end.
