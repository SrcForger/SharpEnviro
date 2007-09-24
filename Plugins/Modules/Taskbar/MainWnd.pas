{
Source Name: MainWnd.pas
Description: TaskBar Module Main Form
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
  Types, Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, JvSimpleXML, SharpApi, Menus,
  Math, Contnrs, SharpESkinManager, SharpETaskItem, SharpESkin,
  SharpEBaseControls, SharpECustomSkinSettings, uTaskManager, uTaskItem,
  DateUtils, GR32, GR32_PNG, SharpIconUtils, SharpEButton, JvComponentBase,
  JvDragDrop;


type
  TColorRec = packed record
                b,g,r,a: Byte;
              end;
  TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
  PColorArray = ^TColorArray;
  THSLColor = record
                Hue, Saturation, Lightness : Integer;
              end;
  TTaskFilter = record
                  FilterStates : Set of Byte;
                  FilterClass : String;
                  FilterFile  : String;
                  FilterType  : integer;
                  FilterName  : String;
                end;

  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SystemSkinManager: TSharpESkinManager;
    ses_maxall: TSharpEButton;
    ses_minall: TSharpEButton;
    DDHandler: TJvDragDrop;
    DropTarget: TJvDropTarget;
    procedure DropTargetDragOver(Sender: TJvDropTarget;
      var Effect: TJvDropEffect);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ses_maxallClick(Sender: TObject);
    procedure ses_minallClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sWidth      : integer;
    sMaxWidth   : integer;
    sAutoHeight : integer;
    sCurrentWidth : integer;
    sSpacing    : integer;
    sState      : TSharpETaskItemStates;
    sSort       : boolean;
    sSortType   : TSortType;
    sDebug      : boolean;
    sMaxAllButton : boolean;
    sMinAllButton : boolean;
    sIFilter,sEFilter : Boolean;
    sIFilters,sEFilters : array of TTaskFilter;
    FLocked : boolean;
    FSpecialButtonWidth : integer;
    FDminA,FDmaxA : TBitmap32; // default min/max all images
    FCustomSkinSettings: TSharpECustomSkinSettings;
    Background : TBitmap32;
    FTipWnd : hwnd;
    FLastDragItem : TSharpETaskItem; // Only a pointer, don't free it...
    FLastDragMinimized : Boolean;
  public
    TM: TTaskManager;
    IList: TObjectList;
    ModuleID : integer;
    BarID : integer;
    BarWnd : hWnd;
    procedure SetSize(NewWidth : integer);
    procedure InitHook;
    procedure CalculateItemWidth(ItemCount : integer);
    procedure AlignTaskComponents;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure WMCommand(var msg: TMessage); message WM_COMMAND;
    procedure WMShellHook(var msg : TMessage); message WM_SHARPSHELLMESSAGE;
    procedure NewTask(pItem : TTaskItem; Index : integer);
    procedure RemoveTask(pItem : TTaskItem; Index : integer);
    procedure UpdateTask(pItem : TTaskItem; Index : integer);
    procedure ActivateTask(pItem : TTaskItem; Index : integer);
    procedure FlashTask(pItem : TTaskItem; Index : integer);
    procedure TaskExchange(pItem1,pItem2 : TTaskItem; n,i : integer);
    procedure SharpETaskItemClick(Sender: TObject);
    procedure OnTaskItemMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure OnDragEventEnter(Sender: TJvDropTarget; var Effect: TJvDropEffect);
    procedure DisplaySystemMenu(pHandle : hwnd);
    procedure GetSpacing;
    procedure CompleteRefresh;
    function CheckFilter(pItem : TTaskItem) : boolean;
    procedure CheckFilterAll;
    procedure LoadFilterSettingsFromXML;
    constructor CreateParented(ParentWindow : hwnd; pID,pBarID : integer; pBarWnd : Hwnd; pHeight : integer);
    procedure AlignSpecialButtons;
    procedure UpdateCustomSettings;
    procedure RepaintComponents;
    procedure UpdateBackground(new : integer = -1);

    procedure DebugOutPutInfo(msg : String);
    procedure DebugOutPutError(msg : String);
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI, ToolTipApi;

var
  SysMenuHandle : hwnd;

{$R *.dfm}

procedure TMainForm.DebugOutPutInfo(msg : String);
begin
  if not sDebug then exit;
  SharpApi.SendDebugMessageEx('Module|Taskbar',PChar(msg),0,DMT_INFO);
end;

procedure TMainForm.DebugOutPutError(msg : String);
begin
  if not sDebug then exit;
  SharpApi.SendDebugMessageEx('Module|Taskbar',PChar(msg),clMaroon,DMT_ERROR);
end;

procedure TMainForm.UpdateBackground(new : integer = -1);
begin
  if (new <> -1) then
     Background.SetSize(new,Height)
     else if (Width <> Background.Width) then
              Background.Setsize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background,self,Background.Width);
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TMainForm.RepaintComponents;
var
  n : integer;
begin
  for n := 0 to IList.Count - 1 do
      TSharpETaskItem(IList.Items[n]).Repaint;
  ses_minall.Repaint;
  ses_maxall.Repaint;
end;

procedure TMainForm.UpdateCustomSettings;
var
  dir : String;
  b : boolean;
begin
  DebugOutPutInfo('TMainForm.UpdatecustomSettings (Procedure)');
  if (not ses_minall.Visible) and (not ses_maxall.Visible) then exit;

  FCustomSkinSettings.LoadFromXML('');
  try
    with FCustomSkinSettings.xml.Items do
    begin
      if ItemNamed['taskbar'] <> nil then
      begin
        with FCustomSkinSettings.xml.Items.ItemNamed['taskbar'] do
        begin
          {$WARNINGS OFF}
          dir := IncludeTrailingBackSlash(FCustomSkinSettings.Path);
          {$WARNINGS ON}
          if FileExists(dir + items.Value('minallicon')) then
          begin
            try
              GR32_PNG.LoadBitmap32FromPNG(ses_minall.Glyph32,dir + items.Value('minallicon'),b);
            except
              ses_minall.Glyph32.Assign(FDminA);
            end;
          end else ses_minall.Glyph32.Assign(FDminA);
          if FileExists(dir + Items.Value('maxallicon')) then
          begin
            try
              GR32_PNG.LoadBitmap32FromPNG(ses_maxall.Glyph32,dir + items.Value('maxallicon'),b);
            except
              ses_maxall.Glyph32.Assign(FDmaxA);
            end;
          end else ses_maxall.Glyph32.Assign(FDmaxA);
        end;
      end else
      begin
        ses_minall.Glyph32.Assign(FDminA);
        ses_maxall.Glyph32.Assign(FDmaxA);
      end;
    end;
  except
    ses_minall.Glyph32.Assign(FDminA);
    ses_maxall.Glyph32.Assign(FDmaxA);
  end;
end;

constructor TMainForm.CreateParented(ParentWindow : hwnd; pID,pBarID : integer; pBarWnd : Hwnd; pHeight : integer);
begin
  DebugOutPutInfo('TMainForm.CreateParented (constructor)');
  Inherited CreateParented(ParentWindow);
  ModuleID := pID;
  BarID := pBarID;
  BarWnd := pBarWnd;
  Height := pHeight;
end;

procedure TMainForm.WMCommand(var msg: TMessage);
begin
  DebugOutPutInfo('TMainForm.WMCommand (Message Procedure)');
  PostMessage(SysMenuHandle, WM_SYSCOMMAND, msg.wparam, msg.lparam);
  inherited;
end;

procedure TMainForm.GetSpacing;
begin
  DebugOutPutInfo('TMainForm.GetSpacing (Procedure)');
  if SystemSkinManager.Skin.TaskItemSkin = nil then exit;
  try
    case sState of
      tisCompact: sSpacing := SystemSkinManager.Skin.TaskItemSkin.Compact.Spacing;
      tisMini: sSpacing := SystemSkinManager.Skin.TaskItemSkin.Mini.Spacing;
    else sSpacing := SystemSkinManager.Skin.TaskItemSkin.Full.Spacing;
    end;
  except
    sSpacing := 2;
  end;

  try
    case sState of
      tisCompact: sMaxWidth := SystemSkinManager.Skin.TaskItemSkin.Compact.SkinDim.WidthAsInt;
      tisMini: sMaxWidth := SystemSkinManager.Skin.TaskItemSkin.Mini.SkinDim.WidthAsInt;
      else sMaxWidth := SystemSkinManager.Skin.TaskItemSkin.Full.SkinDim.WidthAsInt;
    end;
  except
    sMaxWidth := 128;
  end;

  try
    case sState of
      tisCompact: sAutoHeight := SystemSkinManager.Skin.TaskItemSkin.Compact.SkinDim.HeightAsInt;
      tisMini   : sAutoHeight := SystemSkinManager.Skin.TaskItemSkin.Mini.SkinDim.HeightAsInt;
      else sAutoHeight := SystemSkinManager.Skin.TaskItemSkin.Full.SkinDim.HeightAsInt;
    end;
  except
    sAutoHeight := Height - 2;
  end;

  if (sAutoHeight > Height) or (sAutoHeight <=0) then
     sAutoHeight := Height;
  if sMaxWidth <= 0 then sMaxWidth := 128;
end;

procedure TMainForm.OnDragEventEnter(Sender: TJvDropTarget; var Effect: TJvDropEffect);
var
  pitem : TTaskItem;
begin
  pitem := TM.GetItemByHandle(TSharpETaskItem(Sender.Control).Tag);
  if pitem <> nil then
     pitem.Restore; 
end;

procedure TMainForm.AlignSpecialButtons;
var
  n : integer;
begin
  DebugOutPutInfo('TMainForm.AlignSpecialButtons (Procedure)');
  n := 1;
  if sMinAllButton then
  begin
    ses_minall.visible := True;
    ses_minall.Left := n;
    ses_minall.width := ses_minall.Height;
    n := n + ses_minall.Width + 2;
  end else ses_minall.Visible := False;
  if sMaxAllButton then
  begin
    ses_maxall.Visible := True;
    ses_maxall.Left := n;
    ses_maxall.Width := ses_maxall.Height;
    n := n + ses_maxall.Width + 2;
  end else ses_maxall.Visible := False;
  FSpecialButtonWidth := n + 4;
end;

procedure TMainForm.DisplaySystemMenu(pHandle : hwnd);
var
  cp: TPoint;
  AppMenu: hMenu;
  //MenuItemInfo: TMenuItemInfo;
begin
  DebugOutPutInfo('TMainForm.DisplaySystemMenu (Procedure)');
  SysMenuHandle := pHandle;
  GetCursorPos(cp);
  AppMenu := GetSystemMenu(pHandle, False);

  if IsIconic(pHandle) then
  begin
    EnableMenuItem(AppMenu, SC_Restore,  mf_bycommand or mf_enabled);
    EnableMenuItem(AppMenu, SC_Move,     mf_bycommand or mf_grayed);
    EnableMenuItem(AppMenu, SC_Size,     mf_bycommand or mf_grayed);
    EnableMenuItem(AppMenu, SC_Minimize, mf_bycommand or mf_grayed);
  end else
  if IsZoomed(pHandle) then
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
  { FillChar(MenuItemInfo, SizeOf(MenuItemInfo), #0);
   MenuItemInfo.cbSize := 44; //SizeOf(MenuItemInfo);
   MenuItemInfo.fMask := MIIM_CHECKMARKS or MIIM_DATA or
     MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE;
   MenuItemInfo.fType := MFT_SEPARATOR;
   MenuItemInfo.wID := $EFFF;
   InsertMenuItem(AppMenu, DWORD(0), True, MenuItemInfo);   }

  TrackPopupMenu(AppMenu, tpm_leftalign or tpm_leftbutton, cp.x, cp.y, 0, Handle, nil);
  //GetSystemMenu(pHandle, True);
end;

procedure TMainForm.OnTaskItemMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  DebugOutPutInfo('TMainForm.OnTaskItemMouseUp (Procedure)');
  if not (Sender is TSharpETaskItem) then exit;
  if Button = mbRight then DisplaySystemMenu(TSharpETaskItem(Sender).Tag);
end;

procedure LoadFilterFromXML(var filter : TTaskFilter; XML : TJvSimpleXMLElem);
var
  n : integer;
begin
  filter.FilterType := XML.Items.IntValue('FilterType',2);
  filter.FilterClass := XML.Items.Value('WndClassName');
  filter.FilterFile  := LowerCase(XML.Items.Value('FileName'));
  filter.FilterStates := [];
  for n := 0 to 10 do
      if XML.Items.BoolValue('SW_'+inttostr(n),False) then filter.FilterStates := filter.FilterStates + [n];
end;

procedure TMainForm.LoadFilterSettingsFromXML;
var
  XML : TJvSimpleXML;
  i,n : integer;
  fn : string;
begin
  DebugOutPutInfo('TMainForm.LoadFilterSettingsFromXML (Procedure)');
  fn := SharpApi.GetSharpeGlobalSettingsPath + 'SharpBar\Module Settings\TaskBar\';
  fn := fn + 'Filters.xml';
  if not FileExists(fn) then
  begin
    sIFilter := False;
    sEFilter := False;
    exit;
  end;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(fn);
    for i := 0 to High(sIFilters) do
    begin
      for n := 0 to XML.Root.Items.Count - 1 do
          if XML.Root.Items.Item[n].Items.Value('Name') = sIFilters[i].FilterName then
             LoadFilterFromXML(sIFilters[i],XML.Root.Items.Item[n]);
    end;
    for i := 0 to High(sEFilters) do
    begin
      for n := 0 to XML.Root.Items.Count - 1 do
          if XML.Root.Items.Item[n].Items.Value('Name') = sEFilters[i].FilterName then
             LoadFilterFromXML(sEFilters[i],XML.Root.Items.Item[n]);
    end;
  except
  end;
  XML.Free;
end;

procedure TMainForm.LoadSettings;
var
  fitem : TJvSimpleXMLElem;
  XML : TJvSimpleXML;
  fileloaded : boolean;
  n : integer;
begin
  DebugOutPutInfo('TMainForm.LoadSettings (Procedure)');
  sState     := tisFull;
  sWidth     := 100;
  sMaxwidth  := 128;
  sSpacing   := 2;
  sSort      := False;
  sDebug     := False;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      case IntValue('State',0) of
        1 : sState := tisCompact;
        2 : sState := tisMini;
        else sState := tisFull;
      end;
      sSort := BoolValue('Sort',False);
      case IntValue('SortType',0) of
        1: sSortType := stWndClass;
        2: sSortType := stTime;
        3: sSortType := stIcon;
        else sSortType := stCaption;
      end;
      sMinAllButton := BoolValue('MinAllButton',False);
      sMaxAllButton := BoolValue('MaxAllButton',False);
      sIFilter := BoolValue('IFilter',False);
      sEFilter := BoolValue('EFilter',False);
      sDebug   := BoolValue('Debug',False);
      setlength(sIFilters,0);
      setlength(sEFilters,0);
      if ItemNamed['IFilters'] <> nil then
      begin
        fitem := ItemNamed['IFilters'];
        for n := 0 to fitem.Items.Count-1 do
        begin
          setlength(sIFilters,length(sIFilters)+1);
          sIFilters[High(sIFilters)].FilterName := fitem.Items.Item[n].Value;
        end;
      end;
      if ItemNamed['EFilters'] <> nil then
      begin
        fitem := ItemNamed['EFilters'];
        for n := 0 to fitem.Items.Count-1 do
        begin
          setlength(sEFilters,length(sEFilters)+1);
          sEFilters[High(sEFilters)].FilterName := fitem.Items.Item[n].Value;
        end;
      end;
    end;
  XML.Free;
  
  if length(sEFilters) = 0 then sEFilter := False;
  if length(sIFilters) = 0 then sIFilter := False;
  if (sIFilter) or (sEFilter) then LoadFilterSettingsFromXML;

  UpdateCustomSettings;

  TM.SortTasks := sSort;
  TM.SortType := sSortType;

  FLocked := True;

  AlignSpecialButtons;
  GetSpacing;
  if TM.SortTasks then TM.DoSortTasks;
  CompleteRefresh;

  FLocked := False;
end;

procedure TMainForm.CompleteRefresh;
var
  n : integer;
begin
  DebugOutPutInfo('TMainForm.CompleteRefresh (Procedure)');
  for n := 0 to IList.Count - 1 do
     ToolTipApi.DeleteToolTip(FTipWnd,Self,TSharpETaskItem(IList[n]).Tag);
  IList.Clear;
  TM.CompleteRefresh;
  AlignTaskComponents;
end;

procedure TMainForm.SetSize(NewWidth : integer);
var
  new : integer;
begin
  DebugOutPutInfo('TMainForm.SetSize (Procedure)');
  new := Max(NewWidth,1);
  UpdateBackground(new);
  Width := new;
  if IList.Count <= 0 then
    exit;
    
  CalculateItemWidth(IList.Count);
  AlignTaskComponents;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  DebugOutPutInfo('TMainForm.ReAlignComponents (Procedure)');
  GetSpacing;
  if IList.Count <=0 then
  begin
    Tag := 1;
    Hint := '1';
    if BroadCast then SendMessage(BarWnd,WM_UPDATEBARWIDTH,0,0);
    exit;
  end;

  NewWidth := Max(FSpecialButtonWidth + IList.Count * sMaxWidth + (IList.Count - 1) * sSpacing,1);

  if sState = tisMini then
     ToolTipApi.EnableToolTip(FTipWnd)
     else ToolTipApi.DisableToolTip(FTipWnd);

  if sState = tisMini then Tag := Max(FSpecialButtonWidth + IList.Count * sMaxWidth + (IList.Count - 1) * sSpacing,1)
     else Tag := Max(FSpecialButtonWidth + IList.Count * 16 + (IList.Count - 1) * sSpacing,1);
     
  Hint := InttoStr(NewWidth);
  if Width <> NewWidth then
  begin
    //AlignTaskComponents;
    if BroadCast then SendMessage(BarWnd,WM_UPDATEBARWIDTH,0,0);
  end else AlignTaskComponents;
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  fitem : TJvSimpleXMLElem;
  XML : TJvSimpleXML;
  n,i : integer;
begin
  DebugOutPutInfo('TMainForm.Settings1Click (Procedure)');
  try
    SettingsForm := TSettingsForm.Create(application.MainForm);
    case sState of
      tisFull    : SettingsForm.cb_tsfull.Checked := True;
      tisCompact : SettingsForm.cb_tscompact.Checked := True;
      tisMini    : SettingsForm.cb_tsminimal.Checked := True;
    end;
    case sSortType of
      stCaption  : SettingsForm.rb_caption.Checked := True;
      stWndClass : SettingsForm.rb_wndclassname.Checked := True;
      stTime     : SettingsForm.rb_timeadded.Checked := True;
      stIcon     : SettingsForm.rb_icon.Checked := True;
    end;
    SettingsForm.cb_debug.Checked  := sDebug;
    SettingsForm.cb_minall.Checked := sMinAllButton;
    SettingsForm.cb_maxall.Checked := sMaxAllButton;
    SettingsForm.cb_sort.Checked := sSort;
    SettingsForm.rb_ifilter.Checked := sIFilter;
    SettingsForm.rb_efilter.Checked := sEFilter;
    SettingsForm.UpdateFilterList;
    for n := 0 to High(sIFilters) do
    begin
      i := SettingsForm.list_include.Items.IndexOf(sIFilters[n].FilterName);
      if i >=0 then SettingsForm.list_include.Checked[i] := True;
    end;
    for n := 0 to High(sEFilters) do
    begin
      i := SettingsForm.list_exclude.Items.IndexOf(sEFilters[n].FilterName);
      if i >=0 then SettingsForm.list_exclude.Checked[i] := True;
    end;

    if SettingsForm.ShowModal = mrOk then
    begin
      if SettingsForm.cb_tscompact.Checked then sState := tisCompact
         else if SettingsForm.cb_tsminimal.Checked then sState := tisMini
              else sState := tisFull;
      sSort := SettingsForm.cb_sort.Checked;
      if SettingsForm.rb_wndclassname.Checked then sSortType := stWndClass
         else if SettingsForm.rb_timeadded.Checked then sSortType := stTime
              else if SettingsForm.rb_icon.Checked then sSortType := stIcon
                   else sSortType := stCaption;
      sIFilter := SettingsForm.rb_ifilter.Checked;
      sEFilter := SettingsForm.rb_efilter.Checked;
      sDebug   := SettingsForm.cb_debug.Checked;
      setlength(sIFilters,0);
      setlength(sEFilters,0);
      for n := 0 to SettingsForm.list_include.Count - 1 do
          if SettingsForm.list_include.Checked[n] then
          begin
            setlength(sIFilters,length(sIFilters)+1);
            sIFilters[High(sIFilters)].FilterName := SettingsForm.list_include.Items[n];
          end;
      for n := 0 to SettingsForm.list_exclude.Count - 1 do
          if SettingsForm.list_exclude.Checked[n] then
          begin
            setlength(sEFilters,length(sEFilters)+1);
            sEFilters[High(sEFilters)].FilterName := SettingsForm.list_exclude.Items[n];
          end;
      sMinAllButton := SettingsForm.cb_minall.Checked;
      sMaxAllButton := SettingsForm.cb_maxall.Checked;

      XML := TJvSimpleXML.Create(nil);
      XML.Root.Name := 'TaskBarModuleSettings';
      with XML.Root.Items do
      begin
        Add('Sort',sSort);
        case sSortType of
          stCaption  : Add('SortType',0);
          stWndClass : Add('SortType',1);
          stTime     : Add('SortType',2);
          stIcon     : Add('SortType',3);
        end;
        case sState of
          tisFull    : Add('State',0);
          tisCompact : Add('State',1);
          tisMini    : Add('State',2);
        end;
        Add('Debug',sDebug);
        Add('MinAllButton',sMinAllButton);
        Add('MaxAllButton',sMaxAllButton);
        Add('IFilter',sIFilter);
        Add('EFilter',sEFilter);
        fitem := Add('IFilters');
        for n := 0 to High(sIFilters) do
            fitem.Items.Add(inttostr(n),sIFilters[n].FilterName);
        fitem := Add('EFilters');
        for n := 0 to High(sEFilters) do
            fitem.Items.Add(inttostr(n),sEFilters[n].FilterName);
      end;
      XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
      XML.Free;
      LoadSettings;
      AlignTaskComponents;
      RealignComponents(True);
    end;
  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.CalculateItemWidth(ItemCount : integer);
var
  n : integer;
  FreeSpace : integer;
  pItem : TSharpETaskItem;
begin
  DebugOutPutInfo('TMainForm.CalculateItemWidth (Procedure)');
  for n := IList.Count - 1 downto 0 do
    if IList.Items[n] <> nil then
    begin
      pItem := TSharpETaskItem(IList.Items[n]);
      pItem.State := sState;
    end;
  FreeSpace := Width - FSpecialButtonWidth;
  if ItemCount = 0 then sCurrentWidth := 16
     else sCurrentWidth := Max(Min((FreeSpace - ItemCount*sSpacing) div ItemCount,sMaxWidth),16);
end;

procedure TMainForm.AlignTaskComponents;
var
  n : integer;
  pTaskItem : TSharpETaskItem;
begin
  DebugOutPutInfo('TMainForm.AlignTaskComponents (Procedure)');
  for n := IList.Count - 1 downto 0 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    if pTaskItem <> nil then
    begin
      if not pTaskItem.Visible then pTaskItem.Visible := True;
      if sCurrentWidth < sMaxWidth then
      begin
        pTaskItem.AutoSize := False;
        pTaskItem.Left := FSpecialButtonWidth + n*sCurrentWidth + n*sSpacing;
        pTaskItem.Width := sCurrentWidth;
        pTaskItem.Height := sAutoHeight;
      end else
      begin
        pTaskItem.Left := FSpecialButtonWidth + n*sMaxWidth + n*sSpacing;
        pTaskItem.AutoSize := True;
      end;
      ToolTipApi.UpdateToolTipRect(FTipWnd,Self,pTaskItem.Tag,
                                   Rect(pTaskItem.Left,pTaskItem.Top,
                                        pTaskItem.Left + pTaskItem.Width,
                                        pTaskItem.Top + pTaskItem.Height));
    end;
  end;
end;

procedure UpdateIcon(var pTaskItem : TSharpETaskItem; pItem : TTaskItem);
var
  bmp : TBitmap32;
begin
  if (pTaskItem = nil) or (pItem = nil) then exit;

  if (pTaskItem = nil) or (pItem = nil) then exit;
  bmp := TBitmap32.Create;
  try
    IconToImage(bmp,pItem.Icon);
    if (bmp.Width <> 0) and (bmp.Height <> 0) then
       pTaskItem.Glyph32.Assign(bmp);
  except
  end;
  bmp.Free;
end;

procedure TMainForm.CheckFilterAll;
var
  n,i : integer;
  pTaskItem : TSharpETaskItem;
  pItem : TTaskItem;
  changed : boolean;
begin
  DebugOutPutInfo('TMainForm.CheckFilterAll (Procedure)');
  if (sIFilter = False) and (sEFilter = False) then exit;

  changed := False;
  FLocked := True;

  // remove tasks
  for i := TM.GetCount - 1 downto 0  do
  begin
    pItem := TM.GetItemByIndex(i);
    if pItem <> nil then
    begin
      for n := IList.Count - 1 downto 0 do
          if TSharpETaskItem(IList.Items[n]).Tag = Integer(pItem.Handle) then
          begin
            pTaskItem := TSharpETaskItem(IList.Items[n]);
            if not CheckFilter(pItem) then
            begin
              RemoveTask(TM.GetItemByHandle(pTaskItem.Tag),0);
              changed := True;
            end;
            break;
          end;
    end;
  end;

  // add new tasks
  for i := TM.GetCount - 1 downto 0  do
  begin
    pItem := TM.GetItemByIndex(i);
    if pItem <> nil then
    begin
      pTaskItem := nil;
      for n := 0 to IList.Count - 1 do
          if TSharpETaskItem(IList.Items[n]).Tag = Integer(pItem.Handle) then
          begin
            pTaskItem := TSharpETaskItem(IList.Items[n]);
            break;
          end;

      if pTaskItem = nil then
         if CheckFilter(pItem) then
         begin
           NewTask(pItem,i);
           changed := True;
        end;
    end;
  end;

  FLocked := False;

  if changed then RealignComponents(True);
end;

function TMainForm.CheckFilter(pItem : TTaskItem) : boolean;
var
  n,i : integer;
  R : TRect;
  Mon : TMonitor;
  nm : boolean;
  f : boolean;
begin
  if pItem = nil then
  begin
    result := false;
    exit;
  end;

//  DebugOutPutInfo('TMainForm.CheckFilter (Procedure)');
  if (sIFilter = False) and (sEFilter = False) then
  begin
    result := true;
    exit;
  end;

  result := true;
  nm := False;
  if sIFilter then
  begin
    for n:=0 to High(sIFilters) do
    begin
      case sIFilters[n].FilterType of
        0: if pItem.Placement.showCmd in sIFilters[n].FilterStates then
              nm := True;
        1: if pItem.WndClass = sIFilters[n].FilterClass then
              nm := True;
        2: if pItem.FileName = sIFilters[n].FilterFile then
              nm := True;
        3: begin
             Mon := Screen.MonitorFromWindow(BarWnd);
             GetWindowRect(pItem.Handle,R);
             if (PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-Top) div 2), Mon.BoundsRect)) then
               nm := True
           end;
        4: begin
             Mon := Screen.MonitorFromWindow(BarWnd);
             GetWindowRect(pItem.Handle,R);
             if not (PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-Top) div 2), Mon.BoundsRect)) then
               nm := True
           end;
        5: begin
             GetWindowRect(pItem.Handle,R);
             f := False;
             for i := 0 to Screen.MonitorCount - 1 do
             begin
               Mon := Screen.Monitors[i];
               if (PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-Top) div 2), Mon.BoundsRect)) then
               begin
                 f := True;
                 break;
               end;
             end;
             nm := not f;
           end;
      end;
      if nm then break;
    end;
  end;

  // task is supposed to be included...
  if nm then exit;

  if sEFilter then
  begin
    for n:=0 to High(sEFilters) do
    begin
      case sEFilters[n].FilterType of
        0: if pItem.Placement.showCmd in sEFilters[n].FilterStates then result := false;
        1: if pItem.WndClass = sEFilters[n].FilterClass then result := false;
        2: if pItem.FileName = sEFilters[n].FilterFile then result := false;
        3: begin
             Mon := Screen.MonitorFromWindow(BarWnd);
             GetWindowRect(pItem.Handle,R);
             if (PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-Top) div 2), Mon.BoundsRect))
               then result := false;
           end;
        4: begin
             Mon := Screen.MonitorFromWindow(BarWnd);
             GetWindowRect(pItem.Handle,R);
             if not (PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-Top) div 2), Mon.BoundsRect)) then
               result := false;
           end;
        5: begin
             GetWindowRect(pItem.Handle,R);
             f := False;
             for i := 0 to Screen.MonitorCount - 1 do
             begin
               Mon := Screen.Monitors[i];
               if (PointInRect(Point(R.Left + (R.Right-R.Left) div 2, R.Top + (R.Bottom-Top) div 2), Mon.BoundsRect)) then
               begin
                 f := True;
                 break;
               end;
             end;
             result := f;
           end;
      end;
    end;
  end;
end;

procedure TMainForm.FlashTask(pItem : TTaskItem; Index : integer);
var
  n : integer;
  pTaskItem : TSharpETaskItem;
begin
  DebugOutPutInfo('TMainForm.FlashTask (Procedure)');
  if pItem = nil then exit;

  for n := 0 to IList.Count - 1 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    if pTaskItem <> nil then
       if pTaskItem.Tag = Integer(pItem.Handle) then
       begin
         if pTaskItem.Down then exit;
         pTaskItem.Flashing := True;
         exit;
       end;
  end;
end;

procedure TMainForm.ActivateTask(pItem : TTaskItem; Index : integer);
var
  n : integer;
  pTaskItem : TSharpETaskItem;
begin
  DebugOutPutInfo('TMainForm.ActivateTask (Procedure)');
  if (pItem = nil) and (Index = - 1) then
  begin
    for n := IList.Count - 1 downto 0 do
    begin
      pTaskItem := TSharpETaskItem(IList.Items[n]);
      if pTaskItem <> nil then
         if pTaskItem.Down then
         begin
           pTaskItem.Down := False;
         end;
    end;
    exit;
  end;

  if pItem = nil then exit;

  pTaskItem := nil;
  CheckFilterAll;

  TM.LastActiveTask := pItem.Handle;
  for n := IList.Count - 1 downto 0 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    if pTaskItem <> nil then
    begin
      if (Integer(pItem.Handle) <> pTaskItem.Tag ) and (pTaskItem.Down) then
      begin
         pTaskItem.Down := False
      end
      else if Integer(pItem.Handle) = pTaskItem.Tag then
      begin
        pTaskItem.Down := True;
        if pTaskItem.Flashing then pTaskItem.Flashing := False;
        UpdateIcon(pTaskItem,pItem);
        pTaskItem.Repaint;
      end;
    end;
  end;
end;

procedure TMainForm.NewTask(pItem : TTaskItem; Index : integer);
var
  pTaskItem : TSharpETaskItem;
begin
  DebugOutPutInfo('TMainForm.NewTask (Procedure)');
  if pItem = nil then exit;

  if not CheckFilter(pItem) then exit;
  pTaskItem := TSharpETaskItem.Create(self);
  CalculateItemWidth(IList.Count + 1);
  IList.Add(pTaskItem);
  pTaskItem.SkinManager := SystemSkinManager;  
  pTaskItem.Width := sCurrentWidth;
  pTaskItem.Parent := self;
  pTaskItem.Left := Width;
  pTaskItem.AutoPosition := True;
  pTaskItem.Margin := 0;
  pTaskItem.Flashing := False;
  pTaskItem.Caption := pItem.Caption;
  pTaskItem.Tag := pItem.Handle;
  pTaskItem.State := sState;
  UpdateIcon(pTaskItem,pItem);
  pTaskItem.OnClick := SharpETaskItemClick;
  pTaskItem.OnMouseUp := OnTaskItemMouseUp;
  ToolTipApi.AddToolTip(FTipWnd,Self,pTaskItem.Tag,
                        Rect(pTaskItem.Left,pTaskItem.Top,
                             pTaskItem.Left + pTaskItem.Width,
                             pTaskItem.Top + pTaskItem.Height),
                             pTaskItem.Caption);
  if not FLocked then ReAlignComponents(True);
end;

procedure TMainForm.TaskExchange(pItem1,pItem2 : TTaskItem; n,i : integer);
var
  index1,index2 : integer;
begin
  DebugOutPutInfo('TMainForm.TaskExchange (Procedure)');
  if (pItem1 = nil) or (pItem2 = nil) then exit;

  index1 := -1;
  index2 := -1;
  for n:= 0 to IList.Count - 1 do
  begin
    if TSharpETaskItem(IList.Items[n]).Tag = Integer(pItem1.Handle) then index1 := n;
    if TSharpETaskItem(IList.Items[n]).Tag = Integer(pItem2.Handle) then index2 := n;
    if (index1 <> -1) and (index2 <> -1) then break;
  end;
  if ((index1 = - 1) or (index2 = -1))
     or ((index1 = index2)) then exit;
  IList.Exchange(index1,index2);
  AlignTaskComponents;
end;

procedure TMainForm.RemoveTask(pItem : TTaskItem; Index : integer);
var
  n : integer;
begin
  DebugOutPutInfo('TMainForm.RemoveTask (Procedure)');
  if pItem = nil then exit;

  for n := IList.Count - 1 downto 0 do
    if TSharpETaskItem(IList.Items[n]).Tag = Integer(pItem.Handle) then
    begin
      ToolTipApi.DeleteToolTip(FTipWnd,Self,TSharpETaskItem(IList.Items[n]).Tag);
      IList.Delete(n);
    end;
  CalculateItemWidth(IList.Count);
  if not FLocked then ReAlignComponents(True);
end;

procedure TMainForm.UpdateTask(pItem : TTaskItem; Index : integer);
var
  pTaskItem : TSharpETaskItem;
  n : integer;
begin
  DebugOutPutInfo('TMainForm.UpdateTask (Procedure)');
  if pItem = nil then exit;

  CheckFilterAll;
  pTaskItem := nil;
  for n := 0 to IList.Count - 1 do
    if TSharpETaskItem(IList.Items[n]).Tag = Integer(pItem.Handle) then
    begin
      pTaskItem := TSharpETaskItem(IList.Items[n]);
      break;
    end;

  if pTaskItem = nil then exit;

  UpdateIcon(pTaskItem,pItem);
  pTaskItem.Caption := pItem.Caption;
  ToolTipApi.UpdateToolTipText(FTipWnd,Self,pTaskItem.Tag,pTaskItem.Caption);
end;

procedure TMainForm.SharpETaskItemClick(Sender: TObject);
var
  pItem : TTaskItem;
begin
  DebugOutPutInfo('TMainForm.SharpETaskItemClick (Procedure)');
  if Sender = nil then exit;
  if not (Sender is TSharpETaskItem) then exit;
  pItem := TM.GetItemByHandle(TSharpETaskItem(Sender).Tag);
  
  if pItem <> nil then
  begin
    pItem.UpdateVisibleState;
    if (not pItem.Visible) or (Integer(TM.LastActiveTask) <> TSharpETaskItem(Sender).Tag) then
    begin
      pItem.Restore;
    end else
    begin
      TSharpETaskItem(Sender).Down := False;
      pItem.Minimize;
    end;
  end;
end;

procedure TMainForm.WMShellHook(var msg : TMessage);
begin
  if TM = nil then
    exit;

 DebugOutPutInfo('TMainForm.WMShellHook (Message Procedure)');
 if msg.LParam = Integer(self.Handle) then exit;
 case msg.WParam of
   HSHELL_WINDOWCREATED : TM.AddTask(msg.LParam);
   HSHELL_REDRAW : TM.UpdateTask(msg.LParam);
   HSHELL_REDRAW + 32768 : TM.FlashTask(msg.LParam);
   HSHELL_WINDOWDESTROYED : TM.RemoveTask(msg.LParam);
   HSHELL_WINDOWACTIVATED : TM.ActivateTask(msg.LParam);
   HSHELL_WINDOWACTIVATED + 32768 : TM.ActivateTask(msg.LParam);
   HSHELL_GETMINRECT      : TM.UpdateTask(msg.LParam);
  end;
end;

procedure TMainForm.InitHook;
begin
  DebugOutPutInfo('TMainForm.InitHook (Procedure)');
  SharpApi.RegisterShellHookReceiver(Handle);
end;

procedure TMainForm.FormCreate(Sender: TObject);
type
  PParam = ^TParam;
  TParam = record
    wndlist: array of hwnd;
  end;
var
  EnumParam : TParam;
  n : integer;

  function EnumWindowsProc(Wnd: HWND; LParam: LPARAM): BOOL; stdcall;
  begin
    if (GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) and
       ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
       ((GetWindowLong(Wnd, GWL_HWNDPARENT) = 0) or
       (GetWindowLong(Wnd, GWL_HWNDPARENT) = Integer(GetDesktopWindow))) and
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0))  then
      with PParam(LParam)^ do
      begin
       setlength(wndlist,length(wndlist)+1);
       wndlist[high(wndlist)] := wnd;
      end;
    result := True;
  end;

begin
  FTipWnd := ToolTipApi.RegisterToolTip(self);

  DebugOutPutInfo('TMainForm.FormCreate (Procedure)');
  FCustomSkinSettings := TSharpECustomSkinSettings.Create;
  DoubleBuffered := True;

  Background := TBitmap32.Create;

  FDminA := TBitmap32.Create;
  FDmaxA := TBitmap32.Create;

  FDminA.Assign(ses_minall.Glyph32);
  FDmaxA.Assign(ses_maxall.Glyph32);

  sIFilter := False;
  sEFilter := False;
  sMinAllButton := False;
  sMaxAllButton := False;
  sMaxwidth  := 128;
  IList := TObjectList.Create;
  IList.Clear;
  TM := TTaskManager.Create;
  TM.Enabled := True;
  TM.OnNewTask := NewTask;
  TM.OnRemoveTask := RemoveTask;
  TM.OnUpdateTask := UpdateTask;
  TM.OnActivateTask := ActivateTask;
  TM.OnFlashTask    := FlashTask;
  TM.OnTaskExchange := TaskExChange;

  //InitHook;
  LoadSettings;

  FLocked := True;
  setlength(EnumParam.wndlist,0);
  EnumWindows(@EnumWindowsProc, Integer(@EnumParam));
  for n := 0 to High(EnumParam.wndlist) do
    TM.AddTask(EnumParam.wndlist[n]);    
  setlength(EnumParam.wndlist,0);
  //EnumWindows(@EnumWindowsProc, 0);
  FLocked := False;
  RealignComponents(False);
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if FTipWnd <> 0 then
     DestroyWindow(FTipWnd); 

  DebugOutPutInfo('TMainForm.FormDestroy (Procedure)');
  FCustomSkinSettings.Free;
  FDminA.Free;
  FDmaxA.Free;
  TM.Free;
  IList.Clear;
  IList.Free;
  FreeAndNil(Background);
  UnRegisterShellHookReceiver(Handle);
end;

procedure TMainForm.ses_minallClick(Sender: TObject);
var
  n : integer;
  pTaskItem : TSharpETaskItem;
  pItem : TTaskItem;
begin
  DebugOutPutInfo('TMainForm.ses_minallClick (Procedure)');
  FLocked := True;
  for n := IList.Count -1 downto 0 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    pTaskItem.Down := False;
    pItem := TTaskItem(TM.GetItemByHandle(pTaskItem.Tag));
    if pItem <> nil then
       pItem.Minimize;
  end;
  FLocked := False;
  RealignComponents(True);
end;

procedure TMainForm.ses_maxallClick(Sender: TObject);
var
  n : integer;
  pTaskItem : TSharpETaskItem;
  pItem : TTaskItem;
begin
  DebugOutPutInfo('TMainForm.ses_maxallClick (Procedure)');
  FLocked := True;

  for n := IList.Count -1 downto 0 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    pItem := TTaskItem(TM.GetItemByHandle(pTaskItem.Tag));
    if pItem <> nil then
       pItem.Restore;
  end;
  FLocked := False;
  RealignComponents(True);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Background.DrawTo(Canvas.Handle,0,0);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  DropTarget.Control := self
end;

procedure TMainForm.DropTargetDragOver(Sender: TJvDropTarget;
  var Effect: TJvDropEffect);
var
  p : TPoint;
  n : integer;
  pItem : TSharpETaskItem;
  ptmitem,ptmitemold : TTaskItem;
begin
  p := ScreenToClient(Mouse.CursorPos);
  for n := 0 to IList.Count - 1 do
  begin
    pItem := TSharpETaskItem(IList.Items[n]);
    if PointInRect(p,Rect(pItem.Left,pItem.Top,pItem.Left + pItem.Width,pItem.Top + pItem.Height)) then
    begin
      if pItem <> FLastDragItem then
      begin
        ptmitem := TM.GetItemByHandle(pItem.Tag);
        if ptmitem <> nil then
        begin
          if (FLastDragMinimized) and (FLastDragItem <> nil) then
          begin
            ptmitemold := TM.GetItemByHandle(FLastDragItem.Tag);
            if ptmitemold <> nil then
               ptmitemold.Minimize;
          end;
          FLastDragMinimized := IsIconic(ptmitem.Handle);
          ptmitem.Restore;
          FLastDragItem := pItem;
        end;
      end;
      exit;
    end;
  end;
end;

end.
