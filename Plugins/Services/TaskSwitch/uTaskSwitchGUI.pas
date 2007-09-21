unit uTaskSwitchGUI;

interface

uses
  Windows, Messages, Graphics, SysUtils, Math, Classes, ExtCtrls, Forms,
  SharpThemeApi, SharpESkin, SharpESkinPart, SharpESkinManager, uTaskSwitchWnd,
  GR32, GR32_Resamplers, SharpIconUtils, SharpGraphicsUtils;

type
  TTSGui = class
  private
    FSkinManager : TSharpESkinManager;
    FWnd : TTaskSwitchWnd;
    FIndex : integer;
    FBackground : TBitmap32;
    FNormal : TBitmap32;
    FUser32DllHandle : integer;
    FPreviewTimer : TTimer;
    FPreviewIndex : integer;
    FInTimer : boolean;
    FShowPreview : boolean;
    PrintWindow : function (SourceWindow: hwnd; Destination: hdc; nFlags: cardinal): bool; stdcall;
    function GetWndVisible: boolean;
    procedure OnPreviewTimer(Sender : TObject);
  public
    wndlist : array of hwnd;
    previews : array of TBitmap32;
    StartState: TKeyboardState;
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure ShowWindow;
    procedure CloseWindow;
    procedure BuildPreviews;
    procedure UpdateHighlight;
    procedure SpecialKeyTest;
  published
    property WndVisible : boolean read GetWndVisible;
    property Index : integer read FIndex write FIndex;
    property ShowPreview : boolean read FShowPreview write FShowPreview;
  end;

var
  TSGUI : TTSGUI;

function ForceForegroundWindow(hwnd: THandle): Boolean;

implementation

{ TTSGui }

function ForceForegroundWindow(hwnd: THandle): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;

begin
  if IsIconic(hwnd) then
    ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = hwnd then
    Result := True
  else begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then begin
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then begin
        // Code by Daniel P. Stasinski
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end
    else begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
  end;
end; { ForceForegroundWindow }

procedure GetIcon(wnd : hwnd; var Icon : TBitmap32);
const
  ICON_SMALL2 = 2;
var
  newicon : hicon;
begin
  newicon := 0;
  try
    SendMessageTimeout(wnd, WM_GETICON, ICON_BIG, 0, SMTO_ABORTIFHUNG, 1000, DWORD(newicon));

    if (newicon = 0) then newicon := HICON(GetClassLong(wnd, GCL_HICON));

    if (newicon = 0) then SendMessageTimeout(wnd, WM_GETICON, 1, 0, SMTO_ABORTIFHUNG, 1000, DWORD(newicon));
    if (newicon = 0) then newicon := HICON(GetClassLong(wnd, GCL_HICON));
    if (newicon = 0) then SendMessageTimeout(wnd, WM_QUERYDRAGICON, 0, 0, SMTO_ABORTIFHUNG, 1000, DWORD(newicon));

    if (newicon = 0) then newicon := LoadIcon(0, IDI_WINLOGO);
  except
  end;

  if newicon <> 0 then
  begin
    IconToImage(Icon,newicon);
    DestroyIcon(newIcon);
  end;
end;

procedure TTSGui.BuildPreviews;
var
  n : integer;
  w,h : integer;
  isize : integer;
  im : integer;
  Bmp,Icon : TBitmap32;
begin
  for n := 0 to High(Previews) do
    Previews[n].Free;
  setlength(Previews,length(wndlist));

  w := Max(FSkinManager.Skin.TaskSwitchSkin.ItemPreview.WidthAsInt,
           FSkinManager.Skin.TaskSwitchSkin.ItemHoverPreview.WidthAsInt);
  h := Max(FSkinManager.Skin.TaskSwitchSkin.ItemPreview.HeightAsInt,
           FSkinManager.Skin.TaskSwitchSkin.ItemHoverPreview.HeightAsInt);

  Icon := TBitmap32.Create;
  Icon.DrawMode := dmBlend;
  Icon.CombineMode := cmMerge;
  TLinearResampler.Create(Icon);
  for n := 0 to High(Previews) do
  begin
    Bmp := TBitmap32.Create;
    TLinearResampler.Create(Bmp);    
    Bmp.SetSize(w,h);
    Bmp.Clear(color32(0,0,0,0));
    Bmp.DrawMode := dmBlend;
    Bmp.CombineMode := cmMerge;

    // Render Icon
    isize := Min(32,w);
    im := (w - isize) div 2;
    GetIcon(wndlist[n],Icon);
    Icon.DrawTo(Bmp,Rect(im,im,w-im,h-im));

    Previews[n] := Bmp;
  end;
  Icon.Free;
end;

procedure TTSGui.CloseWindow;
begin
  if FPreviewTimer.Enabled then
    FPreviewTimer.Enabled := False;

  UnhookWindowsHookEx(FWnd.Hook);
  
  try
    FWnd.Close;
    FWnd.Picture.SetSize(1,1);
    FBackground.SetSize(1,1);
    FNormal.SetSize(1,1);
  except
  end;
end;

constructor TTSGui.Create;
begin
  inherited Create;

  FInTimer := False;

  setlength(wndlist,0);
  setlength(previews,0);
  FWnd := nil;

  if not SharpThemeApi.Initialized then
  begin
    SharpThemeApi.InitializeTheme;
    SharpThemeApi.LoadTheme(True,[tpSkin,tpScheme,tpInfo]);
  end;  

  FSkinManager := TSharpESkinManager.Create(nil,[scBar,scTaskSwitch]);
  FSkinManager.SkinSource := ssSystem;
  FSkinManager.SchemeSource := ssSystem;
  FSkinManager.Skin.UpdateDynamicProperties(FSkinManager.Scheme);

  FBackground := TBitmap32.Create;
  FNormal := TBitmap32.Create;
  FNormal.DrawMode := dmBlend;
  FNormal.CombineMode := cmMerge;

  FUser32DllHandle := LoadLibrary('user32.dll');
  if FUser32DllHandle <> 0 then
     @PrintWindow := GetProcAddress(FUser32DllHandle, 'PrintWindow');

  FPreviewTimer := TTimer.Create(nil);
  FPreviewTimer.Interval := 10;
  FPreviewTimer.OnTimer := OnPreviewTimer;
  FPreviewTimer.Enabled := False;       
end;

destructor TTSGui.Destroy;
var
  n : integer;
begin
  FSkinManager.Free;
  setlength(wndlist,0);
  for n := 0 to High(Previews) do
    Previews[n].Free;
  setlength(Previews,0);

  if FWnd <> nil then
  begin
    if FWnd.Visible then
      CloseWindow;
    FWnd.Free;
  end;

  FreeLibrary(FUser32DllHandle);
  FUser32DllHandle := 0;     

  FBackground.Free;
  FNormal.Free;

  FPreviewTimer.Enabled := False;
  FPreviewTimer.Free;

  inherited Destroy;
end;

function TTSGui.GetWndVisible: boolean;
begin
  if Assigned(FWnd) then
    result := FWnd.Visible
    else result := False;
end;

// function written by Andre Beckedorf (graphics32 dev team)
function HasVisiblePixel(Bitmap: TBitmap32): Boolean;
var
  I: Integer;
  S: PColor32;
begin
  Result := False;
  if (Bitmap.DrawMode = dmBlend) and (Bitmap.MasterAlpha = 0) then Exit;

  S := @Bitmap.Bits[0];
  for I := 0 to Bitmap.Width * Bitmap.Height - 1 do
  begin
    if S^ shr 24 > 0 then
    begin
      Result := True;
      Exit;
    end;
    Inc(S);
  end;
end;

procedure TTSGui.OnPreviewTimer(Sender: TObject);
var
  WndBmp : TBitmap32;
  R,R2 : TRect;
  Bmp : TBitmap32;
  pwsucc : boolean;
  w,h : integer;
  TSS : TSharpETaskSwitchSkin;
  x,y : integer;
  n : integer;
  Spacing : integer;
begin
  FInTimer := True;
  pwsucc := True;
    
  if not IsIconic(wndlist[FPreviewIndex]) then
  begin
    w := Max(FSkinManager.Skin.TaskSwitchSkin.ItemPreview.WidthAsInt,
             FSkinManager.Skin.TaskSwitchSkin.ItemHoverPreview.WidthAsInt);
    h := Max(FSkinManager.Skin.TaskSwitchSkin.ItemPreview.HeightAsInt,
             FSkinManager.Skin.TaskSwitchSkin.ItemHoverPreview.HeightAsInt);

    WndBmp := TBitmap32.Create;
    WndBmp.DrawMode := dmBlend;
    WndBmp.CombineMode := cmMerge;
    TLinearResampler.Create(WndBmp);
    Bmp := TBitmap32.Create;
    try
      Bmp.SetSize(w,h);
      Bmp.DrawMode := dmBlend;
      Bmp.CombineMode := cmMerge;
      Bmp.Clear(color32(0,0,0,0));

      GetWindowRect(wndlist[FPreviewIndex],R);
      WndBmp.SetSize(R.Right-R.Left,R.Bottom-R.Top);
      WndBmp.Clear(color32(0,0,0,0));
      pwsucc := PrintWindow(wndlist[FPreviewIndex],WndBmp.Handle,0);
      if pwsucc and HasVisiblePixel(WndBmp) then
      begin
        R2 := Rect(0,0,0,0);
        if (WndBmp.Width/WndBmp.Height)=(w/h) then
        begin
          R2 := Rect(0,0,w,h);
        end
        else if (WndBmp.Width/WndBmp.Height)>(w/h) then
        begin
          R2.Left := 0;
          R2.Top := round((h div 2 - ((w/WndBmp.Width)*WndBmp.Height) / 2));
          R2.Right := w;
          R2.bottom := round((h div 2 + ((w/WndBmp.Width)*WndBmp.Height) / 2));
        end else
        begin
          R2.Left := round((w div 2 - ((h/WndBmp.Height)*WndBmp.Width) / 2));
          R2.Top := 0;
          R2.Right := round((w div 2 + ((h/WndBmp.Height)*WndBmp.Width) / 2));
          R2.bottom := h;
        end;
        WndBmp.ResetAlpha(255);
        Bmp.Draw(R2,WndBmp.ClipRect,WndBmp);
        Previews[FPreviewIndex].DrawTo(Bmp,Rect(w-20,h-20,w,h));
        Previews[FPreviewIndex].Clear(color32(0,0,0,0));
        Previews[FPreviewIndex].Assign(Bmp);

        TSS := FSkinManager.Skin.TaskSwitchSkin;

        Spacing := TSS.Spacing;
        x := TSS.LROffset.XAsInt;
        y := TSS.TBOffset.XAsInt;

        for n := 0 to FPreviewIndex - 1 do
        begin
          x := x + TSS.Item.SkinDim.WidthAsInt + Spacing;
          if x > FBackground.Width - TSS.LROffset.YAsInt - TSS.Item.SkinDim.WidthAsInt  then
          begin
            x := TSS.LROffset.XAsInt;
            y := y + TSS.Item.SkinDim.HeightAsInt + spacing;
          end;
        end;

        w := TSS.Item.SkinDim.WidthAsInt;
        h := TSS.Item.SkinDim.HeightAsInt;

        FNormal.DrawMode := dmOpaque;
        FNormal.FillRect(x,y,x+w,y+h,color32(0,0,0,0));
        FNormal.DrawMode := dmBlend;

        Bmp.SetSize(TSS.ItemHover.SkinDim.WidthAsInt,TSS.ItemHover.SkinDim.HeightAsInt);
        Bmp.Clear(color32(0,0,0,0));
        Bmp.DrawMode := dmBlend;
        Bmp.CombineMode := cmMerge;
        TSS.Item.draw(Bmp,FSkinManager.Scheme);
        previews[FPreviewIndex].DrawTo(Bmp,TSS.ItemPreview.XAsInt,TSS.ItemPreview.YAsInt);
        Bmp.DrawTo(FNormal,x,y);
        UpdateHighlight;
      end;
    finally
      Bmp.Free;
      WndBmp.Free;
    end;
  end;

  FPreviewIndex := FPreviewIndex + 1;
  if FPreviewIndex > High(wndlist) then
    FPreviewTimer.Enabled := False;
  FInTimer := False;

  SpecialKeyTest;  
end;

function KeyHook(Code: integer; wParam: WPARAM; LParam: LPARAM): Longint; stdcall;
type
  KBDLLHOOKSTRUCT = record 
                      vkCode: DWORD;
                      scanCode: DWORD;
                      flags: DWORD;
                      time: DWORD;
                      dwExtraInfo: DWORD;
                    end;
  PKBDLLHOOKSTRUCT = ^KBDLLHOOKSTRUCT;
begin
  if WPARAM = WM_KEYUP then
  begin
    TSGUI.CloseWindow;
    ForceForegroundWindow(TSGUI.wndlist[TSGUI.Index]);
  end else TSGUI.SpecialKeyTest;
{  else if WPARAM = WM_SYSKEYDOWN then
  begin
    pkh:=PKBDLLHOOKSTRUCT(LParam);
    showmessage(inttostr(TSGUI.StartState[pkh.vkCode]));
    if TSGUI.StartState[pkh.vkCode] = 0 then
      TSGUI.CloseWindow;
  end;}

  result := CallNextHookEx(13,Code,WParam,LParam);
end;

procedure TTSGui.ShowWindow;
const
  CAPTUREBLT = $40000000;
var
  WrapCount : integer;
  Spacing : integer;
  Count : integer;
  w,h : integer;
  TSS : TSharpETaskSwitchSkin;
  x,y : integer;
  n: Integer;
  temp : TBitmap32;
  Shift : TShiftState;
  dc : HDC;
begin
  if FPreviewTimer.Enabled then
    FPreviewTimer.Enabled := False;

  BuildPreviews;

  TSS := FSkinManager.Skin.TaskSwitchSkin;

  WrapCount := Max(1,TSS.WrapCount);
  Spacing := TSS.Spacing;

  w := TSS.LROffset.XAsInt +
       TSS.LROffset.YAsInt;
  h := TSS.TBOffset.XAsInt +
       TSS.TBOffset.YAsInt;

  Count := length(wndlist);
  if Count < WrapCount then
    w := w + Count * TSS.Item.SkinDim.WidthAsInt
           + (Count - 1) * Spacing
    else w := w + WrapCount * TSS.Item.SkinDim.WidthAsInt
                + (WrapCount - 1) * Spacing;
  if Count mod WrapCount = 0 then
  h := h + round((Int(Count / WrapCount))
           * Max(TSS.Item.SkinDim.HeightAsInt,
                 TSS.ItemHover.SkinDim.HeightAsInt))
  else h := h + round((Int(Count / WrapCount) + 1)
                * Max(TSS.Item.SkinDim.HeightAsInt,
                      TSS.ItemHover.SkinDim.HeightAsInt));

  if FWnd <> nil then
     FWnd.Free;
  FWnd := TTaskSwitchWnd.Create(nil,self);                      

  // Draw Background
  FBackground.SetSize(w,h);
  FBackground.Clear(color32(0,0,0,0));

  if FSkinManager.Skin.BarSkin.GlassEffect then
  begin
    dc := GetWindowDC(GetDesktopWindow);
    Temp := TBitmap32.Create;
    try
      BitBlt(FBackground.Canvas.Handle,
             0,
             0,
             FBackground.Width,
             FBackground.Height,
             dc,
             FWnd.Monitor.Left + FWnd.Monitor.Width div 2 - FBackground.Width div 2,
             FWnd.Monitor.Top + FWnd.Monitor.Height div 2 - FBackground.Height div 2,
             SRCCOPY or CAPTUREBLT);
      if SharpThemeApi.GetSkinGEBlend then
        BlendImageC(FBackground,GetSkinGEBlendColor,GetSkinGEBlendAlpha);
      fastblur(FBackground,GetSkinGEBlurRadius,GetSkinGEBlurIterations);
      if GetSkinGELighten then
         lightenBitmap(FBackground,GetSkinGELightenAmount);
      FBackground.ResetAlpha(255);
      Temp.SetSize(w,h);
      Temp.Clear(color32(0,0,0,0));
      TSS.Background.draw(Temp,FSkinManager.Scheme);
      ReplaceTransparentAreas(FBackground,Temp,Color32(0,0,0,0));      
      Temp.DrawMode := dmBlend;
      Temp.CombineMode := cmMerge;
      Temp.DrawTo(FBackground,0,0);
    finally
      ReleaseDC(GetDesktopWindow, dc);
      Temp.Free;
    end;
  end else TSS.Background.draw(FBackground,FSkinManager.Scheme);

  // Draw Normal Items
  FNormal.SetSize(w,h);
  FNormal.Clear(color32(0,0,0,0));
  x := TSS.LROffset.XAsInt;
  y := TSS.TBOffset.XAsInt;

  Temp := TBitmap32.Create;
  Temp.DrawMode := dmBlend;
  Temp.CombineMode := cmMerge;
  for n := 0 to High(wndlist) do
  begin
    Temp.SetSize(TSS.Item.SkinDim.WidthAsInt,TSS.Item.SkinDim.HeightAsInt);
    Temp.Clear(color32(0,0,0,0));
    TSS.Item.draw(Temp,FSkinManager.Scheme);
    previews[n].DrawTo(Temp,TSS.ItemPreview.XAsInt,TSS.ItemPreview.YAsInt);
    Temp.DrawTo(FNormal,x,y);
    x := x + TSS.Item.SkinDim.WidthAsInt + Spacing;
    if x > w - TSS.LROffset.YAsInt - TSS.Item.SkinDim.WidthAsInt  then
    begin
      x := TSS.LROffset.XAsInt;
      y := y + TSS.Item.SkinDim.HeightAsInt + spacing;
    end;
  end;
  temp.Free;

  FWnd.Hook := SetWindowsHookEx(13,KeyHook, HInstance,0);  
  FWnd.Left := FWnd.Monitor.Left + FWnd.Monitor.Width div 2 - FBackground.Width div 2;
  FWnd.Top := FWnd.Monitor.Top + FWnd.Monitor.Height div 2 - FBackground.Height div 2;
  
  FWnd.Show;
  SetWindowPos(FWnd.handle, HWND_TOPMOST, FWnd.Left, FWnd.Top,
    FWnd.Width, FWnd.Height, SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
  ForceForegroundWindow(FWnd.Handle);


  // WH_KEYBOARD_LL = 13
  UpdateHighlight;
  FPreviewIndex := 0;
  if ShowPreview then
    FPreviewTimer.Enabled := True;
  SpecialKeyTest;
end;

procedure TTSGui.SpecialKeyTest;
var
  kalt,kctrl,kshift : boolean;
begin
  kalt := (GetAsyncKeyState(VK_MENU) <> 0);
  kctrl := (GetAsyncKeyState(VK_CONTROL) <> 0);
  kshift := (GetAsyncKeyState(VK_SHIFT) <> 0);
  if (not kalt) and (not kctrl) and (not kshift) then
  begin
    CloseWindow;
    ForceForegroundWindow(wndlist[FIndex]);
  end;
end;

function GetCaption(wnd : hwnd) : String;
var
  buf:Array[0..1024] of char;
begin
  GetWindowText(wnd,@buf,sizeof(buf));
  result := buf;
end;

procedure TTSGui.UpdateHighlight;
var
  Spacing : integer;
  x,y : integer;
  w,h : integer;
  n : integer;
  TSS : TSharpETaskSwitchSkin;
  temp : TBitmap32;
  NTemp : TBitmap32;
  ST : TSkinText;
  TextPos : TPoint;
  FontBmp : TBitmap32;
  Caption : String;
begin
  if FIndex > High(wndlist) then
    FIndex := Low(wndlist)
  else
  if FIndex < Low(wndlist) then
    FIndex := High(wndlist);

  TSS := FSkinManager.Skin.TaskSwitchSkin;
  ST := CreateThemedSkinText(FSkinManager.Skin.TaskSwitchSkin.Background.SkinText);

  Spacing := TSS.Spacing;

  x := TSS.LROffset.XAsInt;
  y := TSS.TBOffset.XAsInt;  

  for n := 0 to FIndex - 1 do
  begin
    x := x + TSS.Item.SkinDim.WidthAsInt + Spacing;
    if x > FBackground.Width - TSS.LROffset.YAsInt - TSS.Item.SkinDim.WidthAsInt  then
    begin
      x := TSS.LROffset.XAsInt;
      y := y + TSS.Item.SkinDim.HeightAsInt + spacing;
    end;
  end;

  w := TSS.Item.SkinDim.WidthAsInt;
  h := TSS.Item.SkinDim.HeightAsInt;

  FWnd.Picture.Assign(FBackground);
  NTemp := TBitmap32.Create;
  NTemp.Assign(FNormal);

  NTemp.DrawMode := dmOpaque;
  NTemp.FillRect(x,y,x+w,y+h,color32(0,0,0,0));
  NTemp.DrawMode := dmBlend;

  temp := TBitmap32.Create;
  temp.Clear(color32(0,0,0,0));
  temp.SetSize(TSS.ItemHover.SkinDim.WidthAsInt,TSS.ItemHover.SkinDim.HeightAsInt);
  temp.DrawMode := dmBlend;
  temp.CombineMode := cmMerge;
  TSS.ItemHover.draw(temp,FSkinManager.Scheme);
  if (TSS.ItemPreview.WidthAsInt <> TSS.ItemHoverPreview.WidthAsInt) or
     (TSS.ItemPreview.Height <> TSS.ItemHoverPreview.Height) then
     previews[FIndex].DrawTo(temp,Rect(TSS.ItemHoverPreview.XAsInt,
                                       TSS.ItemHoverPreview.YAsInt,
                                       TSS.ItemHoverPreview.XAsInt + TSS.ItemHoverPreview.WidthAsInt,
                                       TSS.ItemHoverPreview.YAsInt + TSS.ItemHoverPreview.HeightAsInt))
  else previews[FIndex].DrawTo(temp,TSS.ItemHoverPreview.XAsInt,TSS.ItemHoverPreview.YAsInt);
  temp.DrawTo(NTemp,x,y);
  temp.Free;

  NTemp.DrawTo(FWnd.Picture,0,0);
  NTemp.Free;

  // Render Text
  Caption := GetCaption(wndlist[FIndex]);
  FontBmp := TBitmap32.Create;
  FontBmp.DrawMode := dmBlend;
  FontBmp.CombineMode := cmMerge;
  FontBmp.SetSize(FBackground.Width,FBackground.Height);
  FontBmp.Clear(color32(0,0,0,0));
  ST.AssignFontTo(FontBmp.Font,FSkinManager.Scheme);
  if FontBmp.TextWidth(Caption) > FBackground.Width - TSS.LROffset.XAsInt - TSS.LROffset.YAsInt - 4 then
  begin
    repeat
      setlength(Caption,length(Caption)-1);
    until (FontBmp.TextWidth(Caption) < FBackground.Width - TSS.LROffset.XAsInt - TSS.LROffset.YAsInt - 4)
          or (length(Caption) = 0);
    setlength(Caption,Max(0,length(Caption)-1));
    Caption := Caption + '...';
  end;
  TextPos := ST.GetXY(Rect(0, 0, FontBmp.TextWidth(Caption), FontBmp.TextHeight(Caption)),
                                 Rect(0, 0, FBackground.Width, FBackground.Height));
  ST.RenderTo(FontBmp,TextPos.x,TextPos.y,Caption,FSkinManager.Scheme);
  ST.Free;
  FontBmp.DrawTo(FWnd.Picture,0,0);
  FontBmp.Free;

  FWnd.PreMul(FWnd.Picture);
  FWnd.DrawWindow;
end;

end.
