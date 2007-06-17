{
Source Name: uSharpCoreServiceMan
Description: Service management routines
Copyright (C) Lee Green

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
unit uSharpCoreServiceMan;

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
  StdCtrls,
  extctrls,
  uSharpCorePluginMethods,
  ComCtrls,
  JclGraphics,
  jclFileUtils,
  jvsimplexml,
  SharpAPI,
  uSharpCoreHelperMethods,
  graphicsfx,
  jvGradient,
  uVersInfo,
  JclShell,
  uSharpCoreServiceList;

type

  TServiceManager = class
  private
    FServiceList:TServiceStore;
    procedure ServiceItemMouseDown(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
    procedure ServiceItemStop(Sender: TObject);
    procedure ServiceItemStart(Sender: TObject);
    procedure ServiceItemConfig(Sender: TObject);
    procedure ServiceItemInfo(Sender: TObject);
    function IsServiceFile(filename: string): Boolean;
    procedure AddNewItemCallBack(Sender: TObject);
    procedure UpdateLiveServiceListXml;

  public
    ItemSelectedID: Integer;
    ServiceExt: string;

    constructor Create;
    destructor Destroy; override;
    function Start(servicefilename: string; ConfigureOnly: Boolean): Integer;

    function SendMsg(filename, Msg: string): integer;
    function Unload(filename: string): Integer;

    function Config(filename: string): Integer;
    function Info(filename: string): Integer;
    procedure SetStartupType(filename: string; SType: integer);

    procedure AddServicesToList;
    procedure LoadServices;

    procedure InitialiseServices;
    procedure UpdateServicesView(ScrollBox: TScrollBox);
    procedure UnInitialiseServices;

    property ServiceList:TServiceStore read FServiceList write FServiceList;

  private
  end;

var
  ServiceManager: TServiceManager;

implementation

uses
  uSharpCoreMainWnd,
  uSharpCoreSettings,
  uSharpCoreItemPnl,
  Menus;

var
  FSBPanelArray: array of TServiceMgrItem;
  StartedSection, StoppedSection, DisabledSection: TLabel;
  SideSectionLine: TShape;
  SideSection: TPanel;
  Gradient: TJvGradient;

procedure TServiceManager.AddServicesToList;
var
  VerNum: string;
  Ver: TVersionInfo;
  servicefilename, servicename: string;
  serviceconfig: TServiceSetting;
  NAService: TSharpService;
  ServStatus: TServiceStatus;
  ConfigStatus, InfoStatus: Boolean;
  NewService: TSharpService;
  Files: TStringList;
  i: integer;
  sr: TSearchRec;
begin

  // Free the existing service list and create a new instance
  if assigned(ServiceList) then
    ServiceList.Clear;

  ServiceList := TServiceStore.Create;
  ServiceList.OnAddItem := AddNewItemCallBack;

  ConfigStatus := False;
  InfoStatus := False;

  // Build the Plugin list
  Files := TStringList.Create;
  Try
  SendDebugMessageEx('SharpCore',pchar('SharpCoreServicePath1: ' + IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))),clBlack,DMT_INFO);
  SendDebugMessageEx('SharpCore',pchar('SharpCoreServicePath2: ' + SharpCoreServicePath),clBlack,DMT_INFO);
  SendDebugMessageEx('SharpCore',pchar('ServiceExt: ' + ServiceExt),clBlack,DMT_INFO);
  Files.Clear;
  if FindFirst(SharpCoreServicePath + '*' + ServiceExt,FAAnyFile,sr) = 0 then
  repeat
    Files.Add(sr.Name);
   SendDebugMessageEx('SharpCore',pchar('AddingService: ' + sr.Name),clBlack,DMT_INFO);
  until FindNext(sr) <> 0;
  FindClose(sr);
  SendDebugMessageEx('SharpCore',pchar('ServiceCount: ' + inttostr(Files.Count)),clBlack,DMT_INFO);

   // Move Actions to top of list
  i := Files.IndexOf('Actions' + ServiceExt);
  if i <> -1 then Files.Move(i,0);

  // Move Exec to top of list
  i := Files.IndexOf('Exec' + ServiceExt);
  if i <> -1 then Files.Move(i,0);

  // Move SystemTray to top of list
  i := Files.IndexOf('SystemTray' + ServiceExt);
  if i <> -1 then Files.Move(i,0);

  // Move SkinController to top of list
  i := Files.IndexOf('SkinController' + ServiceExt);
  if i <> -1 then Files.Move(i,0);

  // Move Startup to end of list
  i := Files.IndexOf('Startup' + ServiceExt);
  if i <> -1 then Files.Move(i,Files.Count-1);

  SendDebugMessageEx('SharpCore',pchar('Order: ' + Files.CommaText),clBlack,DMT_INFO);

  for i := 0 to Pred(Files.Count) do begin

    servicefilename := SharpCoreServicePath + Files.Strings[i];
    servicename := ExtractFileName(PathRemoveExtension(servicefilename));

    if IsServiceFile(servicefilename) then begin
      // Get configuration information
      ServiceConfig := TServiceSetting.Create(PathRemoveExtension(Files.Strings[i]));

      // check for config + info
      Newservice := LoadService(pchar(servicefilename));
      try
        if Newservice.dllhandle <> 0 then begin

          if (@NewService.DisplayInfoWnd = nil) then
            InfoStatus := True
          else
            InfoStatus := False;
        end;
      finally
        UnLoadService(@NewService);
      end;

      // Extract Version Information
      ver := TVersionInfo.create(servicefilename);
      try
        VerNum := ver.FileVersion;
      except
        VerNum := '-';
      end;
      ver.Free;

      // Check if the service is disabled
      if serviceconfig.serviceType = stNever then
        ServStatus := ssDisabled
      else
        ServStatus := ssStopped;

      // Add the Service
      ServiceList.Add(i,
        servicename, ServiceConfig.Author,
        ServiceConfig.Description,
        servicefilename, VerNum, ServiceConfig.serviceType, ServStatus, InfoStatus, ConfigStatus,
        ServiceConfig.RunAtStart,
        NAService);

    end;
  end;

  Finally
    Files.Clear;
    Files.free;
  End;

end;

function TServiceManager.Config(filename: string): Integer;
begin
  Result := 0;
end;

constructor TServiceManager.Create;
begin
  ItemSelectedID := -1;
end;

function TServiceManager.Start(servicefilename: string; ConfigureOnly: Boolean):
  Integer;
var
  Newservice: TSharpService;
  i: integer;
begin
  Result := MR_OK;
  Newservice.Dllhandle := 0;
  Newservice := LoadService(pchar(servicefilename));
  if Newservice.dllhandle = 0 then begin
    Result := MR_INCOMPATIBLE;
    exit;
  end;

  for i := 0 to servicelist.Count - 1 do begin
    if lowercase(ServiceList.Info[i].Filename) = lowercase(servicefilename) then begin
      ServiceList.Info[i].DllProcess := Newservice;

      // Configure Only
      if ConfigureOnly then
        Exit;

      // Execute based on type
      if ServiceList.Info[i].SrvType = stOnce then begin
        try
          ServiceList.Info[i].DllProcess.Start(Application.Handle);
          ServiceList.Info[i].Status := ssStarted;

          ServiceManager.UpdateServicesView(SharpCoreMainWnd.sbList);
          SharpCoreMainWnd.sbList.Refresh;

          if ServiceList.Info[i].Status <> ssStopped then begin
            ServiceManager.unload(servicefilename);
            ServiceManager.UpdateServicesView(SharpCoreMainWnd.sbList);
            Result := -1;
            exit;
          end;
        except
          Result := MR_ERRORSTARTING;
        end;
      end
      else if ServiceList.Info[i].SrvType = stAlways then begin
        try
          ServiceList.Info[i].Status := ssStarted;
          ServiceList.Info[i].DllProcess.Start(Application.MainForm.Handle);
        except
          Result := MR_ERRORSTARTING;
          ServiceList.Info[i].Status := ssStopped;
        end;
      end;

      exit;
    end;
  end;
end;

procedure TServiceManager.InitialiseServices;
begin

  DInfo('Initialise Services');

  // Create the Service Folder if it does not exist
  if DirectoryExists(SharpCoreServicePath) = false then begin
    Info('Creating Dir: ' + SharpCoreServicePath);
    CreateDir(SharpCoreServicePath);
  end;

  // Add the Services
  AddServicesToList;

  // Update Services View
  Self.UpdateServicesView(SharpCoreMainWnd.sbList);

end;

function TServiceManager.Unload(filename: string): integer;
var
  i: integer;
begin
  Result := MR_STOPPED;
  DInfo(format('Unload %s', [filename]));
  for i := 0 to Pred(ServiceList.count) do begin
    if lowercase(filename) = lowercase(ServiceList.Info[i].FileName) then begin
      {stop the plugin}

      try
        try
          ServiceList.Info[i].DllProcess.Stop;
        except
        end;

        UnLoadService(@ServiceList.Info[i].DllProcess);
        ServiceList.Info[i].Status := ssStopped;
        Result := MR_STOPPED;
        exit;

      except
        Result := MR_ERRORSTOPPING;
        DError(format('Error Unloading %s', [filename]));
        exit;
      end;
    end;
  end;

end;

procedure TServiceManager.UnInitialiseServices;
var
  i: integer;
begin
  if ServiceList.Count <> 0 then begin
    for i := 0 to Pred(ServiceList.Count) do begin
      if (ServiceList.Info[i].Status = ssStarted) and (lowercase(ServiceList.Info[i].Name) <>
        'shutdown') then
        ServiceManager.Unload(ServiceList.Info[i].FileName);
    end;

    ServiceManager.UpdateServicesView(SharpCoreMainWnd.sbList);
  end;

end;

function TServiceManager.SendMsg(filename, Msg: string): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Pred(ServiceList.count) do begin
    if lowercase(filename) =
      lowercase(ServiceList.Info[i].Name) then begin

      Result := ServiceList.Info[i].DllProcess.SCMsg(msg);
    end;
  end;
end;

procedure TServiceManager.SetStartupType(filename: string; SType: integer);
var
  i: integer;
const
  STRunOnce = 0;
  STRunAlways = 1;
  STDontRun = 2;
begin

  for i := 0 to Pred(ServiceList.count) do begin
    if filename = Servicelist.Info[i].FileName then begin
      case SType of
        STRunOnce: begin
            ServiceList.Info[i].SrvType := stOnce;
            ServiceList.Info[i].RunAtStart := '1';

            if ServiceList.Info[i].Status = ssStarted then
              Unload(ServiceList.info[i].FileName);

            ServiceList.Info[i].Status := ssStopped;
          end;

        STRunAlways: begin
            ServiceList.Info[i].SrvType := stAlways;
            ServiceList.Info[i].RunAtStart := '1';

            if ServiceList.Info[i].Status = ssStarted then
              Unload(ServiceList.info[i].FileName);

            ServiceList.Info[i].Status := ssStopped;
          end;

        STDontRun: begin
            ServiceList.Info[i].SrvType := stNever;
            ServiceList.Info[i].RunAtStart := '0';

            if ServiceList.Info[i].Status = ssStarted then
              Unload(ServiceList.info[i].FileName);

            ServiceList.Info[i].Status := ssDisabled;
          end;
      end;
      ServiceList.SaveSettings(i);
      UpdateServicesView(SharpCoreMainWnd.sbList);
    end;
  end;

  {save}
end;

procedure TServiceManager.UpdateServicesView(ScrollBox: TScrollBox);
var
  itemy: Integer;
  sstatusid: integer;
  sstatus: TServicestatus;
  i: integer;
  DrawnPanel: Boolean;
const
  ItemHeight = 25;
begin

  // Add all to ScrollBox
  if ServiceList.Count > 0 then begin

    SharpCoreMainWnd.sbList.Color := clwhite;

    // First Free all components if assigned
    for i := 0 to high(fsbpanelarray) do begin
      if assigned(FSBPanelArray[i]) then
        FSBPanelArray[i].Free;
    end;
    setlength(FSBPanelArray, ServiceList.Count);

    if Assigned(StartedSection) then
      StartedSection.Hide;
    if Assigned(StoppedSection) then
      StoppedSection.Hide;
    if Assigned(DisabledSection) then
      DisabledSection.Hide;

    sstatusid := 0;
    itemy := 0;

    sstatus := TserviceStatus(sstatusid);
    DrawnPanel := False;

    SharpCoreMainWnd.sbList.DisableAlign;
    repeat
      for i := 0 to Pred(ServiceList.Count) do begin

        if ServiceList.Info[i].Status = sstatus then begin

          // Create the Identifier panel
          if DrawnPanel = False then begin
            // draw panel
            if not (Assigned(SideSection)) then
              SideSection := TPanel.Create(ScrollBox);

            with SideSection do begin
              Parent := ScrollBox;
              Left := 0;
              top := 0;
              Width := 100;
              Height := ScrollBox.Height;
              Color := $00E9E9E9;
              Align := alLeft;
              BevelInner := bvNone;
              BevelOuter := bvNone;
              DoubleBuffered := True;
            end;

            if not (Assigned(SideSectionLine)) then
              SideSectionLine := Tshape.Create(SideSection);
            with SideSectionLine do begin
              parent := SideSection;
              Align := alRight;
              width := 1;
              Pen.Color := $00B8B8B8;

            end;

            if not (Assigned(Gradient)) then
              Gradient := TJvGradient.Create(SideSection);
            with Gradient do begin
              Parent := SideSection;
              Align := alclient;
              Width := 50;
              StartColor := Darker(SideSection.Color, 10);
              EndColor := SideSection.Color;
            end;

            case sstatus of
              ssStarted: begin

                  if not (Assigned(StartedSection)) then
                    StartedSection := Tlabel.Create(SideSection);

                  itemy := itemy + 20;
                  with StartedSection do begin
                    Parent := SideSection;
                    //Bevelouter := bvnone;
                    Top := itemy + 4;
                    Font.Name := 'arial';
                    font.Color := clgray;
                    font.Size := 10;
                    font.Style := [fsbold];
                    Caption := 'Started';
                    Height := 15;
                    Color := $00E9E9E9;
                    //BorderStyle := bsnone;
                    Left := 0;
                    Alignment := taRightJustify;
                    Width := 95;
                    Visible := True;
                    //DoubleBuffered := True;
                    Transparent := True;
                  end;
                  DrawnPanel := True;
                  //itemy := itemy + 15;
                end;
              ssStopped: begin

                  if not (Assigned(StoppedSection)) then
                    StoppedSection := TLabel.Create(StoppedSection);
                  itemy := itemy + 20;
                  with StoppedSection do begin
                    Parent := SideSection;
                    // Bevelouter := bvnone;
                    Top := itemy + 4;
                    Font.Name := 'arial';
                    font.Color := clgray;
                    font.Size := 10;
                    font.Style := [fsbold];
                    Caption := 'Stopped';
                    Height := 15;
                    Color := $00E9E9E9;
                    // BorderStyle := bsnone;
                    Left := 0;
                    Alignment := taRightJustify;
                    Width := 95;
                    Visible := True;
                    // DoubleBuffered := True;
                    Transparent := True;
                  end;
                  DrawnPanel := True;
                  //itemy := itemy + 15;
                end;
              ssDisabled: begin

                  if not (Assigned(DisabledSection)) then
                    DisabledSection := TLabel.Create(SideSection);
                  itemy := itemy + 20;
                  with DisabledSection do begin
                    Parent := SideSection;
                    //Bevelouter := bvnone;
                    Top := itemy + 4;
                    Font.Name := 'Arial';
                    font.Color := clgray;
                    font.Size := 10;
                    font.Style := [fsbold];
                    Caption := 'Disabled';
                    Height := 15;
                    Color := $00E9E9E9;
                    //BorderStyle := bsnone;
                    Left := 0;
                    Alignment := taRightJustify;
                    Width := 95;
                    Visible := True;
                    // DoubleBuffered := True;
                    Transparent := True;
                  end;
                  DrawnPanel := True;
                  //itemy := itemy + 15;
                end;
            end;
          end;

          FSBPanelArray[i] := TServiceMgrItem.Create(ScrollBox);
          with FSBPanelArray[i] do begin
            DoubleBuffered := True;

            OnMouseDown := ServiceItemMouseDown;
            OnStopBtn := ServiceItemStop;
            OnStartBtn := ServiceItemStart;
            OnConfigBtn := ServiceItemConfig;
            OnInfoBtn := ServiceItemInfo;

            SelectedBorderColor := clLtGray;
            SelectedGradientTo := Darker(clWhite, 3);
            SelectedGradientFrom := clwhite;

            tag := i;
            FocusedBorderColor := clLtGray;

            FSBPanelArray[i].HasConfig := False;
            FSBPanelArray[i].HasInfo := True;

            case ServiceList.Info[i].Status of
              ssDisabled: FSBPanelArray[i].Status := stDisabled;
              ssStopped: FSBPanelArray[i].Status := stStopped;
              ssStarted: FSBPanelArray[i].Status := stStarted;
            end;

            Parent := ScrollBox;
            Height := ItemHeight;
            Width := ScrollBox.Width - 109;
            top := itemy;
            Left := 105;

            // Check for Info Wnd
            if ServiceList.Info[i].Status = ssStarted then begin
              if ServiceList.Info[i].InfoDisabled then
                FSBPanelArray[i].HasInfo := False;
            end
            else
              FSBPanelArray[i].HasInfo := False;

            Title :=
              PathRemoveExtension(extractfilename(ServiceList.Info[i].Filename));
            Detail :=
              extractfilename(ServiceList.Info[i].Description);
          end;

          itemy := itemy + ItemHeight + 2;

        end;

      end;

      sstatusid := sstatusid + 1;
      sstatus := tservicestatus(sstatusid);
      DrawnPanel := False;
    until sstatusid = 3;
    SharpCoreMainWnd.sbList.EnableAlign;

  end;

end;

procedure TServiceManager.ServiceItemMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  id: integer;
begin
  id := TServiceMgrItem(sender).Tag;
  ItemSelectedId := id;

  for i := 0 to high(FSBPanelArray) do
    FSBPanelArray[i].Selected := False;
  TServiceMgrItem(Sender).Selected := True;

  if Button = mbRight then begin
    case ServiceList.Info[ItemSelectedID].status of
      ssDisabled: begin
          with SharpCoreMainWnd do begin
            miEnDisService.Caption := 'Enable Service';
            SendCMsg1.Visible := False;

          end;
        end;
      ssStarted: begin
          with SharpCoreMainWnd do begin
            miEnDisService.Caption := 'Disable Service';
            SendCMsg1.Visible := True;
          end;
        end;
      ssStopped: begin
          with SharpCoreMainWnd do begin
            miEnDisService.Caption := 'Disable Service';
            SendCMsg1.Visible := False;
          end;
        end;
    end;

    with SharpCoreMainWnd do begin
      miRunOnce.Checked := False;
      miRunAlways.Checked := False;
      miStartupOpt.Visible := True;

      case ServiceList.Info[ItemSelectedID].SrvType of
        stOnce: miRunOnce.Checked := True;
        stAlways: miRunAlways.Checked := True;
        stNever: miStartupOpt.Visible := False;
      end;
    end;
    SharpCoreMainWnd.mnuServices.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);

  end;
end;

function TServiceManager.IsServiceFile(filename: string): Boolean;
begin
  Result := False;

  if ExtractFileExt(filename) = ServiceExt then
    Result := True;

end;

procedure TServiceManager.LoadServices;
var
  i: integer;
  st: TServiceType;
  fn: string;
begin
  Try
  for i := 0 to Pred(ServiceList.Count) do begin
    with ServiceList, ServiceList.Info[i], ServiceManager do begin
      Application.ProcessMessages;
      st := SrvType;
      fn := FileName;

      if (st = stAlways) or (st = stOnce) then
      begin
        Start(fn, False);

        // Start SharpBar after the Skin Controller
        if Name = 'SkinController' then
        begin
          // SharpBar must be started before the startup components are executed
          ShellExec(hInstance,'open',GetSharpeDirectory+'SharpBar.exe','',GetSharpeDirectory,0);
          sleep(6000);
        end;
      end;
    end;
  end;
  Finally
    UpdateLiveServiceListXml;
  End;
end;

procedure TServiceManager.ServiceItemStop(Sender: TObject);
var
  id: integer;
  sname: string;
begin
  try
    id := TServiceMgrItem(Sender).Tag;
    sname := ServiceList.Info[id].Filename;

    if ServiceManager.Unload(sname) = MR_STOPPED then begin
      TServiceMgrItem(Sender).Status := stStopped;
      ServiceList.Info[id].Status := ssStopped;
    end;

    
    UpdateServicesView(SharpCoreMainWnd.sbList);
  except
    On E: Exception Do Begin
        DERROR('Error while stopping the Service');
        DTRACE(E.Message);
      End;
  end;
end;

procedure TServiceManager.ServiceItemStart(Sender: TObject);
var
  id: integer;
  sname: string;
begin
  try
    id := TServiceMgrItem(Sender).Tag;

    sname := ServiceList.Info[id].Filename;

    if ServiceManager.Start(sname, false) = MR_OK then begin
      TServiceMgrItem(Sender).Status := stStarted;
      ServiceList.Info[id].Status := ssStarted;
    end;

    
    UpdateServicesView(SharpCoreMainWnd.sbList);
  except
    On E: Exception Do Begin
        DERROR('Error while starting the Service');
        DTRACE(E.Message);
      End;
  end;
end;

procedure TServiceManager.ServiceItemConfig(Sender: TObject);
var
  id: integer;
  sname: string;
begin
  id := TServiceMgrItem(Sender).Tag;

  sname := ServiceList.Info[id].Filename;
  UpdateServicesView(SharpCoreMainWnd.sbList);

  try
    ServiceManager.Config(sname);
  except
    On E: Exception Do Begin
        DERROR('Error while opening the Settings Window');
        DTRACE(E.Message);
      End;
  end;
end;

procedure TServiceManager.AddNewItemCallBack(Sender: TObject);
begin
  DTrace(Format('Add Service: %s - %s', [TInfo(Sender).Name,
    TInfo(Sender).FileName]));
  //SharpCoreMainWnd.lblStatus.Caption := Format('Service Count: %d', [ServiceList.Count])
end;

function TServiceManager.Info(filename: string): Integer;
var
  i: integer;
begin
  Result := MR_OK;
  DInfo('TServiceManager.Info');

  for i := 0 to ServiceList.count - 1 do begin
    if filename = servicelist.info[i].filename then begin
      ServiceList.Info[i].DllProcess.DisplayInfoWnd;
    end;
  end;
end;

procedure TServiceManager.ServiceItemInfo(Sender: TObject);
var
  id: integer;
  sname: string;
begin
  id := TServiceMgrItem(Sender).Tag;

  sname := ServiceList.Info[id].Filename;
  
  UpdateServicesView(SharpCoreMainWnd.sbList);
  try
    ServiceManager.Info(sname);
  except
    On E: Exception Do Begin
        DERROR('Error while opening the Information Window');
        DTRACE(E.Message);
      End;
  end;
end;

procedure TServiceManager.UpdateLiveServiceListXml;
var
  Xml:TJvSimpleXml;
  sFn:String;
  i:Integer;

  tmpInfo:TInfo;
begin
  
  Xml := TJvSimpleXML.Create(nil);
  Xml.Root.Name := 'ServiceList';
  Try
    // Delete File First
    sFn := SharpCoreSettingsPath+'ServiceList.xml';
    DeleteFile(sFn);

    For i := 0 to Pred(ServiceList.Count) do begin

      tmpInfo := ServiceList.Info[i];

      xml.root.Items.Add(tmpInfo.Name);
        with xml.Root.Items.ItemNamed[tmpInfo.Name].Properties do begin
          Add('ID', tmpInfo.ID);
        end;
    end;
  Finally
    Xml.SaveToFile(sFn);
    Xml.Free;
  End;
end;

destructor TServiceManager.Destroy;
begin
  ServiceList.Free;
  inherited;
end;

end.

