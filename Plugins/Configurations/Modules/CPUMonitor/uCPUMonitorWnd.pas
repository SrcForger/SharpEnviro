{
Source Name: uCPUMonitorWnd.pas
Description: CPUMonitor Module Settings Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit uCPUMonitorWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JclSimpleXml, Menus, ComCtrls, SharpAPI, SharpCenterAPI,
  ExtCtrls, SharpEGaugeBoxEdit, SharpECenterHeader,
  Registry, JclStrings, JvPageList, SharpEColorEditorEx, SharpESwatchManager,
  JvSpin, SharpERoundPanel, adCPUUsage, ISharpCenterHostUnit, Mask, JvExMask,
  JvExControls;

type
  TfrmCPUMon = class(TForm)
    plMain: TJvPageList;
    pagMon: TJvStandardPage;
    SharpESwatchManager1: TSharpESwatchManager;
    Panel5: TPanel;
    Panel6: TPanel;
    pagColors: TJvStandardPage;
    Colors: TSharpEColorEditorEx;
    Panel2: TPanel;
    sgbBackground: TSharpeGaugeBox;
    sgbForeground: TSharpeGaugeBox;
    Panel4: TPanel;
    sgbBorder: TSharpeGaugeBox;
    pagError: TJvStandardPage;
    SharpERoundPanel1: TSharpERoundPanel;
    Label10: TLabel;
    Label11: TLabel;
    Button1: TButton;
    Label12: TLabel;
    pagError2: TJvStandardPage;
    SharpERoundPanel2: TSharpERoundPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader3: TSharpECenterHeader;
    SharpECenterHeader5: TSharpECenterHeader;
    Panel1: TPanel;
    cboGraphType: TComboBox;
    SharpECenterHeader2: TSharpECenterHeader;
    edit_cpu: TSharpeGaugeBox;
    sgbUpdate: TSharpeGaugeBox;
    SharpECenterHeader4: TSharpECenterHeader;
    Panel3: TPanel;
    sgbWidth: TSharpeGaugeBox;
    procedure FormCreate(Sender: TObject);
    procedure cb_numbersClick(Sender: TObject);
    procedure sgbWidthChangeValue(Sender: TObject; Value: Integer);
    procedure ColorsChangeColor(ASender: TObject; AValue: Integer);
    procedure edit_cpuChange(Sender: TObject);
    procedure rbGraphBarClick(Sender: TObject);
    procedure pagColorsShow(Sender: TObject);
    procedure pagMonShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    sLastPage: TJvStandardPage;
    procedure UpdateSettings;
    procedure CheckValidKeys;
  public
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmCPUMon: TfrmCPUMon;

implementation

{$R *.dfm}

procedure TfrmCPUMon.Button1Click(Sender: TObject);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.Access := KEY_ALL_ACCESS;
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\PerfOS\Performance', False) then begin
    Reg.WriteInteger('Disable Performance Counters', 0);
    Reg.CloseKey;
  end;

  Reg.Free;

  plMain.ActivePage := sLastPage;
end;

procedure TfrmCPUMon.cb_numbersClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmCPUMon.CheckValidKeys;
var
  Reg: TRegistry;
  PerfMonDisabled: Boolean;
  PerfMonAccessDisabled: Boolean;
begin
  Reg := TRegistry.Create;
  Reg.Access := KEY_READ;
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  PerfMonAccessDisabled := False;
  if not Reg.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib', False) then
    PerfMonAccessDisabled := True
  else
    Reg.CloseKey;

  if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\PerfOS\Performance', False) then
  begin
    if Reg.ValueExists('Disable Performance Counters') then
      PerfMonDisabled := (Reg.ReadInteger('Disable Performance Counters') <> 0)
    else PerfMonDisabled := False;
    Reg.CloseKey;
  end else PerfMonDisabled := False;

  Reg.Free;

  if PerfMonAccessDisabled then
    pagError2.Show
  else if PerfMonDisabled then
    pagError.Show;
end;

procedure TfrmCPUMon.ColorsChangeColor(ASender: TObject; AValue: Integer);
begin
  UpdateSettings;
end;

procedure TfrmCPUMon.edit_cpuChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmCPUMon.FormCreate(Sender: TObject);
begin
  sLastPage := pagMon;
  try
    edit_cpu.Max := adCpuUsage.GetCPUCount;
  except
  end;
end;

procedure TfrmCPUMon.pagColorsShow(Sender: TObject);
begin
  sLastPage := pagColors;
  CheckValidKeys;
end;

procedure TfrmCPUMon.pagMonShow(Sender: TObject);
begin
  sLastPage := pagMon;
  CheckValidKeys;
end;

procedure TfrmCPUMon.rbGraphBarClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmCPUMon.sgbWidthChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateSettings;
end;

procedure TfrmCPUMon.UpdateSettings;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;

end.

