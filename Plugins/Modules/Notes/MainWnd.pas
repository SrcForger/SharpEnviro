{
Source Name: MainWnd.pas
Description: Notes Module - Main Window
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
  Windows, Messages, SysUtils, Classes, Controls, Forms, Types,
  StdCtrls, GR32, GR32_PNG, SharpEButton,
  JclSimpleXML, SharpApi, Menus, Math, NotesWnd, SharpTypes,
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
    NotesForm : TSharpENotesForm;
    mInterface : ISharpBarModule;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure LoadSettings;
    procedure LoadTabsSettings;
    procedure SaveSettings;
    procedure SaveTabsSettings;
    procedure UpdateBangs;
    procedure SendUpdateNotes;
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

procedure TMainForm.SendUpdateNotes;
var
  NotesWndList : THandleArray;
  wParam : Word;
  i : integer;
begin
  // Get a list of all notes windows.
  NotesWndList := FindAllWindows('TSharpENotesForm');

  for i := 0 to High(NotesWndList) do
    // Do not send a message to ourselves.
    if NotesWndList[i] <> NotesForm.Handle then
      // Only send the message to visible windows.
      if IsWindowVisible(NotesWndList[i]) then
      begin
        // Pass the notes directory so only those modules that
        // have the same directory will reload their settings.
        wParam := GlobalAddAtom(PAnsiChar(Settings.Directory));
        // Send the message to the window.
        SendMessage(NotesWndList[i], WM_UPDATENOTES, wParam, 0);
      end;

  SetLength(NotesWndList, 0);
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
  ResID : String;
begin
  if mInterface = nil then
    exit;
  if mInterface.SkinInterface = nil then
    exit;

  TempBmp := TBitmap32.Create;
  if mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y <= 16 then
  begin
    TempBmp.SetSize(16,16);
    ResID := 'buttonicon';
  end else
  begin
    TempBmp.SetSize(32,32);
    ResID := 'buttonicon32';
  end;

  TempBmp.Clear(color32(0,0,0,0));
  try
    ResStream := TResourceStream.Create(HInstance, ResID, RT_RCDATA);
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
begin
  XML := TJclSimpleXML.Create;
  try
    XML.Root.Name := 'NotesModuleSettings';
    with xml.Root.Items do
    begin
      Add('Directory', StringReplace(Settings.Directory, SharpApi.GetSharpeUserSettingsPath, '{#SharpEUserSettingsDir#}', [rfReplaceAll,rfIgnoreCase]));
      Add('CaptionText', Settings.Caption);
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
    end;
    XML.SaveToFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
  finally
    XML.Free;
  end;
end;

procedure TMainForm.SaveTabsSettings;
var
  XML : TJclSimpleXML;
  i : Integer;
begin
  XML := TJclSimpleXML.Create;
  try
    XML.Root.Name := 'NotesModuleTabsSettings';
    with xml.Root.Items do
    begin
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
    if not DirectoryExists(Settings.Directory) then
      ForceDirectories(Settings.Directory);
    XML.SaveToFile(Settings.Directory + '\NotesModuleTabsSettings.xml');
  except
  end;
  XML.Free;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
  Mon : TMonitor;
  notesDirectory : string;
  notesDirectoryChanged : Boolean;
  notesOpen : Boolean;
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
      // Get the directory the module should use to store and display tabs.
      notesDirectory := Value('Directory', Settings.Directory);
      notesDirectory := StringReplace(notesDirectory, '{#SharpEUserSettingsDir#}', SharpApi.GetSharpeUserSettingsPath, [rfReplaceAll,rfIgnoreCase]);
      notesDirectoryChanged := (CompareText(Settings.Directory, notesDirectory) <> 0);
      notesOpen := NotesForm.Visible;

      // If the user changed the notes directory then we need to reload the tabs.
      if (notesDirectoryChanged) then
      begin
        if notesOpen then
          // Close the form so everything gets saved.
          NotesForm.Close;
        // Free the old settings and create a new one.
        Settings.Free;
        Settings := NotesSettings.Create;
        Settings.Directory := notesDirectory;
      end;

      // Get the name the user may have defined and use it for the caption.
      Settings.Caption := Value('CaptionText', Settings.Caption);

      // Set the caption for the main form and notes form.
      Self.Caption := Settings.Caption;
      NotesForm.Caption := Settings.Caption;

      Settings.ShowCaption := BoolValue('Caption', Settings.ShowCaption);
      Settings.ShowIcon := BoolValue('Icon', Settings.ShowIcon);
      Settings.AlwaysOnTop := BoolValue('AlwaysOnTop', Settings.AlwaysOnTop);

      if Settings.AlwaysOnTop then
        NotesForm.FormStyle := fsStayOnTop
      else
        NotesForm.FormStyle := fsNormal;

      if (not FReload) or notesDirectoryChanged then
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
      end;

      if notesDirectoryChanged and notesOpen then
        NotesForm.Show;
    end;
  XML.Free;

  if not DirectoryExists(Settings.Directory) then
    ForceDirectories(Settings.Directory);  
end;

procedure TMainForm.LoadTabsSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
  tabName : string;
  tabSettings : NotesTabSettings;
  i : Integer;
begin
  // We store the settings for the tabs in the directory the
  // module uses for storing and displaying tabs.
  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(Settings.Directory + '\NotesModuleTabsSettings.xml');
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      if ItemNamed['Tabs'] <> nil then
        with ItemNamed['Tabs'].Items do
          for i := 0 to Pred(Count) do
          begin
            tabName := Item[i].Items.Value('Name', '');
            // No point and adding the settings if the file does not exist.
            if FileExists(Settings.Directory + '\' + tabName + '.rtf') then
            begin
              tabSettings := NotesTabSettings.Create(tabName);
              tabSettings.Tags := Item[i].Items.Value('Tags', tabSettings.Tags);
              tabSettings.IconIndex := Item[i].Items.IntValue('IconIndex', tabSettings.IconIndex);
              tabSettings.SelStart := Item[i].Items.IntValue('SelStart', tabSettings.SelStart);
              tabSettings.SelLength := Item[i].Items.IntValue('SelLength', tabSettings.SelLength);
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
  newWidth := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;

  if (Settings.ShowIcon) and (Button.Glyph32 <> nil) then
  begin
    LoadIcon;
    newWidth := newWidth + Button.GetIconWidth;
  end else Button.Glyph32.SetSize(0,0);

  if (Settings.ShowCaption) then
  begin
    Button.Caption := Settings.Caption;
    newWidth := newWidth + Button.GetTextWidth;
  end else Button.Caption := '';

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
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
  if NotesForm = nil then NotesForm := TSharpENotesForm.Create(self);

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
  NotesForm := TSharpENotesForm.Create(Self);
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
