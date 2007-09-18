{
Source Name: uControlPanelItems.dpr
Description: Control Panel Enumeration Unit
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

unit uControlPanelItems;

interface

uses
  SysUtils,
  Classes,
  Windows,
  Registry;

type
 TCPLItem = record
              Name : String;
              Description : String;
              FileName : String;
              Icon : String;
              GUIDItem : boolean;
            end;
 TCPLItems = array of TCPLItem;

 function GetCPLItems : TCPLItems;

implementation

function GetCPLItems : TCPLItems;
const
  CPL_KEY = '\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\ControlPanel\NameSpace';

var
  Reg : TRegistry;
  List : TStringList;
  n : integer;
  valid : boolean;
  lName,lDescription,lFileName,lIcon : String;
  lGUIDItem : boolean;
begin
  setlength(result,0);

  Reg := TRegistry.Create;
  List := TStringList.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(CPL_KEY,False);
    Reg.GetKeyNames(List);
    Reg.CloseKey;
    for n := 0 to List.count - 1 do
    begin
      valid := False;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.OpenKey(CPL_KEY + '\' + List[n],False);
      if Reg.ValueExists('Module') then
      begin
        lName := Reg.ReadString('Name');
        lDescription := Reg.ReadString('Info');
        lFileName := Reg.ReadString('Module');
        lIcon     := lFileName+',-' + inttostr(Reg.ReadInteger('IconIndex'));
        lGUIDItem := False;
        Valid := True;
        Reg.CloseKey;
      end else
      begin
        Reg.CloseKey;
        Reg.RootKey := HKEY_CLASSES_ROOT;
        lGUIDItem := False;
        if Reg.KeyExists('\CLSID\' + List[n]) then
        begin
          Reg.OpenKey('\CLSID\' + List[n],False);
          lName := Reg.ReadString('');
          lDescription := Reg.ReadString('System.ApplicationName');
          if Reg.KeyExists('\CLSID\' + List[n] + '\Shell\Open\Command') then
          begin
            Reg.CloseKey;
            Reg.OpenKey('\CLSID\' + List[n] + '\Shell\Open\Command',False);
            lFileName := Reg.ReadString('');
            Reg.CloseKey;
            lGUIDItem := True;
          end else
          begin
            lFileName := Reg.ReadString('System.ApplicationName');
            lGUIDItem := False;
            Reg.CloseKey;
          end;
          if Reg.KeyExists('\CLSID\' + List[n] + '\DefaultIcon') then
          begin
            Reg.OpenKey('\CLSID\' + List[n] + '\DefaultIcon',False);
            lIcon := Reg.ReadString('');
            Reg.CloseKey;
            lGUIDItem := True;
          end else lIcon := lFileName;
          Valid := True;
        end;
      end;
      if valid then
      begin
        setlength(result,length(result)+1);
        with result[high(result)] do
        begin
          FileName := lFilename;
          Description := lDescription;
          Name := lName;
          Icon := lIcon;
          GUIDItem := lGUIDItem;
        end;
      end;
    end;
  finally
    List.Free;
    Reg.Free;
  end;
end;

end.
