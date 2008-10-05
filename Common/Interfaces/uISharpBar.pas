unit uISharpBar;

interface

uses
  Windows;

type
  ISharpBar = interface(IInterface)
    ['{C0FBFFCE-BAD4-468B-9687-2C0C7FD9F67C}']
    procedure UpdateModuleSize; stdcall;
    function GetModuleXMLFile(ModuleID : integer) : String; stdcall;

    function GetBarID : integer; stdcall;
    property BarID : integer read GetBarID;

    function GetBarWnd : hwnd; stdcall;
    property BarWnd : hwnd read GetBarWnd;
  end;

implementation

end.
