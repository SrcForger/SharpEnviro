unit uWeatherList;

interface
uses
  Classes,
  jclIniFiles,
  ContNrs,
  SysUtils,
  JvSimpleXml,
  dialogs,
  Forms;


type
  // "Private" Object, TWeatherList needs it...
  TWeatherItem = class(TObject)
  private
    FID: Integer;
    FLocation: String;
    FLocationID: String;
    FEnabled: Boolean;
    FCCLastUpdated: String;
    FFCLastUpdated: String;
    FLastIconID: Integer;
    FLastTemp: Integer;
  public
    constructor Create;
    Property ID: Integer Read FID Write FID;
    Property Location: String Read FLocation Write FLocation;
    Property LocationID: String read FLocationID Write FLocationID;
    Property Enabled: Boolean Read FEnabled Write FEnabled;
    Property FCLastUpdated: String read FFCLastUpdated write FFCLastUpdated;
    Property CCLastUpdated: String read FCCLastUpdated write FCCLastUpdated;
    Property LastIconID: Integer read FLastIconID write FLastIconID;
    Property LastTemp: Integer read FLastTemp write FLastTemp;
  end;

  TWeatherList = class(TObject)
  private
    FItems: TObjectList;
    FOnAddItem: TNotifyEvent;
    FFileName: string;

    function GetCount: integer;
    function GeTWeatherItem(Index: integer): TWeatherItem;
    procedure Debug(Str: string; ErrorType: Integer);

  public
    constructor Create(FileName: string);
    destructor Destroy; override;

    function Add(Location:String; LocationID:String; FCLastUpdated:String;
      CCLastUpdated: String; LastIconID:Integer; LastTemp:Integer;
        Enabled:Boolean): TWeatherItem;

    procedure Delete(Index: integer); overload;
    procedure Delete(AObject: TWeatherItem); overload;
    procedure Clear;

    property Count: integer read GetCount;
    property Info[Index: integer]: TWeatherItem read GeTWeatherItem;

    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;

    procedure Load(xmlfile: TFilename); overload;
    procedure Save(xmlfile: TFilename); overload;
    procedure Load; overload;
    procedure Save; overload;

    property FileName: string read FFileName write FFileName;
  end;

  var
    TmpWeatherList: TWeatherList;
    WeatherList:TWeatherList;

implementation

uses
  uWeatherMgr, SharpApi;



{ TWeatherList }

function TWeatherList.Add(Location:String; LocationID:String;
  FCLastUpdated:String; CCLastUpdated: String; LastIconID:Integer;
    LastTemp:Integer; Enabled:Boolean): TWeatherItem;
begin
  Result := TWeatherItem.Create;
  Result.ID := Self.Count;
  Result.Location := Location;
  Result.LocationID := LocationID;
  Result.Enabled := Enabled;
  Result.FCLastUpdated := FCLastUpdated;
  Result.CCLastUpdated := CCLastUpdated;
  Result.LastIconID := LastIconID;
  Result.LastTemp := LastTemp;
  FItems.Add(Result);

  if Assigned(FOnAddItem) then
    FOnAddItem(Result);
end;

constructor TWeatherList.Create(FileName: string);
begin
  inherited Create;
  FFileName := FileName;
  FItems := TObjectList.Create;

  if FileExists(FileName) then
    Load
  else begin
    Save;
  end;
end;

procedure TWeatherList.Delete(Index: integer);
begin
  FItems.Delete(Index);
end;

procedure TWeatherList.Clear;
begin
  FItems.Clear;
end;

destructor TWeatherList.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TWeatherList.GetCount: integer;
begin
  Result := FItems.Count;
end;

function TWeatherList.GeTWeatherItem(Index: integer): TWeatherItem;
begin
  Result := (FItems[Index] as TWeatherItem);
end;

procedure TWeatherList.Load;
begin
  Load(FFilename);
end;

procedure TWeatherList.Load(xmlfile: TFilename);
var
  ItemCount, Loop: Integer;
  xml: TjvSimpleXml;
  prop: string;
  sMsg: string;
begin

  xml := TJvSimpleXml.Create(nil);

  try
    try
      xml.LoadFromFile(xmlfile);

      if xml.Root.Name <> 'WeatherLocations' then begin
        sMsg := 'Invalid WeatherLocations File' + #13;
        //Debug(sMsg, DMT_ERROR);

        sMsg := sMsg + Format('Expected "%s" found "%s"',['WeatherLocations',xml.Root.Name]);
        MessageDlg(sMsg, mtError, [mbOK], 0);

        // Save empty and reload
        exit;
      end;

      Itemcount := xml.Root.Properties.Item[0].IntValue;
      for Loop := 0 to itemcount - 1 do begin
        prop := 'Location' + inttostr(loop);

        with xml.Root.Items do begin

          self.Add(
            ItemNamed['Location' + inttostr(loop)].Properties.Value('Location',''),
            ItemNamed['Location' + inttostr(loop)].Properties.Value('LocationID',''),
            ItemNamed['Location' + inttostr(loop)].Properties.Value('FCLastUpdated','-1'),
            ItemNamed['Location' + inttostr(loop)].Properties.Value('CCLastUpdated','-1'),
            ItemNamed['Location' + inttostr(loop)].Properties.IntValue('LastIconID',-1),
            ItemNamed['Location' + inttostr(loop)].Properties.IntValue('LastTemp',-999),
            ItemNamed['Location' + inttostr(loop)].Properties.BoolValue('Enabled',True));
        end;
      end;
    except

      on E: Exception do begin
        Debug('Error While Loading Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);

        // Create New
        Save;
      end;
    end;
  finally
    xml.Free;
  end;
end;

procedure TWeatherList.Save;
begin
  Save(FFilename);
end;

procedure TWeatherList.Save(xmlfile: TFilename);
var
  i: Integer;
  Xml: TjvSimpleXml;
begin
  Xml := TJvSimpleXml.Create(nil);

  try
    try
      Xml.Root.Name := 'WeatherLocations';
      xml.Root.Properties.Add('ItemCount', self.count);

      for i := 0 to self.Count - 1 do begin
        Xml.Root.Items.Add(Format('Location%d', [i]));
        Xml.Root.Items.Item[i].Properties.Add('Location', Self.Info[i].Location);
        Xml.Root.Items.Item[i].Properties.Add('LocationID', Self.Info[i].LocationID);
        Xml.Root.Items.Item[i].Properties.Add('FCLastUpdated', Self.Info[i].FCLastUpdated);
        Xml.Root.Items.Item[i].Properties.Add('CCLastUpdated', Self.Info[i].CCLastUpdated);
        Xml.Root.Items.Item[i].Properties.Add('LastIconID', Self.Info[i].LastIconID);
        Xml.Root.Items.Item[i].Properties.Add('LastTemp', Self.Info[i].LastTemp);
        Xml.Root.Items.Item[i].Properties.Add('Enabled', Self.Info[i].Enabled);
      end;

      Xml.SaveToFile(xmlfile);
    except
      on E: Exception do begin
        Debug('Error While Saving Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);
      end;
    end;

  finally
    Xml.Free;
  end;
end;

procedure TWeatherList.Debug(Str: string; ErrorType: Integer);
begin
  SendDebugMessageEx('Weather Service',PChar(Str),0,ErrorType);
end;

procedure TWeatherList.Delete(AObject: TWeatherItem);
var
  n:integer;
begin
  n := FItems.IndexOf(AObject);

  if n <> -1 then
    FItems.Delete(n);
end;

{ TWeatherItem }

{ TWeatherItem }

constructor TWeatherItem.Create;
begin
  FLocation := '';
  FLocationID := '';
  FEnabled := False;
  FCCLastUpdated := '-1';
  FFCLastUpdated := '-1';
  FLastIconID := -1;
  FLastTemp := -999;
end;

end.




