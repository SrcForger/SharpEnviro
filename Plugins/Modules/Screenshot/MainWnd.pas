{
Source Name: MainWnd.pas
Description: SharpE Bar Module - Main Window
Copyright (C) Ron Nicholson <sylaei@gmail.com>

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
  // Default Units
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, Math, Clipbrd, shellctrls, jpeg,
  // Custom Units
  JvSimpleXML, GR32, SharpESkinManager, SharpEBaseControls, SharpEButton,
  GR32_Image, PngImage,
  // SharpE Units
  SharpApi, uSharpBarAPI, SharpESkin, SharpEScheme, SharpEImage32, Buttons,
  PngBitBtn;
type
  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    MenuSettingsItem: TMenuItem;
    SkinManager: TSharpESkinManager;
    svdSave: TSaveDialog;
    btnSS: TSharpEButton;
    procedure btnSSMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuSettingsItemClick(Sender: TObject);
    procedure ScreenShot();
    procedure SaveAsDlg(bitMap: TBitmap);
    procedure AutoGen(bitMap: TBitmap);
    procedure saveFormat(bitMap: TBitmap; strFormat: string; strFilename: string);
    procedure WMShellHook(var msg : TMessage); message WM_SHARPSHELLMESSAGE;

  protected
  private
    blnClipboard : boolean;
    blnSaveDlg : boolean;
    blnAutoGen : boolean;
    blnAutoGenNum : boolean;
    blnDateTime : boolean;
    blnActiveWin : boolean;
    intDateTimeFormat : integer;
    strFilename : string;
    strAppend : string;
    strLocation : string;
    strFormat : string;
    hwndActive : hWnd;
    blnJpgGrayScale : boolean;
    intJpgCompression : integer;
    intPngCompression : integer;

  public
    ModuleID : integer;
    BarWnd : hWnd;
    Background : TBitmap32;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure SetWidth(new : integer);
    procedure UpdateBackground(new : integer = -1);
  end;

const CAPTUREBLT = $40000000;

implementation

uses SettingsWnd;

{$R *.dfm}

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    blnClipboard := BoolValue('Clipboard', True);
    blnSaveDlg := BoolValue('SaveAs', False);
    blnAutoGen := BoolValue('AutoGen', False);
    blnAutoGenNum := BoolValue('AutoGenNum', False);
    blnActiveWin := BoolValue('ActiveWin', False);
    blnDateTime := BoolValue('DateTime', False);
    intDateTimeFormat := IntValue('DateTimeFormat', 0);
    strFilename := Value('Filename', 'Screenshot');
    strAppend := Value('Append', '0');
    strLocation := Value('Location', strLocation);
    strFormat := Value('Format', 'Bmp');
    intJpgCompression := IntValue('JpgCompression', 75);
    blnJpgGrayScale := BoolValue('JpgGrayScale', False);
    intPngCompression := IntValue('PngCompression', 5);
  end;
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
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  self.Caption := 'ScreenShot' ;
  btnSS.Width := btnSS.Height;
  btnSS.Left := 2;
  newWidth := btnSS.Width + 4;
  self.Tag := NewWidth;
  self.Hint := inttostr(NewWidth);
  if (BroadCast) and (newWidth <> Width) then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;

procedure TMainForm.MenuSettingsItemClick(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  try

    SettingsForm := TSettingsForm.Create(nil);
    SettingsForm.cbxClipboard.Checked := blnClipboard;
    SettingsForm.cbxSaveAs.Checked := blnSaveDlg;
    SettingsForm.cbxSaveToFile.Checked := blnAutoGen;
    SettingsForm.cbxNum.Checked := blnAutoGenNum;
    SettingsForm.tbxFilename.Text := strFilename;
    SettingsForm.tbxNum.Text := strAppend;
    SettingsForm.DlbFolders.Directory := strLocation;
    SettingsForm.tbxFilename.Enabled := blnAutoGen;
    SettingsForm.tbxNum.Enabled := blnAutoGenNum;
    SettingsForm.cbxNum.Enabled := blnAutoGen;
    SettingsForm.cbxDateTime.Checked := blnDateTime;
    SettingsForm.cbxDateTimeFormat.Enabled := blnDateTime;
    SettingsForm.cbxDateTimeFormat.ItemIndex := intDateTimeFormat;
    SettingsForm.cbxActive.Checked := blnActiveWin;
    SettingsForm.cbxFormat.Text := strFormat;
    SettingsForm.speJpgCompression.Value := intJpgCompression;
    SettingsForm.chkJpgGrayscale.Checked := blnJpgGrayscale;
    SettingsForm.spePngCompression.Value := intPngCompression;
    if SettingsForm.ShowModal = mrOk then
    begin
      blnClipboard := SettingsForm.cbxClipboard.Checked;
      blnSaveDlg := SettingsForm.cbxSaveAs.Checked;
      blnAutoGen := SettingsForm.cbxSaveToFile.Checked;
      blnAutoGenNum := SettingsForm.cbxNum.Checked;
      blnDateTime := SettingsForm.cbxDateTime.Checked;
      blnActiveWin := SettingsForm.cbxActive.Checked;
      strFilename := SettingsForm.tbxFilename.Text;
      strAppend := SettingsForm.tbxNum.Text;
      strLocation := SettingsForm.DlbFolders.Directory;
      intDateTimeFormat := SettingsForm.cbxDateTimeFormat.ItemIndex;
      strFormat := SettingsForm.cbxFormat.Text;
      intJpgCompression := SettingsForm.speJpgCompression.Value;
      blnJpgGrayscale := SettingsForm.chkJpgGrayscale.Checked;
      intPngCompression := SettingsForm.spePngCompression.Value;
      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        Clear;
        Add('Clipboard',blnClipboard);
        Add('SaveAs', blnSaveDlg);
        Add('AutoGen', blnAutoGen);
        Add('AutoGenNum', blnAutoGenNum);
        Add('ActiveWin', blnActiveWin);
        Add('DateTime', blnDateTime);
        Add('DateTimeFormat', intDateTimeFormat);
        Add('Filename', strFilename);
        Add('Append', strAppend);
        Add('Location', strLocation);
        Add('Format', strFormat);
        Add('JpgCompression', intJpgCompression);
        Add('JpgGrayscale', blnJpgGrayscale);
        Add('PngCompression', intPngCompression);
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
    end;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Background := TBitmap32.Create;
  DoubleBuffered := True;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  PostMessage(BarWnd,WM_UNREGISTERSHELLHOOK,self.handle,0);
  Background.Free;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Background.DrawTo(Canvas.Handle,0,0);
end;

procedure TMainForm.ScreenShot();
var
  bitMap: TBitmap;
  hdcSrc : THandle;
  dc : HDC;
  r : TRect;
begin
  try
    begin
      bitMap := TBitmap.Create;
      if (blnActiveWin) then
      begin
       if (hwndActive <> 0)then
        begin
         SetForeGroundWindow(hwndActive);
         dc := GetWindowDC(hwndActive);
         GetWindowRect(hwndActive,r);
         bitMap.Width := r.Right - r.Left;
         bitMap.Height := r.Bottom - r.Top;
         BitBlt(bitMap.Canvas.Handle, 0, 0, bitMap.Width, bitMap.Height,dc, 0, 0, SRCCOPY or CAPTUREBLT);
        end
       end
      else
      begin
        hdcSrc := GetWindowDC(GetDesktopWindow);
        bitMap.Width  := Screen.Width;
        bitMap.Height := Screen.Height;
        BitBlt(bitMap.Canvas.Handle, 0, 0, bitMap.Width, bitMap.Height,hdcSrc, 0, 0, SRCCOPY or CAPTUREBLT);
      end;
      if (blnClipboard) then Clipboard.Assign(bitMap);
      if (blnSaveDlg) then SaveAsDlg(bitMap);
      if (blnAutoGen) then AutoGen(bitMap);

      end;
  finally
    ReleaseDC(0, hdcSrc);
  end;
end;

procedure TMainForm.SaveAsDlg(bitMap : TBitmap);
begin
    svdSave.InitialDir := strLocation;
    if svdSave.Execute then
    begin
      saveFormat(bitMap, strFormat, svdSave.FileName);
    end;
end;

procedure TMainForm.AutoGen(bitMap : TBitmap);
var
  count: integer;
  strFile: string;
  strName : string;
  strDTFormat : string;
  dtmDate : TDateTime;
  item : TJvSimpleXMLElem;
begin
  strFile := strLocation;
  strFile := strFile + '\';
  strFile := strfile + strFilename;
  if blnAutoGenNum then strFile := strFile + ' ' + strAppend;
  if (blnDateTime) then
  begin
    if intDateTimeFormat = 0 then strDTFormat := 'DDMMYYYYHHMMSS'
    else strDTFormat := 'MMDDYYYYHHMMSS';
    dtmDate := Now();
    DateTimeToString(strName, strDTFormat, dtmDate);
    strFile := strFile + ' - ' + strName;
  end;
  if blnAutoGenNum then
  begin
    count := StrToInt(strAppend);
    count := count + 1;
    strAppend := IntToStr(count);
  end;
  saveFormat(bitMap, strFormat, strFile);
  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    Clear;
    Add('Append', strAppend);
  end;
  uSharpBarAPI.SaveXMLFile(BarWnd);
end;

procedure TMainForm.saveFormat(bitMap: TBitmap; strFormat: string; strFilename: string);
var
  JPG: TJPEGImage;
  PNG: TPNGObject;
begin
   if (strFormat = 'Jpg') then
   begin
      JPG := TJPEGImage.Create;
      Try
        JPG.Grayscale := blnJpgGrayscale;
        JPG.CompressionQuality := intJpgCompression;
        JPG.Assign(bitMap);
        strFilename := strFilename + '.jpg';
        JPG.SaveToFile(strFilename);
      Finally
        JPG.Free;
      end;
   end
   else if (strFormat = 'Png') then
   begin
       PNG := TPNGObject.Create;
       Try
        PNG.CompressionLevel := intPngCompression;
        PNG.Assign(bitMap);
        strFilename := strFilename + '.png';
        PNG.SaveToFile(strFilename);
       Finally
        PNG.Free;
       end;
   end
   else
   begin
      Try
        strFilename := strFilename + '.bmp';
        bitMap.SaveToFile(strFilename);
      Finally
        bitMap.Free;
      end;
   end;

end;

procedure TMainForm.btnSSMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
        ScreenShot();
  end;
end;

procedure TMainForm.WMShellHook(var msg : TMessage);
begin
  if msg.LParam = self.Handle then exit;
  if msg.LParam = 0 then exit;
  case msg.WParam of
     HSHELL_WINDOWACTIVATED : hwndActive := msg.LParam;
  end;
end;

end.


