{
Source Name: SharpEScheme
Description: SharpE component for SharpE
Copyright (C) Malx (Malx@techie.com)
              Martin Krämer (MartinKraemer@gmx.net)

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
unit SharpEScheme;

interface

uses
  Windows,
  SharpApi,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  StdCtrls,
  gr32,
  ISharpESkinComponents,
  SharpThemeApiEx,
  uThemeConsts;

type
  TSharpEScheme = class(TInterfacedObject, ISharpEScheme)
  private
    FColors  : TSharpEColorSet;
    FInterface : ISharpEScheme;
  protected
  public
    constructor Create(OwnsInterface : boolean = False); reintroduce;
    destructor Destroy; override;
    procedure Assign(Source: TSharpEScheme); overload;
    procedure Assign(Source: ISharpEScheme); overload;
    procedure AddColor(Name,Tag,Info : String; Color : integer; sType : TSharpESchemeType); overload;
    procedure AddColor(Color : TSharpESkinColor); overload;
    procedure ClearColors;

    // ISharpEScheme Interface
    function GetColorByName(Name : String) : integer; stdcall;
    function GetColorByTag(Tag  : String) : integer; stdcall;
    function GetColorIndexByTag(Tag : String) : integer; stdcall;

    function GetColors : TSharpEColorSet; stdcall;
    procedure SetColors(value : TSharpEColorSet); stdcall;
    property Colors : TSharpEColorSet read GetColors write SetColors;

    property SelfInterface : ISharpEScheme read FInterface write FInterface;
  end;

implementation


constructor TSharpEScheme.Create(OwnsInterface : boolean = False);
begin
  inherited Create;
  
  ClearColors;
  AddColor('Throbberback','$Throbberback','Throbberback',$B68972,stColor);
  AddColor('Throbberdark','$Throbberdark','Throbberdark',$5B4439,stColor);
  AddColor('Throbberlight','$Throbberlight','Throbberlight',$C5958D,stColor);
  AddColor('ThrobberText','$ThrobberText','ThrobberText',$000000,stColor);
  AddColor('WorkAreaback','$WorkAreaback','WorkAreaback',$CACACA,stColor);
  AddColor('WorkAreadark','$WorkAreadark','WorkAreadark',$757575,stColor);
  AddColor('WorkArealight','$WorkArealight','WorkArealight',$F5F5F5,stColor);
  AddColor('WorkAreaText','$WorkAreaText','WorkAreaText',$000000,stColor);

  if OwnsInterface then
    FInterface := self;
end;

destructor TSharpEScheme.Destroy;
begin
  ClearColors;
  inherited Destroy;
end;

procedure TSharpEScheme.Assign(Source: TSharpEScheme);
var
  ss: TSharpEScheme;
  n : integer;
begin
  if Source is TSharpEScheme then ss := Source as TSharpEScheme
     else exit;

  ClearColors;
  setlength(FColors,length(ss.Colors));
  for n := 0 to High(ss.Colors) do
      FColors[n] := ss.Colors[n];
end;

procedure TSharpEScheme.Assign(Source: ISharpEScheme);
var
  n : integer;
begin
  ClearColors;
  setlength(FColors,length(Source.Colors));
  for n := 0 to High(Source.Colors) do
      FColors[n] := Source.Colors[n];
end;

procedure TSharpEScheme.AddColor(Color : TSharpESkinColor);
begin
  setlength(FColors,length(FColors)+1);
  FColors[High(FColors)].Name := Color.Name;
  FColors[High(FColors)].Tag := Color.Tag;
  FColors[High(FColors)].Info := Color.Info;
  FColors[High(FColors)].Color := Color.Color;
  FColors[High(FColors)].SchemeType := Color.SchemeType;
end;

procedure TSharpEScheme.AddColor(Name,Tag,Info : String; Color : integer; sType : TSharpESchemeType);
var
  n : integer;
begin
  setlength(FColors,length(FColors)+1);
  n := High(FColors);
  FColors[n].Name := Name;
  FColors[n].Tag  := Tag;
  FColors[n].Info := Info;
  FColors[n].Color := Color;
  FColors[n].SchemeType := sType;
end;

function TSharpEScheme.GetColorByName(Name : String) : integer;
var
  n : integer;
begin
  result := 0;
  for n := 0 to High(FColors) do
      if CompareText(FColors[n].Name,Name) = 0 then
      begin
        result := FColors[n].Color;
        exit;
      end;
end;

function TSharpEScheme.GetColorByTag(Tag  : String) : integer;
var
  n : integer;
begin
  result := 0;
  for n := 0 to High(FColors) do
      if CompareText(FColors[n].Tag,Tag) = 0 then
      begin
        result := FColors[n].Color;
        exit;
      end;
end;

function TSharpEScheme.GetColorIndexByTag(Tag : String) : integer;
var
  n : integer;
begin
  result := -1;
  for n := 0 to High(FColors) do
      if CompareText(FColors[n].Tag,Tag) = 0 then
      begin
        result := n;
        exit;
      end;
end;

function TSharpEScheme.GetColors: TSharpEColorSet;
begin
  result := FColors;
end;

procedure TSharpEScheme.SetColors(value: TSharpEColorSet);
begin
  FColors := Value;
end;

procedure TSharpEScheme.ClearColors;
begin
  setlength(FColors,0);
end;

end.
