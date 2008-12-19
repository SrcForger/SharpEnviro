unit uWeatherOptions;

interface
uses
  Classes,
  ContNrs,
  SysUtils,
  jclSimpleXml,
  dialogs,
  Sharpapi,
  Forms,

  IXmlBaseUnit;

type
  TWeatherOptions = class( TInterfacedXmlBase )
  private
    FMetric: boolean;
    FFileName: String;
    FCCondInterval: Integer;
    FFCastInterval: Integer;
    FCheckInterval: Integer;

  public
    constructor Create;
    property FileName: string read FFileName write FFileName;

    procedure LoadSettings;
    procedure SaveSettings;

    property Metric: boolean read FMetric Write FMetric;
    Property CCondInterval: Integer read FCCondInterval write FCCondInterval;
    property FCastInterval: Integer read FFCastInterval write FFCastInterval;
    property CheckInterval: Integer read FCheckInterval write FCheckInterval;
  end;

implementation

constructor TWeatherOptions.Create;
begin
  FMetric := False;
  FCCondInterval := 30;
  FCastInterval := 120;
  FCheckInterval := 60;
end;

procedure TWeatherOptions.LoadSettings;
begin
  XmlFilename := FFileName;
  if Load then begin
    with XmlRoot.Items.ItemNamed['Main'].Items do begin
      FMetric := BoolValue('Metric');
      FCCondInterval := IntValue('CCondInterval',30);
      FFCastInterval := IntValue('FCastInterval',120);
      FCheckInterval := IntValue('CheckInterval',60);
    end;
  end;
end;

procedure TWeatherOptions.SaveSettings;
var
  node: TJclSimpleXMLElemClassic;
begin
  // Delete file and set up XML
  XmlFilename := FFileName;
  XmlRoot.Items.Clear;
  XmlRoot.Name := 'Weather';

  with XmlRoot do begin
    node := Items.Add('Main');

    with node.Items do begin
      Add('Metric',FMetric);
      Add('CCondInterval',FCCondInterval);
      Add('FCastInterval',FCastInterval);
      Add('CheckInterval',FCheckInterval);
    end;

    Save;
  end;
end;

end.

