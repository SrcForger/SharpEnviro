unit SharpEListBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PngImageList, Types, ComCtrls, JclFileUtils;

type
  TSEColumn_WidthType = (cwtPercent, cwtPixel);

  TSharpEListBoxColumn = class(TObject)
  private
    FWidth: Integer;
    FTextColor: TColor;
    FSelectedTextColor: TColor;
    FVAlign: TVerticalAlignment;
    FHAlign: TAlignment;
    FColumnRect: TRect;
    FOwner: TComponent;
    FPngImageList: TPngImageList;

    procedure SetWidth(const Value: Integer);
    procedure SetHAlign(const Value: TAlignment);
    procedure SetSelectedTextColor(const Value: TColor);
    procedure SetTextColor(const Value: TColor);
    procedure SetVAlign(const Value: TVerticalAlignment);
  public
    constructor Create(AOwner: Tcomponent);
    destructor Destroy; override;
    property Width: Integer read FWidth write SetWidth;
    property ColumnRect: TRect read FColumnRect write FColumnRect;
    property TextColor: TColor read FTextColor write SetTextColor;
    property SelectedTextColor: TColor read FSelectedTextColor write SetSelectedTextColor;

    property HAlign: TAlignment read FHAlign write SetHAlign;
    property VAlign: TVerticalAlignment read FVAlign write SetVAlign;
    property Owner: TComponent read FOwner write fOwner;

    property PngImageList: TPngImageList read
      FPngImageList write FPngImageList;
  private
  end;

  TSharpEListBoxColors = class(TObject)
  private
    FBorderColor: TColor;
    FItemColorSelected: TColor;
    FBorderColorSelected: TColor;
    FItemColor: TColor;
  published
    property BorderColor: TColor read FBorderColor write FBorderColor;
    property BorderColorSelected: TColor read FBorderColorSelected write FBorderColorSelected;
    property ItemColor: TColor read FItemColor write FItemColor;
    property ItemColorSelected: TColor read FItemColorSelected write FItemColorSelected;
  end;

  TSharpEListItem = class(TPersistent)
  private
    FSubItems: TStringList;
    FSubItemImages: TList;
    FData: Pointer;
    FHint: string;
    FID: Integer;
    function GetSubItemImageIndex(ASubItemIndex: Integer): Integer;
    procedure SetSubItemImageIndex(ASubItemIndex: Integer;
      const Value: Integer);
    function GetSubItemText(ASubItem: Integer): string;
    procedure SetSubItemText(ASubItem: Integer; const Value: string);

  public
    constructor Create;
    destructor Destroy; override;
    function AddSubItem(AText: string; AImageIndex: Integer = -1): Integer;
    property Hint: string read FHint write FHint;
    property Data: Pointer read FData write FData;
    property ID: Integer read FID write FID;
    property SubItemImageIndexes: TList read FSubItemImages write FSubItemImages;

    property SubItemImageIndex[ASubItemIndex: Integer]: Integer read GetSubItemImageIndex write
    SetSubItemImageIndex; default;
    property SubItemText[ASubItem: Integer]: string read GetSubItemText write SetSubItemText;
    function SubItemCount: Integer;
  end;

  TSharpEListBoxOnClickItem = procedure(AText: string; AItem: Integer; ACol: Integer) of object;
  TSharpEListBoxGetColTextColor = procedure(const ACol: Integer; AItem: TSharpEListItem; var AColor: TColor) of object;
  TSharpEListBoxGetItemColor = procedure (const AItem: Integer; var AColor:TColor) of object;
  TSharpEListBoxGetColCursor = procedure(const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor) of object;

  TSharpEListBox = class(TCustomListBox)
  private
    FPngImageCollection: TPngImageCollection;
    FColors: TSharpEListBoxColors;
    FItemOffset: TPoint;
    FColumns: TList;
    FOnClickItem: TSharpEListBoxOnClickItem;
    FOnGetCellTextColor: TSharpEListBoxGetColTextColor;
    FOnGetCellCursor: TSharpEListBoxGetColCursor;
    FOnDblClickItem: TSharpEListBoxOnClickItem;
    FOnGetCellColor: TSharpEListBoxGetItemColor;
    procedure DrawItemEvent(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure DrawSelection(ARect: TRect; AState: TOwnerDrawState; AItem: TSharpEListItem);
    procedure SetColors(const Value: TSharpEListBoxColors);
    procedure DrawItemText(ACanvas: TCanvas; ARect: TRect; AFlags: Longint; Aitem: TSharpEListItem; ACol: Integer);
    procedure DrawItemIcon(ACanvas: TCanvas; ARect: TRect; AItem: TSharpEListItem;
      ACol: Integer);
    function GetColumn(AColumn: Integer): TSharpEListBoxColumn;
    function GetColumnCount: Integer;
    procedure SetColumn(AColumn: Integer; const Value: TSharpEListBoxColumn);
    procedure MouseDownEvent(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseMoveEvent(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    function GetItem(AItem: Integer): TSharpEListItem;
    procedure SetItem(AItem: Integer; const Value: TSharpEListItem);
    procedure UpdateColumnSizes;
    procedure SetColumns(const Value: TList);
    procedure DblClickItem(Sender:TObject);
    procedure ClickItem(Sender:TObject);
  public
    constructor Create(Sender: TComponent); override;
    destructor Destroy; override;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    property Item[AItem: Integer]: TSharpEListItem read GetItem write
    SetItem; default;

    function AddColumn(AText: string): TSharpEListBoxColumn;
    property ColumnCount: Integer read GetColumnCount stored True;

    function AddItem(AText: string; AImageIndex: Integer = -1): TSharpEListItem; reintroduce;

    property Column[AColumn: Integer]: TSharpEListBoxColumn read GetColumn
    write SetColumn;
    property Columns: TList read FColumns write SetColumns stored True;
    property Colors: TSharpEListBoxColors read FColors write SetColors stored True;

  published
    property ItemHeight;
    property OnClickItem: TSharpEListBoxOnClickItem read FOnClickItem write FOnClickItem stored True;
    property OnDblClickItem: TSharpEListBoxOnClickItem read FOnDblClickItem write FOnDblClickItem stored True;
    property OnGetCellTextColor: TSharpEListBoxGetColTextColor read FOnGetCellTextColor write FOnGetCellTextColor stored True;
    property OnGetCellCursor: TSharpEListBoxGetColCursor read FOnGetCellCursor write FOnGetCellCursor stored True;
    property OnGetCellColor: TSharpEListBoxGetItemColor read FOnGetCellColor write FOnGetCellColor;
    property ItemOffset: TPoint read FItemOffset write FItemOffset;
    property BevelInner;
    property BevelOuter;
    property Borderstyle;
    property Ctl3d;
    property Align;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SharpE', [TSharpEListBox]);

  //RegisterPropertyEditor(TypeInfo(TList), TSharpEListBox,
  //  'Columns', TSharpEListBoxColumnsProperty);

end;

{ TSharpEListBoxItemColumn }

procedure TSharpEListBoxColumn.SetWidth(const Value: Integer);
begin
  FWidth := Value;
  TSharpEListBox(Self.Owner).UpdateColumnSizes;
end;

{ TSharpEListBox }

function TSharpEListBox.AddColumn(AText: string): TSharpEListBoxColumn;
begin
  Result := TSharpEListBoxColumn.Create(Self);
  FColumns.Add(Result);
end;

constructor TSharpEListBoxColumn.Create(AOwner: TComponent);
begin
  FWidth := 50;
  FVAlign := taVerticalCenter;
  FHAlign := taLeftJustify;
  FOwner := AOwner;

  //FColumns := TList.Create;
  //FColumns.Clear;
end;

procedure TSharpEListBox.CNDrawItem(var Message: TWMDrawItem);
begin
  Exclude(TOwnerDrawState(LongRec(Message.DrawItemStruct^.itemState).Lo),
    odFocused);

  inherited;
end;

constructor TSharpEListBox.Create(Sender: TComponent);
begin
  inherited;
  Self.Style := lbOwnerDrawFixed;
  Self.OnDrawItem := DrawItemEvent;
  Self.OnClick := ClickItem;
  Self.OnMouseMove := MouseMoveEvent;
  Self.OnDblClick := DblClickItem;
  Self.ItemHeight := 24;

  FColors := TSharpEListBoxColors.Create;
  FColors.ItemColor := clWindow;
  FColors.ItemColorSelected := clBtnFace;
  FColors.BorderColor := clBtnFace;
  FColors.BorderColorSelected := clBtnShadow;

  FColumns := TList.Create;

  FItemOffset := Point(2, 2);
end;

destructor TSharpEListBox.Destroy;
begin
  FColors.Free;

  if assigned(FPngImageCollection) then
    FPngImageCollection.Free;

  FColumns.Clear;
  FColumns.Free;

  inherited;
end;

procedure TSharpEListBox.DrawItemEvent(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  tmpItem: TSharpEListItem;
  R: TRect;
  X, Y, i: Integer;
begin
  tmpItem := TSharpEListItem(Self.Items.Objects[Index]);

  if Assigned(tmpItem) then
  begin
    SetBkMode(Self.Canvas.Handle, TRANSPARENT);

    // Draw Selection
    DrawSelection(Rect, State, tmpItem);

    // Draw Columns
    X := ItemOffset.X;
    Y := Rect.Top + ItemOffset.Y;
    for i := 0 to Pred(ColumnCount) do
    begin

      if i = Pred(ColumnCount) then
        R := Types.Rect(X, Y, Self.Width - (itemoffset.X * 2), Y + ItemHeight - ItemOffset.Y)
      else
        R := Types.Rect(X, Y, X + Column[i].Width + itemoffset.x, Y + ItemHeight - ItemOffset.Y);

      //Self.Canvas.FillRect(R);
      R.Left := R.Left + 8;

      if i <= (tmpItem.SubItemCount - 1) then
      begin
        if tmpItem.SubItemImageIndex[i] <> -1 then
        begin
          DrawItemIcon(Self.Canvas, R, tmpItem, i);
          //PngImageCollection.Items[tmpItem[i].IconIndex].PngImage.Draw(Self.Canvas, R);
        end;

        DrawItemText(Self.Canvas, R, 0, tmpItem, i);
        //Self.Canvas.TextOut(R.Left,R.Top,tmpItem[i].Text);
        X := X + Column[i].Width;
      end;
    end;

  end;
end;

procedure TSharpEListBox.DrawItemIcon(ACanvas: TCanvas; ARect: TRect;
  AItem: TSharpEListItem; ACol: Integer);
var
  R: TRect;
  iW, iH, iItemHWOffsets, iItemWWOffsets: Integer;
begin
  // Get W+H of Icon

  iW := Column[ACol].PngImageList.Width;// PngImageCollection.Items[AItem.SubItemImageIndex[ACol]].PngImage.Width;
  iH := Column[ACol].PngImageList.Height;//PngImageCollection.Items[AItem.SubItemImageIndex[ACol]].PngImage.Height;

  // Vertical postion
  case Column[ACol].VAlign of
    taAlignTop: R := Rect(0, ARect.Top + ItemOffset.Y, 0, ARect.Top + ItemOffset.Y + iH);
    taAlignBottom: R := Rect(0, ARect.Bottom - ItemOffset.Y - iH, 0, ARect.Bottom - ItemOffset.Y);
    taVerticalCenter:
      begin
        iItemHWOffsets := ItemHeight - (ItemOffset.Y * 2);
        R := Rect(0, ARect.Top + (iItemHWOffsets div 2) - (iH div 2), 0, iH);
      end;
  end;

  // Horizontal position
  case Column[ACol].HAlign of
    taLeftJustify: R := Rect(ARect.Left + 0 + ItemOffset.X, R.Top, Arect.Left + iW, R.Bottom);
    taRightJustify: R := Rect(ARect.Left + Column[ACol].Width - iW, R.Top, ARect.Left + Column[ACol].Width - ItemOffset.X, R.Bottom);
    taCenter:
      begin
        iItemWWOffsets := Column[ACol].Width - (ItemOffset.X);
        R := Rect(ARect.Left + (iItemWWOffsets div 2) - (iW div 2) + itemoffset.X, R.Top, ARect.Left + iW, R.Bottom);
      end;
  end;

  Try
    Column[ACol].PngImageList.PngImages[AItem.SubItemImageIndex[ACol]].PngImage.Draw(ACanvas, R);
  Except
  End;
end;

procedure TSharpEListBox.DrawItemText(ACanvas: TCanvas; ARect: TRect;
  AFlags: Integer; Aitem: TSharpEListItem; ACol: Integer);
var
  s: string;
  tmpColor: TColor;
  iImgWidth: Integer;
const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
  VerticalAlignments: array[TVerticalAlignment] of Longint = (DT_TOP, DT_BOTTOM,
    DT_VCENTER);

begin

  AFlags := AFlags or DT_NOPREFIX or DT_EXPANDTABS or DT_SINGLELINE or
    VerticalAlignments[Column[ACol].VAlign] or Alignments[Column[ACol].HAlign];
  AFlags := DrawTextBiDiModeFlags(AFlags);

  iImgWidth := 0;
  if Aitem.SubItemImageIndex[ACol] <> -1 then
  begin
    iImgWidth := Column[ACol].PngImageList.Width;// PngImageCollection.Items[Aitem.SubItemImageIndex[ACol]].PngImage.Width + 2;
    ARect.Left := ARect.Left + iImgWidth + 4;
  end;

  s := PathCompactPath(Self.Canvas.Handle, Aitem.SubItemText[ACol], Column[ACol].Width - ItemOffset.X - iImgWidth, cpEnd);

  if Assigned(FOnGetCellTextColor) then
  begin

    tmpColor := clWindowText;

    FOnGetCellTextColor(ACol, Aitem, tmpColor);
    ACanvas.Font.Color := tmpColor;
  end
  else
  begin
    if AItem.ID = Self.ItemIndex then
      ACanvas.Font.Color := Column[Acol].SelectedTextColor
    else
      ACanvas.Font.Color := Column[Acol].TextColor;
  end;

  DrawText(ACanvas.Handle, PChar(s), Length(s), ARect, AFlags);
end;

procedure TSharpEListBox.DrawSelection(ARect: TRect;
  AState: TOwnerDrawState; AItem: TSharpEListItem);
var
  tmpColor, tmpColorBorder:TColor;
begin
  tmpColor := Colors.ItemColor;
  if Assigned(FOnGetCellColor) then
    FOnGetCellColor(AItem.ID,tmpColor);

  Self.Canvas.Brush.Color := tmpColor;
  Self.Canvas.Pen.Color := tmpColor;
  Self.Canvas.RoundRect(ARect.Left + ItemOffset.X, ARect.Top + Itemoffset.Y,
      ARect.Right - ItemOffset.X, ARect.Bottom - itemoffset.Y, 10, 10);

  //Self.Canvas.FillRect(ARect);

  // Get Colours
  if odSelected in AState then
  begin
    tmpColor := Colors.ItemColorSelected;

    if Assigned(FOnGetCellColor) then
    FOnGetCellColor(AItem.ID,tmpColor);

    Self.Canvas.Brush.Color := tmpColor;
    Self.Canvas.Pen.Color := Colors.BorderColorSelected;

    Self.Canvas.RoundRect(ARect.Left + ItemOffset.X, ARect.Top + Itemoffset.Y,
      ARect.Right - ItemOffset.X, ARect.Bottom - itemoffset.Y, 10, 10);
  end;
  if (odFocused in AState) and (odSelected in AState) then
  begin
    Self.Canvas.Brush.Color := Colors.ItemColorSelected;
    Self.Canvas.Pen.Color := Colors.BorderColorSelected;

    Self.Canvas.RoundRect(ARect.Left + ItemOffset.X, ARect.Top + Itemoffset.Y,
      ARect.Right - ItemOffset.X, ARect.Bottom - itemoffset.Y, 10, 10);
  end;
end;

function TSharpEListBox.GetColumnCount: Integer;
begin
  Result := FColumns.Count;
end;

function TSharpEListBox.GetColumn(AColumn: Integer): TSharpEListBoxColumn;
begin
  Result := TSharpEListBoxColumn(FColumns[AColumn]);
end;

procedure TSharpEListBox.SetColors(const Value: TSharpEListBoxColors);
begin
  FColors := Value;
  Invalidate;
end;

procedure TSharpEListBox.SetColumn(AColumn: Integer;
  const Value: TSharpEListBoxColumn);
begin
  FColumns.Items[AColumn] := Value;
end;

procedure TSharpEListBoxColumn.SetHAlign(const Value: TAlignment);
begin
  FHAlign := Value;
end;

procedure TSharpEListBoxColumn.SetTextColor(const Value: TColor);
begin
  FTextColor := Value;
end;

procedure TSharpEListBoxColumn.SetVAlign(const Value: TVerticalAlignment);
begin
  FVAlign := Value;
end;

procedure TSharpEListBoxColumn.SetSelectedTextColor(const Value: TColor);
begin
  FSelectedTextColor := Value;
end;

procedure TSharpEListBox.SetColumns(const Value: TList);
begin
  FColumns.Assign(Value);
end;

procedure TSharpEListBox.DblClickItem(Sender: TObject);
var
  i: Integer;
  id: Integer;
  R: TRect;
  X,Y: Integer;
  pt: TPoint;
begin
  if Self.ItemIndex = -1 then
    exit;

  pt := Self.ScreenToClient(Mouse.CursorPos);
  X := pt.X;
  Y := pt.Y;

  Self.Invalidate;
  id := Self.ItemIndex;
  R := Self.ItemRect(id);

  for i := 0 to Pred(ColumnCount) do
  begin
    if (X > Column[i].ColumnRect.Left) and (X < Column[i].ColumnRect.Right) and
      (Y > R.Top) and (Y < R.Bottom) then
      if assigned(FOnDblClickItem) then
        FOnDblClickItem(Item[id].SubItemText[i], id, i);
  end;
  inherited;
end;

procedure TSharpEListBox.ClickItem(Sender: TObject);
var
  i: Integer;
  id: Integer;
  R: TRect;
  X,Y: Integer;
  pt: TPoint;
begin
  if Self.ItemIndex = -1 then
    exit;

  pt := Self.ScreenToClient(Mouse.CursorPos);
  X := pt.X;
  Y := pt.Y;

  Self.Invalidate;
  id := Self.ItemIndex;
  R := Self.ItemRect(id);

  for i := 0 to Pred(ColumnCount) do
  begin
    if (X > Column[i].ColumnRect.Left) and (X < Column[i].ColumnRect.Right) and
      (Y > R.Top) and (Y < R.Bottom) then
      if assigned(FOnClickItem) then
        FOnClickItem(Item[id].SubItemText[i], id, i);
  end;
  inherited;
end;
{ TSharpEListItem }

function TSharpEListItem.AddSubItem(AText: string;
  AImageIndex: Integer): Integer;
begin
  FSubItems.Add(AText);
  Result := FSubItemImages.Add(Pointer(AImageIndex));
end;

constructor TSharpEListItem.Create;
begin
  FSubItems := TStringList.Create;
  FSubItemImages := TList.Create;
end;

destructor TSharpEListItem.Destroy;
begin
  FSubItems.Free;
  FSubItemImages.Free;
  inherited;
end;

function TSharpEListItem.GetSubItemImageIndex(ASubItemIndex: Integer): Integer;
begin
  Result := Integer(FSubItemImages[ASubItemIndex]);
end;

function TSharpEListItem.GetSubItemText(ASubItem: Integer): string;
begin
  Result := FSubItems[ASubItem];
end;

procedure TSharpEListItem.SetSubItemImageIndex(ASubItemIndex: Integer;
  const Value: Integer);
begin
  FSubItemImages[ASubItemIndex] := Pointer(Value);
end;

function TSharpEListBox.AddItem(AText: string;
  AImageIndex: Integer): TSharpEListItem;
begin
  Result := TSharpEListItem.Create;
  Result.AddSubItem(AText, AImageIndex);

  Result.ID := Self.Items.AddObject(AText, Result);
end;

procedure TSharpEListItem.SetSubItemText(ASubItem: Integer; const Value: string);
begin
  FSubItems[ASubItem] := Value;
end;

function TSharpEListItem.SubItemCount: Integer;
begin
  Result := FSubItems.Count;
end;

procedure TSharpEListBox.UpdateColumnSizes;
var
  i: Integer;
  x: Integer;
begin
  x := 0;
  for i := 0 to Pred(FColumns.Count) do
  begin
    Column[i].ColumnRect := Rect(x, 0, x + Column[i].Width, ItemHeight);
    x := x + Column[i].Width;
  end;
end;

procedure TSharpEListBox.MouseDownEvent(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  id: Integer;
  R: TRect;
begin
  if Self.ItemIndex = -1 then
    exit;

  Self.Invalidate;
  id := Self.ItemIndex;
  R := Self.ItemRect(id);

  for i := 0 to Pred(ColumnCount) do
  begin
    if (X > Column[i].ColumnRect.Left) and (X < Column[i].ColumnRect.Right) and
      (Y > R.Top) and (Y < R.Bottom) then
      if assigned(FOnClickItem) then
        FOnClickItem(Item[id].SubItemText[i], id, i);
  end;
  inherited;
end;

function TSharpEListBox.GetItem(AItem: Integer): TSharpEListItem;
begin
  Result := TSharpEListItem(Self.Items.Objects[AItem]);
end;

procedure TSharpEListBox.SetItem(AItem: Integer;
  const Value: TSharpEListItem);
begin
  Self.Items.Objects[AItem] := Value;
end;

procedure TSharpEListBox.MouseMoveEvent(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  id: Integer;
  i: Integer;
  R: TRect;
  cur: TCursor;
begin
  if Self.ItemIndex = -1 then
    exit;
  Self.Cursor := crDefault;
  id := Self.ItemIndex;
  R := Self.ItemRect(id);

  for i := 0 to Pred(ColumnCount) do
  begin
    if (X > Column[i].ColumnRect.Left) and (X < Column[i].ColumnRect.Right) and
      (Y > R.Top) and (Y < R.Bottom) then
    begin
      cur := crDefault;
      if Assigned(FOnGetCellCursor) then
        FOnGetCellCursor(i, TSharpEListItem(Self.Item[id]), cur);

      Self.Cursor := cur;
    end;
  end;
end;

destructor TSharpEListBoxColumn.Destroy;
begin
  inherited;
end;

end.

