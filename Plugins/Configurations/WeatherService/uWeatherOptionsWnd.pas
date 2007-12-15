unit uWeatherOptionsWnd;

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
  ComCtrls,
  StdCtrls,
  {httpget, }
  jvsimplexml, Buttons, Tabs, JvPageList, JvExControls, JvComponent, Mask,
  JvExMask, JvSpin, ExtCtrls;

type
  TfrmWeatherOptions = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    GroupBox1: TGroupBox;
    edtCheck: TJvSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtForecast: TJvSpinEdit;
    Label4: TLabel;
    edtCurConditions: TJvSpinEdit;
    rgUnits: TRadioGroup;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWeatherOptions: TfrmWeatherOptions;

implementation

{$R *.dfm}

end.

