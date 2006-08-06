unit uWeatherItemEditWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, pngimage, uWeatherList, jvSimpleXml,
  PngSpeedButton;

type
  TWeatherLocation = Class
    Location: String;
    LocationID: String;
  end;

type
  TfrmWeatherItem = class(TForm)
    gbx1: TPanel;
    lbResults: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnOk: TButton;
    edtLocation: TEdit;
    Label1: TLabel;
    sbLookup: TPngSpeedButton;
    ImageLb: TImage;
    procedure edtLocationKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbResultsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbResultsClick(Sender: TObject);
    procedure sbLookupClick(Sender: TObject);
  private
    { Private declarations }
    Procedure DownloadLocationData(Location:String);
    Procedure UpdateSearchList(AResults:String);
    procedure Debug(Str: string; ErrorType: Integer);
    
  public
    { Public declarations }
    procedure ClearListbox;
  end;

var
  frmWeatherItem: TfrmWeatherItem;

implementation

uses
  uWeatherItemsListWnd, uWeatherMgr, SharpApi, SOAPHTTPTrans;

{$R *.dfm}

{ TForm1 }

procedure TfrmWeatherItem.ClearListbox;
var
  i: Integer;
begin
  for i := 0 to lbResults.Items.Count - 1 do
  begin
    if Assigned(lbResults.Items.Objects[i]) then
      lbResults.Items.Objects[i].Free;
  end;
  lbResults.Items.Clear;
end;

procedure TfrmWeatherItem.DownloadLocationData(Location: String);
var
  Stream: TMemoryStream;
  StrStream:TStringStream;
  HTTPReqResp1: THTTPReqResp;
  UrlTarget: String;
begin
  Stream := TMemoryStream.Create;
  HTTPReqResp1 := THTTPReqResp.Create(Self);
  try
  try
    HTTPReqResp1.UseUTF8InHeader := False;

    UrlTarget := Format('http://xoap.weather.com/search/search?where=%s',[Location]);
    HTTPReqResp1.URL := UrlTarget;
    HTTPReqResp1.Execute(UrlTarget, Stream);

    Debug(STRSeperator,DMT_INFO);
    Debug(STRRequest + UrlTarget,DMT_INFO);
    Debug(STRDateTime + DateTimeToStr(now),DMT_INFO);
    Debug(STRSeperator,DMT_INFO);

    StrStream := TStringStream.Create('');
    StrStream.CopyFrom(Stream, 0);
    try
      
      UpdateSearchList(StrStream.DataString);
    finally
      StrStream.Free;
    end;
  except
    Debug(Format('Error Searching for %s (Connection Issue)',[Location]),DMT_ERROR);
    exit;
  end;
  finally
    Stream.Free;
    HTTPReqResp1.Free;
  end;
end;

procedure TfrmWeatherItem.edtLocationKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    sbLookup.Click;
end;

procedure TfrmWeatherItem.FormCreate(Sender: TObject);
begin
  lbResults.Enabled := False;
end;

procedure TfrmWeatherItem.FormShow(Sender: TObject);
begin
  edtLocation.SetFocus;
end;

procedure TfrmWeatherItem.UpdateSearchList(AResults: String);
var
  xml: TJvSimpleXML;
  n:integer;
  tmpWl: TWeatherLocation;
begin
  ClearListbox;
  
  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromString(AResults);

    // check for nodes
    if XML.Root.Items.Count = 0 then begin
      lbResults.AddItem('No Items Found',nil);
    end
    else begin
      for n:=0 to XML.Root.Items.Count-1 do
      begin
        tmpWl := TWeatherLocation.Create;
        tmpWl.Location := XML.Root.Items.Item[n].Value;
        tmpWl.LocationID := Xml.Root.Items.Item[n].Properties.ItemNamed['id'].Value;
        lbResults.AddItem(tmpWl.Location,tmpWl);
      end;
    end;

  finally
    xml.Free;
  end;
end;

procedure TfrmWeatherItem.Debug(Str: string; ErrorType: Integer);
begin
  SendDebugMessageEx('Weather Service',PChar(Str),0,ErrorType);
end;

procedure TfrmWeatherItem.sbLookupClick(Sender: TObject);
begin
  DownloadLocationData(edtLocation.Text);
  if lbResults.Count <> 0 then
    lbResults.Enabled := True;
end;

procedure TfrmWeatherItem.lbResultsClick(Sender: TObject);
var
  s:String;
begin
  if lbResults.ItemIndex <> -1 then begin
    s := lbResults.Items.Strings[lbResults.itemindex];

    if (s <> 'No Items Found') and (s <> 'No location provided') then
      edtLocation.Text := s;
  end;
end;

procedure TfrmWeatherItem.lbResultsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  sLocation: string;

  R, ARect: Trect;
  lst: TlistBox;
  
  cs:tcolorschemeex;
begin
  if Index = -1 then exit;
  lst:= TlistBox(Control);
  if lst.Style = lbStandard then exit;

  ARect := Rect;
  R := ARect;
  if R.Top > lst.Height then exit;

  cs := LoadColorSchemeEx;
  sLocation := lst.Items[Index];

  lst.Canvas.Font := lst.Font ;
  if odSelected in state then
    begin
      lst.Canvas.Font.Color := cs.WorkAreaText;
      lst.Canvas.Brush.Color := cs.WorkArealight;
    end;

  if (odFocused in state) and (odSelected in state) then
    begin
      lst.Canvas.Font.Color := cs.WorkAreaText;
      lst.Canvas.Brush.Color := cs.WorkArealight;
    end;

  if not (odDefault in state) then
    lst.Canvas.FillRect (Arect)
  else
    lst.Canvas.FillRect (R);

  lst.Canvas.TextOut(R.Left+ImageLb.Width+6,R.Top+4,sLocation);

  lst.Canvas.Draw (R.Left+3, R.top + 3, ImageLb.Picture.Graphic);
end;

end.                                                 
