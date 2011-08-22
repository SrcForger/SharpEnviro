unit uSharpHTTP;

interface

uses
  Types, Registry, Windows, Classes, SysUtils, ShellApi,
  SharpApi, SharpTypes, uSharpXmlUtils,
  JclSimpleXML,
  SOAPHTTPTrans;

type
  TSharpHTTP = class(TObject)
  private
    FRequest: THTTPReqResp;

    FProxyEnabled: Boolean;
    FProxyAddress: String;
    FProxyPort: String;

    FXmlPath: String;
    FLastCheck: TDateTime;

  public
    constructor Create(UTF8InHeader: Boolean = False);
    destructor Destroy; override;

    function Download(const Url: String; Stream: TStream): Boolean; overload;
    function Download(const Url: String; const OutPath: String): Boolean; overload;

    procedure LoadSettings;
    procedure SaveSettings;

    property ProxyEnabled: Boolean read FProxyEnabled write FProxyEnabled;
    property ProxyAddress: String read FProxyAddress write FProxyAddress;
    property ProxyPort: String read FProxyPort write FProxyPort;
    
  end;

implementation

constructor TSharpHTTP.Create(UTF8InHeader: Boolean);
begin
  inherited Create();

  FXmlPath := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\HTTP.xml';

  FRequest := THTTPReqResp.Create(nil);
  FRequest.UseUTF8InHeader := UTF8InHeader;
  LoadSettings;
end;

destructor TSharpHTTP.Destroy;
begin
  FreeAndNil(FRequest);
end;


procedure TSharpHTTP.LoadSettings;
var
  XML: TJclSimpleXML;
begin
  // Reset settings
  FProxyEnabled := False;
  FProxyAddress := '';
  FProxyPort := '';

  XML := TJclSimpleXML.Create;
  try
    if uSharpXmlUtils.LoadXMLFromSharedFile(XML, FXmlPath) then
    begin
      if xml.Root.Items.ItemNamed['Proxy'] <> nil then
      begin
        with xml.Root.Items.ItemNamed['Proxy'].Properties do
        begin
          FProxyEnabled := BoolValue('enable', False);
          FProxyAddress := Value('address', '');
          FProxyPort := Value('port', '');
        end;
      end;
    end;
  finally
    XML.Free;

    FileAge(FXmlPath, FLastCheck);
  end;
end;

procedure TSharpHTTP.SaveSettings;
var
  XML: TJclSimpleXML;
begin
  XML := TJclSimpleXml.Create;
  try
    XML.Root.Items.Clear;
    XML.Root.Name := 'HTTP';

    with XML.Root do
    begin
      with Items.Add('Proxy').Properties do
      begin
        Add('enable', FProxyEnabled);
        Add('address', FProxyAddress);
        Add('port', FProxyPort);
      end;
    end;

    uSharpXmlUtils.SaveXMLToSharedFile(XML, FXmlPath);
  finally
    XML.Free;
  end;
end;

function TSharpHTTP.Download(const Url: String; Stream: TStream): Boolean;
var
  dbg: String;
  tm: TDateTime;
begin
  Result := False;
  if not Assigned(FRequest) then
    Exit;

  // Check if we should reload settings
  FileAge(FXmlPath, tm);
  if FLastCheck <> tm then
    LoadSettings;

  try
    dbg := 'Downloading ' + Url;
    if (FProxyEnabled) and (FProxyAddress <> '') and (FProxyPort <> '') then
      dbg := dbg + ' using proxy ' + FProxyAddress + ':' + FProxyPort;
    
    SharpApi.SendDebugMessage('HTTP', dbg, DMT_INFO);

    if (FProxyEnabled) and (FProxyAddress <> '') and (FProxyPort <> '') then
      FRequest.Proxy := FProxyAddress + ':' + FProxyPort;

    FRequest.URL := Url;
    FRequest.Execute(Url, Stream);
    SharpApi.SendDebugMessage('HTTP', Url + ' was downloaded successfully!', DMT_INFO);
    Result := True;
  except

  end;
end;

function TSharpHTTP.Download(const Url: String; const OutPath: String): Boolean;
var
  Stream: TMemoryStream;
begin
  Result := False;

  Stream := TMemoryStream.Create;
  try
    if Download(Url, Stream) then
    begin
      Stream.SaveToFile(OutPath);
      Result := True;
    end;
  finally
    Stream.Free;
  end;
end;

end.
