{
Source Name: SharpBarListEditWnd.pas
Description: SharpBarList Edit Window
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExControls, JvComponent, ImgList,
  PngImageList, JvExStdCtrls, JvEdit, JvValidateEdit, JvValidators,
  JvComponentBase, JvErrorIndicator, ExtCtrls, JvPageList, SharpApi,
  JclStrings, SharpCenterApi, GR32, GR32_Image,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TfrmEditWnd = class(TForm)
    Panel1: TPanel;
    cboModules: TComboBox;
    cboPosition: TComboBox;
    Preview: TImage32;
    lbDescription: TLabel;
    lbAuthor: TLabel;
    Label3: TLabel;
    JvLabel1: TLabel;

    procedure cboModulesSelect(Sender: TObject);
    procedure cboPositionChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cboModulesClick(Sender: TObject);
  private
    FPluginHost : ISharpCenterHost;
    FModuleItem : TObject;
    { Private declarations }
  public
    { Public declarations }
    procedure BuildModuleList;
    procedure LoadModuleData;

    property ModuleItem: TObject read FModuleItem write FModuleItem;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;

    procedure Init;
    procedure Save;
  end;

var
  frmEditWnd: TfrmEditWnd;

implementation

uses
  uListWnd;

{$R *.dfm}

procedure TfrmEditWnd.BuildModuleList;
var
  s : String;
  sr : TSearchRec;
  Dir : String;
begin
  Dir := SharpApi.GetSharpeDirectory + 'Modules\';
  if FindFirst(Dir + '*.dll',FAAnyFile,sr) = 0 then
  repeat
    s := sr.Name;
    setlength(s,length(s)-length(ExtractFileExt(s)));
    cboModules.Items.Add(s);
  until FindNext(sr) <> 0;
  FindClose(sr);

  cboModules.ItemIndex := -1;
  cboModules.Text := 'Please Select';

  LoadModuleData;

end;

procedure TfrmEditWnd.LoadModuleData;
var
  Dir : String;
  FName : String;
  moduleinfo : TMetaData;
  Bmp : TBitmap32;
  bHasPreview : Boolean;
begin
  lbDescription.Caption := '';
  lbAuthor.Visible := False;
  Preview.Visible := False;
  if cboModules.ItemIndex < 0 then
    exit;

  lbDescription.Caption := 'No description available for this module';

  Dir := SharpApi.GetSharpeDirectory + 'Modules\';
  FName := Dir + cboModules.Text + '.dll';

  if FileExists(FName) then
  begin
    Bmp := TBitmap32.Create;
    GetModuleMetaData(FName, Bmp, moduleinfo, bHasPreview);

    lbDescription.Caption := moduleinfo.Description;
    lbAuthor.Caption := 'Created by ' + moduleinfo.Author;
    lbAuthor.Visible := True;
    if bHasPreview then
    begin
      Preview.Bitmap.SetSize(Bmp.Width+2,Bmp.Height+2);
      Preview.Bitmap.Clear(clBlack32);
      Preview.Bitmap.Draw(1,1,Bmp);
      Preview.Visible := True;
      Preview.Top := 500;
    end;
    Bmp.Free;
  end;
end;

procedure TfrmEditWnd.Save;
var
  Dir: string;
  wnd: hwnd;
  msg: TSharpE_DataStruct;
  cds: TCopyDataStruct;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  case PluginHost.EditMode of
    sceAdd: begin
        wnd := FindWindow(nil, PChar('SharpBar_' + PluginHost.PluginId));
        if wnd <> 0 then begin
          msg.Handle := frmListWnd.Handle;
          msg.Module := frmEditWnd.cboModules.Text + '.dll';
          msg.LParam := BC_ADD;
          if frmEditWnd.cboPosition.ItemIndex = 0 then
            msg.RParam := -1
          else
            msg.RParam := 1;
          with cds do begin
            dwData := 0;
            cbData := SizeOf(TSharpE_DataStruct);
            lpData := @msg;
          end;
        end;
        SendMessage(wnd, WM_COPYDATA, WM_BARCOMMAND, Cardinal(@cds));
      end;
  end;

  FPluginHost.Refresh;
end;

procedure TfrmEditWnd.cboModulesClick(Sender: TObject);
begin
  FPluginHost.Editing := true;

  LoadModuleData;
end;

procedure TfrmEditWnd.cboModulesSelect(Sender: TObject);
begin
  FPluginHost.Editing := true;

end;

procedure TfrmEditWnd.cboPositionChange(Sender: TObject);
begin
  FPluginHost.Editing := true;

end;

procedure TfrmEditWnd.FormShow(Sender: TObject);
begin
  BuildModuleList;
end;

procedure TfrmEditWnd.Init;
begin

end;

end.
