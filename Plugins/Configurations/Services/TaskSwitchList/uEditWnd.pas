{
Source Name: uEditSchemeWnd
Description: Edit/Create Scheme Window
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

unit uEditWnd;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  ExtCtrls,

  SharpApi,
  SharpCenterApi,
  SharpThemeApiEx,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,

  uTaskswitchUtility;

type
  TfrmEdit = class(TForm)
    edName: TLabeledEdit;
    edAction: TLabeledEdit;
    procedure edNameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    FUpdating: Boolean;
    FPluginHost: ISharpCenterHost;
    FItemEdit: TTaskSwitchItem;

  public
    procedure Init;
    procedure Save;

    property ItemEdit: TTaskSwitchItem read FItemEdit write FItemEdit;
    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmEdit: TfrmEdit;

implementation

uses JclStrings,
  uListWnd;

{$R *.dfm}

procedure TfrmEdit.edNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  FItemEdit := TTaskSwitchItem.Create;
end;

procedure TfrmEdit.Init;
var
  tmp: TTaskSwitchItem;
begin
  case FPluginHost.EditMode of
    sceAdd: begin
        edName.Text := '';
        edAction.Text := '';

        if ((Visible) and (edName.Enabled)) then
          edName.SetFocus;
      end;
    sceEdit: begin
        tmp := TTaskSwitchItem(frmList.lbList.SelectedItem.Data);
        edName.Text := tmp.Name;
        edAction.Text := tmp.Action;

        FItemEdit.Name := edName.Text;
        FItemEdit.Action := edAction.Text;

        if ((Visible) and (edName.Enabled)) then
          edName.SetFocus;
      end;
  end;

  PluginHost.Refresh;
end;

procedure TfrmEdit.Save;
var
  tmp: TTaskSwitchItem;
begin

  case FPluginHost.EditMode of
    sceAdd: begin
        tmp := frmList.TaskSwitchList.AddItem;
        tmp.Name := edName.Text;
        tmp.Action := edAction.Text;
        tmp.CycleForward := true;
        tmp.Gui := true;
        tmp.Preview := true;
      end;
    sceEdit: begin
        tmp := TTaskSwitchItem(frmList.lbList.SelectedItem.Data);
        tmp.Name := edName.Text;
        tmp.Action := edAction.Text;
    end;
  end;

  PluginHost.Save;
  frmList.AddItems;
end;

end.

