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

unit uModuleManagerListEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExControls, JvComponent, JvLabel, ImgList,
  PngImageList, JvExStdCtrls, JvEdit, JvValidateEdit, JvValidators,
  JvComponentBase, JvErrorIndicator, ExtCtrls, JvPageList, SharpApi,
  JclStrings, SharpCenterApi, GR32, GR32_Image;

type
  TfrmMMEdit = class(TForm)
    vals: TJvValidators;
    errorinc: TJvErrorIndicator;
    pilError: TPngImageList;
    plEdit: TJvPageList;
    pagEdit: TJvStandardPage;
    pagDelete: TJvStandardPage;
    Label2: TLabel;
    Label1: TJvLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Label3: TJvLabel;
    cobo_modules: TComboBox;
    JvLabel1: TJvLabel;
    cobo_position: TComboBox;
    Preview: TImage32;
    lbDescription: TJvLabel;
    lbAuthor: TJvLabel;
    procedure valBarNameValidate(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
    procedure cobo_modulesSelect(Sender: TObject);
    procedure cobo_positionChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cobo_modulesClick(Sender: TObject);
  private
    FModuleItem : TObject;
    { Private declarations }
  public
    { Public declarations }
    procedure BuildModuleList;
    procedure LoadModuleData;
    function ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM):Boolean;
    procedure ClearValidation;

    property ModuleItem: TObject read FModuleItem write FModuleItem;
  end;

var
  frmMMEdit: TfrmMMEdit;

implementation

uses
  uModuleManagerListWnd;

{$R *.dfm}

procedure TfrmMMEdit.BuildModuleList;
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
    cobo_Modules.Items.Add(s);
  until FindNext(sr) <> 0;
  FindClose(sr);

  cobo_Modules.ItemIndex := - 1;
end;

procedure TfrmMMEdit.LoadModuleData;
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
  if cobo_modules.ItemIndex < 0 then
    exit;

  lbDescription.Caption := 'No description available for this module';

  Dir := SharpApi.GetSharpeDirectory + 'Modules\';
  FName := Dir + cobo_modules.Text + '.dll';

  if FileExists(FName) then
  begin
    Bmp := TBitmap32.Create;
    GetModuleMetaData(FName, Bmp, moduleinfo, bHasPreview);

    lbDescription.Caption := moduleinfo.Description;
    lbAuthor.Caption := 'Version ' + moduleinfo.Version + ' by ' + moduleinfo.Author;
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

function TfrmMMEdit.ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
begin
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
    vals.ValidationSummary := nil;

    Result := vals.Validate;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TfrmMMEdit.cobo_modulesClick(Sender: TObject);
begin
  CenterDefineEditState(True);

  LoadModuleData;
end;

procedure TfrmMMEdit.cobo_modulesSelect(Sender: TObject);
begin
  CenterDefineEditState(True);

end;

procedure TfrmMMEdit.cobo_positionChange(Sender: TObject);
begin
  CenterDefineEditState(True);

end;

procedure TfrmMMEdit.FormShow(Sender: TObject);
begin
  BuildModuleList;
end;

procedure TfrmMMEdit.ClearValidation;
begin
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TfrmMMEdit.valBarNameValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
begin
  Valid := True;
end;

end.
