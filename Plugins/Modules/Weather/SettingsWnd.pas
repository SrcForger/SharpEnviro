{
Source Name: SettingsWnd
Description: Weather module settings window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit SettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, SharpApi, Menus, JvSimpleXML;

type
  TSettingsForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    OpenFile: TOpenDialog;
    cb_showicon: TCheckBox;
    cb_info: TCheckBox;
    Label1: TLabel;
    dd_location: TComboBox;
    pop_add: TPopupMenu;
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
    edit_top: TEdit;
    edit_bottom: TEdit;
    lb_top: TLabel;
    lb_bottom: TLabel;
    btn_addtop: TButton;
    btn_addbottom: TButton;
    N1: TMenuItem;
    Examples1: TMenuItem;
    emperature21C1: TMenuItem;
    Condition3: TMenuItem;
    WindSpeed1: TMenuItem;
    procedure WindSpeed1Click(Sender: TObject);
    procedure cb_infoClick(Sender: TObject);
    procedure btn_addbottomClick(Sender: TObject);
    procedure btn_addtopClick(Sender: TObject);
    procedure Condition3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FLastEdit : TEdit;
  public
    sLocation : String;
    procedure BuildLocationList(current : string);
  end;


implementation

{$R *.dfm}

procedure TSettingsForm.Button1Click(Sender: TObject);
var
  n : integer;
  XML : TJvSimpleXML;
begin
  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(GetSharpEUserSettingsPath+'SharpCore\Services\Weather\weatherlist.xml');
    for n := 0 to XML.Root.Items.Count - 1 do
        if XML.Root.Items.Item[n].Properties.Value('Location') = dd_location.Text then
    begin
      sLocation := XML.Root.Items.Item[n].Properties.Value('LocationID');
      break;
    end;
  except
  end;
  XML.Free;

  self.ModalResult := mrOk;
end;

procedure TSettingsForm.Button2Click(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TSettingsForm.BuildLocationList(current : string);
var
  XML : TJvSimpleXML;
  n : integer;
begin
  sLocation := current;
  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(GetSharpEUserSettingsPath+'SharpCore\Services\Weather\weatherlist.xml');
    for n := 0 to XML.Root.Items.Count - 1 do
    begin
        dd_location.Items.Add(XML.Root.Items.Item[n].Properties.Value('Location','error loading location data'));
        if XML.Root.Items.Item[n].Properties.Value('LocationID') = current then
           dd_location.ItemIndex := dd_location.Items.IndexOf(XML.Root.Items.Item[n].Properties.Value('Location'));
    end;
  except
  end;
  XML.Free;
  
  if length(trim(dd_location.text)) = 0 then
     if dd_location.Items.Count >0 then
        dd_location.ItemIndex := 0;
end;

procedure TSettingsForm.Condition3Click(Sender: TObject);
begin
  if FLastEdit <> nil then
     FLastEdit.Text := FLastEdit.Text + TMenuItem(Sender).Hint;
end;

procedure TSettingsForm.btn_addtopClick(Sender: TObject);
var
  p : TPoint;
begin
  FLastEdit := edit_top;
  p := ClientToScreen(Point(btn_addtop.Left, btn_addtop.Top + btn_addtop.Height));
  pop_add.Popup(p.x,p.y);
end;

procedure TSettingsForm.btn_addbottomClick(Sender: TObject);
var
  p : TPoint;
begin
  FLastEdit := edit_bottom;
  p := ClientToScreen(Point(btn_addbottom.Left, btn_addbottom.Top + btn_addbottom.Height));
  pop_add.Popup(p.x,p.y);
end;

procedure TSettingsForm.cb_infoClick(Sender: TObject);
begin
  lb_top.Enabled := cb_info.checked;
  lb_bottom.Enabled := cb_info.checked;
  btn_addtop.Enabled := cb_info.checked;
  btn_addbottom.Enabled := cb_info.checked;
  edit_top.Enabled := cb_info.checked;
  edit_bottom.Enabled := cb_info.checked;
end;

procedure TSettingsForm.WindSpeed1Click(Sender: TObject);
begin
  if FLastEdit <> nil then
     FLastEdit.Text := TMenuItem(Sender).Hint;
end;

end.
