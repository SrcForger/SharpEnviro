unit uISharpBarModule;

interface

uses
  Windows, SharpApi, Forms, GR32,
  uISharpESkin, uISharpBar;


const
  IID_ISharpBarModule : TGUID = '{94D9277E-7285-44EC-8284-7FD736D55A07}';
  IID_ISharpBarModuleAdv : TGUID = '{C7FBE839-5D9E-4CA0-A908-80A36A4EBFD6}';

type
  ISharpBarModule = interface(IInterface)
    ['{94D9277E-7285-44EC-8284-7FD736D55A07}']
    function CloseModule : HRESULT; stdcall;
    function Refresh : HRESULT; stdcall;
    function SetTopHeight(Top,Height : integer) : HRESULT; stdcall;
    function UpdateMessage(part : TSU_UPDATE_ENUM; param : integer) : HRESULT; stdcall;
    function InitModule : HRESULT; stdcall;
    function ModuleMessage(msg: string) : HRESULT; stdcall;    

    function GetSkinInterface : ISharpESkin; stdcall;
    procedure SetSkinInterface(Value : ISharpESkin); stdcall;
    property SkinInterface : ISharpESkin read GetSkinInterface write SetSkinInterface;

    function GetBarInterface : ISharpBar; stdcall;
    procedure SetBarInterface(Value : ISharpBar); stdcall;
    property BarInterface : ISharpBar read GetBarInterface write SetBarInterface;

    function GetID : integer; stdcall;
    property ID : integer read GetID;

    function GetForm : TForm; stdcall;
    property Form : TForm read GetForm;

    function GetLeft : integer; stdcall;
    procedure SetLeft(Value : integer); stdcall;
    property Left : integer read GetLeft write SetLeft;

    function GetSize : integer; stdcall;
    procedure SetSize(Value : integer); stdcall;
    property Size : integer read GetSize write SetSize;

    function GetMaxSize : integer; stdcall;
    procedure SetMaxSize(Value : integer); stdcall;
    property MaxSize : integer read GetMaxSize write SetMaxSize;

    function GetMinSize : integer; stdcall;
    procedure SetMinSize(Value : integer); stdcall;
    property MinSize : integer read GetMinSize write SetMinSize;

    function GetBackground : TBitmap32; stdcall;
    property Background : TBitmap32 read GetBackground;
  end;

implementation

end.
