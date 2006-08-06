{
Source Name: uCompServiceAppStatus
Description: Component Statuses List
Copyright (C)
              Zack Cerza - zcerza@coe.neu.edu (original dev)
              Pixol (Pixol@sharpe-shell.org)

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

unit uCompServiceAppStatus;

interface

uses
  // Standard
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ImgList,
  Menus,
  ExtCtrls,

  // JVCL
  JvComponent,
  JvFormPlacement;

type
  TfrmComponentStat = class(TForm)
    lvStatusItems: TListView;
    ilLv: TImageList;
    mnuItem: TPopupMenu;
    miStart: TMenuItem;
    miStop: TMenuItem;
    Timer1: TTimer;
    procedure mnuItemPopup(Sender: TObject);
    procedure miStartClick(Sender: TObject);
    procedure miStopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmComponentStat: TfrmComponentStat;

implementation

uses
  uCompServiceMain,
  uCompServiceAppStore;

{$R *.dfm}

procedure TfrmComponentStat.mnuItemPopup(Sender: TObject);
var
  imgid: integer;
begin
  miStart.Enabled := false;
  miStop.Enabled := false;

  if lvStatusItems.ItemIndex = -1 then
    exit;

  imgid := lvStatusItems.Selected.ImageIndex;
  if (imgid = 8) or (imgid = 9) then
    miStart.Enabled := True;
  if imgid = 5 then
    miStop.Enabled := True;

end;

procedure TfrmComponentStat.miStartClick(Sender: TObject);
var
  SelectedID: Integer;
begin
  SelectedID := lvStatusItems.ItemIndex;

  CompServ.LoadComponent(selectedid, ItemStorage.Info[selectedID].Command);
  CompServ.UpdateList(lvStatusItems);
end;

procedure TfrmComponentStat.miStopClick(Sender: TObject);
var
  SelectedID: Integer;
begin
  SelectedID := lvStatusItems.ItemIndex;

  TerminateProcess(ItemStorage.Info[SelectedID].ProcessHandle, 0);
  CompServ.UpdateList(lvStatusItems);
end;

procedure TfrmComponentStat.Timer1Timer(Sender: TObject);
begin
  if lvStatusItems.ItemIndex <> -1 then
    CompServ.UpdateList(frmComponentStat.lvStatusItems);
end;

procedure TfrmComponentStat.FormCreate(Sender: TObject);
begin
  lvStatusItems.DoubleBuffered := True;
end;

procedure TfrmComponentStat.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    frmComponentStat.Hide;
end;

end.
