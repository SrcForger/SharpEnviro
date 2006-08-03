{
Source Name: uSharpDeskAdvancedSettnigsForm.pas
Description: Advanced XML settings Form for editing all xml properties directly
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
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

unit uSharpDeskAdvancedSettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, SharpApi, StdCtrls, JvSimpleXML,
  GR32_Layers, SharpDeskApi,
  uSharpDeskDesktopObject;

type
  TASettingsForm = class(TForm)
    img1: TImage;
    lb_theme: TLabel;
    lbl1: TLabel;
    List: TStringGrid;
    Panel2: TPanel;
    Panel1: TPanel;
    btn_Change: TButton;
    btn_close: TButton;
    procedure FormShow(Sender: TObject);
    procedure ListSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure ListSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btn_ChangeClick(Sender: TObject);
    procedure btn_closeClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
//    procedure Load(pObjectID,pPackageIndex : integer);
    procedure Load(pDesktopObject : TDesktopObject);
  end;

var
  ASettingsForm: TASettingsForm;
  cs : TColorScheme;
  DesktopObject : TDesktopObject;

const
     DESK_SETTINGS = 'Settings\SharpDesk\SharpDesk.xml';
     THEME_SETTINGS = 'Settings\SharpTheme\Themes.xml';
     OBJECT_SETTINGS = 'Settings\SharpDesk\Objects.xml';   

implementation

uses uSharpDeskMainForm,
     uSharpDeskFunctions;

{$R *.dfm}

procedure TASettingsForm.Load(pDesktopObject : TDesktopObject);
var
   n : integer;
   pass, j: integer;
   hold: TStringList;
   fn : string;
   sfile : string;
   XML : TJvSimpleXML;
begin
  if pDesktopObject = nil then exit;
  DesktopObject := pDesktopObject;

  List.RowCount:=0;
  List.FixedCols:=1;

  fn := DesktopObject.Settings.ObjectFile;
  setlength(fn,length(fn)-length(SharpDesk.ObjectExt));
  sfile := SharpApi.GetSharpeUserSettingsPath +  'SharpDesk\Objects\'
           + fn + '\' + inttostr(DesktopObject.Settings.ObjectID)
           +'.xml';

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(sfile);
  except
    XML.Root.Clear;
  end;

  for n:=0 to XML.Root.Items.Count - 1 do
      with XML.Root.Items do
      begin
        List.RowCount:=List.RowCount+1;
        List.Cells[0,List.RowCount-2]:=Item[n].Name;
        List.Cells[1,List.RowCount-2]:=Item[n].Value;
        if Item[n].Items.Count>0 then List.Cells[1,List.RowCount-2]:='{Child Items}';
      end;

  XML.Free;

  List.RowCount:=List.RowCount-1;

  hold := TStringList.Create;
  for pass := 1 to List.RowCount - 1 do
       for j := 0 to List.RowCount - 2 do
           if List.Cells[0, j] > List.Cells[0, j + 1] then
           begin
             hold.Assign(List.Rows[j]);
             List.Rows[j].Assign(List.Rows[j + 1]);
             List.Rows[j + 1].Assign(hold);
           end;
  hold.Free;
end;

procedure TASettingsForm.FormShow(Sender: TObject);
var
  n : integer;
begin
  List.ColWidths[0]:=100;
  List.ColWidths[1]:=284;
  n := GetCurrentMonitor;
  self.Left:=Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - self.Width div 2;
  self.top:=Screen.Monitors[n].Top + Screen.Monitors[n].Height div 2 - self.Height div 2;
end;

procedure TASettingsForm.ListSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
     if (List.Cells[0,ARow]=UPPERCASE('OBJECTFILE'))
        or (List.Cells[1,ARow]='{Child Items}') then exit;
end;

procedure TASettingsForm.ListSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
     if (UPPERCASE(List.Cells[0,ARow])='OBJECTFILE')
        or (List.Cells[1,ARow]='{Child Items}') then CanSelect:=False;
end;

procedure TASettingsForm.btn_ChangeClick(Sender: TObject);
var
   n : integer;
   XML : TJvSimpleXML;
   fn : string;
   sfile : string;
begin
  if DesktopObject = nil then exit;

  fn := DesktopObject.Settings.ObjectFile;
  setlength(fn,length(fn)-length(SharpDesk.ObjectExt));
  sfile := SharpApi.GetSharpeUserSettingsPath +  'SharpDesk\Objects\'
           + fn + '\' + inttostr(DesktopObject.Settings.ObjectID)
           +'.xml';

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(sfile);
  except
    XML.Root.Clear;
  end;

  with XML.Root.Items do
  begin
    for n:=0 to Count-1 do
    begin
      if Item[n].Items.Count<=0 then
         Item[n].Value:=List.Cells[1,List.Cols[0].IndexOf(Item[n].Name)];
    end;
  end;
  XML.SaveToFile(sfile);
  XML.Free;
  DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                          DesktopObject.Layer,
                                          SDM_REPAINT_LAYER,0,0,0);
  Close;
end;

procedure TASettingsForm.btn_closeClick(Sender: TObject);
begin
     ASettingsForm.Close;
end;

end.
