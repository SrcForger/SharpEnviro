{
Source Name: SharpBarBarList
Description: SharpBar Manager Config Window
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

unit uModuleManagerListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, uSEListboxPainter, JclFileUtils, Math,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx, GR32, GR32_PNG, SharpApi, SharpCenterApi,
  ExtCtrls, Menus, Contnrs, Types, JclStrings, SharpERoundPanel, SharpThemeApi;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TModuleItem = class
    Name: string;
    Configure: Boolean;
    MFile: string;
    ID: integer;
    Position: Integer;
  private

  end;

  TfrmMMList = class(TForm)
    StatusImages: TPngImageList;
    pnlRight: TSharpERoundPanel;
    lbModulesRight: TSharpEListBoxEx;
    lblRight: TLabel;
    pnlLeft: TSharpERoundPanel;
    lblLeft: TLabel;
    lbModulesLeft: TSharpEListBoxEx;
    procedure FormCreate(Sender: TObject);
    procedure lbModulesGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);

    procedure lbModulesClickItem(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure lbModulesGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);

    procedure lbModulesGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
  private
    FWinHandle: Thandle;
    FModuleList: TObjectList;
    procedure AddItemsToList;
    procedure WndProc(var msg: TMessage);

  public
    BarID: integer;
    procedure BuildModuleList;
    function UpdateUI: Boolean;
    function SaveUi: Boolean;
    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
  end;

var
  frmMMList: TfrmMMList;

const
  colName = 0;
  colMoveUp = 1;
  colMoveDown = 2;
  colDelete = 4;
  colEdit = 3;

  iidxMoveUp = 1;
  iidxMoveDown = 2;
  iidxDelete = 3;

implementation

uses uModuleManagerListEdit;

{$R *.dfm}

{ TfrmConfigListWnd }

function PointInRect(P: TPoint; Rect: TRect): boolean;
begin
  if (P.X >= Rect.Left) and (P.X <= Rect.Right)
    and (P.Y >= Rect.Top) and (P.Y <= Rect.Bottom) then
    PointInRect := True
  else
    PointInRect := False;
end;

procedure TfrmMMList.lbModulesClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpModule: TModuleItem;
  wnd: THandle;
  s: string;
  cFile: string;
begin
  if Sender = lbModulesLeft then
    lbModulesRight.ItemIndex := -1
  else
    lbModulesLeft.ItemIndex := -1;

  tmpModule := TModuleItem(AItem.Data);
  if tmpModule = nil then
    exit;

  wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(BarID)));
  if wnd = 0 then
    exit;

  case ACol of
    colDelete: SendMessage(wnd, WM_BARCOMMAND, BC_DELETE, tmpModule.ID);
    colMoveUp: if AItem.SubItemImageIndex[ACol] <> -1 then
        SendMessage(wnd, WM_BARCOMMAND, BC_MOVEUP, tmpModule.ID);
    colMoveDown: if AItem.SubItemImageIndex[ACol] <> -1 then
        SendMessage(wnd, WM_BARCOMMAND, BC_MOVEDOWN, tmpModule.ID);
    colEdit: begin

        if AItem.SubItemText[ACol] <> '' then begin
          s := tmpModule.MFile;
          setlength(s, length(s) - length(ExtractFileExt(s)));
          cfile := SharpApi.GetCenterDirectory + '_Modules\' + s + '.con';

          if FileExists(cfile) then
            SharpCenterApi.CenterCommand(sccLoadSetting,
              PChar(cfile),
              PChar(inttostr(BarID) + ':' + inttostr(tmpModule.ID)))
        end;
      end;
  end;
  BuildModuleList;
end;

procedure TfrmMMList.lbModulesGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmpModule: TModuleItem;
  wnd: THandle;
begin
  tmpModule := TModuleItem(AItem.Data);
  if tmpModule = nil then
    exit;

  case ACol of
    colMoveUp, colMoveDown, colDelete: if AItem.SubItemImageIndex[ACol] <> -1 then
        ACursor := crHandPoint;
    colEdit: if AItem.SubItemText[ACol] <> '' then
        ACursor := crHandPoint;
  end;

end;

procedure TfrmMMList.lbModulesGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
begin
  case ACol of
    colMoveUp: begin
        if Sender = lbModulesLeft then begin
          if AItem.ID = 0 then
            AImageIndex := -1
          else
            AImageIndex := iidxMoveUp;
        end
        else begin
          AImageIndex := iidxMoveUp;
        end;
      end;
    colDelete: AImageIndex := iidxDelete;
    colMoveDown: begin
        if Sender = lbModulesLeft then begin
          AImageIndex := iidxMoveDown;
        end
        else begin
          if AItem.ID = Pred(lbModulesRight.Count) then
            AImageIndex := -1
          else
            AImageIndex := iidxMoveDown;
        end;
      end;
  end;
end;

procedure TfrmMMList.lbModulesGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpModule: TModuleItem;
begin
  tmpModule := TModuleItem(AItem.Data);
  if tmpModule = nil then
    exit;

  case ACol of
    colEdit: begin
        if tmpModule.Configure then
          AColText := '<font color="clNavy"><u>Edit</u>'
        else
          AColText := '';
      end;
  end;
end;

procedure TfrmMMList.FormCreate(Sender: TObject);
begin
  FWinHandle := AllocateHWND(WndProc);
  FModuleList := TObjectList.Create;
  Self.DoubleBuffered := true;

  CenterDefineButtonState(scbEditTab, False);
end;

procedure TfrmMMList.FormDestroy(Sender: TObject);
var
  n: integer;
begin

  {for n := 0 to lbModuleList.Count - 1 do
    if Assigned(lbModuleList.Item[n].Data) then
    begin
      TModuleItem(lbModuleList.Item[n].Data).Free;
      lbModuleList.Item[n].Data := nil;
    end;
  lbModuleList.Clear; }

  DeallocateHWnd(FWinHandle);
  FModuleList.Free;
end;

procedure TfrmMMList.FormResize(Sender: TObject);
begin
  Self.Height := pnlRight.Height + pnlLeft.Height + 10;
end;

procedure TfrmMMList.FormShow(Sender: TObject);
begin
  lblRight.Font.Style := [fsBold];
  lblLeft.Font.Style := [fsBold];
end;

procedure TfrmMMList.BuildModuleList;
var
  i: Integer;
  n: Integer;
  tmpModule: TModuleItem;
  newItem: TSharpEListItem;
begin
  // Get selected item
  LockWindowUpdate(Self.Handle);
  try

    n := -1;
    if lbModulesLeft.SelectedItem <> nil then
      n := TModuleItem(lbModulesLeft.SelectedItem.Data).ID
    else if lbModulesRight.SelectedItem <> nil then
      n := TModuleItem(lbModulesRight.SelectedItem.Data).ID;

    lbModulesLeft.Clear;
    lbModulesRight.Clear;
    AddItemsToList;

    for i := 0 to FModuleList.Count - 1 do begin

      tmpModule := TModuleItem(FModuleList.Items[i]);

      if tmpModule.Position = -1 then
        newItem := lbModulesLeft.AddItem(tmpModule.Name)
      else if tmpModule.Position = 1 then
        newItem := lbModulesRight.AddItem(tmpModule.Name);

      newItem.Data := tmpModule;
      newItem.AddSubItem('', -1);
      newItem.AddSubItem('', -1);
      newItem.AddSubItem('', -1);
      newItem.AddSubItem('', -1);

    end;

    if n <> -1 then begin
      for i := 0 to Pred(lbModulesLeft.Count) do begin
        tmpModule := TModuleItem(lbModulesLeft.Item[i].Data);
        if tmpModule.ID = n then begin
          lbModulesLeft.ItemIndex := i;
          exit;
        end;
      end;
      for i := 0 to Pred(lbModulesRight.Count) do begin
        tmpModule := TModuleItem(lbModulesRight.Item[i].Data);
        if tmpModule.ID = n then begin
          lbModulesRight.ItemIndex := i;
          exit;
        end;
      end;
    end;

  finally

    LockWindowUpdate(0);
    Self.Height := pnlRight.Height + pnlLeft.Height + 10;
  end;

end;

function TfrmMMList.UpdateUI: Boolean;
begin
  Result := False;
  CenterDefineButtonState(scbDeleteTab, False);

  case FEditMode of
    sceAdd: begin
        if frmMMEdit <> nil then begin
          frmMMEdit.pagEdit.Show;
          Result := True;
        end;
      end;
  end;
end;

procedure TfrmMMList.WndProc(var msg: TMessage);
begin
  if ((msg.Msg = WM_SHARPEUPDATESETTINGS) and (msg.WParam = integer(suCenter))) then begin
    BuildModuleList;
    CenterUpdateSize;
  end;
end;

function TfrmMMList.SaveUi: Boolean;
var
  Dir: string;
  ModuleItem: TModuleItem;
  wnd: hwnd;
  msg: TSharpE_DataStruct;
  cds: TCopyDataStruct;
begin
  Result := True;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  case FEditMode of
    sceAdd: begin
        wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(BarID)));
        if wnd <> 0 then begin
          msg.Module := frmMMEdit.cobo_modules.Text + '.dll';
          msg.LParam := BC_ADD;
          if frmMMEDit.cobo_position.ItemIndex = 0 then
            msg.RParam := -1
          else
            msg.RParam := 1;
          with cds do begin
            dwData := 0;
            cbData := SizeOf(TSharpE_DataStruct);
            lpData := @msg;
          end;
        end;
        if sendmessage(wnd, WM_COPYDATA, WM_BARCOMMAND, Cardinal(@cds)) = BCR_SUCCESS then begin
          BuildModuleList;
        end;
      end;
  end;
end;

procedure TfrmMMList.AddItemsToList;
var
  xml: TJvSimpleXML;
  newItem: TModuleItem;
  dir: string;
  slBars: TStringList;
  i, j, n, index: Integer;

  function ExtractBarID(ABarXmlFileName: string): Integer;
  var
    s: string;
    n: Integer;
  begin
    s := PathRemoveSeparator(ExtractFilePath(ABarXmlFileName));
    n := JclStrings.StrLastPos('\', s);
    s := Copy(s, n + 1, length(s));
    result := StrToInt(s);

  end;

begin
  FModuleList.Clear;
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  slBars := TStringList.Create;
  xml := TJvSimpleXML.Create(nil);
  try

    // build list of bar.xml files
    AdvBuildFileList(dir + '*bar.xml', faAnyFile, slBars, amAny, [flFullNames, flRecursive]);
    for i := 0 to Pred(slBars.Count) do begin

      n := ExtractBarID(slBars[i]);
      if n = BarID then begin
        xml.LoadFromFile(slBars[i]);
        if xml.Root.Items.ItemNamed['Modules'] <> nil then begin
          with xml.Root.Items.ItemNamed['Modules'].Items do begin
            for j := 0 to Pred(Count) do begin
              newItem := TModuleItem.Create;
              with newItem do begin
                MFile := Item[j].Items.Value('Module', '');
                Name := PathRemoveExtension(MFile);
                ID := Item[j].Items.IntValue('ID', -1);
                Position := Item[j].Items.IntValue('Position', -1);

                newItem.Configure := False;
                if FileExists(SharpApi.GetCenterDirectory + '_Modules\' + newItem.Name + '.con') then
                  newItem.Configure := True;
              end;
              FModuleList.Add(newItem);
            end;
          end;
        end;
      end;
    end;

  finally
    slBars.Free;
    xml.Free;
  end;
end;

end.

