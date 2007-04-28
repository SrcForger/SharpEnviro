{
Source Name: uSharpDeskSettingsForm.pas
Description: Form for changing object properties
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
 - OS : Windows 2000 or higher

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

unit uSharpDeskSettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, SharpApi,JvRollOut, Types,
  ComCtrls, ImgList, JvComponent,
  gr32,
  gr32_layers,
  uSharpDeskObjectFile,
  uSharpDeskDesktopObject,
  SharpDeskApi, SharpThemeApi, JvExExtCtrls, ToolWin;

type
  TSettingsForm = class(TForm)
    SettingsPanel: TPanel;
    Panel2: TPanel;
    bottompanel: TPanel;
    btn_ok: TButton;
    btn_cancel: TButton;
    btn_apply: TButton;
    ObjectSets: TListView;
    ImageList1: TImageList;
    ObjectRollout: TJvRollOut;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    procedure ObjectRolloutExpand(Sender: TObject);
    procedure ObjectRolloutCollapse(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btn_applyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure NewSetExecute(Sender: TObject);
    procedure ObjectSetsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ObjectSetsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    ObjectFile : TObjectFile;
    DesktopObject : TDesktopObject;
    ObjectID : Integer;
    pSettingsWnd : hwnd;
    Save : boolean;
    CreateMode : boolean;
  public
    procedure Updatesize;
    procedure BuildObjectSets;
    procedure Load(pDesktopObject : TDesktopObject); overload;
    procedure Load(pObjectFile : TObjectFile; ID,PosX,PosY : integer; pCreate : boolean); overload;
  end;


var
   SettingsForm : TSettingsForm;

implementation

uses uSharpDeskMainForm,
     uSharpDeskObjectInfoForm,
     uSharpDeskObjectSetItem,
     uSharpDeskObjectSet,
     uSharpDeskFunctions;

{$R *.dfm}


procedure TSettingsForm.Updatesize;
begin
  SettingsForm.Width := SettingsPanel.Left + SettingsPanel.Width + 2*SettingsPanel.Left;
  SettingsForm.Height := SettingsPanel.Top + SettingsPanel.Height + 76 + ObjectRollout.Height;
end;

procedure TSettingsForm.BuildObjectSets;
var
   n : integer;
   ListItem : TListItem;
   tempObjectSet : TObjectSet;
   Theme : String;
begin
  ObjectSets.Clear;
  Theme := SharpThemeApi.GetThemeName;
  for n := 0 to SharpDesk.ObjectSetList.Count - 1 do
  begin
    tempObjectSet := TObjectSet(SharpDesk.ObjectSetList[n]);
    if tempObjectSet.ThemeList.IndexOf(Theme) < 0 then continue;
    ListItem := ObjectSets.Items.Add;
    ListItem.StateIndex := tempObjectSet.SetID;
    ListItem.Caption := tempObjectSet.Name;
    if (not CreateMode) and (DesktopObject <> nil) then
       if TObjectSet(DesktopObject.Settings.Owner).SetID = tempObjectSet.SetID then
          ListItem.Selected := True;
    if (n = 0) and (CreateMode) then ListItem.Selected := True;
    ListItem.Update;
  end;
end;

procedure TSettingsForm.Load(pDesktopObject : TDesktopObject);
begin
  Load(pDesktopObject.Owner,
       pDesktopObject.Settings.ObjectID,
       pDesktopObject.Settings.Pos.X,
       pDesktopObject.Settings.Pos.Y,
       False);
end;

function GetControlByHandle(AHandle: THandle): TWinControl;
begin
 Result := Pointer(GetProp( AHandle,
                            PChar( Format( 'Delphi%8.8x',
                                           [GetCurrentProcessID]))));
end;

procedure TSettingsForm.Load(pObjectFile : TObjectFile; ID,PosX,PosY : integer; pCreate : boolean);
var
   Rect : TRect;
   P : TPoint;
   n : integer;
begin
     CreateMode:=pCreate;
     ObjectID := ID;

     if not pObjectFile.Loaded then
        pObjectFile.Load;

     ObjectFile := pObjectFile;

     if CreateMode then
     begin
       DesktopObject := nil;
       pSettingsWnd  := ObjectFile.DllStartSettingsWnd(0,SettingsPanel.Handle);
     end else
     begin
       DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(ObjectID));
       pSettingsWnd  := ObjectFile.DllStartSettingsWnd(ObjectID,SettingsPanel.Handle);
     end;

     GetWindowRect(pSettingsWnd,Rect);
     p.x := Rect.Right - Rect.Left;
     p.y := Rect.Bottom - Rect.Top;
     Rect.Left   := 0;
     Rect.Top    := 0;
     Rect.Right  := p.x;
     Rect.Bottom := p.y;
     SetWindowPos(pSettingsWnd,HWND_TOP,0,0,p.x,p.y,SWP_SHOWWINDOW);
//     P := SettingsPanel.ScreenToClient(Rect.BottomRight);
     SettingsPanel.Width := P.x;
     SettingsPanel.Height := P.y;
     n := GetCurrentMonitor;
     Updatesize;
//     SettingsForm.Width:= SettingsPanel.Left + SettingsPanel.Width + 2*SettingsPanel.Left;
//     SettingsForm.Height:=SettingsPanel.Top + SettingsPanel.Height + BottomPanel.Height + 164;
     SettingsForm.Left:=Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - SettingsForm.Width div 2;
     SettingsForm.top:=Screen.Monitors[n].Top + Screen.Monitors[n].Height div 2 - SettingsForm.Height div 2;
     ObjectSets.Column[0].Width := ObjectSets.Width-9;
     GetControlByHandle(pSettingsWnd).Parent := SettingsPanel;
end;


procedure TSettingsForm.btn_applyClick(Sender: TObject);
begin
  Save := True;
  if ObjectSets.Selected = nil then exit;
  ObjectFile.DllCloseSettingsWnd(ObjectID,True);
  ObjectFile.DllSharpDeskMessage(ObjectID,DesktopObject.Layer,SDM_REPAINT_LAYER,0,0,0);
  DesktopObject.Settings.Pos := Point(round(DesktopObject.Layer.Location.Left),
                                      round(DesktopObject.Layer.Location.Top));
  SharpDesk.ObjectSetList.SaveSettings;
  pSettingsWnd := ObjectFile.DllStartSettingsWnd(ObjectID,SettingsPanel.Handle);
  Save := False;
end;

procedure TSettingsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   tempSetting : TObjectSetItem;
   ObjectSet : TObjectSet;
begin
  SharpDesk.DeskSettings.SetObjectRolledOut := not ObjectRollout.Collapsed;
  SharpDesk.DeskSettings.SaveSettings;

  if (ObjectSets.Selected = nil) and (Save) then
  begin
    showmessage('Please select an object set!');
    exit;
  end;
  
  ObjectFile.DllCloseSettingsWnd(ObjectID,Save);
  if Save then
  begin
    if CreateMode then
    begin
      ObjectSet := TObjectSet(SharpDesk.ObjectSetList.GetSetByID(ObjectSets.Selected.StateIndex));
      tempsetting := ObjectSet.AddDesktopObject(ObjectID,
                                                ObjectFile.FileName,
                                                Point(LastX,LastY),
                                                False,
                                                False);
{      tempSetting := SharpDesk.DeskSettings.ObjectSet.AddDesktopObject(ObjectID,
                                                                       ObjectFile.FileName,
                                                                       Point(LastX,LastY),
                                                                       False);}
      DesktopObject := TDesktopObject(ObjectFile.AddDesktopObject(tempsetting));
    end else
    begin
      ObjectSet := TObjectSet(SharpDesk.ObjectSetList.GetSetByID(ObjectSets.Selected.StateIndex));
      if TObjectSet(DesktopObject.Settings.Owner) <> ObjectSet then
      begin
        TObjectSet(DesktopObject.Settings.Owner).Remove(DesktopObject.Settings);
        ObjectSet.Add(DesktopObject.Settings);
        DesktopObject.Settings.Owner := ObjectSet;
      end;
      ObjectFile.DllSharpDeskMessage(ObjectID,DesktopObject.Layer,SDM_REPAINT_LAYER,0,0,0);
    end;

    DesktopObject.Settings.Pos := Point(round(DesktopObject.Layer.Location.Left),
                                        round(DesktopObject.Layer.Location.Top));
    SharpDesk.ObjectSetList.SaveSettings;
  end else
      if ObjectFile.Count = 0 then
         ObjectFile.UnLoad;
  SharpDesk.CheckInvisibleLayers;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
var
 n : integer;
begin
  Save:=False;

  ObjectRollout.Collapsed := not SharpDesk.DeskSettings.SetObjectRolledOut;

  BuildObjectSets;

  if CreateMode then btn_apply.Enabled := False
     else btn_apply.Enabled := True;

  n := GetCurrentMonitor;
//  SettingsForm.Width:= SettingsPanel.Left + SettingsPanel.Width + 2*SettingsPanel.Left;
//  SettingsForm.Height:=SettingsPanel.Top + SettingsPanel.Height + BottomPanel.Height + 164;
  SettingsForm.Left:=Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - SettingsForm.Width div 2;
  SettingsForm.top:=Screen.Monitors[n].Top + Screen.Monitors[n].Height div 2 - SettingsForm.Height div 2;

  if ObjectSets.Selected = nil then
     if ObjectSets.Items.Count > 0 then
        ObjectSets.Items[0].Selected := True;

  Updatesize;
end;

procedure TSettingsForm.btn_okClick(Sender: TObject);
begin
     Save:=True;
     SettingsForm.Close;
end;

procedure TSettingsForm.btn_cancelClick(Sender: TObject);
begin
     Save:=False;
     SettingsForm.Close;
end;



procedure TSettingsForm.NewSetExecute(Sender: TObject);
var
  s : String;
begin
 // SettingsForm.FormStyle := fsNormal;
  s:= InputBox('Create Object Set','Object Set name : ','');
 // SettingsForm.FormStyle := fsStayOnTop;
  if (length(s) = 0) or (s='') then exit;
  SharpDesk.ObjectSetList.AddObjectSet(s, SharpThemeApi.GetThemeName);
  SharpDesk.ObjectSetList.SaveSettings;
  BuildObjectSets;
end;

procedure TSettingsForm.ObjectSetsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ObjectSets.Items.Count = 0 then exit;
  if ObjectSets.GetItemAt(X,Y) = nil then
     ObjectSets.ItemIndex := ObjectSets.tag;
end;

procedure TSettingsForm.ObjectSetsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Selected then ObjectSets.Tag := ObjectSets.ItemIndex;
end;

procedure TSettingsForm.FormResize(Sender: TObject);
begin
  ObjectRollout.Left := 2;
  ObjectRollout.Top := self.Height - ObjectRollout.Height - 66;
  ObjectRollout.Width := self.Width - 12;
  Objectsets.Columns.Items[0].Width := Objectsets.Width - 36;
end;

procedure TSettingsForm.ObjectRolloutCollapse(Sender: TObject);
begin
  Updatesize;
end;

procedure TSettingsForm.ObjectRolloutExpand(Sender: TObject);
begin
  Updatesize;
end;

end.
