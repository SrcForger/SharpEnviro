{
Source Name: uSharpDeskObjectFile
Description: TObjectFile class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
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

unit uSharpDeskObjectFile;

interface

uses Windows,
     Contnrs,
     SysUtils,
     Graphics,
     gr32,
     gr32_layers,
     gr32_image,
     SharpApi,
     SharpDeskApi,
     uSharpDeskTDeskSettings,
     uSharpDeskTThemeSettings,
     uSharpDeskTObjectSettings,
     uSharpDeskObjectSetItem;

type

    TObjectFile = class(TObjectList)
    private
      FFileName        : String;
      FPath            : String;
      FDllHandle       : THandle;
      FLoaded          : boolean;
      FOwner           : TObject;
    public
      DllCloseSettingsWnd : function (ObjectID : integer; SaveSettings : boolean) : boolean;
      DllCreateLayer      : function (Image: TImage32; ObjectID : integer) : TBitmapLayer;
      DllStartSettingsWnd : function (ObjectID : integer; owner : Hwnd): hwnd;
      DllSharpDeskMessage : procedure(ObjectID : integer; Layer : TBitmapLayer; DeskMessage,P1,P2,P3 : integer);
      DllGetSettings      : procedure(pDeskSettings   : TDeskSettings;
                                      pThemeSettings  : TThemeSettings;
                                      pObjectSettings : TObjectSettings);
      procedure Unload;
      procedure UnloadObjects;
      procedure Load;
      function AddDesktopObject(pSettings : TObjectSetItem) : TObject;
      function GetByObjectID(ID : integer) : TObject;
      constructor Create(pOwner : TObject; pFileName : String);
      destructor Destroy; override;
    published
      property DllHandle       : THandle read FDLLHandle;
      property FileName        : String  read FFileName;
      property Path            : String  read FPath;
      property Loaded          : boolean read FLoaded;
      property Owner           : TObject read FOwner;
    end;



implementation


uses uSharpDeskDesktopObject,
     uSharpDeskManager,
     uSharpDeskObjectFileList;


constructor TObjectFile.Create(pOwner : TObject; pFileName : String);
begin
  Inherited Create;
  FOwner           := pOwner;
  FPath            := pFileName;
  FFileName        := ExtractFileName(pFileName);
  FLoaded          := False;
  Load;
end;



destructor TObjectFile.Destroy;
begin
  Unload;
  Inherited Destroy;
end;


function TObjectFile.GetByObjectID(ID : integer) : TObject;
var
   n : integer;
begin
  for n := 0 to Count - 1 do
      if TDesktopObject(Items[n]).Settings.ObjectID = ID then
      begin
        result := TDesktopObject(Items[n]);
        exit;
      end;
  result := nil;
end;


function TObjectFile.AddDesktopObject(pSettings : TObjectSetItem) : TObject;
var
   tempObject : TDesktopObject;
begin
  tempObject := TDesktopObject.Create(self,pSettings);
  self.Add(tempObject);
  DllSharpDeskMessage(tempObject.Settings.ObjectID,tempObject.Layer,SDM_INIT_DONE,0,0,0);
  result := tempObject;
end;

procedure TObjectFile.Unload;
begin
  if not FLoaded then exit;

  UnloadObjects;

  try
    FreeLibrary(FDllHandle);
  finally
    FLoaded    := False;
    FDllHandle := 0;
    DllCreateLayer      := nil;
    DllStartSettingsWnd := nil;
    DllCloseSettingsWnd := nil;
    DllSharpDeskMessage := nil;
    DllGetSettings      := nil;
  end;
end;



procedure TObjectFile.Load;
begin
  Unload;
  if not FileExists(FPath) then exit;

  try
    FDllhandle := LoadLibrary(PChar(FPath));

    if FDllhandle <> 0 then
    begin
      @DllCloseSettingsWnd := GetProcAddress(dllhandle, 'CloseSettingsWnd');
      @DllCreateLayer      := GetProcAddress(dllhandle, 'CreateLayer');
      @DllSharpDeskMessage := GetProcAddress(dllhandle, 'SharpDeskMessage');
      @DllStartSettingsWnd := GetProcAddress(dllhandle, 'StartSettingsWnd');
      @DllGetSettings      := GetProcAddress(dllhandle, 'GetSettings');
    end;

    if (@DllCreateLayer = nil) or
       (@DllStartSettingsWnd = nil) or
       (@DllCloseSettingsWnd = nil) or
       (@DllSharpDeskMessage = nil) then
    begin
      FreeLibrary(FDllhandle);
      FDllhandle := 0;
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(FPath + ' is not a valid SharpDesk object'),clmaroon,DMT_ERROR);
      exit;
    end;

    FLoaded := True;
    if (@DLLGetSettings <> nil) then
       DLLGetSettings(TSharpDeskManager(TObjectFileList(FOwner).Owner).DeskSettings,
                      TSharpDeskManager(TObjectFileList(FOwner).Owner).ThemeSettings,
                      TSharpDeskManager(TObjectFileList(FOwner).Owner).ObjectSettings);
    SharpApi.SendDebugMessageEx('SharpDesk',PChar('Initializing ' + FPath),clblack,DMT_STATUS);
  except
    try
      FreeLibrary(FDllhandle);
    finally
      FDllhandle := 0;
    end;
    SharpApi.SendDebugMessageEx('SharpDesk',PChar('Filaed to initialize ' + FPath),clmaroon,DMT_ERROR);
  end;
end;



procedure TObjectFile.UnloadObjects;
begin
  Clear;
 { for n:= 0 to Count - 1 do
      if Items[n] <> nil then
      begin
        Items[n].Free;
        Items[n] := nil;
      end;
  Pack;    }
end;


end.
