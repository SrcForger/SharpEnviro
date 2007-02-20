{
Source Name: uSharpCenterManager
Description: Management class for SharpCenter
Copyright (C) lee@sharpe-shell.org

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

unit uSharpCenterManager;

interface

uses
  Windows,
  Messages,
  SysUtils,
  SharpApi,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ExtCtrls,
  Menus,
  jclFileUtils,
  JclStrings,
  uSharpCenterDllMethods,
  SharpEListBoxEx,
  PngImageList,
  PngImage,
  StdCtrls,
  
  Contnrs;

const
  cLoadSetting = '_loadSetting';
  cChangeFolder = '_navdir';
  cUnloadDll = '_unloaddll';
  cLoadDll = '_loaddll';

type
  TBT = (btUnspecified, btFolder, btSetting, btDll);

type
  TBTData = class
  private
    FIconIndex: Integer;
    FID: Integer;
    FCaption: string;
    FBT: TBT;
    FStatus: string;
  public
    constructor Create;
    property Caption: string read FCaption write FCaption;
    property Status: string read FStatus write FStatus;
    property IconIndex: Integer read FIconIndex write FIconIndex;
    property ID: Integer read FID write FID;
    property BT: TBT read FBT write FBT;
  end;

type
  TBTDataDll = class(TBTData)
  private
    FPath: string;
    FPluginID: string;
    FSetting: TSetting;
  public
    property Path: string read FPath write FPath;
    property Setting: TSetting read FSetting write FSetting;
    property PluginID: String read FPluginID write FPluginID;
  end;

type
  TBTDataFolder = class(TBTData)
  private
    FPath: string;
  public
    property Path: string read FPath write FPath;
  end;

  TBTDataSetting = class(TBTData)
  private
    FSettingFile: string;
  public
    property SettingFile: string read FSettingFile write FSettingFile;
  end;

type
  TSharpCenterHistoryItem = class
  private
    FCommand: string;
    FParameter: string;
    FPluginID: String;
    FID: Integer;
  public
    property ID: Integer read FID write FID;
    property Command: string read FCommand write FCommand;
    property Parameter: string read FParameter write FParameter;
    property PluginID: String read FPluginID write FPluginID;
  end;

type
  TSharpCenterHistory = class
  private
    FList: TList;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Delete(AItem: TSharpCenterHistoryItem);

    function AddFolder(APath: string): TSharpCenterHistoryItem;
    function AddDll(ADll, APluginID: String): TSharpCenterHistoryItem;
    function AddSetting(ASetting: string): TSharpCenterHistoryItem;
    function Add(ACommand, AParameter, APluginID: String): TSharpCenterHistoryItem;
    function GetLastEntry: TSharpCenterHistoryItem;
    property List: TList read FList write FList;

    property Count: Integer read GetCount;
  end;

type
  TSharpCenterManager = class
  private
    FThemesPath: string;
    FModulesPath: string;
    FObjectsPath: string;
    FHistory: TSharpCenterHistory;

    FCurrentCommand: TSharpCenterHistoryItem;
    FEditItemState: Boolean;
    FEditItemWarning: Boolean;
    FCenterDir: String;
    procedure AssignIconIndex(AFileName: string; ABTData: TBTData);

    procedure SetEditItemWarning(const Value: Boolean);
    procedure SetEditItemState(const Value: Boolean);
    function GetCenterDir: String;
  public
    constructor Create;
    destructor Destroy; override;

    property History: TSharpCenterHistory read FHistory write FHistory;
    property CurrentCommand: TSharpCenterHistoryItem read FCurrentCommand write FCurrentCommand;
    property CenterDir: String read GetCenterDir;

    function GetNextHistory: string;
    procedure ClearHistory;

    procedure BuildRootFromPath(APath: string; Alistbox: TSharpEListBoxEx);
    procedure BuildRoot(AListBox: TSharpEListBoxEx);

    property EditItemState: Boolean read FEditItemState write SetEditItemState;
    property EditItemWarning: Boolean read FEditItemWarning write SetEditItemWarning;
    function CheckEditState:Boolean;
  end;

var
  SCM: TSharpCenterManager;

implementation

uses
  uSharpCenterMainWnd,
  uSharpCenterCommon,
  JvSimpleXml;

constructor TSharpCenterManager.Create;
begin
  FHistory := TSharpCenterHistory.Create;
  FCenterDir := GetCenterDirectory;

  FCurrentCommand := TSharpCenterHistoryItem.Create;
  FCurrentCommand.Command := cChangeFolder;
  FCurrentCommand.Parameter := FCenterDir;
  FCurrentCommand.PluginID := '';

  // Load definitions
  LoadCenterDefines(FThemesPath, FModulesPath, FObjectsPath);
end;

destructor TSharpCenterManager.Destroy;
begin
  FHistory.Free;
  inherited;
end;

function TSharpCenterManager.GetNextHistory: string;
begin
  Result := '';

  {if FHistory.Count <> 0 then begin
    idx := FHistory.Count - 1;

    Result := FHistory.Strings[idx];
    FHistory.Delete(idx);
  end; }
end;

procedure TSharpCenterManager.ClearHistory;
begin
  FHistory.Clear;
end;

procedure TSharpCenterManager.BuildRootFromPath(APath: string; Alistbox:
  TSharpEListboxEx);
var
  SRec: TSearchRec;
  NewBT: TBTData;
  pngfile: string;
  sIcon, sName: string;
  xml: TJvSimpleXML;
  li:TSharpEListItem;

begin
  // Clear list box

  AListbox.Items.Clear;
  Alistbox.ItemHeight := GlobalItemHeight;
  try
    FCurrentCommand.Command := cChangeFolder;
    FCurrentCommand.Parameter := APath;
    FCurrentCommand.PluginID := '';
    APath := PathAddSeparator(APath);

    if FindFirst(APath + '*.*', SysUtils.faAnyFile, SRec) = 0 then
      repeat
        if (sRec.Name = '.') or (sRec.Name = '..') then
          Continue;

        if (ExtractFileExt(sRec.Name) = '.con') then
        begin

          xml := TJvSimpleXML.Create(nil);
          try
            Xml.LoadFromFile(APath + sRec.Name);

            if xml.Root.Items.ItemNamed['Default'] <> nil then
            begin
              with xml.Root.Items.ItemNamed['Default'] do
              begin
                if Items.ItemNamed['Name'] <> nil then
                  sName := Items.ItemNamed['Name'].Value;

                if Items.ItemNamed['Icon'] <> nil then
                  sIcon := APath + Items.ItemNamed['Icon'].Value;
              end;
            end
            else
            begin
              sName := PathRemoveExtension(sRec.Name);
              sIcon := APath + PathRemoveExtension(sRec.Name) + '.png';
            end;

          finally
            Xml.Free;
          end;

          NewBT := TBTDataSetting.Create;
          NewBT.Caption := sName;
          TBTDataSetting(NewBt).SettingFile := APath + sRec.Name;
          NewBT.ID := -1;
          NewBT.BT := btSetting;
          pngfile := sIcon;
          AssignIconIndex(pngfile, NewBT);

          li := Alistbox.AddItem(NewBT.Caption,NewBT.IconIndex);
          li.Data := Pointer(NewBT);
        end
        else if IsDirectory(APath + sRec.Name) then
        begin

          if Copy(sRec.Name, 0, 1) <> '_' then
          begin

            NewBT := TBTDataFolder.Create;
            NewBT.Caption := PathRemoveExtension(sRec.Name);
            TBTDataFolder(NewBT).Path := APath + sRec.Name;
            NewBT.ID := -1;

            TBTDataFolder(NewBT).BT := btFolder;

            pngfile := APath + PathRemoveExtension(sRec.Name) + '.png';
            AssignIconIndex(pngfile, NewBT);
            li := Alistbox.AddItem(NewBT.Caption,NewBT.IconIndex);
            li.Data := Pointer(NewBT);
          end;
        end;
      until
        FindNext(SRec) <> 0;

  finally
    if AListbox.Items.Count = 0 then
    begin
      AListbox.Enabled := False;
      AListbox.AddItem('No items found', -1);
    end
    else
      AListbox.Enabled := True;
  end;
end;

procedure TSharpCenterManager.AssignIconIndex(AFileName: string; ABTData:
  TBTData);
var
  tmpPngImage: TPNGObject;
  tmpPiC: TPngImageCollectionItem;
begin
  if FileExists(AFileName) then
  begin
    tmpPngImage := TPNGObject.Create;
    tmpPngImage.LoadFromFile(AFileName);
    tmpPngImage.CreateAlpha;

    tmpPiC := SharpCenterWnd.picMain.PngImages.Add();
    tmpPiC.PngImage.Assign(tmpPngImage);
    tmpPiC.Background := clWindow;

    ABTData.IconIndex := tmpPic.Index;
  end
  else ABTData.IconIndex := 1;

  SharpCenterWnd.lbTree.ItemHeight := GlobalItemHeight;
end;

{ TBTData }

constructor TBTData.Create;
begin
  FCaption := '';
  FStatus := '';
  FID := -1;
  FBT := btUnspecified;
  FIconIndex := -1;
end;

{ TSharpCenterHistory }

constructor TSharpCenterHistory.Create;
begin
  FList := TList.Create;
end;

procedure TSharpCenterHistory.Clear;
begin
  FList.Clear;
end;

destructor TSharpCenterHistory.Destroy;
var
  i: Integer;
begin
  for i := 0 to Pred(FList.Count) do
    TSharpCenterHistoryItem(FList[i]).Free;

  FList.Free;
  inherited;
end;

function TSharpCenterHistory.AddFolder(APath: string): TSharpCenterHistoryItem;
begin
  Result := nil;
  if APath = '' then
    exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := cChangeFolder;
  Result.Parameter := APath;
  Result.PluginID := '';
  Result.ID := FList.Count;

  FList.Add(Result);
end;

function TSharpCenterHistory.AddDll(
  ADll, APluginID: string): TSharpCenterHistoryItem;
begin
  Result := nil;
  if ADll = '' then
    exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := '_loaddll';
  Result.Parameter := ADll;
  Result.PluginID := APluginID;
  Result.ID := FList.Count;

  FList.Add(Result);
end;

function TSharpCenterHistory.AddSetting(
  ASetting: string): TSharpCenterHistoryItem;
begin
  Result := nil;
  if ASetting = '' then
    exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := cLoadSetting;
  Result.Parameter := ASetting;
  Result.PluginID := '';
  Result.ID := FList.Count;

  FList.Add(Result);
end;

function TSharpCenterHistory.GetLastEntry: TSharpCenterHistoryItem;
begin
  Result := nil;
  if FList.Last <> nil then
    Result := TSharpCenterHistoryItem(FList.Last);
end;

function TSharpCenterHistory.Add(ACommand, AParameter, APluginID: string): TSharpCenterHistoryItem;
begin
  Result := TSharpCenterHistoryItem.Create;
  Result.Command := ACommand;
  Result.Parameter := AParameter;
  Result.PluginID := APluginID;
  Result.ID := FList.Count;

  FList.Add(Result);
end;

procedure TSharpCenterHistory.Delete(AItem: TSharpCenterHistoryItem);
var
  n: Integer;
begin
  n := FList.IndexOf(AItem);
  if n <> -1 then
  begin
    FList.Delete(n);
  end;
end;

procedure TSharpCenterManager.SetEditItemWarning(const Value: Boolean);
begin
  FEditItemWarning := Value;
  SharpCenterWnd.UpdateSettingTheme;
end;

procedure TSharpCenterManager.SetEditItemState(const Value: Boolean);
begin
  FEditItemState := Value;
  SharpCenterWnd.UpdateSettingTheme;
end;

function TSharpCenterManager.CheckEditState:Boolean;
begin
  Result := False;
  If EditItemState then begin
      EditItemWarning := True;
      Result := True;
  end;

    if ((EditItemState) or (EditItemWarning)) then
        Result := True;
end;

function TSharpCenterManager.GetCenterDir: String;
begin
  Result := FCenterDir;
end;

procedure TSharpCenterManager.BuildRoot(AListBox: TSharpEListBoxEx);
begin
  History.Clear;
  BuildRootFromPath(CenterDir, AListBox);
end;

function TSharpCenterHistory.GetCount: Integer;
begin
  Result := FList.Count;
end;

initialization
  SCM := TSharpCenterManager.Create;
finalization
  FreeAndNil(SCM);

end.






