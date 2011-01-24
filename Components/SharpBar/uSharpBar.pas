unit uSharpBar;

interface

uses
  Messages,
  Windows,
  Classes,
  Math,
  SharpApi,
  SysUtils,
  JclSimpleXml,
  JclFileUtils,
  JclStrings;

type
  TBarItem = class
  public
    Name: string;
    BarID: integer;
    Monitor: integer;
    PMonitor: boolean;
    HPos: integer;
    VPos: integer;
    AutoStart: boolean;
    ModuleCount: Integer;
    Modules: string;
    FixedWidthEnabled: boolean;
    FixedWidth: integer;
    MiniThrobbers: boolean;
    DisableHideBar: boolean;
    ShowThrobber: boolean;
    StartHidden: boolean;
    AlwaysOnTop: boolean;
    AutoHide: Boolean;
    AutoHideTime: integer;
    ForceAlwaysOnTop: Boolean;

    constructor Create(BarID: integer = -1);

  end;

implementation

constructor TBarItem.Create(BarID: Integer);
var
  xml : TJclSimpleXML;
  slModules: TStringList;
  dir : string;
  j: integer;
begin
  if BarID = -1 then
  begin
    Name := 'Toolbar';
    Self.BarID := 0;
    Monitor := 0;
    PMonitor := True;
    HPos := 0;
    VPos := 0;
    AutoStart := True;
    FixedWidthEnabled := False;
    FixedWidth := 50;
    MiniThrobbers := False;
    DisableHideBar := True;
    ShowThrobber := True;
    StartHidden := False;
    AlwaysOnTop := True;
    AutoHide := False;
    AutoHideTime := 1000;

    Exit;
  end;

  xml := TJclSimpleXML.Create;
  slModules := TStringList.Create;
  try
    // build list of bar.xml files
    dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

    xml.LoadFromFile(dir + IntToStr(BarID) + '\Bar.xml');
    if xml.Root.Items.ItemNamed['Settings'] <> nil then
      with xml.Root.Items.ItemNamed['Settings'].Items do
      begin
        Name := Value('Name', 'Toolbar');
        Self.BarID := BarID;
        Monitor := IntValue('MonitorIndex', 0);
        PMonitor := BoolValue('PrimaryMonitor', True);
        HPos := IntValue('HorizPos', 0);
        VPos := IntValue('VertPos', 0);
        AutoStart := BoolValue('AutoStart', True);
        FixedWidthEnabled := BoolValue('FixedWidthEnabled', False);
        FixedWidth := Min(90,Max(10,IntValue('FixedWidth', 50)));
        MiniThrobbers := BoolValue('ShowMiniThrobbers', False);
        DisableHideBar := BoolValue('DisableHideBar', True);
        ShowThrobber := BoolValue('ShowThrobber', True);
        StartHidden := BoolValue('StartHidden', False);
        AlwaysOnTop := BoolValue('AlwaysOnTop', True);
        AutoHide := BoolValue('AutoHide', False);
        AutoHideTime := IntValue('AutoHideTime', 1000);
      end;

      slModules.Clear;
      if xml.Root.Items.ItemNamed['Modules'] <> nil then
        with xml.Root.Items.ItemNamed['Modules'] do
        begin
          ModuleCount := Items.Count;
          for j := 0 to Pred(Items.Count) do
          begin
            if Items.Item[j].Items.Value('Module') <> '' then
              slModules.Add(PathRemoveExtension(Items.Item[j].Items.Value('Module')))
          end;

          if slModules.Count <> 0 then
            Modules := slModules.CommaText;
        end;
  finally
    xml.Free;
    slModules.Free;
  end;
end;

end.
