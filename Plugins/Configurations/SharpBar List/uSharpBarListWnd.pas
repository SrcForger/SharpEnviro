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
  JclStrings;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TBarItem = class
    Name: string;
    BarID: integer;
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
    tmrUpdate: TTimer;
    procedure tmrUpdateTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure lbBarListGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);

    procedure lbBarListClickItem(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem);
    procedure lbBarListResize(Sender: TObject);
    procedure lbBarListGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbBarListGetCellText(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem;
      var AColText: string);
    procedure FormShow(Sender: TObject);
  private
    function IsBarRunning(ID: integer): boolean;

    function PointInRect(P: TPoint; Rect: TRect): boolean;
    procedure BuildBarList;
  public
    FBarList: TObjectList;
    
    function BarSpaceCheck: boolean;

  end;

  procedure AddItemsToList(AList: TObjectList);

var
  frmBarList: TfrmBarList;
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

uses uSharpBarListEditWnd,
  SharpThemeApi;

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

procedure TfrmBarList.lbBarListClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  wnd: hwnd;
  Dir: string;
  FName: string;
  iBarID: Integer;
  XML: TJvSimpleXML;
  fileloaded: boolean;
  tmpBar: TBarItem;
  bDelete: Boolean;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin
  tmpBar := TBarItem(AItem.Data);
  if tmpBar = nil then
    exit;

  case ACol of
    colEdit: begin
        if (IsBarRunning(tmpBar.BarID)) then
          CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory
            + '\_Components\BarEdit.con'), pchar(inttostr(tmpBar.BarID)));
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
    colEnableDisable: begin

        if tmpBar.AutoStart then begin
          wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(tmpBar.BarID)));
          if wnd <> 0 then
            SendMessage(wnd, WM_SHARPTERMINATE, 0, 0);
        end;

        tmpBar.AutoStart := not (tmpBar.AutoStart);
        Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(tmpBar.BarID) + '\';
        FName := Dir + 'bar.xml';

        XML := TJvSimpleXML.Create(nil);
        if FileCheck(FName,True) then begin
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
        if FileCheck(FName) then        
          XML.SaveToFile(FName);
        XML.Free;

        tmrUpdate.Enabled := True;
      end;
  end;

  if frmEditItem <> nil then
    frmEditItem.InitUi( frmEditItem.EditMode);

  CenterUpdateEditTabs(lbBarList.Count,lbBarList.ItemIndex);
  CenterUpdateConfigFull;
end;

procedure TfrmBarList.lbBarListGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmpBar: TBarItem;
begin

  tmpBar := TBarItem(AItem.Data);
  if tmpBar = nil then
    exit;

  case ACol of
    colStartStop, colEnableDisable, colDelete: ACursor := crHandPoint;
    colEdit: if (IsBarRunning(tmpBar.BarID)) then
        ACursor := crHandPoint;
  end;
end;

procedure TfrmBarList.lbBarListGetCellImageIndex(Sender: TObject; const ACol: Integer;
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

procedure TfrmBarList.lbBarListGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpBar: TBarItem;
  s: String;
begin

  tmpBar := TBarItem(AItem.Data);
  if tmpBar = nil then
    exit;

  case ACol of
    colName: begin
        s := 'ID: ' + IntToStr(tmpBar.BarID);
        if tmpBar.Name <> '' then
          s := tmpBar.Name;
        if tmpBar.ModuleCount = 0 then
          AColText := s
        else if tmpBar.ModuleCount > 0 then
          AColText := format('%s (%d)<br><font color="clGray">%s', [s, tmpbar.ModuleCount,
            tmpBar.Modules]);
      end;
    colStartStop: begin

        if not (tmpBar.AutoStart) then
          AColText := ''
        else if IsBarRunning(tmpBar.BarID) then
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
          AColText := '<font color="clGray"><u>Edit</u>'
        else if IsBarRunning(tmpBar.BarID) then
          AColText := '<font color="clNavy"><u>Edit</u>'
        else
          AColText := '<font color="clGray"><u>Edit</u>'
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
  Self.DoubleBuffered := true;
  lbBarList.DoubleBuffered := true;
end;

procedure TfrmBarList.FormDestroy(Sender: TObject);
begin
  FBarList.Free;
end;

procedure TfrmBarList.FormShow(Sender: TObject);
begin
  BuildBarList;
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

procedure TfrmBarList.BuildBarList;
var
  newItem: TSharpEListItem;
  selectedIndex, i: Integer;
  tmpBar: TBarItem;
begin

  // Get selected item
  LockWindowUpdate(Self.Handle);
  if lbBarList.ItemIndex <> -1 then
    selectedIndex := TBarItem(lbBarList.Item[lbBarList.ItemIndex].Data).BarID
  else
    selectedIndex := -1;

  lbBarList.Clear;
  AddItemsToList(FBarList);

  for i := 0 to FBarList.Count - 1 do begin

    tmpBar := TBarItem(FBarList.Items[i]);

    newItem := lbBarList.AddItem(tmpBar.Name);
    newItem.Data := tmpBar;
    newItem.AddSubItem('');
    newItem.AddSubItem('');
    newItem.AddSubItem('');
    newItem.AddSubItem('');

    if tmpBar.BarID = selectedIndex then
      lbBarList.ItemIndex := i;

  end;
  LockWindowUpdate(0);

  if lbBarList.ItemIndex = -1 then
    if lbBarList.Count <> 0 then
      lbBarList.ItemIndex := 0;

  if frmBarList <> nil then begin
    CenterUpdateEditTabs(frmBarList.lbBarList.Count,frmBarList.lbBarList.ItemIndex);
    CenterUpdateConfigFull;
  end;
end;

procedure TfrmBarList.tmrUpdateTimer(Sender: TObject);
begin
  tmrUpdate.Enabled := False;
  BuildBarList;

  if frmEditItem <> nil then
    frmEditItem.InitUi( frmEditItem.EditMode);

  CenterUpdateEditTabs(lbBarList.Count,lbBarList.ItemIndex);
  CenterUpdateConfigFull;
end;

{ TBarItem }

procedure AddItemsToList(AList: TObjectList);
var
  xml: TJvSimpleXML;
  newItem: TBarItem;
  dir: string;
  slBars, slModules: TStringList;
  i, j: Integer;

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
  AList.Clear;
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  newItem := nil;
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
            BarID := ExtractBarID(slBars[i]);
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

      AList.Add(newItem);
    end;

  finally
    slBars.Free;
    slModules.Free;
    xml.Free;
  end;
end;

end.

