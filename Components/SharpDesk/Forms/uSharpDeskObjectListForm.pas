{
Source Name: uSharpDeskObjectListForm.pas
Description: Form for displaying informations about all installed desktop objects
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

unit uSharpDeskObjectListForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SharpApi, SharpFX, Grids, ComCtrls,
  GR32,
  uSharpDeskDesktopObject,
  uSharpDeskObjectSet,
  uSharpDeskObjectFile;

type
  TObjectListForm = class(TForm)
    tv_list: TTreeView;
    lv_info: TListView;
    procedure FormShow(Sender: TObject);
    procedure tv_listChange(Sender: TObject; Node: TTreeNode);
  private
  public
    procedure BuildList;
    procedure AddInfoItem(Name,Value : String); overload;
    procedure AddInfoItem(Name : String; Value : integer); overload;
    procedure AddInfoItem(Name : String; Value : boolean); overload;        
  end;

const
  VersionInfo: array [1..8] of string = (
    'CompanyName', 'FileDescription', 'FileVersion', 'InternalName',
    'LegalCopyRight', 'OriginalFileName', 'ProductName', 'ProductVersion');


var
  ObjectListForm: TObjectListForm;

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

procedure TObjectListForm.BuildList;
var
  n,i : integer;
  DesktopObject : TDesktopObject;
  Node : TTreeNode;
begin
  lv_info.Clear;
  tv_list.Items.Clear;
  with SharpDesk do
  begin
    for n := 0 to ObjectFileList.Count - 1 do
        with ObjectFileList.Items[n] as TObjectFile do
        begin
          Node := tv_list.Items.Add(nil,FileName);
          for i := 0 to Count -1 do
          begin
            DesktopObject := TDesktopObject(Items[i]);
            tv_list.Items.AddChild(Node,inttostr(DesktopObject.Settings.ObjectID));
          end;
        end;
  end;
end;

procedure TObjectListForm.FormShow(Sender: TObject);
var
  n : integer;
begin
  BuildList;

  n := GetCurrentMonitor;
  self.Left:=Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - self.Width div 2;
  self.top:=Screen.Monitors[n].Top + Screen.Monitors[n].Height div 2 - self.Height div 2;
end;

procedure TObjectListForm.AddInfoItem(Name : String; Value : integer);
begin
  AddInfoItem(Name,inttostr(Value));
end;

procedure TObjectListForm.AddInfoItem(Name : String; Value : boolean);
begin
  if Value then AddInfoItem(Name,'True')
     else AddInfoItem(Name,'False');
end;

procedure TObjectListForm.AddInfoItem(Name,Value : String);
var
  ListItem : TListItem;
begin
  ListItem := TListItem.Create(lv_info.Items);
  lv_info.Items.AddItem(ListItem);
  ListItem.Caption := Name;
  ListItem.SubItems.Add(Value);
end;

procedure TObjectListForm.tv_listChange(Sender: TObject; Node: TTreeNode);
var
  DesktopObject : TDesktopObject;
  ObjectFile    : TObjectFile;
  ObjectSet     : TObjectSet;
  L : TFloatRect;
begin
  if (Node = nil) then
  begin
    lv_info.Clear;
    exit;
  end;
  lv_info.Clear;
  if (Node.Level=0) then
  begin
    ObjectFile := SharpDesk.ObjectFileList.GetByObjectFile(Node.Text);
    if ObjectFile = nil then exit;
    AddInfoItem('Object file',ObjectFile.FileName);
    AddInfoItem('Object path',ObjectFile.Path);
    AddInfoItem('Object count',ObjectFile.Count);
    AddInfoItem('Loaded',ObjectFile.Loaded);
    AddInfoItem('Version',GetFileInfo(ObjectFile.Path,'FileVersion'));
    AddInfoItem('Original filename',GetFileInfo(ObjectFile.Path,'OriginalFileName'));
    AddInfoItem('Description',GetFileInfo(ObjectFile.Path,'FileDescription'));
    AddInfoItem('Author',GetFileInfo(ObjectFile.Path,'Author'));
    AddInfoItem('Copyright',GetFileInfo(ObjectFile.Path,'CompanyName'));
    if @ObjectFile.DllGetSettings = nil then AddInfoItem('Sharing settings',False)
       else AddInfoItem('Sharing settings',True);
    if @ObjectFile.DllRenderTooltip = nil then AddInfoItem('Tooltip support',False)
       else AddInfoItem('Tooltip support',True);
    exit;
  end;

  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(strtoint(Node.Text)));
  if DesktopObject = nil then exit;

  AddInfoItem('Object ID',DesktopObject.Settings.ObjectID);
  AddInfoItem('Object file',DesktopObject.Settings.ObjectFile);
  AddInfoItem('Class name',DesktopObject.Layer.ClassName);
  ObjectSet := TObjectSet(DesktopObject.Settings.Owner);
  AddInfoItem('Object set',Objectset.Name);
  AddInfoItem('Locked',DesktopObject.Settings.Locked);
  AddInfoItem('Pos X',DesktopObject.Settings.Pos.X);
  AddInfoItem('Pos Y',DesktopObject.Settings.Pos.Y);
  if DesktopObject.Layer <> nil then
  begin
    AddInfoItem('Layer exists','True');
    L := DesktopObject.Layer.Location;
    AddInfoItem('Layer.left',round(L.Left));
    AddInfoItem('Layer.top',round(L.Top));
    AddInfoItem('Layer.width',round(L.Right-L.Left));
    AddInfoItem('Layer.height',round(L.Bottom-L.Top));
    AddInfoItem('Layer master alpha',DesktopObject.Layer.Bitmap.MasterAlpha);
  end else AddInfoItem('Layer exists','False');
end;

end.
