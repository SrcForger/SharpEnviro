{
Source Name: uSharpDeskLayeredWindow.pas
Description: layered window class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
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

unit uSharpDeskLayeredWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  GR32,
  SharpApi,
  SharpDeskApi;

type
  TSharpDeskLayeredWindow = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDblClick(Sender: TObject);
  private
    FTerminate : boolean;
    DC: HDC;
    Blend: TBlendFunction;
    FPicture : TBitmap32;
    FDesktopObject : TObject;
    procedure UpdateWndLayer;
  protected
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMNCHitTest(var Message: TWMNCHitTest);
    procedure WMMouseMove(var Msg: TMessage); message WM_MOUSEMOVE;
    procedure WMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
  public
    procedure DrawWindow;
  published
    property Picture : TBitmap32 read FPicture write FPicture;
    property DesktopObject : TObject read FDesktopObject write FDesktopObject;
  end;

var
  SharpDeskLayeredWindow: TSharpDeskLayeredWindow;
  dbclick : boolean = False;

implementation

uses
  uSharpDeskDesktopObject,
  uSharpDeskMainForm,
  uSharpDeskFunctions;

{$R *.dfm}

procedure TSharpDeskLayeredWindow.WMMouseMove(var Msg: TMessage);
var
  pDesktopObject : TDesktopObject;
  CPos : TPoint;
  tme: TTRACKMOUSEEVENT;  
  TrackMouseEvent_: function(var EventTrack: TTrackMouseEvent): BOOL; stdcall; 
begin
  tme.cbSize := sizeof(TTRACKMOUSEEVENT);
  tme.dwFlags := TME_HOVER or TME_LEAVE;
  tme.dwHoverTime := 10;
  tme.hwndTrack := self.Handle;
  @TrackMouseEvent_:= @TrackMouseEvent; // nur eine Pointerzuweisung!!!
  TrackMouseEvent_(tme);

  pDesktopObject := TDesktopObject(FDesktopObject);
  pDesktopObject.DeskManager.LastLayer := Tag;
  if not pDesktopObject.Selected then
  begin
    SharpDesk.UnselectAll;
    pDesktopObject.Selected := True;
    pDesktopObject.Owner.DllSharpDeskMessage(pDesktopObject.Settings.ObjectID,
                                             pDesktopObject.Layer,
                                             SDM_MOUSE_ENTER,0,0,0);
   // self.DrawWindow;
  end;

  CPos := SharpDesk.Image.ScreenToClient(Mouse.CursorPos);
  pDesktopObject.Owner.DllSharpDeskMessage(pDesktopObject.Settings.ObjectID,
                                          pDesktopObject.Layer,
                                          SDM_MOUSE_MOVE,CPos.X,CPos.Y,0);  
end;

procedure TSharpDeskLayeredWindow.WMMouseLeave(var Msg: TMessage);
var
  pDesktopObject : TDesktopObject;
begin
  pDesktopObject := TDesktopObject(FDesktopObject);
  if pDesktopObject = nil then exit;
  try
  //  if PointInRect(Mouse.CursorPos,self.BoundsRect) then exit;
    pDesktopObject.Owner.DllSharpDeskMessage(pDesktopObject.Settings.ObjectID,
                                             pDesktopObject.Layer,
                                             SDM_MOUSE_LEAVE,0,0,0);
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_MOUSE_LEAVE to ' + inttostr(pDesktopObject.Settings.ObjectID) + '('+pDesktopObject.Owner.FileName+')'), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
    end;
  end;
  pDesktopObject.Selected := False;
  SharpDesk.SelectionCount := 0;
end;

procedure TSharpDeskLayeredWindow.WMPaint(var Msg: TWMPaint);
begin
  inherited;
  Application.ProcessMessages;
end;

procedure TSharpDeskLayeredWindow.WMNCHitTest(var Message: TWMNCHitTest);
begin
  if PtInRect(ClientRect, ScreenToClient(Point(Message.XPos, Message.YPos))) then
     Message.Result := HTClient;
end;

procedure TSharpDeskLayeredWindow.DrawWindow;
begin
  UpdateWndLayer;
end;

procedure TSharpDeskLayeredWindow.FormCreate(Sender: TObject);
begin
  DC := 0;

  with Blend do
  begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    SourceConstantAlpha := 255;
    AlphaFormat := AC_SRC_ALPHA;
  end;

  SetWindowLong(Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW or WS_EX_TOPMOST);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
  SetWindowPos(Handle, HWND_TOPMOST, 0,0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
end;

procedure TSharpDeskLayeredWindow.UpdateWndLayer;
var
  TopLeft, BmpTopLeft: TPoint;
  BmpSize: TSize;
  Bmp : TBitmap32;
begin
  if (Width=0) or (Height=0) then exit;
  BmpSize.cx := Width;
  BmpSize.cy := Height;
  BmpTopLeft := Point(0, 0);
  TopLeft := BoundsRect.TopLeft;

  DC := GetDC(Handle);
  try
    if not Win32Check(LongBool(DC)) then
      RaiseLastWin32Error;

    Bmp := TBitmap32.Create;
    //bmp.SetSize(FPicture.Width,FPicture.Height);
    Bmp.SetSize(Width,Height);
    Bmp.Clear(color32(1,1,1,1));
    FPicture.DrawMode := dmBlend;    
    //Bmp.Draw(0,0,FPicture);
    FPicture.DrawTo(Bmp,Rect(0,0,self.Width,self.Height));
    if not Win32Check(UpdateLayeredWindow(Handle, DC, @TopLeft, @BmpSize,
      Bmp.Handle, @BmpTopLeft, clNone, @Blend, ULW_ALPHA)) then
      RaiseLastWin32Error;
    Bmp.Free;
  finally
    ReleaseDC(Handle, DC);
  end;
end;

procedure TSharpDeskLayeredWindow.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  pDesktopObject : TDesktopObject;
begin
  if (not TDesktopObject(FDesktopObject).Settings.Locked) and (Button = mbLeft) and (not dbclick) then
  begin
    ReleaseCapture;
    Perform(WM_NCLBUTTONDOWN,HTCAPTION,0);
    pDesktopObject := TDesktopObject(FDesktopObject);
    pDesktopObject.DeskManager.LastLayer := Tag;
    p := pDesktopObject.DeskManager.Image.ScreenToClient(Mouse.CursorPos);
    pDesktopObject.Settings.Pos := p;
    pDesktopObject.DeskManager.MoveLayerTo(pDesktopObject,p.X-x,p.Y-y);
    pDesktopObject.DeskManager.ObjectSetList.SaveSettings;
  end else dbclick := False;
end;

procedure TSharpDeskLayeredWindow.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pDesktopObject : TDesktopObject;
  i : integer;
  b : integer;
begin
  pDesktopObject := TDesktopObject(FDesktopObject);
  pDesktopObject.DeskManager.LastLayer := Tag;
  pDesktopObject.Selected := True;

  case Button of
   mbLeft   : B:=0;
   mbRight  : B:=1;
   mbMiddle : B:=2;
   else B:=0;
  end;
  try
    pDesktopObject.Owner.DllSharpDeskMessage(pDesktopObject.Settings.ObjectID,
                                             pDesktopObject.Layer,
                                             SDM_MOUSE_UP,Mouse.CursorPos.X,Mouse.CursorPos.Y,B);
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_MOUSE_UP to ' + inttostr(pDesktopObject.Settings.ObjectID) + '('+pDesktopObject.Owner.FileName+')'), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
    end;
  end;

  if Button = mbRight then
  with SharpDeskMainForm do
  begin
    ENDOFCUSTOMMENU.Visible := True;
    STARTOFBOTTOMMENU.Visible := True;
    SharpApi.SendMessageTo('SharpMenuWMForm',WM_CLOSESHARPMENU,0,0);

    while ObjectPopUp.Items[0].Name <> 'ENDOFCUSTOMMENU' do ObjectPopUp.Items.Delete(0);
    while ObjectPopUp.Items[ObjectPopUp.Items.Count-1].Name <> 'STARTOFBOTTOMMENU' do ObjectPopUp.Items.Delete(ObjectPopUp.Items.Count-1);
    while ObjectPopUp.Images.Count > ObjectPopUpImageCount do ObjectPopUp.Images.Delete(ObjectPopUpImageCount);
    ObjectMenu.Items.Clear;
    ObjectMenuImages.Clear;
    try
      pDesktopObject.Owner.DllSharpDeskMessage(pDesktopObject.Settings.ObjectID,
                                               pDesktopObject.Layer,
                                               SDM_MENU_POPUP,Mouse.CursorPos.X,Mouse.CursorPos.Y,0);
      except
        on E: Exception do
        begin
         SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_MENU_POPUP to ' + inttostr(pDesktopObject.Settings.ObjectID) + '('+pDesktopObject.Owner.FileName+')'), clred, DMT_ERROR);
         SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
        end;
      end;
      i := ObjectPopUp.Images.Count;
      ObjectPopUp.Images.AddImages(ObjectMenu.Images);
      CopyMenuItems(ObjectMenu.Items,ObjectPopUp.Items[0],ObjectPopUpImageCount-(ObjectPopUpImageCount-i),True);

      if ObjectPopUp.Items[0].Name = 'ENDOFCUSTOMMENU' then ObjectPopUp.Items[0].Visible := False
         else ObjectPopUp.Items[0].Visible := True;

      if ObjectPopUp.Items[ObjectPopUp.Items.Count-1].Name = 'STARTOFBOTTOMMENU' then ObjectPopUp.Items[ObjectPopUp.Items.Count-1].Visible := False
         else ObjectPopUp.Items[ObjectPopUp.Items.Count-1].Visible := True;
  
    if pDesktopObject.Settings.Locked then LockObjec1.ImageIndex:=4
       else LockObjec1.ImageIndex:=29;
    if pDesktopObject.Settings.isWindow then MakeWindow1.ImageIndex:=4
       else MakeWindow1.ImageIndex:=29;
    self.PopupMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.y);
  end;
end;

procedure TSharpDeskLayeredWindow.FormDblClick(Sender: TObject);
var
  pDesktopObject : TDesktopObject;
  Cpos : TPoint;
begin
  dbclick := True;
  CPos := SharpDesk.Image.ScreenToClient(Mouse.CursorPos);
  pDesktopObject := TDesktopObject(FDesktopObject);
  pDesktopObject.Owner.DllSharpDeskMessage(pDesktopObject.Settings.ObjectID,
                                           pDesktopObject.Layer,
                                           SDM_DOUBLE_CLICK,
                                           CPos.X,CPos.Y,0);
end;

end.
