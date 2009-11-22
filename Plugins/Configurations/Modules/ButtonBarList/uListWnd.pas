{
Source Name: uListWnd.pas
Description: <Type> List Window
Copyright (C) <Author> (<Email>)

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

unit uListWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Contnrs,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ImgList,
  PngImageList,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,

  SharpEListBoxEx, uButtonBarList, SharpIconUtils, GR32, ExtCtrls, SharpApi, SharpCenterApi;

type

  TfrmList = class(TForm)
    lbItems: TSharpEListBoxEx;
    pilUnselected: TPngImageList;
    tmrUpdatePosition: TTimer;
    pilSelected: TPngImageList;
    pilDelete: TPngImageList;
    tmrRenderItems: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbItemsGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbItemsGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbItemsClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbItemsResize(Sender: TObject);
    procedure lbItemsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lbItemsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tmrUpdatePositionTimer(Sender: TObject);
    procedure tmrRenderItemsTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    FItems: TButtonBarList;
    FPluginHost: ISharpCenterHost;
    procedure SetPluginHost(const Value: ISharpCenterHost);
  public
    property Items: TButtonBarList read FItems write FItems;
    procedure RenderItems;
    procedure UpdateImages;
    function GetImage(pTarget,pIcon : String; selected: Boolean) : TBitmap;

    property PluginHost: ISharpCenterHost read FPluginHost write SetPluginHost;
  end;

var
  frmList: TfrmList;

const
  colIcon = 0;
  colName = 1;
  colCopy = 2;
  colDelete = 3;

implementation

uses
  SharpThemeApiEx,
  uEditWnd;

{$R *.dfm}

function TfrmList.GetImage(pTarget,pIcon : String; selected: Boolean) : TBitmap;
var
  BGBmp,Bmp : TBitmap32;
  col: TColor;
begin
  if selected then col := lbItems.Colors.ItemColorSelected else
  col := lbItems.Colors.ItemColor;

  result := TBitmap.Create;
  result.Canvas.Brush.Color := ColorToRGB(col);
  result.Width := pilUnselected.Width;
  result.Height := pilUnselected.Height;
  result.Canvas.FillRect(result.Canvas.ClipRect);
  BGBmp := TBitmap32.Create;
  Bmp := TBitmap32.Create;
  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;
  IconStringToIcon(pIcon,pTarget,Bmp);
  BGBmp.SetSize(Bmp.Width,Bmp.Height);

  BGBmp.Clear(color32(ColorToRGB(col)));

  Bmp.DrawTo(BGBmp);
  BGBmp.DrawTo(result.Canvas.Handle,Rect(0,0,result.Width,result.Height),Rect(0,0,Bmp.Width,Bmp.Height));

  Bmp.Free;
  BGBmp.Free;
end;

procedure TfrmList.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  lbItems.DoubleBuffered := True;

  FItems := TButtonBarList.Create;
end;

procedure TfrmList.FormDestroy(Sender: TObject);
begin
  FItems.Free;
end;

procedure TfrmList.FormShow(Sender: TObject);
begin
  FItems.Filename := FPluginHost.GetModuleXmlFilename;
  tmrRenderItems.Enabled := true;
end;

procedure TfrmList.lbItemsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpItemData: TButtonBarItem;
  bDelete: boolean;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin

  tmpItemData := TButtonBarItem(AItem.Data);
  if tmpItemData = nil then
    exit;

  case ACol of
    colDelete: begin

        bDelete := True;
        if not (CtrlDown) then
          if (MessageDlg(Format('Are you sure you want to delete: %s item?', [tmpItemData.Name]),
            mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
            bDelete := False;

        
        if bDelete then begin
          lbItems.DeleteItem(lbItems.ItemIndex);
          FItems.Extract(tmpItemData);
          FPluginHost.Save;
        end;

        FPluginHost.SetEditTabsVisibility( lbItems.ItemIndex, lbItems.Count );
        FPluginHost.Refresh;
        Abort;
        
      end;
    colCopy: begin
      FItems.AddButtonItem(tmpItemData.Name, tmpItemData.Command, tmpItemData.Icon );
      FPluginHost.Save;

      LockWindowUpdate(frmList.Handle);
      try
        frmList.RenderItems;
      finally
        LockWindowUpdate(0);
      end;

      UpdateImages;
    end;
  end;

  if frmEdit <> nil then
    frmEdit.Init;


  FPluginHost.SetEditTabsVisibility( lbItems.ItemIndex, lbItems.Count );
  FPluginHost.Refresh;

end;

procedure TfrmList.lbItemsDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  tmrUpdatePosition.Enabled := False;

  FPluginHost.SetEditTabsVisibility( lbItems.ItemIndex, lbItems.Count );
  FPluginHost.Refresh;

  FPluginHost.Save;
end;

procedure TfrmList.lbItemsDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  n: Integer;
begin
  n := lbItems.ItemAtPos(point(x, y), True);
  if ((n <> -1) and (lbItems.ItemIndex <> -1) and (n <> lbItems.ItemIndex)) then begin
    Accept := True;

    // If Ctrl is not pressed, we are simply repositioning
    tmrUpdatePosition.Enabled := True;
  end;
end;

procedure TfrmList.lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ((ACol >= 2) and (AItem = lbItems.SelectedItem)) then
    ACursor := crHandPoint;
end;

procedure TfrmList.lbItemsGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
var
  tmpItemData: TButtonBarItem;
begin

  tmpItemData := TButtonBarItem(AItem.Data);
  if tmpItemData = nil then
    exit;

  case ACol of
    colDelete: AImageIndex := 0;
    colCopy: AImageIndex := 1;
  end;

end;

procedure TfrmList.lbItemsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpItemData: TButtonBarItem;
  s:String;
  colItemTxt, colDescTxt, colBtnTxt: TColor;
begin

  tmpItemData := TButtonBarItem(AItem.Data);
  if tmpItemData = nil then
    exit;

  // Assign theme colours
  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  case ACol of
    colName: begin
      s := tmpItemData.Name;
      if s = '' then s := '*Untitled';

      AColText := format('<font color="%s">%s<BR><font color="%s">%s',[ColorToString(colItemTxt),s,ColorToString(colDescTxt),tmpItemData.Command]);
    end;
  end;
end;

procedure TfrmList.lbItemsResize(Sender: TObject);
begin
  Self.Height := lbItems.Height;
end;

procedure TfrmList.RenderItems;
var
  newItem: TSharpEListItem;
  selectedIndex, i: Integer;
  tmpItemData: TButtonBarItem;
begin

    if lbItems.ItemIndex <> -1 then
      selectedIndex := TButtonBarItem(lbItems.Item[lbItems.ItemIndex].Data).Id
    else
      selectedIndex := -1;

    lbItems.Clear;
    FItems.Load;

    for i := 0 to FItems.Count - 1 do begin

      tmpItemData := TButtonBarItem(FItems.Items[i]);

      newItem := lbItems.AddItem('');
      newItem.Data := tmpItemData;
      newitem.AddSubItem('');
      newitem.AddSubItem('');
      newitem.AddSubItem('');

      if tmpItemData.Id = selectedIndex then
        lbItems.ItemIndex := i;
    end;

  if lbItems.ItemIndex = -1 then
    lbItems.ItemIndex := 0;

  FPluginHost.SetEditTabsVisibility( lbItems.ItemIndex, lbItems.Count );
  FPluginHost.Refresh;
end;

procedure TfrmList.SetPluginHost(const Value: ISharpCenterHost);
begin
  FPluginHost := Value;
end;

procedure TfrmList.tmrRenderItemsTimer(Sender: TObject);
begin
  tmrRenderItems.Enabled := false;
  RenderItems;
  UpdateImages;
end;

procedure TfrmList.tmrUpdatePositionTimer(Sender: TObject);
var
  pt: TPoint;
  n: Integer;
begin
  pt := lbItems.ScreenToClient(Mouse.CursorPos);
  tmrUpdatePosition.Enabled := False;

  n := lbItems.ItemAtPos(point(pt.x, pt.y), True);
  if ((n <> -1) and (lbItems.ItemIndex <> -1) and (n <> lbItems.ItemIndex)) then begin

    FItems.Exchange(n,lbItems.ItemIndex);
    lbItems.Items.Exchange(n,lbItems.ItemIndex);
    FPluginHost.Save;
    end;
  end;

procedure TfrmList.UpdateImages;
var
  i: Integer;
  tmpItemData: TButtonBarItem;
  bmp, bmpMask: TBitmap;
begin
  pilSelected.Clear;
  pilUnselected.Clear;

  bmpMask := TBitmap.Create;
  bmpMask.Canvas.Brush.Color := clBlack;
  bmpMask.Canvas.FillRect(bmpMask.Canvas.ClipRect);

  for i := 0 to Pred(lbItems.Count) do begin

      tmpItemData := TButtonBarItem(lbItems[i].Data);
      if tmpItemData <> nil then begin
        // Add the icon
        bmp := TBitmap.Create;
        try
          bmp := GetImage(tmpItemData.Command,tmpItemData.Icon,false);
          lbItems[i].ImageIndex := pilUnselected.Add(bmp,bmpMask);
          bmp := GetImage(tmpItemData.Command,tmpItemData.Icon,true);
          lbItems[i].SubItemSelectedImageIndex[0] := pilSelected.Add(bmp,bmpMask);
        finally
          bmp.Free;
        end;
      end;
    end;

 BmpMask.Free;
end;

end.

