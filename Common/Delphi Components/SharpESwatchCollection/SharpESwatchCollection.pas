unit SharpESwatchCollection;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  menus,
  pngimagelist,
  SharpApi,
  GR32_Image,
  GR32_Layers,
  SharpESwatchManager,
  Types;

{$R SharpESwatchRes.RES}

type
  TSelectColorEvent = procedure(ASender: TObject; AColor: TColor) of object;

type
  TSharpESwatchCollection = class(TScrollBox)
  private
    FPopupMenu: Tpopupmenu;
    FImageList: TPngImageList;

    FOnDblClickSwatch: TSelectColorEvent;
    FOpenDialog: TOpenDialog;
    FSaveDialog: TSaveDialog;

    FImage32: TImage32;
    FSwatchManager: TSharpESwatchManager;

    procedure PopupMenuEvent(ASender: TObject);
    procedure MouseDownEvent(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
      ALayer: TCustomLayer);
    procedure ControlMouseDownEvent(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MenuClickEvent(Sender: TObject);
    procedure LoadResources;

    procedure PopupSwatchMenu(AX, AY: Integer; ASender: TComponent);

  protected
    procedure Resize; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Image32: TImage32 read FImage32 write FImage32;

  published
    property SwatchManager: TSharpESwatchManager read FSwatchManager write
      FSwatchManager;
    property OnDblClickSwatch: TSelectColorEvent read FOnDblClickSwatch write
      FOnDblClickSwatch;
  end;

implementation

{ TSharpESwatchCollection }

constructor TSharpESwatchCollection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Self.ParentFont := True;
  Self.BorderStyle := bsNone;

  // Create Popup Menu
  FPopupMenu := TPopupMenu.Create(Self);
  FPopupMenu.OnPopup := PopupMenuEvent;
  Self.OnMouseUp := ControlMouseDownEvent;

  FOpenDialog := TOpenDialog.Create(nil);
  FOpenDialog.DefaultExt := '*.swatch';
  FOpenDialog.Filter := 'SharpE Swatch Collection (*.swatch)|*.swatch';
  FSaveDialog := TSaveDialog.Create(nil);
  FSaveDialog.DefaultExt := '*.swatch';
  FSaveDialog.Filter := 'SharpE Swatch Collection (*.swatch)|*.swatch';

  FImage32 := TImage32.Create(Self);
  FImage32.Parent := Self;
  FImage32.Left := 0;
  FImage32.Align := alTop;
  FImage32.Height := Self.Height;
  FImage32.OnMouseUp := MouseDownEvent;

  LoadResources;
end;

destructor TSharpESwatchCollection.Destroy;
begin
  FPopupMenu.Free;
  FOpenDialog.Free;
  FSaveDialog.Free;
  FImage32.Free;
  if Assigned(FImageList) then
    FImageList.Free;

  inherited Destroy;
end;

procedure TSharpESwatchCollection.Resize;
begin
  inherited;

  if FSwatchManager <> nil then
    FSwatchManager.Resize;
end;

procedure TSharpESwatchCollection.PopupMenuEvent(ASender: TObject);
var
  n: Integer;
  bEnabled: Boolean;
  p: TPoint;
  tmp: TSharpESwatchCollectionItem;
begin
  FPopupMenu.Items.Clear;

  p := FImage32.ScreenToClient(Mouse.CursorPos);
  tmp := FSwatchManager.GetItemFromPoint(p);
  FPopupMenu.Tag := Integer(tmp);
  bEnabled := tmp <> nil;

  if FSwatchManager = nil then
    exit;

  // Swatch tezt
  FPopupMenu.Images := FImageList;
  with FPopupMenu.Items do begin

    Add(NewItem('Rename Swatch', 0, False, bEnabled, MenuClickEvent,
      0, 'miRenameSwatch'));

    Add(NewItem('Delete Swatch', 0, False, bEnabled, MenuClickEvent,
      0, 'miDeleteSwatch'));

    Add(NewItem('-', 0, False, True, MenuClickEvent,
      0, 'miBlank'));

    Add(NewItem('File', 0, False, True, MenuClickEvent,
      0, 'miFile'));

    n := IndexOf(Find('File'));
    with Items[n] do begin
      Add(NewItem('Load', 0, False, True, MenuClickEvent,
        0, 'miLoadSwatch'));

      Add(NewItem('-', 0, False, True, MenuClickEvent,
        0, 'miBlank'));

      Add(NewItem('Save All', 0, False, True, MenuClickEvent,
        0, 'miSaveAllSwatch'));

      Add(NewItem('Save Selected', 0, False, True, MenuClickEvent,
        0, 'miSaveSelSwatch'));

    end;

    Add(NewItem('Selection', 0, False, True, MenuClickEvent,
      0, 'miSelection'));

    n := IndexOf(Find('Selection'));
    with Items[n] do begin

      Add(NewItem('Select All', 0, False, True, MenuClickEvent,
        0, 'miSelectAll'));
      Add(NewItem('Select None', 0, False, True, MenuClickEvent,
        0, 'miSelectNone'));

      Add(NewItem('-', 0, False, True, MenuClickEvent,
        0, 'miBlank'));

      Add(NewItem('Delete All', 0, False, True, MenuClickEvent,
        0, 'miDeleteAll'));

      Add(NewItem('Delete Selected', 0, False, True, MenuClickEvent,
        0, 'miDeleteSelected'));
    end;

    Add(NewItem('Options', 0, False, True, MenuClickEvent,
      0, 'miOptions'));

    n := IndexOf(Find('Options'));
    with Items[n] do begin
      Add(NewItem('Show Text', 0, FSwatchManager.ShowCaptions, True, MenuClickEvent,
        0, 'miShowSwatchText'));
      Add(NewItem('Sort By', 0, False, True, MenuClickEvent,
        0, 'miSortBy'));

      n := IndexOf(Find('Sort By'));
      with Items[n] do begin
        Add(NewItem('Hue', 0, FSwatchManager.SortMode = sortHue, True, MenuClickEvent,
          0, 'miSortHue'));
        Add(NewItem('Saturation', 0, FSwatchManager.SortMode = sortSat, True, MenuClickEvent,
          0, 'miSortSat'));
        Add(NewItem('Luminosity', 0, FSwatchManager.SortMode = sortLum, True, MenuClickEvent,
          0, 'miSortLum'));
        Add(NewItem('-', 0, False, True, MenuClickEvent,
          0, 'miBlank'));
        Add(NewItem('Name', 0, FSwatchManager.SortMode = sortName, True, MenuClickEvent,
          0, 'miSortName'));
      end;

    end;
    //mi := TMenuItem.
  end;
end;

procedure TSharpESwatchCollection.MouseDownEvent(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  ALayer: TCustomLayer);
var
  tmp: TSharpESwatchCollectionItem;
begin
  if FSwatchManager = nil then
    Exit;

  if Button = mbRight then
    PopupSwatchMenu(Mouse.CursorPos.X, Mouse.CursorPos.Y, Self)
  else begin
    tmp := FSwatchManager.GetItemFromPoint(Point(X, Y));
    if (tmp = nil) then
      FSwatchManager.DeselectAll
    else begin

      if not (ssCtrl in Shift) then begin

        FSwatchManager.DeselectAll;
        if Assigned(FOnDblClickSwatch) then
          FOnDblClickSwatch(tmp, tmp.Color);
      end
      else
        FSwatchManager.SetItemSelected(Point(X, Y));

    end;
  end;
end;

procedure TSharpESwatchCollection.MenuClickEvent(Sender: TObject);
var
  sName: string;
  i: Integer;
  tmpMI: TMenuItem;
  tmpSwatch: TSharpESwatchCollectionItem;
begin
  if FSwatchManager = nil then
    Exit;

  tmpSwatch := TSharpESwatchCollectionItem(FPopupMenu.Tag);

  tmpMI := TMenuItem(Sender);

  if tmpMI.Name = 'miRenameSwatch' then begin

    sName := tmpSwatch.ColorName;
    if InputQuery('Rename Swatch', 'Enter Name:', sName) then begin

      tmpSwatch.ColorName := sName;
      Resize;
    end;
  end
  else if tmpMI.Name = 'miDeleteSwatch' then begin

    FSwatchManager.Swatches.Delete(FSwatchManager.Swatches.IndexOf(tmpSwatch.DisplayName));
    Resize;
  end
  else if tmpMI.Name = 'miDeleteAll' then begin

    FSwatchManager.Swatches.Clear;
    Resize;
  end
  else if tmpMI.Name = 'miDeleteSelected' then begin

    for i := Pred(SwatchManager.Swatches.Count) downto 0 do begin
      tmpSwatch := TSharpESwatchCollectionItem(SwatchManager.Swatches.Items[i]);

      if tmpSwatch.Selected then
        SwatchManager.Swatches.Delete(SwatchManager.Swatches.IndexOf(tmpSwatch.DisplayName));
    end;

    Resize;
  end
  else if tmpMI.Name = 'miLoadSwatch' then begin

    if not (DirectoryExists(GetSharpeGlobalSettingsPath + 'Swatches')) then
      CreateDir(GetSharpeGlobalSettingsPath + 'Swatches');

    FOpenDialog.Title := 'Load Swatches';
    FOpenDialog.InitialDir := GetSharpeGlobalSettingsPath + 'Swatches';
    if FOpenDialog.Execute then
      if ExtractFileExt(FOpenDialog.FileName) = '.swatch' then
        FSwatchManager.Load(FOpenDialog.FileName);
  end
  else if tmpMI.Name = 'miSaveAllSwatch' then begin

    if not (DirectoryExists(GetSharpeGlobalSettingsPath + 'Swatches')) then
      CreateDir(GetSharpeGlobalSettingsPath + 'Swatches');

    FSaveDialog.Title := 'Save All Swatches';
    FSaveDialog.InitialDir := GetSharpeGlobalSettingsPath + 'Swatches';
    if FSaveDialog.Execute then
      if ExtractFileExt(FSaveDialog.FileName) = '.swatch' then
        FSwatchManager.Save(FSaveDialog.FileName);
  end
  else if tmpMI.Name = 'miSaveSelSwatch' then begin

    if not (DirectoryExists(GetSharpeGlobalSettingsPath + 'Swatches')) then
      CreateDir(GetSharpeGlobalSettingsPath + 'Swatches');

    FSaveDialog.Title := 'Save Selected Swatches';
    FSaveDialog.InitialDir := GetSharpeGlobalSettingsPath + 'Swatches';
    if FSaveDialog.Execute then
      if ExtractFileExt(FSaveDialog.FileName) = '.swatch' then
        FSwatchManager.Save(FSaveDialog.FileName, True);
  end
  else if tmpMi.Name = 'miSelectAll' then
    FSwatchManager.SelectAll
  else if tmpMi.Name = 'miSelectNone' then
    FSwatchManager.DeselectAll
  else if tmpMi.Name = 'miShowSwatchText' then
    FSwatchManager.ShowCaptions := not (FSwatchManager.ShowCaptions)
  else if tmpMi.Name = 'miSortHue' then
    FSwatchManager.SortMode := sortHue
  else if tmpMi.Name = 'miSortSat' then
    FSwatchManager.SortMode := sortSat
  else if tmpMi.Name = 'miSortLum' then
    FSwatchManager.SortMode := sortLum
  else if tmpMi.Name = 'miSortName' then
    FSwatchManager.SortMode := sortName;

  Invalidate;
end;

procedure TSharpESwatchCollection.LoadResources;
var
  png: TPngImageCollectionItem;
begin
  FImageList := TPngImageList.Create(Self);
  png := FImageList.PngImages.Add();
  png.PngImage.LoadFromResourceName(HInstance, 'SWATCH_COLLECTION_ADD_PNG');
  png := FImageList.PngImages.Add();
  png.PngImage.LoadFromResourceName(HInstance, 'SWATCH_COLLECTION_EDIT_PNG');
  png := FImageList.PngImages.Add();
  png.PngImage.LoadFromResourceName(HInstance, 'SWATCH_COLLECTION_CANCEL_PNG');
  png := FImageList.PngImages.Add();
  png.PngImage.LoadFromResourceName(HInstance, 'SWATCH_COLLECTION_LOAD_PNG');
  png := FImageList.PngImages.Add();
  png.PngImage.LoadFromResourceName(HInstance, 'SWATCH_COLLECTION_SAVE_PNG');
  png := FImageList.PngImages.Add();
  png.PngImage.LoadFromResourceName(HInstance, 'SWATCH_COLLECTION_SAVE_PNG');
end;

procedure TSharpESwatchCollection.PopupSwatchMenu(AX, AY: Integer; ASender: TComponent);
begin
  FPopupMenu.Tag := Integer(ASender);
  FPopupMenu.Popup(AX, AY);
end;

procedure TSharpESwatchCollection.ControlMouseDownEvent(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseDownEvent(Sender, Button, shift, x, y, nil);
end;

end.

