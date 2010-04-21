unit uSharpBarInterface;

interface

uses
  Windows,SharpApi,JclSimpleXML,SysUtils, SharpTypes,
  uISharpBar, uSharpEModuleManager, Classes;

type
  TSharpBarInterface = class(TInterfacedObject, ISharpBar)
    private
      FBarID : integer;
      FBarWnd : hwnd;
    public
      ModuleManager : TModuleManager;

      // ISharpBar Interface
      function  GetModuleWindows(pFileName : String) : String; stdcall;
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

function TSharpBarInterface.GetModuleWindows(pFileName : String) : String;
var
  n : integer;
  temp : TModule;
  List : TStringList;
begin
  result := '';
  List := TStringList.Create;
  for n := 0 to ModuleManager.Modules.Count - 1 do
  begin
    temp := TModule(ModuleManager.Modules.Items[n]);
    if compareText(ExtractFileName(temp.ModuleFile.FileName),pFileName) = 0 then
      List.Add(inttostr(temp.mInterface.Form.Handle));
  end;
  result := List.CommaText;
  List.Free;
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
    try
      XML.Root.Name := 'ModuleSettings';
      XML.SaveToFile(Dir + inttostr(ModuleID) + '.xml');
    finally
      XML.Free;
    end;
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
  // try/except to prevent "not enough storage is available to process this command"
  // error message which can happen when bringin the computer back from hibernation
  try
    if ModuleManager <> nil then
      ModuleManager.ReCalculateModuleSize(True);
  except
  end;
end;

end.
