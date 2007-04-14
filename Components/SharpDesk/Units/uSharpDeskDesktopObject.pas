{
Source Name: uSharpDeskDesktopObject.pas
Description: TDesktopObject class
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

unit uSharpDeskDesktopObject;

interface

uses Windows,
     Types,
     Forms,
		 Graphics,
     Dialogs,
     SysUtils,
     gr32_layers,
     gr32_image,
     gr32,
     SharpApi,
     SharpDeskApi,
     uSharpDeskManager,
     uSharpDeskObjectFile,
     uSharpDeskObjectSetItem,
     uSharpDeskLayeredWindow;

type
    TDesktopObject = class
    private
      FOwner       : TObjectFile;
      FDeskManager : TSharpDeskManager;
      FSettings    : TObjectSetItem;
      FSelected 	 : boolean;
      FLayer			 : TBitmapLayer;
      FWindow      : TSharpDeskLayeredWindow;
      procedure FSetSelected(Value : boolean);
      procedure LayerOnPaint(Sender: TObject; Buffer: TBitmap32);
      procedure LayerOnChange(Sender : TObject);
      //procedure BitmapOnChange(Sender : TObject);
    public
      constructor Create(pOwner : TObjectFile;
                         pSettings : TObjectSetItem);
      destructor Destroy; override;
      procedure Delete;
      procedure MakeWindow;
      procedure MakeLayer;
    published
      property DeskManager : TSharpDeskManager read FDeskManager;
      property Owner       : TObjectfile  read FOwner;
      property Layer		   : TBitmapLayer read FLayer write FLayer;
      property Selected    : boolean 		 read FSelected write FSetSelected;
      property Settings    : TObjectSetItem read FSettings write FSettings;
    end;

implementation

uses uSharpDeskObjectFileList,
     uSharpDeskObjectSet;


procedure TDesktopObject.Delete;
begin
  self.Owner.DllSharpDeskMessage(FSettings.ObjectID,FLayer,SDM_DELETE_LAYER,0,0,0);
  TObjectSet(FSettings.Owner).Remove(FSettings);
end;

constructor TDesktopObject.Create(pOwner : TObjectFile;
                                  pSettings : TObjectSetItem);
begin
	Inherited Create;
  FOwner := pOwner;
  FWindow := nil;
  try
    FDeskManager := TSharpDeskManager(TObjectFileList(FOwner.Owner).Owner);
  except
    FDeskManager := nil;
  end;

  FSettings := pSettings;
  FSelected := False;


  if (FOwner = nil) or
     (FSettings.ObjectID = 0) or
     (FDeskManager.Image = nil) then
     begin
          SharpApi.SendDebugMessageEx('SharpDesk',
                                      PChar('Failed to load object!'),
                                      clmaroon,
                                      DMT_ERROR);
          exit;
     end;

  try
  	FLayer := Fowner.DllCreateLayer(FDeskManager.Image,FSettings.ObjectID);
    FLayer.OnPaint := LayerOnPaint;
		FLayer.Tag := FSettings.ObjectID;
    FLayer.AlphaHit:=False;
    FLayer.Location := FloatRect(FSettings.Pos.X,
                                 FSettings.Pos.Y,
                                 FSettings.Pos.X + FLayer.Bitmap.Width,
                                 FSettings.Pos.Y + FLayer.Bitmap.Height);
		FLayer.BringToFront;

    SharpApi.SendDebugMessageEx('SharpDesk',
                                PChar('adding ' + inttostr(FSettings.ObjectID) + '('+FOwner.FileName+')'),
                                clblack,
                                DMT_STATUS);
		FOwner.DllSharpDeskMessage(FSettings.ObjectID,FLayer,SDM_UPDATE_LAYER,0,0,0);
  except
    SharpApi.SendDebugMessageEx('SharpDesk',
                                PChar('failed to add ' + inttostr(FSettings.ObjectID) + '('+FOwner.FileName+')'),
                                clmaroon,
                                DMT_ERROR);

    if FLayer <> nil then FLayer.Free;
		FLayer := TBitmapLayer.Create(FDeskManager.Image.Layers);
    FLayer.Bitmap.Width := 32;
    FLayer.Bitmap.Height := 32;
    FLayer.Bitmap.Clear(color32(128,128,128,128));
    FLayer.Tag := FSettings.ObjectID;
    FLAyer.AlphaHit := False;
    FLayer.Location := FloatRect(FSettings.Pos.X,
                                 FSettings.Pos.Y,
                                 FSettings.Pos.X+FLayer.Bitmap.Width,
                                 FSettings.Pos.Y+FLayer.Bitmap.Height);
    FLayer.BringToFront;
  end;
  if FSettings.isWindow then MakeWindow;
end;

procedure TDesktopObject.MakeWindow;
begin
  if FWindow <> nil then MakeLayer;
  
  try
   {  if LOB_VISIBLE and FLAyer.LayerOptions <> 0 then showmessagE('LOB_VISIBLE');
     if LOB_GDI_OVERLAY and FLAyer.LayerOptions <> 0 then showmessagE('LOB_GDI_OVERLAY');
     if LOB_MOUSE_EVENTS and FLAyer.LayerOptions <> 0 then showmessagE('LOB_MOUSE_EVENTS');
     if LOB_NO_UPDATE and FLAyer.LayerOptions <> 0 then showmessagE('LOB_NO_UPDATE');
     if LOB_NO_CAPTURE and FLAyer.LayerOptions <> 0 then showmessagE('LOB_NO_CAPTURE');
     if LOB_INVALID and FLAyer.LayerOptions <> 0 then showmessagE('LOB_INVALID');
     if LOB_RESERVED_25 and FLAyer.LayerOptions <> 0 then showmessagE('LOB_RESERVED_25');
     if LOB_RESERVED_24 and FLAyer.LayerOptions <> 0 then showmessagE('LOB_RESERVED_24');
     if LOB_RESERVED_MASK and FLAyer.LayerOptions <> 0 then showmessagE('LOB_RESERVED_MASK');}

    FLayer.Visible := False;
    //FLayer.LayerOptions := LOB_NO_CAPTURE;
    FDeskManager.Image.Repaint;
    FLayer.OnChange := LayerOnChange;
    //FLayer.Bitmap.OnChange := BitmapOnChange;
    FWindow := TSharpDeskLayeredWindow.Create(nil);
    FWindow.Left := FSettings.Pos.X;
    FWindow.Top := FSettings.Pos.Y;
    FWindow.Width := FLayer.Bitmap.Width;
    FWindow.Height := FLayer.Bitmap.Height;
    FWindow.Width := round(FLayer.Location.Right-FLayer.Location.Left);
    FWindow.Height := round(FLayer.Location.Bottom-FLayer.Location.Top);
    FWindow.Picture := FLayer.Bitmap;
    FWindow.DesktopObject := self;
    FWindow.Tag := FSettings.ObjectID;
    FWindow.PopupMenu := FDeskManager.Image.PopupMenu;
   // showmessage(inttostr(FWindow.Left));
    FWindow.Show;
    FWindow.DrawWindow;
    FSettings.isWindow := True;
  except
    FSettings.isWindow := False;
    FLayer.Visible := True;
    SharpApi.SendDebugMessageEx('SharpDesk','Error creating object window',clred,DMT_ERROR);
    try
      FWindow.Free;
    finally
      FWindow := nil;
    end;
  end;
end;


procedure TDesktopObject.MakeLayer;
begin
  if FWindow <> nil then
  begin
    FSettings.isWindow := False;
    try
      try
        FWindow.Free;
      except
        SharpApi.SendDebugMessageEx('SharpDesk','Error creating object window',clred,DMT_ERROR);
      end;
    finally
      FWindow := nil;
    end;
    FLayer.Visible := True;
//    FLayer.LayerOptions := LOB_VISIBLE or LOB_GDI_OVERLAY or LOB_MOUSE_EVENTS or LOB_RESERVED_MASK;
//    FLayer.Bitmap.OnChange := nil;
//    FLayer.Bitmap.Changed;
    FLayer.BringToFront;
    FDeskManager.BackgroundLayer.SendToBack;
    FDeskManager.Image.Repaint;    
  end;
end;

procedure TDesktopObject.LayerOnChange(Sender : TObject);
begin
  if Fwindow <> nil then
  begin
//    FWindow.Left := FSettings.Pos.X;
//    FWindow.Top := FSettings.Pos.Y;
 //   FWindow.Width := FLayer.Bitmap.Width;
 //   FWindow.Height := FLayer.Bitmap.Height;
//    FWindow.Left  := round(FLayer.Location.Left);
  //  FWindow.Top   := round(FLayer.Location.Top);
    FWindow.Width := round(FLayer.Location.Right-FLayer.Location.Left);
    FWindow.Height := round(FLayer.Location.Bottom-FLayer.Location.Top);
    FWindow.DrawWindow;
    SetWindowPos(FWindow.Handle, HWND_TOPMOST,
                         round(FLayer.Location.Left),
                         round(FLayer.Location.Top),
                         0,
                         0, SWP_NOACTIVATE or SWP_NOSIZE);
    FWindow.Picture := FLayer.Bitmap;
  end;
end;

{procedure TDesktopObject.BitmapOnChange(Sender : TObject);
begin
  if Fwindow <> nil then
  begin
    FWindow.Left := FSettings.Pos.X;
    FWindow.Top := FSettings.Pos.Y;
    FWindow.Width := FLayer.Bitmap.Width;
    FWindow.Height := FLayer.Bitmap.Height;
    FWindow.Picture := FLayer.Bitmap;
    FWindow.DrawWindow;
  end;
end;  }

procedure TDesktopObject.LayerOnPaint(Sender: TObject; Buffer: TBitmap32);
begin
  if FWindow <> nil then
  begin
    FWindow.Left := FSettings.Pos.X;
    FWindow.Top := FSettings.Pos.Y;
    FWindow.Width := FLayer.Bitmap.Width;
    FWindow.Height := FLayer.Bitmap.Height;
    FWindow.Picture := FLayer.Bitmap;
    FWindow.DrawWindow;
  end;
end;


destructor TDesktopObject.Destroy;
begin
  SharpApi.SendDebugMessageEx('SharpDesk',PChar('Sending SDM_CLOSE_LAYER to ' + inttostr(Settings.ObjectID)),0,DMT_INFO);
  FOwner.DllSharpDeskMessage(Settings.ObjectID,FLayer,SDM_CLOSE_LAYER,0,0,0);
//  if FLayer <> nil then FreeAndNil(FLayer);
  if FWindow<>nil then
  begin
    FWindow.Free;
    FWindow := nil;
  end;
	Inherited Destroy;
end;

procedure TDesktopObject.FSetSelected(Value : boolean);
var
  i : integer;
begin
  if Settings.Locked then i := 1
     else i := 0;
     
  if Value <> FSelected then
  try
    case Value of
     True : Owner.DllSharpDeskMessage(FSettings.ObjectID,Layer,SDM_SELECT,i,0,0);
     False : Owner.DllSharpDeskMessage(FSettings.ObjectID,Layer,SDM_DESELECT,i,0,0);
    end;
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_SELECT/SDM_DESELECT to ' + inttostr(Settings.ObjectID) + '('+Owner.FileName+')'), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
    end;
  end;
  FSelected := Value;
end;

end.
