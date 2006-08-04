unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32_Image, SharpEBaseControls, SharpEButton,
  SharpESkinManager, SharpEScheme, SharpESkin, ExtCtrls, SharpEProgressBar,
  JvSimpleXML, SharpApi, Jclsysinfo, Menus, Math, SharpEEdit, SharpELabel;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    lb_clock: TSharpELabel;
    ClockTimer: TTimer;
    procedure ClockTimerTimer(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sFormat : String;
    sStyle  : TSharpELabelStyle;
  public
    ModuleID : integer;
    BarWnd   : hWnd;
    procedure LoadSettings;
    procedure ReAlignComponents;
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI;

{$R *.dfm}

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  SharpApi.RegisterActionEx(PChar('!FocusMiniScmd ('+inttostr(ModuleID)+')'),'Modules',self.Handle,1);

  sFormat := 'HH:MM:SS';
  sStyle  := lsMedium;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sFormat := Value('Format','HH:MM:SS');
    case IntValue('Style',1) of
      0: sStyle := lsSmall;
      2: sStyle := lsBig;
      else sStyle := lsMedium
    end;
  end;

  ReAlignComponents;
end;

procedure TMainForm.ReAlignComponents;
var
  FreeBarSpace : integer;
  newWidth : integer;
begin
  self.Caption := sFormat;
  ClockTimer.OnTimer(ClockTimer);

  FreeBarSpace := GetFreeBarSpace(BarWnd) + self.Width;
  if FreeBarSpace <0 then FreeBarSpace := 1;
  newWidth := lb_clock.Canvas.TextWidth(sFormat)+4;
  if newWidth > FreeBarSpace then Width := FreeBarSpace
     else Width := newWidth;
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
    SettingsForm.edit_format.Text := sFormat;
    case sStyle of
      lsSmall  : SettingsForm.cb_small.Checked := True;
      lsMedium : SettingsForm.cb_medium.Checked := True;
      lsBig    : SettingsForm.cb_large.Checked := True;
    end;

    if SettingsForm.ShowModal = mrOk then
    begin
      sFormat  := SettingsForm.edit_format.Text;
      if SettingsForm.cb_small.Checked then sStyle := lsSmall
         else if SettingsForm.cb_large.Checked then sStyle := lsBig
              else sStyle := lsMedium;

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        clear;
        Add('Format',sFormat);
        case sStyle of
          lsSmall  : Add('Style',0);
          lsMedium : Add('Style',1);
          lsBig    : Add('Style',2);
       end;
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
      ClockTimer.OnTimer(ClockTimer);
    end;
    ReAlignComponents;

  finally
    SettingsForm.Free;
    SettingsForm := nil;
    SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
  end;
end;

procedure TMainForm.ClockTimerTimer(Sender: TObject);
var
  s : string;
begin
  if lb_clock.LabelStyle <> sStyle then
  begin
    lb_clock.LabelStyle := sStyle;
    RealignComponents;
  end;
  DateTimeToString(s,sFormat,now());
  lb_clock.Caption := s;
end;

end.
