{
Source Name: SchemeEditWnd.pas
Description: Scheme Create/Edit Form
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

unit SchemeEditWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, JvSimpleXML, SharpEColorPicker;

type
  TSchemeEditForm = class(TForm)
    Panel1: TPanel;
    cpanel: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label5: TLabel;
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    FileName : String;
    procedure LoadFromFile;
    procedure ClearComponents;
  end;

var
  SchemeEditForm: TSchemeEditForm;

implementation

{$R *.dfm}

procedure TSchemeEditForm.ClearComponents;
var
  n : integer;
begin
  for n := cpanel.ComponentCount -1 downto 0 do
      cpanel.Components[n].Free;
end;

procedure TSchemeEditForm.LoadFromFile;
var
  XML : TJvSimpleXML;
  NameEdit, TagEdit, InfoEdit : TEdit;
  ColorPicker : TSharpEColorPicker;
  n,i :  integer;
begin
  ClearComponents;
  if not FileExists(FileName) then exit;

  i := 0;
  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(FileName);
    for n := 0 to XML.Root.Items.Count -1 do
        with XML.Root.Items.Item[n].Items do
        begin
          NameEdit := TEdit.Create(cpanel);
          NameEdit.Parent := cpanel;
          NameEdit.Width := 128;
          NameEdit.Left := 8;
          NameEdit.Top  := i + 8;
          NameEdit.Text := Value('Name','');
          TagEdit := TEdit.Create(cpanel);
          TagEdit.Parent := cpanel;
          TagEdit.Width := 128;
          TagEdit.Left := 8+128+8;
          TagEdit.Top  := i + 8;
          TagEdit.Text := Value('Tag','');
          InfoEdit := TEdit.Create(cpanel);
          InfoEdit.Parent := cpanel;
          InfoEdit.Width := 128;
          InfoEdit.Left := 8+128+8+128+8;
          InfoEdit.Top  := i + 8;
          InfoEdit.Text := Value('Info','');
          ColorPicker := TSharpEColorPicker.Create(cpanel);
          ColorPicker.Parent := cpanel;
          ColorPicker.Left := 8+128+8+128+8+128+16;
          ColorPicker.Top := i + 8;
          ColorPicker.Color := IntValue('Default',0);
          i := i + 32;
        end;
  except
  end;
  Height := i + 32 + 8 + Panel1.Height + Panel3.Height;
  XML.Free;
end;

procedure TSchemeEditForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearComponents;
end;

procedure TSchemeEditForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TSchemeEditForm.Button2Click(Sender: TObject);
var
  XML : TJvSimpleXML;
  n : integer;
begin
  XML := TJvSimpleXML.Create(nil);
  XML.Root.Name := 'SharpESkinScheme';
  XML.Root.Clear;
  for n := 0 to (cpanel.ComponentCount div 4)-1 do
  begin
    if (length(trim(TEdit(cpanel.Components[n*4]).Text)) <> 0)
       and (length(trim(TEdit(cpanel.Components[n*4+1]).Text)) <> 0) then
    begin
      with XML.Root.Items.Add('item').Items do
      begin
        Add('Name',TEdit(cpanel.Components[n*4]).Text);
        Add('Tag',TEdit(cpanel.Components[n*4+1]).Text);
        Add('Info',TEdit(cpanel.Components[n*4+2]).Text);
        Add('Default',TSharpEColorPicker(cpanel.Components[n*4+3]).Color);
      end;
    end;
  end;
  ForceDirectories(ExtractFileDir(FileName));
  XML.SaveToFile(FileName);
  XML.Free;
  Close;
end;

procedure TSchemeEditForm.Button3Click(Sender: TObject);
var
  NameEdit, TagEdit, InfoEdit : TEdit;
  ColorPicker : TSharpEColorPicker;
  i : integer;
begin
  if cpanel.ComponentCount = 0 then i := 8
     else i := TSharpEColorPicker(cpanel.Components[cpanel.ComponentCount-1]).top;
  i := i + 32;

  NameEdit := TEdit.Create(cpanel);
  NameEdit.Parent := cpanel;
  NameEdit.Width := 128;
  NameEdit.Left := 8;
  NameEdit.Top  := i;
  TagEdit := TEdit.Create(cpanel);
  TagEdit.Parent := cpanel;
  TagEdit.Width := 128;
  TagEdit.Left := 8+128+8;
  TagEdit.Top  := i;
  InfoEdit := TEdit.Create(cpanel);
  InfoEdit.Parent := cpanel;
  InfoEdit.Width := 128;
  InfoEdit.Left := 8+128+8+128+8;
  InfoEdit.Top  := i;
  ColorPicker := TSharpEColorPicker.Create(cpanel);
  ColorPicker.Parent := cpanel;
  ColorPicker.Left := 8+128+8+128+8+128+16;
  ColorPicker.Top := i;

  Height := i + 8 + 32 + 8 + Panel1.Height + Panel3.Height;
end;

end.
