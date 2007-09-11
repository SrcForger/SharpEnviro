{
Source Name: MainWnd.pas
Description: Button Module - Main Window
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Math, GR32, ToolTipApi, ShellApi,
  JvSimpleXML,
  SharpApi,
  uSharpBarAPI,
  SharpEBaseControls,
  SharpESkin,
  SharpEScheme,
  SharpESkinManager,
  SharpEButton,
  SharpIconUtils;


type
  TButtonRecord = record
                    btn: TSharpEButton;
                    target: String;
                    icon: String;
                    caption: String;
                  end;

  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    sb_config: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Settings1Click(Sender: TObject);
    procedure sb_configClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    sWidth       : integer;
    sShowLabel   : boolean;
    FButtonSpacing : integer;
    sShowIcon    : boolean;
    FButtonList  : array of TButtonRecord;
    Background   : TBitmap32;
    FHintWnd     : hwnd; 
    procedure ClearButtons;
    procedure AddButton(pTarget,pIcon,pCaption : String; Index : integer = -1);
    procedure UpdateButtons;
  public
    ModuleID : integer;
    BarID : integer;
    BarWnd : hWnd;
    OldLBWindowProc: TWndMethod;
    procedure RefreshIcons;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure SetWidth(new : integer);
    procedure UpdateBackground(new : integer = -1);
    procedure LBWindowProc(var Message: TMessage);
    procedure WMDropFiles(var msg: TMessage); message WM_DROPFILES;
  end;


implementation

uses SettingsWnd;

{$R *.dfm}

procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := params.ExStyle or WS_EX_ACCEPTFILES;
end;

procedure TMainForm.LBWindowProc(var Message: TMessage);
begin
  if Message.Msg = WM_DROPFILES then
     WMDropFiles(Message);
  OldLBWindowProc(Message);
end;

procedure TMainForm.WMDropFiles(var msg: TMessage);
var
  pcFileName: PChar;
  i, iSize, iFileCount: integer;
  p : TPoint;
  n : integer;
  index : integer;
begin
  index := High(FButtonList) + 1;
  p := ScreenToClient(Mouse.CursorPos);
  for n := 0 to High(FButtonList) do
   if p.x < FButtonList[n].btn.Left then
   begin
     index := n - 1;
     break;
   end;

  pcFileName := '';
  iFileCount := DragQueryFile(Msg.wParam, $FFFFFFFF, pcFileName, 255);
  for i := 0 to iFileCount - 1 do
  begin
     iSize := DragQueryFile(Msg.wParam, i, nil, 0) + 1;
     pcFileName := StrAlloc(iSize);
     DragQueryFile(Msg.wParam, i, pcFileName, iSize);
     AddButton(pcFileName,'shell:icon',ExtractFileName(pcFileName),index);
     StrDispose(pcFileName);
  end;
  DragFinish(Msg.wParam);
  sb_config.Left := -200;  
  UpdateButtons;
  SaveSettings;
  RealignComponents(True);
end;

procedure TMainForm.ClearButtons;
var
  n : integer;
begin
  for n := 0 to High(FButtonList) do
  begin
    FButtonList[n].btn.Free;
    ToolTipApi.DeleteToolTip(FHintWnd,self,n);
  end;
  setlength(FButtonList,0);
end;

procedure TMainForm.AddButton(pTarget,pIcon,pCaption : String; Index : integer = -1);
var
  n : integer;
begin
  setlength(FButtonList,length(FButtonList)+1);
  if (Index < Low(FButtonList)) or (Index > High(FButtonList)) then
    Index := High(FButtonList)
    else for n := High(FButtonList) downto Index + 1 do
      begin
        FButtonList[n].btn := FButtonList[n-1].btn;
        FButtonList[n].target := FButtonList[n-1].target;
        FButtonList[n].caption := FButtonList[n-1].caption;
        FButtonList[n].icon := FButtonList[n-1].icon;
      end;
  with FButtonList[Index] do
  begin
    btn := TSharpEButton.Create(self);
    btn.Visible := False;
    btn.AutoPosition := True;
    btn.AutoSize := True;
    btn.GlyphResize := True;
    btn.Hint := pTarget;
    btn.Width := sWidth;
    btn.Parent := self;
    btn.left := FButtonSpacing + High(FButtonList)*FButtonSpacing + High(FButtonList)*sWidth;
    btn.OnMouseUp := btnMouseUp;
    btn.SkinManager := SharpESkinManager1;
    ToolTipApi.AddToolTip(FHintWnd,self,High(FButtonList),
                          Rect(btn.left,btn.top,btn.Left + btn.Width,btn.Top + btn.Height),
                          pCaption);

    caption := pCaption;
    target := pTarget;
    icon := pIcon;

    if sShowLabel then
    begin
      btn.Caption := pCaption;
      btn.GlyphSpacing := 4;
    end else
    begin
      btn.Caption := '';
      btn.GlyphSpacing := 0;
    end;

    if sShowIcon then
    begin
      if not IconStringToIcon(pIcon,pTarget,btn.Glyph32) then
         btn.Glyph32.SetSize(0,0)
    end else btn.Glyph32.SetSize(0,0);
  end;
end;

procedure TMainForm.RefreshIcons;
var
  n : integer;
begin
  if not sShowIcon then exit;

  for n := 0 to High(FButtonList) do
      with FButtonList[n] do
           if not IconStringToIcon(Icon,Target,btn.Glyph32) then
              btn.Glyph32.SetSize(0,0)
end;

procedure TMainForm.SaveSettings;
var
  XML : TJvSimpleXML;
  n : integer;
begin
  XML := TJvSimpleXMl.Create(nil);
  XML.Root.Name := 'MenuModuleSettings';
  with XML.Root.Items do
  begin
    Add('Width',sWidth);
    Add('ShowLabel',sShowLabel);
    Add('ShowIcon',sShowIcon);
    with Add('Buttons').Items do
    begin
      for n := 0 to High(FButtonList) do
      with FButtonList[n] do
           with Add('item').Items do
           begin
             Add('Target',Target);
             Add('Icon',Icon);
             Add('Caption',Caption);
           end;
    end;
  end;
  XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
  XML.Free;
end;

procedure TMainForm.sb_configClick(Sender: TObject);
begin
  Settings1.OnClick(Settings1);
end;

procedure TMainForm.UpdateButtons;
var
  n : integer;
begin
  for n := 0 to High(FButtonList) do
      with FButtonList[n] do
      begin
        btn.Width := sWidth;
        btn.Left := FButtonSpacing + n*FButtonSpacing + n*sWidth;
        if btn.Left + btn.Width < Width then
           btn.Visible := True
           else btn.Visible := False;
        ToolTipApi.UpdateToolTipRect(FHintWnd,self,High(FButtonList),
                                     Rect(btn.left,btn.top,btn.Left + btn.Width,btn.Top + btn.Height));
      end;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJvSimpleXML;
  fileloaded : boolean;
  n : integer;
begin
  ClearButtons;

  sWidth       := 25;
  sShowLabel   := False;
  sShowIcon    := True;
  FButtonSpacing := 2;

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
      sWidth       := IntValue('Width',25);
      sShowLabel   := BoolValue('ShowLabel',False);
      sShowIcon    := BoolValue('ShowIcon',sShowIcon);
      if ItemNamed['Buttons'] <> nil then
      with ItemNamed['Buttons'].Items do
           for n := 0 to Count - 1 do
               AddButton(Item[n].Items.Value('Target','C:\'),
                         Item[n].Items.Value('Icon','shell:icon'),
                         Item[n].Items.Value('Caption','C:\'));
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
  new := Max(new,1);

  UpdateBackground(new);

  Width := new;

  UpdateButtons;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  self.Caption := 'ButtonBar';
  if sWidth<20 then sWidth := 20;

  sb_config.Visible := (length(FButtonList) = 0);
  if sb_config.Visible then
  begin
    sb_config.Left := 2;
    newWidth := sb_config.Left + sb_config.Width + 2
  end
  else newWidth := FButtonSpacing + High(FButtonList)*FButtonSpacing + length(FButtonList)*sWidth + FButtonSpacing;

  self.Tag := NewWidth;
  self.Hint := inttostr(NewWidth);

  if (BroadCast) and (newWidth <> Width) then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0)
     else UpdateButtons;
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  n : integer;
begin
  try
    SettingsForm := TSettingsForm.Create(application.MainForm);
    SettingsForm.cb_labels.Checked  := sShowLabel;
    SettingsForm.cb_icon.Checked := sShowIcon;
    SettingsForm.tb_size.Position   := sWidth;
    for n := 0 to High(FButtonList) do
        with FButtonList[n] do
             SettingsForm.AddButton(Target,Caption,Icon);

    if SettingsForm.ShowModal = mrOk then
    begin
      sShowLabel := SettingsForm.cb_labels.Checked;
      sWidth := SettingsForm.tb_size.Position;
      sShowIcon := SettingsForm.cb_icon.Checked;

      ClearButtons;
      for n := 0 to SettingsForm.buttons.Items.Count - 1 do
          with SettingsForm.buttons.Items.Item[n] do
               AddButton(SubItems[0],SubItems[1],Caption);

      SaveSettings;
    end;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.btnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ActionStr : String;
begin
  if Button = mbLeft then
  begin
    ActionStr := TSharpEButton(Sender).Hint;
    if UPPERCASE(ActionStr) = '!SHOWMENU' then SetForegroundWindow(FindWindow(nil,'SharpMenuWMForm'));
    SharpApi.SharpExecute(ActionStr);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Background := TBitmap32.Create;
  DoubleBuffered := True;
  FHintWnd := ToolTipApi.RegisterToolTip(self);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Background.Free;
  if FHintWnd <> 0 then
     DestroyWindow(FHintWnd);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  if Background <> nil then
     Background.DrawTo(Canvas.Handle,0,0);
end;

end.
