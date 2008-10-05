unit ISharpCenterPluginUnit;

interface

uses
  Windows, SharpApi,SharpCenterApi, SharpETabList, Controls, Forms, Classes, GR32,
  ISharpCenterHostUnit;

const
  IID_ISharpCenterPluginEdit: TGUID = '{C7477868-4A58-4EDF-8D81-2C0B1732C116}';
  IID_ISharpCenterPluginTabs: TGUID = '{1874CB85-3577-4CBD-9F73-EE464223E3FD}';
  IID_ISharpCenterPluginPreview: TGUID = '{C397A7F1-86D1-4E20-AD5C-EA52C51DC306}';
  IID_ISharpCenterPlugin: TGUID = '{F9E1BB12-4885-43FF-B4CB-56517F6F486D}';

type
  ISharpCenterPluginPreview = interface(IInterface)
  ['{C397A7F1-86D1-4E20-AD5C-EA52C51DC306}']

  procedure UpdatePreview( ABitmap: TBitmap32 ); stdCall;
  end;

  ISharpCenterPluginEdit = interface(IInterface)
  ['{C7477868-4A58-4EDF-8D81-2C0B1732C116}']

  function OpenEdit: THandle; stdCall;
  function CloseEdit(AApply:Boolean): boolean; stdCall;
  end;

  ISharpCenterPluginTabs = interface(IInterface)
  ['{1874CB85-3577-4CBD-9F73-EE464223E3FD}']

  procedure ClickPluginTab(ATab: TStringItem); stdCall;
  procedure AddPluginTabs(ATabItems: TStringList); stdCall;
  end;

  ISharpCenterPlugin = interface(IInterface)
  ['{F9E1BB12-4885-43FF-B4CB-56517F6F486D}']

  function GetPluginHost : TInterfacedSharpCenterHostBase; stdcall;
  procedure SetPluginHost(Value : TInterfacedSharpCenterHostBase); stdcall;
  property PluginHost: TInterfacedSharpCenterHostBase read GetPluginHost write SetPluginHost;

  function Open : THandle; stdcall;
  procedure Close; stdcall;
  procedure Save; stdcall;
  procedure Refresh; stdCall;

  function GetPluginName : string; stdcall;
  function GetPluginStatusText : string; stdcall;
  function GetPluginDescriptionText : string; stdcall;
  end;

  TInterfacedSharpCenterPlugin = class(TInterfacedObject, ISharpCenterPlugin)

  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    function GetPluginHost : TInterfacedSharpCenterHostBase; stdcall;
    procedure SetPluginHost(Value : TInterfacedSharpCenterHostBase); stdcall;

  public
    property PluginHost: TInterfacedSharpCenterHostBase read GetPluginHost write SetPluginHost;

    function Open : THandle; virtual; stdcall;
    procedure Close; virtual; stdcall;
    procedure Save; virtual; stdcall;
    procedure Refresh; virtual; stdCall;

    function GetPluginName : string; virtual; stdcall;
    function GetPluginStatusText : string; virtual; stdcall;
    function GetPluginDescriptionText : string; virtual; stdcall;
  end;




implementation

{ TInterfacedSharpCenterPlugin }

procedure TInterfacedSharpCenterPlugin.Close;
begin

end;

function TInterfacedSharpCenterPlugin.GetPluginDescriptionText: string;
begin

end;

function TInterfacedSharpCenterPlugin.GetPluginHost: TInterfacedSharpCenterHostBase;
begin
  Result := FPluginHost;
end;

function TInterfacedSharpCenterPlugin.GetPluginName: string;
begin

end;

function TInterfacedSharpCenterPlugin.GetPluginStatusText: string;
begin

end;

function TInterfacedSharpCenterPlugin.Open: THandle;
begin
  Result := 0;
end;

procedure TInterfacedSharpCenterPlugin.Refresh;
begin

end;

procedure TInterfacedSharpCenterPlugin.Save;
begin

end;

procedure TInterfacedSharpCenterPlugin.SetPluginHost(
  Value: TInterfacedSharpCenterHostBase);
begin
  FPluginHost := Value;
end;

end.
