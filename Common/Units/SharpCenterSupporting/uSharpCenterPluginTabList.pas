{
Source Name: uSharpCenterPluginTabList
Description: A List type for the plugin PluginTabs
Copyright (C) lee@sharpe-shell.org

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
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

unit uSharpCenterPluginTabList;

interface
uses
  Windows,
  dialogs,
  shellapi,
  graphics,
  PngSpeedButton,
  Classes,
  sharpapi,
  Tabs,
  PngImageList,
  PngImage,
  SysUtils,
  JvSimpleXml;

type
  TPluginTabItem = class(TObject)
  private
    FIconID: Integer;
    FID: Integer;
    FIcon: string;
    FCaption: string;
    FStatus: String;
    FData: TObject;
  public
    constructor Create;
    property Caption: string read FCaption write FCaption;
    property Data: TObject read FData write FData;
    property ID: Integer read FID write FID;
    property Icon: string read FIcon write FIcon;
    property IconID: Integer read FIconID write FIconID;
    property Status: String read FStatus Write FStatus;
  end;

type
  TPluginTabItemList = class
  private
    FList: TList;
    FIconList: TPngImageCollection;
    //function AssignIconIndex(AFilename: string; var APluginTabObject:
     // TPluginTabItem): Integer;
    function GetPluginTabItem(AID: Integer): TPluginTabItem;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(ACaption: string; AData: TObject; AIcon: string; AStatus:String): TPluginTabItem;

    procedure Clear;
    function Count:Integer;

    property GetItem[AID:Integer] : TPluginTabItem read GetPluginTabItem; default;
    property IconList: TPngImageCollection read FIconList write FIconList;
  end;



implementation

{ TPluginTabItemList }

function TPluginTabItemList.Add(ACaption: string; AData: TObject; AIcon: string; AStatus:String): TPluginTabItem;
begin
  Result := TPluginTabItem.Create;
  Result.Caption := ACaption;
  Result.Status := AStatus;
  Result.Data := AData;
  Result.ID := FList.Count;
  Result.Icon := AIcon;
  FList.Add(Result);

end;

{function TPluginTabItemList.AssignIconIndex(AFilename: string;
  var APluginTabObject: TPluginTabItem): Integer;
var
  tmpPngImage: TPNGObject;
  tmpPiC: TPngImageCollectionItem;
  idx: Integer;
begin
  Result := '';
  if FileExists(AFileName) then begin
    tmpPngImage := TPNGObject.Create;
    tmpPngImage.LoadFromFile(AFileName);
    tmpPngImage.CreateAlpha;

    tmpPiC := FIconList.Items.Add();
    tmpPiC.PngImage.Assign(tmpPngImage);
    tmpPiC.Background := clWindow;
    idx := tmpPic.Index;

    Result := idx;
  end;
end;     }

procedure TPluginTabItemList.Clear;
begin
  FList.Clear;
end;

function TPluginTabItemList.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TPluginTabItemList.Create;
begin
  FList := TList.Create;
end;

destructor TPluginTabItemList.Destroy;
begin
  FList.Free;

  inherited;
end;

function TPluginTabItemList.GetPluginTabItem(AID: Integer): TPluginTabItem;
begin
  if AID > FList.Count then Result := nil else
    Result := TPluginTabItem(FList[AID]);
end;

{ TPluginTabItem }

constructor TPluginTabItem.Create;
begin
  FIconID := -1;
end;

end.


