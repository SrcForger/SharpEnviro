unit sharpprocess;

interface

uses classes, Forms, SysUtils, ShellApi, ShlObj, ComObj, Windows,
     Graphics, psapi, tlHelp32, messages, jclshell, GR32, GR32_Image, SharpAPI,
     SharpLibrary, SharpEImage32, ShellHookTypes, Activex, ComCtrls, HotKeyManager;

{$REGION ' Process & File Type Declarations '}
type
  TProcessObject = record
                    Handle  : HWnd;
                    Bitmap  : TBitmap32;
                    Caption : string;
                    Icon    : HICON;
                    Path    : string;
                  end;
  PTProcessObject = ^TProcessObject;

type
  TContainerObject = record
                    Icon    : HICON;
                    Bitmap  : TBitmap32;
                    Caption : string;
                    Count   : integer;
                    Path    : string;
                  end;
  PTContainerObject = ^TContainerObject;

type
  TQuickLaunchObject = record
                    Bitmap  : TBitmap32;
                    Caption : string;
                    Icon    : HICON;
                    Path    : string;
                  end;
  PTQuickLaunchObject = ^TQuickLaunchObject;

type
  TSharpTask = class(TPersistent)
  private
    { Private declarations }
    procedure SetWindowState(iMode: integer; wnd: HWND);
  public
    { Public declarations }
    ContainerList: TList;
    QuickList: TList;
    WindowList: TList;

    function CreateShortcut(szFile: string): IPersistFile;

    procedure ActivateWindow(wnd: HWND);
    procedure Build;
    procedure DeActivateWindow(wnd: HWND);
    procedure DisplayContainerFolder(szFile: string);
    procedure DisplayPropertySheet(szFile: string);
    procedure Empty;
    procedure Execute(szFile: string);
  protected
    { Protected declarations }
  end;

TProcessType = (ptTask, ptQuick);

TPositionInfo = record
                     Left : integer;
                     Top  : integer;
end;

TDrawType = (dtDown, dtHover, dtNormal);

TPushDirection = (pdUp, pdDown, pdRight, pdLeft);

type
  TSharpTaskImage = class(TSharpEImage32)
  private
    fActive : boolean;
    fAlphaLevel: cardinal; //Test - Might be removed
    fDisplayBitmap: TBitmap32;
    fPath : string;
    fProcessType: TProcessType;

    fHWND : HWND;

    procedure WMCOMMAND(var msg: TMessage); message WM_COMMAND;
    procedure WMHSHELLBROADCAST(var Msg: TMessage); message WM_HSHELL_BROADCAST;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Active : boolean read fActive write fActive;
    property AlphaLevel : Cardinal read fAlphaLevel write fAlphaLevel;
    property DisplayBitmap : TBitmap32 read fDisplayBitmap write fDisplayBitmap;
    property Path: string read fPath write fPath;
    property ProcessType: TProcessType read fProcessType write fProcessType;
    property WND : HWND read fHWND write fHWND;

    function GetQuickHint: string;
    function StillExists: boolean;

    procedure AdjustSize(iWidth, iHeight: integer; iPadding: integer = 0;bPadWidthOnly: boolean = False;bPadHeightOnly: boolean = False);
    procedure CreateShortCut;
    procedure DisplayContainerFolder;
    procedure DisplayPopup;
    procedure DisplayPropertySheet;
    procedure DrawBackground(dtType: TDrawType = dtNormal);
    procedure Execute;
    procedure FlipWindow(bOnlySetFocus: boolean = False);
    procedure Update;
  end;
{$ENDREGION}

{$REGION ' Container Function / Procedure Declarations '}
  function BuildContainerList: TList;
  procedure EmptyContainerList(ConList: TList);
{$ENDREGION}

{$REGION ' Quick Launch Function / Procedure Declarations '}
  function BuildQuickList: TList;
  function BuildQuickListBitmap: Graphics.TBitmap;
  function GetQuickLaunchPath: string;
  procedure EmptyQuickList(QuickList: TList);
{$ENDREGION}

{$REGION ' Window List Function / Procedure Declarations '}
  function BuildWindowList: TList;
  function BuildWindowListBitmap: Graphics.TBitmap;
  procedure EmptyWindowList(WindowList: TList);
{$ENDREGION}

function GetActiveWindow: HWND;
function IsTaskWindow(isWnd: HWND): boolean;
function SharpEBroadCastEx(msg: integer; wpar: wparam; lpar: lparam): integer;

procedure PushAWindow(Wnd: HWND; bRecall: boolean = false; bVWM: boolean = False; iDeskCount: integer = 0; pdDirection: TPushDirection = pdRight; iDistance: integer = 0);

implementation

//const
//  LOCALIZED_KEYNAMES = True;

var
//  i: integer;
  wpara: wparam;
  mess: integer;
  lpara: lparam;

function GetPathFromWND(WndProc: HWND): string;
function _GetFileName(iPID: DWORD): string;
var
  PIDArray: array [0..1023] of DWORD;
  cb: DWORD;
  I: Integer;
  ProcCount: Integer;
  hMod: HMODULE;
  hProcess: THandle;
  ModuleName: array [0..300] of Char;
begin
  Result := '';

  EnumProcesses(@PIDArray, SizeOf(PIDArray), cb);

  ProcCount := cb div SizeOf(DWORD);

  for I := 0 to (ProcCount - 1) do
   begin
    if (PIDArray[I] = iPID) then
     begin
      hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or
      PROCESS_VM_READ,
      False,
      PIDArray[I]);

      if (hProcess <> 0) then
       begin
        EnumProcessModules(hProcess, @hMod, SizeOf(hMod), cb);
        GetModuleFilenameEx(hProcess, hMod, ModuleName, SizeOf(ModuleName));
        Result := ModuleName;
        CloseHandle(hProcess);
        break;
       end;
     end;
   end;
end;
function _GetFileNameNT(iPID: DWORD): string;
var
  PIDArray: array [0..1023] of DWORD;
  cb: DWORD;
  I: Integer;
  ProcCount: Integer;
  hMod: HMODULE;
  hProcess: THandle;
  ModuleName: array [0..300] of Char;
begin
  Result := '';

  EnumProcesses(@PIDArray, SizeOf(PIDArray), cb);

  ProcCount := cb div SizeOf(DWORD);

  for I := 0 to (ProcCount - 1) do
   begin
    if (PIDArray[I] = iPID) then
     begin
      hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or
      PROCESS_VM_READ,
      False,
      PIDArray[I]);

      if (hProcess <> 0) then
       begin
        EnumProcessModules(hProcess, @hMod, SizeOf(hMod), cb);
        GetModuleFilenameEx(hProcess, hMod, ModuleName, SizeOf(ModuleName));
        Result := ModuleName;
        CloseHandle(hProcess);
        break;
       end;
     end;
   end;
end;
var
  MyInt: DWORD;
begin
  Result := '';

  MyInt := 0;
  GetWindowThreadProcessId(WndProc,@MyInt);

  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
   begin
    Result := _GetFileNameNT(MyInt);
   end
  else
   begin
    Result := _GetFileName(MyInt);
   end;
end;

procedure PushAWindow(Wnd: HWND; bRecall: boolean = false; bVWM: boolean = False; iDeskCount: integer = 0; pdDirection: TPushDirection = pdRight; iDistance: integer = 0);
var
//  wp: WindowPlacement;
  bIconic, bMaximized: boolean;
  iWidth: integer;
  rcSize: TRect;
begin
  if (IsWindow(Wnd)) then
   begin
    bIconic := IsIconic(Wnd);

    bMaximized := False;

    if not bIconic then
     begin
      bMaximized := IsZoomed(Wnd);
     end;

    GetWindowRect(Wnd, rcSize);

    if (bVWM) then
     begin
      iWidth := (rcSize.Right - rcSize.Left);

      if (bIconic) then
       begin
       end
      else
       begin
        if (bMaximized) then
         begin
          rcSize.Left := rcSize.Left + 4;
          rcSize.Top := rcSize.Top + 4;
         end;

//        if (rcSize.Top < 10000) then
        //(Top < 0) Fix 
        if (rcSize.Top < 5000) then
         begin
          rcSize.Top := (rcSize.Top + 10000);
         end;

        if not (bRecall) then
         begin
          rcSize.Left := rcSize.Left + ((0 - iDeskCount) * 10000);
         end;

        if (((rcSize.Left > -5) and (rcSize.Left < Screen.DesktopWidth)) or
        ((rcSize.Left < 0) and ((rcSize.Left + iWidth) > -1)) or bRecall) then
         begin
          //If we're being asked to recall a window, we're assuming that the window
          // being recalled, was previously moved by this procedure
//          rcSize.Left := rcSize.Left + 100000;
          rcSize.Left := rcSize.Left - ((rcSize.Left div 10000) * 10000);

//          rcSize.Top := rcSize.Top - ((rcSize.Top div 10000) * 10000);
          rcSize.Top := rcSize.Top - 10000;
         end;

        if (bMaximized) then
         begin
          rcSize.Left := rcSize.Left - 4;
          rcSize.Top := rcSize.Top - 4;
         end;

       end;
     end
    else
     begin
      case pdDirection of
       pdUp:
        begin
         rcSize.Top := (rcSize.Top - iDistance);
        end;
       pdDown:
        begin
         rcSize.Top := (rcSize.Top + iDistance);
        end;
       pdRight:
        begin
         rcSize.Left := (rcSize.Left + iDistance);
        end;
       pdLeft:
        begin
         rcSize.Left := (rcSize.Left - iDistance);
        end;
      end;
     end;

    if not (bIconic) then
     begin
      SetWindowPos(Wnd, HWND_BOTTOM, rcSize.Left, rcSize.Top, 0, 0,
                   SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOSIZE);
     end;
   end;
end;

{$REGION ' TSharpTaskImage Events / Procedures '}
constructor TSharpTaskImage.Create(AOwner: TComponent);
begin
  inherited;

  fDisplayBitmap := TBitmap32.Create;

  ShowHint := True;

  BitmapAlign := baCenter;
  Bitmap.DrawMode := dmBlend;
  Bitmap.CombineMode := cmMerge;
  RepaintMode := rmOptimizer;
  ScaleMode := smNormal;

  AdjustSize(16,16,0);
end;
destructor TSharpTaskImage.Destroy;
begin
  if Assigned(fDisplayBitmap) then
    FreeAndNil(fDisplayBitmap);

  inherited;
end;

procedure TSharpTaskImage.WMCOMMAND(var msg: TMessage);
begin
  if (ProcessType = ptTask) then
   begin
    PostMessage(WND, WM_SysCommand, msg.wparam, msg.lparam);

    msg.LParam := WND;
    PostMessage(Parent.Handle, WM_SysCommand, msg.wparam, msg.lparam);
   end;
  inherited;
end;
procedure TSharpTaskImage.WMHSHELLBROADCAST(var Msg: TMessage);
begin
  //This one isn't getting called, cause the bug in BroadCast()
  Update;
end;

function TSharpTaskImage.GetQuickHint: string;
var
  szBuffer: string;
begin
  szBuffer := ExtractFileName(Path);
  szBuffer := Copy(szBuffer, 0, (Length(szBuffer) - Length(ExtractFileExt(szBuffer))));

  Result := szBuffer;
end;
function TSharpTaskImage.StillExists: boolean;
begin
  Result := False;

  if (ProcessType = ptQuick) then
   begin
    Result := FileExists(Path);
   end;

  if (ProcessType = ptTask) then
   begin
    Result := IsWindowVisible(Wnd);
   end;
end;

procedure TSharpTaskImage.AdjustSize(iWidth, iHeight: integer; iPadding: integer = 0;bPadWidthOnly: boolean = False;bPadHeightOnly: boolean = False);
begin
  Bitmap.SetSize(iWidth, iHeight);

  Width := iWidth;
  Height := iHeight;

  if not bPadWidthOnly then
   Height := iHeight + iPadding;

  if not bPadHeightOnly then
   Width := iWidth + iPadding;
end;
procedure TSharpTaskImage.CreateShortCut;
var
  tmpTask: TSharpTask;
begin
  tmpTask := TSharpTask.Create;
  try
   tmpTask.CreateShortcut(Path);
  finally
   FreeAndNil(tmpTask);
  end;
end;
procedure TSharpTaskImage.Execute;
var
  tmpTask: TSharpTask;
begin
  tmpTask := TSharpTask.Create;
  try
   tmpTask.Execute(Path);
  finally
   FreeAndNil(tmpTask);
  end;
end;
procedure TSharpTaskImage.DisplayContainerFolder;
var
  tmpTask: TSharpTask;
begin
  tmpTask := TSharpTask.Create;
  try
    tmpTask.DisplayContainerFolder(Path);
  finally
   FreeAndNil(tmpTask);
  end;
end;
procedure TSharpTaskImage.DisplayPropertySheet;
var
  tmpTask: TSharpTask;
begin
  tmpTask := TSharpTask.Create;
  try
    tmpTask.DisplayPropertySheet(Path);
  finally
   FreeAndNil(tmpTask);
  end;
end;
procedure TSharpTaskImage.DisplayPopup;
var
  ptCursor: TPoint;
  AppMenu: hMenu;
begin
  AppMenu := GetSystemMenu(Wnd, False);

  GetCursorPos(ptCursor);

  if IsIconic(Wnd) then
   begin
    EnableMenuItem(AppMenu, sc_restore, mf_bycommand or mf_enabled);
    EnableMenuItem(AppMenu, sc_move, mf_bycommand or mf_grayed);
    EnableMenuItem(AppMenu, sc_size, mf_bycommand or mf_grayed);
    EnableMenuItem(AppMenu, sc_minimize, mf_bycommand or mf_grayed);
   end
  else
   if IsZoomed(Wnd) then
    begin
     EnableMenuItem(AppMenu, sc_restore, mf_bycommand or mf_enabled);
     EnableMenuItem(AppMenu, sc_move, mf_bycommand or mf_grayed);
     EnableMenuItem(AppMenu, sc_size, mf_bycommand or mf_grayed);
     EnableMenuItem(AppMenu, sc_maximize, mf_bycommand or mf_grayed);
    end
   else
    begin
     EnableMenuItem(AppMenu, sc_restore, mf_bycommand or mf_grayed);
     EnableMenuItem(AppMenu, sc_move, mf_bycommand or mf_enabled);
     EnableMenuItem(AppMenu, sc_size, mf_bycommand or mf_enabled);
     EnableMenuItem(AppMenu, sc_minimize, mf_bycommand or mf_enabled);
    end;

    TrackPopupMenu(AppMenu, tpm_leftalign or tpm_leftbutton, ptCursor.x, ptCursor.y, 0, Handle, nil);
end;
procedure TSharpTaskImage.DrawBackground(dtType: TDrawType = dtNormal);
begin
  Bitmap.Clear(clWhite);

  case dtType of
   dtDown:
    begin
    end;
   dtHover:
    begin
    end;
   dtNormal:
    begin
     DisplayBitmap.DrawTo(Bitmap, Rect(0,0,Bitmap.Width,Bitmap.Height));
    end;
  end;
end;
procedure TSharpTaskImage.FlipWindow(bOnlySetFocus: boolean = False);
begin
  if IsWindow(Wnd) then
   begin
    if (IsIconic(Wnd) or bOnlySetFocus) then
     begin
      ShowWindow(Wnd, SW_RESTORE);

      BringWindowToTop(Wnd);
	    SetActiveWindow(Wnd);
	    SetForegroundWindow(Wnd);

      SendMessageEX('SharpE_VWM',nil,WM_SHARPTASKMESSAGE,Wnd,1);

     end
    else
     begin
      ShowWindow(Wnd, SW_MINIMIZE);
     end;
   end;
end;

procedure TSharpTaskImage.Update;
var
  icDisplay: HICON;
begin
  if StillExists then
   begin
    if (ProcessType = ptTask) then
     begin
      try
//       Active := (Wnd = GetForegroundWindow);
       Active := (Wnd = GetActiveWindow);

       GetWindowIcon(icDisplay, Wnd);

       IconToImage(DisplayBitmap, icDisplay);

       DrawBackground;

       Path := GetPathFromWND(Wnd);

       Hint := GetWindowCaption(Wnd);
//       Text := GetWindowCaption(Wnd);
      finally
       DestroyIcon(icDisplay);
      end;
     end;

    if (ProcessType = ptQuick) then
     begin
      if (FileExists(Path)) then
       begin
       end
      else
       begin
        Free;
       end;
    end;
   end
  else
   begin
    Free;
   end;
end;
{$ENDREGION}

{$REGION ' TSharpTask Procedures '}
function TSharpTask.CreateShortcut(szFile: string): IPersistFile;
var
  MyObject: IUnknown;
  MySLink: IShellLink;
  MyPFile: IPersistFile;
  WideFile: WideString;
  CmdLine, Args, WorkDir, LinkFile: string;
begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;

  CmdLine := szFile;
  Args := '';
  WorkDir := ExtractFilePath(szFile);

  LinkFile := ExtractFileName(szFile);
  LinkFile := Copy(LinkFile, 0, (Length(LinkFile) - Length(ExtractFileExt(LinkFile))));
  LinkFile := GetQuickLaunchPath + '\' + LinkFile + '.lnk';
  LinkFile := LowerCase(LinkFile);

  with MySLink do
   begin
    SetPath(PChar(CmdLine));
    SetArguments(PChar(Args));
    SetWorkingDirectory(PChar(WorkDir));
   end;

  WideFile := LinkFile;

  MyPFile.Save(PWChar(WideFile), False);

  Result := MyPFile;
end;

procedure TSharpTask.ActivateWindow(wnd: HWND);
begin
  SetWindowState(0, wnd);
end;
procedure TSharpTask.Build;
begin
  Empty;

  ContainerList := BuildContainerList;
  QuickList := BuildQuickList;
  WindowList := BuildWindowList;
end;

procedure TSharpTask.DeActivateWindow(wnd: HWND);
begin
  SetWindowState(1, wnd);
end;
procedure TSharpTask.DisplayContainerFolder(szFile: string);
begin
  Execute(ExtractFilePath(szFile));
end;
procedure TSharpTask.DisplayPropertySheet(szFile: string);
var
  xp: TPoint;
begin
  GetCursorPos(xp);

  DisplayContextMenu(0, szFile, xp);
end;
procedure TSharpTask.Empty;
begin
  if Assigned(ContainerList) then
    EmptyContainerList(ContainerList);

  if Assigned(QuickList) then
    EmptyQuickList(QuickList);

  if Assigned(WindowList) then
    EmptyWindowList(WindowList);
end;
procedure TSharpTask.Execute(szFile: string);
begin
  ShellExecute(0, nil, pchar(szFile), nil, nil, SW_SHOWNORMAL);
end;
procedure TSharpTask.SetWindowState(iMode: integer; wnd: HWND);
begin
  case iMode of
    0:
     begin
      ShowWindow(wnd, SW_RESTORE);

	    BringWindowToTop(wnd);
	    SetActiveWindow(wnd);
	    SetForegroundWindow(wnd);
     end;
    1:
     begin
      ShowWindow(wnd, SW_MINIMIZE);
     end;
  end
end;
{$ENDREGION}

{$REGION ' Container Functions / Procedures '}
function BuildContainerList: TList;
  function  GetAppInfo(De, szProcess:string): string;

  {
     CompanyName
     FileDescription
     FileVersion
     InternalName
     LegalCopyright
     OriginalFilename
     ProductName
     ProductVersion
  }

  type
    PaLeerBuffer = array [0..MAX_PATH] of char;

  var
   Size, Size2 : DWord;
   Pt, Pt2     : Pointer;
   Idioma      : string;

   begin
     Result:='';

     try
     Size := GetFileVersionInfoSize(PChar(szProcess), Size2);
     if (Size > 0) then
      begin
       GetMem (Pt, Size);
       GetFileVersionInfo (PChar(szProcess), 0, Size, Pt);
       VerQueryValue( Pt, '\VarFileInfo\Translation',Pt2, Size2);
       Idioma := IntToHex( DWord(Pt2^), 8);

       Idioma := Copy(Idioma,5,4)+Copy(Idioma,1,4);

       VerQueryValue( Pt,
                      Pchar('\StringFileInfo\'+
                      Idioma+'\'+
                      De),
                      Pt2, Size2);

       if Size2 > 0 then
        begin
         Result := Copy(PaLeerBuffer(Pt2^),1,Size2);
        end
       else
        begin
         Result := '';
        end;

       FreeMem (Pt);
      end;
   except
   end;
   end;
  function InContainerList(szPath: string; ConList: TList): boolean;
  var
   i, j: integer;
  begin
   Result := False;

   j := Pred(ConList.Count);
   for i := 0 to j do
    begin
     if (PTContainerObject(ConList.Items[i]).Path = szPath) then
      begin
        Result := True;
        break;
      end;
    end;
  end;
  function WhereIsContainer(szPath: string; ConList: TList): integer;
  var
   i, j: integer;
  begin
    Result := -1;

    j := Pred(ConList.Count);
    for i := 0 to j do
     begin
      if (PTContainerObject(ConList.Items[i]).Path = szPath) then
       begin
        Result := i;
        break;
       end;
     end;

  end;
var
  ContainerList, WindowList: TList;
  MyContainerPtr : ^TContainerObject;

  i, j, k: integer;

  wIndex: word;
begin
  Result := nil;

  WindowList := BuildWindowList;

  if (WindowList.Count > 0) then
   begin
    ContainerList := TList.Create;

    j := Pred(WindowList.Count);
    for i := 0 to j do
     begin
      if not (InContainerList(PTProcessObject(WindowList.Items[i]).Path, ContainerList)) then
       begin
        New(MyContainerPtr);

        MyContainerPtr.Path := PTProcessObject(WindowList.Items[i]).Path;
        MyContainerPtr.Caption := PTProcessObject(WindowList.Items[i]).Caption;
        MyContainerPtr.Icon := PTProcessObject(WindowList.Items[i]).Icon;
        MyContainerPtr.Count := 1;

        ContainerList.Add(MyContainerPtr);
       end
      else
       begin
        k := WhereIsContainer(PTProcessObject(WindowList.Items[i]).Path, ContainerList);

        if (k > -1) then
         begin
          PTContainerObject(ContainerList.Items[k]).Count := PTContainerObject(ContainerList.Items[k]).Count + 1;

          if (PTContainerObject(ContainerList.Items[k]).Count = 2) then
           begin
            PTContainerObject(ContainerList.Items[k]).Icon := ExtractAssociatedIcon(hInstance,PChar(PTContainerObject(ContainerList.Items[k]).Path),wIndex);
            PTContainerObject(ContainerList.Items[k]).Caption := GetAppInfo('FileDescription', PTContainerObject(ContainerList.Items[k]).Path);
           end;
         end;
       end;
     end;

    Result := ContainerList;
   end;

  EmptyWindowList(WindowList);
  FreeAndNil(WindowList);
end;
procedure EmptyContainerList(ConList: TList);
var
  i, j: integer;
begin
  if (ConList.Count > 0) Then
   begin
    j := Pred(ConList.Count);

    for i := 0 to j do
     begin
      DestroyIcon(PTContainerObject(ConList[I]).Icon);
      Dispose(PTContainerObject(ConList[I]));
     end;

    ConList.Clear;
   end;
end;
{$ENDREGION}

{$REGION ' Quick Launch Functions / Procedures '}
function BuildQuickList : TList;
  procedure GetQuickLaunchInfo(lstQuick: TList; szQuickInfo: string);
  var
    MyQuickPtr : ^TQuickLaunchObject;

    szBuffer, szExt: string;

    Link: TShellLink;
    wIndex: word;
  begin
    szExt := UpperCase(ExtractFileExt(szQuickInfo));

    if (szExt = '.INI') then exit;

    if (szExt = '.LNK') then
     begin
      ShellLinkResolve(szQuickInfo, Link);
     end
    else
     begin
      Link.Target := szQuickInfo;
      Link.IconIndex := 0;
     end;

    szBuffer := ExtractFileName(szQuickInfo);

    if not FileExists(Link.Target) then exit;

    New(MyQuickPtr);

    MyQuickPtr.Caption := Copy(szBuffer, 0, (Length(szBuffer) - 4));
    MyQuickPtr.Path := szQuickInfo;

    wIndex := 0;

    if (Link.IconIndex > -1) then
     wIndex := Link.IconIndex;

    if (szExt = '.SCF') then
     begin
 	    MyQuickPtr.Icon := ExtractAssociatedIcon(hInstance, PChar(Link.Target), wIndex);
     end
    else
     begin
      MyQuickPtr.Icon := ExtractIcon(0, PChar(Link.Target), wIndex);
     end;

    if (MyQuickPtr.Icon = 0) then
     begin
 	    MyQuickPtr.Icon := ExtractAssociatedIcon(hInstance, PChar(Link.Target), wIndex);
     end;

    if (MyQuickPtr.Icon > 0) then
     begin
      MyQuickPtr.Bitmap := TBitmap32.Create;
      IconToImage(MyQuickPtr.Bitmap, MyQuickPtr.Icon);
     end;

    lstQuick.Add(MyQuickPtr);
  end;
var
  sr: TSearchRec;
  FileAttrs: Integer;
  QuickList : TList;
  qLaunchDir: string;
begin
  Result := nil;

  QuickList := TList.Create;

  FileAttrs := 0;
  FileAttrs := FileAttrs + faAnyFile;

  qLaunchDir := GetQuickLaunchPath;

  if (FindFirst(qLaunchDir + '\*.*', FileAttrs, sr) = 0) then
   begin
    if (sr.Attr and FileAttrs) = sr.Attr then
     begin
      if (sr.Size > 0) then
       begin
        GetQuickLaunchInfo(QuickList,qLaunchDir + '\' + sr.Name);
       end;
     end;

     while (FindNext(sr) = 0) do
      begin
       if (sr.Attr and FileAttrs) = sr.Attr then
        begin
         if (sr.Size > 0) then
          begin
           GetQuickLaunchInfo(QuickList,qLaunchDir + '\' + sr.Name);
          end;
        end;
      end;

     FindClose(sr.FindHandle);
   end;

  Result := QuickList;
end;
function BuildQuickListBitmap: Graphics.TBitmap;
var
  bmpQuickList: Graphics.TBitmap;
  icQuickList: TIcon;
  QuickList: TList;
  i, j: integer;
begin
  Result := nil;

  //Why did I have to say Graphics.TBitmap.Create, instead of just TBitmap.Create ????
  try
   QuickList := BuildQuickList;

   if (QuickList.Count > 0) then
    begin
     bmpQuickList := Graphics.TBitmap.Create;

     bmpQuicklist.Width := ((QuickList.Count * 16) + (QuickList.Count * 2) + 2);
     bmpQuickList.Height := 20;

     j := Pred(QuickList.Count);
     for i := 0 to j do
      begin
       try
        icQuickList := TIcon.Create;
        icQuickList.Handle := PTQuickLaunchObject(QuickList.Items[i]).Icon;

        DrawIconEx(bmpQuickList.Canvas.Handle,((i * 16) + ((i + 1) * 2)),2,PTQuickLaunchObject(QuickList.Items[i]).Icon, 16, 16, 0, 0, DI_NORMAL);
       finally
        FreeAndNil(icQuickList);
       end;
      end;

     EmptyQuickList(QuickList);
     FreeAndNil(QuickList);

     Result := bmpQuickList;
    end;
  finally
//   bmpWindowList.Free;
  end;
end;
function GetQuickLaunchPath: string;
begin
  Result := GetSpecialFolder(0,CSIDL_APPDATA) + '\Microsoft\Internet Explorer\Quick Launch';
end;
procedure EmptyQuickList(QuickList: TList);
var
  i, j: integer;
begin
  if (QuickList.Count > 0) Then
   begin
    j := Pred(QuickList.Count);

    for i := 0 to j do
     begin
      DestroyIcon(PTQuickLaunchObject(QuickList[I]).Icon);
      Dispose(PTQuickLaunchObject(QuickList[I]));
     end;

    QuickList.Clear;
   end;
end;
{$ENDREGION}

{$REGION ' Window List Functions / Procedures '}
function WindowCallback(WHandle : HWnd; Var Parm : Pointer) : Boolean; stdcall;
var
//  MyInt: DWORD;
  MyWindowPtr : ^TProcessObject;
  lExStyle : DWORD;
  Buf: array[0..255] of Char; {&&&}
  bParent, bDesktopOwned: boolean;
  szBuffer: string;
begin
	Result := True;

  if not (IsWindowVisible(WHandle)) then exit;

  lExStyle := (GetWindowLong(WHandle, GWL_EXSTYLE));

  if ((lExStyle and WS_EX_TOOLWINDOW) <> 0) then exit;

  if (GetWindowLong(WHandle, GWL_HWNDPARENT) > 0) then
   bParent := False
  else
   bParent := True;

  bDesktopOwned := (HWND(GetWindowLong(Whandle, GWL_HWNDPARENT)) = GetDesktopWindow);

  if not (bParent or bDesktopOwned) then exit;

  GetClassName(WHandle, Buf, SizeOf(Buf)-1);
  szBuffer := UpperCase(Buf);

  if (szBuffer = 'WINDOWSSCREENSAVERCLASS') or (szBuffer = 'D3DSAVERWNDCLASS') then exit;

  New(MyWindowPtr);

  {Window Handle}
  MyWindowPtr.Handle := WHandle;

  Buf := '';

  {Window Caption}
  GetWindowText(WHandle, Buf, SizeOf(Buf)-1);
  MyWindowPtr.Caption := Buf;

  {Process Path}
//  MyInt := 0;
//  GetWindowThreadProcessId(WHandle,@MyInt);

//  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
//   begin
//    MyWindowPtr.Path := _GetFileNameNT(MyInt);
//   end
//  else
//   begin
//    MyWindowPtr.Path := _GetFileName(MyInt);
//   end;
  MyWindowPtr.Path := GetPathFromWND(MyWindowPtr.Handle);

  {Icon}
  GetWindowIcon(MyWindowPtr.Icon, WHandle);

  if (MyWindowPtr.Icon > 0) then
   begin
    MyWindowPtr.Bitmap := TBitmap32.Create;
    IconToImage(MyWindowPtr.Bitmap, MyWindowPtr.Icon);
   end;

  TList(Parm).Add(MyWindowPtr);
end;
function BuildWindowList: TList;
var
  WindowList : TList;
begin
  Result := nil;

  WindowList := TList.Create;

  EnumWindows(@WindowCallback,Longint(@WindowList));

  Result := WindowList;
end;
function BuildWindowListBitmap: Graphics.TBitmap;
var
  bmpWindowList: Graphics.TBitmap;
  icWindowList: TIcon;
  WindowList: TList;
  i, j: integer;
begin
  Result := nil;

  try
   WindowList := BuildWindowList;

   if (WindowList.Count > 0) then
    begin
     bmpWindowList := Graphics.TBitmap.Create;

     bmpWindowlist.Width := ((WindowList.Count * 16) + (WindowList.Count * 2) + 2);
     bmpWindowList.Height := 20;

     j := Pred(WindowList.Count);
     for i := 0 to j do
      begin
       try
        icWindowList := TIcon.Create;
        icWindowList.Handle := PTProcessObject(WindowList.Items[i]).Icon;

        bmpWindowList.Canvas.Draw(((i * 16) + ((i + 1) * 2)),2,icWindowList);
       finally
        FreeAndNil(icWindowList);
       end;
      end;

     EmptyWindowList(WindowList);
     FreeAndNil(WindowList);

     Result := bmpWindowList;
    end;
  finally
//   bmpWindowList.Free;
  end;
end;
procedure EmptyWindowList(WindowList: TList);
var
  i, j: integer;
begin
  if (WindowList.Count > 0) Then
   begin
    j := Pred(WindowList.Count);

    for i := 0 to j do
     begin
      DestroyIcon(PTProcessObject(WindowList[I]).Icon);
      Dispose(PTProcessObject(WindowList[I]));
     end;

    WindowList.Clear;
   end;
end;
{$ENDREGION}

function GetActiveWindow: HWND;
var
  i: HWND;
begin
  Result := GetForegroundWindow;
  i := HWND(GetWindowLong(Result, GWL_HWNDPARENT));

  if (i > 0) then Result := i;
end;

function IsTaskWindow(isWnd: HWND): boolean;
var
  tmpTask: TSharpTask;
  i,j: integer;
begin
  Result := False;

  tmpTask := TSharpTask.Create;
  try
   tmpTask.Build;
   j := Pred(tmpTask.WindowList.Count);
    for i := 0 to j do
     begin
      if (PTProcessObject(tmpTask.WindowList.Items[i]).Handle = isWnd) then
       begin
        Result := True;
        break;
       end;
     end;
   tmpTask.Empty;
  finally
   FreeAndNil(tmpTask);
  end;
end;

function SharpEBroadCastEx(msg: integer; wpar: wparam; lpar: lparam): integer;
  function EnumChildWindowsProc(Wnd: hwnd; param: lParam): boolean; export; stdcall;
  begin
    Result := False;

    SendMessage(wnd, mess, wpara, lpara);

//    inc(i);
    result := true;
  end;
  function EnumWindowsProc(Wnd: hwnd; param: lParam): boolean; export; stdcall;
  begin
    Result := False;

    SendMessage(wnd, mess, wpara, lpara);

    EnumChildWindows(wnd, @EnumChildWindowsProc,mess);
//    inc(i);
    result := true;
  end;
begin
//  i := 0;
  mess := msg;
  wpara := wpar;
  lpara := lpar;
  EnumWindows(@EnumWindowsProc, msg);
//  result := i;
  Result := 0;
end;

end.
