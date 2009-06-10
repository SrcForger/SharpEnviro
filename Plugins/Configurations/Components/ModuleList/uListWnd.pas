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

unit uListWnd;

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
  StdCtrls,
  JvSimpleXml,
  JclFileUtils,
  Math,
  ImgList,
  PngImageList,
  SharpEListBox,
  SharpEListBoxEx,
  GR32,
  GR32_PNG,
  SharpApi,
  SharpCenterApi,
  ExtCtrls,
  Menus,
  Contnrs,
  Types,
  JclStrings,
  SharpERoundPanel,
  SharpThemeApiEx,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit, SharpECenterHeader, pngimage;

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

  TfrmListWnd = class(TForm)
    StatusImages: TPngImageList;
    lbModulesRight: TSharpEListBoxEx;
    lbModulesLeft: TSharpEListBoxEx;
    Panel2: TPanel;
    Image1: TImage;
    lblLeft: TLabel;
    Panel1: TPanel;
    Image2: TImage;
    lblRight: TLabel;
    Shape1: TShape;
    Shape2: TShape;
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
    FPluginHost: ISharpCenterHost;
    procedure CustomWndProc(var msg: TMessage);

  public
    procedure BuildModuleList;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

procedure AddItemsToList(APluginID: string; AList: TObjectList);
function ExtractBarID(ABarXmlFileName: string): Integer;
function ExtractBarName(ABarID: string): string;

var
  frmListWnd: TfrmListWnd;

const
  colName = 0;
  colEdit = 1;
  colMoveUp = 2;
  colMoveDown = 3;
  colDelete = 4;
  

  iidxMoveUp = 1;
  iidxMoveDown = 2;
  iidxDelete = 3;

implementation

uses uEditWnd;

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

procedure TfrmListWnd.lbModulesClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpModule: TModuleItem;
  wnd: THandle;
  s: string;
  cFile: string;
begin
  LockWindowUpdate(Self.Handle);
  try

  if Sender = lbModulesLeft then
    lbModulesRight.ItemIndex := -1
  else
    lbModulesLeft.ItemIndex := -1;

  tmpModule := TModuleItem(AItem.Data);
  if tmpModule = nil then
    exit;

  wnd := FindWindow(nil, PChar('SharpBar_' + PluginHost.PluginId));
  if wnd = 0 then
    exit;

  case ACol of
    colDelete: SendMessage(wnd, WM_BARCOMMAND, BC_DELETE, tmpModule.ID);
    colMoveUp: begin
      SendMessage(wnd, WM_BARCOMMAND, BC_MOVEUP, tmpModule.ID);
    end;
    colMoveDown: begin
      SendMessage(wnd, WM_BARCOMMAND, BC_MOVEDOWN, tmpModule.ID);
    end;
    colEdit: begin

        if AItem.SubItemText[ACol] <> '' then begin
          s := tmpModule.MFile;
          setlength(s, length(s) - length(ExtractFileExt(s)));
          cfile := SharpApi.GetCenterDirectory + '_Modules\' + s + '.con';

          if FileExists(cfile) then
            SharpCenterApi.CenterCommand(sccLoadSetting,
              PChar(cfile),
              PChar(PluginHost.PluginId + ':' + inttostr(tmpModule.ID)))
        end;
      end;
  end;

  BuildModuleList;
  FPluginHost.Refresh;

  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmListWnd.lbModulesGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmpModule: TModuleItem;
begin
  tmpModule := TModuleItem(AItem.Data);
  if tmpModule = nil then
    exit;

  case ACol of
    colMoveUp,colMoveDown, colDelete: if AItem.SubItemImageIndex[ACol] <> -1 then
        ACursor := crHandPoint;
    colEdit: if AItem.SubItemText[ACol] <> '' then
        ACursor := crHandPoint;
  end;

end;

procedure TfrmListWnd.lbModulesGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
begin
  case ACol of
    0: AImageIndex := 0;
    colMoveUp: begin
        AImageIndex := iidxMoveUp;
      end;
    colMoveDown: begin
        AImageIndex := iidxMoveDown;
      end;
    colDelete: AImageIndex := iidxDelete;
  end;
end;

procedure TfrmListWnd.lbModulesGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpModule: TModuleItem;
	colItemTxt, colDescTxt, colBtnTxt: TColor;
begin
  tmpModule := TModuleItem(AItem.Data);
  if tmpModule = nil then
    exit;

  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  case ACol of
    colName: begin
      AColText := Format('<font color="%s">%s <font color="%s">(%d)',[colorToString(colItemTxt),tmpModule.Name,
        colorToString(colDescTxt),tmpModule.ID])
    end;
    colEdit: begin
        if tmpModule.Configure then
          AColText := Format('<font color="%s"><u>%s</u>',[colorToString(colBtnTxt),'Edit'])
        else
          AColText := '';
      end;
  end;
end;

procedure TfrmListWnd.FormCreate(Sender: TObject);
begin
  FWinHandle := AllocateHWND(CustomWndProc);
  FModuleList := TObjectList.Create;
  Self.DoubleBuffered := true;
  lbModulesRight.DoubleBuffered := True;
  lbModulesLeft.DoubleBuffered := True;
end;

procedure TfrmListWnd.FormDestroy(Sender: TObject);
begin
  DeallocateHWnd(FWinHandle);
  FModuleList.Free;
end;

procedure TfrmListWnd.FormResize(Sender: TObject);
begin
  Self.Height := lbModulesRight.Height + lbModulesLeft.Height + 80;
end;

procedure TfrmListWnd.FormShow(Sender: TObject);
begin
  BuildModuleList;
  lblLeft.Font.Color := PluginHost.Theme.PluginSectionTitle;
  lblRight.Font.Color := lblLeft.Font.Color;
end;

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

function ExtractBarName(ABarID: string): String;
  var
    xml:TJvSimpleXML;
  begin
    xml := TJvSimpleXML.Create(nil);
    try
      if FileCheck(SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + ABarID + '\Bar.xml',True) then
      begin
        xml.LoadFromFile(SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + ABarID + '\Bar.xml');
        if xml.Root.items.ItemNamed['Settings'] <> nil then
          Result := xml.Root.items.ItemNamed['Settings'].Items.Value('Name','');
      end;
    finally
      xml.Free;
    end;

  end;

procedure TfrmListWnd.BuildModuleList;
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
    AddItemsToList(PluginHost.PluginId, FModuleList);

    for i := 0 to FModuleList.Count - 1 do begin

      tmpModule := TModuleItem(FModuleList.Items[i]);

      if tmpModule.Position = -1 then
        newItem := lbModulesLeft.AddItem(tmpModule.Name)
      else newItem := lbModulesRight.AddItem(tmpModule.Name);

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

    lbModulesRight.AutosizeGrid := true;
    lbModulesLeft.AutosizeGrid := true;
    LockWindowUpdate(0);
    Self.OnResize(nil);
  end;

end;

procedure TfrmListWnd.CustomWndProc(var msg: TMessage);
begin
  if ((msg.Msg = WM_SHARPEUPDATESETTINGS) and (msg.WParam = integer(suCenter))) then begin
    BuildModuleList;
    FPluginHost.Refresh;
  end;
end;

procedure AddItemsToList(APluginID: string; AList: TObjectList);
var
  xml: TJvSimpleXML;
  newItem: TModuleItem;
  dir: string;
  slBars: TStringList;
  i, j, n: Integer;

begin
  AList.Clear;
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  slBars := TStringList.Create;
  xml := TJvSimpleXML.Create(nil);
  try

    // build list of bar.xml files
    AdvBuildFileList(dir + '*bar.xml', faAnyFile, slBars, amAny, [flFullNames, flRecursive]);
    for i := 0 to Pred(slBars.Count) do begin

      n := ExtractBarID(slBars[i]);
      if n = StrToInt(APluginID) then begin
        if FileCheck(slBars[i],True) then
        begin
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
                AList.Add(newItem);
              end;
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

