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
  SharpERoundPanel, SharpECenterHeader, SharpECustomSkinSettings, JclSimpleXml;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmCPUMon = class(TForm)
    plMain: TJvPageList;
    pagMon: TJvStandardPage;
    SharpESwatchManager1: TSharpESwatchManager;
    Panel5: TPanel;
    sgbUpdate: TSharpeGaugeBox;
    Panel6: TPanel;
    edit_cpu: TJvSpinEdit;
    pagColors: TJvStandardPage;
    Colors: TSharpEColorEditorEx;
    Panel2: TPanel;
    sgbBackground: TSharpeGaugeBox;
    Panel3: TPanel;
    sgbForeground: TSharpeGaugeBox;
    Panel4: TPanel;
    sgbBorder: TSharpeGaugeBox;
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
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    SharpECenterHeader3: TSharpECenterHeader;
    SharpECenterHeader4: TSharpECenterHeader;
    Panel7: TPanel;
    sgbWidth: TSharpeGaugeBox;
    SharpECenterHeader5: TSharpECenterHeader;
    SharpECenterHeader6: TSharpECenterHeader;
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
    sLastPage: TJvStandardPage;
    FModuleId: Integer;
    FBarId: Integer;
    procedure UpdateSettings;
    procedure CheckValidKeys;
  public
    procedure Load;
    procedure Save;
    property BarId: Integer read FBarId write FBarId;
    property ModuleId: Integer read FModuleId write FModuleId;
  end;

var
  frmCPUMon: TfrmCPUMon;

implementation

uses SharpThemeApi,
  SharpCenterApi,
  adCPUUsage, uSharpBarAPI;

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
    edit_cpu.MaxValue := adCpuUsage.GetCPUCount;
  except
  end;
end;

procedure TfrmCPUMon.Load;
var
  Custom: TSharpECustomSkinSettings;
  scheme: TSharpEColorSet;
  Skin: string;
  i: Integer;
  XML: TJclSimpleXML;
  fileloaded: Boolean;
begin
  Custom := TSharpECustomSkinSettings.Create;
  Custom.LoadFromXML(XmlGetSkinDir);
  with Custom.xml.Items do
    if ItemNamed['cpumonitor'] <> nil then
      with ItemNamed['cpumonitor'].Items, frmCPUMon do
      begin
        XmlGetThemeScheme(scheme);
        Colors.Items.Item[0].ColorCode := XmlSchemeCodeToColor(IntValue('bgcolor', 0), scheme);
        Colors.Items.Item[1].ColorCode := XmlSchemeCodeToColor(IntValue('fgcolor', clwhite), scheme);
        Colors.Items.Item[2].ColorCode := XmlSchemeCodeToColor(IntValue('bordercolor', clwhite), scheme);
        sgbBackground.Value := IntValue('bgalpha', 255);
        sgbForeground.Value := IntValue('fgalpha', 255);
        sgbBorder.Value := IntValue('borderalpha', 255);
      end;
  Custom.Free;
  skin := XmlGetSkin(XmlGetTheme);
  XML := TJclSimpleXML.Create;
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(FBarId,FModuleId));
    fileloaded := True;
  except
  end;
  if fileloaded then
    with XML.Root.Items, frmCPUMon do
    begin
      if ItemNamed['global'] <> nil then
        with ItemNamed['global'].Items do
        begin
          sgbWidth.Value := IntValue('Width', sgbWidth.Value);
          sgbUpdate.Value := IntValue('Update', sgbUpdate.Value);
          edit_cpu.Value := IntValue('CPU', round(edit_cpu.Value));
          i := IntValue('DrawMode', 1);
          case i of
            0:
              rbGraphBar.Checked := True;
            2:
              rbCurrentUsage.Checked := True;
          else
            rbGraphLine.Checked := True;
          end;
        end;
      if ItemNamed['skin'] <> nil then
        if ItemNamed['skin'].Items.ItemNamed[skin] <> nil then
          with ItemNamed['skin'].Items.ItemNamed[skin].Items do
          begin
            Colors.Items.Item[0].ColorCode := IntValue('BGColor', Colors.Items.Item[0].ColorCode);
            Colors.Items.Item[1].ColorCode := IntValue('FGColor', Colors.Items.Item[1].ColorCode);
            Colors.Items.Item[2].ColorCode := IntValue('BorderColor', Colors.Items.Item[2].ColorCode);
            sgbBackground.Value := IntValue('BGAlpha', sgbBackground.Value);
            sgbForeground.Value := IntValue('FGAlpha', sgbForeground.Value);
            sgbBorder.Value := IntValue('BorderAlpha', sgbBorder.Value);
          end;
    end;
  XML.Free;
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

procedure TfrmCPUMon.Save;
var
  XML : TJclSimpleXML;
  skin : String;
  fileloaded : boolean;
  fname : string;
begin
  if frmCPUMon = nil then
    exit;

  fname := uSharpBarApi.GetModuleXMLFile(FBarId,FModuleId);
  XML := TJclSimpleXML.Create;

  fileloaded := false;
  if FileExists(fname) then
  begin
    try
      XML.LoadFromFile(fname);
      fileloaded := True;
    except
      XML.Root.Clear;
    end;
  end;
  if not fileloaded then
    XML.Root.Name := 'CPUMonitorModuleSettings';
    
  skin := SharpThemeApi.GetSkinName;
  with XML.Root.Items, frmCPUMon do
  begin
    if ItemNamed['global'] = nil then
      Add('global');
    with ItemNamed['global'].Items do
    begin
      Clear;
      Add('Width',sgbWidth.Value);
      Add('Update',sgbUpdate.Value);
      Add('CPU',round(edit_cpu.Value));
      if rbGraphBar.Checked then
        Add('DrawMode',0)
      else if rbCurrentUsage.Checked then
        Add('DrawMode',2)
      else Add('DrawMode',1);
    end;

    if ItemNamed['skin'] <> nil then
    begin
      if ItemNamed['skin'].Items.ItemNamed[skin] = nil then
         ItemNamed['skin'].Items.Add(skin);
    end else Add('skin').Items.Add(skin);
    with ItemNamed['skin'].Items.ItemNamed[skin].Items do
    begin
      Clear;
      Add('BGColor',Colors.Items.Item[0].ColorCode);
      Add('FGColor',Colors.Items.Item[1].ColorCode);
      Add('BorderColor',Colors.Items.Item[2].ColorCode);
      Add('BGAlpha',sgbBackground.Value);
      Add('FGAlpha',sgbForeground.Value);
      Add('BorderAlpha',sgbBorder.Value);
    end;
  end;
  XML.SaveToFile(FName);
  XML.Free;
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

