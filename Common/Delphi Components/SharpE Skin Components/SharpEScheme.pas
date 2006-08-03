{
Source Name: SharpEScheme
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
unit SharpEScheme;

interface

uses
  Windows,
  SharpApi,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  gr32,
  SharpEBase;

type
  TSchemeEvent = procedure of object;

  TSharpEScheme = class(TComponent)
  private
    FThrobberback: Tcolor;
    FThrobberdark: Tcolor;
    FThrobberlight: Tcolor;
    FThrobbertext: Tcolor;
    FWorkAreaback: Tcolor;
    FWorkAreadark: Tcolor;
    FWorkArealight: Tcolor;
    FWorkAreatext: Tcolor;
    FOnNotify: TSchemeEvent;

    procedure NotifyManager;
    procedure SetTB(Value: TColor);
    procedure SetTD(Value: TColor);
    procedure SetTL(Value: TColor);
    procedure SetTT(Value: TColor);
    procedure SetWB(Value: TColor);
    procedure SetWD(Value: TColor);
    procedure SetWL(Value: TColor);
    procedure SetWT(Value: TColor);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignScheme(ss: TColorSchemeEx);
    property OnNotify: TSchemeEvent read FOnNotify write FOnNotify;
  published
    property Throbberback: Tcolor read FThrobberback write SetTB;
    property Throbberdark: Tcolor read FThrobberdark write SetTD;
    property Throbberlight: Tcolor read FThrobberlight write SetTL;
    property Throbbertext: Tcolor read FThrobbertext write SetTT;
    property WorkAreaback: Tcolor read FWorkAreaback write SetWB;
    property WorkAreadark: Tcolor read FWorkAreadark write SetWD;
    property WorkArealight: Tcolor read FWorkArealight write SetWL;
    property WorkAreatext: Tcolor read FWorkAreatext write SetWT;
  end;

implementation
uses SharpESkinManager,
  SharpEDefault;

constructor TSharpEScheme.Create(AOwner: TComponent);
begin
  inherited;
  AssignScheme(DefaultSharpEColorScheme);
end;

procedure TSharpEScheme.NotifyManager;
begin
  if Assigned(OnNotify) then
    OnNotify;
end;

procedure TSharpEScheme.Notification(AComponent: TComponent; Operation:
  TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent is TSharpESkinManager) then
    begin
      if (AComponent as TSharpESkinManager).CompScheme = self then
        FOnNotify := nil;
    end;
  end
end;

procedure TSharpEScheme.SetTB(Value: TColor);
begin
  if FThrobberBack <> Value then
  begin
    FThrobberBack := Value;
    NotifyManager;
  end;
end;

procedure TSharpEScheme.SetTD(Value: TColor);
begin
  if FThrobberDark <> Value then
  begin
    FThrobberDark := Value;
    NotifyManager;
  end;
end;

procedure TSharpEScheme.SetTL(Value: TColor);
begin
  if FThrobberLight <> Value then
  begin
    FThrobberLight := Value;
    NotifyManager;
  end;
end;

procedure TSharpEScheme.SetTT(Value: TColor);
begin
  if FThrobberText <> Value then
  begin
    FThrobberText := Value;
    NotifyManager;
  end;
end;

procedure TSharpEScheme.SetWB(Value: TColor);
begin
  if FWorkAreaBack <> Value then
  begin
    FWorkAreaBack := Value;
    NotifyManager;
  end;
end;

procedure TSharpEScheme.SetWD(Value: TColor);
begin
  if FWorkAreaDark <> Value then
  begin
    FWorkAreaDark := Value;
    NotifyManager;
  end;
end;

procedure TSharpEScheme.SetWL(Value: TColor);
begin
  if FWorkAreaLight <> Value then
  begin
    FWorkAreaLight := Value;
    NotifyManager;
  end;
end;

procedure TSharpEScheme.SetWT(Value: TColor);
begin
  if FWorkAreaText <> Value then
  begin
    FWorkAreaText := Value;
    NotifyManager;
  end;
end;

procedure TSharpEScheme.Assign(Source: TPersistent);
var ss: TSharpEScheme;
begin
  if Source is TSharpEScheme then
    ss := Source as TSharpEScheme
  else
    exit;
  FThrobberback := ss.Throbberback;
  FThrobberdark := ss.Throbberdark;
  FThrobberlight := ss.Throbberlight;
  FThrobberText := ss.ThrobberText;
  FWorkAreaBack := ss.WorkAreaback;
  FWorkAreaDark := ss.WorkAreadark;
  FWorkAreaLight := ss.WorkArealight;
  FWorkAreaText := ss.WorkAreaText;
end;

procedure TSharpEScheme.AssignScheme(ss: TColorSchemeEx);
begin
  FThrobberback := ss.Throbberback;
  FThrobberdark := ss.Throbberdark;
  FThrobberlight := ss.Throbberlight;
  FThrobberText := ss.ThrobberText;
  FWorkAreaBack := ss.WorkAreaback;
  FWorkAreaDark := ss.WorkAreadark;
  FWorkAreaLight := ss.WorkArealight;
  FWorkAreaText := ss.WorkAreaText;
end;

end.
