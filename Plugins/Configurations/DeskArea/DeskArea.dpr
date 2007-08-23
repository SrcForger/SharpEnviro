﻿{
Source Name: DeskArea
Description: DeskArea Configuration
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

library DeskArea;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  GR32,
  SharpThemeApi,
  JvPageList,
  Graphics,
  uDeskAreaSettingsWnd in 'uDeskAreaSettingsWnd.pas' {frmDASettings},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSharpDeskTDeskSettings in '..\..\..\Components\SharpDesk\Units\uSharpDeskTDeskSettings.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas';

{$E .dll}

{$R *.res}


function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  n,i : integer;
  FName : String;
  DAItem : TDAItem;
  Mon : TMonitor;
  MonID : integer;
begin
  if frmDASettings = nil then frmDASettings := TfrmDASettings.Create(nil);

  uVistaFuncs.SetVistaFonts(frmDASettings);
  frmDASettings.ParentWindow := aowner;
  frmDASettings.Left := 2;
  frmDASettings.Top := 2;
  frmDASettings.BorderStyle := bsNone;

  FName := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\DeskArea\DeskArea.xml';
  XML := TJvSimpleXML.Create(nil);
  try
    if FileExists(FName) then
    begin
      XML.LoadFromFile(FName);
      for n := 0 to Screen.MonitorCount - 1 do
      begin
        Mon := Screen.Monitors[n];
        if Mon.Primary then MonID := -100
           else MonID := Mon.MonitorNum;
        DAItem := TDAItem.Create;
        DAItem.MonID := MonID;
        DAItem.Mon := Mon;
        DAList.Add(DAItem);

        if XML.Root.Items.ItemNamed['Monitors'] <> nil then
           for i := 0 to XML.Root.Items.ItemNamed['Monitors'].Items.Count - 1 do
               if XML.Root.Items.ItemNamed['Monitors'].Items.Item[i].Items.IntValue('ID',0) = MonID then
                  with XML.Root.Items.ItemNamed['Monitors'].Items.Item[i].Items do
                  begin
                    DAItem.AutoMode       := BoolValue('AutoMode',True);
                    DAItem.OffSets.Left   := IntValue('Left',0);
                    DAItem.OffSets.Top    := IntValue('Top',0);
                    DAItem.OffSets.Right  := IntValue('Right',0);
                    DAItem.OffSets.Bottom := IntValue('Bottom',0);
                   break;
                 end;
        if MonID = -100 then
           frmDASettings.UpdateGUIFromDAItem(DAItem);
      end;
    end;
  finally
    XML.Free;
  end;

  frmDASettings.Show;
  result := frmDASettings.Handle;
end;

procedure Save;
var
  FName : String;
  n : integer;
  DAItem : TDAItem;
  XML : TJvsimpleXML;
begin
  FName := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\DeskArea\DeskArea.xml';
  XML := TJvSimpleXML.Create(nil);
  XML.Root.Clear;
  try
    XML.Root.Name := 'SharpEDeskArea';
    XML.Root.Items.Add('Monitors');
    with XML.Root.Items.ItemNamed['Monitors'].Items do
    begin
      for n := 0 to DAList.Count - 1 do
      begin
        DAItem := TDAItem(DAList.Items[n]);
        with Add('item').Items do
        begin
          Add('ID',DAItem.MonID);
          Add('AutoMode',DAItem.AutoMode);
          Add('Left',DAItem.OffSets.Left);
          Add('Top',DAItem.OffSets.Top);
          Add('Right',DAItem.OffSets.Right);
          Add('Bottom',DAItem.OffSets.Bottom);
        end;
      end;
    end;

    XML.SaveToFile(FName + '~');
    if FileExists(FName) then
       DeleteFile(FName);
    RenameFile(FName + '~',FName);
  finally
    XML.Free;
  end;
end;

function Close : boolean;
begin
  result := True;
  try
    frmDASettings.Close;
    frmDASettings.Free;
    frmDASettings := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('DeskArea');
end;

procedure SetStatusText(var AStatusText: PChar);
begin
  AStatusText := '';
end;

procedure ClickBtn(AButtonID: Integer; AButton:TPngSpeedButton; AText:String);
begin
end;

function SetBtnState(AButtonID: Integer): Boolean;
begin
  Result := False;
end;

procedure ClickTab(ATab: TPluginTabItem);
begin
  frmDASettings.UpdateGUIFromDAItem(TDAItem(ATab.Data));
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
var
  n : integer;
begin
  if frmDASettings <> nil then
  begin
    for n := 0 to DAList.Count - 1 do
        if TDAItem(DAList.Items[n]).MonID = - 100 then
        begin
          ATabs.Add('Primary Monitor',TDAItem(DAList.Items[n]),'','');
          break;
        end;

    for n := 0 to DAList.Count - 1 do
        if TDAItem(DAList.Items[n]).MonID <> - 100 then
           ATabs.Add('Monitor (' + inttostr(n) + ')',TDAItem(DAList.Items[n]),'','');
  end;
end;

function SetSettingType : TSU_UPDATE_ENUM;
begin
  result := suDeskArea;
end;

procedure UpdatePreview(var ABmp: TBitmap32);
begin
  if frmDASettings.currentDAItem = nil then
  begin
    ABmp.SetSize(0,0);
    exit;
  end;

  ABmp.SetSize(frmDASettings.PreviewBmp.Width+2,frmDASettings.PreviewBmp.Height+2);
  ABmp.Clear(color32(0,0,0,255));
  frmDASettings.PreviewBmp.DrawTo(ABmp,1,1);
end;


exports
  Open,
  Close,
  Save,
  SetDisplayText,
  SetStatusText,
  SetBtnState,
  SetSettingType,
  GetCenterScheme,
  UpdatePreview,
  AddTabs,
  ClickTab,
  ClickBtn;

end.

