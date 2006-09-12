unit main;

interface

uses
  Controls, Forms, Windows, Messages, ShellHookTypes, sharpapi, sharpprocess;

type
  TfmMain = class(TForm)
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    HookData: PShellHookData;

    FMappedFileHandle: THandle;

    property MappedFileHandle: THandle read FMappedFileHandle write FMappedFileHandle;

    procedure WMHSHELLNOTIFY(var Msg: TMessage); message WM_HSHELL_NOTIFY;
  public
    { Public declarations }
    procedure Hook;
    procedure UnHook;
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  fmMain: TfmMain;

procedure HookShell; stdcall; external 'SharpProcess.dll';
procedure UnHookShell; stdcall; external 'SharpProcess.dll';

implementation

{$R *.dfm}

{$REGION ' Form Events & Overrides & Message Traps '}
procedure TfmMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do begin
    WinClassName := 'SharpE_SystemTask';
  end;
end;
procedure TfmMain.FormCreate(Sender: TObject);
begin
//
end;
procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//
end;
procedure TfmMain.FormDestroy(Sender: TObject);
begin
  fmMain := nil;
end;
procedure TfmMain.WMHSHELLNOTIFY(var Msg: TMessage);
begin
  SharpEBroadCastEx(WM_HSHELL_BROADCAST,Msg.WParam,Msg.LParam);
end;
{$ENDREGION}

{$REGION ' Hook Procedures '}
procedure TfmMain.Hook;
var
  mm: MINIMIZEDMETRICS;
begin
  FillChar(mm, SizeOf(MINIMIZEDMETRICS), 0);

  mm.cbSize := SizeOf(MINIMIZEDMETRICS);
  SystemParametersInfo(SPI_GETMINIMIZEDMETRICS, sizeof(MINIMIZEDMETRICS),@mm, 0);

  mm.iArrange := mm.iArrange or ARW_HIDE;
  SystemParametersInfo(SPI_SETMINIMIZEDMETRICS, sizeof(MINIMIZEDMETRICS),@mm, 0);

  { Create the Memory Mapped File that will allow hooked application to pass    }
  { data to this application, and allow the hooked applications to know the     }
  { handle of this window.                                                      }
  MappedFileHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
    SizeOf(TShellHookData), str_ShellHookData);
  HookData := MapViewOfFile(MappedFileHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  if Assigned(HookData) then
   begin
    FillChar(HookData^, SizeOf(TShellHookData), #0);
    HookData^.AppHandle := Handle;
    HookShell;
   end;
end;
procedure TfmMain.UnHook;
begin
  UnHookShell;

  if Assigned(HookData) then
   begin
    UnmapViewOfFile(HookData);
   end;

  if (MappedFileHandle > 0) then
   CloseHandle(MappedFileHandle);
end;
{$ENDREGION}

end.
