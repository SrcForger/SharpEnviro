{
Source Name: uSharpEModuleManager.pas
Description: Dll Module Handler
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
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

unit uSharpEModuleManager;

interface

uses 
  Windows,
  Dialogs,
  SysUtils,
  Forms,
  Classes,
  Contnrs,
  Menus,
  Math,
  SharpESkinManager,
  SharpEBar,
  SharpEMiniThrobber,
  JvSimpleXML,
  Controls;


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
                     FParent    : hwnd;
                     FDllHandle : integer;
                     FLoaded    : boolean;
                     FSkinManager : TSharpESkinManager;
                     FBar         : TSharpEBar;
                     FModuleSettings : TJvSimpleXML;
                     procedure LoadDll;
                     procedure UnloadDll;
                   public
                     DllCreateModule    : function(ID : integer; parent : hwnd) : hwnd;
                     DllCloseModule     : function(ID : integer) : boolean;
                     DllPosChanged      : procedure(ID : integer);
                     DllModuleMessage   : function (ID : integer; msg: string): integer;
                     DllShowSettingsWnd : procedure(ID : integer);
                     DllRefresh         : procedure(ID : integer);
                     DllSetSize         : procedure(ID : integer; NewWidth : integer);
                     DllUpdateMessage   : procedure(Part : integer);
                     procedure Clear;
                     constructor Create(pFileName : string; pParent : hwnd;
                                        pSkinManager : TSharpESkinManager;
                                        pBar         : TSharpEBar;
                                        pModuleSettings : TJvSimpleXML); reintroduce;
                     destructor Destroy; override;
                   published
                     property FileName : string read FFileName;
                     property Parent   : hwnd   read FParent;
                   end;

  TModule        = class
                   private
                     FOwnerForm  : TWinControl;
                     FControl    : TWinControl;
                     FHandle     : hwnd;
                     FID         : integer;
                     FModuleFile : TModuleFile;
                     FPosition   : integer;
                     FThrobber   : TSharpEMiniThrobber;
                   public
                     constructor Create(pOwnerForm  : TWinControl;
                                        pModuleFile : TModuleFile;
                                        pID : integer;
                                        pParent : hwnd;
                                        pPosition : integer); reintroduce;
                     destructor Destroy; override;
                   published
                     property ID      : integer     read FID;
                     property Control : TWinControl read FControl;
                     property Handle  : hwnd        read FHandle;
                     property ModuleFile : TModuleFile read FModuleFile;
                     property Position : integer    read FPosition write FPosition;
                     property OwnerForm : TWinControl read FOwnerForm;
                     property Throbber : TSharpEMiniThrobber read FThrobber;
                   end;

  TModuleManager = class
                   private
                     FDirectory         : String;
                     FModuleFiles       : TObjectList;
                     FModules           : TObjectList;
                     FParent            : hwnd;
                     FSkinManager       : TSharpESkinManager;
                     FBar               : TSharpEBar;
                     FModuleSettings    : TJvSimpleXML;
                     FThrobberMenu      : TPopupMenu;
                     FThrobberMovePoint : TPoint;
                     FThrobberMove      : Boolean;
                     FThrobberMoveID    : integer;
                     FModuleSpacing     : integer;
                   public
                     constructor Create(pParent : hwnd;
                                        pSkinManager : TSharpESkinManager;
                                        pBar         : TSharpEBar;
                                        pModuleSettings : TJvSimpleXML); reintroduce;
                     destructor Destroy; override;
                     procedure Clear;
                     procedure UnloadModules;
                     procedure Unload(ID : integer);
                     procedure Delete(ID : integer);
                     procedure Clone(ID : integer);
                     procedure CreateModule(MFID : integer; Position : integer);
                     procedure LoadModule(ID : integer; Module : String; Position,Index : integer);
                     procedure LoadFromDirectory(pDirectory : String);
                     procedure FixModulePositions;
                     function GetModule(ID : integer) : TModule;
                     function GetModuleIndex(ID : integer) : integer;
                     procedure SortModulesByPosition;
                     procedure RefreshMiniThrobbers;
                     function GetFirstRModuleIndex : integer;
                     function GenerateModuleID : integer;
                     function GetFreeBarSpace : integer;
                     function GetMaxBarSpace : integer;
                     procedure MoveModule(Index, Direction : integer);
                     function SendPluginMessage(ID : integer; msg : string) : integer;
                     procedure BroadcastPluginMessage(msg : string);
                     procedure BroadcastPluginUpdate(part : integer);
                     procedure BroadCastModuleRefresh;
                     procedure ReCalculateModuleSize;
                     procedure OnMiniThrobberClick(Sender : TObject);
                     procedure OnMiniThrobberMouseDown(Sender : TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
                     procedure OnMiniThrobberMouseUp(Sender : TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
                     procedure OnMiniThrobberMouseMove(Sender : TObject; Shift: TShiftState; X, Y: integer);
                   published
                     property Directory      : string       read FDirectory;
                     property Parent         : hwnd         read FParent;
                     property ModuleFiles    : TObjectList  read FModuleFiles;
                     property Modules        : TObjectList  read FModules;
                     property ModuleSettings : TJvSimpleXML read FModuleSettings;
                     property ThrobberMenu   : TPopupMenu   read FThrobberMenu write FThrobberMenu;
                   end;

implementation


uses uSharpBarApi,
     SharpApi,
     SharpBarMainWnd;


type
  THandleArray = array of HWND;


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
                                  pSkinManager : TSharpESkinManager;
                                  pBar         : TSharpEBar;
                                  pModuleSettings : TJvSimpleXML);
begin
  inherited Create;
  FParent       := pParent;
  FSkinManager  := pSkinManager;
  FBar          := pBar;
  FModuleSpacing := 4;
  FModules  := TObjectList.Create;
  FModules.Clear;
  FModuleSettings := pModuleSettings;
  FModuleFiles := TObjectList.Create;
  FModuleFiles.Clear;
end;

destructor TModuleManager.Destroy;
begin
  Clear;
  FModules.Free;
  FModules := nil;
  FModuleFiles.Free;
  FModuleFiles := nil;
  inherited Destroy;
end;

// Sends an update message to all modules
procedure TModuleManager.BroadcastPluginUpdate(part : integer);
var
  n : integer;
  mf : TModuleFile;
begin
  for n := 0 to FModuleFiles.Count - 1 do
  begin
    mf := TModuleFile(FModuleFiles.Items[n]);
    if @mf.DllUpdateMessage <> nil then
       mf.DllUpdateMessage(part);
  end;
end;

// Broadcast a message to all modules
procedure TModuleManager.BroadCastPluginMessage(msg : string);
var
  n : integer;
  tempModule : TModule;
begin
  for n := 0 to FModules.Count - 1 do
  begin
    tempModule := TModule(FModules.Items[n]);
    if assigned(tempModule.ModuleFile.DllModuleMessage) then
       tempModule.ModuleFile.DllModuleMessage(tempModule.ID,msg);
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
    if tempModule.ID = ID then
    begin
      if assigned(tempModule.ModuleFile.DllModuleMessage) then
      begin
        result := tempModule.ModuleFile.DllModuleMessage(ID,msg);
        exit;
      end;
    end;
  end;
end;

procedure TModuleManager.Clone(ID : integer);
var
  tempModule : TModule;
  newID : integer;
  tempsettings : string;
  n : integer;
begin
  if GetFreeBarSpace < 50 then
     if MessageBox(Application.Handle,
                   'Your SharpBar is nearly full. Adding this module may cause' + #10#13 +
                   'overlap between modules, preventing you from accessing their throbbers.' + #10#13 +
                   'Continue anyway?','Confirm: Clone Module',MB_YESNO or MB_ICONWARNING) = IDNO then exit;

  tempModule := TModule(GetModule(ID));
  if tempModule = nil then exit;

  newID := GenerateModuleID;

  // Search the module we settings which we want to clone
  for n := 0 to FModuleSettings.Root.Items.Count - 1 do
      if FModuleSettings.Root.Items.Item[n].Items.IntValue('ID',-1) = ID then
      begin
        // Found the module -> Clone the settings
        if FModuleSettings.Root.Items.Item[n].Items.ItemNamed['Settings'] <> nil then
        begin
          tempsettings := FModuleSettings.Root.Items.Item[n].Items.ItemNamed['Settings'].SaveToString;
          with FModuleSettings.Root.Items.Add('Item').Items do
          begin
            Add('ID',newID);
            Add('Settings').LoadFromString(tempsettings);
          end;
          FModuleSettings.SaveToFile(FModuleSettings.FileName);
          break;
        end;
      end;

  LoadModule(newID,ExtractFileName(tempModule.ModuleFile.FileName),TempModule.Position,GetModuleIndex(ID)+1);
end;

procedure TModuleManager.Delete(ID : integer);
var
  n,i : integer;
  TempModule : TModule;
begin
  for n := 0 to FModules.Count - 1 do
  begin
    TempModule := TModule(FModules.Items[n]);
    if TempModule.ID = ID then
    begin
      TempModule.ModuleFile.DLLCloseModule(ID);
      FModules.Delete(n);

      for i := 0 to FModuleSettings.Root.Items.Count -1 do
          if FModuleSettings.Root.Items.Item[i].Items.IntValue('ID',-1) = ID then
          begin
            FModuleSettings.Root.Items.Delete(i);
            ForceDirectories(ExtractFileDir(FModuleSettings.FileName));
            FModuleSettings.SaveToFile(FModuleSettings.FileName);
            break;
          end;

      LockWindow(FParent);
      BroadCastModuleRefresh;
      FixModulePositions;
      UnLockWindow(FParent);
      exit;
    end;
  end;
end;

procedure TModuleManager.UnloadModules;
begin
  while FModules.Count <> 0 do
        Unload(TModule(FModules.Items[0]).ID);
end;

procedure TModuleManager.Unload(ID : integer);
var
  n : integer;
  TempModule : TModule;
begin
  for n := 0 to FModules.Count - 1 do
  begin
    TempModule := TModule(FModules.Items[n]);
    if TempModule.ID = ID then
    begin
      TempModule.ModuleFile.DLLCloseModule(ID);
      FModules.Delete(n);
      LockWindow(FParent);
      FixModulePositions;
      UnLockWindow(FParent);
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
        if TModule(FModules.Items[n]).ID = strtoint(s) then
        begin
          b := false;
          break;
        end;
  until b;
  result := strtoint(s);
end;

procedure TModuleManager.CreateModule(MFID : integer; Position : integer);
var
  tempModuleFile : TModuleFile;
begin
  if MFID > FModuleFiles.Count - 1 then exit;
  if GetFreeBarSpace < 50 then
     if MessageBox(Application.Handle,
                   'There is only few free space left for a new module.' + #10#13 +
                   'Adding another module might cause modules to overlap eachother.' + #10#13 +
                   'Do you really want to continue?','Confirm: New Module',MB_YESNO or MB_ICONWARNING) = IDNO then exit;
  tempModuleFile := TModuleFile(FModuleFiles.Items[MFID]);
  LoadModule(GenerateModuleID,ExtractFileName(tempModuleFile.FFileName),Position,-1);
  ReCalculateModuleSize;
end;

procedure TModuleManager.LoadModule(ID : integer; Module : String; Position, Index : integer);
var
 n,i : integer;
 pFile : TModuleFile;
 found : boolean;
begin
  if (ID = -1) or (length(Module)=0) then exit;

  for n := 0 to FModuleFiles.Count -1 do
  begin
    pFile := TModuleFile(FModuleFiles.Items[n]);
    if ExtractFileName(pFile.FileName) = Module then
    begin
      found := False;

      // Search the xml item for this Module
      for i := 0 to FModuleSettings.Root.Items.Count -1 do
      begin
        if FModuleSettings.Root.Items.Item[i].Items.IntValue('ID',-1) = ID then
        begin
          // check if the xml item has a Settings sub item - if not create it
          if FModuleSettings.Root.Items.Item[i].Items.ItemNamed['Settings'] = nil then
             FModuleSettings.Root.Items.Item[i].Items.Add('Settings');
          // set XMLItem to the Settings sub item (will be passed to the module)
          //XMLItem := FModuleSettings.Root.Items.Item[n].Items.ItemNamed['Settings'];
          // Item found
          found := True;
          break;
        end;
      end;

      // there is no xml item for this Module
      // we have to create one so that the Module will be able to save settings!
      if not found then
      begin
        with FModuleSettings.Root.Items.Add('Item').Items do
        begin
          Add('ID',ID);
          //XMLItem := Add('Settings');
          Add('Settings');
          FModuleSettings.SaveToFile(FModuleSettings.FileName);
        end;
      end;

      if Index <> -1 then FModules.Insert(Index,TModule.Create(FBar.aform,pFile,ID,FParent,Position))
         else FModules.Add(TModule.Create(FBar.aform,pFile,ID,FParent,Position));
    end;
  end;
  SortModulesByPosition;
end;

// Load all module dll files from a directory
procedure TModuleManager.LoadFromDirectory(pDirectory : string);
var
  sr : TSearchRec;
  temp : TModuleFile;
begin
  Clear;
  {$WARNINGS OFF}
  FDirectory := IncludeTrailingBackSlash(pDirectory);
  {$WARNINGS ON}
  if FindFirst(FDirectory + '*.dll',FAAnyFile,sr) = 0 then
  repeat
    temp := TModuleFile.Create(FDirectory + sr.Name,FParent, FSkinManager, FBar, FModuleSettings);
    FModuleFiles.Add(temp);
  until FindNext(sr) <> 0;
  FindClose(sr);
end;

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
    size := size + pModule.Control.Width;
    if pModule.Throbber.Visible then
       size := size + pModule.Throbber.Width + FModuleSpacing
       else size := size + FModuleSpacing;
  end;

  result := GetMaxBarSpace - size;
end;

function FindAllWindows(const WindowClass: string): THandleArray;
type
  PParam = ^TParam;
  TParam = record
    ClassName: string;
    Res: THandleArray;
  end;
var
  Rec: TParam;

  function GetWndClass(pHandle: hwnd): string;
  var
    buf: array[0..254] of Char;
  begin
    GetClassName(pHandle, buf, SizeOf(buf));
    result := buf;
  end;

  function _EnumProc(_hWnd: HWND; _LParam: LPARAM): LongBool; stdcall;
  begin
    with PParam(_LParam)^ do
    begin
      if (CompareText(GetWndClass(_hWnd), ClassName) = 0) then
      begin
        SetLength(Res, Length(Res) + 1);
        Res[Length(Res) - 1] := _hWnd;
      end;
      Result := True;
    end;
  end;

begin
  try
    Rec.ClassName := WindowClass;
    SetLength(Rec.Res, 0);
    EnumWindows(@_EnumProc, Integer(@Rec));
  except
    SetLength(Rec.Res, 0);
  end;
  Result := Rec.Res;
end;

function TModuleManager.GetMaxBarSpace : integer;
var
  maxsize : integer;
  pForm : TWinControl;
  pMon : TMonitor;
  lo,ro : integer;
  harray : THandleArray;
  n : integer;
  R : TRect;
  freespace : integer;
begin
  pForm := GetControlByHandle(FParent);

  // get screen size
  pMon := Screen.MonitorFromPoint(Point(pForm.Left,pForm.Top),mdNearest);
  maxSize := pMon.Width;

  setlength(harray,0);
  // find all SharpBar windows and store their handle in harray
  harray := FindAllWindows('TSharpBarMainForm');
  for n := 0 to High(harray) do
  begin
    if harray[n] <> pForm.Handle then
    begin                                                       
      GetWindowRect(harray[n],R);
      // another bar on the same monitor with the same top position ?
      if (R.Top = pForm.Top) and (Screen.MonitorFromPoint(R.TopLeft,mdNearest) = pMon) then
      begin
        freespace := GetWindowLong(harray[n],GWL_USERDATA);
        MaxSize := MaxSize - (R.Right - R.Left) + freespace;
      end;
    end;
  end;
  setlength(harray,0);

  // get left/right offets for plugin area
  try
    if FBar.ShowThrobber then
       lo := strtoint(FSkinManager.Skin.BarSkin.PAXoffset.X)
       else lo := FBar.Throbber.Left;
    ro := strtoint(FSkinManager.Skin.BarSkin.PAXoffset.Y);
  except
    lo := 0;
    ro := 0;
  end;

  result := maxsize - ro - lo;
end;

function TModuleManager.GetModuleIndex(ID : integer) : integer;
var
  n : integer;
begin
  for n := 0 to FModules.Count - 1 do
      if TModule(FModules.Items[n]).ID = ID then
      begin
        result := n;
        exit;
      end;
  result := -1;
end;

function TModuleManager.GetModule(ID : integer) : TModule;
var
  n : integer;
begin
  for n := 0 to FModules.Count - 1 do
      if TModule(FModules.Items[n]).ID = ID then
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
  i : integer;
  cPos,Pos : TPoint;
  update : boolean;
begin
  if FThrobberMoveID = -1 then exit;
  if Shift = [ssLeft] then
  begin
    MP := Mouse.CursorPos;
    if not FThrobberMove then
    begin
      // Make sure the mouse was moved more than a few pixels before starting the move bar code
      if (abs(FThrobberMovePoint.X - MP.X) > 32) then
         FThrobberMove := True
         else exit;
    end;
    if FThrobberMove then
    begin
      update := False;
      tempModule := GetModule(FThrobberMoveID);
      if tempModule = nil then exit;
      index := FModules.IndexOf(TempModule);
      pos := tempModule.FControl.ClientToScreen(Point(tempModule.Control.Left,0));
      if index>0 then
      begin
        checkModule := TModule(FModules.Items[index -1]);
        Cpos := FBar.aform.ClientToScreen(Point(CheckModule.Control.Left,0));
        if MP.X <= CPos.X + CheckModule.FControl.Width then
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
        Cpos := FBar.aform.ClientToScreen(Point(CheckModule.Control.Left,0));
        if MP.X >= CPos.X then
        begin
          if (MP.X >= CPos.X + CheckModule.Control.Width) and
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
        LockWindow(FParent);
        SortModulesByPosition;
        FixModulePositions;
        UnLockWindow(FParent);
        exit;
      end;
    end;
  end;
end;

procedure TModuleManager.OnMiniThrobberMouseUp(Sender : TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FThrobberMoveID := -1;
  if FThrobberMove then FThrobberMove := False;
end;

procedure TModuleManager.OnMiniThrobberMouseDown(Sender : TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  mThrobber : TSharpEMiniThrobber;
  tempModule : TModule;
begin
  mThrobber := TSharpEMiniThrobber(Sender);
  if (mThrobber = nil) or (FThrobberMenu = nil) then exit;
  tempModule := GetModule(mThrobber.Tag); // tag = module ID
  if tempModule = nil then exit;

  if Button = mbLeft then
  begin
    FThrobberMovePoint := Mouse.CursorPos;
    FThrobberMoveID    := mThrobber.Tag;
  end else FThrobberMove := False;
end;

procedure TModuleManager.OnMiniThrobberClick(Sender : TObject);
var
  mThrobber : TSharpEMiniThrobber;
  tempModule : TModule;
  p : TPoint;
  n : integer;
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
  for n := 0 to FThrobberMenu.Items.Count - 1 do
  begin
      if FThrobberMenu.Items.Items[n].Tag = -1 then
      begin
        if @tempModule.ModuleFile.DllShowSettingsWnd = nil then
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
    if @pModule.ModuleFile.DllRefresh <> nil then
       pModule.ModuleFile.DllRefresh(pModule.ID);
  end;
end;

// Update the position of all modules and their mini throbbers
// This will also update the main window width
procedure TModuleManager.FixModulePositions;
var
  n,i : integer;
  ro,lo,rx,x : integer;
  TempModule     : TModule;
  IDArray        : array of integer;
  ParentControl  : TWinControl;
  LeftSize,RightSize : integer;
  MTWidth : integer; // mini Throbbers
  RCount,LCount : integer;
  CList : TObjectList;
begin
  setlength(IDArray,0);
  try
    if FBar.ShowThrobber then
       lo := strtoint(FSkinManager.Skin.BarSkin.PAXoffset.X)
       else lo := FBar.Throbber.Left;
    ro := strtoint(FSkinManager.Skin.BarSkin.PAXoffset.Y);
  except
    lo := 0;
    ro := 0;
  end;
  ParentControl := GetControlByHandle(FParent);

  if FModules.Count > 0 then
     MTWidth := TModule(FModules.Items[0]).Throbber.Width+FModuleSpacing
     else MTWidth := FModuleSpacing;

  LeftSize := 0;
  RightSize := 0;
  // Get the overall bar size
  for n := 0 to FModules.Count -1 do
  begin
    TempModule := TModule(FModules.Items[n]);
    if TempModule.Position = -1 then LeftSize := LeftSize + TempModule.Control.Width + MTWidth
       else RightSize := RightSize + TempModule.Control.Width + MTWidth;
  end;

  if not (FBar.HorizPos = hpFull) then
     if lo + ro + LeftSize + RightSize <> ParentControl.Width then
        ParentControl.Width := Max(lo + ro + FSkinManager.Skin.BarSkin.ThDim.XAsInt+5,lo + ro + LeftSize + RightSize);

  if FBar.HorizPos = hpFull then SetWindowLong(ParentControl.Handle,GWL_USERDATA,0)
     else SetWindowLong(ParentControl.Handle,GWL_USERDATA,Max(ParentControl.Width - lo - ro - LeftSize - Rightsize,0));

  x := 0;
  rx := 0;
  RCount := 0;
  LCount := 0;
  CList := TObjectList.Create;
  CList.OwnsObjects := False;
  for n := 0 to FModules.Count -1 do
  begin
    TempModule := TModule(FModules.Items[n]);
    if TempModule.Position = -1 then
    begin
      LCount := LCount + 1;
      i := lo + x + MTWidth*(LCount);
      if TempModule.Control.Left <> i then
      begin
        TempModule.Control.Left := i;
        CList.Add(TempModule);
      end;
      x := x + TempModule.Control.Width;
    end else
    begin
      RCount := RCount + 1;
      if not (FBar.HorizPos = hpFull) then
         i := lo + LeftSize + rx + MTWidth*(RCount)
         else i := ParentControl.Width - ro - RightSize + rx + MTWidth*(RCount);
      if i <> TempModule.Control.Left then
      begin
        TempModule.Control.Left := i;
        CList.Add(TempModule);
      end;
      rx := rx + TempModule.Control.Width;
    end;
    TempModule.Control.Top  := strtoint(FSkinManager.Skin.BarSkin.PAYoffset.X);
    TempModule.Throbber.Left := TempModule.Control.Left-TempModule.Throbber.Width-FModuleSpacing div 2;
    TempModule.Throbber.Top  := TempModule.Control.Top;
    TempModule.Throbber.OnClick := OnMiniThrobberClick;
    TempModule.Throbber.OnMouseDown := OnMiniThrobberMouseDown;
    TempModule.Throbber.OnMouseMove := OnMiniThrobberMouseMove;
    TempModule.Throbber.OnMouseUp   := OnMiniThrobberMouseUp;
    if not TempModule.Throbber.Visible then TempModule.Throbber.Visible := True;
  end;

  for n := 0 to Clist.Count -1 do
  begin
    TempModule := TModule(CList.Items[n]);
    TempModule.ModuleFile.DllPosChanged(TempModule.ID);
  end;
  CList.Clear;
  FreeAndNil(CList);
end;


procedure TModuleManager.RefreshMiniThrobbers;
var
  TempModule : TModule;
  n : integer;
begin
  for n := 0 to FModules.Count -1 do
  begin
    TempModule := TModule(FModules.Items[n]);
    TempModule.Throbber.UpdateSkin;
    TempModule.Throbber.Invalidate;
  end;
end;

// Calculate how much space every module is taking and check how much free bar
// space is left. Adjust the size of modules with dynamic size (task list,...)
// if there is more space needed or of the dynamic module can have more space.
procedure TModuleManager.ReCalculateModuleSize;
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
  pMon : TMonitor;
  R : TRect;
  freespace : integer;
begin
  if FModules = nil then exit;

  minsize := 0;
  maxsize := 0;
  smod    := 0;
  setlength(nonminmaxrequest,0);
  maxbarsize := GetMaxBarSpace;
  for n := 0 to FModules.Count - 1 do
  begin
    temp := TModule(FModules.Items[n]);
    msize.Min := temp.Control.Tag;
    try
      msize.Width := strtoint(temp.Control.Hint);
    except
      msize.Width := msize.Min;
    end;
    minsize := minsize + msize.Min;
    maxsize := maxsize + msize.Width;
    smod := smod + temp.Throbber.Width + FModuleSpacing;
    if msize.Min <> msize.Width then
    begin
      setlength(nonminmaxrequest,length(nonminmaxrequest)+1);
      nonminmaxrequest[High(nonminmaxrequest)] := abs(msize.Width - msize.Min);
    end;
  end;

  FreeMinSpace := Max(0,maxbarsize - minsize - smod);
  if (length(nonminmaxrequest) > 0) and (FreeMinSpace > 0) and (maxsize > maxbarsize)then
  begin
    for n := 0 to High(nonminmaxrequest) do
        nonminmaxrequest[n] := round(Int(((nonminmaxrequest[n])/(maxsize - minsize))*FreeMinSpace));
  end;

  i := 0;
  for n := 0 to FModules.Count - 1 do
  begin
    temp := TModule(FModules.Items[n]);
    msize.Min := temp.Control.Tag;
    try
      msize.Width := strtoint(temp.Control.Hint);
    except
      msize.Width := msize.Min;
    end;
    if msize.Min <> msize.Width then
    begin
      try
        temp.ModuleFile.DllSetSize(temp.ID,msize.Min + nonminmaxrequest[i]);
      finally
        i := i + 1;
      end;
    end else
    begin
      try
        temp.ModuleFile.DllSetSize(temp.ID,msize.Min);
      except
      end;
    end;
  end;

  FixModulePositions;

  ParentControl := GetControlByHandle(FParent);
 // if (minsize-maxsize) <> 0 then
 //    SetWindowLong(ParentControl.Handle,GWL_USERDATA,minsize-maxsize);

  // Check if there is no bar space left and if other bars which have
  // free space left should resize
  pMon := Screen.MonitorFromPoint(Point(ParentControl.Left,ParentControl.Top),mdNearest);
  maxSize := pMon.Width - ParentControl.Width;

  setlength(harray,0);
  // find all SharpBar windows and store their handle in harray
  harray := FindAllWindows('TSharpBarMainForm');
  for n := 0 to High(harray) do
    if harray[n] <> ParentControl.Handle then
    begin
      GetWindowRect(harray[n],R);
      // another bar on the same monitor with the same top position?
      if (R.Top = ParentControl.Top) and (Screen.MonitorFromPoint(R.TopLeft,mdNearest) = pMon) then
          MaxSize := MaxSize - (R.Right - R.Left);
    end;
//  if MaxSize < 0 then
    for n := 0 to High(harray) do
      if harray[n] <> ParentControl.Handle then
      begin
        GetWindowRect(harray[n],R);
        // another bar on the same monitor with the same top position?
        if (R.Top = ParentControl.Top) and (Screen.MonitorFromPoint(R.TopLeft,mdNearest) = pMon) then
        begin
          freespace := GetWindowLong(harray[n],GWL_USERDATA);
          if (MaxSize < 0) and (FreeSpace > 0) then
          begin
             PostMessage(harray[n],WM_UPDATEBARWIDTH,0,0);
             break;
          end;
        end;
      end;
  setlength(harray,0);
end;


// ############## TModuleFile #################

constructor TModuleFile.Create(pFileName : String; pParent : hwnd;
                               pSkinManager : TSharpESkinManager;
                               pBar         : TSharpEBar;
                               pModuleSettings : TJvSimpleXML);
begin
  Inherited Create;
  FParent   := pParent;
  FModuleSettings := pModuleSettings;
  FFileName := pFileName;
  FSkinManager := pSkinManager;
  FBar         := pBar;
  FLoaded   := False;
  LoadDll;
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

    DllShowSettingsWnd := nil;
    DllModuleMessage   := nil;
  
    if FDllHandle <> 0 then
    begin
      @DllCreateModule    := GetProcAddress(FDllHandle, 'CreateModule');
      @DllCloseModule     := GetProcAddress(FDllHandle, 'CloseModule');
      @DllPosChanged      := GetProcAddress(FDllHandle, 'PosChanged');
      @DllUpdateMessage    := GetProcAddress(FDllHandle, 'UpdateMessage');
      @DllModuleMessage   := GetProcAddress(FDllHandle, 'ModuleMessage');
      @DllShowSettingsWnd := GetProcAddress(FDllHandle, 'ShowSettingsWnd');
      @DllRefresh         := GetProcAddress(FDllHandle, 'Refresh');
      @DllSetSize         := GetProcAddress(FDllHandle, 'SetSize');
    end;

    if (@DllCreateModule = nil) or
       (@DllCloseModule = nil) or
       (@DllPosChanged = nil) or
       (@DllUpdateMessage = nil) or
       (@DllSetSize = nil) then
    begin
      FreeLibrary(FDllhandle);
      FDllhandle := 0;
      DllCreateModule      := nil;
      DllCloseModule       := nil;
      DllPosChanged        := nil;
      DllUpdateMessage     := nil;
      DllModuleMessage     := nil;
      DllShowSettingsWnd   := nil;
      DllRefresh           := nil;
      DllSetSize           := nil;
      exit;
    end;

    FLoaded := True;
  except
    try
      FreeLibrary(FDllhandle);
    finally
      FDllHandle := 0;
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
    DllCreateModule      := nil;
    DllCloseModule       := nil;
    DllPosChanged        := nil;
    DllUpdateMessage     := nil;
    DllModuleMessage     := nil;
    DllShowSettingsWnd   := nil;
    DllRefresh           := nil;
    DllSetSize           := nil;
  end;
end;

procedure TModuleFile.Clear;
begin
end;


// ############## TModule #################

constructor TModule.Create(pOwnerForm  : TWinControl; pModuleFile : TModuleFile; pID : integer; pParent : hwnd; pPosition : integer);
begin
  Inherited Create;
  FOwnerForm := pOwnerForm;
  FID := pID;
  FModuleFile := pModuleFile;
  FHandle := FModuleFile.DllCreateModule(FID,pParent);
  FControl := GetControlByHandle(FHandle);
  FPosition := pPosition;
  FThrobber := TSharpEMiniThrobber.Create(FOwnerForm);
  FThrobber.Cursor := crHandPoint;
  FThrobber.AutoPosition := True;
  FThrobber.Parent := FOwnerForm;
  FThrobber.BringToFront;
  FThrobber.SkinManager := pModuleFile.FSkinManager;
  FThrobber.Visible := False;
  FThrobber.Tag := FID;
  FThrobber.SpecialBackground := TSharpBarMainForm(FOwnerForm).BGImage;
end;

destructor TModule.Destroy;
begin
  FThrobber.Free;
  FThrobber := nil;
  Inherited Destroy;
end;

end.
