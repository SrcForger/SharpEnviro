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
  // SharpE API Units
  SharpApi, uSharpBarAPI,
  // SharpE Skin Units
  SharpESkin, SharpESkinManager, SharpEButton;

type
  TMainForm = class(TForm)
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
  private
    // Events
    procedure ButtonOnClick(Sender: TObject);

    // Declare your settings for the module directly in the class! (NO global vars!)
    // Example:
    // sWidth : integer;
  public
    // visual components
    SkinManager : TSharpESkinManager;
    Button: TSharpEButton;

    // vars and functions
    ModuleID : integer;
    BarID : integer;
    BarWnd : hWnd;
    Background : TBitmap32;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure SetWidth(new : integer);
    procedure UpdateBackground(new : integer = -1);
    procedure ShowSettingsWindow;    
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
  XML : TJvSimpleXML;
  fileloaded : boolean;
begin
  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with XML.Root.Items do
    begin
      // Load your settings heare
      // Example: sWidth := IntValue('Width',sWidth);
    end;
  XML.Free;
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

  // Align the Components
  Button.Left := 2;
  Button.Width := Width - 4;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  // The caption of the module is the description in the module manager!
  self.Caption := 'My Module' ;

  newWidth := Button.GetTextWidth + 16;

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


procedure TMainForm.ShowSettingsWindow;
var
  SettingsForm : TSettingsForm;
  XML : TJvSimpleXML;
begin
  try
    SettingsForm := TSettingsForm.Create(application.MainForm);
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

      XML := TJvSimpleXML.Create(nil);
      XML.Root.Name := 'TemplateModuleModuleSettings';
      with XML.Root.Items do
      begin
        // Save the settings to this XML item!
        // it's recommend to just Clear the item and add the settings again!
        // Example:
        // Add('Width',sWidth);
      end;
      XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
      XML.Free;
    end;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
  end;
end;


procedure TMainForm.ButtonOnClick(Sender: TObject);
begin
  // what happens if the button is clicked...
  ShowMessage('Click!');
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;

  // Create all clases
  Background := TBitmap32.Create;

  // Create all visual components
  // The second param of TSharpESkinManager.Create defines which parts of the
  // current skin to load. If you want to use other skin components than the
  // button then you have add those to this param.
  // for example if you want to use a button and a progressbar:
  // SkinManager := TSharpESkinManager.Create(nil,[scButton,scProgressBar]);
  SkinManager := TSharpESkinManager.Create(nil,[scButton]);
  SkinManager.SkinSource := ssSystem;  // load the global skin
  SkinManager.SchemeSource := ssSystem;// load the global scheme
  SkinManager.HandleUpdates := False;  // don't react on global window messages

  Button := TSharpEButton.Create(self);
  Button.SkinManager := SkinManager;   // Assign the SkinManager to the button
  Button.Caption := 'My SharpE Module';
  Button.AutoSize := True;             // height and top position of the button
  Button.AutoPosition := True;         // will be auto changed to the skin values
  Button.OnClick := ButtonOnClick;     // assign the OnClick event to the button
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  // Free all clasess
  Background.Free;

  // Free all Components
  Button.Free;
  SkinManager.Free;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Background.DrawTo(Canvas.Handle,0,0);
end;

end.
