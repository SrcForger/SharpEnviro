unit uSharpCenterDllConfigWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Tabs,
  Types,
  pngimage,
  ExtCtrls,
  Buttons,
  PngSpeedButton,
  JvExControls,
  JvComponent,
  JvGradient,
  uSharpCenterDllMethods,
  JvSimpleXml,
  JclGraphics,
  JclGraphUtils,
  SharpApi,
  StdCtrls,
  SharpEListBox,
  PngImageList,
  uSEListboxPainter,
  uSharpCenterSectionList,
  uSharpCenterManager;

type
  TfrmDllConfig_ = class(TForm)
    {procedure lbDllsClick(Sender: TObject);
    procedure lbSectionsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnHomeClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbSectionsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbDllsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Button1Click(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);  }
  private
    { Private declarations }
    {FMoveUp, FMoveDown: Boolean;
    FConfigDll: TConfigDll;
    FPluginID: Integer;
    FCancelClicked: Boolean;
    FDllFilename: string;
    FName: string;
    FOwnerWinControl: TWinControl;
    FPluginHandle: THandle;
    FSections: TSectionObjectList;

    procedure ResizeToFitWindow(AHandle: THandle; AControl: TWinControl);
    function GetControlByHandle(AHandle: THandle): TWinControl;
    function GetConfigChanged: Boolean;

    function AssignIconIndex(ASectionObject: TSectionObject): Integer; overload;
    procedure AssignIconIndex(AFileName: string; ABTData: TBTData); overload;
    function GetDisplayName(ADllFilename: string; APluginID: Integer): string;  }

  public
    { Public declarations }
    {constructor Create(AOwner: TWinControl; AConfigurationFile: string; AName:
      string);
    destructor Destroy; override;
    property ConfigDll: TConfigDll read FConfigDll write FConfigDll;
    property PluginID: Integer read FPluginID write FPluginID;
    property DllFilename: string read FDllFilename write FDllFilename;
    property Name: string read FName write FName;
    property OwnerWinControl: TWinControl read FOwnerWinControl write
      FOwnerWinControl;
    property PluginHandle: THandle read FPluginHandle write FPluginHandle;

    procedure UnloadDll;
    procedure ReloadDll;
    procedure LoadDll(AFileName: string);
    procedure LoadConfiguration(AConfigurationFile: string);
    procedure LoadSelectedDll(AItemIndex: Integer);

    procedure InitialiseWindow(AOwner: TWinControl; AName: string);
    property ConfigChanged: Boolean read GetConfigChanged;
    procedure UpdateSize;
    procedure UpdateSections;

    procedure WMSysCommand(var Message: TMessage); message WM_SYSCOMMAND; }
  end;

var
  frmDllConfig_: TfrmDllConfig_;

implementation

uses
  uSharpCenterMainWnd;

{$R *.dfm}

{procedure TfrmDllConfig.Button1Click(Sender: TObject);
begin
  btnCancel.Enabled := true;
end;                }

{* procedure TfrmDllConfig.lbDllsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  colItem: TColor;
  num: string;
  tmpItem: TBTDataDll;
begin
  if lbDlls.Items.Count = 0 then
    exit;

  num := '';
  tmpItem := TBTDataDll(lbDlls.Items.Objects[Index]);
  if tmpItem <> nil then
//    PaintListbox(lbDlls, Rect, 0 {5}//, State, tmpItem.Caption,
//      picMain,
//      tmpItem.IconIndex, tmpItem.Status, clBlack);
//end; *}

{procedure TfrmDllConfig.FormResize(Sender: TObject);
begin
  lbDlls.Invalidate;
  lbSections.Invalidate;
  UpdateSize;
end; }

{constructor TfrmDllConfig.Create(AOwner: TWinControl;
  AConfigurationFile: string; AName: string);
begin
  inherited Create(AOwner);

  InitialiseWindow(AOwner, AName);
  LoadConfiguration(AConfigurationFile);
end;              }

{procedure TfrmDllConfig.lbDllsClick(Sender: TObject);
begin
  if lbDlls.ItemIndex = -1 then
    exit;

  LoadSelectedDll(lbDlls.ItemIndex);
end;     }



end.

