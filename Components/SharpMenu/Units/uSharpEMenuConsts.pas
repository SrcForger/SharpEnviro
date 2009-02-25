unit uSharpEMenuConsts;

interface

uses Classes, ShellApi, Forms, ShlObj, ActiveX, ComObj, Messages,Windows, JclSysInfo, JclShell, JclFileUtils, SysUtils, SharpApi;

type
  TSharpEMenuConsts = class
  private
    FConstList : TStringList;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function ParseString(pString : String) : String;
    function GetGenericIcon(pSource : String) : String;
  end;

implementation

uses
  uSharpEMenu,
  uSharpEMenuIcons;

constructor TSharpEMenuConsts.Create;
begin
  inherited Create;
  FConstList := TStringList.Create;
  FConstList.Clear;
  {$WARNINGS OFF}
  FConstList.Add('{#SharpEDir#}='               + SharpApi.GetSharpeDirectory);
  FConstList.Add('{#SharpEUserSettingsDir#}='   + SharpApi.GetSharpeUserSettingsPath);
  FConstList.Add('{#SharpEGlobalSettingsDir#}=' + SharpApi.GetSharpeGlobalSettingsPath);
  FConstList.Add('{#WindowsDir#}='              + IncludeTrailingBackSlash(JclSysInfo.GetWindowsFolder));
  FConstList.Add('{#System32Dir#}='             + IncludeTrailingBackSlash(JclSysInfo.GetWindowsSystemFolder));
  FConstList.Add('{#TempDir#}='                 + IncludeTrailingBackSlash(JclSysInfo.GetWindowsTempFolder));
  FConstList.Add('{#StartMenuDir#}='            + IncludeTrailingBackSlash(JclSysInfo.GetStartmenuFolder));
  FConstList.Add('{#CommonStartMenuDir#}='      + IncludeTrailingBackSlash(JclSysInfo.GetCommonStartmenuFolder));
  FConstList.Add('{#DesktopDir#}='              + IncludeTrailingBackSlash(JclSysInfo.GetDesktopDirectoryFolder));
  FConstList.Add('{#CommonDesktopDir#}='        + IncludeTrailingBackSlash(JclSysInfo.GetCommonDesktopDirectoryFolder));
  FConstList.Add('{#MyDocumentsDir#}='          + IncludeTrailingBackSlash(JclSysInfo.GetPersonalFolder));
  FConstList.Add('{#ProgramFilesDir#}='         + IncludeTrailingBackSlash(JclSysInfo.GetProgramFilesFolder));
  FConstList.Add('{#AppDataDir#}='              + IncludeTrailingBackSlash(JclSysInfo.GetAppdataFolder));
  FConstList.Add('{#CommonAppDataDir#}='        + IncludeTrailingBackSlash(JclSysInfo.GetCommonAppdataFolder));
  {$WARNINGS ON}
end;

destructor TSharpEMenuConsts.Destroy;
begin
  FConstList.Free;
  inherited Destroy;
end;

function TSharpEMenuConsts.GetGenericIcon(pSource: String): String;
type
  TShellLinkInfo = record
    Error: Boolean;
    lnkFileName: String;
    Description: String;
    FileName: String;
    WorkingDirectory: String;
    Arguments: String;
    WindowState: TWindowState;
    HotKey: TShortCut;
    IconFileName: String;
    IconIndex: Integer;
  end;

  // source http://forum.delphi-treff.de/showthread.php?t=20831
  function GetShellLinkInfo(lnkFileName: String): TShellLinkInfo;
  var
    HRes: HResult;
    Link: IShellLink;
    PerFile: IPersistFile;
    Buffer: array[0..255] of Char;
    IntBuffer: Integer;
    WordBuffer: Word;
    Size: Integer;
    W: PWideChar;
    Data: TWin32FindData;
  begin
    Result.Error := False;

    Size := (Length(lnkFileName) +1) *SizeOf(WideChar);
    GetMem(W, Size);
    StringToWideChar(lnkFileName, W, Size);

    CoInitialize(nil);
    HRes := CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER, IShellLink, Link);
    if not Succeeded(HRes) then Result.Error := True;

    HRes := Link.QueryInterface(IPersistFile, PerFile);
    if not Succeeded(HRes) then Result.Error := True;

    HRes := PerFile.Load(W, STGM_READ);
    if not Succeeded(HRes) then Result.Error := True;

    Result.lnkFileName := lnkFileName;

    //Beschreibung

    Link.GetDescription(@Buffer, MAX_PATH -5);
    Result.Description := StrPas(Buffer);

    //Ziel

    Link.GetPath(@Buffer, MAX_PATH -5, Data, SLGP_UNCPRIORITY);
    Result.FileName := StrPas(Buffer);

    //Arbeitsverzeichnis

    Link.GetWorkingDirectory(@Buffer, MAX_PATH -5);
    Result.WorkingDirectory := StrPas(Buffer);

    //Argumente

    Link.GetArguments(@Buffer, MAX_PATH -5);
    Result.Arguments := StrPas(Buffer);

    //FensterStatus

    Link.GetShowCmd(IntBuffer); //SW_SHOWNORMAL, SW_SHOWMINNOACTIVE, SW_SHOWMAXIMIZED

    case IntBuffer of
      SW_SHOWNORMAL: Result.WindowState := wsNormal;
      SW_SHOWMINNOACTIVE: Result.WindowState := wsMinimized;
      SW_SHOWMAXIMIZED: Result.WindowState := wsMaximized;
    else
      Result.WindowState := wsNormal;
    end;

    //HotKey

    Link.GetHotkey(WordBuffer);
    Result.HotKey := WordBuffer;  // haut nicht ganz hin, übernimmt nicht die modifiers


    //Icon

    Link.GetIconLocation(@Buffer, MAX_PATH -5, IntBuffer);
    Result.IconFileName := StrPas(Buffer);
    Result.IconIndex := IntBuffer;

    CoUninitialize;
    FreeMem(W, Size);
  end;

var
  Ext : String;
  link: TShellLinkInfo;
begin
  {$WARNINGS OFF}
  if isDirectory(ExcludeTrailingBackSlash(pSource)) or isDirectory(IncludeTrailingBackSlash(pSource)) then
    result := 'generic.folder'
  else
  begin
    Ext := ExtractFileExt(pSource);
    if (CompareText(Ext,'.lnk') = 0) then
    begin
      link := GetShellLinkInfo(pSource);
      Ext := ExtractFileExt(link.FileName);
    end;
    if isDirectory(ExcludeTrailingBackSlash(pSource)) or isDirectory(IncludeTrailingBackSlash(pSource)) then
    begin
      result := 'generic.folder';
      exit;
    end;

    if SharpEMenuIcons.FindGenericIcon('generic' + Ext) then
    begin
      result := 'generic' + Ext;
      exit;
    end;
    
    if (CompareText(Ext,'.exe') = 0) or (CompareText(Ext,'.bat') = 0)
      or (CompareText(Ext,'.com') = 0) then
      result := 'generic.application'
    else if (CompareText(Ext,'.html') = 0) or (CompareText(Ext,'.htm') = 0)
      or (CompareText(Ext,'.url') = 0) or (CompareText(Ext,'.php') = 0)
      or (CompareText(Ext,'.xml') = 0)  then
      result := 'generic.url'
    else if (CompareText(Ext,'.mp3') = 0) or (CompareText(Ext,'.wav') = 0)
      or (CompareText(Ext,'.xmi') = 0) or (CompareText(Ext,'.midi') = 0)
      or (CompareText(Ext,'.ogg') = 0) or (CompareText(Ext,'.wma') = 0) then
      result := 'generic.music'
    else if (CompareText(Ext,'.jpg') = 0) or (CompareText(Ext,'.jpeg') = 0)
      or (CompareText(Ext,'.bmp') = 0) or (CompareText(Ext,'.png') = 0)
      or (CompareText(Ext,'.gif') = 0) or (CompareText(Ext,'.nef') = 0) then
      result := 'generic.image'
    else if (CompareText(Ext,'.avi') = 0) or (CompareText(Ext,'.mov') = 0)
      or (CompareText(Ext,'.mpg') = 0) or (CompareText(Ext,'.mpeg') = 0)
      or (CompareText(Ext,'.wmv') = 0) or (CompareText(Ext,'.rm') = 0) then
      result := 'generic.movie'
    else result := 'generic.file';
  end
  {$WARNINGS ON}
end;

function TSharpEMenuConsts.ParseString(pString : String) : String;
var
  n : integer;
  r : String;
begin
  r := pString;
  for n := 0 to FConstList.Count - 1 do
    r := StringReplace(r,FConstList.Names[n],FConstList.ValueFromIndex[n],[rfReplaceAll,rfIgnoreCase]);
  if length(pString) > 1 then
  begin
    if (pString[1] <> '\') and (pString[2] <> '\') then
      r := StringReplace(r,'\\','\',[rfReplaceAll,rfIgnoreCase])
    else r := '\' + StringReplace(r,'\\','\',[rfReplaceAll,rfIgnoreCase]);
  end;
  result := r;
end;


end.
