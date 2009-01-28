{
Source Name: uEditWnd.pas
Description: Options Window
Copyright (C) Lee Green (lee@sharpenviro.com)

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
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  JclSimpleXml,
  JclFileUtils,
  SharpFileUtils,
  SharpEGaugeBoxEdit,
  SharpAPI,
  SharpDialogs,
  SharpECenterHeader,
  ISharpCenterHostUnit;

type
  TfrmEdit = class(TForm)
    pnlOptions: TPanel;
    Panel2: TPanel;
    chkDisplayIcon: TCheckBox;
    chkDisplayCaption: TCheckBox;
    pnlMenu: TPanel;
    pnlIcon: TPanel;
    btnIconBrowse: TButton;
    cbMenu: TComboBox;
    schMenu: TSharpECenterHeader;
    pnlDisplayOptions: TPanel;
    schDisplayOptions: TSharpECenterHeader;
    SharpECenterHeader1: TSharpECenterHeader;
    editCaption: TEdit;
    SharpECenterHeader2: TSharpECenterHeader;
    editIcon: TEdit;
    procedure FormCreate(Sender: TObject);

    procedure SettingsChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure gbSizeChangeValue(Sender: TObject; Value: Integer);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure PopulateMenus;
    procedure UpdateSettings;
  public
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmEdit: TfrmEdit;

const
  colName = 0;

implementation

{$R *.dfm}

procedure TfrmEdit.btnBrowseClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.IconDialog('',
                               [smiCustomIcon,smiSharpEIcon],
                               Mouse.CursorPos);
  if length(trim(s))>0 then
  begin
    editIcon.Text := s;
  end;
end;

procedure TfrmEdit.PopulateMenus;
var
  files: TStringList;
  i: Integer;
  s: string;
begin
  cbMenu.Clear;
  files := TStringList.Create;
  try

  SharpFileUtils.FindFiles(files, GetSharpeUserSettingsPath + 'SharpMenu\','*.xml');

    for i := 0 to pred(files.Count) do begin
      s := files[i];
      setlength(s,length(s) - length(ExtractFileExt(s)));

      cbMenu.Items.Add( PathRemoveExtension( ExtractFileName(s) ) );
    end;

  finally
    files.Free;
  end;
end;

procedure TfrmEdit.SettingsChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  PopulateMenus;
end;

procedure TfrmEdit.gbSizeChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateSettings;
end;

procedure TfrmEdit.UpdateSettings;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;
end.

