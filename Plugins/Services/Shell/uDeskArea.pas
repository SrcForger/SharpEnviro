{
Source Name: uDeskArea.pas
Description: DeskArea classes
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

unit uDeskArea;

interface

uses Windows, Messages, Math, Classes, ShellApi, SysUtils,
     UxTheme, JclSimpleXml, JclStrings,
     SharpApi, SharpTypes,
     MonitorList, 
     uTypes, uTray,
     uSystemFuncs;

type
  TDeskAreaManager = class
  private
    FAutoModeList : array of boolean;
    FOffsetList : array of TRect;
    FMonIDList : array of integer;
    FScreenChange : Boolean;

  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure LoadSettings;
    procedure SetDeskArea;
    procedure SetFullScreenArea;

    procedure Enable;
    procedure Disable;

    property ScreenChange : Boolean read FScreenChange write FScreenChange;
  end;

var
  DeskAreaManager : TDeskAreaManager;

implementation

uses uWindows;

function GetBarAutoHide(Index : integer): boolean;
var
  ha : THandleArray;
  Text : String;
  BarID : integer;
  xml : TJclSimpleXml;

  function ExtractBarID(WndName: string): String;
  var
    s: string;
    n: Integer;
  begin
    s := WndName;
    n := JclStrings.StrLastPos('_', s);
    s := Copy(s, n + 1, length(s));
    result := s;
  end;
begin
  Result := False;

  Index := abs(Index);
  ha := FindAllWindows('TSharpBarMainForm');
  if Index <= High(ha) then
  begin
    SetLength(Text, 255);
    SetLength(Text, GetWindowText(ha[Index], PChar(Text), Length(Text)));

    if not TryStrToInt(ExtractBarID(Text), BarID) then
      exit;

    if not FileExists(GetSharpeUserSettingsPath + 'SharpBar\Bars\' + IntToStr(BarID) + '\Bar.xml') then
      exit;

    xml := TJclSimpleXml.Create;
    try
      xml.LoadFromFile(GetSharpeUserSettingsPath + 'SharpBar\Bars\' + IntToStr(BarID) + '\Bar.xml');
      if xml.Root.Items.ItemNamed['Settings'] <> nil then
        with xml.Root.Items.ItemNamed['Settings'].Items do
        begin
          Result := BoolValue('AutoHide', False);
        end;
    finally
      xml.Free;
    end;
  end;
  setlength(ha,0);
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

{ TDeskAreaManager }

constructor TDeskAreaManager.Create;
begin
  inherited Create;

  setlength(FAutoModeList,0);
  setlength(FOffsetList,0);
  setlength(FMonIDList,0);

  FScreenChange := False;
end;

destructor TDeskAreaManager.Destroy;
begin
  SetFullScreenArea;
  setlength(FOffsetList,0);
  setlength(FAutoModeList,0);
  setlength(FMonIDList,0);

  inherited Destroy;
end;

procedure TDeskAreaManager.Enable;
begin
  SetTimer(WindowsClass.DeskAreaTimerWnd,1,3000,nil);
  SetDeskArea;
end;

procedure TDeskAreaManager.Disable;
begin
  KillTimer(WindowsClass.DeskAreaTimerWnd,1);
  SetFullScreenArea;
end;

procedure TDeskAreaManager.SetDeskArea;
var
  n,i : integer;
  BR : array of TBarRect;
  Area : TRect;
  am : boolean;
  MonID : integer;
  Index : integer;
  ABItem : TAppBarItem;
  MonCount : integer;
  b : boolean;
begin
  setlength(BR,0);
  for n := 0 to SharpApi.GetSharpBarCount - 1 do
  begin
    setlength(BR,length(BR)+1);
    BR[High(BR)] := SharpApi.GetSharpBarArea(n);
  end;

  MonCount := MonList.MonitorCount;

  for n := 0 to MonCount - 1 do
  begin
    if MonList.Monitors[n] = MonList.PrimaryMonitor then
      MonID := -100
    else MonID := MonList.Monitors[n].MonitorNum;

    Index := -1;
    for i := 0 to High(FMonIDList) do
      if FMonIDList[i] = MonID then
      begin
        Index := i;
        break;
      end;

    Area := MonList.Monitors[n].BoundsRect;

    if Index <> -1 then
      am := FAutoModeList[Index]
      else am := True;
    if am then
    begin
      for i := 0 to High(BR) do
      begin
        b := GetBarAutoHide(i);
        if (IsWindowVisible(BR[i].wnd))
          and (not b) then
           if PointInRect(Point(BR[i].R.Left + (BR[i].R.Right - BR[i].R.Left) div 2,
                                BR[i].R.Top + (BR[i].R.Bottom - BR[i].R.Top) div 2),
                          MonList.Monitors[n].BoundsRect) then
           begin
             if BR[i].R.Top < MonList.Monitors[n].Top + MonList.Monitors[n].Height div 2 then
                Area.Top := Max(Area.Top,BR[i].R.Bottom)
                else Area.Bottom := Min(Area.Bottom,BR[i].R.Top);
           end;
      end;
    end;

    // apply custom monitor offsets
    if Index <> -1 then
    begin
      Area.Left   := Area.Left + FOffsetList[Index].Left;
      Area.Top    := Area.Top + FOffsetList[Index].Top;
      Area.Right  := Area.Right - FOffsetList[Index].Right;
      Area.Bottom := Area.Bottom - FOffsetList[Index].Bottom;
    end;

    // apply app bars
    if TrayManager <> nil then
      for i := 0 to TrayManager.AppBarList.Count - 1 do
      begin
        ABItem := TAppBarItem(TrayManager.AppBarList.Items[i]);
        if not ABItem.AutoHideBar then
          if PointInRect(Point(ABItem.Data.abd.rc.Left + (ABItem.Data.abd.rc.Right - ABItem.Data.abd.rc.Left) div 2,
                               ABItem.Data.abd.rc.Top + (ABItem.Data.abd.rc.Bottom - ABItem.Data.abd.rc.Top) div 2),
                         MonList.Monitors[n].BoundsRect) then
          begin
            if ((ABItem.Data.abd.uEdge = ABE_RIGHT) and (Area.Right > ABItem.Data.abd.rc.Left)) then
              Area.Right := ABItem.Data.abd.rc.Left
            else if ((ABItem.Data.abd.uEdge = ABE_LEFT) and (Area.Left < ABItem.Data.abd.rc.Right) and (Area.Right > ABItem.Data.abd.rc.Left)) then
              Area.Left := ABItem.Data.abd.rc.Right
          end;
      end;

    if ((Win32MajorVersion = 5) and (Win32MinorVersion >= 1)) or (Win32MajorVersion = 6) then
    begin
      if not uxTheme.IsThemeActive then
      begin
        Area.Top := Area.Top + 4;
        Area.Bottom := Area.Bottom - 4;
      end;
    end;

    if not EqualRect(Area, MonList.Monitors[n].WorkareaRect) then
    begin
      SharpApi.SendDebugMessage('Shell', Format('Setting workarea to: Left %d, Right %d Top %d, Bottom %d, ', [Area.Left, Area.Right, Area.Top, Area.Bottom]), 0);

      SystemParametersInfo(SPI_SETWORKAREA, 1, @Area, SPIF_SENDWININICHANGE);
      SystemParametersInfo(SPI_SETWORKAREA, 1, @Area, SPIF_SENDWININICHANGE);
    end
  end;
  setlength(BR,0);
end;

procedure TDeskAreaManager.SetFullScreenArea;
var
  n : integer;
  i : cardinal;
  Area : TRect;
  Mon : TMonitorItem;
  r: Cardinal;
begin
  i := 0;
  try
    for n := 0 to MonList.MonitorCount - 1 do
    begin
      Mon := MonList.Monitors[n];
      Area := Rect(Mon.Left,Mon.Top,Mon.Left + Mon.Width, Mon.Top + Mon.Height);
      SystemParametersInfo(SPI_SETWORKAREA, i, @Area, SPIF_UPDATEINIFILE);
      SendMessageTimeOut(HWND_BROADCAST, WM_SETTINGCHANGE, SPI_SETWORKAREA, 0,SMTO_ABORTIFHUNG,20,r);
    end;
  except
    exit;
  end;
end;

procedure TDeskAreaManager.LoadSettings;
var
  XML : TJclSimpleXML;
  Dir : String;
  n : integer;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\DeskArea\';
  setlength(FOffsetList,0);
  setlength(FAutoModeList,0);
  setlength(FMonIDList,0);
  if FileExists(Dir + 'DeskArea.xml') then
  begin
    XML := TJclSimpleXML.Create;
    try
      XML.LoadFromFile(Dir + 'DeskArea.xml');
      if XML.Root.Items.ItemNamed['Monitors'] <> nil then
         with XML.Root.Items.ItemNamed['Monitors'].Items do
         begin
           for n := 0 to Count - 1 do
               with XML.Root.Items.ItemNamed['Monitors'].Items.Item[n].Items do
               begin
                 setlength(FMonIDList,length(FMonIDList)+1);
                 FMonIDList[High(FMonIDList)] := IntValue('ID',-1);
                 setlength(FAutoModeList,length(FAutoModeList)+1);
                 FAutoModeList[High(FAutoModeList)] := BoolValue('AutoMode',True);
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
