unit uSEListboxPainter;

interface

uses
  // Standard
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  sharpapi,
  ExtCtrls,
  Buttons,
  ImgList,
  ComCtrls,
  ToolWin,
  ShellApi,
  Menus,
  tlhelp32,
  Types,
  PngImageList,
  JclFileUtils,
  Tabs,
  SharpFX,
  JclGraphics,
  SharpESkinManager;

procedure PaintListbox(AListbox: TListBox; ARect: TRect; ALeftOffset:Integer; AState:
  TOwnerDrawState; AText: string; APngCollection: TPngImageCollection; AIconIndex:
  Integer; AStatus: string = ''; AFontColor: TColor = clWindowText; ASelectedColor:TColor=clBtnFace); overload;

procedure PaintListbox(AListbox: TListBox; ARect: TRect; ALeftOffset:Integer; AState:
  TOwnerDrawState; AText: string; APngImageList: TPngImageList; AIconIndex:
  Integer; AStatus: string = ''; AFontColor: TColor = clWindowText; ASelectedColor:TColor=clBtnFace); overload;

procedure PaintListbox(AListbox: TListBox; ARect: TRect; ALeftOffset:Integer; AState:
  TOwnerDrawState; AText: string; AStatus: string = ''; AFontColor: TColor = clWindowText; ASelectedColor:TColor=clBtnFace); overload;



implementation

procedure PaintListbox(AListbox: TListBox; ARect: TRect; ALeftOffset:Integer; AState:
  TOwnerDrawState; AText: string; AStatus: string = ''; AFontColor: TColor = clWindowText; ASelectedColor:TColor=clBtnFace); overload;
var
  s: string;
  tsStatus: Integer;
  R, RImg: Trect;
  w, n: Integer;
  pici: TPngImageCollectionItem;
  TextTop: Integer;
  IconWidth, IconHeight, IconTop, ItemHeight: Integer;
begin
  R := ARect;
  IconTop := 0;
  IconHeight := 0;
  pici := nil;
  IconWidth := 0;

  if R.Top > AListbox.Height then
    exit;

  SetBkMode(AListbox.Canvas.Handle,TRANSPARENT);

  ItemHeight := R.Bottom-R.Top;
  AListbox.Canvas.Font.Color := colortorgb(AFontColor);
  Alistbox.Canvas.Brush.Color := clWindow;
  AListbox.Canvas.FillRect(R);

  // Get Colours
  if odSelected in AState then
  begin
    AListbox.Canvas.Brush.Color := ASelectedColor;
    AListbox.Canvas.Pen.Color := ASelectedColor;

    AListBox.Canvas.RoundRect(R.Left-ALeftOffset,R.Top,R.Right-ALeftOffset,R.Bottom,10,10);
  end;
  if (odFocused in AState) and (odSelected in AState) then
  begin
    AListbox.Canvas.Brush.Color := ASelectedColor;
    AListbox.Canvas.Pen.Color := ASelectedColor;

    AListBox.Canvas.RoundRect(R.Left-ALeftOffset,R.Top,R.Right-ALeftOffset,R.Bottom,10,10);
  end;

  {if not (odDefault in AState) then begin
    AListbox.Canvas.FillRect(R);
  end; }

  // Get Status Text Width
  if AStatus <> '' then
    tsStatus := AListbox.Canvas.TextWidth(AStatus)
  else
    tsStatus := 0;

  // Get the center of the height, and assign it to TextTop
  TextTop := (ItemHeight div 2) - (AListbox.Canvas.TextHeight(AText) div 2);

  // Width of item
  w := R.Right;

  // Get available space for the main text
  n := w - (tsStatus + IconWidth+10);


  s := PathCompactPath(AListbox.Canvas.Handle, AText, n, cpEnd);
  AListbox.Canvas.TextOut(R.Left + IconWidth + 8, R.Top+TextTop, s);

  if AStatus <> '' then
    AListbox.Canvas.TextOut(R.Right - tsStatus - 4, R.Top+TextTop, AStatus);

end;

procedure PaintListbox(AListbox: TListBox; ARect: TRect; ALeftOffset:Integer; AState:
  TOwnerDrawState; AText: string; APngCollection: TPngImageCollection; AIconIndex:
  Integer;
  AStatus: string = ''; AFontColor: TColor = clWindowText; ASelectedColor:TColor=clBtnFace);
var
  s: string;
  tsStatus: Integer;
  R, RImg: Trect;
  w, n: Integer;
  pici: TPngImageCollectionItem;
  TextTop: Integer;
  IconWidth, IconHeight, IconTop, ItemHeight: Integer;
begin
  R := ARect;
  IconTop := 0;
  IconHeight := 0;
  pici := nil;
  IconWidth := 0;

  if R.Top > AListbox.Height then
    exit;

  SetBkMode(AListbox.Canvas.Handle,TRANSPARENT);

  ItemHeight := R.Bottom-R.Top;
  AListbox.Canvas.Font.Color := colortorgb(AFontColor);
  Alistbox.Canvas.Brush.Color := clWindow;
  AListbox.Canvas.FillRect(R);

  // Get Colours
  if odSelected in AState then
  begin
    AListbox.Canvas.Brush.Color := ASelectedColor;
    AListbox.Canvas.Pen.Color := ASelectedColor;

    AListBox.Canvas.RoundRect(R.Left-ALeftOffset,R.Top,R.Right-ALeftOffset,R.Bottom,10,10);
  end;
  if (odFocused in AState) and (odSelected in AState) then
  begin
    AListbox.Canvas.Brush.Color := ASelectedColor;
    AListbox.Canvas.Pen.Color := ASelectedColor;

    AListBox.Canvas.RoundRect(R.Left-ALeftOffset,R.Top,R.Right-ALeftOffset,R.Bottom,10,10);
  end;

  {if not (odDefault in AState) then begin
    AListbox.Canvas.FillRect(R);
  end; }

  // Get Status Text Width
  if AStatus <> '' then
    tsStatus := AListbox.Canvas.TextWidth(AStatus)
  else
    tsStatus := 0;

  // Get Icon Height+Width
  if assigned(APngCollection) then begin
    if Assigned(APngCollection.Items.Items[AIconIndex]) then begin
      pici := APngCollection.Items.Items[AIconIndex];
      IconWidth := pici.PngImage.Width;
      IconHeight := pici.PngImage.Height;
      IconTop := (ItemHeight div 2) - (IconHeight div 2);
    end;
  end;

  // Get the center of the height, and assign it to TextTop
  TextTop := (ItemHeight div 2) - (AListbox.Canvas.TextHeight(AText) div 2);

  // Width of item
  w := R.Right;

  // Get available space for the main text
  n := w - (tsStatus + IconWidth+10);


  s := PathCompactPath(AListbox.Canvas.Handle, AText, n, cpEnd);
  AListbox.Canvas.TextOut(R.Left + IconWidth + 8, R.Top+TextTop, s);

  if AStatus <> '' then
    AListbox.Canvas.TextOut(R.Right - tsStatus - 4, R.Top+TextTop, AStatus);

  if not (odDefault in AState) then begin
    if AIconIndex <> -1 then
    if assigned(pici) then begin
      RImg := Types.Rect(R.Left + 3, R.Top+IconTop, r.Left + 3 + IconWidth, R.Top + IconTop + IconHeight);
      pici.PngImage.Draw(AListbox.Canvas, RImg);
    end;
  end;
end;

procedure PaintListbox(AListbox: TListBox; ARect: TRect; ALeftOffset:Integer; AState:
  TOwnerDrawState; AText: string; APngImageList: TPngImageList; AIconIndex:
  Integer;
  AStatus: string = ''; AFontColor: TColor = clWindowText; ASelectedColor:TColor=clBtnFace);
var
  s: string;
  tsStatus: Integer;
  R, RImg: Trect;
  w, n: Integer;
  pici: TPngImageCollectionItem;
  TextTop: Integer;
  IconWidth, IconHeight, IconTop, ItemHeight: Integer;
begin
  R := ARect;
  IconTop := 0;
  IconHeight := 0;
  pici := nil;
  IconWidth := 0;
  
  if R.Top > AListbox.Height then
    exit;

  SetBkMode(AListbox.Canvas.Handle,TRANSPARENT);

  ItemHeight := R.Bottom-R.Top;
  AListbox.Canvas.Font.Color := colortorgb(AFontColor);
  Alistbox.Canvas.Brush.Color := clWindow;
  AListbox.Canvas.FillRect(R);

  // Get Colours
  if odSelected in AState then
  begin
    AListbox.Canvas.Brush.Color := ASelectedColor;
    AListbox.Canvas.Pen.Color := ASelectedColor;

    AListBox.Canvas.RoundRect(R.Left-ALeftOffset,R.Top,R.Right-ALeftOffset,R.Bottom,10,10);
  end;
  if (odFocused in AState) and (odSelected in AState) then
  begin
    AListbox.Canvas.Brush.Color := ASelectedColor;
    AListbox.Canvas.Pen.Color := ASelectedColor;

    AListBox.Canvas.RoundRect(R.Left-ALeftOffset,R.Top,R.Right-ALeftOffset,R.Bottom,10,10);
  end;

  {if not (odDefault in AState) then begin
    AListbox.Canvas.FillRect(R);
  end; }

  // Get Status Text Width
  if AStatus <> '' then
    tsStatus := AListbox.Canvas.TextWidth(AStatus)
  else
    tsStatus := 0;

  // Get Icon Height+Width
  if assigned(APngImageList) then begin
    if Assigned(APngImageList.PngImages.Items[AIconIndex]) then begin
      pici := APngImageList.PngImages.Items[AIconIndex];
      IconWidth := pici.PngImage.Width;
      IconHeight := pici.PngImage.Height;
      IconTop := (ItemHeight div 2) - (IconHeight div 2);
    end;
  end;

  // Get the center of the height, and assign it to TextTop
  TextTop := (ItemHeight div 2) - (AListbox.Canvas.TextHeight(AText) div 2);

  // Width of item
  w := R.Right;

  // Get available space for the main text
  n := w - (tsStatus + IconWidth+10);


  s := PathCompactPath(AListbox.Canvas.Handle, AText, n, cpEnd);
  AListbox.Canvas.TextOut(R.Left + IconWidth + 8, R.Top+TextTop, s);

  if AStatus <> '' then
    AListbox.Canvas.TextOut(R.Right - tsStatus - 4, R.Top+TextTop, AStatus);

  if not (odDefault in AState) then begin
    if AIconIndex <> -1 then
    if assigned(pici) then begin
      RImg := Types.Rect(R.Left + 3, R.Top+IconTop, r.Left + 3 + IconWidth, R.Top + IconTop + IconHeight);
      pici.PngImage.Draw(AListbox.Canvas, RImg);
    end;
  end;
end;

end.


