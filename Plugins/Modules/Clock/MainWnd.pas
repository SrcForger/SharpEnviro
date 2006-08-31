{
Source Name: MainWnd
Description: Clock module main window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32_Image, SharpEBaseControls, SharpEButton,
  SharpESkinManager, SharpEScheme, SharpESkin, ExtCtrls, SharpEProgressBar,
  JvSimpleXML, SharpApi, Jclsysinfo, Menus, Math, SharpEEdit, SharpELabel;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    lb_clock: TSharpELabel;
    ClockTimer: TTimer;
    procedure lb_clockDblClick(Sender: TObject);
    procedure ClockTimerTimer(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sFormat : String;
    sStyle  : TSharpELabelStyle;
  public
    ModuleID : integer;
    BarWnd   : hWnd;
    procedure LoadSettings;
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(BroadCast : boolean);
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI;

{$R *.dfm}

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  SharpApi.RegisterActionEx(PChar('!FocusMiniScmd ('+inttostr(ModuleID)+')'),'Modules',self.Handle,1);

  sFormat := 'HH:MM:SS';
  sStyle  := lsMedium;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sFormat := Value('Format','HH:MM:SS');
    case IntValue('Style',1) of
      0: sStyle := lsSmall;
      2: sStyle := lsBig;
      else sStyle := lsMedium
    end;
  end;
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
  Width := NewWidth;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  self.Caption := sFormat;
  ClockTimer.OnTimer(ClockTimer);

  newWidth := lb_clock.Canvas.TextWidth(sFormat)+4;
  Tag := newWidth;
  Hint := inttostr(NewWidth);
  if newWidth <> width then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);

end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
    SettingsForm.edit_format.Text := sFormat;
    case sStyle of
      lsSmall  : SettingsForm.cb_small.Checked := True;
      lsMedium : SettingsForm.cb_medium.Checked := True;
      lsBig    : SettingsForm.cb_large.Checked := True;
    end;

    if SettingsForm.ShowModal = mrOk then
    begin
      sFormat  := SettingsForm.edit_format.Text;
      if SettingsForm.cb_small.Checked then sStyle := lsSmall
         else if SettingsForm.cb_large.Checked then sStyle := lsBig
              else sStyle := lsMedium;

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        clear;
        Add('Format',sFormat);
        case sStyle of
          lsSmall  : Add('Style',0);
          lsMedium : Add('Style',1);
          lsBig    : Add('Style',2);
       end;
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
      ClockTimer.OnTimer(ClockTimer);
    end;
    ReAlignComponents(True);

  finally
    SettingsForm.Free;
    SettingsForm := nil;
  end;
end;

procedure TMainForm.ClockTimerTimer(Sender: TObject);
var
  s : string;
begin
  if lb_clock.LabelStyle <> sStyle then
  begin
    lb_clock.LabelStyle := sStyle;
    RealignComponents(True);
  end;
  DateTimeToString(s,sFormat,now());
  lb_clock.Caption := s;
end;

procedure TMainForm.lb_clockDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute('timedate.cpl');
end;

end.
