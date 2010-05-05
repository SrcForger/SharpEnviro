{
Source Name: uDeskAreaSettingsWnd.pas
Description: DeskArea Settings Window
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, Menus, SharpApi, ExtCtrls, Buttons, Math,
  GR32, SharpCenterApi, SharpGraphicsUtils, SharpEGaugeBoxEdit,
  Types, SharpECenterHeader, ISharpCenterHostUnit, graphicsFx, JvExControls,
  JvXPCore, JvXPCheckCtrls;

type
  TDAItem = class
    private
    public
      AutoMode : boolean;
      OffSets  : TRect;
      Mon      : TMonitor;
      MonID    : integer;
    end;

  TfrmSettings = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    sgb_left: TSharpeGaugeBox;
    sgb_top: TSharpeGaugeBox;
    sgb_bottom: TSharpeGaugeBox;
    sgb_right: TSharpeGaugeBox;
    SharpECenterHeader4: TSharpECenterHeader;
    SharpECenterHeader1: TSharpECenterHeader;
    cb_automode: TJvXPCheckbox;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgb_leftChangeValue(Sender: TObject; Value: Integer);
    procedure cb_automodeClick(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;
    procedure SendUpdate;
    
  public
    CurrentDAItem : TDAItem;
    update : boolean;
    PreviewBmp : TBitmap32;
    procedure UpdateGUIFromDAItem(DAItem : TDAItem);
    procedure UpdateDAItemFromGui;
    procedure RenderPreview;
    procedure UpdatePreview( var ABmp: TBitmap32 );

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmSettings: TfrmSettings;
  DAList : TList;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }


function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TfrmSettings.RenderPreview;
const
  PreviewHeight = 70;
var
  w,h : integer;
  n : integer;
  barBoundsRect : TBarRect;
  F : real;
  monBoundsRect : TRect;
  color: TColor;
begin
  if CurrentDAItem = nil then exit;
  if CurrentDAItem.Mon = nil then exit;

  with CurrentDAItem do
  begin
    // decide size
    h := PreviewHeight;
    F := h / Mon.Height;
    w := round(Mon.Width * F);

    PreviewBmp.SetSize(w,h);
    PreviewBmp.Clear(clWhite);

    monBoundsRect := Mon.BoundsRect;
    for  n := 0 to GetSharpBarCount - 1 do
    begin
      barBoundsRect := GetSharpBarArea(n);

      if PointInRect(Point(barBoundsRect.R.Left + (barBoundsRect.R.Right - barBoundsRect.R.Left) div 2,
                     barBoundsRect.R.Top + (barBoundsRect.R.Bottom - barBoundsRect.R.Top) div 2),Mon.BoundsRect) then
      begin
        if barBoundsRect.R.Bottom + 40 < h then
          barBoundsRect.R.Bottom := barBoundsRect.R.Bottom + 40;

        if barBoundsRect.R.Top - 40 > 0 then
          barBoundsRect.R.Top := barBoundsRect.R.Top - 40;

        PreviewBmp.FillRect(round((barBoundsRect.R.Left - Mon.Left) * F),
                            round((barBoundsRect.R.Top - Mon.Top) * F),
                            round((barBoundsRect.R.Right - Mon.Left) * F),
                            round((barBoundsRect.R.Bottom - Mon.Top)* F),color32(clBlue));
        if AutoMode then
        begin
          if barBoundsRect.R.Top < Mon.Top + Mon.Height div 2 then
            monBoundsRect.Top := Max(monBoundsRect.Top,barBoundsRect.R.Bottom)
            else monBoundsRect.Bottom := Min(monBoundsRect.Bottom,barBoundsRect.R.Top);
        end;
      end;
    end;

    monBoundsRect.Left := monBoundsRect.Left + OffSets.Left - Mon.BoundsRect.Left;
    monBoundsRect.Top  := monBoundsRect.Top + OffSets.Top - Mon.BoundsRect.Top;
    monBoundsRect.Right := monBoundsRect.Right - OffSets.Right - Mon.BoundsRect.Left;
    monBoundsRect.Bottom := monBoundsRect.Bottom - OffSets.Bottom - Mon.BoundsRect.Top;

    color := clBlack;
    PreviewBmp.FrameRectS(round(monBoundsRect.Left * F),
                          round(monBoundsRect.Top * F),
                          round(monBoundsRect.Right * F),
                          round(monBoundsRect.Bottom * F),color32(color));

  end;


  PluginHost.Refresh(rtPreview);
end;

procedure TfrmSettings.UpdateDAItemFromGui;
begin
  if update then exit;
  if CurrentDAItem = nil then exit;

  CurrentDAItem.AutoMode := cb_automode.Checked;
  CurrentDAItem.OffSets.Left := sgb_left.Value;
  CurrentDAItem.OffSets.top := sgb_top.Value;
  CurrentDAItem.OffSets.right := sgb_right.Value;
  CurrentDAItem.OffSets.bottom := sgb_bottom.Value;
  RenderPreview;
  SendUpdate;
end;

procedure TfrmSettings.UpdateGUIFromDAItem(DAItem : TDAItem);
begin
  update := True;
  CurrentDAItem := DAItem;
  cb_automode.Checked := CurrentDAItem.AutoMode;
  sgb_left.Value   := CurrentDAItem.OffSets.Left;
  sgb_top.Value    := CurrentDAItem.OffSets.top;
  sgb_right.Value  := CurrentDAItem.OffSets.right;
  sgb_bottom.Value := CurrentDAItem.OffSets.bottom;

  Update := False;
  RenderPreview;
end;

procedure TfrmSettings.UpdatePreview( var ABmp: TBitmap32 );
begin
  if currentDAItem = nil then
  begin
    ABmp.SetSize(0,0);
    exit;
  end;

  ABmp.SetSize(PreviewBmp.Width+2,PreviewBmp.Height+2);
  ABmp.Clear(color32(PluginHost.Theme.Background));

  frmSettings.PreviewBmp.DrawTo(ABmp,1,1);
end;

procedure TfrmSettings.cb_automodeClick(Sender: TObject);
begin
  UpdateDAItemFromGui;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  Update := False;
  Self.DoubleBuffered := true;
  Panel1.DoubleBuffered := True;
  Panel2.DoubleBuffered := True;

  PreviewBmp := TBitmap32.Create;
  PreviewBmp.DrawMode := dmBlend;
  PreviewBmp.CombineMode := cmMerge;

  DAList := TList.Create;
end;

procedure TfrmSettings.SendUpdate;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;

procedure TfrmSettings.sgb_leftChangeValue(Sender: TObject; Value: Integer);
begin
  if update then 
    exit;

  UpdateDAItemFromGui;
end;

procedure TfrmSettings.FormDestroy(Sender: TObject);
var
  I : Integer;
begin
  for I := DAList.Count - 1 downto 0 do
    TDAItem(DAList.Items[I]).Free;

  DAList.Free;
  PreviewBmp.Free;
end;

end.

