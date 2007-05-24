{
Source Name: BarPreview.pas
Description: SharpE Bar Preview Rendering
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
 - OS : Windows 2000 or higher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit BarPreview;

interface

uses SharpApi, SharpThemeApi, Math, GR32, JvSimpleXML, BarForm, SharpEBar,
     Windows, SysUtils, Dialogs;

procedure CreateBarPreview(ABitmap : TBitmap32; pSkin,pScheme : String; Width : integer); overload;
procedure CreateBarPreview(ABitmap : TBitmap32; pSkin : String; pSchemeList: TSharpEColorSet; Width : integer); overload;

implementation

procedure CreateBarPreview(ABitmap : TBitmap32; pSkin : String; pSchemeList: TSharpEColorSet; Width : integer);
var
  BarWnd: TBarWnd;
  Dir : String;
  skinfile : String;
  colorvalue : String;
  colorint   : integer;
  XML : TJvSimpleXML;
  n : integer;
  ThrobberPos : TPoint;
  ButtonPos : TPoint;
begin
  try
    XML := TJvSimpleXML.Create(nil);

    BarWnd := TBarWnd.Create(nil);
    Dir := SharpApi.GetSharpeDirectory;
    skinfile := Dir + 'Skins\' + pSkin + '\skin.xml';
    if FileExists(skinfile) then BarWnd.SharpESkin1.LoadFromXmlFile(skinfile);
    BarWnd.SharpEScheme1.ClearColors;
    for n := 0 to High(pSchemeList) do
        BarWnd.SharpEScheme1.AddColor(pSchemeList[n]);

    ThrobberPos := Point(BarWnd.SkinManager.Skin.BarSkin.ThDim.XAsInt,
                         BarWnd.SkinManager.Skin.BarSkin.ThDim.YAsInt);
    ButtonPos := Point(BarWnd.SkinManager.Skin.BarSkin.PAXoffset.XAsInt+8,
                       BarWnd.SkinManager.Skin.BarSkin.PAYoffset.XAsInt+BarWnd.SkinManager.Skin.ButtonSkin.SkinDim.YAsInt);

    BarWnd.Left := -100;
    BarWnd.Top := -100;
    BarWnd.Width := width;

    BarWnd.SharpEBar1.UpdateSkin;
    ShowWindow(BarWnd.SharpEBar1.abackground.handle,SW_HIDE);
    ABitmap.SetSize(max(width,1),BarWnd.SkinManager.Skin.BarSkin.SkinDim.HeightAsInt);
    ABitmap.Clear(color32(0,0,0,0));
    BarWnd.SharpEBar1.VertPos := vpTop;
    BarWnd.SharpEBar1.UpdateSkin;
    BarWnd.SharpEBar1.Skin.DrawTo(ABitmap,0,0);
    BarWnd.SharpEBar1.Throbber.UpdateSkin;
    BarWnd.SharpEBar1.Throbber.Skin.DrawTo(ABitmap,
                                           ThrobberPos.X,
                                           ThrobberPos.Y);
    BarWnd.Button.UpdateSkin;
    BarWnd.Button.Skin.DrawTo(ABitmap,ButtonPos.X,ButtonPos.Y);
  finally
    XML.Free;
    FreeAndNil(barWnd);
  end;
end;

procedure CreateBarPreview(ABitmap : TBitmap32; pSkin,pScheme : String; Width : integer);
var
  BarWnd: TBarWnd;
  Dir : String;
  skinfile : String;
  schemefile : String;
  colorvalue : String;
  colorint   : integer;
  XML : TJvSimpleXML;
  n : integer;
  throbberpos : TPoint;
  buttonpos : TPoint;
  st : TSharpESchemeType;
  s : String;
begin
  try
    XML := TJvSimpleXML.Create(nil);

    BarWnd := TBarWnd.Create(nil);
    Dir := SharpApi.GetSharpeDirectory;
    skinfile := Dir + 'Skins\' + pSkin + '\skin.xml';
    if FileExists(skinfile) then BarWnd.SharpESkin1.LoadFromXmlFile(skinfile);
    schemefile := Dir + 'Skins\' + pSkin + '\Schemes\' + pScheme;
    if not FileExists(schemefile) then schemefile := Dir + 'Skins\' + pSkin + '\scheme.xml';
    if FileExists(schemefile) then
    try
      BarWnd.SharpEScheme1.ClearColors;
      XML.LoadFromFile(schemefile);
      for n := 0 to XML.Root.Items.Count - 1 do
          with XML.Root.Items.Item[n].Items do
          begin
            if ItemNamed['Default'] <> nil then
               colorvalue := Value('Default','0')
               else colorvalue := Value('Color','0');
            colorint := SharpThemeApi.ParseColor(PChar(colorvalue));
            s := Value('type','color');
            if CompareText(s,'boolean') = 0 then
               st := stBoolean
               else if CompareText(s,'integer') = 0 then
                    st := stInteger
                    else st := stColor;
            BarWnd.SharpEScheme1.AddColor('temp',Value('Tag','temp'),'temp',colorint,st);
          end;
    except
    end;

    ThrobberPos := Point(BarWnd.SkinManager.Skin.BarSkin.ThDim.XAsInt,
                         BarWnd.SkinManager.Skin.BarSkin.ThDim.YAsInt);
    ButtonPos := Point(BarWnd.SkinManager.Skin.BarSkin.PAXoffset.XAsInt+8,
                       BarWnd.SkinManager.Skin.BarSkin.PAYoffset.XAsInt+BarWnd.SkinManager.Skin.ButtonSkin.SkinDim.YAsInt);

    BarWnd.Left := -100;
    BarWnd.Top := -100;
    BarWnd.Width := width;

    BarWnd.SharpEBar1.UpdateSkin;
    ShowWindow(BarWnd.SharpEBar1.abackground.handle,SW_HIDE);
    ABitmap.SetSize(max(width,1),BarWnd.SkinManager.Skin.BarSkin.SkinDim.HeightAsInt);
    ABitmap.Clear(color32(0,0,0,0));
    BarWnd.SharpEBar1.VertPos := vpTop;
    BarWnd.SharpEBar1.UpdateSkin;
    BarWnd.SharpEBar1.Skin.DrawTo(ABitmap,0,0);
    BarWnd.SharpEBar1.Throbber.UpdateSkin;
    BarWnd.SharpEBar1.Throbber.Skin.DrawTo(ABitmap,
                                           ThrobberPos.X,
                                           ThrobberPos.Y);
    BarWnd.Button.UpdateSkin;
    BarWnd.Button.Skin.DrawTo(ABitmap,ButtonPos.X,ButtonPos.Y);
  finally
    XML.Free;
    FreeAndNil(barWnd);
  end;
end;

end.
