{
Source Name: uSharpDeskTDragAndDrop.pas
Description: Drag and Drop manager class
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

unit uSharpDeskTDragAndDrop;

interface

uses ExtCtrls,
     Classes,
     Graphics,
     Windows,
     Contnrs,
     SysUtils,
     ShellApi,
     Forms,
     Dialogs,
     SharpApi,
     JvSimpleXML;

type
    TDragAndDropItem = class
                       private
                       public
                         FObjectFile : String;
                         FExtension  : String;
                         FXMLFile    : String;
                         FMaxLength  : integer;

                         property ObjectFile : String  read FObjectFile write FObjectFile;
                         property Extension  : String  read FExtension  write FExtension;
                         property XMLFile    : String  read FXMLFile    write FXMLFile;
                         property MaxLength  : Integer read FMaxLength  write FMaxLength;
                       end;

    TDragAndDropManager = class (TObjectList)
                           private
                             FOwner      : TObject;
                           public
                             constructor Create(pOwner : TObject; pDirectory : String);
                             destructor Destroy; override;
                             function IsExtRegistered(pExt : String) : boolean;
                             function GetIndexByExt(pExt : String) : integer;
                             procedure DoDragAndDrop(pFile : String; X,Y : integer);
                             procedure LoadDDInformations(pDirectory : String);
                             procedure RegisterDragAndDrop(handle : hwnd);
                             procedure UnRegisterDragAndDrop(handle : hwnd);
                             
                             property Owner      : TObject read FOwner;
                          end;

implementation

uses uSharpDeskManager,
     uSharpDeskObjectFile,
     uSharpDeskObjectSet,
     uSharpDeskObjectSetItem,
     SharpThemeApiEx;


// ######################################


constructor TDragAndDropManager.Create(pOwner : TObject; pDirectory : String);
begin
  inherited Create;
  FOwner := pOwner;
  LoadDDInformations(pDirectory);
end;


// ######################################


destructor TDragAndDropManager.Destroy;
begin
  Clear;
  Inherited Destroy;
end;


// ######################################


function TDragAndDropManager.GetIndexByExt(pExt : String) : integer;
var
   n : integer;
   pFile : String;
begin
  pFile := pExt;
  pExt := ExtractFileExt(LowerCase(pExt));

  if Count = 0 then
  begin
    GetIndexByExt:=-1;
    exit;
  end;

  for n:=0 to Count - 1 do
  if (TDragAndDropItem(Items[n]).Extension = pExt) or (TDragAndDropItem(Items[n]).Extension = '*.*') then
  begin
    if (TDragAndDropItem(Items[n]).MaxLength>=length(pFile)) or (TDragAndDropItem(Items[n]).MaxLength = 0) then
    begin
      GetIndexByExt := n;
      exit;
    end;
  end;
  GetIndexByExt:=-1;
end;


// ######################################


procedure TDragAndDropManager.DoDragAndDrop(pFile : String; X,Y : integer);
var
   tXML : TJvSimpleXML;
   oXML : TJvSimpleXML;
   n,i : integer;
   fn,s,ID : string;
   ObjectFile : TObjectFile;
   ObjectSet : TObjectSet;
   ObjectSetItem : TObjectSetItem;
   //SList : TStringList;
begin  
  n := GetIndexByExt(pFile);
  if n = -1 then exit;
  ObjectFile := TSharpDeskManager(FOwner).ObjectFileList.GetByObjectFile(TDragAndDropItem(Items[n]).ObjectFile);
  if ObjectFile = nil then exit;

  tXML := TJvSimpleXML.Create(nil);
  try
    tXML.LoadFromFile(TDragAndDropItem(Items[n]).XMLFile);
  except
    tXML.Free;
    SharpApi.SendDebugMessageEx('SharpDesk',PChar('Failed to load Drag & Drop config file :' + TDragAndDropItem(Items[n]).XMLFile),clred,DMT_ERROR);
    exit;
  end;

  oXML := TJvSimpleXML.Create(nil);
  s := ObjectFile.FileName;
  setlength(s,length(s)-length(TSharpDeskManager(FOwner).ObjectExt));
  oXML.Root.Name := s+'ObjectSettings';
  ID := inttostr(TSharpDeskManager(FOwner).GenerateObjectID);

{  SList := TStringList.Create;
  SList.Clear;
  for n := 0 to TSharpDeskManager(FOwner).ObjectSetList.Count - 1 do
    if TObjectSet(TSharpDeskManager(FOwner).ObjectSetList.Items[n]).ThemeList.IndexOf(SharpThemeApi.GetThemeName) >= 0 then
       SList.Add(inttostr(TObjectSet(TSharpDeskManager(FOwner).ObjectSetList.Items[n]).SetID));
  ObjectSet := TObjectset(TSharpDeskManager(FOwner).ObjectSetList.GetSetByID(strtoint(SList[0])));
  SList.Free;}
  ObjectSet := TObjectset(TSharpDeskManager(FOwner).ObjectSet);
  if ObjectSet = nil then exit;
  ObjectSetItem := ObjectSet.AddDesktopObject(strtoint(ID),ObjectFile.FileName,Point(X,Y),False,False);

  for i:=0 to tXML.Root.Items.ItemNamed['DefaultSettings'].Items.Count-1 do
  begin
    s:=tXML.Root.Items.ItemNamed['DefaultSettings'].Items.Item[i].Value;
    s:=StringReplace(s,'{FileName}',ExtractFileName(pFile),[rfReplaceAll,rfIgnoreCase]);
    s:=StringReplace(s,'{File}',pFile,[rfReplaceAll,rfIgnoreCase]);
    with oXML.Root.Items.Add(tXML.Root.Items.ItemNamed['DefaultSettings'].Items.Item[i].Name,s) do
         for n:=0 to tXML.Root.Items.ItemNamed['DefaultSettings'].Items.Item[i].Properties.Count -1 do
             Properties.Add(tXML.Root.Items.ItemNamed['DefaultSettings'].Items.Item[i].Properties.Item[n].Name,tXML.Root.Items.ItemNamed['DefaultSettings'].Items.Item[i].Properties.Item[n].Value);
  end;
  fn := ObjectFile.FileName;
  setlength(fn,length(fn)-length(TSharpDeskManager(FOwner).ObjectExt));
  ForceDirectories(SharpApi.GetSharpeUserSettingsPath +  'SharpDesk\Objects\'
                  + fn + '\');
  oXML.SaveToFile(SharpApi.GetSharpeUserSettingsPath +  'SharpDesk\Objects\'
                  + fn + '\' + ID + '.xml');

  TSharpDeskManager(FOwner).ObjectSet.Save;
  ObjectFile.AddDesktopObject(ObjectSetItem);
  tXML.Free;
  oXML.Free;
end;


// ######################################


function TDragAndDropManager.IsExtRegistered(pExt : String) : boolean;
var
   n : integer;
begin
  pExt := LowerCase(pExt);

  if Count = 0 then
  begin
    IsExtRegistered:=False;
    exit;
  end;

  for n:=0 to Count - 1 do
  if (TDragAndDropItem(Items[n]).Extension=pExt) or (TDragAndDropItem(Items[n]).Extension = '*.*') then
  begin
    IsExtRegistered := True;
    exit;
  end;
  IsExtRegistered := False;
end;


// ######################################


procedure TDragAndDropManager.RegisterDragAndDrop(handle : hwnd);
begin
     DragAcceptFiles(Handle, True);
end;


// ######################################


procedure TDragAndDropManager.UnRegisterDragAndDrop(handle : hwnd);
begin
     DragAcceptFiles(Handle, False);
end;


// ######################################


procedure TDragAndDropManager.LoadDDInformations(pDirectory : String);
var
   XML : TJvSimpleXML;
   SR : TSearchRec;
   DragAndDropItem : TDragAndDropItem;
begin
  {$WARNINGS OFF}
  Clear;
  if not DirectoryExists(pDirectory) then exit;
  if FindFirst(IncludeTrailingBackSlash(pDirectory)+'*.XML', faAnyFile , sr) = 0 then
  repeat
    XML := TJvSimpleXML.Create(nil);
    try
      
      XML.LoadFromFile(IncludeTrailingBackSlash(pDirectory)+SR.Name);
      if TSharpDeskManager(FOwner).ObjectFileList.GetByObjectFile(XML.Root.Items.ItemNamed['Settings'].Items.Value('Object','none')) <> nil then
      begin
        DragAndDropItem := TDragAndDropItem.Create;
        DragAndDropItem.ObjectFile := XML.Root.Items.ItemNamed['Settings'].Items.Value('Object','none');
        DragAndDropItem.XMLFile    := IncludeTrailingBackSlash(pDirectory)+SR.Name;
        DragAndDropItem.Extension  := LowerCase(XML.Root.Items.ItemNamed['Settings'].Items.Value('FileExt','.'));
        DragAndDropItem.MaxLength  := XML.Root.Items.ItemNamed['Settings'].Items.IntValue('MaxLength',0);
        Add(DragAndDropItem);
      end;
    finally
      XML.Free;
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
  {$WARNINGS ON}
end;


// ######################################


end.
