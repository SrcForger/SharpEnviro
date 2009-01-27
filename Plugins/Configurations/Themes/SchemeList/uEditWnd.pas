{
Source Name: uEditSchemeWnd
Description: Edit/Create Scheme Window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  ExtCtrls,
  SharpeColorEditorEx,
  ContNrs,
  uSchemeList,
  SharpERoundPanel,
  JclIniFiles,
  SharpApi,
  SharpCenterApi,
  SharpThemeApiEx,
  SharpESwatchManager,
  SharpEColorEditor, ImgList, PngImageList, JvComponentBase,
  ISharpCenterHostUnit;

type
  TfrmEditWnd = class(TForm)
    edAuthor: TLabeledEdit;
    edName: TLabeledEdit;

    procedure FormCreate(Sender: TObject);
    procedure EditChange(Sender: TObject);

  private
    FUpdating: boolean;
    FSchemeItem: TSchemeItem;
    FSelectedColorIdx: Integer;
    FPluginHost: TInterfacedSharpCenterHostBase;
  public
    property SchemeItem: TSchemeItem read FSchemeItem write FSchemeItem;

    procedure InitUI;
    procedure Save;

    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmEditWnd: TfrmEditWnd;

implementation

uses JclStrings,
  uListWnd;

{$R *.dfm}

procedure TfrmEditWnd.EditChange(Sender: TObject);
begin
  if Not(FUpdating) then
    FPluginHost.SetEditing(true);
end;

procedure TfrmEditWnd.FormCreate(Sender: TObject);
begin
  FSelectedColorIdx := 0;
end;

procedure TfrmEditWnd.InitUI;
var
  df:TSC_DEFAULT_FIELDS;
  tmpItem, lstItem: TSchemeItem;
begin
  FUpdating := True;
  try
  case FPluginHost.EditMode of
    sceAdd: begin

        CenterReadDefaults(df);
        tmpItem := TSchemeItem.Create(nil);

        edName.Text := '';
        edAuthor.Text := df.Author;
        SchemeItem := tmpItem;
      end;
    sceEdit: begin

        if frmListWnd.lbSchemeList.SelectedItem = nil then exit;

        lstItem := TSchemeItem(frmListWnd.lbSchemeList.SelectedItem.Data);

        tmpItem := TSchemeItem.Create(nil);
        tmpItem.Name := lstItem.Name;
        tmpItem.Author := lstItem.Author;

        edName.Text := tmpItem.Name;
        edAuthor.Text := tmpItem.Author;
        SchemeItem := tmpItem;

      end;
  end;
  finally
    FUpdating := False;
  end;
end;

procedure TfrmEditWnd.Save;
var
  scheme: TSchemeItem;
  sOriginalName: string;
  df:TSC_DEFAULT_FIELDS;
begin

  case FPluginHost.EditMode of
    sceAdd: begin

        FSchemeItem.Name := edName.Text;
        FSchemeItem.Author := edAuthor.Text;
        FSchemeManager.Save(edName.Text, edAuthor.Text);
        FSchemeItem.Free;

        CenterReadDefaults(df);
        df.Author := edAuthor.Text;
        CenterWriteDefaults(df);

        frmListWnd.EditScheme(edName.Text);
        Exit;
      end;
    sceEdit: begin

          scheme := TSchemeItem(frmListWnd.lbSchemeList.SelectedItem.Data);
          sOriginalName := scheme.Name;

          FSchemeManager.Save(edName.Text, edAuthor.Text, sOriginalName);

          if Not(CompareText(edName.Text,sOriginalName) = 0) then
            FSchemeManager.Delete(scheme);

          scheme.Name := edName.Text;
          scheme.Author := edAuthor.Text;

        SharpEBroadCast(WM_SHARPEUPDATESETTINGS, Integer(suScheme), 0);
      end;
  end;

  frmListWnd.RebuildSchemeList;
end;

end.

