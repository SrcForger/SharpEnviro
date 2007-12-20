unit EditWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpApi, Buttons, PngSpeedButton, SharpEHotkeyEdit, StdCtrls,
  ExtCtrls, SharpDialogs, JclFileUtils, JvErrorIndicator, JvValidators,
  JvComponentBase, ImgList, PngImageList, SharpcenterApi, SharpEListBoxEx,
  uExecServiceAliasList;

type
  TfrmEditWnd = class(TForm)
    edName: TLabeledEdit;
    edCommand: TLabeledEdit;
    Button1: TPngSpeedButton;
    cbElevation: TCheckBox;
    pilError: TPngImageList;
    vals: TJvValidators;
    valName: TJvRequiredFieldValidator;
    valCommand: TJvRequiredFieldValidator;
    valNameExists: TJvCustomValidator;
    errorinc: TJvErrorIndicator;
    procedure Button1Click(Sender: TObject);
    procedure UpdateEditState(Sender: TObject);
    procedure valNameExistsValidate(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
    FItemEdit: TAliasListItem;
    { Private declarations }
  public
    { Public declarations }
    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
    function InitUi(AEditMode: TSCE_EDITMODE_ENUM):Boolean;
    function ValidateEdit(AEditMode: TSCE_EDITMODE_ENUM):Boolean;
    function Save(AApply: Boolean; AEditMode: TSCE_EDITMODE_ENUM):Boolean;
  end;

var
  frmEditWnd: TfrmEditWnd;

implementation

uses ItemsWnd;

{$R *.dfm}

{ TfrmEditWnd }

procedure TfrmEditWnd.Button1Click(Sender: TObject);
begin
  edCommand.Text := SharpDialogs.TargetDialog(STI_ALL_TARGETS, Mouse.CursorPos);
  edName.Text := PathRemoveExtension(ExtractFileName(edCommand.Text));
end;

procedure TfrmEditWnd.UpdateEditState(Sender: TObject);
begin
  CenterDefineEditState(True);
end;

function TfrmEditWnd.InitUi(AEditMode: TSCE_EDITMODE_ENUM):Boolean;
var
  tmpItem: TSharpEListItem;
  tmp: TAliasListItem;
begin
  Result := False;
  edName.OnChange := nil;
  edCommand.OnChange := nil;
  cbElevation.OnClick := nil;
  try

    case AEditMode of
      sceAdd: begin
          edName.Text := '';
          edCommand.Text := '';
          edName.SetFocus;

          FItemEdit := nil;
        end;
      sceEdit: begin

          if frmItemsWnd.lbItems.SelectedItem = nil then
            exit;

          tmpItem := frmItemsWnd.lbItems.SelectedItem;
          tmp := TAliasListItem(tmpItem.Data);
          FItemEdit := tmp;

          edName.Text := tmp.AliasName;
          edCommand.Text := tmp.AliasValue;
          cbElevation.Checked := tmp.Elevate;
          edName.SetFocus;
        end;
    end;

  finally
    edName.OnChange := UpdateEditState;
    edCommand.OnChange := UpdateEditState;
    cbElevation.OnClick := UpdateEditState;

    if frmItemsWnd.lbItems.SelectedItem <> nil then begin
      CenterDefineButtonState(scbEditTab, True);
    end
    else begin
      CenterDefineButtonState(scbEditTab, False);
      CenterSelectEditTab(scbAddTab);

      edName.Text := '';
      edCommand.Text := '';
      cbElevation.Checked := False;
    end;
  end;
end;

function TfrmEditWnd.Save(AApply: Boolean;
  AEditMode: TSCE_EDITMODE_ENUM): Boolean;
var
  tmpItem: TSharpEListItem;
  tmp: TAliasListItem;
begin
  Result := false;
  if not (AApply) then
    Exit;

  case AEditMode of
    sceAdd: begin
        frmItemsWnd.AliasItems.Add(edName.Text, edCommand.Text, cbElevation.Checked);
        CenterDefineSettingsChanged;

        frmItemsWnd.AddItems;

        frmItemsWnd.AliasItems.Save;
        Result := True;
      end;
    sceEdit: begin
        tmpItem := frmItemsWnd.lbItems.SelectedItem;
        tmp := TAliasListItem(tmpItem.Data);
        tmp.AliasName := edName.Text;
        tmp.AliasValue := edCommand.Text;
        tmp.Elevate := cbElevation.Checked;

        CenterDefineSettingsChanged;
        frmItemsWnd.AddItems;

        frmItemsWnd.AliasItems.Save;
        Result := True;
      end;
  end;

  CenterUpdateConfigFull;
end;

function TfrmEditWnd.ValidateEdit(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
begin
  Result := False;

  case AEditMode of
    sceAdd, sceEdit: begin

        errorinc.BeginUpdate;
        try
          errorinc.ClearErrors;
          vals.ValidationSummary := nil;

          Result := vals.Validate;
        finally
          errorinc.EndUpdate;
        end;
      end;
    sceDelete: Result := True;
  end;
end;

procedure TfrmEditWnd.valNameExistsValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  idx: Integer;
  s: string;
begin
  Valid := True;

  s := '';
  if ValueToValidate <> null then
    s := VarToStr(ValueToValidate);

  if s = '' then begin
    Valid := False;
    Exit;
  end;

  idx := frmItemsWnd.AliasItems.IndexOfName(s);

  if (idx <> -1) then begin

    if FItemEdit <> nil then
      if FItemEdit.AliasName = s then
        exit;

    Valid := False;
  end;
end;

end.
