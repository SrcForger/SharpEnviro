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
  PngImageList,
  PngImage,
  StdCtrls,
  SharpApi,
  Contnrs;

const
  cLoadConfig = '_loadconfig';
  cChangeFolder = '_navdir';
  cUnloadDll = '_unloaddll';
  cLoadDll = '_loaddll';

type
  TBT = (btUnspecified, btFolder, btConfig, btDll);

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
    FDllProc: TConfigDll;
  public
    property Path: string read FPath write FPath;
    property DllProc: TConfigDll read FDllProc write FDllProc;
    property PluginID: String read FPluginID write FPluginID;
  end;

type
  TBTDataFolder = class(TBTData)
  private
    FPath: string;
  public
    property Path: string read FPath write FPath;
  end;

  TBTDataConfig = class(TBTData)
  private
    FConfigFile: string;
  public
    property ConfigFile: string read FConfigFile write FConfigFile;
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
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Delete(AItem: TSharpCenterHistoryItem);

    function AddFolder(APath: string): TSharpCenterHistoryItem;
    function AddDll(ADll, APluginID: String): TSharpCenterHistoryItem;
    function AddConfig(AConfig: string): TSharpCenterHistoryItem;
    function Add(ACommand, AParameter, APluginID: String): TSharpCenterHistoryItem;
    function GetLastEntry: TSharpCenterHistoryItem;
    property List: TList read FList write FList;
  end;

type
  TSharpCenterManager = class
  private
    FThemesPath: string;
    FModulesPath: string;
    FObjectsPath: string;
    FHistory: TSharpCenterHistory;

    FCurrentCommand: TSharpCenterHistoryItem;
    procedure AssignIconIndex(AFileName: string; ABTData: TBTData);
    function GetFirstPathElement(APath: string): string;
    //function GetDisplayName(ADllFilename: string; APluginID: Integer): string;
  public
    constructor Create;
    destructor Destroy; override;

    property History: TSharpCenterHistory read FHistory write FHistory;
    property CurrentCommand: TSharpCenterHistoryItem read FCurrentCommand write FCurrentCommand;
    procedure ClickButton(Sender: TObject);
    function GetNextHistory: string;
    procedure ClearHistory;

    procedure BuildSectionItemsFromPath(APath: string; Alistbox: TListbox);
    procedure SetNavRoot(APath: string);
  end;

var
  SharpCenterManager: TSharpCenterManager;

implementation

uses
  uSharpCenterMainWnd,
  uSharpCenterCommon,
  uSharpCenterDllConfigWnd,
  JvSimpleXml;

procedure TSharpCenterManager.ClickButton(Sender: TObject);
var
  tmpBTData: TBTData;
  tmpBTDataFolder: TBTDataFolder;
  tmpBTDataConfig: TBTDataConfig;
  sName: string;
begin
  // Unload Dll
  if SharpCenterWnd.ConfigDll.DllHandle <> 0 then
    SharpCenterWnd.UnloadDll;

  // Get the Button Data
  tmpBTData :=
    TBTData(SharpCenterWnd.lbTree.Items.Objects[SharpCenterWnd.lbTree.ItemIndex]);
  sName := tmpBTData.Caption;

  case tmpBTData.BT of
    btUnspecified: ;
    btFolder:
      begin
        tmpBTDataFolder := TBTDataFolder(tmpBTData);

        History.Add(FCurrentCommand.Command, FCurrentCommand.Parameter, FCurrentCommand.PluginID);

        FCurrentCommand.Command := cChangeFolder;
        FCurrentCommand.Parameter := PathAddSeparator(tmpBTDataFolder.Path);
        SetNavRoot(FCurrentCommand.Parameter);

        SharpCenterWnd.lbTree.Clear;
        BuildSectionItemsFromPath(FCurrentCommand.Parameter, SharpCenterWnd.lbTree);

        SharpCenterWnd.btnBack.Enabled := True;
      end;
    btConfig:
      begin

        tmpBTDataConfig := TBTDataConfig(tmpBTData);
        History.Add(FCurrentCommand.Command, FCurrentCommand.Parameter, FCurrentCommand.PluginID);

        FCurrentCommand.Command := cLoadConfig;
        FCurrentCommand.Parameter := tmpBTDataConfig.ConfigFile;

        SetNavRoot(tmpBTDataConfig.ConfigFile);
        SharpCenterWnd.btnBack.Enabled := True;

        if fileexists(FCurrentCommand.Parameter) then
        begin

          SharpCenterWnd.InitialiseWindow(SharpCenterWnd.pnlMain,
            tmpBTDataConfig.Caption);
          SharpCenterWnd.LoadConfiguration(FCurrentCommand.Parameter,FCurrentCommand.PluginID);

        end;

      end;
    btDll:
      begin
        //tmpBTDatadLL := TBTDatadLL(tmpBTData);

        SharpCenterWnd.LoadSelectedDll(SharpCenterWnd.lbTree.ItemIndex);
      end;
  end;
end;

constructor TSharpCenterManager.Create;
begin
  FHistory := TSharpCenterHistory.Create;

  FCurrentCommand := TSharpCenterHistoryItem.Create;
  FCurrentCommand.Command := cChangeFolder;
  FCurrentCommand.Parameter := GetCenterDirectory;

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

function TSharpCenterManager.GetFirstPathElement(APath: string): string;
var
  n: Integer;
  s: string;
begin
  APath := PathAddSeparator(APath);
  s := Copy(APath, 0, Length(APath) - 1);
  n := StrILastPos('Root', s);
  Result := Copy(APath, n, length(s) - n + 1);

end;

procedure TSharpCenterManager.BuildSectionItemsFromPath(APath: string; Alistbox:
  TListbox);
var
  SRec: TSearchRec;
  NewBT: TBTData;
  pngfile: string;
  sIcon, sName: string;
  xml: TJvSimpleXML;

begin
  // Clear list box
  AListbox.Items.Clear;
  Alistbox.ItemHeight := 32;
  try
    FCurrentCommand.Command := cChangeFolder;
    FCurrentCommand.Parameter := APath;
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

          NewBT := TBTDataConfig.Create;
          NewBT.Caption := sName;
          TBTDataConfig(NewBt).ConfigFile := APath + sRec.Name;
          NewBT.ID := -1;
          NewBT.BT := btConfig;
          pngfile := sIcon;
          AssignIconIndex(pngfile, NewBT);
          AListbox.Items.AddObject(NewBT.Caption, NewBT);
        end
        else if IsDirectory(APath + sRec.Name) then
        begin

          if Copy(sRec.Name, 0, 1) <> '_' then
          begin

            NewBT := TBTDataFolder.Create;
            NewBT.Caption := PathRemoveExtension(sRec.Name);

            AListbox.Items.AddObject(NewBT.Caption,
              NewBT);
            TBTDataFolder(NewBT).Path := APath + sRec.Name;
            NewBT.ID := -1;

            TBTDataFolder(NewBT).BT := btFolder;

            pngfile := APath + PathRemoveExtension(sRec.Name) + '.png';
            AssignIconIndex(pngfile, NewBT);
          end;
        end;
      until
        FindNext(SRec) <> 0;

  finally
    if AListbox.Items.Count = 0 then
    begin
      AListbox.Enabled := False;
      AListbox.AddItem('No items found', nil);
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

    tmpPiC := SharpCenterWnd.picMain.Items.Add();
    tmpPiC.PngImage.Assign(tmpPngImage);
    tmpPiC.Background := clWindow;

    ABTData.IconIndex := tmpPic.Index;
  end
  else if ExtractFilePath(AFileName) = GetCenterDirectory then
    ABTData.IconIndex := 3
  else
    ABTData.IconIndex := 2;

  SharpCenterWnd.lbTree.ItemHeight := 32;
  {if SharpCenterWnd.picMain.Items.Items[ABTData.IconIndex].PngImage.Height + 6 >
    SharpCenterWnd.lbTree.ItemHeight then
    SharpCenterWnd.lbTree.ItemHeight :=
      SharpCenterWnd.picMain.Items.Items[ABTData.IconIndex].PngImage.Height + 6;  }
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

{function TSharpCenterManager.GetDisplayName(ADllFilename: string; APluginID:
  Integer):
  string;
var
  tmpConfigDll: TConfigDll;
  s: PChar;
begin
  Result := '';

  if fileexists(ADllFilename) then begin
    tmpConfigDll := LoadConfigDll(PChar(ADllFilename));

    try
      if @tmpConfigDll.GetDisplayName <> nil then begin
        tmpConfigDll.GetDisplayName(APluginID, s);
        Result := s;
      end;

    finally
      UnloadConfigDll(@tmpConfigDll);
    end;
  end;
end;    }

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

function TSharpCenterHistory.AddConfig(
  AConfig: string): TSharpCenterHistoryItem;
begin
  Result := nil;
  if AConfig = '' then
    exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := cLoadConfig;
  Result.Parameter := AConfig;
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

procedure TSharpCenterManager.SetNavRoot(APath: string);
var
  tmpStrl: TStringList;
  s, sHtml, sPre: string;
  i: Integer;
begin
  sHtml := '';
  s := GetFirstPathElement(APath);
  tmpStrl := TStringList.Create;
  try
    StrTokenToStrings(s, '\', tmpStrl);
    sPre := PathRemoveSeparator(GetCenterDirectory);

    for i := 0 to Pred(tmpStrl.Count) do
    begin
      if i <> 0 then
        sPre := sPre + '\' + tmpStrl[i];

      if ((CompareText(PathAddSeparator(ExtractFilePath(sPre)),ExtractFilePath(FCurrentCommand.Parameter)) = 0) or
        (CompareText(PathAddSeparator(sPre),FCurrentCommand.Parameter) = 0)) then
      sHtml := sHtml + Format('/<A HREF="%s"><b>%s</b></A>', [sPre, tmpStrl[i]]) else
      sHtml := sHtml + Format('/<A HREF="%s">%s</A>', [sPre, tmpStrl[i]]);
    end;
  finally
    tmpStrl.Free;
    SharpCenterWnd.lblTree.Caption := sHtml;
  end;
end;

end.




