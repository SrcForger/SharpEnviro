library Weather;

uses
  windows,
  registry,
  Classes,
  Messages,
  activex,
  sysutils,
  Jclstrings,
  forms,
  SharpApi,
  PngSpeedButton,
  uWeatherItemsListWnd in 'uWeatherItemsListWnd.pas' {FrmWeatherItemsList},
  uWeatherOptionsWnd in 'uWeatherOptionsWnd.pas' {frmWeatherOptions},
  uWeatherItemEditWnd in 'uWeatherItemEditWnd.pas' {frmWeatherItem},
  uWeatherList in '..\..\Services\Weather\uWeatherList.pas',
  uWeatherMgr in '..\..\Services\Weather\uWeatherMgr.pas',
  uWeatherOptions in '..\..\Services\Weather\uWeatherOptions.pas';

{$E dll}

{$R *.RES}

function Open(const APluginID:Integer; owner: hwnd):hwnd;
var
  fn:String;
begin

  if FrmWeatherItemsList = nil then
    FrmWeatherItemsList := TFrmWeatherItemsList.Create(nil);

  fn := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\weatheroptions.xml';
  tmpWeatherOptions := TWeatherSettings.Create(fn);

  fn := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\weatherlist.xml';
  TmpWeatherList := TWeatherList.Create(fn);

  FrmWeatherItemsList.ParentWindow := owner;
  FrmWeatherItemsList.Left := 0;
  FrmWeatherItemsList.Top := 0;
  FrmWeatherItemsList.BorderStyle := bsNone;
  FrmWeatherItemsList.UpdateDisplay(TmpWeatherList);
  FrmWeatherItemsList.Show;
  
  result := FrmWeatherItemsList.Handle;


end;

function New(const APluginID:Integer; owner: hwnd):hwnd;
var
  fn:String;
begin
  if FrmWeatherItemsList = nil then
    FrmWeatherItemsList := TFrmWeatherItemsList.Create(nil);

  fn := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\weatheroptions.xml';
  tmpWeatherOptions := TWeatherSettings.Create(fn);

  fn := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\weatherlist.xml';
  TmpWeatherList := TWeatherList.Create(fn);

  FrmWeatherItemsList.ParentWindow := owner;
  FrmWeatherItemsList.Left := 0;
  FrmWeatherItemsList.Top := 0;
  FrmWeatherItemsList.BorderStyle := bsNone;
  FrmWeatherItemsList.UpdateDisplay(TmpWeatherList);
  FrmWeatherItemsList.Show;

  result := FrmWeatherItemsList.Handle;
end;

procedure Help;
begin
  SharpApi.HelpMsg('go {docs}\SharpCore\Services\weather.sdoc');
end;

function Close(owner: hwnd; SaveSettings: Boolean): boolean;
begin

  try

    if SaveSettings then begin
      TmpWeatherList.Save;
      tmpWeatherOptions.Save;
    end;

    FrmWeatherItemsList.Close;
    FrmWeatherItemsList.Free;
    FrmWeatherItemsList := nil;

    result := True;
  except
    result := False;
  end;
end;

function ConfigDllType: Integer;
begin
  Result := SCU_SERVICE;
end;

procedure GetDisplayName(const APluginID:Integer; var ADisplayName:PChar);
begin
  ADisplayName := PChar('Weather');
end;

procedure BtnAdd(var AButton:TPngSpeedButton);
begin
  FrmWeatherItemsList.AddItem;
end;

procedure BtnEdit(var AButton:TPngSpeedButton);
begin
  FrmWeatherItemsList.EditItem;
end;

procedure BtnDelete(var AButton:TPngSpeedButton);
begin
  FrmWeatherItemsList.DeleteItem;
end;

procedure BtnImport(var AButton:TPngSpeedButton);
begin
  FrmWeatherItemsList.ImportList;
end;

procedure BtnExport(var AButton:TPngSpeedButton);
begin
  FrmWeatherItemsList.ExportList;
end;

procedure BtnClear(var AButton:TPngSpeedButton);
begin
  FrmWeatherItemsList.ClearList;
end;

exports
  Open,
  New,
  Close,
  Help,
  BtnAdd,
  BtnEdit,
  BtnDelete,
  BtnClear,
  BtnImport,
  BtnExport,
  ConfigDllType,
  GetDisplayName;

begin

end.


