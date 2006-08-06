unit uWeatherOptions;

interface
uses
  Classes,
  jclIniFiles,
  ContNrs,
  SysUtils,
  JvSimpleXml,
  dialogs,
  Sharpapi,
  Forms;

type
  TWeatherSettings = class
  private
    FMetric: boolean;
    FFileName: String;
    FCCondInterval: Integer;
    FFCastInterval: Integer;
    FCheckInterval: Integer;
  public
    constructor Create(Value: string);

    procedure Load(filename: string); overload;
    procedure Save(filename: string); overload;
    procedure Load; overload;
    procedure Save; overload;

  published
    property Metric: boolean read FMetric Write FMetric;
    Property CCondInterval: Integer read FCCondInterval write FCCondInterval;
    property FCastInterval: Integer read FFCastInterval write FFCastInterval;
    property CheckInterval: Integer read FCheckInterval write FCheckInterval;
  end;

  procedure Debug(Message: string; DebugType: Integer);

var
  WeatherOptions, tmpWeatherOptions: TWeatherSettings;

  { TWeatherItem }

implementation

constructor TWeatherSettings.Create(Value: string);
begin
  FMetric := False;

  if Value <> '' then
    FFileName := Value;

  if FileExists(value) then
    Load
  else begin
    Save;
    Load;
  end;
end;

procedure TWeatherSettings.Load(filename: string);
var
  xml: TjvSimpleXml;
begin
  // Check if file exists
  If Not(FileExists(filename)) Then Begin
    Debug(format('%s does not exist',[filename]),DMT_WARN);
    exit;
  End;

  // Create and load XML file
  xml := TJvSimpleXml.Create(nil);
  try

    Try
      xml.LoadFromFile(filename);
    Except
      Debug(format('Error loading %s',[filename]),DMT_ERROR);
    End;

    Try
    with xml.Root.Items.ItemNamed['Main'].Items do begin
      FMetric := BoolValue('Metric');
      FCCondInterval := IntValue('CCondInterval',30);
      FFCastInterval := IntValue('FCastInterval',120);
      FCheckInterval := IntValue('CheckInterval',60);
    end;
    Except
      Debug('Error: ' + xml.XMLData,DMT_ERROR);
    End;

  finally
    xml.Free;
  end;
end;

procedure Debug(Message: string; DebugType: Integer);
begin
  SendDebugMessageEx('Weather Service', pchar(Message), 0, DebugType);
end;

procedure TWeatherSettings.Load;
begin
  Load(FFileName);
end;

procedure TWeatherSettings.Save;
begin
  Save(FFilename);
end;

procedure TWeatherSettings.Save(filename: string);
var
  xml: TjvSimpleXml;
begin
  // Delete file and set up XML
  DeleteFile(filename);
  xml := TJvSimpleXml.Create(nil);

  try
    Try
    xml.Root.Name := 'Weather';

    // Add the properties to the root node
    xml.root.Items.Add('Main');
    with xml.Root.Items.ItemNamed['Main'].items do begin
      Add('Metric',FMetric);
      Add('CCondInterval',FCCondInterval);
      Add('FCastInterval',FCastInterval);
      Add('CheckInterval',FCheckInterval);
    end;

    xml.SaveToFile(filename);
    Except
      Debug(format('Error saving %s',[filename]),DMT_ERROR);
    End;
  finally
    xml.Free;
  end;
end;

end.

