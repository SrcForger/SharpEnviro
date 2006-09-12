{
Source Name: MainWnd.pas
Description: VWM Main Window
Copyright (C) Viper <tom_viper@msn.com>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General PublicLicense as published by the Free Software Foundation; either
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
  StdCtrls, Math, Menus, GR32_Image, SharpEBaseControls, SharpEButton,
  SharpESkinManager, SharpEScheme, SharpESkin, ExtCtrls, uSharpBarAPI,
  JvSimpleXML, SharpApi, ShellHookTypes, SharpProcess, HotKeyManager, Dialogs;

type
  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    background: TImage32;
    SharpEButton1: TSharpEButton;
    SharpEButton2: TSharpEButton;
    SharpEButton3: TSharpEButton;
    SharpEButton4: TSharpEButton;
    HotKeyManager1: THotKeyManager;
    procedure HotKeyManager1HotKeyPressed(HotKey: Cardinal; Index: Word);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);

    procedure Settings1Click(Sender: TObject);

    procedure GenericButtonClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    sWidth : integer;

    procedure WMHSHELLBROADCAST(var Msg: TMessage); message WM_HSHELL_BROADCAST;

    procedure WMSHARPEUPDATEACTIONS(var Msg : TMessage); message WM_SHARPEUPDATEACTIONS;
    procedure WMSHARPEACTIONMESSAGE(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;
    procedure WMSHARPVWMMESSAGE(var Msg: TMessage); message WM_SHARPVWMMESSAGE;
  public
    ModuleID : integer;
    BarWnd : hWnd;

    BangCommand_Append: string;

    iCurrentDesktop: integer;

    procedure GiveSmallChildrenTheFinger(bRecallMode: boolean = false; iDeskCount: integer = 0);
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure RecallWindows;
    procedure RegisterBangs;
    procedure RegisterHotkeys;
    procedure SetSize(NewWidth : integer);
    procedure UnRegisterBangs;
    procedure UnRegisterHotkeys;
  end;

implementation

uses SettingsWnd;

{$R *.dfm}

const
  LOCALIZED_KEYNAMES = True;

{$REGION ' Form Events, Overrides and Message Traps '}
procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do begin
    WinClassName := 'SharpE_VWM';
  end;
end;
procedure TMainForm.FormCreate(Sender: TObject);
begin
  iCurrentDesktop := 0;
end;
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//
end;
procedure TMainForm.FormDestroy(Sender: TObject);
begin
//
end;

procedure TMainForm.WMHSHELLBROADCAST(var Msg: TMessage);
begin
//  PushAWindow(Msg.WParam,True,True);
end;
procedure TMainForm.WMSHARPEUPDATEACTIONS(var Msg : TMessage);
begin
  RegisterBangs;
end;
procedure TMainForm.WMSHARPEACTIONMESSAGE(var Msg : TMessage);
begin
  case msg.LParam of
    0: GenericButtonClick(SharpEButton1);
    1: GenericButtonClick(SharpEButton2);
    2: GenericButtonClick(SharpEButton3);
    3: GenericButtonClick(SharpEButton4);
  end;
end;
procedure TMainForm.WMSHARPVWMMESSAGE(var Msg: TMessage);
begin
  iCurrentDesktop := Msg.LParam;
end;
{$ENDREGION}

{$REGION ' Bang Procedures '}
procedure TMainForm.RegisterBangs;
begin
  SharpApi.RegisterActionEx(PChar('!ToggleDesktop1' + BangCommand_Append),'Modules',Handle,0);
  SharpApi.RegisterActionEx(PChar('!ToggleDesktop2' + BangCommand_Append),'Modules',Handle,1);
  SharpApi.RegisterActionEx(PChar('!ToggleDesktop3' + BangCommand_Append),'Modules',Handle,2);
  SharpApi.RegisterActionEx(PChar('!ToggleDesktop4' + BangCommand_Append),'Modules',Handle,3);
end;
procedure TMainForm.UnRegisterBangs;
begin
  SharpApi.UnRegisterAction(PChar('!ToggleDesktop1' + BangCommand_Append));
  SharpApi.UnRegisterAction(PChar('!ToggleDesktop2' + BangCommand_Append));
  SharpApi.UnRegisterAction(PChar('!ToggleDesktop3' + BangCommand_Append));
  SharpApi.UnRegisterAction(PChar('!ToggleDesktop4' + BangCommand_Append));
end;
{$ENDREGION}

{$REGION ' Configuration Procedures '}
procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  sWidth := 178;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if (item <> nil) then with item.Items do
   begin
    sWidth := IntValue('Width',178);
   end;

//  ReAlignComponents(False);
end;
procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  SettingsForm := TSettingsForm.Create(nil);
  try
//    SettingsForm.tb_size.Position := sWidth;

    if (SettingsForm.ShowModal = mrOk) then
    begin
//      sWidth := SettingsForm.tb_size.Position;

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if (item <> nil) then with item.Items do
      begin
        clear;
        Add('Width',sWidth);
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
    end;

    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
////    SettingsForm := nil;
//    SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
  end;
end;
{$ENDREGION}

{$REGION ' Misc Procedures '}
procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  SharpEButton1.Width := (Width div 4);
  SharpEButton2.Width := SharpEButton1.Width;
  SharpEButton3.Width := SharpEButton1.Width;
  SharpEButton4.Width := SharpEButton1.Width;

  if (sWidth < 20) then sWidth := 20;

  newWidth := sWidth + 4;

  Tag := newWidth;
  Hint := inttostr(newWidth);

  if (newWidth <> Width) then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;
procedure TMainForm.SetSize(NewWidth : integer);
begin
  Width := NewWidth;
//  edit.Width := max(1,NewWidth - 4);
end;

procedure TMainForm.GenericButtonClick(Sender: TObject);
var
  g, h: integer;
begin
  g := iCurrentDesktop;

  iCurrentDesktop := (Sender as TSharpEButton).Tag;

  h := (iCurrentDesktop - g);

  GiveSmallChildrenTheFinger(false, h);
end;
{$ENDREGION}

{$REGION ' Window Procedures '}
procedure TMainForm.RecallWindows;
begin
  GenericButtonClick(SharpEButton1);

  GiveSmallChildrenTheFinger(True);
end;
procedure TMainForm.GiveSmallChildrenTheFinger(bRecallMode: boolean = false; iDeskCount: integer = 0);
var
  i, j: integer;
  test: TSharpTask;
begin
  test := TSharpTask.Create;
  try
    test.Build;

    j := pred(test.WindowList.Count);
    for i := 0 to j do
     begin
      PushAWindow(PTProcessObject(test.WindowList.Items[i]).Handle,bRecallMode,True,iDeskCount);
     end;
    SharpEBroadCastEx(WM_SHARPVWMMESSAGE,0,iCurrentDesktop);
  finally
    test.Empty;

    FreeAndNil(test);
  end;
end;
{$ENDREGION}

{$REGION ' Hotkey Procedures '}
procedure TMainForm.RegisterHotkeys;
  procedure AddHotKey(szHotKey: string);
  var
    HotKeyVar: Cardinal;
  begin
    HotKeyVar := TextToHotKey(szHotKey, LOCALIZED_KEYNAMES);
    if (HotKeyVar <> 0) then
     begin
      if HotKeyAvailable(HotKeyVar) then
       begin
        HotKeyManager1.AddHotKey(HotKeyVar);
       end;
     end;
  end;
begin
  AddHotKey('Win+Up');
  AddHotKey('Win+Down');
  AddHotKey('Win+Left');
  AddHotKey('Win+Right');
end;
procedure TMainForm.UnRegisterHotkeys;
  procedure RemoveHotKey(szHotKey: string);
  var
    HotKeyVar: Cardinal;
  begin
    HotKeyVar := TextToHotKey(szHotKey, LOCALIZED_KEYNAMES);
    if (HotKeyVar <> 0) then
     begin
      if not HotKeyAvailable(HotKeyVar) then
       begin
        HotKeyManager1.RemoveHotKey(HotKeyVar);
       end;
     end;
  end;
begin
  RemoveHotKey('Win+Up');
  RemoveHotKey('Win+Down');
  RemoveHotKey('Win+Left');
  RemoveHotKey('Win+Right');
end;
procedure TMainForm.HotKeyManager1HotKeyPressed(HotKey: Cardinal; Index: Word);
var
  szHotKey: string;
begin
  szHotKey := HotKeyToText(HotKey,LOCALIZED_KEYNAMES);

  if (szHotKey = 'Win+Up') then GenericButtonClick(SharpEButton2);
  if (szHotKey = 'Win+Down') then GenericButtonClick(SharpEButton3);
  if (szHotKey = 'Win+Left') then GenericButtonClick(SharpEButton1);
  if (szHotKey = 'Win+Right') then GenericButtonClick(SharpEButton4);
end;
{$ENDREGION}

end.
