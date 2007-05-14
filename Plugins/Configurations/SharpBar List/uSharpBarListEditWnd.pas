{
Source Name: SharpBarListEditWnd.pas
Description: SharpBarList Edit Window
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

unit uSharpBarListEditWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExControls, JvComponent, JvLabel, ImgList,
  PngImageList, JvExStdCtrls, JvEdit, JvValidateEdit, JvValidators,
  JvComponentBase, JvErrorIndicator, ExtCtrls, JvPageList, SharpApi,
  JclStrings;

type
  TfrmEditItem = class(TForm)
    vals: TJvValidators;
    errorinc: TJvErrorIndicator;
    pilError: TPngImageList;
    plEdit: TJvPageList;
    pagEdit: TJvStandardPage;
    edName: TLabeledEdit;
    Label3: TJvLabel;
    cbBasedOn: TComboBox;
    pagDelete: TJvStandardPage;
    Label2: TLabel;
    Label1: TJvLabel;
    cobo_monitor: TComboBox;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    cobo_valign: TComboBox;
    cobo_halign: TComboBox;
    JvLabel3: TJvLabel;
    valBarName: TJvCustomValidator;
    Label4: TLabel;
    pagBarSpace: TJvStandardPage;
    Label5: TLabel;
    JvLabel4: TJvLabel;
    Label6: TLabel;
    procedure valBarNameValidate(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
    procedure cbBasedOnSelect(Sender: TObject);

    procedure edThemeNameKeyPress(Sender: TObject; var Key: Char);
  private
    FBarItem : TObject;
    { Private declarations }
  public
    { Public declarations }
    procedure BuildMonList;
    function ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM):Boolean;
    procedure ClearValidation;

    property BarItem: TObject read FBarItem write FBarItem;

  end;

var
  frmEditItem: TfrmEditItem;

implementation

uses
  uSharpBarListWnd;

{$R *.dfm}

procedure TfrmEditItem.BuildMonList;
var
  n : integer;
  s : String;
  Mon : TMonitor;
begin
  cobo_monitor.Clear;
  for n := 0 to Screen.MonitorCount - 1 do
  begin
    Mon := Screen.Monitors[n];
    if Mon.Primary then
       s := 'Primary'
       else s := inttostr(Mon.MonitorNum);
    s := s + ' (' + inttostr(Mon.Width) + 'x' + inttostr(Mon.Height) + ')';
    cobo_monitor.Items.Add(s);
    if Mon.Primary then
       cobo_monitor.Items.Move(n,0);
  end;
end;

procedure TfrmEditItem.edThemeNameKeyPress(Sender: TObject; var Key: Char);
begin
  SharpEBroadCast(WM_SHARPCENTERMESSAGE,SCM_SET_EDIT_STATE,0);
  frmBarList.lbBarList.Enabled := False;
end;

function TfrmEditItem.ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
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

procedure TfrmEditItem.cbBasedOnSelect(Sender: TObject);
begin
  SharpEBroadCast(WM_SHARPCENTERMESSAGE,SCM_SET_EDIT_STATE,0);
  frmBarList.lbBarList.Enabled := False;
end;

procedure TfrmEditItem.ClearValidation;
begin
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TfrmEditItem.valBarNameValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  n : integer;
begin
  if (plEdit.ActivePage = pagDelete) or (plEdit.ActivePage = pagBarSpace) then
  begin
    Valid := True;
    exit;
  end;

  if length(trim(ValueToValidate)) = 0 then
  begin             
    valBarName.ErrorMessage := 'Please enter a valid name!';
    Valid := False;
    exit;
  end;

  for n := 0 to frmBarList.lbBarList.Count - 1 do
      if BarItem <> TBarItem(frmBarList.lbBarList.Item[n].Data) then
         if CompareText(frmBarList.lbBarList.Item[n].SubItemText[1],ValueToValidate) = 0 then
         begin
           valBarName.ErrorMessage := 'Another Bar with the same name already exists!';
           Valid := False;
           exit;
         end;

  Valid := True;
end;

end.
