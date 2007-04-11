unit BarHideWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TBarHideForm = class(TForm)
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CreateParams(var Params: TCreateParams); override;
  private
    procedure WMMove(var msg : TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
  public
    procedure UpdateStatus;
  end;

var
  BarHideForm: TBarHideForm;

implementation

uses SharpBarMainWnd, SharpEBar;

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

procedure TBarHideForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Closing then
     if not SharpBarMainForm.Visible then SharpBarMainForm.Show;
end;

procedure TBarHideForm.FormClick(Sender: TObject);
begin
  if Application.Terminated then exit;

  if SharpBarMainForm.Visible then
  begin
    if not SharpBarMainForm.SharpEBar.DisableHideBar then SharpBarMainForm.Hide
  end
     else
     begin
       SharpBarMainForm.Show;
       if not (SharpBarMainForm.SharpEBar.SpecialHideForm) then
       begin
         Close;
         exit;
       end;
     end;
  UpdateStatus;
end;

procedure TBarHideForm.UpdateStatus;
var
  mon : TMonitor;
begin
  if Application.Terminated then exit;

  mon := Screen.MonitorFromWindow(SharpBarMainForm.Handle);
  if mon = nil then mon := Screen.MonitorFromPoint(Point(SharpBarMainForm.Left,SharpBarMainForm.Top));

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
  width := 1;
  height := 1;
  left := -4096;
  top := -4096;
//  Setwindowlong(handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW or WS_EX_LAYERED);
end;

procedure TBarHideForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
   if (Y=Height-1) and (SharpBarMainForm.SharpEBar.VertPos = vpBottom)
      or (Y=0) and (SharpBarMainForm.SharpEBar.VertPos = vpTop) then
   begin
     if ModuleManager.Modules.Count = 0 then
     begin
       SharpBarMainForm.SharpEBar.ShowThrobber := True;
       exit;
     end;
     SharpBarMainForm.SharpEBar.ShowThrobber := not SharpBarMainForm.SharpEBar.ShowThrobber;
     LockWindow(SharpBarMainForm.Handle);
     ModuleManager.FixModulePositions;
     UnLockWindow(SharpBarMainForm.Handle);
     if SharpBarMainForm.SharpEBar.ShowThrobber then SharpBarMainForm.SharpEBar.Throbber.Repaint;
   end;
end;

end.
