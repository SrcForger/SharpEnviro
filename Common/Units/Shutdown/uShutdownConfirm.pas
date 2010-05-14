unit uShutdownConfirm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls, uVistaFuncs,
  SharpThemeApiEx, uThemeConsts, uSystemFuncs,
  GR32, GR32_Png, SharpIconUtils, GR32_Image;

type
  TShutdownConfirmForm = class(TForm)
    ConText: TLabel;
    btnYes: TButton;
    btnNo: TButton;
    IconImage: TImage32;
    TimeoutText: TLabel;
    TimeoutTimer: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnYesClick(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
    procedure TimeoutTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure CreateParams(var Params: TCreateParams); override;

    procedure SetMsgIcon(s : string);
    procedure SetMsgText(s : string);
    procedure SetMsgCaption(s : string);
    procedure SetMsgTimeout(s : String);
  private
    { Private declarations }
    FMsgIcon : string;
    FMsgText : string;
    FMsgCaption : string;
    FMsgTimeout : string;
    FDoTimeout  : boolean;

  public
    { Public declarations }
    procedure LoadIcon;

    property MsgIcon: string read FMsgIcon write SetMsgIcon;
    property MsgText: string read FMsgText write SetMsgText;
    property MsgCaption: string read FMsgCaption write SetMsgCaption;
    property MsgTimeout: string read FMsgTimeout write SetMsgTimeout;
    property DoTimeout: boolean read FDoTimeout write FDoTimeout;
  end;

var
  ShutdownConfirmForm: TShutdownConfirmForm;

implementation

{$R *.dfm}

procedure TShutdownConfirmForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    ExStyle := ExStyle or WS_EX_TOPMOST;
    WndParent := GetDesktopwindow;
  end;
end;

procedure TShutdownConfirmForm.btnNoClick(Sender: TObject);
begin
  ModalResult := mrNo;
  CloseModal;
end;

procedure TShutdownConfirmForm.btnYesClick(Sender: TObject);
begin
  ModalResult := mrYes;
  CloseModal;
end;

procedure TShutdownConfirmForm.FormActivate(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TShutdownConfirmForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  TimeoutTimer.Enabled := False;
end;

procedure TShutdownConfirmForm.FormCreate(Sender: TObject);
begin
  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

  // Enable vista fonts
  SetVistaFonts(Self);

  // Load the current theme
  GetCurrentTheme.LoadTheme([tpIconSet]);

  FDoTimeout := True;
end;

procedure TShutdownConfirmForm.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  ForceForegroundWindow(Handle);

  TimeoutTimer.Tag := 20;
  TimeoutTimer.Enabled :=  FDoTimeout;
end;

procedure TShutdownConfirmForm.SetMsgIcon(s : string);
begin
  FMsgIcon := s;
  LoadIcon;
end;

procedure TShutdownConfirmForm.SetMsgText(s : string);
begin
  FMsgText := s;
  ConText.Caption := FMsgText;
end;

procedure TShutdownConfirmForm.SetMsgTimeout(s: String);
begin
  FMsgTimeout := s;
  TimeoutText.Caption := s + ' 20 seconds.';
end;

procedure TShutdownConfirmForm.TimeoutTimerTimer(Sender: TObject);
begin
  TimeoutTimer.Tag := TimeoutTimer.Tag - 1;
  TimeoutText.Caption := FMsgTimeout + ' ' + inttostr(TimeoutTimer.Tag) + ' seconds.';
  if TimeoutTimer.Tag <= 0 then
  begin
    TimeoutTimer.Tag := 20;
    TimeoutTimer.Enabled := False;
    btnYes.OnClick(btnYes);
  end;  
end;

procedure TShutdownConfirmForm.SetMsgCaption(s : string);
begin
  FMsgCaption := s;
  Self.Caption := FMsgCaption;
end;

procedure TShutdownConfirmForm.LoadIcon;
var
  TempBmp : TBitmap32;
begin
  TempBmp := TBitmap32.Create;
  try
    TempBmp.DrawMode := dmBlend;
    TempBmp.CombineMode := cmMerge;
    TempBmp.SetSize(64, 64);

    TempBmp.Clear(color32(0,0,0,0));
    IconStringToIcon(FMsgIcon, '', TempBmp, 64);
    IconImage.Bitmap.Assign(TempBmp);
  finally
    TempBmp.Free;
  end;
end;

end.
