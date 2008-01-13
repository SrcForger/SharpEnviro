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
unit uSharpCenterHistoryManager;

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
  TSharpCenterHistoryItem = class
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
  TSharpCenterHistoryManager = class
  private
    FList: TList;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Delete(AItem: TSharpCenterHistoryItem);

    function AddFolder(APath: string): TSharpCenterHistoryItem;
    function AddDll(ADll, APluginID: String): TSharpCenterHistoryItem;
    function AddSetting(ASetting: string): TSharpCenterHistoryItem;
    function Add(ACommand: TSCC_COMMAND_ENUM; AParameter, APluginID: string): TSharpCenterHistoryItem;
    function GetLastEntry: TSharpCenterHistoryItem;
    property List: TList read FList write FList;

    property Count: Integer read GetCount;
  end;

implementation

{ TSharpCenterHistory }

constructor TSharpCenterHistoryManager.Create;
begin
  FList := TList.Create;
end;

procedure TSharpCenterHistoryManager.Clear;
begin
  FList.Clear;
end;

destructor TSharpCenterHistoryManager.Destroy;
var
  i: Integer;
begin
  for i := 0 to Pred(FList.Count) do
    TSharpCenterHistoryItem(FList[i]).Free;

  FList.Free;
  inherited;
end;

function TSharpCenterHistoryManager.AddFolder(APath: string): TSharpCenterHistoryItem;
begin
  Result := nil;
  if APath = '' then
    exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := sccChangeFolder;
  Result.Param := APath;
  Result.PluginID := '';
  Result.ID := FList.Count;

  FList.Add(Result);
end;

function TSharpCenterHistoryManager.AddDll(
  ADll, APluginID: string): TSharpCenterHistoryItem;
begin
  Result := nil;
  if ADll = '' then
    exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := sccLoadDll;
  Result.Param := ADll;
  Result.PluginID := APluginID;
  Result.ID := FList.Count;

  FList.Add(Result);
end;

function TSharpCenterHistoryManager.AddSetting(
  ASetting: string): TSharpCenterHistoryItem;
begin
  Result := nil;
  if ASetting = '' then
    exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := sccLoadSetting;
  Result.Param := ASetting;
  Result.PluginID := '';
  Result.ID := FList.Count;

  FList.Add(Result);
end;

function TSharpCenterHistoryManager.GetLastEntry: TSharpCenterHistoryItem;
begin
  Result := nil;
  if FList.Last <> nil then
    Result := TSharpCenterHistoryItem(FList.Last);
end;

function TSharpCenterHistoryManager.Add(ACommand: TSCC_COMMAND_ENUM; AParameter, APluginID: string): TSharpCenterHistoryItem;
var
  i:Integer;
begin
  Result := nil;

  for i := 0 to Pred(FList.Count) do begin
    if ((TSharpCenterHistoryItem(FList[i]).Param = AParameter) and
      ((TSharpCenterHistoryItem(FList[i]).Command = ACommand))) then
        exit;
  end;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := ACommand;
  Result.Param := AParameter;
  Result.PluginID := APluginID;
  Result.ID := FList.Count;

  FList.Add(Result);
end;

procedure TSharpCenterHistoryManager.Delete(AItem: TSharpCenterHistoryItem);
var
  n: Integer;
begin
  n := FList.IndexOf(AItem);
  if n <> -1 then
  begin
    FList.Delete(n);
  end;
end;

function TSharpCenterHistoryManager.GetCount: Integer;
begin
  Result := FList.Count;
end;

end.
