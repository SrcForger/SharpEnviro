unit uSharpEMenuConsts;

interface

uses Classes, JclSysInfo, SysUtils, SharpApi;

type
  TSharpEMenuConsts = class
  private
    FConstList : TStringList;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function ParseString(pString : String) : String;
  end;

implementation

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
  FConstList.Add('{#AppDataDir#)='              + IncludeTrailingBackSlash(JclSysInfo.GetAppdataFolder));
  FConstList.Add('{#CommonAppDataDir#)='        + IncludeTrailingBackSlash(JclSysInfo.GetCommonAppdataFolder));
  {$WARNINGS ON}
end;

destructor TSharpEMenuConsts.Destroy;
begin
  FConstList.Free;
  inherited Destroy;
end;

function TSharpEMenuConsts.ParseString(pString : String) : String;
var
  n : integer;
  r : String;
begin
  r := pString;
  for n := 0 to FConstList.Count - 1 do
      r := StringReplace(r,FConstList.Names[n],FConstList.ValueFromIndex[n],[rfReplaceAll,rfIgnoreCase]);
  result := r;
end;


end.
