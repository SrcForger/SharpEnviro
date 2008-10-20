{
Source Name: MainWnd.pas
Description: Button Module - Main Window
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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Math, GR32, ToolTipApi, ShellApi, CommCtrl,
  JclSimpleXML,
  SharpCenterApi,
  SharpApi,
  uSharpBarAPI,
  SharpEBaseControls,
  SharpEButton,
  uISharpBarModule,
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
    sWidth       : integer;
    sShowLabel   : boolean;
    FButtonSpacing : integer;
    sShowIcon    : boolean;
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
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : Boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure RefreshIcons;
    procedure SaveSettings;
  end;


implementation

{$R *.dfm}

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
  sb_config.Left := -200;  
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
  with FButtonList[Index] do
  begin
    btn := TSharpEButton.Create(self);
    btn.PopUpMenu := ButtonPopup;
    btn.Visible := False;
    btn.AutoPosition := True;
    btn.AutoSize := True;
    btn.Hint := pTarget;
    btn.Width := sWidth;
    btn.Parent := self;
    btn.left := FButtonSpacing + High(FButtonList)*FButtonSpacing + High(FButtonList)*sWidth;
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
      if not IconStringToIcon(pIcon,pTarget,btn.Glyph32) then
         btn.Glyph32.SetSize(0,0)
    end else btn.Glyph32.SetSize(0,0);
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
        if not IconStringToIcon(Icon,Target,btn.Glyph32) then
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
    Add('Width',sWidth);
    Add('ShowLabel',sShowLabel);
    Add('ShowIcon',sShowIcon);
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
  XML.SaveToFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
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
begin
  for n := 0 to High(FButtonList) do
      with FButtonList[n] do
      begin
        btn.Width := sWidth;
        btn.Left := FButtonSpacing + n*FButtonSpacing + n*sWidth;
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
  fileloaded : boolean;
  n : integer;
begin
  ClearButtons;

  sWidth       := 25;
  sShowLabel   := False;
  sShowIcon    := True;
  FButtonSpacing := 2;

  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      sWidth       := IntValue('Width',25);
      sShowLabel   := BoolValue('ShowLabel',False);
      sShowIcon    := BoolValue('ShowIcon',sShowIcon);
      if ItemNamed['Buttons'] <> nil then
      with ItemNamed['Buttons'].Items do
           for n := 0 to Count - 1 do
               AddButton(Item[n].Items.Value('Target','C:\'),
                         Item[n].Items.Value('Icon','shell:icon'),
                         Item[n].Items.Value('Caption','C:\'));
    end;
  XML.Free;
end;

procedure TMainForm.UpdateSize;
begin
  UpdateButtons;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean = True);
var
  newWidth : integer;
begin
  self.Caption := 'ButtonBar (' + inttostr(length(FButtonList)) + ')';
  if sWidth<20 then sWidth := 20;

  sb_config.Visible := (length(FButtonList) = 0);
  if sb_config.Visible then
  begin
    sb_config.Left := 2;
    newWidth := sb_config.Left + sb_config.Width + 2
  end
  else newWidth := FButtonSpacing + High(FButtonList)*FButtonSpacing + length(FButtonList)*sWidth + FButtonSpacing;

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateButtons;
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

end.
