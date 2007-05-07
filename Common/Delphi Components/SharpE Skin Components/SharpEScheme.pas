{
Source Name: SharpEScheme
Description: SharpE component for SharpE
Copyright (C) Malx (Malx@techie.com)
              Martin Krämer (MartinKraemer@gmx.net)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
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
  Forms,
  Dialogs,
  StdCtrls,
  gr32,
  SharpEBase,
  SharpThemeApi;

type
  TSchemeEvent = procedure of object;

  TSharpEScheme = class(TComponent)
  private
    FColors  : TSharpEColorSet;
    FOnNotify: TSchemeEvent;

    //procedure NotifyManager;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AddColor(Name,Tag,Info : String; Color : integer; sType : TSharpESchemeType); overload;
    procedure AddColor(Color : TSharpESkinColor); overload;
    function GetColorByName(Name : String) : integer;
    function GetColorByTag(Tag  : String) : integer;
    function GetColorIndexByTag(Tag : String) : integer;
    procedure ClearColors;
    property OnNotify: TSchemeEvent read FOnNotify write FOnNotify;
  published
    property Colors : TSharpEColorSet read FColors;
  end;

implementation
uses SharpESkinManager,
  SharpEDefault;

constructor TSharpEScheme.Create(AOwner: TComponent);
begin
  inherited;
  ClearColors;
  Assign(DefaultSharpEScheme);
end;

destructor TSharpEScheme.Destroy;
begin
  ClearColors;
  inherited Destroy;
end;

{procedure TSharpEScheme.NotifyManager;
begin
  if Assigned(OnNotify) then OnNotify;
end;    }

procedure TSharpEScheme.Notification(AComponent: TComponent; Operation:
  TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent is TSharpESkinManager) then
    begin
      if (AComponent as TSharpESkinManager).CompScheme = self then FOnNotify := nil;
    end;
  end
end;

procedure TSharpEScheme.Assign(Source: TPersistent);
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

procedure TSharpEScheme.ClearColors;
begin
  setlength(FColors,0);
end;

end.
