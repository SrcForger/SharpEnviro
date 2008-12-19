{
Source Name: MainWnd
Description: Memory Monitor Module - Main Window
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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, SharpEBaseControls, GR32,
  SharpTypes, ExtCtrls, SharpEProgressBar,
  JvSimpleXML, SharpApi, Menus, Math, SharpESkinLabel, uISharpBarModule;


type
  TMainForm = class(TForm)
    UpdateTimer: TTimer;
    lb_swpbar: TSharpESkinLabel;
    lb_rambar: TSharpESkinLabel;
    lb_swp: TSharpESkinLabel;
    lb_ram: TSharpESkinLabel;
    swpbar: TSharpEProgressBar;
    rambar: TSharpEProgressBar;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BackgroundDblClick(Sender: TObject);
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
  public
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
    procedure UpdateSize;
  end;

type 
  TMemoryStatusEx = packed record 
    dwLength: DWORD; 
    dwMemoryLoad: DWORD; 
    ullTotalPhys: Int64; 
    ullAvailPhys: Int64; 
    ullTotalPageFile: Int64; 
    ullAvailPageFile: Int64; 
    ullTotalVirtual: Int64; 
    ullAvailVirtual: Int64; 
    ullAvailExtendedVirtual: Int64; 
  end;


function GlobalMemoryStatusEx(var lpBuffer: TMemoryStatusEx): BOOL; stdcall; external kernel32;

implementation

{$R *.dfm}

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
    XML.LoadFromFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
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


procedure TMainForm.UpdateComponentSkins;
begin
  lb_ram.SkinManager := mInterface.SkinInterface.SkinManager;
  lb_swp.SkinManager := mInterface.SkinInterface.SkinManager;
  lb_rambar.SkinManager := mInterface.SkinInterface.SkinManager;
  lb_swpbar.SkinManager := mInterface.SkinInterface.SkinManager;
  rambar.SkinManager := mInterface.SkinInterface.SkinManager;
  swpbar.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.UpdateSize;
begin
  ReAlignComponents;
end;

procedure TMainForm.ReAlignComponents;
var
  spacing : integer;
  o1,o3,o4,o5 : integer;
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
        o3 := 2;

        if ShowRamInfo then
        begin
          lb_ram.Caption := 'RAM:';
          lb_ram.Left := o1 -5;
          lb_ram.LabelStyle := lsSmall;
          lb_ram.AutoPos := apTop;          
          lb_ram.Visible := True;
          lb_ram.UpdateSkin;
          o3 := lb_ram.Left + lb_ram.Width + 2;
          o4 := o3;
        end else lb_ram.visible := False;

        if ShowRamBar then
        begin
          rambar.visible := True;
          rambar.left := o1;
          rambar.AutoPos := apBottom;
          rambar.Width := BarWidth;
          o4 := max(o4,rambar.Left + rambar.Width + 2);
        end else rambar.visible := False;

        if ShowRamPC then
        begin
          lb_rambar.LabelStyle := lsSmall;
          lb_rambar.UpdateSkin;
          if ShowRamInfo then lb_rambar.Left := o3 - 8
             else lb_rambar.Left := o3 - 5;
          lb_rambar.AutoPos := apTop;
          lb_rambar.Visible := True;
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
          lb_swp.LabelStyle := lsSmall;
          lb_swp.UpdateSkin;
          lb_swp.Left := o4 - 5;
          lb_swp.AutoPos := apTop;
          lb_swp.Visible := True;
          o3 := lb_swp.Left + lb_swp.Width + 2;
          o5 := o3;
        end else lb_swp.visible := False;

        if ShowSwpBar then
        begin
          swpbar.visible := True;
          swpbar.AutoPos := apBottom;
          swpbar.left := o4;
          swpbar.Width := BarWidth;
          o5 := max(o5,swpbar.Left + swpbar.Width + 2);
        end else swpbar.visible := False;

        if ShowSwpPC then
        begin
          lb_swpbar.LabelStyle := lsSmall;
          lb_swpbar.UpdateSkin;
          if ShowRamInfo then lb_swpbar.Left := o3 - 8
             else lb_swpbar.Left := o3 - 5;
          lb_swpbar.AutoPos := apTop;
          lb_swpbar.Visible := True;          
          o5 := max(o5,lb_swpbar.Left + lb_swpbar.Width + 2);
        end else lb_swpbar.Visible := False;
      end;
   1: begin
        if ShowRamInfo then
        begin
          lb_ram.Caption := 'ram';
          lb_ram.Left := o1;
          lb_ram.LabelStyle := lsMedium;
          lb_ram.UpdateSkin;
          lb_ram.AutoPos := apCenter;
          lb_ram.Visible := True;
          o1 := lb_ram.Left + lb_ram.Width + 2;
        end else lb_ram.Visible := False;

        if ShowRamBar then
        begin
          rambar.Width := BarWidth;
          rambar.AutoPos := apCenter;
          rambar.Visible := True;
          rambar.Left := o1;
          o1 := rambar.Left + rambar.Width + 2;
        end else rambar.Visible := False;

        if ShowRamPC then
        begin
          lb_rambar.LabelStyle := lsMedium;
          lb_rambar.UpdateSkin;
          lb_rambar.Left := o1;
          lb_rambar.AutoPos := apCenter;
          lb_rambar.Visible := True;          
          o1 := lb_rambar.Left + lb_rambar.Width + 2;
        end else lb_rambar.Visible := False;

        o1 := o1 + spacing;

        if ShowSWPInfo then
        begin
          spacing := 0;
          lb_swp.Caption := 'swp';
          lb_swp.LabelStyle := lsMedium;
          lb_swp.UpdateSkin;
          lb_swp.Left := o1;
          lb_swp.AutoPos := apCenter;
          lb_swp.Visible := True;          
          o1 := lb_swp.Left + lb_swp.Width + 2;
        end else lb_swp.Visible := False;

        if ShowSWPBar then
        begin
          spacing := 0;
          swpbar.Width := BarWidth;
          swpbar.AutoPos := apCenter;
          swpbar.Visible := True;
          swpbar.Left := o1;
          o1 := swpbar.Left + swpbar.Width + 2;
        end else swpbar.Visible := False;

        if ShowSWPPC then
        begin
          spacing := 0;
          lb_swpbar.LabelStyle := lsMedium;
          lb_swpbar.UpdateSkin;
          lb_swpbar.Left := o1;
          lb_swpbar.AutoPos := apCenter;
          lb_swpbar.Visible := True;
          o1 := lb_swpbar.Left + lb_swpbar.Width + 2;
        end else lb_swpbar.Visible := False;

        o1 := o1 - spacing;
      end
   else begin
          if ShowRamInfo then
          begin
            lb_ram.Caption := 'ram';
            lb_ram.LabelStyle := lsSmall;
            lb_ram.UpdateSkin;
            lb_ram.Left := o1;
            lb_ram.AutoPos := apTop;
            lb_ram.Visible := True;
            o3 := lb_ram.Left + lb_ram.Width + 2;
          end else lb_ram.Visible := False;

          if ShowSWPInfo then
          begin
            lb_swp.Caption := 'swp';
            lb_swp.LabelStyle := lsSmall;
            lb_swp.UpdateSkin;
            lb_swp.Left := o1;
            lb_swp.AutoPos := apBottom;
            lb_swp.Visible := True;
            o3 := lb_swp.Left + lb_swp.Width + 2;
          end else lb_swp.Visible := False;

          if ShowRamBar then
          begin
            rambar.Width := BarWidth;
            rambar.Left := o3;
            rambar.AutoPos := apTop;
            rambar.Visible := True;
            o4 := rambar.Left + rambar.Width + 2;
          end else rambar.Visible := False;

          if ShowSwpBar then
          begin
            swpbar.Width := Barwidth;
            swpbar.Left := o3;
            swpbar.AutoPos := apBottom;
            swpbar.Visible := True;
            o4 := swpbar.Left + swpbar.Width + 2;
          end else swpbar.Visible := False;

          if ShowRamPC then
          begin
            lb_rambar.Left := max(o3,o4);
            lb_rambar.AutoPos := apTop;
            lb_rambar.LabelStyle := lsSmall;
            lb_rambar.UpdateSkin;            
            lb_rambar.Visible := True;
            o5 := lb_rambar.Left + lb_rambar.Width + 2;
          end else lb_rambar.Visible := FalsE;

          if ShowSwpPC then
          begin
            lb_swpbar.Left := max(o3,o4);
            lb_swpbar.AutoPos := apBottom;
            lb_swpbar.LabelStyle := lsSmall;
            lb_swpbar.UpdateSkin;
            lb_swpbar.Visible := True;
            o5 := lb_swpbar.Left + lb_swpbar.Width + 2;
          end else lb_swpbar.Visible := FalsE;
        end;
  end;

  NewWidth := max(o1,max(max(o3,o4),o5));

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else Repaint;
end;


procedure TMainForm.FormShow(Sender: TObject);
begin
  UpdateTimer.Enabled := True;
end;

procedure TMainForm.UpdateTimerTimer(Sender: TObject);
var
  memStat : TMemoryStatusEx;
  i,t : integer;
begin
  memStat.dwLength := SizeOf(memStat);
  GlobalMemoryStatusEx(memStat);

  if (RamBar.Visible) or (lb_rambar.Visible) then
  begin
    i := round(((memstat.ullTotalPhys - memstat.ullAvailPhys) / memstat.ullTotalPhys) * 100);
    t := memstat.ullAvailPhys div 1024 div 1024;
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
    i := round(((memstat.ullTotalPageFile - memstat.ullAvailPageFile) / memstat.ullTotalPageFile) * 100);
    t := memstat.ullAvailPageFile div 1024 div 1024;
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

procedure TMainForm.BackgroundDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute('TaskMgr.exe');
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

end.
