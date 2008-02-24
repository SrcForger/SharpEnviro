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

unit uSharpBarListEditWnd;

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
  JvLabel,
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
  JvSimpleXml,
  SharpApi,
  JclStrings,
  SharpCenterApi,
  SharpEListBoxEx,
  uSharpBarListWnd;

type
  TfrmEditItem = class(TForm)
    vals: TJvValidators;
    errorinc: TJvErrorIndicator;
    pilError: TPngImageList;
    valBarName: TJvCustomValidator;
    edName: TLabeledEdit;
    cobo_monitor: TComboBox;
    cbBasedOn: TComboBox;
    cobo_valign: TComboBox;
    cobo_halign: TComboBox;
    JvLabel3: TLabel;
    JvLabel2: TLabel;
    JvLabel1: TLabel;
    Label3: TLabel;
    pnlBarSpace: TPanel;
    Label1: TLabel;
    JvLabel4: TJvLabel;
    procedure valBarNameValidate(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
    procedure cbBasedOnSelect(Sender: TObject);

    procedure edThemeNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FBarItem: TBarItem;
    FEditMode: TSCE_EDITMODE_ENUM;
    FUpdating: Boolean;
    { Private declarations }
  public
    { Public declarations }
    procedure BuildMonList;
    procedure ClearMonList;
    function ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
    procedure ClearValidation;

    property BarItem: TBarItem read FBarItem write FBarItem;
    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
    function InitUi(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
    function SaveUi(AApply: Boolean; AEditMode: TSCE_EDITMODE_ENUM): Boolean;
  end;

type
  TIntObject = class
    Value: Integer;
    constructor Create(pValue: integer);
  end;

var
  frmEditItem: TfrmEditItem;

implementation

{$R *.dfm}

function TfrmEditItem.InitUi(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
var
  tmpItem: TSharpEListItem;
  tmpBar: TBarItem;
  n: integer;
  BarItem: TBarItem;
begin
  Result := False;


  FUpdating := True;
  Try

  case AEditMode of
    sceAdd: begin

          if Not(frmBarList.BarSpaceCheck) then begin
    pnlBarSpace.Show;
    Exit;
  end;
        
          pnlBarSpace.Hide;
          FrmEditItem.edName.Text := '';

          frmEditItem.cbBasedOn.Items.Clear;
          frmEditItem.cbBasedOn.Items.AddObject('New Bar', nil);

          // Build list
          for n := 0 to frmBarList.lbBarList.Count - 1 do begin
            tmpBar := TBarItem(frmBarList.lbBarList.Item[n].Data);
            frmEditItem.cbBasedOn.Items.AddObject(tmpBar.Name, tmpBar);
          end;

          frmEditItem.cbBasedOn.ItemIndex := 0;
          frmEditItem.cbBasedOn.Enabled := True;
          frmEditItem.BarItem := nil;

          frmEditItem.BuildMonList;
          frmEditItem.cobo_monitor.ItemIndex := 0;
          frmEditItem.edName.SetFocus;

        Result := True;
      end;
    sceEdit: begin
        if frmBarList.lbBarList.ItemIndex <> -1 then begin

          pnlBarSpace.Hide;
          tmpItem := frmBarList.lbBarList.SelectedItem;
          BarItem := TBarItem(tmpItem.Data);

          FrmEditItem.edName.Text := BarItem.Name;
          FrmEditItem.edName.SetFocus;

          if frmEditItem.BarItem = nil then
            frmEditItem.BarItem := TBarItem.Create;

          frmEditItem.BarItem.Name := BarItem.Name;
          frmEditItem.BarItem.BarID := BarItem.BarID;
          frmEditItem.BarItem.Monitor := BarItem.Monitor;
          frmEditItem.BarItem.PMonitor := BarItem.PMonitor;
          frmEditItem.BarItem.HPos := BarItem.HPos;
          frmEditItem.BarItem.VPos := BarItem.VPos;
          frmEditItem.BarItem.AutoStart := BarItem.AutoStart;

          frmEditItem.BuildMonList;
          if BarItem.PMonitor then
            frmEditItem.cobo_monitor.ItemIndex := 0
          else
            frmEditItem.cobo_monitor.ItemIndex := Min(abs(BarItem.Monitor), frmEditItem.cobo_monitor.Items.Count - 1);
          frmEditItem.cobo_valign.ItemIndex := BarItem.VPos;
          frmEditItem.cobo_halign.ItemIndex := BarItem.HPos;

          frmEditItem.cbBasedOn.Items.Clear;
          frmEditItem.cbBasedOn.Items.AddObject('Not Applicable', nil);
          frmEditItem.cbBasedOn.ItemIndex := 0;
          frmEditItem.cbBasedOn.Enabled := False;

          Result := True;
        end;
      end;
  end;
  Finally
    FUpdating := False;
  End;
end;

function TfrmEditItem.SaveUi(AApply: Boolean; AEditMode: TSCE_EDITMODE_ENUM): Boolean;
var
  XML: TJvSimpleXML;
  Dir: string;
  NewID: string;
  CID: integer;
  n: integer;
  wnd: hwnd;
  sr: TSearchRec;
  fileloaded: boolean;
begin
  Result := True;
  if Not(AApply) then exit;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';
  CID := 0;

  case AEditMode of
    sceAdd: begin
        // Generate a new unique bar ID and make sure that there is no other
        // bar with the same ID
        repeat
          NewID := '';
          for n := 1 to 8 do
            NewID := NewID + inttostr(random(9) + 1);
        until not DirectoryExists(Dir + NewID);

        if FrmEditItem.cbBasedOn.ItemIndex > 0 then begin
          CID := TBarItem(FrmEditItem.cbBasedOn.Items.Objects[FrmEditItem.cbBasedOn.ItemIndex]).BarID;

          if FindFirst(Dir + inttostr(CID) + '\*.xml', FAAnyFile, sr) = 0 then
            repeat
              if FileExists(Dir + inttostr(CID) + '\' + sr.Name) then
                CopyFile(PChar(Dir + inttostr(CID) + '\' + sr.Name),
                  PChar(Dir + NewID + '\' + sr.Name), True);
            until FindNext(sr) <> 0;
          FindClose(sr);
        end;

        XML := TJvSimpleXML.Create(nil);
        if FileCheck(Dir + NewID + '\Bar.xml',True) then begin
          try
            XML.LoadFromFile(Dir + NewID + '\Bar.xml');
            fileloaded := True;
          except
            fileloaded := False;
          end;
        end
        else
          fileloaded := False;

        if not fileloaded then
          XML.Root.Name := 'SharpBar';

        with XML.Root.Items do begin
          if ItemNamed['Settings'] = nil then
            Add('Settings');

          with ItemNamed['Settings'].Items do begin
            clear;
            Add('ID', NewID);
            Add('Name', FrmEditItem.edName.Text);
            Add('ShowThrobber', True);
            Add('DisableHideBar', False);
            Add('AutoStart', True);
            Add('AutoPosition', True);
            Add('PrimaryMonitor', (FrmEditItem.cobo_monitor.ItemIndex = 0));
            Add('MonitorIndex', TIntObject(FrmEditItem.cobo_monitor.Items.Objects[FrmEditItem.cobo_monitor.ItemIndex]).Value);
            Add('HorizPos', FrmEditItem.cobo_halign.ItemIndex);
            Add('VertPos', FrmEditItem.cobo_valign.ItemIndex);
          end;

          if ItemNamed['Modules'] = nil then
            Add('Modules');
        end;
        ForceDirectories(Dir + NewID);
        if FileCheck(Dir + NewID + '\Bar.xml') then
          XML.SaveToFile(Dir + NewID + '\Bar.xml');
        XML.Free;
      end;
    sceEdit: begin
        CID := TBarItem(frmEditItem.BarItem).BarID;
        XML := TJvSimpleXML.Create(nil);
        fileloaded := False;
        if FileCheck(Dir + inttostr(CID) + '\Bar.xml',True) then begin
          try
            XML.LoadFromFile(Dir + inttostr(CID) + '\Bar.xml');
            fileloaded := True;
          except
          end;
        end;
        if FileLoaded then
          with XML.Root.Items do begin
            if ItemNamed['Settings'] = nil then
              Add('Settings');

            with ItemNamed['Settings'].Items do begin
              Clear;
              Add('ID', NewID);
              Add('Name', FrmEditItem.edName.Text);
              Add('ShowThrobber', True);
              Add('DisableHideBar', False);
              Add('AutoStart', True);
              Add('AutoPosition', True);
              Add('PrimaryMonitor', (FrmEditItem.cobo_monitor.ItemIndex = 0));
              Add('MonitorIndex', TIntObject(FrmEditItem.cobo_monitor.Items.Objects[FrmEditItem.cobo_monitor.ItemIndex]).Value);
              Add('HorizPos', FrmEditItem.cobo_halign.ItemIndex);
              Add('VertPos', FrmEditItem.cobo_valign.ItemIndex);
            end;
          end;
        if FileCheck(Dir + inttostr(CID) + '\Bar.xml') then
          XML.SaveToFile(Dir + inttostr(CID) + '\Bar.xml');
        XML.Free;
      end;
  end;

  if AEditMode = sceAdd then
    SharpApi.SharpExecute('_nohist,' + SharpApi.GetSharpeDirectory + 'SharpBar.exe' +
      ' -load:' + NewID +
      ' -noREB' +
      ' -noLASB')
  else if AEditMode = sceEdit then begin
    wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(CID)));
    if wnd <> 0 then
      SendMessage(wnd, WM_BARREPOSITION, 0, 0);
  end;

  frmBarList.tmrUpdate.Enabled := True;
end;

procedure TfrmEditItem.BuildMonList;
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

procedure TfrmEditItem.edThemeNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Not(FUpdating) then
    CenterDefineEditState(True);
end;

procedure TfrmEditItem.FormCreate(Sender: TObject);
begin
  BarItem := TBarItem.Create;
end;

procedure TfrmEditItem.FormDestroy(Sender: TObject);
begin
  ClearMonList;
end;

function TfrmEditItem.ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
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

procedure TfrmEditItem.cbBasedOnSelect(Sender: TObject);
begin
  if Not(FUpdating) then
    CenterDefineEditState(True);
end;

procedure TfrmEditItem.ClearMonList;
var
  n: integer;
begin
  for n := 0 to cobo_monitor.Items.Count - 1 do
    TIntObject(cobo_monitor.Items.Objects[n]).Free;
  cobo_monitor.Items.Clear;
end;

procedure TfrmEditItem.ClearValidation;
begin
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TfrmEditItem.valBarNameValidate(Sender: TObject;
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

  for n := 0 to frmBarList.lbBarList.Count - 1 do
    if BarItem <> TBarItem(frmBarList.lbBarList.Item[n].Data) then
      if CompareText(frmBarList.lbBarList.Item[n].SubItemText[1], ValueToValidate) = 0 then begin
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

