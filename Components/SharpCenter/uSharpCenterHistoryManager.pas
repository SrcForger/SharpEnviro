{
Source Name: uSharpCenterHistory
Description: History Management
Copyright (C) Pixol - pixol@sharpe-shell.org

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
  
  Contnrs;

type
  TSharpCenterHistoryItem = class
  private
    FCommand: string;
    FParam: string;
    FPluginID: String;
    FID: Integer;
  public
    property ID: Integer read FID write FID;
    property Command: string read FCommand write FCommand;
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
    function Add(ACommand, AParameter, APluginID: String): TSharpCenterHistoryItem;
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
  Result.Command := SCC_CHANGE_FOLDER;
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
  Result.Command := '_loaddll';
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
  Result.Command := SCC_LOAD_SETTING;
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

function TSharpCenterHistoryManager.Add(ACommand, AParameter, APluginID: string): TSharpCenterHistoryItem;
begin
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
