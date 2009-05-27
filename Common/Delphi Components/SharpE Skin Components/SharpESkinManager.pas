{
Source Name: SharpESkinManager
Description: SharpE component for SharpE
Copyright (C) Malx (Malx@techie.com)
              Martin Krämer (MartinKraemer@gmx.net)

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
unit SharpESkinManager;

interface

uses
  Windows,
  Messages,
  Types,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  StdCtrls,
  Forms,
  gr32,
  ISharpESkinComponents,
  SharpEAnimationTimers,
  SharpEBase,
  SharpEDefault,
  SharpESkin,
  SharedBitmapList,
  SharpEScheme,
  SharpApi,
  SharpTypes;

type
  TSkinSource = (ssDefault, ssSystem, ssComponent);
  TSchemeSource = TSkinSource;


  TSharpESkinManager = class(TInterfacedObject,ISharpESkinManager)
  private
    FRootInterface: ISharpESkinManager;
    FNoSystemSchemeInit: boolean;
    FOnSkinChanged: TNotifyEvent;
    FUsingMainWnd : boolean;
    FHandleUpdates : boolean;
    FHandleThemeApiUpdates : boolean;
    FSkinItems : TSharpESkinItems;
    FMsgWnd : Hwnd;
    FMainForm : TForm;
    FScheme : TSharpEScheme;
    FSchemeInterface : ISharpEScheme;
    FSkin : TSharpESkin;
    FSkinInterface : ISharpESkin;
    procedure ComponentSkinUpdated;
    function MessageHook(var Msg: TMessage): Boolean;
    procedure MessageHook2(var Msg: TMessage);
    procedure SetSkinItems(Value : TSharpESkinItems);
    function GetSkinItems : TSharpESkinItems; stdcall;
  protected
  public
    constructor Create(MainForm: TComponent); reintroduce; overload; 
    constructor Create(MainForm: TComponent; Skins : TSharpESkinItems); reintroduce; overload;
    constructor CreateRuntime(MainForm: TComponent; Skin : TSharpESkin; Scheme : TSharpEScheme; Skins : TSharpESkinItems = ALL_SHARPE_SKINS); overload;
    constructor CreateRuntime(MainForm: TComponent; Skin : TSharpESkin; Scheme : TSharpEScheme; NoSystemScheme : boolean; Skins : TSharpESkinItems = ALL_SHARPE_SKINS); overload;
    destructor Destroy; override;
    procedure LoadSkinFromStream;
    property RootInterface: ISharpESkinManager read FRootInterface write FRootInterface;
    property MainForm: TForm read FMainForm write FMainForm;
    property HandleUpdates : boolean read FHandleUpdates write FHandleUpdates;
    property HandleThemeApiUpdates : boolean read FHandleThemeApiUpdates write FHandleThemeApiUpdates;
    property onSkinChanged: TNotifyEvent read FOnSkinChanged write FOnSkinChanged;
    property SkinItems : TSharpESkinItems read GetSkinItems write SetSkinItems;

    // ISharpESkinManager Interface
    function AnimationHasScriptRunning(pComponent : TObject) : boolean; stdcall;
    procedure AnimationStopScript(pComponent : TObject); stdcall;
    function AnimationIsTimerActive : boolean; stdcall;

    function ParseColor(src : String) : integer; stdcall;

    procedure RefreshControls; stdcall;
    procedure UpdateSkin; stdcall;
    procedure UpdateScheme; stdcall;    

    function GetScheme : ISharpEScheme; stdcall;
    function GetSkin : ISharpESkin; stdcall;

    function GetBarBottom : boolean; stdcall;
    procedure SetBarBottom(Value : boolean); stdcall;

    property Scheme : ISharpEScheme read GetScheme;
    property Skin : ISharpESkin read GetSkin;

    property BarBottom : boolean read GetBarBottom write SetBarBottom;
  end;

procedure LoadSharpEScheme(Scheme: TSharpEScheme);

implementation
uses
  SharpEBaseControls,
  SharpThemeApiEx,
  uThemeConsts,
  uISharpETheme,
  SharpESkinPart;

constructor TSharpESkinManager.CreateRuntime(MainForm: TComponent;
                                             Skin : TSharpESkin; Scheme : TSharpEScheme;
                                             NoSystemScheme : boolean;
                                             Skins : TSharpESkinItems = ALL_SHARPE_SKINS);
begin
  FNoSystemSchemeInit := NoSystemScheme;
  CreateRuntime(MainForm, Skin, Scheme, Skins);
end;

constructor TSharpESkinManager.CreateRuntime(MainForm: TComponent;
                                             Skin : TSharpESkin; Scheme : TSharpEScheme;
                                             Skins : TSharpESkinItems = ALL_SHARPE_SKINS);
begin
  FScheme := Scheme;
  FSkin := Skin;
  Create(MainForm,Skins);
end;

procedure TSharpESkinManager.SetBarBottom(Value: boolean);
begin
  SharpESkinPart.SharpESkinTextBarBottom := Value;
end;

procedure TSharpESkinManager.SetSkinItems(Value : TSharpESkinItems);
begin
  if Value <> FSkinItems then
  begin
    FSkinItems := Value;
    FreeAndNil(FSkin);
    FSkin := TSharpESkin.Create(FSkinItems);
    FSkin.OnNotify := ComponentSkinUpdated;
    UpdateSkin;
  end;
end;

constructor TSharpESkinManager.Create(MainForm: TComponent);
begin
  Create(MainForm, ALL_SHARPE_SKINS);
end;

constructor TSharpESkinManager.Create(MainForm: TComponent; Skins : TSharpESkinItems);
begin
  FRootInterface := nil;
  FSkinItems := Skins;

  if FScheme = nil then
    FScheme := TSharpEScheme.Create;
  FSchemeInterface := FScheme;
      
  if (FSkinItems <> []) and (FSkin = nil) then
  begin
    FSkin := TSharpESkin.Create(FSkinItems);
    FSkin.OnNotify := ComponentSkinUpdated;
  end;
  FSkinInterface := FSkin;

  FHandleUpdates := True;
  FHandleThemeApiUpdates := True;

  inherited Create;

  //Hook a message wnd....
  FUsingMainWnd := Application.Handle <> 0;
  If FUsingMainWnd then begin
    Application.HookMainWindow(MessageHook);
    FMsgWnd := Application.Handle;
  end
  else begin
    FMsgWnd := classes.AllocateHwnd(MessageHook2);
  end;

  UpdateSkin;
 end;

destructor TSharpESkinManager.Destroy;
begin
  if FUsingMainWnd then Application.UnHookMainWindow(MessageHook)
  else Classes.DeAllocateHwnd(FMsgWnd) ;

  FSchemeInterface := nil;
  FSkinInterface := nil;
  FScheme := nil;
  FSkin := nil;
  inherited;
end;

procedure TSharpESkinManager.UpdateSkin;
begin
  LoadSkinFromStream;
  if not FNoSystemSchemeInit then
    LoadSharpEScheme(FScheme);
  FSkin.UpdateDynamicProperties(FSchemeInterface);
  RefreshControls;
  if Assigned(FOnSkinChanged) then FOnSkinChanged(self);
end;

procedure TSharpESkinManager.UpdateScheme;
begin
  if not FNoSystemSchemeInit then
    LoadSharpEScheme(FScheme);
  FSkin.UpdateDynamicProperties(FSchemeInterface);
  RefreshControls;
end;

function TSharpESkinManager.MessageHook(var Msg: TMessage): Boolean;
var
  Theme : ISharpETheme;
begin
  result := false;
  if not FHandleUpdates then
  begin
    Msg.Result := DefWindowProc(FMsgWnd,Msg.Msg,Msg.WParam,Msg.LParam);
    exit;
  end;

  if (Msg.Msg = WM_SHARPEUPDATESETTINGS) then
  begin
    if (FHandleThemeApiUpdates)
      and ([TSU_UPDATE_ENUM(msg.WParam)] <= [suSkinFont,suSkinFileChanged,suTheme,
                                            suIconSet,suScheme]) then
      Theme := GetCurrentTheme;
    if (Msg.WParam = Integer(suTheme)) then
    begin
      if FHandleThemeApiUpdates then
        Theme.LoadTheme;
    end else
    if (Msg.WParam = Integer(suSkinFont)) then
    begin
      if FHandleThemeApiUpdates then
        Theme.LoadTheme([tpSkinFont]);
      RefreshControls;
    end
    else if (Msg.WParam = Integer(suSkinFileChanged)) then
    begin
      if FHandleThemeApiUpdates then
        Theme.LoadTheme([tpSkinScheme]);
      UpdateSkin;
    end
    else if (Msg.WParam = Integer(suScheme)) then
    begin
      if FHandleThemeApiUpdates then
        Theme.LoadTheme([tpSkinScheme]);
      UpdateScheme;
      if Assigned(FOnSkinChanged) then FOnSkinChanged(self);
        RefreshControls;
    end;
  end else Msg.Result := DefWindowProc(FMsgWnd,Msg.Msg,Msg.WParam,Msg.LParam);
end;

procedure TSharpESkinManager.MessageHook2(var Msg: TMessage);
begin
  MessageHook(Msg);
end;

function TSharpESkinManager.ParseColor(src: String): integer;
begin
  result := SharpESkinPart.ParseColor(src,FSchemeInterface);
end;

procedure TSharpESkinManager.RefreshControls;
var
  i: Integer;
  u : boolean;
  p : TPoint;
begin
  if MainForm = nil then exit;

  if MainForm is TForm then
  begin
    p := TForm(MainForm).ClientToScreen(point(0,0));
    u := SharpESkinTextBarBottom;
    if p.y > TForm(MainForm).Monitor.Top + TForm(MainForm).Monitor.Height div 2 then
      SharpESkinTextBarBottom := True
    else SharpESkinTextBarBottom := False;
    if SharpESkinTextBarBottom <> u then
      Skin.UpdateDynamicProperties(FSchemeInterface);
  end;

  for i := MainForm.ComponentCount - 1 downto 0 do
  begin
    if (MainForm.Components[i] is TCustomSharpEGraphicControl) then
       (MainForm.Components[i] as TCustomSharpEGraphicControl).UpdateSkin(self)
    else
      if (MainForm.Components[i] is TCustomSharpEComponent) then
         (MainForm.Components[i] as TCustomSharpEComponent).UpdateSkin(self)
      else
       if (MainForm.Components[i] is TCustomSharpEControl) then
         (MainForm.Components[i] as TCustomSharpEControl).UpdateSkin(self);
  end;
end;

function TSharpESkinManager.AnimationHasScriptRunning(pComponent: TObject): boolean;
begin
  result := SharpEAnimManager.HasScriptRunning(pComponent);
end;

function TSharpESkinManager.AnimationIsTimerActive: boolean;
begin
  result := SharpEAnimManager.TimerActive;
end;

procedure TSharpESkinManager.AnimationStopScript(pComponent: TObject);
begin
  SharpEAnimManager.StopScript(pComponent);
end;

procedure TSharpESkinManager.ComponentSkinUpdated;
begin
  RefreshControls;
end;

function TSharpESkinManager.GetBarBottom: boolean;
begin
  result := SharpESkinPart.SharpESkinTextBarBottom;
end;

function TSharpESkinManager.GetScheme: ISharpEScheme;
begin
  result := FSchemeInterface;
end;

function TSharpESkinManager.GetSkin: ISharpESkin;
begin
  result := FSkinInterface;
end;

function TSharpESkinManager.GetSkinItems: TSharpESkinItems;
begin
  result := FSkinItems;
end;

procedure TSharpESkinManager.LoadSkinFromStream;
var
  loadfile : String;
  Stream : TMemoryStream;
begin
  FSkin.Clear;

  loadfile := SharpApi.GetSharpeUserSettingsPath + 'SharpE.skin';
  if FileExists(loadfile) then
  begin
    Stream := TMemoryStream.Create;
    Stream.LoadFromFile(loadfile);
    try
      FSkin.LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;
end;

//***********************************
//* Help functions
//***********************************

procedure LoadSharpEScheme(Scheme: TSharpEScheme);
var
  n : integer;
  Theme : ISharpETheme;
begin
  try
    Theme := GetCurrentTheme;
    Scheme.ClearColors;
    for n := 0 to Theme.Scheme.GetColorCount - 1 do
        Scheme.AddColor(Theme.Scheme.GetColorByIndex(n));
  except
    Scheme.Assign(DefaultSharpEScheme);
  end;
end;

end.
