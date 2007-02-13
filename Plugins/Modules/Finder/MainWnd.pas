{
Source Name: MainWnd.pas
Description: Finder Main Window
Copyright (C) Viper <tom_viper@msn.com>

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
  StdCtrls, Math, Menus, GR32, GR32_Image, SharpEBaseControls, SharpEButton,
  SharpESkinManager, SharpEScheme, SharpESkin, ExtCtrls,
  JvSimpleXML, SharpApi, SharpProcess, ShellHookTypes, COMMCTRL, dialogs;

type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    SharpEButton1: TSharpEButton;
    popTasks: TPopupMenu;
    Image1: TImage;
    procedure SharpEButton1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);

    procedure Settings1Click(Sender: TObject);
  protected
  private
    sWidth : integer;

    gImageList1: HWND;

    ImageList1: TImageList;

    procedure GenericMouseClick(Sender: TObject);

    procedure WMHSHELLBROADCAST(var Msg: TMessage); message WM_HSHELL_BROADCAST;

    procedure WMSHARPEUPDATEACTIONS(var Msg : TMessage); message WM_SHARPEUPDATEACTIONS;
    procedure WMSHARPEACTIONMESSAGE(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;
  public
    BangCommand_Append: string;

    ModuleID : integer;
    BarWnd : hWnd;

    procedure BuildTaskMenu;
    procedure EmptyTaskMenu;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure RegisterBangs;
    procedure SetSize(NewWidth : integer);
    procedure UnRegisterBangs;
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI;

{$R *.dfm}

{$REGION ' Form Events, Overrides and Message Traps '}
procedure TMainForm.FormCreate(Sender: TObject);
begin
  gImageList1 := ImageList_Create(16, 16, ILC_COLOR32 or ILC_MASK, 0, 1);
  ImageList1 := TImageList.Create(Self);
  ImageList1.Handle := gImageList1;

  popTasks.Images := ImageList1;

  SharpEButton1.Glyph32.Assign(Image1.Picture.Bitmap);
end;
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//
end;
procedure TMainForm.FormDestroy(Sender: TObject);
begin
  ImageList_RemoveAll(gImageList1);

  ImageList_Destroy(gImageList1);

  FreeAndNil(ImageList1);
end;
procedure TMainForm.WMHSHELLBROADCAST(var Msg: TMessage);
begin
//  BuildTaskMenu;
end;
procedure TMainForm.WMSHARPEUPDATEACTIONS(var Msg : TMessage);
begin
  RegisterBangs;
end;
procedure TMainForm.WMSHARPEACTIONMESSAGE(var Msg : TMessage);
begin
//  case msg.LParam of
//    0: edit.SetFocus;
//  end;
end;
{$ENDREGION}

{$REGION ' Configuration Procedures '}
procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  sWidth := 32;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if (item <> nil) then with item.Items do
   begin
    sWidth := IntValue('Width',32);
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
    SettingsForm.tb_size.Position := sWidth;

    if (SettingsForm.ShowModal = mrOk) then
    begin
      sWidth := SettingsForm.tb_size.Position;

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
//    SettingsForm := nil;
    SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
  end;
end;
{$ENDREGION}

{$REGION ' Misc Procedures '}
procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  if (sWidth < 20) then sWidth := 20;

  SharpEButton1.Glyph32.Clear(color32(0,0,0,0));
  SharpEButton1.Glyph32.Assign(Image1.Picture.Bitmap);

  SharpEButton1.Left := 2;

//  edit.Left := 2;

  newWidth := (sWidth + 4);

  Tag := newWidth;
  Hint := inttostr(newWidth);

  if (newWidth <> Width) then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;
procedure TMainForm.SetSize(NewWidth : integer);
begin
  Width := NewWidth;
  SharpEButton1.Width := max(1,NewWidth - 4);
  Background.Bitmap.BeginUpdate;
  Background.Bitmap.SetSize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background.Bitmap,self);
  Background.Bitmap.EndUpdate;
end;
{$ENDREGION}

{$REGION ' Bang Procedures '}
procedure TMainForm.RegisterBangs;
begin
//  SharpApi.RegisterActionEx(PChar('!FocusGoogleCmd' + BangCommand_Append),'Modules',Handle,0);
end;
procedure TMainForm.UnRegisterBangs;
begin
//  SharpApi.UnRegisterAction(PChar('!FocusGoogleCmd' + BangCommand_Append));
end;
{$ENDREGION}

{$REGION ' Task Menu Procedures '}
procedure TMainForm.BuildTaskMenu;
var
  i, j: integer;
  test: TSharpTask;
  miItem: TMenuItem;
begin
  //This is the first text mode version of "my" Finder module
  //Really crude code throughout.
  test := TSharpTask.Create;
  try
    EmptyTaskMenu;

    ImageList_RemoveAll(gImageList1);

    test.Build;

//    test.

    j := pred(test.WindowList.Count);
    for i := 0 to j do
     begin
      miItem := TMenuItem.Create(popTasks);

      try
       miItem.Caption := PTProcessObject(test.WindowList.Items[i]).Caption;
       miItem.Tag := PTProcessObject(test.WindowList.Items[i]).Handle;
       miItem.ImageIndex := ImageList_AddIcon(gImageList1, PTProcessObject(test.WindowList.Items[i]).Icon);
       miItem.OnClick := GenericMouseClick;
       popTasks.Items.Add(miItem);
      except
      end;
     end;
  finally
    test.Empty;

    FreeAndNil(test);
  end;
end;
procedure TMainForm.EmptyTaskMenu;
begin
  popTasks.Items.Clear;
end;
{$ENDREGION}

procedure TMainForm.SharpEButton1Click(Sender: TObject);
var
  x, CaptionHeight, BreakHeight,
  ExtraPixels, TotalHeight : integer;
  Test: TRect;
begin
  BuildTaskMenu;

  //Since users want floating bars, we need to try and better
  //determine where to popup our Task menu
  TotalHeight   := 0;
  BreakHeight   := 2;
  ExtraPixels   := 6;
  CaptionHeight := Canvas.TextHeight('Wg');

  for x := 0 to popTasks.Items.Count - 1 do
   begin
    if popTasks.Items.Items[x].Caption = '-' then TotalHeight := TotalHeight + BreakHeight
    else TotalHeight := TotalHeight + CaptionHeight;
    TotalHeight := TotalHeight + ExtraPixels;
   end;

  if TotalHeight <> 0 then
   begin
    TotalHeight := TotalHeight + ExtraPixels;

    GetWindowRect(Handle,Test);

    //Stupid top/bottom check. This will be changed shortly
    //to something real and more effective
    if (test.Top < (Screen.DesktopHeight div 2)) then
     begin
      popTasks.Popup(Test.Left,Test.Top + Height);
     end
    else
     begin
      popTasks.Popup(Test.Left, Test.Top - TotalHeight);
     end;
   end;
end;

procedure TMainForm.GenericMouseClick(Sender: TObject);
var
  test: TSharpTask;
begin
  test := TSharpTask.Create;

  try
    test.ActivateWindow((Sender as TMenuItem).Tag);
  finally
    FreeAndNil(test);
  end;
end;

end.
