unit uExecServiceExtractShortcut;

interface

uses
  Windows, Forms, ShellAPI, ShlObj, ComObj, ActiveX;

const
  EXP_DARWIN_ID_SIG       = $A0000006;   // The link's Microsoft© Windows© Installer identifier (ID).
  EXP_LOGO3_ID_SIG        = $A0000007;
  EXP_SPECIAL_FOLDER_SIG  = $A0000005;   // Special folder information.
  EXP_SZLINK_SIG          = $A0000001;   // The target name.
  EXP_SZICON_SIG          = $A0000007;   // The icon name.
  NT_CONSOLE_PROPS_SIG    = $A0000002;   // Console properties.
  NT_FE_CONSOLE_PROPS_SIG = $A0000004;   // The console's code page.

type
  LPDATABLOCK_HEADER      =  ^DATABLOCK_HEADER;
  DATABLOCK_HEADER        = packed record
    cbSize,
    dwSignature:          DWORD;
  end;

  LPEXP_DARWIN_LINK       =  ^EXP_DARWIN_LINK;
  EXP_DARWIN_LINK         =  packed record
    dbh:                  DATABLOCK_HEADER;
    szDarwinID:           Array [0..MAX_PATH-1] of char;
    szwDarwinID:          Array [0..MAX_PATH-1] of word;
  end;

  LPEXP_SPECIAL_FOLDER    =  ^EXP_SPECIAL_FOLDER;
  EXP_SPECIAL_FOLDER      =  packed record
    dbh:                  DATABLOCK_HEADER;
    idSpecialFolder,
    cbOffset:             DWORD;
  end;

  LP_EXP_SZ_LINK          =  ^EXP_SZ_LINK;
  EXP_SZ_LINK             =  packed record
    dbh:                  DATABLOCK_HEADER;
    szTarget:             Array [0..MAX_PATH-1] of char;
    szwTarget:            Array [0..MAX_PATH-1] of word;
  end;

  NT_CONSOLE_PROPS        =  packed record
    dbh:                  DATABLOCK_HEADER;
    wFillAttribute:       WORD;
    wPopupFillAttribute:  WORD;
    dwScreenBufferSize:   COORD;
    dwWindowSize:         COORD;
    dwWindowOrigin:       COORD;
    nFont:                DWORD;
    nInputBufferSize:     DWORD;
    dwFontSize:           COORD;
    uFontFamily:          UINT;
    uFontWeight:          UINT;
    FaceName:             Array [0..LF_FACESIZE-1] of word;
    uCursorSize:          UINT;
    bFullScreen:          BOOL;
    bQuickEdit:           BOOL;
    bInsertMode:          BOOL;
    bAutoPosition:        BOOL;
    uHistoryBufferSize:      UINT;
    uNumberOfHistoryBuffers: UINT;
    bHistoryNoDup:        BOOL;
    ColorTable:           Array [0..16-1] of COLORREF;
  end;

  NT_FE_CONSOLE_PROPS     =  packed record
    dbh:                  DATABLOCK_HEADER;
    uCodePage:            UINT;
  end;

const
  SLDF_HAS_ID_LIST        = $00000001;   // Shell link saved with ID list
  SLDF_HAS_LINK_INFO      = $00000002;   // Shell link saved with LinkInfo
  SLDF_HAS_NAME           = $00000004;
  SLDF_HAS_RELPATH        = $00000008;
  SLDF_HAS_WORKINGDIR     = $00000010;
  SLDF_HAS_ARGS           = $00000020;
  SLDF_HAS_ICONLOCATION   = $00000040;
  SLDF_UNICODE            = $00000080;   // the strings are unicode
  SLDF_FORCE_NO_LINKINFO  = $00000100;   // don't create a LINKINFO (make a dumb link)
  SLDF_HAS_EXP_SZ         = $00000200;   // the link contains expandable env strings
  SLDF_RUN_IN_SEPARATE    = $00000400;   // Run the 16-bit target exe in a separate VDM/WOW
  SLDF_HAS_LOGO3ID        = $00000800;   // this link is a special Logo3/MSICD link
  SLDF_HAS_DARWINID       = $00001000;   // this link is a special Darwin link
  SLDF_RUNAS_USER         = $00002000;   // Run this link as a different user
  SLDF_HAS_EXP_ICON_SZ    = $00004000;   // contains expandable env string for icon path
  SLDF_NO_PIDL_ALIAS      = $00008000;   // don't ever resolve to a logical location
  SLDF_FORCE_UNCNAME      = $00010000;   // make GetPath() prefer the UNC name to the local name
  SLDF_RUN_WITH_SHIMLAYER = $00020000;   // Launch the target of this link w/ shim layer active
  SLDF_RESERVED           = $80000000;

type
  IShellLinkDataList   =  interface(IUnknown)
     ['{45E2B4AE-B1C3-11D0-B92F-00A0C90312E1}']
     function AddDataBlock(pDataBlock: Pointer): HResult; stdcall;
     function CopyDataBlock(dwSig: DWORD; var ppDataBlock: Pointer): HResult; stdcall;
     function RemoveDataBlock(dwSig: DWORD): HResult; stdcall;
     function GetFlags(pdwFlags: PDWORD): HResult; stdcall;
     function SetFlags(dwFlags: DWORD): HResult; stdcall;
  end;

type
  TLinkParams = packed record
     Target:     String;
     pdlTarget:  PItemIDList;
     Description:String;
     Parameters: String;
     WorkDir:    String;
  end;

function ResolveLink(LinkFile: String; var LinkParams: TLinkParams): HResult;
function ExecutePidl(IDList: PItemIDList; pdwProcess: PDWORD): Boolean;

implementation

function MsiLocateComponentA(szComponent: PChar; lpPathBuf: PChar; pcchBuf: PDWORD): Integer; stdcall; external 'msi.dll';
function MsiGetShortcutTargetA(szShortcutTarget, szProductCode, szFeatureID, szComponentCode: PChar): Integer; stdcall; external 'msi.dll';

procedure DisposePIDL(ID: PItemIDList);
var  Malloc:     IMalloc;
begin
  if Assigned(ID) then
  begin
     OLECheck(SHGetMalloc(Malloc));
     Malloc.Free(ID);
     Malloc:=nil;
  end;
end;

function CopyITEMID(Malloc: IMalloc; ID: PItemIDList): PItemIDList;
begin

  result:=Malloc.Alloc(ID^.mkid.cb + SizeOf(ID^.mkid.cb));
  CopyMemory(Result, ID, ID^.mkid.cb+SizeOf(ID^.mkid.cb));

end;

function NextPIDL(IDList: PItemIDList): PItemIDList;
begin

  result:=IDList;
  Inc(PChar(Result), IDList^.mkid.cb);

end;

function GetPIDLSize(IDList: PItemIDList): Integer;
begin

  if Assigned(IDList) then
  begin
     result:=SizeOf(IDList^.mkid.cb);
     while (IDList^.mkid.cb <> 0) do
     begin
        Inc(result, IDList^.mkid.cb);
        IDList:=NextPIDL(IDList);
     end;
  end
  else
     result:=0;

end;

procedure StripLastID(IDList: PItemIDList);
var  MarkerID:   PItemIDList;
begin

  MarkerID:=IDList;
  if Assigned(IDList) then
  begin
     while (IDList.mkid.cb <> 0) do
     begin
        MarkerID:=IDList;
        IDList:=NextPIDL(IDList);
     end;
     MarkerID.mkid.cb:=0;
  end;

end;

function CreatePIDL(Size: Integer): PItemIDList;
var  Malloc:     IMalloc;
begin

  if (SHGetMalloc(Malloc) <> S_OK) then
    result:=nil
  else
  begin
     try
        result:=Malloc.Alloc(Size);
        if Assigned(Result) then FillChar(Result^, Size, 0);
     finally
        Malloc:=nil;
     end;
  end;

end;

function CopyPIDL(IDList: PItemIDList): PItemIDList;
var  Size:       Integer;
begin

  Size:=GetPIDLSize(IDList);
  result:=CreatePIDL(Size);
  if Assigned(result) then CopyMemory(result, IDList, Size);

end;

function ConcatPIDLs(IDList1, IDList2: PItemIDList): PItemIDList;
var  cb1, cb2:   Integer;
begin

  if Assigned(IDList1) then
    cb1:=GetPIDLSize(IDList1)-SizeOf(IDList1^.mkid.cb)
  else
    cb1:=0;
  cb2:=GetPIDLSize(IDList2);
  result:=CreatePIDL(cb1 + cb2);
  if Assigned(result) then
  begin
     if Assigned(IDList1) then CopyMemory(result, IDList1, cb1);
     CopyMemory(PChar(result)+cb1, IDList2, cb2);
  end;

end;

function ExecutePidl(IDList: PItemIDList; pdwProcess: PDWORD): Boolean;
var  lpExecInfo:    TShellExecuteInfo;
begin

  // Check process handle buffer
  if Assigned(pdwProcess) then pdwProcess^:=0;

  // Clear buffer
  ZeroMemory(@lpExecInfo, SizeOf(lpExecInfo));

  // Set parameters
  lpExecInfo.cbSize:=SizeOf(lpExecInfo);
  lpExecInfo.fMask:=SEE_MASK_FLAG_NO_UI or SEE_MASK_IDLIST;
  if Assigned(pdwProcess) then lpExecInfo.fMask:=lpExecInfo.fMask or SEE_MASK_NOCLOSEPROCESS;
  lpExecInfo.Wnd:=GetDesktopWindow;
  lpExecInfo.nShow:=SW_SHOWNORMAL;
  lpExecInfo.lpIDList:=IDList;

  // Attempt the start
  result:=ShellExecuteEx(@lpExecInfo);

  // Return the process handle if successful and buffer was passed
  if result and Assigned(pdwProcess) then pdwProcess^:=lpExecInfo.hProcess;

end;

function ResolveLink(LinkFile: String; var LinkParams: TLinkParams): HResult;
var  psl:        IShellLink;
     ppf:        IPersistFile;
     ppshf:      IShellFolder;
     psldl:      IShellLinkDataList;
     pdl:        PItemIDList;
     lpData:     Pointer;
     str:        TStrRet;
     dwSize:     DWORD;
     //szDID:      String;
     wfd:        WIN32_FIND_DATA;
     wszFile:    Array [0..MAX_PATH] of WideChar;
     szArgs:     Array [0..MAX_PATH] of Char;
     szPath:     Array [0..MAX_PATH] of Char;
     szDesc:     Array [0..MAX_PATH] of Char;
begin

  // Clear out buffer
  with LinkParams do
  begin
     Target:='';
     pdlTarget:=nil;
     Description:='';
     Parameters:='';
     WorkDir:='';
  end;

  // Get a pointer to the IShellLink interface.
  CoInitialize(nil);
  result:=CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER, IShellLink, psl);
  if (result = S_OK) then
  begin
     // Get a pointer to the IPersistFile interface.
     result:=psl.QueryInterface(IPersistFile, ppf);
     if (result = S_OK) then
     begin
        // Ensure that the string is Unicode.
        MultiByteToWideChar(CP_ACP, 0, PChar(LinkFile), -1, @wszFile, MAX_PATH);
        // Load the shortcut.
        result:=ppf.Load(@wszFile, STGM_READ);
        if (result = S_OK) then
        begin
           // Resolve the link.
           result:=psl.Resolve(Application.Handle, 16);
           if (result = S_OK) then
           begin
              // Get the path to the link target.
              result:=psl.GetPath(@szPath, MAX_PATH, wfd, SLGP_UNCPRIORITY); // SLGP_SHORTPATH);
              // Check result, may need to get the pidl
              if (result <> S_OK) then
              begin
                 // Attempt the pidl get
                 result:=psl.GetIDList(pdl);
                 if (result = S_OK) then
                 begin
                    // Make a copy of this
                    LinkParams.pdlTarget:=CopyPidl(pdl);
                    DisposePIDL(pdl);
                    ZeroMemory(@szPath, SizeOf(szPath));
                 end;
              end;
              if (result = S_OK) then
              begin
                 LinkParams.Target:=szPath;
                 // Check IShellLinkDataList
                 if (psl.QueryInterface(IShellLinkDataList, psldl) = S_OK) then
                 begin
                    if (MsiGetShortcutTargetA(PChar(LinkFile), nil, nil, @szDesc) = 0) then
                    begin
                       MsiLocateComponentA(@szDesc, @szPath, @dwSize);
                       LinkParams.Target:=szPath;
                    end;
                 end;
                 // Get the description of the target.
                 result:=psl.GetDescription(@szDesc, MAX_PATH);
                 // Check description
                 if (result = S_OK) then
                 begin
                    // Check for null description
                    if (szDesc[0] = #0) and Assigned(LinkParams.pdlTarget) then
                    begin
                       ShGetDesktopFolder(ppshf);
                       if (ppshf.GetDisplayNameOf(LinkParams.pdlTarget, SHGDN_NORMAL, str) = S_OK) then
                       begin
                          case str.uType of
                             STRRET_CSTR    :
                                SetString(LinkParams.Description, str.cStr, lstrlen(str.cStr));
                             STRRET_OFFSET  :
                             begin
                                lpData:=@LinkParams.pdlTarget.mkid.abID[str.uOffset-SizeOf(LinkParams.pdlTarget.mkid.cb)];
                                SetString(LinkParams.Description, PChar(lpData), LinkParams.pdlTarget.mkid.cb-str.uOffset);
                             end;
                             STRRET_WSTR    :
                             begin
                                LinkParams.Description:=str.pOleStr;
                                //SysFreeString(str.pOleStr);
                             end;
                          end;
                       end;
                       // Release the desktop folder
                       ppshf:=nil;
                    end
                    else
                       // Description
                       LinkParams.Description:=szDesc;
                    // Get the arguments
                    result:=psl.GetArguments(@szArgs, MAX_PATH);
                    if (result = S_OK) then
                    begin
                       LinkParams.Parameters:=szArgs;
                       // Get the working directory
                       result:=psl.GetWorkingDirectory(@szPath, MAX_PATH);
                       if (result = S_OK) then LinkParams.WorkDir:=szPath;
                    end;
                 end;
              end;
           end;
        end;
        // Release the pointer to the IPersistFile interface.
        ppf:=nil;
     end;
     // Release the pointer to the IShellLink interface.
     psl:=nil;
  end;
end;

end.
