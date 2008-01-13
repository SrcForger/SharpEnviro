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
  JvSimpleXml,
  JclFileUtils,
  Registry,
  ImgList,
  PngImageList,
  GR32,
  GR32_PNG,
  SharpApi,
  ExtCtrls,
  Menus,
  JclStrings,
  GR32_Image,
  SharpEGaugeBoxEdit,
  JvPageList,
  JvExControls,
  ComCtrls,
  Mask,
  SharpEColorEditorEx,
  SharpESwatchManager,
  JvExMask,
  JvSpin,
  SharpERoundPanel;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmCPUMon = class(TForm)
    plMain: TJvPageList;
    pagMon: TJvStandardPage;
    Panel1: TPanel;
    sgbWidth: TSharpeGaugeBox;
    SharpESwatchManager1: TSharpESwatchManager;
    Label4: TLabel;
    Panel5: TPanel;
    sgbUpdate: TSharpeGaugeBox;
    Label5: TLabel;
    Label8: TLabel;
    Panel6: TPanel;
    edit_cpu: TJvSpinEdit;
    pagColors: TJvStandardPage;
    Colors: TSharpEColorEditorEx;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    sgbBackground: TSharpeGaugeBox;
    Panel3: TPanel;
    sgbForeground: TSharpeGaugeBox;
    Panel4: TPanel;
    sgbBorder: TSharpeGaugeBox;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    rbGraphBar: TRadioButton;
    rbCurrentUsage: TRadioButton;
    rbGraphLine: TRadioButton;
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cb_numbersClick(Sender: TObject);
    procedure sgbWidthChangeValue(Sender: TObject; Value: Integer);
    procedure ColorsChangeColor(ASender: TObject; AValue: Integer);
    procedure edit_cpuChange(Sender: TObject);
    procedure rbGraphBarClick(Sender: TObject);
    procedure pagColorsShow(Sender: TObject);
    procedure pagMonShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    sLastPage: TJvStandardPage;
    procedure UpdateSettings;
    procedure CheckValidKeys;
  public
    sModuleID: string;
    sBarID: string;
  end;

var
  frmCPUMon: TfrmCPUMon;

implementation

uses SharpThemeApi,
  SharpCenterApi,
  adCPUUsage;

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

  if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\PerfOS\Performance', False) then begin
    if Reg.ValueExists('Disable Performance Counters') then
      PerfMonDisabled := (Reg.ReadInteger('Disable Performance Counters') <> 0)
    else
      PerfMonDisabled := True;
    Reg.CloseKey;
  end
  else
    PerfMonDisabled := True;

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
  DoubleBuffered := true;
  try
    edit_cpu.MaxValue := adCpuUsage.GetCPUCount;
  except
  end;
end;

procedure TfrmCPUMon.FormShow(Sender: TObject);
begin
  Label7.Font.Color := clGrayText;
  Label8.Font.Color := clGrayText;
  Label2.Font.Color := clGrayText;
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
    SharpCenterApi.CenterDefineSettingsChanged;
end;

end.

