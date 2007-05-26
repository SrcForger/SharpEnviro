{
Source Name: uSettingsWnd
Description: Configuration window for Prism
Copyright (C) Lee Green <Pixol@sharpe-shell.org>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 6
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
unit uSettingsWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Spin,
  ComCtrls,
  pngimage,
  JvPageList,
  JvExControls,
  JvComponent,
  Mask,
  JvExMask,
  JvSpin,
  SharpApi;

type
  TfrmSettingsWnd = class(TForm)
    coldlg: TColorDialog;
    Label3: TLabel;
    plConfig: TJvPageList;
    spGeneral: TJvStandardPage;
    chkMemOptimer: TCheckBox;
    Label5: TLabel;
    JvStandardPage2: TJvStandardPage;
    Label6: TLabel;
    lbl2: TLabel;
    lbl11: TLabel;
    spnedtMemEvtInt: TJvSpinEdit;
    spnedtMemLowThres: TJvSpinEdit;
    procedure chkCpuEnableClick(Sender: TObject);
    procedure chkMemOptimerClick(Sender: TObject);

    procedure spnedtMemEvtIntChange(Sender: TObject);
    procedure spnedtMemLowThresChange(Sender: TObject);
  private
    { Private declarations }
    FInitialising: Boolean;
  public
    { Public declarations }
    procedure InitialiseSettings;
  end;

var
  frmSettingsWnd: TfrmSettingsWnd;

implementation

uses
  uPrismSettings;

{$R *.dfm}

{ TfrmSettingsWnd }

procedure TfrmSettingsWnd.InitialiseSettings;
var
  b: boolean;
begin
  FInitialising := True;
  try
    with PrismSettings do begin

      // Mem
      chkMemOptimer.Checked := EnableMemOptim;
      spnedtMemEvtInt.Value := MemEventInterval;
      spnedtMemLowThres.Value := MemLowThreshold;

      spnedtMemEvtInt.Enabled := EnableMemOptim;
      spnedtMemLowThres.Enabled := EnableMemOptim;

    end;
  finally
    FInitialising := False;
  end;
end;

procedure TfrmSettingsWnd.chkCpuEnableClick(Sender: TObject);
begin
  //PrismSettings.EnableCpuOptim := chkCpuEnable.Checked;
  //InitialiseSettings;
end;

procedure TfrmSettingsWnd.chkMemOptimerClick(Sender: TObject);
begin
  if FInitialising then exit;
  PrismSettings.EnableMemOptim := chkMemOptimer.Checked;
  SharpCenterBroadCast(WM_SETTINGSCHANGED, 1, 1);
  InitialiseSettings;
end;

procedure TfrmSettingsWnd.spnedtMemEvtIntChange(Sender: TObject);
begin
  if FInitialising then exit;
  PrismSettings.MemEventInterval := TSpinEdit(Sender).Value;
  SharpCenterBroadCast(WM_SETTINGSCHANGED, 1, 1);
  InitialiseSettings;
end;

procedure TfrmSettingsWnd.spnedtMemLowThresChange(Sender: TObject);
begin
  if FInitialising then exit;
  PrismSettings.MemLowThreshold := TSpinEdit(Sender).Value;
  SharpCenterBroadCast(WM_SETTINGSCHANGED, 1, 1);
  InitialiseSettings;
end;

end.

