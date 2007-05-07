{
Source Name: uSharpDeskManager
Description: TSharpDeskManager class
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


unit uSharpDeskManager;

interface

uses
    Windows,
    Classes,
    Contnrs,
    Forms,
    Dialogs,
    SysUtils,
    ShlObj,
    Types,
    Graphics,
    Registry,
    JvSimpleXMl,
    gr32,
    gr32_image,
    gr32_layers,
    SharpApi,
    uSharpDeskDebugging,
    uSharpDeskObjectSetList,
    uSharpDeskObjectFileList,
    uSharpDeskTDeskSettings,
    uSharpDeskTDragAndDrop,
    uSharpDeskObjectSet;

const
  CLONE_X = 48;
  CLONE_Y = 48;

type

    TAlignBy = (albLeft,albCenter);

    TIntClass = class(TObject)
    public
      IntValue : integer;
    end;

    TIntArray = array of integer;

    TSelectionLayer = class(TPositionedlayer)
                      private
                      public
                      protected
                        procedure Paint(Buffer: TBitmap32); override;
                      end;


    TSharpDeskManager = class(TObject)
    private
      FSelectionCount  : integer;  // Count of selected layers
      FLayerMousePos   : TPoint;   // Position of the Mouse when last clicked on a layer
      FDoubleClick     : boolean;  // Was the last action a DoubleClick
      FEnabled         : boolean;  // Is SharpDesk Enabled
      FMouseDown       : boolean;  // Mouse button currently pressed
      FObjectsMoved    : boolean;  // Have objects been moved
      FLastLayer       : integer;  // Last selected Layer ID
      FObjectExt       : String;
      FBackgroundLayer : TBitmapLayer;
      FEffectLayer     : TBitmapLayer;
      FSelectLayer     : TSelectionLayer;
      FImage           : TImage32;
      FObjectSetList   : TObjectSetList;
      FObjectFileList  : TObjectFileList;
      FDeskSettings    : TDeskSettings;
      FDragAndDrop     : TDragAndDropManager;
    public
      constructor Create(pImage32 : TImage32);
      destructor Destroy; override;
      procedure AlignSelectedObjectsToGrid;
      procedure AlignSelectedObjects(aID : integer);
      procedure AssignSelectedObjectsToSet(setID : integer);
      procedure BringSelectedObjectsToFront;
      procedure CheckObjectPosition;
      procedure CheckPresetsFile;
      procedure CheckAlignsFile;
      procedure CheckGhostObjects;
      procedure CheckGhostLayers;
      procedure CheckInvisibleLayers;
      procedure CloneSelectedObjects;
      procedure ConvertOldObjectFormat;
      procedure CreatePreset(pDesktopObject : TObject; pName : String);
      procedure DeleteSelectedLayers;
      procedure DisableAnimation;
      procedure EnableAnimation;
      function  GenerateObjectID : integer;
      function  GetDesktopObjectByID(ID : integer) : TObject;
      function  GetNextGridPoint(Pos : TPoint) : TPoint;
      function  GetUpperLeftMostLayerPos : TPoint;
      function  IsAnyObjectSetLoaded : boolean;
      procedure LockAllObjects;
      procedure LoadObjectSet(OSet : TObjectSet);
      procedure LoadObjectSets(SetList : String);
      procedure LoadObjectSetsFromTheme(pThemeName : String);
      procedure LoadPreset(pDesktopObject : TObject; pID : integer; Save : boolean);
      procedure LoadPresetForSelected(pID : integer);
      procedure LoadPresetForAll(pObjectFile : TObject; pID : integer);
      procedure LockSelectedObjects;
      procedure MoveLayerTo(pDesktopObject : TObject; X,Y : integer);
      procedure MoveLayerBy(pDesktopObject : TObject; dX,dY : integer);
      procedure MoveSelectedLayers(dX,dY : integer; pIgnoreLocked : boolean);
      procedure ResizeBackgroundLayer;
      procedure SavePresetAs(pDesktopObject : TObject; PresetID : integer);
      procedure SelectAll;
      procedure SelectBySetID(pSetID : integer);
      function  SelectedObjectsOfSameType(dummy : integer) : boolean; overload;
      function  SelectedObjectsOfSameType(dummy : string) : String; overload;
      procedure SendSelectedObjectsToBack;
      procedure SendMessageToAllObjects(messageID : integer; P1,P2,P3 : integer);
      procedure UnloadAllObjects;
      procedure UnLockAllObjects;
      procedure UnLockSelectedObjects;
      procedure UnselectAll;
      procedure UpdateSelection(Rect : TRect);
      procedure UpdateAnimationLayer;
    published
      property BackgroundLayer : TBitmapLayer        read FBackgroundLayer;
      property DeskSettings    : TDeskSettings       read FDeskSettings;
      property DoubleClick     : boolean             read FDoubleClick     write FDoubleClick;
      property DragAndDrop     : TDragAndDropManager read FDragAndDrop;
      property Enabled         : boolean             read FEnabled         write FEnabled;
      property Image           : TImage32            read FImage;
      property LastLayer       : integer             read FLastLayer       write FLastLayer;
      property LayerMousePos   : TPoint              read FLayerMousePos   write FLayerMousePos;
      property MouseDown       : boolean             read FMouseDown       write FMouseDown;
      property ObjectExt       : String              read FObjectExt;
      property ObjectFileList  : TObjectFileList     read FObjectFileList;
      property ObjectSetList   : TObjectSetList      read FObjectSetList;
      property ObjectsMoved    : boolean             read FObjectsMoved    write FObjectsMoved;
      property SelectionCount  : integer             read FSelectionCount  write FSelectionCount;
      property SelectLayer     : TSelectionLayer     read FSelectLayer;
    end;

implementation

uses uSharpDeskDesktopObject,
     uSharpDeskObjectFile,
     uSharpDeskObjectSetItem,
     uSharpDeskFunctions,
     SharpDeskApi,
     SharpThemeApi;



procedure TSelectionLayer.Paint(Buffer: TBitmap32);
var
  L : TFloatRect;
begin
  L := GetAdjustedLocation;
  Buffer.SetStipple([clwhite32,clwhite32,clwhite32,clblack32,clblack32,clblack32]);
  Buffer.StippleStep := 1;
  Buffer.LineFSP(Round(L.Left),Round(L.Top),Round(L.Right),Round(L.Top));
  Buffer.LineFSP(Round(L.Right),Round(L.Top),Round(L.Right),Round(L.Bottom));
  Buffer.LineFSP(Round(L.Left),Round(L.Top),Round(L.Left),Round(L.Bottom));
  Buffer.LineFSP(Round(L.Left),Round(L.Bottom),Round(L.Right),Round(L.Bottom));
end;


constructor TSharpDeskManager.Create(pImage32 : TImage32);
begin
  Inherited Create;

  if (ParamCount >= 1) then
  begin
    if (lowercase(ParamStr(1)) = '-ext') then
        FObjectExt := ParamStr(2);
  end else FObjectExt := '.object';
  SharpApi.SendDebugMessage('SharpDesk','Using "'+FObjectExt+'" as object extension',clblue);

  ConvertOldObjectFormat;

  FImage := pImage32;

  FEnabled := False;
  FDoubleClick := False;

  FBackgroundLayer := TBitmapLayer.Create(FImage.Layers);
  FBackgroundLayer.Bitmap.MasterAlpha:=0;
  FBackgroundLayer.Bitmap.DrawMode:=dmBlend;
  FBackgroundLayer.Bitmap.SetSize(10,10);
//  FBackgroundLayer.Bitmap.SetSize(FImage.Width,FImage.Height);
  FBackgroundLayer.Scaled := True;
  FBackgroundLayer.Bitmap.Clear(Color32(100,100,100,0));
  FBackgroundLayer.AlphaHit:=False;
  FBackgroundLayer.Location:=FloatRect(0,0,FImage.Width,FImage.Height);
  FBackgroundLayer.Tag:=-1;
  FBackgroundLayer.SendToBack;

  FEffectLayer := TBitmapLayer.Create(FImage.Layers);
  FEffectLayer.Tag := -1;
  FEffectLayer.AlphaHit := False;
  FEffectLayer.BringToFront;
  FEffectLayer.Bitmap.SetSize(10,10);
  //FEffectLayer.Bitmap.SetSize(FImage.Width,FImage.Height);
  FEffectLayer.Bitmap.DrawMode := dmBlend;
  FEffectLayer.Bitmap.CombineMode := cmBlend;
  FEffectLayer.Bitmap.Clear(color32(255,255,255,255));
  FEffectLayer.Bitmap.MasterAlpha := 0;
  FEffectLayer.Scaled := True;
  FEffectLayer.Location := FBackgroundLayer.Location;

  FSelectLayer := TSelectionLayer.Create(FImage.Layers);
  FSelectLayer.Visible := False;
  FSelectLayer.Location := FloatRect(0,0,1,1);
  FSelectLayer.Tag:=-3;
  FSelectLayer.BringToFront;

  LastLayer:=-1;

  try
    SharpApi.SendDebugMessageEx('SharpDesk','loading SharpDesk settings',clblack,DMT_STATUS);
    FDeskSettings := TDeskSettings.Create(self);
  except
    SharpApi.SendDebugMessageEx('SharpDesk','error loading SharpDesk settings',clred,DMT_ERROR);
  end;

  FObjectSetList := TObjectSetList.Create(GetSharpeUserSettingsPath + 'SharpDesk\Sets.xml');
  FObjectFileList := TObjectFileList.Create(self,ExtractFileDir(Application.ExeName)+'\Objects\',FObjectExt,FImage);
  FDragAndDrop := TDragAndDropManager.Create(self,GetSharpeGlobalSettingsPath + 'SharpDesk\DragAndDrop');
  if FDesksettings.DragAndDrop then FDragAndDrop.RegisterDragAndDrop(FImage.Parent.Handle)
     else FDragAndDrop.UnregisterDragAndDrop(FImage.Parent.Handle);

  FEnabled := True;
  CheckGhostObjects;
  CheckInvisibleLayers;
  CheckObjectPosition;
end;



destructor TSharpDeskManager.Destroy;
begin
  DebugFree(FObjectSetList);
  DebugFree(FObjectFileList);
  DebugFree(FDeskSettings);
  DebugFree(FDragAndDrop);
end;



function TSharpDeskManager.GetNextGridPoint(Pos : TPoint) : TPoint;
var
   r : TPoint;
begin
  if not FDeskSettings.Grid then
  begin
    GetNextGridPoint := Pos;
    exit;
  end;
  r.X:=round(Pos.x/FDesksettings.GridX)*FDesksettings.GridX;
  r.Y:=round(Pos.y/FDesksettings.GridY)*FDesksettings.GridY;
  GetNextGridPoint:=r;
end;



function TSharpDeskManager.GetDesktopObjectByID(ID : integer) : TObject;
var
   n,i : integer;
begin
  with FObjectFileList do
  begin
    for n := 0 to Count - 1 do
        for i := 0 to TObjectFile(Items[n]).Count - 1 do
            if TDesktopObject(TObjectFile(Items[n]).Items[i]).Settings.ObjectID = ID then
            begin
              result := TDesktopObject(TObjectFile(Items[n]).Items[i]);
              exit;
            end;
    result := nil;
  end;
end;



procedure TSharpDeskManager.LoadObjectSet(OSet : TObjectSet);
var
   n : integer;
   ObjectFile : TObjectFile;
begin
  if OSet = nil then exit;
  for n := 0 to OSet.Count - 1 do
      begin
        ObjectFile := FObjectFileList.GetByObjectFile(TObjectSetItem(OSet.Items[n]).ObjectFile);
        if ObjectFile <> nil then ObjectFile.AddDesktopObject(TObjectSetItem(OSet.Items[n]));
      end;
end;



procedure TSharpDeskManager.UnselectAll;
var
   n,i : integer;
begin
  FSelectionCount := 0;
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
          TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]).Selected := False;
end;



procedure TSharpDeskManager.SelectAll;
var
   n,i : integer;
begin
  FSelectionCount := 0;
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
      begin
        FSelectionCount := FSelectionCount + 1;
        TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]).Selected := True;
      end;
end;



procedure TSharpDeskManager.UpdateSelection(Rect : TRect);
var
   n,i : integer;
   Point : TPoint;
   DesktopObject : TDesktopObject;
begin
  SelectionCount := 0;
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
      begin
        DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
        Point.X := round(DesktopObject.Layer.Location.Left + (DesktopObject.Layer.Location.Right-DesktopObject.Layer.Location.Left) / 2);
        Point.Y := round(DesktopObject.Layer.Location.Top + (DesktopObject.Layer.Location.Bottom-DesktopObject.Layer.Location.Top) / 2);
        DesktopObject.Selected := PointInRect(Point,Rect);
        if DesktopObject.Selected then SelectionCount := SelectionCount + 1;
      end;
end;



procedure TSharpDeskManager.MoveLayerTo(pDesktopObject : TObject; X,Y : integer);
var
   P : TPoint;
   L : TFloatRect;
begin
  if pDesktopObject = nil then exit;
  FObjectsMoved := True;
  L := TDesktopObject(pDesktopObject).Layer.Location;
  P.X := X - round(L.Left) + round((L.Right - L.Left) / 2);
  P.Y := Y - round(L.Top) + round((L.Bottom - L.Top) / 2);
  MoveLayerBy(pDesktopObject,P.X,P.Y);
end;



procedure TSharpDeskManager.MoveLayerBy(pDesktopObject : TObject; dX,dY : integer);
var
   w,h : integer;
   R,L : TFloatRect;
begin
  if pDesktopObject = nil then exit;
  if (dX = 0) and (dY = 0) then  exit;
  FObjectsMoved := True;
  R := TDesktopObject(pDesktopObject).Layer.Location;
  w := round(R.Right - R.Left);
  h := round(r.Bottom - R.Top);
  L.Left := R.Left + dX;
  L.Top := R.Top + dY;
  L.Right := L.Left + w;
  L.Bottom := L.Top + h;
  TDesktopObject(pDesktopObject).Layer.Location := L;
//  TDesktopObject(pDesktopObject).Settings.Pos := Point(round(L.Left),round(L.Top));
  TDesktopObject(pDesktopObject).Settings.Pos := Point(TDesktopObject(pDesktopObject).Settings.Pos.X +dx,
                                                       TDesktopObject(pDesktopObject).Settings.Pos.Y +dy);
  TDesktopObject(pDesktopObject).Layer.Bitmap.Changed;
end;


procedure TSharpDeskManager.MoveSelectedLayers(dX,dY : integer; pIgnoreLocked : boolean);
var
   n,i : integer;
   DesktopObject : TDesktopObject;
begin
  if (dx=0) and (dy=0) then exit
      else FObjectsMoved := True;
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
      begin
        DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
        if (DesktopObject.Selected) and ((not DesktopObject.Settings.Locked) or (pIgnoreLocked)) then
           MoveLayerBy(DesktopObject,dX,dY);
      end;
  AlignSelectedObjectsToGrid;
end;



procedure TSharpDeskManager.DeleteSelectedLayers;
var
   DesktopObject : TDesktopObject;
   n,i,k,c : integer;
   fn : string;
begin
  for n := 0 to FObjectFileList.Count -1 do
  begin
    k := 0;
    c := TObjectFile(FObjectFileList.Items[n]).Count;
    for i := 0 to c - k - 1 do
    begin
      DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i-k]);
      if DesktopObject.Selected then
      begin
        try
          fn := DesktopObject.Settings.ObjectFile;
          setlength(fn,length(fn)-length(FObjectExt));
          DeleteFile(SharpApi.GetSharpeUserSettingsPath +  'SharpDesk\Objects\'
                     + fn + '\' + inttostr(DesktopObject.Settings.ObjectID)
                     +'.xml');
        except
        end;
        DesktopObject.Delete;
        TObjectFile(FObjectFileList.Items[n]).Delete(i-k);
        k := k + 1;
      end;
    end;
    if TObjectFile(FObjectFileList.Items[n]).Count = 0 then
       TObjectFile(FObjectFileList.Items[n]).Unload;
  end;
  FObjectSetList.SaveSettings;
  CheckGhostLayers;
  CheckInvisibleLayers;
end;



procedure TSharpDeskManager.UnloadAllObjects;
var
   n : integer;
begin
  for n := 0 to FObjectFileList.Count - 1 do
      TObjectFile(FObjectFileList.Items[n]).UnloadObjects;
end;



procedure TSharpDeskManager.ResizeBackgroundLayer;
begin
//  FBackgroundLayer.Bitmap.SetSize(FImage.Width,FImage.Height);
  FBackgroundLayer.Bitmap.SetSize(10,10);
  FBackgroundLayer.Scaled := True;
  FBackgroundLayer.Bitmap.Clear(Color32(100,100,100,0));
  FBackgroundLayer.Location:=FloatRect(0,0,FImage.Width,FImage.Height);
  FEffectLayer.Bitmap.SetSize(10,10);
  FEffectLayer.Scaled := True;
  FEffectLayer.Bitmap.Clear(Color32(0,0,0,255));
  FEffectLayer.Location:=FloatRect(0,0,FImage.Width,FImage.Height);
end;



procedure TSharpDeskManager.CloneSelectedObjects;
var
   DesktopObject : TDesktopObject;
   ObjectSet : TObjectSet;
   Settings : TObjectSetItem;
   n,i,c : integer;
   newID : integer;
   newfile,oldfile,fn : string;
   newList : TObjectList;
begin
  newList := TObjectList.Create(False);
  for n := 0 to FObjectFileList.Count -1 do
  begin
    c := TObjectFile(FObjectFileList.Items[n]).Count;
    for i := 0 to c - 1 do
    begin
      DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
      if DesktopObject.Selected then
      begin
        ObjectSet := TObjectSet(DesktopObject.Settings.Owner);
        newID := ObjectSetList.GenerateObjectID;
        fn := DesktopObject.Settings.ObjectFile;
        setlength(fn,length(fn)-length(FObjectExt));
        oldfile := SharpApi.GetSharpeUserSettingsPath +  'SharpDesk\Objects\'
                   + fn + '\' + inttostr(DesktopObject.Settings.ObjectID)
                   +'.xml';
        newfile := SharpApi.GetSharpeUserSettingsPath +  'SharpDesk\Objects\'
                   + fn + '\' + inttostr(newID)
                   +'.xml';
        if FileExists(oldfile) then
           CopyFile(PChar(oldfile),PChar(newfile),false);
        Settings := ObjectSet.AddDesktopObject(newId,
                                               DesktopObject.Settings.ObjectFile,
                                               Point(DesktopObject.Settings.Pos.X + CLONE_X,
                                                     DesktopObject.Settings.Pos.Y + CLONE_Y),
                                               False,
                                               False);
        TObjectFile(FObjectFileList.Items[n]).AddDesktopObject(Settings);
        newList.Add(TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[TObjectFile(FObjectFileList.Items[n]).Count - 1]));
      end;
    end;
  end;

  UnselectAll;
  for n := 0 to NewList.Count - 1 do
      TDesktopObject(NewList.Items[n]).Selected := True;
  newList.Free;
  FObjectSetList.SaveSettings;
end;



procedure TSharpDeskManager.CheckObjectPosition;
var
   DesktopObject : TDesktopObject;
   n,i : integer;
   w,h : integer;
   nPos,oPos : TPoint;
   L : TFloatRect;
begin
  if not FDeskSettings.CheckObjectPosition then
  begin
    FObjectSetList.SaveSettings;
    exit
  end;

  for n := 0 to FObjectFileList.Count -1 do
  begin
    for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
    begin
      DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
      oPos.X := round(DesktopObject.Layer.Location.Left);
      oPos.Y := round(DesktopObject.Layer.Location.Top);
      w := round(DesktopObject.Layer.Location.Right-DesktopObject.Layer.Location.Left);
      h := round(DesktopObject.Layer.Location.Bottom-DesktopObject.Layer.Location.Top);
      nPos := oPos;
      if oPos.X + w < 0 then nPos.X := 0
         else if oPos.X > Screen.DesktopWidth - 48 then nPos.X := Screen.DesktopWidth - 48;
      if oPos.Y + h < 0 then nPos.Y := 0
         else if oPos.Y > Screen.DesktopHeight - 48 then nPos.Y := Screen.DesktopHeight - 48;
      if (nPos.X<>oPos.X) or (nPos.Y<>oPos.Y) then
      begin
        L := DesktopObject.Layer.Location;
        L.Right := nPos.X + (L.Right - L.Left);
        L.Bottom := nPos.Y + (L.Bottom - L.Top);
        L.Left := nPos.X;
        L.Top := nPos.Y;
        DesktopObject.Layer.Location := L;
        DesktopObject.Settings.Pos := nPos;
      end;
    end;
  end;
  FObjectSetList.SaveSettings;
end;



procedure TSharpDeskManager.LockAllObjects;
var
   n,i : integer;
begin
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
          TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]).Settings.Locked := True;
  FObjectSetList.SaveSettings;
end;



procedure TSharpDeskManager.LockSelectedObjects;
var
   n,i : integer;
   DesktopObject : TDesktopObject;
begin
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
      begin
        DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
        if DesktopObject.Selected then DesktopObject.Settings.Locked := True;
      end;
  FObjectSetList.SaveSettings;
end;



procedure TSharpDeskManager.UnLockAllObjects;
var
   n,i : integer;
begin
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
          TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]).Settings.Locked := False;
  FObjectSetList.SaveSettings;
end;



procedure TSharpDeskManager.UnLockSelectedObjects;
var
   n,i : integer;
   DesktopObject : TDesktopObject;
begin
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
      begin
        DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
        if DesktopObject.Selected then DesktopObject.Settings.Locked := False;
      end;
  FObjectSetList.SaveSettings;
end;



procedure TSharpDeskManager.AlignSelectedObjectsToGrid;
var
   n,i : integer;
   DesktopObject : TDesktopObject;
   CPos : TPoint;
begin
  if not self.FDeskSettings.Grid then exit;
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
      begin
        DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
        if (DesktopObject.Selected) and (not DesktopObject.Settings.Locked) then
        begin
          CPos := GetNextGridPoint(DesktopObject.Settings.Pos);
          MoveLayerTo(DesktopObject,
                      CPos.X - DesktopObject.Layer.Bitmap.Width,
                      CPos.Y - DesktopObject.Layer.Bitmap.Height);
          DesktopObject.Settings.Pos := CPos;
        end;
      end;
end;



procedure TSharpDeskManager.SendSelectedObjectsToBack;
var
   n,i : integer;
   DesktopObject : TDesktopObject;
begin
  if not self.FDeskSettings.Grid then exit;
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
      begin
        DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
        if DesktopObject.Selected then
        begin
          TObjectSet(DesktopObject.Settings.Owner).Extract(DesktopObject.Settings);
          TObjectSet(DesktopObject.Settings.Owner).Insert(0,DesktopObject.Settings);
          DesktopObject.Layer.SendToBack;
        end;
      end;
  FObjectSetList.SaveSettings;
  FEffectLayer.SendToBack;
  FBackgroundLayer.SendToBack;
end;



procedure TSharpDeskManager.BringSelectedObjectsToFront;
var
   n,i : integer;
   DesktopObject : TDesktopObject;
begin
  if not self.FDeskSettings.Grid then exit;

  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
      begin
        DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
        if DesktopObject.Selected then
        begin
          TObjectSet(DesktopObject.Settings.Owner).Extract(DesktopObject.Settings);
          TObjectSet(DesktopObject.Settings.Owner).Add(DesktopObject.Settings);
          DesktopObject.Layer.BringToFront;
        end;
      end;
  FObjectSetList.SaveSettings;
end;



procedure TSharpDeskManager.CreatePreset(pDesktopObject : TObject; pName : String);
var
   XML : TJvSimpleXML;
   oXML : TJvSimpleXML;
   MaxID : integer;
   n : integer;
   fn : string;
   tempObject : TDesktopObject;
begin
  tempObject := TDesktopObject(pDesktopObject);
  if tempObject = nil then exit;

  CheckPresetsFile;
  XML := TJvSimpleXML.Create(nil);
  oXML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(GetSharpeUserSettingsPath + 'SharpDesk\Presets.xml');
    with XML.Root.Items.ItemNamed['PresetList'].Items do
    begin
      for n:=0 to Count-1 do
          if (Item[n].Items.Value('Name',pName)=pName)
             and (Item[n].Items.Value('ObjectFile',tempObject.Owner.FileName)=tempObject.Owner.FileName) then
             begin
               showmessage('Another preset with the same name already exists!');
               XML.Free;
               XML := nil;
               exit;
             end;
             MaxID:=0;
             for n:=0 to Count-1 do
                 if strtoint(Item[n].Name)>=MaxID then
                    MaxID := strtoint(Item[n].Name)+1;
      Add(inttostr(MaxID));
    end;
    with XML.Root.Items.ItemNamed['PresetList'].Items.ItemNamed[inttostr(MaxID)].Items do
    begin
      Add('Name',pName);
      Add('ObjectFile',tempObject.Owner.FileName);
    end;

    fn := tempObject.Settings.ObjectFile;
    setlength(fn,length(fn)-length(FObjectExt));
    oXML.LoadFromFile(SharpApi.GetSharpeUserSettingsPath +  'SharpDesk\Objects\'
                      + fn + '\' + inttostr(tempObject.Settings.ObjectID)
                      +'.xml');

    XML.Root.Items.ItemNamed['PresetSettings'].Items.Add(inttostr(MaxID));
    with XML.Root.Items.ItemNamed['PresetSettings'].Items.ItemNamed[inttostr(MaxID)].Items do
    begin
      for n:=0 to oXML.Root.Items.Count-1 do
          if oXML.Root.Items.Item[n].Properties.BoolValue('CopyValue',False) then
             Add(oXML.Root.Items.Item[n].Name,
                 oXML.Root.Items.Item[n].Value).Properties.Add('CopyValue',True);
            end;
    XML.SaveToFile(GetSharpeUserSettingsPath + 'SharpDesk\Presets.xml');
  finally
    if XML <> nil then XML.Free;
    if oXML <> nil then oXML.Free;
  end;
end;



procedure TSharpDeskManager.SavePresetAs(pDesktopObject : TObject; PresetID : integer);
var
   XML : TJvSimpleXML;
   oXML : TJvSimpleXML;
   n : integer;
   fn : string;
   DesktopObject : TDesktopObject;
begin
  DesktopObject := TDesktopObject(pDesktopObject);

  CheckPresetsFile;
  XML := TJvSimpleXML.Create(nil);
  oXML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(GetSharpeUserSettingsPath + 'SharpDesk\Presets.xml');
    XML.Root.Items.ItemNamed['PresetSettings'].Items.Delete(inttostr(PresetID));
    XML.Root.Items.ItemNamed['PresetSettings'].Items.Add(inttostr(PresetID));

    fn := DesktopObject.Settings.ObjectFile;
    setlength(fn,length(fn)-length(FObjectExt));
    oXML.LoadFromFile(SharpApi.GetSharpeUserSettingsPath +  'SharpDesk\Objects\'
                      + fn + '\' + inttostr(DesktopObject.Settings.ObjectID)
                      +'.xml');

    with XML.Root.Items.ItemNamed['PresetSettings'].Items.ItemNamed[inttostr(PresetID)].Items do
    begin
      for n:=0 to oXML.Root.Items.Count-1 do
          if oXML.Root.Items.Item[n].Properties.BoolValue('CopyValue',False) then
             Add(oXML.Root.Items.Item[n].Name,
                 oXML.Root.Items.Item[n].Value).Properties.Add('CopyValue',True);
    end;
    XML.SaveToFile(GetSharpeUserSettingsPath + 'SharpDesk\Presets.xml');
  finally
    XML.Free;
    oXML.Free;
  end;
end;


procedure TSharpDeskManager.LoadPresetForSelected(pID : integer);
var
  n,i : integer;
  DesktopObject : TDesktopObject;
begin
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
      begin
        DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
        if DesktopObject.Selected then
           LoadPreset(DesktopObject,pID,False);
      end;
end;


procedure TSharpDeskManager.LoadPresetForAll(pObjectFile : TObject; pID : integer);
var
   ObjectFile : TObjectFile;
   n : integer;
begin
  if pObjectFile = nil then exit;
  ObjectFile := TObjectFile(pObjectFile);
  for n := 0  to ObjectFile.Count - 1 do
      LoadPreset(ObjectFile.Items[n],pID,False);
end;



procedure TSharpDeskManager.LoadPreset(pDesktopObject : TObject; pID : integer; Save : boolean);
var
   XML : TJvSimpleXML;
   oXML : TJvSimpleXML;
   n,i : integer;
   DesktopObject : TDesktopObject;
   fn : String;
begin
  DesktopObject := TDesktopObject(pDesktopObject);

  CheckPresetsFile;
  XML := TJvSimpleXML.Create(nil);
  oXML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(GetSharpeUserSettingsPath + 'SharpDesk\Presets.xml');
    
    fn := DesktopObject.Settings.ObjectFile;
    setlength(fn,length(fn)-length(FObjectExt));
    oXML.LoadFromFile(SharpApi.GetSharpeUserSettingsPath +  'SharpDesk\Objects\'
                      + fn + '\' + inttostr(DesktopObject.Settings.ObjectID)
                      +'.xml');

    with oXML.Root.Items do
    begin
      for n:=0 to Count-1 do
          if Item[n].Properties.BoolValue('CopyValue',False) then
          for i:=0 to XML.Root.Items.ItemNamed['PresetSettings'].Items.ItemNamed[inttostr(pID)].Items.Count-1 do
              if Item[n].Name = XML.Root.Items.ItemNamed['PresetSettings'].Items.ItemNamed[inttostr(pID)].Items.Item[i].Name then
              begin
                Item[n].Value := XML.Root.Items.ItemNamed['PresetSettings'].Items.ItemNamed[inttostr(pID)].Items.Item[i].Value;
                break;
              end;
    end;
    oXML.SaveToFile(SharpApi.GetSharpeUserSettingsPath +  'SharpDesk\Objects\'
                      + fn + '\' + inttostr(DesktopObject.Settings.ObjectID)
                      +'.xml');
  finally
    XML.Free;
    oXML.Free;
  end;

  DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                          DesktopObject.Layer,
                                          SDM_REPAINT_LAYER,0,0,0);
end;



procedure TSharpDeskManager.AlignSelectedObjects(aID : integer);
var
   XML           : TJvSimpleXML;
   oXML          : TJvSimpleXML;
   X,Y,Wrap      : integer;
   nX,nY,nWrap   : integer;
   n,i           : integer;
   k,j           : integer;
   w,h           : integer;
   Start         : TPoint;
   Align         : TAlignBy;
   VList         : TStringList;
   DesktopObject : TDesktopObject;
   tempInt       : TIntClass;
   XMLItem       : TJvSimpleXMLElem;
   SValue        : String;
   L             : TFloatRect;
   fn            : String;
begin
  if FSelectionCount <= 1 then exit;
  CheckAlignsFile;
  if not FileExists(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml') then exit;

  XML := TJvSimpleXML.Create(nil);
  oXML := TJvSimpleXML.Create(nil);
  // Get settings for the align set
  try
    XML.LoadFromFile(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml');
    with XML.Root.Items.ItemNamed[inttostr(aID)].Items do
    begin
      X := IntValue('X',64);
      Y := IntValue('Y',64);
      Wrap := IntValue('Wrap',8);
      n := IntValue('Align',0);
      case n of
        0 : Align := albLeft;
        1 : Align := albCenter;
        else Align := albCenter;
      end;
    end;
  finally
    XML.Free;
  end;

  // Create object list and sort it
  Start := GetUpperLeftMostLayerPos;
  VList := TStringList.Create;
  VList.Clear;

  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
          begin
            DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
            if DesktopObject.Selected then
            begin
              fn := DesktopObject.Settings.ObjectFile;
              setlength(fn,length(fn)-length(FObjectExt));
              fn := SharpApi.GetSharpeUserSettingsPath +  'SharpDesk\Objects\'
                    + fn + '\' + inttostr(DesktopObject.Settings.ObjectID) + '.xml';
              SValue := inttostr(DesktopObject.Settings.ObjectID);
              if FileExists(fn) then
              try
                oXML.LoadFromFile(fn);
                XMLItem := oXML.Root;
                for j := 0 to XMLItem.Items.Count -1 do
                    for k := 0 to XMLItem.Items.Item[j].Properties.Count - 1 do
                        if UPPERCASE(XMLItem.Items.Item[j].Properties.Item[k].Name) = 'SORTVALUE' then
                        begin
                             SValue := XMLItem.Items.Item[j].Value;
                             break;
                        end;
              except
              end;
              VList.Add(SValue);
              tempInt := TIntClass.Create;
              tempInt.IntValue := DesktopObject.Settings.ObjectID;
              VList.Objects[VList.Count-1] := tempInt;
            end;
          end;

  oXML.Free;

  // Align all selected objects
  VList.Sort;
  nX := 0;
  nY := 0;
  nWrap := 0;
  if (Start.X + X) >= Screen.DesktopWidth - 32 then
     Start.X := Screen.DesktopWidth - X - 32;
  if (Start.Y + Y) >= Screen.DesktopHeight - 32 then
     Start.Y := Screen.DesktopHeight - Y - 32;
  for n := 0 to VList.Count - 1 do
  begin
    DesktopObject := TDesktopObject(GetDesktopObjectByID(TIntClass(VList.Objects[n]).IntValue));
    if DesktopObject <> nil then
    begin
      L := DesktopObject.Layer.Location;
      w := round(L.Right - L.Left);
      h := round(L.Bottom - L.Top);
      case Align of
        albLeft : DesktopObject.Settings.Pos := Types.Point(Start.X + nX * X,
                                                            Start.Y + nY * Y);
        albCenter : DesktopObject.Settings.Pos := Types.Point(Start.X + nX * X - w div 2,
                                                              Start.Y + nY * Y);
      end;
      L.Left := DesktopObject.Settings.Pos.X;
      L.Top := DesktopObject.Settings.Pos.Y;
      L.Right := L.Left + w;
      L.Bottom := L.Top + h;
      DesktopObject.Layer.Location := L;
      DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                              DesktopObject.Layer,
                                              SDM_MOVE_LAYER,0,0,0);
    end;
    nX := nX + 1;
    nWrap := nWrap + 1;
    if (Start.X + nX * X) + X >= Screen.DesktopWidth then
       nWrap := Wrap;
    if (Start.Y + nY * Y) + Y >= Screen.DesktopHeight then
    begin
      nY := 0;
      nx := 0;
      nWrap := 0;
      Start.X := Start.X + 16;
      if (Start.X + X) >= Screen.DesktopWidth - 32 then
         Start.X := Screen.DesktopWidth - X - 32;
    end;
    if nWrap >= Wrap then
    begin
      nX := 0;
      nY := nY + 1;
      nWrap := 0;
    end;
  end;

  // Clear the object list
  for n := 0 to VList.Count - 1 do
  begin
    TIntClass(VList.Objects[n]).Free;
    VList.Objects[n] := nil;
  end;
  FreeAndNil(VList);
end;



function TSharpDeskManager.GetUpperLeftMostLayerPos : TPoint;
var
   n,i : integer;
   pos : TPoint;
   DesktopObject : TDesktopObject;
begin
  if FImage.Layers.Count = 0 then
  begin
    GetUpperLeftMostLayerPos := Screen.DesktopRect.TopLeft;
    exit;
  end;

  pos := Screen.DesktopRect.BottomRight;
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
          begin
            DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
            if DesktopObject.Selected then
            begin
              if DesktopObject.Settings.Pos.X < pos.X then pos.X := DesktopObject.Settings.Pos.X;
              if DesktopObject.Settings.Pos.Y < pos.Y then pos.Y := DesktopObject.Settings.Pos.Y;
            end;
          end;
    GetUpperLeftMostLayerPos := pos;
end;


// ######################################


procedure TSharpDeskManager.ConvertOldObjectFormat;
var
   sr : TSearchRec;
   ObjTitle : String;
begin
     if FindFirst(ExtractFilePath(application.exename)+'Objects\*.dll', faAnyFile, sr) = 0 then
     begin
         repeat
               ObjTitle   := sr.Name;
               SetLength(ObjTitle,length(ObjTitle)-4);
               If FileExists(ExtractFilePath(application.exename)+'Objects\'+ObjTitle+'.object') then DeleteFile(PChar(ExtractFilePath(application.exename)+'Objects\'+ObjTitle+'.object'));
               MoveFile(PChar(ExtractFilePath(application.exename)+'Objects\'+ObjTitle+'.dll'),PChar(ExtractFilePath(application.exename)+'Objects\'+ObjTitle+'.object'));
         until FindNext(sr) <> 0;
         FindClose(sr);
     end;
end;



procedure TSharpDeskManager.LoadObjectSetsFromTheme(pThemeName : String);
var
  n : integer;
  ObjectSet : TObjectSet;
begin
  UnloadAllObjects;
  for n := 0 to FObjectSetList.Count - 1 do
  begin
    ObjectSet := TObjectSet(FObjectSetList.Items[n]);
    if ObjectSet.ThemeList.IndexOf(pThemeName) >= 0 then
       LoadObjectSet(ObjectSet); 
  end;
  if FEffectLayer.Bitmap.MasterAlpha<>0 then FEffectLayer.BringToFront;
end;

procedure TSharpDeskManager.LoadObjectSets(SetList : String);
var
   SList : TStringList;
   n : integer;
   ObjectSet : TObjectSet;
begin
  UnloadAllObjects;
  SList := TStringList.Create;
  SList.Clear;
  SList.CommaText := SetList;
  for n:= 0 to SList.Count - 1 do
  begin
    ObjectSet := TObjectSet(ObjectSetList.GetSetByID(strtoint(SList[n])));
    LoadObjectSet(ObjectSet);
  end;
  SList.Free;
  if FEffectLayer.Bitmap.MasterAlpha<>0 then FEffectLayer.BringToFront;
end;



procedure TSharpDeskManager.SelectBySetID(pSetID : integer);
var
   DesktopObject : TDesktopObject;
   n : integer;
   i : integer;
begin
  UnselectAll;
  for n := 0 to FObjectFileList.Count -1 do
  begin
    for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
    begin
      DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
      if DesktopObject <> nil then
         if TObjectSet(DesktopObject.Settings.Owner).SetID = pSetID then
         begin
           FSelectionCount := FSelectionCount + 1;
           DesktopObject.Selected := True;
         end;
    end;
  end;
end;



function TSharpDeskManager.GenerateObjectID : integer;
begin
  if FObjectSetList = nil then result := -1
     else result := FObjectSetList.GenerateObjectID;
end;



function  TSharpDeskManager.IsAnyObjectSetLoaded : boolean;
var
   n : integer;
   SList : TStringList;
begin
  SList := TStringList.Create;
  SList.Clear;
  for n := 0 to ObjectSetList.Count - 1 do
      if TObjectSet(ObjectSetList.Items[n]).ThemeList.IndexOf(SharpThemeApi.GetThemeName) >= 0 then
         SList.Add(inttostr(TObjectSet(ObjectSetList.Items[n]).SetID));
  for n := 0 to SList.Count - 1 do
      if FObjectSetList.GetSetByID(strtoint(SList[n])) <> nil then
      begin
        result := True;
        SList.Free;
        exit;
      end;
  SList.Free;
  result := False;
end;



procedure TSharpDeskManager.CheckPresetsFile;
var
  n : integer;
  newFile : String;
  FileName : String;
  XML : TJvSimpleXML;
begin
  FileName := GetSharpeUserSettingsPath + 'SharpDesk\Presets.xml';
  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(FileName);
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(Format('Error While Loading "%s"', [FileName])), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
      if FileExists(FileName) then
      begin
        n := 1;
        while FileExists(FileName + 'backup#' + inttostr(n)) do n := n + 1;
        NewFile := FileName + 'backup#' + inttostr(n);
        CopyFile(PChar(FileName),PChar(NewFile),True);
        SharpApi.SendDebugMessageEx('SharpDesk',PChar('Old file backup :' + NewFile),clblue,DMT_INFO);
      end;
      ForceDirectories(ExtractFileDir(FileName));
      XML.Root.Clear;
      XML.Root.Name := 'Presets';
      XML.Root.Items.Add('PresetList');
      XML.Root.Items.Add('PresetSettings');
      XML.SaveToFile(FileName);
    end;
  end;
  XML.Free;
end;



procedure TSharpDeskManager.CheckAlignsFile;
var
  n : integer;
  newFile : String;
  FileName : String;
  XML : TJvSimpleXML;
begin
  FileName := GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml';
  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(FileName);
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(Format('Error While Loading "%s"', [FileName])), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
      if FileExists(FileName) then
      begin
        n := 1;
        while FileExists(FileName + 'backup#' + inttostr(n)) do n := n + 1;
        NewFile := FileName + 'backup#' + inttostr(n);
        CopyFile(PChar(FileName),PChar(NewFile),True);
        SharpApi.SendDebugMessageEx('SharpDesk',PChar('Old file backup :' + NewFile),clblue,DMT_INFO);
      end;
      ForceDirectories(ExtractFileDir(FileName));
      XML.Root.Clear;
      XML.Root.Name := 'Aligns';
      XML.SaveToFile(FileName);
    end;
  end;
  XML.Free;
end;



procedure TSharpDeskManager.CheckGhostObjects;
var
   n,i : integer;
   ObjectSet : TObjectSet;
   ObjectSetItem : TObjectSetItem;
   ObjectList : TStringList;
   sr,sr2 : TSearchRec;
   dir : String;
   oID : string;
begin
  UnloadAllObjects;

  ObjectList := TStringList.Create;
  ObjectList.Clear;
  for n := 0 to FObjectSetList.Count - 1 do
  begin
    ObjectSet := TObjectSet(FObjectSetList.Items[n]);
    for i := 0 to ObjectSet.Count - 1 do
    begin
      ObjectSetItem := TObjectSetItem(ObjectSet.Items[i]);
      ObjectList.Add(Inttostr(ObjectSetItem.ObjectID));
    end;
  end;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpDesk\Objects\';
  if FindFirst(Dir + '*.*', faDirectory , sr) = 0 then
  repeat
    if (sr.Name <> '.') and (sr.Name <> '..') then
    begin
      if FindFirst(Dir + sr.Name + '\*.xml',faAnyFile,sr2) = 0 then
      repeat
        oID := sr2.Name;
        setlength(oID,length(oID)-4);
        if (ObjectList.IndexOf(oID) = -1) then
        begin
          DeleteFile(Dir + sr.Name + '\' + sr2.Name);
          SharpApi.SendDebugMessageEx('SharpDesk',PChar('Deleting Ghost settings file: '+Dir + sr.Name + '\' + sr2.Name), clred, DMT_ERROR);
        end;
      until FindNext(sr2) <> 0;
      FindClose(sr2);
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);

  ObjectList.Free;
  exit;
end;


procedure TSharpDeskManager.SendMessageToAllObjects(messageID : integer; P1,P2,P3 : integer);
var
  i,n : integer;
  DesktopObject : TDesktopObject;
begin
  for i := 0 to  FObjectFileList.Count - 1 do
      for n := 0 to TObjectFile(FObjectFileList.Items[i]).Count - 1 do
      begin
        DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[i]).Items[n]);
        if DesktopObject<>nil then
           DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                                   DesktopObject.Layer,
                                                   messageID,P1,P2,P3);
      end;
end;

procedure TSharpDeskManager.CheckGhostLayers;
var
  n : integer;
begin
  n := 0;
  while n<FImage.Layers.Count do
        if (GetDesktopObjectByID(FImage.Layers.Items[n].Tag) = nil) and (FImage.Layers.Items[n].Tag>=0) then
           FImage.Layers.Delete(n)
           else n := n + 1;
end;


// This procedure will only render the disable animation
procedure TSharpDeskManager.DisableAnimation;
var
  n : integer;
begin
  FEffectLayer.Bitmap.SetSize(FImage.Bitmap.Width,FImage.Bitmap.Height);
  FImage.Bitmap.DrawTo(FEffectLayer.Bitmap);
  if FEffectLayer.Bitmap.MasterAlpha = 255 then exit;
  FEffectLayer.BringToFront;
  for n := 0 to 5 do
  begin
    FEffectLayer.Bitmap.MasterAlpha := n*51;
    FImage.Repaint;
    sleep(10);
  end;
  FEffectLayer.Bitmap.MasterAlpha := 255;
  FEffectLayer.Bitmap.DrawMode := dmOpaque;
end;

// This procedure will only render the enable animation
procedure TSharpDeskManager.EnableAnimation;
var
  n : integer;
begin
  FImage.Bitmap.DrawTo(FEffectLayer.Bitmap);
  if FEffectLayer.Bitmap.MasterAlpha = 0 then exit;
  FEffectLayer.Bitmap.DrawMode := dmBlend;
  FEffectLayer.BringToFront;
  for n := 5 downto 0 do
  begin
    FEffectLayer.Bitmap.MasterAlpha := n*51;
    FImage.Repaint;
    sleep(10);
  end;
  FEffectLayer.Bitmap.MasterAlpha := 0;
  FEffectLayer.SendToBack;
  FEffectLayer.Bitmap.SetSize(10,10)
end;

procedure TSharpDeskManager.UpdateAnimationLayer;
begin
  FImage.Bitmap.DrawTo(FEffectLayer.Bitmap);
end;

procedure TSharpDeskManager.CheckInvisibleLayers;
//var
 //n,i : integer;
 //DesktopObject : TDesktopObject;
begin
  // handled by objects now

 { for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
      begin
        DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
        if not HasVisiblePixel(DesktopObject.Layer.Bitmap) then
           begin
             showmessage(inttostr(DesktopObject.Layer.Bitmap.Width));
             if (DesktopObject.Layer.Bitmap.Width<=10) or (DesktopObject.Layer.Bitmap.Height<=10) then
                DesktopObject.Layer.Bitmap.SetSize(16,16);
             DesktopObject.Layer.Bitmap.clear(color32(128,128,128,128));
           end;
      end;     }
end;

procedure TSharpDeskManager.AssignSelectedObjectsToSet(setID : integer);
var
  n,i : integer;
  DesktopObject : TDesktopObject;
  ObjectSet     : TObjectSet;
begin
  if setID > ObjectSetList.Count - 1 then exit;
  ObjectSet := TObjectSet(ObjectSetList.Items[SetID]);
  if ObjectSet = nil then exit;

  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
      begin
        DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
        if DesktopObject.Selected then
        begin
          if ObjectSet <> TObjectSet(DesktopObject.Settings.Owner) then
          begin
            ObjectSet.AddDesktopObject(DesktopObject.Settings.ObjectID,DesktopObject.Settings.ObjectFile,DesktopObject.Settings.Pos,DesktopObject.Settings.Locked,DesktopObject.Settings.isWindow);
            TObjectSet(DesktopObject.Settings.Owner).Remove(DesktopObject.Settings);
            DesktopObject.Settings := TObjectsetItem(ObjectSet.Items[ObjectSet.Count-1]);
          end;
        end;
      end;
  FObjectSetList.SaveSettings;
end;

function  TSharpDeskManager.SelectedObjectsOfSameType(dummy : string) : String;
var
  n,i : integer;
  t : String;
  DesktopObject : TDesktopObject;
begin
  t := '';
  for n := 0 to FObjectFileList.Count -1 do
      for i := 0 to TObjectFile(FObjectFileList.Items[n]).Count - 1 do
      begin
        DesktopObject := TDesktopObject(TObjectFile(FObjectFileList.Items[n]).Items[i]);
        if DesktopObject.Selected then
        begin
          if length(t) = 0 then t := DesktopObject.Settings.ObjectFile
             else if t<>DesktopObject.Settings.ObjectFile then
             begin
               result := '0';
               exit;
             end;
        end;
      end;
  result := t;
end;

function  TSharpDeskManager.SelectedObjectsOfSameType(dummy : integer) : boolean;
begin
  if SelectedObjectsOfSameType('') = '0' then result := false
     else result := true;
end;

end.
