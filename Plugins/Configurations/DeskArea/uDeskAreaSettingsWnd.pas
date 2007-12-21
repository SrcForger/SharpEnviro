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

unit uDeskAreaSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi,
  ExtCtrls, Buttons, PngBitBtn, GR32_Image, Math,
  SharpThemeApi, Contnrs, GR32, GR32_Resamplers, SharpCenterApi,
  SharpGraphicsUtils, SharpEGaugeBoxEdit, Types;

type
  TDAItem = class
    private
    public
      AutoMode : boolean;
      OffSets  : TRect;
      Mon      : TMonitor;
      MonID    : integer;
    end;

  TfrmDASettings = class(TForm)
    Panel1: TPanel;
    Label4: TLabel;
    cb_automode: TCheckBox;
    Panel2: TPanel;
    sgb_left: TSharpeGaugeBox;
    sgb_top: TSharpeGaugeBox;
    Label2: TLabel;
    Label1: TLabel;
    sgb_bottom: TSharpeGaugeBox;
    sgb_right: TSharpeGaugeBox;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgb_leftChangeValue(Sender: TObject; Value: Integer);
    procedure cb_automodeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure SendUpdate;
  public
    CurrentDAItem : TDAItem;
    update : boolean;
    PreviewBmp : TBitmap32;
    procedure UpdateGUIFromDAItem(DAItem : TDAItem);
    procedure UpdateDAItemFromGui;
    procedure RenderPreview;
  end;

var
  frmDASettings: TfrmDASettings;
  DAList : TObjectList;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }


function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TfrmDASettings.RenderPreview;
const
  PreviewHeight = 128;
var
  w,h : integer;
  n : integer;
  BR : TBarRect;
  F : real;
  DR : TRect;
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
    PreviewBmp.Clear(color32(255,255,255,255));

    DR := Mon.BoundsRect;
    for  n := 0 to GetSharpBarCount - 1 do
    begin
      BR := GetSharpBarArea(n);
      if PointInRect(Point(BR.R.Left + (BR.R.Right - BR.R.Left) div 2,
                     BR.R.Top + (BR.R.Bottom - BR.R.Top) div 2),
                     Mon.BoundsRect) then
      begin
        PreviewBmp.FillRect(round(BR.R.Left * F),
                            round(BR.R.Top * F),
                            round(BR.R.Right * F),
                            round(BR.R.Bottom * F),color32(0,0,128,255));
        if AutoMode then
        begin
          if BR.R.Top < Mon.Top + Mon.Height div 2 then
            DR.Top := Max(DR.Top,BR.R.Bottom)
            else DR.Bottom := Min(DR.Bottom,BR.R.Top);
        end;
      end;
    end;
    DR.Left := DR.Left + OffSets.Left - Mon.BoundsRect.Left;
    DR.Top  := DR.Top + OffSets.Top - Mon.BoundsRect.Top;
    DR.Right := DR.Right - OffSets.Right - Mon.BoundsRect.Left;
    DR.Bottom := DR.Bottom - OffSets.Bottom - Mon.BoundsRect.Top;
    PreviewBmp.FrameRectS(round(DR.Left * F),
                          round(DR.Top * F),
                          round(DR.Right * F),
                          round(DR.Bottom * F),color32(128,0,0,255));
  end;
  CenterUpdatePreview;
end;

procedure TfrmDASettings.UpdateDAItemFromGui;
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

procedure TfrmDASettings.UpdateGUIFromDAItem(DAItem : TDAItem);
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

procedure TfrmDASettings.cb_automodeClick(Sender: TObject);
begin
  UpdateDAItemFromGui;
end;

procedure TfrmDASettings.FormCreate(Sender: TObject);
begin
  Update := False;
  Self.DoubleBuffered := true;
  Panel1.DoubleBuffered := True;
  Panel2.DoubleBuffered := True;

  PreviewBmp := TBitmap32.Create;
  PreviewBmp.DrawMode := dmBlend;
  PreviewBmp.CombineMode := cmMerge;

  DAList := TObjecTList.Create(False);
end;

procedure TfrmDASettings.SendUpdate;
begin
  if Visible then
    SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmDASettings.sgb_leftChangeValue(Sender: TObject; Value: Integer);
begin
  if update then 
    exit;
    
  UpdateDAItemFromGui;
end;

procedure TfrmDASettings.FormDestroy(Sender: TObject);
begin
  DAList.Free;
  PreviewBmp.Free;
end;

procedure TfrmDASettings.FormShow(Sender: TObject);
begin
  Label4.Font.Color := clGray;
  Label1.Font.Color := clGray;
end;

end.

