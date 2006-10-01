{
Source Name: MainWnd
Description: Memory Monitor Module - Main Window
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
  JvSimpleXML, SharpApi, Jclsysinfo, Menus, SharpELabel, Math, SharpESkinLabel;


type
  TMainForm = class(TForm)
    Background: TImage32;
    rambar: TSharpEProgressBar;
    UpdateTimer: TTimer;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    swpbar: TSharpEProgressBar;
    SharpESkinManager1: TSharpESkinManager;
    lb_ram: TSharpESkinLabel;
    lb_swp: TSharpESkinLabel;
    lb_rambar: TSharpESkinLabel;
    lb_swpbar: TSharpESkinLabel;
    procedure BackgroundDblClick(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
  private
    BarWidth    : integer;
    ShowRAMBar  : boolean;
    ShowRAMPC   : boolean;
    ShowRAMInfo : boolean;
    ShowSWPBar  : boolean;
    ShowSWPPC   : boolean;
    ShowSWPInfo : boolean;
    ItemAlign   : integer;
  public
    ModuleID : integer;
    BarWnd : hWnd;
    procedure LoadSettings;
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(BroadCast : boolean);
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI;

{$R *.dfm}

function Li2Double(x: LARGE_INTEGER): Double; 
begin 
  Result := x.HighPart * 4.294967296E9 + x.LowPart 
end;

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  BarWidth := 100;
  ShowRAMBar  := True;
  ShowRAMPC   := True;
  ShowRAMInfo := False;
  ShowSWPBar  := True;
  ShowSWPPC   := True;
  ShowSWPInfo := False;
  ItemAlign   := 2;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    BarWidth := IntValue('Width',100);
    ShowRAMBar  := BoolValue('ShowRAMBar',True);
    ShowRAMPC   := BoolValue('ShowRAMPC',True);
    ShowRAMInfo := BoolValue('ShowRAMInfo',False);
    ShowSWPBar  := BoolValue('ShowSWPBar',True);
    ShowSWPPC   := BoolValue('ShowSWPPC',True);
    ShowSWPInfo := BoolValue('ShowSWPInfo',False);
    ItemAlign   := IntValue('ItemAlign',2);
    if ItemAlign >2 then ItemAlign := 2;
    if ItemAlign <1 then ItemAlign := 1;
  end;
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
  Width := NewWidth;
  ReAlignComponents(False);
end;

procedure TMainForm.ReAlignComponents(Broadcast : boolean);
var
  spacing,h : integer;
  o1,o2,o3,o4,o5 : integer;
  NewWidth : integer;
begin
  if BarWidth<25 then BarWidth := 25;

  spacing := 10;

  o1 := 2;
  o3 := 0;
  o4 := 0;
  o5 := 0;

  lb_swp.Left := -100;
  lb_ram.Left := -100;

  case ItemAlign of
   1: begin
{        lb_ram.Width := lb_ram.Canvas.TextWidth(lb_ram.caption);
        lb_ram.Height := lb_ram.Canvas.TextHeight(lb_ram.Caption);
        lb_swp.Width := lb_swp.Canvas.TextWidth(lb_swp.caption);
        lb_swp.Height := lb_swp.Canvas.TextHeight(lb_swp.Caption);
        lb_rambar.Width := lb_rambar.Canvas.TextWidth('100%');
        lb_rambar.Height := lb_rambar.Canvas.TextHeight('100%');
        lb_swpbar.Width := lb_swpbar.Canvas.TextWidth('100%');
        lb_swpbar.Height := lb_swpbar.Canvas.TextHeight('100%');}

        if ShowRamInfo then
        begin
          lb_ram.Visible := True;
          lb_ram.Left := o1;
          lb_ram.LabelStyle := lsMedium;
          lb_ram.Top := Height div 2 - lb_ram.Height div 2 - 2;
          o1 := lb_ram.Left + lb_ram.Width + 2;
        end else lb_ram.Visible := False;

        if ShowRamBar then
        begin
          rambar.AutoSize := True;
          rambar.Width := BarWidth;
          rambar.Visible := True;
          rambar.Height := Height div 2;
          rambar.Left := o1;
          rambar.Top := Height div 2  - rambar.Height div 2;
          o1 := rambar.Left + rambar.Width + 2;
        end else rambar.Visible := False;

        if ShowRamPC then
        begin
          lb_rambar.Visible := True;
          lb_rambar.LabelStyle := lsMedium;
          lb_rambar.Left := o1;
          lb_rambar.Top := Height div 2 - lb_rambar.Height div 2 - 1;
          o1 := lb_rambar.Left + lb_rambar.Width + 2;
        end else lb_rambar.Visible := False;

        o1 := o1 + spacing;

        if ShowSWPInfo then
        begin
          spacing := 0;
          lb_swp.Visible := True;
          lb_swp.LabelStyle := lsMedium;
          lb_swp.Left := o1;
          lb_swp.Top := Height div 2 - lb_swp.Height div 2 - 2;
          o1 := lb_swp.Left + lb_swp.Width + 2;
        end else lb_swp.Visible := False;

        if ShowSWPBar then
        begin
          spacing := 0;
          swpbar.AutoSize := True;
          swpbar.Width := BarWidth;
          swpbar.Visible := True;
          swpbar.Left := o1;
          swpbar.Height := Height div 2;
          swpbar.Top := Height div 2 - swpbar.Height div 2;
          o1 := swpbar.Left + swpbar.Width + 2;
        end else swpbar.Visible := False;

        if ShowSWPPC then
        begin
          spacing := 0;
          lb_swpbar.Visible := True;
          lb_swpbar.LabelStyle := lsMedium;
          lb_swpbar.Left := o1;
          lb_swpbar.Top := Height div 2 - lb_swpbar.Height div 2 - 1;
          o1 := lb_swpbar.Left + lb_swpbar.Width + 2;
        end else lb_swpbar.Visible := False;

        o1 := o1 - spacing;
      end
   else begin
          o2 := (Height - 2 - 4) div 2;
       {   lb_ram.Width := lb_ram.Canvas.TextWidth(lb_ram.caption);
          lb_ram.Height := lb_ram.Canvas.TextHeight(lb_ram.Caption);
          lb_swp.Width := lb_swp.Canvas.TextWidth(lb_swp.caption);
          lb_swp.Height := lb_swp.Canvas.TextHeight(lb_swp.Caption);
          lb_swpbar.Width := lb_swpbar.Canvas.TextWidth('100%');
          lb_swpbar.Height := lb_swpbar.Canvas.TextHeight('100%');
          lb_rambar.Width := lb_rambar.Canvas.TextWidth('100%');
          lb_rambar.Height := lb_rambar.Canvas.TextHeight('100%');   }

          if ShowRamInfo then
          begin
            lb_ram.Visible := True;
            lb_ram.LabelStyle := lsSmall;
            lb_ram.Left := o1;
            lb_ram.Top := 1 + (o2 div 2) - (lb_ram.Height div 2);
            o3 := lb_ram.Left + lb_ram.Width + 2;
          end else lb_ram.Visible := False;

          if ShowSWPInfo then
          begin
            lb_swp.Visible := True;
            lb_swp.LabelStyle := lsSmall;
            lb_swp.Left := o1;
            lb_swp.Top := Height - 3 - (o2 div 2) - (lb_swp.Height div 2);
            o3 := lb_swp.Left + lb_swp.Width + 2;
          end else lb_swp.Visible := False;

          if ShowRamBar then
          begin
            rambar.Width := BarWidth;
            rambar.AutoSize := False;
            rambar.Left := o3;
            rambar.Height := o2;
            rambar.Top := 2;
            rambar.Visible := True;
            o4 := rambar.Left + rambar.Width + 2;
          end else rambar.Visible := False;

          if ShowSwpBar then
          begin
            swpbar.Width := Barwidth;
            swpbar.AutoSize := False;
            swpbar.Left := o3;
            swpbar.Height := o2;
            swpbar.Top := Height - 2 - swpbar.Height;
            swpbar.Visible := True;
            o4 := swpbar.Left + swpbar.Width + 2;
          end else swpbar.Visible := False;

          if ShowRamPC then
          begin
            lb_rambar.Visible := True;
            lb_rambar.Left := max(o3,o4);
            lb_rambar.Top := 1 + (o2 div 2) - (lb_rambar.Height div 2);
            lb_rambar.LabelStyle := lsSmall;
            o5 := lb_rambar.Left + lb_rambar.Width + 2;
          end else lb_rambar.Visible := FalsE;

          if ShowSwpPC then
          begin
            lb_swpbar.Visible := True;
            lb_swpbar.Left := max(o3,o4);
            lb_swpbar.Top := Height - 3 - (o2 div 2) - (lb_swp.Height div 2);
            lb_swpbar.LabelStyle := lsSmall;
            o5 := lb_swpbar.Left + lb_swpbar.Width + 2;
          end else lb_swpbar.Visible := FalsE;
        end;
  end;

  NewWidth := max(o1,max(max(o3,o4),o5));
  Tag := NewWidth;
  Hint := inttostr(NewWidth);
  if (BroadCast) and (NewWidth <> Width) then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;


procedure TMainForm.FormShow(Sender: TObject);
begin
  UpdateTimer.Enabled := True;
end;

procedure TMainForm.UpdateTimerTimer(Sender: TObject);
var
  memStat : TMemoryStatus;
  i : integer;
begin
  memStat.dwLength := SizeOf(memStat);
  GlobalMemoryStatus(memStat);

  if (RamBar.Visible) or (lb_rambar.Visible) then
  begin
    i := round(((memstat.dwTotalPhys - memstat.dwAvailPhys) / memstat.dwTotalPhys) * 100);
    if RamBar.Visible then
       if (i <> rambar.Value) then
           rambar.Value := i;
    if (lb_rambar.Visible) then
       if (inttostr(i) + '%' <> lb_rambar.Caption) then
          lb_rambar.Caption := inttostr(i) + '%';
  end;

  if (SwpBar.Visible) or (lb_swpbar.Visible) then
  begin
    i := round(((memstat.dwTotalPageFile - memstat.dwAvailPageFile) / memstat.dwTotalPageFile) * 100);
    if SwpBar.Visible then
       if i <> swpbar.Value then
          swpbar.Value := i;
    if lb_swpbar.Visible then
       if (inttostr(i) + '%' <> lb_swpbar.Caption) then
           lb_swpbar.Caption := inttostr(i) + '%';
  end;
end;

procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  SettingsForm := TSettingsForm.Create(nil);
  SettingsForm.cb_rambar.Checked  := ShowRAMBar;
  SettingsForm.cb_raminfo.checked := ShowRAMInfo;
  SettingsForm.cb_rampc.Checked   := ShowRAMPC;
  SettingsForm.cb_swpbar.Checked  := ShowSWPBar;
  SettingsForm.cb_swpinfo.Checked := ShowSWPInfo;
  SettingsForm.cb_swppc.Checked   := ShowSWPPC;
  SettingsForm.tb_size.Position   := Barwidth;
  case ItemAlign of
    1: SettingsForm.rb_halign.Checked := True
    else SettingsForm.rb_valign.Checked := True;
  end;
  if SettingsForm.ShowModal = mrOk then
  begin
    ShowRAMBar  := SettingsForm.cb_rambar.Checked;
    ShowRAMInfo := SettingsForm.cb_raminfo.checked;
    ShowRAMPC   := SettingsForm.cb_rampc.Checked;
    ShowSWPBar  := SettingsForm.cb_swpbar.Checked;
    ShowSWPInfo := SettingsForm.cb_swpinfo.Checked;
    ShowSWPPC   := SettingsForm.cb_swppc.Checked;
    Barwidth    := SettingsForm.tb_size.Position;
    if SettingsForm.rb_halign.Checked then ItemAlign := 1
       else ItemAlign := 2;
       
    item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
    if item <> nil then with item.Items do
    begin
      clear;
      Add('Width',BarWidth);
      Add('ShowRAMBar',ShowRAMBar);
      Add('ShowRAMInfo',ShowRAMInfo);
      Add('ShowRAMPC',ShowRAMPC);
      Add('ShowSWPBar',ShowSWPBar);
      Add('ShowSWPInfo',ShowSWPInfo);
      Add('ShowSWPPC',ShowSWPPC);
      Add('ItemAlign',ItemAlign);
    end;
    uSharpBarAPI.SaveXMLFile(BarWnd);
    ReAlignComponents(true);
  end;
  FreeAndNil(SettingsForm);
end;

procedure TMainForm.BackgroundDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute('TaskMgr.exe');
end;

end.
