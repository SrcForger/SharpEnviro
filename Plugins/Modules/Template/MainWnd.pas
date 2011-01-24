{
Source Name: MainWnd
Description: Alarm Clock module main window
Copyright (C) Mathias Tillman <mathias@sharpenviro.com>

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

unit MainWnd;

interface

uses
  Windows, SysUtils, Classes, Forms, Dialogs, Types, DateUtils, SharpIconUtils,
  uISharpBarModule, ISharpESkinComponents, JclShell, Graphics,
  SharpApi, SharpCenterApi, Menus, SharpEButton, ExtCtrls, SharpEBaseControls, Controls,
  GR32, GR32_PNG, GR32_Image, JclSimpleXML, IXmlBaseUnit,
  PngImageList;

type
  TMainForm = class(TForm)
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  public
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure ReAlignComponents(Broadcast : boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure LoadIcons;

  end;


implementation

uses
  uSharpXMLUtils;

{$R *.dfm}

{TMainForm}

procedure TMainForm.LoadIcons;
begin

end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  n : integer;
begin
  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    with XML.Root.Items do
    begin
      for n := 0 to Count - 1 do
      with XML.Root.Items.Item[n].Items do
      begin
        if XML.Root.Items.Item[n].Name = 'Settings' then
        begin
          // Settings go here
        end;
      end;
    end;
  XML.Free;

  LoadIcons;
end;

procedure TMainForm.SaveSettings;
var
  XML : TJclSimpleXML;
begin
  XML := TJclSimpleXML.Create;
  with XML.Root do
  begin
    Name := 'Template';

    // Clear the list so we don't get duplicates.
    Items.Clear;

    Items.Add('Settings');
    with Items.ItemNamed['Settings'].Items do
    begin
      // Add('Name', Value);
    end;
  end;

  if not SaveXMLToSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    SharpApi.SendDebugMessageEx('Template',PChar('Failed to Save settings to File: ' + mInterface.BarInterface.GetModuleXMLFile(mInterface.ID)),clred,DMT_ERROR);

  XML.Free;
end;

procedure TMainForm.UpdateComponentSkins;
begin
  //button.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.UpdateSize;
begin
  Repaint;
end;

procedure TMainForm.ReAlignComponents(Broadcast : boolean = True);
var
  newWidth : integer;
begin
  self.Caption := 'Template';

  newWidth := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;

  if (newWidth <> Width) and (Broadcast) then
    mInterface.BarInterface.UpdateModuleSize
  else
    UpdateSize;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  // Save settings
  SaveSettings;
end;

procedure TMainForm.FormPaint(Sender: TObject);
var
  Bmp : TBitmap32;
begin
  Bmp := TBitmap32.Create;
  Bmp.Assign(mInterface.Background);

  Bmp.DrawTo(Canvas.Handle,0,0);
  Bmp.Free;
end;

end.
