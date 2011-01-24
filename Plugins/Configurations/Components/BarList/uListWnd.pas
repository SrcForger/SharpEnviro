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
  JclSimpleXml,
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

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmListWnd = class(TForm)
    lbBarList: TSharpEListBoxEx;
    tmrUpdate: TTimer;
    StatusImages: TPngImageList;
    pnlBarList: TPanel;
    procedure tmrUpdateTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure lbBarListGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);

    procedure lbBarListResize(Sender: TObject);
    procedure lbBarListGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbBarListGetCellText(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem;
      var AColText: string);
    procedure FormShow(Sender: TObject);
    procedure lbBarListDblClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbBarListClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbBarListGetCellWidth(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColWidth: Integer);

  private
    FWinHandle: THandle;
    FPluginHost: ISharpCenterHost;

    function IsBarRunning(ID: integer): boolean;

    procedure CustomWndProc(var msg: TMessage);
    function PointInRect(P: TPoint; Rect: TRect): boolean;
    procedure BuildBarList;
  public
    FBarList: TObjectList;

    function BarSpaceCheck: boolean;

    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;

  end;

procedure AddItemsToList(AList: TObjectList);

var
  frmListWnd: TfrmListWnd;
const
  colName = 0;
  colStartStop = 1;
  colEnableDisable = 2;
  colEdit = 3;
  colDelete = 4;

  iidxStop = 2;
  iidxPause = 1;
  iidxPlay = 0;
  iidxDelete = 6;

implementation

uses
  uEditWnd,
  SharpThemeApiEx,
  uSharpXMLUtils;

{$R *.dfm}

{ TfrmConfigListWnd }

function TfrmListWnd.IsBarRunning(ID: integer): boolean;
var
  h: hwnd;
begin
  h := FindWindow(nil, PChar('SharpBar_' + inttostr(ID)));
  result := h <> 0;
end;

function TfrmListWnd.PointInRect(P: TPoint; Rect: TRect): boolean;
begin
  if (P.X >= Rect.Left) and (P.X <= Rect.Right)
    and (P.Y >= Rect.Top) and (P.Y <= Rect.Bottom) then
    PointInRect := True
  else
    PointInRect := False;
end;



procedure TfrmListWnd.lbBarListClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  wnd: hwnd;
  Dir: string;
  FName: string;
  iBarID: Integer;
  XML: TJclSimpleXML;
  tmpBar: TBarItem;
  bDelete: Boolean;
  i : integer;
  bShouldStart : Boolean;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin
  tmpBar := TBarItem(AItem.Data);
  if (tmpBar = nil) and (AItem.ID <> -1) then
    exit;

  if (AItem.ID = -1) then
  begin
    if ACol = colEdit then
    begin
      bShouldStart := True;
      for i := 0 to FBarList.Count - 1 do
      begin
        if IsBarRunning(TBarItem(FBarList.Items[i]).BarID) then
          bShouldStart := False;
      end;
    
      if bShouldStart then
      begin
        for i := 0 to FBarList.Count - 1 do
        begin
          if not IsBarRunning(TBarItem(FBarList.Items[i]).BarID) then
          begin
            SharpApi.SharpExecute('_nohist,' + SharpApi.GetSharpeDirectory + 'SharpBar.exe' +
                                ' -load:' + inttostr(TBarItem(FBarList.Items[i]).BarID) +
                                ' -noREB' +
                                ' -noLASB');
          end;
        end;
      end else
      begin
        for i := 0 to FBarList.Count - 1 do
        begin
          if IsBarRunning(TBarItem(FBarList.Items[i]).BarID) then
          begin
            wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(TBarItem(FBarList.Items[i]).BarID)));
            if wnd <> 0 then
              SendMessage(wnd, WM_SHARPTERMINATE, 0, 0);
          end;
        end;
      end;
    end;

    tmrUpdate.Enabled := True;
    exit;
  end;

  case ACol of
    colEdit: begin
        if (IsBarRunning(tmpBar.BarID)) then
          CenterCommand(sccLoadSetting,
						PChar('Components'),
						PChar('BarEdit'),
						PChar(inttostr(tmpBar.BarID)));
      end;
    colStartStop: begin
        if not (IsBarRunning(tmpBar.BarID)) then begin
          SharpApi.SharpExecute('_nohist,' + SharpApi.GetSharpeDirectory + 'SharpBar.exe' +
            ' -load:' + inttostr(tmpBar.BarID) +
            ' -noREB' +
            ' -noLASB');
          tmrUpdate.Enabled := True;
        end
        else begin
          wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(tmpBar.BarID)));
          if wnd <> 0 then
            SendMessage(wnd, WM_SHARPTERMINATE, 0, 0);

          tmrUpdate.Enabled := True;
        end;

      end;
    colDelete: begin

        bDelete := True;
        iBarID := tmpBar.BarID;
        if not (CtrlDown) then
          if (MessageDlg(Format('Are you sure you want to delete: %s?', [tmpBar.Name]), mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
            bDelete := False;

        if bDelete then begin

          Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';
          if IsBarRunning(iBarID) then begin
            wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(iBarID)));
            SendMessage(wnd, WM_SHARPTERMINATE, 0, 0);
            // give it a second to shutdown
            sleep(500);
          end;
          DeleteDirectory(Dir + inttostr(iBarID), True);
          tmrUpdateTimer(nil);

          tmrUpdate.Enabled := True;
        end;
      end;
    colEnableDisable:
      begin
        if tmpBar.AutoStart then
        begin
          wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(tmpBar.BarID)));
          if wnd <> 0 then
            SendMessage(wnd, WM_SHARPTERMINATE, 0, 0);
        end;

        tmpBar.AutoStart := not (tmpBar.AutoStart);
        Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(tmpBar.BarID) + '\';
        FName := Dir + 'bar.xml';

        XML := TJclSimpleXML.Create;
        if LoadXMLFromSharedFile(XML,FName,False) then // don't load outdated backup!
        begin
          with XML.Root.Items do
          begin
            if ItemNamed['Settings'] = nil then
              Add('Settings');
            with ItemNamed['Settings'].Items do
            begin
              if ItemNamed['AutoStart'] <> nil then
                ItemNamed['AutoStart'].BoolValue := tmpBar.AutoStart
              else Add('AutoStart', tmpBar.AutoStart);
            end;
          end;
          SaveXMLToSharedFile(XML,FName,True);
        end;
        XML.Free;

        tmrUpdate.Enabled := True;
      end;
  end;

  if frmEditWnd <> nil then
    frmEditWnd.Init;

  FPluginHost.SetEditTabsVisibility( lbBarList.ItemIndex, lbBarList.Count );
  FPluginHost.Refresh;
end;

procedure TfrmListWnd.lbBarListDblClickItem(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem);
var
  tmpBar: TBarItem;
begin
  tmpBar := TBarItem(AItem.Data);
  if tmpBar = nil then
    exit;

  case ACol of
    colName: begin
        if (IsBarRunning(tmpBar.BarID)) then
          CenterCommand(sccLoadSetting,
						PChar('Components'),
						PChar('BarEdit'),
						PChar(inttostr(tmpBar.BarID)));
    end;
  end;
end;

procedure TfrmListWnd.lbBarListGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmpBar: TBarItem;
begin

  tmpBar := TBarItem(AItem.Data);
  if (tmpBar = nil) and (AItem.ID <> -1) then
    exit;

  if (AItem.ID = -1) then
  begin
    if (ACol = colEdit) then
      ACursor := crHandPoint;
      
    exit;
  end;

  case ACol of
    colStartStop, colEnableDisable, colDelete: ACursor := crHandPoint;
    colEdit: if (IsBarRunning(tmpBar.BarID)) then
        ACursor := crHandPoint;
  end;
end;

procedure TfrmListWnd.lbBarListGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmpBar: TBarItem;
begin

  tmpBar := TBarItem(AItem.Data);
  if tmpBar = nil then
    exit;

  case ACol of
    colName: begin
        if IsBarRunning(tmpBar.BarID) then
          AImageIndex := iidxPlay
        else if tmpBar.AutoStart then
          AImageIndex := iidxPause
        else if not (tmpBar.AutoStart) then
          AImageIndex := iidxStop;

      end;
    colDelete: AImageIndex := iidxDelete;
  end;
end;

procedure TfrmListWnd.lbBarListGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpBar: TBarItem;
  s, sScreen, sHPos, sVPos: string;
  colItemTxt, colDescTxt, colBtnTxt, colBtnDisabledTxt: TColor;

  i : integer;
  b : Boolean;

  function GetBarID: string;
  begin
    case tmpBar.HPos of
      0: sHPos := 'Left';
      1: sHPos := 'Middle';
      2: sHPos := 'Right';
      3: sHPos := 'Full';
    else
      sHPos := '';
    end;

    case tmpBar.VPos of
      0: sVPos := 'Top';
      1: sVPos := 'Bottom';
    else
      sVPos := '';
    end;

    if tmpBar.Monitor = 0 then
      sScreen := '' else
      sScreen := Format('Screen: %d ', [tmpBar.Monitor]);

    if ((sHPos <> '') and (sVPos <> '')) then begin

      Result := Format('%sBar Aligned %s %s', [sScreen, sVPos, sHPos]);

    end else
      Result := 'ID: ' + IntToStr(tmpBar.BarID);
  end;
begin
  tmpBar := TBarItem(AItem.Data);
  if (tmpBar = nil) and (AItem.ID <> -1) then
    exit;

 // Assign theme colours
  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt, colBtnDisabledTxt);

  if AItem.ID = -1 then
  begin
    case ACol of
      colEdit:
      begin
        b := False;

        for i := 0 to FBarList.Count - 1 do
        begin
          if (TBarItem(FBarList.Items[i]).AutoStart) and (IsBarRunning(TBarItem(FBarList.Items[i]).BarID)) then
            b := True;
        end;
        if b then
          AColText := format('<font color="%s"><u>%s</u>',[ColorToString(colBtnTxt),'Stop All'])
        else
          AColText := format('<font color="%s"><u>%s</u>',[ColorToString(colBtnTxt),'Start All']);
      end;
    end;

    exit;
  end;

  case ACol of
    colName: begin

        s := GetBarID;

        if tmpBar.Name <> '' then
          s := tmpBar.Name;
        AColText := format('<font color="%s">%s (%d Modules)<br><font color="%s">%s',
            [colorToString(colItemTxt), s, tmpbar.ModuleCount, colorToString(colDescTxt), tmpBar.Modules]);
      end;
    colStartStop: begin

        if not (tmpBar.AutoStart) then
          AColText := ''
        else if IsBarRunning(tmpBar.BarID) then
          AColText := format('<font color="%s"><u>%s</u>',[ColorToString(colBtnTxt),'Stop'])
        else
          AColText := format('<font color="%s"><u>%s</u>',[ColorToString(colBtnTxt),'Start']);
      end;
    colEnableDisable: begin
        if tmpBar.AutoStart then
          AColText := format('<font color="%s"><u>%s</u>',[ColorToString(colBtnTxt),'Disable'])
        else
          AColText := format('<font color="%s"><u>%s</u>',[ColorToString(colBtnTxt),'Enable'])
      end;
    colEdit: begin

        if not (tmpBar.AutoStart) then
          AColText := format('<font color="%s"><u>%s</u>',[ColorToString(colBtnDisabledTxt),'Edit'])
        else if IsBarRunning(tmpBar.BarID) then
          AColText := format('<font color="%s"><u>%s</u>',[ColorToString(colBtnTxt),'Edit'])
        else
          AColText := format('<font color="%s"><u>%s</u>',[ColorToString(colBtnDisabledTxt),'Edit'])
      end;
  end;

end;

procedure TfrmListWnd.lbBarListGetCellWidth(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AColWidth: Integer);
begin
  if AItem.ID = -1 then
  begin
    case ACol of
      colEdit:
      begin
        AColWidth := 60;
      end;
    end;
  end;
end;

procedure TfrmListWnd.lbBarListResize(Sender: TObject);
begin
  pnlBarList.Height := lbBarList.Height;
  Self.Height := pnlBarList.Height;
end;

procedure TfrmListWnd.FormCreate(Sender: TObject);
begin
  FWinHandle := Classes.AllocateHWND(CustomWndProc);
  FBarList := TObjectList.Create(True);
  Self.DoubleBuffered := true;
  lbBarList.DoubleBuffered := true;
end;

procedure TfrmListWnd.FormDestroy(Sender: TObject);
begin
  FBarList.Free;
  Classes.DeallocateHWnd(FWinHandle);
end;

procedure TfrmListWnd.CustomWndProc(var msg: TMessage);
begin
  if (msg.Msg = WM_BARSTATUSCHANGED) then begin
    BuildBarList;

    FPluginHost.Refresh;
  end;
end;

procedure TfrmListWnd.FormShow(Sender: TObject);
begin
  BuildBarList;
end;

function TfrmListWnd.BarSpaceCheck: boolean;
var
  BR: array of TBarRect;
  Mon: TMonitor;
  n: integer;
  lp: TPoint;

  function BarAtPos(x, y: integer): boolean;
  var
    i: integer;
  begin
    for i := 0 to High(BR) do
      if PointInRect(Point(BR[i].R.Left + (BR[i].R.Right - BR[i].R.Left) div 2,
        BR[i].R.Top + (BR[i].R.Bottom - BR[i].R.Top) div 2),
        Mon.BoundsRect) then
        if PointInRect(Point(x, y), BR[i].R)
          or PointInRect(Point(x - 75, y), BR[i].R)
          or PointInRect(Point(x + 75, y), BR[i].R) then begin
          result := true;
          exit;
        end;
    lp := Point(x, y);
    result := false;
  end;

begin
  result := False;
  setlength(BR, 0);
  for n := 0 to SharpApi.GetSharpBarCount - 1 do begin
    setlength(BR, length(BR) + 1);
    BR[High(BR)] := SharpApi.GetSharpBarArea(n);
  end;

  lp := point(-1, -1);
  for n := -1 to Screen.MonitorCount - 1 do begin
    // start with the current monitor
    if n = -1 then
      Mon := Monitor
    else
      Mon := Screen.Monitors[n];
    if (n <> -1) and (Mon = Monitor) then
      Continue; // don't test the current monitor twice
    if BarAtPos(Mon.Left, Mon.Top) then
      if BarAtPos(Mon.Left + Mon.Width div 2, Mon.Top) then
        if BarAtPos(Mon.Left + Mon.Width, Mon.Top) then
          if BarAtPos(Mon.Left, Mon.Top + Mon.Height) then
            if BarAtPos(Mon.Left + Mon.Width div 2, Mon.Top + Mon.Height) then
              BarAtPos(Mon.Left + Mon.Width, Mon.Top + Mon.Height);
    if (lp.x <> -1) and (lp.y <> -1) then
      break;
  end;
  setlength(BR, 0);
  if (lp.x = -1) and (lp.y = -1) then
    exit;

  result := True;
end;

procedure TfrmListWnd.BuildBarList;
var
  newItem: TSharpEListItem;
  selectedIndex, i, bari: Integer;
  tmpBar: TBarItem;
begin
  selectedIndex := -1;

  // Get selected item
  LockWindowUpdate(Self.Handle);
  // We need to account for the Top and Bottom headers before setting the selectedIndex
  if lbBarList.Count > 2 then
  begin
    if lbBarList.Item[lbBarList.ItemIndex].Header then
      selectedIndex := TBarItem(lbBarList.Item[lbBarList.ItemIndex + 1].Data).BarID
    else
      selectedIndex := TBarItem(lbBarList.Item[lbBarList.ItemIndex].Data).BarID
  end;

  lbBarList.Clear;
  AddItemsToList(FBarList);

  newItem := lbBarList.AddItem('<br>Top Bars<hr>');
  newItem.Data := nil;
  newItem.Header := True;
  newItem.ID := -1;
  newItem.AddSubItem('');
  newItem.AddSubItem('');
  newItem.AddSubItem('');
  newItem.AddSubItem('');

  // Add Top bars
  bari := 1;
  for i := 0 to FBarList.Count - 1 do
  begin
    tmpBar := TBarItem(FBarList.Items[i]);
    if tmpBar.VPos <> 0 then
      continue;

    newItem := lbBarList.AddItem(tmpBar.Name);
    newItem.Data := tmpBar;
    newItem.AddSubItem('');
    newItem.AddSubItem('');
    newItem.AddSubItem('');
    newItem.AddSubItem('');

    if tmpBar.BarID = selectedIndex then
      lbBarList.ItemIndex := bari;

    bari := bari + 1;
  end;

  newItem := lbBarList.AddItem('<br>Bottom Bars<hr>');
  newItem.Data := nil;
  newItem.Header := True;

  bari := bari + 1;

  // Add Bottom bars
  for i := 0 to FBarList.Count - 1 do
  begin
    tmpBar := TBarItem(FBarList.Items[i]);
    if tmpBar.VPos <> 1 then
      continue;

    newItem := lbBarList.AddItem(tmpBar.Name);
    newItem.Data := tmpBar;
    newItem.AddSubItem('');
    newItem.AddSubItem('');
    newItem.AddSubItem('');
    newItem.AddSubItem('');

    if tmpBar.BarID = selectedIndex then
      lbBarList.ItemIndex := bari;

    bari := bari + 1;
  end;

  lbBarList.UpdateHeaders;

  // When setting the ItemIndex account for the Top and Bottom headers
  if (lbBarList.Count > 2) and (lbBarList.ItemIndex = -1) then
    lbBarList.ItemIndex := 1;

  LockWindowUpdate(0);

  FPluginHost.SetEditTabsVisibility( lbBarList.ItemIndex, lbBarList.Count );
  FPluginHost.Refresh;
end;

procedure TfrmListWnd.tmrUpdateTimer(Sender: TObject);
begin
  tmrUpdate.Enabled := False;
  BuildBarList;

  if frmEditWnd <> nil then
    frmEditWnd.Init;

  FPluginHost.SetEditTabsVisibility( lbBarList.ItemIndex, lbBarList.Count );
  FPluginHost.Refresh;
end;

{ TBarItem }

procedure AddItemsToList(AList: TObjectList);
var
  xml: TJclSimpleXML;
  newItem: TBarItem;
  dir: string;
  slBars, slModules: TStringList;
  n,i, j: Integer;

  function ExtractBarID(ABarXmlFileName: string): String;
  var
    s: string;
    n: Integer;
  begin
    s := PathRemoveSeparator(ExtractFilePath(ABarXmlFileName));
    n := JclStrings.StrLastPos('\', s);
    s := Copy(s, n + 1, length(s));
    result := s;
  end;

begin
  AList.Clear;
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  newItem := nil;
  slBars := TStringList.Create;
  slModules := TStringList.Create;
  xml := TJclSimpleXML.Create;
  try
    // build list of bar.xml files
    AdvBuildFileList(dir + '*bar.xml', faAnyFile, slBars, amAny, [flFullNames, flRecursive]);
    for i := 0 to Pred(slBars.Count) do
    begin
      if TryStrToInt(ExtractBarID(slBars[i]),n) then
      begin
        xml.LoadFromFile(slBars[i]);
        if xml.Root.Items.ItemNamed['Settings'] <> nil then
          with xml.Root.Items.ItemNamed['Settings'].Items do
          begin
            newItem := TBarItem.Create;
            with newItem do
            begin
              Name := Value('Name', 'Toolbar');
              BarID := StrToInt(ExtractBarID(slBars[i]));
              Monitor := IntValue('MonitorIndex', 0);
              PMonitor := BoolValue('PrimaryMonitor', True);
              HPos := IntValue('HorizPos', 0);
              VPos := IntValue('VertPos', 0);
              AutoStart := BoolValue('AutoStart', True);
              FixedWidthEnabled := BoolValue('FixedWidthEnabled', False);
              FixedWidth := Min(90,Max(10,IntValue('FixedWidth', 50)));
              MiniThrobbers := BoolValue('ShowMiniThrobbers', False);
              DisableHideBar := BoolValue('DisableHideBar', True);
              ShowThrobber := BoolValue('ShowThrobber', True);
              StartHidden := BoolValue('StartHidden', False);
              AlwaysOnTop := BoolValue('AlwaysOnTop', True);
              AutoHide := BoolValue('AutoHide', False);
              AutoHideTime := IntValue('AutoHideTime', 1000);
            end;
          end;

          slModules.Clear;
          if xml.Root.Items.ItemNamed['Modules'] <> nil then
          with xml.Root.Items.ItemNamed['Modules'] do
          begin
            newItem.ModuleCount := Items.Count;
            for j := 0 to Pred(Items.Count) do
            begin
              if Items.Item[j].Items.Value('Module') <> '' then
                slModules.Add(PathRemoveExtension(Items.Item[j].Items.Value('Module')))
            end;

            if slModules.Count <> 0 then
              newItem.Modules := slModules.CommaText;
          end;
          AList.Add(newItem);
      end;
    end;
  finally
    slBars.Free;
    slModules.Free;
    xml.Free;
  end;
end;

end.

