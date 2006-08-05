{
Source Name: sFilterWnd
Description: ---
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

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

unit sFilterWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXML;

type
  Tsfilterform = class(TForm)
    list_filters: TListBox;
    btn_new: TButton;
    btn_edit: TButton;
    btn_delete: TButton;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure list_filtersClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_newClick(Sender: TObject);
  private
  public
    procedure UpdateFilterList;
    procedure UpdateButtonStates;
  end;

var
  sfilterform: Tsfilterform;

implementation

uses EditFilterWmd, SharpAPI;

{$R *.dfm}

procedure Tsfilterform.UpdateButtonStates;
begin
  if list_filters.ItemIndex <0 then
  begin
    btn_edit.Enabled := False;
    btn_delete.Enabled := False;
  end else
  begin
    btn_edit.Enabled := True;
    btn_delete.Enabled := True;
  end;
end;

procedure Tsfilterform.UpdateFilterList;
var
  n : integer;
  XML : TJvSimpleXML;
  fn : string;
begin
  list_filters.Clear;
  fn := SharpApi.GetSharpeGlobalSettingsPath + 'SharpBar\Module Settings\TaskBar\';
  ForceDirectories(fn);
  fn := fn + 'Filters.xml';
  if not FileExists(fn) then exit;

  XML := TJvSimpleXMl.Create(nil);
  try
    XML.LoadFromFile(fn);
    for n := 0 to XML.Root.Items.Count - 1 do
        list_filters.items.add(XML.Root.Items.Item[n].Items.Value('Name','Error reading XML data'));
  except
  end;
  XML.Free;
end;

procedure Tsfilterform.btn_newClick(Sender: TObject);
begin
  try
    EditFilterForm := TEditFilterForm.Create(nil);
    EditFilterForm.showmodal;
  finally
    FreeAndNil(EditFilterForm);
  end;
  UpdateFilterList;
  UpdateButtonStates;
end;

procedure Tsfilterform.FormShow(Sender: TObject);
begin
  UpdateFilterList;
  UpdateButtonStates;
end;

procedure Tsfilterform.btn_editClick(Sender: TObject);
begin
  if list_filters.ItemIndex <0 then exit;
  try
    EditFilterForm := TEditFilterForm.Create(nil);
    EditFilterForm.LoadFromXML(list_filters.Items[list_filters.Itemindex]);
    EditFilterForm.showmodal;
  finally
    FreeAndNil(EditFilterForm);
  end;
  UpdateFilterList;
  UpdateButtonStates;
end;

procedure Tsfilterform.list_filtersClick(Sender: TObject);
begin
  UpdateButtonStates;
end;

procedure Tsfilterform.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
