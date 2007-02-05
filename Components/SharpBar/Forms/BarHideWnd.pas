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

procedure TBarHideForm.WMMove(var msg : TWMWindowPosChanging);
begin
  if not self.Visible then exit;
//  msg.WindowPos.x := self.Left;
//  msg.WindowPos.y := self.Top;
end;

procedure TBarHideForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Application.Terminated then exit;

  if not SharpBarMainForm.Visible then SharpBarMainForm.Show;
end;

procedure TBarHideForm.FormClick(Sender: TObject);
begin
  if Application.Terminated then exit;

  if SharpBarMainForm.Visible then
  begin
    if not SharpBarMainForm.SharpEBar1.DisableHideBar then SharpBarMainForm.Hide
  end
     else
     begin
       SharpBarMainForm.Show;
       if not (SharpBarMainForm.SharpEBar1.SpecialHideForm) then
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

  if (SharpBarMainForm.SharpEBar1.VertPos = vpTop) and
     (SharpBarMainForm.SharpEBar1.SpecialHideForm) then
  begin
    Left := SharpBarMainForm.Left;
    Width := SharpBarMainForm.Width;
    if mon <> nil then Top := mon.Top;
    Height := 1;
    if not Visible then Show;
  end else
  if (SharpBarMainForm.SharpEBar1.VertPos = vpBottom) and
     (SharpBarMainForm.SharpEBar1.SpecialHideForm) then
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
  Setwindowlong(handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW or WS_EX_LAYERED);
end;

procedure TBarHideForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
   if (Y=Height-1) and (SharpBarMainForm.SharpEBar1.VertPos = vpBottom)
      or (Y=0) and (SharpBarMainForm.SharpEBar1.VertPos = vpTop) then
   begin
     if ModuleManager.Modules.Count = 0 then
     begin
       SharpBarMainForm.SharpEBar1.ShowThrobber := True;
       exit;
     end;
     SharpBarMainForm.SharpEBar1.ShowThrobber := not SharpBarMainForm.SharpEBar1.ShowThrobber;
     LockWindow(SharpBarMainForm.Handle);
     ModuleManager.FixModulePositions;
     UnLockWindow(SharpBarMainForm.Handle);
     if SharpBarMainForm.SharpEBar1.ShowThrobber then SharpBarMainForm.SharpEBar1.Throbber.Repaint;
   end;
end;

end.
