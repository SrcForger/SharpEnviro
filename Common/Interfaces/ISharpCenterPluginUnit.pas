unit ISharpCenterPluginUnit;

interface

uses
  Windows, SharpApi,SharpCenterApi, SharpETabList, Controls, Forms, Classes, GR32,
  ISharpCenterHostUnit;

const
  IID_ISharpCenterPluginEdit: TGUID = '{C7477868-4A58-4EDF-8D81-2C0B1732C116}';
  IID_ISharpCenterPluginValidation: TGUID = '{3E12792D-C1D9-4C58-B055-FFC4B1A72D3F}';
  IID_ISharpCenterPluginTabs: TGUID = '{1874CB85-3577-4CBD-9F73-EE464223E3FD}';
  IID_ISharpCenterPluginPreview: TGUID = '{C397A7F1-86D1-4E20-AD5C-EA52C51DC306}';
  IID_ISharpCenterPlugin: TGUID = '{F9E1BB12-4885-43FF-B4CB-56517F6F486D}';

type
  ISharpCenterPluginValidation = interface(IInterface)
  ['{3E12792D-C1D9-4C58-B055-FFC4B1A72D3F}']
    procedure SetupValidators; stdCall;
  end;

  ISharpCenterPluginPreview = interface(IInterface)
  ['{C397A7F1-86D1-4E20-AD5C-EA52C51DC306}']
    procedure UpdatePreview(ABitmap: TBitmap32); stdCall;
  end;

  ISharpCenterPluginEdit = interface(IInterface)
  ['{C7477868-4A58-4EDF-8D81-2C0B1732C116}']
    function OpenEdit: THandle; stdCall;
    procedure CloseEdit(AApply: Boolean); stdCall;
  end;

  ISharpCenterPluginTabs = interface(IInterface)
  ['{1874CB85-3577-4CBD-9F73-EE464223E3FD}']
    procedure ClickPluginTab(ATab: TStringItem); stdCall;
    procedure AddPluginTabs(ATabItems: TStringList); stdCall;
  end;

  ISharpCenterPlugin = interface(IInterface)
  ['{F9E1BB12-4885-43FF-B4CB-56517F6F486D}']
    // ISharpCenterPlugin
    function GetPluginHost : ISharpCenterHost; stdcall;
    procedure SetPluginHost(Value : ISharpCenterHost); stdcall;
    property PluginHost: ISharpCenterHost read GetPluginHost write SetPluginHost;

    function GetCanDestroy : boolean; stdcall;
    procedure SetCanDestroy(Value : boolean); stdcall;
    property CanDestroy: boolean read GetCanDestroy write SetCanDestroy;

    function Open : THandle; stdcall;
    procedure Close; stdcall;
    procedure Save; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing : Boolean); stdCall;

    function GetPluginName : string; stdcall;
    function GetPluginStatusText : string; stdcall;
    function GetPluginDescriptionText : string; stdcall;
  end;

  TInterfacedSharpCenterPlugin = class(TObject, ISharpCenterPlugin)
  private
    FRefCount: integer;
    FCanDestroy: boolean;
    FPluginHost: ISharpCenterHost;

    function GetPluginHost : ISharpCenterHost; stdcall;
    procedure SetPluginHost(Value : ISharpCenterHost); stdcall;

    function GetCanDestroy : boolean; stdcall;
    procedure SetCanDestroy(Value : boolean); stdcall;
    
  protected
    // IUnknown
    function _AddRef: Integer; virtual; stdcall;
    function _Release: Integer; virtual; stdcall;
    
  public
    constructor Create;
    destructor Destroy; override;

    // IUnknown
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;

    // ISharpCenterPlugin
    property PluginHost: ISharpCenterHost read GetPluginHost write SetPluginHost;
    property CanDestroy: boolean read FCanDestroy write FCanDestroy;

    function Open : THandle; virtual; stdcall;
    procedure Close; virtual; stdcall;
    procedure Save; virtual; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing : Boolean); virtual; stdCall;

    function GetPluginName : string; virtual; stdcall;
    function GetPluginStatusText : string; virtual; stdcall;
    function GetPluginDescriptionText : string; virtual; stdcall;
  end;




implementation

{ TInterfacedSharpCenterPlugin }

constructor TInterfacedSharpCenterPlugin.Create;
begin
  inherited;

  FRefCount := 0;
end;

destructor TInterfacedSharpCenterPlugin.Destroy;
begin
  FPluginHost := nil;
  
  inherited;
end;

function TInterfacedSharpCenterPlugin._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TInterfacedSharpCenterPlugin._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if (Result = 0) and (FCanDestroy) then
    Destroy;
end;

function TInterfacedSharpCenterPlugin.QueryInterface(const IID: TGUID; out Obj): HResult;
const
  E_NOINTERFACE = HResult($80004002);
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TInterfacedSharpCenterPlugin.GetCanDestroy : boolean;
begin
  Result := FCanDestroy;
end;
procedure TInterfacedSharpCenterPlugin.SetCanDestroy(Value : boolean);
begin
  FCanDestroy := Value;
end;

procedure TInterfacedSharpCenterPlugin.Close;
begin

end;

function TInterfacedSharpCenterPlugin.GetPluginDescriptionText: string;
begin
  Result := '';
end;

function TInterfacedSharpCenterPlugin.GetPluginHost: ISharpCenterHost;
begin
  Result := FPluginHost;
end;

function TInterfacedSharpCenterPlugin.GetPluginName: string;
begin
  Result := '';
end;

function TInterfacedSharpCenterPlugin.GetPluginStatusText: string;
begin
  Result := '';
end;

function TInterfacedSharpCenterPlugin.Open: THandle;
begin
  Result := 0;
end;

procedure TInterfacedSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing : Boolean);
begin

end;

procedure TInterfacedSharpCenterPlugin.Save;
begin

end;

procedure TInterfacedSharpCenterPlugin.SetPluginHost(Value: ISharpCenterHost);
begin
  FPluginHost := Value;
end;

end.
