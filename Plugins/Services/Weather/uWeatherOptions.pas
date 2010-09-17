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
    FIconSet: String;

  public
    constructor Create;
    property FileName: string read FFileName write FFileName;

    procedure LoadSettings;
    procedure SaveSettings;

    property Metric: boolean read FMetric Write FMetric;
    Property CCondInterval: Integer read FCCondInterval write FCCondInterval;
    property FCastInterval: Integer read FFCastInterval write FFCastInterval;
    property CheckInterval: Integer read FCheckInterval write FCheckInterval;
    property IconSet: String read FIconSet write FIconSet;
  end;

implementation

constructor TWeatherOptions.Create;
begin
  FMetric := False;
  FCCondInterval := 30;
  FCastInterval := 120;
  FCheckInterval := 60;
  FIconSet := 'Default';
  FFileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\WeatherOptions.xml';
end;

procedure TWeatherOptions.LoadSettings;
begin
  XmlFilename := FFileName;
  if Load then begin
    if XmlRoot.Items.ItemNamed['Main'] <> nil then
      with XmlRoot.Items.ItemNamed['Main'].Items do begin
        FMetric := BoolValue('Metric');
        FCCondInterval := IntValue('CCondInterval',30);
        FFCastInterval := IntValue('FCastInterval',120);
        FCheckInterval := IntValue('CheckInterval',60);
      end;
    if XmlRoot.Items.ItemNamed['Skin'] <> nil then
      with XmlRoot.Items.ItemNamed['Skin'].Items do begin
        FIconSet := Value('IconSet', 'Default');


        if not DirectoryExists(SharpAPI.GetSharpeDirectory + 'Icons\Weather\' + FIconSet) then
          FIconSet := 'Default';
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

  with XmlRoot do
  begin
    with Items.Add('Main').Items do
    begin
      Add('Metric',FMetric);
      Add('CCondInterval',FCCondInterval);
      Add('FCastInterval',FCastInterval);
      Add('CheckInterval',FCheckInterval);
    end;

    with Items.Add('Skin').Items do
    begin
      Add('IconSet', FIconSet);
    end;

    Save;
  end;
end;

end.

