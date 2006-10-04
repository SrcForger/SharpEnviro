{
Source Name: SharpESkinManager
Description: SharpE component for SharpE
Copyright (C) Malx (Malx@techie.com)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpe-shell.org

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
unit SharpESkinManager;

interface

uses
  Windows,
  Messages,
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
  SharpApi;

type
  TSkinSource = (ssDefault, ssSystem, ssComponent);
  TSchemeSource = TSkinSource;


  TSharpESkinManager = class(TComponent)
  private
    FOnSkinChanged: TNotifyEvent;
    FSkinSource: TSkinSource;
    FSchemeSource: TSkinSource;
    FSystemScheme: TSharpEScheme;
    FComponentScheme: TSharpEScheme;
    FSystemSkin: TSystemSharpESkin;
    FComponentSkin: TSharpESkin;
    FUsingMainWnd : boolean;
    FIsThemeLoading : boolean;
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
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateRuntime(AOwner: TComponent; Skin : TSharpESkin; Scheme : TSharpEScheme);
    destructor Destroy; override;
    property Scheme: TSharpEScheme read GetScheme;
    property Skin: TSharpESkin read GetSkin;
    property SystemSkin: TSystemSharpESkin read FSystemSkin;
    procedure RefreshControls;
  published
    property SkinSource: TSkinSource read FSkinSource write SetSkinSource;
    property SchemeSource: TSchemeSource read FSchemeSource write SetSchemeSource;
    property CompScheme: TSharpEScheme read FComponentScheme write SetComponentScheme;
    property CompSkin: TSharpESkin read FComponentSkin write SetComponentSkin;
    property onSkinChanged: TNotifyEvent read FOnSkinChanged write FOnSkinChanged;
  end;

procedure LoadSharpEScheme(Scheme: TSharpEScheme);

implementation
uses
  SharpEButton,
  SharpEForm,
  SharpEPanel,
  SharpEBar,
  SharpECheckBox,
  SharpERadioBox,
  SharpEProgressBar,
  SharpELabel,
  SharpEEdit,
  SharpEMiniThrobber,
  SharpETaskItem,
  SharpThemeApi;

constructor TSharpESkinManager.CreateRuntime(AOwner: TComponent; Skin : TSharpESkin; Scheme : TSharpEScheme);
begin
  FComponentScheme := Scheme;
  FComponentSkin := Skin;
  Create(AOwner);
end;

constructor TSharpESkinManager.Create(AOwner: TComponent);
begin
  FSystemScheme := TSharpEScheme.create(nil);
  FSystemSkin := TSystemSharpESkin.create;
  FSystemSkin.OnSkinChanged := SystemSkinChanged;
  FSystemSkin.OnNotify := ComponentSkinUpdated;

  FIsThemeLoading := False;

  if not (csDesigning in ComponentState) then
  begin
    if not SharpThemeApi.Initialized then
    begin
      SharpThemeApi.InitializeTheme;
      SharpThemeApi.LoadTheme(True);
    end;
  end;

  LoadSharpEScheme(FSystemScheme);
  inherited;

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

  if FSkinSource = ssSystem then
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
  if Assigned(FOnSkinChanged) then
     FOnSkinChanged(self);
  //RefreshControls;
end;

function TSharpESkinManager.MessageHook(var Msg: TMessage): Boolean;
begin
  if (msg.Msg = WM_THEMELOADINGSTART) then FIsThemeLoading := True;
  if (msg.Msg = WM_THEMELOADINGEND) then
  begin
    FIsThemeLoading := False;
    if not (csDesigning in ComponentState) then
       SharpThemeApi.LoadTheme;
    LoadSharpEScheme(FSystemScheme);
    RefreshControls;
  end;
  if (SchemeSource = ssSystem) and
     ((Msg.Msg = WM_SHARPETHEMEUPDATE) or (Msg.Msg = WM_SHARPEUPDATESETTINGS)) then
  Begin
    if not FIsThemeLoading then
    begin
      if not (csDesigning in ComponentState) then
         SharpThemeApi.LoadTheme;
      LoadSharpEScheme(FSystemScheme);
      if Assigned(FOnSkinChanged) then FOnSkinChanged(self);
      RefreshControls;
    end;
  end;
  if (Msg.Msg = WM_SYSTEMSKINUPDATE) then
  begin

  end;
  result := false;
end;

procedure TSharpESkinManager.MessageHook2(var Msg: TMessage);
begin
  MessageHook(Msg);
end;

procedure TSharpESkinManager.RefreshControls;
var
  i: Integer;
begin
  for i := Owner.ComponentCount - 1 downto 0 do
  begin
    if (Owner.Components[i] is TSharpEButton) then
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
                             (Owner.Components[i] as TSharpETaskItem).UpdateSkin(self);

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
