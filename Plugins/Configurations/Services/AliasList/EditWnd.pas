unit EditWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpApi, Buttons, PngSpeedButton, StdCtrls,
  ExtCtrls, SharpDialogs, JclFileUtils, SharpEListBoxEx,
  JvComponentBase, ImgList, SharpcenterApi,
  uExecServiceAliasList, ISharpCenterHostUnit, JvExControls, JvXPCore,
  JvXPCheckCtrls;

type
  TfrmEditWnd = class(TForm)
    edName: TLabeledEdit;
    edCommand: TLabeledEdit;
    Button1: TPngSpeedButton;
    cbElevation: TJvXPCheckbox;
    procedure Button1Click(Sender: TObject);
    procedure UpdateEditState(Sender: TObject);
  private
    FItemEdit: TAliasListItem;
    FUpdating: Boolean;
    FPluginHost: ISharpCenterHost;
    { Private declarations }
  public
    { Public declarations }
    procedure Init;
    procedure Save;

    property ItemEdit: TAliasListItem read FItemEdit write FItemEdit;
    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
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

procedure TfrmEditWnd.Init;
var
  tmpItem: TSharpEListItem;
  tmp: TAliasListItem;
begin
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

procedure TfrmEditWnd.Save;
var
  tmpItem: TSharpEListItem;
  tmp: TAliasListItem;
begin

  case FPluginHost.EditMode of
    sceAdd: begin
        frmItemsWnd.AliasItems.AddItem(edName.Text, edCommand.Text, cbElevation.Checked);
        FPluginHost.SetSettingsChanged;

        frmItemsWnd.AddItems;

        frmItemsWnd.AliasItems.Save;
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
      end;
  end;

  PluginHost.Refresh(rtAll);
end;

end.
