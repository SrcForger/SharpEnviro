unit uSharpDeskSharpETheme;

interface

uses
    Dialogs,
    Graphics,
    SysUtils,
    JvSimpleXML,
    Forms,
    SharpApi;

type

    TWallpaperAlign = (waTile,waCenter,waStretch,waScale);

    TSharpEMonitor = class
                     private
                     public
                       BackgroundColor         : TColor;
                       Gradient                : Boolean;
                       GradientStart           : integer;
                       GradientEnd             : integer;
                       GradientStartAlpha      : integer;
                       GradientEndAlpha        : integer;
                       GradientType            : integer;
                       ScanLines               : Boolean;
                       ScanLineStart           : integer;
                       ScanLineEnd             : integer;
                       ScanLineStartAlpha      : integer;
                       ScanLineEndAlpha        : integer;
                       ScanLineThickness       : integer;
                       ScanLineSpacing         : integer;
                       ScanLineType            : integer;
                       Blending                : Boolean;
                       ColorBlend              : integer;
                       ColorBlendValue         : integer;
                       BrightnessBalance       : Integer;
                       Wallpaper               : String;
                       WallpaperAlign          : TWallpaperAlign;
                       MirrorVertical          : Boolean;
                       MirrorHorizontal        : Boolean;
                       constructor Create; reintroduce;
                       procedure Assign(pSharpEMonitor : TSharpEMonitor);                       
                     published
                     end;

    TSharpETheme = class
                   private
                   public
                     AnimScale               : Boolean;
                     AnimScaleValue          : integer;
                     AnimAlpha               : Boolean;
                     AnimAlphaValue          : integer;
                     AnimBlend               : Boolean;
                     AnimBlendValue          : integer;
                     AnimBlendColor          : integer;
                     AnimBB                  : Boolean;
                     AnimBBValue             : integer;
                     DeskHoverAnimation      : Boolean;
                     DeskDisplayCaption      : Boolean;
                     DeskTextShadow          : Boolean;
                     DeskUseIconShadow       : Boolean;
                     MenuGradientBanner      : Boolean;
                     MenuShowGradientCaption : Boolean;
                     MenuDropShadow          : Boolean;
                     MenuTitles              : Boolean;
                     MenuIcons               : Boolean;
                     DeskUseAlphaBlend       : Boolean;
                     DeskUseColorBlend       : Boolean;
                     DeskFontAlpha           : Boolean;
                     DeskFontAlphaValue      : integer;
                     DeskIconShadow          : integer;
                     DeskAlphaBlend          : integer;
                     DeskColorBlend          : integer;
                     ThemeID                 : integer;
                     ObjectSets              : String;
                     Skin                    : String; 
                     ShadowAlpha             : Integer;
                     MenuOpacity             : integer;
                     MenuGradientStart       : integer;
                     MenuGradientEnd         : integer;
                     MenuSelectedColor       : integer;
                     MenuSelectedBorderColor : integer;
                     TextFont                : TFont;
                     MenuTitleFont           : TFont;
                     MenuFont                : TFont;
                     Description             : String;
                     Name                    : String;
                     IconSet                 : String;
                     MenuFile                : String;
                     MenuGradientCaption     : String;
                     Author                  : String;
                     AuthorWebsite           : String;
                     Comments                : String;
                     ShadowColor             : TColor;
                     Scheme                  : TColorSchemeEx;
                     DeskColorBlendColor     : TColor;
                     DeskIconShadowColor     : TColor;
                     Cursor                  : integer;
                     UseCursor               : boolean;
                     Monitors                : array of TSharpEMonitor;
                     constructor Create;
                     destructor Destroy; override;
                     procedure Assing(pTheme : TSharpETheme);
                     procedure AssignMonitors(pMonList : array of TSharpEMonitor);
                     procedure ClearMonitorList;
                   published
                   end;



implementation


procedure TSharpEMonitor.Assign(pSharpEMonitor : TSharpEMonitor);
begin
  BackgroundColor    := pSharpEMonitor.BackgroundColor;
  Gradient           := pSharpEMonitor.Gradient;
  GradientStart      := pSharpEMonitor.GradientStart;
  GradientEnd        := pSharpEMonitor.GradientEnd;
  GradientStartAlpha := pSharpEMonitor.GradientStartAlpha;
  GradientEndAlpha   := pSharpEMonitor.GradientEndAlpha;
  GradientType       := pSharpEMonitor.GradientType;
  ScanLines          := pSharpEMonitor.ScanLines;
  ScanLineStart      := pSharpEMonitor.ScanLineStart;
  ScanLineEnd        := pSharpEMonitor.ScanLineEnd;
  ScanLineStartAlpha := pSharpEMonitor.ScanLineStartAlpha;
  ScanLineEndAlpha   := pSharpEMonitor.ScanLineEndAlpha;
  ScanLineThickness  := pSharpEMonitor.ScanLineThickness;
  ScanLineSpacing    := pSharpEMonitor.ScanLineSpacing;
  ScanLineType       := pSharpEMonitor.ScanLineType;
  Blending           := pSharpEMonitor.Blending;
  ColorBlend         := pSharpEMonitor.ColorBlend;
  ColorBlendValue    := pSharpEMonitor.ColorBlendValue;
  BrightnessBalance  := pSharpEMonitor.BrightnessBalance;
  Wallpaper          := pSharpEMonitor.Wallpaper;
  WallpaperAlign     := pSharpEMonitor.WallpaperAlign;
  MirrorVertical     := pSharpEMonitor.MirrorVertical;
  MirrorHorizontal   := pSharpEMonitor.MirrorHorizontal;
end;


constructor TSharpEMonitor.Create;
begin
  inherited Create;
  BackgroundColor    := 6574908;
  Gradient           := False;
  GradientStart      := 0;
  GradientEnd        := 0;
  GradientStartAlpha := 255;
  GradientEndAlpha   := 255;
  GradientType       := 3;
  ScanLines          := False;
  ScanLineStart      := 0;
  ScanLineEnd        := 0;
  ScanLineStartAlpha := 255;
  ScanLineEndAlpha   := 255;
  ScanLineThickness  := 3;
  ScanLineSpacing    := 2;
  ScanLineType       := 2;
  Blending           := False;
  ColorBlend         := 0;
  ColorBlendValue    := 0;
  BrightnessBalance  := 0;
  Wallpaper          := '';
  WallpaperAlign     := waCenter;
  MirrorVertical     := False;
  MirrorHorizontal   := False;
end;

constructor TSharpETheme.Create;
begin
  Inherited Create;
  TextFont := TFont.Create;
  MenuFont := TFont.Create;
  MenuTitleFont := TFont.Create;
   
  {Default Settings}                   
  DeskDisplayCaption      := True;
  DeskTextShadow          := True;
  DeskUseIconShadow       := True;
  DeskUseAlphaBlend       := False;
  DeskUseColorBlend       := False;
  MenuGradientBanner      := True;
  MenuShowGradientCaption := True;
  MenuDropShadow          := True;
  MenuTitles              := False;
  MenuIcons               := True;
  DeskIconShadow          := 128;
  DeskAlphaBlend          := 192;
  DeskColorBlend          := 0;
  ThemeID                 := 0;
  ObjectSets              := '1';
  ShadowAlpha             := 128;
  MenuOpacity             := 255;
  MenuGradientStart       := -1;
  MenuGradientEnd         := -2;
  MenuSelectedColor       := -3;
  MenuSelectedBorderColor := 0;
  Description             := 'Auto created theme';
  Name                    := 'Default';
  IconSet                 := 'Ximian2';
  MenuFile                := 'Default';
  MenuGradientCaption     := 'SharpE PB5';
  Author                  := '';
  AuthorWebsite           := '';
  Comments                := '';
  ShadowColor             := 0;
  DeskColorBlendColor     := 0;
  DeskIconShadowColor     := 0;
  Scheme.Throbberback     := 9597786;
  Scheme.Throbberdark     := 4798765;
  Scheme.Throbberlight    := 11310210;
  Scheme.ThrobberText     := clBlack;
  Scheme.WorkAreaback     := 11842740;
  Scheme.WorkAreadark     := 5921370;
  Scheme.WorkArealight    := 13948116;
  Scheme.WorkAreaText     := clBlack;
  DeskFontAlpha           := False;
  DeskFontAlphaValue      := 255;
  Cursor                  := 0;
  UseCursor               := False;
  Skin                    := 'SharpE';

  AnimScale          := False;
  AnimScaleValue     := 0;
  AnimAlpha          := True;
  AnimAlphaValue     := 128;
  AnimBlend          := False;
  AnimBlendValue     := 0;
  AnimBlendColor     := clwhite;
  AnimBB             := True;
  AnimBBValue        := 50;
  DeskHoverAnimation := True;
    
  setlength(Monitors,1);
  Monitors[High(Monitors)] := TSharpEMonitor.Create;
end;



destructor TSharpETheme.Destroy;
begin
  TextFont.Free;
  MenuFont.Free;
  MenuTitleFont.Free;
  ClearMonitorList;
  Inherited Destroy;  
end;


procedure TSharpETheme.ClearMonitorList;
var
  n : integer;
begin
  for n:=0 to High(Monitors) do
     Monitors[n].Free;
  setlength(Monitors,0);
  Monitors := nil;
end;



procedure TSharpETheme.AssignMonitors(pMonList : array of TSharpEMonitor);
var
  n : integer;
begin
  ClearMonitorList;
  for n := 0  to High(pMonList) do
  begin
    setlength(Monitors,length(Monitors)+1);
    Monitors[High(Monitors)] := TSharpEMonitor.Create;
    Monitors[High(Monitors)].Assign(pMonList[n]);
  end;
end;



procedure TSharpETheme.Assing(pTheme : TSharpETheme);
var
   n : integer;
begin
  Author                  := pTheme.Author;
  AuthorWebsite           := pTheme.AuthorWebsite;
  Comments                := pTheme.Comments;
  DeskUseAlphaBlend       := pTheme.DeskUseAlphaBlend;
  DeskUseColorBlend       := pTheme.DeskUseColorBlend;
  DeskUseIconShadow       := pTheme.DeskUseIconShadow;
  DeskIconShadowColor     := pTheme.DeskIconShadowColor;
  DeskIconShadow          := pTheme.DeskIconShadow;
  DeskAlphaBlend          := pTheme.DeskAlphaBlend;
  DeskColorBlend          := pTheme.DeskColorBlend;
  DeskColorBlendColor     := pTheme.DeskColorBlendColor;
  DeskDisplayCaption      := pTheme.DeskDisplayCaption;
  DeskTextShadow          := pTheme.DeskTextShadow;
  DeskFontAlpha           := pTheme.DeskFontAlpha;
  DeskFontAlphaValue      := pTheme.DeskFontAlphaValue;
  MenuGradientBanner      := pTheme.MenuGradientBanner;
  MenuShowGradientCaption := pTheme.MenuShowGradientCaption;
  MenuDropShadow          := pTheme.MenuDropShadow;
  MenuTitles              := pTheme.MenuTitles;
  MenuIcons               := pTheme.MenuIcons;
  ObjectSets              := pTheme.ObjectSets;
  Cursor                  := pTheme.Cursor;
  UseCursor               := pTheme.UseCursor;
  Skin                    := pTheme.Skin;
  ClearMonitorList;
  for n := 0 to High(pTheme.Monitors) do
  begin
    setlength(Monitors,length(Monitors) + 1);
    Monitors[High(Monitors)] := TSharpEMonitor.Create;
    with Monitors[High(Monitors)] do
    begin
      BackgroundColor    := pTheme.Monitors[n].BackgroundColor;
      Gradient           := pTheme.Monitors[n].Gradient;
      GradientStart      := pTheme.Monitors[n].GradientStart;
      GradientEnd        := pTheme.Monitors[n].GradientEnd;
      GradientStartAlpha := pTheme.Monitors[n].GradientStartAlpha;
      GradientEndAlpha   := pTheme.Monitors[n].GradientEndAlpha;
      GradientType       := pTheme.Monitors[n].GradientType;
      ScanLines          := pTheme.Monitors[n].ScanLines;
      ScanLineStart      := pTheme.Monitors[n].ScanLineStart;
      ScanLineEnd        := pTheme.Monitors[n].ScanLineEnd;
      ScanLineStartAlpha := pTheme.Monitors[n].ScanLineStartAlpha;
      ScanLineEndAlpha   := pTheme.Monitors[n].ScanLineEndAlpha;
      ScanLineThickness  := pTheme.Monitors[n].ScanLineThickness;
      ScanLineSpacing    := pTheme.Monitors[n].ScanLineSpacing;
      ScanLineType       := pTheme.Monitors[n].ScanLineType;
      Blending           := pTheme.Monitors[n].Blending;
      ColorBlend         := pTheme.Monitors[n].ColorBlend;
      ColorBlendValue    := pTheme.Monitors[n].ColorBlendValue;
      BrightnessBalance  := pTheme.Monitors[n].BrightnessBalance;
      Wallpaper          := pTheme.Monitors[n].Wallpaper;
      WallpaperAlign     := pTheme.Monitors[n].WallpaperAlign;
      MirrorVertical     := pTheme.Monitors[n].MirrorVertical;
      MirrorHorizontal   := pTheme.Monitors[n].MirrorHorizontal;
    end;
  end;
  ShadowAlpha             := pTheme.ShadowAlpha;
  MenuOpacity             := pTheme.MenuOpacity;
  MenuGradientStart       := pTheme.MenuGradientStart;
  MenuGradientEnd         := pTheme.MenuGradientEnd;
  MenuSelectedColor       := pTheme.MenuSelectedColor;
  MenuSelectedBorderColor := pTheme.MenuSelectedBorderColor;
  TextFont.Assign(pTheme.TextFont);
  MenuTitleFont.Assign(pTheme.MenuTitleFont);
  MenuFont.Assign(pTheme.MenuFont);
  Description             := pTheme.Description;
  Name                    := pTheme.Name;
  IconSet                 := pTheme.IconSet;
  MenuFile                := pTheme.MenuFile;
  MenuGradientCaption     := pTheme.MenuGradientCaption;
  ShadowColor             := pTheme.ShadowColor;
  Scheme                  := pTheme.Scheme;
  AnimScale               := pTheme.AnimScale;
  AnimScaleValue          := pTheme.AnimScaleValue;
  AnimAlpha               := pTheme.AnimAlpha;
  AnimAlphaValue          := pTheme.AnimAlphaValue;
  AnimBlend               := pTheme.AnimBlend;
  AnimBlendValue          := pTheme.AnimBlendValue;
  AnimBlendColor          := pTheme.AnimBlendColor;
  AnimBB                  := pTheme.AnimBB;
  AnimBBValue             := pTheme.AnimBBValue;
  DeskHoverAnimation      := pTheme.DeskHoverAnimation;
end;


end.
