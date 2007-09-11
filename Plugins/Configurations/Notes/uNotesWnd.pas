{
Source Name: uNotesWnd.pas
Description: Notes Module Settings Window
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

unit uNotesWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, JclFileUtils,
  ImgList, PngImageList, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit,
  JvPageList, JvExControls, ComCtrls, Mask;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmNotes = class(TForm)
    plMain: TJvPageList;
    pagNotes: TJvStandardPage;
    Label5: TLabel;
    cb_alwaysontop: TCheckBox;
    Label3: TLabel;
    Label1: TLabel;
    rb_icon: TRadioButton;
    rb_text: TRadioButton;
    rb_icontext: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cb_alwaysontopClick(Sender: TObject);
    procedure rb_textClick(Sender: TObject);
  private
    procedure UpdateSettings;
  public
    sModuleID: string;
    sBarID : string;
  end;

var
  frmNotes: TfrmNotes;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmNotes.cb_alwaysontopClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmNotes.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmNotes.FormShow(Sender: TObject);
begin
  Label5.Font.Color := clGrayText;
  Label1.Font.Color := clGrayText;
end;

procedure TfrmNotes.rb_textClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmNotes.UpdateSettings;
begin
  if Visible then
    SharpCenterApi.CenterDefineSettingsChanged;
end;

end.

