{
Source Name: BarPreview.pas
Description: SharpE Bar Preview Rendering
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit BarPreview;

interface

uses SharpApi, Types, SharpThemeApi, Math, GR32, JvSimpleXML, BarForm, SharpEBar,
     Windows, SysUtils, Dialogs, Graphics, uSharpEMenu, uSharpEMenuSettings;

procedure CreateBarPreview(ABitmap : TBitmap32; pTheme,pSkin,pScheme : String; Width : integer); overload;
procedure CreateBarPreview(ABitmap : TBitmap32; pTheme,pSkin : String; pSchemeList: TSharpEColorSet; Width : integer; drawbg : boolean = true); overload;

implementation

procedure CreateBarPreview(ABitmap : TBitmap32; pTheme,pSkin : String; pSchemeList: TSharpEColorSet; Width : integer; drawbg : boolean = true);
const
  csize = 12;
var
  BarWnd: TBarWnd;
  Dir : String;
  skinfile : String;
  themeskinfile : String;
  XML : TJvSimpleXML;
  n : integer;
  ThrobberPos : TPoint;
  ButtonPos : TPoint;
  x,y : integer;
  menu : TSharpEMenu;
  menusettings : TSharpEMenuSettings;
  menubmp : TBitmap32;
begin
  menuBmp := TBitmap32.Create;
  XML := TJvSimpleXML.Create(nil);
  try
    BarWndUseMenu := True;
    BarWnd := TBarWnd.Create(nil);
    Dir := SharpApi.GetSharpeDirectory;
    skinfile := Dir + 'Skins\' + pSkin + '\skin.xml';
    themeskinfile := SharpThemeApi.GetThemeDirectory(PChar(pTheme)) + 'skin.xml';
    if FileExists(skinfile) then BarWnd.SkinComp.LoadFromXmlFile(skinfile);
    BarWnd.SharpEScheme1.ClearColors;
    for n := 0 to High(pSchemeList) do
        BarWnd.SharpEScheme1.AddColor(pSchemeList[n]);

    BarWnd.SkinComp.UpdateDynamicProperties(BarWnd.SharpEScheme1);

    ThrobberPos := Point(BarWnd.SkinManager.Skin.BarSkin.ThDim.XAsInt,
                         BarWnd.SkinManager.Skin.BarSkin.ThDim.YAsInt);
    ButtonPos := Point(BarWnd.SkinManager.Skin.BarSkin.PAXoffset.XAsInt+8,
                       BarWnd.SkinManager.Skin.BarSkin.PAYoffset.XAsInt+BarWnd.SkinManager.Skin.ButtonSkin.SkinDim.YAsInt);

    // Draw Menu
    menuBmp.DrawMode := dmBlend;
    menuBmp.CombineMode := cmMerge;
    menusettings := TSharpEMenuSettings.Create;
    menusettings.CacheIcons := False;
    menusettings.WrapMenu := False;
    menu := TSharpEMenu.Create(BarWnd.SkinManager,menusettings);
    menu.AddLabelItem('SharpE Menu',False);
    menu.AddSeparatorItem(False);
    menu.AddSubMenuItem('Sub Menu','','',False);
    menu.AddLinkItem('Menu Item','','',False);
    menu.RenderTo(menuBmp,0,0,ABitmap);

    BarWnd.Left := -100;
    BarWnd.Top := -100;
    BarWnd.Width := width - menuBmp.Width - 32;       

    BarWnd.SharpEBar1.UpdateSkin;
    ShowWindow(BarWnd.SharpEBar1.abackground.handle,SW_HIDE);
    ABitmap.SetSize(max(width,1)+2*csize,max(BarWnd.SkinManager.Skin.BarSkin.SkinDim.HeightAsInt,menuBmp.Height)+2*csize);
    ABitmap.Clear(color32(255,0,254,0));

    if drawbg then
       with BarWnd.Background do
       begin
         SetSize(ABitmap.Width + 3*csize,ABitmap.Height + 3*csize);
         Clear(color32(clsilver));
         for x := 0 to (ABitmap.Width + 2*csize) div (2 * csize) do
             for y := 0 to (ABitmap.Height + 2*csize) div (csize) do
                 if y mod 2 = 0 then
                    FillRect(2*x*csize,y*csize,2*x*csize + csize,y*csize + csize,clWhite32)
                 else FillRect(2*x*csize + csize,y*csize,2*x*csize + 2*csize,y*csize + csize,clWhite32);
         DrawTo(ABitmap,-round(1.5*csize),-round(1.5*csize));
       end else BarWnd.Background.Clear(color32(0,0,0,0));

    menuBmp.Clear(color32(0,0,0,0));
    menu.RenderTo(menuBmp,0,0,ABitmap);

    try
      XML.LoadFromFile(themeskinfile);
      with XML.Root.Items do
      begin
         BarWnd.ApplyGlassEffect(IntValue('GEBlurRadius',2),
                                 IntValue('GEBlurIterations',2),
                                 BoolValue('GEBlend',False),
                                 IntValue('GEBlendColor',clblue),
                                 IntValue('GEBlendAlpha',32),
                                 BoolValue('GELighten',True),
                                 IntValue('GELightenAmount',23));
      end;
    except
    end;

    BarWnd.SharpEBar1.VertPos := vpTop;
    BarWnd.SharpEBar1.UpdateSkin;
    BarWnd.SharpEBar1.abackground.Skin.Drawto(ABitmap,round(1.5*csize),round(1.5*csize));
    BarWnd.SharpEBar1.Skin.DrawTo(ABitmap,round(1.5*csize),round(1.5*csize));
    BarWnd.SharpEBar1.Throbber.UpdateSkin;
    BarWnd.SharpEBar1.Throbber.Skin.DrawTo(ABitmap,
                                           ThrobberPos.X + round(1.5*csize),
                                           ThrobberPos.Y + round(1.5*csize));
    BarWnd.Button.UpdateSkin;

    BarWnd.Button.Skin.DrawTo(ABitmap,ButtonPos.X + round(1.5*csize),ButtonPos.Y+round(1.5*csize));

    menuBmp.DrawTo(ABitmap,ABitmap.Width - menuBmp.Width - 24,ABitmap.Height div 2 - menuBmp.Height div 2);

  finally
    XML.Free;
    menuBmp.Free;
    if menu <> nil then
       FreeAndNil(menu);
    if menusettings <> nil then
       FreeAndNil(menusettings);
    if barWnd <> nil then
       FreeAndNil(barWnd);
    FreeAndNil(SharpEMenuPopups);
    setlength(pSchemeList,0);
  end;
end;

procedure CreateBarPreview(ABitmap : TBitmap32; pTheme,pSkin,pScheme : String; Width : integer);
const
  csize = 12;
var
  BarWnd: TBarWnd;
  Dir : String;
  skinfile : String;
  schemefile : String;
  themeskinfile : String;
  colorvalue : String;
  colorint   : integer;
  XML : TJvSimpleXML;
  n : integer;
  throbberpos : TPoint;
  buttonpos : TPoint;
  st : TSharpESchemeType;
  s : String;
  x,y : integer;
begin
  XML := TJvSimpleXML.Create(nil);
  try
    

    BarWndUseMenu := False;
    BarWnd := TBarWnd.Create(nil);
    Dir := SharpApi.GetSharpeDirectory;
    skinfile := Dir + 'Skins\' + pSkin + '\skin.xml';
    themeskinfile := SharpThemeApi.GetThemeDirectory(PChar(pTheme)) + 'skin.xml';
    if FileExists(skinfile) then BarWnd.SkinComp.LoadFromXmlFile(skinfile);
    //schemefile := Dir + 'Skins\' + pSkin + '\Schemes\' + pScheme;
    //if not FileExists(schemefile) then
    schemefile := Dir + 'Skins\' + pSkin + '\scheme.xml';
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

    BarWnd.SkinComp.UpdateDynamicProperties(BarWnd.SharpEScheme1);

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

       with BarWnd.Background do
       begin
         SetSize(ABitmap.Width + 3*csize,ABitmap.Height + 3*csize);
         Clear(color32(clsilver));
         for x := 0 to (ABitmap.Width + 2*csize) div (2 * csize) do
             for y := 0 to (ABitmap.Height + 2*csize) div (csize) do
                 if y mod 2 = 0 then
                    FillRect(2*x*csize,y*csize,2*x*csize + csize,y*csize + csize,clWhite32)
                 else FillRect(2*x*csize + csize,y*csize,2*x*csize + 2*csize,y*csize + csize,clWhite32);
         DrawTo(ABitmap,-round(1.5*csize),-round(1.5*csize));
       end;

    if BarWnd.SkinManager.Skin.BarSkin.GlassEffect then
    begin
      try
        XML.LoadFromFile(themeskinfile);
        with XML.Root.Items do
        begin
           BarWnd.ApplyGlassEffect(IntValue('GEBlurRadius',2),
                                   IntValue('GEBlurIterations',2),
                                   BoolValue('GEBlend',False),
                                   IntValue('GEBlendColor',clblue),
                                   IntValue('GEBlendAlpha',32),
                                   BoolValue('GELighten',True),
                                   IntValue('GELightenAmount',23));
        end;
      except
      end;
    end;

    BarWnd.SharpEBar1.VertPos := vpTop;
    BarWnd.SharpEBar1.UpdateSkin;
    BarWnd.SharpEBar1.abackground.Skin.Drawto(ABitmap,0,0);
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
