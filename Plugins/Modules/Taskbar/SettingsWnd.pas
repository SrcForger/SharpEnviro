{
Source Name: SettingsWnd.pas
Description: TaskBar Module Settings Form
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
 - OS : Windows XP

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

unit SettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, SharpApi, ExtCtrls,
  CheckLst, JvSimpleXML;

type
  TSettingsForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    cb_tsfull: TRadioButton;
    cb_tscompact: TRadioButton;
    cb_tsminimal: TRadioButton;
    Panel1: TPanel;
    cb_sort: TCheckBox;
    rb_caption: TRadioButton;
    rb_wndclassname: TRadioButton;
    rb_timeadded: TRadioButton;
    rb_icon: TRadioButton;
    Button3: TButton;
    list_include: TCheckListBox;
    rb_ifilter: TCheckBox;
    list_exclude: TCheckListBox;
    rb_efilter: TCheckBox;
    cb_minall: TCheckBox;
    cb_maxall: TCheckBox;
    cb_debug: TCheckBox;
    Label2: TLabel;
    procedure rb_efilterClick(Sender: TObject);
    procedure rb_ifilterClick(Sender: TObject);
    procedure cb_sortClick(Sender: TObject);
    procedure list_excludeClickCheck(Sender: TObject);
    procedure list_includeClickCheck(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
    procedure UpdateFilterList;
    procedure UpdateStates;
  end;


implementation

uses sFilterWnd;

{$R *.dfm}

procedure TSettingsForm.UpdateStates;
begin
  if cb_sort.Checked then
  begin
    rb_caption.Enabled := True;
    rb_wndclassname.Enabled := True;
    rb_timeadded.Enabled := True;
    rb_icon.Enabled := True;
  end else
  begin
    rb_caption.Enabled := False;
    rb_wndclassname.Enabled := False;
    rb_timeadded.Enabled := False;
    rb_icon.Enabled := False;
  end;

  if rb_ifilter.Checked then list_include.Enabled := True
     else list_include.Enabled := False;

  if rb_efilter.Checked then list_exclude.Enabled := True
     else list_exclude.Enabled := False;
end;

procedure TSettingsForm.UpdateFilterList;
var
  n,i : integer;
  XML : TJvSimpleXML;
  SListI,SListE : TStringList;
  fn : string;
begin
  fn := SharpApi.GetSharpeGlobalSettingsPath + 'SharpBar\Module Settings\TaskBar\';
  ForceDirectories(fn);
  fn := fn + 'Filters.xml';
  if not FileExists(fn) then exit;

  SListI := TStringList.Create;
  SListE := TStringList.Create;

  SListI.Clear;
  SListE.Clear;
  // copy the current checked items
  for n := 0 to list_include.Items.Count - 1 do
      if list_include.Checked[n] then SListI.Add(list_include.Items[n]);
  for n := 0 to list_exclude.Items.Count - 1 do
      if list_exclude.Checked[n] then SListE.Add(list_exclude.Items[n]);
  list_include.Clear;
  list_exclude.Clear;

  XML := TJvSimpleXMl.Create(nil);
  try
    XML.LoadFromFile(fn);
    for n := 0 to XML.Root.Items.Count - 1 do
        list_include.items.add(XML.Root.Items.Item[n].Items.Value('Name','Error reading XML data'));
  except
  end;
  for n := 0 to list_include.Count - 1 do
      list_exclude.Items.Add(list_include.Items[n]);

  // check for previous checked items and check them again
  for n := 0 to SListI.Count - 1 do
  begin
    i := list_include.Items.IndexOf(SListI[n]);
    if i >=0 then list_include.Checked[i] := True
  end;
  for n := 0 to SListE.Count - 1 do
  begin
    i := list_exclude.Items.IndexOf(SListE[n]);
    if i >=0 then list_exclude.Checked[i] := True
  end;

  SListI.Free;
  SListE.Free;
  XML.Free;
end;

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  self.ModalResult := mrOk;
end;

procedure TSettingsForm.Button2Click(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TSettingsForm.Button3Click(Sender: TObject);
begin
  try
    sFilterForm := TsFilterForm.Create(nil);
    sFilterForm.ShowModal;
  finally
    FreeAndNil(sFilterForm);
  end;
  UpdateFilterList;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  UpdateFilterList;
  UpdateStates;
end;

procedure TSettingsForm.list_includeClickCheck(Sender: TObject);
var
  n : integer;
begin
  for n := 0 to list_include.Count - 1 do
      if list_include.Checked[n] then list_exclude.Checked[n] := False;
end;

procedure TSettingsForm.list_excludeClickCheck(Sender: TObject);
var
  n : integer;
begin
  for n := 0 to list_exclude.Count - 1 do
      if list_exclude.Checked[n] then list_include.Checked[n] := False;
end;

procedure TSettingsForm.cb_sortClick(Sender: TObject);
begin
  UpdateStates;
end;

procedure TSettingsForm.rb_ifilterClick(Sender: TObject);
begin
  UpdateStates;
end;

procedure TSettingsForm.rb_efilterClick(Sender: TObject);
begin
  UpdateStates;
end;

end.
