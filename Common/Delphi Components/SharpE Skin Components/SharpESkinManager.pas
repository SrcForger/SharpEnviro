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
  Forms,
  Dialogs,
  StdCtrls,
  gr32,
  SharpEBase,
  SharpEDefault,
  SharpESkin,
  SharedBitmapList,
  SharpEScheme,
  SharpApi,
  SharpCenterApi;

type
  TSkinSource = (ssDefault, ssSystem, ssComponent);
  TSchemeSource = TSkinSource;


  TSharpESkinManager = class(TComponent)
  private
    FNoSystemSchemeInit: boolean;
    FOnSkinChanged: TNotifyEvent;
    FSkinSource: TSkinSource;
    FSchemeSource: TSkinSource;
    FSystemScheme: TSharpEScheme;
    FComponentScheme: TSharpEScheme;
    FSystemSkin: TSystemSharpESkin;
    FComponentSkin: TSharpESkin;
    FUsingMainWnd : boolean;
    FHandleUpdates : boolean;
    FSkinItems : TSharpESkinItems;
    FMsgWnd : Hwnd;
    procedure SystemSkinChanged(sender : TObject);
    procedure SetSkinSource(value: TSkinSource);
    procedure SetSchemeSource(value: TSchemeSource);
    procedure SetComponentScheme(value: TSharpEScheme);
    procedure SetComponentSkin(value: TSharpESkin);
    function GetScheme: TSharpEScheme;
    function GetSkin: TSharpESkin;
    procedure ComponentSchemeUpdated;
    procedure ComponentSkinUpdated;
    function MessageHook(var Msg: TMessage): Boolean;
    procedure MessageHook2(var Msg: TMessage);
    procedure SetComponentSkins(Value : TSharpESkinItems);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; Skins : TSharpESkinItems = ALL_SHARPE_SKINS); reintroduce; overload;
    constructor CreateRuntime(AOwner: TComponent; Skin : TSharpESkin; Scheme : TSharpEScheme; Skins : TSharpESkinItems = ALL_SHARPE_SKINS); overload;
    constructor CreateRuntime(AOwner: TComponent; Skin : TSharpESkin; Scheme : TSharpEScheme; NoSystemScheme : boolean; Skins : TSharpESkinItems = ALL_SHARPE_SKINS); overload;
    destructor Destroy; override;
    property Scheme: TSharpEScheme read GetScheme;
    property Skin: TSharpESkin read GetSkin;
    property SystemSkin: TSystemSharpESkin read FSystemSkin;
    procedure RefreshControls;
    procedure UpdateSkin;
    procedure UpdateScheme;
  published
    property SkinSource: TSkinSource read FSkinSource write SetSkinSource;
    property SchemeSource: TSchemeSource read FSchemeSource write SetSchemeSource;
    property CompScheme: TSharpEScheme read FComponentScheme write SetComponentScheme;
    property CompSkin: TSharpESkin read FComponentSkin write SetComponentSkin;
    property ComponentSkins: TSharpESkinItems read FSkinItems write SetComponentSkins default ALL_SHARPE_SKINS;
    property HandleUpdates : boolean read FHandleUpdates write FHandleUpdates;
    property onSkinChanged: TNotifyEvent read FOnSkinChanged write FOnSkinChanged;
  end;

procedure LoadSharpEScheme(Scheme: TSharpEScheme);

implementation
uses
  SharpEBaseControls,
  SharpThemeApi,
  SharpESkinPart;

constructor TSharpESkinManager.CreateRuntime(AOwner: TComponent;
                                             Skin : TSharpESkin; Scheme : TSharpEScheme;
                                             NoSystemScheme : boolean;
                                             Skins : TSharpESkinItems = ALL_SHARPE_SKINS);
begin
  FNoSystemSchemeInit := NoSystemScheme;
  CreateRuntime(AOwner, Skin, Scheme, Skins);
end;

constructor TSharpESkinManager.CreateRuntime(AOwner: TComponent;
                                             Skin : TSharpESkin; Scheme : TSharpEScheme;
                                             Skins : TSharpESkinItems = ALL_SHARPE_SKINS);
begin
  FComponentScheme := Scheme;
  FComponentSkin := Skin;
  Create(AOwner,Skins);
end;

procedure TSharpESkinManager.SetComponentSkins(Value : TSharpESkinItems);
begin
  if Value <> FSkinItems then
  begin
    FSkinItems := Value;
    FreeAndNil(FSystemSkin);
    FSystemSkin := TSystemSharpESkin.create(FSkinItems);
    FSystemSkin.OnSkinChanged := SystemSkinChanged;
    FSystemSkin.OnNotify := ComponentSkinUpdated;
    UpdateSkin;
  end;
end;

constructor TSharpESkinManager.Create(AOwner: TComponent);
begin
  Create(AOwner, [scBar]);
end;

constructor TSharpESkinManager.Create(AOwner: TComponent; Skins : TSharpESkinItems = ALL_SHARPE_SKINS);
begin
  FSkinItems := Skins;

  FSystemScheme := TSharpEScheme.create(nil);
  if FSkinItems <> [] then
  begin
    FSystemSkin := TSystemSharpESkin.create(FSkinItems);
    FSystemSkin.OnSkinChanged := SystemSkinChanged;
    FSystemSkin.OnNotify := ComponentSkinUpdated;
  end;

  FHandleUpdates := True;

  if not FNoSystemSchemeInit then
  begin
    if not (csDesigning in ComponentState) then
    begin
      if not SharpThemeApi.Initialized then
      begin
        SharpThemeApi.InitializeTheme;
        SharpThemeApi.LoadTheme(True,[tpSkin,tpScheme]);
      end;
    end;

    LoadSharpEScheme(FSystemScheme);
  end;

  inherited Create(AOwner);

 //Default values
  FSchemeSource := ssDefault;
  FSkinSource := ssDefault;


  //Hook a message wnd....
  FUsingMainWnd := Application.Handle <> 0;
  If FUsingMainWnd then begin
    Application.HookMainWindow(MessageHook);
    FMsgWnd := Application.Handle;
  end
  else begin
    FMsgWnd := classes.AllocateHwnd(MessageHook2);
  end;

  if (FSkinSource = ssSystem) and not (csDesigning in ComponentState) then
     FSystemSkin.Activated := true
 end;

destructor TSharpESkinManager.Destroy;
begin
  if FUsingMainWnd then Application.UnHookMainWindow(MessageHook)
  else Classes.DeAllocateHwnd(FMsgWnd) ;

  FSystemScheme.Free;
  FSystemSkin.Free;
  inherited;
end;

procedure TSharpESkinManager.Loaded;
begin
  inherited;
  RefreshControls;
end;

procedure TSharpESkinManager.SystemSkinChanged(sender : TObject);
begin
  Skin.UpdateDynamicProperties(Scheme);
  if Assigned(FOnSkinChanged) then
     FOnSkinChanged(self);
end;

procedure TSharpESkinManager.UpdateSkin;
begin
  if SkinSource = ssSystem then
  begin
    SystemSkin.LoadSkinFromStream;
    LoadSharpEScheme(FSystemScheme);
  end;
  Skin.UpdateDynamicProperties(Scheme);
  RefreshControls;
  if Assigned(FOnSkinChanged) then FOnSkinChanged(self);
end;

procedure TSharpESkinManager.UpdateScheme;
begin
  if SkinSource = ssSystem then
     LoadSharpEScheme(FSystemScheme);
  Skin.UpdateDynamicProperties(Scheme);
  RefreshControls;
end;

function TSharpESkinManager.MessageHook(var Msg: TMessage): Boolean;
begin
  result := false;
  if not FHandleUpdates then exit;

  if (Msg.Msg = WM_SHARPEUPDATESETTINGS) then
  begin
    if (Msg.WParam = Integer(suSkinFont)) then
    begin
      if not (csDesigning in ComponentState) then
        SharpThemeApi.LoadTheme(False,[tpSkinFont]);
        RefreshControls;
    end
    else if (Msg.WParam = Integer(suSkinFileChanged)) then
    begin
      if not (csDesigning in ComponentState) then
         SharpThemeApi.LoadTheme(False,[tpSkin,tpScheme]);
      UpdateSkin;
    end
    else if (Msg.WParam = Integer(suScheme)) then
    begin
      if not (csDesigning in ComponentState) then
         SharpThemeApi.LoadTheme(False,[tpSkin,tpScheme]);
      UpdateScheme;
      if Assigned(FOnSkinChanged) then FOnSkinChanged(self);
      RefreshControls;
    end;
  end;
end;

procedure TSharpESkinManager.MessageHook2(var Msg: TMessage);
begin
  MessageHook(Msg);
end;

procedure TSharpESkinManager.RefreshControls;
var
  i: Integer;
  u : boolean;
  p : TPoint;
begin
  if Owner = nil then exit;

  if Owner is TForm then
  begin
    p := TForm(Owner).ClientToScreen(point(0,0));
    u := SharpESkinTextBarBottom;
    if p.y > TForm(Owner).Monitor.Top + TForm(Owner).Monitor.Height div 2 then
      SharpESkinTextBarBottom := True
    else SharpESkinTextBarBottom := False;
    if SharpESkinTextBarBottom <> u then
      Skin.UpdateDynamicProperties(Scheme);
  end;

  for i := Owner.ComponentCount - 1 downto 0 do
  begin
    if (Owner.Components[i] is TCustomSharpEGraphicControl) then
       (Owner.Components[i] as TCustomSharpEGraphicControl).UpdateSkin(self)
    else
      if (Owner.Components[i] is TCustomSharpEComponent) then
         (Owner.Components[i] as TCustomSharpEComponent).UpdateSkin(self)
      else
       if (Owner.Components[i] is TCustomSharpEControl) then
         (Owner.Components[i] as TCustomSharpEControl).UpdateSkin(self);
 {   if (Owner.Components[i] is TSharpEButton) then
      (Owner.Components[i] as TSharpEButton).UpdateSkin(self)
    else
      if (Owner.Components[i] is TSharpEForm) then
        (Owner.Components[i] as TSharpEForm).UpdateSkin(self)
      else
        if (Owner.Components[i] is TSharpEBar) then
          (Owner.Components[i] as TSharpEBar).UpdateSkin(self)
        else
          if (Owner.Components[i] is TSharpEPanel) then
            (Owner.Components[i] as TSharpEPanel).UpdateSkin(self)
          else
            if (Owner.Components[i] is TSharpECheckBox) then
              (Owner.Components[i] as TSharpECheckBox).UpdateSkin(self)
            else
              if (Owner.Components[i] is TSharpEProgressBar) then
                (Owner.Components[i] as TSharpEProgressBar).UpdateSkin(self)
              else
                  if (Owner.Components[i] is TSharpEThrobber) then
                    (Owner.Components[i] as TSharpEThrobber).UpdateSkin(self)
                  else
                    if (Owner.Components[i] is TSharpELabel) then
                      (Owner.Components[i] as TSharpELabel).UpdateSkin(self)
                    else
                      if (Owner.Components[i] is TSharpERadioBox) then
                        (Owner.Components[i] as TSharpERadioBox).UpdateSkin(self)
                      else
                        if (Owner.Components[i] is TSharpEEdit) then
                          (Owner.Components[i] as TSharpEEdit).UpdateSkin(self)
                        else
                          if (Owner.Components[i] is TSharpEMiniThrobber) then
                            (Owner.Components[i] as TSharpEMiniThrobber).UpdateSkin(self)
                          else if (Owner.Components[i] is TSharpETaskItem) then
                             (Owner.Components[i] as TSharpETaskItem).UpdateSkin(self);}
  end;
end;

procedure TSharpESkinManager.Notification(AComponent: TComponent; Operation:
  TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FComponentScheme) then
    begin
      FComponentScheme := nil;
      if FSchemeSource = ssComponent then
        RefreshControls;
    end;
    if (AComponent = FComponentSkin) then
    begin
      FComponentSkin := nil;
      if FSkinSource = ssComponent then
        RefreshControls;
    end;
  end
end;

procedure TSharpESkinManager.ComponentSchemeUpdated;
begin
  if FSchemeSource = ssComponent then
    RefreshControls;
end;

procedure TSharpESkinManager.ComponentSkinUpdated;
begin
  if (FSkinSource = ssComponent) or (FSkinSource = ssSystem) then
    RefreshControls;
end;

procedure TSharpESkinManager.SetComponentScheme(value: TSharpEScheme);
begin
  if (FComponentScheme <> value) then
  begin
    if Assigned(FComponentScheme) then
      FComponentScheme.OnNotify := nil;
    FComponentScheme := value;
    if Assigned(FComponentScheme) then
    begin
      FComponentScheme.FreeNotification(self);
      FComponentScheme.OnNotify := ComponentSchemeUpdated;
      if FSchemeSource = ssComponent then
        RefreshControls;
    end;
  end;
end;

procedure TSharpESkinManager.SetComponentSkin(value: TSharpESkin);
begin
  if (FComponentSkin <> value) then
  begin
    if Assigned(FComponentSkin) then
      FComponentSkin.OnNotify := nil;
    FComponentSkin := value;
    if Assigned(FComponentSkin) then
    begin
      FComponentSkin.FreeNotification(self);
      FComponentSkin.OnNotify := ComponentSkinUpdated;
      if FSkinSource = ssComponent then
        RefreshControls;
    end;
  end;
end;

procedure TSharpESkinManager.SetSkinSource(value: TSkinSource);
begin
  if FSkinSource <> value then
  begin
    FSkinSource := value;
    if FSkinSource = ssSystem then
      FSystemSkin.Activated := true
    else
      FSystemSkin.Activated := false;
    RefreshControls;
  end;
end;

procedure TSharpESkinManager.SetSchemeSource(value: TSchemeSource);
begin
  if FSchemeSource <> value then
  begin
    FSchemeSource := value;
    RefreshControls;
  end;
end;

function TSharpESkinManager.GetScheme: TSharpEScheme;
begin
  if FSchemeSource = ssSystem then
    result := FSystemScheme
  else
    if (FSchemeSource = ssComponent) and Assigned(FComponentScheme) then
      result := FComponentScheme
    else
      result := DefaultSharpEScheme;
end;

function TSharpESkinManager.GetSkin: TSharpESkin;
begin
  if FSkinSource = ssSystem then
    result := FSystemSkin
  else
    if (FSkinSource = ssComponent) and Assigned(FComponentSkin) then
      result := FComponentSkin
    else
      result := DefaultSharpESkin;
end;

//***********************************
//* Help functions
//***********************************

procedure LoadSharpEScheme(Scheme: TSharpEScheme);
var
  n : integer;
begin
  try
    Scheme.ClearColors;
    for n := 0 to SharpThemeApi.GetSchemeColorCount - 1 do
        Scheme.AddColor(SharpThemeApi.GetSchemeColorByIndex(n));
  except
    Scheme.Assign(DefaultSharpEScheme);
  end;
end;

end.
