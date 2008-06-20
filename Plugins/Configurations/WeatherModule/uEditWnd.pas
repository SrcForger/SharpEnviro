﻿{
Source Name: uEditWnd.pas
Description: Options Window
Copyright (C) Lee Green (lee@sharpenviro.com)

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

unit uEditWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Contnrs,
  Graphics,
  Controls,
  Forms,
  StdCtrls,
  ImgList,
  PngImageList,
  SharpTypes,
  SharpEListBoxEx, TaskFilterList, ExtCtrls, JclSimpleXml, JclStrings, Menus;

type
  TfrmEdit = class(TForm)
    pnlOptions: TPanel;
    Label3: TLabel;
    lblWeatherLocationDesc: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    chkDisplayIcon: TCheckBox;
    chkDisplayLabels: TCheckBox;
    cbLocation: TComboBox;
    Label6: TLabel;
    Label4: TLabel;
    lblLabelDesc: TLabel;
    lblDisplayDesc: TLabel;
    Panel3: TPanel;
    Label2: TLabel;
    Panel4: TPanel;
    Label5: TLabel;
    edtTopLabel: TEdit;
    edtBottomLabel: TEdit;
    btnBrowseTop: TButton;
    btnBrowseBottom: TButton;
    mnuTags: TPopupMenu;
    GlobalValues1: TMenuItem;
    Location1: TMenuItem;
    Name1: TMenuItem;
    Long1: TMenuItem;
    Latitute1: TMenuItem;
    ObservationStation1: TMenuItem;
    imeZone1: TMenuItem;
    Moon1: TMenuItem;
    IconCode1: TMenuItem;
    MoonText1: TMenuItem;
    Sundata1: TMenuItem;
    SunRise1: TMenuItem;
    SunSet1: TMenuItem;
    Units1: TMenuItem;
    Distance1: TMenuItem;
    Pressure1: TMenuItem;
    Speed1: TMenuItem;
    emperature1: TMenuItem;
    UnitOfPrecip1: TMenuItem;
    CurrentCondition1: TMenuItem;
    emperature2: TMenuItem;
    FeelsLikeTemperature1: TMenuItem;
    Value1: TMenuItem;
    Wind1: TMenuItem;
    DirectionDegr1: TMenuItem;
    DirectionText1: TMenuItem;
    MaxSpeed1: TMenuItem;
    Speed2: TMenuItem;
    BarometerPressure1: TMenuItem;
    CurrentPressure1: TMenuItem;
    RaisorFallText1: TMenuItem;
    UV1: TMenuItem;
    Value2: TMenuItem;
    UVValueText1: TMenuItem;
    N2: TMenuItem;
    ConditionText1: TMenuItem;
    Dewpoint1: TMenuItem;
    Humidity1: TMenuItem;
    LastUpdate1: TMenuItem;
    Visibility1: TMenuItem;
    Forecast1: TMenuItem;
    Day11: TMenuItem;
    Day1: TMenuItem;
    Condition1: TMenuItem;
    DayIcon1: TMenuItem;
    Humidity2: TMenuItem;
    precipitation1: TMenuItem;
    WIND2: TMenuItem;
    DirectionDegr2: TMenuItem;
    DirectionText2: TMenuItem;
    MaxSpeed2: TMenuItem;
    Speed3: TMenuItem;
    Day2: TMenuItem;
    Condition2: TMenuItem;
    Icon1: TMenuItem;
    Humidity3: TMenuItem;
    Precipitation2: TMenuItem;
    Wind4: TMenuItem;
    DirectionDegr3: TMenuItem;
    DirectionText3: TMenuItem;
    MaxSpeed3: TMenuItem;
    Speed4: TMenuItem;
    N4: TMenuItem;
    DayName1: TMenuItem;
    Date1: TMenuItem;
    HighestTemperature1: TMenuItem;
    LowestTemperature1: TMenuItem;
    imeSunset1: TMenuItem;
    SunRise2: TMenuItem;
    N3: TMenuItem;
    LastUpdate2: TMenuItem;
    N1: TMenuItem;
    Examples1: TMenuItem;
    Condition3: TMenuItem;
    emperature21C1: TMenuItem;
    WindSpeed1: TMenuItem;
    procedure FormCreate(Sender: TObject);

    procedure SettingsChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure miTagClick(Sender: TObject);
    procedure miExampleClick(Sender: TObject);
  private
    FModuleId: string;
    FBarId: string;
    FUpdating: boolean;
    procedure PopulateLocations;
  public
    property BarId: string read FBarId write FBarId;
    property ModuleId: string read FModuleId write FModuleId;

    procedure LoadSettings;
    procedure SaveSettings;
  end;

var
  frmEdit: TfrmEdit;

const
  colName = 0;

implementation

uses SharpThemeApi, SharpApi, SharpCenterApi, uSharpBarAPI, SharpESkin;

{$R *.dfm}

procedure TfrmEdit.btnBrowseClick(Sender: TObject);
var
  p : TPoint;
  btn: TButton;
begin
  btn := TButton(Sender);
  p := ClientToScreen(Point(btn.Left, btn.Top + btn.Height));

  if btn = btnBrowseTop then
    mnuTags.PopupComponent := edtTopLabel else
    mnuTags.PopupComponent := edtBottomLabel;

  mnuTags.Popup(p.x,p.y);
end;

procedure TfrmEdit.PopulateLocations;
var
  xml:TJclSimpleXML;
  n: Integer;
begin
  cbLocation.Clear;
  xml := TJclSimpleXML.Create;
  try
    xml.LoadFromFile(GetSharpEUserSettingsPath+'SharpCore\Services\Weather\WeatherList.xml');

    for n := 0 to XML.Root.Items.Count - 1 do begin
      cbLocation.Items.Add(xml.Root.Items.Item[n].Properties.Value('location',''));
    end;

  finally
    xml.Free;
  end;
end;

procedure TfrmEdit.miExampleClick(Sender: TObject);
var
  edt: TEdit;
begin
  edt := TEdit(mnuTags.PopupComponent);

  if edt <> nil then
     edt.Text := TMenuItem(Sender).Hint;

  SettingsChange(nil);
end;

procedure TfrmEdit.SettingsChange(Sender: TObject);
begin
  if not (FUpdating) then
    CenterDefineSettingsChanged;
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  lblWeatherLocationDesc.Font.Color := clGrayText;
  lblLabelDesc.Font.Color := clGrayText;
  lblDisplayDesc.Font.Color := clGrayText;
end;

procedure TfrmEdit.LoadSettings;
var
  xml: TJclSimpleXML;
  fileloaded: boolean;
  showIcon, showLabels: boolean;
  location, topLabel, bottomLabel: string;
begin
  xml := TJclSimpleXML.Create;
  FUpdating := True;
  try
    fileloaded := False;
    try
      XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(StrToInt(FBarId), StrToInt(FModuleId)));
      fileloaded := True;
    except
    end;

    if fileloaded then
      with xml.Root.Items do
      begin

        // Location
        PopulateLocations;
        location := Value('Location', '');
        cbLocation.ItemIndex := cbLocation.Items.IndexOf(location);
        if cbLocation.ItemIndex = -1 then cbLocation.ItemIndex := 0;

        // Show icon
        showIcon := BoolValue('ShowIcon', true);
        chkDisplayIcon.Checked := showIcon;

        // Show labels
        showLabels := BoolValue('ShowLabels', true);
        chkDisplayLabels.Checked := showLabels;

        // Top label
        topLabel := Value('TopLabel','Temperature: {#TEMPERATURE#}°{#UNITTEMP#}');
        edtTopLabel.Text := topLabel;

        // Bottom label
        bottomLabel := Value('BottomLabel','Condition: {#CONDITION#}');
        edtBottomLabel.Text := bottomLabel;
      end;

  finally
    XML.Free;
    FUpdating := False;
  end;

end;

procedure TfrmEdit.miTagClick(Sender: TObject);
var
  edt: TEdit;
begin
  edt := TEdit(mnuTags.PopupComponent);

  if edt <> nil then
     edt.Text := edt.Text + TMenuItem(Sender).Hint;

  SettingsChange(nil);
end;

procedure TfrmEdit.SaveSettings;
var
  xml: TJclSimpleXML;
begin
  xml := TJclSimpleXML.Create;
  try
    xml.Root.Name := 'WeatherModuleSettings';
    with xml.Root.Items do
    begin

      // Location
      Add('Location',cbLocation.Text);

      // Show icon
      Add('ShowIcon',chkDisplayIcon.Checked);

      // Show labels
      Add('ShowLabels', chkDisplayLabels.Checked);

      // Top label
      Add('TopLabel', edtTopLabel.Text);

      // Bottom label
      Add('BottomLabel', edtBottomLabel.Text);
    end;

  finally
    XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(StrToInt(FBarId), StrToInt(FModuleId)));
    XML.Free;
  end;

end;

end.
