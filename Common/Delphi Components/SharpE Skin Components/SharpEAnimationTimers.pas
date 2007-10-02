{
Source Name: SharpEAnimationTimers.pas
Description: Generic Timer and Script parsing unit for Skin animation scripts
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

unit SharpEAnimationTimers;

interface

uses
  DateUtils,
  Dialogs,
  Windows,
  SysUtils,
  Math,
  Graphics,
  SharpESkinPart,
  SharpEScheme,
  SharpEBaseControls,
  Contnrs,
  ExtCtrls,
  JvInterpreter,
  Variants;

type
  TOnTimerFinishedEvent = procedure (Sender : TObject; SkinPart : TSkinPart) of Object;

  TSkinPartInfo = record
                    ID : String;
                    spart : TSkinPart;
                    BlendColor : integer;
                    BlendColorString : string;
                    BlendAlpha : integer;
                    GradientColorFrom : String;
                    GradientColorTo   : String;
                    GradientColorFromS : String;
                    GradientColorToS   : String;
                    MasterAlpha : integer;
                    GradientAlphaFrom : String;
                    GradientAlphaTo   : String;
                    TextColorString : String;
                    TextColor : integer;
                    TextAlpha : integer;
                    TextShadowColor : integer;
                    TextShadowColorString : String;
                    TextShadowAlpha : integer;
                  end;

  TSkinPartArray = array of TSkinPartInfo;

  TSharpEAnimTimer = class
                     private
                       FInterpreter : TJvInterpreterProgram;
                       FTimer       : TTimer;
                       FScheme      : TSharpEScheme;
                       FComponent   : TObject;
                       FSkinPart    : TSkinPart;
                       ETime        : Int64;
                       FModList     : TSkinPartArray;
                       FLMList      : TSkinPartArray;
                       FOnTimerFinished : TOnTimerFinishedEvent;
                     public
                       constructor Create(pComponent : TObject;
                                          pScript : String;
                                          pSkinPart : TSkinPart;
                                          pScheme : TSharpEScheme); reintroduce;
                       destructor Destroy; override;
                       procedure Update(pComponent : TObject;
                                        pScript : String;
                                        pSkinPart : TSkinPart;
                                        pScheme : TSharpEScheme);
                       procedure OnAnimTimer(Sender : TObject);
                       procedure OnInterpreterGetValue(Sender: TObject; Identifier: string; var Value: Variant; Args: TjvInterpreterArgs; var Done: Boolean);
                       function FindSkinPart(ID : String; BasePart : TSkinPart) : TSkinPart;
                       procedure AddToModList(SP : TSkinPart; var ML : TSkinPartArray);
                       procedure RestoreFromModList(SP : TSkinPart; var ML : TSkinPartArray);
                       procedure RestoreSkinParts;
                       procedure BuildRestoreList(SP : TSkinPart);

                       property Component : TObject read FComponent;
                       property Timer     : TTimer  read FTimer;
                       property OnTimerFinished : TOnTimerFinishedEvent read FOnTimerFinished write FOnTimerFinished;
                     end;

  TSharpETimerManager = class
                        private
                          FTimers : TObjectList;
                          FCheckTimer : TTimer;
                          FTimerActive : boolean;
                        public
                          constructor Create; reintroduce;
                          destructor Destroy; override;
                          function ExecuteScript(pComponent : TObject;
                                                 pScript : String;
                                                 pSkinPart : TSkinPart;
                                                 pScheme : TSharpEScheme) : TSharpEAnimTimer;
                          procedure OnCheckTimer(Sender : TObject);
                          function HasScriptRunning(pComponent : TObject) : boolean;
                          procedure StopScript(pComponent : TObject);

                          property TimerActive : boolean read FTimerActive write FTimerActive;
                        end;

var
  SharpEAnimManager : TSharpETimerManager;


implementation

function Script_IntToStr(Int : integer) : String;
begin
  try
    result := Inttostr(Int);
  except
    result := '';
  end;
end;

function Script_StrToInt(Str : String) : integer;
begin
  if not TryStrToInt(Str,result) then
     result := 0;
end;

function Script_GetGradientFromColor(SP : TSkinPart) : String;
begin
  result := SP.GradientColorS.X;
end;

function Script_GetGradientToColor(SP : TSkinPart) : String;
begin
  result := SP.GradientColorS.Y;
end;

function Script_GetColor(SP : TSkinPart) : String;
begin
  result := SP.BlendColorString;
end;

function Script_GetTextAlpha(SP : TSkinPart) : integer;
begin
  result := SP.SkinText.Alpha;
end;

function Script_GetTextColor(SP : TSkinPart) : String;
begin
  result := SP.SkinText.ColorString;
end;

function Script_GetTextShadowColor(SP : TSkinPart) : String;
begin
  result := SP.SkinText.ShadowColorString;
end;

function Script_GetTextShadowAlpha(SP : TSkinPart) : integer;
begin
  result := SP.SkinText.ShadowAlpha;
end;

function Script_GetAlpha(SP : TSkinPart) : integer;
begin
  result := SP.MasterAlpha;
end;

procedure Script_SetAlpha(SP : TSkinPart; NewAlpha : integer);
begin
  SP.MasterAlpha := Max(0,Min(255,NewAlpha));
end;

procedure Script_SetTextAlpha(SP : TSkinPart; NewAlpha : integer);
begin
  SP.SkinText.Alpha := Max(0,Min(255,NewAlpha));
end;

procedure Script_SetTextShadowAlpha(SP : TSkinPart; NewAlpha : integer);
begin
  SP.SkinText.ShadowAlpha := Max(0,Min(255,NewAlpha));
end;

procedure Script_SetTextShadowColor(SP : TSkinPart; NewColor : String; Scheme : TSharpEScheme);
begin
  SP.SkinText.ShadowColorString := NewColor;
  SP.SkinText.ShadowColor := SchemedStringToColor(NewColor,Scheme);
end;

procedure Script_setColor(SP : TSkinPart; NewColor : String; Scheme : TSharpEScheme);
begin
  SP.BlendColorString := NewColor;
  SP.BlendColor := SchemedStringToColor(NewColor,Scheme);
end;

procedure Script_IncreaseTextShadowAlpha(SP : TSkinPart; Amount : integeR);
var
  n : integer;
begin
  n := Max(0,Min(255,SP.SkinText.ShadowAlpha + Amount));
  SP.SkinText.ShadowAlpha := n;
end;

procedure Script_DecreaseTextShadowAlpha(SP : TSkinPart; Amount : integeR);
var
  n : integer;
begin
  n := Max(0,Min(255,SP.SkinText.ShadowAlpha - Amount));
  SP.SkinText.ShadowAlpha := n;
end;

procedure Script_IncreaseTextAlpha(SP : TSkinPart; Amount : integer);
var
  n : integer;
begin
  n := Max(0,Min(255,SP.SkinText.Alpha + Amount));
  SP.SkinText.Alpha := n;
end;

procedure Script_DecreaseTextAlpha(SP : TSkinPart; Amount : integer);
var
  n : integer;
begin
  n := Max(0,Min(255,SP.SkinText.Alpha - Amount));
  SP.SkinText.Alpha := n;
end;

procedure Script_IncreaseGradientFromAlpha(SP : TSkinPart; Amount: integer);
var
  n : integer;
begin
  n := Min(255,SP.GradientAlpha.XAsInt + Amount);
  SP.GradientAlpha.SetPoint(inttostr(n),SP.GradientAlpha.Y);
end;

procedure Script_IncreaseGradientToAlpha(SP : TSkinPart; Amount: integer);
var
  n : integer;
begin
  n := Min(255,SP.GradientAlpha.YAsInt + Amount);
  SP.GradientAlpha.SetPoint(SP.GradientAlpha.X,inttostr(n));
end;

procedure Script_DecraseGradientFromAlpha(SP : TSkinPart; Amount: integer);
var
  n : integer;
begin
  n := Max(0,SP.GradientAlpha.XAsInt - Amount);
  SP.GradientAlpha.SetPoint(inttostr(n),SP.GradientAlpha.Y);
end;

procedure Script_DecraseGradientToAlpha(SP : TSkinPart; Amount: integer);
var
  n : integer;
begin
  n := Max(0,SP.GradientAlpha.YAsInt - Amount);
  SP.GradientAlpha.SetPoint(SP.GradientAlpha.X,inttostr(n));
end;

procedure Script_SetTextColor(SP : TSkinPart; NewColor : String; Scheme : TSharpEScheme);
begin
  SP.SkinText.ColorString := NewColor;
  SP.SkinText.Color := SchemedStringToColor(NewColor,Scheme);
end;

function Script_GetGradientFromAlpha(SP : TSkinPart) : integer;
begin
  result := SP.GradientAlpha.XAsInt;
end;

function Script_GetGradientToAlpha(SP : TSkinPart) : integer;
begin
  result := SP.GradientAlpha.YAsInt;
end;

procedure Script_SetGradientFromAlpha(SP : TSkinPart; NewAlpha : integer);
begin
  SP.GradientAlpha.SetPoint(inttostr(Max(0,Min(255,NewAlpha))),SP.GradientAlpha.Y);
end;

procedure Script_SetGradientToAlpha(SP : TSkinPart; NewAlpha : integer);
begin
  SP.GradientAlpha.SetPoint(SP.GradientAlpha.X,inttostr(Max(0,Min(255,NewAlpha))));
end;

function StepBlendColor(FromColor,ToColor,CurrentColor : integer; Step : integer) : integer;
var
  FR,FG,FB : integer;
  CR,CG,CB : integer;
  TR,TG,TB : integer;
  NR,NG,NB : integer;
  stepr : real;
begin
  FR := GetRValue(FromColor);
  FG := GetGValue(FromColor);
  FB := GetBValue(FromColor);
  TR := GetRValue(ToColor);
  TG := GetGValue(ToColor);
  TB := GetBValue(ToColor);
  CR := GetRValue(CurrentColor);
  CG := GetGValue(CurrentColor);
  CB := GetBValue(CurrentColor);
  stepr := 1 / Step;
  if FR > TR then NR := Max(CR + round((TR-FR)*stepr),TR)
     else if  FR < TR then NR := Min(CR - round((FR-TR)*stepr),TR)
     else NR := TR;
  if FG > TG then NG := Max(CG + round((TG-FG)*stepr),TG)
     else if  FG < TG then NG := Min(CG - round((FG-TG)*stepr),TG)
     else NG := TG;
  if FB > TB then NB := Max(CB + round((TB-FB)*stepr),TB)
     else if  FB < TB then NB := Min(CB - round((FB-TB)*stepr),TB)
     else NB := TB;

  result := RGB(NR,NG,NB);
end;

procedure Script_IncreaseAlpha(SP : TSkinPart; Amount : integer);
begin
  SP.MasterAlpha := Min(255,SP.MasterAlpha + Amount);
end;

procedure Script_DecreaseAlpha(SP : TSkinPart; Amount : integer);
begin
  SP.MasterAlpha := Max(0,SP.MasterAlpha - Amount);
end;

procedure Script_BlendTextShadowColor(SP : TSkinPart; pFromColor, pToColor : String; Step : integer; Scheme : TSharpEScheme);
var
  NewColor : integer;
  CurrentColor, FromColor, ToColor : integer;
begin
  FromColor := SchemedStringToColor(pFromColor, Scheme);
  ToColor := SchemedStringToColor(pToColor, Scheme);
  CurrentColor := SchemedStringToColor(SP.SkinText.ShadowColorString, Scheme);
  NewColor := StepBlendColor(FromColor,ToColor,CurrentColor,Step);

  if NewColor = ToColor then
  begin
    SP.SkinText.ShadowColorString := pToColor;
    SP.SkinText.ShadowColor := SchemedStringToColor(pToColor, Scheme)
  end
  else
  begin
    SP.SkinText.ShadowColorString := inttostr(NewColor);
    SP.SkinText.ShadowColor := NewColor;
  end;
end;

procedure Script_BlendTextColor(SP : TSkinPart; pFromColor, pToColor : String; Step : integer; Scheme : TSharpEScheme);
var
  NewColor : integer;
  CurrentColor, FromColor, ToColor : integer;
begin
  FromColor := SchemedStringToColor(pFromColor, Scheme);
  ToColor := SchemedStringToColor(pToColor, Scheme);
  CurrentColor := SchemedStringToColor(SP.SkinText.ColorString, Scheme);
  NewColor := StepBlendColor(FromColor,ToColor,CurrentColor,Step);

  if NewColor = ToColor then
  begin
    SP.SkinText.Color := SchemedStringToColor(pToColor,Scheme);
    SP.SkinText.ColorString := pToColor;
  end
  else
  begin
    SP.SkinText.ColorString := inttostr(NewColor);
    SP.SkinText.Color := NewColor;
  end;
end;

procedure Script_BlendColor(SP : TSkinPart; pFromColor, pToColor : String; Step : integer; Scheme : TSharpEScheme);
var
  NewColor : integer;
  CurrentColor, FromColor, ToColor : integer;
begin
  FromColor := SchemedStringToColor(pFromColor, Scheme);
  ToColor := SchemedStringToColor(pToColor, Scheme);
  CurrentColor := SchemedStringToColor(SP.BlendColorString, Scheme);
  NewColor := StepBlendColor(FromColor,ToColor,CurrentColor,Step);

  if NewColor = ToColor then
  begin
    SP.BlendColor := SchemedStringToColor(pToColor,Scheme);
    SP.BlendColorString := pToColor;
  end
  else
  begin
    SP.BlendColorString := inttostr(NewColor);
    SP.BlendColor := NewColor;
  end;
end;

procedure Script_BlendGradientFrom(SP : TSkinPart; pFromColor, pToColor : String; Step : integer; Scheme : TSharpEScheme);
var
  NewColor : integer;
  CurrentColor, FromColor, ToColor : integer;
begin
  FromColor := SchemedStringToColor(pFromColor, Scheme);
  ToColor := SchemedStringToColor(pToColor, Scheme);
  CurrentColor := SchemedStringToColor(SP.GradientColorS.X, Scheme);
  NewColor := StepBlendColor(FromColor,ToColor,CurrentColor,Step);

  if NewColor = ToColor then
  begin
    SP.GradientColor.SetPoint(inttostr(SchemedStringToColor(pToColor,Scheme)),SP.GradientColor.Y);
    SP.GradientColorS.SetPoint(pToColor,SP.GradientColorS.Y);
  end
  else
  begin
    SP.GradientColorS.SetPoint(inttostr(NewColor),SP.GradientColorS.Y);
    SP.GradientColor.SetPoint(inttostr(NewColor),SP.GradientColor.Y);
  end;
end;

procedure Script_BlendGradientTo(SP : TSkinPart; pFromColor, pToColor : String; Step : integer; Scheme : TSharpEScheme);
var
  NewColor : integer;
  CurrentColor, FromColor, ToColor : integer;
begin
  FromColor := SchemedStringToColor(pFromColor, Scheme);
  ToColor := SchemedStringToColor(pToColor, Scheme);
  CurrentColor := SchemedStringToColor(SP.GradientColorS.Y, Scheme);
  NewColor := StepBlendColor(FromColor,ToColor,CurrentColor,Step);

  if NewColor = ToColor then
  begin
    SP.GradientColor.SetPoint(SP.GradientColor.X,inttostr(SchemedStringToColor(pToColor,Scheme)))
  end
  else
  begin
    SP.GradientColor.SetPoint(SP.GradientColor.X,inttostr(NewColor));
    SP.GradientColorS.SetPoint(SP.GradientColorS.X,inttostr(NewColor));
  end;
end;

constructor TSharpEAnimTimer.Create(pComponent : TObject;
                                    pScript : String;
                                    pSkinPart : TSkinPart;
                                    pScheme : TSharpEScheme);
begin
  Inherited Create;
  FTimer := TTimer.Create(nil);
  FTimer.OnTimer := OnAnimTimer;
  FInterpreter := TJvInterpreterProgram.Create(nil);
  FInterpreter.OnGetValue := OnInterpreterGetValue;
  Setlength(FLMList,0);

  Update(pComponent,pScript,pSkinPart,pScheme);
end;

destructor TSharpEAnimTimer.Destroy;
begin
  FTimer.Free;
  FInterpreter.Free;
  SetLength(FLMList,0);
  Inherited Destroy;
end;

procedure  TSharpEAnimTimer.RestoreFromModList(SP : TSkinPart; var ML : TSkinPartArray);
var
  n : integer;
  b : boolean;
begin
  b := False;
  for n := 0 to High(ML) do
      if ML[n].spart = SP then
      begin
        b := True;
        break;
      end;
  if not B then exit;
  with ML[n] do
  begin
    SP.BlendColor := BlendColor;
    SP.BlendColorString := BlendColorString;
    SP.GradientColor.SetPoint(GradientColorFrom,GradientColorTo);
    SP.GradientColorS.SetPoint(GradientColorFromS,GradientColorToS);
    SP.BlendAlpha := BlendAlpha;
    SP.MasterAlpha := MasterAlpha;
    SP.GradientAlpha.SetPoint(GradientAlphaFrom,GradientAlphaTo);
    SP.SkinText.ColorString := TextColorString;
    SP.SkinText.Color := TextColor;
    SP.SkinText.Alpha := TextAlpha;
    SP.SkinText.ShadowAlpha := TextShadowAlpha;
    SP.SkinText.ShadowColor := TextShadowColor;
    SP.SkinText.ShadowColorString := TextShadowColorString;
  end;
end;

procedure TSharpEAnimTimer.AddToModList(SP : TSkinPart; var ML : TSkinPartArray);
var
  n : integer;
  b : boolean;
begin
  b := False;
  for n := 0 to High(ML) do
      if ML[n].spart = SP then
      begin
        b := True;
        break;
      end;
  if not b then
  begin
    setlength(ML,length(ML)+1);
    n := High(ML);
  end;
  with ML[n] do
  begin
    ID := SP.ID;
    spart := SP;
    BlendColor := SP.BlendColor;
    BlendColorString := SP.BlendColorString;
    GradientColorFrom := SP.GradientColor.X;
    GradientColorTo := SP.GradientColor.Y;
    GradientColorFromS := SP.GradientColorS.X;
    GradientColorToS := SP.GradientColorS.Y;
    BlendAlpha := SP.BlendAlpha;
    MasterAlpha := SP.MasterAlpha;
    GradientAlphaFrom := SP.GradientAlpha.X;
    GradientAlphaTo  := SP.GradientAlpha.Y;
    TextColor := SP.SkinText.Color;
    TextColorString := SP.SkinText.ColorString;
    TextAlpha := SP.SkinText.Alpha;
    TextShadowAlpha := SP.SkinText.ShadowAlpha;
    TextShadowColor := SP.SkinText.ShadowColor;
    TextShadowColorString := SP.SkinText.ShadowColorString;
  end;
end;

procedure TSharpEAnimTimer.BuildRestoreList(SP : TSkinPart);
var
  n : integer;
begin
  AddToModList(SP,FModList);
  for n := 0 to SP.Items.Count -1 do
  begin
    BuildRestoreList(SP.Items[n]);
  end;
end;

procedure TSharpEAnimTimer.RestoreSkinParts;
var
  n : integer;
begin
  for n := 0 to High(FModList) do
      with FModList[n] do
      if spart <> nil then
      begin
        spart.BlendColor := FModList[n].BlendColor;
        spart.SkinText.ShadowColor := FModList[n].TextShadowColor;
        spart.SkinText.Color := FModList[n].TextColor;
        spart.BlendColorString := FModList[n].BlendColorString;
        spart.SkinText.ShadowColorString := FModList[n].TextShadowColorString;
        spart.SkinText.ColorString := FModList[n].TextColorString;
        spart.GradientColor.SetPoint(FModList[n].GradientColorFrom,FModList[n].GradientColorTo);
        spart.GradientColorS.SetPoint(FModList[n].GradientColorFromS,FModList[n].GradientColorToS);
        spart.BlendAlpha := FModList[n].BlendAlpha;
        spart.MasterAlpha := FModList[n].MasterAlpha;
        spart.GradientAlpha.SetPoint(FModList[n].GradientAlphaFrom,FModList[n].GradientAlphaTo);
      end;
end;

procedure TSharpEAnimTimer.Update(pComponent : TObject;
                                  pScript : String;
                                  pSkinPart : TSkinPart;
                                  pScheme : TSharpEScheme);
begin
  FComponent := pComponent;
  FSkinPart  := pSkinPart;
  FScheme    := pScheme;

  try
    FInterpreter.Pas.CommaText := pScript;
    FTimer.Interval := FInterpreter.CallFunction('InitAnimation',nil,[]);
    ETime := DateTimeToUnix(now);
    FTimer.Enabled := True;
  except
    FTimer.Enabled := False;
  end;
end;

procedure TSharpEAnimTimer.OnAnimTimer(Sender : TObject);
var
  continue : boolean;
begin
  FTimer.Tag := FTimer.Tag + 1;
  if (FComponent = nil) or (FSkinPart = nil) or (FScheme = nil) then
  begin
    FTimer.Enabled := False;
    exit;
  end;

  setlength(FModList,0);
  try
    BuildRestoreList(FSkinPart);
  except
  end;

  try
    continue :=  FInterpreter.CallFunction('OnAnimate',nil,[]);
  except
    continue := False;
  end;

  SharpEAnimManager.TimerActive := True;
  try
    if FComponent is TCustomSharpEGraphicControl then
       TCustomSharpEGraphicControl(FComponent).UpdateSkin
    else if FComponent is TCustomSharpEComponent then
            TCustomSharpEComponent(FComponent).UpdateSkin
    else if FComponent is TCustomSharpEControl then
            TCustomSharpEControl(FComponent).UpdateSkin;
  except
    continue := False;
  end;
  SharpEAnimManager.TimerActive := False;
  FTimer.Enabled := continue;

  try
    RestoreSkinParts;
  except
  end;

  // max animation time =  10 seconds;
  if DateTimeToUnix(now) - ETime > 10 then FTimer.Enabled := False;

  try
    if (FTimer.Enabled = False) and (Assigned(FOnTimerFinished)) then
       FOnTimerFinished(Self,FSkinPart);
  except
  end;
end;

procedure TSharpEAnimTimer.OnInterpreterGetValue(Sender: TObject; Identifier: string; var Value: Variant; Args: TjvInterpreterArgs; var Done: Boolean);
const
  sBlendGradientFromColor    = 0;
  sBlendGraidentToColor      = 1;
  sBlendColor                = 2;
  sIncraseAlpha              = 3;
  sDecraseAlpha              = 4;
  sGetColor                  = 5;
  sIntToStr                  = 6;
  sStrToInt                  = 7;
  sGetAlpha                  = 8;
  sGetGradientFromColor      = 9;
  sGetGradientToColor        = 10;
  sSetAlpha                  = 11;
  sSetGradientFromAlpha      = 12;
  sSetGradientToAlpha        = 13;
  sIncreaseGradientFromAlpha = 14;
  sIncreaseGradientToAlpha   = 15;
  sDecraseGradientFromAlpha  = 16;
  sDecraseGradientToAlpha    = 17;
  sBlendTextColor            = 18;
  sGetTextColor              = 19;
  sSetTextColor              = 20;
  sGetTextAlpha              = 21;
  sSetTextAlpha              = 22;
  sIncreaseTextAlpha         = 23;
  sDecreaseTextAlpha         = 24;
  sGetTextShadowAlpha        = 25;
  sSetTextShadowAlpha        = 26;
  sIncreaseTextShadowAlpha   = 27;
  sDecreaseTextShadowAlpha   = 28;
  sGetTextShadowColor        = 29;
  sSetTextShadowColor        = 30;
  sBlendTextShadowColor      = 31;
  sSetColor                  = 32;
  sGetGradientFromAlpha      = 33;
  sGetGradientToAlpha        = 34;

var
  temp : TSkinPart;
  stype : integer;
   n : integer;
begin
  try
    for n := 0 to High(FScheme.Colors) do
    begin
      if CompareText(Identifier, FScheme.Colors[n].Tag) = 0 then
      begin
        Value := FScheme.Colors[n].Color;
        Done := True;
      end;
    end;

         if CompareText(Identifier,'BlendGradientFromColor') = 0      then stype := sBlendGradientFromColor
    else if CompareText(Identifier, 'BlendGradientToColor') = 0       then stype := sBlendGraidentToColor
    else if CompareText(Identifier, 'BlendColor') = 0                 then stype := sBlendColor
    else if CompareText(Identifier, 'IncreaseAlpha') = 0              then stype := sIncraseAlpha
    else if CompareText(Identifier, 'DecreaseAlpha') = 0              then stype := sDecraseAlpha
    else if CompareText(Identifier, 'GetColor') = 0                   then stype := sGetColor
    else if CompareText(Identifier, 'IntToStr')  = 0                  then stype := sIntToStr
    else if CompareText(Identifier, 'StrToInt')  = 0                  then stype := sStrToInt
    else if CompareText(Identifier, 'GetAlpha')  = 0                  then stype := sGetAlpha
    else if CompareText(Identifier, 'GetGradientFromColor')  = 0      then stype := sGetGradientFromColor
    else if CompareText(Identifier, 'GetGradientToColor')  = 0        then stype := sGetGradientToColor
    else if CompareText(Identifier, 'SetAlpha')  = 0                  then stype := sSetAlpha
    else if CompareText(Identifier, 'SetGradientFromAlpha')  = 0      then stype := sSetGradientFromAlpha
    else if CompareText(Identifier, 'SetGradientToAlpha')  = 0        then stype := sSetGradientToAlpha
    else if CompareText(Identifier, 'IncreaseGradientFromAlpha')  = 0 then stype := sIncreaseGradientFromAlpha
    else if CompareText(Identifier, 'IncreaseGradientToAlpha')  = 0   then stype := sIncreaseGradientToAlpha
    else if CompareText(Identifier, 'DecreaseGradientFromAlpha')  = 0 then stype := sDecraseGradientFromAlpha
    else if CompareText(Identifier, 'DecreaseGradientToAlpha')  = 0   then stype := sDecraseGradientToAlpha
    else if CompareText(Identifier, 'BlendTextColor') = 0             then stype := sBlendTextColor
    else if CompareText(Identifier, 'GetTextColor') = 0               then stype := sGetTextColor
    else if CompareText(Identifier, 'SetTextColor') = 0               then stype := sSetTextColor
    else if CompareText(Identifier, 'GetTextAlpha') = 0               then stype := sGetTextAlpha
    else if CompareText(Identifier, 'SetTextAlpha') = 0               then stype := sSetTextAlpha
    else if CompareText(Identifier, 'IncreaseTextAlpha') = 0          then stype := sIncreaseTextAlpha
    else if CompareText(Identifier, 'DecreaseTextAlpha') = 0          then stype := sDecreaseTextAlpha
    else if CompareText(Identifier, 'GetTextShadowColor') = 0         then stype := sGetTextShadowColor
    else if CompareText(Identifier, 'SetTextShadowColor') = 0         then stype := sSetTextShadowColor
    else if CompareText(Identifier, 'BlendTextShadowColor') = 0       then stype := sBlendTextShadowColor
    else if CompareText(Identifier, 'GetTextShadowAlpha') = 0         then stype := sGetTextShadowAlpha
    else if CompareText(Identifier, 'SetTextShadowAlpha') = 0         then stype := sSetTextShadowAlpha
    else if CompareText(Identifier, 'IncreaseTextShadowAlpha') = 0    then stype := sIncreaseTextShadowAlpha
    else if CompareText(Identifier, 'DecreaseTextShadowAlpha') = 0    then stype := sDecreaseTextShadowAlpha
    else if CompareText(Identifier, 'SetColor') = 0                   then stype := sSetColor
    else if CompareText(Identifier, 'GetGradientFromAlpha') = 0       then stype := sGetGradientFromAlpha
    else if CompareText(Identifier, 'GetGradientToAlpha') = 0         then stype := sGetGradientToAlpha
    else stype := -1;

    if    (stype = sBlendGradientFromColor)
       or (stype = sBlendGraidentToColor)
       or (stype = sBlendColor)
       or (stype = sIncraseAlpha)
       or (stype = sDecraseAlpha)
       or (stype = sSetAlpha)
       or (stype = sSetGradientFromAlpha)
       or (stype = sSetGradientToAlpha)
       or (stype = sIncreaseGradientFromAlpha)
       or (stype = sIncreaseGradientToAlpha)
       or (stype = sDecraseGradientFromAlpha)
       or (stype = sDecraseGradientToAlpha)
       or (stype = sBlendTextColor)
       or (stype = sSetTextColor)
       or (stype = sSetTextAlpha)
       or (stype = sIncreaseTextAlpha)
       or (stype = sDecreaseTextAlpha)
       or (stype = sSetTextShadowColor)
       or (stype = sSetTextShadowAlpha)
       or (stype = sIncreaseTextShadowAlpha)
       or (stype = sDecreaseTextShadowAlpha)
       or (stype = sBlendTextShadowColor)
       or (stype = sSetcolor) then
    begin
      temp := FindSkinPart(VarToStr(Args.Values[0]),FSkinPart);
      if temp <> nil then
      begin
//        AddToModList(temp, FModList);
        RestoreFromModList(temp, FLMList);
        case stype of
          sBlendGradientFromColor    : Script_BlendGradientFrom(temp,VarToStr(Args.Values[1]),VarToStr(Args.Values[2]),Args.Values[3],FScheme);
          sBlendGraidentToColor      : Script_BlendGradientTo(temp,VarToStr(Args.Values[1]),VarToStr(Args.Values[2]),Args.Values[3],FScheme);
          sBlendColor                : Script_BlendColor(temp,VarToStr(Args.Values[1]),VarToStr(Args.Values[2]),Args.Values[3],FScheme);
          sBlendTextColor            : Script_BlendTextColor(temp,VarToStr(Args.Values[1]),VarToStr(Args.Values[2]),Args.Values[3],FScheme);
          sIncraseAlpha              : Script_IncreaseAlpha(temp,Args.Values[1]);
          sDecraseAlpha              : Script_DecreaseAlpha(temp,Args.Values[1]);
          sSetTextColor              : Script_SetTextColor(temp,Args.Values[1],FScheme);
          sSetAlpha                  : Script_SetAlpha(temp,Args.Values[1]);
          sSetGradientFromAlpha      : Script_SetGradientFromAlpha(temp,Args.Values[1]);
          sSetGradientToAlpha        : Script_SetGradientToAlpha(temp,Args.Values[1]);
          sIncreaseGradientFromAlpha : Script_IncreaseGradientFromAlpha(temp,Args.Values[1]);
          sIncreaseGradientToAlpha   : Script_IncreaseGradientToAlpha(temp,Args.Values[1]);
          sDecraseGradientFromAlpha  : Script_DecraseGradientFromAlpha(temp,Args.Values[1]);
          sDecraseGradientToAlpha    : Script_DecraseGradientToAlpha(temp,Args.Values[1]);
          sSetTextAlpha              : Script_SetTextAlpha(temp,Args.Values[1]);
          sIncreaseTextAlpha         : Script_IncreaseTextAlpha(temp,Args.Values[1]);
          sDecreaseTextAlpha         : Script_DecreaseTextAlpha(temp,Args.Values[1]);
          sSetTextShadowAlpha        : Script_SetTextShadowAlpha(temp,Args.Values[1]);
          sSetTextShadowColor        : Script_SetTextShadowColor(temp,Args.Values[1],FScheme);
          sIncreaseTextShadowAlpha   : Script_IncreaseTextShadowAlpha(temp,Args.Values[1]);
          sDecreaseTextShadowAlpha   : Script_DecreaseTextShadowAlphA(temp,Args.Values[1]);
          sBlendTextShadowColor      : Script_BlendTextShadowColor(temp,VarToStr(Args.Values[1]),VarToStr(Args.Values[2]),Args.Values[3],FScheme);
          sSetColor                  : Script_SetColor(temp,Args.Values[1],FScheme);
        end;
        AddToModList(temp, FLMList);
      end;
      Done := True;
    end else
    if    (stype = sGetColor)
       or (stype = sIntToStr)
       or (stype = sStrToInt)
       or (stype = sGetAlpha)
       or (stype = sGetGradientFromColor)
       or (stype = sGetGradientToColor)
       or (stype = sGetTextColor)
       or (stype = sGetTextAlpha)
       or (stype = sGetTextShadowColor)
       or (stype = sGetTextShadowAlpha)
       or (stype = sGetGradientFromAlpha)
       or (stype = sGetGradientToAlpha) then
    begin
      temp := FindSkinPart(VarToStr(Args.Values[0]),FSkinPart);
      if temp <> nil then
      begin
        case stype of
          sGetColor             : Value := Script_GetColor(temp);
          sIntToStr             : Value := Script_Inttostr(Args.Values[0]);
          sStrToInt             : Value := Script_Inttostr(Args.Values[0]);
          sGetAlpha             : Value := Script_GetAlpha(temp);
          sGetGradientFromColor : Value := Script_GetGradientFromColor(temp);
          sGetGradientToColor   : Value := Script_GetGradientToColor(temp);
          sGetTextColor         : Value := Script_GetTextColor(temp);
          sGetTextAlpha         : Value := Script_GetTextAlpha(temp);
          sGetGradientFromAlpha : Value := Script_GetGradientFromAlpha(temp);
          sGetGradientToAlpha   : Value := Script_GetGradientToAlpha(temp);
        end;
      end;
      Done := True;
    end;
  except
    FTimer.Enabled := False;
  end;
end;

function TSharpEAnimTimer.FindSkinPart(ID : String; BasePart : TSkinPart) : TSkinPart;
var
  n : integer;
begin
  if BasePart.ID = ID then
  begin
    result := BasePart;
    exit;
  end;
  for n := 0 to BasePart.Items.Count -1 do
  begin
    result := FindSkinPart(ID,BasePart.Items[n]);
    if result <> nil then exit;
  end;
  result := nil;
end;


constructor TSharpETimerManager.Create;
begin
  Inherited Create;
  FTimers := TObjectList.Create;
  FCheckTimer := TTimer.Create(nil);
  FCheckTimer.OnTimer := OnCheckTimer;
  FCheckTimer.Interval := 1000;
  FCheckTimer.Enabled := False;
end;

destructor TSharpETimerManager.Destroy;
begin
  FTimers.Free;
  FCheckTimer.Free;
  Inherited Destroy;
end;

function TSharpETimerManager.ExecuteScript(pComponent : TObject;
                                           pScript : String;
                                           pSkinPart : TSkinPart;
                                           pScheme : TSharpEScheme) : TSharpEAnimTimer;
var
  n : integer;
  temp : TSharpEAnimTimer;
begin
  for n := 0 to FTimers.Count -1 do
  begin
    temp := TSharpEAnimTimer(FTimers.Items[n]);
    if temp.Component = pComponent then
    begin
      temp.Update(pComponent,pScript,pSkinPart,pScheme);
      result := temp;
      exit;
    end;
  end;
  temp := TSharpEAnimTimer.Create(pComponent,pScript,pSkinPart,pScheme);
  FTimers.Add(temp);
  result := temp;
  FCheckTimer.Enabled := True;
end;

procedure TSharpETimerManager.OnCheckTimer(Sender : TObject);
var
  n : integer;
  temp : TSharpEAnimTimer;
begin
  for n := FTimers.Count - 1 downto 0 do
  begin
    temp := TSharpEAnimTimer(FTimers.Items[n]);
    if (not temp.Timer.Enabled) or (not assigned(temp.Component)) then
    begin
      FTimers.Extract(temp);
      temp.Free;
    end;
  end;

  if FTimers.Count = 0 then FCheckTimer.Enabled := False;
end;

function TSharpETimerManager.HasScriptRunning(pComponent : TObject) : boolean;
var
  n : integer;
  temp : TSharpEAnimTimer;
begin
  for n := 0 to FTimers.Count -1 do
  begin
    temp := TSharpEAnimTimer(FTimers.Items[n]);
    if (temp.Component = pComponent) and (temp.Timer.Enabled) then
    begin
      result := True;
      exit;
    end;
  end;
  result := False;
end;

procedure TSharpETimerManager.StopScript(pComponent : TObject);
var
  n : integer;
  temp : TSharpEAnimTimer;
begin
  for n := 0 to FTimers.Count -1 do
  begin
    temp := TSharpEAnimTimer(FTimers.Items[n]);
    if (temp.Component = pComponent)then
    begin
      temp.Timer.Enabled := False;
      exit;
    end;
  end;
end;


initialization
  SharpEAnimManager := TSharpETimerManager.Create;
  
finalization
  SharpEAnimManager.Free;

end.
