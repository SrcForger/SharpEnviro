{
Source Name: uSharpDeskSettingsWnd.pas
Description: SharpDesk Settings Window
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

unit uSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,  Menus, ComCtrls, SharpApi, SharpCenterApi,
  SharpEGaugeBoxEdit, ImgList, PngImageList, JvExControls, ExtCtrls,
  ISharpCenterHostUnit, SharpECenterHeader, JvXPCore, JvXPCheckCtrls;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmSettings = class(TForm)
    pcOptions: TPageControl;
    tabObjects: TTabSheet;
    tabDesktop: TTabSheet;
    tabMenu: TTabSheet;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    SharpECenterHeader3: TSharpECenterHeader;
    SharpECenterHeader4: TSharpECenterHeader;
    cb_adjustsize: TJvXPCheckbox;
    cb_useexplorer: TJvXPCheckbox;
    cb_amm: TJvXPCheckbox;
    cb_wpwatch: TJvXPCheckbox;
    cb_dd: TJvXPCheckbox;
    cb_singleclick: TJvXPCheckbox;
    SharpECenterHeader5: TSharpECenterHeader;
    SharpECenterHeader6: TSharpECenterHeader;
    SharpECenterHeader7: TSharpECenterHeader;
    pnlGrid: TPanel;
    sgb_gridy: TSharpeGaugeBox;
    sgb_gridx: TSharpeGaugeBox;
    cb_grid: TJvXPCheckbox;
    SharpECenterHeader8: TSharpECenterHeader;
    Panel1: TPanel;
    Label1: TLabel;
    cbMenuList: TComboBox;
    Panel3: TPanel;
    Label2: TLabel;
    cbMenuShift: TComboBox;
    SharpECenterHeader9: TSharpECenterHeader;
    cb_autorotate: TJvXPCheckbox;
    procedure sgb_gridyChangeValue(Sender: TObject; Value: Integer);
    procedure cb_ddClick(Sender: TObject);
    procedure cb_ammClick(Sender: TObject);
    procedure cb_singleclickClick(Sender: TObject);
    procedure cb_gridClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbMenuListChange(Sender: TObject);
    procedure cb_useexplorerClick(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;
    procedure UpdateGridBox;
    procedure SendUpdate;
  public
    procedure BuildMenuList(cMenu,sMenu : String);
    procedure UpdateExplorerStatus;    

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := true;
end;

procedure TfrmSettings.UpdateExplorerStatus;
begin
  cb_adjustsize.Enabled := not cb_useexplorer.Checked;
  cb_amm.Enabled := not cb_useexplorer.Checked;
  cb_grid.Enabled := not cb_useexplorer.Checked;
  sgb_gridx.Enabled := not cb_useexplorer.Checked;
  sgb_gridy.Enabled := not cb_useexplorer.Checked;
  cb_dd.Enabled := not cb_useexplorer.Checked;
  cb_singleclick.Enabled := not cb_useexplorer.Checked;
  cbmenulist.Enabled := not cb_useexplorer.Checked;
  cbmenushift.Enabled := not cb_useexplorer.Checked;
  Label1.Enabled := not cb_useexplorer.Checked;
  Label2.Enabled := not cb_useexplorer.Checked;
end;

procedure TfrmSettings.UpdateGridBox;
begin
  pnlGrid.Visible := cb_grid.Checked;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  UpdateGridBox;
  UpdateExplorerStatus;
end;

procedure TfrmSettings.cb_gridClick(Sender: TObject);
begin
  UpdateGridBox;
  SendUpdate;
end;

procedure TfrmSettings.SendUpdate;
begin
  if Visible then
     FPluginHost.SetSettingsChanged;
end;

procedure TfrmSettings.cb_singleclickClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.cb_useexplorerClick(Sender: TObject);
begin
  UpdateExplorerStatus;
  SendUpdate;
end;

procedure TfrmSettings.BuildMenuList(cMenu,sMenu : String);
var
  sr : TSearchRec;
  Dir : String;
  s : string;
begin
  cbmenulist.Items.Clear;
  Dir := SharpApi.GetSharpeUserSettingsPath;
  if FindFirst(Dir + 'SharpMenu\*.xml',FAAnyFile,sr) = 0 then
  repeat
    s := sr.Name;
    setlength(s,length(s) - length(ExtractFileExt(s)));
    cbmenulist.Items.Add(s);
    cbmenushift.Items.Add(s);
    if CompareText(s,cMenu) = 0 then
      cbmenulist.ItemIndex := cbmenulist.Items.Count - 1;
    if CompareText(s,sMenu) = 0 then
      cbmenushift.ItemIndex := cbmenushift.Items.Count - 1;

  until FindNext(sr) <> 0;
  FindClose(sr);

  if (cbmenulist.ItemIndex < 0) and (cbmenulist.Items.Count > 0) then
     cbmenulist.ItemIndex := 0;
  if (cbmenushift.ItemIndex < 0) and (cbmenushift.Items.Count > 0) then
     cbmenushift.ItemIndex := 0;
end;

procedure TfrmSettings.cbMenuListChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.cb_ammClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.cb_ddClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.sgb_gridyChangeValue(Sender: TObject;
  Value: Integer);
begin
  SendUpdate;
end;

end.

