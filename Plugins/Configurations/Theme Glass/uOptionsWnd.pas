{
Source Name: uOptionsWnd.pas
Description: Options Window
Copyright (C) Lee Green (lee@sharpenviro.com)

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

unit uOptionsWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Contnrs,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ImgList,
  PngImageList,
  JvSimpleXml,

  SharpEListBoxEx,
  SharpEColorEditorEx,
  SharpEColorEditor,
  SharpEGaugeBoxEdit,
  ExtCtrls,
  JvExStdCtrls,
  JvCheckBox,
  SharpESwatchManager;

type
  TfrmOptions = class(TForm)
    sceGlassOptions: TSharpEColorEditorEx;
    SharpESwatchManager1: TSharpESwatchManager;
    procedure FormShow(Sender: TObject);
    procedure sceGlassOptionsUiChange(Sender: TObject);
  private
    FPluginID: string;
    FUpdating: boolean;
  public
    procedure AddOptions;
    procedure Save;
    property PluginID: string read FPluginID write FPluginID;
  end;

var
  frmOptions: TfrmOptions;

implementation

uses SharpThemeApi,
  SharpCenterApi, SharpApi;

{$R *.dfm}

{ TfrmOptions }

procedure TfrmOptions.AddOptions;
var
  tmpItem: TSharpEColorEditorExItem;
var
  XML: TJvSimpleXML;
  sSkinFile: string;
begin
  FUpdating := True;
  XML := TJvSimpleXML.Create(nil);
  sceGlassOptions.BeginUpdate;
  try

    sSkinFile := XmlGetSkinFile(FPluginID);
    if FileExists(XmlGetSkinFile(FPluginID)) then begin
      XML.LoadFromFile(XmlGetSkinFile(FPluginID));
      with XML.Root.Items do begin

        tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
        tmpItem.Title := 'Blur Radius';
        tmpItem.Description := 'Adjust this value to define the glass blur effect';
        tmpItem.ValueText := 'Blur Radius: ';
        tmpItem.ValueEditorType := vetValue;
        tmpItem.ValueMax := 10;
        tmpItem.Value := IntValue('GEBlurRadius', 1);

        tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
        tmpItem.Title := 'Blur Iterations';
        tmpItem.Description := 'Adjust this value to define the blur iterations';
        tmpItem.ValueText := 'Blur Amount: ';
        tmpItem.ValueEditorType := vetValue;
        tmpItem.ValueMax := 5;
        tmpItem.Value := IntValue('GEBlurIterations', 3);

        tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
        tmpItem.Title := 'Blend';
        tmpItem.Description := 'Enable blend options?';
        tmpItem.ValueEditorType := vetBoolean;
        tmpItem.Value := IntValue('GEBlend', 0);

        tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
        tmpItem.Title := 'Blend Color';
        tmpItem.ValueEditorType := vetColor;
        tmpItem.Value := IntValue('GEBlendColor', clWhite);

        tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
        tmpItem.Title := 'Blend Transparecy';
        tmpItem.Description := 'Adjust this value to define the blend transparency';
        tmpItem.ValueText := 'Blend Amount: ';
        tmpItem.ValueEditorType := vetValue;
        tmpItem.ValueMax := 255;
        tmpItem.Value := IntValue('GEBlendAlpha', 32);

        tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
        tmpItem.Title := 'Lighten';
        tmpItem.Description := 'Enable lighten options?';
        tmpItem.ValueEditorType := vetBoolean;
        tmpItem.Value := IntValue('GELighten', 1);

        tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
        tmpItem.Title := 'Lighten Transparency';
        tmpItem.Description := 'Adjust this value to define the lighten transparency';
        tmpItem.ValueText := 'Lighten Amount: ';
        tmpItem.ValueEditorType := vetValue;
        tmpItem.ValueMax := 255;
        tmpItem.Value := IntValue('GELightenAmount', 32);

      end;
    end;
  finally
    XML.Free;
    FUpdating := False;
    sceGlassOptions.EndUpdate;
  end;
end;

procedure TfrmOptions.FormShow(Sender: TObject);
begin
  AddOptions;
end;

procedure TfrmOptions.Save;
var
  tmpItem: TSharpEColorEditorExItem;
var
  XML: TJvSimpleXML;
  sSkinFile: string;
begin
  XML := TJvSimpleXML.Create(nil);
  try

    sSkinFile := XmlGetSkinFile(FPluginID);
    if FileExists(XmlGetSkinFile(FPluginID)) then begin

    Xml.Root.Name := 'SharpEThemeSkin';

      with XML.Root.Items do begin

        Add('Skin',XmlGetSkin(FPluginID));
        Add('GEBlurRadius',sceGlassOptions.Items.Item[0].Value);
        Add('GEBlurIterations',sceGlassOptions.Items.Item[1].Value);
        Add('GEBlend',sceGlassOptions.Items.Item[2].Value);
        Add('GEBlendColor',sceGlassOptions.Items.Item[3].Value);
        Add('GEBlendAlpha',sceGlassOptions.Items.Item[4].Value);
        Add('GELighten',sceGlassOptions.Items.Item[5].Value);
        Add('GELightenAmount',sceGlassOptions.Items.Item[6].Value);
      end;

    end;
  finally
    XML.SaveToFile(sSkinFile);
    XML.Free;
  end;
end;

procedure TfrmOptions.sceGlassOptionsUiChange(Sender: TObject);
begin
  if Not(FUpdating) then begin
    Save;
    BroadcastGlobalUpdateMessage(suScheme, 0);
  end;
end;

end.

