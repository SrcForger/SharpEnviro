unit SharpUnicode;

interface

function WideOpenDialog : WideString;
function WideSelectDirectory(const Caption: WideString; const Root: WideString; var Directory: WideString): Boolean;

implementation

uses
  Windows, SysUtils, Forms, ActiveX, ShlObj, ShellApi, Dialogs, CommDlg;

function WideOpenDialog : WideString;
var
  OpenFile: TOpenFilenameW;
  FileName: WideString;
begin
  FillChar(OpenFile, SizeOf(OpenFile), 0);
  SetLength(FileName, 1024);
  FileName[1] := #0;
  OpenFile.lStructSize := SizeOf(OpenFile) - (SizeOf(DWORD) shl 1) - SizeOf(Pointer); { subtract size of added fields }
  OpenFile.hInstance := HInstance;
  OpenFile.hWndOwner := 0;
  OpenFile.lpstrDefExt := 'txt';
  OpenFile.lpstrFilter := 'All files (*.*)'#0'*.*'#0#0;
  OpenFile.lpstrTitle := 'Open File';
  OpenFile.Flags := OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST;
  OpenFile.lpstrFile := PWideChar(FileName);
  OpenFile.nMaxFile := Length(FileName) - 1;
  if GetOpenFileNameW(OpenFile) then
  begin
    result := FileName;
    setlength(FileName,0);
  end;
end;

// WideSelectDirectory based on Tnt Delphi Unicode Controls version 2.3.0
function SelectDirCB_W(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessageW(Wnd, BFFM_SETSELECTIONW, Integer(True), lpdata);
  result := 0;
end;

function WideSelectDirectory(const Caption: WideString; const Root: WideString; var Directory: WideString): Boolean;
{$IFNDEF COMPILER_7_UP}
const
  BIF_NEWDIALOGSTYLE     = $0040;
  BIF_USENEWUI = BIF_NEWDIALOGSTYLE or BIF_EDITBOX;
{$ENDIF}
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfoW;
  Buffer: PWideChar;
  OldErrorMode: Cardinal;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  Result := False;
 // if not WideDirectoryExists(Directory) then
  //  Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH * SizeOf(WideChar));
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do
      begin
        {$IFDEF COMPILER_9_UP}
        hWndOwner := Application.ActiveFormHandle;
        {$ELSE}
        hWndOwner := Application.Handle;
        {$ENDIF}
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PWideChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS;
        if Win32MajorVersion >= 5 then
          ulFlags := ulFlags or BIF_USENEWUI;
        if Directory <> '' then
        begin
          lpfn := SelectDirCB_W;
          lParam := Integer(PWideChar(Directory));
        end;
      end;
      WindowList := DisableTaskWindows(0);
      OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
      try
        ItemIDList := ShBrowseForFolderW(BrowseInfo);
      finally
        SetErrorMode(OldErrorMode);
        EnableTaskWindows(WindowList);
      end;
      Result :=  ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDListW(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

end.
