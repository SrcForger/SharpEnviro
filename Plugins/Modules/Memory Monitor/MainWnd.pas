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
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, SharpEBaseControls, GR32,
  SharpESkinManager, SharpEScheme, SharpESkin, ExtCtrls, SharpEProgressBar,
  JvSimpleXML, SharpApi, Menus, Math, SharpESkinLabel;


type
  TMainForm = class(TForm)
    UpdateTimer: TTimer;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    lb_swpbar: TSharpESkinLabel;
    lb_rambar: TSharpESkinLabel;
    lb_swp: TSharpESkinLabel;
    lb_ram: TSharpESkinLabel;
    swpbar: TSharpEProgressBar;
    rambar: TSharpEProgressBar;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
    sITC        : integer;
    Background  : TBitmap32;
  public
    ModuleID : integer;
    BarID : integer;
    BarWnd : hWnd;
    procedure LoadSettings;
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(BroadCast : boolean);
    procedure UpdateBackground(new : integer = -1);
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
  XML : TJvSimpleXML;
  fileloaded : boolean;
begin
  BarWidth := 50;
  ShowRAMBar  := True;
  ShowRAMPC   := True;
  ShowRAMInfo := True;
  ShowSWPBar  := True;
  ShowSWPPC   := True;
  ShowSWPInfo := True;
  sITC        := 0;
  ItemAlign   := 3;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      BarWidth := IntValue('Width',BarWidth);
      ShowRAMBar  := BoolValue('ShowRAMBar',ShowRAMBar);
      ShowRAMPC   := BoolValue('ShowRAMPC',ShowRAMPC);
      ShowRAMInfo := BoolValue('ShowRAMInfo',ShowRAMInfo);
      ShowSWPBar  := BoolValue('ShowSWPBar',ShowSWPBar);
      ShowSWPPC   := BoolValue('ShowSWPPC',ShowSWPPC);
      ShowSWPInfo := BoolValue('ShowSWPInfo',ShowSWPInfo);
      ItemAlign   := IntValue('ItemAlign',ItemAlign);
      sITC        := IntValue('ITC',sITC);
      if ItemAlign >3 then ItemAlign := 3;
      if ItemAlign <1 then ItemAlign := 1;
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

procedure TMainForm.SetSize(NewWidth : integer);
begin
  NewWidth := Max(1,NewWidth);

  UpdateBackground(NewWidth);

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

  UpdateTimerTimer(UpdateTimer);
  case ItemAlign of
   3: begin
        o2 := (Height - 2 - 4) div 2;
        o3 := 2;

        if ShowRamInfo then
        begin
          lb_ram.Caption := 'RAM:';
          lb_ram.Visible := True;
          lb_ram.LabelStyle := lsSmall;
          lb_ram.UpdateSkin;
          lb_ram.Left := o1 -5;
          lb_ram.Top := 2 + (o2 div 2) - (lb_ram.Height div 2);
          o3 := lb_ram.Left + lb_ram.Width + 2;
          o4 := o3;
        end else lb_ram.visible := False;

        if ShowRamBar then
        begin
          rambar.AutoSize := False;
          rambar.visible := True;
          rambar.Height := o2;
          rambar.left := o1;
          rambar.Top := Height - 2 - rambar.Height;
          rambar.Width := BarWidth;
          o4 := max(o4,rambar.Left + rambar.Width + 2);
        end else rambar.visible := False;

        if ShowRamPC then
        begin
          lb_rambar.Visible := True;
          lb_rambar.LabelStyle := lsSmall;
          lb_rambar.UpdateSkin;
          if ShowRamInfo then lb_rambar.Left := o3 - 8
             else lb_rambar.Left := o3 - 5;
          lb_rambar.Top := 2 + (o2 div 2) - (lb_ram.Height div 2);
          o4 := max(o4,lb_rambar.Left + lb_rambar.Width + 2);
        end else lb_rambar.Visible := False;

        if (ShowRamPC) or (ShowRamBar) or (ShowRamInfo) then
        begin
          o3 := o4 + 7;
          o4 := o4 + 5;
        end else o3 := o4 + 5;

        if ShowSwpInfo then
        begin
          lb_swp.Caption := 'SWAP:';
          lb_swp.Visible := True;
          lb_swp.LabelStyle := lsSmall;
          lb_swp.UpdateSkin;
          lb_swp.Left := o4 - 5;
          lb_swp.Top := 2 + (o2 div 2) - (lb_swp.Height div 2);
          o3 := lb_swp.Left + lb_swp.Width + 2;
          o5 := o3;
        end else lb_swp.visible := False;

        if ShowSwpBar then
        begin
          swpbar.AutoSize := False;
          swpbar.visible := True;
          swpbar.Height := o2;
          swpbar.left := o4;
          swpbar.Top := Height - 2 - swpbar.Height;
          swpbar.Width := BarWidth;
          o5 := max(o5,swpbar.Left + swpbar.Width + 2);
        end else swpbar.visible := False;

        if ShowSwpPC then
        begin
          lb_swpbar.Visible := True;
          lb_swpbar.LabelStyle := lsSmall;
          lb_swpbar.UpdateSkin;
          if ShowRamInfo then lb_swpbar.Left := o3 - 8
             else lb_swpbar.Left := o3 - 5;
          lb_swpbar.Top := 1 + (o2 div 2) - (lb_swp.Height div 2);
          o5 := max(o5,lb_swpbar.Left + lb_swpbar.Width + 2);
        end else lb_swpbar.Visible := False;
      end;
   1: begin
        if ShowRamInfo then
        begin
          lb_ram.Caption := 'ram';
          lb_ram.Visible := True;
          lb_ram.Left := o1;
          lb_ram.LabelStyle := lsMedium;
          lb_ram.UpdateSkin;
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
          lb_rambar.UpdateSkin;
          lb_rambar.Left := o1;
          lb_rambar.Top := Height div 2 - lb_rambar.Height div 2 - 1;
          o1 := lb_rambar.Left + lb_rambar.Width + 2;
        end else lb_rambar.Visible := False;

        o1 := o1 + spacing;

        if ShowSWPInfo then
        begin
          spacing := 0;
          lb_swp.Caption := 'swp';
          lb_swp.Visible := True;
          lb_swp.LabelStyle := lsMedium;
          lb_swp.UpdateSkin;
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
          lb_swpbar.UpdateSkin;
          lb_swpbar.Left := o1;
          lb_swpbar.Top := Height div 2 - lb_swpbar.Height div 2 - 1;
          o1 := lb_swpbar.Left + lb_swpbar.Width + 2;
        end else lb_swpbar.Visible := False;

        o1 := o1 - spacing;
      end
   else begin
          o2 := (Height - 2 - 4) div 2;

          if ShowRamInfo then
          begin
            lb_ram.Caption := 'ram';
            lb_ram.Visible := True;
            lb_ram.LabelStyle := lsSmall;
            lb_ram.UpdateSkin;
            lb_ram.Left := o1;
            lb_ram.Top := 1 + (o2 div 2) - (lb_ram.Height div 2);
            o3 := lb_ram.Left + lb_ram.Width + 2;
          end else lb_ram.Visible := False;

          if ShowSWPInfo then
          begin
            lb_swp.Caption := 'swp';
            lb_swp.Visible := True;
            lb_swp.LabelStyle := lsSmall;
            lb_swp.UpdateSkin;
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
            lb_rambar.UpdateSkin;
            lb_rambar.Left := max(o3,o4);
            lb_rambar.Top := 1 + (o2 div 2) - (lb_rambar.Height div 2);
            lb_rambar.LabelStyle := lsSmall;
            o5 := lb_rambar.Left + lb_rambar.Width + 2;
          end else lb_rambar.Visible := FalsE;

          if ShowSwpPC then
          begin
            lb_swpbar.Visible := True;
            lb_swpbar.UpdateSkin;
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
  if (BroadCast) and (NewWidth <> Width) then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0)
     else Repaint;
end;


procedure TMainForm.FormShow(Sender: TObject);
begin
  UpdateTimer.Enabled := True;
end;

procedure TMainForm.UpdateTimerTimer(Sender: TObject);
var
  memStat : TMemoryStatus;
  i,t : integer;
begin
  memStat.dwLength := SizeOf(memStat);
  GlobalMemoryStatus(memStat);

  if (RamBar.Visible) or (lb_rambar.Visible) then
  begin
    i := round(((memstat.dwTotalPhys - memstat.dwAvailPhys) / memstat.dwTotalPhys) * 100);
    t := memstat.dwAvailPhys div 1024 div 1024;
    if RamBar.Visible then
       if (i <> rambar.Value) then
           rambar.Value := i;
    if (lb_rambar.Visible) then
    begin
      case sITC of
        0: if CompareText(inttostr(i) + '%',lb_rambar.Caption) <> 0 then
           begin
             lb_rambar.Caption := inttostr(i) + '%';
             repaint;
           end;
        else if CompareText(inttostr(t) + ' MB free',lb_rambar.Caption) <> 0 then
             begin
               lb_rambar.Caption := inttostr(t) + ' MB free';
               repaint;
             end;
       end;
    end;
  end;

  if (SwpBar.Visible) or (lb_swpbar.Visible) then
  begin
    i := round(((memstat.dwTotalPageFile - memstat.dwAvailPageFile) / memstat.dwTotalPageFile) * 100);
    t := memstat.dwAvailPageFile div 1024 div 1024;
    if SwpBar.Visible then
       if i <> swpbar.Value then
          swpbar.Value := i;

    if lb_swpbar.Visible then
    begin
      case sITC of
        0: if CompareText(inttostr(i) + '%',lb_swpbar.Caption) <> 0 then
           begin
             lb_swpbar.Caption := inttostr(i) + '%';
             repaint;
           end;
        else if CompareText(inttostr(t) + ' MB free',lb_swpbar.Caption) <> 0 then
             begin
               lb_swpbar.Caption := inttostr(t) + ' MB free';
               repaint;
             end;
      end;
    end;
  end;
end;

procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  XML : TJvSimpleXML;
begin
  SettingsForm := TSettingsForm.Create(application.MainForm);
  SettingsForm.cb_rambar.Checked  := ShowRAMBar;
  SettingsForm.cb_raminfo.checked := ShowRAMInfo;
  SettingsForm.cb_rampc.Checked   := ShowRAMPC;
  SettingsForm.cb_swpbar.Checked  := ShowSWPBar;
  SettingsForm.cb_swpinfo.Checked := ShowSWPInfo;
  SettingsForm.cb_swppc.Checked   := ShowSWPPC;
  SettingsForm.tb_size.Position   := Barwidth;

  case sITC of
    0: SettingsForm.cb_itc_pt.Checked := True
    else SettingsForm.cb_itc_fmb.Checked := True;
  end;

  case ItemAlign of
    1: SettingsForm.rb_halign.Checked := True;
    3: SettingsForm.rb_halign2.Checked := True;
    else SettingsForm.rb_valign.Checked := True;
  end;

  if SettingsForm.ShowModal = mrOk then
  begin
    if SettingsForm.cb_itc_pt.Checked then sITC := 0
       else sITC := 1;

    ShowRAMBar  := SettingsForm.cb_rambar.Checked;
    ShowRAMInfo := SettingsForm.cb_raminfo.checked;
    ShowRAMPC   := SettingsForm.cb_rampc.Checked;
    ShowSWPBar  := SettingsForm.cb_swpbar.Checked;
    ShowSWPInfo := SettingsForm.cb_swpinfo.Checked;
    ShowSWPPC   := SettingsForm.cb_swppc.Checked;
    Barwidth    := SettingsForm.tb_size.Position;
    if SettingsForm.rb_halign.Checked then ItemAlign := 1
       else if SettingsForm.rb_halign2.Checked then ItemAlign := 3
       else ItemAlign := 2;

    XML := TJvSimpleXML.Create(nil);
    XML.Root.Name := 'MemoryMonitorModuleSettings';
    with XML.Root.Items do
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
      Add('ITC',sITC);
    end;
    XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
    XML.Free;
    ReAlignComponents(true);
    repaint;
  end;
  FreeAndNil(SettingsForm);
end;

procedure TMainForm.BackgroundDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute('TaskMgr.exe');
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
