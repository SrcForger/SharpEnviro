{
Source Name: BalloonWindow
Description: SystemTray Module - Balloon Window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>
              Malx

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

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

unit BalloonWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ExtCtrls, Contnrs, SharpFX, SharpApi;

type

  TBalloonItem = class(TObject)
                 public
                   Title : String;
                   Text  : String;
                   Icon  : integer;
                   Timeout : integer;
                   Owner : TObject;
                 end;

  TBalloonForm = class(TForm)
    Image1: TImage;
    IconList: TImageList;
    UpdateTimer: TTimer;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FTrayManager : TObject;
    BalloonList  : TObjectList;
    procedure ShowNext;
  public
    { Public-Deklarationen }
    property TrayManager : TObject read FTrayManager write FTrayManager;
    function ShowBalloon : boolean;
    procedure AddBallonTip(TrayItem : TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  cs : TColorScheme;
  offset: integer;
  RowCount: integer;
  BalloonRgn: hrgn;
  ChoosedIcon: Ticon;
  bOverCross: boolean;
  backbuffer: Tbitmap;
  FixedTitle: string;
  textarray: array of string;

implementation

uses TrayIconsManager, declaration, Winver;

{$R *.dfm}

procedure TBalloonForm.CreateParams(var Params: TCreateParams);
var
  WinVersion : Cardinal;
const
  CS_DROPSHADOW = $00020000;
begin
  inherited;
  WinVersion := GetWinVer;
  if WinVersion = OS_WINXP then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure TBalloonForm.AddBallonTip(TrayItem : TObject);
var
  temp : TBalloonItem;
begin
  temp := TBalloonItem.Create;
  temp.Timeout := TTrayItem(TrayItem).BTimeout;
  temp.Title := TTrayItem(TrayItem).FInfoTitle;
  temp.Text := TTrayItem(TrayItem).FInfo;
  temp.Icon := TTrayItem(TrayItem).BInfoFlags;
  temp.Owner := TTrayItem(TrayItem);
  BalloonList.Add(Temp);
//  if BalloonList.IndexOf(TrayItem) <> -1 then exit;
//  BalloonList.Add(TTrayItem(TrayItem));
  if not visible then ShowNext;
end;

procedure TBalloonForm.ShowNext;
var
  temp : TBalloonItem;
begin
  if BalloonList.Count = 0 then
  begin
    UpdateTimer.Enabled := False;
    Close;
    exit;
  end;
  repeat
    temp := TBalloonItem(BalloonList.Items[0]);
    if not TTrayClient(FTrayManager).IconExists(TTrayItem(temp.Owner)) then
    begin
      BalloonList.Delete(0);
      temp := nil;
    end;
  until (temp <> nil) or (BalloonList.Count <= 0);

  if BalloonList.Count = 0 then
  begin
    UpdateTimer.Enabled := False;
    Close;
    exit;
  end;

  UpdateTimer.Enabled := False;
  UpdateTimer.Interval := temp.Timeout;
  if UpdateTimer.Interval > 30000 then
     UpdateTimer.Interval := 30000;
  if UpdateTimer.Interval < 10000 then
     UpdateTimer.Interval := 10000;
  UpdateTimer.Enabled := True;
  ShowBalloon;
  //if ShowBalloon then BalloonList.Delete(0);
end;

procedure TBalloonForm.FormCreate(Sender: TObject);
begin
  SetWindowLong(Application.Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW);
  SetWindowLong(Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW);
  ShowWindow(application.handle, SW_HIDE);

  BalloonList := TObjectList.Create;
  BalloonList.OwnsObjects := True;
  ChoosedIcon := Ticon.Create;
  backbuffer := Tbitmap.create;
  backbuffer.width := 20;
  backbuffer.height := 20;
end;

procedure TBalloonForm.FormDestroy(Sender: TObject);
begin
  UpdateTimer.Enabled := False;
  BalloonList.Free;
  BalloonList := nil;
  ChoosedIcon.Free;
  backbuffer.free;
end;

function TBalloonForm.ShowBalloon : boolean;
var
  rg: hrgn;
  pa: array[1..4] of Tpoint;
  w, h, width2, i, j, x, y: integer;
  TitleWidth: integer;
  MaxWidth: integer;
  LastSpace: integer;
  right: boolean;
  top: boolean;
  realicon: integer;
  item : TBalloonItem;
  trayitem : TTrayItem;
  InfoTitle, Info : String;
  IconPos : TPoint;
begin
  item := TBalloonItem(BalloonList.Items[0]);
  if item.Owner = nil then
  begin
    result := False;
    BalloonList.Delete(0);
    ShowNext;
    exit;
  end;
  trayitem := TTrayItem(item.owner);
  Hide;
  postmessage(trayitem.Wnd, trayitem.CallbackMessage, trayitem.uID, NIN_BALLOONSHOW);


  IconPos := TTrayClient(FTrayManager).GetIconPos(trayitem);
  x := TTrayClient(FTrayManager).screenpos.x + IconPos.X;
  y := TTrayClient(FTrayManager).screenpos.y + IconPos.Y;

  InfoTitle := item.Title;
  Info      := item.Text;

  //Time to decide size;
  if length(InfoTitle) > 64 then
    setlength(InfoTitle, 64);
  if length(Info) > 255 then
    setLength(Info, 255);

  FixedTitle := '';
  for i := 1 to length(InfoTitle) do
  begin
    if (InfoTitle[i] = #13) or (InfoTitle[i] = #10) then
      FixedTitle := FixedTitle + ' '
    else
      FixedTitle := FixedTitle + InfoTitle[i];
  end;
  canvas.Font.Style := [fsBold];
  TitleWidth := canvas.TextWidth(InfoTitle) + 44; //34 =  båda ikonerna

  if TitleWidth > 300 then
    MaxWidth := TitleWidth
  else
    MaxWidth := 300;

  canvas.Font.Style := [];
  LastSpace := 0;
  setlength(textarray, 0);
  setlength(textarray, length(Info) + 2);
  RowCount := 1;
  for i := 1 to length(Info) do
  begin
    if (Info[i] = #13) or (Info[i] = #10) then
    begin
      inc(RowCount);
      LastSpace := 0;
    end
    else
    begin
      textarray[RowCount] := textarray[RowCount] + Info[i];
      if (Info[i] = #32) then
        LastSpace := length(textarray[RowCount]);
      if canvas.TextWidth(textarray[Rowcount]) > Maxwidth then
      begin
        if LastSpace > 0 then
        begin
          if lastspace <> length(textarray[Rowcount]) then
          begin
            for j := (LastSpace + 1) to length(textarray[Rowcount]) do
            begin
              textarray[rowcount + 1] := textarray[rowcount + 1] +
                textarray[rowcount][j];
            end;
          end;
          setlength(textarray[Rowcount], LastSpace);
          if canvas.TextWidth(textarray[Rowcount]) > maxwidth then
            maxwidth := canvas.TextWidth(textarray[Rowcount]);
          inc(RowCount);
          LastSpace := 0;
        end;
      end;
    end;
  end;

  w := TitleWidth;
  h := 40 + RowCount * 13;

  width2 := 0;
  for i := 1 to RowCount do
  begin
    if Canvas.TextWidth(Textarray[i]) > width2 then
      width2 := canvas.TextWidth(Textarray[i]);
  end;

  if w < width2 then
    w := width2;

  inc(w, 24);

  case item.Icon of
    1, 10: realicon := 0;
    3: realicon := 1;
    2: realicon := 2;
    0: realicon := 0;
  else
    realicon := 0;
  end;

  right := x > screen.Width - w - 20;
  top := y < h + 20;

  if Top then
    self.Top := y
  else
    self.Top := y - h - 19;

  if Right then
    self.Left := x - w + 20
  else
    self.Left := x - 20;

  self.Height := h + 20;
  self.Width := w;

  if Top then
    rg := CreateRoundRectRgn(0, 19, w, h + 19, 15, 15)
  else
    rg := CreateRoundRectRgn(0, 0, w, h, 15, 15);

  if Right then
  begin
    pa[1].X := w - 20;
    pa[2].X := w - 40;
    pa[3].X := w - 20;
    pa[4].X := w - 20;
  end
  else
  begin
    pa[1].X := 20;
    pa[2].X := 40;
    pa[3].X := 20;
    pa[4].X := 20;
  end;
  if Top then
  begin
    pa[1].Y := 21;
    pa[2].Y := 21;
    pa[3].Y := 0;
    pa[4].Y := 21;
    offset := 19;
  end
  else
  begin
    pa[1].Y := h - 2;
    pa[2].Y := h - 2;
    pa[3].Y := h + 19;
    pa[4].Y := h - 2;
    offset := 0;
  end;
  DeleteObject(BalloonRgn);
  BalloonRgn := CreatePolygonRgn(pa, 3, WINDING);
  combinergn(rg, rg, BalloonRgn, RGN_OR);
  combinergn(BalloonRgn, BalloonRgn, rg, RGN_OR);
  IconList.GetIcon(realicon, ChoosedIcon);
  SetWindowRgn(self.handle, rg, true);
  if self.Visible = false then
    self.Show;
  result := true;
end;

procedure TBalloonForm.UpdateTimerTimer(Sender: TObject);
var
  item : TBalloonItem;
  trayicon : TTrayItem;
begin
  UpdateTimer.enabled := false;
  item := TBalloonItem(BalloonList.Items[0]);
  if item.Owner <> nil then
  begin
    trayicon := TTrayItem(item.owner);
    if Visible then
    begin
      postmessage(trayicon.Wnd, trayicon.CallbackMessage, trayicon.uID, NIN_BALLOONTIMEOUT);
      Balloonlist.Delete(0);
      close;
    end;
  end;
  ShowNext;
end;

procedure TBalloonForm.FormPaint(Sender: TObject);
var
  hej: hbrush;
  i: integer;
begin
  cs := LoadColorScheme;
  backbuffer.Canvas.Pen.Color := cs.Throbberlight;
  backbuffer.Canvas.Brush.Color := cs.Throbberlight;
  self.Canvas.Brush.Color := cs.Throbberlight;
  PaintRgn(self.canvas.Handle, BalloonRgn);
  hej := CreateSolidBrush(0);
  FrameRgn(self.canvas.Handle, BalloonRgn, hej, 1, 1);
  Deleteobject(hej);
  backbuffer.Canvas.Rectangle(0, 0, 20, 20);
  backbuffer.Canvas.Draw(0, 0, ChoosedIcon);
  createdropshadow(@backbuffer, cs.Throbberlight, 0, 0);
  self.Canvas.Draw(11, 8 + offset, BackBuffer);
  Canvas.Font.Style := [fsBold];
  self.Canvas.TextOut(34, 10 + offset, FixedTitle);
  canvas.Font.Style := [];
  for i := 1 to RowCount do
  begin
    self.Canvas.TextOut(10, 16 + 13 * i + offset, Textarray[i]);
  end;
  backbuffer.Canvas.Rectangle(0, 0, 20, 20);
  backbuffer.Canvas.Draw(0, 0, Image1.Picture.Icon);
  changecolor(@backbuffer, clBlack, cs.Throbberdark, 1, 1, 1, 1);
  self.canvas.Draw(self.clientWidth - 23, 5 + offset, backbuffer);
end;

procedure TBalloonForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (X > self.clientWidth - 23) and (X < self.clientWidth - 7) and
    (Y > 5 + offset) and (Y < 21 + offset) then
  begin
    if not (bOverCross) then
    begin
      backbuffer.Canvas.Rectangle(0, 0, 20, 20);
      backbuffer.Canvas.Draw(0, 0, Image1.Picture.Icon);
      changecolor(@backbuffer, clBlack, clblack, 1, 1, 1, 1);
      self.canvas.Draw(self.clientWidth - 23, 5 + offset,
        backbuffer);
      bOverCross := true;
    end;
  end
  else
  begin
    if bOverCross then
    begin
      backbuffer.Canvas.Rectangle(0, 0, 20, 20);
      backbuffer.Canvas.Draw(0, 0, Image1.Picture.Icon);
      changecolor(@backbuffer, clBlack, cs.Throbberdark, 1, 1, 1, 1);
      self.canvas.Draw(self.clientWidth - 23, 5 + offset,
        backbuffer);
      bOverCross := false;
    end;
  end;
end;

procedure TBalloonForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  item : TBalloonItem;
  trayicon : TTrayItem;
begin
  if (X > self.clientWidth - 23) and (X < self.clientWidth - 7) and
    (Y > 5 + offset) and (Y < 21 + offset) then
  begin
    if Button = mbLeft then
    begin
      UpdateTimer.OnTimer(UpdateTimer);
    end;
  end
  else
  begin
    item := TBalloonItem(BalloonList.Items[0]);
    if item = nil then
       UpdateTimer.OnTimer(UpdateTimer)
    else if item.owner <> nil then
    begin
      trayicon := TTrayItem(item.owner);
      if Button = mbLeft then
      begin
        postmessage(trayicon.Wnd,trayicon.CallbackMessage,trayicon.UID,NIN_BALLOONUSERCLICK);
        UpdateTimer.OnTimer(UpdateTimer);
      end
      else
      begin
        postmessage(trayicon.Wnd,trayicon.CallbackMessage,trayicon.UID,NIN_BALLOONHIDE);
        UpdateTimer.OnTimer(UpdateTimer);
      end;
    end;
  end;
end;

end.
