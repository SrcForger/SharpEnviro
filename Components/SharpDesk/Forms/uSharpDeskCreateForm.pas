{
Source Name: uSharpDeskCreateForm.pas
Description: Form for creating a new desktop object
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
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

unit uSharpDeskCreateForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SharpApi, ImgList, ComCtrls;

type
  TCreateForm = class(TForm)
    IconList: TImageList;
    edit_filter: TEdit;
    objects: TListView;
    btn_add: TButton;
    btn_cancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edit_filterChange(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
    procedure edit_filterKeyPress(Sender: TObject; var Key: Char);
    procedure objectsDblClick(Sender: TObject);
    procedure objectsKeyPress(Sender: TObject; var Key: Char);
  private
  public
    procedure BuildObjectList;
  end;


var
   CreateForm: TCreateForm;
   cs : TColorScheme;
   OldItem : integer;
   SettingsWnd : hwnd;


implementation

uses uSharpDeskMainForm,
     uSharpDeskSettingsForm,
     uSharpDeskObjectFile,
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

procedure TCreateForm.BuildObjectList;
var
   n,i,k : integer;
   ListItem : TListItem;
   Icon : TIcon;
   TempIcon : HIcon;
   Filter,s,filename : String;
begin
     if SharpDesk.ObjectFileList.Count = 0 then exit;
     Filter := Edit_Filter.Text;
     Objects.Clear;
     IconList.Clear;
     IconList.BkColor := Objects.Color;
     k := -1;
     for n:=0 to SharpDesk.ObjectFileList.Count - 1 do
     begin
          //if TObjectFile(SharpDesk.ObjectFileList.Items[n]).Loaded then
          begin
            filename := TObjectFile(SharpDesk.ObjectFileList.Items[n]).FileName;
            s:='';
            if (length(Filter)<=length(filename)) and (length(Filter)>0) then
               for i:=1 to length(Filter) do
                    s := s + filename[i];
            if UPPERCASE(s)=UPPERCASE(Filter) then
            begin
                 k := k + 1;
                 ListItem := Objects.Items.Add;
                 ListItem.StateIndex := k;
                 ListItem.ImageIndex := n;
                 setlength(filename,length(filename)-7);
                 ListItem.Caption := filename;
                 ListItem.SubItems.Add(GetFileInfo(TObjectFile(SharpDesk.ObjectFileList.Items[n]).Path, 'FileDescription'));
                 ListItem.SubItems.Add(GetFileInfo(TObjectFile(SharpDesk.ObjectFileList.Items[n]).Path, 'FileVersion'));
                 s := ExtractFilePath(Application.ExeName) + 'Images\'+filename+'.ico';
                 if not FileExists(s) then s:= ExtractFilePath(Application.ExeName) + '\Images\DefaultObject.ico';
                 if FileExists(s) then
                 begin
                   Icon := TIcon.Create;
                   TempIcon := loadimage(0,pchar(s),IMAGE_ICON,32,32,LR_DEFAULTSIZE or LR_LOADFROMFILE);
                   if TempIcon = 0 then Icon.LoadFromFile(s)
                      else Icon.Handle := TempIcon;
                      IconList.AddIcon(Icon);
                      if TempIcon<>0 then
                      begin
                        Icon.ReleaseHandle;
                        DestroyIcon(TempIcon);
                      end;
                   Icon.Free;
                 end else IconList.AddIcon(Application.Icon);
                 if Objects.Selected = nil then
                    ListItem.Selected := True;
            end;
          end;
     end;
end;


procedure TCreateForm.FormShow(Sender: TObject);
var
  n : integer;
begin
  cs:=LoadColorScheme;
  edit_filter.Text := '';
  BuildObjectList;
  n := GetCurrentMonitor;
  self.Left:=Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - self.Width div 2;
  self.top:=Screen.Monitors[n].Top + Screen.Monitors[n].Height div 2 - self.Height div 2;
  self.BringToFront;
end;

procedure TCreateForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Objects.Clear;
     IconList.Clear;
end;

procedure TCreateForm.edit_filterChange(Sender: TObject);
begin
     BuildObjectList;
end;

procedure TCreateForm.btn_cancelClick(Sender: TObject);
begin
     CreateForm.Close;
end;

procedure TCreateForm.btn_addClick(Sender: TObject);
var
   ID : integer;
begin
     if Objects.Selected = nil then exit;

     ID :=  SharpDesk.ObjectSetList.GenerateObjectID;

     SettingsForm.Load(TObjectFile(SharpDesk.ObjectFileList.Items[Objects.Selected.ImageIndex]),
                       ID,
                       LastX,
                       LastY,
                       True);
     CreateForm.Visible:=False;
     SettingsForm.ShowModal;

     CreateForm.Close;
end;

procedure TCreateForm.edit_filterKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then
     begin
          btn_add.Click;
          Key := #0;
     end;
end;

procedure TCreateForm.objectsDblClick(Sender: TObject);
begin
     btn_add.Click;
end;

procedure TCreateForm.objectsKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then btn_add.Click;
end;

end.
