{
Source Name: uSharpDeskObjectInfoForm.pas
Description: Form for displaying informations about the selected object
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

unit uSharpDeskObjectInfoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  uSharpDeskDesktopObject;

type
  TObjectInfoForm = class(TForm)
    lb_version: TLabel;
    lb_LO: TLabel;
    lb_Filename: TLabel;
    lb_Description: TLabel;
    lb_author: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Image1: TImage;
    btn_close: TButton;
    procedure btn_closeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
    procedure LoadSettings(DesktopObject : TDesktopObject);
  end;

const
  VersionInfo: array [1..8] of string = (
    'CompanyName', 'FileDescription', 'FileVersion', 'InternalName',
    'LegalCopyRight', 'OriginalFileName', 'ProductName', 'ProductVersion');  

var
  ObjectInfoForm: TObjectInfoForm;

function GetFileInfo(FName, InfoType: string): string;

implementation

uses uSharpDeskMainForm,
     uSharpDeskFunctions;

{$R *.dfm}


function GetFileInfo(FName, InfoType: string): string;
var
  Info     : Pointer;
  InfoData : Pointer;
  InfoSize : LongInt;
  InfoLen  : {$IFDEF WIN32} DWORD;{$ELSE} LongInt; {$ENDIF}
  DataLen  : {$IFDEF WIN32} UInt; {$ELSE} word; {$ENDIF}
  LangPtr  : Pointer;
begin
  result:=''; DataLen:=255;
  if Length(FName)<=0 then exit;
  FName:=FName+#0;
  InfoSize:=GetFileVersionInfoSize(@Fname[1], InfoLen);
  if (InfoSize > 0) then
    begin
      GetMem(Info, InfoSize);
      try
        if GetFileVersionInfo(@FName[1], InfoLen, InfoSize, Info) then
          begin
            if VerQueryValue(Info,'\VarFileInfo\Translation',LangPtr, DataLen) then
              InfoType:=Format('\StringFileInfo\%0.4x%0.4x\%s'#0,[LoWord(LongInt(LangPtr^)),
                                                                  HiWord(LongInt(LangPtr^)), InfoType]);
            if VerQueryValue(Info,@InfoType[1],InfoData,Datalen) then
              Result := strPas(InfoData);
          end;
      finally
        FreeMem(Info, InfoSize);
      end;
    end;
end;


procedure TObjectInfoForm.LoadSettings(DesktopObject : TDesktopObject);
begin
     if DesktopObject = nil then exit;
     lb_FileName.Caption:=DesktopObject.Owner.FileName;
     lb_Version.Caption:='Version : ['+ GetFileInfo(DesktopObject.Owner.Path, 'FileVersion')+']';
     lb_Author.Caption:='Author : '+ GetFileInfo(DesktopObject.Owner.Path, 'Author') + ' ('+GetFileInfo(DesktopObject.Owner.Path, 'CompanyName')+')';
     lb_Description.Caption:=GetFileInfo(DesktopObject.Owner.Path, 'FileDescription');
     lb_lo.Caption:='Loaded Objects : '+inttostr(DesktopObject.Owner.Count);
end;

procedure TObjectInfoForm.btn_closeClick(Sender: TObject);
begin
     ObjectInfoForm.Close;
end;

procedure TObjectInfoForm.FormShow(Sender: TObject);
var
  n: integer;
begin
  n := GetCurrentMonitor;
  self.Left:=Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - self.Width div 2;
  self.top:=Screen.Monitors[n].Top + Screen.Monitors[n].Height div 2 - self.Height div 2;
end;

end.
