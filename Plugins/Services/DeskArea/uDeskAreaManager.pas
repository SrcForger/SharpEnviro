{
Source Name: uDeskAreaManager.dpr
Description: Desk Area Manager Class
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.SharpE-Shell.org

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

unit uDeskAreaManager;

interface

uses
  Windows,SysUtils,Forms,ExtCtrls,Types,Math,SharpApi,JvSimpleXML,
  uxTheme;

type
  TDeskAreaManager = class
  private
    FTimer : TTimer;
    FAutoMode : boolean;
    FOffsetList : array of TRect;
    procedure OnTimer(Sender : TObject);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure LoadSettings;
    procedure SetDeskArea;
    procedure SetFullScreenArea;

    procedure Enable;
    procedure Disable;
  published
  end;

implementation

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

// ####################################################################

constructor TDeskAreaManager.Create;
begin
  inherited Create;

  FAutoMode := True;
  setlength(FOffsetList,0);

  FTimer := TTimer.Create(nil);
  FTimer.Interval := 1000;
  FTimer.OnTimer := OnTimer;
  FTimer.Enabled := True;
end;

destructor TDeskAreaManager.Destroy;
begin
  FTimer.Enabled := False;
  FreeAndNil(FTimer);
  SetFullScreenArea;
  setlength(FOffsetList,0);

  inherited Destroy;
end;

procedure TDeskAreaManager.Enable;
begin
  FTimer.Enabled := True;
  SetDeskArea;
end;

procedure TDeskAreaManager.Disable;
begin
  FTimer.Enabled := False;
  SetFullScreenArea;
end;

procedure TDeskAreaManager.OnTimer(Sender : TObject);
begin
  SetDeskArea;
end;

procedure TDeskAreaManager.SetDeskArea;
var
  n,i,k : integer;
  BR : array of TBarRect;
  Area : TRect;
begin
  setlength(BR,0);
  for n := 0 to SharpApi.GetSharpBarCount - 1 do
  begin
    setlength(BR,length(BR)+1);
    BR[High(BR)] := SharpApi.GetSharpBarArea(n);
  end;
  for n := 0 to Screen.MonitorCount - 1 do
  begin
    Area := Screen.Monitors[n].BoundsRect;
    if FAutoMode then
    begin
      for i := 0 to High(BR) do
      begin
        if IsWindowVisible(BR[i].wnd) then
           if PointInRect(Point(BR[i].R.Left + (BR[i].R.Right - BR[i].R.Left) div 2,
                                BR[i].R.Top + (BR[i].R.Bottom - BR[i].R.Top) div 2),
                          Screen.Monitors[n].BoundsRect) then
           begin
             if BR[i].R.Top < Screen.Monitors[n].Top + Screen.Monitors[n].Height div 2 then
                Area.Top := Max(Area.Top,BR[i].R.Bottom)
                else Area.Bottom := Min(Area.Bottom,BR[i].R.Top);
           end;
      end;
    end;

    // apply custom monitor offsets
    //Try
    if n <= High(FOffsetList) then
    begin
      Area.Left   := Area.Left + FOffsetList[n].Left;
      Area.Top    := Area.Top + FOffsetList[n].Top;
      Area.Right  := Area.Right - FOffsetList[n].Right;
      Area.Bottom := Area.Bottom - FOffsetList[n].Bottom;
    end;

    {if not uxTheme.IsThemeActive then
    begin
      Area.Top := Area.Top + 4;
      Area.Bottom := Area.Bottom - 4;
    end; }
   // Except
   // End;

    k := 0;
    if (Area.Left <> Screen.Monitors[n].WorkareaRect.Left) or
       (Area.Right <> Screen.Monitors[n].WorkareaRect.Right) or
       (Area.Top <> Screen.Monitors[n].WorkareaRect.Top) or
       (Area.Bottom <> Screen.Monitors[n].WorkareaRect.Bottom) then
       SystemParametersInfo(SPI_SETWORKAREA, k, @Area, SPIF_SENDWININICHANGE);
  end;
  setlength(BR,0);
end;

procedure TDeskAreaManager.SetFullScreenArea;
var
  n : integer;
  i : cardinal;
  Area : TRect;
  Mon : TMonitor;
begin
  i := 0;
  for n := 0 to Screen.MonitorCount - 1 do
  begin
    Mon := Screen.Monitors[n];
    Area := Rect(Mon.Left,Mon.Top,Mon.Left + Mon.Width, Mon.Top + Mon.Height);
    SystemParametersInfo(SPI_SETWORKAREA, i, @Area, SPIF_SENDWININICHANGE);
  end;
end;

procedure TDeskAreaManager.LoadSettings;
var
  XML : TJvSimpleXML;
  Dir : String;
  n : integer;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\';
  FAutoMode := True;
  setlength(FOffsetList,0);
  if FileExists(Dir + 'DeskArea.xml') then
  begin
    XML := TJvSimpleXML.Create(nil);
    try
      XML.LoadFromFile(Dir + 'DeskArea.xml');
      if XML.Root.Items.ItemNamed['Settings'] <> nil then
         FAutoMode := XML.Root.Items.ItemNamed['Settings'].Items.BoolValue('AutoMode',True);
      if XML.Root.Items.ItemNamed['Offsets'] <> nil then
         with XML.Root.Items.ItemNamed['Offsets'].Items do
         begin
           for n := 0 to Count - 1 do
               with XML.Root.Items.ItemNamed['Offsets'].Items.Item[n].Items do
               begin
                 setlength(FOffsetList,length(FOffsetList)+1);
                 with FOffsetList[High(FOffsetList)] do
                 begin
                   Left   := IntValue('Left',0);
                   Top    := IntValue('Top',0);
                   Right  := IntValue('Right',0);
                   Bottom := IntValue('Bottom',0);
                 end;
               end;
         end;

    finally
      XML.Free;
    end;
  end;
end;



end.
