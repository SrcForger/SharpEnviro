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
    procedure ObjectRolloutExpand(Sender: TObject);
    procedure ObjectRolloutCollapse(Sender: TObject);
    procedure btn_applyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
  private
    ObjectFile : TObjectFile;
    DesktopObject : TDesktopObject;
    ObjectID : Integer;
    pSettingsWnd : hwnd;
    Save : boolean;
    CreateMode : boolean;
  public
    procedure Updatesize;
    procedure Load(pDesktopObject : TDesktopObject); overload;
    procedure Load(pObjectFile : TObjectFile; ID,PosX,PosY : integer; pCreate : boolean); overload;
  end;


var
   SettingsForm : TSettingsForm;

implementation

uses uSharpDeskMainForm,
     uSharpDeskObjectSetItem,
     uSharpDeskObjectSet,
     uSharpDeskFunctions;

{$R *.dfm}


procedure TSettingsForm.Updatesize;
begin
  SettingsForm.Width := SettingsPanel.Left + SettingsPanel.Width + 2*SettingsPanel.Left;
  SettingsForm.Height := SettingsPanel.Top + SettingsPanel.Height + 76;// + ObjectRollout.Height;
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
     GetControlByHandle(pSettingsWnd).Parent := SettingsPanel;
end;


procedure TSettingsForm.btn_applyClick(Sender: TObject);
begin
  Save := True;
  //if ObjectSets.Selected = nil then exit;
  ObjectFile.DllCloseSettingsWnd(ObjectID,True);
  ObjectFile.DllSharpDeskMessage(ObjectID,DesktopObject.Layer,SDM_REPAINT_LAYER,0,0,0);
  DesktopObject.Settings.Pos := Point(round(DesktopObject.Layer.Location.Left),
                                      round(DesktopObject.Layer.Location.Top));
  SharpDesk.ObjectSet.Save;
  pSettingsWnd := ObjectFile.DllStartSettingsWnd(ObjectID,SettingsPanel.Handle);
  Save := False;
end;

procedure TSettingsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   tempSetting : TObjectSetItem;
   ObjectSet : TObjectSet;
begin
  ObjectFile.DllCloseSettingsWnd(ObjectID,Save);
  if Save then
  begin
    if CreateMode then
    begin
      ObjectSet := TObjectSet(SharpDesk.ObjectSet);
      tempsetting := ObjectSet.AddDesktopObject(ObjectID,
                                                ObjectFile.FileName,
                                                Point(LastX,LastY),
                                                False,
                                                False);
      DesktopObject := TDesktopObject(ObjectFile.AddDesktopObject(tempsetting));
    end else
    begin
      ObjectSet := TObjectSet(SharpDesk.ObjectSet);
      if TObjectSet(DesktopObject.Settings.Owner) <> ObjectSet then
      begin
        TObjectSet(DesktopObject.Settings.Owner).Remove(DesktopObject.Settings);
        ObjectSet.Add(DesktopObject.Settings);
        DesktopObject.Settings.Owner := ObjectSet;
      end;
      ObjectFile.DllSharpDeskMessage(ObjectID,DesktopObject.Layer,SDM_REPAINT_LAYER,0,0,0);
    end;

    if DesktopObject <> nil then
      DesktopObject.Settings.Pos := Point(round(DesktopObject.Layer.Location.Left),
                                          round(DesktopObject.Layer.Location.Top));
    SharpDesk.ObjectSet.Save;
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

  if CreateMode then btn_apply.Enabled := False
     else btn_apply.Enabled := True;

  n := GetCurrentMonitor;
//  SettingsForm.Width:= SettingsPanel.Left + SettingsPanel.Width + 2*SettingsPanel.Left;
//  SettingsForm.Height:=SettingsPanel.Top + SettingsPanel.Height + BottomPanel.Height + 164;
  SettingsForm.Left:=Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - SettingsForm.Width div 2;
  SettingsForm.top:=Screen.Monitors[n].Top + Screen.Monitors[n].Height div 2 - SettingsForm.Height div 2;

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

procedure TSettingsForm.ObjectRolloutCollapse(Sender: TObject);
begin
  Updatesize;
end;

procedure TSettingsForm.ObjectRolloutExpand(Sender: TObject);
begin
  Updatesize;
end;

end.
