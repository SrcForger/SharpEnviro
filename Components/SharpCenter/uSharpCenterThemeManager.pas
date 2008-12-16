unit uSharpCenterThemeManager;

interface

uses
  Windows,
  dialogs,
  shellapi,
  graphics,
  Classes,
  SysUtils,
  sharpapi,
  GR32,
  SharpCenterAPI, JclSimpleXml;

type
  TCenterThemeManager = Class(TList)
    private
    FTheme: TCenterThemeInfo;
    public
      procedure GetTheme;
      procedure Load;
      procedure Save;
      procedure Refresh;

      property Theme: TCenterThemeInfo read FTheme write FTheme;
  End;

implementation

{ TCenterSchemeList }


procedure TCenterThemeManager.GetTheme;
begin

end;

procedure TCenterThemeManager.Load;
var
  xml:TJclSimpleXml;
  path: string;
  cThemes: TCenterThemeInfoSet;
  tmpCTheme: TCenterThemeInfo;
  i: Integer;
begin
  xml := TJclSimpleXML.Create;
  try
    // Create dir
    path := GetSharpeGlobalSettingsPath + 'SharpCenter\' + 'Schemes\';
    if Not(DirectoryExists(path)) then ForceDirectories(path);

    Setlength(cThemes,0);
    XmlGetCenterThemeList(cThemes);

    for i := 0 to high(cthemes) do begin
      tmpCTheme := cthemes[i];
    end;

  finally
    xml.Free;
  end;
end;

procedure TCenterThemeManager.Refresh;
begin
  XmlGetCenterTheme( XmlGetCenterTheme, FTheme );
end;

procedure TCenterThemeManager.Save;
begin

end;

end.
