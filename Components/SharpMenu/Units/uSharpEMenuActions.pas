{
Source Name: uSharpEMenuActions.pas
Description: SharpE Menu Actions Handler class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.sharpe-shell.net

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

unit uSharpEMenuActions;

interface

uses Windows,
     Contnrs,
     SysUtils,
     SharpApi,
     JclSysInfo,
     uSharpEMenuItem;

type
  TSharpEMenuActions = class
  private
    FOwner : TObject;
  public
    constructor Create(pOwner : TObject); reintroduce;
    procedure OnLinkClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure UpdateDynamicDirectory(var pDynList : TObjectList; pDir : String);
    procedure UpdateDynamicDriveList(var pDynList : TObjectList);
  end;

implementation

uses uSharpEMenu;

constructor TSharpEMenuActions.Create(pOwner : TObject);
begin
  inherited Create;
  
  FOwner := pOwner;
end;

procedure TSharpEMenuActions.OnLinkClick(pItem : TSharpEMenuItem; var CanClose : boolean);
begin
  SharpApi.SharpExecute(pItem.Action);
  CanClose := True;
end;

procedure TSharpEMenuActions.UpdateDynamicDirectory(var pDynList : TObjectList; pDir : String);
var
  pMenu : TSharpEMenu;
  submenu : TSharpEMenu;
  n,i,k : integer;
  item,subitem : TSharpEMenuItem;
  sr : TSearchRec;
  found,subfound : boolean;
  s : String;
  Dir : String;
begin
  pMenu := TSharpEMenu(FOwner);
  Dir := IncludeTrailingBackSlash(pDir);

  if FindFirst(pDir + '*',faAnyFile,sr) = 0 then
  repeat
    if (CompareText(sr.Name,'.') <> 0) and (CompareText(sr.Name,'..') <> 0) then
    begin
      found := False;
      // search for sub menu item with caption = sr.Name
      for n := pDynList.Count - 1 downto 0  do
      begin
        item := TSharpEMenuItem(pDynList.Items[n]);
        if (sr.Attr and faDirectory) > 0 then
        begin
           if item.Caption = sr.Name then
           begin
             found := true;
             pDynList.Delete(n);
             break;
           end;
        end
        else
        begin
          s := sr.Name;
          setlength(s,length(s) - length(ExtractFileExt(sr.Name)));
          if item.Action = Dir + sr.Name then
          begin
            pDynList.Delete(n);
            found := true;
            break;
          end;
        end;
      end;
      if (not found) then
      begin
        // item not found, add it
        if (sr.Attr and faDirectory) > 0 then
        begin
          found := False;
          for i := 0 to pMenu.Items.Count - 1 do
          begin
            item := TSharpEMenuItem(pMenu.Items.Items[i]);
            if (item.isDynamic) and (item.ItemType = mtSubMenu) then
            begin
              if (item.Caption = sr.Name) then
              begin
                submenu := TSharpEMenu(item.SubMenu);
                if submenu <> nil then
                begin
                  subfound := False;
                  for k := 0 to submenu.Items.count - 1 do
                  begin
                    subitem := TSharpEMenuItem(submenu.Items.Items[k]);
                    if (subitem.ItemType = mtDynamicDir) and (subitem.Action = Dir + sr.Name + '\') then
                    begin
                      subfound := True;
                      break;
                    end;
                  end;
                  if not subfound then
                  begin
                    submenu.AddDynamicDirectoryItem(Dir + sr.Name + '\',False);
                  end;
                end;
                found := True;
                break;
              end;
            end;
          end;
          if (not found) then
          begin
            item := TSharpEMenuItem(pMenu.AddSubMenuItem(sr.name,'shellicon',Dir + sr.Name + '\',true));
            item.SubMenu := TSharpEMenu.Create(pMenu.SkinManager);
            TSharpEMenu(item.SubMenu).AddDynamicDirectoryItem(Dir + sr.Name + '\',False);
          end;
        end else
        begin
          // do not add hidden files! (desktop.ini ...)
          if not((sr.Attr and faHidden) > 0) then
          begin
            s := sr.Name;
            setlength(s,length(s) - length(ExtractFileExt(sr.Name)));
            found := false;
            for n := 0 to pMenu.Items.Count - 1 do
            begin
              item := TSharpEMenuItem(pMenu.Items.Items[n]);
              if (item.ItemType = mtLink) and (item.isDynamic) then
                 if (item.Caption = s) then
                 begin
                   found := true;
                   break;
                 end;
            end;
            if (not found) then
               pMenu.AddLinkItem(s,Dir + sr.Name,'shellicon',true);
          end;
        end;
      end;
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
end;

procedure TSharpEMenuActions.UpdateDynamicDriveList(var pDynList : TObjectList);

  function DriveExists(DriveByte: Byte): Boolean;
  begin
    Result := GetLogicalDrives and (1 shl DriveByte) <> 0;
  end;

  function DriveType(DriveByte: Byte): String;
  begin
    case GetDriveType(PChar(Chr(DriveByte + Ord('A')) + ':\')) of
      DRIVE_UNKNOWN: Result := 'Unknown';
      DRIVE_NO_ROOT_DIR: Result := 'NO ROOT DIR';
      DRIVE_REMOVABLE: Result := 'Removeable Drive';
      DRIVE_FIXED: Result := 'Hard Drive';
      DRIVE_REMOTE: Result := 'Network Drive';
      DRIVE_CDROM: Result := 'CD-ROM/DVD';
      DRIVE_RAMDISK: Result := 'RAM Disk';
    else
      Result := 'anderer Laufwerkstyp';
    end;
  end;

var
  i,n : integer;
  item : TSharpEMenuItem;
  pMenu : TSharpEMenu;
  found : boolean;
  s,sn : String;
begin
  pMenu := TSharpEMenu(FOwner);
  
  for i := 0 to 25 do
      if DriveExists(i) then
      begin
        found := false;
        for n := pDynList.Count - 1 downto 0  do
        begin
          sn := JclSysInfo.GetVolumeName(Chr(i + Ord('A')));
          if length(sn) <= 0 then
             sn := DriveType(i);
          s := '['+Chr(i + Ord('A')) + ':] - ' + sn;
          item := TSharpEMenuItem(pDynList.Items[n]);
          if (item.ItemType = mtLink) and (item.Caption = s)
             and (item.Action = Chr(i + Ord('A')) + ':\') then
          begin
            pDynList.Delete(n);
            found := true;
            break;
          end;
        end;
        if (not found) then
        begin
          sn := JclSysInfo.GetVolumeName(Chr(i + Ord('A')));
          if length(sn) <= 0 then
             sn := DriveType(i);
          pMenu.AddLinkItem('['+Chr(i + Ord('A')) + ':] - ' + sn,
                            Chr(i + Ord('A')) + ':\',
                            'shellicon',
                            true);
        end;
      end;
end;

end.
