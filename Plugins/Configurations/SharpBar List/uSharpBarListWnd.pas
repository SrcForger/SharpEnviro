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
  SharpEListBox, SharpEListBoxEx,GR32, GR32_PNG, SharpApi, SharpCenterApi,
  ExtCtrls, Menus, Contnrs, Types;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TBarItem = class
               Name : String;
               ID   : integer;
               Monitor : integer;
               PMonitor : boolean;
               HPos : integer;
               VPos : integer;
               AutoStart : boolean;
             end;

  TfrmBarList = class(TForm)
    StatusImages: TPngImageList;
    lbBarList: TSharpEListBoxEx;
    pilDefault: TPngImageList;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbBarListDblClickItem(const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbBarListGetCellCursor(const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbBarListGetCellFont(const ACol: Integer; AItem: TSharpEListItem;
      var AFont: TFont);
    procedure lbBarListGetCellTextColor(const ACol: Integer;
      AItem: TSharpEListItem; var AColor: TColor);
    procedure lbBarListClickItem(const ACol: Integer; AItem: TSharpEListItem);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
  private

  public
    BarList: TObjectList;
    procedure BuildBarList;
    procedure UpdateBarStatus;
    function UpdateUI:Boolean;
    function SaveUi: Boolean;
    procedure ConfigureItem;
    Property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
  end;

var
  frmBarList: TfrmBarList;

implementation

uses uSharpBarListEditWnd, SharpThemeApi;

{$R *.dfm}

{ TfrmConfigListWnd }

function IsBarRunning(ID : integer) : boolean;
var
  h : hwnd;
begin
  h := FindWindow(nil,PChar('SharpBar_'+inttostr(ID)));
  result := h <> 0;
end;

function GetBarIIndex(Item : TBarItem) : integer;
begin
  if IsBarRunning(Item.ID) then
  begin
    result := 0;
    exit;
  end;

  if Item.AutoStart then
     result := 1
     else result := 2;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TfrmBarList.FormShow(Sender: TObject);
begin
  lbBarList.Margin := Rect(0,0,0,0);
  lbBarList.ColumnMargin := Rect(6,0,6,0);
end;

procedure TfrmBarList.lbBarListClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
var
  BarItem : TBarItem;
  wnd : hwnd;
  Dir : String;
  FName : String;
  XML : TJvSimpleXML;
  fileloaded : boolean;
  enable : boolean;
begin
 if frmEditItem <> nil then
 begin
   UpdateUI;
   exit;
 end;

  if (ACol = 4 ) then
  begin
    if (CompareText(AItem.SubItemText[4],'Configure') = 0) then
    begin
      BarItem :=  TBarItem(AItem.Data);
      CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory
                    + '\_Components\Module Manager.con'), pchar(inttostr(BarItem.ID)));
    end;
  end;

  // Start / Stop / Disable / Enable clicked
  if (ACol = 2) or (ACol = 3) then
  begin
    BarItem :=  TBarItem(AItem.Data);
    if (CompareText(AItem.SubItemText[2],'Start') = 0) and (ACol = 2) then
    begin
      SharpApi.SharpExecute('_nohist,' + SharpApi.GetSharpeDirectory + 'SharpBar.exe'+
                            ' -load:' + inttostr(BarItem.ID) +
                            ' -noREB' +
                            ' -noLASB');
      UpdateBarStatus;
    end
    else if (CompareText(AItem.SubItemText[2],'Stop') = 0) and (ACol = 2)  then
    begin
      wnd := FindWindow(nil,PChar('SharpBar_' + inttostr(BarItem.ID)));
      if wnd <> 0 then
         SendMessage(wnd,WM_SHARPTERMINATE,0,0);

      UpdateBarStatus;
    end
    else
    begin
      enable := (CompareText(AItem.SubItemText[3],'Enable') = 0) and (ACol = 3);
      if not enable then
      begin
        wnd := FindWindow(nil,PChar('SharpBar_' + inttostr(BarItem.ID)));
        if wnd <> 0 then
           SendMessage(wnd,WM_SHARPTERMINATE,0,0);
      end;
      Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(BarItem.ID) +'\';
      FName := Dir + 'bar.xml';

      XML := TJvSimpleXML.Create(nil);
      if FileExists(FName) then
      begin
        try
          XML.LoadFromFile(FName);
          fileloaded := True;
        except
          fileloaded := False;
        end;
        if fileloaded then
          with XML.Root.Items do
          begin
            if ItemNamed['Settings'] = nil then
              Add('Settings');
            with ItemNamed['Settings'].Items do
            begin
              if ItemNamed['AutoStart'] <> nil then
                ItemNamed['AutoStart'].BoolValue := enable
              else Add('AutoStart',enable);
            end;
          end;
      end;
      XML.SaveToFile(FName);
      XML.Free;

      BuildBarList;
    end;
  end;
end;

procedure TfrmBarList.lbBarListDblClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
begin
  ConfigureItem;
end;

procedure TfrmBarList.lbBarListGetCellCursor(const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if (ACol = 2) or (ACol = 3) or (ACol = 4) then
    ACursor := crHandPoint;
end;

procedure TfrmBarList.lbBarListGetCellFont(const ACol: Integer;
  AItem: TSharpEListItem; var AFont: TFont);
begin
  if (ACol = 2) or (ACol = 3) or (ACol = 4) then
    AFont.Style := [fsUnderline];
end;

procedure TfrmBarList.lbBarListGetCellTextColor(const ACol: Integer;
  AItem: TSharpEListItem; var AColor: TColor);
begin
  if (ACol = 2) or (ACol = 3) or (ACol = 4) then
  begin
    if frmEditItem = nil then
      AColor := clNavy
    else AColor := clGray;
  end;
end;

procedure TfrmBarList.FormCreate(Sender: TObject);
begin
  BarList := TObjectList.Create(True);
  BuildBarList;
  Self.DoubleBuffered := true;
end;

procedure TfrmBarList.FormDestroy(Sender: TObject);
begin
  BarList.Free;
end;

procedure TfrmBarList.UpdateBarStatus;
var
  n : integer;
  iindex : integer;
  SelItem : TBarItem;
  SList : TStringList;
  c : boolean;
  i : integer;
begin
  if lbBarList.ItemIndex >= 0 then
     SelItem := TBarItem(lbBarList.Item[lbBarList.ItemIndex].Data)
     else SelItem := nil;

  c := False;

  for n := 0 to lbBarList.Count - 1 do
  begin
    iindex := GetBarIIndex(TBarItem(lbBarList.Item[n].Data));
    if lbBarList.Item[n].SubItemImageIndex[0] <> iindex then
    begin
      lbBarList.Item[n].SubItemImageIndex[0] := iindex;
      c := true;
    end;
  end;

  if c then
  begin
    BuildBarList;
    exit;
    SList := TStringList.Create;
    for n := 0 to lbBarList.Count - 1 do
    begin
      SList.AddObject(inttostr(lbBarList.Item[n].SubItemImageIndex[0]) + lbBarList.Item[n].SubItemText[1],
                               lbBarList.Item[n].Data);
    end;
    SList.Sort;
    for n := 0 to SList.Count - 1 do
    begin
      for i := n to lbBarList.Count - 1 do
          if lbBarList.Item[i] = SList.Objects[n] then
          begin
            lbBarList.Items.Move(i,n);
            break;
          end;
    end;
     SList.Free;
    lbBarList.Repaint;

    if SelItem <> nil then
       for n := 0 to lbBarList.Count - 1 do
       begin
         if SelItem = TBarItem(lbBarList.Item[n].Data) then
         begin
           lbBarList.ItemIndex := n;
           exit;
         end;
       end;
  end;
end;

procedure TfrmBarList.BuildBarList;
var
  n: Integer;
  newItem:TSharpEListItem;
  XML : TJvSimpleXML;
  Dir : String;
  iindex : integer;
  BarItem : TBarItem;
  SList : TStringList;
  sr : TSearchRec;
  fileloaded : boolean;
  lastselected : integer;
begin
  if lbBarList.ItemIndex <> - 1 then
    lastselected := TBarItem(lbBarList.Item[lbBarList.ItemIndex].Data).ID
  else lastselected := - 1;

  lbBarList.Clear;
  BarList.Clear;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  XML := TJvSimpleXML.Create(nil);
  if FindFirst(Dir + '*',FADirectory,sr) = 0 then
  repeat
    XML.Root.Clear;
    if FileExists(Dir + sr.Name + '\Bar.xml') then
    begin
      try
        xml.LoadFromFile(Dir + sr.Name + '\Bar.xml');
        fileloaded := True;
      except
        fileloaded := False;
      end;
      if fileloaded then
      begin
        if XML.Root.Items.ItemNamed['Settings'] <> nil then
          with XML.Root.Items.ItemNamed['Settings'].Items do
          begin
            BarItem := TBarItem.Create;
            with BarItem do
            begin
              Name := Value('Name','Toolbar');
              ID := strtoint(sr.Name);
              Monitor := IntValue('MonitorIndex',0);
              PMonitor := BoolValue('PrimaryMonitor',True);
              HPos := IntValue('HorizPos',0);
              VPos := IntValue('VertPos',0);
              AutoStart := BoolValue('AutoStart',True);
            end;
            BarList.Add(BarItem);            
        end;
      end;
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
  XML.free;

  SList := TStringList.Create;
  for n := 0 to BarList.Count - 1 do
  begin
    iindex := GetBarIIndex(TBarItem(BarList.Items[n]));
    SList.AddObject(inttostr(iindex) + TBarItem(BarList.Items[n]).Name,BarList.Items[n]);
  end;
  SList.Sort;
  for n := 0 to SList.Count - 1 do
      BarList.Move(BarList.IndexOf(SList.Objects[n]),n);
  SList.Free;

  for n := 0 to BarList.Count - 1 do
      with TBarItem(BarList.Items[n]) do
      begin
        iindex := GetBarIIndex(TBarItem(BarList.Items[n]));
        newItem := lbBarList.AddItem('',iindex);
        newItem.Data := TBarItem(BarList.Items[n]);
        newItem.AddSubItem(Name);
        case iindex of
          0: begin
               newItem.AddSubItem('Stop');
               newItem.AddSubItem('Disable');
               newItem.AddSubItem('Configure');               
             end;
          1: begin
               newItem.AddSubItem('Start');
               newItem.AddSubItem('Disable');
               newItem.AddSubItem('');
             end;
          2: begin
               newItem.AddSubItem('');
               newItem.AddSubItem('Enable');
               newItem.AddSubItem('');               
             end;
        end;
        if ID = lastselected then
          lbBarList.ItemIndex := n;    
      end;

  if lbBarList.Items.Count = 0 then
  begin
    CenterDefineButtonState(scbEditTab,False);
    CenterDefineButtonState(scbDeleteTab,False);
  end else
  begin
    if lbBarList.ItemIndex = - 1 then
      lbBarList.ItemIndex := 0;
    CenterDefineButtonState(scbEditTab,True);
    CenterDefineButtonState(scbDeleteTab,True);
  end;
end;

function BarSpaceCheck : boolean;
var
  BR : array of TBarRect;
  Mon : TMonitor;
  n : integer;
  lp : TPoint;

  function BarAtPos(x,y : integer) : boolean;
  var
    i : integer;
  begin
    for i := 0 to High(BR) do
        if PointInRect(Point(BR[i].R.Left + (BR[i].R.Right - BR[i].R.Left) div 2,
                             BR[i].R.Top + (BR[i].R.Bottom - BR[i].R.Top) div 2),
                             Mon.BoundsRect) then
           if PointInRect(Point(x,y),BR[i].R)
              or PointInRect(Point(x-75,y),BR[i].R)
              or PointInRect(Point(x+75,y),BR[i].R) then
           begin
             result := true;
             exit;
           end;
    lp := Point(x,y);
    result := false;
  end;

begin
  result := False;
  setlength(BR,0);
  for n := 0 to SharpApi.GetSharpBarCount - 1 do
  begin
    setlength(BR,length(BR)+1);
    BR[High(BR)] := SharpApi.GetSharpBarArea(n);
  end;

  lp := point(-1,-1);
  for n := - 1 to Screen.MonitorCount - 1 do
  begin
    // start with the current monitor
    if n = - 1 then Mon := frmBarList.Monitor
       else Mon := Screen.Monitors[n];
    if (n <> -1) and (Mon = frmBarList.Monitor) then Continue; // don't test the current monitor twice
    if BarAtPos(Mon.Left,Mon.Top) then
       if BarAtPos(Mon.Left + Mon.Width div 2, Mon.Top) then
       if BarAtPos(Mon.Left + Mon.Width, Mon.Top) then
       if BarAtPos(Mon.Left,Mon.Top + Mon.Height) then
       if BarAtPos(Mon.Left + Mon.Width div 2, Mon.Top + Mon.Height) then
          BarAtPos(Mon.Left + Mon.Width, Mon.Top + Mon.Height);
    if (lp.x <> - 1) and (lp.y  <> - 1) then
       break;
  end;
  setlength(BR,0);
  if (lp.x = - 1) and (lp.y  = - 1) then
     exit;

  result := True;
end;

function TfrmBarList.UpdateUI: Boolean;
var
  tmpItem: TSharpEListItem;
 // tmpThemeItem: TThemeListItem;
  n : integer;
  BarItem : TBarItem;
begin
  Result := False;
  case FEditMode of
  sceAdd :
    begin
      if BarSpaceCheck then
      begin
        frmEditItem.pagEdit.Show;
        FrmEditItem.edName.Text := '';

        frmEditItem.cbBasedOn.Items.Clear;
        frmEditItem.cbBasedOn.Items.AddObject('New Bar',nil);
        for n := 0 to lbBarList.Count - 1 do
            frmEditItem.cbBasedOn.Items.AddObject(lbBarList.Item[n].SubItemText[1],
                                                lbBarList.Item[n].Data);
        frmEditItem.cbBasedOn.ItemIndex := 0;
        frmEditItem.cbBasedOn.Enabled := True;
        frmEditItem.BarItem := nil;

        frmEditItem.BuildMonList;
        frmEditItem.cobo_monitor.ItemIndex := 0;
        frmEditItem.edName.SetFocus;
      end else
      begin
        frmEditItem.pagBarSpace.Show;
      end;
//      frmBarList.lbBarList.Enabled := False;
      Result := True;
    end;
  sceEdit:
    begin
      if lbBarList.ItemIndex <> -1 then
      begin
        tmpItem := lbBarList.Item[lbBarList.ItemIndex];
        BarItem := TBarItem(tmpItem.Data);

        frmEditItem.pagEdit.Show;
        FrmEditItem.edName.Text := BarItem.Name;
        FrmEditItem.edName.SetFocus;
        frmEditItem.BarItem := BarItem;

        frmEditItem.BuildMonList;
        if BarItem.PMonitor then
           frmEditItem.cobo_monitor.ItemIndex := 0
           else frmEditItem.cobo_monitor.ItemIndex := Min(abs(BarItem.Monitor),frmEditItem.cobo_monitor.Items.Count-1);
        frmEditItem.cobo_valign.ItemIndex := BarItem.VPos;
        frmEditItem.cobo_halign.ItemIndex := BarItem.HPos;

        frmEditItem.cbBasedOn.Items.Clear;
        frmEditItem.cbBasedOn.Items.AddObject('Not Applicable',nil);
        frmEditItem.cbBasedOn.ItemIndex := 0;
        frmEditItem.cbBasedOn.Enabled := False;

//        frmBarList.lbBarList.Enabled := False;

        Result := True;
      end;
    end;
  sceDelete:
    begin
      if frmBarList.lbBarList.ItemIndex <> -1 then
      begin
        Result := True;
        frmEditItem.pagDelete.Show;
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

function TfrmBarList.SaveUi: Boolean;
var
  XML : TJvSimpleXML;
  Dir : String;
  NewID : String;
  CID : integer;
  n : integer;
  BarItem : TBarItem;
  wnd : hwnd;
  sr : TSearchRec;
  fileloaded : boolean;
begin
  Result := True;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  case FEditMode of
    sceAdd:
      begin
        // Generate a new unique bar ID and make sure that there is no other
        // bar with the same ID
        repeat
          NewID := '';
          for n := 1 to 8 do NewID := NewID + inttostr(random(9)+1);
        until not DirectoryExists(Dir + NewID);

        if FrmEditItem.cbBasedOn.ItemIndex > 0 then
        begin
          CID := TBarItem(FrmEditItem.cbBasedOn.Items.Objects[FrmEditItem.cbBasedOn.ItemIndex]).ID;

          if FindFirst(Dir + inttostr(CID) + '\*.xml',FAAnyFile,sr) = 0 then
          repeat
            if FileExists(Dir + inttostr(CID) + '\' + sr.Name) then
              CopyFile(PChar(Dir + inttostr(CID) + '\' + sr.Name),
                       PChar(Dir + NewID + '\' + sr.Name),True);
          until FindNext(sr) <> 0;
          FindClose(sr);
        end;

        XML := TJvSimpleXML.Create(nil);
        if FileExists(Dir + NewID + '\Bar.xml') then
        begin
          try
            XML.LoadFromFile(Dir + NewID + '\Bar.xml');
            fileloaded := True;
          except
            fileloaded := False;
          end;
        end else fileloaded := False;

        if not fileloaded then
          XML.Root.Name := 'SharpBar';

        with XML.Root.Items do
        begin
          if ItemNamed['Settings'] = nil then
            Add('Settings');

          with ItemNamed['Settings'].Items do
          begin
            clear;
            Add('ID',NewID);
            Add('Name',FrmEditItem.edName.Text);
            Add('ShowThrobber',True);
            Add('DisableHideBar',False);
            Add('AutoStart',True);
            Add('AutoPosition',True);
            Add('PrimaryMonitor',(FrmEditItem.cobo_monitor.ItemIndex = 0));
            Add('MonitorIndex',TIntObject(FrmEditItem.cobo_monitor.Items.Objects[FrmEditItem.cobo_monitor.ItemIndex]).Value);
            Add('HorizPos',FrmEditItem.cobo_halign.ItemIndex);
            Add('VertPos',FrmEditItem.cobo_valign.ItemIndex);
          end;

          if ItemNamed['Modules'] = nil then
            Add('Modules');
        end;
        ForceDirectories(Dir + NewID);
        XML.SaveToFile(Dir + NewID + '\Bar.xml');
        XML.Free;
      end;
    sceEdit:
      begin
        CID := TBarItem(frmEditItem.BarItem).ID;
        XML := TJvSimpleXML.Create(nil);
        fileloaded := False;
        if FileExists(Dir + inttostr(CID) + '\Bar.xml') then
        begin
          try
            XML.LoadFromFile(Dir + inttostr(CID) + '\Bar.xml');
            fileloaded := True;
          except
          end;
        end;
        if FileLoaded then
          with XML.Root.Items do
          begin
            if ItemNamed['Settings'] = nil then
              Add('Settings');

            with ItemNamed['Settings'].Items do
            begin
              Clear;
              Add('ID',NewID);
              Add('Name',FrmEditItem.edName.Text);
              Add('ShowThrobber',True);
              Add('DisableHideBar',False);
              Add('AutoStart',True);
              Add('AutoPosition',True);
              Add('PrimaryMonitor',(FrmEditItem.cobo_monitor.ItemIndex = 0));
              Add('MonitorIndex',TIntObject(FrmEditItem.cobo_monitor.Items.Objects[FrmEditItem.cobo_monitor.ItemIndex]).Value);
              Add('HorizPos',FrmEditItem.cobo_halign.ItemIndex);
              Add('VertPos',FrmEditItem.cobo_valign.ItemIndex);
            end;
          end;
        XML.SaveToFile(Dir + inttostr(CID) + '\Bar.xml');
        XML.Free;
      end;
    sceDelete:
      begin
        BarItem := TBarItem(lbBarList.Item[lbBarList.ItemIndex].Data);
        if IsBarRunning(BarItem.ID) then
        begin
          wnd := FindWindow(nil,PChar('SharpBar_'+inttostr(BarItem.ID)));
          SendMessage(wnd,WM_SHARPTERMINATE,0,0);
          // give it a second to shutdown
          sleep(500);
        end;
        DeleteDirectory(Dir + inttostr(BarItem.ID),True);
      end;
  end;

  if FEditMode = sceAdd then
     SharpApi.SharpExecute('_nohist,' + SharpApi.GetSharpeDirectory + 'SharpBar.exe'+
                           ' -load:' + NewID +
                           ' -noREB' +
                           ' -noLASB')
     else if FEditMode = sceEdit then
     begin
       wnd := FindWindow(nil,PChar('SharpBar_' + inttostr(CID)));
       if wnd <> 0 then
          SendMessage(wnd,WM_BARREPOSITION,0,0);
     end;
                           
  BuildBarList;
end;

procedure TfrmBarList.ConfigureItem;
begin
  if lbBarList.ItemIndex < 0 then exit;

//  sBar := TThemeListItem(lbThemeList.Item[lbThemeList.ItemIndex].Data).Name;
//  SharpApi.CenterMsg(sccLoadSetting,PChar(SharpApi.GetCenterDirectory
//    + '_Themes\Theme.con'),pchar(sTheme))
end;

procedure TfrmBarList.Timer1Timer(Sender: TObject);
begin
  UpdateBarStatus;
end;

end.

