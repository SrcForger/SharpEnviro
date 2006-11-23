unit SharpEListBoxReg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvPageListTreeView, JvExControls,
  JvComponent, JvPageList, DesignIntf,
  DesignWindows,
  DesignEditors,
  TypInfo, StdCtrls, ImgList, PngImageList, ToolWin, Buttons, PngSpeedButton,
  JvExStdCtrls, JvCombobox, JvColorCombo, ExtCtrls, Mask, JvExMask, JvSpin;

type
  TSharpEListBoxColumnsProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

type
  TfrmEditColumn = class(TForm)
    lbColumns: TListBox;
    ToolBar1: TToolBar;
    btnAdd: TToolButton;
    btnDelete: TToolButton;
    PngImageList1: TPngImageList;
    Label1: TLabel;
    JvSpinEdit1: TJvSpinEdit;
    plMain: TJvPageList;
    plAddColumns: TJvStandardPage;
    plConfig: TJvStandardPage;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    JvColorComboBox1: TJvColorComboBox;
    Label4: TLabel;
    JvColorComboBox2: TJvColorComboBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label5: TLabel;
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEditColumn: TfrmEditColumn;

implementation

uses
  SharpEListBoxEx;

{ TSharpEListBoxColumnsProperty }

{function TSharpEListBoxColumnsProperty.GetValue: TList;
begin
  Result := TSharpEListBox(getcomponent(0)).columns;
  if  TSharpEListBox(getcomponent(0)).ColumnCount = 0 then
  Result := '(Undefined)' else
  Result := '(Columns Defined: ' + IntToStr(TSharpEListBox((getcomponent(0))).ColumnCount) + ')';
end;

procedure TSharpEListBoxColumnsProperty.SetValue(const Value: TList);
begin
  inherited;
  TSharpEListBox(getcomponent(0)).columns.assign(Value);// := TSharpEListBox(getcomponent(0)).columns;
end;   }

procedure TSharpEListBoxColumnsProperty.Edit;
var
  i:Integer;
  tmpColumn:TSharpEListBoxExColumn;
begin
  inherited;
  frmEditColumn := TFrmEditColumn.Create(nil);
  frmEditColumn.Tag := Integer(TSharpEListBoxEx(getcomponent(0)));
  Try

    For i := 0 to Pred(TSharpEListBoxEx(getcomponent(0)).ColumnCount) do begin
      tmpColumn := TSharpEListBoxEx(getcomponent(0)).Column[i];
      frmEditColumn.lbColumns.AddItem('Column 1',tmpColumn);
    end;

    if TSharpEListBoxEx(getcomponent(0)).ColumnCount = 0 then
      frmEditColumn.plMain.ActivePage := frmEditColumn.plAddColumns else
      frmEditColumn.plMain.ActivePage := frmEditColumn.plConfig;

    frmEditColumn.ShowModal;



  Finally
    FreeAndNil(FrmEditColumn);
  End;
end;

function TSharpEListBoxColumnsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

{$R *.dfm}

procedure TfrmEditColumn.btnAddClick(Sender: TObject);
var
  lb:TSharpEListBoxEx;
  s:String;
  tmpCol: TSharpEListBoxExColumn;
begin
  lb := TSharpEListBoxEx(Pointer(Self.Tag));

  tmpCol := lb.AddColumn('');
  s := 'Column ' + IntToStr(lb.ColumnCount);

  frmEditColumn.lbColumns.AddItem(s,tmpCol);
  plMain.ActivePage := plConfig;

end;

end.
