{
Source Name: uSharpCenterHistory
Description: History Management
Copyright (C) Pixol - pixol@sharpe-shell.org

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
unit uSharpCenterHistoryList;

interface

uses
  Windows,
  Messages,
  SysUtils,
  SharpApi,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ExtCtrls,
  Menus,
  jclFileUtils,
  JclStrings,
  uSharpCenterDllMethods,
  SharpEListBoxEx,
  PngImageList,
  PngImage,
  StdCtrls,

  SharpCenterApi,
  Contnrs;

type
  TSharpCenterHistoryItem = class(TPersistent)
  private
    FCommand: TSCC_COMMAND_ENUM;
    FParam: string;
    FPluginID: String;
    FID: Integer;
  public
    property ID: Integer read FID write FID;
    property Command: TSCC_COMMAND_ENUM read FCommand write FCommand;
    property Param: string read FParam write FParam;
    property PluginID: String read FPluginID write FPluginID;
  end;

type
  TSharpCenterHistoryList = class(TObjectList)
  private
    function GetItem(Index: Integer): TSharpCenterHistoryItem;
    procedure SetItem(Index: Integer; const Value: TSharpCenterHistoryItem);
  public
    procedure DeleteItem(AItem: TSharpCenterHistoryItem);

    function AddFolder(APath: string): TSharpCenterHistoryItem;
    function AddDll(ADll, APluginId: String): TSharpCenterHistoryItem;
    function AddCon(AConFile, APluginId: string): TSharpCenterHistoryItem;
    function AddItem(ACommand: TSCC_COMMAND_ENUM; AParameter, APluginID: string): TSharpCenterHistoryItem;
    function GetLastEntry: TSharpCenterHistoryItem;

    property Item[Index: Integer] : TSharpCenterHistoryItem
             read GetItem write SetItem; Default;
  end;

implementation

{ TSharpCenterHistory }

function TSharpCenterHistoryList.AddFolder(APath: string): TSharpCenterHistoryItem;
begin
  Result := nil;
  if APath = '' then
    exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := sccChangeFolder;
  Result.Param := APath;
  Result.PluginID := '';
  Result.ID := Count;

  Add(Result);
end;

function TSharpCenterHistoryList.AddDll(
  ADll, APluginID: string): TSharpCenterHistoryItem;
begin
  Result := nil;
  if ADll = '' then
    exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := sccLoadDll;
  Result.Param := ADll;
  Result.PluginID := APluginID;
  Result.ID := Count;

  Add(Result);
end;

function TSharpCenterHistoryList.AddCon(
  AConFile, APluginId: string): TSharpCenterHistoryItem;
begin
  Result := nil;
  if AConFile = '' then
    exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := sccLoadSetting;
  Result.Param := AConFile;
  Result.PluginID := APluginId;
  Result.ID := Count;

  Add(Result);
end;

function TSharpCenterHistoryList.GetLastEntry: TSharpCenterHistoryItem;
begin
  Result := nil;
  if Last <> nil then
    Result := TSharpCenterHistoryItem(Last);
end;

procedure TSharpCenterHistoryList.SetItem(Index: Integer;
  const Value: TSharpCenterHistoryItem);
begin

end;

function TSharpCenterHistoryList.AddItem(ACommand: TSCC_COMMAND_ENUM; AParameter, APluginID: string): TSharpCenterHistoryItem;
begin
  Result := TSharpCenterHistoryItem.Create;
  Result.Command := ACommand;
  Result.Param := AParameter;
  Result.PluginID := APluginID;
  Result.ID := Count;

  Add(Result);
end;

procedure TSharpCenterHistoryList.DeleteItem(AItem: TSharpCenterHistoryItem);
var
  n: Integer;
begin
  n := IndexOf(AItem);
  if n <> -1 then
  begin
    Delete(n);
  end;
end;

function TSharpCenterHistoryList.GetItem(
  Index: Integer): TSharpCenterHistoryItem;
begin
  Result := nil;

  if Index < Count then
    Result := TSharpCenterHistoryItem(Items[Index]);
end;

end.
