{
Source Name: uSharpDeskTThemeSettings.pas
Description: TThemeSettings class
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

unit uSharpDeskTThemeSettings;

interface

uses
    Dialogs,
    Windows,
    Classes,
    Graphics,
    SysUtils,
    JvSimpleXML,
    Forms,
    Contnrs,
    SharpApi,
    uSharpDeskSharpETheme;

type
   // TWallpaperAlign = (waTile,waCenter,waStretch,waScale);



    TThemeSettings = class (TObjectList)
                     private
                       XML :TJvSimpleXML;                     
                       FFileName : String;
                       procedure FreeThemes;
                     public
                       constructor Create; overload;
                       constructor Create(pFileName : String); overload;
                       destructor Destroy; override;
                       procedure ReloadThemes; overload;
                       procedure ReloadThemes(pFileName : String); overload;
                       procedure SaveThemes; overload;
                       procedure SaveThemes(pFileName : String); overload;
                       procedure DeleteTheme(ID : integer; Save : boolean);
                       procedure CreateXMLFile(pFileName : String);
                       function NewTheme : TSharpETheme;
                       function GetThemeByID(ID : integer) : TSharpETheme;
                     published
                     end;



implementation



constructor TThemeSettings.Create(pFileName : String);
begin
  inherited Create;
  XML := TJvSimpleXML.Create(nil);
  Count := 0;
  FFileName := pFileName;
end;



constructor TThemeSettings.Create;
begin
  inherited Create;
  XML := TJvSimpleXML.Create(nil);
  FFileName := GetSharpeGlobalSettingsPath + 'SharpTheme\Themes.xml';
end;



destructor TThemeSettings.Destroy;
begin
  XML.Free;
  Clear;
  inherited Destroy;
end;



procedure TThemeSettings.CreateXMLFile;
var
   n : integer;
   newFile : String;
begin
  if FileExists(FFileName) then
  begin
    n := 1;
    while FileExists(FFileName + 'backup#' + inttostr(n)) do n := n + 1;
    NewFile := FFileName + 'backup#' + inttostr(n);
    CopyFile(PChar(FFileName),PChar(NewFile),True);
    SharpApi.SendDebugMessageEx('ThemeControler',PChar('Old file backup :' + NewFile),clblue,DMT_INFO);
  end;
  Clear;
  NewTheme;
  ForceDirectories(ExtractFileDir(FFileName));
  XML.Root.Clear;
  XML.Root.Name := 'SharpTheme';
  XML.Root.Items.Add('Themes');
  SaveThemes(FFileName);
  Clear;
  ReloadThemes(FFileName);
end;



procedure TThemeSettings.SaveThemes;
begin
  SaveThemes(FFileName);
end;

procedure TThemeSettings.SaveThemes(pFileName : String);
var
   n,i,k : integer;
   Theme : TSharpETheme;
begin
  XML.Root.Items.ItemNamed['Themes'].Items.Clear;
  for n:=0 to self.Count-1 do
  begin
    Theme := TSharpETheme(Items[n]);
    with Theme do
    begin
      XML.Root.Items.ItemNamed['Themes'].Items.Add(inttostr(Theme.ThemeID));
      with XML.Root.Items.ItemNamed['Themes'].Items.ItemNamed[inttostr(Theme.ThemeID)].Items do
      begin
        Add('Name',Name);
        Add('Author',Author);
        Add('AuthorWebsite',AuthorWebsite);
        Add('Comments',Comments);
        Add('Skin',Skin);
        Add('Menu',MenuFile);
        Add('ObjectSet',ObjectSets);
        Add('IconSet',IconSet);
        Add('Description',Description);
        Add('DeskHoverAnimation',DeskHoverAnimation);
        Add('AnimScale',AnimScale);
        Add('AnimScaleValue',AnimScaleValue);
        Add('AnimAlpha',AnimAlpha);
        Add('AnimAlphaValue',AnimAlphaValue);
        Add('AnimBlend',AnimBlend);
        Add('AnimBlendValue',AnimBlendValue);
        Add('AnimBlendColor',AnimBlendColor);
        Add('AnimBB',AnimBB);
        Add('AnimBBValue',AnimBBValue);
        Add('DeskTextShadow',DeskTextShadow);
        Add('DeskDisplayCaption',DeskDisplayCaption);
        Add('DeskColorBlend',DeskColorBlend);
        Add('DeskColorBlendColor',DeskColorBlendColor);
        Add('DeskAlphaBlend',DeskAlphaBlend);
        Add('DeskIconShadow',DeskIconShadow);
        Add('DeskIconShadowColor',DeskIconShadowColor);
        Add('DeskUseIconShadow',DeskUseIconShadow);
        Add('DeskUseAlphaBlend',DeskUseAlphaBlend);
        Add('DeskUseColorBlend',DeskUseColorBlend);
        Add('Cursor',Cursor);
        Add('UseCursor',UseCursor);
        Add('Scheme');
        with ItemNamed['Scheme'].Items do
        begin
          Add('3DThrobberBack',Scheme.Throbberback);
          Add('3DThrobberDark',Scheme.Throbberdark);
          Add('3DThrobberLight',Scheme.Throbberlight);
          Add('3DThrobberText',Scheme.ThrobberText);
          Add('3DWorkAreaBack',Scheme.WorkAreaback);
          Add('3DWorkAreaDark',Scheme.WorkAreadark);
          Add('3DWorkAreaLight',Scheme.WorkArealight);
          Add('3DWorkAreaText',Scheme.WorkAreaText);
        end;
        Add('Font');
        with ItemNamed['Font'].Items do
        begin
          Add('DeskFontAlpha',DeskFontAlpha);
          Add('DeskFontAlphaValue',DeskFontAlphaValue);
          Add('ShadowColor',ShadowColor);
          Add('ShadowAlpha',ShadowAlpha);
          Add('Name',TextFont.Name);
          Add('Color',TextFont.Color);
          Add('Size',TextFont.size);
          Add('fsBold',fsbold in TextFont.style);
          Add('fsItalic',fsItalic in TextFont.style);
          Add('fsUnderline',fsUnderline in TextFont.style);
        end;
        Add('Monitors');
        for k := 0 to High(Monitors) do
        begin
          ItemNamed['Monitors'].Items.Add(inttostr(k));
          with ItemNamed['Monitors'].Items.ItemNamed[inttostr(k)].Items do
          begin
            Add('Wallpaper',Monitors[k].Wallpaper);
            Add('BackgroundColor',Monitors[k].Backgroundcolor);
            case Monitors[k].WallpaperAlign of
              waStretch : i:= 0;
              waTile   : i:= 1;
              waCenter  : i:= 2;
              waScale   : i:= 3;
              else i:=2;
            end;
            Add('WallpaperAlign',i);
            Add('Gradient',Monitors[k].Gradient);
            Add('GradientStart',Monitors[k].GradientStart);
            Add('GradientEnd',Monitors[k].GradientEnd);
            Add('GradientStartAlpha',Monitors[k].GradientStartAlpha);
            Add('GradientEndAlpha',Monitors[k].GradientEndAlpha);
            Add('GradientType',Monitors[k].GradientType);
            Add('ScanLines',Monitors[k].ScanLines);
            Add('SLStart',Monitors[k].ScanLineStart);
            Add('SLEnd',Monitors[k].ScanLineEnd);
            Add('SLStartAlpha',Monitors[k].ScanLineStartAlpha);
            Add('SLEndAlpha',Monitors[k].ScanLineEndAlpha);
            Add('SLThickness',Monitors[k].ScanLineThickness);
            Add('SLSpacing',Monitors[k].ScanLineSpacing);
            Add('SLType',Monitors[k].ScanLineType);
            Add('Blending',Monitors[k].Blending);
            Add('ColorBlend',Monitors[k].ColorBlend);
            Add('ColorBlendValue',Monitors[k].ColorBlendValue);
            Add('BrightnessBalance',Monitors[k].BrightnessBalance);
            Add('MirrorVertical',Monitors[k].MirrorVertical);
            Add('MirrorHorizontal',Monitors[k].MirrorHorizontal);
          end;
        end;
        Add('SharpMenu');
        with ItemNamed['SharpMenu'].Items do
        begin
          Add('GradientBanner',MenuGradientBanner);
          Add('DisplayGradientCaption',MenuShowGradientCaption);
          Add('UseShadow',MenuDropShadow);
          Add('UseTitle',MenuTitles);
          Add('UseImages',MenuIcons);
          Add('Opacity',MenuOpacity);
          Add('GradientStart',MenuGradientStart);
          Add('GradientEnd',MenuGradientEnd);
          Add('SelectedColor',MenuSelectedColor);
          Add('SelectedBorderColor',MenuSelectedBorderColor);
          Add('GradientCaption',MenuGradientCaption);
          Add('titleFont');
          Add('menuFont');
        end;
        with ItemNamed['SharpMenu'].Items.ItemNamed['titleFont'].Items do
        begin
          Add('fontname',MenuTitleFont.Name);
          Add('fontsize',MenuTitleFont.Size);
          Add('fsBold',fsbold in MenuTitleFont.style);
          Add('fsItalic',fsItalic in MenuTitleFont.style);
          Add('fsUnderline',fsUnderline in MenuTitleFont.style);
        end;
        with ItemNamed['SharpMenu'].Items.ItemNamed['menuFont'].Items do
        begin
          Add('fontname',MenuFont.Name);
          Add('fontsize',MenuFont.Size);
          Add('fsBold',fsbold in MenuFont.style);
          Add('fsItalic',fsItalic in MenuFont.style);
          Add('fsUnderline',fsUnderline in MenuFont.style);
        end;
      end;
    end;
  end;
  XML.SaveToFile(pFileName);
end;



procedure TThemeSettings.DeleteTheme(ID : integer; Save : boolean);
var
   n : integer;
begin
  for n:=0 to Count-1 do
      if TSharpETheme(Items[n]).ThemeID = ID then
      begin
        Delete(n);
        break;
      end;
  if Save then SaveThemes;
end;



function TThemeSettings.NewTheme : TSharpETheme;
var
   max,n : integer;
   Theme : TSharpETheme;
begin
  Theme := TSharpETheme.Create;
  max := 1;
  for n:=0 to Count-1 do
      if TSharpETheme(Items[n]).ThemeID >= max then max := TSharpETheme(Items[n]).ThemeID+1;

  Theme.ThemeID := max;
  self.Add(Theme);

  result := Theme;
end;



function TThemeSettings.GetThemeByID(ID : integer) : TSharpETheme;
var
   n : integer;
begin
  if Count = 0 then
  begin
    result := nil;
    exit;
  end;

  for n:=0 to Count-1 do
      if TSharpETheme(Items[n]).ThemeID = ID then
      begin
        result := TSharpETheme(Items[n]);
        exit;
      end;
  result := TSharpETheme(Items[0])
end;



procedure TThemeSettings.FreeThemes;
begin
  clear;
end;



procedure TThemeSettings.ReloadThemes;
begin
  ReloadThemes(FFileName);
end;



procedure TThemeSettings.ReloadThemes(pFileName : String);
var
   k,i,n : integer;
   Theme : TSharpETheme;
begin
  if pFileName = '' then pFileName := FFileName
     else FFileName := pFileName;

  if not FileExists(FFileName) then CreateXMLFile(FFileName);
 
  FreeThemes;
  
  try
    XML.LoadFromFile(FFileName);
  except
    on E: Exception do 
    begin
      SharpApi.SendDebugMessageEx('ThemeControler',PChar(Format('Error While Loading "%s"', [FFileName])), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('Themecontroler',PChar(E.Message),clblue, DMT_TRACE);
      CreateXMLFile(FFileName);
      try
        XML.LoadFromFile(FFileName);
      except
        exit;
      end;
    end;
  end;

  with XML.Root.Items.ItemNamed['Themes'].Items do
  for n:=0 to Count-1 do
      with Item[n].Items do
      begin
        Theme := TSharpETheme.Create;
        setlength(Theme.Monitors,0);
        self.Add(Theme);
        with Theme do
        begin
          ThemeID                 := strtoint(XML.Root.Items.ItemNamed['Themes'].Items.Item[n].Name);
          Name                    := Value('Name','default');
          Author                  := Value('Author','');
          AuthorWebsite           := Value('AuthorWebsite','');
          Comments                := Value('Comments','');
          Skin                    := Value('Skin','SharpE');
          MenuFile                := Value('Menu','default');
          Description             := Value('Description','<no description>');
          IconSet                 := Value('IconSet','Default');
          DeskDisplayCaption      := BoolValue('DeskDisplayCaption',True);
          DeskTextShadow          := BoolValue('DeskTextShadow',True);
          DeskUseIconShadow       := BoolValue('DeskUseIconShadow',True);
          ObjectSets              := Value('ObjectSet','0');
          DeskAlphaBlend          := IntValue('DeskAlphaBlend',255);
          DeskColorBlend          := IntValue('DeskColorBlend',0);
          DeskColorBlendColor     := IntValue('DeskColorBlendColor',0);
          DeskIconShadowColor     := IntValue('DeskIconShadowColor',0);
          DeskIconShadow          := IntValue('DeskIconShadow',255);
          DeskUseAlphaBlend       := BoolValue('DeskUseAlphaBlend',False);
          DeskUseColorBlend       := BoolValue('DeskUseColorBlend',False);
          DeskHoverAnimation      := BoolValue('DeskHoverAnimation',True);         
          AnimScale               := BoolValue('AnimScale',False);
          AnimScaleValue          := IntValue('AnimScaleValue',0);
          AnimAlpha               := BoolValue('AnimAlpha',True);
          AnimAlphaValue          := IntValue('AnimAlphaValue',128);
          AnimBlend               := BoolValue('AnimBlend',False);
          AnimBlendValue          := IntValue('AnimBlendValue',0);
          AnimBlendColor          := IntValue('AnimBlendColor',clwhite);
          AnimBB                  := BoolValue('AnimBB',True);
          AnimBBValue             := IntValue('AnimBBValue',50);
          Cursor                  := IntValue('Cursor',0);
          UseCursor               := BoolValue('UseCursor',False);
          with ItemNamed['Scheme'].Items do
          begin
            Scheme.Throbberback  := StringToColor(Value('3DThrobberBack','7165507'));
            Scheme.Throbberdark  := StringToColor(Value('3DThrobberDark','3549985'));
            Scheme.Throbberlight := StringToColor(Value('3DThrobberLight','9864824'));
            Scheme.ThrobberText  := StringToColor(Value('3DThrobberText','0'));
            Scheme.WorkAreaback  := StringToColor(Value('3DWorkAreaBack','1184274'));
            Scheme.WorkAreadark  := StringToColor(Value('3DWorkAreaDark','5921370'));
            Scheme.WorkArealight := StringToColor(Value('3DWorkAreaLight','1394811'));
            Scheme.WorkAreaText  := StringToColor(Value('3DWorkAreaText','0'));
          end;
          with ItemNamed['Font'].Items do
          begin
            DeskFontAlpha      :=  BoolValue('DeskFontAlpha',False);
            DeskFontAlphaValue := intValue('DeskFontAlphaValue',255);
            ShadowColor        := StringToColor(Value('ShadowColor','0'));
            ShadowAlpha        := IntValue('ShadowAlpha',128);
            TextFont.Name      := Value('Name','Arial');
            TextFont.Color     := StringToColor(Value('Color','0'));
            TextFont.Size      := IntValue('Size',8);
            TextFont.Style     := [];
            if BoolValue('fsBold',False) then TextFont.Style := TextFont.Style + [fsBold];
            if BoolValue('fsItalic',False) then TextFont.Style := TextFont.Style + [fsItalic];
            if BoolValue('fsUnderline',False) then TextFont.Style := TextFont.Style + [fsUnderline];
          end;
          for k := 0 to ItemNamed['Monitors'].Items.Count - 1 do
              with ItemNamed['Monitors'].Items.Item[k].Items do
              begin
                setlength(Monitors,length(Monitors)+1);
                Monitors[High(Monitors)] := TSharpEMonitor.Create;
                with Monitors[High(Monitors)] do
                begin
                  Wallpaper := Value('Wallpaper','');
                  BackGroundColor := StringToColor(Value('BackgroundColor','0'));
                  i:= IntValue('WallpaperAlign',0);
                  case i of
                    0 : WallpaperAlign := waStretch;
                    1 : WallpaperAlign := waTile;
                    2 : WallpaperAlign := waCenter;
                    3 : WallpaperAlign := waScale;
                    else WallpaperAlign := waCenter;
                  end;
                  Gradient           := BoolValue('Gradient',False);
                  GradientStart      := IntValue('GradientStart',0);
                  GradientEnd        := IntValue('GradientEnd',0);
                  GradientStartAlpha := IntValue('GradientStartAlpha',0);
                  GradientEndAlpha   := IntValue('GradientEndAlpha',0);
                  GradientType       := IntValue('GradientType',2);
                  ScanLines          := BoolValue('ScanLines',False);
                  ScanLineStart      := IntValue('SLStart',0);
                  ScanLineEnd        := IntValue('SLEnd',0);
                  ScanLineStartAlpha := IntValue('SLStartAlpha',0);
                  ScanLineEndAlpha   := IntValue('SLEndAlpha',0);
                  ScanLineThickness  := IntValue('SLThickness',1);
                  ScanLineSpacing    := IntValue('SLSpacing',1);
                  ScanLineType       := IntValue('SLType',1);
                  Blending           := BoolValue('Blending',False);
                  ColorBlend         := IntValue('ColorBlend',0);
                  ColorBlendValue    := IntValue('ColorBlendValue',0);
                  BrightnessBalance  := IntValue('BrightnessBalance',0);
                  MirrorHorizontal   := BoolValue('MirrorHorizontal',False);
                  MirrorVertical     := BoolValue('MirrorVertical',False);
                end;
              end;
              with ItemNamed['SharpMenu'].Items do
              begin
                MenuGradientBanner      := BoolValue('GradientBanner',False);
                MenuShowGradientCaption := BoolValue('DisplayGradientCaption',true);
                MenuDropShadow          := BoolValue('UseShadow',True);
                MenuTitles              := BoolValue('UseTitle',False);
                MenuIcons               := BoolValue('UseImages',True);
                MenuOpacity             := IntValue('Opacity',128);
                MenuGradientStart       := IntValue('GradientStart',-2);
                MenuGradientEnd         := IntValue('GradientEnd',-3);
                MenuSelectedColor       := IntValue('SelectedColor',-3);
                MenuSelectedBorderColor := IntValue('SelectedBorderColor',0);
                MenuGradientCaption     := Value('GradientCaption','SharpE PB5');
              end;
              with ItemNamed['SharpMenu'].Items.ItemNamed['titleFont'].Items do
              begin
                MenuTitleFont.Name := Value('fontname','Arial');
                MenuTitleFont.Size := IntValue('fontsize',8);
                MenuTitleFont.Style := [];
                if BoolValue('fsBold',False)=True then      MenuTitleFont.Style := MenuTitleFont.Style + [fsbold];
                if BoolValue('fsItalic',False)=True then    MenuTitleFont.Style := MenuTitleFont.Style + [fsitalic];
                if BoolValue('fsUnderline',False)=True then MenuTitleFont.Style := MenuTitleFont.Style + [fsunderline];
              end;
              with ItemNamed['SharpMenu'].Items.ItemNamed['menuFont'].Items do
              begin
                MenuFont.Name := Value('fontname','Arial');
                MenuFont.Size := IntValue('fontsize',8);
                MenuFont.Style := [];
                if BoolValue('fsBold',False)=True      then MenuFont.Style := MenuFont.Style + [fsbold];
                if BoolValue('fsItalic',False)=True    then MenuFont.Style := MenuFont.Style + [fsitalic];
                if BoolValue('fsUnderline',False)=True then MenuFont.Style := MenuFont.Style + [fsunderline];
              end;
          end;
        end;
  if self.Count = 0 then
  begin
    NewTheme;
  end;
end;

end.

