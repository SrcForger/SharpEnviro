unit SharpEListBoxEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PngImageList, Types, ComCtrls, Extctrls, JclFileUtils, GR32, GR32_Image;

type
  TSEColumn_WidthType = (cwtPercent, cwtPixel);

  TSharpEListBoxExColumn = class(TCollectionItem)
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
    property Owner: TComponent read FOwner write fOwner;
  public
    constructor Create(AOwner: Tcomponent); reintroduce;
    destructor Destroy; override;
  published
    property Width: Integer read FWidth write SetWidth;
    property ColumnRect: TRect read FColumnRect write FColumnRect;
    property TextColor: TColor read FTextColor write SetTextColor;
    property SelectedTextColor: TColor read FSelectedTextColor write SetSelectedTextColor;

    property HAlign: TAlignment read FHAlign write SetHAlign;
    property VAlign: TVerticalAlignment read FVAlign write SetVAlign;

    property PngImageList: TPngImageList read
      FPngImageList write FPngImageList;
  end;

  TSharpEListBoxExColumns = Class(TCollection)
  private
    function GetItem(Index: Integer): TSharpEListBoxExColumn;
    procedure SetItem(Index: Integer; const Value: TSharpEListBoxExColumn);
  public
    function Add(AOwner:TComponent):TSharpEListBoxExColumn;
    procedure Delete(AIndex: Integer); overload;
    procedure Delete(ASharpEListBoxExColumn: TSharpEListBoxExColumn); overload;
    property Item[Index: Integer]: TSharpEListBoxExColumn read GetItem write SetItem;
  end;

  TSharpEListBoxExColors = class(TObject)
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

  TSharpEListBoxExOnClickItem = procedure(AText: string; AItem: Integer; ACol: Integer) of object;
  TSharpEListBoxExGetColTextColor = procedure(const ACol: Integer; AItem: TSharpEListItem; var AColor: TColor) of object;
  TSharpEListBoxExGetItemColor = procedure (const AItem: Integer; var AColor:TColor) of object;
  TSharpEListBoxExGetColCursor = procedure(const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor) of object;

  TSharpEListBoxEx = class(TCustomListBox)
  private
    FPngImageCollection: TPngImageCollection;
    FColors: TSharpEListBoxExColors;
    FItemOffset: TPoint;
    FColumns: TSharpEListBoxExColumns;
    FOnClickItem: TSharpEListBoxExOnClickItem;
    FOnGetCellTextColor: TSharpEListBoxExGetColTextColor;
    FOnGetCellCursor: TSharpEListBoxExGetColCursor;
    FOnDblClickItem: TSharpEListBoxExOnClickItem;
    FOnGetCellColor: TSharpEListBoxExGetItemColor;
    FMargin: TRect;
    FColumnMargin: TRect;

    procedure DrawItemEvent(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure DrawSelection(ARect: TRect; AState: TOwnerDrawState; AItem: TSharpEListItem);
    procedure SetColors(const Value: TSharpEListBoxExColors);
    procedure DrawItemText(ACanvas: TCanvas; ARect: TRect; AFlags: Longint; Aitem: TSharpEListItem; ACol: Integer);
    procedure DrawItemImage(ACanvas: TCanvas; ARect: TRect; AItem: TSharpEListItem;
      ACol: Integer);
    function GetColumn(AColumn: Integer): TSharpEListBoxExColumn;
    function GetColumnCount: Integer;
    procedure SetColumn(AColumn: Integer; const Value: TSharpEListBoxExColumn);
    procedure MouseMoveEvent(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    function GetItem(AItem: Integer): TSharpEListItem;
    procedure SetItem(AItem: Integer; const Value: TSharpEListItem);
    procedure UpdateColumnSizes;
    procedure SetColumns(const Value: TSharpEListBoxExColumns);
    procedure DblClickItem(Sender:TObject);
    procedure ClickItem(Sender:TObject);

    function IsImageIndexValid(AItem: TSharpEListItem; ACol, AImageIndex: Integer): Boolean;
    procedure MouseDownEvent(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  public
    constructor Create(Sender: TComponent); override;
    destructor Destroy; override;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    property Item[AItem: Integer]: TSharpEListItem read GetItem write
    SetItem; default;

    function AddColumn(AText: string): TSharpEListBoxExColumn;
    property ColumnCount: Integer read GetColumnCount stored True;

    function AddItem(AText: string; AImageIndex: Integer = -1): TSharpEListItem; reintroduce;

    property Column[AColumn: Integer]: TSharpEListBoxExColumn read GetColumn
    write SetColumn;
  protected
    Procedure Loaded; override;
  published
    property Columns: TSharpEListBoxExColumns read FColumns write SetColumns stored True;
    property Colors: TSharpEListBoxExColors read FColors write SetColors stored True;
    property Margin: TRect read FMargin write FMargin;
    property ColumnMargin: TRect read FColumnMargin write FColumnMargin;


    property ItemHeight;
    property OnClickItem: TSharpEListBoxExOnClickItem read FOnClickItem write FOnClickItem stored True;
    property OnDblClickItem: TSharpEListBoxExOnClickItem read FOnDblClickItem write FOnDblClickItem stored True;
    property OnGetCellTextColor: TSharpEListBoxExGetColTextColor read FOnGetCellTextColor write FOnGetCellTextColor stored True;
    property OnGetCellCursor: TSharpEListBoxExGetColCursor read FOnGetCellCursor write FOnGetCellCursor stored True;
    property OnGetCellColor: TSharpEListBoxExGetItemColor read FOnGetCellColor write FOnGetCellColor;
    
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
  RegisterComponents('SharpE', [TSharpEListBoxEx]);
end;

{ TSharpEListBoxExItemColumn }

procedure TSharpEListBoxExColumn.SetWidth(const Value: Integer);
begin
  FWidth := Value;

 //TSharpEListBoxEx(Owner).UpdateColumnSizes;
end;

{ TSharpEListBoxEx }

function TSharpEListBoxEx.AddColumn(AText: string): TSharpEListBoxExColumn;
begin
  Result := FColumns.Add(Self);
end;

constructor TSharpEListBoxExColumn.Create(AOwner: TComponent);
begin
  FWidth := 50;
  FVAlign := taVerticalCenter;
  FHAlign := taLeftJustify;
  FOwner := AOwner;

  //FColumns := TList.Create;
  //FColumns.Clear;
end;

procedure TSharpEListBoxEx.CNDrawItem(var Message: TWMDrawItem);
begin
  Exclude(TOwnerDrawState(LongRec(Message.DrawItemStruct^.itemState).Lo),
    odFocused);

  inherited;
end;

constructor TSharpEListBoxEx.Create(Sender: TComponent);
begin
  inherited;
  Self.DoubleBuffered := True;
  Self.Style := lbOwnerDrawFixed;
  Self.OnDrawItem := DrawItemEvent;
  Self.OnClick := ClickItem;
  Self.OnMouseMove := MouseMoveEvent;
  Self.OnMouseDown := MouseDownEvent;
  Self.OnDblClick := DblClickItem;
  Self.ItemHeight := 24;

  FColors := TSharpEListBoxExColors.Create;
  FColors.ItemColor := clWindow;
  FColors.ItemColorSelected := clBtnFace;
  FColors.BorderColor := clBtnFace;
  FColors.BorderColorSelected := clBtnShadow;

  FColumns := TSharpEListBoxExColumns.Create(TSharpEListBoxExColumn);

  FItemOffset := Point(2, 2);
  FMargin := Rect(2,2,2,2);
  FColumnMargin := Rect(2,2,2,2);

end;

destructor TSharpEListBoxEx.Destroy;
begin
  FColors.Free;

  if assigned(FPngImageCollection) then
    FPngImageCollection.Free;

  FColumns.Clear;
  FColumns.Free;

  inherited;
end;

procedure TSharpEListBoxEx.DrawItemEvent(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  tmpItem: TSharpEListItem;
  R: TRect;
  X, Y: Integer;
  i: Integer;

begin
try
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

      R.Left := R.Left + 8;
      //Self.Canvas.FillRect(R);

      if (i <= tmpItem.SubItemCount - 1) then
      begin
        if IsImageIndexValid(tmpItem,i,tmpItem.SubItemImageIndex[i]) then
        begin
          DrawItemImage(Self.Canvas, R, tmpItem, i);
        end;

        DrawItemText(Self.Canvas, R, 0, tmpItem, i);
        X := X + Column[i].Width;
      end;
    end;

  end;
except
end;
end;

procedure TSharpEListBoxEx.DrawItemImage(ACanvas: TCanvas; ARect: TRect;
  AItem: TSharpEListItem; ACol: Integer);
var
  R: TRect;
  iW, iH, iItemHWOffsets, iItemWWOffsets, n: Integer;
begin
  // Get W+H of Icon

  iW := Column[ACol].PngImageList.Width;
  iH := Column[ACol].PngImageList.Height;

  // Vertical postion
  case Column[ACol].VAlign of
    taAlignTop: R := Rect(0, ARect.Top + ItemOffset.Y, 0, ARect.Top + ItemOffset.Y + iH);
    taAlignBottom: R := Rect(0, ARect.Bottom - ItemOffset.Y - iH, 0, ARect.Bottom - ItemOffset.Y);
    taVerticalCenter:
      begin
        iItemHWOffsets := ItemHeight - (ItemOffset.Y * 2);
        n := (iItemHWOffsets div 2) - (iH div 2);

        R := Rect(0, ARect.Top + n, 0, iH);
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

procedure TSharpEListBoxEx.DrawItemText(ACanvas: TCanvas; ARect: TRect;
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
  if  IsImageIndexValid(AItem,ACol,Aitem.SubItemImageIndex[ACol]) then
  begin
    iImgWidth := Column[ACol].PngImageList.Width;
    ARect.Left := ARect.Left + iImgWidth +4;
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

  SetBkMode(Self.Canvas.Handle, TRANSPARENT);
  DrawText(ACanvas.Handle, PChar(s), Length(s),
    ARect, AFlags);
end;

procedure TSharpEListBoxEx.DrawSelection(ARect: TRect;
  AState: TOwnerDrawState; AItem: TSharpEListItem);
var
  tmpColor:TColor;
begin
  tmpColor := Colors.ItemColor;
  if Assigned(FOnGetCellColor) then
    FOnGetCellColor(AItem.ID,tmpColor);

  if Not(Enabled) then
    tmpColor := clWindow;

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

    if Not(Enabled) then
    tmpColor := clBtnFace;

    Self.Canvas.Brush.Color := tmpColor;
    Self.Canvas.Pen.Color := tmpColor;

    Self.Canvas.RoundRect(ARect.Left + ItemOffset.X, ARect.Top + Itemoffset.Y,
      ARect.Right - ItemOffset.X, ARect.Bottom - itemoffset.Y, 10, 10);
  end;
  if (odFocused in AState) and (odSelected in AState) then
  begin
    Self.Canvas.Brush.Color := Colors.ItemColorSelected;
    Self.Canvas.Pen.Color := Colors.BorderColorSelected;

    if Not(Enabled) then begin
      Self.Canvas.Brush.Color := clBtnFace;
      Self.Canvas.Pen.Color := clBtnFace;
    end;

    Self.Canvas.RoundRect(ARect.Left + ItemOffset.X, ARect.Top + Itemoffset.Y,
      ARect.Right - ItemOffset.X, ARect.Bottom - itemoffset.Y, 10, 10);
  end;
end;

function TSharpEListBoxEx.GetColumnCount: Integer;
begin
  Result := FColumns.Count;
end;

function TSharpEListBoxEx.GetColumn(AColumn: Integer): TSharpEListBoxExColumn;
begin
  Result := FColumns.Item[AColumn];
end;

procedure TSharpEListBoxEx.SetColors(const Value: TSharpEListBoxExColors);
begin
  FColors := Value;
  Invalidate;
end;

procedure TSharpEListBoxEx.SetColumn(AColumn: Integer;
  const Value: TSharpEListBoxExColumn);
begin
  FColumns.Items[AColumn] := Value;
end;

procedure TSharpEListBoxExColumn.SetHAlign(const Value: TAlignment);
begin
  FHAlign := Value;
end;

procedure TSharpEListBoxExColumn.SetTextColor(const Value: TColor);
begin
  FTextColor := Value;
end;

procedure TSharpEListBoxExColumn.SetVAlign(const Value: TVerticalAlignment);
begin
  FVAlign := Value;
end;

procedure TSharpEListBoxExColumn.SetSelectedTextColor(const Value: TColor);
begin
  FSelectedTextColor := Value;
end;

procedure TSharpEListBoxEx.SetColumns(const Value: TSharpEListBoxExColumns);
begin
  FColumns.Assign(Value);
end;

procedure TSharpEListBoxEx.DblClickItem(Sender: TObject);
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

procedure TSharpEListBoxEx.ClickItem(Sender: TObject);
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
        if assigned(Item[id]) then
          if i <= Pred(Item[id].SubItemCount) then
            FOnClickItem(Item[id].SubItemText[i], id, i);
  end;
  inherited;
end;
procedure TSharpEListBoxEx.Loaded;
begin
  inherited;
end;

{ TSharpEListItem }

function TSharpEListItem.AddSubItem(AText: string;
  AImageIndex: Integer=-1): Integer;
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

function TSharpEListBoxEx.AddItem(AText: string;
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
  Result := 0;

  if Assigned(FSubItems) then
  Result := FSubItems.Count;
end;

procedure TSharpEListBoxEx.UpdateColumnSizes;
var
  i: Integer;
  x: Integer;
begin
  x := 0;
  for i := 0 to Pred(ColumnCount) do
  begin
    Column[i].ColumnRect := Rect(x, 0, x + Column[i].Width, ItemHeight);
    x := x + Column[i].Width;
  end;
end;

procedure TSharpEListBoxEx.MouseDownEvent(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  id: Integer;
  col: Integer;
  R: TRect;
  colText: String;
begin
  if Self.ItemIndex = -1 then
    exit;

  Self.Invalidate;
  id := Self.ItemIndex;
  R := Self.ItemRect(id);
  col := -1;

  UpdateColumnSizes;

  // Check if in bounds
  if (X > 0) and (X < Self.Width) and
      (Y > R.Top) and (Y < R.Bottom) then begin

    for i := 0 to Pred(ColumnCount) do
    begin
      if (X > Column[i].ColumnRect.Left) and (X < Column[i].ColumnRect.Right) and
        (Y > R.Top) and (Y < R.Bottom) then  begin
        col := i;
        break;
      end;
    end;

    if Assigned(FOnClickItem) then begin

      if ((col > Pred(Item[id].SubItemCount)) or (col = -1)) then
        colText := '' else
        colText := Item[id].SubItemText[col];

      FOnClickItem(colText, id, col);
    end;
  end;

  {for i := 0 to Pred(ColumnCount) do
  begin
    if (X > Column[i].ColumnRect.Left) and (X < Column[i].ColumnRect.Right) and
      (Y > R.Top) and (Y < R.Bottom) then
      if assigned(FOnClickItem) then
        if assigned(Item[id]) then
          if i < Pred(Item[id].SubItemCount) then
            FOnClickItem(Item[id].SubItemText[i], id, i);
  end; }
  inherited;
end;

function TSharpEListBoxEx.GetItem(AItem: Integer): TSharpEListItem;
begin
  Result := TSharpEListItem(Self.Items.Objects[AItem]);
end;

function TSharpEListBoxEx.IsImageIndexValid(AItem: TSharpEListItem;
  ACol, AImageIndex: Integer): Boolean;
begin
  Result := False;
  if ( (AImageIndex <> -1) and (Column[ACol].PngImageList <> nil)  and
      (Column[ACol].PngImageList.PngImages[AImageIndex] <> nil)) then
        Result := True;
end;

procedure TSharpEListBoxEx.SetItem(AItem: Integer;
  const Value: TSharpEListItem);
begin
  Self.Items.Objects[AItem] := Value;
end;

procedure TSharpEListBoxEx.MouseMoveEvent(Sender: TObject;
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

destructor TSharpEListBoxExColumn.Destroy;
begin
  inherited;
end;

{ TSharpEListBoxExColumns }

function TSharpEListBoxExColumns.Add(AOwner:TComponent):TSharpEListBoxExColumn;
begin
  result := inherited Add as TSharpEListBoxExColumn;
  Result.Owner := Aowner;
end;

procedure TSharpEListBoxExColumns.Delete(
  ASharpEListBoxExColumn: TSharpEListBoxExColumn);
begin

end;

procedure TSharpEListBoxExColumns.Delete(AIndex: Integer);
begin
  inherited Items[AIndex] as TSharpEListBoxExColumn;
end;

function TSharpEListBoxExColumns.GetItem(
  Index: Integer): TSharpEListBoxExColumn;
begin
  result := inherited Items[Index] as TSharpEListBoxExColumn;
end;

procedure TSharpEListBoxExColumns.SetItem(Index: Integer;
  const Value: TSharpEListBoxExColumn);
begin
  inherited Items[Index] := Value;
end;

end.


