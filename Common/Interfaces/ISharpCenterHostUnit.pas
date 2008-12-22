unit ISharpCenterHostUnit;

interface

uses
  Windows, SharpApi,SharpCenterApi, SharpETabList, Controls, Forms, Graphics, Classes, GR32,
  uVistaFuncs, SysUtils, jclSimpleXml, JvValidators, JvErrorIndicator, IXmlBaseUnit;

const
  IID_ISharpCenterHost: TGUID = '{2277C19F-F87B-4CED-9ADA-8C3467426066}';

type
  TRefreshTypeEnum = ( rtAll, rtSize, rtPreview, rtTabs, rtTheme, rtTitle, rtStatus, rtDescription );

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

  function GetWarning : Boolean; stdcall;
  procedure SetWarning(Value : Boolean); stdcall;
  property Warning: Boolean read GetWarning write SetWarning;

  procedure Refresh( ARefreshType: TRefreshTypeEnum = rtAll ); stdCall;

  function Open(AForm: TForm) : THandle; stdcall;
  function OpenEdit(AForm: TForm):THandle; stdCall;
  procedure Save; stdCall;

  procedure SetSettingsChanged; stdCall;

  procedure SetEditTab( ATab: TSCB_BUTTON_ENUM ); stdCall;
  procedure SetEditTabVisibility(  ATab: TSCB_BUTTON_ENUM; Visible: Boolean); stdCall;
  procedure SetEditTabsVisibility( AItemIndex: Integer; AItemCount: Integer); stdCall;
  procedure SetButtonVisibility( AButton: TSCB_BUTTON_ENUM; Visible: Boolean); stdCall;
end;

type
  TSetEditTabEvent = procedure( ATab: TSCB_BUTTON_ENUM ) of object;
  TSetEditTabVisibilityEvent = procedure( ATab: TSCB_BUTTON_ENUM; AVisible: Boolean) of object;
  TSetEditTabsVisibilityEvent = procedure ( AItemIndex: Integer; AItemCount: Integer) of object;
  TSetEditingEvent = procedure ( AValue: Boolean ) of object;
  TThemeFormEvent = procedure ( AForm: TForm; AEditing: Boolean ) of object;
type
  TInterfacedSharpCenterHostBase = class(TInterfacedObject,ISharpCenterHost)

    private
      FEditOwner: TWinControl;
      FPluginOwner: TWinControl;
      FPluginId: string;
      FTheme: TCenterThemeInfo;
      FEditMode: TSCE_EDITMODE_ENUM;
      FEditing: Boolean;
      FWarning: Boolean;
      FOnSettingsChanged: TNotifyEvent;

      FOnSetEditTabVisibility: TSetEditTabVisibilityEvent;
      FOnSetEditTab: TSetEditTabEvent;
      FOnRefreshAll: TNotifyEvent;
      FOnRefreshPluginTabs: TNotifyEvent;
      FOnRefreshPreview: TNotifyEvent;
      FOnRefreshTheme: TNotifyEvent;
      FOnRefreshTitle: TNotifyEvent;
      FOnRefreshSize: TNotifyEvent;
      FOnSetEditing: TSetEditingEvent;
      FOnSetWarning: TSetEditingEvent;
      FOnSetButtonVisibility: TSetEditTabVisibilityEvent;
      FXml: TInterfacedXmlBase;
      FOnSave: TNotifyEvent;

      FValidator: TJvValidators;
      FErrorIndicator: TJvErrorIndicator;
      FOnThemePluginForm: TThemeFormEvent;
      FOnThemeEditForm: TThemeFormEvent;

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
      function GetWarning : Boolean; stdcall;
      procedure SetWarning(Value : Boolean); stdcall;
    public
      constructor Create;
      destructor Destroy; override;
      function GetTheme : TCenterThemeInfo; virtual; stdCall;
      procedure SetEditing(Value : Boolean); stdCall;
      property EditOwner : TWinControl read GetEditOwner write SetEditOwner;
      property PluginOwner : TWinControl read GetPluginOwner write SetPluginOwner;
      property PluginId : string read GetPluginId write SetPluginId;
      property Theme: TCenterThemeInfo read GetTheme write SetTheme;
      property EditMode: TSCE_EDITMODE_ENUM read GetEditMode write
        SetEditMode;
      property Editing: Boolean read GetEditing write SetEditing;
      property Warning: Boolean read GetWarning write SetWarning;

      procedure Refresh( ARefreshType: TRefreshTypeEnum = rtAll ); stdCall;
      function Open(AForm: TForm) : THandle; stdcall;
      function OpenEdit(AForm: TForm):THandle; stdCall;
      procedure Save; stdCall;

      procedure GetBarModuleIdFromPluginId(var barId, moduleId: string);

      procedure SetEditTab( ATab: TSCB_BUTTON_ENUM ); stdCall;
      procedure SetEditTabVisibility( ATab: TSCB_BUTTON_ENUM; AVisible: Boolean); stdCall;
      procedure SetEditTabsVisibility( AItemIndex: Integer; AItemCount: Integer); stdCall;
      procedure SetButtonVisibility( AButton: TSCB_BUTTON_ENUM; Visible: Boolean); stdCall;
      procedure SetSettingsChanged; stdCall;

      procedure AssignThemeToPluginForm( APluginForm: TForm );
      procedure AssignThemeToEditForm( AEditForm: TForm );
      procedure AssignThemeToForms( AForm, AEditForm: TForm );

      property Xml: TInterfacedXmlBase read FXml;
      property Validator: TJvValidators read FValidator;
      property ErrorIndicator: TJvErrorIndicator read FErrorIndicator;

      function AddRequiredFieldValidator( controlToValidate: TControl;
        errorMessage: string; propertyToValidate: string ): TJvRequiredFieldValidator;

      function AddCustomValidator( controlToValidate: TControl;
        errorMessage: string; propertyToValidate: string ): TJvCustomValidator;

      property OnSave: TNotifyEvent read FOnSave write
        FOnSave;

      property OnRefreshAll: TNotifyEvent read FOnRefreshAll write
        FOnRefreshAll;

      property OnRefreshTitle: TNotifyEvent read FOnRefreshTitle write
        FOnRefreshTitle;

      property OnRefreshSize: TNotifyEvent read FOnRefreshSize write
        FOnRefreshSize;

      property OnRefreshTheme: TNotifyEvent read FOnRefreshTheme write
        FOnRefreshTheme;

      property OnRefreshPreview: TNotifyEvent read FOnRefreshPreview write
        FOnRefreshPreview;

      property OnRefreshPluginTabs: TNotifyEvent read FOnRefreshPluginTabs write
        FOnRefreshPluginTabs;

      property OnSettingsChanged: TNotifyEvent read FOnSettingsChanged write
        FOnSettingsChanged;

      property OnSetEditing: TSetEditingEvent read FOnSetEditing write
        FOnSetEditing;

      property OnSetWarning: TSetEditingEvent read FOnSetWarning write
        FOnSetWarning;

      property OnSetEditTab: TSetEditTabEvent read FOnSetEditTab write
        FOnSetEditTab;

      property OnSetEditTabVisibility: TSetEditTabVisibilityEvent read FOnSetEditTabVisibility write
        FOnSetEditTabVisibility;

      property OnSetButtonVisibility: TSetEditTabVisibilityEvent read FOnSetButtonVisibility write
        FOnSetButtonVisibility;

      property OnThemeEditForm: TThemeFormEvent read FOnThemeEditForm write
        FOnThemeEditForm;

      property OnThemePluginForm: TThemeFormEvent read FOnThemePluginForm write
        FOnThemePluginForm;
    end;

implementation

{ TInterfacedSharpCenterHostBase }

procedure TInterfacedSharpCenterHostBase.GetBarModuleIdFromPluginId(var barId, moduleId: string);
begin
   barId := copy(FPluginId, 0, pos(':',FPluginId)-1);
   moduleId := copy(FPluginId, pos(':',FPluginId)+1, length(FPluginId) - pos(':',FPluginId));
end;

function TInterfacedSharpCenterHostBase.AddCustomValidator(
  controlToValidate: TControl; errorMessage,
  propertyToValidate: string): TJvCustomValidator;
var
  tmp: TJvCustomValidator;
begin
  tmp := TJvCustomValidator.Create( Application.MainForm );
  tmp.ControlToValidate := controlToValidate;
  tmp.ErrorMessage := errorMessage;
  tmp.PropertyToValidate := propertyToValidate;
  Validator.Insert(tmp);

  result := tmp;
end;

function TInterfacedSharpCenterHostBase.AddRequiredFieldValidator(
  controlToValidate: TControl; errorMessage,
  propertyToValidate: string): TJvRequiredFieldValidator;
var
  tmp: TJvRequiredFieldValidator;
begin
  tmp := TJvRequiredFieldValidator.Create( Application.MainForm );
  tmp.ControlToValidate := controlToValidate;
  tmp.ErrorMessage := errorMessage;
  tmp.PropertyToValidate := propertyToValidate;
  Validator.Insert(tmp);

  result := tmp;
end;

procedure TInterfacedSharpCenterHostBase.AssignThemeToEditForm(
  AEditForm: TForm);
begin
  if assigned(FOnThemeEditForm) then
    FOnThemeEditForm( AEditForm, FEditing );
end;

procedure TInterfacedSharpCenterHostBase.AssignThemeToPluginForm(
  APluginForm: TForm);
begin
  if assigned(FOnThemePluginForm) then
    FOnThemePluginForm( APluginForm, FEditing );
end;

procedure TInterfacedSharpCenterHostBase.AssignThemeToForms( AForm, AEditForm: TForm );
var
  colBackground: Tcolor;
begin
  AssignThemeToPluginForm(AForm);
  colBackground := FTheme.EditBackground;

  If FEditing then begin
    with FTheme do begin
      EditBackground := EditBackgroundError;
    end;
    FTheme.EditBackground := FTheme.EditBackgroundError;
  end;

  AssignThemeToEditForm(AEditForm);
  FTheme.EditBackground := colBackground;

end;

constructor TInterfacedSharpCenterHostBase.Create;
begin
  FXml := TInterfacedXmlBase.Create;

  FErrorIndicator := TJvErrorIndicator.Create(nil);
  FValidator := TJvValidators.Create(nil);
  with FValidator do begin
    ErrorIndicator := FErrorIndicator;
  end;
end;

destructor TInterfacedSharpCenterHostBase.Destroy;
begin
  FXml := nil;
  FValidator.Free;
  FErrorIndicator.Free;
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

function TInterfacedSharpCenterHostBase.GetWarning: Boolean;
begin
  result := FWarning;
end;

function TInterfacedSharpCenterHostBase.Open(AForm: TForm): THandle;
begin
  AForm.ParentWindow := FPluginOwner.Handle;
  AForm.BorderStyle := bsNone;
  AForm.Left := 0;
  AForm.Top := 0;
  AForm.Show;
  result := AForm.Handle;
end;

function TInterfacedSharpCenterHostBase.OpenEdit(AForm: TForm): THandle;
begin
  AForm.ParentWindow := FEditOwner.Handle;
  AForm.BorderStyle := bsNone;
  AForm.Left := 0;
  AForm.Top := 0;
  AForm.Show;
  result := AForm.Handle;
end;

procedure TInterfacedSharpCenterHostBase.SetEditTab(ATab: TSCB_BUTTON_ENUM);
begin
  if assigned(FOnSetEditTab) then
    FOnSetEditTab( ATab );
end;

procedure TInterfacedSharpCenterHostBase.SetEditTabsVisibility(AItemIndex,
  AItemCount: Integer);

  procedure BC(AEnabled: Boolean; AButton: TSCB_BUTTON_ENUM);
  begin
    if AEnabled then
      SetEditTabVisibility(AButton, True)
    else
      SetEditTabVisibility(AButton, False);
  end;

begin
  if ((AItemCount = 0) or (AItemIndex = -1)) then begin
    BC(False, scbEditTab);

    if (AItemCount = 0) then begin
      SetEditTab(scbAddTab);
    end;

    BC(True, scbAddTab);

  end
  else begin
    BC(True, scbAddTab);
    BC(True, scbEditTab);
  end;
end;
procedure TInterfacedSharpCenterHostBase.SetEditTabVisibility(
  ATab: TSCB_BUTTON_ENUM; AVisible: Boolean);
begin
  if assigned(FOnSetEditTabVisibility) then
    FOnSetEditTabVisibility( ATab, AVisible );
end;

procedure TInterfacedSharpCenterHostBase.Refresh(
  ARefreshType: TRefreshTypeEnum = rtAll);
begin
  case ARefreshType of
    rtAll: begin
      if assigned(FOnRefreshAll) then
        FOnRefreshAll(Self);
    end;
    rtSize: begin
      if assigned(FOnRefreshSize) then
        FOnRefreshSize(Self);
    end;
    rtPreview: begin
      if assigned(FOnRefreshPreview) then
        FOnRefreshPreview(Self);
    end;
    rtTabs: begin
      if assigned(FOnRefreshPluginTabs) then
        FOnRefreshPluginTabs(Self);
    end;
    rtTheme : begin
      if assigned(FOnRefreshTheme) then
        FOnRefreshTheme(Self);
    end;
    rtTitle,rtStatus,rtDescription : begin
      if assigned(FOnRefreshTitle) then
        FOnRefreshTitle(Self);
    end;
  end;
end;

procedure TInterfacedSharpCenterHostBase.Save;
begin
  if assigned(FOnSave) then
    FOnSave(Self);
end;

procedure TInterfacedSharpCenterHostBase.SetButtonVisibility(
  AButton: TSCB_BUTTON_ENUM; Visible: Boolean);
begin
  if assigned(FOnSetButtonVisibility) then
    FOnSetButtonVisibility(AButton,Visible);
end;

procedure TInterfacedSharpCenterHostBase.SetEditing(Value: Boolean);
begin
  FEditing := Value;

  if assigned(FOnSetEditing) then
    FOnSetEditing(Value);
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

procedure TInterfacedSharpCenterHostBase.SetWarning(Value: Boolean);
begin
  if FWarning <> Value then begin

    FWarning := Value;

    if Assigned(FOnSetWarning) then
      FOnSetWarning(Value);
  end;
end;

end.
