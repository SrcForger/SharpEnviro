{
Source Name: MainWnd.pas
Description: TaskBar Module Main Form
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
 - OS : Windows XP

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
  Dialogs, StdCtrls, GR32_Image, SharpEBaseControls, 
  SharpESkinManager, SharpEScheme, SharpEButton, SharpESkin, ExtCtrls,
  JvSimpleXML, SharpApi, Jclsysinfo, Menus, Math, Contnrs,
  SharpETaskItem,
  uTaskManager,
  uTaskItem,
  shellhook,
  DateUtils,
  GR32,
  GR32_Filters;


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
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SystemSkinManager: TSharpESkinManager;
    FlashTimer: TTimer;
    ses_minall: TSharpEButton;
    ses_maxall: TSharpEButton;
    procedure ses_maxallClick(Sender: TObject);
    procedure ses_minallClick(Sender: TObject);
    procedure FlashTimerTimer(Sender: TObject);
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
    sMaxAllButton : boolean;
    sMinAllButton : boolean;
    sIFilter,sEFilter : Boolean;
    sIFilters,sEFilters : array of TTaskFilter;
    FLocked : boolean;
    FSpecialButtonWidth : integer;
  public
    TM: TTaskManager;
    IList: TObjectList;
    ModuleID : integer;
    BarWnd : hWnd;
    procedure InitHook;
    procedure CalculateItemWidth(ItemCount : integer);
    procedure AlignTaskComponents;
    procedure LoadSettings;
    procedure ReAlignComponents;
    procedure WMCommand(var msg: TMessage); message WM_COMMAND;
    procedure WMShellHook(var msg : TMessage); message WM_SHELLHOOK;
    procedure NewTask(pItem : TTaskItem; Index : integer);
    procedure RemoveTask(pItem : TTaskItem; Index : integer);
    procedure UpdateTask(pItem : TTaskItem; Index : integer);
    procedure ActivateTask(pItem : TTaskItem; Index : integer);
    procedure FlashTask(pItem : TTaskItem; Index : integer);
    procedure TaskExchange(pItem1,pItem2 : TTaskItem; n,i : integer);
    procedure SharpETaskItemClick(Sender: TObject);
    procedure OnTaskItemMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure DisplaySystemMenu(pHandle : hwnd);
    procedure GetSpacing;
    procedure CompleteRefresh;
    function CheckFilter(pItem : TTaskItem) : boolean;
    procedure CheckFilterAll;
    procedure LoadFilterSettingsFromXML;
    constructor CreateParented(ParentWindow : hwnd; pID : integer; pBarWnd : Hwnd; pHeight : integer);
    procedure AlignSpecialButtons;
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI;

var
  SysMenuHandle : hwnd;
  usend : boolean;

{$R *.dfm}

constructor TMainForm.CreateParented(ParentWindow : hwnd; pID : integer; pBarWnd : Hwnd; pHeight : integer);
begin
  Inherited CreateParented(ParentWindow);
  ModuleID := pID;
  BarWnd := pBarWnd;
  Height := pHeight;
end;

procedure TMainForm.WMCommand(var msg: TMessage);
begin
  PostMessage(SysMenuHandle, WM_SYSCOMMAND, msg.wparam, msg.lparam);
  inherited;
end;

procedure TMainForm.GetSpacing;
var
  r : TRect;
begin
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

  if (sAutoHeight > Height - 2) or (sAutoHeight <=0) then
     sAutoHeight := Height -2;
  if sMaxWidth <= 0 then sMaxWidth := 128;
end;

procedure TMainForm.AlignSpecialButtons;
var
  n : integer;
begin
  n := 0;
  if sMinAllButton then
  begin
    ses_minall.visible := True;
    ses_minall.Left := n;
    n := n + ses_minall.Width + 2;
  end else ses_minall.Visible := False;
  if sMaxAllButton then
  begin
    ses_maxall.Visible := True;
    ses_maxall.Left := n;
    n := n + ses_maxall.Width + 2;
  end else ses_maxall.Visible := False;
  FSpecialButtonWidth := n;
end;

procedure TMainForm.DisplaySystemMenu(pHandle : hwnd);
var
  cp: TPoint;
  AppMenu: hMenu;
begin
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

   TrackPopupMenu(AppMenu, tpm_leftalign or tpm_leftbutton, cp.x, cp.y, 0, Handle, nil);
end;

procedure TMainForm.OnTaskItemMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if not (Sender is TSharpETaskItem) then exit;
  if Button = mbRight then DisplaySystemMenu(TSharpETaskItem(Sender).Tag);
end;

procedure IconToImage(Bmp : TBitmap32; const icon : hicon);
var
   w,h,i    : Integer;
   p        : PColorArray;
   p2       : pColor32;
   bmi      : BITMAPINFO;
   AlphaBmp : Tbitmap32;
   tempbmp  : Tbitmap;
   info     : Ticoninfo;
   alphaUsed : boolean;
begin
     Alphabmp := nil;
     tempbmp := Tbitmap.Create;
//     dc := createcompatibledc(0);
     try
        //get info about icon
        GetIconInfo(icon,info);
        tempbmp.handle := info.hbmColor;
        ///////////////////////////////////////////////////////
        // Here comes a ugly step were it tries to paint it as
        // a 32 bit icon and check if it is successful.
        // If failed it will paint it as an icon with fewer colors.
        // No way of deciding bitcount in the beginning has been
        // found reliable , try if you want too.   /Malx
        ///////////////////////////////////////////////////////
        AlphaUsed := false;
        if true then
        begin //32-bit icon with alpha
              w := tempbmp.Width;
              h := tempbmp.Height;
              Bmp.setsize(w,h);
              with bmi.bmiHeader do
              begin
                   biSize := SizeOf(bmi.bmiHeader);
                   biWidth := w;
                   biHeight := -h;
                   biPlanes := 1;
                   biBitCount := 32;
                   biCompression := BI_RGB;
                   biSizeImage := 0;
                   biXPelsPerMeter := 1; //dont care
                   biYPelsPerMeter := 1; //dont care
                   biClrUsed := 0;
                   biClrImportant := 0;
              end;
              GetMem(p,w*h*SizeOf(TColorRec));
              GetDIBits(tempbmp.Canvas.Handle,tempbmp.Handle,0,h,p,bmi,DIB_RGB_COLORS);
              P2 := Bmp.PixelPtr[0, 0];
              for i := 0 to w*h-1 do
              begin
                   if (p[i].a > 0) then alphaused := true;
                   P2^ := color32(p[i].r,p[i].g,p[i].b,p[i].a);
                   Inc(P2);// proceed to the next pixel
              end;
              FreeMem(p);
        end;
        if not(alphaused) then
        begin // 24,16,8,4,2 bit icons
              Bmp.Assign(tempbmp);
              AlphaBmp := Tbitmap32.Create;
              tempbmp.handle := info.hbmMask;
              AlphaBmp.Assign(tempbmp);
              Invert(AlphaBmp,AlphaBmp);
              Intensitytoalpha(Bmp,AlphaBmp);
        end;
     finally
//            DeleteDC(dc);
            AlphaBmp.free;
            DeleteObject(info.hbmMask);
            DeleteObject(info.hbmColor);
            tempbmp.free;
     end;
end;

procedure LoadFilterFromXML(var filter : TTaskFilter; XML : TJvSimpleXMLElem);
var
  n : integer;
begin
  filter.FilterType := XML.Items.IntValue('FilterType',2);
  filter.FilterClass := XML.Items.Value('WndClassName');
  filter.FilterFile  := XML.Items.Value('FileName');
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
  item,fitem : TJvSimpleXMLElem;
  n : integer;
begin
  sState     := tisFull;
  sWidth     := 100;
  sMaxwidth  := 128;
  sSpacing   := 2;
  sSort      := False;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
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
  if length(sEFilters) = 0 then sEFilter := False;
  if length(sIFilters) = 0 then sIFilter := False;
  if (sIFilter) or (sEFilter) then LoadFilterSettingsFromXML;

  TM.SortTasks := sSort;
  TM.SortType := sSortType;

  LockWindowUpdate(Handle);
  FLocked := True;

  AlignSpecialButtons;
  GetSpacing;
  if TM.SortTasks then TM.DoSortTasks;
  CompleteRefresh;
  ReAlignComponents;

  LockWindowUpdate(0);
  FLocked := False;
end;

procedure TMainForm.CompleteRefresh;
begin
  LockWindowUpdate(Handle);
  try
    IList.Clear;
    TM.CompleteRefresh;
    AlignTaskComponents;
  finally
    if not FLocked then LockWindowUpdate(0);
  end;
end;

procedure TMainForm.ReAlignComponents;
var
  FreeBarSpace : integer;
  newWidth,oWidth : integer;
begin
  if IList.Count <=0 then
  begin
    Width := 1;
    if not usend then
    begin
      usend := True;
      SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
      usend := False;
    end;
    exit;
  end;

  LockWindowUpdate(Handle);
  FLocked := True;
  try
    GetSpacing;
    CalculateItemWidth(IList.Count);
    NewWidth := FSpecialButtonWidth + IList.Count * sCurrentWidth + (IList.Count - 1) * sSpacing;
    FreeBarSpace := GetFreeBarSpace(BarWnd) + self.Width;
    if NewWidth > FreeBarSpace then
    begin
      CalculateItemWidth(IList.Count);
      NewWidth := FSpecialButtonWidth + IList.Count * sCurrentWidth + (IList.Count - 1) * sSpacing;
    end;
    if Width <> NewWidth then
    begin
      if NewWidth < 0 then NewWidth := 1;
      self.Width := NewWidth;
      AlignTaskComponents;
      SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
    end;
  finally
    FLocked := False;
    LockWindowUpdate(0);
  end;
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item,fitem : TJvSimpleXMLElem;
  n,i : integer;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
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
      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        clear;
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
      uSharpBarAPI.SaveXMLFile(BarWnd);
      LoadSettings;
    end;
  finally
    SettingsForm.Free;
    SettingsForm := nil;
    SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
  end;
end;

procedure TMainForm.CalculateItemWidth(ItemCount : integer);
var
  n : integer;
  FreeSpace : integer;
begin
  for n := 0 to IList.Count -1 do
      TSharpETaskItem(IList.Items[n]).State := sState;
  FreeSpace := GetFreeBarSpace(BarWnd) + self.Width - FSpecialButtonWidth;
  if ItemCount = 0 then sCurrentWidth := 16
     else sCurrentWidth := Max(Min((FreeSpace - ItemCount*sSpacing) div ItemCount,sMaxWidth),16);
end;

procedure TMainForm.AlignTaskComponents;
var
  n : integer;
  pTaskItem : TSharpETaskItem;
begin
  LockWindowUpdate(Handle);
  try
    for n := 0 to IList.Count -1 do
    begin
      pTaskItem := TSharpETaskItem(IList.Items[n]);
      if sCurrentWidth < sMaxWidth then
      begin
        pTaskItem.AutoSize := False;
        pTaskItem.Width := sCurrentWidth;
        pTaskItem.Height := sAutoHeight;
        pTaskItem.Left := FSpecialButtonWidth + n*sCurrentWidth + n*sSpacing;
      end else
      begin
        pTaskItem.AutoSize := True;
        pTaskItem.Left := FSpecialButtonWidth + n*sMaxWidth + n*sSpacing;
      end;
    end;
  finally
    if not FLocked then LockWindowUpdate(0);
  end;
end;

procedure UpdateIcon(var pTaskItem : TSharpETaskItem; pItem : TTaskItem);
var
  bmp : TBitmap32;
begin
  if (pTaskItem = nil) or (pItem = nil) then exit;
  bmp := TBitmap32.Create;
  try
    IconToImage(bmp,pItem.Icon);
    if (bmp.Width <> 0) and (bmp.Height <> 0) then
       pTaskItem.Glyph32.Assign(bmp);
  finally
    bmp.Free;
  end;
end;

procedure TMainForm.CheckFilterAll;
var
  n,i : integer;
  pTaskItem : TSharpETaskItem;
  pItem : TTaskItem;
begin
  if (sIFilter = False) and (sEFilter = False) then exit;

  pTaskItem := nil;
  for i := 0 to TM.GetCount do
  begin
    pItem := TM.GetItemByIndex(i);
    if pItem <> nil then
    begin
      for n := 0 to IList.Count - 1 do
      if TSharpETaskItem(IList.Items[n]).Tag = pItem.Handle then
      begin
        pTaskItem := TSharpETaskItem(IList.Items[n]);
        break;
      end;
      if pTaskItem = nil then
         if CheckFilter(pItem) then NewTask(pItem,i);
    end;
  end;

end;

function TMainForm.CheckFilter(pItem : TTaskItem) : boolean;
var
  n : integer;
begin
  if (sIFilter = False) and (sEFilter = False) then
  begin
    result := true;
    exit;
  end;

  result := false;
  if sIFilter then
  begin
    for n:=0 to High(sIFilters) do
    begin
      case sIFilters[n].FilterType of
        0: if pItem.Placement.showCmd in sIFilters[n].FilterStates then result := true;
        1: if pItem.WndClass = sIFilters[n].FilterClass then result := true;
        2: if pItem.FileName = sIFilters[n].FilterFile then result := true;
      end;
    end;
  end else result := true;

  if sEFilter then
  begin
    for n:=0 to High(sEFilters) do
    begin
      case sEFilters[n].FilterType of
        0: if pItem.Placement.showCmd in sEFilters[n].FilterStates then result := false;
        1: if pItem.WndClass = sEFilters[n].FilterClass then result := false;
        2: if pItem.FileName = sEFilters[n].FilterFile then result := false;
      end;
    end;
  end;
end;

procedure TMainForm.FlashTask(pItem : TTaskItem; Index : integer);
var
  n : integer;
  pTaskItem : TSharpETaskItem;
begin
  for n := 0 to IList.Count -1 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    if pTaskItem.Tag = pItem.Handle then
    begin
      if pTaskItem.Down then exit;
      pTaskItem.Flashing := True;
      if not FlashTimer.Enabled then FlashTimer.Enabled := True;
      exit;
    end;
  end;
end;

procedure TMainForm.ActivateTask(pItem : TTaskItem; Index : integer);
var
  n : integer;
  pTaskItem : TSharpETaskItem;
begin
  pTaskItem := nil;
  CheckFilterAll;

  for n := 0 to IList.Count -1 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    if (pItem.Handle <> pTaskItem.Tag ) and (pTaskItem.Down) then
       pTaskItem.Down := False
       else if pItem.Handle = pTaskItem.Tag then
       begin
         pTaskItem.Down := True;
         if pTaskItem.Flashing then pTaskItem.Flashing := False;
         UpdateIcon(pTaskItem,pItem);
         pTaskItem.Repaint;
       end;
  end;
end;

procedure TMainForm.NewTask(pItem : TTaskItem; Index : integer);
var
  pTaskItem : TSharpETaskItem;
  oWidth : integer;
begin
  if not CheckFilter(pItem) then exit;
  pTaskItem := TSharpETaskItem.Create(self);
  oWidth := sCurrentWidth;
  CalculateItemWidth(IList.Count + 1);
  if oWidth <> sCurrentWidth then
     AlignTaskComponents;
  IList.Add(pTaskItem);
  pTaskItem.Width := sCurrentWidth;
  pTaskItem.Parent := Background;
  pTaskItem.SkinManager := SystemSkinManager;
  pTaskItem.Left := FSpecialButtonWidth + (IList.Count-1) * sCurrentWidth + (IList.Count - 2) * sSpacing;
  pTaskItem.AutoPosition := True;
  pTaskItem.AutoSize := True;
  pTaskItem.Margin := 0;
  pTaskItem.Flashing := False;
  pTaskItem.Caption := pItem.Caption;
  pTaskItem.Tag := pItem.Handle;
  pTaskItem.State := sState;
  UpdateIcon(pTaskItem,pItem);
  pTaskItem.OnClick := SharpETaskItemClick;
  pTaskItem.OnMouseUp := OnTaskItemMouseUp;
  pTaskItem.Show;
  ReAlignComponents;
end;

procedure TMainForm.TaskExchange(pItem1,pItem2 : TTaskItem; n,i : integer);
var
  index1,index2 : integer;
begin
  index1 := -1;
  index2 := -1;
  for n:= 0 to IList.Count - 1 do
  begin
    if TSharpETaskItem(IList.Items[n]).Tag = pItem1.Handle then index1 := n;
    if TSharpETaskItem(IList.Items[n]).Tag = pItem2.Handle then index2 := n;
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
  for n := IList.Count -1 downto 0 do
      if TSharpETaskItem(IList.Items[n]).Tag = pItem.Handle then
         IList.Delete(n);
  CalculateItemWidth(IList.Count);
  ReAlignComponents;
end;

procedure TMainForm.UpdateTask(pItem : TTaskItem; Index : integer);
var
  pTaskItem : TSharpETaskItem;
  n : integer;
begin
  CheckFilterAll;
  pTaskItem := nil;
  for n := 0 to IList.Count - 1 do
      if TSharpETaskItem(IList.Items[n]).Tag = pItem.Handle then
      begin
        pTaskItem := TSharpETaskItem(IList.Items[n]);
        break;
      end;
  if pTaskItem = nil then
  begin
    if CheckFilter(pItem) then NewTask(pItem,Index);
    exit;
  end else if not CheckFilter(pItem) then
  begin
    RemoveTask(pItem,Index);
    exit;
  end;

  UpdateIcon(pTaskItem,pItem);
  pTaskItem.Caption := pItem.Caption;
end;

procedure TMainForm.SharpETaskItemClick(Sender: TObject);
var
  pItem : TTaskItem;
begin
  if Sender = nil then exit;
  if not (Sender is TSharpETaskItem) then exit;
  try
    pItem := TM.GetItemByHandle(TSharpETaskItem(Sender).Tag);
  except
    exit;
  end;
  if pItem <> nil then
  begin
    pItem.UpdateVisibleState;
    if (not pItem.Visible) or (not TSharpETaskItem(Sender).Down) then
    begin
      pItem.Restore;
    	BringWindowToTop(pItem.Handle);
      SetActiveWindow(pItem.Handle);
      SetForegroundWindow(pItem.Handle);
    end else
    begin
      TSharpETaskItem(Sender).Down := False;
      pItem.Minimize;
    end;
  end;
end;

procedure TMainForm.WMShellHook(var msg : TMessage);
begin
 //Hide;
 if msg.LParam = self.Handle then exit;
 case msg.WParam of
   M_NEWTASK       : TM.AddTask(msg.LParam);
   M_CAPTIONUPDATE : TM.UpdateTask(msg.LParam);
   M_TASKFLASHING  : TM.FlashTask(msg.LParam);
   M_DELTASK       : TM.RemoveTask(msg.LParam);
   M_ACTIVATETASK  : TM.ActivateTask(msg.LParam);
   M_GETMINRECT    : TM.UpdateTask(msg.LParam);
  end;

//    :
// M_TASKFLASHING
// end;
end;

procedure TMainForm.InitHook;
begin
  PostMessage(BarWnd,WM_REGISTERSHELLHOOK,ModuleID,0);
  CalculateItemWidth(IList.Count);
  AlignTaskComponents;
  ReAlignComponents;
end;

procedure TMainForm.FormCreate(Sender: TObject);

  function EnumWindowsProc(Wnd: HWND; LParam: LPARAM): BOOL; stdcall;
  var
    buffer : array[0..254] of Char;
    buffer2 : array[0..254] of Char;
    icon : hicon;
  begin
    if (GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) and
       ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
       ((GetWindowLong(Wnd, GWL_HWNDPARENT) = 0) or
       (GetWindowLong(Wnd, GWL_HWNDPARENT) = GetDesktopWindow)) and
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0))  then
    begin
      TM.AddTask(wnd);
    end;
    result := True;
  end;

begin
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

  InitHook;
  LoadSettings;

  EnumWindows(@EnumWindowsProc, 0);
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
  TM.Free;
  IList.Clear;
  IList.Free;
  PostMessage(BarWnd,WM_UNREGISTERSHELLHOOK,self.handle,0);
end;

procedure TMainForm.FlashTimerTimer(Sender: TObject);
var
  fc,n : integer;
  pTaskItem : TSharpETaskItem;
begin
  fc := 0;
  for n := 0 to IList.Count -1 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    if pTaskItem.Flashing then
    begin
      fc := fc + 1;
      pTaskItem.FlashState := not pTaskItem.FlashState;
    end;
  end;
  if fc = 0 then FlashTimer.Enabled := False;
end;

procedure TMainForm.ses_minallClick(Sender: TObject);
var
  n : integer;
  pTaskItem : TSharpETaskItem;
  pItem : TTaskItem;
begin
  for n := IList.Count -1 downto 0 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    pItem := TTaskItem(TM.GetItemByHandle(pTaskItem.Tag));
    if pItem <> nil then
       pItem.Minimize;
  end;
end;

procedure TMainForm.ses_maxallClick(Sender: TObject);
var
  n : integer;
  pTaskItem : TSharpETaskItem;
  pItem : TTaskItem;
begin
  for n := IList.Count -1 downto 0 do
  begin
    pTaskItem := TSharpETaskItem(IList.Items[n]);
    pItem := TTaskItem(TM.GetItemByHandle(pTaskItem.Tag));
    if pItem <> nil then
       pItem.Restore;
  end;
end;

end.
