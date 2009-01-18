{
Source Name: uWeatherList
Description: Weather List Class
Copyright (C) Pixol (pixol@sharpe-shell.org)

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

unit uWeatherList;

interface
uses
  Classes,
  ContNrs,
  SysUtils,
  JclSimpleXml,

  IXmlBaseUnit;


type
  TWeatherItem = class(TObject)
  private
    FID: Integer;
    FLocation: String;
    FLocationID: String;
    FEnabled: Boolean;
    FCCLastUpdated: String;
    FFCLastUpdated: String;
    FLastIconID: Integer;
    FLastTemp: Integer;
    FMetric: Boolean;
  public
    constructor Create;
    Property ID: Integer Read FID Write FID;
    Property Location: String Read FLocation Write FLocation;
    Property LocationID: String read FLocationID Write FLocationID;
    Property Enabled: Boolean Read FEnabled Write FEnabled;
    Property FCLastUpdated: String read FFCLastUpdated write FFCLastUpdated;
    Property CCLastUpdated: String read FCCLastUpdated write FCCLastUpdated;
    Property LastIconID: Integer read FLastIconID write FLastIconID;
    Property LastTemp: Integer read FLastTemp write FLastTemp;
    property Metric: Boolean read FMetric write FMetric;
  end;

  TWeatherList = class(TInterfacedXmlBaseList)
  private
    FOnAddItem: TNotifyEvent;
    FFileName: string;

    function GetItem(Index: Integer): TWeatherItem;
    procedure SetItem(Index: Integer; const Value: TWeatherItem);

  public

    function AddItem(Location:String; LocationID:String; FCLastUpdated:String;
      CCLastUpdated: String; LastIconID:Integer; LastTemp:Integer;
        Enabled:Boolean; Metric:Boolean): TWeatherItem; overload;

    procedure Delete(weatherItem: TWeatherItem); overload;

    property Item[Index: Integer] : TWeatherItem
             read GetItem write SetItem; Default;

    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;

    procedure LoadSettings;
    procedure SaveSettings;

    property FileName: string read FFileName write FFileName;
  end;

implementation

uses
  SharpApi;

function TWeatherList.AddItem(Location:String; LocationID:String;
  FCLastUpdated:String; CCLastUpdated: String; LastIconID:Integer;
    LastTemp:Integer; Enabled:Boolean; Metric:Boolean): TWeatherItem;
begin
  Result := TWeatherItem.Create;
  Result.ID := Self.Count;
  Result.Location := Location;
  Result.LocationID := LocationID;
  Result.Enabled := Enabled;
  Result.FCLastUpdated := FCLastUpdated;
  Result.CCLastUpdated := CCLastUpdated;
  Result.LastIconID := LastIconID;
  Result.LastTemp := LastTemp;
  Result.Metric := Metric;
  Self.Add(Result);

  if Assigned(FOnAddItem) then
    FOnAddItem(Result);
end;

function TWeatherList.GetItem(Index: Integer): TWeatherItem;
begin
  Result := nil;
  if (Index >= 0) and (Index < Count) then
    Result := TWeatherItem(Items[Index]);
end;

procedure TWeatherList.LoadSettings;
var
  i: Integer;
  props: TJclSimpleXMLProps;
begin
  Xml.XmlFilename := FFileName;
  if Xml.Load then begin
    for i := 0 to Pred(xml.XmlRoot.Items.Count) do begin
      props := Xml.XmlRoot.Items.Item[i].Properties;

      Self.AddItem(
        props.Value('Location'),
        props.Value('LocationId'),
        props.Value('FCLastUpdated','-1'),
        props.Value('CCLastUpdated','-1'),
        props.IntValue('LastIconId',-1),
        props.IntValue('LastTemp',-999),
        props.BoolValue('Enabled',True),
        props.BoolValue('Metric',True));

    end;
  end;
end;

procedure TWeatherList.SetItem(Index: Integer; const Value: TWeatherItem);
begin
  if (Index >= 0) and (Index < Count)
  then Self[Index] := Value;
end;

procedure TWeatherList.SaveSettings;
var
  i: Integer;
  node: TJclSimpleXMLElemClassic;
begin
  Xml.XmlFilename := FFileName;
  Xml.XmlRoot.Clear;
  Xml.XmlRoot.Name := 'WeatherLocations';
  with Xml.XmlRoot do begin

    for i := 0 to pred(self.Count) do begin

      node := Xml.XmlRoot.Items.Add('WeatherLocation');
      with node.Properties do begin
        Add('Location', Self[i].Location);
        Add('LocationID', Self[i].LocationID);
        Add('FCLastUpdated', Self[i].FCLastUpdated);
        Add('CCLastUpdated', Self[i].CCLastUpdated);
        Add('LastIconID', Self[i].LastIconID);
        Add('LastTemp', Self[i].LastTemp);
        Add('Enabled', Self[i].Enabled);
        Add('Metric', Self[i].Metric);
      end;
    end;

    Xml.Save;
  end;
end;

procedure TWeatherList.Delete(weatherItem: TWeatherItem);
var
  n:integer;
begin
  n := IndexOf(weatherItem);

  if n <> -1 then
    Delete(n);
end;

constructor TWeatherItem.Create;
begin
  FLocation := '';
  FLocationID := '';
  FEnabled := False;
  FCCLastUpdated := '-1';
  FFCLastUpdated := '-1';
  FLastIconID := -1;
  FLastTemp := -999;
end;

end.




