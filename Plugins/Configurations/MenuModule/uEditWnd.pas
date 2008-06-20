﻿{
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
  SharpEGaugeBoxEdit, SharpIconUtils, GR32_Image, GR32;

type
  TfrmEdit = class(TForm)
    pnlOptions: TPanel;
    Label3: TLabel;
    lblSizeDesc: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    chkDisplayIcon: TCheckBox;
    chkDisplayCaption: TCheckBox;
    Label6: TLabel;
    Label4: TLabel;
    lblMenuDesc: TLabel;
    lblDisplayDesc: TLabel;
    Panel3: TPanel;
    Label2: TLabel;
    pnlCaption: TPanel;
    Label7: TLabel;
    pnlIcon: TPanel;
    Label8: TLabel;
    edCaption: TEdit;
    btnIconBrowse: TButton;
    edIcon: TEdit;
    gbSize: TSharpeGaugeBox;
    cbMenu: TComboBox;
    procedure FormCreate(Sender: TObject);

    procedure SettingsChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure gbSizeChangeValue(Sender: TObject; Value: Integer);
  private
    FModuleId: string;
    FBarId: string;
    FUpdating: boolean;
    procedure PopulateMenus;
    procedure UpdateIcon;
  public
    property BarId: string read FBarId write FBarId;
    property ModuleId: string read FModuleId write FModuleId;

    procedure LoadSettings;
    procedure SaveSettings;
  end;

var
  frmEdit: TfrmEdit;

const
  colName = 0;

implementation

uses SharpThemeApi, SharpDialogs, SharpApi, SharpCenterApi, uSharpBarAPI, SharpESkin;

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

procedure TfrmEdit.btnBrowseClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.IconDialog('',
                               [smiCustomIcon,smiSharpEIcon],
                               ClientToScreen(point(btnIconBrowse.Left,btnIconBrowse.Top)));
  if length(trim(s))>0 then
  begin
    edIcon.Text := s;
    UpdateIcon;
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

  SharpThemeApi.FindFiles(files, GetSharpeUserSettingsPath + 'SharpMenu\','*.xml');

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
  if not (FUpdating) then
    CenterDefineSettingsChanged;
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  lblSizeDesc.Font.Color := clGrayText;
  lblMenuDesc.Font.Color := clGrayText;
  lblDisplayDesc.Font.Color := clGrayText;
end;

procedure TfrmEdit.gbSizeChangeValue(Sender: TObject; Value: Integer);
begin
  if not (FUpdating) then
    CenterDefineSettingsChanged;
end;

procedure TfrmEdit.LoadSettings;
var
  xml: TJclSimpleXML;
  fileloaded: boolean;
  showLabel, showIcon: boolean;
  icon, menu, caption, s: string;
  width: integer;
begin
  xml := TJclSimpleXML.Create;
  FUpdating := True;
  try
    fileloaded := False;
    try
      XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(StrToInt(FBarId), StrToInt(FModuleId)));
      fileloaded := True;
    except
    end;

    if fileloaded then
      with xml.Root.Items do
      begin
        PopulateMenus;

        // Width
        width := IntValue('Width', 100);
        gbSize.Value := width;

        // Show label
        showLabel := BoolValue('ShowLabel', true);
        chkDisplayCaption.Checked := showLabel;

        // Show icon
        showIcon := BoolValue('ShowIcon', true);
        chkDisplayIcon.Checked := showIcon;

        // Icon
        icon := Value('Icon','icon.mycomputer');
        edIcon.Text := icon;
        UpdateIcon;

        // Menu
        menu := Value('Menu','Menu.xml');
        s := PathRemoveExtension( ExtractFileName(menu) );
        cbMenu.ItemIndex := cbMenu.Items.IndexOf(s);

        // Caption
        caption := Value('Caption','Menu');
        edCaption.Text := caption;
      end;

  finally
    XML.Free;
    FUpdating := False;
  end;

end;

procedure TfrmEdit.SaveSettings;
var
  xml: TJclSimpleXML;
begin
  xml := TJclSimpleXML.Create;
  try
    xml.Root.Name := 'WeatherModuleSettings';
    with xml.Root.Items do
    begin

      // Width
      Add('Width',gbSize.Value);

      // Show label
      Add('ShowLabel',chkDisplayCaption.Checked);

      // Show icon
      Add('ShowIcon', chkDisplayIcon.Checked);

      // Icon
      Add('Icon', edIcon.Text);

      // Menu
      Add('Menu', cbMenu.Text);

      // Caption
      Add('Caption', edCaption.Text);
    end;

  finally
    XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(StrToInt(FBarId), StrToInt(FModuleId)));
    XML.Free;
  end;

end;

end.
