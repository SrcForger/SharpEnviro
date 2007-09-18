{
Source Name: MainWnd.pas
Description: iDrop Module Main Form
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32_Image,
  SharpESkinManager, SharpEScheme, SharpESkin, ExtCtrls, SharpECustomSkinSettings,
  JvSimpleXML, SharpApi,shellAPI, Menus, JclFileUtils, GR32, GR32_Ellipse;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    AnimTimer: TTimer;
    SkinManager: TSharpESkinManager;
    procedure AnimTimerTimer(Sender: TObject);
    procedure BackgroundDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    sWidth  : integer;
    sTarget : String;
    FCustomBmp : TBitmap32;
    FCustomBlendColor : integer;
    FCustomSkinSettings: TSharpECustomSkinSettings;
  public
    ModuleID : integer;
    BarWnd : hWnd;
    BGBmp : TBitmap32;
    OldLBWindowProc: TWndMethod;
    lastcolor : TColor;
    procedure LBWindowProc(var Message: TMessage);
    procedure WMDropFiles(var msg: TMessage); message WM_DROPFILES;
    procedure LoadSettings;
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(BroadCast : boolean);
    procedure Draw(startcolor : Tcolor; ck : boolean);
    procedure UpdateCustomSettings;
  end;


implementation

uses SettingsWnd,
     Math,
     GR32_PNG,
     uSharpBarAPI,
     SharpESkinPart;

{$R *.dfm}

procedure TMainForm.UpdateCustomSettings;
var
  dir : String;
  s   : String;
  b   : boolean;
  tmp : TBitmap32;
begin
  FCustomSkinSettings.LoadFromXML('');
  if FCustomBmp <> nil then FreeAndNil(FCustomBmp);
  try
    with FCustomSkinSettings.xml.Items do
    begin
      if ItemNamed['idrop'] <> nil then
      begin
        with FCustomSkinSettings.xml.Items.ItemNamed['idrop'] do
        begin
          {$WARNINGS OFF}
          dir := IncludeTrailingBackSlash(FCustomSkinSettings.Path);
          {$WARNINGS ON}
          if items.ItemNamed['blendcolor'] <> nil then
          begin
            s := items.Value('blendcolor',inttostr(clwhite));
            FCustomBlendColor := SharpESkinPart.SchemedStringToColor(s,SkinManager.Scheme);
          end else s := '-1';
          if FileExists(dir + items.Value('background')) then
          begin
            FCustomBmp := TBitmap32.Create;
            tmp        := TBitmap32.Create;
            try
              GR32_PNG.LoadBitmap32FromPNG(tmp,dir + items.Value('background'),b);
              if CompareText(s,'-1') <> 0 then
                 SharpESkinPart.doBlend(FCustomBmp,tmp,FCustomBlendColor);
            except
              FreeAndNil(FCustomBmp);
            end;
            tmp.Free;
          end
        end;
      end;
    end;
  except
  end;
end;

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
  Fo      : TSHFILEOpStruct;
  buffer  : array[0..4096] of char;
  p       : pchar;
begin
   if not IsDirectory(sTarget) then
   begin
      showmessage('Target directory does not exists!');
      exit;
   end;
   AnimTimer.Tag := 0;
   AnimTimer.Interval := 250;
   AnimTimer.Enabled := True;
   pcFileName := '';
   iFileCount := DragQueryFile(Msg.wParam, $FFFFFFFF, pcFileName, 255);
   FillChar(Buffer, sizeof(Buffer), #0);
   p := @buffer;
   for i := 0 to iFileCount - 1 do
   begin
      iSize := DragQueryFile(Msg.wParam, i, nil, 0) + 1;
      pcFileName := StrAlloc(iSize);
      DragQueryFile(Msg.wParam, i, pcFileName, iSize);
      if i<>iFileCount-1 then p := StrECOPY(p, pcFileName) + 1
         else StrECopy(p,pcFileName);
      StrDispose(pcFileName);
   end;

   FillChar(Fo, sizeof(Fo), #0);
   Fo.Wnd    := Handle;
   if GetKeyState(VK_SHIFT) < 0 then Fo.wFunc := FO_MOVE
       else Fo.wFunc  := FO_COPY;
   Fo.pFrom  := @Buffer;
   Fo.pTo    := PChar(sTarget);
   Fo.fFlags := 0;
   SHFILEOperation(Fo);
   DragFinish(Msg.wParam);
   AnimTimer.Interval := 250;
   AnimTimer.Tag := 1;
end;

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  sWidth  := Height;
  sTarget := 'X:\';

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sTarget := Value('Target','X:\');
  end;

  UpdateCustomSettings;
end;

procedure TMainForm.Draw(startcolor : Tcolor; ck : boolean);
var
  n : integer;
  s : integer;
  Bmp : TBitmap32;
  c : TColor;
begin
  if BGBmp = nil then exit;
  if Background.Bitmap = nil then exit;
  if BGBmp.Width < 1 then exit;

  if FCustomBmp <> nil then
  begin
    BGBmp.DrawTo(Background.Bitmap);
    FCustomBmp.CombineMode := cmMerge;
    FCustomBmp.DrawMode := dmBlend;
    FCustomBmp.DrawTo(Background.Bitmap,
                      width div 2 - FCustomBmp.Width div 2,
                      height div 2 - FCustomBmp.Height div 2); 
    exit;
  end;

  cs := LoadColorSchemeEx;
  Bmp := TBitmap32.Create;
  try
    Bmp.Assign(BGBmp);
    try
      n := 0;
      s := 4;
      if startcolor = 0 then
         c := cs.WorkAreaback
         else c := startcolor;
      repeat
        Ellipse(Bmp,Rect(4+n*s,1+n*s,Bmp.Width-4-n*s,Bmp.Height-1-n*s),True, True,clBlack32,color32(c));
        if ck then
        begin
          if c = cs.WorkAreaback then
             c := cs.Throbberback else c := cs.WorkAreaback;
        end;
        n := n + 1;
      until Bmp.Height - 1 - n*s - 1 - n*s <=4;
    except
    end;
    Bmp.DrawTo(Background.Bitmap);
  finally
    Bmp.Free;
  end;
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
  Width := NewWidth;

  Background.Bitmap.BeginUpdate;
  Background.Bitmap.SetSize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background.Bitmap,self);
  Background.Bitmap.EndUpdate;
  BGBmp.Assign(Background.Bitmap);

  Draw(0,True);
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newwidth : integer;
begin
  if FCustomBmp <> nil then
     newwidth := max(2,FCustomBmp.Width + 4)
     else newwidth := Height + 8;

  Tag := newwidth;
  Hint := inttostr(newwidth);
  if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
  Draw(0,True);
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  try
    SettingsForm := TSettingsForm.Create(application.MainForm);
    SettingsForm.edit_target.Text := sTarget;
    if SettingsForm.ShowModal = mrOk then
    begin
      sTarget  := SettingsForm.edit_target.Text;

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        clear;
        Add('Target',sTarget);
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
      ReAlignComponents(True);
    end;

  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  BGBmp := TBitmap32.Create;
  FCustomSkinSettings := TSharpECustomSkinSettings.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(BGBmp);
  FreeAndNil(FCustomSkinSettings);
  if FCustomBmp <> nil then  FreeAndNil(FCustomBmp);
end;

procedure TMainForm.BackgroundDblClick(Sender: TObject);
begin
  {$WARNINGS OFF}
  SharpApi.SharpExecute(IncludeTrailingBackSlash(sTarget));
  {$WARNINGS ON}
end;

procedure TMainForm.AnimTimerTimer(Sender: TObject);
begin
  if FCustomBmp <> nil then
  begin
    AnimTimer.Enabled := False;
    exit;
  end;

  if AnimTimer.Tag <1 then
  begin
    if LastColor = cs.WorkAreaback then
       LastColor := cs.ThrobberBack else LastColor := cs.WorkAreaback;
    Draw(LastColor,True);
  end
  else
  begin
    AnimTimer.Tag := AnimTimer.Tag +1;
    if LastColor = cs.WorkAreaback then
       LastColor := cs.ThrobberBack else LastColor := cs.WorkAreaback;
    Draw(LastColor,False);
  end;
  if AnimTimer.Tag >= 8 then
  begin
    AnimTimer.Enabled := False;
    Draw(0,True);
  end;
end;

end.
