{
Source Name: uSharpEMenuIcon.pas
Description: SharpE Menu Icon Class
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

unit uSharpEMenuIcon;

interface

uses SysUtils,Classes,GR32,GR32_Resamplers;

type
  TIconType = (itShellIcon,itCustomIcon);

  TSharpEMenuIcon = class
  private
    FIcon : TBitmap32;
    FIconHandle : THandle; // Only used for shell icons!
    FIconSource : String;
    FIconType : TIconType;
    FCount : integer;
    FCached : Boolean;
  public
    property Icon : TBitmap32 read FIcon;
    property IconSource : String read FIconSource;
    property IconType : TIconType read FIconType write FIconType;
    property IconShellHandle : THandle read FIconHandle;
    property Count : integer read FCount write FCount;
    property Cached : boolean read FCached write FCached;
    constructor Create(pIconSource,pIconData : String); reintroduce; overload;
    constructor Create(pIconSource : String; pBmp : TBitmap32); overload;
    constructor Create(pIconSource : String; pIconType : TIconType; Stream : TStream); overload;
    destructor Destroy; override;
  end;

implementation

uses SharpIconUtils;

constructor TSharpEMenuIcon.Create(pIconSource : String; pIconType : TIconType; Stream : TStream);
begin
  inherited Create;
  FCached := False;

  FIcon := TBitmap32.Create;
  FIconHandle := 0;
  FIconType := pIconType;
  FIconSource := pIconSource;
  TLinearResampler.Create(FIcon);
  FIcon.LoadFromStream(Stream);
end;

constructor TSharpEMenuIcon.Create(pIconSource : String; pBmp : TBitmap32);
begin
  inherited Create;
  FCached := False;
  
  FIcon := TBitmap32.Create;
  FIcon.SetSize(16,16);
  FIcon.Clear(Color32(0,0,0,0));
  FIconHandle := 0;
  FIconType := itCustomIcon;
  FIconSource := pIconSource;
  FCount := 1;

  if pBmp <> nil then
  begin
    FIcon.Assign(pBmp);
    FIcon.DrawMode := dmBlend;
    FIcon.CombineMode := cmMerge;
    TLinearResampler.Create(FIcon);
  end;
end;

constructor TSharpEMenuIcon.Create(pIconSource,pIconData : String);
begin
  inherited Create;
  FCached := False;

  FIcon := TBitmap32.Create;
  FIcon.DrawMode := dmBlend;
  FIcon.CombineMode := cmMerge;
  FIconHandle := 0;
  TLinearResampler.Create(FIcon);
  FCount := 1;

  if CompareText(pIconSource,'shell:icon') = 0 then
  begin
    FIconSource := pIconData;
    FIconType := itShellIcon;
  end else
  begin
    FIconSource := pIconSource;
    FIconType := itCustomIcon;
  end;
  SharpIconUtils.IconStringToIcon(pIconSource,pIconData,FIcon,32);
end;

destructor TSharpEMenuIcon.Destroy;
begin
  FreeAndNil(FIcon);
end;

end.
