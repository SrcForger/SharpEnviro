unit SharpThemeApiEx;

interface

uses
  uISharpETheme,
  uIThemeList;

function GetCurrentTheme : ISharpETheme; external 'SharpThemeApiEx.dll';
function GetThemeList : IThemeList; external 'SharpThemeApiEx.dll';
function GetTheme(pName : String) : ISharpETheme; external 'SharpThemeApiEx.dll';

implementation

end.
