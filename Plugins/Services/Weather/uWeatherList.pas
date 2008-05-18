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
  jclIniFiles,
  ContNrs,
  SysUtils,
  JvSimpleXml;


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

  TWeatherList = class(TObjectList)
  private
    FOnAddItem: TNotifyEvent;
    FFileName: string;

    procedure Debug(Str: string; ErrorType: Integer);
    function GetItem(Index: Integer): TWeatherItem;
    procedure SetItem(Index: Integer; const Value: TWeatherItem);

  public
    constructor Create(FileName: string);

    function Add(Location:String; LocationID:String; FCLastUpdated:String;
      CCLastUpdated: String; LastIconID:Integer; LastTemp:Integer;
        Enabled:Boolean; Metric:Boolean): TWeatherItem; overload;

    procedure Delete(weatherItem: TWeatherItem); overload;

    property Item[Index: Integer] : TWeatherItem
             read GetItem write SetItem; Default;

    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;

    procedure Load(xmlfile: TFilename); overload;
    procedure Save(xmlfile: TFilename); overload;
    procedure Load; overload;
    procedure Save; overload;

    property FileName: string read FFileName write FFileName;
  end;

  var
    WeatherList:TWeatherList;

implementation

uses
  SharpApi;

function TWeatherList.Add(Location:String; LocationID:String;
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

constructor TWeatherList.Create(FileName: string);
begin
  inherited Create;
  FFileName := FileName;

  if FileExists(FileName) then
    Load
  else begin
    Save;
  end;
end;

function TWeatherList.GetItem(Index: Integer): TWeatherItem;
begin
  Result := nil;
  if (Index >= 0) and (Index < Count) then
    Result := (Items[Index] as TWeatherItem);
end;

procedure TWeatherList.Load;
begin
  Load(FFilename);
end;

procedure TWeatherList.Load(xmlfile: TFilename);
var
  ItemCount, Loop: Integer;
  xml: TjvSimpleXml;
  prop: string;
begin

  xml := TJvSimpleXml.Create(nil);

  try
    try
      xml.LoadFromFile(xmlfile);

      Itemcount := xml.Root.Properties.Item[0].IntValue;
      for Loop := 0 to itemcount - 1 do begin
        prop := 'Location' + inttostr(loop);

        with xml.Root.Items do begin

          self.Add(
            ItemNamed['Location' + inttostr(loop)].Properties.Value('Location',''),
            ItemNamed['Location' + inttostr(loop)].Properties.Value('LocationID',''),
            ItemNamed['Location' + inttostr(loop)].Properties.Value('FCLastUpdated','-1'),
            ItemNamed['Location' + inttostr(loop)].Properties.Value('CCLastUpdated','-1'),
            ItemNamed['Location' + inttostr(loop)].Properties.IntValue('LastIconID',-1),
            ItemNamed['Location' + inttostr(loop)].Properties.IntValue('LastTemp',-999),
            ItemNamed['Location' + inttostr(loop)].Properties.BoolValue('Enabled',True),
            ItemNamed['Location' + inttostr(loop)].Properties.BoolValue('Metric',True));
        end;
      end;
    except

      on E: Exception do begin
        Debug('Error While Loading Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);

        // Create New
        Save;
      end;
    end;
  finally
    xml.Free;
  end;
end;

procedure TWeatherList.Save;
begin
  Save(FFilename);
end;

procedure TWeatherList.SetItem(Index: Integer; const Value: TWeatherItem);
begin
  if (Index >= 0) and (Index < Count)
  then Self[Index] := Value;
end;

procedure TWeatherList.Save(xmlfile: TFilename);
var
  i: Integer;
  Xml: TjvSimpleXml;
begin
  Xml := TJvSimpleXml.Create(nil);

  try
    try
      Xml.Root.Name := 'WeatherLocations';
      xml.Root.Properties.Add('ItemCount', self.count);

      for i := 0 to self.Count - 1 do begin
        Xml.Root.Items.Add(Format('Location%d', [i]));
        Xml.Root.Items.Item[i].Properties.Add('Location', Self[i].Location);
        Xml.Root.Items.Item[i].Properties.Add('LocationID', Self[i].LocationID);
        Xml.Root.Items.Item[i].Properties.Add('FCLastUpdated', Self[i].FCLastUpdated);
        Xml.Root.Items.Item[i].Properties.Add('CCLastUpdated', Self[i].CCLastUpdated);
        Xml.Root.Items.Item[i].Properties.Add('LastIconID', Self[i].LastIconID);
        Xml.Root.Items.Item[i].Properties.Add('LastTemp', Self[i].LastTemp);
        Xml.Root.Items.Item[i].Properties.Add('Enabled', Self[i].Enabled);
        Xml.Root.Items.Item[i].Properties.Add('Metric', Self[i].Metric);
      end;

      ForceDirectories(ExtractFilePath((xmlFile)));
      Xml.SaveToFile(xmlfile);
    except
      on E: Exception do begin
        Debug('Error While Saving Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);
      end;
    end;

  finally
    Xml.Free;
  end;
end;

procedure TWeatherList.Debug(Str: string; ErrorType: Integer);
begin
  SendDebugMessageEx('Weather Service',PChar(Str),0,ErrorType);
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




