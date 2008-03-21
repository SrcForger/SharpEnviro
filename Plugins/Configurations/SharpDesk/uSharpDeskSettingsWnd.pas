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

unit uSharpDeskSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi, SharpCenterApi,
  SharpEGaugeBoxEdit, ImgList, PngImageList, JvPageList, JvExControls, ExtCtrls;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmDeskSettings = class(TForm)
    cb_adjustsize: TCheckBox;
    cb_amm: TCheckBox;
    cb_autorotate: TCheckBox;
    cb_dd: TCheckBox;
    cb_singleclick: TCheckBox;
    cb_wpwatch: TCheckBox;
    JvLabel1: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    Label4: TLabel;
    cb_grid: TCheckBox;
    sgb_gridy: TSharpeGaugeBox;
    sgb_gridx: TSharpeGaugeBox;
    Panel2: TPanel;
    Label7: TLabel;
    cbMenuList: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    cbMenuShift: TComboBox;
    procedure sgb_gridyChangeValue(Sender: TObject; Value: Integer);
    procedure cb_ddClick(Sender: TObject);
    procedure cb_ammClick(Sender: TObject);
    procedure cb_singleclickClick(Sender: TObject);
    procedure cb_gridClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbMenuListChange(Sender: TObject);
  private
    procedure UpdateGridBox;
    procedure SendUpdate;
  public
    procedure BuildMenuList(cMenu,sMenu : String);
  end;

var
  frmDeskSettings: TfrmDeskSettings;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmDeskSettings.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := true;
  Panel1.DoubleBuffered := true;
end;

procedure TfrmDeskSettings.UpdateGridBox;
begin
  sgb_gridx.Visible := cb_grid.Checked;
  sgb_gridy.Visible := cb_grid.Checked;
end;

procedure TfrmDeskSettings.FormShow(Sender: TObject);
var
  i:Integer;
begin
  UpdateGridBox;

  For i := 0 to Pred(Self.ComponentCount) do
    if Self.Components[i].ClassName = TLabel.ClassName then
      TLabel(Self.Components[i]).Font.Color := clGray;

end;

procedure TfrmDeskSettings.cb_gridClick(Sender: TObject);
begin
  UpdateGridBox;
  SendUpdate;
end;

procedure TfrmDeskSettings.SendUpdate;
begin
  if Visible then
     CenterDefineSettingsChanged;
end;

procedure TfrmDeskSettings.cb_singleclickClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDeskSettings.BuildMenuList(cMenu,sMenu : String);
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

procedure TfrmDeskSettings.cbMenuListChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDeskSettings.cb_ammClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDeskSettings.cb_ddClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDeskSettings.sgb_gridyChangeValue(Sender: TObject;
  Value: Integer);
begin
  SendUpdate;
end;

end.

