{
Source Name: uSharpEModuleManager.pas
Description: Dll Module Handler                              
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit uSharpEModuleManager;
                         
interface

uses 
  Windows,
  Messages,
  SysUtils,
  Forms,
  Classes,
  Contnrs,
  graphics,
  ExtCtrls,
  Menus,
  Math,
  Controls,
  MonitorList,
  uSystemFuncs,
  SharpTypes,
  SharpESkinManager,
  SharpEBar,
  SharpEMiniThrobber,
  SharpCenterApi,
  SharpApi,
  uISharpBarModule,
  uISharpESkin,
  uISharpBar,
  uSharpESkinInterface;


{ Note about the class structure:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Some people might dislike all the params for the constructors
  and how these params are given to the "child" classes by constructor params again.
  The simple reason for this is that I hate classes which are using global vars.
  Classes are supposed to be as independent as possible, they should be able to work
  on their own. Therefore I won't accept any class which is directly using
  global vars from other units.
  (Keep this in mind when you make changes to the class structure)

  BB
  }

{ Class Structure:
  ~~~~~~~~~~~~~~~

  TModuleManager - manages module dll files and all module windows
  TModuleManager.ModuleFiles -> ObjectList of TModuleFiles
  TModuleManager.Modules     -> ObjectList of TModule
  
  TModuleFile - class for each module dll files... contains dll function links
  TModule - Module class itself... module window handle, mini throbber, ...
}

type


  TModuleFile    = class
                   private
                     FFileName  : string;
                     FDllHandle : integer;
                     FLoaded    : boolean;
                     procedure LoadDll;
                     procedure UnloadDll;
                   public
                     DllCreateModule : function(ID,BarID : integer; BarWnd : hwnd) : IInterface;
                     procedure Clear;
                     constructor Create(pFileName : string); reintroduce;
                     destructor Destroy; override;

                     property FileName : string read FFileName;
                     property Loaded : boolean read FLoaded;
                   end;

  TModule        = class
                   private
                     FOwnerForm  : TWinControl;
                     FModuleFile : TModuleFile;
                     FPosition   : integer;
                     FThrobber   : TSharpEMiniThrobber;
                     FInterface          : IInterface;
                     FModuleInterface    : ISharpBarModule;
                     FModuleManager      : TObject;
                   public
                     constructor Create(pOwnerForm  : TWinControl;
                                        pModuleFile : TModuleFile;
                                        pID : integer;
                                        pBarID : integer;
                                        pParent : hwnd;
                                        pPosition : integer;
                                        pMM : TObject); reintroduce;
                     destructor Destroy; override;
                     procedure UpdateBackgroundW(NewWidth : integer);
                     procedure UpdateBackgroundL(NewLeft : integer);
                     procedure UpdateBackgroundS(NewTop, NewHeight : integer);
                     procedure UpdateBackgroundF(NewLeft, NewTop, NewWidth, NewHeight : integer);
                     procedure UpdateBackground; 

                     property ModuleManager : TObject read FModuleManager;
                     property ModuleFile : TModuleFile read FModuleFile;
                     property Position : integer    read FPosition write FPosition;
                     property OwnerForm : TWinControl read FOwnerForm;
                     property Throbber : TSharpEMiniThrobber read FThrobber write FThrobber;
                     property mInterface : ISharpBarModule read FModuleInterface;
                   end;

  TModuleManager = class
                   private
                     FDragForm          : TForm;
                     FDragLastBar       : hwnd;
                     FDragThrobber      : TSharpEMiniThrobber;
                     FDragReleaseTimer  : TTimer;
                     FDirectory         : String;
                     FModuleFiles       : TObjectList;
                     FModules           : TObjectList;
                     FParent            : hwnd;
                     FSkinInterface     : ISharpESkinInterface;
                     FBarInterface      : ISharpBar;
                     FBar               : TSharpEBar;
                     FThrobberMenu      : TPopupMenu;
                     FThrobberMovePoint : TPoint;
                     FThrobberMove      : Boolean;
                     FThrobberMoveID    : integer;
                     FModuleSpacing     : integer;
                     FShowMiniThrobbers : Boolean;
                     FShutdown          : Boolean;
                     FBarID             : integer;
                     FBarName           : string;
                     procedure SetShowMiniThrobbers(Value : Boolean);
                   public
                     constructor Create(pParent : hwnd;
                                        pSkinInterface : ISharpESkinInterface;
                                        pBarInterface : ISharpBar;
                                        pBar         : TSharpEBar); reintroduce;
                     destructor Destroy; override;
                     procedure Clear;
                     procedure UnloadModules;
                     procedure Unload(Item : TModule); overload;
                     procedure Unload(ID : integer); overload;
                     procedure Delete(ID : integer);
                     procedure Clone(ID : integer);
                     procedure CreateModule(MFID : integer; Position : integer; wnd : HWND = 0);
                     function LoadModule(ID : integer; Module : String; Position,Index : integer) : TModule; overload;
                     function LoadModule(ID : integer; FromBar: integer; Position,Index : integer) : TModule; overload;
                     procedure LoadFromDirectory(pDirectory : String);
                     procedure RefreshFromDirectory(pDirectory : String);
                     procedure FixModulePositions(ForceUpdate : boolean = False);
                     procedure SaveBarSettings;
                     function GetModule(ID : integer) : TModule;
                     function GetModuleIndex(ID : integer) : integer;
                     procedure SortModulesByPosition;
                     procedure RefreshMiniThrobbers;
                     procedure UpdateBarSize(PluginWidth : integer; ForceUpdate: boolean = False);
                     function GetFirstRModuleIndex : integer;
                     function GenerateModuleID : integer;
                     function GetFreeBarSpace : integer;
                     function GetMaxBarSpace : integer;
                     function GetModuleFileByFileName(pFileName : String) : TModuleFile;
                     function GetModuleFileIndexByFileName(pFileName : String) : Integer;
                     procedure MoveModule(Index, Direction : integer);
                     function SendPluginMessage(ID : integer; msg : string) : integer;
                     procedure BroadcastPluginMessage(msg : string);
                     procedure BroadcastPluginUpdate(part : TSU_UPDATE_ENUM; param : integer = 0);
                     procedure BroadCastModuleRefresh;
                     procedure ReCalculateModuleSize(Broadcast : boolean = True; ForceUpdate: boolean = False);
                     procedure OnMiniThrobberClick(Sender : TObject);
                     procedure OnMiniThrobberMouseDown(Sender : TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
                     procedure OnMiniThrobberMouseUp(Sender : TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
                     procedure OnMiniThrobberMouseMove(Sender : TObject; Shift: TShiftState; X, Y: integer);
                     procedure OnDragReleaseTimerOnTimer(Sender : TObject);
                     procedure DebugOutput(Msg: string; Level, msgtype: integer);
                     function GetModuleHeight : integer;
                     function GetModuleTop : integer;
                     procedure UpdateModuleHeights;

                     property ModuleDirectory : string       read FDirectory;
                     property Parent          : hwnd         read FParent;
                     property ModuleFiles     : TObjectList  read FModuleFiles;
                     property Modules         : TObjectList  read FModules;
                     property ThrobberMenu    : TPopupMenu   read FThrobberMenu write FThrobberMenu;
                     property ShowMiniThrobbers : Boolean    read FShowMiniThrobbers write SetShowMiniThrobbers;
                     property BarID           : integer      read FBarID write FBarID;
                     property BarName         : string        read FBarName write FBarName;
                     property SkinInterface   : ISharpESkinInterface read FSkinInterface;
                     property BarInterface    : ISharpBar read FBarInterface;
                   end;

implementation


uses SharpBarMainWnd,
     JclSimpleXML;



function GetControlByHandle(AHandle: THandle): TWinControl;
begin
 Result := Pointer(GetProp( AHandle,
                            PChar( Format( 'Delphi%8.8x',
                                           [GetCurrentProcessID]))));
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

// ############## TModuleManager #################

constructor TModuleManager.Create(pParent : hwnd;
                                  pSkinInterface : ISharpESkinInterface;
                                  pBarInterface : ISharpBar;
                                  pBar         : TSharpEBar);
begin
  inherited Create;
  FShutdown     := False;
  FDragLastBar  := 0;
  FDragForm     := nil;
  FParent       := pParent;
  FSkinInterface  := pSkinInterface;
  FBarInterface := pBarInterface;
  FBar          := pBar;
  FShowMiniThrobbers := True;
  FModuleSpacing := 4;
  FModules  := TObjectList.Create;
  FModules.Clear;
  FModuleFiles := TObjectList.Create;
  FModuleFiles.Clear;
  FDragReleaseTimer := TTimer.Create(nil);
  FDragReleaseTimer.Interval := 100;
  FDragReleaseTimer.Enabled := False;
  FDragReleaseTimer.OnTimer := OnDragReleaseTimerOnTimer;
end;

destructor TModuleManager.Destroy;
begin
  FShutdown := True;
  FBarInterface := nil;
  FSkinInterface := nil;
  Clear;
  FModules.Free;
  FModules := nil;
  FModuleFiles.Free;
  FModuleFiles := nil;
  inherited Destroy;
end;

procedure TModuleManager.SetShowMiniThrobbers(Value : Boolean);
begin
  FShowMiniThrobbers := Value;

  if FShowMiniThrobbers then
     FModuleSpacing := 4
     else FModuleSpacing := 6;
end;

procedure TModuleManager.OnDragReleaseTimerOnTimer(Sender : TObject);
begin
  FDragReleaseTimer.Enabled := False;
  if FDragThrobber <> nil then
  begin
    FDragThrobber.Free;
    FDragThrobber := nil;
  end;
  FBar.aform.Repaint;

  SortModulesByPosition;
  FixModulePositions;
  SaveBarSettings;

  SharpApi.BroadcastGlobalUpdateMessage(suCenter);

end;

// Sends an update message to all modules
procedure TModuleManager.BroadcastPluginUpdate(part : TSU_UPDATE_ENUM; param : integer = 0);
var
  n : integer;
  temp : TModule;
begin
  for n := 0 to FModules.Count - 1 do
  begin
    temp := TModule(FModules.Items[n]);
    if [part] <= [suBackground,suTheme,suSkinFileChanged,suScheme] then
    begin
      temp.UpdateBackground;
      temp.mInterface.Form.Repaint;
    end;
    temp.mInterface.UpdateMessage(part,param);
  end;
end;

// Broadcast a message to all modules
procedure TModuleManager.BroadCastPluginMessage(msg : string);
var
  n : integer;
  tempModule : TModule;
begin
  for n := FModules.Count - 1 downto 0 do
  begin
    tempModule := TModule(FModules.Items[n]);
    if tempModule.ModuleFile.Loaded then 
      tempModule.mInterface.ModuleMessage(msg);
  end;
end;

procedure TModuleManager.SaveBarSettings;
var
  xml: TJclSimpleXML;
  Dir: string;
  i: integer;
  tempModule: TModule;
begin
  DebugOutput('Saving Bar Settings', 1, 1);
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(FBarID) + '\';
  xml := TJclSimpleXMl.Create;
  try
    xml.Root.Name := 'SharpBar';

    // Save Bar Settings
    with xml.Root.Items.Add('Settings') do begin
      Items.AdD('Name', FBarName);
      Items.Add('AutoPosition', FBar.AutoPosition);
      Items.Add('PrimaryMonitor', FBar.PrimaryMonitor);
      Items.Add('MonitorIndex', FBar.MonitorIndex);
      Items.Add('HorizPos', HorizPosToInt(FBar.HorizPos));
      Items.Add('VertPos', VertPosToInt(FBar.VertPos));
      Items.Add('AutoStart', FBar.AutoStart);
      Items.Add('ShowThrobber', FBar.ShowThrobber);
      Items.Add('DisableHideBar', FBar.DisableHideBar);
      Items.Add('StartHidden', not FBar.aform.Visible);
      Items.Add('AlwaysOnTop', FBar.AlwaysOnTop);
      Items.Add('ShowMiniThrobbers', ModuleManager.ShowMiniThrobbers);
    end;

    // Save the Module List
    with xml.Root.Items.Add('Modules') do begin
      for i := 0 to ModuleManager.Modules.Count - 1 do begin
        tempModule := TModule(ModuleManager.Modules.Items[i]);
        with Items.Add('Item') do begin
          Items.Add('ID', tempModule.mInterface.ID);
          Items.Add('Position', tempModule.Position);
          Items.Add('Module', ExtractFileName(tempModule.ModuleFile.FileName));
        end;
      end;
    end;

    ForceDirectories(Dir);
    if FileCheck(Dir + 'Bar.xml') then
      xml.SaveToFile(Dir + 'Bar.xml');
  finally
    xml.Free;
  end;
end;

// Broadcast a message to a single module by ID
function TModuleManager.SendPluginMessage(ID : integer; msg : string) : integer;
var
  n : integer;
  tempModule : TModule;
begin
  result := 0;
  for n := 0 to FModules.Count - 1 do
  begin
    tempModule := TModule(FModules.Items[n]);
    if tempModule.mInterface.ID = ID then
    begin
      tempModule.mInterface.ModuleMessage(msg);
      exit;
    end;
  end;
end;

// Clone a Module
procedure TModuleManager.Clone(ID : integer);
var
  tempModule : TModule;
  newID : integer;
  Dir : String;
begin
  if GetFreeBarSpace < 50 then
     if MessageBox(Application.Handle,
                   'Your SharpBar is nearly full. Adding this module may cause' + #10#13 +
                   'overlap between modules, preventing you from accessing their throbbers.' + #10#13 +
                   'Continue anyway?','Confirm: Clone Module',MB_YESNO or MB_ICONWARNING) = IDNO then exit;

  tempModule := TModule(GetModule(ID));
  if tempModule = nil then exit;

  newID := GenerateModuleID;
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(FBarID) + '\';
  if FileExists(Dir + inttostr(ID) + '.xml') then
    CopyFile(PChar(Dir + inttostr(ID) + '.xml'),PChar(Dir + inttostr(NewID) + '.xml'),False);

  LoadModule(newID,ExtractFileName(tempModule.ModuleFile.FileName),TempModule.Position,GetModuleIndex(ID)+1);
  SharpCenterApi.BroadcastCenterMessage(integer(suModule),0);
end;

// Delete and Module (also deletes the module settings)
procedure TModuleManager.DebugOutput(Msg: string; Level, msgtype: integer);
begin
  if (Debug) and (Level <= DebugLevel) then
    SharpAPI.SendDebugMessageEx('SharpBar', PChar(Msg), clBlack, msgtype);
end;

procedure TModuleManager.Delete(ID : integer);
var
  n,i : integer;
  TempModule : TModule;
  MF : TModuleFile;
  hm : boolean;
  Dir : String;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(FBarID) + '\';
  for n := 0 to FModules.Count - 1 do
  begin
    TempModule := TModule(FModules.Items[n]);
    if TempModule.mInterface.ID = ID then
    begin
      MF := TempModule.ModuleFile;
      TempModule.mInterface.CloseModule;
      FModules.Delete(n);

      if FileExists(Dir + inttostr(ID) + '.xml') then
        DeleteFile(Dir + inttostr(ID) + '.xml');

      if FileExists(Dir + IntToStr(ID) + '.xml_bak') then
        DeleteFile(Dir + IntToStr(ID) + '.xml_bak');

      // Check if the same module file has other modules loaded...
      hm := False;
      for i := 0 to FModules.Count - 1 do
      begin
        if TModule(FModules.Items[i]).ModuleFile = MF then
        begin
          hm := True;
          break;
        end;
      end;
      if not hm then
         MF.UnloadDll; // No other modules loaded by that Module File... unload the dll

      BroadCastModuleRefresh;
      FixModulePositions;

      exit;
    end;
  end;
end;

// Unload all modules
procedure TModuleManager.UnloadModules;
begin
  while FModules.Count <> 0 do
    Unload(TModule(FModules.Items[0]));
end;

procedure TModuleManager.Unload(Item : TModule);
var
  MF : TModuleFile;
  hm : boolean;
  i : integer;
begin
  if Item = nil then
    exit;

  MF := Item.ModuleFile;
  Item.mInterface.CloseModule;
  FModules.Remove(Item);

  // Check if the same module file has other modules loaded...
  hm := False;
  for i := 0 to FModules.Count - 1 do
  begin
    if TModule(FModules.Items[i]).ModuleFile = MF then
    begin
      hm := True;
      break;
    end;
  end;
  if not hm then
    MF.UnloadDll; // No other modules loaded by that Module File... unload the dll

  FixModulePositions;
end;

// Unload a module
procedure TModuleManager.Unload(ID : integer);
var
  n : integer;
  TempModule : TModule;
begin
  for n := 0 to FModules.Count - 1 do
  begin
    TempModule := TModule(FModules.Items[n]);
    if TempModule.mInterface.ID = ID then
    begin
      Unload(TempModule);
      exit;
    end;
  end;
end;

// Gets the index of the first module which is aligned at the right of the bar
// make sure that SortModulesByPosition has been called before using this
// returns -1 if there is no right aligned module
function TModuleManager.GetFirstRModuleIndex : integer;
var
  n : integer;
begin
  for n := 0 to FModules.Count -1 do
      if TModule(FModules.Items[n]).Position <> -1 then
      begin
        result := n;
        exit;
      end;
  result := -1;
end;

// Sort the TObjectList to have all left aligned modules at the top of the list
// stupid but simple sort function,
// not the most effective way but we are just changing some Index numbers
// of class pointers - so don't panic ;)
procedure TModuleManager.SortModulesByPosition;
var
  n : integer;
  LC,RC : integer;
  bsdone : boolean;
begin
  LC := 0;
  RC := 0;
  for n := 0 to FModules.Count -1 do
      if TModule(FModules.Items[n]).Position = -1 then
         LC := LC + 1
         else RC := RC + 1;
  if (RC = 0) or (LC = 0) or (FModules.Count <= 1) then exit;

  repeat
    bsdone := True;
    for n := 1 to FModules.Count -1 do
        if (TModule(FModules.Items[n]).Position = -1) and
           (TModule(FModules.Items[n-1]).Position <> -1) then
           FModules.Exchange(n-1,n);

    for n := 0 to FModules.Count -1 do
        if (TModule(FModules.Items[n]).Position = -1) and (n > LC - 1) then
           bsdone := False;
  until bsdone;

end;


// Move a module around!
// make sure to call
//   ModuleManager.SortModulesByPosition;
//   ModuleManager.FixModulePositions;
// after all movements are done!
// Param: Direction:integer ::: -1 == Left, 1 == Right
procedure TModuleManager.MoveModule(Index, Direction : integer);
var
  tm : TModule;
  ri : integer;
begin
  if (Index <0) or (Index>FModules.Count -1) then exit;
  tm := TModule(FModules.Items[Index]);
  ri := GetFirstRModuleIndex;
  if (Direction = -1) then
  begin
    if (Index = 0) and (ri <> 0) then exit;
    if Index = ri then tm.Position := -1
       else FModules.Exchange(Index, Index -1);
  end else
  begin
    if (Index = FModules.Count -1) and (ri <> -1) then exit;
    if ri = -1 then ri := FModules.Count;
    if Index = ri -1 then tm.Position := 1
       else FModules.Exchange(Index, Index +1);
  end;
end;


procedure TModuleManager.Clear;
begin
  UnloadModules;
  while FModuleFiles.Count <> 0 do
        FModuleFiles.Delete(0);
end;

// Generate a unique ID for a new module
function TModuleManager.GenerateModuleID : integer;
var
  n : integer;
  s : string;
  b : boolean;
begin
  repeat
    b := True;
    setlength(s,0);
    for n := 0 to 6 do s := s + inttostr(random(10));
    for n := 0 to FModules.Count -1 do
        if TModule(FModules.Items[n]).mInterface.ID = strtoint(s) then
        begin
          b := false;
          break;
        end;
  until b;
  result := strtoint(s);
end;

procedure TModuleManager.CreateModule(MFID : integer; Position : integer; wnd : HWND);
var
  tempModuleFile : TModuleFile;
begin
  if MFID > FModuleFiles.Count - 1 then exit;

  if InSendMessage then
    ReplyMessage(0);

  if GetFreeBarSpace < 50 then
     if MessageBox(wnd,
                   'There may not be space on your bar for a new module.' + #10#13 +
                   'Adding another module might cause modules to overlap each other.' + #10#13 +
                   'Do you want to continue?','Confirm: New Module',MB_YESNO or MB_ICONWARNING or MB_APPLMODAL) = IDNO then exit;
  tempModuleFile := TModuleFile(FModuleFiles.Items[MFID]);
  LoadModule(GenerateModuleID,ExtractFileName(tempModuleFile.FFileName),Position,-1);
  ReCalculateModuleSize;
end;

// Special load funtion which copies a module from another bar!
function TModuleManager.LoadModule(ID : integer; FromBar: integer; Position,Index : integer) : TModule;
var
  DirA,DirB,Module : String;
  XML : TJclSimpleXML;
  n : integer;
  fileloaded : boolean;
begin
  // Import the module settings from the temporary file
  DirA := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(FromBar) + '\';
  DirB := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(FBarID) + '\';

  CopyFile(PChar(DirA + inttostr(ID) + '.xml'),PChar(DirB + inttostr(ID) + '.xml'),False);

  // find what module it is
  XML := TJclSimpleXML.Create;
  fileloaded := False;
  try
    if FileCheck(DirA + 'Bar.xml',True) then
    begin
      XML.LoadFromFile(DirA + 'Bar.xml');
      fileloaded := True;
    end;
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpBar',PChar('(LoadModuleSpecial): Error loading '+ DirA + 'Bar.xml'), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpBar',PChar(E.Message),clblue, DMT_TRACE);
    end;
  end;
  if fileloaded then
    if XML.Root.Items.ItemNamed['Modules'] <> nil then
      with XML.Root.Items.ItemNamed['Modules'].Items do
        for n := 0 to Count - 1 do
          if Item[n].Items.IntValue('ID',-1) = ID then
          begin
            Module := Item[n].Items.Value('Module','');
            break;
          end;
  XML.Free;

  if length(Module) > 0 then
     result := LoadModule(ID,Module,Position,Index)
     else result := nil;
end;

function TModuleManager.LoadModule(ID : integer; Module : String; Position, Index : integer) : TModule;
var
 n : integer;
 pFile : TModuleFile;
 pModule : TModule;
begin
  result := nil;
  if (ID = -1) or (length(Module)=0) then exit;

  for n := 0 to FModuleFiles.Count -1 do
  begin
    pFile := TModuleFile(FModuleFiles.Items[n]);
    if ExtractFileName(pFile.FileName) = Module then
    begin
      pModule := TModule.Create(FBar.aform,pFile,ID,FBarID,FParent,Position,self);
      if Index <> -1 then FModules.Insert(Index,pModule)
         else FModules.Add(pModule);
      pModule.mInterface.InitModule;
      result := pModule;
    end;
  end;
  SortModulesByPosition;
end;

function TModuleManager.GetModuleFileByFileName(pFileName : String) : TModuleFile;
var
  n : integer;
  temp : TModuleFile;
begin
  for n := 0 to FModuleFiles.Count - 1 do
  begin
    temp := TModuleFile(FModuleFiles.Items[n]);
    if (CompareText(temp.FFileName,pFileName) = 0)
      or (CompareText(ExtractFileName(temp.FFileName),pFileName) = 0) then
    begin
      result := temp;
      exit;
    end;
  end;
  result := nil;
end;

function TModuleManager.GetModuleFileIndexByFileName(pFileName: String): Integer;
var
  n : integer;
  temp : TModuleFile;
begin
  for n := 0 to FModuleFiles.Count - 1 do
  begin
    temp := TModuleFile(FModuleFiles.Items[n]);
    if (CompareText(temp.FFileName,pFileName) = 0)
      or (CompareText(ExtractFileName(temp.FFileName),pFileName) = 0) then
    begin
      result := n;
      exit;
    end;
  end;
  result := -1;
end;

function TModuleManager.GetModuleHeight: integer;
begin
  result := FSkinInterface.SkinManager.Skin.Bar.BarHeight -
            FSkinInterface.SkinManager.Skin.Bar.PAYoffset.X -
            FSkinInterface.SkinManager.Skin.Bar.PAYoffset.Y;
end;

// Load all module dll files from a directory
procedure TModuleManager.RefreshFromDirectory(pDirectory : string);
var
  sr : TSearchRec;
  temp : TModuleFile;
begin
  {$WARNINGS OFF}
  FDirectory := IncludeTrailingBackSlash(pDirectory);
  {$WARNINGS ON}
  if FindFirst(FDirectory + '*.dll',FAAnyFile,sr) = 0 then
  repeat
    if GetModuleFileByFileName(FDirectory + sr.Name) = nil then
    begin
      temp := TModuleFile.Create(FDirectory + sr.Name);
      FModuleFiles.Add(temp);
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
end;

procedure TModuleManager.LoadFromDirectory(pDirectory : string);
begin
  Clear;
  RefreshFromDirectory(pDirectory);
end;

// Calculate and return how much free bar space is left
function TModuleManager.GetFreeBarSpace : integer;
var
  n : integer;
  size : integer;
  pModule : TModule;
begin
  // get size of all modules
  size := 0;
  for n := 0 to FModules.Count - 1 do
  begin
    pModule := TModule(FModules.Items[n]);
    size := size + pModule.mInterface.MinSize;
    if pModule.Throbber.Visible then
       size := size + pModule.Throbber.Width + FModuleSpacing
       else size := size + FModuleSpacing;
  end;

  result := GetMaxBarSpace - size;
end;

// Calculate how much space is available
// This function also takes care of other SharpBar windows which are
// poditioned at the same screen border!
function TModuleManager.GetMaxBarSpace : integer;
var
  maxsize : integer;
  pForm : TWinControl;
  pMon : TMonitorItem;
  lo,ro : integer;
  harray : THandleArray;
  n : integer;
  R : TRect;
  freespace : integer;
  MTWidth : integer;
  mbar : boolean;
begin
  pForm := GetControlByHandle(FParent);

  // get screen size
  pMon := MonList.MonitorFromPoint(Point(pForm.Left,pForm.Top),mdNearest);
  if pMon = nil then
     pMon := MonList.FindMonitor(TForm(pForm).Monitor.Handle);
  if pMon = nil then
  begin
    result := 0;
    exit;
  end;
  maxSize := pMon.Width;

  setlength(harray,0);
  // find all SharpBar windows and store their handle in harray
  harray := FindAllWindows('TSharpBarMainForm');
  mbar := False;
  for n := 0 to High(harray) do
  begin
    if harray[n] <> pForm.Handle then
    begin
      GetWindowRect(harray[n],R);
      // another bar on the same monitor with the same top position ?
      if (R.Top = pForm.Top) and (MonList.MonitorFromPoint(R.TopLeft,mdNearest) = pMon) then
      begin
        freespace := GetWindowLong(harray[n],GWL_USERDATA);
        if (FBar.HorizPos = hpLeft) or (FBar.HorizPos = hpRight) then
        begin
          if (R.Left > pMon.Left) and (R.Left < pMon.Left + pMon.Width div 2) then
          begin
            mbar := True;
            MaxSize := R.Left - pMon.Left + freespace div 2;
          end else if (not mbar) then
                       MaxSize := MaxSize - (R.Right - R.Left) + freespace div 2;
        end else MaxSize := Min(MaxSize,pMon.Width - 2 * (R.Right - R.Left) + freespace div 2);
      end;
    end;
  end;
  setlength(harray,0);

  if (FModules.Count > 0) and (FShowMiniThrobbers) then
     MTWidth := TModule(FModules.Items[0]).Throbber.Width
     else MTWidth := 0;

  // get left/right offets for plugin area
  if FBar.ShowThrobber then
    lo := FSkinInterface.SkinManager.Skin.Bar.PAXoffset.X
  else lo := FBar.Throbber.Left;
  ro := FSkinInterface.SkinManager.Skin.Bar.PAXoffset.Y;

  result := maxsize - ro - lo - FModules.Count * MTWidth;
end;

function TModuleManager.GetModuleIndex(ID : integer) : integer;
var
  n : integer;
begin
  for n := 0 to FModules.Count - 1 do
      if TModule(FModules.Items[n]).mInterface.ID = ID then
      begin
        result := n;
        exit;
      end;
  result := -1;
end;

function TModuleManager.GetModuleTop: integer;
begin
  result := FSkinInterface.SkinManager.Skin.Bar.PAYoffset.X;
end;

function TModuleManager.GetModule(ID : integer) : TModule;
var
  n : integer;
begin
  for n := 0 to FModules.Count - 1 do
      if TModule(FModules.Items[n]).mInterface.ID = ID then
      begin
        result := TModule(FModules.Items[n]);
        exit;
      end;
  result := nil;
end;

procedure TModuleManager.OnMiniThrobberMouseMove(Sender : TObject; Shift: TShiftState; X, Y: integer);
var
  MP : TPoint;
  checkModule,tempModule : TModule;
  index : integer;
  i,n : integer;
  cPos,Pos : TPoint;
  update : boolean;
  pForm : TForm;
  BR : TBarRect;
  b : boolean;
begin
  if FThrobberMoveID = -1 then exit;
  if Shift = [ssLeft] then
  begin
    if not GetCursorPosSecure(MP) then
      exit;

    if not FThrobberMove then
    begin
      // Make sure the mouse was moved more than a few pixels before starting the move bar code
      if (abs(FThrobberMovePoint.X - MP.X) > 32)
         or (abs(FThrobberMovePoint.Y - MP.Y) > 32) then
         FThrobberMove := True
         else exit;
    end;
    pForm := TForm(GetControlByHandle(FParent));
    if (FThrobberMove and PointInRect(MP,Rect(pForm.Left,
                                              pForm.Top,
                                              pForm.Left + pForm.Width,
                                              pForm.Top + pForm.Height))) then
    begin
      if FDragForm <> nil then FreeAndNil(FDragForm);
      update := False;
      tempModule := GetModule(FThrobberMoveID);
      if tempModule = nil then exit;
      index := FModules.IndexOf(TempModule);
      pos := tempModule.mInterface.Form.ClientToScreen(Point(tempModule.mInterface.Form.Left,0));
      if index>0 then
      begin
        checkModule := TModule(FModules.Items[index -1]);
        Cpos := FBar.aform.ClientToScreen(Point(CheckModule.mInterface.Form.Left,0));
        if MP.X <= CPos.X + CheckModule.mInterface.Form.Width then
        begin
          if (MP.X <= CPos.X) and
             ((FBar.HorizPos <> hpFull) or
             ((FBar.HorizPos = hpFull) and (checkmodule.Position = tempModule.Position))) then
          begin
            i := checkmodule.Position;
            checkmodule.Position := tempModule.Position;
            tempModule.Position := i;
            FModules.Exchange(index,index-1);
            update := true;
          end
          else if (checkmodule.Position <> tempModule.Position) then
               begin
                 tempModule.Position := checkModule.Position;
                 update := true;
               end;
        end
      end
      else if (index = 0) and (tempModule.Position = 1)
              and (MP.X < FBar.aform.Left + 100) then
      begin
        tempModule.Position := -1;
        Update := True;
      end;
      if (index < FModules.Count - 1) then
      begin
        checkModule := TModule(FModules.Items[index +1]);
        Cpos := FBar.aform.ClientToScreen(Point(CheckModule.mInterface.Form.Left,0));
        if MP.X >= CPos.X then
        begin
          if (MP.X >= CPos.X + CheckModule.mInterface.Form.Width) and
             ((FBar.HorizPos <> hpFull) or
             ((FBar.HorizPos = hpFull) and (checkmodule.Position = tempModule.Position))) then
          begin
            i := checkmodule.Position;
            checkmodule.Position := tempModule.Position;
            tempModule.Position := i;
            FModules.Exchange(index,index+1);
            update := true;
          end
          else if (checkmodule.Position <> tempModule.Position) then
               begin
                 tempModule.Position := checkModule.Position;
                 update := true;
               end;
        end;
      end
      else if (index = FModules.Count - 1) and (tempModule.Position = -1)
              and (MP.X > FBar.aform.Left + FBar.aform.Width-100) then
      begin
        tempModule.Position := 1;
        update := true;
      end;

      if Update then
      begin
        SortModulesByPosition;
        FixModulePositions;
        exit;
      end;
    end else if (FThrobberMove) then // Mouse Moving but no in Bar Rect
    begin
      b := False;
      for n := 0 to SharpApi.GetSharpBarCount - 1 do
      begin
        BR := SharpApi.GetSharpBarArea(n);
        if (BR.Wnd <> FParent) and (PointInRect(MP,BR.R)) then
        begin
          // Mouse is in another bar!
          if FDragLastBar <> BR.Wnd then
          begin
            tempModule := GetModule(FThrobberMoveID);
            if tempModule = nil then exit;

            FDragThrobber := tempModule.Throbber;
            FDragThrobber.Visible := False;
            tempmodule.throbber := nil; // The Throbber must be released after
                                        // the event has finished
            FreeAndNil(FDragForm);
            FDragLastBar := BR.Wnd;
            SendMessage(BR.wnd,WM_BARINSERTMODULE,FThrobberMoveID,FBarID);
            Delete(FThrobberMoveID);            
            FThrobberMove := False;
            FThrobberMoveID := -1;
            b := True;
            TSharpBarMainForm(Application.MainForm).SaveBarSettings;
          end;
          break;
        end;
      end;

      if not b then
      begin
        tempModule := GetModule(FThrobberMoveID);
        if tempModule = nil then exit;

        if FDragForm = nil then
        begin
          FDragForm := TForm.Create(nil);
          FDragForm.Width := tempModule.mInterface.Form.Width;
          FDragForm.Height := tempModule.mInterface.Form.Height;
          FDragForm.BorderStyle := bsNone;
          SetWindowLong(FDragForm.handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
          FDragForm.AlphaBlend := True;
          FDragForm.AlphaBlendValue := 128;
          FDragForm.Show;
        end;
        FDragForm.Left := MP.X;
        FDragForm.Top := MP.Y;
        FDragForm.Canvas.Lock;
        tempModule.mInterface.Form.PaintTo(FDragForm.Canvas.Handle,0,0);
        FDragForm.Canvas.Unlock;
      end;
    end;
  end;
end;

procedure TModuleManager.OnMiniThrobberMouseUp(Sender : TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FThrobberMoveID := -1;
  if FDragForm <> nil then FreeAndNil(FDragForm);
  FDragReleaseTimer.Enabled := True;
  FDragLastBar := 0;
  if FThrobberMove then FThrobberMove := False;
end;

procedure TModuleManager.OnMiniThrobberMouseDown(Sender : TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  mThrobber : TSharpEMiniThrobber;
  tempModule : TModule;
  MP : TPoint;
begin
  mThrobber := TSharpEMiniThrobber(Sender);
  if (mThrobber = nil) or (FThrobberMenu = nil) then exit;
  tempModule := GetModule(mThrobber.Tag); // tag = module ID
  if tempModule = nil then exit;

  if Button = mbLeft then
  begin
    if not GetCursorPosSecure(MP) then
      exit;

    if FDragForm <> nil then FreeAndNil(FDragForm);
    FDragLastBar := 0;
    FThrobberMovePoint := MP;
    FThrobberMoveID    := mThrobber.Tag;
  end else FThrobberMove := False;
end;

procedure TModuleManager.OnMiniThrobberClick(Sender : TObject);
var
  mThrobber : TSharpEMiniThrobber;
  tempModule : TModule;
  p : TPoint;
  n : integer;
  s : String;
  cfile : String;
begin
  mThrobber := TSharpEMiniThrobber(Sender);
  if (mThrobber = nil) or (FThrobberMenu = nil) then exit;
  tempModule := GetModule(mThrobber.Tag); // tag = module ID
  if tempModule = nil then exit;
  p.x := mThrobber.Left + mThrobber.Width;
  p.y := mThrobber.Top;
  p := mThrobber.Parent.ClientToScreen(p);
  FThrobberMenu.PopupComponent := mThrobber;

  // search the settings menu item and enable/disable it
  // settings menu item has .tag = -1
  s := ExtractFileName(tempModule.ModuleFile.FileName);
  setlength(s,length(s) - length(ExtractFileExt(s)));
  cfile := SharpApi.GetCenterDirectory + '_Modules\' + s + '.con';

  for n := 0 to FThrobberMenu.Items.Count - 1 do
  begin
      if FThrobberMenu.Items.Items[n].Tag = -1 then
      begin
        if (not FileExists(cfile)) then
           FThrobberMenu.Items.Items[n].Enabled := False
           else FThrobberMenu.Items.Items[n].Enabled := True;
        break;
      end;
  end;

  FThrobberMenu.Popup(p.x,p.y);
end;

procedure TModuleManager.BroadCastModuleRefresh;
var
  n : integer;
  pModule : TModule;
begin
  for n := 0 to FModules.Count -1 do
  begin
    pModule := TModule(FModules.Items[n]);
    pModule.UpdateBackground;
    pModule.mInterface.Refresh;
  end;
end;

// Update the position of all modules and their mini throbbers
// This will also update the main window width
procedure TModuleManager.FixModulePositions(ForceUpdate : boolean = False);
var
  n,i : integer;
  ro,lo,rx,x : integer;
  TempModule     : TModule;
  ParentControl  : TWinControl;
  LeftSize,RightSize : integer;
  MTWidth : integer; // mini Throbbers
  RCount,LCount : integer;
  nw : integer;
  CList : TObjectList;
begin
  if FShutdown then exit;

  if FBar.ShowThrobber then
    lo := FSkinInterface.SkinManager.Skin.Bar.PAXoffset.X
  else lo := FBar.Throbber.Left;
  ro := FSkinInterface.SkinManager.Skin.Bar.PAXoffset.Y;

  ParentControl := GetControlByHandle(FParent);

  if (FModules.Count > 0) and (FShowMiniThrobbers) then
     MTWidth := TModule(FModules.Items[0]).Throbber.Width+FModuleSpacing
     else MTWidth := FModuleSpacing;

  LeftSize := 0;
  RightSize := 0;
  // Get the overall bar size
  for n := 0 to FModules.Count -1 do
  begin
    TempModule := TModule(FModules.Items[n]);
    if TempModule.Position = -1 then LeftSize := LeftSize + TempModule.mInterface.Form.Width + MTWidth
       else RightSize := RightSize + TempModule.mInterface.Form.Width + MTWidth;
  end;

  if not (FBar.HorizPos = hpFull) then
     if lo + ro + LeftSize + RightSize <> ParentControl.Width then
  begin
    nw := Max(lo + ro + FSkinInterface.SkinManager.Skin.Bar.ThrobberWidth+5,lo + ro + LeftSize + RightSize);
    FBar.UpdateSkin(nw);
    ParentControl.Width := nw;
  end;

  if FBar.HorizPos = hpFull then SetWindowLong(ParentControl.Handle,GWL_USERDATA,0);
//     else SetWindowLong(ParentControl.Handle,GWL_USERDATA,Max(ParentControl.Width - lo - ro - LeftSize - Rightsize,0));

  x := 0;
  rx := 0;
  RCount := 0;
  LCount := 0;
  CList := TObjectList.Create(False);
  for n := 0 to FModules.Count -1 do
  begin
    TempModule := TModule(FModules.Items[n]);
    if TempModule.Position = -1 then
    begin
      LCount := LCount + 1;
      i := lo + x + MTWidth*(LCount);
      if (TempModule.mInterface.Form.Left <> i) or (ForceUpdate) then
      begin
        TempModule.UpdateBackgroundL(i);
        TempModule.mInterface.Left := i;
        Clist.Add(TempModule);
      end;
      x := x + TempModule.mInterface.Form.Width;
    end else
    begin
      RCount := RCount + 1;
      if not (FBar.HorizPos = hpFull) then
         i := lo + LeftSize + rx + MTWidth*(RCount)
         else i := ParentControl.Width - ro - RightSize + rx + MTWidth*(RCount);
      if (i <> TempModule.mInterface.Form.Left) or (ForceUpdate) then
      begin
        TempModule.UpdateBackgroundL(i);
        TempModule.mInterface.Left := i;
        CList.Add(TempModule);
      end;
      rx := rx + TempModule.mInterface.Form.Width;
    end;
    if TempModule.mInterface.Form.Top <> FSkinInterface.SkinManager.Skin.Bar.PAYoffset.X then
      TempModule.mInterface.Form.Top  := FSkinInterface.SkinManager.Skin.Bar.PAYoffset.X;
    if TempModule.Throbber. Left <> TempModule.mInterface.Form.Left-TempModule.Throbber.Width-FModuleSpacing div 2 then
      TempModule.Throbber.Left := TempModule.mInterface.Form.Left-TempModule.Throbber.Width-FModuleSpacing div 2;
    if TempModule.Throbber.Top <> TempModule.mInterface.Form.Top then
      TempModule.Throbber.Top  := TempModule.mInterface.Form.Top;
    TempModule.Throbber.Bottom := (FBar.VertPos = vpBottom);
    TempModule.Throbber.OnClick := OnMiniThrobberClick;
    TempModule.Throbber.OnMouseDown := OnMiniThrobberMouseDown;
    TempModule.Throbber.OnMouseMove := OnMiniThrobberMouseMove;
    TempModule.Throbber.OnMouseUp   := OnMiniThrobberMouseUp;
    if (FShowMiniThrobbers) and (not TempModule.Throbber.Visible) then TempModule.Throbber.Visible := True
       else if (not FShowMiniThrobbers) then tempModule.Throbber.Visible := False;
  end;

  for n := 0 to CList.Count -1 do
  begin
    TempModule := TModule(CList.Items[n]);
    TempModule.mInterface.Form.Repaint;
  end;
  CList.Clear;
  CList.Free;
end;


procedure TModuleManager.RefreshMiniThrobbers;
var
  TempModule : TModule;
  n : integer;
begin
  if not ShowMiniThrobbers then
    exit;
    
  for n := 0 to FModules.Count -1 do
  begin
    TempModule := TModule(FModules.Items[n]);
    TempModule.Throbber.Bottom := (FBar.VertPos = vpBottom);
    TempModule.Throbber.UpdateSkin;
    TempModule.Throbber.Invalidate;
  end;
end;

// Calculate and update the size of the bar
procedure TModuleManager.UpdateBarSize(PluginWidth : integer; ForceUpdate: boolean = False);
var
  lo,ro : integer;
  MTWidth : integer;
  ParentControl : TWinControl;
  nw : integer;
begin
  if FBar.ShowThrobber then
    lo := FSkinInterface.SkinManager.Skin.Bar.PAXoffset.X
  else lo := FBar.Throbber.Left;
  ro := FSkinInterface.SkinManager.Skin.Bar.PAXoffset.Y;
  
  ParentControl := GetControlByHandle(FParent);

  if (FModules.Count > 0) and (FShowMiniThrobbers) then
     MTWidth := TModule(FModules.Items[0]).Throbber.Width+FModuleSpacing
     else MTWidth := FModuleSpacing;

  PluginWidth := PluginWidth + MTWidth * FModules.Count;

  if ((ForceUpdate) or ((not (FBar.HorizPos = hpFull)) and (lo + ro + PluginWidth <> ParentControl.Width))) then
  begin
    nw := Max(lo + ro + FSkinInterface.SkinManager.Skin.Bar.ThrobberWidth + 5,lo + ro + PluginWidth);
    FBar.UpdatePosition(nw);
//    FBar.UpdateSkin(nw);
    ParentControl.Width := nw;
  end;
end;

procedure TModuleManager.UpdateModuleHeights;
var
  n : integer;
  temp : TModule;
  t,h : integer;
begin
  t := GetModuleTop;
  h := GetModuleHeight;
  for n := 0 to FModules.Count - 1 do
  begin
    temp := TModule(FModules.Items[n]);
    temp.UpdateBackgroundS(GetModuleTop,GetModuleHeight);
    temp.mInterface.SetTopHeight(t,h);
    temp.mInterface.Form.Repaint;
  end;
end;

// Calculate how much space every module is taking and check how much free bar
// space is left. Adjust the size of modules with dynamic size (task list,...)
// if there is more space needed or of the dynamic module can have more space.
procedure TModuleManager.ReCalculateModuleSize(Broadcast : boolean = True; ForceUpdate: boolean = False);
type
  TModuleSize = record
                  Min : integer;
                  Max : integer;
                end;
var
  n : integer;
  temp : TModule;
  msize : TModuleSize;
  i : integer;
  minsize : integer;
  maxsize : integer;
  maxbarsize : integer;
  FreeMinSpace : integer;
  nonminmaxrequest : array of integer;
  smod : integer;
  harray : THandleArray;
  ParentControl : TWinControl;
  pMon : TMonitorItem;
  R : TRect;
  newsize : integer;
  csize : integer;
  sdif : integer;
begin
  if FShutdown then exit;
  if FModules = nil then exit;

  minsize := 0;
  maxsize := 0;
  smod    := 0;
  setlength(nonminmaxrequest,0);
  maxbarsize := GetMaxBarSpace;
  for n := 0 to FModules.Count - 1 do
  begin
    temp := TModule(FModules.Items[n]);
    msize.Min := temp.mInterface.MinSize;
    msize.Max := temp.mInterface.MaxSize;
    minsize := minsize + mSize.Min;
    maxsize := maxsize + mSize.Max;
    smod := smod + FModuleSpacing;
    if msize.Min <> msize.Max then
    begin
      setlength(nonminmaxrequest,length(nonminmaxrequest)+1);
      nonminmaxrequest[High(nonminmaxrequest)] := abs(msize.Max - msize.Min);
    end;
  end;

  FreeMinSpace := Max(0,maxbarsize - minsize - smod);
  if (length(nonminmaxrequest) > 0) and (FreeMinSpace > 0) and (maxsize > maxbarsize - smod)then
  begin
    for n := 0 to High(nonminmaxrequest) do
        nonminmaxrequest[n] := round(Int(((nonminmaxrequest[n])/(maxsize - minsize))*FreeMinSpace));
  end;

  newsize := 0;
  // Calculate new bar size
  i := 0;
  csize := 0;
  for n := 0 to FModules.Count - 1 do
  begin
    temp := TModule(FModules.Items[n]);
    msize.Min := temp.mInterface.MinSize;
    msize.Max := temp.mInterface.MaxSize;
    csize := csize + msize.Min;
    if csize > maxbarsize - smod then
       newsize := newsize + 1
    else
    begin
      if msize.Min <> msize.Max then
         newsize := newsize + msize.Min + nonminmaxrequest[i]
      else newsize := newsize + msize.Min;
    end;
    if msize.Min <> msize.Max then
       i := i + 1;
  end;
  UpdateBarSize(newsize,ForceUpdate);

  // Send update messages to modules
  i := 0;
  csize := 0;
  for n := 0 to FModules.Count - 1 do
  begin
    temp := TModule(FModules.Items[n]);
    msize.Min := temp.mInterface.MinSize;
    msize.Max := temp.mInterface.MaxSize;
    csize := csize + msize.Min;
    if csize > maxbarsize - smod then
    begin
      // module out of bar area... hide it and make it small...
      // Check if the module is too big...
      temp.mInterface.Form.Visible := False;
      temp.mInterface.Size := 1;
    end else
    begin
      if not temp.mInterface.Form.Visible then
         temp.mInterface.Form.Visible := True;
      if msize.Min <> msize.Max then
        newsize := msize.Min + nonminmaxrequest[i]
      else newsize := msize.Min;
      if temp.mInterface.Size <> newsize then
      begin
        temp.UpdateBackgroundW(newsize);
        temp.mInterface.Size := newsize;
      end;
    end;
    if msize.Min <> msize.Max then
       i := i + 1;
  end;

  setlength(nonminmaxrequest,0);
  FixModulePositions;

  ParentControl := GetControlByHandle(FParent);
  sdif := maxsize - minsize;

  // Check if there is no bar space left and if other bars which have
  // free space left should resize
  pMon := MonList.MonitorFromPoint(Point(ParentControl.Left,ParentControl.Top),mdNearest);
  maxSize := pMon.Width - ParentControl.Width;

  setlength(harray,0);

  if Broadcast then
  begin
    SetWindowLong(ParentControl.Handle,GWL_USERDATA,0);
    // find all SharpBar windows and store their handle in harray
    harray := FindAllWindows('TSharpBarMainForm');
    for n := 0 to High(harray) do
      if harray[n] <> ParentControl.Handle then
      begin
        GetWindowRect(harray[n],R);
        // another bar on the same monitor with the same top position?
        if (R.Top = ParentControl.Top) and (MonList.MonitorFromPoint(R.TopLeft,mdNearest) = pMon) then
            MaxSize := MaxSize - (R.Right - R.Left);
      end;
  //  if MaxSize < 0 then
      for n := 0 to High(harray) do
        if harray[n] <> ParentControl.Handle then
        begin
          GetWindowRect(harray[n],R);
          // another bar on the same monitor with the same top position?
          if (R.Top = ParentControl.Top) and (MonList.MonitorFromPoint(R.TopLeft,mdNearest) = pMon) then
          begin
            //freespace := GetWindowLong(harray[n],GWL_USERDATA);
            //if (MaxSize < 0) and (FreeSpace > 0) then
            begin
               PostMessage(harray[n],WM_UPDATEBARWIDTH,1,0);
               break;
            end;
          end;
        end;
    setlength(harray,0);
  end;
  SetWindowLong(ParentControl.Handle,GWL_USERDATA,abs(sdif));
  RefreshMiniThrobbers;
end;


// ############## TModuleFile #################

constructor TModuleFile.Create(pFileName : String);
begin
  Inherited Create;
  FFileName        := pFileName;
  FLoaded          := False;

  DllCreateModule := nil;
end;

destructor TModuleFile.Destroy;
begin
  Inherited Destroy;
  UnloadDll;
end;


procedure TModuleFile.LoadDll;
begin
  UnloadDll;

  if not FileExists(FileName) then exit;

  try
    FDllHandle := LoadLibrary(PChar(FFileName));

    if FDllHandle <> 0 then
      @DllCreateModule := GetProcAddress(FDllHandle, 'CreateModule');

    if (@DllCreateModule = nil) then
    begin
      FreeLibrary(FDllhandle);
      FDllhandle := 0;
      DllCreateModule := nil;
      exit;
    end;

    FLoaded := True;
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpBar',PChar('Error loading ' + FileName), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpBar',PChar(E.Message),clblue, DMT_TRACE);
      try
        FreeLibrary(FDllhandle);
      finally
        FDllHandle := 0;
      end;
    end;
  end;
end;

procedure TModuleFile.UnloadDll;
begin
  Clear;

  try
    if not FLoaded then exit;
    FreeLibrary(FDllHandle);
  finally
    FLoaded    := False;
    FDllHandle := 0;
    DllCreateModule := nil;
  end;
end;

procedure TModuleFile.Clear;
begin
end;


// ############## TModule #################

constructor TModule.Create(pOwnerForm  : TWinControl; pModuleFile : TModuleFile; pID,pBarID : integer; pParent : hwnd; pPosition : integer; pMM : TObject);
begin
  Inherited Create;

  Screen.Cursor[crHandPoint] := LoadCursor(0, IDC_HAND);

  FInterface          := nil;
  FModuleInterface    := nil;
  FModuleManager := pMM;

  FOwnerForm := pOwnerForm;
  FModuleFile := pModuleFile;
  if not FModuleFile.FLoaded then
    FModuleFile.LoadDll;

  FInterface := FModuleFile.DllCreateModule(pID,pBarID,pOwnerForm.Handle);
  if not (FInterface.QueryInterface(IID_ISharpBarModule,FModuleInterface) = S_OK) then
    FModuleInterface := nil;

  if (FModuleInterface = nil) then
    if MessageBox(pOwnerForm.Handle,
        PChar('SharpBar tried to create a non valid Module ('+FModuleFile.FileName+'). It is highly recommend to terminate the bar and delete the invalid module file. Do you want to continue and terminate the SharpBar?)'),
        'Critical Error',
        MB_YESNO) = IDYES then
          Halt;

  FModuleInterface.SkinInterface := TModuleManager(FModuleManager).SkinInterface;
  FModuleInterface.BarInterface := TModuleManager(FModuleManager).BarInterface;
  FModuleInterface.SetTopHeight(TModuleManager(FModuleManager).GetModuleTop,
                                TModuleManager(FModuleManager).GetModuleHeight);
  FModuleInterface.Form.Show;


  FPosition := pPosition;

  FThrobber := TSharpEMiniThrobber.Create(FOwnerForm);
  FThrobber.Cursor := crHandPoint;
  FThrobber.AutoPosition := True;
  FThrobber.Parent := FOwnerForm;
  FThrobber.BringToFront;
  FThrobber.SkinManager := TModuleManager(FModuleManager).SkinInterface.SkinManager;
  FThrobber.Visible := False;
  FThrobber.Tag := FModuleInterface.ID;
//  FThrobber.SpecialBackground := TSharpBarMainForm(FOwnerForm).BGImage;
  FThrobber.SpecialBackground := TSharpBarMainForm(FOwnerForm).SharpEBar.Skin;
end;

destructor TModule.Destroy;
begin
  FInterface          := nil;
  FModuleInterface.SkinInterface := nil;
  FModuleInterface.BarInterface := nil;
  FModuleInterface    := nil;

  if FThrobber <> nil then
  begin
    FThrobber.Free;
    FThrobber := nil;
  end;
  Inherited Destroy;
end;

procedure TModule.UpdateBackground;
begin
  if mInterface <> nil then
    UpdateBackgroundF(mInterface.Form.Left,
                     mInterface.Form.Top,
                     mInterface.Form.Width,
                     mInterface.Form.Height);
end;

procedure TModule.UpdateBackgroundF(NewLeft, NewTop, NewWidth, NewHeight : integer);
var
  Src : TRect;
begin
  if mInterface <> nil then
  begin
    Src.Left := NewLeft;
    Src.Top := NewTop;
    Src.Right := Src.Left + NewWidth;
    Src.Bottom := Src.Top + NewHeight;
    mInterface.Background.SetSize(Src.Right - Src.Left,Src.Bottom - Src.Top);
    TSharpBarMainForm(FOwnerForm).SharpEBar.Skin.DrawTo(mInterface.Background,0,0,Src);
  end;

end;

procedure TModule.UpdateBackgroundW(NewWidth: integer);
begin
  if mInterface <> nil then
    UpdateBackgroundF(mInterface.Form.Left,
                     mInterface.Form.Top,
                     NewWidth,
                     mInterface.Form.Height);
end;

procedure TModule.UpdateBackgroundS(NewTop, NewHeight : integer);
begin
  if mInterface <> nil then
    UpdateBackgroundF(mInterface.Form.Left,
                     NewTop,
                     mInterface.Form.Width,
                     NewHeight);
end;

procedure TModule.UpdateBackgroundL(NewLeft : integer);
begin
  if mInterface <> nil then
    UpdateBackgroundF(NewLeft,
                     mInterface.Form.Top,
                     mInterface.Form.Width,
                     mInterface.Form.Height);
end;

end.
