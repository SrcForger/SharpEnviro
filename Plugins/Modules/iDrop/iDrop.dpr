{
Source Name: iDrop.drp
Description: iDrop Module Main Project File
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

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

library iDrop;



uses
  Windows,
  Controls,
  Dialogs,
  SysUtils,
  Forms,
  Classes,
  Contnrs,
  SharpESkinManager,
  SharpEBar,
  StdCtrls,
  JvSimpleXML,
  uSharpBarApi,
  MainWnd in 'MainWnd.pas' {MainForm},
  SettingsWnd in 'SettingsWnd.pas' {SettingsForm};

type
  TModule = class
            private
              FForm : TForm;
              FID   : integer;
              FPos  : integer;
              FBarWnd  : hWnd;
            public
              constructor Create(pID : integer; pParent : hwnd); reintroduce;
              destructor Destroy; override;
            published
              property ID   : integer read FID;
              property Pos  : integer read FPos write FPos;
              property Form : TForm   read FForm;
              property BarWnd : hWnd  read FBarWnd;
            end;

var
  ModuleList : TObjectList;

{$R *.res}

function GetControlByHandle(AHandle: THandle): TWinControl;
begin
 Result := Pointer(GetProp( AHandle,
                            PChar( Format( 'Delphi%8.8x',
                                           [GetCurrentProcessID]))));
end;

constructor TModule.Create(pID : integer; pParent : hwnd);
begin
  inherited Create;
  FID   := pID;
  FBarWnd := pParent;
  FForm := TMainForm.CreateParented(pParent);
  FForm.BorderStyle := bsNone;
  try
    FForm.Height := GetBarPluginHeight(FBarWnd);
  except
  end;
  FForm.ParentWindow := pParent;
  with FForm as TMainForm do
  begin
    ModuleID := pID;
    BarWnd   := FBarWnd;
    LoadSettings;
    ReAlignComponents(False);
    Show;
  end;

end;

destructor TModule.Destroy;
begin
  FForm.Free;
  FForm := nil;
  inherited Destroy;
end;

function CreateModule(ID : integer;
                      parent : hwnd) : hwnd;
var
  temp : TModule;
begin
  try
    if ModuleList = nil then
       ModuleList := TObjectList.Create;

    temp := TModule.Create(ID,parent);
    ModuleList.Add(temp);
  except
    result := 0;
    exit;
  end;
  result := temp.Form.Handle;
end;

function CloseModule(ID : integer) : boolean;
var
  n : integer;
begin
  result := False;
  if ModuleList = nil then exit;

  try
    for n := 0 to ModuleList.Count - 1 do
        if TModule(ModuleList.Items[n]).ID = ID then
        begin
          ModuleList.Delete(n);
          result := True;
          exit;
        end;
  except
    result := False;
  end;
end;

procedure Refresh(ID : integer);
begin
end;

procedure PosChanged(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0  to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.Form).Background.Bitmap.SetSize(temp.Form.Width,temp.Form.Height);
        uSharpBarAPI.PaintBarBackGround(temp.BarWnd,TMainForm(temp.Form).Background.Bitmap,Temp.Form);
        if TMainForm(temp.Form).BGBmp <> nil then
           TMainForm(temp.Form).BGBmp.Assign(TMainForm(temp.Form).Background.Bitmap);
        TMainForm(temp.Form).ReAlignComponents(False);
      end;
end;

procedure SkinChanged(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0  to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        temp.Form.Height := GetBarPluginHeight(temp.BarWnd);
        TMainForm(temp.Form).UpdateCustomSettings;
        TMainForm(temp.Form).ReAlignComponents(True);
      end;
end;

procedure ShowSettingsWnd(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.FForm).Settings1Click(TMainForm(temp.FForm).Settings1);
      end;
end;

procedure SetSize(ID : integer; NewWidth : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.FForm).SetSize(NewWidth);
      end;
end;

Exports
  CreateModule,
  CloseModule,
  Poschanged,
  Refresh,
  SkinChanged,
  ShowSettingsWnd,
  SetSize;


end.
