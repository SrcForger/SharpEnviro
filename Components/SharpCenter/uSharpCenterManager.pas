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
  pngimage,
  pngimagelist,

  JclFileUtils,
  JvSimpleXml,

  Menus,

  uSharpCenterHistoryManager,
  uSharpCenterDllMethods,
  uSharpCenterPluginTabList;

type
  TSharpCenterItemType = (itmNone, itmFolder, itmSetting, itmDll);
  TTabID = (tidHome, tidFavourite, tidHistory, tidImport, tidExport);
  TEditTabID = (tidAdd, tidEdit, tidDelete);

const
  SCE_CON_EXT = '.con';
  SCE_ICON_FOLDER = 1;
  SCE_ICON_ITEM = 0;

type
  TSharpCenterManagerItem = Class
  private
    FPath: string;
    FFilename: string;
    FIconIndex: Integer;
    FItemType: TSharpCenterItemType;
    FCaption: string;
    FStatus: string;
    FPluginID: string;
    FPlugin: TSetting;
  public
    constructor Create;
    property Caption: string read FCaption write FCaption;
    property Status: string read FStatus write FStatus;
    property PluginID: string read FPluginID write FPluginID;
    property Plugin: TSetting read FPlugin write FPlugin;

    property Filename: string read FFilename write FFilename;
    property Path: string read FPath write FPath;

    property IconIndex: Integer read FIconIndex write FIconIndex;
    property ItemType: TSharpCenterItemType read FItemType write FItemType;
  end;

type
  TSharpCenterManagerAddNavItem = Procedure (AItem: TSharpCenterManagerItem) of object;

type
  TSharpCenterManager = Class
  private

    FStateEditWarning: Boolean;
    FStateEditItem: Boolean;
    FHistory: TSharpCenterHistoryManager;
    FActiveCommand: TSharpCenterHistoryItem;
    FRoot: String;
    FUnloadTimer: TTimer;

    FActivePlugin: TSetting;
    FUnloadCommand: TSharpCenterHistoryItem;
    FActivePluginID: string;
    FActiveFile: string;
    FOnAddNavItem: TSharpCenterManagerAddNavItem;
    FPngImageList: TPngImageList;

    FPluginWndHandle: THandle;
    FEditWndHandle: THandle;
    FOnLoadPlugin: TNotifyEvent;
    FOnUnloadPlugin: TNotifyEvent;
    FPluginTabs: TPluginTabItemList;
    FOnAddPluginTabs: TNotifyEvent;
    FOnUpdateTheme: TNotifyEvent;
    FOnInitNavigation: TNotifyEvent;
    FEditWndContainer: TPanel;
    FPluginContainer: TPanel;
    FOnLoadEdit: TNotifyEvent;
    FOnCancelEdit: TNotifyEvent;
    FOnApplyEdit: TNotifyEvent;

    // Events
    procedure UnloadTimerEvent(Sender:TObject);

    // Dll Methods

    Function UnloadDllTimer(ACommand, AParam, APluginID: string):Boolean;
    Function LoadPluginTabs: Boolean;

    procedure SetStateEditItem(const Value: Boolean);
    procedure SetStateEditWarning(const Value: Boolean);
    function GetHistory: TSharpCenterHistoryManager;

    
    function GetRoot: String;
    procedure AssignIconIndex(AFile: string; AItem: TSharpCenterManagerItem);

    procedure SetActiveCommand(ACommand, AParam, APluginID:String);
    procedure SetUnloadCommand(ACommand, AParam, APluginID:String);

    function GetDisplayName(AFile, APluginID: string): string;
    function GetStatusText(AFile, APluginID: string): string;

  public
    constructor Create;
    destructor Destroy; override;

    // Nav Methods
    Function BuildNavFromPath(APath: string):Boolean;
    Function BuildNavFromFile(AFile: string):Boolean;
    Function BuildNavRoot:Boolean;

    Function Load(AFile, APluginID: String):Boolean;
    Function Save:Boolean;
    Function Reload:Boolean;
    Function Unload:Boolean;

    Function LoadEdit(ATabID:Integer):Boolean;
    Function ApplyEdit(ATabID:Integer):Boolean;
    Function CancelEdit(ATabID:Integer):Boolean;

    function CheckEditState:Boolean;

    Function ExecuteCommand(ACommand, AParam, APluginID: string):Boolean;

    property OnAddNavItem: TSharpCenterManagerAddNavItem read FOnAddNavItem write FOnAddNavItem;
    property PngImageList: TPngImageList read FPngImageList write FPngImageList;

    property StateEditItem: Boolean read FStateEditItem write SetStateEditItem;
    property StateEditWarning: Boolean read FStateEditWarning write SetStateEditWarning;

    property History: TSharpCenterHistoryManager read GetHistory;
    
    property ActivePlugin: TSetting read FActivePlugin write FActivePlugin;
    property ActivePluginID: string read FActivePluginID write FActivePluginID;
    property ActiveFile: string read FActiveFile write FActiveFile;

    property Root: String read GetRoot;

    property ActiveCommand: TSharpCenterHistoryItem read FActiveCommand write FActiveCommand;
    property UnloadCommand: TSharpCenterHistoryItem read FUnloadCommand write FUnloadCommand;

    property PluginTabs: TPluginTabItemList read FPluginTabs write FPluginTabs;

    property PluginWndHandle: THandle read FPluginWndHandle write FPluginWndHandle;
    property EditWndHandle: THandle read FEditWndHandle write FEditWndHandle;

    property PluginContainer: TPanel read FPluginContainer write FPluginContainer;
    property EditWndContainer: TPanel read FEditWndContainer write FEditWndContainer;


    property OnInitNavigation: TNotifyEvent read FOnInitNavigation write FOnInitNavigation;
    property OnUpdateTheme: TNotifyEvent read FOnUpdateTheme write FOnUpdateTheme;
    property OnAddPluginTabs: TNotifyEvent read FOnAddPluginTabs write FOnAddPluginTabs;
    property OnUnloadPlugin: TNotifyEvent read FOnUnloadPlugin write FOnUnloadPlugin;
    property OnLoadPlugin: TNotifyEvent read FOnLoadPlugin write FOnLoadPlugin;
    property OnLoadEdit: TNotifyEvent read FOnLoadEdit write FOnLoadEdit;
    property OnApplyEdit: TNotifyEvent read FOnApplyEdit write FOnApplyEdit;
    property OnCancelEdit: TNotifyEvent read FOnCancelEdit write FOnCancelEdit;
end;

var
  SCM: TSharpCenterManager;

implementation

{ TSharpCenterManager }

function TSharpCenterManager.Load(AFile, APluginID: String): Boolean;
var
  Xml: TJvSimpleXML;
  iSettingType: Integer;
  sFile, sName: string;

begin
  Result := False;
  Xml := TJvSimpleXML.Create(nil);
  FActiveFile := AFile;

  try

    if FileExists(AFile) then begin
      ActivePlugin := LoadPlugin(PChar(AFile));

      if (@ActivePlugin.Open) <> nil then
      begin
        FPluginWndHandle := ActivePlugin.Open(Pchar(APluginID), FPluginContainer.Handle);
        FPluginContainer.ParentWindow := FPluginWndHandle;

        // Get setting type
        if (@ActivePlugin.SetSettingType <> nil) then
          iSettingType := ActivePlugin.SetSettingType
        else
          iSettingType := -1;

        // load plugin tabs
        LoadPluginTabs;

        if Assigned(FOnLoadPlugin) then
          FOnLoadPlugin(Self);

        if Assigned(FOnAddPluginTabs) then
          FOnAddPluginTabs(Self);

        if Assigned(FOnUpdateTheme) then
          FOnUpdateTheme(Self);

        Result := True;

        case iSettingType of
          SCU_SHARPTHEME: ; // already assigned
          SCU_SERVICE:
            begin
              sName := GetDisplayName(FActiveFile, FActivePluginID);
              sFile := GetSharpeUserSettingsPath + 'SharpCore\ServiceList.xml';

              if FileExists(sFile) then
              begin
                Xml.LoadFromFile(sFile);
                with Xml.Root.Items do

                  if ItemNamed[sName] <> nil then
                    FActivePluginID := ItemNamed[sName].Properties.Value('ID', '');
              end;
            end;
        end;
      end;
    end;

  finally
    Xml.Free;
  end;
end;

function TSharpCenterManager.Unload: Boolean;
begin
  Result := False;
  if ActivePlugin.Dllhandle = 0 then
    exit;

  if Assigned(FOnUnloadPlugin) then
    FOnUnloadPlugin(Self);

  // Handle proper closing of the setting
  if @FActivePlugin.Close <> nil then
    FActivePlugin.Close(false);

  // Unload dll
  UnloadPlugin(@FActivePlugin);

  FEditWndHandle := 0;
  FPluginWndHandle := 0;
  Result := True;
end;

function TSharpCenterManager.UnloadDllTimer(ACommand, AParam,
  APluginID: string): Boolean;
begin
  Result := True;
  SetUnloadCommand(ACommand,AParam,APluginID);
  FUnloadTimer.Enabled := True;
end;

procedure TSharpCenterManager.UnloadTimerEvent(Sender: TObject);
begin
  FUnloadTimer.Enabled := False;

  if CompareText(FUnloadCommand.Command, cUnloadDll) = 0 then
  begin
    if FActivePlugin.Dllhandle <> 0 then
      Unload;

    if not (IsDirectory(FUnloadCommand.Param)) then
      Load(FUnloadCommand.Param, FUnloadCommand.PluginID);
  end
  else if CompareText(FUnloadCommand.Command, cChangeFolder) = 0 then
  begin
    if FActivePlugin.Dllhandle <> 0 then
      Unload;

    BuildNavFromPath(FUnloadCommand.Param)
  end
  else if CompareText(FUnloadCommand.Command, cLoadSetting) = 0 then
  begin

    if FActivePlugin.Dllhandle <> 0 then
      Unload;

    Load(FUnloadCommand.Param,FUnloadCommand.PluginID);
  end;
end;

function TSharpCenterManager.Reload: Boolean;
begin
  Result := Load(FActiveFile, FActivePluginID);
end;

function TSharpCenterManager.Save: Boolean;
var
  iSettingType: Integer;
  n: Integer;
  bClose: Boolean;
begin
  bClose := True;
  if (@FActivePlugin.Close <> nil) then
    bClose := FActivePlugin.Close(True);

  if bClose then
  begin
    iSettingType := 0;
    if (@FActivePlugin.SetSettingType) <> nil then
      iSettingType := FActivePlugin.SetSettingType;

    if TryStrToInt(FActivePluginID, n) then
      n := StrToInt(FActivePluginID)
    else
      n := -1;

    SharpEBroadCast(WM_SHARPEUPDATESETTINGS, iSettingType, n);
  end;

  Result := bClose;
end;

function TSharpCenterManager.BuildNavFromFile(AFile: string): Boolean;
var
  xml: TJvSimpleXML;
  i: Integer;
  pngfile: string;
  s, sDll, sIcon: string;
  sStatus: string;
  sPath: string;

  sFirstNavFile, sFirstPluginID: String;
  newItem: TSharpCenterManagerItem;
begin
  Result := True;
  try

    if Assigned(FOnInitNavigation) then
      FOnInitNavigation(Self);

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

          s := GetDisplayName(sPath + sDll, '');
          sStatus := SCM.GetStatusText(sPath + sDll, '');

          if s = '' then
            newItem.Caption := Items.Item[i].Name
          else
            newItem.Caption := s;

          newItem.Filename := sPath + sDll;
          newItem.PluginID := SCM.ActivePluginID;

          pngfile := sPath + sIcon;
          SCM.AssignIconIndex(pngfile, newItem);

          if Assigned(FOnAddNavItem) then begin
            FOnAddNavItem(newItem);
          end;

          if i = 0 then begin
             sFirstNavFile := newItem.Filename;
             sFirstPluginID := newItem.PluginID;
          end;
        end;
      end;

    finally
      xml.Free;
    end;

  finally
    Load(sFirstNavFile,sFirstPluginID);

  end;
end;

function TSharpCenterManager.BuildNavFromPath(APath: string): Boolean;
var
  SRec: TSearchRec;
  xml:TJvSimpleXML;
  newItem: TSharpCenterManagerItem;

  sName, sIcon, sPng: String;
  iCount: Integer;
begin
  iCount := 0;
  Result := True;

  if Assigned(FOnInitNavigation) then
    FOnInitNavigation(Self);

  try
    SetActiveCommand(cChangeFolder,APath,'');
    APath := PathAddSeparator(APath);

    if FindFirst(APath + '*.*', SysUtils.faAnyFile, SRec) = 0 then
    repeat
      if (sRec.Name = '.') or (sRec.Name = '..') then
        Continue;

      if CompareText(ExtractFileExt(sRec.Name),SCE_CON_EXT) = 0 then
        begin

          xml := TJvSimpleXML.Create(nil);
          try
            Xml.LoadFromFile(APath + sRec.Name);

            if xml.Root.Items.ItemNamed['Default'] <> nil then
            begin
              with xml.Root.Items.ItemNamed['Default'] do
              begin
                if Items.ItemNamed['Name'] <> nil then
                  sName := Items.ItemNamed['Name'].Value;

                if Items.ItemNamed['Icon'] <> nil then
                  sIcon := APath + Items.ItemNamed['Icon'].Value;
              end;
            end
            else
            begin
              sName := PathRemoveExtension(sRec.Name);
              sIcon := APath + PathRemoveExtension(sRec.Name) + '.png';
            end;

          finally
            Xml.Free;
          end;

          newItem := TSharpCenterManagerItem.Create;
          newItem.Caption := sName;
          newItem.ItemType := itmSetting;
          newItem.Filename := APath + sRec.Name;
          sPng := sIcon;
          AssignIconIndex(sPng,newItem);

          if Assigned(FOnAddNavItem) then begin
            FOnAddNavItem(newItem);
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
              FOnAddNavItem(newItem);
              Inc(iCount);
            end;
          end;
        end;
      until
        FindNext(SRec) <> 0;

  finally
    if iCount = 0 then
    begin
      newItem := TSharpCenterManagerItem.Create;
      newItem.Caption := 'No items found';
      newItem.ItemType := itmNone;

      if Assigned(FOnAddNavItem) then begin
        FOnAddNavItem(newItem);
      end;

    end;
  end;
end;

function TSharpCenterManager.ExecuteCommand(ACommand, AParam,
  APluginID: string): Boolean;
begin
  Result := True;
  if CompareText(ACommand, cChangeFolder) = 0 then
  begin
    UnloadDllTimer(cChangeFolder, AParam, APluginID);
  end
  else if CompareText(ACommand, cUnloadDll) = 0 then
  begin
    UnloadDllTimer(cUnloadDll, AParam, APluginID);
  end
  else if CompareText(ACommand, cLoadSetting) = 0 then
  begin
    UnloadDllTimer(cLoadSetting, AParam, APluginID);

  end else begin
    MessageDlg('Unknown command', mtError, [mbOK], 0);
    Result := False;
  end;
end;

function TSharpCenterManager.BuildNavRoot: Boolean;
begin
  History.Clear;
  Result := BuildNavFromPath(FRoot);
end;

procedure TSharpCenterManager.SetStateEditWarning(const Value: Boolean);
begin
  FStateEditWarning := Value;

  if Assigned(FonUpdateTheme) then
    FOnUpdateTheme(Self);
end;

procedure TSharpCenterManager.SetStateEditItem(const Value: Boolean);
begin
  FStateEditItem := Value;

  if Assigned(FonUpdateTheme) then
    FOnUpdateTheme(Self);
end;

function TSharpCenterManager.GetHistory: TSharpCenterHistoryManager;
begin
  Result := FHistory;
end;

constructor TSharpCenterManager.Create;
begin
  // Create the history object
  FHistory := TSharpCenterHistoryManager.Create;

  // Set the active root path
  FRoot := GetCenterDirectory;

  // Create the unload timer
  FUnloadTimer := TTimer.Create(nil);
  FUnloadTimer.OnTimer := UnloadTimerEvent;
  FUnloadTimer.Interval := 1;
  FUnloadTimer.Enabled := False;

  // Set the default active command to the center root
  FActiveCommand := TSharpCenterHistoryItem.Create;
  FUnloadCommand := TSharpCenterHistoryItem.Create;
  FActiveCommand.Command := cChangeFolder;
  FActiveCommand.Param := FRoot;
  FActiveCommand.PluginID := '';

  FPluginTabs := TPluginTabItemList.Create;
  FPngImageList := TPngImageList.Create(nil);
end;

destructor TSharpCenterManager.Destroy;
begin
  FHistory.Free;
  FUnloadTimer.Free;

  inherited;
end;

function TSharpCenterManager.GetRoot: String;
begin
  Result := FRoot;
end;

function TSharpCenterManager.CheckEditState: Boolean;
begin
  Result := False;
  If StateEditItem then begin
    StateEditWarning := True;
    Result := True;
  end;

  if ((StateEditItem) or (StateEditWarning)) then
    Result := True;
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
  end
  else if AItem.ItemType = itmFolder then
     AItem.IconIndex := SCE_ICON_FOLDER
  else
    AItem.IconIndex := SCE_ICON_FOLDER;
end;

procedure TSharpCenterManager.SetActiveCommand(ACommand, AParam, APluginID:String);
begin
  FActiveCommand.Command := ACommand;
  FActiveCommand.Param := AParam;
  FActiveCommand.PluginID := APluginID;
end;

procedure TSharpCenterManager.SetUnloadCommand(ACommand, AParam,
  APluginID: String);
begin
  FUnloadCommand.Command := ACommand;
  FUnloadCommand.Param := AParam;
  FUnloadCommand.PluginID := APluginID;
end;

function TSharpCenterManager.LoadPluginTabs: Boolean;
begin
  FPluginTabs.Clear;
  Result := True;

  if (@ActivePlugin.AddTabs <> nil) then
    ActivePlugin.AddTabs(FPluginTabs);
end;

function TSharpCenterManager.GetDisplayName(AFile, APluginID: string): string;
var
  tmpSetting: Tsetting;
  s: PChar;
begin
  Result := '';

  if fileexists(AFile) then
  begin
    tmpSetting := LoadPlugin(PChar(Afile));

    try
      if @tmpSetting.SetDisplayText <> nil then
      begin
        tmpSetting.SetDisplayText(Pchar(APluginID), s);
        Result := s;
      end;

    finally
      UnloadPlugin(@tmpSetting);
    end;
  end;
end;

function TSharpCenterManager.GetStatusText(AFile,
  APluginID: string): string;
var
  tmpSetting: Tsetting;
  s: PChar;
begin
  Result := '';

  if fileexists(AFile) then
  begin
    tmpSetting := LoadPlugin(PChar(AFile));

    try
      if @tmpSetting.SetStatusText <> nil then
      begin
        tmpSetting.SetStatusText(Pchar(s));
        Result := s;
      end;

    finally
      UnloadPlugin(@tmpSetting);
    end;
  end;
end;

function TSharpCenterManager.LoadEdit(ATabID:Integer): Boolean;
var
  handle:THandle;
begin
  handle := 0;
  Result := True;
  
  if CheckEditState then exit;

  if (@FActivePlugin.OpenEdit <> nil) then begin

      case Integer(ATabID) of
        Integer(tidAdd): handle :=
          FActivePlugin.OpenEdit(EditWndContainer.Handle,sceAdd);
        Integer(tidEdit): handle :=
          FActivePlugin.OpenEdit(EditWndContainer.Handle,sceEdit);
        Integer(tidDelete): handle :=
          FActivePlugin.OpenEdit(EditWndContainer.Handle,sceDelete);
      end;

      if handle <> HR_NORECIEVERWINDOW then begin
        EditWndHandle := handle;
        EditWndContainer.ParentWindow := EditWndHandle;

        if assigned(FOnUpdateTheme) then
          FOnUpdateTheme(Self);
          
        if assigned(FOnLoadEdit) then
          FOnLoadEdit(Self);



      end;
    end;
end;

function TSharpCenterManager.ApplyEdit(ATabID: Integer): Boolean;
var
  bValid: Boolean;
begin
  Result := True;

  if ATabID = integer(tidDelete) then begin
    if (@ActivePlugin.ClickBtn <> nil) then
      ActivePlugin.ClickBtn(SCB_DELETE,'');

      LoadPluginTabs;
      if Assigned(FOnAddPluginTabs) then
        FOnAddPluginTabs(Self);

      exit;
  end;

  bValid := True;
  if (@ActivePlugin.CloseEdit <> nil) then begin

    case ATabID of
      Integer(tidAdd): bValid := ActivePlugin.CloseEdit(sceAdd,True);
      Integer(tidEdit): bValid := ActivePlugin.CloseEdit(sceEdit,True);
      Integer(tidDelete): bValid:= ActivePlugin.CloseEdit(sceDelete,True);
    end;
  end;

  if bValid then begin
    StateEditItem := False;
    StateEditWarning := False;
    EditWndHandle := 0;

    if Assigned(FOnApplyEdit) then
      FOnApplyEdit(Self);

    LoadPluginTabs;
    if Assigned(FOnAddPluginTabs) then
      FOnAddPluginTabs(Self);

  end else begin
    CheckEditState;
    Result := false;
  end;
end;

function TSharpCenterManager.CancelEdit(ATabID: Integer): Boolean;
begin
  Result := True;

  if (@ActivePlugin.CloseEdit <> nil) then
    ActivePlugin.CloseEdit(sceEdit,False);

  if Not(StateEditItem) then begin
    StateEditItem := False;
    StateEditWarning := False;
    EditWndHandle := 0;

    if assigned(FOnCancelEdit) then
      FOnCancelEdit(nil);

    exit;
  end;

  StateEditItem := False;
  StateEditWarning := False;
  EditWndHandle := 0;

  if assigned(FOnCancelEdit) then
    FOnCancelEdit(Self);
end;

{ TSharpCenterManagerItem }

constructor TSharpCenterManagerItem.Create;
begin

end;

initialization
  SCM := TSharpCenterManager.Create;
finalization
  FreeAndNil(SCM);

end.

