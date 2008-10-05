unit uSharpBarInterface;

interface

uses
  Windows,SharpApi,JclSimpleXML,SysUtils,
  uISharpBar, uSharpEModuleManager;

type
  TSharpBarInterface = class(TInterfacedObject, ISharpBar)
    private
      FBarID : integer;
      FBarWnd : hwnd;
    public
      ModuleManager : TModuleManager;

      // ISharpBar Interface
      procedure UpdateModuleSize; stdcall;
      function GetModuleXMLFile(ModuleID : integer) : String; stdcall;

      function GetBarID : integer; stdcall;
      procedure SetBarID(Value : integer);
      property BarID : integer read GetBarID write SetBarID;

      function GetBarWnd : hwnd; stdcall;
      procedure SetBarWnd(Value : hwnd);
      property BarWnd : hwnd read GetBarWnd write SetBarWnd;
  end;

implementation

{ TSharpBarInterface }

function TSharpBarInterface.GetBarID: integer;
begin
  result := FBarID;
end;

function TSharpBarInterface.GetBarWnd: hwnd;
begin
  result := FBarWnd;
end;

function TSharpBarInterface.GetModuleXMLFile(ModuleID: integer): String;
var
  Dir : String;
  XML : TJclSimpleXML;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(ModuleManager.BarID) + '\';
  if not FileExists(Dir + inttostr(ModuleID) + '.xml') then
  begin
    ForceDirectories(Dir);
    XML := TJclSimpleXML.Create;
    XML.Root.Name := 'ModuleSettings';
    XML.SaveToFile(Dir + inttostr(ModuleID) + '.xml');
  end;
  result := Dir + inttostr(ModuleID) + '.xml';
end;

procedure TSharpBarInterface.SetBarID(Value: integer);
begin
  FBarID := Value;
end;

procedure TSharpBarInterface.SetBarWnd(Value: hwnd);
begin
  FBarWnd := Value;
end;

procedure TSharpBarInterface.UpdateModuleSize;
begin
  if ModuleManager <> nil then
    ModuleManager.ReCalculateModuleSize(True);
end;

end.
