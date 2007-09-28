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
  SharpEListBox, SharpEListBoxEx,GR32, GR32_PNG, SharpApi, SharpCenterApi,
  ExtCtrls, Menus, Contnrs, Types;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TModuleItem = class
                  MFile : String;
                  ID : integer;
                end;

  TfrmMMList = class(TForm)
    StatusImages: TPngImageList;
    lbModuleList: TSharpEListBoxEx;
    pilDefault: TPngImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbModuleListGetCellCursor(const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbModuleListGetCellFont(const ACol: Integer; AItem: TSharpEListItem;
      var AFont: TFont);
    procedure lbModuleListGetCellTextColor(const ACol: Integer;
      AItem: TSharpEListItem; var AColor: TColor);
    procedure lbModuleListClickItem(const ACol: Integer; AItem: TSharpEListItem);
    procedure FormDestroy(Sender: TObject);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
  private

  public
    BarID : integer;
    procedure BuildModuleList;
    function UpdateUI:Boolean;
    function SaveUi: Boolean;
    Property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
  end;

var
  frmMMList: TfrmMMList;

implementation

uses uModuleManagerListEdit, SharpThemeApi;

{$R *.dfm}

{ TfrmConfigListWnd }

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TfrmMMList.FormShow(Sender: TObject);
begin
  BuildModuleList;
end;

procedure TfrmMMList.lbModuleListClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
var
  ModuleItem : TModuleItem;
  wnd : hwnd;
  index : integer;
  n : integer;
  cfile : String;
  s : String;
begin
  if frmMMEdit <> nil then
  begin
    UpdateUI;
    exit;
  end;

  index := -1;
  ModuleItem := TModuleItem(AItem.Data);
  for n := 0 to lbModuleList.Count - 1 do
    if lbModuleList.Item[n] = AItem then
    begin
      index := n;
      break;
    end;

  if index = -1 then
    exit;

  wnd := FindWindow(nil,PChar('SharpBar_'+inttostr(BarID)));
  if wnd = 0 then
    exit;
    
  if (ACol = 4 ) then
  begin
    if (CompareText(AItem.SubItemText[4],'Configure') = 0) then
    begin
      s := ModuleItem.MFile;
      setlength(s,length(s) - length(ExtractFileExt(s)));
      cfile := SharpApi.GetCenterDirectory + '_Modules\' + s + '.con';

      if FileExists(cfile) then
        SharpCenterApi.CenterCommand(sccLoadSetting,
                                     PChar(cfile),
                                     PChar(inttostr(BarID) + ':' +inttostr(ModuleItem.ID)))
    end;
  end;

  // Start / Stop / Disable / Enable clicked
  if (ACol = 2) or (ACol = 3) then
  begin
    if ((CompareText(AItem.SubItemText[2],'Move Up') = 0)) and (ACol = 2) then
    begin
      // Move Up
      if SendMessage(wnd,WM_BARCOMMAND,BC_MOVEUP,ModuleItem.ID) = BCR_SUCCESS then
      begin
        if lbModuleList.Item[max(0,index-1)].Data = nil  then
          lbModuleList.Item[index].SubItemImageIndex[0] := 0;
        lbModuleList.Items.Exchange(index,max(0,index-1));
      end;
    end
    else if ((CompareText(AItem.SubItemText[3],'Move Down') = 0)) and (ACol = 3) then
    begin
      // Move Down
      if SendMessage(wnd,WM_BARCOMMAND,BC_MOVEDOWN,ModuleItem.ID) = BCR_SUCCESS then
      begin
        if lbModuleList.Item[min(lbModuleList.Count - 1,index+1)].Data = nil  then
          lbModuleList.Item[index].SubItemImageIndex[0] := 1;
        lbModuleList.Items.Exchange(index,min(lbModuleList.Count - 1,index+1));
      end;
    end;
  end;
end;

procedure TfrmMMList.lbModuleListGetCellCursor(const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if (ACol = 2) or (ACol = 3) or (ACol = 4) then
    ACursor := crHandPoint;
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
  if (ACol = 2) or (ACol = 3) or (ACol = 4) then
  begin
    if frmMMEdit = nil then
      AColor := clNavy
    else AColor := clGray;
  end;
end;

procedure TfrmMMList.FormCreate(Sender: TObject);
begin
  BuildModuleList;
  Self.DoubleBuffered := true;

    CenterDefineButtonState(scbEditTab,False);  
end;

procedure TfrmMMList.FormDestroy(Sender: TObject);
var
  n : integer;
begin
  for n := 0 to lbModuleList.Count - 1 do
    if Assigned(lbModuleList.Item[n].Data) then
    begin
      TModuleItem(lbModuleList.Item[n].Data).Free;
      lbModuleList.Item[n].Data := nil;
    end;
  lbModuleList.Clear;
end;

procedure TfrmMMList.BuildModuleList;
var
  n: Integer;
  newItem:TSharpEListItem;
  XML : TJvSimpleXML;
  Dir : String;
  ModuleItem : TModuleItem;
  sr : TSearchRec;
  fileloaded : boolean;
  index,oindex : integer;
  s : String;
begin
  for n := 0 to lbModuleList.Count - 1 do
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
  end;
end;

function TfrmMMList.UpdateUI: Boolean;
begin
  Result := False;
  case FEditMode of
  sceAdd :
    begin
      lbModuleList.Enabled := False;
      frmMMEdit.pagEdit.Show;
      Result := True;
    end;
  sceDelete:
    begin
      if lbModuleList.ItemIndex <> -1 then
      begin
        Result := True;
        frmMMEDit.pagDelete.Show;
        CenterDefineButtonState(scbDelete,True);
      end
      else
      begin
        Result := False;
        CenterDefineButtonState(scbDelete,False);
      end;
    end;
  end;
end;

function TfrmMMList.SaveUi: Boolean;
var
  Dir : String;
  ModuleItem : TModuleItem;
  wnd : hwnd;
  msg: TSharpE_DataStruct;
  cds: TCopyDataStruct;
begin
  Result := True;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';
  lbModuleList.Enabled := True;

  case FEditMode of
    sceAdd:
      begin
        wnd := FindWindow(nil,PChar('SharpBar_'+inttostr(BarID)));
        if wnd <> 0 then
        begin
          msg.Module := frmMMEdit.cobo_modules.Text + '.dll';
          msg.LParam := BC_ADD;
          if frmMMEDit.cobo_position.ItemIndex = 0 then
            msg.RParam := -1
          else msg.RParam := 1;
          with cds do
          begin
            dwData := 0;
            cbData := SizeOf(TSharpE_DataStruct);
            lpData := @msg;
          end;
        end;
        if sendmessage(wnd, WM_COPYDATA, WM_BARCOMMAND, Cardinal(@cds)) = BCR_SUCCESS then
        begin
          BuildModuleList;
        end;
      end;
    sceDelete:
      begin
        if assigned(lbModuleList.Item[lbModuleList.ItemIndex].Data) then
        begin
          ModuleItem := TModuleItem(lbModuleList.Item[lbModuleList.ItemIndex].Data);
          wnd := FindWindow(nil,PChar('SharpBar_'+inttostr(BarID)));
          if wnd <> 0 then
            if SendMessage(wnd,WM_BARCOMMAND,BC_DELETE,ModuleItem.ID) = BCR_SUCCESS then
            begin
              lbModuleList.Items.Delete(lbModuleList.ItemIndex);
              ModuleItem.Free;
            end;
        end;
      end;
  end;
end;


end.

