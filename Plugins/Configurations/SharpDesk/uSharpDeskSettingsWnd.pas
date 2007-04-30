{
Source Name: uSharpDeskSettingsWnd.pas
Description: SharpDesk Settings Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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

unit uSharpDeskSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi,
  JvExComCtrls, JvComCtrls, ExtCtrls, JvPageList, JvExControls;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmDeskSettings = class(TForm)
    JvPageList1: TJvPageList;
    JvSettingsPage: TJvStandardPage;
    Panel1: TPanel;
    cb_grid: TCheckBox;
    pn_grid: TPanel;
    lb_gridx1: TLabel;
    lb_gridx: TLabel;
    Label1: TLabel;
    lb_gridy: TLabel;
    tb_gridx: TJvTrackBar;
    tb_gridy: TJvTrackBar;
    Panel2: TPanel;
    cb_singleclick: TCheckBox;
    JvAdvSettingsPage: TJvStandardPage;
    Panel3: TPanel;
    cb_amm: TCheckBox;
    Label2: TLabel;
    procedure cb_ammClick(Sender: TObject);
    procedure cb_singleclickClick(Sender: TObject);
    procedure cb_gridClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tb_gridyChange(Sender: TObject);
    procedure tb_gridxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure UpdateGridBox;
    procedure SendUpdate;
  public
  end;

var
  frmDeskSettings: TfrmDeskSettings;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmDeskSettings.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := true;
end;

procedure TfrmDeskSettings.UpdateGridBox;
begin
  pn_grid.visible := cb_grid.Checked;
end;

procedure TfrmDeskSettings.tb_gridxChange(Sender: TObject);
begin
   lb_gridx.Caption := inttostr(tb_gridx.Position) +'px';
   SendUpdate;
end;

procedure TfrmDeskSettings.tb_gridyChange(Sender: TObject);
begin
   lb_gridy.Caption := inttostr(tb_gridy.Position) +'px';
   SendUpdate;
end;

procedure TfrmDeskSettings.FormShow(Sender: TObject);
begin
  UpdateGridBox;
end;

procedure TfrmDeskSettings.cb_gridClick(Sender: TObject);
begin
  UpdateGridBox;
  SendUpdate;
end;

procedure TfrmDeskSettings.SendUpdate;
begin
  if Visible then
     SharpEBroadCast(WM_SHARPCENTERMESSAGE, SCM_SET_SETTINGS_CHANGED, 0);
end;

procedure TfrmDeskSettings.cb_singleclickClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDeskSettings.cb_ammClick(Sender: TObject);
begin
  SendUpdate;
end;

end.

