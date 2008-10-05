unit ISharpCenterHostUnit;

interface

uses
  Windows, SharpApi,SharpCenterApi, SharpETabList, Controls, Forms, Classes, GR32,
  uVistaFuncs, SysUtils, jclSimpleXml;

const
  IID_ISharpCenterHost: TGUID = '{2277C19F-F87B-4CED-9ADA-8C3467426066}';

type
  ISharpCenterHost = interface(IInterface)
  ['{2277C19F-F87B-4CED-9ADA-8C3467426066}']

  function GetEditOwner : TWinControl; stdcall;
  procedure SetEditOwner(Value : TWinControl); stdcall;
  property EditOwner : TWinControl read GetEditOwner write SetEditOwner;

  function GetPluginOwner : TWinControl; stdcall;
  procedure SetPluginOwner(Value : TWinControl); stdcall;
  property PluginOwner : TWinControl read GetPluginOwner write SetPluginOwner;

  function GetPluginId : string; stdcall;
  procedure SetPluginId(Value : string); stdcall;
  property PluginId : string read GetPluginId write SetPluginId;

  function GetTheme : TCenterThemeInfo; stdcall;
  procedure SetTheme(Value : TCenterThemeInfo); stdcall;
  property Theme: TCenterThemeInfo read GetTheme write SetTheme;

  function GetEditMode : TSCE_EDITMODE_ENUM; stdcall;
  procedure SetEditMode(Value : TSCE_EDITMODE_ENUM); stdcall;
  property EditMode: TSCE_EDITMODE_ENUM read GetEditMode write
    SetEditMode;

  function GetEditing : Boolean; stdcall;
  procedure SetEditing(Value : Boolean); stdcall;
  property Editing: Boolean read GetEditing write SetEditing;

  procedure RefreshTheme; stdcall;
  function Open(AForm: TForm) : THandle; stdcall;
  function OpenEdit(AForm: TForm):THandle; stdCall;

  procedure SetSettingsChanged; stdCall;
end;

type
  TInterfacedSharpCenterHostBase = class(TInterfacedObject,ISharpCenterHost)

    private
      FEditOwner: TWinControl;
      FPluginOwner: TWinControl;
      FPluginId: string;
      FTheme: TCenterThemeInfo;
      FEditMode: TSCE_EDITMODE_ENUM;
      FEditing: Boolean;
      FXml: TJclSimpleXML;
    FOnSettingsChanged: TNotifyEvent;
      function GetEditOwner : TWinControl; stdCall;
      procedure SetEditOwner(Value : TWinControl); stdCall;
      function GetPluginOwner : TWinControl; stdCall;
      procedure SetPluginOwner(Value : TWinControl); stdCall;
      function GetPluginId : string; stdCall;
      procedure SetPluginId(Value : string); stdCall;
      
      procedure SetTheme(Value : TCenterThemeInfo); stdCall;
      function GetEditMode : TSCE_EDITMODE_ENUM; stdCall;
      procedure SetEditMode(Value : TSCE_EDITMODE_ENUM); stdCall;
      function GetEditing : Boolean; stdCall;
      procedure SetEditing(Value : Boolean); stdCall;
    function GetXml: TJclSimpleXML;
    public
      constructor Create;
      destructor Destroy; override;
      function GetTheme : TCenterThemeInfo; virtual; stdCall;

      property EditOwner : TWinControl read GetEditOwner write SetEditOwner;
      property PluginOwner : TWinControl read GetPluginOwner write SetPluginOwner;
      property PluginId : string read GetPluginId write SetPluginId;
      property Theme: TCenterThemeInfo read GetTheme write SetTheme;
      property EditMode: TSCE_EDITMODE_ENUM read GetEditMode write
        SetEditMode;
      property Editing: Boolean read GetEditing write SetEditing;
      property Xml: TJclSimpleXML read GetXml;

      procedure RefreshTheme; virtual; stdCall;
      function Open(AForm: TForm) : THandle; stdcall;
      function OpenEdit(AForm: TForm):THandle; stdCall;

      property OnSettingsChanged: TNotifyEvent read FOnSettingsChanged write
        FOnSettingsChanged;

      procedure SetSettingsChanged; stdCall;
    end;

implementation

{ TInterfacedSharpCenterHostBase }

constructor TInterfacedSharpCenterHostBase.Create;
begin
  FXml := TJclSimpleXML.Create;
end;

destructor TInterfacedSharpCenterHostBase.Destroy;
begin
  FXml.Free;
end;

function TInterfacedSharpCenterHostBase.GetEditing: Boolean;
begin
  Result := FEditing;
end;

function TInterfacedSharpCenterHostBase.GetEditMode: TSCE_EDITMODE_ENUM;
begin
  Result := FEditMode;
end;

function TInterfacedSharpCenterHostBase.GetEditOwner: TWinControl;
begin
  Result := FEditOwner;
end;

function TInterfacedSharpCenterHostBase.GetPluginId: string;
begin
  Result := FPluginId;
end;

function TInterfacedSharpCenterHostBase.GetPluginOwner: TWinControl;
begin
  Result := FPluginOwner;
end;

function TInterfacedSharpCenterHostBase.GetTheme: TCenterThemeInfo;
begin
  Result := FTheme;
end;

function TInterfacedSharpCenterHostBase.GetXml: TJclSimpleXML;
begin
  result :=  FXml;
end;

function TInterfacedSharpCenterHostBase.Open(AForm: TForm): THandle;
begin
  AForm.ParentWindow := FPluginOwner.Handle;
  AForm.Left := 0;
  AForm.Top := 0;
  AForm.Show;
  result := AForm.Handle;
end;

function TInterfacedSharpCenterHostBase.OpenEdit(AForm: TForm): THandle;
begin
  AForm.ParentWindow := FEditOwner.Handle;
  AForm.Left := 0;
  AForm.Top := 0;
  AForm.Show;
  result := AForm.Handle;
end;

procedure TInterfacedSharpCenterHostBase.RefreshTheme;
begin

end;

procedure TInterfacedSharpCenterHostBase.SetEditing(Value: Boolean);
begin
  FEditing := Value;
end;

procedure TInterfacedSharpCenterHostBase.SetEditMode(Value: TSCE_EDITMODE_ENUM);
begin
  FEditMode := Value;
end;

procedure TInterfacedSharpCenterHostBase.SetEditOwner(Value: TWinControl);
begin
  FEditOwner := Value;
end;

procedure TInterfacedSharpCenterHostBase.SetPluginId(Value: string);
begin
  FPluginId := Value;
end;

procedure TInterfacedSharpCenterHostBase.SetPluginOwner(Value: TWinControl);
begin
  FPluginOwner := Value;
end;

procedure TInterfacedSharpCenterHostBase.SetSettingsChanged;
begin
  if assigned(FOnSettingsChanged) then
    FOnSettingsChanged(Self);
end;

procedure TInterfacedSharpCenterHostBase.SetTheme(Value: TCenterThemeInfo);
begin
  FTheme := Value;
end;

end.
