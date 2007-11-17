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

unit uSharpBarListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, uSEListboxPainter, JclFileUtils, Math,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx, GR32, GR32_PNG, SharpApi, SharpCenterApi,
  ExtCtrls, Menus, Contnrs, Types, JclStrings;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TBarItem = class
    Name: string;
    ID: integer;
    Monitor: integer;
    PMonitor: boolean;
    HPos: integer;
    VPos: integer;
    AutoStart: boolean;
    ModuleCount: Integer;
    Modules: string;
  end;

  TfrmBarList = class(TForm)
    StatusImages: TPngImageList;
    lbBarList: TSharpEListBoxEx;
    pilDefault: TPngImageList;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure lbBarListGetCellCursor(const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);

    procedure lbBarListClickItem(const ACol: Integer; AItem: TSharpEListItem);
    procedure lbBarListResize(Sender: TObject);
    procedure lbBarListGetCellImageIndex(const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbBarListGetCellText(const ACol: Integer; AItem: TSharpEListItem;
      var AColText: string);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
    procedure AddItemsToList;
  private
    function IsBarRunning(ID: integer): boolean;

    function PointInRect(P: TPoint; Rect: TRect): boolean;
    function BarSpaceCheck: boolean;
  public
    FBarList: TObjectList;
    procedure BuildBarList;
    procedure BuildBarList2;
    procedure UpdateBarStatus;
    function UpdateUI: Boolean;
    function SaveUi: Boolean;
    procedure ConfigureItem;
    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
  end;

var
  frmBarList: TfrmBarList;
const
  colName = 0;
  colStartStop = 1;
  colEnableDisable = 2;
  colEdit = 3;

  iidxStop = 2;
  iidxPause = 1;
  iidxPlay = 0;

implementation

uses uSharpBarListEditWnd, SharpThemeApi;

{$R *.dfm}

{ TfrmConfigListWnd }

function TfrmBarList.IsBarRunning(ID: integer): boolean;
var
  h: hwnd;
begin
  h := FindWindow(nil, PChar('SharpBar_' + inttostr(ID)));
  result := h <> 0;
end;

function TfrmBarList.PointInRect(P: TPoint; Rect: TRect): boolean;
begin
  if (P.X >= Rect.Left) and (P.X <= Rect.Right)
    and (P.Y >= Rect.Top) and (P.Y <= Rect.Bottom) then
    PointInRect := True
  else
    PointInRect := False;
end;

procedure TfrmBarList.lbBarListClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
var
  wnd: hwnd;
  Dir: string;
  FName: string;
  XML: TJvSimpleXML;
  fileloaded: boolean;
  enable: boolean;

  tmpBar: TBarItem;
begin
  if frmEditItem <> nil then begin
    UpdateUI;
    exit;
  end;

  tmpBar := TBarItem(AItem.Data);
  if tmpBar = nil then
    exit;

  case ACol of
    colEdit: begin
        CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory
          + '\_Components\Module Manager.con'), pchar(inttostr(tmpBar.ID)));
      end;
    colStartStop: begin
        if not (IsBarRunning(tmpBar.ID)) then begin
          SharpApi.SharpExecute('_nohist,' + SharpApi.GetSharpeDirectory + 'SharpBar.exe' +
            ' -load:' + inttostr(tmpBar.ID) +
            ' -noREB' +
            ' -noLASB');
          UpdateBarStatus;
        end
        else begin
          wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(tmpBar.ID)));
          if wnd <> 0 then
            SendMessage(wnd, WM_SHARPTERMINATE, 0, 0);

          UpdateBarStatus;
        end;

      end;
    colEnableDisable: begin

        if tmpBar.AutoStart then begin
          wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(tmpBar.ID)));
          if wnd <> 0 then
            SendMessage(wnd, WM_SHARPTERMINATE, 0, 0);
        end;

        tmpBar.AutoStart := not (tmpBar.AutoStart);
        Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(tmpBar.ID) + '\';
        FName := Dir + 'bar.xml';

        XML := TJvSimpleXML.Create(nil);
        if FileExists(FName) then begin
          try
            XML.LoadFromFile(FName);
            fileloaded := True;
          except
            fileloaded := False;
          end;
          if fileloaded then
            with XML.Root.Items do begin
              if ItemNamed['Settings'] = nil then
                Add('Settings');
              with ItemNamed['Settings'].Items do begin
                if ItemNamed['AutoStart'] <> nil then
                  ItemNamed['AutoStart'].BoolValue := tmpBar.AutoStart
                else
                  Add('AutoStart', tmpBar.AutoStart);
              end;
            end;
        end;
        XML.SaveToFile(FName);
        XML.Free;

        BuildBarList;
      end;
  end;
end;

procedure TfrmBarList.lbBarListGetCellCursor(const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ((AItem.SubItemText[ACol] = '') or (frmEditItem <> nil)) then
    exit;
  if (ACol = colStartStop) or (ACol = colEnableDisable) or (ACol = colEdit) then
    ACursor := crHandPoint;
end;

procedure TfrmBarList.lbBarListGetCellImageIndex(const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmpBar: TBarItem;
begin

  tmpBar := TBarItem(AItem.Data);
  if tmpBar = nil then
    exit;

  case ACol of
    colName: begin
        if IsBarRunning(tmpBar.ID) then
          AImageIndex := iidxPlay
        else if tmpBar.AutoStart then
          AImageIndex := iidxPause
        else if not (tmpBar.AutoStart) then
          AImageIndex := iidxStop;

      end;
  end;
end;

procedure TfrmBarList.lbBarListGetCellText(const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpBar: TBarItem;
begin

  tmpBar := TBarItem(AItem.Data);
  if tmpBar = nil then
    exit;

  case ACol of
    colName: begin
        if tmpBar.ModuleCount = 0 then
          AColText := tmpBar.Name
        else if tmpBar.ModuleCount > 0 then
          AColText := format('%s (%d)<br><font color="clGray">%s', [tmpBar.Name, tmpbar.ModuleCount,
            tmpBar.Modules]);
      end;
    colStartStop: begin

        if not (tmpBar.AutoStart) then
          AColText := ''
        else if IsBarRunning(tmpBar.ID) then
          AColText := '<font color="clNavy"><u>Stop</u>'
        else
          AColText := '<font color="clNavy"><u>Start</u>';
      end;
    colEnableDisable: begin
        if tmpBar.AutoStart then
          AColText := '<font color="clNavy"><u>Disable</u>'
        else
          AColText := '<font color="clNavy"><u>Enable</u>';
      end;
    colEdit: begin

        if not (tmpBar.AutoStart) then
          AColText := ''
        else if IsBarRunning(tmpBar.ID) then
          AColText := '<font color="clNavy"><u>Edit</u>';
      end;
  end;

end;

procedure TfrmBarList.lbBarListResize(Sender: TObject);
begin
  Self.Height := lbBarList.Height;
end;

procedure TfrmBarList.FormCreate(Sender: TObject);
begin
  FBarList := TObjectList.Create(True);
  BuildBarList;
  Self.DoubleBuffered := true;
  lbBarList.DoubleBuffered := true;
end;

procedure TfrmBarList.FormDestroy(Sender: TObject);
begin
  FBarList.Free;
end;

procedure TfrmBarList.UpdateBarStatus;
var
  n: integer;
  iindex: integer;
  SelItem: TBarItem;
  SList: TStringList;
  c: boolean;
  i: integer;
begin
  BuildBarList;
end;

procedure TfrmBarList.BuildBarList;
var
  n: Integer;
  newItem: TSharpEListItem;
  XML: TJvSimpleXML;
  Dir: string;
  iindex: integer;
  BarItem: TBarItem;
  SList: TStringList;
  sr: TSearchRec;
  fileloaded: boolean;
  lastselected: integer;
begin
  BuildBarList2;
end;

function TfrmBarList.BarSpaceCheck: boolean;
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
      Mon := frmBarList.Monitor
    else
      Mon := Screen.Monitors[n];
    if (n <> -1) and (Mon = frmBarList.Monitor) then
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

function TfrmBarList.UpdateUI: Boolean;
var
  tmpItem: TSharpEListItem;
  tmpBar: TBarItem;
  n: integer;
  BarItem: TBarItem;
begin
  Result := False;
  case FEditMode of
    sceAdd: begin
        if BarSpaceCheck then begin
          frmEditItem.pagEdit.Show;
          FrmEditItem.edName.Text := '';

          frmEditItem.cbBasedOn.Items.Clear;
          frmEditItem.cbBasedOn.Items.AddObject('New Bar', nil);
          for n := 0 to lbBarList.Count - 1 do begin
            tmpBar := TBarItem(lbBarList.Item[n].Data);
            frmEditItem.cbBasedOn.Items.AddObject(tmpBar.Name, tmpBar);
          end;
          frmEditItem.cbBasedOn.ItemIndex := 0;
          frmEditItem.cbBasedOn.Enabled := True;
          frmEditItem.BarItem := nil;

          frmEditItem.BuildMonList;
          frmEditItem.cobo_monitor.ItemIndex := 0;
          frmEditItem.edName.SetFocus;
        end
        else begin
          frmEditItem.pagBarSpace.Show;
        end;
        //      frmBarList.lbBarList.Enabled := False;
        Result := True;
      end;
    sceEdit: begin
        if lbBarList.ItemIndex <> -1 then begin
          tmpItem := lbBarList.Item[lbBarList.ItemIndex];
          BarItem := TBarItem(tmpItem.Data);

          frmEditItem.pagEdit.Show;
          FrmEditItem.edName.Text := BarItem.Name;
          FrmEditItem.edName.SetFocus;

          if frmEditItem.BarItem = nil then
            frmEditItem.BarItem := TBarItem.Create;

          frmEditItem.BarItem.Name := BarItem.Name;
          frmEditItem.BarItem.ID := BarItem.ID;
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
    sceDelete: begin
        if frmBarList.lbBarList.ItemIndex <> -1 then begin
          Result := True;
          frmEditItem.pagDelete.Show;
          CenterDefineButtonState(scbDelete, True);
        end
        else begin
          Result := False;
          CenterDefineButtonState(scbDelete, False);
        end;
      end;
  end;
end;

function TfrmBarList.SaveUi: Boolean;
var
  XML: TJvSimpleXML;
  Dir: string;
  NewID: string;
  CID: integer;
  n: integer;
  BarItem: TBarItem;
  wnd: hwnd;
  sr: TSearchRec;
  fileloaded: boolean;
begin
  Result := True;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  case FEditMode of
    sceAdd: begin
        // Generate a new unique bar ID and make sure that there is no other
        // bar with the same ID
        repeat
          NewID := '';
          for n := 1 to 8 do
            NewID := NewID + inttostr(random(9) + 1);
        until not DirectoryExists(Dir + NewID);

        if FrmEditItem.cbBasedOn.ItemIndex > 0 then begin
          CID := TBarItem(FrmEditItem.cbBasedOn.Items.Objects[FrmEditItem.cbBasedOn.ItemIndex]).ID;

          if FindFirst(Dir + inttostr(CID) + '\*.xml', FAAnyFile, sr) = 0 then
            repeat
              if FileExists(Dir + inttostr(CID) + '\' + sr.Name) then
                CopyFile(PChar(Dir + inttostr(CID) + '\' + sr.Name),
                  PChar(Dir + NewID + '\' + sr.Name), True);
            until FindNext(sr) <> 0;
          FindClose(sr);
        end;

        XML := TJvSimpleXML.Create(nil);
        if FileExists(Dir + NewID + '\Bar.xml') then begin
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
        XML.SaveToFile(Dir + NewID + '\Bar.xml');
        XML.Free;
      end;
    sceEdit: begin
        CID := TBarItem(frmEditItem.BarItem).ID;
        XML := TJvSimpleXML.Create(nil);
        fileloaded := False;
        if FileExists(Dir + inttostr(CID) + '\Bar.xml') then begin
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
        XML.SaveToFile(Dir + inttostr(CID) + '\Bar.xml');
        XML.Free;
      end;
    sceDelete: begin
        BarItem := TBarItem(lbBarList.Item[lbBarList.ItemIndex].Data);
        if IsBarRunning(BarItem.ID) then begin
          wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(BarItem.ID)));
          SendMessage(wnd, WM_SHARPTERMINATE, 0, 0);
          // give it a second to shutdown
          sleep(500);
        end;
        DeleteDirectory(Dir + inttostr(BarItem.ID), True);
      end;
  end;

  if FEditMode = sceAdd then
    SharpApi.SharpExecute('_nohist,' + SharpApi.GetSharpeDirectory + 'SharpBar.exe' +
      ' -load:' + NewID +
      ' -noREB' +
      ' -noLASB')
  else if FEditMode = sceEdit then begin
    wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(CID)));
    if wnd <> 0 then
      SendMessage(wnd, WM_BARREPOSITION, 0, 0);
  end;

  BuildBarList;
end;

procedure TfrmBarList.BuildBarList2;
var
  newItem: TSharpEListItem;
  XML: TJvSimpleXML;
  Dir: string;
  BarItem: TBarItem;
  SList: TStringList;
  sr: TSearchRec;
  fileloaded: boolean;

  selectedIndex, i, index: Integer;
  tmpBar: TBarItem;
begin

  // Get selected item
  LockWindowUpdate(Self.Handle);
  if lbBarList.ItemIndex <> -1 then
    selectedIndex := TBarItem(lbBarList.Item[lbBarList.ItemIndex].Data).ID
  else
    selectedIndex := -1;

  lbBarList.Clear;
  AddItemsToList;

  for i := 0 to FBarList.Count - 1 do begin

    tmpBar := TBarItem(FBarList.Items[i]);

    newItem := lbBarList.AddItem(tmpBar.Name);
    newItem.Data := tmpBar;
    newItem.AddSubItem('');
    newItem.AddSubItem('');
    newItem.AddSubItem('');

    if tmpBar.ID = selectedIndex then
      lbBarList.ItemIndex := i;

  end;
  LockWindowUpdate(0);

  if lbBarList.Items.Count = 0 then begin
    CenterDefineButtonState(scbEditTab, False);
    CenterDefineButtonState(scbDeleteTab, False);
  end
  else begin
    if lbBarList.ItemIndex = -1 then
      lbBarList.ItemIndex := 0;
    CenterDefineButtonState(scbEditTab, True);
    CenterDefineButtonState(scbDeleteTab, True);
  end;       
end;

procedure TfrmBarList.ConfigureItem;
begin
  if lbBarList.ItemIndex < 0 then
    exit;

  //  sBar := TThemeListItem(lbThemeList.Item[lbThemeList.ItemIndex].Data).Name;
  //  SharpApi.CenterMsg(sccLoadSetting,PChar(SharpApi.GetCenterDirectory
  //    + '_Themes\Theme.con'),pchar(sTheme))
end;

procedure TfrmBarList.Timer1Timer(Sender: TObject);
begin
  UpdateBarStatus;
end;

{ TBarItem }

procedure TfrmBarList.AddItemsToList;
var
  xml: TJvSimpleXML;
  newItem: TBarItem;
  dir: string;
  slBars, slModules: TStringList;
  i, j, index: Integer;

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
  FBarList.Clear;
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  slBars := TStringList.Create;
  slModules := TStringList.Create;
  xml := TJvSimpleXML.Create(nil);
  try

    // build list of bar.xml files
    AdvBuildFileList(dir + '*bar.xml', faAnyFile, slBars, amAny, [flFullNames, flRecursive]);
    for i := 0 to Pred(slBars.Count) do begin
      xml.LoadFromFile(slBars[i]);
      if xml.Root.Items.ItemNamed['Settings'] <> nil then
        with xml.Root.Items.ItemNamed['Settings'].Items do begin
          newItem := TBarItem.Create;
          with newItem do begin
            Name := Value('Name', 'Toolbar');
            ID := ExtractBarID(slBars[i]);
            Monitor := IntValue('MonitorIndex', 0);
            PMonitor := BoolValue('PrimaryMonitor', True);
            HPos := IntValue('HorizPos', 0);
            VPos := IntValue('VertPos', 0);
            AutoStart := BoolValue('AutoStart', True);
          end;
        end;

      slModules.Clear;
      if xml.Root.Items.ItemNamed['Modules'] <> nil then
        with xml.Root.Items.ItemNamed['Modules'] do begin
          newItem.ModuleCount := Items.Count;
          for j := 0 to Pred(Items.Count) do begin

            if Items.Item[j].Items.Value('Module') <> '' then
              slModules.Add(PathRemoveExtension(Items.Item[j].Items.Value('Module')))
          end;

          if slModules.Count <> 0 then
            newItem.Modules := slModules.CommaText;
        end;

      FBarList.Add(newItem);
    end;

    // Sort
    {slBars.Clear;
    for i := 0 to FBarList.Count - 1 do begin
      index := GetBarIndex(TBarItem(FBarList.Items[i]));
      slBars.AddObject(inttostr(index) + TBarItem(FBarList.Items[i]).Name, FBarList.Items[i]);
    end;
    slBars.Sort;
    for i := 0 to slBars.Count - 1 do
      FBarList.Move(FBarList.IndexOf(slBars.Objects[i]), i);   }

  finally
    slBars.Free;
    slModules.Free;
    xml.Free;
  end;
end;

end.

