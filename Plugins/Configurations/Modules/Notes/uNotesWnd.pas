{
Source Name: uNotesWnd.pas
Description: Notes Module Settings Window
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

unit uNotesWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, JclFileUtils,
  ImgList, PngImageList, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit,
  JvPageList, JvExControls, ComCtrls, Mask, SharpCenterAPI, ISharpCenterHostUnit,
  SharpECenterHeader, JvXPCore, JvXPCheckCtrls, JvXPButtons, JvBaseDlg,
  JvBrowseFolder;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmNotes = class(TForm)
    plMain: TJvPageList;
    pagNotes: TJvStandardPage;
    rb_icon: TRadioButton;
    rb_text: TRadioButton;
    rb_icontext: TRadioButton;
    schWindowOptions: TSharpECenterHeader;
    schDisplayOptions: TSharpECenterHeader;
    cbAlwaysOnTop: TJvXPCheckbox;
    editCaptionText: TLabeledEdit;
    editDirectory: TLabeledEdit;
    schDirectoryOptions: TSharpECenterHeader;
    JvBrowseForFolderDialog1: TJvBrowseForFolderDialog;
    btnBrowse: TJvXPButton;
    procedure FormCreate(Sender: TObject);
    procedure cb_alwaysontopClick(Sender: TObject);
    procedure rb_textClick(Sender: TObject);
    procedure cbAlwaysOnTopClick(Sender: TObject);
    procedure editCaptionTextChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure editDirectoryChange(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure UpdateSettings;
  public
    sModuleID: string;
    sBarID : string;
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmNotes: TfrmNotes;

implementation

{$R *.dfm}

procedure TfrmNotes.btnBrowseClick(Sender: TObject);
var
  newDirectory : string;
begin
  newDirectory := editDirectory.Text;
  if BrowseForFolder('Browse for Notes folder...', True, newDirectory) then
    editDirectory.Text := newDirectory;
end;

procedure TfrmNotes.cbAlwaysOnTopClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmNotes.cb_alwaysontopClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmNotes.editDirectoryChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmNotes.editCaptionTextChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmNotes.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmNotes.rb_textClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmNotes.UpdateSettings;
begin
  if Visible then
    PluginHost.Save;
end;

end.

