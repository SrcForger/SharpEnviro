{
Source Name: SharpDialogs.dpr
Description: dll exporting commonly used menus and dialogs
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

library SharpDialogs;


uses
  Windows,
  Messages,
  Graphics,
  Dialogs,
  SysUtils,
  Classes,
  Forms,
  Types,
  Menus,
  PngImageList,
  PngImage,
  ActiveX,
  ShellApi,
  ShlObj,
  SharpApi,
  ExPopupList in 'ExPopupList.pas';

type
  TTargetDialogSelectItem = (stiFile,stiRecentFiles,stiMostUsedFiles,stiDrive,
                             stiDirectory,stiShellFolders,stiScript,stiAction);
  TTargetDialogSelectItems = Set of TTargetDialogSelectItem;
  TTargetDialogClickHandler = class
                                procedure OnFileOpenClick(Sender : TObject);
                                procedure OnMRClick(Sender : TObject);
                                procedure OnDriveClick(Sender : TObject);
                                procedure OnShellFolderClick(Sender : TObject);
                                procedure OnDirOpenClick(Sender : TObject);
                                procedure OnScriptClick(Sender : TObject);
                                procedure OnActionClick(Sender : TObject);
                              end;


const
  STI_ALL_TARGETS = [stiFile,stiRecentFiles,stiMostUsedFiles,stiDrive,
                     stiDirectory,stiShellFolders,stiScript,stiAction];

var
  targetmenuresult : String;
  targetmenu  : TPopupMenu;

{$R Glyphs.res}
{$R *.res}

procedure BuildShellFolderList(Slist : TStringList);
begin
 SList.Clear;

 SList.Add('shell:Administrative Tools=Administrative Tools');
 SList.Add('shell:AppData=Application Data');
 SList.Add('shell:Common Administrative Tools=All Users Administrative Tools');
 SList.Add('shell:Common AppData=All Users Application Data');
 SList.Add('shell:Common Desktop=All Users Desktop');
 SList.Add('shell:Common Documents=All Users Documents');
 SList.Add('shell:Common Favorites=All Users Favorites');
 SList.Add('shell:Common Menu=All Users Start Menu');
 SList.Add('shell:Common Startup=All Users Startup');
 SList.Add('shell:Common Templates=All Users Templates');
 SList.Add('shell:Common Programs=Common Programs');
 SList.Add('shell:CommonProgramFiles=Common Program Files');
 SList.Add('shell:ControlPanelFolder=Control Panel');
 SList.Add('shell:Cookies=Cookies');
 SList.Add('shell:Desktop=Desktop');
 SList.Add('shell:Favorites=Favorites');
 SList.Add('shell:Fonts=Fonts');
 SList.Add('shell:History=History');
 SList.Add('shell:InternetFolder=Internet Folder');
 SList.Add('shell:Local AppData=Local Application Data');
 SList.Add('shell:Menu=Menu');
 SList.Add('shell:DriveFolder=My Computer');
 SList.Add('shell:Personal=My Documents');
 SList.Add('shell:My Music=My Music');
 SList.Add('shell:My Pictures=My Pictures');
 SList.Add('shell:NetHood=NetHood');
 SList.Add('shell:ConnectionsFolder=Network Connections');
 SList.Add('shell:NetworkFolder=Network Folder');
 SList.Add('shell:PrintHood=PrintHood');
 SList.Add('shell:Profile=User Profile');
 SList.Add('shell:ProgramFiles=Program Files');
 SList.Add('shell:Programs=Programs');
 SList.Add('shell:PrintersFolder=Printers Folder');
 SList.Add('shell:Recent=Recent Documents');
 SList.Add('shell:RecycleBinFolder=Recycle Bin');
 SList.Add('shell:SendTo=Send To');
 SList.Add('shell:SystemX86=System32');
 SList.Add('shell:System=System32');
 SList.Add('shell:Templates=Templates');
 SList.Add('shell:Windows=Windows Directory');
end;

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
    Result := 'other drive type';
  end; 
end;

function GetDriveName(DriveByte : Byte) : string;
var
  NotUsed, VolFlags: DWORD;
  Buf: array[0..MAX_PATH] of Char;
begin
  try
    GetVolumeInformation(PChar(Chr(DriveByte + Ord('A')) + ':\'), Buf, SizeOf(Buf), nil, NotUsed, VolFlags, nil, 0);
    Result := Buf;
  except
  end;
end;

procedure TTargetDialogClickHandler.OnActionClick(Sender : TObject);
begin
  try
    targetmenuresult := TMenuItem(Sender).Hint;
  finally
    nrevent := False;
  end;
end;

procedure TTargetDialogClickHandler.OnScriptClick(Sender : TObject);
begin
  try
    targetmenuresult := TMenuItem(Sender).Hint;
  finally
    nrevent := False;
  end;
end;

procedure TTargetDialogClickHandler.OnDirOpenClick(Sender : TObject);
var
  pidl, pidlSelected: PItemIDList;
  bi: TBrowseInfo;
  szDirName: array [0..260] of AnsiChar;
begin
  {Get the root PIDL of the network neighborhood tree}
  if SHGetSpecialFolderLocation(Application.Handle, CSIDL_DESKTOP, pidl) = NOERROR then
  begin
    {Populate a BROWSEINFO structure}
    bi.hwndOwner := Application.Handle;
    bi.pidlRoot := pidl;
    bi.pszDisplayName := szDirName;
    bi.lpszTitle := 'Select Directory';
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
      targetmenuresult := szDirName;
      {Release the PIDL of the computer name}
      CoTaskMemFree(pidlSelected);
    end;
    {Release the PIDL of the network neighborhood tree}
    CoTaskMemFree(pidl);
  end;
  nrevent := False;
end;

procedure TTargetDialogClickHandler.OnShellFolderClick(Sender : TObject);
begin
  try
    targetmenuresult := TMenuItem(Sender).Hint;
  finally
    nrevent := False;
  end;
end;

procedure TTargetDialogClickHandler.OnDriveClick(Sender : TObject);
begin
  try
    targetmenuresult := TMenuItem(Sender).Hint;
  finally
    nrevent := False;
  end;
end;

procedure TTargetDialogClickHandler.OnMRClick(Sender : TObject);
begin
  try
    targetmenuresult := TMenuItem(Sender).Hint;
  finally
    nrevent := False;
  end;
end;

procedure TTargetDialogClickHandler.OnFileOpenClick(Sender : TObject);
var
  ofdialog : TOpenDialog;
begin
  try
    ofdialog := TOpenDialog.Create(nil);
    ofdialog.Filter := 'All Files (*.*)|*.*';
    if ofdialog.Execute then targetmenuresult := ofdialog.FileName;
  finally
    nrevent := False;
  end;
end;


function TargetDialog(TargetItems : TTargetDialogSelectItems; PopupPoint : TPoint) : PChar;
var
  menuItem : TMenuItem;
  SList : TStringList;
  n : integer;
  i : integer;
  mindex : integer;
  sr : TSearchRec;
  s,dir : String;
  targetmenuclick : TTargetDialogClickHandler;
  iml : TPngImageList;
  bmp : TBitmap;
begin
  targetmenuresult := '';
  targetmenu := TPopupMenu.Create(nil);
  targetmenuclick := TTargetDialogClickHandler.Create;
  iml := TPngImageList.Create(nil);
  iml.Width := 16;
  iml.Height := 16;
  targetmenu.Images := iml;

  SList := TStringList.Create;
  try
    // Build Image List
    Bmp := TBitmap.Create;
    Bmp.Width := 16;
    Bmp.Height := 16;
    Bmp.Canvas.Brush.Color := clRed;
    Bmp.canvas.FillRect(bmp.canvas.ClipRect);
    
    iml.Add(bmp,bmp);

    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'recentfile');
    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'open');
    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'drivecdrom');
    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'driveharddisk');
    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'driveremovable');
    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'folder');
    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'specialfolder');
    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'file');
    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'specialfile');
    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'scriptfile');
    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'actions');
    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'actionscategory');
    iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'action');

    iml.Add(bmp,bmp);

    Bmp.Free;

    targetmenu.Items.Clear;
    mindex := -1;

    // two Dummy items! do not remove!
    menuItem := TMenuItem.Create(targetmenu);
    targetmenu.Items.Add(menuItem);
    menuItem.Visible := False;
    mindex := mindex + 1;

    menuItem := TMenuItem.Create(targetmenu);
    menuItem.Visible := False;
    targetmenu.Items.Add(menuItem);
    mindex := mindex + 1;

    if stiFile in TargetItems then
    begin
      // Files Menu
      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'File';
      menuItem.ImageIndex := 8;
      targetmenu.Items.Add(menuItem);
      mindex := mindex + 1;

      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Open...';
      menuItem.OnClick := targetmenuclick.OnFileOpenClick;
      menuItem.ImageIndex := 2;
      targetmenu.Items.Items[mindex].Add(menuItem);

      if (stiRecentFiles in TargetItems) or (stiMostUsedFiles in TargetItems) then
      begin
        menuItem := TMenuItem.Create(targetmenu);
        menuItem.Caption := '-';
        targetmenu.Items.Items[mindex].Add(menuItem);
      end;

      if stiRecentFiles in TargetItems then
      begin
        menuItem := TMenuItem.Create(targetmenu);
        menuItem.Caption := 'Recent';
        menuItem.ImageIndex := 1;
        targetmenu.Items.Items[mindex].Add(menuItem);

        SList.CommaText := SharpApi.GetRecentItems(10);
        for n := 0 to SList.Count -1 do
        begin
          menuItem := TMenuItem.Create(targetmenu);
          menuItem.Caption := ExtractFileName(SList[n]);
          if length(trim(menuItem.Caption)) = 0 then menuItem.Caption := SList[n];
          menuItem.Hint := SList[n];
          menuItem.OnClick := targetmenuclick.OnMRClick;
          menuItem.ImageIndex := 9;
          targetmenu.Items.Items[mindex].Items[targetmenu.Items.Items[mindex].Count-1].Add(menuItem);
        end;
      end;

      if stiMostUsedFiles in TargetItems then
      begin
        menuItem := TMenuItem.Create(targetmenu);
        menuItem.Caption := 'Most Used';
        menuItem.ImageIndex := 1;
        targetmenu.Items.Items[mindex].Add(menuItem);
        //mindex := mindex + 1;

        SList.CommaText := SharpApi.GetMostUsedItems(10);
        for n := 0 to SList.Count -1 do
        begin
          menuItem := TMenuItem.Create(targetmenu);
          menuItem.Caption := ExtractFileName(SList[n]);
          if length(trim(menuItem.Caption)) = 0 then menuItem.Caption := SList[n];
          menuItem.Hint := SList[n];
          menuItem.OnClick := targetmenuclick.OnMRClick;
          menuItem.ImageIndex := 9;
          targetmenu.Items.Items[mindex].Items[targetmenu.Items.Items[mindex].Count-1].Add(menuItem);
        end;
      end;
    end;


    if stiDrive in TargetItems then
    begin
      // Drive Menu
      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Drive';
      menuItem.ImageIndex := 4;
      targetmenu.Items.Add(menuItem);
      mindex := mindex + 1;

      for i := 0 to 25 do
          if DriveExists(i) then
          begin
            menuItem := TMenuItem.Create(targetmenu);
            // menuItem.Caption := '[' + inttostr(i) + ':\] ' + GetDriveName(i) +' (' + DriveType(i) +')';
            case GetDriveType(PChar(Chr(i + Ord('A')) + ':\')) of
              DRIVE_UNKNOWN: menuItem.ImageIndex := 5;
              DRIVE_NO_ROOT_DIR: menuItem.ImageIndex := 5;
              DRIVE_REMOVABLE: menuItem.ImageIndex := 5;
              DRIVE_FIXED: menuItem.ImageIndex := 4;
              DRIVE_REMOTE: menuItem.ImageIndex := 5;
              DRIVE_CDROM: menuItem.ImageIndex := 3;
              DRIVE_RAMDISK: menuItem.ImageIndex := 4;
              else menuItem.ImageIndex := 5;
            end;
            menuItem.Caption := '[' + Chr(i + Ord('A')) + ':\] ' + DriveType(i);
            menuItem.Hint := Chr(i + Ord('A')) + ':\';
            menuItem.OnClick := targetmenuclick.OnDriveClick;

            targetmenu.Items.Items[mindex].Add(menuItem);
          end;
    end;

    if stiDirectory in TargetItems then
    begin
      // Directory  Menu
      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Directory';
      targetmenu.Items.Add(menuItem);
      menuItem.ImageIndex := 6;
      mindex := mindex + 1;

      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Open...';
      menuItem.ImageIndex := 2;
      menuItem.OnClick := targetmenuclick.OnFileOpenClick;//.OnDirOpenClick;
      targetmenu.Items.Items[mindex].Add(menuItem);

      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := '-';
      targetmenu.Items.Items[mindex].Add(menuItem);

      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Shell Folder';
      menuItem.ImageIndex := 7;
      targetmenu.Items.Items[mindex].Add(menuItem);

      BuildShellFolderList(Slist);
      if stiShellFolders in TargetItems then
      begin
        for n := 0 to SList.Count -1 do
        begin
          menuItem := TMenuItem.Create(targetmenu);
          menuItem.Caption := SList.ValueFromIndex[n];
          menuItem.Hint := SList.Names[n];
          menuItem.ImageIndex := 6;
          menuItem.OnClick := targetmenuclick.OnShellFolderClick;
          targetmenu.Items.Items[mindex].Items[targetmenu.Items.Items[mindex].Count-1].Add(menuItem);
        end;
      end;
    end;

    if stiScript in TargetItems then
    begin
      // Scripts Menu
      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Script';
      menuItem.ImageIndex := 10;
      targetmenu.Items.Add(menuItem);
      mindex := mindex + 1;

      Dir := SharpApi.GetSharpeUserSettingsPath + 'Scripts\';
      if FindFirst(Dir + '*.sescript',FAAnyFile,sr) = 0 then
      repeat
        menuItem := TMenuItem.Create(targetmenu);
        s := sr.Name;
        setlength(s,length(s) - length('.sescript'));
        menuItem.Caption := s;
        menuItem.ImageIndex := 9;
        menuItem.Hint := Dir + sr.Name;
        menuItem.OnClick := targetmenuclick.OnScriptClick;
        targetmenu.Items.Items[mindex].Add(menuItem);
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;

    if stiAction in TargetItems then
    begin
      // Actions Menu
      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Actions';
      menuItem.ImageIndex := 11;
      targetmenu.Items.Add(menuItem);
      mindex := mindex + 1;

      SList.Clear;
      SList.DelimitedText := SharpApi.GetDelimitedActionList;
      SList.Sort;
      s := '';
      for n := 0 to SList.Count - 1 do
      begin
        if CompareText(s,SList.Names[n]) <> 0 then
        begin
          s := SList.Names[n];
          menuItem := TMenuItem.Create(targetmenu);
          menuItem.Caption := s;
          menuItem.ImageIndex := 12;
          targetmenu.Items.Items[mindex].Add(menuitem);
        end;
        menuItem := TMenuItem.Create(targetmenu);
        menuItem.Caption := SList.ValueFromIndex[n];
        menuItem.Hint    := SList.ValueFromIndex[n];
        menuItem.OnClick := targetmenuclick.OnActionClick;
        menuItem.ImageIndex := 13;
        targetmenu.Items.Items[mindex].Items[targetmenu.Items.Items[mindex].Count -1 ].Add(menuItem); 
      end;
    end;

    targetmenu.Popup(PopupPoint.X,PopupPoint.Y);

    // freeze until OnClick event is done;
    while nrevent do
    begin
      Application.ProcessMessages;
    end;

  finally
    FreeAndNil(SList);
    FreeAndNil(TargetMenu);
    FreeAndNil(targetmenuclick);
  end;
  result := PChar(targetmenuresult);
end;


Exports
  TargetDialog;



procedure EntryPointProc(Reason: Integer);
begin
    case reason of
        DLL_PROCESS_ATTACH:
            begin
            end;

        DLL_PROCESS_DETACH:
            begin
            end;
    end;
end;

// we have to tell the DLL where our entry point proc is and call it as an attach
begin 
    DllProc := @EntryPointProc; 
    EntryPointProc(DLL_PROCESS_ATTACH); 
end.
