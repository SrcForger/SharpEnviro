{
Source Name: SharpEForm
Description: SharpE component for SharpE
Copyright (C) Malx (Malx@techie.com)

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
unit SharpEForm;

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
  Types,
  gr32,
  SharpeDefault,
  SharpEBase,
  SharpEBaseControls,
  SharpESkinManager;

type
  TSharpEBGForm = class
  private
    FTBarRect: TRect;
    fproc: TFarproc;
    FBmp: TBitmap32;
    st: string;
    owner: TComponent;
    Blend: TBlendFunction;
    WindowHandle: hWnd;
    lroffset,tboffset : TPoint;
  protected
    procedure UpdateSkin;
    procedure UpdateWndLayer;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure WndProc(var msg: TMessage);
    procedure UpdateSize;
    procedure SetZOrder;
    property handle: hwnd read WindowHandle;
  end;

  TSharpEForm = class(TCustomSharpEComponent)
  private
    FTitleBar: boolean;
    FBGForm: TSharpEBGForm;
    FSkin: TBitmap32;
    hproc: TFarproc;
    fproc: TFarproc;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateSkin; override;
    procedure WndProc(var msg: TMessage);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    property Skin: TBitmap32 read FSkin;
  published
    property BGForm : TSharpEBGForm read FBGForm;
    property TitleBar: boolean read FTitleBar write FTitleBar;
    property SkinManager;
  end;

implementation

function PlainWinProc(hWnd: THandle; nMsg: UINT;
  wParam, lParam: Cardinal): Cardinal; export; stdcall;
begin
  Result := DefWindowProc(hWnd, nMsg, wParam, lParam);
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TSharpEBGForm.WndProc(var msg: TMessage);
var
  powner : TForm;
  cp : TPoint;
begin
  powner := TForm(TSharpEForm(Owner).Owner);

  if msg.Msg = WM_ACTIVATE then
     msg.Result := 0
  else
  if msg.Msg = WM_ACTIVATEAPP then
  begin
    SetZOrder;
    //  powner.Show;
      //powner.SetFocus;
  end else
  if (msg.Msg = WM_LBUTTONDOWN) or (msg.Msg = WM_NCLBUTTONDOWN) then
  begin
    //  if TSharpEForm(powner).TitleBar then
    begin
      cp := Mouse.CursorPos;
      ScreenToClient(WindowHandle,cp);
      if PointInRect(cp,FTBarRect) then
      begin
        ReleaseCapture;
        powner.Perform(WM_NCLBUTTONDOWN,HTCAPTION,0);
      end;
    end;
  end;

  msg.Result := DefWindowProc(windowHandle, msg.Msg, msg.wParam, msg.lParam);
  st := inttostr(msg.result);
end;

constructor TSharpEBGForm.Create(AOwner: TComponent);
var
  WindowClass: TWndClassEx;
  powner : TForm;
begin
  owner := AOwner;

  lroffset.X := 0;
  lroffset.Y := 0;
  tboffset.X := 0;
  tboffset.Y := 0;

  FBmp := TBitmap32.create;
  FBmp.SetSize(256,256);
  FBmp.Clear(clred32);
  with Blend do
  begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    SourceConstantAlpha := $FF;
    AlphaFormat := AC_SRC_ALPHA;
  end;

  try
    fproc := Classes.MakeObjectInstance(WndProc);
   // initialize the window class structure
    WindowClass.cbSize := sizeOf(TWndClassEx);
    WindowClass.lpszClassName := 'SharpEBackgroundForm';
    WindowClass.style := cs_VRedraw or cs_HRedraw or cs_DBLCLKS;
    WindowClass.hInstance := HInstance;
    WindowClass.lpfnWndProc := @PlainWinProc;
    WindowClass.cbClsExtra := 0;
    WindowClass.cbWndExtra := 0;
    WindowClass.hIcon := LoadIcon(hInstance, MakeIntResource('MAINICON'));
    WindowClass.hIconSm := LoadIcon(hInstance, MakeIntResource('MAINICON'));
    WindowClass.hCursor := LoadCursor(0, idc_Arrow); ;
    WindowClass.hbrBackground := GetStockObject(white_Brush);
    WindowClass.lpszMenuName := nil;
    // register the class
    if RegisterClassEx(WindowClass) = 0 then
      MessageBox(0, 'Invalid class registration', 'IconWindow', MB_OK)
    else
    begin
      powner := TForm(TSharpEForm(Owner).Owner);
      WindowHandle := CreateWindowEx(WS_EX_LAYERED or //WS_EX_TRANSPARENT or
        WS_EX_TOOLWINDOW,
        WindowClass.lpszClassName, // class name
        'SharpEBackgroundForm', // title
        WS_POPUP, // styles
        powner.left-lroffset.X, powner.Top-tboffset.X,
          // position
        powner.width+lroffset.X+lroffset.Y, powner.Height+tboffset.X+tboffset.Y,
          // size
        0, // parent window
        0, // menu
        HInstance, // instance handle
        nil); // initial parameters
      if WindowHandle = 0 then
        MessageBox(0, 'Window not created', 'SharpEBackgroundForm', MB_OK)
      else
      begin
        ShowWindow(WindowHandle, sw_shownormal);
      //   hproc := TFarProc(GetWindowLong(form.handle,GWL_WNDPROC));
      //  fproc := Classes.MakeObjectInstance(WndProc);
        SetWindowlong(Windowhandle, GWL_WNDPROC, longword(fproc));

      end;
    end;
  except
    MessageBox(0, 'Problem when creating Window', 'SharpEBackgroundForm',
      MB_OK)
  end;
end;

destructor TSharpEBGForm.Destroy;
begin
  try
    DestroyWindow(WindowHandle);
    Windows.UnregisterClass(PChar('SharpEBackgroundForm'),hInstance);
  except
  end;
  FBmp.free;
  inherited;
end;

procedure TSharpEBGForm.UpdateSkin;
var
  powner: TForm;
  pmanager: TSharpESkinManager;
  TextRect,CompRect: TRect;
  p: TPoint;
  Caption : String;
begin
  powner := TForm(TSharpEForm(Owner).Owner);
  pmanager := TSharpEForm(Owner).SkinManager;
  try
    Caption := powner.Caption;
  except
    Caption := '';
  end;
  if powner <> nil then
  begin
    if Assigned(pmanager) then
    begin
      lroffset.X := pmanager.Skin.FormSkin.FullLROffset.XAsInt;
      lroffset.Y := pmanager.Skin.FormSkin.FullLROffset.YAsInt;
      tboffset.X := pmanager.Skin.FormSkin.FullTBOffset.XAsInt;
      tboffset.Y := pmanager.Skin.FormSkin.FullTBOffset.YAsInt;
    end;
    CompRect := Rect(0, 0,powner.Width,powner.height);
    FTBarRect := pmanager.Skin.FormSkin.TitleDim.GetRect(CompRect);
    FBmp.SetSize(powner.width+lroffset.X+lroffset.Y, powner.Height+tboffset.X+tboffset.Y);
    FBmp.Clear(color32(0,0,0,0));
    if not pmanager.Skin.FormSkin.Full.Empty then
    begin
      pmanager.Skin.FormSkin.Full.draw(FBmp,pmanager.scheme);
      pmanager.Skin.FormSkin.Full.SkinText.AssignFontTo(FBmp.Font,pmanager.scheme);
      TextRect := Rect(0, 0, FBmp.TextWidth(Caption), FBmp.TextHeight(Caption));
      p := pmanager.Skin.FormSkin.Full.SkinText.GetXY(TextRect, CompRect);
      FBmp.RenderText(p.X, p.Y, caption, 0, Color32(FBmp.Font.color));
    end;
    UpdateSize;
    UpdateWndLayer;
  end;
end;

procedure TSharpEBGForm.UpdateSize;
var
  powner : TForm;
begin
  if Owner <> nil then
  begin
    powner := TForm(TSharpEForm(Owner).Owner);
    if powner <> nil then
       SetWindowPos(WindowHandle, 0, powner.left-lroffset.X, powner.Top-tboffset.X,
                    powner.width+lroffset.X+lroffset.Y, powner.Height+tboffset.X+tboffset.Y,
                    SWP_NOZORDER or SWP_NOACTIVATE);
  end;
end;

procedure TSharpEBGForm.SetZOrder;
var
  powner : TForm;
begin
  if Owner <> nil then
  begin
    powner := TForm(TSharpEForm(Owner).Owner);
    if powner <> nil then
       SetWindowPos(WindowHandle, powner.handle, 0, 0, 0, 0,
                    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
  end;
end;

procedure TSharpEBGForm.UpdateWndLayer;
var
  BmpTopLeft: TPoint;
  BmpSize: TSize;
  dc: hdc;
begin
  if (FBmp.Width <=0) or (FBmp.Height <=0) then exit;
  BmpSize.cx := FBmp.Width;
  BmpSize.cy := FBmp.Height;
  BmpTopLeft := Point(0, 0);
  DC := GetDC(WindowHandle);
  try
    if not LongBool(DC) then
      RaiseLastOSError;
    if not UpdateLayeredWindow(WindowHandle, DC, nil, @BmpSize,
      FBmp.Handle, @BmpTopLeft, clNone, @Blend, ULW_ALPHA) then
      RaiseLastOSError;
  finally
    ReleaseDC(WindowHandle, DC);
  end;
end;


constructor TSharpEForm.Create(AOwner: TComponent);
begin
  inherited;
  FTitleBar := True;
  if csDesigning in ComponentState then exit;
  FBGForm := TSharpEBGForm.Create(self);
  FSkin := TBitmap32.Create;
  FSkin.DrawMode := dmBlend;
  FSkin.CombineMode := cmMerge;
  TForm(aowner).BorderStyle := bsNone;
  hproc := TFarProc(GetWindowLong(TForm(aowner).handle, GWL_WNDPROC));
  fproc := Classes.MakeObjectInstance(WndProc);
  SetWindowlong(TForm(aowner).handle, GWL_WNDPROC, longword(fproc));
  TForm(aowner).OnCloseQuery := FormCloseQuery;
  UpdateSkin;
end;

destructor TSharpEForm.Destroy;
begin
  if (csDesigning in ComponentState) and (Owner is TForm) then
    (Owner as TForm).Color := clBtnFace;
  if not (csDesigning in ComponentState) then
  begin
    FBGForm.Free;
    FSkin.Free;
  end;
  inherited;
end;

procedure TSharpEForm.WndProc(var msg: TMessage);
begin
  case msg.Msg of
    WM_MOVE:
      begin
        FBGForm.UpdateSize;
      end;
    WM_SIZE:
      begin
        UpdateSkin;
      end;
    WM_SHOWWINDOW:
      begin
        if msg.WParam > 0 then
        begin
          Showwindow(FBGForm.Handle, sw_ShowNormal);
        end
        else
        begin
          Showwindow(FBGForm.Handle, SW_HIDE);
        end;
      end;
    WM_ACTIVATE:
      begin
        if LOWORD(msg.WParam) = WA_INACTIVE then
        begin
         // Throbber.FButtonDown := false;
        end
        else
        begin
          FBGForm.SetZOrder;
        end;
      end;
    WM_MOUSELEAVE:
      begin
        //Throbber.SMouseLeave;
      end;
    WM_LBUTTONDOWN,
      WM_RBUTTONDOWN:
      begin
      end;
  end;
  msg.result := CallWindowProc(hproc, TForm(Owner).Handle, msg.msg, msg.wparam, msg.lparam);
end;

procedure TSharpEForm.UpdateSkin;
begin
  if (csDestroying in Owner.ComponentState) or
    (csLoading in Owner.ComponentState) or
    (csDesigning in Owner.ComponentState) then
    exit;
  if (Owner is TForm) then
  begin
    if Assigned(FManager) then
    begin
      (Owner as TForm).Color := FManager.Scheme.GetColorByName('WorkAreaback');
      FBGForm.UpdateSkin;
    end
    else
      (Owner as TForm).Color := DefaultSharpEScheme.GetColorByName('WorkAreaback');
  end;
end;

procedure TSharpEForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;
  ShowWindow(FBGForm.WindowHandle,SW_HIDE);
end;

end.
