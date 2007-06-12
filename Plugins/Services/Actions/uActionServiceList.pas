{
Source Name: ActionList
Description: An Object list to hold the Actions
Copyright (C) Pixol (Lee Green)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

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

unit uActionServiceList;

interface
uses
  // Standard
  Classes,
  ContNrs,
  SysUtils,
  dialogs,
  Forms,

  // JCL
  jclIniFiles,

  // JVCL
  JvSimpleXml;

type
  // "Private" Object, TActionStore needs it...
  TInfo = class(TObject)
  private
    FWindowHandle: Integer;
    FLParamID: Integer;
    FID: Integer;
    FActionName: string;
    FGroupName: string;
  public
    property ID: Integer read FID write FID;
    property ActionName: string read FActionName write FActionName;
    property GroupName: string read FGroupName write FGroupName;
    property WindowHandle: Integer read FWindowHandle write FWindowHandle;
    property LParamID: Integer read FLParamID write FLParamID;
  end;

  TActionStore = class(TObject)
  private
    FItems: TObjectList;
    FOnAddItem: TNotifyEvent;

    function GetCount: integer;
    function GetInfo(Index: integer): TInfo;

  public
    constructor Create;
    destructor Destroy; override;

    function Add(ActionName, GroupName: string; WindowHandle, LParamID: Integer): TInfo;
    procedure Delete(Index: integer);
    procedure DeleteAll;

    property Count: integer read GetCount;
    property Info[Index: integer]: TInfo read GetInfo;

    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
  end;

implementation

{ TActionStore }

function TActionStore.Add(ActionName, GroupName: string; WindowHandle, LParamID: Integer): TInfo;
begin
  Result := TInfo.Create;
  Result.ID := Self.Count;
  Result.ActionName := ActionName;
  Result.GroupName := GroupName;
  Result.WindowHandle := WindowHandle;
  Result.LParamID := LParamID;
  FItems.Add(Result);

  if Assigned(FOnAddItem) then
    FOnAddItem(Result);
end;

constructor TActionStore.Create;
begin
  inherited Create;
  FItems := TObjectList.Create;
end;

procedure TActionStore.Delete(Index: integer);
begin
  FItems.Delete(Index);
end;

procedure TActionStore.DeleteAll;
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
    Delete(i);
end;

destructor TActionStore.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TActionStore.GetCount: integer;
begin
  Result := FItems.Count;
end;

function TActionStore.GetInfo(Index: integer): TInfo;
begin
  Result := (FItems[Index] as TInfo);
end;

{ TInfo }

end.

