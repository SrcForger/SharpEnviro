unit SharpEListBoxEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PngImageList, PngImage, Types, ComCtrls, Extctrls, JclFileUtils, GR32, GR32_Image, JclGraphics;

type
  TSEColumn_WidthType = (cwtPercent, cwtPixel);
  TSEColumn_Align = (calLeft, calRight);
  TSEColumn_Type = (ctDefault, ctCheck);

  TSharpEListBoxExColumn = class(TCollectionItem)
  private
    FWidth: Integer;
    FVAlign: TVerticalAlignment;
    FHAlign: TAlignment;
    FColumnRect: TRect;
    FOwner: TComponent;
    FImages: TPngImageList;
    FColumnAlign: TSEColumn_Align;
    FSelectedImages: TPngImageList;
    FStretchColumn: Boolean;
    FCursorRect: TRect;
    FCanSelect: Boolean;
    FColumnType: TSEColumn_Type;

    procedure SetWidth(const Value: Integer);
    procedure SetHAlign(const Value: TAlignment);
    procedure SetVAlign(const Value: TVerticalAlignment);
    property Owner: TComponent read FOwner write fOwner;
  public

    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    property CursorRect: TRect read FCursorRect write FCursorRect;
  published
    property Width: Integer read FWidth write SetWidth;
    property ColumnRect: TRect read FColumnRect write FColumnRect;

    property HAlign: TAlignment read FHAlign write SetHAlign;
    property VAlign: TVerticalAlignment read FVAlign write SetVAlign;
    property ColumnAlign: TSEColumn_Align read FColumnAlign write FColumnAlign;
    property StretchColumn: Boolean read FStretchColumn write FStretchColumn;
    property CanSelect: Boolean read FCanSelect write FCanSelect default True;
    property ColumnType: TSEColumn_Type read FColumnType write FColumnType;

    property Images: TPngImageList read
      FImages write FImages;
    property SelectedImages: TPngImageList read
      FSelectedImages write FSelectedImages;
  end;

  TSharpEListBoxExColumns = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TSharpEListBoxExColumn;
    procedure SetItem(Index: Integer; const Value: TSharpEListBoxExColumn);
  public
    function Add(AOwner: TComponent): TSharpEListBoxExColumn;
    procedure Delete(AIndex: Integer); overload;
    procedure Delete(ASharpEListBoxExColumn: TSharpEListBoxExColumn); overload;
    property Item[Index: Integer]: TSharpEListBoxExColumn read GetItem write SetItem;
  end;

  TSharpEListBoxExColors = class(TPersistent)
  private
    FBorderColor: TColor;
    FItemColorSelected: TColor;
    FBorderColorSelected: TColor;
    FCheckColorSelected: TColor;
    FItemColor: TColor;
    FCheckColor: TColor;
  published
    property BorderColor: TColor read FBorderColor write FBorderColor;
    property BorderColorSelected: TColor read FBorderColorSelected write FBorderColorSelected;
    property ItemColor: TColor read FItemColor write FItemColor;
    property ItemColorSelected: TColor read FItemColorSelected write FItemColorSelected;
    property CheckColorSelected: TColor read FCheckColorSelected write FCheckColorSelected;
    property CheckColor: TColor read FCheckColor write FCheckColor;

  end;

  TSharpEListItem = class(TPersistent)
  private
    FSubItems: TStringList;
    FSubItemImages: TList;
    FSubItemSelectedImages: TList;
    FData: Pointer;
    FHint: string;
    FID: Integer;
    FOwner: TComponent;
    FSubItemCheckedStates: TList;

    function GetSubItemText(ASubItem: Integer): string;
    procedure SetSubItemText(ASubItem: Integer; const Value: string);

    procedure SetSubItemSelectedImageIndex(ASubItemIndex: Integer;
      const Value: Integer);
    function GetSubItemSelectedImageIndex(ASubItemIndex: Integer): Integer;

    function GetSubItemImageIndex(ASubItemIndex: Integer): Integer;
    procedure SetSubItemImageIndex(ASubItemIndex: Integer;
      const Value: Integer);
    function GetCaption: string;
    procedure SetCaption(const Value: string);
    function GetImageIndex: Integer;
    procedure SetImageIndex(const Value: Integer);
    function GetChecked: Boolean;
    function GetSubItemChecked(ASubItemIndex: Integer): boolean;
    procedure SetSubItemChecked(ASubItemIndex: Integer; const Value: boolean);

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    function AddSubItem(AText: string; AImageIndex: Integer = -1; 
      ASelectedImageIndex: Integer = -1): Integer; overload;
    function AddSubItem(AText: string; AChecked:Boolean): Integer; overload;
    property Hint: string read FHint write FHint;
    property Data: Pointer read FData write FData;
    property ID: Integer read FID write FID;
    property Caption: string read GetCaption write SetCaption;
    property ImageIndex: Integer read GetImageIndex write SetImageIndex;
    property Checked: Boolean read GetChecked;

    property SubItemImageIndex[ASubItemIndex: Integer]: Integer read GetSubItemImageIndex write
    SetSubItemImageIndex; default;
    property SubItemSelectedImageIndex[ASubItemIndex: Integer]: Integer read GetSubItemSelectedImageIndex write
    SetSubItemSelectedImageIndex;

    property SubItemImageIndexes: TList read FSubItemImages write FSubItemImages;
    property SubItemSelectedImageIndexes: TList read FSubItemSelectedImages write FSubItemSelectedImages;
    property SubItemCheckedStates: TList read FSubItemCheckedStates write FSubItemCheckedStates;

    property SubItemChecked[ASubItem: Integer]: boolean read GetSubItemChecked write SetSubItemChecked;
    property SubItemText[ASubItem: Integer]: string read GetSubItemText write SetSubItemText;
    function SubItemCount: Integer;
  end;

  TSharpEListBoxExOnClickCheck = procedure(const ACol: Integer; AItem: TSharpEListItem; var AChecked:Boolean) of object;
  TSharpEListBoxExOnClickItem = procedure(const ACol: Integer; AItem: TSharpEListItem) of object;
  TSharpEListBoxExGetItemColor = procedure(const AItem: Integer; var AColor: TColor) of object;
  TSharpEListBoxExGetColCursor = procedure(const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor) of object;
  TSharpEListBoxExGetColText = procedure(const ACol: Integer; AItem: TSharpEListItem; var AColText: string) of object;
  TSharpEListBoxExGetColImageIndex = procedure(const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: integer; const ASelected: Boolean) of object;
  TSharpEListBoxExGetColClickable = procedure(const ACol: Integer; AItem: TSharpEListItem; var AClickable: Boolean) of object;

  TSharpEListBoxEx = class(TCustomListBox)
  private
    FPngImageCollection: TPngImageCollection;
    FColors: TSharpEListBoxExColors;
    FItemOffset: TPoint;
    FColumns: TSharpEListBoxExColumns;
    FOnClickItem: TSharpEListBoxExOnClickItem;
    FOnGetCellCursor: TSharpEListBoxExGetColCursor;
    FOnDblClickItem: TSharpEListBoxExOnClickItem;
    FOnGetCellColor: TSharpEListBoxExGetItemColor;
    FAutoSizeGrid: Boolean;
    FOnGetCellText: TSharpEListBoxExGetColText;
    FOnGetCellImageIndex: TSharpEListBoxExGetColImageIndex;
    FLast: Integer;
    FOnGetCellClickable: TSharpEListBoxExGetColClickable;

    FOnClickCheck: TSharpEListBoxExOnClickCheck;
    procedure ResizeEvent(Sender: TObject);
    procedure DrawItemEvent(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure DrawSelection(ARect: TRect; AState: TOwnerDrawState; AItem: TSharpEListItem);
    procedure SetColors(const Value: TSharpEListBoxExColors);
    procedure DrawItemText(ACanvas: TCanvas; ARect: TRect; AFlags: Longint;
      Aitem: TSharpEListItem; ACol: Integer; APngImage: TPngObject);
    procedure DrawItemImage(ACanvas: TCanvas; ARect: TRect;
      AItem: TSharpEListItem; ACol: Integer; APngImage: TPNGObject);
    function GetColumn(AColumn: Integer): TSharpEListBoxExColumn;
    function GetColumnCount: Integer;
    procedure SetColumn(AColumn: Integer; const Value: TSharpEListBoxExColumn);
    procedure MouseMoveEvent(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MeasureItemEvent(Control: TWinControl; Index: Integer;
      var Height: Integer);

    function GetItem(AItem: Integer): TSharpEListItem;
    procedure SetItem(AItem: Integer; const Value: TSharpEListItem);
    procedure UpdateColumnSizes;
    procedure SetColumns(const Value: TSharpEListBoxExColumns);

    function IsImageIndexValid(AItem: TSharpEListItem; ACol,
      AImageIndex: Integer; ASelected: Boolean): Boolean;

    procedure SetAutoSizeGrid(const Value: Boolean);

    function GetSelectedItem: TSharpEListItem;
    procedure DrawDefaultItem(AItem: TSharpEListItem;
      ASelected: Boolean; AColumn: TSharpEListBoxExColumn);
    procedure DrawCheckedItem(AItem: TSharpEListItem;
      AChecked: Boolean; AColumn: TSharpEListBoxExColumn);

  public

    constructor Create(Sender: TComponent); override;
    destructor Destroy; override;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    property Item[AItem: Integer]: TSharpEListItem read GetItem write
    SetItem; default;

    function AddColumn(AText: string): TSharpEListBoxExColumn;
    property ColumnCount: Integer read GetColumnCount stored True;

    function AddItem(AText: string;
      AImageIndex: Integer = -1; ASelectedImageIndex: Integer = -1): TSharpEListItem;  overload;
    function AddItem(AText: string; AChecked:Boolean): TSharpEListItem; overload;

    property SelectedItem: TSharpEListItem read GetSelectedItem;
    property Column[AColumn: Integer]: TSharpEListBoxExColumn read GetColumn
    write SetColumn;

    function GetItemAtCursorPos(ACursorPosition: TPoint): TSharpEListItem;
    function GetColumnAtMouseCursorPos: TSharpEListBoxExColumn;
  protected
    procedure Loaded; override;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;

  published
    property Columns: TSharpEListBoxExColumns read FColumns write SetColumns stored True;
    property Colors: TSharpEListBoxExColors read FColors write SetColors stored True;
    property Color;
    property Font;
    property Anchors;
    property PopupMenu;
    property Constraints;
    property OnResize;

    property ItemHeight;
    property OnClickCheck: TSharpEListBoxExOnClickCheck read FOnClickCheck write FOnClickCheck;
    property OnClickItem: TSharpEListBoxExOnClickItem read FOnClickItem write FOnClickItem stored True;
    property OnGetCellCursor: TSharpEListBoxExGetColCursor read FOnGetCellCursor write FOnGetCellCursor stored True;
    property OnGetCellColor: TSharpEListBoxExGetItemColor read FOnGetCellColor write FOnGetCellColor;
    property OnGetCellText: TSharpEListBoxExGetColText read FOnGetCellText write FOnGetCellText;
    property OnGetCellImageIndex: TSharpEListBoxExGetColImageIndex read FOnGetCellImageIndex write FOnGetCellImageIndex;
    property OnGetCellClickable: TSharpEListBoxExGetColClickable read FOnGetCellClickable write FOnGetCellClickable;

    property ItemOffset: TPoint read FItemOffset write FItemOffset;
    property AutosizeGrid: Boolean read FAutoSizeGrid write SetAutoSizeGrid;
    property BevelInner;
    property BevelOuter;
    property Borderstyle;
    property Ctl3d;
    property Align;
    property ParentFont;
  end;

procedure Register;

implementation

uses
  JvJVCLUtils;

  {$R SharpEListBoxEx.res}

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpEListBoxEx]);
end;

{ TSharpEListBoxExItemColumn }

procedure TSharpEListBoxExColumn.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ TSharpEListBoxEx }

function TSharpEListBoxEx.AddColumn(AText: string): TSharpEListBoxExColumn;
begin
  Result := FColumns.Add(Self);
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
  Self.DoubleBuffered := False;
  Self.Style := lbOwnerDrawVariable;
  Self.OnDrawItem := DrawItemEvent;

  Self.OnMouseMove := MouseMoveEvent;
  //Self.OnMeasureItem := MeasureItemEvent;

  Self.OnResize := ResizeEvent;
  Self.Color := clWindow;

  FColors := TSharpEListBoxExColors.Create;
  FColors.ItemColor := clWindow;
  FColors.ItemColorSelected := clBtnFace;
  FColors.CheckColorSelected := clBtnFace;
  FColors.CheckColor := $00ecf1e9;
  FColors.BorderColor := clBtnFace;
  FColors.BorderColorSelected := clBtnShadow;

  FColumns := TSharpEListBoxExColumns.Create(Self, TSharpEListBoxExColumn);

  ItemHeight := 30;
  FItemOffset := Point(2, 2);
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
  tmpCol: TSharpEListBoxExColumn;
  tmpPng: TPngObject;
  R: TRect;
  iCol, iImgIdx, iSelImgIdx: Integer;
  bSelected: Boolean;
  tmpItem: TSharpEListItem;
begin
  UpdateColumnSizes;
  tmpItem := TSharpEListItem(Self.Items.Objects[Index]);
  Rect.Right := Self.ClientWidth;

  bSelected := (Index = ItemIndex);

  if Assigned(tmpItem) then begin
    SetBkMode(Self.Canvas.Handle, TRANSPARENT);

    // Draw Selection
    DrawSelection(Rect, State, tmpItem);

    // Draw Columns
    for iCol := 0 to Pred(ColumnCount) do begin

      tmpCol := Column[iCol];
      Column[iCol].ColumnRect := Types.Rect(Column[iCol].ColumnRect.Left, Rect.Top,
        Column[iCol].ColumnRect.Right, Rect.Bottom);
      R := Column[iCol].ColumnRect;

      if (iCol <= tmpItem.SubItemCount - 1) then begin

        case Column[iCol].ColumnType of
          ctDefault: DrawDefaultItem(tmpItem, bSelected, tmpCol);
          ctCheck: DrawCheckedItem(tmpItem, bSelected, tmpCol);
        end;

      end;
    end;
  end;
end;

procedure TSharpEListBoxEx.DrawItemImage(ACanvas: TCanvas; ARect: TRect;
  AItem: TSharpEListItem; ACol: Integer; APngImage: TPNGObject);
var
  R: TRect;
  iW, iH, iItemHWOffsets, iItemWWOffsets, n: Integer;
begin
  iW := APngImage.Width;
  iH := APngImage.Height;

  // Vertical postion
  case Column[ACol].VAlign of
    taAlignTop: R := Rect(0, ARect.Top + ItemOffset.Y, 0, ARect.Top + ItemOffset.Y + iH);
    taAlignBottom: R := Rect(0, ARect.Bottom - ItemOffset.Y - iH, 0, ARect.Bottom - ItemOffset.Y);
    taVerticalCenter: begin
        iItemHWOffsets := ItemHeight;
        n := (iItemHWOffsets div 2) - (iH div 2);

        R := Rect(0, ARect.Top + n, 0, ARect.Top + n + iH);
      end;
  end;

  // Horizontal position
  case Column[ACol].HAlign of
    taLeftJustify: R := Rect(ARect.Left + 0 + ItemOffset.X, R.Top, Arect.Left + iW, R.Bottom);
    taRightJustify: R := Rect(Arect.Right - iw - ItemOffset.X, R.Top, ARect.Right, R.Bottom);

    taCenter: begin
        iItemWWOffsets := ARect.Right - ARect.Left;
        R := Rect(ARect.Left + (iItemWWOffsets div 2) - (iW div 2), R.Top, ARect.Left + (iItemWWOffsets div 2) + iW, R.Bottom);
      end;
  end;

  if R.Right - R.Left > 0 then
    if R.Bottom - R.Top > 0 then
      APngImage.Draw(ACanvas, R);
end;

procedure TSharpEListBoxEx.DrawItemText(ACanvas: TCanvas; ARect: TRect;
  AFlags: Integer; Aitem: TSharpEListItem; ACol: Integer; APngImage: TPNGObject);
var
  sColText: string;
  iImgWidth, iTextHeight: Integer;
  bmp32: TBitmap32;
  rColRect, rTextRect: TRect;
  iItemHWOffsets, n: Integer;
begin
  // Init
  sColText := Aitem.SubItemText[ACol];
  if Assigned(FOnGetCellText) then begin
    FOnGetCellText(ACol, Aitem, sColText);
  end;

  rColRect := ARect;

  // Get Image Width
  iImgWidth := 0;
  if APngImage <> nil then
    iImgWidth := APngImage.Width + 8;

  // Define Horizontal Column Align
{$REGION 'ColumnAlign'}
  case Column[Acol].HAlign of
    taLeftJustify: begin
        sColText := '<ALIGN="LEFT">' + sColText;
        rColRect.Left := rColRect.Left + iImgWidth + ItemOffset.X;
      end;
    taRightJustify: begin
        sColText := '<ALIGN="RIGHT">' + sColText;
        rColRect.Right := rColRect.Right - iImgWidth - ItemOffset.X;
      end;
    taCenter: sColText := '<ALIGN="CENTER">' + sColText;
  end;
{$ENDREGION}

  // Define Vertical Column Align
{$REGION 'VerticalAlign'}
  ACanvas.Font := Self.Font;
  iTextHeight := HTMLTextHeight(ACanvas, sColText, 100);
  case Column[ACol].VAlign of
    taAlignTop: rColRect := Rect(rColRect.Left, ARect.Top + ItemOffset.Y, rColRect.Right, ARect.Top + ItemOffset.Y + iTextHeight);
    taAlignBottom: rColRect := Rect(rColRect.Left, ARect.Bottom - ItemOffset.Y - iTextHeight, rColRect.Right, ARect.Bottom - ItemOffset.Y);
    taVerticalCenter: begin
        iItemHWOffsets := ItemHeight-ItemOffset.Y;
        n := (iItemHWOffsets div 2) - (iTextHeight div 2);

        rColRect := Rect(rColRect.Left, ARect.Top + n, rColRect.Right, ARect.Top + n + iTextHeight);
      end;
  end;
{$ENDREGION}

  bmp32 := TBitmap32.Create;
  try
    bmp32.SetSize(rColRect.Right - rColRect.Left, rColRect.Bottom - rColRect.Top);
    bmp32.draw(bmp32.ClipRect, rColRect, ACanvas.Handle);
    bmp32.Canvas.Font := Self.Font;
    rTextRect := bmp32.ClipRect;

    if rColRect.Right - rColRect.Left > 0 then
      if rColRect.Bottom - rColRect.Top > 0 then begin
        SetBkMode(bmp32.Canvas.Handle, TRANSPARENT);
        HTMLDrawText(bmp32.Canvas, rTextRect, [], sColText, 100);
      end;

  finally
    bmp32.DrawTo(ACanvas.Handle, rColRect.Left, rColRect.Top);
    bmp32.Free;
  end;

end;

procedure TSharpEListBoxEx.DrawSelection(ARect: TRect;
  AState: TOwnerDrawState; AItem: TSharpEListItem);
var
  tmpColor: TColor;
  i:Integer;
  col: TSharpEListBoxExColumn;
  x,y: Integer;
begin
  Self.Canvas.Brush.Color := Color;
  Self.Canvas.FillRect(ARect);

  tmpColor := Colors.ItemColor;
  if Assigned(FOnGetCellColor) then
    FOnGetCellColor(AItem.ID, tmpColor);

  y := 0;
  if AItem.ID = 0 then begin
    y := itemoffset.Y;
  end;

  // Checked
    if AItem.Checked then  begin
      tmpColor :=  FColors.CheckColor;
    end;

  if not (Enabled) then
    tmpColor := clWindow;

  Self.Canvas.Brush.Color := tmpColor;
  Self.Canvas.Pen.Color := tmpColor;

  Self.Canvas.RoundRect(ARect.Left + ItemOffset.X, ARect.Top + y,
      ARect.Right - (ItemOffset.X), ARect.Bottom - itemoffset.Y, 10, 10);

  // Get Colours
  if odSelected in AState then begin
    tmpColor := Colors.ItemColorSelected;

    if Assigned(FOnGetCellColor) then
      FOnGetCellColor(AItem.ID, tmpColor);

    if AItem.Checked then  begin
      tmpColor := FColors.FCheckColorSelected;
    end;

    if not (Enabled) then
      tmpColor := clBtnFace;

    Self.Canvas.Brush.Color := tmpColor;
    Self.Canvas.Pen.Color := tmpColor;

    Self.Canvas.RoundRect(ARect.Left + ItemOffset.X, ARect.Top + y,
      ARect.Right - (ItemOffset.X), ARect.Bottom - itemoffset.Y, 10, 10);
  end;

  if (odFocused in AState) and (odSelected in AState) then begin
    Self.Canvas.Brush.Color := Colors.ItemColorSelected;
    Self.Canvas.Pen.Color := Colors.BorderColorSelected;

    if not (Enabled) then begin
      Self.Canvas.Brush.Color := clBtnFace;
      Self.Canvas.Pen.Color := clBtnFace;
    end;

    if AItem.Checked then  begin
      Self.Canvas.Brush.Color :=  $00def3d5;
      Self.Canvas.Pen.Color := $00def3d5;
    end;

    Self.Canvas.RoundRect(ARect.Left + ItemOffset.X, ARect.Top + y,
      ARect.Right - (ItemOffset.X), ARect.Bottom - itemoffset.Y, 10, 10);
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

function TSharpEListBoxEx.GetColumnAtMouseCursorPos: TSharpEListBoxExColumn;
var
  iCol, X, Y: Integer;
  R: TRect;
  tmpItem: TSharpEListItem;
  pt: TPoint;
begin
  result := nil;

  tmpItem := GetItemAtCursorPos(Mouse.CursorPos);
  if tmpItem = nil then begin
    exit;
  end;

  pt := Self.ScreenToClient(Mouse.CursorPos);
  X := pt.X;
  Y := pt.Y;

  for iCol := 0 to Pred(ColumnCount) do begin

    R := Self.ItemRect(tmpItem.ID);

    if (X > Column[iCol].ColumnRect.Left) and (X < Column[iCol].ColumnRect.Right) and
      (Y > R.Top) and (Y < R.Bottom) then begin

      Result := Column[iCol];
      break;
    end;
  end;
end;

procedure TSharpEListBoxEx.SetAutoSizeGrid(const Value: Boolean);
begin
  FAutoSizeGrid := Value;

  if not (csDesigning in ComponentState) and FAutoSizeGrid then
    Self.Height := Self.Count * Self.ItemHeight;
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

procedure TSharpEListBoxExColumn.SetVAlign(const Value: TVerticalAlignment);
begin
  FVAlign := Value;
end;

procedure TSharpEListBoxEx.SetColumns(const Value: TSharpEListBoxExColumns);
begin
  FColumns.Assign(Value);
end;

procedure TSharpEListBoxEx.Loaded;
begin
  inherited;
  if ItemHeight < 30 then
    ItemHeight := 30;
end;

{ TSharpEListItem }

function TSharpEListItem.AddSubItem(AText: string; AImageIndex: Integer = -1;
  ASelectedImageIndex: Integer = -1): Integer;
begin
  Result := -1;

  FSubItems.Add(AText);
  FSubItemCheckedStates.Add(Pointer(-1));
  FSubItemImages.Add(Pointer(AImageIndex));
  FSubItemSelectedImages.Add(Pointer(ASelectedImageIndex));
  
end;

function TSharpEListItem.AddSubItem(AText: string; AChecked: Boolean): Integer;
begin
  Result := -1;

  FSubItems.Add(AText);
  FSubItemCheckedStates.Add(Pointer(Integer(AChecked)));
  FSubItemImages.Add(Pointer(-1));
  FSubItemSelectedImages.Add(Pointer(-1));

end;

constructor TSharpEListItem.Create(AOwner: TComponent);
begin
  FOwner := AOwner;
  FSubItems := TStringList.Create;
  FSubItemImages := TList.Create;
  FSubItemSelectedImages := TList.Create;
  FSubItemCheckedStates := TList.Create;
end;

destructor TSharpEListItem.Destroy;
begin
  FSubItems.Free;
  FSubItemImages.Free;
  FSubItemSelectedImages.Free;
  FSubItemCheckedStates.Free;
  inherited;
end;

function TSharpEListItem.GetSubItemSelectedImageIndex(
  ASubItemIndex: Integer): Integer;
var
  col, idx: Integer;
  b: Boolean;
begin
  col := ASubItemIndex;
  idx := Integer(FSubItemSelectedImages[ASubItemIndex]);
  b := true;

  if Assigned(TSharpEListBoxEx(FOwner).FOnGetCellImageIndex) then begin
    TSharpEListBoxEx(FOwner).FOnGetCellImageIndex(col, Self, idx, b);
    Result := idx;
  end
  else
    Result := idx;

end;

function TSharpEListItem.GetCaption: string;
begin
  Result := GetSubItemText(0);
end;

function TSharpEListItem.GetChecked: Boolean;
var
  i:Integer;
  b: Boolean;
  col: TSharpEListBoxExColumn;
begin
  Result := False;
  for i := 0 to Pred(TSharpEListBoxEx(FOwner).ColumnCount) do begin
    if SubItemChecked[i] = True then begin
      Result := True;
      exit;
    end;
  end;
end;

function TSharpEListItem.GetImageIndex: Integer;
begin
  Result := GetSubItemImageIndex(0);
end;

function TSharpEListItem.GetSubItemChecked(ASubItemIndex: Integer): boolean;
var
  col, idx: Integer;
  b: Boolean;
begin
  Result := False;

  if (ASubItemIndex < FSubItemCheckedStates.Count ) then begin
    col := ASubItemIndex;
    b := Boolean(FSubItemCheckedStates[ASubItemIndex]);
    Result := b;
  end;
end;

function TSharpEListItem.GetSubItemImageIndex(ASubItemIndex: Integer): Integer;
var
  col, idx: Integer;
  b: Boolean;
begin
  col := ASubItemIndex;
  idx := Integer(FSubItemImages[ASubItemIndex]);
  b := false;

  if Assigned(TSharpEListBoxEx(FOwner).FOnGetCellImageIndex) then begin
    TSharpEListBoxEx(FOwner).FOnGetCellImageIndex(col, Self, idx, b);
    Result := idx;
  end
  else
    Result := idx;

end;

function TSharpEListItem.GetSubItemText(ASubItem: Integer): string;
var
  col: Integer;
  s: string;
begin
  col := ASubItem;
  s := FSubItems[ASubItem];

  if Assigned(TSharpEListBoxEx(FOwner).FOnGetCellText) then begin
    TSharpEListBoxEx(FOwner).FOnGetCellText(col, Self, s);
    Result := s;
  end
  else
    Result := s;
end;

function TSharpEListBoxEx.AddItem(AText: string;
  AImageIndex: Integer = -1; ASelectedImageIndex: Integer = -1): TSharpEListItem;
begin
  Result := TSharpEListItem.Create(Self);
  Result.AddSubItem(AText, AImageIndex, ASelectedImageIndex);

  Result.ID := Self.Items.AddObject(AText, Result);

  if FAutoSizeGrid then
    Self.Height := (Self.Count + 1) * Self.ItemHeight;
end;

function TSharpEListBoxEx.AddItem(AText: string;
  AChecked: Boolean): TSharpEListItem;
begin
  Result := TSharpEListItem.Create(Self);
  Result.AddSubItem(AText, AChecked);

  Result.ID := Self.Items.AddObject(AText, Result);

  if FAutoSizeGrid then
    Self.Height := (Self.Count + 1) * Self.ItemHeight;
end;

procedure TSharpEListItem.SetSubItemSelectedImageIndex(ASubItemIndex: Integer;
  const Value: Integer);
begin
  FSubItemSelectedImages[ASubItemIndex] := Pointer(Value);
end;

procedure TSharpEListItem.SetCaption(const Value: string);
begin
  FSubItems[0] := Value;
  TSharpEListBoxEx(FOwner).Invalidate;
end;

procedure TSharpEListItem.SetImageIndex(const Value: Integer);
begin
  FSubItemImages[0] := Pointer(Value);
  TSharpEListBoxEx(FOwner).Invalidate;
end;

procedure TSharpEListItem.SetSubItemChecked(ASubItemIndex: Integer;
  const Value: boolean);
begin
  If ASubItemIndex < FSubItemCheckedStates.Count then
    FSubItemCheckedStates[ASubItemIndex] := Pointer(value);

  TSharpEListBoxEx(FOwner).Invalidate;
end;

procedure TSharpEListItem.SetSubItemImageIndex(ASubItemIndex: Integer;
  const Value: Integer);
begin
  FSubItemImages[ASubItemIndex] := Pointer(Value);
  TSharpEListBoxEx(FOwner).Invalidate;
end;

procedure TSharpEListItem.SetSubItemText(ASubItem: Integer; const Value: string);
begin
  FSubItems[ASubItem] := Value;
  TSharpEListBoxEx(FOwner).Invalidate;
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
  fixedwidth: integer;
  scount: integer;
  stretchedwidth: integer;
begin
  fixedwidth := 0;
  stretchedwidth := 0;
  scount := 0;
  for i := 0 to ColumnCount - 1 do
    if (not Column[i].StretchColumn) then
      fixedwidth := fixedwidth + Column[i].Width
    else
      scount := scount + 1;

  x := 0;
  if scount > 0 then
    stretchedwidth := (Width - fixedwidth) div scount;
  for i := 0 to ColumnCount - 1 do
    if (Column[i].ColumnAlign = calLeft) then begin
      if Column[i].StretchColumn then begin
        Column[i].ColumnRect := Rect(x + ItemOffset.X, 0,
          x + stretchedwidth - ItemOffset.X, ItemHeight);

        x := x + stretchedwidth;
      end
      else begin
        Column[i].ColumnRect := Rect(x + ItemOffset.X, 0,
          x + Column[i].Width - ItemOffset.X, ItemHeight);

        x := x + Column[i].Width;
      end;
    end;

  x := width;
  for i := ColumnCount - 1 downto 0 do
    if (Column[i].ColumnAlign = calRight) then begin
      if Column[i].StretchColumn then begin
        Column[i].ColumnRect := Rect(x - stretchedwidth - ItemOffset.X, 0, x - (ItemOffset.X * 2), ItemHeight);
        x := x - stretchedwidth;
      end
      else begin
        Column[i].ColumnRect := Rect(x - Column[i].Width - ItemOffset.X, 0, x - (ItemOffset.X * 2), ItemHeight);
        x := x - Column[i].Width;
      end;
    end;
end;

procedure TSharpEListBoxEx.WMLButtonDown(var Message: TWMLButtonDown);
var
  ItemNo: Integer;
  tmpItem: TSharpEListItem;
  tmpCol: TSharpEListBoxExColumn;
  bCanSelect, bChecked: Boolean;
  p: TPoint;
  ShiftState: TShiftState;
begin
  ShiftState := KeysToShiftState(Message.Keys);
  if (DragMode = dmAutomatic) and FMultiSelect then begin
    if not (ssShift in ShiftState) or (ssCtrl in ShiftState) then begin
      ItemNo := ItemAtPos(SmallPointToPoint(Message.Pos), True);
      if (ItemNo >= 0) and (Selected[ItemNo]) then begin
        BeginDrag(False);
        Exit;
      end;
    end;
  end;

  p := SmallPointToPoint(Message.Pos);
  ItemNo := ItemAtPos(p, True);

  if ItemNo <> -1 then begin
    tmpItem := Self.Item[itemNo];
    tmpCol := GetColumnAtMouseCursorPos;

    if tmpCol <> nil then begin

      bCanSelect := tmpCol.CanSelect;
      if assigned(FOnGetCellClickable) then
        FOnGetCellClickable(tmpCol.ID, tmpItem, bCanSelect);

      if tmpCol.ColumnType = ctCheck then begin

        bChecked := Not(tmpItem.SubItemChecked[tmpCol.ID]);
        tmpItem.SubItemChecked[tmpCol.ID] := bChecked;
        bCanSelect := False;

        if assigned(FOnClickCheck) then
          FOnClickCheck(tmpCol.ID, tmpItem, bChecked);
      end;

      if bCanSelect then begin
        Self.ItemIndex := ItemNo;
        Self.Invalidate;

        if Assigned(FOnClickItem) then
          FOnClickItem(tmpCol.ID, tmpItem);
      end
      else begin
        if Assigned(FOnClickItem) then
          FOnClickItem(tmpCol.ID, tmpItem);
      end;
    end;
  end
  else
    inherited;

  {if (DragMode = dmAutomatic) and not (FMultiSelect and
    ((ssCtrl in ShiftState) or (ssShift in ShiftState))) then
    BeginDrag(False); }
end;

function TSharpEListBoxEx.GetItem(AItem: Integer): TSharpEListItem;
begin
  Result := nil;
  if Self.Items.Count <> 0 then
    if AItem <> -1 then
      Result := TSharpEListItem(Self.Items.Objects[AItem]);
end;

function TSharpEListBoxEx.GetItemAtCursorPos(
  ACursorPosition: TPoint): TSharpEListItem;
var
  n: Integer;
begin
  result := nil;
  n := Self.ItemAtPos(Self.ScreenToClient(ACursorPosition), true);
  if n <> -1 then
    Result := Item[n];
end;

function TSharpEListBoxEx.GetSelectedItem: TSharpEListItem;
begin
  Result := nil;
  if Self.ItemIndex <> -1 then
    Result := Item[Self.ItemIndex];
end;

function TSharpEListBoxEx.IsImageIndexValid(AItem: TSharpEListItem;
  ACol, AImageIndex: Integer; ASelected: Boolean): Boolean;

  function SelectedValid: Boolean;
  begin
    Result := False;
    if ((AImageIndex <> -1) and (Column[ACol].SelectedImages <> nil) and
      (AImageIndex < Column[ACol].SelectedImages.PngImages.Count) and
      (Column[ACol].SelectedImages.PngImages[AImageIndex] <> nil)) then
      Result := True;
  end;

  function DefaultValid: Boolean;
  begin
    Result := False;
    if ((AImageIndex <> -1) and (Column[ACol].Images <> nil) and
      (Column[ACol].Images <> nil) and (AImageIndex < Column[ACol].Images.PngImages.Count) and
      (Column[ACol].Images.PngImages[AImageIndex] <> nil)) then
      Result := True;
  end;

begin
  Result := False;

  if ASelected then begin
    if (Column[ACol].SelectedImages = nil) then
      Result := DefaultValid
    else
      Result := SelectedValid;
  end
  else
    Result := DefaultValid;
end;

procedure TSharpEListBoxEx.SetItem(AItem: Integer;
  const Value: TSharpEListItem);
begin
  Self.Items.Objects[AItem] := Value;
end;

procedure TSharpEListBoxEx.MeasureItemEvent(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  if Index = 0 then
    Height := 20;
end;

procedure TSharpEListBoxEx.MouseMoveEvent(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  iCol: Integer;
  R: TRect;
  cur: TCursor;
  tmpItem: TSharpEListItem;
  b: Boolean;
begin
  Self.Cursor := crDefault;
  tmpItem := GetItemAtCursorPos(Mouse.CursorPos);
  if tmpItem = nil then
    exit;

  for iCol := 0 to Pred(ColumnCount) do begin

    R := Self.ItemRect(tmpItem.ID);

    if (X > Column[iCol].ColumnRect.Left) and (X < Column[iCol].ColumnRect.Right) and
      (Y > R.Top) and (Y < R.Bottom) then begin

      cur := crDefault;

      b := Column[iCol].CanSelect;
      if Assigned(FOnGetCellClickable) then
        FOnGetCellClickable(iCol, tmpItem, b);

      //if b then
        if Assigned(FOnGetCellCursor) then
          FOnGetCellCursor(iCol, tmpItem, cur);

      Self.Cursor := cur;
      exit;
    end;
  end;
end;

procedure TSharpEListBoxEx.ResizeEvent(Sender: TObject);
begin
  UpdateColumnSizes;

  Self.Invalidate;
end;

constructor TSharpEListBoxExColumn.Create(Collection: TCollection);
begin
  inherited;
  FCanSelect := True;
  FWidth := 30;
  FVAlign := taVerticalCenter;
  FHAlign := taLeftJustify;
  FStretchColumn := False;
  FOwner := TSharpEListBoxEx(Collection.Owner);
end;

destructor TSharpEListBoxExColumn.Destroy;
begin
  inherited;
end;

procedure TSharpEListBoxEx.DrawCheckedItem(AItem: TSharpEListItem;
  AChecked: Boolean; AColumn: TSharpEListBoxExColumn);
var
  iCol: Integer;
  r:TRect;
  bChecked: Boolean;
  tmpPng: TPNGObject;
begin

  iCol := AColumn.Index;
  r := AColumn.ColumnRect;

  // Get the checked state
  tmpPng := TPNGObject.Create;
  Try
    bChecked := AItem.SubItemChecked[iCol];
    if bChecked  then
      tmpPng.LoadFromResourceName(HInstance, 'SHARPE_LISTBOXEX_CHECK_PNG' ) else
      tmpPng.LoadFromResourceName(HInstance, 'SHARPE_LISTBOXEX_UNCHECK_PNG' );

  DrawItemImage(Self.Canvas, r, AItem, iCol, tmpPng);
  DrawItemText(Self.Canvas, r, 0, AItem, iCol, tmpPng);
  Finally
    tmpPng.Free;
  End;
end;

procedure TSharpEListBoxEx.DrawDefaultItem(AItem: TSharpEListItem;
  ASelected: Boolean; AColumn: TSharpEListBoxExColumn);
var
  iSelImgIdx: Integer;
  iImgIdx: Integer;
  iCol: Integer;
  tmpPng: TPNGObject;
  r: TRect;
begin

  iCol := AColumn.Index;
  r := AColumn.ColumnRect;

  // Get the selected image index
  iSelImgIdx := AItem.SubItemSelectedImageIndex[iCol];

  // If event assigned, get this image index
  if assigned(FOnGetCellImageIndex) then
    FOnGetCellImageIndex(iCol, AItem, iSelImgIdx, True);

  // Check Draw Selected
  if ((ASelected) and (AColumn.SelectedImages <> nil) and
    (IsImageIndexValid(AItem, iCol, iSelImgIdx, ASelected))) then begin

    tmpPng := nil;
    if iSelImgIdx <> -1 then
      if AColumn.SelectedImages.PngImages[iSelImgIdx] <> nil then
        tmpPng := AColumn.SelectedImages.PngImages.Items[iSelImgIdx].PngImage;

    if tmpPng <> nil then
      DrawItemImage(Self.Canvas, r, AItem, iCol, tmpPng);

    DrawItemText(Self.Canvas, r, 0, AItem, iCol, tmpPng);
  end
  else begin
    // Else Draw Default

    // Get the default image index
    iImgIdx := AItem.SubItemImageIndex[iCol];

    // If event assigned, get this image index
    if assigned(FOnGetCellImageIndex) then
      FOnGetCellImageIndex(iCol, AItem, iImgIdx, False);

    // Check if the image index is valid
    if IsImageIndexValid(AItem, iCol, iImgIdx, ASelected) then begin

      tmpPng := nil;
      if iImgIdx <> -1 then
        tmpPng := AColumn.Images.PngImages.Items[iImgIdx].PngImage;

      if tmpPng <> nil then
        DrawItemImage(Self.Canvas, r, AItem, iCol, tmpPng);
        
      DrawItemText(Self.Canvas, r, 0, AItem, iCol, tmpPng);
    end
    else
      DrawItemText(Self.Canvas, r, 0, AItem, iCol, nil);
  end;
end;

{ TSharpEListBoxExColumns }

function TSharpEListBoxExColumns.Add(AOwner: TComponent): TSharpEListBoxExColumn;
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

