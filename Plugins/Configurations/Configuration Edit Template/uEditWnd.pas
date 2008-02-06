{
Source Name: uEditWnd.pas
Description: <Type> Items Edit window
Copyright (C) <Author> (<Email>)

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
  // Standard
  Windows,
  Messages,
  SysUtils,
  Forms,
  Variants,
  Classes,
  ImgList,
  Controls,
  Graphics,

  // SharpE
  SharpApi,
  SharpCenterApi,

  // Jedi
  JvExControls,
  JvErrorIndicator,
  JvValidators,
  JvComponentBase,

  // PngImage
  PngImageList;

type
  TfrmEdit = class(TForm)
    vals: TJvValidators;
    pilError: TPngImageList;
    eiVals: TJvErrorIndicator;

    procedure UpdateEditState(Sender: TObject);

  private
    { Private declarations }
    FUpdating: Boolean;
    FEditMode: TSCE_EDITMODE_ENUM;
  public
    { Public declarations }

    procedure InitUi(AEditMode: TSCE_EDITMODE_ENUM; AChangePage: Boolean = False);
    function ValidateEdit(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
    procedure ClearValidation;
    function Save(AApply: Boolean; AEditMode: TSCE_EDITMODE_ENUM): Boolean;

    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
  end;

var
  frmEdit: TfrmEdit;

implementation

uses
  uListWnd;

{$R *.dfm}

procedure TfrmEdit.InitUi(AEditMode: TSCE_EDITMODE_ENUM;
  AChangePage: Boolean = False);
begin
  FUpdating := True;
  try

    case AEditMode of
      sceAdd: begin

        end;
      sceEdit: begin

        end;
    end;

  finally
    FUpdating := False;
  end;
end;

procedure TfrmEdit.ClearValidation;
begin
  eiVals.BeginUpdate;
  try
    eiVals.ClearErrors;
  finally
    eiVals.EndUpdate;
  end;
end;

function TfrmEdit.ValidateEdit(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
begin
  Result := False;

  case AEditMode of
    sceAdd, sceEdit: begin

        eiVals.BeginUpdate;
        try
          eiVals.ClearErrors;
          vals.ValidationSummary := nil;

          Result := vals.Validate;
        finally
          eiVals.EndUpdate;
        end;
      end;
    sceDelete: Result := True;
  end;
end;

function TfrmEdit.Save(AApply: Boolean;
  AEditMode: TSCE_EDITMODE_ENUM): Boolean;
begin
  Result := false;
  if not (AApply) then
    Exit;

  case AEditMode of
    sceAdd: begin
        Result := True;
      end;
    sceEdit: begin
        Result := True;
      end;
  end;

  frmList.RenderItems;
  CenterUpdateConfigFull;
end;

procedure TfrmEdit.UpdateEditState(Sender: TObject);
begin
  if Not(FUpdating) then
    CenterDefineEditState(True);
end;

end.

