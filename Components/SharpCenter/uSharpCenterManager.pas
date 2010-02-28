unit uSharpCenterManager;

interface

uses
  Windows,
  Messages,
  SysUtils,
  SharpApi,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ExtCtrls,
  Contnrs,
  pngimage,
  pngimagelist,
  JvValidators,
  JclFileUtils,
  JvSimpleXml,

  Menus,

  uSharpCenterHistoryList,
  uSharpCenterPluginManager,
  ISharpCenterPluginUnit,
  ISharpCenterHostUnit,
  SharpCenterApi,
  SharpETabList,
  uSharpCenterHost,
  uSharpCenterThemeManager;

type
  TSharpCenterItemType = (itmNone, itmFolder, itmSetting, itmDll);
  TTabID = (tidHome, tidFavourite, tidHistory, tidImport, tidExport);
  TEditTabID = (tidAdd, tidEdit, tidDelete);

const
  SCE_CON_EXT = '.con';
  SCE_ICON_FOLDER = 1;
  SCE_ICON_ITEM = 0;

type
  TSharpCenterManagerItem = class
  private
    FPath: string;
    FFilename: string;
    FIconIndex: Integer;
    FItemType: TSharpCenterItemType;
    FCaption: string;
    FStatus: string;
    FPluginID: string;
    FPlugin: TPlugin;
    FDescription: string;
    procedure SetCaption(const Value: string);
  public
    constructor Create;
    property Caption: string read FCaption write SetCaption;
    property Status: string read FStatus write FStatus;
    property Description: string read FDescription write FDescription;
    property PluginID: string read FPluginID write FPluginID;
    property Plugin: TPlugin read FPlugin write FPlugin;

    property Filename: string read FFilename write FFilename;
    property Path: string read FPath write FPath;

    property IconIndex: Integer read FIconIndex write FIconIndex;
    property ItemType: TSharpCenterItemType read FItemType write FItemType;
  end;

type
  TSharpCenterManagerAddNavItem = procedure(AItem: TSharpCenterManagerItem;
    const AIndex: Integer) of object;
  TSharpCenterSetHomeTitle = procedure(ADescription: string) of object;

type
  TSharpCenterManager = class
  private
    FHistory: TSharpCenterHistoryList;
    FRoot: string;

    FPlugin: TPlugin;
    FUnloadCommand: TSharpCenterHistoryItem;
    FActivePluginID: string;
    FActiveFile: string;
    FOnAddNavItem: TSharpCenterManagerAddNavItem;
    FPngImageList: TPngImageList;

    FPluginHandle: THandle;
    FEditHandle: THandle;
    FOnLoadPlugin: TNotifyEvent;
    FOnUnloadPlugin: TNotifyEvent;
    FOnAddPluginTabs: TNotifyEvent;
    FOnUpdateTheme: TNotifyEvent;
    FOnInitNavigation: TNotifyEvent;
    FOnLoadEdit: TNotifyEvent;
    FOnCancelEdit: TNotifyEvent;
    FOnApplyEdit: TNotifyEvent;
    FOnSetTitle: TNotifyEvent;
    FOnSetHomeTitle: TSharpCenterSetHomeTitle;
    FOnRefreshTheme: TNotifyEvent;
    FPluginHost: TInterfacedSharpCenterHostBase;
    FPluginTabs: TStringList;
    FThemeManager: TCenterThemeManager;

    FPluginTabIndex: Integer;
    FPluginVersion: string;

    // Dll Methods

    function UnloadDllTimer(ACommand: TSCC_COMMAND_ENUM; AParam,
      APluginID: string; APluginTabIndex: Integer): Boolean;

    function GetHistory: TSharpCenterHistoryList;

    function GetRoot: string;
    procedure AssignIconIndex(AFile: string; AItem: TSharpCenterManagerItem);

    procedure SetUnloadCommand(ACommand: TSCC_COMMAND_ENUM; AParam,
      APluginID: string; APluginTabIndex: Integer);

    procedure GetItemText(AFile, APluginID: string; var AName: string;
      var AStatus: string; var ADescription: string);
    procedure BuildNavFromCommandLine;
    function GetTheme: TCenterThemeInfo;

  public
    constructor Create;
    destructor Destroy; override;

    // Nav Methods
    procedure BuildNavFromPath(APath: string);
    procedure BuildNavFromFile(AFile: string; ALoad: Boolean = True; AHistory:Boolean = True);
    procedure BuildNavRoot;

    function LoadHome: Boolean;
    function Load(AFile, APluginID: string): Boolean;
    procedure Save;
    function Reload: Boolean;
    function Unload: Boolean;

    function LoadEdit(ATabID: Integer): Boolean;
    function ApplyEdit(ATabID: Integer): Boolean;
    function CancelEdit(ATabID: Integer): Boolean;

    function CheckEditState: Boolean;

    procedure UpdateSettingsBroadcast;
    procedure RefreshTheme;
    procedure RefreshValidation;

    function PluginHasEditSupport: Boolean;
    function PluginHasValidationSupport: Boolean;
    function PluginHasTabSupport: Boolean;
    function PluginHasPreviewSupport: Boolean;

    function ExecuteCommand(ACommand: TSCC_COMMAND_ENUM; AParam,
      APluginID: string; APluginTabIndex: Integer): Boolean;

    property OnAddNavItem: TSharpCenterManagerAddNavItem read FOnAddNavItem write FOnAddNavItem;
    property PngImageList: TPngImageList read FPngImageList write FPngImageList;

    property History: TSharpCenterHistoryList read GetHistory;

    property Plugin: TPlugin read FPlugin write FPlugin;
    property ActivePluginID: string read FActivePluginID write FActivePluginID;
    property ActiveFile: string read FActiveFile write FActiveFile;

    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;

    property Root: string read GetRoot;

    property UnloadCommand: TSharpCenterHistoryItem read FUnloadCommand write FUnloadCommand;

    property PluginTabs: TStringList read FPluginTabs write FPluginTabs;
    function LoadPluginTabs: Boolean;
    procedure ClickTab( ATabIndex: Integer );
    property PluginTabIndex: Integer read FPluginTabIndex write FPluginTabIndex;

    property PluginWndHandle: THandle read FPluginHandle write FPluginHandle;
    property EditWndHandle: THandle read FEditHandle write FEditHandle;
    property Theme: TCenterThemeInfo read GetTheme;
    property PluginVersion: string read FPluginVersion write FPluginVersion;

    property ThemeManager: TCenterThemeManager read FThemeManager write FThemeManager;
    property OnInitNavigation: TNotifyEvent read FOnInitNavigation write FOnInitNavigation;
    property OnUpdateTheme: TNotifyEvent read FOnUpdateTheme write FOnUpdateTheme;
    property OnAddPluginTabs: TNotifyEvent read FOnAddPluginTabs write FOnAddPluginTabs;
    property OnUnloadPlugin: TNotifyEvent read FOnUnloadPlugin write FOnUnloadPlugin;
    property OnSetTitle: TNotifyEvent read FOnSetTitle write FOnSetTitle;
    property OnLoadPlugin: TNotifyEvent read FOnLoadPlugin write FOnLoadPlugin;
    property OnLoadEdit: TNotifyEvent read FOnLoadEdit write FOnLoadEdit;
    property OnApplyEdit: TNotifyEvent read FOnApplyEdit write FOnApplyEdit;
    property OnCancelEdit: TNotifyEvent read FOnCancelEdit write FOnCancelEdit;
    property OnSetHomeTitle: TSharpCenterSetHomeTitle read FOnSetHomeTitle write FOnSetHomeTitle;
    property OnRefreshTheme: TNotifyEvent read FOnRefreshTheme write FOnRefreshTheme;
  end;

var
  SCM: TSharpCenterManager;

implementation

{ TSharpCenterManager }

function TSharpCenterManager.Load(AFile, APluginID: string): Boolean;
var
  Xml: TJvSimpleXML;
begin
  Result := False;
  Xml := TJvSimpleXML.Create(nil);
  FActiveFile := AFile;

  try
    if FileExists(AFile) then
    begin
      FPlugin := LoadPluginInterface(PChar(AFile), FPluginHost);

      if ((FPlugin.Dllhandle <> 0) and (@FPlugin.InitPluginInterface <> nil)) then
      begin
        FPluginHost.PluginId := APluginID;
        FPlugin.PluginInterface := FPlugin.InitPluginInterface(FPluginHost);
        FPlugin.PluginInterface.CanDestroy := false;
        FPluginHandle := Plugin.PluginInterface.Open;
        FPluginHost.PluginOwner.ParentWindow := FPluginHandle;

        // load plugin tabs
        LoadPluginTabs;

        if Assigned(FOnLoadPlugin) then
          FOnLoadPlugin(Self);

        if Assigned(FOnUpdateTheme) then
          FOnUpdateTheme(Self);

        Result := True;
      end;
    end;

  finally
    Xml.Free;
  end;
end;

function TSharpCenterManager.Unload: Boolean;
begin
  Result := False;
  if (Plugin.Dllhandle = 0) then
    exit;

  if Assigned(FOnUnloadPlugin) then
    FOnUnloadPlugin(Self);

  // Call the close method on the plugin
  FPlugin.PluginInterface.Close;

  FPluginTabs.Clear;

  // Unload the plugin
  UnloadPluginInterface(FPlugin, FPluginHost);

  FEditHandle := 0;
  FPluginHandle := 0;
  FPlugin.Dllhandle := 0;

  Result := True;
end;

function TSharpCenterManager.UnloadDllTimer(ACommand: TSCC_COMMAND_ENUM; AParam,
  APluginID: string; APluginTabIndex: Integer): Boolean;
begin
  Result := True;
  SetUnloadCommand(ACommand, AParam, APluginID, APluginTabIndex);

  SCM.PluginTabIndex := FUnloadCommand.TabIndex;

  if FUnloadCommand.Command = sccUnloadDll then
  begin
    if FPlugin.Dllhandle <> 0 then
      Unload;

    if not (IsDirectory(FUnloadCommand.Param)) then
      Load(FUnloadCommand.Param, FUnloadCommand.PluginID);
  end
  else if FUnloadCommand.Command = sccChangeFolder then
  begin
    if FPlugin.Dllhandle <> 0 then
      Unload;

    ActivePluginID := FUnloadCommand.PluginID;
    BuildNavFromPath(FUnloadCommand.Param)
  end
  else if FUnloadCommand.Command = sccLoadDll then
  begin
    if FPlugin.Dllhandle <> 0 then
      Unload;

    ActivePluginID := FUnloadCommand.PluginID;
    BuildNavFromCommandLine;
  end
  else if FUnloadCommand.Command = sccLoadSetting then
  begin

    if FPlugin.Dllhandle <> 0 then
      Unload;

    ActivePluginID := FUnloadCommand.PluginID;
    if CompareText(ExtractFileExt(FUnloadCommand.Param), '.con') = 0 then begin
      BuildNavFromFile(FUnloadCommand.Param);
    end
    else begin
      BuildNavFromCommandLine;
    end;
  end;
end;

procedure TSharpCenterManager.RefreshTheme;
begin
  FThemeManager.Refresh;

  if Plugin.Dllhandle <> 0 then
    Plugin.PluginInterface.Refresh(SCM.Theme,FPluginHost.Editing);

  if assigned(FOnRefreshTheme) then
    FOnRefreshTheme(Self);
end;

function TSharpCenterManager.Reload: Boolean;
begin
  Result := Load(FActiveFile, FActivePluginID);
end;

procedure TSharpCenterManager.Save;
begin
  FPlugin.PluginInterface.Save;

  UpdateSettingsBroadcast;
end;

procedure TSharpCenterManager.BuildNavFromFile(AFile: string; ALoad: Boolean = True;
 AHistory:Boolean=True );
var
  xml: TJvSimpleXML;
  i: Integer;
  pngfile: string;
  sName, sStatus, sTitle, sDescription, sDll, sIcon: string;
  sPath: string;
  sFirstNavFile, sFirstPluginID: string;
  newItem: TSharpCenterManagerItem;
begin
  if not fileexists(AFile) then exit;

  LockWindowUpdate(Application.MainForm.Handle);

  FPngImageList.Clear;
  
  try

    if Assigned(FOnInitNavigation) then
      FOnInitNavigation(Self);

    if AHistory then
      History.AddCon(AFile, ActivePluginID);

    xml := TJvSimpleXML.Create(nil);
    try
      xml.LoadFromFile(AFile);

      with xml.Root.Items.ItemNamed['Sections'] do
      begin
        for i := 0 to Pred(Items.Count) do
        begin

          newItem := TSharpCenterManagerItem.Create;
            newItem.ItemType := itmDll;

            sPath := ExtractFilePath(AFile);
            sDll := '';
            if Items.Item[i].Items.ItemNamed['Dll'] <> nil then
              sDll := Items.Item[i].Items.ItemNamed['Dll'].Value;

            sIcon := '';
            if Items.Item[i].Items.ItemNamed['Icon'] <> nil then
              sIcon := Items.Item[i].Items.ItemNamed['Icon'].Value;

            sName := '';
            sStatus := '';
            sTitle := '';
            sDescription := '';
            GetItemText(sPath + sDll, SCM.ActivePluginID, sName, sStatus, sDescription);

            if Items.Item[i].Items.ItemNamed['Name'] <> nil then
              sName := Items.Item[i].Items.ItemNamed['Name'].Value;

            if sName = '' then
              newItem.Caption := Items.Item[i].Name
            else
              newItem.Caption := sName;

            newItem.Filename := sPath + sDll;
            newItem.PluginID := SCM.ActivePluginID;
            newItem.Description := sDescription;
            NewItem.Status := sStatus;

            pngfile := sPath + sIcon;
            SCM.AssignIconIndex(pngfile, newItem);

            if Assigned(FOnAddNavItem) then begin
              FOnAddNavItem(newItem, newItem.IconIndex);
            end;

            if i = 0 then
            begin
              sFirstNavFile := newItem.Filename;
              sFirstPluginID := newItem.PluginID;
            end;
        end;
      end;

    finally
      xml.Free;
    end;

  finally
    if ALoad then begin
      Unload;
      Load(sFirstNavFile, sFirstPluginID);
    end else
    begin
      // Add the first dll in the con file
      FHistory.AddDll(sFirstNavFile,sFirstPluginID);
    end;

    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterManager.BuildNavFromPath(APath: string);
var
  SRec: TSearchRec;
  xml: TJvSimpleXML;
  newItem: TSharpCenterManagerItem;

  sName, sIcon, sPng: string;
  iCount: Integer;
  sPath: string;
  sDll: string;
  sStatus: string;
  sTitle: string;
  sDescription: string;
begin
  // Unload the dll first
  SCM.Unload;

  iCount := 0;
  LockWindowUpdate(Application.MainForm.Handle);

  FPngImageList.Clear;

  if Assigned(FOnInitNavigation) then
    FOnInitNavigation(Self);

  try
    APath := PathAddSeparator(APath);

    if FindFirst(APath + '*.*', SysUtils.faAnyFile, SRec) = 0 then
      repeat
        if (sRec.Name = '.') or (sRec.Name = '..') then
          Continue;

        if CompareText(ExtractFileExt(sRec.Name), SCE_CON_EXT) = 0 then
        begin

          xml := TJvSimpleXML.Create(nil);
          try
            Xml.LoadFromFile(APath + sRec.Name);

            if xml.Root.Items.ItemNamed['Default'] <> nil then
            begin
              with xml.Root.Items.ItemNamed['Default'] do
              begin
                if Items.ItemNamed['Dll'] <> nil then
                  sDll := Items.ItemNamed['Dll'].Value;

                if Items.ItemNamed['Icon'] <> nil then
                  sIcon := APath + Items.ItemNamed['Icon'].Value;
              end;
            end
            else
            begin
              if xml.Root.Items.ItemNamed['Sections'] <> nil then
                if xml.Root.Items.ItemNamed['Sections'].items.Item[0] <> nil then
                  sDll := xml.Root.Items.ItemNamed['Sections'].items.Item[0].Items.ItemNamed['Dll'].Value;

              sName := PathRemoveExtension(sRec.Name);
              sIcon := APath + PathRemoveExtension(sRec.Name) + '.png';
            end;

            sPath := ExtractFilePath(APath + sRec.Name);
            sName := '';
            sStatus := '';
            sTitle := '';
            sDescription := '';
            GetItemText(sPath + sDll, SCM.ActivePluginID, sName, sStatus, sDescription);

          finally
            Xml.Free;
          end;

          newItem := TSharpCenterManagerItem.Create;
            newItem.Caption := sName;
            newItem.Status := sStatus;
            newItem.ItemType := itmSetting;
            newItem.Filename := APath + sRec.Name;
            sPng := sIcon;
            AssignIconIndex(sPng, newItem);

            if Assigned(FOnAddNavItem) then begin
              FOnAddNavItem(newItem, -1);
              Inc(iCount);
            end;
        end
        else if IsDirectory(APath + sRec.Name) then
        begin

          if Copy(sRec.Name, 0, 1) <> '_' then
          begin

            newItem := TSharpCenterManagerItem.Create;
              newItem.Caption := PathRemoveExtension(sRec.Name);
              newItem.Path := APath + sRec.Name;
              newItem.ItemType := itmFolder;
              sPng := APath + PathRemoveExtension(sRec.Name) + '.png';
              AssignIconIndex(sPng, newItem);

              if Assigned(FOnAddNavItem) then begin
                FOnAddNavItem(newItem, -1);
                Inc(iCount);
              end;
          end;
        end;
      until
        FindNext(SRec) <> 0;
  finally
    FindClose(sRec);

    if iCount = 0 then
    begin
      newItem := TSharpCenterManagerItem.Create;
      newItem.Caption := 'No items found';
      newItem.ItemType := itmNone;

      if Assigned(FOnAddNavItem) then
      begin
        FOnAddNavItem(newItem, 0);
      end;

    end;
    LockWindowUpdate(0);

    if SCM.History.Count <= 1 then
      SCM.LoadHome;

    History.AddFolder(APath);
  end;
end;

function TSharpCenterManager.ExecuteCommand(ACommand: TSCC_COMMAND_ENUM; AParam,
  APluginID: string; APluginTabIndex: Integer): Boolean;
begin
  Result := True;
  if ACommand = sccChangeFolder then
  begin
    UnloadDllTimer(sccChangeFolder, AParam, APluginID, APluginTabIndex);
  end else
    if ACommand = sccUnloadDll then
    begin
      UnloadDllTimer(sccUnloadDll, AParam, APluginID, APluginTabIndex);
    end else
      if ACommand = sccLoadSetting then
      begin
        UnloadDllTimer(sccLoadSetting, AParam, APluginID, APluginTabIndex);

      end
      else
        if ACommand = sccLoadDll then begin
          UnloadDllTimer(sccLoadDll, AParam, APluginID, APluginTabIndex);
        end
        else begin
          MessageDlg('Unknown command', mtError, [mbOK], 0);
        end;
end;

procedure TSharpCenterManager.UpdateSettingsBroadcast;
var
  enumSettingType: TSU_UPDATE_ENUM;
  n: Integer;
begin
  enumSettingType := FPlugin.ConfigType;

  // if a ':' is in the string then it's a suModule message
  // we need to extract the ModuleID and send it as param...
  if pos(':', FActivePluginID) <> 0 then
  begin
    if not TryStrToInt(copy(FActivePluginID, pos(':', FActivePluginID) + 1, length(FActivePluginID) - pos(':', FActivePluginID)), n) then
      n := -1;
  end
  else if TryStrToInt(FActivePluginID, n) then
    n := StrToInt(FActivePluginID) else
    n := -1;

  SharpEBroadCast(WM_SHARPEUPDATESETTINGS, Integer(enumSettingType), n);
end;

procedure TSharpCenterManager.BuildNavFromCommandLine;
var
  iSections: Integer;
  sDll: string;
  strl: TStringList;
  xml: TJvSimpleXML;
  sConFile: string;
  i: Integer;
begin
  strl := Tstringlist.Create;
  xml := TJvSimpleXML.Create(nil);
  sConFile := '';
  try
    AdvBuildFileList(GetCenterDirectory + '*.con', faNormalFile, strl, amAny, [flRecursive, flFullNames], '', nil);
    for i := 0 to Pred(strl.Count) do
    begin
      xml.LoadFromFile(strl[i]);
      for iSections := 0 to Pred(xml.Root.Items[0].Items.Count) do
      begin
        sDll := ExtractFilePath(strl[0]) + xml.Root.Items[0].Items[iSections].Items.Value('Dll', '');
        if CompareText(ExtractFileName(FUnloadCommand.Param), ExtractFileName(sDll)) = 0 then
        begin
          sConFile := strl[i];
          break;
        end;
      end;
      if sConfile <> '' then
        break;
    end;
  finally
    strl.Free;
    xml.Free;
  end;

  if sConFile <> '' then
    BuildNavFromFile(sConFile, False, False);

  Load(FUnloadCommand.Param, FUnloadCommand.PluginID);
end;

procedure TSharpCenterManager.BuildNavRoot;
begin
  History.Clear;
  BuildNavFromPath(FRoot);
end;

function TSharpCenterManager.GetHistory: TSharpCenterHistoryList;
begin
  Result := FHistory;
end;

constructor TSharpCenterManager.Create;
var
  meta: TMetaData;
  priority, delay: Integer;
begin
  // Create the host interface
  FThemeManager := TCenterThemeManager.Create;

  FPluginHost := TInterfacedSharpCenterHostBase.Create;
  FPluginHost.CanDestroy := False;

  RefreshTheme;
  FPluginHost.Theme := FThemeManager.Theme;

  FHistory := TSharpCenterHistoryList.Create;

  // Set the active root path
  FRoot := GetCenterDirectory;

  // Get the plugin version
  SharpAPI.GetComponentMetaData( GetSharpeDirectory + 'SharpCore.exe', meta, priority, delay);
  FPluginVersion := meta.Version;

  FUnloadCommand := TSharpCenterHistoryItem.Create;

  FPluginTabs := TStringList.Create;
  FPngImageList := TPngImageList.Create(nil);
end;

destructor TSharpCenterManager.Destroy;
begin
  FHistory.Free;
  FUnloadCommand.Free;
  FPluginTabs.Free;
  FPngImageList.Free;

  // Don't free the interface, set the interface to nil
  FThemeManager.Free;

  FPluginHost.CanDestroy := True;
  FPluginHost := nil;

  inherited;
end;

function TSharpCenterManager.GetRoot: string;
begin
  Result := FRoot;
end;

function TSharpCenterManager.GetTheme: TCenterThemeInfo;
begin
  Result := FThemeManager.Theme;
end;

function TSharpCenterManager.CheckEditState: Boolean;
begin
  Result := False;
  if PluginHost.Editing then begin
    PluginHost.Warning := True;
    Result := True;
  end;

  if ((PluginHost.Editing) or (PluginHost.Warning)) then
    Result := True;
end;

procedure TSharpCenterManager.ClickTab(ATabIndex: Integer);
var
  tmpStrItem: TStringItem;
begin
  if ( (ATabIndex >= 0) and ( ATabIndex < FPluginTabs.Count) ) then begin

    tmpStrItem.FString := FPluginTabs[ATabIndex];
    tmpStrItem.FObject := FPluginTabs.Objects[ATabIndex];

    FPlugin.TabInterface.ClickPluginTab(tmpStrItem);
  end;
end;

procedure TSharpCenterManager.RefreshValidation;
var
  i: Integer;
begin
  // Delete existing
  for i := Pred(PluginHost.Validator.Count) downto 0 do
  begin
    PluginHost.Validator[i].Free;
  end;
  // Set validation graphics
  PluginHost.ErrorIndicator.Images := FPngImageList;
  PluginHost.ErrorIndicator.ImageIndex := 3;
  Plugin.ValidationInterface.SetupValidators;
end;

procedure TSharpCenterManager.AssignIconIndex(AFile: string;
  AItem: TSharpCenterManagerItem);
var
  tmpPngImage: TPNGObject;
  tmpPiC: TPngImageCollectionItem;
begin
  if FileExists(AFile) then
  begin
    tmpPngImage := TPNGObject.Create;
    tmpPngImage.LoadFromFile(AFile);
    tmpPngImage.CreateAlpha;

    tmpPiC := FPngImageList.PngImages.Add();
    tmpPiC.PngImage.Assign(tmpPngImage);
    tmpPiC.Background := clWindow;

    AItem.IconIndex := tmpPic.Index;
    tmpPngImage.Free;
  end
  else if AItem.ItemType = itmFolder then
    AItem.IconIndex := SCE_ICON_FOLDER
  else
    AItem.IconIndex := SCE_ICON_ITEM;
end;

procedure TSharpCenterManager.SetUnloadCommand(ACommand: TSCC_COMMAND_ENUM; AParam,
  APluginID: string; APluginTabIndex: Integer);
begin
  FUnloadCommand.Command := ACommand;
  FUnloadCommand.Param := AParam;
  FUnloadCommand.PluginID := APluginID;
  FUnloadCommand.TabIndex := APluginTabIndex;
end;

function TSharpCenterManager.LoadPluginTabs: Boolean;
var
  tmp : TStringlist;
  tmpObj : TObject;
  i : integer;
begin
  Result := True;
  
  tmp := TStringList.Create;
  try
    if (PluginHasTabSupport) then
    begin
      Plugin.TabInterface.AddPluginTabs(tmp);
      
      PluginTabs.Clear;

      for I := 0 to tmp.Count - 1 do
      begin
        PluginTabs.AddObject(PAnsiChar(tmp[i]), tmp.Objects[i]);
      end;

      if Assigned(FOnAddPluginTabs) then
        FOnAddPluginTabs(Self);
    end else
      if Assigned(FOnAddPluginTabs) then
        FOnAddPluginTabs(Self);

    if (PluginTabs.Count > 0) then
      ClickTab(FPluginTabIndex);
  finally
    tmp.Free;
  end;
end;

function TSharpCenterManager.PluginHasEditSupport: Boolean;
var
  tmp:ISharpCenterPluginEdit;
begin
  Result := True;

  if FPlugin.PluginInterface = nil then begin
    Result := false;
    exit;
  end;

  tmp := nil;
  if not(FPlugin.PluginInterface.QueryInterface(IID_ISharpCenterPluginEdit,tmp) = S_OK) then
    Result := False else begin
      with Plugin do begin
        EditInterface := tmp;
      end;
    end;
end;

function TSharpCenterManager.PluginHasValidationSupport: Boolean;
var
  tmp:ISharpCenterPluginValidation;
begin
  Result := True;

  if FPlugin.PluginInterface = nil then begin
    Result := false;
    exit;
  end;

  tmp := nil;
  if not(FPlugin.PluginInterface.QueryInterface(IID_ISharpCenterPluginValidation,tmp) = S_OK) then
    Result := False else begin
      with Plugin do begin
        ValidationInterface := tmp;
      end;
    end;
end;

function TSharpCenterManager.PluginHasPreviewSupport: Boolean;
var
  tmp:ISharpCenterPluginPreview;
begin
  Result := True;

  if FPlugin.PluginInterface = nil then begin
    Result := false;
    exit;
  end;

  tmp := nil;
  if not(FPlugin.PluginInterface.QueryInterface(IID_ISharpCenterPluginPreview,tmp) = S_OK) then
    Result := False else begin
      with Plugin do begin
        PreviewInterface := tmp;
      end;
    end;
end;

function TSharpCenterManager.PluginHasTabSupport: Boolean;
var
  tmp:ISharpCenterPluginTabs;
begin
  Result := True;

  if FPlugin.PluginInterface = nil then begin
    Result := false;
    exit;
  end;

  tmp := nil;
  if not(FPlugin.PluginInterface.QueryInterface(IID_ISharpCenterPluginTabs,tmp) = S_OK) then
    Result := False else begin
      with Plugin do begin
        TabInterface := tmp;
      end;
    end;
end;

procedure TSharpCenterManager.GetItemText(AFile, APluginID: string;
          var AName, AStatus, ADescription: string);
var
  tmpPlugin: TPlugin;
begin
  try
    AName := '';
    AStatus := '';
    ADescription := '';
    FPluginHost.PluginId := APluginID;

    if fileexists(AFile) then
    begin
      tmpPlugin := LoadPluginInterface(PChar(Afile), FPluginHost);
      AName := tmpPlugin.PluginData.Name;
      AStatus := tmpPlugin.PluginData.Status;
      ADescription := tmpPlugin.PluginData.Description;
    end;
  finally
    UnloadPluginInterface(tmpPlugin, FPluginHost);
  end;
end;

function TSharpCenterManager.LoadEdit(ATabID: Integer): Boolean;
var
  editMode:TSCE_EDITMODE_ENUM;
begin
  Result := True;
  editMode := sceAdd;

  if CheckEditState then exit;

  if (PluginHasEditSupport) then begin

    case Integer(ATabID) of
      Integer(tidAdd): editMode := sceAdd;
      Integer(tidEdit): editMode := sceEdit;
      Integer(tidDelete): editMode := sceDelete;
    end;

    FPluginHost.EditMode := editMode;
    FEditHandle := Plugin.EditInterface.OpenEdit();
    FPluginHost.EditOwner.ParentWindow := FEditHandle;

    // Set up validators
    if (PluginHasValidationSupport) then begin
      RefreshValidation;
    end;

    if assigned(FOnUpdateTheme) then
      FOnUpdateTheme(Self);

    if assigned(FOnLoadEdit) then
      FOnLoadEdit(Self);

  end;
end;

function TSharpCenterManager.LoadHome: Boolean;
var
  Xml: TJvSimpleXML;
  sFile, tmp: string;
begin
  Result := False;
  Xml := TJvSimpleXML.Create(nil);
  sFile := GetCenterDirectory + '_home\home.dll';
  try
    if FileExists(sFile) then
    begin
      FPlugin := LoadPluginInterface(PChar(sFile), FPluginHost);

      if ((FPlugin.Dllhandle <> 0) and (@FPlugin.InitPluginInterface <> nil)) then
      begin
        FPluginHandle := Plugin.PluginInterface.Open;
        FPluginHost.PluginOwner.ParentWindow := FPluginHandle;

        LoadPluginTabs;

        if Assigned(FOnSetHomeTitle) then
        begin
          tmp := FPlugin.PluginData.Description;
          if tmp = '' then
            tmp := FPlugin.MetaData.Description;

          FOnSetHomeTitle(tmp);
        end;

        if Assigned(FOnLoadPlugin) then
          FOnLoadPlugin(Self);

        if Assigned(FOnUpdateTheme) then
          FOnUpdateTheme(Self);

        Result := True;
      end;
    end;
  finally
    Xml.Free;
  end;
end;

function TSharpCenterManager.ApplyEdit(ATabID: Integer): Boolean;
var
  bValid: Boolean;
  editMode: TSCE_EDITMODE_ENUM;
begin
  Result := True;
  editMode  := sceAdd;

  LockWindowUpdate(Application.MainForm.Handle);
  try

    bValid := True;
    if (PluginHasEditSupport) then begin

      case ATabID of
        Integer(tidAdd): editMode := sceAdd;
        Integer(tidEdit): editMode := sceEdit;
        Integer(tidDelete): editMode := sceDelete;
      end;

      FPluginHost.EditMode := editMode;

      // Validate here
      if (PluginHasValidationSupport) then begin
        bValid := PluginHost.Validator.Validate;
      end else
        bValid := true;

      if bValid then
        Plugin.EditInterface.CloseEdit( True );
    end;

    if bValid then begin
      PluginHost.Editing := False;
      PluginHost.Warning := False;
      EditWndHandle := 0;

      if Assigned(FOnApplyEdit) then
        FOnApplyEdit(Self);

      LoadPluginTabs;

    end else begin
      CheckEditState;
      Result := false;
    end;

  finally
    LockWindowUpdate(0);
  end;
end;

function TSharpCenterManager.CancelEdit(ATabID: Integer): Boolean;
begin
  Result := True;

  if (PluginHasEditSupport) then begin
    PluginHost.EditMode := sceEdit;

    Plugin.EditInterface.CloseEdit(False);
  end;

  if not (PluginHost.Editing) then begin
    PluginHost.Editing := False;
    PluginHost.Warning := False;
    EditWndHandle := 0;

    if assigned(FOnCancelEdit) then
      FOnCancelEdit(nil);

    exit;
  end;

  PluginHost.Warning := False;
  PluginHost.Editing := False;
  EditWndHandle := 0;

  if assigned(FOnCancelEdit) then
    FOnCancelEdit(Self);
end;

{ TSharpCenterManagerItem }

constructor TSharpCenterManagerItem.Create;
begin

end;

procedure TSharpCenterManagerItem.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

initialization
  SCM := TSharpCenterManager.Create;
finalization
  if Assigned(SCM) then
    FreeAndNil(SCM);

end.

