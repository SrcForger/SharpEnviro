{
Source Name: Button.dpr
Description: SharpBar Module Main Project File
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

library Notes;

uses
  Windows,
  Controls,
  SysUtils,
  Forms,
  Classes,
  Contnrs,
  GR32,
  Graphics,
  StdCtrls,
  uISharpBarModule,
  uISharpESkin,
  uISharpBar,
  {$IFDEF DEBUG}DebugDialog,{$ENDIF}
  MainWnd in 'MainWnd.pas' {MainForm},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  uSystemFuncs in '..\..\..\Common\Units\SystemFuncs\uSystemFuncs.pas',
  uInterfacedSharpBarModuleBase in '..\..\..\Components\SharpBar\uInterfacedSharpBarModuleBase.pas',
  NotesTabOptionsWnd in 'NotesTabOptionsWnd.pas' {TabOptionsForm},
  NotesWnd in 'NotesWnd.pas' {NotesForm},
  uNotesSettings in 'uNotesSettings.pas';

type
  TInterfacedSharpBarModule = class(TInterfacedSharpBarModuleBase)
    private
    public
      constructor Create(pID,pBarID : integer; pBarWnd : hwnd); override;

      function CloseModule : HRESULT; override;
      function SetTopHeight(Top,Height : integer) : HRESULT; override;
      function UpdateMessage(part : TSU_UPDATE_ENUM; param : integer) : HRESULT; override;
      function ModuleMessage(msg: string) : HRESULT; override;
      function InitModule : HRESULT; override;

      procedure SetSkinInterface(Value : ISharpESkinInterface); override;
      procedure SetSize(Value : integer); override;
  end;

{$R Preview.res}
{$R *.res}

{ TInterfacedSharpBarModule }

function TInterfacedSharpBarModule.CloseModule: HRESULT;
begin
  try
    if TMainForm(Form).NotesForm <> nil then
      if TMainForm(Form).Visible then
        TMainForm(Form).NotesForm.Close;

    Form.Free;
    Form := nil;
    result := S_OK;
  except
    on E:Exception do
    begin
      result := E_FAIL;
      SharpApi.SendDebugMessageEx(PChar(ModuleName),PChar('Error in CloseModule('
        + inttostr(ID) + '):' + E.Message),clred,DMT_ERROR);
    end;
  end;
end;

constructor TInterfacedSharpBarModule.Create(pID, pBarID: integer;
  pBarWnd: hwnd);
begin
  inherited Create(pID, pBarID, pBarWnd);
  ModuleName := 'Notes Module';

  try
    Form := TMainForm.CreateParented(BarWnd);
    Form.BorderStyle := bsNone;
    TMainForm(Form).mInterface := self;
    Form.ParentWindow := BarWnd;
  except
    on E:Exception do
    begin
      SharpApi.SendDebugMessageEx(PChar(ModuleName),PChar('Error in CreateModule('
        + inttostr(ID) + '):' + E.Message),clred,DMT_ERROR);
      exit;
    end;
  end;
end;

function TInterfacedSharpBarModule.InitModule: HRESULT;
begin
  result := inherited InitModule;

  if Form <> nil then
  begin
    TMainForm(Form).LoadSettings;
    TMainForm(Form).RealignComponents;
  end;
end;

function TInterfacedSharpBarModule.ModuleMessage(msg: string): HRESULT;
begin
  result := inherited ModuleMessage(msg);

  if CompareText(msg,'MM_SHARPEUPDATEACTIONS') <> 0 then exit;

  if not (Initialized) then
    exit;

  if Form <> nil then  
    TMainForm(Form).UpdateBangs;
end;

procedure TInterfacedSharpBarModule.SetSize(Value: integer);
begin
  inherited SetSize(Value);

  TMainForm(Form).UpdateSize;
end;

procedure TInterfacedSharpBarModule.SetSkinInterface(Value: ISharpESkinInterface);
begin
  inherited SetSkinInterface(Value);

  if Form <> nil then
    TMainForm(Form).UpdateComponentSkins;
end;

function TInterfacedSharpBarModule.SetTopHeight(Top, Height: integer): HRESULT;
begin
  result := inherited SetTopHeight(Top, Height);

  if (Form <> nil) and (Initialized) then
    TMainForm(Form).RealignComponents;
end;

function TInterfacedSharpBarModule.UpdateMessage(part: TSU_UPDATE_ENUM;
  param: integer): HRESULT;
const
  processed : TSU_UPDATES = [suSkinFileChanged,suBackground,suTheme,suSkin,
                             suScheme,suIconSet,suSkinFont,suModule];
begin
  result := inherited UpdateMessage(part,param);

  if not (Initialized) then
    exit;

  if not (part in processed) then
    exit;  

  if (part = suModule) and (ID  = param) then
  begin
    TMainForm(Form).LoadSettings;
    TMainForm(Form).ReAlignComponents;
  end;

  if [part] <= [suTheme,suSkinFileChanged] then
    TMainForm(Form).ReAlignComponents;
end;

function GetMetaData(Preview : TBitmap32) : TMetaData;
var
  Bmp : TBitmap32;
  ResStream : TResourceStream;
  b : boolean;
begin
  with result do
  begin
    Name := 'Notes';
    Author := 'Martin Krämer <Martin@SharpEnviro.com>';
    Description := 'Quick access to an easy to use notes window (with tab support)';
    Version := '0.7.6.5';
    ExtraData := 'preview: True';
    DataType := tteModule;

    Bmp := TBitmap32.Create;
    ResStream := TResourceStream.Create(HInstance, 'Preview', RT_RCDATA);
    try
      LoadBitmap32FromPng(Bmp,ResStream,b);
    finally
      ResStream.Free;
    end;
    Preview.SetSize(Bmp.Width,Bmp.Height);
    Bmp.DrawTo(Preview);
    Bmp.Free;
  end;
end;

function CreateModule(ID,BarID : integer; BarWnd : hwnd) : IInterface;
begin
  result := TInterfacedSharpBarModule.Create(ID,BarID,BarWnd);
end;

Exports
  CreateModule,
  GetMetaData;

begin
end.
