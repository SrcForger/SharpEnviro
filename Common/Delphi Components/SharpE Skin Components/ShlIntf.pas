
(********************************************************)
(*                                                      *)
(*      Object Modeler Class Library                    *)
(*                                                      *)
(*      Open Source Released 2000                       *)
(*                                                      *)
(********************************************************)

unit ShlIntf;

interface

uses
  Windows;

const
// Class IDs
  {$EXTERNALSYM CLSID_AutoComplete}
  CLSID_AutoComplete: TGUID = (
    D1:$00BB2763; D2:$6A77; D3:$11D0; D4:($A5,$35,$00,$C0,$4F,$D7,$D0,$62));
  {$EXTERNALSYM CLSID_ACLHistory}
  CLSID_ACLHistory: TGUID = (
    D1:$00BB2764; D2:$6A77; D3:$11D0; D4:($A5,$35,$00,$C0,$4F,$D7,$D0,$62));
  {$EXTERNALSYM CLSID_ACListISF}
  CLSID_ACListISF: TGUID = (
    D1:$03C036F1; D2:$A186; D3:$11D0; D4:($82,$4A,$00,$AA,$00,$5B,$43,$83));
  {$EXTERNALSYM CLSID_ACLMRU}
  CLSID_ACLMRU: TGUID = (
    D1:$6756A641; D2:$DE71; D3:$11D0; D4:($83,$1B,$00,$AA,$00,$5B,$43,$83));
  {$EXTERNALSYM CLSID_ACLMulti}
  CLSID_ACLMulti: TGUID = (
    D1:$00BB2765; D2:$6A77; D3:$11D0; D4:($A5,$35,$00,$C0,$4F,$D7,$D0,$62));

// Interface IDs
  {$EXTERNALSYM IID_IAutoComplete}
  IID_IAutoComplete: TGUID = (
    D1:$00BB2762; D2:$6A77; D3:$11D0; D4:($A5,$35,$00,$C0,$4F,$D7,$D0,$62));
  {$EXTERNALSYM IID_IAutoComplete2}
  IID_IAutoComplete2: TGUID = (
    D1:$EAC04BC0; D2:$3791; D3:$11D2; D4:($BB,$95,$00,$60,$97,$7B,$46,$4C));
  {$EXTERNALSYM IID_IAutoCompList}
  IID_IAutoCompList: TGUID = (
    D1:$00BB2760; D2:$6A77; D3:$11D0; D4:($A5,$35,$00,$C0,$4F,$D7,$D0,$62));
  {$EXTERNALSYM IID_IACList}
  IID_IACList: TGUID = (
    D1:$77A130B0; D2:$94FD; D3:$11D0; D4:($A5,$44,$00,$C0,$4F,$D7,$d0,$62));
  {$EXTERNALSYM IID_IACList2}
  IID_IACList2: TGUID = (
    D1:$470141A0; D2:$5186; D3:$11D2; D4:($BB,$B6,$00,$60,$97,$7B,$46,$4C));
  {$EXTERNALSYM IID_ICurrentWorkingDirectory}
  IID_ICurrentWorkingDirectory: TGUID = (
    D1:$91956D21; D2:$9276; D3:$11D1; D4:($92,$1A,$00,$60,$97,$DF,$5B,$D4));
  {$EXTERNALSYM IID_IObjMgr}
  IID_IObjMgr: TGUID = (
    D1:$00BB2761; D2:$6A77; D3:$11D0; D4:($A5,$35,$00,$C0,$4F,$D7,$D0,$62));

// String constants for Interface IDs
  SID_IAutoComplete            = '{00BB2762-6A77-11D0-A535-00C04FD7D062}';
  SID_IAutoComplete2           = '{EAC04BC0-3791-11D2-BB95-0060977B464C}';
  SID_IACList                  = '{77A130B0-94FD-11D0-A544-00C04FD7d062}';
  SID_IACList2                 = '{470141A0-5186-11D2-BBB6-0060977B464C}';
  SID_ICurrentWorkingDirectory = '{91956D21-9276-11D1-921A-006097DF5BD4}';
  SID_IObjMgr                  = '{00BB2761-6A77-11D0-A535-00C04FD7D062}';

type
  {$EXTERNALSYM IAutoComplete}
  IAutoComplete = interface(IUnknown)
    [SID_IAutoComplete]
    function Init(hwndEdit: HWND; punkACL: IUnknown; pwszRegKeyPath: PWideChar;
      pwszQuickComplete: PWideChar): HResult; stdcall;
    function Enable(fEnable: Boolean): HResult; stdcall;
   end;

const
  {$EXTERNALSYM ACO_NONE}
  ACO_NONE               = $0000;
  {$EXTERNALSYM ACO_AUTOSUGGEST}
  ACO_AUTOSUGGEST        = $0001;
  {$EXTERNALSYM ACO_AUTOAPPEND}
  ACO_AUTOAPPEND         = $0002;
  {$EXTERNALSYM ACO_SEARCH}
  ACO_SEARCH             = $0004;
  {$EXTERNALSYM ACO_FILTERPREFIXES}
  ACO_FILTERPREFIXES     = $0008;
  {$EXTERNALSYM ACO_USETAB}
  ACO_USETAB             = $0010;
  {$EXTERNALSYM ACO_UPDOWNKEYDROPSLIST}
  ACO_UPDOWNKEYDROPSLIST = $0020;
  {$EXTERNALSYM ACO_RTLREADING}
  ACO_RTLREADING         = $0040;

type
  {$EXTERNALSYM IAutoComplete2}
  IAutoComplete2 = interface(IAutoComplete)
    [SID_IAutoComplete2]
    function SetOptions(dwFlag: DWORD): HResult; stdcall;
    function GetOptions(out dwFlag: DWORD): HResult; stdcall;
  end;

  {$EXTERNALSYM IACList}
  IACList = interface(IUnknown)
    [SID_IACList]
    function Expand(pszExpand: PWideChar): HResult; stdcall;
  end;

const
  ACLO_NONE            = 0;    // don't enumerate anything
  ACLO_CURRENTDIR      = 1;    // enumerate current directory
  ACLO_MYCOMPUTER      = 2;    // enumerate MyComputer
  ACLO_DESKTOP         = 4;    // enumerate Desktop Folder
  ACLO_FAVORITES       = 8;    // enumerate Favorites Folder
  ACLO_FILESYSONLY     = 16;   // enumerate only the file system

type
  {$EXTERNALSYM IACList2}
  IACList2 = interface(IACList)
    [SID_IACList2]
    function SetOptions(dwFlag: DWORD): HResult; stdcall;
    function GetOptions(out pdwFlag: DWORD): HResult; stdcall;
  end;

  {$EXTERNALSYM IID_ICurrentWorkingDirectory}
  ICurrentWorkingDirectory = interface(IUnknown)
    [SID_ICurrentWorkingDirectory]
    function GetDirectory(pwzPath: PWideChar; cchSize: DWORD): HResult; stdcall;
    function SetDirectory(pwzPath: PWideChar): HResult; stdcall;
  end;

  {$EXTERNALSYM IObjMgr}
  IObjMgr = interface(IUnknown)
    [SID_IObjMgr]
    function Append(punk: IUnknown): HResult; stdcall;
    function Remove(punk: IUnknown): HResult; stdcall;
  end;

implementation

end.
