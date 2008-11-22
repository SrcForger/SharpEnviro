{
Source Name: uSettingsWnd.pas
Description: VWM Service Settings Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit uSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi, SharpCenterApi,
  SharpEGaugeBoxEdit, ImgList, PngImageList, JvPageList, JvExControls, ExtCtrls,
  SharpECenterHeader, JvXPCore, JvXPCheckCtrls, ISharpCenterHostUnit;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmSettings = class(TForm)
    SharpECenterHeader1: TSharpECenterHeader;
    pnlGrid: TPanel;
    sgbVwmCount: TSharpeGaugeBox;
    SharpECenterHeader2: TSharpECenterHeader;
    chkFocusTopMost: TJvXPCheckbox;
    SharpECenterHeader3: TSharpECenterHeader;
    chkFollowFocus: TJvXPCheckbox;
    SharpECenterHeader4: TSharpECenterHeader;
    chkNotifications: TJvXPCheckbox;
    procedure sgbVwmCountChangeValue(Sender: TObject; Value: Integer);
    procedure SettingsChanged(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure SendUpdate;
  public
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmSettings.SettingsChanged(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.SendUpdate;
begin
  if Visible then
    PluginHost.Save;
end;

procedure TfrmSettings.sgbVwmCountChangeValue(Sender: TObject; Value: Integer);
begin
  SettingsChanged(nil);
end;

end.

