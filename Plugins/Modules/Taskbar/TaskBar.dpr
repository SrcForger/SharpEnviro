{
Source Name: TaskBar.dpr
Description: SharpBar Module Main Project File
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
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

library TaskBar;



uses
  Windows,
  Controls,
  Dialogs,
  SysUtils,
  Forms,
  Classes,
  Messages,
  Contnrs,
  SharpESkinManager,
  SharpEBar,
  StdCtrls,
  JvSimpleXML,
  MainWnd in 'MainWnd.pas' {MainForm},
  SettingsWnd in 'SettingsWnd.pas' {SettingsForm},
  uTaskItem in 'uTaskItem.pas',
  uTaskManager in 'uTaskManager.pas',
  sFilterWnd in 'sFilterWnd.pas' {sfilterform},
  EditFilterWmd in 'EditFilterWmd.pas' {EditFilterForm},
  MouseTimer in '..\..\..\Common\Units\MouseTimer\MouseTimer.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  shellhook in '..\..\..\Common\Libraries\ShellHook\shellhook.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas';

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
  MouseTimer : TMouseTimer;

{$R *.res}

procedure DebugOutputInfo(msg : String);
begin
end;


function GetControlByHandle(AHandle: THandle): TWinControl;
begin
 Result := Pointer(GetProp( AHandle,
                            PChar( Format( 'Delphi%8.8x',
                                           [GetCurrentProcessID]))));
end;

constructor TModule.Create(pID : integer; pParent : hwnd);
var
  i : integer;
begin
  inherited Create;
  FID   := pID;
  FBarWnd := pParent;
  try
    i := GetBarPluginHeight(FBarWnd);
  except
    i := 16;
  end;
  FForm := TMainForm.CreateParented(pParent,ID,FBarWnd,i);
  FForm.BorderStyle := bsNone;
  FForm.ParentWindow := pParent;
  FForm.Height := i;
  MouseTimer.AddWinControl(TMainForm(FForm));
  with FForm as TMainForm do
  begin
    ModuleID := pID;
    BarWnd   := FBarWnd;
    RealignComponents(False);
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

    if MouseTimer = nil then
       MouseTimer := TMouseTimer.Create;

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
  if ModuleList = nil then
  begin
    result := False;
    exit;
  end;

  try
    for n := 0 to ModuleList.Count - 1 do
        if TModule(ModuleList.Items[n]).ID = ID then
        begin
          MouseTimer.RemoveWinControl(TModule(ModuleList.Items[n]).Form);
          if MouseTimer.ControlList.Count = 0 then
             FreeAndNil(MouseTimer);
          ModuleList.Delete(n);
          result := True;
          exit;
        end;
  except
    result := False;
  end;
end;

procedure Refresh(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0  to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.Form).ReAlignComponents(False);
      end;
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
        TMainForm(temp.Form).Background.Bitmap.BeginUpdate;
        TMainForm(temp.Form).Background.Bitmap.SetSize(temp.Form.Width,temp.Form.Height);
        uSharpBarAPI.PaintBarBackGround(temp.BarWnd,TMainForm(temp.Form).Background.Bitmap,Temp.Form);
        TMainForm(temp.Form).Background.Bitmap.EndUpdate;
        TMainForm(temp.Form).Background.Repaint;
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
        TMainForm(temp.Form).Background.Bitmap.BeginUpdate;
        TMainForm(temp.Form).Background.Bitmap.SetSize(temp.Form.Width,temp.Form.Height);
        uSharpBarAPI.PaintBarBackGround(temp.BarWnd,TMainForm(temp.Form).Background.Bitmap,Temp.Form);
        TMainForm(temp.Form).Background.Bitmap.EndUpdate;
        TMainForm(temp.Form).Background.Repaint;
        TMainForm(temp.Form).UpdateCustomSettings;
        TMainForm(temp.Form).ReAlignComponents(False);
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

begin

end.
