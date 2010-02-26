unit uSharpCenterPluginManager;

interface

uses
  Windows,
  dialogs,
  shellapi,
  graphics,
  Classes,
  forms,
  sharpapi,
  GR32,
  SharpCenterApi,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TPlugin = record
    Dll: string;
    Dllhandle: Thandle;
    ConfigType: TSU_UPDATE_ENUM;
    ConfigMode: TSC_MODE_ENUM;
    MetaData: TMetaData;

    PluginInterface: ISharpCenterPlugin;
    EditInterface: ISharpCenterPluginEdit;
    ValidationInterface: ISharpCenterPluginValidation;
    PreviewInterface: ISharpCenterPluginPreview;
    TabInterface: ISharpCenterPluginTabs;

    InitPluginInterface: function (APluginHost: ISharpCenterHost) : ISharpCenterPlugin;
  end;
  PPlugin = ^TPlugin;

function LoadPluginInterface(dll: Pchar; var pluginHost: TInterfacedSharpCenterHostBase): TPlugin;
function UnloadPluginInterface(var plugin: TPlugin; var pluginHost: TInterfacedSharpCenterHostBase): hresult;

implementation

uses
  uSharpCenterManager;

function UnloadPluginInterface(var plugin: TPlugin; var pluginHost: TInterfacedSharpCenterHostBase): hresult;
begin
  result := 0;

  if plugin.DllHandle = 0 then
    exit;
    
  try
    if Assigned(plugin.EditInterface) then
      plugin.EditInterface := nil;
    if Assigned(plugin.ValidationInterface) then
      plugin.ValidationInterface := nil;
    if Assigned(plugin.PreviewInterface) then
      plugin.PreviewInterface := nil;
    if Assigned(plugin.TabInterface) then
      plugin.TabInterface := nil;
    if Assigned(plugin.InitPluginInterface) then
      plugin.InitPluginInterface := nil;
    if Assigned(plugin.PluginInterface) then
    begin
      plugin.PluginInterface.CanDestroy := true;
      plugin.PluginInterface := nil;
    end;

    // Unload the XML interface
    pluginHost.UnloadXml;

    FreeLibrary(plugin.dllhandle);
    plugin.DllHandle := 0;

    result := MR_OK;
  except
    SendDebugMessageEx('SharpCenter','UnloadPluginInterface failed',clRed,DMT_ERROR);
  end;
end;

function LoadPluginInterface(dll: Pchar; var pluginHost: TInterfacedSharpCenterHostBase): TPlugin;
begin
  result.Dll := dll;

  GetConfigMetaData(Dll,Result.MetaData,Result.ConfigMode,Result.ConfigType);
  if Result.MetaData.Version <> scm.PluginVersion  then begin
    result.DllHandle := 0;
  end else
  begin
    // Load the XML interface
    pluginHost.LoadXml;

    result.dllhandle := LoadLibrary(dll);
    if result.dllhandle <> 0 then begin
      @result.InitPluginInterface := GetProcAddress(result.Dllhandle, 'InitPluginInterface');
      
      if (@result.InitPluginInterface = nil) then
      begin
        FreeLibrary(result.dllhandle);
        result.dllhandle := 0;
        SendDebugMessageEx('SharpCenter','Unable to load plugin, InitPluginInterface does not exist',clRed,DMT_ERROR);
      end;
    end;
  end;
end;

end.
