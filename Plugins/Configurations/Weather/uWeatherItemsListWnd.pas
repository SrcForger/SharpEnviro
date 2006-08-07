unit uWeatherItemsListWnd;

interface

uses
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
  pngimage,

  ExtCtrls,
  Buttons,
  ImgList,
  ComCtrls,
  ToolWin,
  JvExControls,
  JvComponent,
  JvGradientHeaderPanel,
  GR32,
  sharpfx,
  JclGraphics,
  JvHtControls,
  JvExStdCtrls,
  Grids,
  PngSpeedButton,
  PngImageList,
  uWeatherList,
  SharpEListBox;

type
  TFrmWeatherItemsList = class(TForm)
    pnl1: TPanel;
    img1: TImage;
    lbl1: TLabel;
    Image2: TImage;
    imlWeatherGlyphs: TPngImageList;
    Shape1: TShape;
    ImageEn: TImage;
    ImageDis: TImage;
    lbWeatherList: TSharpEListBox;
    Panel1: TPanel;
    dlgImport: TOpenDialog;
    dlgExport: TSaveDialog;
    procedure Panel1Resize(Sender: TObject);
    procedure img1Click(Sender: TObject);
    procedure sbOptionsClick(Sender: TObject);

    procedure lbWeatherListDblClick(Sender: TObject);
    procedure lbWeatherListMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure lbWeatherListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbWeatherListDrawItem2(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure edtLocationChange(Sender: TObject);
    procedure rdoMetricClick(Sender: TObject);
    procedure rdoStandardClick(Sender: TObject);
  private
    { Private declarations }
    function GetWeatherIndex(AWeatherItem: TWeatherItem): Integer;
    procedure CenterForm(var AForm: TForm; AOwner: TForm);
  public
    { Public declarations }
    procedure LoadSettings;
    procedure UpdateDisplay(AData: TWeatherList);

    procedure AddItem;
    procedure EditItem;
    procedure DeleteItem;
    procedure ClearList;
    procedure ExportList;
    procedure ImportList;
  end;

var
  FrmWeatherItemsList: TFrmWeatherItemsList;

implementation

uses
  uWeatherOptionsWnd,
  uWeatherOptions,
  uWeatherItemEditWnd,
  Types,
  SharpApi,
  JclFileUtils,
  uSEListboxPainter;

{$R *.dfm}

procedure TFrmWeatherItemsList.CenterForm(var AForm: TForm; AOwner: TForm);
var
  p: TPoint;
begin
  p := ClientToScreen(AOwner.ScreenToClient(AOwner.ClientOrigin));
  AForm.Left := p.x + AOwner.Width div 2 - AForm.Width div 2;
  AForm.Top := p.y + AOwner.Height div 2 - AForm.Height div 2;
end;

procedure TFrmWeatherItemsList.LoadSettings;
begin
  UpdateDisplay(TmpWeatherList);
  {edtLocation.Text := TempWeatherSettings.LocationID;

  if TempWeatherSettings.Metric then
    rdoMetric.Checked := True
  else
    rdoStandard.Checked := True;}
end;

procedure TFrmWeatherItemsList.edtLocationChange(Sender: TObject);
begin
  //TempWeatherSettings.LocationID := edtLocation.Text;
end;

procedure TFrmWeatherItemsList.rdoMetricClick(Sender: TObject);
begin
  //TempWeatherSettings.Metric := true;
end;

procedure TFrmWeatherItemsList.rdoStandardClick(Sender: TObject);
begin
  //TempWeatherSettings.Metric := false;
end;

procedure TFrmWeatherItemsList.UpdateDisplay(AData: TWeatherList);
var
  i: Integer;
  n: Integer;
begin
  n := lbWeatherList.ItemIndex;
  lbWeatherList.Clear;
  for i := 0 to Pred(AData.Count) do begin
    lbWeatherList.AddItem(AData.Info[i].Location, AData.Info[i]);
  end;
  if (n = -1) or (n > lbWeatherList.Items.Count - 1) then
    n := 0;

  if lbWeatherList.Count <> 0 then
    lbWeatherList.ItemIndex := n;
end;

procedure TFrmWeatherItemsList.lbWeatherListDblClick(Sender: TObject);
begin
  if lbWeatherList.ItemIndex <> -1 then
    EditItem;

end;

procedure TFrmWeatherItemsList.lbWeatherListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
{var
  sLocation,sLastUpdated,sLastTemp, s: string;
  tsLastUpdated, tsLastTemp: Integer;

  R, RImg,ARect: Trect;
  lst: TlistBox;
  Ident,n,n2,w: integer;

  obj:TWeatherItem;
  pici:TPngImageCollectionItem; }
begin
  {  if Index = -1 then exit;
    lst:= TlistBox(Control);
    obj := TWeatherItem(lst.Items.Objects[Index]);
    if not(assigned(obj)) then exit;
    if lst.Style = lbStandard then exit;

    ARect := Rect;
    R := ARect;
    if R.Top > lst.Height then exit;
    sLocation := obj.Location;

    if Not(obj.Enabled) then
      sLocation := sLocation + ' (Disabled)';

    if obj.CCLastUpdated = '-1' then
      sLastUpdated := 'Queued Update' else
      sLastUpdated := '^' + DateTimeToStr(StrToFloat(obj.CCLastUpdated));

    if obj.LastTemp = -999 then
      sLastTemp := '' else begin
        if tmpWeatherOptions.Metric then
          sLastTemp := Format(' (%dÃ‚Â°C)',[obj.LastTemp]) else
          sLastTemp := Format(' (%dÃ‚Â°F)',[obj.LastTemp]);
      end;

    lst.Canvas.Font := lst.Font ;
    if odSelected in state then
      begin
        lst.Canvas.Font.Color := clBlack;
        lst.Canvas.Brush.Color := Darker(clWindow,10);
      end;

    if (odFocused in state) and (odSelected in state) then
      begin
        lst.Canvas.Font.Color := clBlack;
        lst.Canvas.Brush.Color := Darker(clWindow,10);
      end;

    if not (odDefault in state) then
      lst.Canvas.FillRect (Arect)
    else
      lst.Canvas.FillRect (R);

    if not(obj.Enabled) then
      lst.canvas.Font.Color := Darker(clWindow,50);

    tsLastUpdated := lst.Canvas.TextWidth(sLastUpdated);
    tsLastTemp := lst.Canvas.TextWidth(sLastTemp);

    w := R.Right;
    n := w - (tsLastUpdated+tsLastTemp+40);
    s := PathCompactPath(lst.Canvas.Handle,sLocation,n,cpEnd);

    lst.Canvas.TextOut(R.Left+ImageEn.Width+8,R.Top+4,s);

    lst.Canvas.Font.Color := Lighter(clBlue,20);
    if sLastTemp <> '' then
      lst.Canvas.TextOut(R.Left+ImageEn.Width+10+lst.Canvas.TextWidth(s),R.Top+4,sLastTemp);

    lst.Canvas.Font.Color := Darker(clWindow,50);
    tsLastUpdated := lst.Canvas.TextWidth(sLastUpdated);
    lst.Canvas.TextOut(R.Right-tsLastUpdated-4,R.Top+4,sLastUpdated);

    if not (odDefault in state) then begin
      if Not(obj.Enabled) then begin
          lst.Canvas.Draw (R.Left+3, R.top + 3, ImageDis.Picture.Graphic);
        end else begin
          if obj.LastIconID = -1 then begin
            lst.Canvas.Draw (R.Left+3, R.top + 3, ImageEn.Picture.Graphic)
            end else begin
              case obj.LastIconID of
              0,3,4,17,35,37,38,47: begin // Storm
                pici := imlWeatherGlyphs.PngImages.Items[6];
                RImg := Types.Rect(R.Left+3,r.Top+3,r.Left+3+16,r.top+3+16);
                pici.PngImage.Draw(lst.Canvas,RImg);
              end;
              1,2,5,7,10,12,39,40: begin // Rain Hard
                pici := imlWeatherGlyphs.PngImages.Items[9];
                RImg := Types.Rect(R.Left+3,r.Top+3,r.Left+3+16,r.top+3+16);
                pici.PngImage.Draw(lst.Canvas,RImg);
              end;
              8,9,11,6,18: begin // Rain Light
                pici := imlWeatherGlyphs.PngImages.Items[7];
                RImg := Types.Rect(R.Left+3,r.Top+3,r.Left+3+16,r.top+3+16);
                pici.PngImage.Draw(lst.Canvas,RImg);
              end;
              13,14,15,16,41,42,43,46: begin // Snow
                pici := imlWeatherGlyphs.PngImages.Items[8];
                RImg := Types.Rect(R.Left+3,r.Top+3,r.Left+3+16,r.top+3+16);
                pici.PngImage.Draw(lst.Canvas,RImg);
              end;
              31,33: begin // Night
                pici := imlWeatherGlyphs.PngImages.Items[1];
                RImg := Types.Rect(R.Left+3,r.Top+3,r.Left+3+16,r.top+3+16);
                pici.PngImage.Draw(lst.Canvas,RImg);
              end;
              27,29: begin // Cloudy Night
                pici := imlWeatherGlyphs.PngImages.Items[3];
                RImg := Types.Rect(R.Left+3,r.Top+3,r.Left+3+16,r.top+3+16);
                pici.PngImage.Draw(lst.Canvas,RImg);
              end;
              26: begin // Overcast
                pici := imlWeatherGlyphs.PngImages.Items[4];
                RImg := Types.Rect(R.Left+3,r.Top+3,r.Left+3+16,r.top+3+16);
                pici.PngImage.Draw(lst.Canvas,RImg);
              end;
              28,30,44: begin // Overcast sun
                pici := imlWeatherGlyphs.PngImages.Items[2];
                RImg := Types.Rect(R.Left+3,r.Top+3,r.Left+3+16,r.top+3+16);
                pici.PngImage.Draw(lst.Canvas,RImg);
              end;
              32,36,34: begin // Sunny
                pici := imlWeatherGlyphs.PngImages.Items[0];
                RImg := Types.Rect(R.Left+3,r.Top+3,r.Left+3+16,r.top+3+16);
                pici.PngImage.Draw(lst.Canvas,RImg);
              end;
              else
                lst.Canvas.Draw (R.Left+3, R.top + 3, ImageEn.Picture.Graphic);
              end;
            end;
        end;
    end;
        }

end;

procedure TFrmWeatherItemsList.lbWeatherListDrawItem2(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  sLocation, sLastUpdated, sLastTemp, s, sText, sStatus: string;
  tsLastUpdated, tsLastTemp: Integer;

  R, RImg, ARect: Trect;
  lst: TlistBox;
  Ident, n, n2, w: integer;
  FontColor: TColor;

  obj: TWeatherItem;
  pici: TPngImageCollectionItem;
begin
  // If nothing selected, exit
  if Index = -1 then
    exit;

  // Get Object, and if not assigned then exit
  obj := TWeatherItem(TListBox(Control).Items.Objects[Index]);
  if not (assigned(obj)) then
    exit;

  // Also do not continue if list style is standard
  if TListBox(Control).Style = lbStandard then
    exit;

  // Object specific extractions

  FontColor := clBlack;
  sLocation := obj.Location;
  if not (obj.Enabled) then
    sLocation := sLocation + ' (Disabled)';

  if obj.CCLastUpdated = '-1' then
    sLastUpdated := 'Queued Update'
  else
    sLastUpdated := FormatDateTime('dd mmm hh:nn',
      StrToFloat(obj.CCLastUpdated));

  if obj.LastTemp = -999 then
    sLastTemp := ''
  else begin
    if tmpWeatherOptions.Metric then
      sLastTemp := Format('%d°C', [obj.LastTemp])
    else
      sLastTemp := Format('%d°F', [obj.LastTemp]);
  end;

  sText := Format('%s (%s)', [sLocation, sLastTemp]);
  sStatus := sLastUpdated;

  // Draw Method
  PaintListbox(TListBox(Control), Rect, 0, State, sText, imlWeatherGlyphs,
    GetWeatherIndex(obj),
    sStatus, FontColor);
end;

procedure TFrmWeatherItemsList.lbWeatherListMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  Height := 30;
end;

procedure TFrmWeatherItemsList.sbOptionsClick(Sender: TObject);
var
  bMetric: Boolean;
  i: integer;
begin
  frmWeatherOptions := TfrmWeatherOptions.Create(nil);
  try
    with frmWeatherOptions, tmpWeatherOptions do begin
      edtCheck.Value := CheckInterval;
      edtForecast.Value := FCastInterval;
      edtCurConditions.Value := CCondInterval;
      bMetric := Metric;

      if Metric then
        rgUnits.ItemIndex := 0
      else
        rgUnits.ItemIndex := 1;

      case frmWeatherOptions.ShowModal of
        mrOk: begin
            case rgUnits.ItemIndex of
              0: Metric := True;
              1: Metric := False;
            end;

            FCastInterval := edtForecast.AsInteger;
            CCondInterval := edtCurConditions.AsInteger;
            CheckInterval := edtCheck.AsInteger;
            tmpWeatherOptions.Save;

            // If unit type changed, then reset all metric types
            if bMetric <> Metric then begin
              for i := 0 to pred(TmpWeatherList.Count) do begin
                TmpWeatherList.Info[i].CCLastUpdated := '-1';
                TmpWeatherList.Info[i].FCLastUpdated := '-1';
                TmpWeatherList.Info[i].LastTemp := -999;
                TmpWeatherList.info[i].LastIconID := -1;
              end;
            end;

            ModalResult := -1;
          end
      else
        ModalResult := -1;
      end;
    end;
  finally
    frmWeatherOptions.Free;
    UpdateDisplay(TmpWeatherList);
  end;
end;

procedure TFrmWeatherItemsList.img1Click(Sender: TObject);
begin
  SharpExecute('http://www.weather.com/?prod=xoap&par=1003043975')
end;

procedure TFrmWeatherItemsList.DeleteItem;
var
  obj: TWeatherItem;
  sPath: string;
begin
  if lbWeatherList.ItemIndex <> -1 then begin
    obj := TWeatherItem(lbWeatherList.Items.Objects[lbWeatherList.ItemIndex]);

    sPath := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\Data\' +
      obj.LocationID + '\';
    TmpWeatherList.Delete(obj);

    UpdateDisplay(TmpWeatherList);
    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
  end;

end;

procedure TFrmWeatherItemsList.EditItem;
var
  obj: TWeatherItem;
  tmpWl: TWeatherLocation;
begin
  if lbWeatherList.ItemIndex <> -1 then begin
    obj := TWeatherItem(lbWeatherList.Items.Objects[lbWeatherList.ItemIndex]);

    frmWeatherItem := TFrmWeatherItem.Create(nil);

    try
      CenterForm(Tform(frmWeatherItem), Self);
      with frmWeatherItem do begin
        frmWeatherItem.Caption := 'Edit Item';
        btnOk.Caption := 'Apply';
        edtLocation.Text := obj.Location;

        case ShowModal of
          mrOk: begin
              if (lbResults.ItemIndex <> -1) then begin

                tmpWl := TWeatherLocation(lbResults.items.objects[lbResults.ItemIndex]);

                if tmpWl <> nil then begin
                  obj.Location := tmpWl.Location;
                  obj.LocationID := tmpWl.LocationId;
                  ModalResult := -1;
                  SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
                end;
              end;
            end;
        end;
      end;
    finally

      // Select
      UpdateDisplay(TmpWeatherList);
      lbWeatherList.ItemIndex := lbWeatherList.Items.IndexOfObject(obj);

      frmWeatherItem.ClearListbox;
      FreeAndNil(frmWeatherItem);

      
    end;
  end;
end;

procedure TFrmWeatherItemsList.AddItem;
var
  tmpWl: TWeatherLocation;
begin
  frmWeatherItem := TfrmWeatherItem.Create(nil);
  try
    CenterForm(Tform(frmWeatherItem), Self);

    with frmWeatherItem do begin
      frmWeatherItem.Caption := 'New Item';
      btnOk.Caption := 'Add';
      edtLocation.Text := '';

      case ShowModal of
        mrOk: begin

            if (lbResults.ItemIndex <> -1) then begin

              if (lbResults.Items[lbResults.ItemIndex] <> 'No location provided')
                and
                (lbResults.Items[lbResults.ItemIndex] <> 'No Items Found') then

                tmpWl :=
                  TWeatherLocation(lbResults.items.objects[lbResults.ItemIndex]);
              TmpWeatherList.Add(tmpWl.Location, tmpWl.LocationID, '-1', '-1',
                -1, -1, True);
              ModalResult := -1;
              SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
            end;
          end;
      end;
    end;
  finally
    frmWeatherItem.ClearListbox;
    FreeAndNil(frmWeatherItem);
    UpdateDisplay(TmpWeatherList);
  end;
end;

procedure TFrmWeatherItemsList.Panel1Resize(Sender: TObject);
begin
  UpdateDisplay(TmpWeatherList);
end;

function TFrmWeatherItemsList.GetWeatherIndex(
  AWeatherItem: TWeatherItem): Integer;
begin
  Result := 11;
  if AWeatherItem.LastIconID = -1 then
    exit;

  case AWeatherItem.LastIconID of
    0, 3, 4, 17, 35, 37, 38, 47: Result := 6;
    1, 2, 5, 7, 10, 12, 39, 40: Result := 9;
    8, 9, 11, 6, 18: Result := 7;
    13, 14, 15, 16, 41, 42, 43, 46: Result := 8;
    31, 33: Result := 1;
    27, 29: Result := 3;
    26: Result := 4;
    28, 30, 44: Result := 2;
    32, 36, 34: Result := 0;
  else
    Result := 10;
  end;
end;

procedure TFrmWeatherItemsList.ClearList;
begin
  if (MessageDlg('Are you sure you want to clear the weather list?',
    mtConfirmation, [mbOK, mbCancel], 0) = mrOk) then
  begin
    TmpWeatherList.Clear;
    UpdateDisplay(TmpWeatherList);
    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
  end;
end;

procedure TFrmWeatherItemsList.ExportList;
begin
  dlgExport.FileName := 'Weather_backup.xml';
  if dlgExport.Execute then
  begin
    TmpWeatherList.Save(dlgExport.FileName);

  end;
end;

procedure TFrmWeatherItemsList.ImportList;
begin
  if dlgImport.Execute then
  begin
    TmpWeatherList.Load(dlgImport.FileName);
    UpdateDisplay(TmpWeatherList);
    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
  end;
end;

end.

