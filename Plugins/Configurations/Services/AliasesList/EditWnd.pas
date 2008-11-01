unit EditWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpApi, Buttons, PngSpeedButton, SharpEHotkeyEdit, StdCtrls,
  ExtCtrls, SharpDialogs, JclFileUtils, JvErrorIndicator, JvValidators,
  JvComponentBase, ImgList, PngImageList, SharpcenterApi, SharpEListBoxEx,
  uExecServiceAliasList, ISharpCenterHostUnit;

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
    FItemEdit: TAliasListItem;
    FUpdating: Boolean;
    FPluginHost: TInterfacedSharpCenterHostBase;
    { Private declarations }
  public
    { Public declarations }
    function InitUi:Boolean;
    function ValidateEdit:Boolean;
    function Save(AApply: Boolean):Boolean;

    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;
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
  if not(FUpdating) then
    FPluginHost.Editing := true;
end;

function TfrmEditWnd.InitUi:Boolean;
var
  tmpItem: TSharpEListItem;
  tmp: TAliasListItem;
begin
  Result := False;
  FUpdating := True;
  try

    case FPluginHost.EditMode of
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
    FUpdating := False;
  end;
end;

function TfrmEditWnd.Save(AApply: Boolean): Boolean;
var
  tmpItem: TSharpEListItem;
  tmp: TAliasListItem;
begin
  Result := false;
  if not (AApply) then
    Exit;

  case FPluginHost.EditMode of
    sceAdd: begin
        frmItemsWnd.AliasItems.Add(edName.Text, edCommand.Text, cbElevation.Checked);
        FPluginHost.SetSettingsChanged;

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

        FPluginHost.SetSettingsChanged;
        frmItemsWnd.AddItems;

        frmItemsWnd.AliasItems.Save;
        Result := True;
      end;
  end;

  PluginHost.Refresh(rtAll);
end;

function TfrmEditWnd.ValidateEdit: Boolean;
begin
  Result := False;

  case FPluginHost.EditMode of
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
