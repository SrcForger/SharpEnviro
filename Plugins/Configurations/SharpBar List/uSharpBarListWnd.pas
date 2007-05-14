﻿{
Source Name: SharpBarBarList
Description: SharpBar Manager Config Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uSharpBarListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, uSEListboxPainter, JclFileUtils, Math,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx,GR32, GR32_PNG, SharpApi,
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
    ListPopup: TPopupMenu;
    procedure ListPopupPopup(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

    procedure lbBarListDblClickItem(AText: string; AItem, ACol: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
    procedure OnListPopupStartClick(Sender : TObject);
    procedure OnListPopupStopClick(Sender : TObject);
    procedure OnListPopupEnableClick(Sender : TObject);
    procedure OnListPopupDisableClick(Sender : TObject);
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
  FName : String;
  iindex : integer;
  BarItem : TBarItem;
  SList : TStringList;
begin
  lbBarList.Clear;
  BarList.Clear;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';
  FName := Dir + 'bars.xml';

  XML := TJvSimpleXML.Create(nil);
  try
    if FileExists(FName) then
    begin
      XML.LoadFromFile(FName);
      if XML.Root.Items.ItemNamed['bars'] <> nil then
         for n := 0 to XML.Root.Items.ItemNamed['bars'].Items.Count - 1 do
             with XML.Root.Items.ItemNamed['bars'].Items.Item[n].Items do
             begin
               BarItem := TBarItem.Create;
               with BarItem do
               begin
                 Name := Value('Name','Toolbar');
                 ID   := IntValue('ID',-1);
                 if ItemNamed['Settings'] <> nil then
                    with ItemNamed['Settings'].Items do
                    begin
                      Monitor := IntValue('MonitorIndex',0);
                      PMonitor := BoolValue('PrimaryMonitor',True);
                      HPos := IntValue('HorizPos',0);
                      VPos := IntValue('VertPos',0);
                      AutoStart := BoolValue('AutoStart',True);
                    end;
               end;
               BarList.Add(BarItem);
             end;
    end
  finally
    XML.Free;
  end;

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
        newItem.AddSubItem(inttostr(ID));
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
      frmBarList.lbBarList.Enabled := False;
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

        frmBarList.lbBarList.Enabled := False;

        Result := True;
      end;
    end;
  sceDelete:
    begin
      if frmBarList.lbBarList.ItemIndex <> -1 then
      begin
        Result := True;
        frmEditItem.pagDelete.Show;
        SharpEBroadCast(WM_SHARPCENTERMESSAGE,SCM_SET_BUTTON_ENABLED,SCB_DELETE);
      end
      else
      begin
        Result := False;
        SharpEBroadCast(WM_SHARPCENTERMESSAGE,SCM_SET_BUTTON_DISABLED,SCB_DELETE);
      end;
    end;
  end;
end;

function TfrmBarList.SaveUi: Boolean;
var
  XML : TJvSimpleXML;
  Dir : String;
  FName : String;
  NewID : String;
  MString : String;
  CID : integer;
  b : boolean;
  n : integer;
  BarItem : TBarItem;
  wnd : hwnd;
begin
  Result := True;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';
  FName := Dir + 'bars.xml';

  XML := TJvSimpleXML.Create(nil);
  try
    if FileExists(FName) then
    begin
      XML.LoadFromFile(FName);
      if XML.Root.Items.ItemNamed['bars'] = nil then
         XML.Root.Items.Add('bars');

      case FEditMode of
        sceAdd:
          begin
            // Generate a new unique bar ID and make sure that there is no other
            // bar with the same ID
            repeat
              NewID := '';
              for n := 1 to 8 do NewID := NewID + inttostr(random(9)+1);

              b := False;
              with xml.root.items.ItemNamed['bars'] do
              begin
                for n := 0 to Items.Count - 1 do
                    if Items.Item[n].Items.Value('ID','0') = NewID then
                    begin
                      b := True;
                      break;
                    end;
              end;
            until not b;

            with xml.root.items.ItemNamed['bars'].Items.Add('item').Items do
            begin
              Add('ID',NewID);
              Add('Name',FrmEditItem.edName.Text);
              with Add('Settings').Items do
              begin
                Add('ShowThrobber',True);
                Add('DisableHideBar',False);
                Add('AutoStart',True);
                Add('AutoPosition',True);
                Add('PrimaryMonitor',(FrmEditItem.cobo_monitor.ItemIndex = 0));
                Add('MonitorIndex',FrmEditItem.cobo_monitor.ItemIndex + 1);
                Add('HorizPos',FrmEditItem.cobo_halign.ItemIndex);
                Add('VertPos',FrmEditItem.cobo_valign.ItemIndex);
              end;
              Add('Modules');
              if FrmEditItem.cbBasedOn.ItemIndex > 0 then
              begin
                CID := TBarItem(FrmEditItem.cbBasedOn.Items.Objects[FrmEditItem.cbBasedOn.ItemIndex]).ID;
                for n := 0 to XML.root.Items.ItemNamed['bars'].Items.Count - 1 do
                    if XML.root.Items.ItemNamed['bars'].Items.Item[n].Items.IntValue('ID',-1) = CID then
                       if XML.root.Items.ItemNamed['bars'].Items.Item[n].Items.ItemNamed['Modules'] <> nil then
                       begin
                         MString := XML.root.Items.ItemNamed['bars'].Items.Item[n].Items.ItemNamed['Modules'].SaveToString;
                         ItemNamed['Modules'].LoadFromString(MString);
                       end;
                CopyFile(PChar(Dir + 'Module Settings\' + inttostr(CID) + '.xml'),
                         PChar(Dir + 'Module Settings\' + NewID + '.xml'),True);
              end;
            end;
          end;
        sceEdit:
          begin
            CID := TBarItem(frmEditItem.BarItem).ID;
            if XML.Root.Items.ItemNamed['bars'] <> nil then
               with XML.root.items.ItemNamed['bars'].Items do
                    for n := 0 to Count - 1 do
                        if Item[n].Items.IntValue('ID',-1) = CID then
                        begin
                          if Item[n].Items.ItemNamed['Name'] <> nil then
                             Item[n].Items.ItemNamed['Name'].Value := FrmEditItem.edName.Text
                             else Item[n].Items.Add('Name',FrmEditItem.edName.Text);
                          if Item[n].Items.ItemNamed['Settings'] = nil then
                             Item[n].Items.Add('Settings');
                          with Item[n].Items.ItemNamed['Settings'].Items do
                          begin
                            Clear;
                            Add('ShowThrobber',True);
                            Add('DisableHideBar',False);
                            Add('AutoStart',True);
                            Add('AutoPosition',True);
                            Add('PrimaryMonitor',(FrmEditItem.cobo_monitor.ItemIndex = 0));
                            Add('MonitorIndex',FrmEditItem.cobo_monitor.ItemIndex + 1);
                            Add('HorizPos',FrmEditItem.cobo_halign.ItemIndex);
                            Add('VertPos',FrmEditItem.cobo_valign.ItemIndex);
                          end;
                          break;
                        end;
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
            with xml.root.items.ItemNamed['bars'] do
                 for n := 0 to Items.Count - 1 do
                     if Items.Item[n].Items.IntValue('ID',-1) = BarItem.ID then
                     begin
                       Items.Delete(n);
                       break;
                     end;
            if FileExists(Dir + 'Module Settings\' + inttostr(BarItem.ID) + '.xml') then
               DeleteFile(PChar(Dir + 'Module Settings\' + inttostr(BarItem.ID) + '.xml'));
          end;
      end;
    end;
  except
    XML.Free;
    Exit;
  end;

  if not DirectoryExists(Dir) then
     ForceDirectories(Dir);
  XML.SaveToFile(FName + '~');
  if FileExists(FName) then
     DeleteFile(FName);
  RenameFile(FName + '~',FName);

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

procedure TfrmBarList.lbBarListDblClickItem(AText: string; AItem,
  ACol: Integer);
begin
  ConfigureItem;
end;

procedure TfrmBarList.ConfigureItem;
var
  sBar: String;
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

procedure TfrmBarList.OnListPopupStartClick(Sender : TObject);
begin
  SharpApi.SharpExecute('_nohist,' + SharpApi.GetSharpeDirectory + 'SharpBar.exe'+
                        ' -load:' + inttostr(TMenuItem(Sender).Tag) +
                        ' -noREB' +
                        ' -noLASB');

  UpdateBarStatus;
end;

procedure TfrmBarList.OnListPopupStopClick(Sender : TObject);
var
  wnd : hwnd;
begin
  wnd := FindWindow(nil,PChar('SharpBar_' + inttostr(TMenuItem(Sender).Tag)));
  if wnd <> 0 then
     SendMessage(wnd,WM_SHARPTERMINATE,0,0);

  UpdateBarStatus;
end;

procedure TfrmBarList.OnListPopupEnableClick(Sender : TObject);
var
  Dir : String;
  FName : String;
  XML : TJvSimpleXML;
  n : integer;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';
  FName := Dir + 'bars.xml';

  XML := TJvSimpleXML.Create(nil);
  try
    if FileExists(FName) then
    begin
      XML.LoadFromFile(FName);
      if XML.Root.Items.ItemNamed['bars'] <> nil then
         with XML.Root.Items.ItemNamed['bars'].Items do
              for n := 0 to Count - 1 do
                  if Item[n].Items.IntValue('ID',-1) = TMenuItem(Sender).Tag then
                  begin
                    if Item[n].Items.ItemNamed['Settings'] = nil then
                       Item[n].Items.Add('Settings');
                    with Item[n].Items.ItemNamed['Settings'].Items do
                    begin
                      if ItemNamed['AutoStart'] <> nil then
                         ItemNamed['AutoStart'].BoolValue := True
                         else Add('AutoStart',True);
                    end;
                  end;
    end;
  except
    XML.Free;
  end;

  if not DirectoryExists(Dir) then
     ForceDirectories(Dir);
  XML.SaveToFile(FName + '~');
  if FileExists(FName) then
     DeleteFile(FName);
  RenameFile(FName + '~',FName);

  BuildBarList;
end;

procedure TfrmBarList.OnListPopupDisableClick(Sender : TObject);
var
  Dir : String;
  FName : String;
  XML : TJvSimpleXML;
  n : integer;
begin
  OnListPopupStopClick(Sender);

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';
  FName := Dir + 'bars.xml';

  XML := TJvSimpleXML.Create(nil);
  try
    if FileExists(FName) then
    begin
      XML.LoadFromFile(FName);
      if XML.Root.Items.ItemNamed['bars'] <> nil then
         with XML.Root.Items.ItemNamed['bars'].Items do
              for n := 0 to Count - 1 do
                  if Item[n].Items.IntValue('ID',-1) = TMenuItem(Sender).Tag then
                  begin
                    if Item[n].Items.ItemNamed['Settings'] = nil then
                       Item[n].Items.Add('Settings');
                    with Item[n].Items.ItemNamed['Settings'].Items do
                    begin
                      if ItemNamed['AutoStart'] <> nil then
                         ItemNamed['AutoStart'].BoolValue := False
                         else Add('AutoStart',False);
                    end;
                  end;
    end;
  except
    XML.Free;
  end;

  if not DirectoryExists(Dir) then
     ForceDirectories(Dir);
  XML.SaveToFile(FName + '~');
  if FileExists(FName) then
     DeleteFile(FName);
  RenameFile(FName + '~',FName);

  BuildBarList;
end;

procedure TfrmBarList.ListPopupPopup(Sender: TObject);
var
  BarItem : TBarItem;
  mitem : TMenuItem;

  procedure AddEnableItem;
  begin
    mitem := TMenuItem.Create(ListPopup);
    mitem.Caption := 'Enable';
    mitem.ImageIndex := 1;
    mitem.OnClick := OnListPopupEnableClick;
    mitem.Tag := BarItem.ID;
    ListPopup.Items.Add(mitem);
  end;

  procedure AddDisableItem;
  begin
    mitem := TMenuItem.Create(ListPopup);
    mitem.Caption := 'Disable';
    mitem.ImageIndex := 2;
    mitem.OnClick := OnListPopupDisableClick;
    mitem.Tag := BarItem.ID;
    ListPopup.Items.Add(mitem);
  end;

  procedure AddStartItem;
  begin
    mitem := TMenuItem.Create(ListPopup);
    mitem.Caption := 'Start';
    mitem.ImageIndex := 0;
    mitem.OnClick := OnListPopupStartClick;
    mitem.Tag := BarItem.ID;
    ListPopup.Items.Add(mitem);
  end;

  procedure AddStopItem;
  begin
    mitem := TMenuItem.Create(ListPopup);
    mitem.Caption := 'Stop';
    mitem.ImageIndex := 1;
    mitem.OnClick := OnListPopupStopClick;
    mitem.Tag := BarItem.ID;
    ListPopup.Items.Add(mitem);
  end;

begin
  ListPopup.Items.Clear;
  if lbBarList.ItemIndex < 0 then
     exit;

  BarItem := TBarItem(lbBarList.Item[lbBarList.ItemIndex].Data);
  if BarItem.AutoStart then
  begin
    if IsBarRunning(BarItem.ID) then
       AddStopItem
       else AddStartItem;
    AddDisableItem;
  end else
  begin
    if IsBarRunning(BarItem.ID) then
       AddStopItem;
    AddEnableItem;
  end;
end;

end.

