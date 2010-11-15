{
Source Name: SharpBarListEditWnd.pas
Description: SharpBarList Edit Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit uEditWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Math,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  JvExControls,
  JvComponent,
  ImgList,
  PngImageList,
  JvExStdCtrls,
  JvEdit,
  JvValidateEdit,
  JvValidators,
  JvComponentBase,
  JvErrorIndicator,
  ExtCtrls,
  JvPageList,
  JclSimpleXml,
  SharpApi,
  JclStrings,
  SharpCenterApi,
  SharpEListBoxEx,
  uListWnd,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit, SharpEGaugeBoxEdit, JvXPCore, JvXPCheckCtrls;

type
  TfrmEditwnd = class(TForm)
    vals: TJvValidators;
    errorinc: TJvErrorIndicator;
    pilError: TPngImageList;
    valBarName: TJvCustomValidator;
    edName: TLabeledEdit;
    cobo_monitor: TComboBox;
    cbBasedOn: TComboBox;
    cobo_valign: TComboBox;
    cobo_halign: TComboBox;
    JvLabel2: TLabel;
    JvLabel1: TLabel;
    Label3: TLabel;
    pnlBarSpace: TPanel;
    Label1: TLabel;
    JvLabel4: TLabel;
    cbFixedWidth: TJvXPCheckbox;
    sgbFixedWidth: TSharpeGaugeBox;
    chkAutoHide: TJvXPCheckbox;
    sgbAutoHide: TSharpeGaugeBox;
    Label2: TLabel;
    Panel1: TPanel;
    procedure valBarNameValidate(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
    procedure cbBasedOnSelect(Sender: TObject);

    procedure edThemeNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbFixedWidthClick(Sender: TObject);
    procedure sgbFixedWidthChangeValue(Sender: TObject; Value: Integer);
    procedure chkAutoHideClick(Sender: TObject);
  private
    FBarItem: TBarItem;
    FUpdating: Boolean;
    FPluginHost: ISharpCenterHost;
    { Private declarations }
  public
    { Public declarations }
    procedure BuildMonList;
    procedure ClearMonList;
    function ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
    procedure ClearValidation;

    property BarItem: TBarItem read FBarItem write FBarItem;

    procedure Init;
    procedure Save;

    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
  end;

type
  TIntObject = class
    Value: Integer;
    constructor Create(pValue: integer);
  end;

var
  frmEditwnd: TfrmEditwnd;

implementation

uses
  uSharpXMLUtils;

{$R *.dfm}

procedure TfrmEditwnd.Init;
var
  tmpItem: TSharpEListItem;
  tmpBar: TBarItem;
  n: integer;
begin
  FUpdating := True;
  try

    case FPluginHost.EditMode of
      sceAdd: begin

          if not (frmListWnd.BarSpaceCheck) then
          begin
            pnlBarSpace.Width := Self.Width;
            pnlBarSpace.Height := Self.Height;
            Label1.Width := Self.Width;
            Label1.Height := Self.Height;
            pnlBarSpace.Show;
            Exit;
          end;

          pnlBarSpace.Hide;
          pnlBarSpace.Width := 0;
          pnlBarSpace.Height := 0;
          edName.Text := '';

          cbBasedOn.Items.Clear;
          cbBasedOn.Items.AddObject('New Bar', nil);

          // Build list
          for n := 0 to frmListWnd.lbBarList.Count - 1 do
          begin
            if not Assigned(frmListWnd.lbBarList.Item[n].Data) then
              continue;
              
            tmpBar := TBarItem(frmListWnd.lbBarList.Item[n].Data);
            cbBasedOn.Items.AddObject(tmpBar.Name, tmpBar);
          end;

          cbBasedOn.ItemIndex := 0;
          cbBasedOn.Enabled := True;
          FBarItem := nil;

          BuildMonList;
          cobo_monitor.ItemIndex := 0;
          edName.SetFocus;
        end;
      sceEdit: begin
          if frmListWnd.lbBarList.ItemIndex <> -1 then begin

            pnlBarSpace.Hide;
            pnlBarSpace.Width := 0;
            pnlBarSpace.Height := 0;
            tmpItem := frmListWnd.lbBarList.SelectedItem;
            FBarItem := TBarItem(tmpItem.Data);

            edName.Text := FBarItem.Name;
            edName.SetFocus;

            if FBarItem = nil then
            begin
              FBarItem := TBarItem.Create;

              FBarItem.Name := 'Toolbar';
              FBarItem.BarID := FBarItem.BarID;
              FBarItem.Monitor := FBarItem.Monitor;
              FBarItem.PMonitor := FBarItem.PMonitor;
              FBarItem.HPos := 1;
              FBarItem.VPos := 0;
              FBarItem.AutoStart := True;
              FBarItem.FixedWidthEnabled := False;
              FBarItem.FixedWidth := 50;
              FBarItem.DisableHideBar := True;
              FBarItem.MiniThrobbers := False;
              FBarItem.StartHidden := False;
              FBarItem.ShowThrobber := True;
              FBarItem.AlwaysOnTop := False;
              FBarItem.AutoHide := False;
              FBarItem.AutoHideTime := 1000;
            end;

            BuildMonList;
            if FBarItem.PMonitor then
              cobo_monitor.ItemIndex := 0
            else
              cobo_monitor.ItemIndex := Min(abs(FBarItem.Monitor), cobo_monitor.Items.Count - 1);
            cobo_valign.ItemIndex := FBarItem.VPos;
            cobo_halign.ItemIndex := FBarItem.HPos;

            sgbFixedWidth.Value := FBarItem.FixedWidth;
            cbFixedWidth.Checked := FBarITem.FixedWidthEnabled;

            chkAutoHide.Checked := FBarItem.AutoHide;
            if FBarITem.AutoHideTime > 0 then
              sgbAutoHide.Value := FBarITem.AutoHideTime div 1000;

            cbBasedOn.Items.Clear;
            cbBasedOn.Items.AddObject('Not Applicable', nil);
            cbBasedOn.ItemIndex := 0;
            cbBasedOn.Enabled := False;
          end;
        end;
    end;
  finally
    cbFixedWidthClick(nil);
    FUpdating := False;
  end;
end;

procedure TfrmEditwnd.Save;
var
  xml: TJclSimpleXML;
  dir: string;
  newId: string;
  copyId: integer;
  n: integer;
  wnd: hwnd;
  sr: TSearchRec;
  fileLoaded: boolean;
begin
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';
  copyId := 0;

  case FPluginHost.EditMode of
    sceAdd: begin
        // Generate a new unique bar ID and make sure that there is no other
        // bar with the same ID
        repeat
          newId := '';
          for n := 1 to 8 do
            newId := newId + inttostr(random(9) + 1);
        until not DirectoryExists(dir + newId);

        CreateDirectory(PChar(dir + newId), nil);

        if cbBasedOn.ItemIndex > 0 then begin
          copyId := TBarItem(cbBasedOn.Items.Objects[cbBasedOn.ItemIndex]).BarID;

          if FindFirst(dir + inttostr(copyId) + '\*.xml', FAAnyFile, sr) = 0 then
            repeat
              if FileExists(dir + inttostr(copyId) + '\' + sr.Name) then
                CopyFile(PChar(dir + inttostr(copyId) + '\' + sr.Name),
                  PChar(dir + newId + '\' + sr.Name), True);
            until FindNext(sr) <> 0;
          FindClose(sr);
        end;

        xml := TJclSimpleXML.Create;
        try
          if FileCheck(dir + newId + '\Bar.xml', True) then begin
            try
              xml.LoadFromFile(dir + newId + '\Bar.xml');
              fileLoaded := True;
            except
              fileLoaded := False;
            end;
          end
          else
            fileLoaded := False;
  
          if not fileLoaded then
            xml.Root.Name := 'SharpBar';
  
          with xml.Root.Items do begin
            if ItemNamed['Settings'] = nil then
              Add('Settings');
  
            with ItemNamed['Settings'].Items do
            begin
              clear;
              Add('ID', newId);
              Add('Name', edName.Text);
              Add('ShowThrobber', True);
              Add('DisableHideBar', True);
              Add('AutoStart', True);
              Add('AutoPosition', True);
              Add('StartHidden', False);
              Add('MiniThrobbers', False);
              Add('PrimaryMonitor', (cobo_monitor.ItemIndex = 0));
              Add('MonitorIndex', TIntObject(cobo_monitor.Items.Objects[cobo_monitor.ItemIndex]).Value);
              Add('HorizPos', cobo_halign.ItemIndex);
              Add('VertPos', cobo_valign.ItemIndex);
              Add('FixedWidth', sgbFixedWidth.Value);
              Add('FixedWidthEnabled', cbFixedWidth.Checked);
              Add('ShowMiniThrobbers', False);
              Add('AlwaysOnTop', False);
              Add('AutoHide', chkAutoHide.Checked);
              Add('AutoHideTime', sgbAutoHide.Value * 1000);
            end;
  
            if ItemNamed['Modules'] = nil then
              Add('Modules');
          end;
          ForceDirectories(dir + newId);
          if FileCheck(dir + newId + '\Bar.xml') then
            xml.SaveToFile(dir + newId + '\Bar.xml');
        finally
          xml.Free;
        end;
      end;
    sceEdit:
      begin
        copyId := TBarItem(FBarItem).BarID;
        xml := TJclSimpleXML.Create;
        if LoadXMLFromSharedFile(XML,dir + inttostr(copyId) + '\Bar.xml',False) then
        begin
          with xml.Root.Items do
          begin
            if ItemNamed['Settings'] = nil then
              Add('Settings');

            with ItemNamed['Settings'].Items do
            begin
              Clear;
              Add('ID', newId);
              Add('Name', edName.Text);
              Add('AutoPosition', True);
              Add('ShowThrobber', FBarItem.ShowThrobber);
              Add('DisableHideBar', FBarItem.DisableHideBar);
              Add('AutoStart', FBarItem.AutoStart);
              Add('AutoPosition', True);
              Add('StartHidden', FBarItem.StartHidden);
              Add('MiniThrobbers', FBarItem.MiniThrobbers);
              Add('PrimaryMonitor', (cobo_monitor.ItemIndex = 0));
              Add('MonitorIndex', TIntObject(cobo_monitor.Items.Objects[cobo_monitor.ItemIndex]).Value);
              Add('HorizPos', cobo_halign.ItemIndex);
              Add('VertPos', cobo_valign.ItemIndex);
              Add('FixedWidth', sgbFixedWidth.Value);
              Add('FixedWidthEnabled', cbFixedWidth.Checked);
              Add('ShowMiniThrobbers', FBarItem.MiniThrobbers);
              Add('AlwaysOnTop', FBarItem.AlwaysOnTop);
              Add('AutoHide', chkAutoHide.Checked);
              Add('AutoHideTime', sgbAutoHide.Value * 1000);
            end;
          end;
          SaveXMLToSharedFile(XML,dir + inttostr(copyId) + '\Bar.xml',True);
        end;
        xml.Free;        
      end;
  end;

  if FPluginHost.EditMode = sceAdd then
    SharpApi.SharpExecute('_nohist,' + SharpApi.GetSharpeDirectory + 'SharpBar.exe' +
      ' -load:' + newId +
      ' -noREB' +
      ' -noLASB')
  else if FPluginHost.EditMode = sceEdit then begin
    wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(copyId)));
    if wnd <> 0 then
      SendMessage(wnd, WM_BARREPOSITION, 0, 0);
  end;

  frmListWnd.tmrUpdate.Enabled := True;
end;

procedure TfrmEditwnd.sgbFixedWidthChangeValue(Sender: TObject; Value: Integer);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEditwnd.BuildMonList;
var
  n: integer;
  s: string;
  Mon: TMonitor;

begin
  ClearMonList;
  for n := 0 to Screen.MonitorCount - 1 do begin
    Mon := Screen.Monitors[n];
    if Mon.Primary then
      s := 'Primary'
    else
      s := inttostr(Mon.MonitorNum);
    s := s + ' (' + inttostr(Mon.Width) + 'x' + inttostr(Mon.Height) + ')';
    cobo_monitor.Items.AddObject(s, TIntObject.Create(Mon.MonitorNum));

    if Mon.Primary then
      cobo_monitor.Items.Move(n, 0);
  end;
end;

procedure TfrmEditwnd.edThemeNameKeyPress(Sender: TObject; var Key: Char);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEditwnd.FormCreate(Sender: TObject);
begin
  FBarItem := TBarItem.Create;
end;

procedure TfrmEditwnd.FormDestroy(Sender: TObject);
begin
  ClearMonList;
end;

function TfrmEditwnd.ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
begin
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
    vals.ValidationSummary := nil;

    Result := vals.Validate;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TfrmEditwnd.cbBasedOnSelect(Sender: TObject);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEditwnd.cbFixedWidthClick(Sender: TObject);
var
  i : integer;
begin
  sgbFixedWidth.Enabled := cbFixedWidth.Checked;

  i := cobo_halign.ItemIndex;
  if cbFixedWidth.Checked then
  begin
    cobo_halign.Items.Clear;
    cobo_halign.Items.Add('Left');
    cobo_halign.Items.Add('Middle');
    cobo_halign.Items.Add('Right');
    if i = 3 then
      cobo_halign.ItemIndex := 1
    else cobo_halign.ItemIndex := i;
  end
  else begin
    cobo_halign.Items.Clear;
    cobo_halign.Items.Add('Left');
    cobo_halign.Items.Add('Middle');
    cobo_halign.Items.Add('Right');
    cobo_halign.Items.Add('Full Screen');
    cobo_halign.ItemIndex := i;
  end;

  if not (FUpdating) then
    FPluginHost.Editing := true;  
end;

procedure TfrmEditwnd.chkAutoHideClick(Sender: TObject);
begin
  sgbAutoHide.Enabled := chkAutoHide.Checked;

  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEditwnd.ClearMonList;
var
  n: integer;
begin
  for n := 0 to cobo_monitor.Items.Count - 1 do
    TIntObject(cobo_monitor.Items.Objects[n]).Free;
  cobo_monitor.Items.Clear;
end;

procedure TfrmEditwnd.ClearValidation;
begin
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TfrmEditwnd.valBarNameValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  n: integer;
begin
  if (pnlBarSpace.Visible) then begin
    Valid := True;
    exit;
  end;

  if length(trim(ValueToValidate)) = 0 then begin
    valBarName.ErrorMessage := 'Please enter a valid name!';
    Valid := False;
    exit;
  end;

  for n := 0 to frmListWnd.lbBarList.Count - 1 do
    if FBarItem <> TBarItem(frmListWnd.lbBarList.Item[n].Data) then
      if CompareText(frmListWnd.lbBarList.Item[n].SubItemText[1], ValueToValidate) = 0 then begin
        valBarName.ErrorMessage := 'Another Bar with the same name already exists!';
        Valid := False;
        exit;
      end;

  Valid := True;
end;

{ TIntObject }

constructor TIntObject.Create(pValue: integer);
begin
  inherited Create;

  Value := pValue;
end;

end.

