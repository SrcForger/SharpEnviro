{
Source Name: uEditWnd.pas
Description: Options Window
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

unit uEditWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Contnrs,
  Graphics,
  Controls,
  Forms,
  StdCtrls,
  ImgList,
  PngImageList,
  SharpTypes,
  SharpEListBoxEx, TaskFilterList, ExtCtrls, JclSimpleXml, JclFileUtils, JclStrings, Menus,
  GR32_Image, GR32, SharpECenterHeader,
  JvExControls, JvXPCore, JvXPCheckCtrls, ISharpCenterHostUnit;

type
  TfrmEdit = class(TForm)
    pnlOptions: TPanel;
    pnlDisplay: TPanel;
    pnlAction: TPanel;
    pnlCaption: TPanel;
    Label7: TLabel;
    pnlIconShow: TPanel;
    Label8: TLabel;
    edCaption: TEdit;
    btnIconBrowse: TButton;
    edIconShow: TEdit;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    chkDisplayIcon: TJvXPCheckbox;
    chkDisplayCaption: TJvXPCheckbox;
    pnlActionR: TPanel;
    pnlIconRestore: TPanel;
    Label3: TLabel;
    btnIconBrowse2: TButton;
    edIconRestore: TEdit;
    Panel1: TPanel;
    chkCustomIcon: TJvXPCheckbox;
    chkAllMonitors: TJvXPCheckbox;
    procedure FormCreate(Sender: TObject);

    procedure SettingsChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure gbSizeChangeValue(Sender: TObject; Value: Integer);
    procedure btnIconBrowse2Click(Sender: TObject);
    procedure chkDisplayIconClick(Sender: TObject);
    procedure chkCustomIconClick(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;
  public
    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmEdit: TfrmEdit;

const
  colName = 0;

implementation

uses
  SharpThemeApiEx, SharpDialogs, SharpApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmEdit.btnBrowseClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.IconDialog('', [smiShellIcon,smiCustomIcon,smiSharpEIcon], Mouse.CursorPos);
  if length(trim(s))>0 then
    edIconShow.Text := s;
end;

procedure TfrmEdit.btnIconBrowse2Click(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.IconDialog('', [smiShellIcon,smiCustomIcon,smiSharpEIcon], Mouse.CursorPos);
  if length(trim(s))>0 then
    edIconRestore.Text := s;
end;

procedure TfrmEdit.chkCustomIconClick(Sender: TObject);
begin
  Label8.Enabled := chkCustomIcon.Checked;
  Label3.Enabled := chkCustomIcon.Checked;
  edIconShow.Enabled := chkCustomIcon.Checked;
  edIconRestore.Enabled := chkCustomIcon.Checked;
  btnIconBrowse.Enabled := chkCustomIcon.Checked;
  btnIconBrowse2.Enabled := chkCustomIcon.Checked;

  if Visible then
    PluginHost.SetSettingsChanged;
end;

procedure TfrmEdit.chkDisplayIconClick(Sender: TObject);
begin
  chkCustomIcon.Enabled := chkDisplayIcon.Checked;
  Label8.Enabled := chkDisplayIcon.Checked and chkCustomIcon.Checked;
  Label3.Enabled := chkDisplayIcon.Checked and chkCustomIcon.Checked;
  edIconShow.Enabled := chkDisplayIcon.Checked and chkCustomIcon.Checked;
  edIconRestore.Enabled := chkDisplayIcon.Checked and chkCustomIcon.Checked;
  btnIconBrowse.Enabled := chkDisplayIcon.Checked and chkCustomIcon.Checked;
  btnIconBrowse2.Enabled := chkDisplayIcon.Checked and chkCustomIcon.Checked;

  if Visible then
    PluginHost.SetSettingsChanged;
end;

procedure TfrmEdit.SettingsChange(Sender: TObject);
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
end;

procedure TfrmEdit.gbSizeChangeValue(Sender: TObject; Value: Integer);
begin
  SettingsChange(Sender);
end;

end.

