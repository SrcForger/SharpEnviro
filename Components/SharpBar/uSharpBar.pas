unit uSharpBar;

interface

uses
  Messages,
  Windows,
  Classes,
  Math,
  Contnrs,
  SharpApi,
  uSharpXMLUtils,
  SysUtils,
  JclSimpleXML,
  JclFileUtils,
  JclStrings;

type
  TBarItem = class;

  TBarItems = class
  private
    FBars: TObjectList;

  protected
    function GetBar(index: integer): TBarItem;
    function GetCount: Integer;

    procedure Clear;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Update;

    property Bars[index: integer]: TBarItem read GetBar;
    property Count: integer read GetCount;
    
  end;

  TModuleItem = class
  public
    ID: Integer;
    Position: Integer;
    Module: String;
  end;

  TBarItem = class
  private
	  FName: string;
    FBarID: integer;
    FMonitor: integer;
    FPMonitor: boolean;
    FHPos: integer;
    FVPos: integer;
    FAutoStart: boolean;
    FFixedWidthEnabled: boolean;
    FFixedWidth: integer;
    FMiniThrobbers: boolean;
    FDisableHideBar: boolean;
    FShowThrobber: boolean;
    FStartHidden: boolean;
    FAlwaysOnTop: boolean;
    FAutoHide: Boolean;
    FAutoHideTime: integer;
    FForceAlwaysOnTop: Boolean;

    FModules: TObjectList;

    function GetModule(i: integer): TModuleItem;
    function GetModuleCount: integer;

    procedure Init;
    procedure Load(sBarID: integer);

    function FindID(sName: String): integer;
    
  public
    property Name: string read FName write FName;
    property BarID: integer read FBarID write FBarID;
    property Monitor: integer read FMonitor write FMonitor;
    property PMonitor: boolean read FPMonitor write FPMonitor;
    property HPos: integer read FHPos write FHPos;
    property VPos: integer read FVPos write FVPos;
    property AutoStart: boolean read FAutoStart write FAutoStart;
    property FixedWidthEnabled: boolean read FFixedWidthEnabled write FFixedWidthEnabled;
    property FixedWidth: integer read FFixedWidth write FFixedWidth;
    property MiniThrobbers: boolean read FMiniThrobbers write FMiniThrobbers;
    property DisableHideBar: boolean read FDisableHideBar write FDisableHideBar;
    property ShowThrobber: boolean read FShowThrobber write FShowThrobber;
    property StartHidden: boolean read FStartHidden write FStartHidden;
    property AlwaysOnTop: boolean read FAlwaysOnTop write FAlwaysOnTop;
    property AutoHide: Boolean read FAutoHide write FAutoHide;
    property AutoHideTime: integer read FAutoHideTime write FAutoHideTime;
    property ForceAlwaysOnTop: Boolean read FForceAlwaysOnTop write FForceAlwaysOnTop;

    property ModuleCount: integer read GetModuleCount;
    property Modules[index: integer]: TModuleItem read GetModule;

    procedure AddModule(item: TModuleItem);
    procedure RemoveModule(i: integer);

    constructor Create(sBarID: integer = -1); overload;
    constructor Create(sName: String); overload;
    destructor Destroy; override;

    function Save: boolean;

  end;

implementation

function ExtractBarID(ABarXmlFileName: string): Integer;
var
  s: string;
  n: Integer;
begin
  s := PathRemoveSeparator(ExtractFilePath(ABarXmlFileName));
  n := JclStrings.StrLastPos('\', s);
  s := Copy(s, n + 1, length(s));

  if not TryStrToInt(s, Result) then
    Result := -1;
end;

{ TBarItems }
constructor TBarItems.Create;
begin
  FBars := TObjectList.Create(False);

  Update;
end;

destructor TBarItems.Destroy;
begin
  Clear;

  FBars.Free;
end;

procedure TBarItems.Clear;
var
  i : integer;
begin
  for i := 0 to FBars.Count - 1 do
    TBarItem(FBars.Items[i]).Free;

  FBars.Clear;
end;

function TBarItems.GetBar(index: integer): TBarItem;
begin
  Result := TBarItem(FBars.Items[index]);
end;

function TBarItems.GetCount: integer;
begin
  Result := FBars.Count;
end;

procedure TBarItems.Update;
var
  slBars : TStringList;
  i : integer;
  barID: Integer;
  barItem: TBarItem;
begin
  Clear;

  slBars := TStringList.Create;
  AdvBuildFileList(SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\*Bar.xml', faAnyFile, slBars, amAny, [flFullNames, flRecursive]);
  for i := 0 to slBars.Count - 1 do
  begin
    barID := ExtractBarID(slBars[i]);
    if barID = -1 then
      continue;

    barItem := TBarITem.Create(barID);
    FBars.Add(barItem);
  end;
end;


{ TBarItem }
constructor TBarItem.Create(sBarID: Integer);
begin
  FModules := TObjectList.Create(False);

  Init;
  if sBarID = -1 then
    Exit;

  Load(sBarID);
end;

constructor TBarItem.Create(sName: string);
begin
  FModules := TObjectList.Create(True);

  Init;
  Load(FindID(sName));
end;

destructor TBarItem.Destroy;
var
  i : integer;
begin
  for i := 0 to FModules.Count - 1 do
    TModuleItem(FModules.Items[i]).Free;

  FreeAndNil(FModules);
end;

procedure TBarItem.AddModule(item: TModuleItem);
begin
  FModules.Add(TObject(item));
end;

procedure TBarItem.RemoveModule(i: integer);
begin
  TModuleItem(FModules.Items[i]).Free;
  FModules.Remove(FModules.Items[i]);
end;

function TBarItem.GetModule(i: integer): TModuleItem;
begin
  Result := TModuleItem(FModules.Items[i]);
end;

function TBarItem.GetModuleCount: integer;
begin
  if Assigned(FModules) then
    Result := FModules.Count
  else
    Result := 0;
end;

procedure TBarItem.Init;
begin
  FName := '';
  FBarID := 0;
  FMonitor := 0;
  FPMonitor := True;
  FHPos := 0;
  FVPos := 0;
  FAutoStart := True;
  FFixedWidthEnabled := False;
  FFixedWidth := 50;
  FMiniThrobbers := False;
  FDisableHideBar := True;
  FShowThrobber := True;
  FStartHidden := False;
  FAlwaysOnTop := True;
  FAutoHide := False;
  FAutoHideTime := 1000;

  FModules.Clear;
end;

function TBarItem.FindID(sName: string): integer;
var
  slBars : TStringList;
  i : integer;
  xml : TJclSimpleXML;
begin
  Result := -1;

  slBars := TStringList.Create;
  try
  AdvBuildFileList(SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\*bar.xml', faAnyFile, slBars, amAny, [flFullNames, flRecursive]);
  for i := 0 to slBars.Count - 1 do
  begin
    xml := TJclSimpleXML.Create;
    try
      if LoadXMLFromSharedFile(xml, slBars[i]) then
      begin
        if xml.Root.Items.ItemNamed['Settings'] <> nil then
          with xml.Root.Items.ItemNamed['Settings'].Items do
          begin
            if Value('Name', '') = sName then
            begin
              Result := ExtractBarID(slBars[i]);
              exit;
            end;
          end;
      end;
    finally
      xml.Free;
    end;
  end;
  finally
    slBars.Free;
  end;
end;

procedure TBarItem.Load(sBarID: Integer);
var
  xml : TJclSimpleXML;
  j: integer;
  module: TModuleItem;
begin
  if sBarID = -1 then
    exit;

  FBarID := sBarID;

  xml := TJclSimpleXML.Create;
  try
    if LoadXMLFromSharedFile(xml, SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + IntToStr(sBarID) + '\Bar.xml') then
    begin
      if xml.Root.Items.ItemNamed['Settings'] <> nil then
        with xml.Root.Items.ItemNamed['Settings'].Items do
        begin
          FName := Value('Name', 'Toolbar');
          FMonitor := IntValue('MonitorIndex', 0);
          FPMonitor := BoolValue('PrimaryMonitor', True);
          FHPos := IntValue('HorizPos', 0);
          FVPos := IntValue('VertPos', 0);
          FAutoStart := BoolValue('AutoStart', True);
          FFixedWidthEnabled := BoolValue('FixedWidthEnabled', False);
          FFixedWidth := Min(90,Max(10,IntValue('FixedWidth', 50)));
          FMiniThrobbers := BoolValue('ShowMiniThrobbers', False);
          FDisableHideBar := BoolValue('DisableHideBar', True);
          FShowThrobber := BoolValue('ShowThrobber', True);
          FStartHidden := BoolValue('StartHidden', False);
          FAlwaysOnTop := BoolValue('AlwaysOnTop', True);
          FAutoHide := BoolValue('AutoHide', False);
          FAutoHideTime := IntValue('AutoHideTime', 1000);
        end;

        FModules.Clear;
        if xml.Root.Items.ItemNamed['Modules'] <> nil then
          with xml.Root.Items.ItemNamed['Modules'] do
          begin
            for j := 0 to Pred(Items.Count) do
            begin
              module := TModuleItem.Create;
              module.ID := Items.Item[j].Items.IntValue('ID', 0);
              module.Position := Items.Item[j].Items.IntValue('Position', 0);
              module.Module := Items.Item[j].Items.Value('Module', '');
              FModules.Add(module);
            end;
          end;
    end;
  finally
    xml.Free;
  end;
end;

function TBarItem.Save: boolean;
var
  xml: TJclSimpleXML;
  i: integer;
begin
  Result := False;

  xml := TJclSimpleXML.Create;
  xml.Root.Name := 'SharpBar';
  try
    with xml.Root.Items do
    begin
      with Add('Settings').Items do
      begin
        Add('Name', FName);
        Add('AutoPosition', True);
        Add('ShowThrobber', FShowThrobber);
        Add('DisableHideBar', FDisableHideBar);
        Add('AutoStart', FAutoStart);
        Add('AutoPosition', True);
        Add('StartHidden', FStartHidden);
        Add('MiniThrobbers', FMiniThrobbers);
        Add('PrimaryMonitor', FPMonitor);
        Add('MonitorIndex', FMonitor);
        Add('HorizPos', FHPos);
        Add('VertPos', FVPos);
        Add('FixedWidth', FFixedWidth);
        Add('FixedWidthEnabled', FFixedWidthEnabled);
        Add('ShowMiniThrobbers', FMiniThrobbers);
        Add('AlwaysOnTop', FAlwaysOnTop);
        Add('AutoHide', FAutoHide);
        Add('AutoHideTime', FAutoHideTime);
      end;

      with Add('Modules').Items do
        for i := 0 to FModules.Count - 1 do
        begin
          with Add('Item').Items do
          begin
            Add('ID', TModuleItem(FModules.Items[i]).ID);
            Add('Position', TModuleItem(FModules.Items[i]).Position);
            Add('Module', TModuleItem(FModules.Items[i]).Module);
          end;
        end;
    end;

    ForceDirectories(SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + IntToStr(FBarID));
    SaveXMLToSharedFile(xml, SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(FBarID) + '\Bar.xml', True);
  finally
    xml.Free;
  end;
end;

end.
