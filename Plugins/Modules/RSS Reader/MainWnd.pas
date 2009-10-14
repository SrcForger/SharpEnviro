{
Source Name: MainWnd
Description: RSS Reader Monitor module main window
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
  Windows, SysUtils, Classes, Controls, Forms, Contnrs,
  Dialogs, StdCtrls, SharpEBaseControls, GR32_Resamplers, SharpNotify,
  ExtCtrls, GR32, uISharpBarModule, SharpTypes, ISharpESkinComponents,
  JclStrings, JclSimpleXML, SharpApi, Menus, Math, SharpESkinLabel,
  uImageDownloadThread, SharpImageUtils, JclStreams, SharpEButton;


type

  TMainForm = class(TForm)
    UpdateTimer: TTimer;
    lb_bottom: TSharpESkinLabel;
    lb_top: TSharpESkinLabel;
    SwitchTimer: TTimer;
    ClosePopupTimer: TTimer;
    PopupTimer: TTimer;
    btnRight: TSharpEButton;
    btnLeft: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure SwitchTimerTimer(Sender: TObject);
    procedure ClosePopupTimerTimer(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure PopupTimerTimer(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure lb_topDblClick(Sender: TObject);
    procedure lb_bottomDblClick(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  protected
  private
    sShowNotification : boolean;  
    sShowIcon    : boolean;
    sURL         : String;
    sFeedUpdate  : integer;
    sSwitchTime  : integer;
    sShowButtons : boolean;
    FFeed        : TJclSimpleXML;
    FFeedValid   : boolean;
    FIcon        : TBitmap32;
    FFeedIndex   : integer;
    FFeedChannel : integer;
    FFeedURL     : String;
    FFeedDesc    : String;
    FFeedImage   : String;
    FErrorMsg    : String;
    FImageList   : TObjectList;
    notifyItem   : TNotifyItem;    
    function FindImage(pUrl : String) : TBitmap32;
  public
    mInterface : ISharpBarModule;
    procedure UpdateDisplay;
    procedure SyncImagesWithFeed;
    procedure ShowDescriptionNotification;
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure RenderIcon(pRepaint : boolean = True);
    procedure LoadIcons;
  end;


implementation

uses GR32_PNG, IdHTTP;

{$R *.dfm}
{$R rssglyphs.res}

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
    ResStream := TResourceStream.Create(HInstance, 'feed'+ResIDSuffix, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FIcon.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  TempBmp.Free;

  FIcon.DrawMode := dmBlend;
  FIcon.CombineMode := cmMerge;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
begin
  sURL := 'http://www.n-tv.de/rss';
  sShowNotification := True;
  sShowIcon := True;
  sSwitchTime := 20000;
  sFeedUpdate := 900000;
  sShowButtons := True;

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
      sShowIcon := BoolValue('showicon',sShowIcon);
      sURL      := Value('url',sURL);
      sShowNotification := BoolValue('shownotification',sShowNotification);
      sSwitchTime := IntValue('switchtime',sSwitchTime);
      sFeedUpdate := IntValue('feedupdate',sFeedUpdate);
      sShowButtons := BoolValue('showbuttons',sShowButtons);
    end;
  XML.Free;
  if sFeedUpdate < 60000 then
    sFeedUpdate := 60000;
  UpdateTimer.Interval := sFeedUpdate;
  SwitchTimer.Interval := sSwitchTime;
  if UpdateTimer.Enabled then
    UpdateTimer.OnTimer(UpdateTimer);
end;

procedure TMainForm.PopupTimerTimer(Sender: TObject);
var
  cursorPos : TPoint;
  clientPos : TPoint;
begin
  PopupTimer.Enabled := False;

  if GetCursorPosSecure(cursorPos) then
    clientPos := ScreenToClient(cursorPos)
  else Exit;

  if not PtInRect(Rect(0,0,Width,Height), clientPos) then
    exit;

  ShowDescriptionNotification;
end;

procedure TMainForm.UpdateComponentSkins;
begin
  lb_top.SkinManager := mInterface.SkinInterface.SkinManager;
  lb_bottom.SkinManager := mInterface.SkinInterface.SkinManager;
  btnRight.SkinManager := mInterface.SkinInterface.SkinManager;
  btnLeft.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure CutString(Src : String; out top : String; out bottom : String);
var
  n,l,center : integer;
  ileft : integer;
  SList : TStringList;
begin
  l := length(Src);
  if l < 20 then
  begin
    top := Src;
    bottom := '';
    exit;
  end;

  center := l div 2;
  SList := TStringList.Create;
  SList.Clear;
  StrTokens(Src,SList);
  ileft := 0;
  for n := 0 to SList.Count - 1 do
  begin
    if ileft + length(SList[n]) div 2 < center then
      ileft := ileft + length(SList[n]) + 1
    else break;
  end;
  top := Trim(Src);
  SetLength(top,ileft);
  bottom := Trim(Copy(Src,ileft+1,l-ileft+1));
  SList.Free;
end;

procedure TMainForm.UpdateDisplay;
var
  n,i : integer;
  channelcount,itemcount : integer;
  channel : integer;
  s,top,bottom : String;
  image : String;
  hasEnclosure : Boolean;
  hasMediaThumbnail : Boolean;
  hasMediaContent : Boolean;
begin
  SwitchTimer.Enabled := False;
  SwitchTimer.Enabled := True;

  if FFeedValid then
  with FFeed.Root.Items do
  begin
    // count all channels and select which channel to read
    channelcount := 0;
    for n := 0 to Count - 1 do
      if CompareText(Item[n].Name,'channel') = 0 then
        channelcount := channelcount + 1;
    if FFeedChannel >= channelcount then
      channel := 0
    else channel := FFeedChannel;

    channelcount := 0;
    for n := 0 to Count - 1 do
      if CompareText(Item[n].Name,'channel') = 0 then
      begin
        // this is the channel we are going to use
        if channelcount = channel then
        with Item[n].Items do
        begin
          // count all items and select which to display
          itemcount := 0;
          for i := 0 to Count - 1 do
            if CompareText(Item[i].Name,'item') = 0 then
              itemcount := itemcount + 1;
          if FFeedIndex >= itemcount then
            FFeedIndex := 0;

          // get the item we want to display
          itemcount := 0;
          for i := 0 to Count - 1 do
            if CompareText(Item[i].Name,'item') = 0 then
            begin
              // This is the item index in the channel we want to display
              if FFeedIndex = itemcount then
              with Item[i].Items do
              begin
                s := Value('Title','Error Loading Title');
                CutString(s,top,bottom);
                lb_top.Caption := top;
                lb_bottom.Caption := bottom;
                RealignComponents(True);
                FFeedURL := Value('link','no link');
                FFeedDesc := Value('description','no description');
                hasEnclosure := (ItemNamed['enclosure'] <> nil);
                if ItemNamed['thumbnail'] <> nil then
                  hasMediaThumbnail := (CompareText(ItemNamed['thumbnail'].NameSpace,'media') = 0)
                else hasMediaThumbnail := False;
                if ItemNamed['content'] <> nil then
                  hasMediaContent := (CompareText(ItemNamed['content'].NameSpace,'media') = 0)
                else hasMediaContent := False;
                if (hasEnclosure) or (hasMediaThumbnail) or (hasMediaContent) then
                begin
                  if hasEnclosure then
                    image := ItemNamed['enclosure'].Properties.Value('url','')
                  else if hasMediaThumbnail then
                    image := ItemNamed['thumbnail'].Properties.Value('url','')
                  else if hasMediaContent then
                    image := ItemNamed['content'].Properties.Value('url','');
                       
                  FFeedImage := image;

                  if length(trim(image)) > 0 then
                    if FindImage(image) = nil then
                      TImageDownloadThread.Create(image,FImageList);
                end else FFeedImage := '';
                
                break;
              end;
              itemcount := itemcount + 1;
            end;
          break;
        end;
        channelcount := channelcount + 1;
      end;
  end;
end;

procedure TMainForm.UpdateSize;
begin
  LoadIcons;
  RenderIcon;
  btnRight.Left := Width - 2 - btnRight.Width;
end;

procedure TMainForm.UpdateTimerTimer(Sender: TObject);
var
  idHTTP : TIdHTTP;
  Stream : TMemoryStream;
  MimeList: TStringList;
  validType : boolean;
  success : boolean;
  n: Integer;
begin
  success := False;
  
  MimeList := TStringList.Create;
  MimeList.Clear;
  MimeList.Add('text/plain');
  MimeList.Add('text/xml');
  MimeList.Add('application/xml');
  MimeList.Add('application/rss');
  MimeList.Add('application/rss+xml');
  MimeList.Add('text/xml-external-parsed-entity');
  MimeList.Add('application/xml-external-parsed-entity');
  MimeList.Add('application/xml-dtd');
  idHTTP := TidHTTP.Create(nil);
  idHTTP.ConnectTimeout := 5000;
  idHTTP.Request.Accept := 'text/plain,text/xml,application/xml,text/xml-external-parsed-entity' +
                           'application/xml-external-parsed-entity,application/xml-dtd' +
                           'application/rss,application/rss+xml';
  idHTTP.HandleRedirects := True;
  try
    idHTTP.Head(sURL);
  except
  end;

  validType := False;
  for n := 0 to MimeList.Count - 1 do
    if StrFind(MimeList[n],idHttp.Response.ContentType) > 0 then
    begin
      validType := True;
      break;
    end;
  SharpApi.SendDebugMessage('rssReader.module','Response.ContentType: ' + idHttp.Response.ContentType,0);

  Stream := TMemoryStream.Create;
  if validType then
  begin
    try
      SharpApi.SendDebugMessage('rssReader.module','Starting download: ' + sURL,0);
      idHTTP.Get(sURL,Stream);
      SharpApi.SendDebugMessage('rssReader.module','Download finished',0);
      success := true;
    except
    end;
  end;

  try
    idHttp.Disconnect;
    idHttp.Free;
  except
  end;

  // try to load file
  FFeedValid := False;
  if success then
  begin
    try
      Stream.Position := 0;
      FFeed.LoadFromStream(Stream,seUTF8);
      FFeedValid := True;
      FFeedIndex := 0;
      UpdateDisplay;
      SyncImagesWithFeed;
    except
      FErrorMsg := 'Invalid feed file';
    end;
  end else
    FErrorMsg := 'Error downloading feed';

  Stream.Free;
  MimeList.Free;
end;

procedure TMainForm.ReAlignComponents(Broadcast : boolean = True);
var
  newWidth : integer;
  o1 : integer;
begin
  self.Caption := 'Rss Reader Module:' + sURL;

  o1 := 4;
  if sShowIcon then
  begin
    RenderIcon;
    o1 := o1 + Height - 4 + 2;
  end;

  if sShowButtons then
  begin
    btnLeft.Left := o1 - 1;
    btnLeft.Visible := True;
    btnRight.Visible := True;
    o1 := o1 + btnLeft.Width + 4;
  end else
  begin
    btnLeft.Visible := False;
    btnRight.Visible := False;
  end;

  lb_top.Left := o1-5;
  lb_bottom.Left := lb_top.Left;

  o1 := o1 + btnRight.Width + 4;

  if length(trim(lb_bottom.Caption)) = 0 then
  begin
    lb_top.AutoPos := apCenter;
    lb_bottom.Visible := False;
  end else
  begin
    lb_top.AutoPos := apTop;
    lb_bottom.Visible := True;
    lb_bottom.UpdateSkin;
  end;

  NewWidth := o1 + max(lb_top.Width,lb_Bottom.Width) + 4;
  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if (newWidth <> Width) and (Broadcast) then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize;
end;

procedure TMainForm.RenderIcon(pRepaint : boolean = True);
begin
  if not sShowIcon then exit;

  if pRepaint then Repaint;
end;

function StripTags(Src : String) : String;
var
  n : integer;
  s : string;
  block : boolean;
begin
  block := False;
  s := '';
  for n := 1 to length(Src) do
  begin
    if (Src[n] = '<') then
      block := True
    else if (Src[n] = '>') then
      block := False
    else if (not block) then
      s := s + Src[n];
  end;
  result := s;
end;

procedure TMainForm.ShowDescriptionNotification;
const
  MaxTextWidth = 300;
var
  NS : ISharpENotifySkin;
  SkinText : ISharpESkinText;
  x, y : Integer;
  edge : TSharpNotifyEdge;
  timeout,linespace,textHeight,textWidth : Integer;
  p : TPoint;
  hasImage : boolean;
  Image : TBitmap32; // only pointer, don't free
  BmpToDisplay : TBitmap32;
  BmpText : TBitmap32;
  Text,SplitText : TStringList;
  n : integer;
  s : string;
  imagesize : TPoint;
begin
  if not FFeedValid then
    exit;

  // Get the cordinates on the screen where the notification window should appear.
  p := Self.ClientToScreen(Point(0, Self.Height));
  x := p.X;
  if p.Y > Monitor.Top + Monitor.Height div 2 then
  begin
    edge := neBottomLeft;
    y := p.Y - Self.Height;
  end else
  begin
    edge := neTopLeft;
    y := p.Y;
  end;

  linespace := 5;
  timeout := 0;

  Image := nil;
  if length(trim(FFeedImage)) > 0 then
    Image := FindImage(FFeedImage);
  hasImage := (Image <> nil);

  BmpToDisplay := TBitmap32.Create;
  BmpToDisplay.DrawMode := dmBlend;
  BmpToDisplay.CombineMode := cmMerge;

  NS := mInterface.SkinInterface.SkinManager.Skin.Notify;
  SkinText := NS.Background.CreateThemedSkinText;
  SkinText.AssignFontTo(BmpToDisplay.Font, mInterface.SkinInterface.SkinManager.Scheme);

  // Create a bitmap for the description Text
  BmpText := TBitmap32.Create;
  SkinText.AssignFontTo(BmpText.Font, mInterface.SkinInterface.SkinManager.Scheme);
  BmpText.DrawMode := dmBlend;
  BmpText.CombineMode := cmMerge;
  textHeight := BmpText.TextHeight('H');

  // Cut and line wrap the description Text
  Text := TStringList.Create;
  SplitText := TStringList.Create;
  StrTokens(StripTags(FFeedDesc),Text);
  s := '';
  textWidth := 0;
  for n := 0 to Text.Count - 1 do
  begin
    if (BmpText.TextWidth(s) + BmpText.TextWidth(Text[n]) > MaxTextWidth) and (length(trim(s)) > 0) then
    begin
      SplitText.Add(trim(s));
      textWidth := Max(textWidth,BmpText.TextWidth(s));
      s := '';
    end;
    s := s + ' ' + Text[n];
  end;
  SplitText.Add(trim(s));
  textWidth := Max(textWidth,BmpText.TextWidth(s));  

  // Render the Text
  BmpText.SetSize(textWidth+8,(textHeight + linespace)*SplitText.Count+8);
  for n := 0 to SplitText.Count - 1 do
    SkinText.RenderToW(BmpText,4,4 + (textHeight + linespace) * n,SplitText[n],mInterface.SkinInterface.SkinManager.Scheme);

  // Render everything
  if hasImage then
  begin
    if (Image.Height > 1.2*BmpText.Height) then
      ScaleImage(Image,Image, (BmpText.Height * 1.2) / Image.Height, True);
    imagesize := Point(Image.Width+4,Image.Height+4);
  end
  else imagesize := Point(0,0);
  BmpToDisplay.SetSize(8 + imagesize.X + BmpText.Width, 4 + Max(ImageSize.y,BmpText.Height));
  if hasImage then
  begin
    BmpToDisplay.FillRect(3,3,5+Image.Width,5+Image.Height,clBlack32);
    Image.DrawTo(BmpToDisplay,4,4);
  end;
  BmpText.DrawTo(BmpToDisplay,ImageSize.X + 4,0);

  notifyItem := SharpNotify.CreateNotifyWindowBitmap(
    0,
    nil,
    x,
    y,
    BmpToDisplay,
    edge,
    mInterface.SkinInterface.SkinManager,
    timeout,
    Monitor.BoundsRect);

  BmpText.Free;
  BmpToDisplay.Free;

  Text.Free;
  SplitText.Free;
end;

procedure TMainForm.SwitchTimerTimer(Sender: TObject);
begin
  if notifyitem <> nil then
    exit;

  FFeedIndex := FFeedIndex + 1;
  UpdateDisplay;
end;

procedure TMainForm.SyncImagesWithFeed;
var
  n,i : integer;
  RssImages : TStringList;
  found : boolean;
  hasEnclosure,hasMediaThumbnail,hasMediaContent : boolean;
  image : String;
begin
  if FFeedValid then
  begin
    // build a list of all images contained in the rss feed
    RssImages := TStringList.Create;
    with FFeed.Root.Items do
      for n := 0 to Count - 1 do
        if CompareText(Item[n].Name,'channel') = 0 then
          for i := 0 to Item[n].Items.Count - 1 do
            if CompareText(Item[n].Items.Item[i].Name,'item') = 0 then
            with Item[n].Items.Item[i].Items do
            begin
              hasEnclosure := (ItemNamed['enclosure'] <> nil);
              if ItemNamed['thumbnail'] <> nil then
                hasMediaThumbnail := (CompareText(ItemNamed['thumbnail'].NameSpace,'media') = 0)
              else hasMediaThumbnail := False;
              if ItemNamed['content'] <> nil then
                hasMediaContent := (CompareText(ItemNamed['content'].NameSpace,'media') = 0)
              else hasMediaContent := False;
              if (hasEnclosure) or (hasMediaThumbnail) or (hasMediaContent) then
              begin
                if hasEnclosure then
                  image := ItemNamed['enclosure'].Properties.Value('url','')
                else if hasMediaThumbnail then
                  image := ItemNamed['thumbnail'].Properties.Value('url','')
                else if hasMediaContent then
                  image := ItemNamed['content'].Properties.Value('url','');

               RssImages.Add(image);
              end;
            end;

    // delete all image from the list wich are not part of the rss feed
    for n := FImageList.Count - 1 downto 0 do
    begin
      found := false;
      for i := 0 to RssImages.Count - 1 do
        if CompareText(RssImages[i],TImageListItem(FImageList[n]).Url) = 0 then
        begin
          found := true;
          break;
        end;
      if (not found) then
        FImageList.Delete(n);
    end;
        
    RssImages.Free;
  end;
end;

procedure TMainForm.btnLeftClick(Sender: TObject);
var
  wasEnabled : boolean;
begin
  wasEnabled := False;
  if SwitchTimer.Enabled then
  begin
    wasEnabled := False;
    SwitchTimer.Enabled := False;
  end;

  FFeedIndex := FFeedIndex - 1;
  if FFeedIndex < 0 then
    FFeedIndex := 0;  
  UpdateDisplay;

  if wasEnabled then
    SwitchTimer.Enabled := True;
end;

procedure TMainForm.btnRightClick(Sender: TObject);
var
  wasEnabled : boolean;
begin
  wasEnabled := True;
  if SwitchTimer.Enabled then
  begin
    wasEnabled := False;
    SwitchTimer.Enabled := False;
  end;

  FFeedIndex := FFeedIndex + 1;
  UpdateDisplay;

  if wasEnabled then
    SwitchTimer.Enabled := True;
end;

procedure TMainForm.ClosePopupTimerTimer(Sender: TObject);
var
  cursorPos : TPoint;
  clientPos : TPoint;
  R : TRect;
begin
  if GetCursorPosSecure(cursorPos) then
    clientPos := ScreenToClient(cursorPos)
  else Exit;

  if sShowButtons then
    R := Rect(btnLeft.Left + btnLeft.Width + 4,0,Width - btnRight.Width - 4,Height)
  else R := Rect(0,0,Width,Height);
  if PtInRect(R, clientPos) then
    Exit;

  SharpNotify.CloseNotifyWindow(notifyItem);
  notifyItem := nil;
  ClosePopupTimer.Enabled := False;
end;

function TMainForm.FindImage(pUrl: String): TBitmap32;
var
  n : integer;
begin
  for n := 0 to FImageList.Count - 1 do
    if CompareText(pURL,TImageListItem(FImageList.Items[n]).Url) = 0 then
    begin
      result := TImageListItem(FImageList.Items[n]).Bmp;
      exit;
    end;
  result := nil;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;

  sShowIcon := True;

  FIcon := TBitmap32.Create;

  FFeedValid := False;
  FFeedIndex := 0;
  FFeedChannel := 0;
  FErrorMsg := 'Updating Feed...';
  FFeed := TJclSimpleXML.Create;

  FImageList := TObjectList.Create(True);
end;

procedure TMainForm.FormDblClick(Sender: TObject);
var
  cursorPos : TPoint;
  clientPos : TPoint;
  R : TRect;
begin
  if GetCursorPosSecure(cursorPos) then
    clientPos := ScreenToClient(cursorPos)
  else Exit;
  
  if sShowButtons then
    R := Rect(btnLeft.Left + btnLeft.Width + 4,0,Width - btnRight.Width - 4,Height)
  else R := Rect(0,0,Width,Height);
  if PtInRect(R, clientPos) then
    SharpExecute(FFeedURL);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SwitchTimer.Enabled := False;
  UpdateTimer.Enabled := False;

  FImageList.Clear;
  FImageList.Free;
  
  FreeAndNil(FIcon);

  FFeedValid := False;  
  FFeed.Free;
end;

procedure TMainForm.FormMouseEnter(Sender: TObject);
begin
  if not sShowNotification then
    Exit;

  // Only enable the timers once while the mouse is over the module
  // and don't allow more than 1 window to popup at a time.
  if not PopupTimer.Enabled and not ClosePopupTimer.Enabled then
  begin
    PopupTimer.Enabled := True;
    ClosePopupTimer.Enabled := True;
  end;
end;

procedure TMainForm.FormPaint(Sender: TObject);
var
  Bmp : TBitmap32;
begin
  Bmp := TBitmap32.Create;
  Bmp.Assign(mInterface.Background);
  if sShowIcon then
  begin
//     FLastIcon.DrawTo(Canvas.Handle,Rect(2,2,Height-2,Height-2),FLastIcon.BoundsRect);
     if FIcon.Resampler = nil then
       TLinearResampler.Create(FIcon);
     FIcon.DrawTo(Bmp,Rect(2,2,Height-2,Height-2));
  end;
  Bmp.DrawTo(Canvas.Handle,0,0);
  Bmp.Free;
end;

procedure TMainForm.lb_bottomDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute(FFeedURL);
end;

procedure TMainForm.lb_topDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute(FFeedURL);
end;

end.
