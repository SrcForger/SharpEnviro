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
  JclSimpleXML,
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
  SharpCenterThemeApi,
  ExtCtrls,
  Menus,
  Contnrs,
  Types,
  JclStrings,
  SharpERoundPanel,
  SharpThemeApiEx,
  uSharpXMLUtils,
  uSharpDeskTDeskSettings,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit, SharpECenterHeader, pngimage, GR32_Image;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TObjectItem = class
    Caption: string;
    Info: string;
    OFile: string;
    ID: integer;
  private

  end;

  TfrmListWnd = class(TForm)
    StatusImages: TPngImageList;
    lbObjects: TSharpEListBoxEx;
    pnlExplorerDesktop: TPanel;
    Label1: TLabel;
    Image321: TImage32;

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
    procedure lbObjectsDblClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
  private
    FWinHandle: Thandle;
    FObjectList: TObjectList;
    FPluginHost: ISharpCenterHost;
    procedure CustomWndProc(var msg: TMessage);

  public
    procedure BuildObjectList;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

procedure AddItemsToList(APluginID: string; AList: TObjectList);

var
  frmListWnd: TfrmListWnd;

const
  colName = 0;
  colEdit = 1;
  colDelete = 2;

  iidxDelete = 1;

implementation

uses uEditWnd;

{$R *.dfm}

{ TfrmListWnd }

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
  tmpObject: TObjectItem;
  wnd: THandle;
  bDelete: boolean;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin
  LockWindowUpdate(Self.Handle);
  try

    tmpObject := TObjectItem(AItem.Data);
    if tmpObject = nil then
      exit;

  wnd := FindWindow('TSharpDeskMainForm', nil);
  if wnd = 0 then
    exit;

  case ACol of
    colDelete: begin
        bDelete := True;
        if not (CtrlDown) then
          if (MessageDlg(Format('Are you sure you want to delete: %s?' + #10#13 +'(%s %s)?', [tmpObject.OFile, tmpObject.Caption, tmpObject.Info]), mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
            bDelete := False;
        if (bDelete) then
          SendMessage(wnd, WM_DESKCOMMAND, BC_DELETE, tmpObject.ID);
      end;
    colEdit: begin

        if AItem.SubItemText[ACol] <> '' then begin

          SharpCenterApi.CenterCommand(sccLoadSetting,
              PChar('Objects'),
			        PChar(tmpObject.OFile),
              PChar(inttostr(tmpObject.ID)))
        end;
      end;
  end;

  BuildObjectList;
  FPluginHost.Refresh;

  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmListWnd.lbModulesGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmpObject: TObjectItem;
begin
  tmpObject := TObjectItem(AItem.Data);
  if tmpObject = nil then
    exit;

  case ACol of
    colDelete: if AItem.SubItemImageIndex[ACol] <> -1 then
        ACursor := crHandPoint;
    colEdit: if AItem.SubItemText[ACol] <> '' then
        ACursor := crHandPoint;
  end;

end;

procedure TfrmListWnd.lbModulesGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmpObject: TObjectItem;
begin
  case ACol of
    0: begin
      tmpObject := TObjectItem(AItem.Data);
      if (CompareText(tmpObject.OFile,'Link') = 0) then
        AImageIndex := 5
      else if (CompareText(tmpObject.OFile,'Clock') = 0) then
        AImageIndex := 2
      else if (CompareText(tmpObject.OFile,'Drive') = 0) then
        AImageIndex := 3
      else if (CompareText(tmpObject.OFile,'Image') = 0) then
        AImageIndex := 4
      else if (CompareText(tmpObject.OFile,'RecycleBin') = 0) then
        AImageIndex := 6
      else if (CompareText(tmpObject.OFile,'Weather') = 0) then
        AImageIndex := 7
      else AImageIndex := 0;
    end;
    colDelete: AImageIndex := iidxDelete;
  end;
end;

procedure TfrmListWnd.lbModulesGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpObject: TObjectItem;
	colItemTxt, colDescTxt, colBtnTxt: TColor;
begin
  tmpObject := TObjectItem(AItem.Data);
  if tmpObject = nil then
    exit;

  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  case ACol of
    colName: begin
      AColText := Format('<font color="%s"><b>%s</b><font color="%s"> (%s)<br>%s',
                         [colorToString(colItemTxt),
                            tmpObject.OFile,
                            colorToString(colDescTxt),
                            tmpObject.Caption,
                            tmpObject.Info,
                            tmpObject.ID]
                         )
    end;
    colEdit: begin
        AColText := Format('<font color="%s"><u>%s</u>',[colorToString(colBtnTxt),'Edit'])
      end;
  end;
end;

procedure TfrmListWnd.lbObjectsDblClickItem(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem);
var
  tmpObject: TObjectItem;
  wnd: THandle;
begin
  tmpObject := TObjectItem(AItem.Data);
  if tmpObject = nil then
    exit;

  wnd := FindWindow('TSharpDeskMainForm', nil);
  if wnd = 0 then
    exit;

  case ACol of
    colName:
    begin
      if AItem.SubItemText[ACol] <> '' then
      begin
        SharpCenterApi.CenterCommand(sccLoadSetting,
                                    PChar('Objects'),
									                  PChar(tmpObject.OFile),
                                    PChar(PluginHost.PluginId + ':' + inttostr(tmpObject.ID)));
      end;
    end;
  end;
end;

procedure TfrmListWnd.FormCreate(Sender: TObject);
var
  XmlDeskSettings: TDeskSettings;
begin
  FWinHandle := Classes.AllocateHWnd(CustomWndProc);
  FObjectList := TObjectList.Create;
  Self.DoubleBuffered := true;
  lbObjects.DoubleBuffered := True;

  XmlDeskSettings := TDeskSettings.Create(nil);
  lbObjects.Visible := not XmlDeskSettings.UseExplorerDesk;
  XmlDeskSettings.Free;
end;

procedure TfrmListWnd.FormDestroy(Sender: TObject);
begin
  Classes.DeallocateHWnd(FWinHandle);
  FObjectList.Free;
end;

procedure TfrmListWnd.FormResize(Sender: TObject);
begin
  Self.Height := lbObjects.Height + 16;
end;

procedure TfrmListWnd.FormShow(Sender: TObject);
begin
  BuildObjectList;

  if (not lbObjects.Visible) then
  begin
    pnlExplorerDesktop.Visible := True;
    PluginHost.SetEditTabVisibility(scbAddTab,false);
  end else pnlExplorerDesktop.Visible := False;
end;

procedure TfrmListWnd.BuildObjectList;
var
  i, j: Integer;
  n: Integer;
  tmpObject: TObjectItem;
  newItem: TSharpEListItem;
  exchange: boolean;
begin
  // Get selected item
  LockWindowUpdate(Self.Handle);
  try

    n := -1;
    if lbObjects.SelectedItem <> nil then
      n := TObjectItem(lbObjects.SelectedItem.Data).ID;

    lbObjects.Clear;
    AddItemsToList(PluginHost.PluginId, FObjectList);


    j := FObjectList.Count;
    repeat
      exchange := false;
      for i := 0 to j - 2 do
        if CompareText(TObjectItem(FObjectList.Items[i]).OFile, TObjectItem(FObjectList.Items[i+1]).OFile) > 0 then
        begin
          FObjectList.Exchange(i,i+1);
          exchange := true;
        end;
      j := j - 1;
    until not (exchange and (j > 1));

    for i := 0 to FObjectList.Count - 1 do
    begin
      tmpObject := TObjectItem(FObjectList.Items[i]);

      newItem := lbObjects.AddItem(tmpObject.OFile);

      newItem.Data := tmpObject;
      newItem.AddSubItem('', -1);
      newItem.AddSubItem('', -1);
      newItem.AddSubItem('', -1);
      newItem.AddSubItem('', -1);
    end;

    if n <> -1 then
    begin
      for i := 0 to lbObjects.Count -1 do
      begin
        tmpObject := TObjectItem(lbObjects.Item[i].Data);
        if tmpObject.ID = n then
        begin
          lbObjects.ItemIndex := i;
          break;
        end;
      end;
    end;

  finally
    lbObjects.AutosizeGrid := true;
    LockWindowUpdate(0);
    Self.OnResize(nil);
  end;
end;

procedure TfrmListWnd.CustomWndProc(var msg: TMessage);
begin
  if ((msg.Msg = WM_SHARPEUPDATESETTINGS) and (msg.WParam = integer(suDesktopObject))) then begin
    BuildObjectList;
    FPluginHost.Refresh;
  end;
end;

procedure AddItemsToList(APluginID: string; AList: TObjectList);
var
  xml, xmlobject: TJclSimpleXML;
  newItem: TObjectItem;
  dir: string;
  n : Integer;
  objectfile : string;
begin
  AList.Clear;
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpDesk\';

  xml := TJclSimpleXML.Create;

  try
    if uSharpXMLUtils.LoadXMLFromSharedFile(xml,dir + 'Objects.xml') then
    for n := 0 to XML.Root.Items.Count - 1 do
      with XML.Root.Items.Item[n].Items do
      begin
        newItem := TObjectItem.Create;
        newItem.ID := IntValue('ID',-1);
        newItem.OFile := Value('Object','');
        newItem.Info := '';
        newItem.Caption := '';
        AList.Add(newItem);

        // load caption from actual object
        xmlobject := TJclSimpleXML.Create;
        try
          objectfile := dir + 'Objects\' + newItem.OFile + '\' + inttostr(newItem.ID) + '.xml';
          if (not FileExists(objectfile)) and (CompareText(newItem.OFile,'Drive') = 0) then
            // When a drive object is added its default is C:\ but the xml file is not generated
            // so we need to handle this and display the appropriate value.
            newItem.Info := 'Location: C:\'
          else if uSharpXMLUtils.LoadXMLFromSharedFile(xmlobject, objectfile) then
          begin
            if (CompareText(newItem.OFile,'Link') = 0) then
            begin
              newItem.Caption := xmlobject.Root.Items.Value('Caption','');
              newitem.Info := 'Target: ' + xmlobject.Root.Items.Value('Target','');
            end else if (CompareText(newItem.OFile,'Clock') = 0) then
            begin
              newItem.Caption := xmlobject.Root.Items.Value('SkinCategory','');
              newItem.Info := 'Skin: ' + xmlobject.Root.Items.Value('Skin','Unknown');
            end else if (CompareText(newItem.OFile,'Drive') = 0) then
            begin
              newItem.Info := 'Location: ' + xmlobject.Root.Items.Value('Target','') + ':\';
            end else if (CompareText(newItem.OFile,'Image') = 0) then
            begin
              newItem.Info := 'Image: ' + xmlobject.Root.Items.Value('IconFile','');
            end else if (CompareText(newItem.OFile,'RecycleBin') = 0) then
            begin
              newItem.Caption := xmlobject.Root.Items.Value('Caption','');
            end else if (CompareText(newItem.OFile,'Weather') = 0) then
            begin
              newItem.Caption := xmlobject.Root.Items.Value('WeatherLocation','');
              newItem.Info := 'Skin: ' + xmlobject.Root.Items.Value('WeatherSkin','Unknown');
            end;
          end;
        finally
          xmlobject.Free;
        end;
      end;
  finally
    xml.free;
  end;
end;

end.

