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
  Contnrs,
  Graphics,
  Controls,
  Forms,
  StdCtrls,
  ImgList,
  PngImageList,
  SharpTypes,
  SharpEListBoxEx, TaskFilterList, ExtCtrls, JclSimpleXml, JclFileUtils, JclStrings, Menus,
  SharpEGaugeBoxEdit, GR32_Image, GR32, SharpECenterHeader,
  JvExControls, JvXPCore, JvXPCheckCtrls, ISharpCenterHostUnit;

type
  TfrmEdit = class(TForm)
    pnlOptions: TPanel;
    pnlDisplay: TPanel;
    pnlAction: TPanel;
    Label2: TLabel;
    pnlCaption: TPanel;
    Label7: TLabel;
    pnlIcon: TPanel;
    Label8: TLabel;
    edCaption: TEdit;
    btnIconBrowse: TButton;
    edIcon: TEdit;
    edAction: TEdit;
    btnAction: TButton;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    chkDisplayIcon: TJvXPCheckbox;
    chkDisplayCaption: TJvXPCheckbox;
    procedure FormCreate(Sender: TObject);

    procedure SettingsChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure gbSizeChangeValue(Sender: TObject; Value: Integer);
    procedure btnActionClick(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure UpdateIcon;
  public
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmEdit: TfrmEdit;

const
  colName = 0;

implementation

uses SharpThemeApi, SharpDialogs, SharpApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmEdit.UpdateIcon;
//var
//  Bmp : TBitmap32;
begin
  {Bmp := TBitmap32.Create;
  try
    Bmp.DrawMode := dmBlend;
    Bmp.CombineMode := cmMerge;
    img_icon.Bitmap.SetSize(img_icon.Width,img_icon.Height);
    img_icon.Bitmap.Clear(color32(self.Color));
    if IconStringToIcon(edIcon.Text,'',Bmp) then
       Bmp.DrawTo(img_icon.Bitmap,Rect(0,0,img_icon.Bitmap.Width,img_icon.Bitmap.Height));
  finally
    Bmp.Free;
  end;  }
end;

procedure TfrmEdit.btnActionClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.TargetDialog(STI_ALL_TARGETS, Mouse.CursorPos);
  if length(trim(s))>0 then
  begin
    edAction.Text := s;
    //UpdateIcon;
  end;
end;

procedure TfrmEdit.btnBrowseClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.IconDialog('', [smiShellIcon,smiCustomIcon,smiSharpEIcon], Mouse.CursorPos);
  if length(trim(s))>0 then
  begin
    edIcon.Text := s;
    //UpdateIcon;
  end;
end;

procedure TfrmEdit.SettingsChange(Sender: TObject);
begin
  if Visible then
    PluginHost.Save;
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

