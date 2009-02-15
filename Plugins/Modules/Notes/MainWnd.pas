{
Source Name: MainWnd.pas
Description: Notes Module - Main Window
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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
  Windows, Messages, SysUtils, Classes, Controls, Forms, Types,
  StdCtrls, GR32, GR32_PNG, SharpEButton,
  JclSimpleXML, SharpApi, Menus, Math, NotesWnd,
  SharpEBaseControls,uISharpBarModule, uNotesSettings;


type
  TMainForm = class(TForm)
    Button: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure ButtonDblClick(Sender: TObject);
  protected
  private
    FSettings: NotesSettings;
    FReload: Boolean;
    procedure WMSharpEBang(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;
    procedure LoadIcon;
  public
    NotesForm : TNotesForm;
    mInterface : ISharpBarModule;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure UpdateBangs;
    property Settings: NotesSettings read FSettings write FSettings;
  end;

implementation

uses uSystemFuncs;

{$R *.dfm}
{$R glyphs.res}

procedure TMainForm.UpdateBangs;
begin
  SharpApi.RegisterActionEx('!ToggleNotes','Modules',self.Handle,1);
end;

procedure TMainForm.UpdateComponentSkins;
begin
  Button.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.WMSharpEBang(var Msg : TMessage);
begin
  case msg.LParam of
    1: begin
         Button.OnClick(Button);
         ForceForegroundWindow(NotesForm.Handle);
       end;
  end;
end;

procedure TMainForm.LoadIcon;
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
begin
  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(32,32);
  TempBmp.Clear(color32(0,0,0,0));
  try
    ResStream := TResourceStream.Create(HInstance, 'buttonicon', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      Button.Glyph32.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;
  TempBmp.Free;
end;

procedure TMainForm.SaveSettings;
var
  XML : TJclSimpleXML;
  i: Integer;
begin
  XML := TJclSimpleXML.Create;
  XML.Root.Name := 'NotesModuleSettings';
  with xml.Root.Items do
  begin
    Add('Name', Button.Caption);
    Add('Caption', Settings.ShowCaption);
    Add('Icon', Settings.ShowIcon);
    Add('AlwaysOnTop', Settings.AlwaysOnTop);
    Add('Left', Settings.Left);
    Add('Top', Settings.Top);
    Add('Height', Settings.Height);
    Add('Width', Settings.Width);
    Add('LineWrap', Settings.WordWrap);
    Add('Filter', Settings.Filter);
    Add('FilterIndex', Settings.FilterIndex);
    Add('LastTab', Settings.LastTab);

    with Add('Tabs').Items do
      for i := 0 to Pred(Settings.Tabs.Count) do
        with Add('Tab').Items do
        begin
          Add('Name', NotesTabSettings(Settings.Tabs.Objects[i]).Name);
          Add('Tags', NotesTabSettings(Settings.Tabs.Objects[i]).Tags);
          Add('IconIndex', NotesTabSettings(Settings.Tabs.Objects[i]).IconIndex);
          Add('SelStart', NotesTabSettings(Settings.Tabs.Objects[i]).SelStart);
          Add('SelLength', NotesTabSettings(Settings.Tabs.Objects[i]).SelLength);
        end;
  end;
  XML.SaveToFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
  XML.Free;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
  Mon : TMonitor;
  i: Integer;
  tabSettings: NotesTabSettings;
begin
  UpdateBangs;

  Mon := screen.MonitorFromWindow(Handle);

  Settings.Left := Mon.Left + Mon.Width div 2 - Settings.Width div 2;
  Settings.Top := Mon.Top + Mon.Height div 2 - Settings.Height div 2;

  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      Self.Caption := Value('Name', 'Notes');
      
      if Self.Caption = '' then
        Self.Caption := 'Notes';

      NotesForm.Caption := Self.Caption;
      Settings.ShowCaption := BoolValue('Caption', Settings.ShowCaption);
      Settings.ShowIcon := BoolValue('Icon', Settings.ShowIcon);
      Settings.AlwaysOnTop := BoolValue('AlwaysOnTop', Settings.AlwaysOnTop);

      if not FReload then
      begin
        // Indicate that we don't want to reload these these.
        FReload := True;

        Settings.Left := IntValue('Left', Settings.Left);
        Settings.Top := IntValue('Top', Settings.Top);
        Settings.Height := Max(64,IntValue('Height', Settings.Height));
        Settings.Width := Max(64,IntValue('Width', Settings.Width));
        Settings.WordWrap := BoolValue('LineWrap', Settings.WordWrap);
        Settings.Filter := Value('Filter', Settings.Filter);
        Settings.FilterIndex := IntValue('FilterIndex', Settings.FilterIndex);
        Settings.LastTab := Value('LastTab', Settings.LastTab);

        if ItemNamed['Tabs'] <> nil then
          with ItemNamed['Tabs'].Items do
            for i := 0 to Pred(Count) do
            begin
              tabSettings := NotesTabSettings.Create(Item[i].Items.Value('Name', 'Unknown' + IntToStr(i)));
              tabSettings.Tags := Item[i].Items.Value('Tags', '');
              tabSettings.IconIndex := Item[i].Items.IntValue('IconIndex', DefaultIconIndex);
              tabSettings.SelStart := Item[i].Items.IntValue('SelStart', 0);
              tabSettings.SelLength := Item[i].Items.IntValue('SelLength', 0);
              Settings.Tabs.AddObject(tabSettings.Name, tabSettings);
            end;
      end;
    end;
  XML.Free;
end;

procedure TMainForm.UpdateSize;
begin
  Button.Width := max(1,Width - 4);
end;

procedure TMainForm.ReAlignComponents;
var
  newWidth : integer;
begin
  Button.Left := 2;
  newWidth := 20;
  if (Settings.ShowIcon) and (Button.Glyph32 <> nil) then
  begin
    LoadIcon;
    newWidth := newWidth + Button.GetIconWidth;
  end else Button.Glyph32.SetSize(0,0);

  if (Settings.ShowCaption) then
  begin
    Button.Caption := Self.Caption;
    newWidth := newWidth + Button.GetTextWidth;
  end else Button.Caption := '';

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TMainForm.ButtonClick(Sender: TObject);
var
  n : integer;
  b : boolean;
  Mon : TMonitor;
begin
  if NotesForm = nil then NotesForm := TNotesForm.Create(self);

  if NotesForm.Visible then
  begin
    NotesForm.Close;
    Exit;
  end;
  
  // check if the window is in any visible monitor
  b := False;
  for n := 0 to Screen.MonitorCount-1 do
    if ((PointInRect(Point(Settings.Left, Settings.Top), Screen.Monitors[n].BoundsRect)) and
      (PointInRecT(Point(Settings.Left + Settings.Width, Settings.Top + Settings.Height), Screen.Monitors[n].BoundsRect))) then
      b := True;

  if not b then
  begin
    Mon := screen.MonitorFromWindow(Handle);
    Settings.Left := Mon.Left + Mon.Width div 2 - Settings.Width div 2;
    Settings.Top := Mon.Top + Mon.Height div 2 - Settings.Height div 2;
  end;

  NotesForm.Left := Settings.Left;
  NotesForm.Top := Settings.Top;
  NotesForm.Width := Settings.Width;
  NotesForm.Height := Settings.Height;
  NotesForm.reNotes.WordWrap := Settings.WordWrap;
  NotesForm.editFilter.Text := Settings.Filter;
  NotesForm.pmFilter.Items[Settings.FilterIndex].Checked := True;

  NotesForm.Show;

  if Settings.AlwaysOnTop then
    NotesForm.FormStyle:= fsStayOnTop
  else
    NotesForm.FormStyle := fsNormal;
end;

procedure TMainForm.ButtonDblClick(Sender: TObject);
begin
  ButtonClick(Button);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FReload := False;
  DoubleBuffered := True;
  NotesForm := TNotesForm.Create(Self);
  Settings := NotesSettings.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if NotesForm <> nil then FreeAndNil(NotesForm);
  if Settings <> nil then Settings.Free;  
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

end.
