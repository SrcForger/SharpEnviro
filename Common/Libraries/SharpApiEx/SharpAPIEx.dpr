{
Source Name: SharpApiEx.dpr
Description: API commands for SharpE
Copyright (C) Lee Green (Pixol) <pixol@sharpe-shell.org>
              Martin Krämer <MartinKraemer@gmx.net>

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

library SharpAPIEx;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

uses
  windows,
  messages,
  SysUtils,
  classes,
  SharpApi,
  uExecServiceRecentItemList in '..\..\..\Plugins\Services\Exec\uExecServiceRecentItemList.pas',
  uExecServiceUsedItemList in '..\..\..\Plugins\Services\Exec\uExecServiceUsedItemList.pas',
  SimpleForms in '..\..\Units\SimpleUnits\SimpleForms.pas';

{$R *.RES}

{ HELPER FUNCTIONS }

function GetDelimitedActionList: WideString;
var
  fn: string;
  strl: tstringlist;
begin
  try
    strl := TStringList.Create;
    fn := ExtractFilePath(Application_GetExeName) + 'tmp';
    ServiceMsg('actions', pchar('_buildactionlist,' + fn));

    if FileExists(fn) then
    begin
      strl.LoadFromFile(fn);
      Result := strl.CommaText;
      FreeAndNil(strl);

      DeleteFile(fn)
    end;

  finally
    if Assigned(strl) then
      FreeAndNil(strl);
  end;

end;

function GetRecentItems(ReturnCount: integer): widestring;
var
  i: integer;
  strl: TStringList;
const
  xmlfile = 'SharpCore\Services\Exec\RiList.xml';
begin

  // Check if greater than recent items capacity
  if ReturnCount > 50 then
  begin
    //ShowMessage('Must not exceed recent item count of 50');
    // why display this error message? useless for any normal user...  BB
    exit;
  end;

  TmpRI := TRecentItemsList.Create(GetSharpeUserSettingsPath + xmlfile);
  strl := TStringList.Create;

  if ReturnCount >= TmpRI.Items.Count - 1 then
    ReturnCount := TmpRI.Items.Count;

  with TmpRI do
  begin
    for i := Items.Count - 1 downto (Items.Count - ReturnCount) do
    begin
      strl.Add(TmpRI[i].Value);
    end;

    Result := strl.CommaText;
  end;

  TmpRI.Free;
  Strl.Free;

end;

function GetMostUsedItems(ReturnCount: integer): widestring;
var
  i: integer;
  strl: tstringlist;
const
  xmlfile = 'SharpCore\Services\Exec\UiList.xml';
begin

  TmpMui := TUsedItemsList.Create(GetSharpeUserSettingsPath + xmlfile);
  strl := TStringList.Create;
  TmpMui.Sort;

  if ReturnCount >= TmpMui.Items.Count then
    ReturnCount := TmpMui.Items.Count;

  with TmpMui do
  begin
    for i := 0 to ReturnCount - 1 do
      strl.Add(TmpMui[i].Value);

    Result := strl.CommaText;
  end;

  TmpMui.Free;
  Strl.Free;
end;

exports
  GetDelimitedActionList,
  GetRecentItems,
  GetMostUsedItems;
begin

end.

