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
    procedure lbModulesLeftGetCellCursor(const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbModuleListGetCellFont(const ACol: Integer; AItem: TSharpEListItem;
      var AFont: TFont);
    procedure lbModuleListGetCellTextColor(const ACol: Integer;
      AItem: TSharpEListItem; var AColor: TColor);
    procedure lbModulesLeftClickItem(const ACol: Integer; AItem: TSharpEListItem);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbModulesRightClickItem(const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbModulesRightGetCellCursor(const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure FormShow(Sender: TObject);
    procedure lbModulesRightGetCellImageIndex(const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbModulesLeftGetCellImageIndex(const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbModulesRightGetCellText(const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
  private
    FWinHandle: Thandle;
    FModuleList: TObjectList;
    procedure AddItemsToList;
    procedure WndProc(var msg: TMessage);
    procedure CenterMessage(var Msg: TMessage);
  public
    BarID: integer;
    procedure BuildModuleList;
    procedure BuildModuleList2;
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
  colEdit = 3;

  iidxMoveUp = 1;
  iidxMoveDown = 2;

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

procedure TfrmMMList.lbModulesLeftClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpModule: TModuleItem;
  wnd: THandle;
begin
  lbModulesRight.ItemIndex := -1;

  tmpModule := TModuleItem(AItem.Data);
  if tmpModule = nil then exit;

  wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(BarID)));
  if wnd = 0 then
    exit;

  case ACol of
    colMoveUp: SendMessage(wnd, WM_BARCOMMAND, BC_MOVEUP, tmpModule.ID);
    colMoveDown: SendMessage(wnd, WM_BARCOMMAND, BC_MOVEDOWN, tmpModule.ID);
  end;

  {if frmMMEdit <> nil then begin
    UpdateUI;
    exit;
  end;

  index := -1;
  ModuleItem := TModuleItem(AItem.Data);
  for n := 0 to lbModuleList.Count - 1 do
    if lbModuleList.Item[n] = AItem then begin
      index := n;
      break;
    end;

  if index = -1 then
    exit;

  wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(BarID)));
  if wnd = 0 then
    exit;

  if (ACol = 4) then begin
    if (CompareText(AItem.SubItemText[4], '<font color="clNavy"><u>Configure') = 0) then begin
      s := ModuleItem.MFile;
      setlength(s, length(s) - length(ExtractFileExt(s)));
      cfile := SharpApi.GetCenterDirectory + '_Modules\' + s + '.con';

      if FileExists(cfile) then
        SharpCenterApi.CenterCommand(sccLoadSetting,
          PChar(cfile),
          PChar(inttostr(BarID) + ':' + inttostr(ModuleItem.ID)))
    end;
  end;

  // Start / Stop / Disable / Enable clicked
  if (ACol = 2) or (ACol = 3) then begin
    if ((CompareText(AItem.SubItemText[2], '<font color="clNavy"><u>Move Up') = 0)) and (ACol = 2) then begin
      // Move Up
      if SendMessage(wnd, WM_BARCOMMAND, BC_MOVEUP, ModuleItem.ID) = BCR_SUCCESS then begin
        if lbModuleList.Item[max(0, index - 1)].Data = nil then
          lbModuleList.Item[index].SubItemImageIndex[0] := 0;
        lbModuleList.Items.Exchange(index, max(0, index - 1));
      end;
    end
    else if ((CompareText(AItem.SubItemText[3], '<font color="clNavy"><u>Move Down') = 0)) and (ACol = 3) then begin
      // Move Down
      if SendMessage(wnd, WM_BARCOMMAND, BC_MOVEDOWN, ModuleItem.ID) = BCR_SUCCESS then begin
        if lbModuleList.Item[min(lbModuleList.Count - 1, index + 1)].Data = nil then
          lbModuleList.Item[index].SubItemImageIndex[0] := 1;
        lbModuleList.Items.Exchange(index, min(lbModuleList.Count - 1, index + 1));
      end;
    end;
  end;  }
end;

procedure TfrmMMList.lbModulesLeftGetCellCursor(const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if (ACol = 2) or (ACol = 3) or (ACol = 4) then
    ACursor := crHandPoint;
end;

procedure TfrmMMList.lbModulesLeftGetCellImageIndex(const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
begin
  case ACol of
    colMoveUp: begin
      if AItem.ID = 0 then
      AImageIndex := -1 else
      AImageIndex := iidxMoveUp;
    end;
    colMoveDown : begin
      AImageIndex := iidxMoveDown;
    end;
  end;
end;

procedure TfrmMMList.lbModulesRightClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpModule: TModuleItem;
  wnd: THandle;
begin
  lbModulesLeft.ItemIndex := -1;

  tmpModule := TModuleItem(AItem.Data);
  if tmpModule = nil then exit;

  wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(BarID)));
  if wnd = 0 then
    exit;

  case ACol of
    colMoveUp: SendMessage(wnd, WM_BARCOMMAND, BC_MOVEUP, tmpModule.ID);
    colMoveDown: SendMessage(wnd, WM_BARCOMMAND, BC_MOVEDOWN, tmpModule.ID);
  end;
end;

procedure TfrmMMList.lbModulesRightGetCellCursor(const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  //
end;

procedure TfrmMMList.lbModulesRightGetCellImageIndex(const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
begin
  case ACol of
    colMoveUp: begin
      AImageIndex := iidxMoveUp;
    end;
    colMoveDown : begin
      if AItem.ID = Pred(lbModulesRight.Count) then
        AImageIndex := -1 else
        AImageIndex := iidxMoveDown;
    end;
  end;
end;

procedure TfrmMMList.lbModulesRightGetCellText(const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpModule: TModuleItem;
begin
  tmpModule := TModuleItem(AItem.Data);
  if tmpModule = nil then exit;

  case ACol of
    colEdit: begin
      if tmpModule.Configure then
      AColText := '<font color="clNavy"><u>Edit</u>' else
      AColText := '';
    end;
  end;
end;

procedure TfrmMMList.lbModuleListGetCellFont(const ACol: Integer;
  AItem: TSharpEListItem; var AFont: TFont);
begin
  if (ACol = 2) or (ACol = 3) or (ACol = 4) then
    AFont.Style := [fsUnderline];
end;

procedure TfrmMMList.lbModuleListGetCellTextColor(const ACol: Integer;
  AItem: TSharpEListItem; var AColor: TColor);
begin
  if (ACol = 2) or (ACol = 3) or (ACol = 4) then begin
    if frmMMEdit = nil then
      AColor := clNavy
    else
      AColor := clGray;
  end;
end;

procedure TfrmMMList.FormCreate(Sender: TObject);
begin
  FWinHandle := AllocateHWND(WndProc);
  FModuleList := TObjectList.Create;
  BuildModuleList;
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
  Self.Height := pnlRight.Height+pnlLeft.Height+10;
end;

procedure TfrmMMList.FormShow(Sender: TObject);
begin
  lblRight.Font.Style := [fsBold];
  lblLeft.Font.Style := [fsBold];
end;

procedure TfrmMMList.BuildModuleList;
{var
  n: Integer;
  newItem:TSharpEListItem;
  XML : TJvSimpleXML;
  Dir : String;
  ModuleItem : TModuleItem;
  sr : TSearchRec;
  fileloaded : boolean;
  index,oindex : integer;
  s : String;  }
begin
  BuildModuleList2;
  {for n := 0 to lbModuleList.Count - 1 do
    if Assigned(lbModuleList.Item[n].Data) then
    begin
      TModuleItem(lbModuleList.Item[n].Data).Free;
      lbModuleList.Item[n].Data := nil;
    end;
  lbModuleList.Clear;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(BarID) + '\';

  oindex := 0;
  XML := TJvSimpleXML.Create(nil);
  if FileExists(Dir + '\Bar.xml') then
  begin
    try
      xml.LoadFromFile(Dir + sr.Name + '\Bar.xml');
      fileloaded := True;
    except
      fileloaded := False;
    end;
    if fileloaded then
    begin
     if XML.Root.Items.ItemNamed['Modules'] <> nil then
       with XML.Root.Items.ItemNamed['Modules'].Items do
         for n := 0 to Count - 1 do
           with Item[n].Items do
           begin
             ModuleItem := TModuleItem.Create;
             with ModuleItem do
             begin
               MFile := Value('Module','');
               ID    := IntValue('ID',-1);

               s := MFile;
               setlength(s,length(s) - length(ExtractFileExt(s)));

               index := IntValue('Position',-1);
               if index < 0 then
                 index := 0
               else index := 1;
               if oindex <> index then
               begin
                 newItem := lbModuleList.AddItem('',-1);
                 newItem.AddSubItem('');
                 newItem.AddSubItem('');
                 newItem.AddSubItem('');
                 newItem.AddSubItem('');
                 newItem.Data := nil;
                 oindex := index;
               end;
               newItem := lbModuleList.AddItem('',index);
               newItem.Data := ModuleItem;
               newItem.AddSubItem(s);
               newItem.AddSubItem('<font color="clNavy"><u>Move Up');
               newItem.AddSubItem('<font color="clNavy"><u>Move Down');

               if FileExists(SharpApi.GetCenterDirectory + '_Modules\' + s + '.con') then
                 newItem.AddSubItem('<font color="clNavy"><u>Configure')
               else newItem.AddSubItem('');

               newItem.SubItemImageIndex[0] := index;
             end;
           end;
    end;
  end;
  XML.free;

  if oindex = 0 then
  begin
    newItem := lbModuleList.AddItem('',-1);
    newItem.AddSubItem('');
    newItem.AddSubItem('');
    newItem.AddSubItem('');
    newItem.AddSubItem('');
    newItem.Data := nil;
  end;

  if lbModuleList.Items.Count = 0 then
  begin
    CenterDefineButtonState(scbDeleteTab,False);
  end else
  begin
    if lbModuleList.ItemIndex = - 1 then
      lbModuleList.ItemIndex := 0;
    CenterDefineButtonState(scbDeleteTab,True);
  end;   }
end;

procedure TfrmMMList.BuildModuleList2;
var
  selectedIndex, i: Integer;
  tmpModule: TModuleItem;
  newItem: TSharpEListItem;
begin
  // Get selected item
  LockWindowUpdate(Self.Handle);
  try

  lbModulesLeft.Clear;
  lbModulesRight.Clear;
  AddItemsToList;

  for i := 0 to FModuleList.Count - 1 do begin

    tmpModule := TModuleItem(FModuleList.Items[i]);

    if tmpModule.Position = -1 then
      newItem := lbModulesLeft.AddItem(tmpModule.Name) else
    if tmpModule.Position = 1 then
      newItem := lbModulesRight.AddItem(tmpModule.Name);

    newItem.Data := tmpModule;
    newItem.AddSubItem('',1);
    newItem.AddSubItem('',2);
    newItem.AddSubItem('<font color="clNavy" /><u>Edit</u>');

  end;
  finally
    LockWindowUpdate(0);
    Self.Height := pnlRight.Height+pnlLeft.Height+10;
  end;

end;

procedure TfrmMMList.CenterMessage(var Msg: TMessage);
begin
  ShowMessage('test');
end;

function TfrmMMList.UpdateUI: Boolean;
begin
  Result := False;
  case FEditMode of
    sceAdd: begin
        frmMMEdit.pagEdit.Show;
        Result := True;
      end;
    sceDelete: begin
        if ((lbModulesLeft.ItemIndex <> -1) or (lbModulesRight.ItemIndex <> -1)) then begin
          Result := True;
          frmMMEDit.pagDelete.Show;
          CenterDefineButtonState(scbDelete, True);
        end
        else begin
          Result := False;
          CenterDefineButtonState(scbDelete, False);
        end;
      end;
  end;
end;

procedure TfrmMMList.WndProc(var msg: TMessage);
begin
  if ((msg.Msg = WM_SHARPEUPDATESETTINGS) and (msg.WParam = integer(suCenter)))  then begin
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

  {case FEditMode of
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
    sceDelete: begin
        if assigned(lbModuleList.Item[lbModuleList.ItemIndex].Data) then begin
          ModuleItem := TModuleItem(lbModuleList.Item[lbModuleList.ItemIndex].Data);
          wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(BarID)));
          if wnd <> 0 then
            if SendMessage(wnd, WM_BARCOMMAND, BC_DELETE, ModuleItem.ID) = BCR_SUCCESS then begin
              lbModuleList.Items.Delete(lbModuleList.ItemIndex);
              ModuleItem.Free;
            end;
        end;
      end;
  end;  }
end;

procedure TfrmMMList.AddItemsToList;
var
  xml: TJvSimpleXML;
  newItem: TModuleItem;
  dir: string;
  slBars: TStringList;
  i, j, index: Integer;

begin
  FModuleList.Clear;
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  slBars := TStringList.Create;
  xml := TJvSimpleXML.Create(nil);
  try

    // build list of bar.xml files
    AdvBuildFileList(dir + '*bar.xml', faAnyFile, slBars, amAny, [flFullNames, flRecursive]);
    for i := 0 to Pred(slBars.Count) do begin
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

  finally
    slBars.Free;
    xml.Free;
  end;
end;

end.

