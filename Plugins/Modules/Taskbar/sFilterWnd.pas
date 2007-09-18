{
Source Name: sFilterWnd
Description: ---
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
    procedure btn_deleteClick(Sender: TObject);
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
    EditFilterForm := TEditFilterForm.Create(application.MainForm);
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
    EditFilterForm := TEditFilterForm.Create(application.MainForm);
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

procedure Tsfilterform.btn_deleteClick(Sender: TObject);
var
  n : integer;
  XML : TJvSimpleXML;
  fn : string;
  b : boolean;
begin
  if list_filters.ItemIndex<0 then exit;
  if MessageBox(Handle,PChar('Do you really want to delete filter '+list_filters.Items[list_filters.Itemindex]),'Confirm',MB_YESNO) = mrNo then exit;

  fn := SharpApi.GetSharpeGlobalSettingsPath + 'SharpBar\Module Settings\TaskBar\';
  ForceDirectories(fn);
  fn := fn + 'Filters.xml';
  if not FileExists(fn) then exit;

  b := False;
  XML := TJvSimpleXMl.Create(nil);
  try
    XML.LoadFromFile(fn);
    for n := XML.Root.Items.Count - 1 downto 0 do
        if list_filters.Items[list_filters.Itemindex] = XML.Root.Items.Item[n].Items.Value('Name','Error reading XML data') then
           XML.Root.Items.Delete(n);
  except
    b := True;
  end;
  if not b then XML.SaveToFile(fn);
  XML.Free;

  UpdateFilterList;
end;

end.
