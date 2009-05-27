{
Source Name: MainWnd.pas                                                    
Description: Application Bar Module - Main Window
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
  uTaskManager,
  uTaskItem,
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
    sMonitorOnly : boolean;
    sVWMOnly     : boolean;
    FButtonSpacing : integer;
    sCountOverlay : boolean;
    FButtonList  : array of TButtonRecord;
    FHintWnd     : hwnd; 
    movebutton   : TSharpETaskItem;
    hasmoved     : boolean;
    FLastMenu    : TSharpEMenuWnd;
    FLastButton  : TButtonRecord;
    FTM : TTaskManager;
    function CheckWindow(wnd : hwnd) : boolean;
    procedure OnNewTask(pItem : TTaskItem; Index : integer);
    procedure OnRemoveTask(pItem : TTaskItem; Index : integer);
    procedure OnUpdateTask(pItem : TTaskItem; Index : integer);
    procedure OnFlaskTask(pItem : TTaskItem; Index : integer);
    procedure OnActivateTask(pItem : TTaskItem; Index : integer);
    procedure ClearButtons;
    procedure UpdateButtonIcon(Btn : TButtonRecord);
    function GetButtonItem(pButton : TSharpETaskItem) : TButtonRecord;
    procedure AddButton(pTarget,pIcon,pCaption : String; Index : integer = -1);
    procedure UpdateButtons;
    procedure WMNotify(var msg : TWMNotify); message WM_NOTIFY;
    procedure WMDropFiles(var msg: TMessage); message WM_DROPFILES;
    procedure WMShellHook(var msg : TMessage); message WM_SHARPSHELLMESSAGE;
    procedure WMCopyData(var msg : TMessage); message WM_COPYDATA;
    procedure WMAddAppBarTask(var msg : TMessage); message WM_ADDAPPBARTASK;
    procedure mnOnClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure mnMouseUp(pItem : TSharpEMenuItem; Button: TMouseButton; Shift: TShiftState);
  public
    mInterface : ISharpBarModule;
    CurrentVWM   : integer;    
    procedure BuildAndShowMenu(btn : TButtonRecord);
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
  IXmlBaseUnit, SharpESkinPart;

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

    sb_config.Left := -200;
    UpdateButtons;
    SaveSettings;
    RealignComponents(True);
    UpdateGlobalFilterList(True);
    CheckList;
    exit;         
  end;
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
  sb_config.Left := -200;
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
          end;
        end;
    end;
    FButtonList[n].btn.Down := (count > 0);
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

    btn.Caption := pCaption;

    if not IconStringToIcon(pIcon,pTarget,btn.Glyph32) then
       btn.Glyph32.SetSize(0,0)
  end;
end;

procedure TMainForm.RefreshIcons;
var
  n : integer;
begin
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

  Btn.Btn.Overlay.Assign(Bmp);
  Btn.Btn.OverlayPos := Point(1,1);
  Bmp.Free;  

  Btn.btn.Repaint;
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
      if ItemNamed['Apps'] <> nil then
      with ItemNamed['Apps'].Items do
           for n := 0 to Count - 1 do
               AddButton(Item[n].Items.Value('Target','C:\'),
                         Item[n].Items.Value('Icon','shell:icon'),
                         Item[n].Items.Value('Caption','C:\'));
    end;
  XML.Free;
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
        FLastButton.btn.Down := False;
        FLastButton.btn.Tag := 0;
      end;
    UpdateButtonIcon(FLastButton);      
  end;
end;

procedure TMainForm.mnOnClick(pItem: TSharpEMenuItem; var CanClose: boolean);
begin
  CanClose := True;

  if pItem = nil then
    exit;

  SwitchToThisWindow(pItem.PropList.GetInt('wnd'), True);
end;

procedure TMainForm.OnActivateTask(pItem: TTaskItem; Index: integer);
var
  n : integer;
begin
  if pItem = nil then exit;

  for n := 0 to High(FButtonList) do
    if FButtonList[n].wnd = pItem.Handle then
      if FButtonList[n].btn.Flashing then
      begin
        FButtonList[n].btn.Flashing := False;
        FButtonList[n].btn.Repaint;
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
          FButtonList[n].btn.Down := True;
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

procedure TMainForm.OnRemoveTask(pItem: TTaskItem; Index: integer);
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
        FButtonList[n].btn.Tag := FButtonList[n].btn.Tag - 1;
        if FButtonList[n].btn.Tag <= 0 then
        begin
          FButtonList[n].btn.Tag := 0;
          FButtonList[n].btn.Down := False;
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

procedure TMainForm.UpdateSize;
begin
  UpdateButtons;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean = True);
var
  newWidth : integer;
  n : integer;
begin
  self.Caption := 'ApplicationBar';

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
          if IsIconic(BtnItem.wnd) or (FTM.LastActiveTask <> BtnItem.wnd) then
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

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

function TMainForm.CheckWindow(wnd: hwnd): boolean;
var
  pItem : TTaskItem;
  Mon : TMonitorItem;
  R : TRect;
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
      GetWindowRect(pItem.Handle,R);
      if not (PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-R.Top) div 2), Mon.BoundsRect)
        or PointInRect(Point(R.Left, R.Top), Mon.BoundsRect)
        or PointInRect(Point(R.Left, R.Bottom), Mon.BoundsRect)
        or PointInRect(Point(R.Right, R.Top), Mon.BoundsRect)
        or PointInRect(Point(R.Right, R.Bottom), Mon.BoundsRect)) then
          result := False;
      end;
    end;
end;

end.
