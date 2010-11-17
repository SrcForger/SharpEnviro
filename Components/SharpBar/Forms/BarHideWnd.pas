unit BarHideWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MonitorList, uSystemFuncs, ExtCtrls;

type
  TBarHideForm = class(TForm)
    curPosTimer: TTimer;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormMouseEnter(Sender: TObject);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure curPosTimerTimer(Sender: TObject);
  private
    FDragging : Boolean;

    procedure WMMove(var msg : TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
  public
    procedure UpdateStatus;
    procedure ShowBar;
    procedure HideBar;
  end;

var
  BarHideForm: TBarHideForm;

implementation

uses SharpBarMainWnd, SharpEBar, SharpApi;

{$R *.dfm}

procedure TBarHideForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := WS_EX_TOOLWINDOW or WS_EX_LAYERED;
end;

procedure TBarHideForm.WMMove(var msg : TWMWindowPosChanging);
begin
  if not self.Visible then exit;
//  msg.WindowPos.x := self.Left;
//  msg.WindowPos.y := self.Top;
end;

procedure TBarHideForm.curPosTimerTimer(Sender: TObject);
var
  pt : TPoint;
begin
  if (SharpBarMainForm.SharpEBar.DisableHideBar) or (SharpBarMainForm.SharpEBar.AutoHide) or (not FDragging) then
  begin
    curPosTimer.Enabled := False;
    exit;
  end;

  GetCursorPos(pt);
  if (pt.X >= Self.Left) and (pt.X < Self.Left + Self.Width) then
  begin
    // Top Bar
    if SharpBarMainForm.SharpEBar.VertPos = vpTop then
    begin
      if pt.Y >= SharpBarMainForm.Height - 1 then
      begin
        Self.Cursor := crDefault;
        ShowBar;
        FDragging := False;
      end;
    // Bottom Bar
    end else if SharpBarMainForm.SharpEBar.VertPos = vpBottom then
    begin
      if pt.Y < Monitor.Top + Monitor.Height - SharpBarMainForm.Height - 1 then
      begin
        Self.Cursor := crDefault;
        ShowBar;
        FDragging := False;
      end;
    end;
  end;
end;

procedure TBarHideForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Closing then
     if not SharpBarMainForm.Visible then
     begin
       SharpBarMainForm.Show;
       SharpBarMainForm.Repaint;
       SharpApi.ServiceMsg('Shell','DeskAreaUpdate');
     end;
end;

procedure TBarHideForm.ShowBar;
begin
  SharpBarMainForm.Show;
  SharpBarMainForm.Repaint;
  ForceForegroundWindow(SharpBarMainForm.Handle);
  SharpApi.ServiceMsg('Shell','DeskAreaUpdate');
  if not (SharpBarMainForm.SharpEBar.SpecialHideForm) then
  begin
    Close;
    exit;
  end;
end;

procedure TBarHideForm.HideBar;
begin
  if not SharpBarMainForm.SharpEBar.DisableHideBar then
  begin
    SharpBarMainForm.Hide;
    // Display a Tooltop if bar was hidden for the first time
    if SharpBarMainForm.FirstHide then
    begin
      SharpBarMainForm.ShowNotify('The SharpBar is now invisible because you left clicked the screen border. You can show the SharpBar again by left clicking the screen border another time.',True);
      SharpBarMainForm.FirstHide := False;
      SharpBarMainForm.SaveBarTooltipSettings;
    end;

    SharpApi.ServiceMsg('Shell','DeskAreaUpdate');
  end;
end;

procedure TBarHideForm.UpdateStatus;
var
  mon : TMonitorItem;
begin
  if Closing then exit;
  if SharpBarMainForm.SharpEBar = nil then
    exit;

  mon := MonList.MonitorFromWindow(SharpBarMainForm.Handle);
  if mon = nil then mon := MonList.MonitorFromPoint(Point(SharpBarMainForm.Left,SharpBarMainForm.Top));

  if (SharpBarMainForm.SharpEBar.VertPos = vpTop) and
     (SharpBarMainForm.SharpEBar.SpecialHideForm) then
  begin
    Left := SharpBarMainForm.Left;
    Width := SharpBarMainForm.Width;
    if mon <> nil then Top := mon.Top;
    Height := 1;
    if not Visible then Show;
  end else
  if (SharpBarMainForm.SharpEBar.VertPos = vpBottom) and
     (SharpBarMainForm.SharpEBar.SpecialHideForm) then
  begin
    Left := SharpBarMainForm.Left;
    Width := SharpBarMainForm.Width;
    if mon <> nil then Top := mon.Top + mon.Height - 1;
    Height := 1;
    if not Visible then Show;
  end else
  if (not SharpBarMainForm.Visible) and (not Visible) then
     Show
  else Hide;
end;

procedure TBarHideForm.FormCreate(Sender: TObject);
begin
  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW or WS_EX_LAYERED and not WS_EX_APPWINDOW);

  width := 1;
  height := 1;
  left := -4096;
  top := -4096;

  FDragging := False;
end;

procedure TBarHideForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (SharpBarMainForm.SharpEBar.DisableHideBar) or (SharpBarMainForm.SharpEBar.AutoHide) then
    exit;

  if (Button = mbLeft) and (Self.Cursor = crSizeNS) and (not FDragging) then
  begin
    FDragging := True;
    curPosTimer.Enabled := True;
  end;
end;

procedure TBarHideForm.FormMouseEnter(Sender: TObject);
begin
  if (SharpBarMainForm.SharpEBar.DisableHideBar) or (SharpBarMainForm.SharpEBar.AutoHide) then
    exit;

  if not SharpBarMainForm.Visible then
    Self.Cursor := crSizeNS;
end;

procedure TBarHideForm.FormMouseLeave(Sender: TObject);
begin
  Self.Cursor := crDefault;
end;

procedure TBarHideForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
   if (Y=Height-1) and (SharpBarMainForm.SharpEBar.VertPos = vpBottom)
      or (Y=0) and (SharpBarMainForm.SharpEBar.VertPos = vpTop) then
   begin
     if ssShift in Shift then
     begin
       // Toggle Mini Throbbers
       ModuleManager.ShowMiniThrobbers := not ModuleManager.ShowMiniThrobbers;
       ModuleManager.ReCalculateModuleSize;
       SharpBarMainForm.SharpEBar.Throbber.Repaint;
     end else
     begin
       // Toggle Main Throbber
       if ModuleManager.Modules.Count = 0 then
       begin
         SharpBarMainForm.SharpEBar.ShowThrobber := True;
         exit;
       end;
       SharpBarMainForm.SharpEBar.ShowThrobber := not SharpBarMainForm.SharpEBar.ShowThrobber;
       ModuleManager.ReCalculateModuleSize;
       if SharpBarMainForm.SharpEBar.ShowThrobber then SharpBarMainForm.SharpEBar.Throbber.Repaint;
       ModuleManager.BroadcastPluginUpdate(suBackground);

       // Display a tooltip if throbber was hidden for the first time
       if not SharpBarMainForm.SharpEBar.ShowThrobber and SharpBarMainForm.FirstThrobberHide then
       begin
         SharpBarMainForm.ShowNotify('The Main Button of the SharpBar was disabled because you right clicked the screen border. You can show the Button again by right clicking the screen border another time.',False);
         SharpBarMainForm.FirstThrobberHide := False;
         SharpBarMainForm.SaveBarTooltipSettings;
       end;
     end;
   end;
end;

end.
