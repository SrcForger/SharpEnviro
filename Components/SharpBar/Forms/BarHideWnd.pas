unit BarHideWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MonitorList;

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

procedure TBarHideForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Closing then
     if not SharpBarMainForm.Visible then
     begin
       SharpBarMainForm.Show;
       SharpBarMainForm.Repaint;
       SharpApi.ServiceMsg('DeskArea','Update');
     end;
end;

procedure TBarHideForm.FormClick(Sender: TObject);
begin
  if Closing then exit;

  if SharpBarMainForm.Visible then
  begin
    if not SharpBarMainForm.SharpEBar.DisableHideBar then
    begin
      SharpBarMainForm.Hide;
      SharpApi.ServiceMsg('DeskArea','Update');
    end;
  end
     else
     begin
       SharpBarMainForm.Show;
       SharpBarMainForm.Repaint;
       SharpApi.ServiceMsg('DeskArea','Update');
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
     end;
   end;
end;

end.
