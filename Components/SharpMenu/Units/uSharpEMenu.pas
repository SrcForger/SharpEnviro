{
Source Name: uSharpEMenu.pas
Description: SharpE Menu Class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.sharpe-shell.net

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

unit uSharpEMenu;

interface

uses SysUtils,Contnrs,GR32,Classes,Dialogs,
     SharpESkinManager,
     uSharpEMenuIcons,
     uSharpEMenuItem,
     uSharpEMenuActions,
     uSharpEMenuConsts;

type
  TSharpEMenu = class
  private
    FSkinManager  : TSharpESkinManager;
    FMenuActions  : TSharpEMenuActions;
    FMenuConsts   : TSharpEMenuConsts;
    FItems : TObjectList;
    FBackground : TBitmap32;
    FNormalMenu : TBitmap32;
    FItemIndex : integer;
    FItemWidth : integer;
    FItemsHeight : array of integer;
    FMouseDown : boolean;
    procedure UpdateItemWidth;
    procedure UpdateItemsHeight;
    procedure ImageCheck(var pbmp : TBitmap32; pSize : TPoint);
    procedure RenderMenuItem(Dst : TBitmap32; px,py : integer;
                             pitem : TObject; state : TSharpEMenuItemState);
    function GetCurrentItem : TSharpEMenuItem;
  public
    constructor Create(pManager  : TSharpESkinManager); reintroduce;
    destructor Destroy; override;
    procedure AddSeparatorItem(pDynamic : boolean);
    procedure AddLabelItem(pCaption : String; pDynamic : boolean);
    function AddLinkItem(pCaption,pTarget,pIcon : String; pDynamic : boolean) : TObject; overload;
    function AddLinkItem(pCaption,pTarget,pIconName : String; pIcon : TBitmap32; pDynamic : boolean) : TObject; overload;
    procedure AddDynamicDirectoryItem(pTarget : String; pMax,pSort : integer; pFilter : String;  pDynamic : boolean);
    procedure AddDriveListItem(pDynamic : boolean);
    function  AddSubMenuItem(pCaption,pIcon,pTarget : String; pDynamic : boolean) : TObject;
    procedure RenderBackground;
    procedure RenderNormalMenu;
    procedure RenderTo(Dst : TBitmap32);
    function GetItemsHeight(pindex : integer) : integer;
    function PerformMouseMove(px,py : integer; var submenu : boolean) : boolean;
    function PerformMouseDown : boolean;
    function PerformMouseUp : boolean;
    function PerformClick : boolean;
    procedure RefreshDynamicContent;
    procedure RecycleBitmaps;
    property ItemIndex  : integer read FItemIndex write FItemIndex;
    property CurrentItem : TSharpEMenuItem read GetCurrentItem;
    property Background : TBitmap32 read FBackground;
    property NormalMenu : TBitmap32 read FNormalMenu;
    property SkinManager : TSharpESkinManager read FSkinManager;
    property Items : TObjectList read FItems;
  end;

var
  SharpEMenuIcons : TSharpEMenuIcons;

implementation

uses Math,
     SharpESkin,
     SharpESkinPart,
     uSharpEMenuWnd;

constructor TSharpEMenu.Create(pManager  : TSharpESkinManager);
begin
  inherited Create;

  FMenuActions := TSharpEMenuActions.Create(self);
  FMenuConsts  := TSharpEMenuConsts.Create;

  FSkinManager := pManager;
  FMouseDown := False;
  FItemIndex := -1;
  FItems := TObjectList.Create;
  FItems.Clear;

  if SharpEMenuIcons = nil then
     SharpEMenuIcons := TSharpEMenuIcons.Create;
end;

destructor TSharpEMenu.Destroy;
var
  n : integer;
begin
  for n := FItems.Count - 1 downto 0 do
      FItems.Delete(n);
  FreeAndNil(FItems);
  FreeAndNil(FMenuActions);
  FreeAndNil(FMenuConsts);
  if SharpEMenuIcons.Items.Count = 0 then
     FreeAndNil(SharpEMenuIcons);
  if FBackground <> nil then
     FreeAndNil(FBackground);
  if FNormalMenu <> nil then
     FreeAndNil(FNormalMenu);

  inherited Destroy;
end;

procedure TSharpEMenu.RecycleBitmaps;
begin
  FreeAndNil(FBackground);
  FreeAndNil(FNormalMenu);
end;

function DynSort(Item1 : Pointer; Item2 : Pointer) : integer;
var
 I1,I2 : TSharpEMenuItem;
 d1,d2 : string;
begin
  I1 := TSharpEMenuItem(Item1);
  I2 := TSharpEMenuItem(Item2);
  if (I1.isDynamic) and (not I2.isDynamic) then
     result := 1
     else if (not I1.isDynamic) and (I2.isDynamic) then
     result := -1
     else if (I1.isDynamic) and (I2.isDynamic) and (I1.ItemType = mtSubMenu) and (I2.ItemType <> I1.ItemType) then
     result := -1
     else if (I1.isDynamic) and (I2.isDynamic) and (I2.ItemType = mtSubMenu) and (I2.ItemType <> I1.ItemType) then
     result := 1
     else if (I1.isDynamic) and (I2.isDynamic) and (I1.ItemType = I2.ItemType) then
     begin
       if (I1.PropList.GetInt('Sort') > 0) and (I2.PropList.GetInt('Sort') > 0) then
       begin
         d1 := I1.PropList.GetString('SortData');
         d2 := I2.PropList.GetString('SortData');
         result := CompareText(d2,d1);
       end else result := CompareText(I1.Caption,I2.Caption);
     end
     else result := I1.ListIndex - I2.ListIndex;
end;

procedure TSharpEMenu.RefreshDynamicContent;
var
  FDynList : TObjectList;
  item : TSharpEMenuItem;
  n : integer;
begin
  FDynList := TObjectList.Create;
  FDynList.OwnsObjects := False;
  FDynList.Clear;

  // Build a list of all dynamic items
  for n := 0 to FItems.Count - 1 do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    if item.isDynamic then
       FDynList.Add(item);
  end;

  // Find all items which are creating dynamic items
  for n := 0 to FItems.Count - 1 do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    case item.ItemType of
      mtDynamicDir : FMenuActions.UpdateDynamicDirectory(FDynList,
                                                         item.PropList.GetString('Action'),
                                                         item.PropList.GetString('Filter'),
                                                         item.PropList.GetInt('Sort'),
                                                         item.PropList.GetInt('MaxItems'));
      mtDriveList : FMenuActions.UpdateDynamicDriveList(FDynList);
    end;
  end;

  // Check which items are left in FDynList and remove them
  for n := FDynList.Count - 1 downto 0 do
  begin
    item := TSharpEMenuItem(FDynList.Items[n]);
    FItems.Remove(item);
  end;

  for n := 0 to FItems.Count - 1 do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    item.ListIndex := n;
  end;

  FItems.Sort(DynSort);

  FDynList.Free;
end;

procedure TSharpEMenu.AddLabelItem(pCaption : String; pDynamic : boolean);
var
  item : TSharpEMenuItem;
begin
  item := TSharpEMenuItem.Create(mtLabel);
  item.isDynamic := False;
  item.Icon := nil;
  item.Caption := pCaption;
  FItems.Add(item);
end;

procedure TSharpEMenu.AddSeparatorItem(pDynamic : boolean);
var
  item : TSharpEMenuItem;
begin
  item := TSharpEMenuItem.Create(mtSeparator);
  item.isDynamic := pDynamic;
  item.icon := nil;
  FItems.Add(Item);
end;

function TSharpEMenu.AddLinkItem(pCaption,pTarget,pIconName : String; pIcon : TBitmap32; pDynamic : boolean) : TObject;
var
  item : TSharpEMenuItem;
begin
  pTarget := FMenuConsts.ParseString(pTarget);
  item := TSharpEMenuItem.Create(mtLink);
  item.Icon := SharpEMenuIcons.AddIcon(pIconName,pIcon);
  item.Caption := pCaption;
  item.PropList.Add('Action',pTarget);
  item.OnClick := FMenuActions.OnLinkClick;
  item.isDynamic := pDynamic;
  FItems.Add(Item);
  result := item;
end;

function TSharpEMenu.AddLinkItem(pCaption,pTarget,pIcon : String; pDynamic : boolean) : TObject;
var
  item : TSharpEMenuItem;
begin
  pTarget := FMenuConsts.ParseString(pTarget);
  pIcon   := FMenuConsts.ParseString(pIcon);
  item := TSharpEMenuItem.Create(mtLink);
  item.Icon := SharpEMenuIcons.AddIcon(pIcon,pTarget);
  item.Caption := pCaption;
  item.PropList.Add('Action',pTarget);
  item.OnClick := FMenuActions.OnLinkClick;
  item.isDynamic := pDynamic;
  FItems.Add(Item);
  result := item;
end;

function TSharpEMenu.AddSubMenuItem(pCaption,pIcon,pTarget : String; pDynamic : boolean) : TObject;
var
  item : TSharpEMenuItem;
begin
  pTarget := FMenuConsts.ParseString(pTarget);
  pIcon   := FMenuConsts.ParseString(pIcon);
  item := TSharpEMenuItem.Create(mtSubMenu);
  item.Icon := SharpEMenuIcons.AddIcon(pIcon,pTarget);
  item.Caption := pCaption;
  item.isDynamic := pDynamic;
  FItems.Add(Item);
  result := Item;
end;

procedure TSharpEMenu.AddDynamicDirectoryItem(pTarget : String; pMax,pSort : integer; pFilter : String; pDynamic : boolean);
var
  item : TSharpEMenuItem;
begin
  item := TSharpEMenuItem.Create(mtDynamicDir);
  item.Icon := nil;
  item.PropList.Add('Action',FMenuConsts.ParseString(pTarget));
  item.PropList.Add('MaxItems',pMax);
  item.PropList.Add('Sort',pSort);
  item.isVisible := False;
  item.isDynamic := pDynamic;
  FItems.Add(Item);
end;

procedure TSharpEMenu.AddDriveListItem(pDynamic : boolean);
var
  item : TSharpEMenuItem;
begin
  item := TSharpEMenuItem.Create(mtDriveList);
  item.Icon := nil;
  item.isVisible := False;
  item.isDynamic := pDynamic;
  FItems.Add(Item);
end;


// Calculate overall items size until pindex (-1 = all)
function TSharpEMenu.GetItemsHeight(pindex : integer) : integer;
var
  n : integer;
  size : integer;
begin
  size := 0;
  if (pindex < 0) or (pindex > High(FItemsHeight)) then
     pindex := High(FItemsHeight);

  for n := 0 to pindex do
      size := size + FItemsHeight[n];
  result := size;
end;

// Calculate the height of the menu and store the result as array in FItemsHeight
procedure TSharpEMenu.UpdateItemsHeight;
var
  n,i : integer;
  menuitemskin : TSharpEMenuItemSkin;
  item : TSharpEMenuItem;
begin
  if (FSkinManager = nil) or (FItems.Count = 0) then
  begin
    setlength(FItemsHeight,0);
    exit;
  end;

  menuitemskin := FSkinManager.Skin.MenuItemSkin;
  setlength(FItemsHeight,0);
  for n:= 0 to FItems.Count -1 do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    setlength(FItemsHeight,length(FItemsHeight) + 1);
    if item.isVisible then
    begin
      case item.ItemType of
        mtLabel    : i := menuitemskin.LabelItem.SkinDim.HeightAsInt;
        mtSeparator: i := menuitemskin.Separator.SkinDim.HeightAsInt;
        mtSubMenu  : i := menuitemskin.NormalSubItem.SkinDim.HeightAsInt;
        else         i := menuitemskin.NormalItem.SkinDim.HeightAsInt;
      end;
    end else i := 0;
    FItemsHeight[High(FItemsHeight)] := i;
  end;
end;

// Calculate the max item width for all menu items and store result in FItemWidth
procedure TSharpEMenu.UpdateItemWidth;
var
  n,i : integer;
  item : TSharpEMenuItem;
  size : integer;
  maxitemtext : integer;
  maxsize : integer;
  temp : TBitmap32;
  menuskin : TSharpEMenuSkin;
  menuitemskin : TSharpEMenuItemSkin;
begin
  size := 255;

  if FSkinManager = nil then
  begin
    FItemWidth := size;
    exit;
  end;
  
  menuitemskin := FSkinManager.Skin.MenuItemSkin;
  menuskin := FSkinManager.Skin.MenuSkin;
  temp := TBitmap32.Create;
  try
    menuitemskin.NormalItem.SkinText.AssignFontTo(temp.font,FSkinManager.Scheme);
    size := menuskin.WidthLimit.XAsInt;
    maxsize := menuskin.WidthLimit.YAsInt;
    maxitemtext := menuitemskin.NormalItem.SkinText.GetMaxWidth(Rect(0,0,maxsize,64));
    for n:= 0 to FItems.Count -1 do
    begin
      item := TSharpEMenuItem(FItems.Items[n]);
      if item.isVisible then
      begin
        i := Min(maxitemtext,temp.TextWidth(item.Caption)) + menuitemskin.NormalItem.WidthMod;
        if (i>size) then
           size := i;
        if (size > maxsize) then
        begin
          size := maxsize;
          break;
        end;
      end;
    end;
  finally
    temp.free;
  end;
  FItemWidth := size;
end;

// Check if a Bmp is nil... if nil then create a new Bitmap and initialize it with pSize
procedure TSharpEMenu.ImageCheck(var pbmp : TBitmap32; pSize : TPoint);
begin
  if (pbmp <> nil) then exit;
  pbmp := TBitmap32.Create;
  pbmp.DrawMode := dmBlend;
  pbmp.CombineMode := cmMerge;
  pbmp.SetSize(Max(pSize.x,1),Max(pSize.y,1));
  pbmp.Clear(color32(0,0,0,0));
end;

function TSharpEMenu.GetCurrentItem : TSharpEMenuItem;
begin
  if (FItemIndex > -1) and (FItemIndex < FItems.Count) then
  begin
    result := TSharpEMenuItem(FItems.Items[FItemIndex]);
  end else result := nil;
end;

procedure TSharpEMenu.RenderBackground;
var
  w,h : integer;
  menuskin : TSharpEMenuSkin;
begin
  ImageCheck(FBackground,Point(255,32));
  if FSkinManager = nil then exit;

  UpdateItemWidth;
  UpdateItemsHeight;

  menuskin := FSkinManager.Skin.MenuSkin;

  w := Max(8,FItemWidth);
  h := Max(8,GetItemsHeight(-1));

  // add Left/Right and Top/Bottom offsets to menu size;
  w := w + menuskin.LROffset.XAsInt + menuskin.LROffset.YAsInt;
  h := h + menuskin.TBOffset.XAsInt + menuskin.TBOffset.YAsInt;

  FBackground.SetSize(w,h);
  FBackground.Clear(color32(0,0,0,0));

  menuskin.Background.draw(FBackground,FSkinManager.Scheme);
end;

procedure TSharpEMenu.RenderMenuItem(Dst : TBitmap32; px,py : integer;
                             pitem : TObject; state : TSharpEMenuItemState);
var
  temp : TBitmap32;
  icon : TBitmap32;
  text : TBitmap32;
  item : TSharpEMenuItem;
  Ipos : TPoint;
  DIcon : boolean;
  Tpos : TPoint;
  DText : boolean;
  drawpart : TObject;
  menuitemskin : TSharpEMenuItemSkin;
  w,h : integer;
begin
  if FSkinManager = nil then exit;
  if Dst = nil then exit;

  item := TSharpEMenuItem(pItem);

  if assigned(item.OnPaint) then
  begin
    item.OnPaint(Dst,px,py,item,state);
    exit;
  end;

  menuitemskin := FSkinManager.Skin.MenuItemSkin;
  w := FItemWidth;

  temp := TBitmap32.Create;
  icon := TBitmap32.Create;
  text := TBitmap32.Create;
  temp.DrawMode := dmBlend;
  icon.DrawMode := dmBlend;
  text.DrawMode := dmBlend;
  temp.CombineMode := cmMerge;
  icon.CombineMode := cmMerge;
  text.CombineMode := cmMerge;
  try
    h := 8;
    case item.ItemType of
      mtLabel     : drawpart := menuitemskin.LabelItem;
      mtSeparator : drawpart := menuitemskin.Separator;
      mtSubMenu   : begin
                      case state of
                        msHover,msDown : drawpart := menuitemskin.HoverSubItem;
                        else             drawpart := menuitemskin.NormalSubItem;
                      end;
                    end;
      else          begin
                      case state of
                        msHover : drawpart := menuitemskin.HoverItem;
                        msDown  : drawpart := menuitemskin.DownItem;
                        else      drawpart := menuitemskin.NormalItem;
                      end;
                    end;
    end;
    icon.Clear(color32(0,0,0,0));
    text.Clear(color32(0,0,0,0));
    dicon := False;
    dtext := False;
    if (drawpart is TSkinPartEx) then
    begin
      with drawpart as TSkinPartEx do
      begin
        h := SkinDim.HeightAsInt;
        if (item.Icon <> nil) and (SkinIcon.DrawIcon) then
        begin
          icon.setsize(SkinIcon.WidthAsInt,SkinIcon.HeightAsInt);
          icon.Clear(color32(0,0,0,0));
          item.Icon.Icon.DrawTo(icon,Rect(0,0,icon.width,icon.height));
          dicon := true;
          Ipos.X := SkinIcon.XAsInt;
          Ipos.Y := SkinIcon.YAsInt;
        end;
        if (length(item.Caption)>0) and (SkinText.DrawText) then
        begin
          text.SetSize(w,h);
          text.clear(color32(0,0,0,0));
          SkinText.AssignFontTo(text.Font,FSkinManager.Scheme);
          Tpos := SkinText.GetXY(Rect(0, 0, text.TextWidth(item.Caption), text.TextHeight(item.Caption)),
                                 Rect(0, 0, w, h));
          SkinText.RenderTo(text,Tpos.x,Tpos.y,item.Caption,FSkinManager.Scheme);
          dtext := true;
        end;
      end;
    end
    else if (drawpart is TSkinPart) then
            h := TSkinPart(drawpart).SkinDim.HeightAsInt;
    temp.SetSize(w,h);
    temp.Clear(color32(0,0,0,0));
    TSkinPart(drawpart).draw(temp,FSkinManager.Scheme);
    temp.DrawTo(dst,px,py);
    if dicon then
       icon.DrawTo(dst,px+IPos.x,py+IPos.y);
    if dtext then
       text.DrawTo(dst,px,py);
  finally
    FreeAndNil(temp);
    FreeAndNil(icon);
    FreeAndNil(text);
  end;
end;

procedure TSharpEMenu.RenderNormalMenu;
var
  item : TSharpEMenuItem;
  n : integer;
  w,h : integer;
  dh : integer;
begin
  ImageCheck(FNormalMenu,Point(255,32));
  if FSkinManager = nil then exit;

  w := FItemWidth;
  h := Max(1,GetItemsHeight(-1));

  FNormalMenu.SetSize(w,h);
  FNormalMenu.Clear(color32(0,0,0,0));

  dh := 0;
  try
    for n := 0 to FItems.Count - 1 do
    begin
      item := TSharpEMenuItem(FItems.Items[n]);
      if item.isVisible then
         RenderMenuItem(FNormalMenu,0,dh,item,msNormal);
      dh := dh + FItemsHeight[n];
    end;
  finally
  end;
end;

procedure TSharpEMenu.RenderTo(Dst : TBitmap32);
var
  menuskin : TSharpEMenuSkin;
  temp : TBitmap32;
  n : integer;
  y : integer;
begin
  if (FSkinManager = nil) then exit;
  if (FBackground = nil) then RenderBackground;
  if (FNormalMenu = nil) then RenderNormalMenu;

  menuskin := FSkinManager.Skin.MenuSkin;
  Dst.Assign(FBackground);
  Dst.clear(color32(0,0,0,0));
  FBackground.DrawTo(Dst);

  temp := TBitmap32.Create;
  temp.assign(FNormalMenu);
  y := 0;
  try
    for n := 0 to High(FItemsHeight) do
    begin
      if (n = FItemIndex) and (TSharpEMenuItem(FItems.Items[n]).isVisible) then
      begin
        temp.DrawMode := dmOpaque;
        temp.FillRect(0,y,FItemWidth,y+FItemsHeight[n],color32(0,0,0,0));
        if FMouseDown then RenderMenuItem(temp,0,y,TSharpEMenuItem(FItems.Items[n]),msDown)
           else RenderMenuItem(temp,0,y,TSharpEMenuItem(FItems.Items[n]),msHover);
        temp.DrawMode := dmBlend;
        break;
      end;
      y := y + FItemsHeight[n];
    end;
    temp.DrawTo(Dst,menuskin.LROffset.XAsInt,menuskin.TBOffset.XAsInt);
  finally
    temp.Free;
  end;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

function TSharpEMenu.PerformClick : boolean;
var
  item : TSharpEMenuItem;
  CanClose : boolean;
begin
  if (FItemIndex > -1) and (FItemIndex < FItems.Count) then
  begin
    item := TSharpEMenuItem(FItems.Items[FItemIndex]);
    if assigned(item.OnClick) then
    begin
      CanClose := False;
      item.OnClick(item,CanClose);
      result := CanClose;
      exit;
    end;
  end;
  result := false;
end;

function TSharpEMenu.PerformMouseDown : boolean;
begin
  if (FItemIndex > -1) and (FItemIndex < FItems.Count) then
  begin
    FMouseDown := True;
    result := true;
  end else result := false;
end;

function TSharpEMenu.PerformMouseUp : boolean;
begin
  if (FItemIndex > -1) and (FItemIndex < FItems.Count) then
  begin
    FMouseDown := False;
    result := true;
  end else result := false;
end;

function TSharpEMenu.PerformMouseMove(px,py : integer; var submenu : boolean) : boolean;
var
  menuskin : TSharpEMenuSkin;
  item : TSharpEMenuItem;
  tl : TPoint;
  n : integer;
begin
  menuskin := FSkinManager.Skin.MenuSkin;
  tl.x := menuskin.LROffset.XAsInt;
  tl.y := menuskin.TBOffset.XAsInt;

  for n := 0 to High(FItemsHeight) do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    if (PointInRect(Point(px,py),Rect(0,tl.y,tl.y + tl.x+FItemWidth,tl.y + FItemsHeight[n]))
        and (item.isVisible)) then
    begin
      result := (FItemIndex <> n);
      FItemIndex := n;
      submenu := (item.ItemType = mtSubMenu);
      exit;
    end;
    tl.y := tl.y + FItemsHeight[n];
  end;
  FItemIndex := -1;
  result := true;
end;

end.
