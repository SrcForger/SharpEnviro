unit uInterfacedSharpBarModuleBase;

interface

uses
  Windows,
  SysUtils,
  Forms,
  Classes,
  Graphics,
  GR32,
  SharpApi,
  uISharpBarModule,
  uISharpBar,
  uISharpESkin;

type
  TInterfacedSharpBarModuleBase = class(TInterfacedObject,ISharpBarModule)
  private
    FInitialized : Boolean;
    FModuleName : String;
    FSkinInterface : ISharpESkinInterface;
    FBarInterface : ISharpBar;
    FID : integer;
    FForm : TForm;
    FMinSize : integer;
    FMaxSize : integer;
    FBackground : TBitmap32;
  public
    BarID : integer;
    BarWnd : hwnd;

    constructor Create(pID,pBarID : integer; pBarWnd : hwnd); reintroduce; virtual;
    destructor Destroy; override;

    property ModuleName : String read FModuleName write FModuleName;
    property Initialized : Boolean read FInitialized write FInitialized;

    // ISharpBarModule methods
    function CloseModule : HRESULT; virtual; stdcall;
    function Refresh : HRESULT; virtual; stdcall;
    function SetTopHeight(Top,Height : integer) : HRESULT; virtual; stdcall;
    function UpdateMessage(part : TSU_UPDATE_ENUM; param : integer) : HRESULT; virtual; stdcall;
    function InitModule : HRESULT; virtual; stdcall;
    function Loaded : HRESULT; virtual; stdcall;
    function ModuleMessage(msg: string) : HRESULT; virtual; stdcall;

    function GetSkinInterface : ISharpESkinInterface; stdcall;
    procedure SetSkinInterface(Value : ISharpESkinInterface); virtual; stdcall;
    property SkinInterface : ISharpESkinInterface read GetSkinInterface write SetSkinInterface;

    function GetBarInterface : ISharpBar; stdcall;
    procedure SetBarInterface(Value : ISharpBar); virtual; stdcall;
    property BarInterface : ISharpBar read GetBarInterface write SetBarInterface;

    function GetID : integer; stdcall;
    property ID : integer read GetID;

    function GetForm : TForm; stdcall;
    procedure SetForm(Value : TForm); stdcall;
    property Form : TForm read GetForm write SetForm;

    function GetLeft : integer; stdcall;
    procedure SetLeft(Value : integer); virtual; stdcall;
    property Left : integer read GetLeft write SetLeft;

    function GetSize : integer; stdcall;
    procedure SetSize(Value : integer); virtual; stdcall;
    property Size : integer read GetSize write SetSize;

    function GetMaxSize : integer; stdcall;
    procedure SetMaxSize(Value : integer); virtual; stdcall;
    property MaxSize : integer read GetMaxSize write SetMaxSize;

    function GetMinSize : integer; stdcall;
    procedure SetMinSize(Value : integer); virtual; stdcall;
    property MinSize : integer read GetMinSize write SetMinSize;

    function GetBackground : TBitmap32; stdcall;
    property Background : TBitmap32 read GetBackground;    
  end;

implementation

function TInterfacedSharpBarModuleBase.CloseModule : HRESULT;
begin
  try
    FForm.Free;
    FForm := nil;
    result := S_OK;
  except
    on E:Exception do
    begin
      result := E_FAIL;
      SharpApi.SendDebugMessageEx(PChar(FModuleName),PChar('Error in CloseModule('
        + inttostr(ID) + '):' + E.Message),clred,DMT_ERROR);
    end;
  end;
end;

constructor TInterfacedSharpBarModuleBase.Create(pID,pBarID : integer; pBarWnd : hwnd);
begin
  FModuleName := 'InterfaceSharpBarModule';
  FInitialized := False;
  FBackground := TBitmap32.Create;
  FForm := nil;

  FID := pID;
  BarID := pBarID;
  BarWnd := pBarWnd;
  MinSize := 100;
  MaxSize := 200;
end;

destructor TInterfacedSharpBarModuleBase.Destroy;
begin
  if Form <> nil then
    CloseModule;

  FBackground.Free;
  FBackground := nil;

  inherited;
end;

function TInterfacedSharpBarModuleBase.GetBackground: TBitmap32;
begin
  result := FBackground;
end;

function TInterfacedSharpBarModuleBase.GetBarInterface: ISharpBar;
begin
  result := FBarInterface;
end;

function TInterfacedSharpBarModuleBase.GetForm: TForm;
begin
  result := FForm;
end;

function TInterfacedSharpBarModuleBase.GetID: integer;
begin
  result := FID;
end;

function TInterfacedSharpBarModuleBase.GetLeft: integer;
begin
  result := FForm.Left;
end;

function TInterfacedSharpBarModuleBase.GetMaxSize: integer;
begin
  result := FMaxSize;
end;

function TInterfacedSharpBarModuleBase.GetMinSize: integer;
begin
  result := FMinSize;
end;

function TInterfacedSharpBarModuleBase.GetSize: integer;
begin
  if Form <> nil then
    result := Form.Width
  else result := 0;
end;

function TInterfacedSharpBarModuleBase.GetSkinInterface: ISharpESkinInterface;
begin
  result := FSkinInterface;
end;

function TInterfacedSharpBarModuleBase.InitModule : HRESULT;
begin
  FInitialized := True;
  result := S_OK;
end;

function TInterfacedSharpBarModuleBase.Loaded : HRESULT;
begin
  Result := S_OK;
end;

function TInterfacedSharpBarModuleBase.ModuleMessage(msg: string) : HRESULT;
begin
  result := S_OK;
end;

function TInterfacedSharpBarModuleBase.Refresh : HRESULT;
begin
  result := S_OK;
  if FForm <> nil then
    FForm.Repaint;
end;

procedure TInterfacedSharpBarModuleBase.SetBarInterface(Value: ISharpBar);
begin
  FBarInterface := Value;
end;

procedure TInterfacedSharpBarModuleBase.SetForm(Value: TForm);
begin
  FForm := Value;
end;

procedure TInterfacedSharpBarModuleBase.SetLeft(Value: integer);
begin
  if FForm <> nil then
  begin
    FForm.Left := Value;
  end;
end;

procedure TInterfacedSharpBarModuleBase.SetMaxSize(Value: integer);
begin
  FMaxSize := Value;
end;

procedure TInterfacedSharpBarModuleBase.SetMinSize(Value: integer);
begin
  FMinSize := Value;
end;

procedure TInterfacedSharpBarModuleBase.SetSize(Value : integer);
begin
  if Form <> nil then
  begin
    Form.Width := Value;
  end;
end;

procedure TInterfacedSharpBarModuleBase.SetSkinInterface(Value: ISharpESkinInterface);
begin
  FSkinInterface := Value;
end;

function TInterfacedSharpBarModuleBase.SetTopHeight(Top, Height: integer): HRESULT;
begin
  if FForm <> nil then
  begin
    FForm.Top := Top;
    FForm.Height := Height;
    result := S_OK;
  end else result := S_FALSE;
end;

function TInterfacedSharpBarModuleBase.UpdateMessage(part: TSU_UPDATE_ENUM;
  param: integer): HRESULT;
const
  processed : TSU_UPDATES = [];
begin
  result := S_OK;

  if not (part in processed) then
    exit;
end;

end.
