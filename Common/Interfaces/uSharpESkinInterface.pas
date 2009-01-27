{
Source Name: uSharpESkinInterface
Description: Implementar Class for the ISharpESkin interface
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

unit uSharpESkinInterface;

interface

uses
  uISharpESkin,
  SharpESkin,
  SharpTypes,
  Classes,
  SharpESkinManager;

type
  TSharpESkinInterface = class(TInterfacedObject, ISharpESkin)
    private
      FSkinManager : TSharpESkinManager;
    public
      constructor Create(AOwner: TComponent; Skins : TSharpESkinItems = ALL_SHARPE_SKINS); reintroduce;
      destructor Destroy; override;

      function GetSkinManager : TSharpESkinManager;
      property SkinManager : TSharpESkinManager read GetSkinManager;
  end;

implementation

{ TSharpESkinInterface }

constructor TSharpESkinInterface.Create(AOwner: TComponent; Skins : TSharpESkinItems = ALL_SHARPE_SKINS);
begin
  FSkinManager := TSharpESkinManager.Create(AOwner, Skins);
  FSkinManager.HandleUpdates := False;
  FSkinManager.SkinSource := ssSystem;
  FSkinManager.SchemeSource := ssSystem;
  FSkinManager.Skin.UpdateDynamicProperties(FSkinManager.Scheme);
end;

destructor TSharpESkinInterface.Destroy;
begin
  FSkinManager.Free;
  
  inherited;
end;

function TSharpESkinInterface.GetSkinManager: TSharpESkinManager;
begin
  result := FSkinManager;
end;

end.
