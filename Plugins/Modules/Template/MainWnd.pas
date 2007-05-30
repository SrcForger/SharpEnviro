{
Source Name: MainWnd.pas
Description: SharpE Bar Module - Main Window
Copyright (C) Author <E-Mail>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
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

unit MainWnd;

interface

uses
  // Default Units
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, Math,
  // Custom Units
  JvSimpleXML, GR32,
  // SharpE Units
  SharpApi, uSharpBarAPI, SharpEBaseControls, SharpESkin, SharpEScheme,
  SharpESkinManager;

type
  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    MenuSettingsItem: TMenuItem;
    SkinManager: TSharpESkinManager;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuSettingsItemClick(Sender: TObject);
  protected
  private
    // Declare your settings for the module directly in the class! (NO global vars!)
    // Example:
    // sWidth : integer;
  public
    ModuleID : integer;
    BarWnd : hWnd;
    Background : TBitmap32;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure SetWidth(new : integer);
    procedure UpdateBackground(new : integer = -1);
  end;

// Skin Manager!
// The SkinManager Component is the most important component of the Window
// It gives access to the current skin and scheme.
// If you are using any SharpE Skin Component then just drop it onto the Form
// and change it's SkinManager property to the SkinManager component


implementation

uses SettingsWnd;

{$R *.dfm}

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    // Load your settings heare
    // Example: sWidth := IntValue('Width',sWidth);
  end;
end;

procedure TMainForm.UpdateBackground(new : integer = -1);
begin
  if (new <> -1) then
     Background.SetSize(new,Height)
     else if (Width <> Background.Width) then
              Background.Setsize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background,self,Background.Width);
end;

procedure TMainForm.SetWidth(new : integer);
begin
  // The Module is receiving it's new size from the SharpBar!
  // Make sure the new width is not negative or zero
  new := Max(new,1);

  // Update the Background Bitmap!
  UpdateBackground(new);

  // Background is updated, now resize the form
  Width := new;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  // The caption of the module is the description in the module manager!
  self.Caption := 'My Module' ;

  newWidth := 100;

  // DO NOT set the size of the form directly in this procedure!
  // The Size of the Module is set by SharpBar when the modules SetSize function is called!
  // The Tag Param of the Form is the MINIMUM size of the module
  // The Hint Param of the Form is the MAXIMUM size of the module
  // If you don't want your module to change it's size dynamicly then just make
  // Tag = Hin
  self.Tag := NewWidth;
  self.Hint := inttostr(NewWidth);

  // Send a message to the bar that the module is requesting a width update
  if (BroadCast) and (newWidth <> Width) then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;


procedure TMainForm.MenuSettingsItemClick(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
    // Update the Settings form now...
    // (Load the current settings into the SettingsForm)
    // Example:
    // SettingsForm.MyControl.SomeSetting := sSomeSetting;
    // ...

    if SettingsForm.ShowModal = mrOk then
    begin
      // Update the settings vars from the SettingsForm now...
      // Example:
      // sSomeSettings := SettingsForm.MyControl.SomeSettings;
      // ...

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        Clear;
        // Save the settings to this XML item!
        // it's recommend to just Clear the item and add the settings again!
        // Example:
        // Add('Width',sWidth);
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
    end;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
  end;
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  Background := TBitmap32.Create;
  DoubleBuffered := True;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Background.Free;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Background.DrawTo(Canvas.Handle,0,0);
end;

end.
