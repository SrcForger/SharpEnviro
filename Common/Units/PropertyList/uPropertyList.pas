{
Source Name: uPropertyList.pas
Description: TPropertyList class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.sharpe-shell.net

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

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

unit uPropertyList;

interface

uses
  SysUtils,
  Classes,
  Contnrs;

type
  TPropertyData = class
                  public
                    Name : String;
                    constructor Create(pName : String); reintroduce;
                  end;
                  
  TIntData = class(TPropertyData)
             public
               Value : integer;
               constructor Create(pName : String; pValue : integer); reintroduce;
             end;

  TStringData = class(TPropertyData)
                public
                  Value : String;
                  constructor Create(pName : String; pValue : String); reintroduce;
                end;

  TBoolData = class(TPropertyData)
              public
                Value : Boolean;
                constructor Create(pName : String; pValue : boolean); reintroduce;
              end;

  TPropertyList = class
  private
    FList : TObjectList;
    function FindByName(pName : String) : TObject;
  public
    procedure Add(pName : String; pValue : String); overload;
    procedure Add(pName : String; pValue : integer); overload;
    procedure Add(pName : String; pValue : boolean); overload;
    function GetString(pName : String) : String;
    function GetInt(pName : String) : integer;
    function GetBool(pName : String) : boolean;
    function Remove(pName : String) : boolean;

    constructor Create; reintroduce;
    destructor Destroy; override;
  published
  end;

implementation

constructor TPropertyData.Create(pName : String);
begin
  inherited Create;
  Name := pName;
end;

constructor TIntData.Create(pName : String; pValue : integer);
begin
  inherited Create(pName);
  Value := pValue;
end;

constructor TStringData.Create(pName : String; pValue : String);
begin
  inherited Create(pName);
  Value := pValue;
end;

constructor TBoolData.Create(pName : String; pValue : boolean);
begin
  inherited Create(pName);
  Value := pValue;
end;

constructor TPropertyList.Create;
begin
  inherited Create;

  FList := TObjectList.Create(True);
  FList.Clear;
end;

destructor TPropertyList.Destroy;
begin
  FList.Clear;
  FreeAndNil(FList)
end;

procedure TPropertyList.Add(pName : String; pValue : String);
begin
  Remove(pName);
  FList.Add(TStringData.Create(pName,pValue));
end;

procedure TPropertyList.Add(pName : String; pValue : Integer);
begin
  Remove(pName);
  FList.Add(TIntData.Create(pName,pValue));
end;

procedure TPropertyList.Add(pName : String; pValue : boolean);
begin
  Remove(pName);
  FList.Add(TBoolData.Create(pName,pValue));
end;

function TPropertyList.GetString(pName : String) : String;
var
  item : TObject;
begin
  item := FindByName(pName);
  result := '';
  if item <> nil then
     if item is TStringData then
        result := TStringData(item).Value;
end;

function TPropertyList.GetInt(pName : String) : integer;
var
  item : TObject;
begin
  item := FindByName(pName);
  result := 0;
  if item <> nil then
     if item is TIntData then
        result := TIntData(item).Value;
end;

function TPropertyList.GetBool(pName : String) : boolean;
var
  item : TObject;
begin
  item := FindByName(pName);
  result := False;
  if item <> nil then
     if item is TBoolData then
        result := TBoolData(item).Value;
end;

function TPropertyList.FindByName(pName : String) : TObject;
var
  n : integer;
begin
  for n := 0 to FList.Count - 1 do
      if CompareText(TPropertyData(FList.Items[n]).Name,pName) = 0 then
      begin
        result := FList.Items[n];
        exit;
      end;
  result := nil;
end;

function TPropertyList.Remove(pName : String) : boolean;
var
  item : TObject;
begin
  item := FindByName(pName);
  if item <> nil then
  begin
    FList.Remove(item);
    result := True;
    exit;
  end;
  result := False;
end;

end.
