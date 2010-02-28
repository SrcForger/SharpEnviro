{
Source Name: AlarmClock
Description: RSS Reader Module Config Dll
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

library AlarmClock;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  uVistaFuncs,
  SysUtils,
  DateUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uAlarmClockWnd in 'uAlarmClockWnd.pas' {frmAlarmClock};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    barID : string;
    moduleID : string;
    procedure Load;
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdCall;
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  PluginHost.GetBarModuleIdFromPluginId(barID, moduleID);
end;

procedure TSharpCenterPlugin.Save;
begin
  with PluginHost.Xml.XmlRoot do
  begin
    Name := 'AlarmClockModuleSettings';

    // Clear the list so we don't get duplicates.
    Items.Clear;

    Items.Add('Settings');
    with Items.ItemNamed['Settings'].Items do
    begin
      Add('Timeout', StrToInt(frmAlarmClock.edtTimeout.Text));
      Add('Snooze', StrToInt(frmAlarmClock.edtSnooze.Text));
    end;  

    Items.Add('Time');
    with Items.ItemNamed['Time'].Items do
    begin
      Add('AutoStart', integer(frmAlarmClock.cbAutostart.Checked));
      if frmAlarmClock.cbDefaultSound.Checked then
        Add('Sound', 'Default')
      else
        Add('Sound', frmAlarmClock.edtSound.Text);

      Add('Second', frmAlarmClock.sgbTimeSecond.Value);
      Add('Minute', frmAlarmClock.sgbTimeMinute.Value);
      Add('Hour', frmAlarmClock.sgbTimeHour.Value);
      Add('Day', frmAlarmClock.sgbTimeDay.Value);
      Add('Month', frmAlarmClock.sgbTimeMonth.Value);
      Add('Year', frmAlarmClock.sgbTimeYear.Value);
    end;   

    PluginHost.Xml.Save;
  end;
end;

procedure TSharpCenterPlugin.Load;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot do
    begin
      if Items.ItemNamed['Settings'] <> nil then
        with Items.ItemNamed['Settings'].Items do
        begin
          frmAlarmClock.edtTimeout.Text := Value('Timeout', '60');
          frmAlarmClock.edtSnooze.Text := Value('Snooze', IntToStr(60*9));
        end;

      if Items.ItemNamed['Time'] <> nil then
        with Items.ItemNamed['Time'].Items do
        begin
          frmAlarmClock.cbAutostart.Checked := BoolValue('AutoStart', True);

          frmAlarmClock.sgbTimeSecond.Value := IntValue('Second', 0);
          frmAlarmClock.sgbTimeMinute.Value := IntValue('Minute', 0);
          frmAlarmClock.sgbTimeHour.Value := IntValue('Hour', 0);
          frmAlarmClock.sgbTimeDay.Value := IntValue('Day', 0);
          frmAlarmClock.sgbTimeMonth.Value := IntValue('Month', 0);
          frmAlarmClock.sgbTimeYear.Value := IntValue('Year', 0);

          frmAlarmClock.cbDefaultSound.Checked := (Value('Sound', 'Default') = 'Default');
          frmAlarmClock.edtSound.Text := Value('Sound', 'Default');
        end;
    end;
  end else
    Save;

  frmAlarmClock.edtSound.Enabled := not frmAlarmClock.cbDefaultSound.Checked;
  frmAlarmClock.btnSoundBrowse.Enabled := not frmAlarmClock.cbDefaultSound.Checked;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmAlarmClock = nil then
    frmAlarmClock := TfrmAlarmClock.Create(nil);
    
  frmAlarmClock.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmAlarmClock);

  Load;
  result := PluginHost.Open(frmAlarmClock);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmAlarmClock);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Alarm Clock';
    Description := 'Alarm Clock Module Configuration';
    Author := 'Mathias Tillman (mathias@sharpenviro.com)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

function GetPluginData(): TPluginData;
begin
  with Result do
  begin
	Name := 'Alarm Clock';
    Description := 'Configure the Alarm Clock';
	Status := '';
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmAlarmClock,AEditing,Theme);
end;

function InitPluginInterface( APluginHost: ISharpCenterHost ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData;

begin
end.

