unit SharpEAnimationTimers;

interface

uses
  DateUtils,
  Dialogs,
  Windows,
  SysUtils,
  Math,
  Graphics,
  SharpESkin,
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
                    BlendColor : String;
                    BlendAlpha : integer;
                    GradientColorFrom : String;
                    GradientColorTo   : String;
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
                     published
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
                        published
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
  try
    result := StrToInt(Str);
  except
    result := 0;
  end;
end;

function Script_GetGradientFromColor(SP : TSkinPart) : String;
begin
  result := SP.GradientColor.X;
end;

function Script_GetGradientToColor(SP : TSkinPart) : String;
begin
  result := SP.GradientColor.Y;
end;

function Script_GetColor(SP : TSkinPart) : String;
begin
  result := SP.BlendColor;
end;

function Script_GetAlpha(SP : TSkinPart) : integer;
begin
  result := SP.BlendAlpha;
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
  SP.BlendAlpha := Min(255,SP.BlendAlpha + Amount);
end;

procedure Script_DecreaseAlpha(SP : TSkinPart; Amount : integer);
begin
  SP.BlendAlpha := Max(0,SP.BlendAlpha - Amount);
end;

procedure Script_BlendColor(SP : TSkinPart; pFromColor, pToColor : String; Step : integer; Scheme : TSharpEScheme);
var
  NewColor : integer;
  CurrentColor, FromColor, ToColor : integer;
begin
  FromColor := SchemedStringToColor(pFromColor, Scheme);
  ToColor := SchemedStringToColor(pToColor, Scheme);
  CurrentColor := SchemedStringToColor(SP.BlendColor, Scheme);
  NewColor := StepBlendColor(FromColor,ToColor,CurrentColor,Step);

  if NewColor = ToColor then SP.BlendColor := pToColor
     else SP.BlendColor := inttostr(NewColor);
end;

procedure Script_BlendGradientFrom(SP : TSkinPart; pFromColor, pToColor : String; Step : integer; Scheme : TSharpEScheme);
var
  NewColor : integer;
  CurrentColor, FromColor, ToColor : integer;
begin
  FromColor := SchemedStringToColor(pFromColor, Scheme);
  ToColor := SchemedStringToColor(pToColor, Scheme);
  CurrentColor := SchemedStringToColor(SP.GradientColor.X, Scheme);
  NewColor := StepBlendColor(FromColor,ToColor,CurrentColor,Step);

  if NewColor = ToColor then SP.GradientColor.SetPoint(pToColor,SP.GradientColor.Y)
     else SP.GradientColor.SetPoint(inttostr(NewColor),SP.GradientColor.Y);
end;

procedure Script_BlendGradientTo(SP : TSkinPart; pFromColor, pToColor : String; Step : integer; Scheme : TSharpEScheme);
var
  NewColor : integer;
  CurrentColor, FromColor, ToColor : integer;
begin
  FromColor := SchemedStringToColor(pFromColor, Scheme);
  ToColor := SchemedStringToColor(pToColor, Scheme);
  CurrentColor := SchemedStringToColor(SP.GradientColor.Y, Scheme);
  NewColor := StepBlendColor(FromColor,ToColor,CurrentColor,Step);

  if NewColor = ToColor then SP.GradientColor.SetPoint(SP.GradientColor.X,pToColor)
     else SP.GradientColor.SetPoint(SP.GradientColor.X,inttostr(NewColor));
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
    SP.GradientColor.SetPoint(GradientColorFrom,GradientColorTo);
    SP.BlendAlpha := BlendAlpha;
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
    GradientColorFrom := SP.GradientColor.X;
    GradientColorTo := SP.GradientColor.Y;
    BlendAlpha := SP.BlendAlpha;
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
    continue :=  FInterpreter.CallFunction('OnAnimate',nil,[]);
  except
    continue := False;
  end;
  FTimer.Enabled := continue;

  SharpEAnimManager.TimerActive := True;
  try
    if FComponent is TCustomSharpEGraphicControl then
       TCustomSharpEGraphicControl(FComponent).UpdateSkin
    else if FComponent is TCustomSharpEComponent then
            TCustomSharpEComponent(FComponent).UpdateSkin
    else if FComponent is TCustomSharpEControl then
            TCustomSharpEControl(FComponent).UpdateSkin;
  finally
    SharpEAnimManager.TimerActive := FalsE;
  end;

  RestoreSkinParts;

  // max animation time =  10 seconds;
  if DateTimeToUnix(now) - ETime > 10 then FTimer.Enabled := False;

  if (FTimer.Enabled = False) and (Assigned(FOnTimerFinished)) then
     FOnTimerFinished(Self,FSkinPart);
end;

procedure TSharpEAnimTimer.OnInterpreterGetValue(Sender: TObject; Identifier: string; var Value: Variant; Args: TjvInterpreterArgs; var Done: Boolean);
const
  sBlendGradientFromColor = 0;
  sBlendGraidentToColor   = 1;
  sBlendColor             = 2;
  sIncraseAlpha           = 3;
  sDecraseAlpha           = 4;
  sGetColor               = 5;
  sIntToStr               = 6;
  sStrToInt               = 7;
  sGetAlpha               = 8;
  sGetGradientFromColor   = 9;
  sGetGradientToColor     = 10;

var
  temp : TSkinPart;
  stype : integer;
begin
  try
         if CompareText(Identifier,'BlendGradientFromColor') = 0 then stype := sBlendGradientFromColor
    else if CompareText(Identifier,'BlendGradientToColor') = 0   then stype := sBlendGraidentToColor
    else if CompareText(Identifier, 'BlendColor') = 0            then stype := sBlendColor
    else if CompareText(Identifier, 'IncreaseAlpha') = 0         then stype := sIncraseAlpha
    else if CompareText(Identifier, 'DecreaseAlpha') = 0         then stype := sDecraseAlpha
    else if CompareText(Identifier, 'GetColor') = 0              then stype := sGetColor
    else if CompareText(Identifier, 'IntToStr')  = 0             then stype := sIntToStr
    else if CompareText(Identifier, 'StrToInt')  = 0             then stype := sStrToInt
    else if CompareText(Identifier, 'GetAlpha')  = 0             then stype := sGetAlpha
    else if CompareText(Identifier, 'GetGradientFromColor')  = 0 then stype := sGetGradientFromColor
    else if CompareText(Identifier, 'GetGradientToColor')  = 0   then stype := sGetGradientToColor
    else stype := -1;

    if    (stype = sBlendGradientFromColor)
       or (stype = sBlendGraidentToColor)
       or (stype = sBlendColor)
       or (stype = sIncraseAlpha)
       or (stype = sDecraseAlpha) then
    begin
      temp := FindSkinPart(VarToStr(Args.Values[0]),FSkinPart);
      if temp <> nil then
      begin
        AddToModList(temp, FModList);
        RestoreFromModList(temp, FLMList);
        case stype of
          sBlendGradientFromColor : Script_BlendGradientFrom(temp,VarToStr(Args.Values[1]),VarToStr(Args.Values[2]),Args.Values[3],FScheme);
          sBlendGraidentToColor   : Script_BlendGradientTo(temp,VarToStr(Args.Values[1]),VarToStr(Args.Values[2]),Args.Values[3],FScheme);
          sBlendColor             : Script_BlendColor(temp,VarToStr(Args.Values[1]),VarToStr(Args.Values[2]),Args.Values[3],FScheme);
          sIncraseAlpha           : Script_IncreaseAlpha(temp,Args.Values[1]);
          sDecraseAlpha           : Script_DecreaseAlpha(temp,Args.Values[1]);
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
       or (stype = sGetGradientToColor) then
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
    if not temp.Timer.Enabled then
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
