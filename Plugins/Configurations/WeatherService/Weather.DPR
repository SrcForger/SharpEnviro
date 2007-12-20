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
  uWeatherItemsListWnd in 'uWeatherItemsListWnd.pas' {frmItemsList},
  uWeatherOptionsWnd in 'uWeatherOptionsWnd.pas' {frmWeatherOptions},
  uWeatherItemEditWnd in 'uWeatherItemEditWnd.pas' {frmItemEdit},
  uWeatherList in '..\..\Services\Weather\uWeatherList.pas',
  uWeatherMgr in '..\..\Services\Weather\uWeatherMgr.pas',
  uWeatherOptions in '..\..\Services\Weather\uWeatherOptions.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas';

{$E dll}

{$R *.RES}

function Open(const APluginID:Pchar; AOwner: hwnd): hwnd;
var
  sFileName:String;
begin

  if frmItemsList = nil then
    frmItemsList := TfrmItemsList.Create(nil);
  SetVistaFonts(frmItemsList);

  CenterDefineConfigurationMode(scmLive);

  sFileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\weatheroptions.xml';
  WeatherOptions := TWeatherSettings.Create(sFileName);

  sFileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\weatherlist.xml';
  WeatherList := TWeatherList.Create(sFileName);

  frmItemsList.ParentWindow := AOwner;
  frmItemsList.Left := 0;
  frmItemsList.Top := 0;
  frmItemsList.BorderStyle := bsNone;
  frmItemsList.UpdateDisplay(WeatherList);
  frmItemsList.Show;
  result := frmItemsList.Handle;
end;

function Close: boolean;
begin
  result := True;
  try
    frmItemsList.Close;
    frmItemsList.Free;
    frmItemsList := nil;

    if frmItemEdit <> nil then begin
      frmItemEdit.Close;
      frmItemEdit.Free;
      frmItemEdit := nil;
    end;
  except
    result := False;
  end;
end;

function OpenEdit(AOwner:Hwnd; AEditMode:TSCE_EDITMODE_ENUM):Hwnd;
begin
  if Not(Assigned(frmItemEdit)) then
    frmItemEdit := TfrmItemEdit.Create(nil);

  SetVistaFonts(frmItemEdit);
  with frmItemEdit do begin
    ParentWindow := AOwner;
    Left := 0;
    Top := 0;
    BorderStyle := bsNone;
    Show;
  end;

  frmItemsList.EditMode := AEditMode;
  frmItemEdit.InitUI(AEditMode, True);
  Result :=  frmItemEdit.Handle;
end;

function CloseEdit(AEditMode:TSCE_EDITMODE_ENUM; AApply:Boolean): boolean;
begin

  // Validation
  if (AApply) and Not(frmItemEdit.ValidateEdit(AEditMode)) then Begin
    Result := False;
    Exit;
  End;

  // Define whether we add/edit or delete the item
  if frmItemEdit.Save(AApply, AEditMode) then Begin

  end;

  FreeAndNil(frmItemEdit);
  Result := True;
end;

procedure SetText(const APluginID:string; var AName:string; var AStatus: String;
  var ATitle: String; var ADescription: String);
var
  tmpWL: TWeatherList;
  sFileName: string;
begin
  // Name
  AName := 'Weather';
  AStatus := '';

  // Status
  sFileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\weatherlist.xml';
  tmpWL := TWeatherList.Create(sFileName);
  Try
    AStatus := IntToStr(tmpWl.Count);
  Finally
    tmpWL.Free;
  End;
end;

function  SetSettingType: TSU_UPDATE_ENUM;
begin
  Result := suService;
end;

procedure GetCenterScheme(var ABackground: TColor;
  var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
  frmItemsList.lbWeatherList.Colors.ItemColor := AItemColor;
  frmItemsList.lbWeatherList.Colors.ItemColorSelected := AItemSelectedColor;

  if Assigned(frmItemEdit) then
    frmItemEdit.Color := ABackground;
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  ATabs.Add('Weather',nil,'',IntToStr(frmItemsList.lbWeatherList.Count));
end;

exports
  Open,
  Close,

  AddTabs,

  OpenEdit,
  CloseEdit,

  SetSettingType,
  SetText,

  GetCenterScheme;

begin

end.


