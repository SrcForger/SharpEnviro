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

    InitPluginInterface: function ( APluginHost: TInterfacedSharpCenterHostBase ) : ISharpCenterPlugin;
  end;
  PPlugin = ^TPlugin;

function LoadPluginInterface(dll: Pchar): TPlugin;
function UnloadPluginInterface(plugin: PPlugin): hresult;

implementation

uses
  uSharpCenterManager;

function UnloadPluginInterface(plugin: PPlugin): hresult;
begin
  result := 0;
  try
    plugin.PluginInterface := nil;
    plugin.EditInterface := nil;
    plugin.ValidationInterface := nil;
    plugin.PreviewInterface := nil;
    plugin.TabInterface := nil;
    plugin.InitPluginInterface := nil;

    plugin.DllHandle := 0;
    FreeLibrary(plugin.dllhandle);
    result := MR_OK;
  except
    SendDebugMessageEx('SharpCenter','UnloadPluginInterface failed',clRed,DMT_ERROR);
  end;
end;

function LoadPluginInterface(dll: Pchar): TPlugin;
begin
    result.Dll := dll;

    GetConfigMetaData(Dll,Result.MetaData,Result.ConfigMode,Result.ConfigType);
    if Result.MetaData.Version <> scm.PluginVersion  then begin
       result.DllHandle := 0;
    end else begin

    result.dllhandle := LoadLibrary(dll);
    if result.dllhandle <> 0 then begin

      @result.InitPluginInterface := GetProcAddress(result.Dllhandle, 'InitPluginInterface');

      if (@result.InitPluginInterface = nil) then begin
        freelibrary(result.dllhandle);
        result.dllhandle := 0;
        SendDebugMessageEx('SharpCenter','Unable to load plugin, InitPluginInterface does not exist',clRed,DMT_ERROR);
      end;
    end;
    end;
end;

end.
