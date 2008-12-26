library Weather;

uses
  windows,
  registry,
  Classes,
  Messages,
  graphics,
  activex,
  sysutils,
  Jclstrings,
  forms,
  SharpApi,
  SharpCenterApi,
  PngSpeedButton,
  uVistaFuncs,
  uListWnd in 'uListWnd.pas' {frmItemswnd},
  uEditWnd in 'uEditWnd.pas' {frmEditWnd},
  uWeatherList in '..\..\..\Services\Weather\uWeatherList.pas',
  uWeatherMgr in '..\..\..\Services\Weather\uWeatherMgr.pas',
  VKToString in '..\..\..\..\Common\Units\SCHotkeyManager\VKToString.pas',
  uScHotkeyMgr in '..\..\..\..\Common\Units\SCHotkeyManager\uScHotkeyMgr.pas',
  uWeatherOptions in '..\..\..\Services\Weather\uWeatherOptions.pas',

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

{$E dll}

{$R *.RES}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit,
    ISharpCenterPluginValidation )
  private
    procedure Load;

  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;
    procedure Save; override; stdCall;


    function GetPluginDescriptionText: String; override; stdCall;
    procedure Refresh; override; stdcall;
    procedure SetupValidators; stdcall;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmItemsWnd);
  FreeAndNil(frmEditWnd);
end;

procedure TSharpCenterPlugin.CloseEdit(AApply: Boolean);
begin
  if AApply then
    frmEditWnd.Save;

  FreeAndNil(frmEditWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  Result := 'Configure your weather locations. SOAP Services provided by Weather.com.';
end;

procedure TSharpCenterPlugin.Load;
begin
  frmItemswnd.WeatherList.FileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\WeatherList.xml';
  frmItemswnd.WeatherList.LoadSettings;

  frmItemswnd.WeatherOptions.FileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\WeatherOptions.xml';
  frmItemswnd.WeatherOptions.LoadSettings;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmItemsWnd = nil then frmItemsWnd := TfrmItemsWnd.Create(nil);
  uVistaFuncs.SetVistaFonts(frmItemsWnd);

  frmItemsWnd.PluginHost := PluginHost;

  Load;
  result := PluginHost.Open(frmItemsWnd);
end;

function TSharpCenterPlugin.OpenEdit: Cardinal;
begin
  if frmEditWnd = nil then frmEditWnd := TfrmEditWnd.Create(nil);
  frmEditWnd.PluginHost := Self.PluginHost;
  uVistaFuncs.SetVistaFonts(frmEditWnd);

  result := PluginHost.OpenEdit(frmEditWnd);
  frmEditWnd.Init;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToForms(frmItemsWnd, frmEditWnd);
end;

procedure TSharpCenterPlugin.Save;
begin
  inherited;
  frmItemswnd.WeatherList.SaveSettings;
  frmItemswnd.WeatherOptions.SaveSettings;
end;

procedure TSharpCenterPlugin.SetupValidators;
begin
  // Can not leave fields blank
  PluginHost.AddRequiredFieldValidator( frmEditWnd.edName,'Please enter a name for this weather Id','Text');
  PluginHost.AddRequiredFieldValidator( frmEditWnd.edWeatherID,'Please enter a valid weather Id','Text');
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Weather';
    Description := 'Weather Service Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.5.2';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suService)]);
  end;
end;

function InitPluginInterface( APluginHost: TInterfacedSharpCenterHostBase ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.

//function Open(const APluginID:Pchar; AOwner: hwnd): hwnd;
//var
//  sFileName:String;
//begin
//
//  if frmItemsList = nil then
//    frmItemsList := TfrmItemsList.Create(nil);
//  SetVistaFonts(frmItemsList);
//
//  sFileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\weatheroptions.xml';
//  WeatherOptions := TWeatherOptions.Create(sFileName);
//
//  sFileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\weatherlist.xml';
//  WeatherList := TWeatherList.Create(sFileName);
//
//  frmItemsList.ParentWindow := AOwner;
//  frmItemsList.Left := 0;
//  frmItemsList.Top := 0;
//  frmItemsList.BorderStyle := bsNone;
//  frmItemsList.UpdateDisplay(WeatherList);
//  frmItemsList.Show;
//
//  result := frmItemsList.Handle;
//end;
//
//function Close: boolean;
//begin
//  result := True;
//  try
//    frmItemsList.Close;
//    frmItemsList.Free;
//    frmItemsList := nil;
//
//    if frmItemEdit <> nil then begin
//      frmItemEdit.Close;
//      frmItemEdit.Free;
//      frmItemEdit := nil;
//    end;
//  except
//    result := False;
//  end;
//  BroadcastGlobalUpdateMessage(suWeather);  
//end;
//
//function OpenEdit(AOwner:Hwnd; AEditMode:TSCE_EDITMODE_ENUM):Hwnd;
//begin
//  if Not(Assigned(frmItemEdit)) then
//    frmItemEdit := TfrmItemEdit.Create(nil);
//
//  SetVistaFonts(frmItemEdit);
//  with frmItemEdit do begin
//    ParentWindow := AOwner;
//    Left := 0;
//    Top := 0;
//    BorderStyle := bsNone;
//    Show;
//  end;
//
//  frmItemsList.EditMode := AEditMode;
//  frmItemEdit.InitUI(AEditMode, True);
//  Result :=  frmItemEdit.Handle;
//end;
//
//function CloseEdit(AEditMode:TSCE_EDITMODE_ENUM; AApply:Boolean): boolean;
//begin
//
//  // Validation
//  if (AApply) and Not(frmItemEdit.ValidateEdit(AEditMode)) then Begin
//    Result := False;
//    Exit;
//  End;
//
//  // Define whether we add/edit or delete the item
//  frmItemEdit.Save(AApply, AEditMode);
//
//  FreeAndNil(frmItemEdit);
//  Result := True;
//end;
//
//procedure SetText(const APluginID:string; var AName:string; var AStatus: String;
//  var ADescription: String);
//var
//  tmpWL: TWeatherList;
//  sFileName: string;
//begin
//  // Name
//  AName := 'Weather';
//  ADescription := 'Configure your weather locations. SOAP Services provided by Weather.com.';
//
//  // Status
//  sFileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\weatherlist.xml';
//  tmpWL := TWeatherList.Create(sFileName);
//  Try
//    AStatus := IntToStr(tmpWl.Count);
//  Finally
//    tmpWL.Free;
//  End;
//end;
//
//procedure GetCenterScheme(var ABackground: TColor;
//  var AItemColor: TColor; var AItemSelectedColor: TColor);
//begin
//  frmItemsList.lbWeatherList.Colors.ItemColor := AItemColor;
//  frmItemsList.lbWeatherList.Colors.ItemColorSelected := AItemSelectedColor;
//
//  if Assigned(frmItemEdit) then
//    frmItemEdit.Color := ABackground;
//end;
//
//
//
//exports
//  Open,
//  Close,
//
//  OpenEdit,
//  CloseEdit,
//  GetMetaData,
//
//  SetText,
//
//  GetCenterScheme;
//
//begin
//
//end.


