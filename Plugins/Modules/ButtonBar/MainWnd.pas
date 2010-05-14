{
Source Name: MainWnd.pas
Description: Button Module - Main Window
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Math, GR32, ToolTipApi, ShellApi, CommCtrl,
  JclSimpleXML,
  JclSysInfo,
  SharpCenterApi,
  SharpApi,
  SharpEBaseControls,
  SharpEButton,
  SharpFileUtils,
  uISharpBarModule,
  uVistaFuncs,
  uKnownFolders,
  SharpIconUtils, ImgList, PngImageList;


type
  TButtonRecord = record
                    btn: TSharpEButton;
                    target: String;
                    icon: String;
                    caption: String;
                  end;

  TMainForm = class(TForm)
    sb_config: TSharpEButton;
    ButtonPopup: TPopupMenu;
    Delete1: TMenuItem;
    PngImageList1: TPngImageList;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);       
    procedure btnMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);         
    procedure sb_configClick(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    sShowLabel   : boolean;
    FButtonSpacing : integer;
    sShowIcon    : boolean;
    sFirstLaunch : boolean;
    FButtonList  : array of TButtonRecord;
    FHintWnd     : hwnd; 
    movebutton   : TSharpEButton;
    hasmoved     : boolean;
    procedure ClearButtons;
    procedure AddButton(pTarget,pIcon,pCaption : String; Index : integer = -1);
    procedure UpdateButtons;
    procedure WMNotify(var msg : TWMNotify); message WM_NOTIFY;
    procedure WMDropFiles(var msg: TMessage); message WM_DROPFILES;    
  public
    mInterface : ISharpBarModule;
    procedure LoadIcons;
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : Boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure RefreshIcons;
    procedure SaveSettings;
    function ImportQuickLaunchItems : boolean;
  end;


implementation

uses
  GR32_PNG,
  uSharpXMLUtils;

{$R *.dfm}
{$R glyphs.res}

procedure TMainForm.LoadIcons;
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
  ResIDSuffix : String;
begin
  if mInterface = nil then
    exit;
  if mInterface.SkinInterface = nil then
    exit;

  TempBmp := TBitmap32.Create;
  if mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y <= 16 then
  begin
    TempBmp.SetSize(16,16);
    ResIDSuffix := '16';
  end else
  begin
    TempBmp.SetSize(32,32);
    ResIDSuffix := '32';
  end;

  TempBmp.Clear(color32(0,0,0,0));
  try
    ResStream := TResourceStream.Create(HInstance, 'listadd'+ResIDSuffix, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      sb_config.Glyph32.Assign(TempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  TempBmp.Free;

  sb_config.Glyph32.DrawMode := dmBlend;
  sb_config.Glyph32.CombineMode := cmMerge;
  sb_config.Glyph32.DrawMode := dmBlend;
  sb_config.Glyph32.CombineMode := cmMerge;
end;

procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := params.ExStyle or WS_EX_ACCEPTFILES;
end;

procedure TMainForm.Delete1Click(Sender: TObject);
var
  dbtn : TSharpEButton;
  n : integer;
  startindex : integer;
  dbtnwidth : integer;
  p : TPoint;
begin
  p := ScreenToClient(ButtonPopup.PopupPoint);
  dbtn := nil;
  startindex := -1;
  for n := 0 to High(FButtonList) do
    if (p.x > FButtonList[n].btn.Left)
      and (p.x < FButtonList[n].btn.Left + FButtonList[n].btn.Width) then
    begin
      dbtn := FButtonList[n].btn;
      startindex := n;
      break;
    end;

  if dbtn = nil then
    exit;
  
  ToolTipApi.DeleteToolTip(FHintWnd,self,startindex);
  dbtnwidth := FButtonList[startindex].btn.Width + FButtonSpacing;
  FButtonList[startindex].btn.Free;
  for n := startindex to High(FButtonList)-1 do
  begin
    ToolTipApi.DeleteToolTip(FHintWnd,self,n+1);
    with FButtonList[n] do
    begin
      btn := FButtonList[n+1].btn;
      btn.Left := FButtonList[n].btn.Left - dbtnwidth;
      target := FButtonList[n+1].target;
      caption := FButtonList[n+1].caption;
      icon := FButtonList[n+1].icon;
      ToolTipApi.AddToolTip(FHintWnd,self,n,
                            Rect(btn.left,btn.top,btn.Left + btn.Width,btn.Top + btn.Height),
                            Caption);        
    end;
  end;
  setlength(FButtonList,length(FButtonList)-1);
  SaveSettings;
  RealignComponents(True);  
end;

procedure TMainForm.WMNotify(var msg: TWMNotify);
begin
  if Msg.NMHdr.code = TTN_SHOW then
  begin
    SetWindowPos(Msg.NMHdr.hwndFrom, HWND_TOPMOST, 0, 0, 0, 0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    Msg.result := 1;
    exit;
  end else Msg.result := 0;
end;

procedure TMainForm.WMDropFiles(var msg: TMessage);
var
  pcFileName: PChar;
  i, iSize, iFileCount: integer;
  p : TPoint;
  n : integer;
  index : integer;
begin
  index := High(FButtonList) + 1;
  p := ScreenToClient(Mouse.CursorPos);
  for n := 0 to High(FButtonList) do
   if p.x < FButtonList[n].btn.Left then
   begin
     index := n - 1;
     break;
   end;

  pcFileName := '';
  iFileCount := DragQueryFile(Msg.wParam, $FFFFFFFF, pcFileName, 255);
  for i := 0 to iFileCount - 1 do
  begin
     iSize := DragQueryFile(Msg.wParam, i, nil, 0) + 1;
     pcFileName := StrAlloc(iSize);
     DragQueryFile(Msg.wParam, i, pcFileName, iSize);
     AddButton(pcFileName,'shell:icon',ExtractFileName(pcFileName),index);
     StrDispose(pcFileName);
  end;
  DragFinish(Msg.wParam);
  sb_config.Visible := False;  
  UpdateButtons;
  SaveSettings;
  RealignComponents(True);
end;

procedure TMainForm.ClearButtons;
var
  n : integer;
begin
  MoveButton := nil;
  for n := 0 to High(FButtonList) do
  begin
    FButtonList[n].btn.Free;
    ToolTipApi.DeleteToolTip(FHintWnd,self,n);
  end;
  setlength(FButtonList,0);
end;

procedure TMainForm.AddButton(pTarget,pIcon,pCaption : String; Index : integer = -1);
var
  n : integer;
  btnLeft : Integer;
begin
  setlength(FButtonList,length(FButtonList)+1);
  if (Index < Low(FButtonList)) or (Index > High(FButtonList)) then
    Index := High(FButtonList)
    else for n := High(FButtonList) downto Index + 1 do
      begin
        ToolTipApi.DeleteToolTip(FHintWnd,self,n-1);
        with FButtonList[n] do
        begin
          btn := FButtonList[n-1].btn;
          target := FButtonList[n-1].target;
          caption := FButtonList[n-1].caption;
          icon := FButtonList[n-1].icon;
          ToolTipApi.AddToolTip(FHintWnd,self,n,
                                Rect(btn.left,btn.top,btn.Left + btn.Width,btn.Top + btn.Height),
                                Caption);
        end;
      end;

  btnLeft := FButtonSpacing;
  if Index > 0 then
    // If this is not the 1st button added then align the new button
    // to the right side of the previous button with some spacing.
    btnLeft := FButtonList[Index - 1].btn.Left + FButtonList[Index - 1].btn.Width + FButtonSpacing;

  with FButtonList[Index] do
  begin
    btn := TSharpEButton.Create(self);
    btn.PopUpMenu := ButtonPopup;
    btn.Visible := False;
    btn.AutoPosition := True;
    btn.AutoSize := True;
    btn.Hint := pTarget;
    btn.Parent := self;
    btn.Left := btnLeft;
    btn.OnMouseUp := btnMouseUp;
    btn.OnMouseDown := btnMouseDown;
    btn.OnMouseMove := btnMouseMove;
    btn.SkinManager := mInterface.SkinInterface.SkinManager;
    ToolTipApi.AddToolTip(FHintWnd,self,High(FButtonList),
                          Rect(btn.left,btn.top,btn.Left + btn.Width,btn.Top + btn.Height),
                          pCaption);

    caption := pCaption;
    target := pTarget;
    icon := pIcon;

    if sShowLabel then
      btn.Caption := pCaption
    else
      btn.Caption := '';

    if sShowIcon then
    begin
      if not IconStringToIcon(pIcon,pTarget,btn.Glyph32,32) then
         btn.Glyph32.SetSize(0,0)
    end else btn.Glyph32.SetSize(0,0);

    btn.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;
    
    if sShowIcon and sShowLabel then
      btn.Width := btn.Width + btn.GetIconWidth + btn.GetTextWidth
    else if sShowIcon then
      btn.Width := btn.Width + btn.GetIconWidth
    else if sShowLabel then
      btn.Width := btn.Width + btn.GetTextWidth;

    if btn.Width < Height then
      btn.Width := Height;
  end;
end;

procedure TMainForm.RefreshIcons;
var
  n : integer;
begin
  if not sShowIcon then exit;

  for n := 0 to High(FButtonList) do
      with FButtonList[n] do
      begin
        if not IconStringToIcon(Icon,Target,btn.Glyph32,32) then
          btn.Glyph32.SetSize(0,0);
        btn.Repaint;
      end;
end;

procedure TMainForm.SaveSettings;
var
  XML : TJclSimpleXML;
  n : integer;
begin
  XML := TJclSimpleXMl.Create;
  XML.Root.Name := 'ButtonBarModuleSettings';
  with XML.Root.Items do
  begin
    Add('ShowCaption',sShowLabel);
    Add('ShowIcon',sShowIcon);
    Add('FirstLaunch',sFirstLaunch);
    with Add('Buttons').Items do
    begin
      for n := 0 to High(FButtonList) do
        with FButtonList[n] do
          with Add('item').Items do
          begin
            Add('Target',Target);
            Add('Icon',Icon);
            Add('Caption',Caption);
          end;
    end;
  end;
  if not SaveXMLToSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    SharpApi.SendDebugMessageEx('ButtonBar',PChar('Failed to save settings to File: ' + mInterface.BarInterface.GetModuleXMLFile(mInterface.ID)),clred,DMT_ERROR);
  XML.Free;
end;

procedure TMainForm.sb_configClick(Sender: TObject);
var
  cfile : String;
begin
  cfile := SharpApi.GetCenterDirectory + '_Modules\ButtonBar.con';

  if FileExists(cfile) then
    SharpCenterApi.CenterCommand(sccLoadSetting,
      PChar(cfile),
      PChar(inttostr(mInterface.BarInterface.BarID) + ':' + inttostr(mInterface.ID)));
end;

procedure TMainForm.UpdateButtons;
var
  n : integer;
  btnLeft : Integer;
begin
  if sb_config.Visible then
  begin
    sb_config.SkinManager := mInterface.SkinInterface.SkinManager;
    sb_config.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod +
      sb_config.GetIconWidth + sb_config.GetTextWidth;
  end;
  
  btnLeft := FButtonSpacing;
  for n := 0 to High(FButtonList) do
      with FButtonList[n] do
      begin
        btn.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;

        if sShowIcon and sShowLabel then
          btn.Width := btn.Width + btn.GetIconWidth + btn.GetTextWidth
        else if sShowIcon then
          btn.Width := btn.Width + btn.GetIconWidth
        else if sShowLabel then
          btn.Width := btn.Width + btn.GetTextWidth;

        if btn.Width < Height then
          btn.Width := Height;
          
        if n > 0 then
          // If this is not the 1st button then align the button
          // to the right side of the previous button with some spacing.
          btnLeft := FButtonList[n - 1].btn.Left + FButtonList[n - 1].btn.Width + FButtonSpacing;
             
        btn.Left := btnLeft;
        if btn.Left + btn.Width < Width then
           btn.Visible := True
           else btn.Visible := False;
        ToolTipApi.UpdateToolTipRect(FHintWnd,self,n,
                                     Rect(btn.left,btn.top,btn.Left + btn.Width,btn.Top + btn.Height));
      end;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  n : integer;
begin
  ClearButtons;

  sShowLabel   := False;
  sShowIcon    := True;
  sFirstLaunch := True;
  FButtonSpacing := 2;

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    with xml.Root.Items do
    begin
      sShowLabel   := BoolValue('ShowCaption',False);
      sShowIcon    := BoolValue('ShowIcon',sShowIcon);
      sFirstLaunch := BoolValue('FirstLaunch',sFirstLaunch);
      if ItemNamed['Buttons'] <> nil then
      with ItemNamed['Buttons'].Items do
           for n := 0 to Count - 1 do
               AddButton(Item[n].Items.Value('Target','C:\'),
                         Item[n].Items.Value('Icon','shell:icon'),
                         Item[n].Items.Value('Caption','C:\'));
    end;
  XML.Free;

  if sFirstLaunch then
  begin
    ImportQuickLaunchItems;
    sFirstLaunch := False;
    SaveSettings;
    RealignComponents(True);
  end;
end;

procedure TMainForm.UpdateSize;
begin
  LoadIcons;
  UpdateButtons;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean = True);
var
  newWidth : integer;
begin
  self.Caption := 'ButtonBar (' + inttostr(length(FButtonList)) + ')';

  sb_config.Visible := (length(FButtonList) = 0);
  if sb_config.Visible then
  begin
    sb_config.SkinManager := mInterface.SkinInterface.SkinManager;
    sb_config.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod +
      sb_config.GetIconWidth + sb_config.GetTextWidth;
    newWidth := FButtonSpacing + sb_config.Left + sb_config.Width + FButtonSpacing;
  end
  else
    newWidth := FButtonSpacing + FButtonList[High(FButtonList)].btn.Left + FButtonList[High(FButtonList)].btn.Width + FButtonSpacing;

  mInterface.MinSize := newWidth;
  mInterface.MaxSize := newWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize;
end;

procedure TMainForm.UpdateComponentSkins;
var
  n : integer;
begin
  sb_config.SkinManager := mInterface.SkinInterface.SkinManager;
  for n := 0 to High(FButtonList) do
    FButtonList[n].btn.SkinManager := mInterface.SkinInterface.SkinManager;
end;


procedure TMainForm.btnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MoveButton := TSharpEButton(Sender);
  hasmoved := False;
end;

procedure TMainForm.btnMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  cButton : TSharpEButton;
  cButtonIndex : integer;
  p : TPoint;
  n : integer;
  cPos : integer;
  temp : TButtonRecord;
  MoveButtonIndex : integer;
begin
  if MoveButton = nil then
    exit;

  cButton := nil;
  cButtonIndex := -1;
  p := ScreenToClient(Mouse.CursorPos);
  for n := 0 to High(FButtonList) do
    if (p.x > FButtonList[n].btn.Left)
      and (p.x < FButtonList[n].btn.Left + FButtonList[n].btn.Width) then
    begin
      cButton := FButtonList[n].btn;
      cButtonIndex := n;
      break;
    end;

  if cButton = nil then
    exit;

  if cButton <> MoveButton then
  begin
    MoveButtonIndex := -1;
    for n := 0 to High(FButtonList) do
      if MoveButton = FButtonList[n].btn then
      begin
        MoveButtonIndex := n;
        break;
      end;
    if MoveButtonIndex <> -1 then
    begin
      hasmoved := True;               
      cPos := FButtonList[cButtonIndex].btn.left;
      temp := FButtonList[cButtonIndex];
      temp.btn.Left := FButtonList[MoveButtonIndex].btn.Left;
      FButtonList[MoveButtonIndex].btn.Left := CPos;
      FButtonList[cButtonIndex] := FButtonList[MoveButtonIndex];
      FButtonList[MoveButtonIndex] := temp;
      ToolTipApi.DeleteToolTip(FHintWnd,self,MoveButtonIndex);
      ToolTipApi.DeleteToolTip(FHintWnd,self,cButtonIndex);
      ToolTipApi.AddToolTip(FHintWnd,self,MoveButtonIndex,
                            Rect(cButton.left,cButton.top,cButton.Left + cButton.Width,cButton.Top + cButton.Height),
                            FButtonList[MoveButtonIndex].caption);
      ToolTipApi.AddToolTip(FHintWnd,self,cButtonIndex,
                            Rect(MoveButton.left,MoveButton.top,MoveButton.Left + MoveButton.Width,MoveButton.Top + MoveButton.Height),
                            FButtonList[cButtonIndex].caption);
    end;
  end;
end;

procedure TMainForm.btnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ActionStr : String;
begin
  MoveButton := nil;
  if (Button = mbLeft) and (not hasmoved) then
  begin
    ActionStr := TSharpEButton(Sender).Hint;
    if UPPERCASE(ActionStr) = '!SHOWMENU' then SetForegroundWindow(FindWindow(nil,'SharpMenuWMForm'));
    SharpApi.SharpExecute(ActionStr);
  end;
  if hasmoved then
    SaveSettings;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  MoveButton := nil;
  DoubleBuffered := True;
  FHintWnd := ToolTipApi.RegisterToolTip(self);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if FHintWnd <> 0 then
     DestroyWindow(FHintWnd);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  if mInterface <> nil then
     mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

function TMainForm.ImportQuickLaunchItems : boolean;
var
  Dir : String;
  SList : TStringList;
  n,i : integer;
  found : boolean;
  caption : String;
  addcount : integer;
begin
  {$WARNINGS OFF}
  if IsWindows7 or IsWindowsVista then
  begin
    Dir := uKnownFolders.GetKnownFolderPath(FOLDERID_Quicklaunch);
    Dir := IncludeTrailingBackSlash(Dir);
  end
  else begin
    Dir := JclSysInfo.GetAppdataFolder;
    Dir := IncludeTrailingBackSlash(Dir);
    Dir := Dir + 'Microsoft\Internet Explorer\Quick Launch\';
  end;
  {$WARNINGS ON}
  SList := TStringList.Create;
  SList.Clear;
  GetExecuteableFilesFromDir(SList,Dir);
  addcount := 0;
  for n := 0 to SList.Count - 1 do
  begin
    found := False;
    for i := 0 to High(FButtonList) do // Check if it already is added
      if CompareText(FButtonList[i].target,SList[n]) = 0 then
      begin
        found := True;
        break;
      end;
    if not found then // Add It
    begin
      caption := ExtractFileName(SList[n]);
      setlength(caption,length(caption) - length(ExtractFileExt(caption))); // remove file extension from filename
      AddButton(SList[n],'shell:icon',caption);
      addcount := addcount + 1;
    end;
  end;
  SList.Free;
  result := (addcount > 0);
end;


end.
