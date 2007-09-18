{
Source Name: iDrop - settingswnd.pas
Description: SharpBar Module - settings window         
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
unit SettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, JvSimpleXML, SharpApi, ShellApi, ActiveX, ShlObj;

type
  TSettingsForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    edit_target: TEdit;
    btn_ok: TButton;
    btn_select: TButton;
    btn_cancel: TButton;
    Label2: TLabel;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Image3: TImage;
    Image4: TImage;
    procedure btn_okClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure btn_selectClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;


implementation

{$R *.dfm}

procedure TSettingsForm.btn_okClick(Sender: TObject);
begin
  Self.ModalResult := mrOK;
end;

procedure TSettingsForm.btn_cancelClick(Sender: TObject);
begin
     Self.ModalResult := mrCancel;
end;

procedure TSettingsForm.btn_selectClick(Sender: TObject);
var
  pidl, pidlSelected: PItemIDList;
  bi: TBrowseInfo;
  szDirName: array [0..260] of AnsiChar;
begin
  {Get the root PIDL of the network neighborhood tree}
  if SHGetSpecialFolderLocation(Handle, CSIDL_DRIVES, pidl) = NOERROR then
  begin
    {Populate a BROWSEINFO structure}
    bi.hwndOwner := Handle;
    bi.pidlRoot := pidl;
    bi.pszDisplayName := szDirName;
    bi.lpszTitle := 'Select iDrop target';
    bi.ulFlags := BIF_RETURNONLYFSDIRS;
    bi.lpfn := nil;
    bi.lParam := 0;
    bi.iImage := - 1;
    {Display the "Browse For Folder" dialog box}
    pidlSelected := SHBrowseForFolder(bi);
    {NULL indicates that Cancel was selected from the dialog box}
    if pidlSelected <> nil then
    begin
      SHGetPathFromIDList(pidlSelected, szDirName);
      edit_target.Text:=szDirName;
      {Release the PIDL of the computer name}
      CoTaskMemFree(pidlSelected);
    end;
    {Release the PIDL of the network neighborhood tree}
    CoTaskMemFree(pidl);
  end;
end;

end.
