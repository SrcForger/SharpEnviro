{
Source Name: VWM.dpr
Description: VWM Module Main Project File
Copyright (C) Viper <tom_viper@msn.com>

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

library VWM;

uses
  Windows,
  Dialogs,
  Controls,
  SysUtils,
  Forms,
  Classes,
  Contnrs,
  SharpESkinManager,
  SharpEBar,
  StdCtrls,
  JvSimpleXML,
  MainWnd in 'MainWnd.pas' {MainForm},
  SettingsWnd in 'SettingsWnd.pas',
  MMSystem,
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  MouseTimer in '..\..\..\Common\Units\MouseTimer\MouseTimer.pas',
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  sharpprocess in '..\..\..\Common\Units\SharpViper\sharpprocess.pas',
  ShellHookTypes in '..\..\Services\SystemTask\ShellHookTypes.pas',
  SharpLibrary in '..\..\..\Common\Units\SharpViper\SharpLibrary.pas';

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

//function GetControlByHandle(AHandle: THandle): TWinControl;
//begin
// Result := Pointer(GetProp( AHandle,
//                            PChar( Format( 'Delphi%8.8x',
//                                           [GetCurrentProcessID]))));
//end;

constructor TModule.Create(pID : integer; pParent : hwnd);
begin
  inherited Create;
  FID := pID;
  FBarWnd := pParent;
  FForm := TMainForm.CreateParented(pParent);
  FForm.BorderStyle := bsNone;
  try
    FForm.Height := GetBarPluginHeight(FBarWnd);
  except
  end;
  FForm.ParentWindow := pParent;
  MouseTimer.AddWinControl(TMainForm(FForm));
  with FForm as TMainForm do
  begin
    ModuleID := pID;
    BarWnd := FBarWnd;

    BangCommand_Append := ' ('+inttostr(ModuleID)+')';
    RegisterBangs;
    RegisterHotkeys;

    LoadSettings;
    ReAlignComponents(False);

    RecallWindows;

    Show;
  end;
 // FForm.Parent := GetControlByHandle(pParent);
end;
destructor TModule.Destroy;
begin
  with FForm as TMainForm do
  begin
    RecallWindows;

//    GiveSmallChildrenTheFinger(True);

    UnRegisterBangs;
    UnRegisterHotkeys;

    Close;
  end;

  FreeAndNil(FForm);

  inherited Destroy;
end;

function CreateModule(ID : integer;
                      parent : hwnd) : hwnd;
var
  temp : TModule;
begin
  result := 0;

  try
    if (ModuleList = nil) then
       ModuleList := TObjectList.Create;

    if (MouseTimer = nil) then
       MouseTimer := TMouseTimer.Create;

    temp := TModule.Create(ID,parent);
    ModuleList.Add(temp);

    result := temp.Form.Handle;
  except
//    result := 0;
//    exit;
  end;
//  result := temp.Form.Handle;
end;
function CloseModule(ID : integer) : boolean;
var
  i, j : integer;
begin
  Result := False;

  if (ModuleList = nil) then exit;

  try
    j := pred(ModuleList.Count);
    for i := 0 to j do
        if ((ModuleList.Items[i] as TModule).ID = ID) then
        begin
          MouseTimer.RemoveWinControl((ModuleList.Items[i] as TModule).Form);
          if (MouseTimer.ControlList.Count = 0) then
             FreeAndNil(MouseTimer);
          ModuleList.Delete(i);
          result := True;
          exit;
        end;
  except
//    result := False;
  end;
end;

procedure Refresh(ID : integer);
var
  i, j : integer;
  temp : TModule;
begin
  j := pred(ModuleList.Count);
  for i := 0 to j do
      if ((ModuleList.Items[i] as TModule).ID = ID) then
      begin
        temp := (ModuleList.Items[i] as TModule);
        (temp.Form as TMainForm).ReAlignComponents(False);
      end;
end;
procedure PosChanged(ID : integer);
var
  i, j : integer;
  temp : TModule;
begin
  j := pred(ModuleList.Count);
  for i := 0 to j do
      if ((ModuleList.Items[i] as TModule).ID = ID) then
      begin
        temp := (ModuleList.Items[i] as TModule);
        (temp.Form as TMainForm).Background.Bitmap.SetSize(temp.Form.Width,temp.Form.Height);
        uSharpBarAPI.PaintBarBackGround(temp.BarWnd,(temp.Form as TMainForm).Background.Bitmap,Temp.Form);
      end;
end;
procedure SkinChanged(ID : integer);
var
  i, j : integer;
  temp : TModule;
begin
  j := pred(ModuleList.Count);
  for i := 0 to j do
      if ((ModuleList.Items[i] as TModule).ID = ID) then
      begin
        temp := (ModuleList.Items[i] as TModule);
        temp.Form.Height := GetBarPluginHeight(temp.BarWnd);
        (temp.Form as TMainForm).ReAlignComponents(False);
      end;
end;
procedure ShowSettingsWnd(ID : integer);
var
  i, j : integer;
  temp : TModule;
begin
  j := pred(ModuleList.Count);
  for i := 0 to j do
     if ((ModuleList.Items[i] as TModule).ID = ID) then
      begin
       temp := (ModuleList.Items[i] as TModule);
       (temp.FForm as TMainForm).Settings1Click((temp.FForm as TMainForm).Settings1);
      end;
end;
procedure SetSize(ID : integer; NewWidth : integer);
var
  i, j : integer;
  temp : TModule;
begin
  j := pred(ModuleList.Count);
  for i := 0 to j do
      if (ModuleList.Items[i] as TModule).ID = ID then
      begin
        temp := (ModuleList.Items[i] as TModule);
        (temp.FForm as TMainForm).SetSize(NewWidth);
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
