{
Source Name: uSharpEMenuActions.pas
Description: SharpE Menu Actions Handler class
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

unit uSharpEMenuActions;

interface

uses Windows,
     Messages,
     Classes,
     Contnrs,
     ShellApi,
     DateUtils,
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
    procedure OnDesktopObjectClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure OnLinkClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure OnFolderclick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure UpdateDynamicDirectory(var pDynList : TObjectList; pDir,
                                     pFilter : String; pSort,pMaxItems : integer);
    procedure UpdateDynamicDriveList(var pDynList : TObjectList; pDriveNames : boolean);
    procedure UpdateControlPanelList(var pDynList : TObjectList);
    procedure UpdateObjectList(var DynList : TObjectList);
  end;

implementation

uses uSharpEMenu,
     GR32,
     SharpIconUtils,
     uPropertyList,
     uControlPanelItems,
     JclFileUtils,
     JclSysUtils,
     JclShell,
     JclStrings;

constructor TSharpEMenuActions.Create(pOwner : TObject);
begin
  inherited Create;
  
  FOwner := pOwner;
end;

procedure TSharpEMenuActions.OnDesktopObjectClick(pItem: TSharpEMenuItem; var CanClose: boolean);
var
  wnd : hwnd;
  msg: TSharpE_DataStruct;
  cds: TCopyDataStruct;
begin
  wnd := FindWindow('TSharpDeskMainForm',nil);
  if wnd <> 0 then
  begin
    msg.Parameter := ExtractFileName(pItem.PropList.GetString('ObjectFile'));
    msg.Command := 'AddObject';

    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TSharpE_DataStruct);
      lpData := @msg;
    end;

    sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
  end;
  CanClose := True;
end;

procedure TSharpEMenuActions.OnFolderclick(pItem : TSharpEMenuItem; var CanClose : boolean);
begin
  SharpApi.SharpExecute(pItem.PropList.GetString('Target'));
  CanClose := True;
end;

procedure TSharpEMenuActions.OnLinkClick(pItem : TSharpEMenuItem; var CanClose : boolean);
begin
  SharpApi.SharpExecute(pItem.PropList.GetString('Action'));
  CanClose := True;
end;

procedure TSharpEMenuActions.UpdateControlPanelList(var pDynList : TObjectList);
var
  CPLList : TCPLItems;
  n,i,k : integer;
  item : TSharpEMenuItem;
  pMenu : TSharpEMenu;
  target : String;
  found : boolean;
  bmp : TBitmap32;
  IconFile,IconID : String;
  bighandle,iconhandle : hicon;
begin
  CPLList := GetCPLItems;
  pMenu := TSharpEMenu(FOwner);

  for n := 0 to High(CPLList) do
      with CPLList[n] do
      begin
        // Check if the item already exists
        found := False;
        for i := 0 to pDynList.Count - 1 do
        begin
          item := TSharpEMenuItem(pDynList.Items[i]);
          if (item.ItemType = mtLink) and (item.Caption = Name) and
             (CompareText(item.PropList.GetString('Action'),FileName) = 0) then
          begin
            pDynList.delete(i);
            found := True;
            break;
          end;
        end;

        if Found then continue;

        if length(trim(Name)) > 0 then
        begin
          Target := FileName;
          Target := StringReplace(Target,'%ProgramFiles%',JclSysInfo.GetProgramFilesFolder,[rfReplaceAll,rfIgnoreCase]);
          Target := StringReplace(Target,'%SystemRoot%',JclSysInfo.GetWindowsFolder,[rfReplaceAll,rfIgnoreCase]);
          Target := Trim(Target);

          if (not GUIDItem) and (not FileExists(Target)) then
             Target := 'control.exe /name ' + Target;

          Icon := StringReplace(Icon,'%ProgramFiles%',JclSysInfo.GetProgramFilesFolder,[rfReplaceAll,rfIgnoreCase]);
          Icon := StringReplace(Icon,'%SystemRoot%',JclSysInfo.GetWindowsFolder,[rfReplaceAll,rfIgnoreCase]);
          Icon := Trim(Icon);
          if not FileExists(Icon) then
          begin
            // Check if it's a ressource icon
            k := StrILastPos(',',Icon);
            if k > 0 then
            begin
              IconFile := JclStrings.StrLeft(Icon,k-1);
              IconID := JclStrings.StrRight(Icon,length(Icon)-k);

              bighandle := 0;
              if CompareText(IconID,'-1') = 0 then
                 ExtractIconEx(PChar(IconFile), 0, bighandle, iconhandle,1)
                 else iconhandle := ExtractIcon(hInstance,PChar(IconFile),StrToInt(IconID));
              if iconhandle <> 0 then
              begin
                bmp := TBitmap32.Create;
                SharpIconUtils.IconToImage(bmp,iconhandle);
                DestroyIcon(iconhandle);
                if bighandle <> 0 then
                   DestroyIcon(bighandle);
                pMenu.AddLinkItem(Name,Target,Icon,bmp,True);
                bmp.Free;
              end else pMenu.AddLinkItem(Name,Target,'shell:icon',True);
            end else pMenu.AddLinkItem(Name,Target,'shell:icon',True);
          end else
          begin
            bmp := TBitmap32.Create;
            SharpIconUtils.extrShellIcon(Bmp,Icon);
            if (not FileExists(Target)) then
                Target := 'control.exe /name ' + Target;
            pMenu.AddLinkItem(Name,Target,Icon,bmp,True);
            bmp.Free;
 //           pMenu.AddLinkItem(Icon,Target,'shell:icon',True);
          end;
        end;
      end;
end;

procedure TSharpEMenuActions.UpdateDynamicDirectory(var pDynList : TObjectList; pDir,
          pFilter : String; pSort,pMaxItems : integer);

  procedure InvertList(var SList : TStringList);
  var
    temp : TStringList;
    n : integer;
  begin
    temp := TStringList.Create;
    temp.Clear;
    temp.Assign(SList);

    SList.Clear;
    for n := temp.Count - 1 downto 0 do
        SList.Add(temp[n]);
    temp.Free;
  end;

var
  pMenu : TSharpEMenu;
  submenu : TSharpEMenu;
  n,i,k,h : integer;
  item,subitem : TSharpEMenuItem;
  sr : TSearchRec;
  found,subfound : boolean;
  s : String;
  Dir : String;
  SList : TStringList;
  svalue : String;
  sname : String;
  dt : TDateTime;
begin
  pMenu := TSharpEMenu(FOwner);
  {$WARNINGS OFF}
  Dir := IncludeTrailingBackSlash(pDir);
  {$WARNINGS ON}

  if length(trim(pFilter)) = 0 then
     pFilter := '*';

  item := nil;

  SList := TStringList.Create;
  SList.Clear;

  if FindFirst(pDir + pFilter,faAnyFile,sr) = 0 then
  repeat
    if (CompareText(sr.Name,'.') <> 0) and (CompareText(sr.Name,'..') <> 0) then
    begin
      if (sr.Attr and faDirectory) > 0 then svalue := '0'
         else
         begin
           case pSort of
             1: svalue := '1';
             2: begin
                  GetFileLastWrite(Dir + sr.Name,dt);
                  svalue := '1' + IntToStr(DateTimeToUnix(dt));
                 end;
             else svalue := '1';
           end;
           {$WARNINGS OFF}
           if (sr.Attr and faHidden) > 0 then
              svalue[1] := '2';
           {$WARNINGS ON}
         end;

      // do not add Directories if sorting is enabled
      if not((pSort > 1) and ((sr.Attr and faDirectory) > 0)) then
          SList.Add(svalue + '=' + sr.Name);
    end;
  until (FindNext(sr) <> 0);
  FindClose(sr);
  SList.Sort;
  if pSort > 0 then InvertList(SList);


  pMaxItems := pMaxItems - 1;
  if (pMaxItems <= 0) or (pMaxItems > SList.Count - 1) then
     pMaxItems := SList.Count - 1;


  for h := 0 to pMaxItems do
  begin
    svalue := SList.ValueFromIndex[h];
    sname := SList.Names[h];

    found := False;

    // search for sub menu item with caption = svalue
    for n := pDynList.Count - 1 downto 0  do
    begin
      item := TSharpEMenuItem(pDynList.Items[n]);

      // Is it a Directory then compare the Caption to DirectoryName
      if sname[1] = '0' then
      begin
        if item.Caption = svalue then
        begin
          found := true;
          pDynList.Delete(n);
          break;
        end;
      end
      else
        // No Directory, there could be multiple files from different directories
        // in the same menu, so compare the filetarget and not the caption
        if item.PropList.GetString('Action') = Dir + svalue then
        begin
          pDynList.Delete(n);
          found := true;
          break;
        end;
    end;

    if (found) then
    begin
      item.PropList.Add('SortData',sname+svalue);
      item.PropList.Add('Sort',pSort);
    end;

    // item not found, add it
    if (not found) then
    begin
      // Is it a Directory?
      if sname[1] = '0' then
      begin
        found := False;
        for i := 0 to pMenu.Items.Count - 1 do
        begin
          item := TSharpEMenuItem(pMenu.Items.Items[i]);
          if (item.isDynamic) and (item.ItemType = mtSubMenu) then
          begin
            if (item.Caption = svalue) then
            begin
              submenu := TSharpEMenu(item.SubMenu);
              if submenu <> nil then
              begin
                subfound := False;
                for k := 0 to submenu.Items.count - 1 do
                begin
                  subitem := TSharpEMenuItem(submenu.Items.Items[k]);
                  if (subitem.ItemType = mtDynamicDir) and (subitem.PropList.GetString('Action') = Dir + svalue + '\') then
                  begin
                    subfound := True;
                    break;
                  end;
                end;
                if not subfound then
                begin
                  submenu.AddDynamicDirectoryItem(Dir + svalue + '\',
                                                  item.PropList.GetInt('MaxItems'),
                                                  item.PropList.GetInt('Sort'),
                                                  item.PropList.GetString('Filter'),
                                                  False);
                end;
              end;
              found := True;
              break;
            end;
          end;
        end;
        if (not found) then
        begin
          item := TSharpEMenuItem(pMenu.AddSubMenuItem(svalue,'shell:icon',Dir + svalue + '\',true));
          item.SubMenu := TSharpEMenu.Create(pMenu.SkinManager,pmenu.Settings);
          item.PropList.Add('Sort',pSort);
          TSharpEMenu(item.SubMenu).AddDynamicDirectoryItem(Dir + svalue + '\',
                                                            item.PropList.GetInt('MaxItems'),
                                                            item.PropList.GetInt('Sort'),
                                                            item.PropList.GetString('Filter'),
                                                            False);
        end;
      end else
      begin
        // It's a File, but do not add hidden files! (desktop.ini ...)
        if not(sname[1] = '2') then
        begin
          s := svalue;
          setlength(s,length(s) - length(ExtractFileExt(svalue)));
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
               with TSharpEMenuItem(pMenu.AddLinkItem(s,Dir + svalue,'shell:icon',true)) do
               begin
                 PropList.Add('SortData',sname+svalue);
                 PropList.Add('Sort',pSort);
               end;
          end;
        end;
      end;
    end;
end;

procedure TSharpEMenuActions.UpdateDynamicDriveList(var pDynList : TObjectList; pDriveNames : boolean);

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
      Result := 'Unknown Type';
    end;
  end;

var
  i,n : integer;
  item : TSharpEMenuItem;
  pMenu : TSharpEMenu;
  found : boolean;
  s,sn : String;
  Tmp: array [0..104] of Char;
  Info: TSHFileInfo;
  P: PChar;
  SC : String;
begin
  pMenu := TSharpEMenu(FOwner);

  try
    FillChar(Tmp[0], SizeOf(Tmp), #0);
    GetLogicalDriveStrings(SizeOf(Tmp), Tmp);
    P := Tmp;
    while P^ <> #0 do
    begin
      SC := P;
      Inc(P, 4);
      SHGetFileInfo(PChar(SC), 0, Info, SizeOf(TSHFileInfo), SHGFI_DISPLAYNAME or SHGFI_TYPENAME);
      found := false;
      for n := pDynList.Count - 1 downto 0  do
      begin
        sn := '';
        if pDriveNames then sn := Trim(Info.szDisplayName)
           else sn := Trim(Info.szTypeName);
        s := '['+ SC[1] + ':] - ' + sn;
        item := TSharpEMenuItem(pDynList.Items[n]);
        if (item.ItemType = mtLink) and (item.Caption = s)
           and (item.PropList.GetString('Action') = SC[1] + ':\') then
        begin
          pDynList.Delete(n);
          found := true;
          break;
        end;
      end;
      if (not found) then
      begin
          sn := '';
          if pDriveNames then sn := Info.szDisplayName
             else sn := Info.szTypeName;
          s := '['+ SC[1] + ':] - ' + sn;
          pMenu.AddLinkItem(s,
                            SC[1] + ':\',
                            'shell:icon',
                            true);
        end;

    end;
  except
  end;
  exit;

  for i := 0 to 25 do
      if DriveExists(i) then
      begin
      end;
end;

procedure TSharpEMenuActions.UpdateObjectList(var DynList: TObjectList);
var
  sr : TSearchRec;
  Dir : String;
  n : integer;
  item : TSharpEMenuItem;
  found : boolean;
  pMenu : TSharpEMenu;
begin
  pMenu := TSharpEMenu(FOwner);

  Dir := SharpApi.GetSharpeDirectory + '\Objects\';
  if FindFirst(Dir + '*.object',faAnyFile,sr) = 0 then
  repeat
    if (CompareText(sr.Name,'.') <> 0) and (CompareText(sr.Name,'..') <> 0) then
    begin
      found := false;
      for n := DynList.Count - 1 downto 0 do
      begin
        item := TSharpEMenuItem(DynList.Items[n]);
        if item.ItemType = mtDesktopObject then
          if CompareText(sr.Name,item.PropList.GetString('ObjectFile')) = 0 then
          begin
            DynList.Delete(n);
            found := True;
            break;
          end;
      end;

      if not found then
      begin
        pMenu.AddObjectItem(sr.Name,True);
      end;
    end;
  until (FindNext(sr) <> 0);
  FindClose(sr);
end;

end.
