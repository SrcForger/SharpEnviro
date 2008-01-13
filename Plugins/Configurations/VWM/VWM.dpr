{
Source Name: VWM.dpr
Description: VWM Module Config Dll
Copyright (C) Martin KrÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¤mer (MartinKraemer@gmx.net)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

library VWM;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  JvSimpleXml,
  GR32,
  GR32_Image,
  PngSpeedButton,
  JvPageList,
  uVistaFuncs,
  SysUtils,
  Graphics,
  uVWMsWnd in 'uVWMsWnd.pas' {frmVWM},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  SharpThemeApi in '..\..\..\Common\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpDialogs in '..\..\..\Common\Libraries\SharpDialogs\SharpDialogs.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas';

{$E .dll}

{$R *.res}

procedure Save;
var
  XML : TJvSimpleXML;
begin
  if frmVWM = nil then
    exit;

  XML := TJvSimpleXML.Create(nil);
  XML.Root.Name := 'VWMModuleSettings';
  with XML.Root.Items, frmVWM do
  begin
    Add('Numbers',cb_numbers.Checked);
    Add('Background',Colors.Items.Item[0].ColorCode);
    Add('Border',Colors.Items.Item[1].ColorCode);
    Add('Foreground',Colors.Items.Item[2].ColorCode);
    Add('Highlight',Colors.Items.Item[3].ColorCode);
    Add('Text',Colors.Items.Item[4].ColorCode);
    Add('BackgroundAlpha',sgb_Background.Value);
    Add('BorderAlpha',sgb_Border.Value);
    Add('ForegroundAlpha',sgb_Foreground.Value);
    Add('HighlightAlpha',sgb_Highlight.Value);
    Add('TextAlpha',sgb_Text.Value);
  end;
  XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmVWM.sBarID),strtoint(frmVWM.sModuleID)));
  XML.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  left,right : String;
  s : string;
  fileloaded : boolean;
begin
  if frmVWM = nil then frmVWM := TfrmVWM.Create(nil);

  s := APluginID;
  left := copy(s, 0, pos(':',s)-1);
  right := copy(s, pos(':',s)+1, length(s) - pos(':',s));
  uVistaFuncs.SetVistaFonts(frmVWM);
  frmVWM.sBarID := left;
  frmVWM.sModuleID := right;
  frmVWM.ParentWindow := aowner;
  frmVWM.Left := 2;
  frmVWM.Top := 2;
  frmVWM.BorderStyle := bsNone;
  result := frmVWM.Handle;

  XML := TJvSimpleXML.Create(nil);
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(left),strtoint(right)));
    fileloaded := True;
  except
  end;

  if fileloaded then
    with XML.Root.Items, frmVWM do
    begin
      cb_numbers.Checked := BoolValue('Numbers',True);
      Colors.Items.Item[0].ColorCode := IntValue('Background',clWhite);
      Colors.Items.Item[1].ColorCode := IntValue('Border',clBlack);
      Colors.Items.Item[2].ColorCode := IntValue('Foreground',clBlack);
      Colors.Items.Item[3].ColorCode := IntValue('Highlight',clWhite);
      Colors.Items.Item[4].ColorCode := IntValue('Text',clBlack);
      sgb_Background.Value := IntValue('BackgroundAlpha',128);
      sgb_Border.Value     := IntValue('BorderAlpha',128);
      sgb_Foreground.Value := IntValue('ForegroundAlpha',64);
      sgb_Highlight.Value  := IntValue('HighlightAlpha',192);
      sgb_Text.Value       := IntValue('TextAlpha',255);
    end;
  XML.Free;

  frmVWM.Show;
end;

function Close : boolean;
begin
  result := True;
  try
    frmVWM.Close;
    frmVWM.Free;
    frmVWM := nil;
  except
    result := False;
  end;
end;


procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
begin
  AName := 'VWM';
  ATitle := 'Virtual Window Manager Module';
  ADescription := 'Configure virtual window manager module';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'VWM';
    Description := 'VWM Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;


exports
  Open,
  Close,
  Save,
  SetText,
  GetMetaData;

begin
end.






