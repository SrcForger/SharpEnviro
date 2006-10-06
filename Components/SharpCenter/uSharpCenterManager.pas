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
  uSharpCenterDllMethods,
  PngImageList,
  PngImage,
  JclStrings,
  StdCtrls,
  SharpApi,
  Contnrs;

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
    FPluginID: Integer;
    FDllProc: TConfigDll;
  public
    property Path: string read FPath write FPath;
    property DllProc: TConfigDll read FDllProc write FDllProc;
    property PluginID: Integer read FPluginID write FPluginID;
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
    property ConfigPath: string read FConfigFile write FConfigFile;
  end;

type
  TSharpCenterHistoryItem = class
  private
    FCommand: string;
    FParameter: string;
    FPluginID: Integer;
  public
    property Command: string read FCommand write FCommand;
    property Parameter: string read FParameter write FParameter;
    property PluginID: Integer read FPluginID write FPluginID;
  end;

type
  TSharpCenterHistory = class
  private
    FStack: TStack;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    function AddFolder(APath: string): TSharpCenterHistoryItem;
    function AddDll(ADll: string; APluginID: Integer): TSharpCenterHistoryItem;
    function AddConfig(AConfig: string): TSharpCenterHistoryItem;
    Function GetLastEntry:TSharpCenterHistoryItem;
  end;

type
  TSharpCenterManager = class
  private
    FCurrentSelected: string;
    FThemesPath: string;
    FModulesPath: string;
    FObjectsPath: string;
    FHistory: TSharpCenterHistory;

    FCurrentCommand: String;


    function GetControlByHandle(AHandle: THandle): TWinControl;
    procedure AssignIconIndex(AFileName: string; ABTData: TBTData);

    function GetDisplayName(ADllFilename: string; APluginID: Integer): string;
  public
    constructor Create;
    destructor Destroy; override;

    property History: TSharpCenterHistory read FHistory write FHistory;

    procedure ClickButton(Sender: TObject);
    function GetNextHistory: string;
    procedure ClearHistory;

    procedure BuildSectionItemsFromPath(APath: string; Alistbox: TListbox);

  end;

var
  SharpCenterManager: TSharpCenterManager;

implementation

uses
  uSharpCenterMainWnd,
  uSharpCenterCommon,
  uSharpCenterDllConfigWnd,
  JvSimpleXml;

function TSharpCenterManager.GetControlByHandle(AHandle: THandle): TWinControl;
begin
  Result := Pointer(GetProp(AHandle,
    PChar(Format('Delphi%8.8x', [GetCurrentProcessID]))));
end;

procedure TSharpCenterManager.ClickButton(Sender: TObject);
var
  tmpBTData: TBTData;
  tmpBTDataFolder: TBTDataFolder;
  tmpBTDataDll: TBTDataDll;
  tmpBTDataConfig: TBTDataConfig;

  iConfigDllType: Integer;
  Xml: TJvSimpleXml;
  sFn, sName: string;

  sets: TStringList;
  dir, s: string;
  i, j, h, w, n: Integer;
  objects, files: TStringList;
begin
  LockWindowUpdate(SharpCenterWnd.Handle);
  try
    // Unload Dll
    if frmDllConfig <> nil then
      frmDllConfig.UnloadDll;

    // Get the Button Data
    tmpBTData :=
      TBTData(SharpCenterWnd.lbSections.Items.Objects[SharpCenterWnd.lbSections.ItemIndex]);
    sName := tmpBTData.Caption;

    case tmpBTData.BT of
      btUnspecified: ;
      btFolder: begin
          tmpBTDataFolder := TBTDataFolder(tmpBTData);

          History.AddFolder(FCurrentCommand);

          FCurrentCommand := PathAddSeparator(tmpBTDataFolder.Path);
          BuildSectionItemsFromPath(FCurrentCommand, SharpCenterWnd.lbSections);

          SharpCenterWnd.btnBack.Enabled := True;
        end;
      btConfig: begin

          // Has to load the xml file
          // Get the multiple plugin configs
          // Add the multiple plugin configs, if any
          // Display the plugin window

          tmpBTDataConfig := TBTDataConfig(tmpBTData);


          History.AddConfig(FCurrentCommand);
          FCurrentCommand := tmpBTDataConfig.ConfigPath;

          if fileexists(FCurrentCommand) then begin

            if not (assigned(frmDllConfig)) then
              frmDllConfig := TfrmDllConfig.Create(SharpCenterWnd.pnlMain,
                tmpBTDataConfig.ConfigPath,
                tmpBTDataConfig.Caption)
            else begin
              frmDllConfig.InitialiseWindow(SharpCenterWnd.pnlMain,
                tmpBTDataConfig.Caption);
              frmDllConfig.LoadConfiguration(FCurrentCommand);
            end;


          end;

        end;
    end;

  finally
    LockWindowUpdate(0);
  end;
end;

constructor TSharpCenterManager.Create;
begin
  FHistory := TSharpCenterHistory.Create;

  // Load definitions
  LoadCenterDefines(FThemesPath, FModulesPath, FObjectsPath);
end;

destructor TSharpCenterManager.Destroy;
begin
  FHistory.Free;
  inherited;
end;

function TSharpCenterManager.GetNextHistory: string;
var
  idx: Integer;
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

procedure TSharpCenterManager.BuildSectionItemsFromPath(APath: string; Alistbox:
  TListbox);
var
  SRec: TSearchRec;
  NewBT: TBTData;

  tmpPngImage: TPNGObject;
  tmpPiC: TPngImageCollectionItem;
  pngfile: string;
  s, sDll, sIcon, sName: string;
  xml: TJvSimpleXML;
  i: Integer;
begin
  // Clear list box
  AListbox.Items.Clear;
  Alistbox.ItemHeight := 16;
  try

    if FindFirst(APath + '*.*', SysUtils.faAnyFile, SRec) = 0 then
      repeat
        if (sRec.Name = '.') or (sRec.Name = '..') then
          Continue;

        if (ExtractFileExt(sRec.Name) = '.con') then begin

          xml := TJvSimpleXML.Create(nil);
          try
            Xml.LoadFromFile(APath + sRec.Name);

            if xml.Root.Items.ItemNamed['Default'] <> nil then begin
              with xml.Root.Items.ItemNamed['Default'] do begin
                if Items.ItemNamed['Name'] <> nil then
                  sName := Items.ItemNamed['Name'].Value;

                if Items.ItemNamed['Icon'] <> nil then
                  sIcon := APath + Items.ItemNamed['Icon'].Value;
              end;
            end
            else begin
              sName := PathRemoveExtension(sRec.Name);
              sIcon := APath + PathRemoveExtension(sRec.Name) + '.png';
            end;

          finally
            Xml.Free;
          end;

          NewBT := TBTDataConfig.Create;
          NewBT.Caption := sName;
          TBTDataConfig(NewBt).ConfigPath := APath + sRec.Name;
          NewBT.ID := -1;
          NewBT.BT := btConfig;
          pngfile := sIcon;
          AssignIconIndex(pngfile, NewBT);
          AListbox.Items.AddObject(NewBT.Caption, NewBT);

          // Process the xml file
          {xml := TJvSimpleXML.Create(nil);
          Try
            xml.LoadFromFile(APath + sRec.Name);

            with xml.Root.Items.ItemNamed['Sections'] do begin
              for i := 0 to Pred(Items.Count) do begin

                NewBT := TBTDataDll.Create;

                sDll := '';
                if Items.Item[i].Items.ItemNamed['Dll'] <> nil then
                  sDll := Items.Item[i].Items.ItemNamed['Dll'].Value;

                sIcon := '';
                if Items.Item[i].Items.ItemNamed['Icon'] <> nil then
                  sIcon := Items.Item[i].Items.ItemNamed['Icon'].Value;

                s := GetDisplayName(APath+sDll, -1);

                if s = '' then
                  NewBT.Caption := Items.Item[i].Name
                else
                  NewBT.Caption := s;

                AListbox.Items.AddObject(NewBT.Caption, NewBT);
                TBTDataDll(NewBT).Path := APath+sDll;
                TBTDataDll(NewBT).PluginID := -1;
                NewBT.ID := -1;
                NewBT.BT := btDll;

                pngfile := APath + sIcon;
                AssignIconIndex(pngfile, ARoot, NewBT);
              end;
            end;

          Finally
            xml.Free;
          End;   }
        end
        else if (IsDirectory(APath + sRec.Name)) then begin

          if Copy(sRec.Name, 0, 1) <> '_' then begin

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
    if AListbox.Items.Count = 0 then begin
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
  if FileExists(AFileName) then begin
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

  if SharpCenterWnd.picMain.Items.Items[ABTData.IconIndex].PngImage.Height + 6 >
    SharpCenterWnd.lbSections.ItemHeight then
    SharpCenterWnd.lbSections.ItemHeight :=
      SharpCenterWnd.picMain.Items.Items[ABTData.IconIndex].PngImage.Height + 6;
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

function TSharpCenterManager.GetDisplayName(ADllFilename: string; APluginID:
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
end;

{ TSharpCenterHistory }

constructor TSharpCenterHistory.Create;
begin
  FStack := TStack.Create;
end;

procedure TSharpCenterHistory.Clear;
begin
  //FStack.;
end;

destructor TSharpCenterHistory.Destroy;
begin
  FStack.Free;
  inherited;
end;

function TSharpCenterHistory.AddFolder(APath: string): TSharpCenterHistoryItem;
begin
  Result := nil;
  if APath = '' then exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := '_navfolder';
  Result.Parameter := APath;
  Result.PluginID := -1;

  FStack.Push(Result);
end;

function TSharpCenterHistory.AddDll(
  ADll: string; APluginID: Integer): TSharpCenterHistoryItem;
begin
  Result := nil;
  if ADll = '' then exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := '_loaddll';
  Result.Parameter := ADll;
  Result.PluginID := APluginID;
  FStack.Push(Result);
end;

function TSharpCenterHistory.AddConfig(
  AConfig: string): TSharpCenterHistoryItem;
begin
  Result := nil;
  if AConfig = '' then exit;

  Result := TSharpCenterHistoryItem.Create;
  Result.Command := '_loadconfig';
  Result.Parameter := AConfig;
  Result.PluginID := -1;
  FStack.Push(Result);
end;

function TSharpCenterHistory.GetLastEntry: TSharpCenterHistoryItem;
var
  n,pluginid:Integer;
  cmd, param:String;
begin
  if FStack.Count > 0 then Result := FStack.Pop
     else result := nil;
end;

end.

