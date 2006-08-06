unit uSharpCenterCommon;

interface

uses
  Windows,
  dialogs,
  shellapi,
  graphics,
  PngSpeedButton,
  Classes,
  sharpapi,
  Tabs,
  PngImageList,
  PngImage,
  SysUtils,
  JvSimpleXml;

procedure LoadCenterDefines(var ThemesDir, ModulesDir, ObjectsDir: string);

implementation

procedure LoadCenterDefines(var ThemesDir, ModulesDir, ObjectsDir: string);
var
  xml: TJvSimpleXML;
  fn, dir: string;
begin
  dir := GetCenterDirectory;
  fn := dir + 'config.xml';

  if not (FileExists(fn)) then begin
    ObjectsDir := dir + 'Objects';
    ModulesDir := dir + 'Modules';
    ThemesDir := dir + 'Themes';
  end
  else begin

    xml := TJvSimpleXml.Create(nil);
    try
      xml.LoadFromFile(fn);

      with xml.Root.Items.ItemNamed['Defines'] do begin
        ThemesDir := dir + Items.ItemNamed['Themes'].Value;
        ModulesDir := dir + Items.ItemNamed['Modules'].Value;
        ObjectsDir := dir + Items.ItemNamed['Objects'].Value;

      end;
    finally
      xml.Free;
    end;
  end;
end;

end.

