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
  Windows, SysUtils, Classes, Controls, Forms, Contnrs, Types, Graphics,
  Dialogs, StdCtrls, SharpEBaseControls, GR32_Resamplers, SharpNotify,
  ExtCtrls, GR32, uISharpBarModule, SharpTypes, ISharpESkinComponents,
  JclStrings, JclSimpleXML, SharpApi, Menus, Math, SharpESkinLabel,
  uImageDownloadThread, SharpImageUtils, JclStreams, SharpEButton, ImgList,
  PngImageList, AppEvnts;


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
    DoubleClickTimer: TTimer;
    ClearNotifyWindows: TTimer;
    Popup: TPopupMenu;
    PngImageList1: TPngImageList;
    ApplicationEvents1: TApplicationEvents;
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
    procedure FormClick(Sender: TObject);
    procedure DoubleClickTimerTimer(Sender: TObject);
    procedure ClearNotifyWindowsTimer(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);
    procedure PopupPopup(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  protected
  private
    sShowNotification : boolean;  
    sShowIcon    : boolean;
    sCustomIcon  : boolean;
    sURL         : String;
    sFeedUpdate  : integer;
    sSwitchTime  : integer;
    sShowButtons : boolean;
    FFeed        : TJclSimpleXML;
    FFeedValid   : boolean;
    FIcon        : TBitmap32;
    FChannelIcon : TBitmap32;
    FFeedIndex   : integer;
    FFeedChannel : integer;
    FFeedURL     : String;
    FFeedDesc    : String;
    FFeedImage   : String;
    FErrorMsg    : String;
    FCustomIcon  : Boolean;
    FImageList   : TObjectList;
    FThreadList  : TObjectList;
    FDeleteList  : TObjectList;
    notifyItem   : TNotifyItem;
    FIconsInitialized : boolean;
    FActivePopup : TPopupMenu;    
    function FindImage(pUrl : String) : TBitmap32;
    procedure OnFeedImageDownload(Sender: TObject);
    procedure OnThumbImageDownload(Sender : TObject);
    procedure OnThreadFinished(Sender : TObject);
    procedure OnFeedUpdateForm(Stream : TStream; isUTF8 : boolean);   
  public
    mInterface : ISharpBarModule;
    procedure UpdateDisplay;
    procedure SyncImagesWithFeed;
    procedure ShowDescriptionNotification;
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure UpdateFeedIcon;
    procedure RenderIcon(pRepaint : boolean = True);
    procedure LoadIcons;
    property FeedValid : boolean read FFeedValid write FFeedValid;
    property Feed : TJclSimpleXML read FFeed;
    property FeedIndex : integer read FFeedIndex write FFeedIndex;
    property ErrorMsg : String read FErrorMsg write FErrorMsg;
  end;


implementation

uses
  GR32_PNG,
  IdHTTP,
  uFeedDownloadThread,
  uSharpXMLUtils;

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
begin
  sURL := 'http://rss.cnn.com/rss/cnn_world.rss';
  sShowNotification := True;
  sShowIcon := True;
  sSwitchTime := 20; // seconds
  sFeedUpdate := 15; // minutes
  sShowButtons := False;
  sCustomIcon := False;

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    with xml.Root.Items do
    begin
      sShowIcon := BoolValue('showicon',sShowIcon);
      sURL      := Value('url',sURL);
      sShowNotification := BoolValue('shownotification',sShowNotification);
      sSwitchTime := IntValue('switchtime',sSwitchTime);
      sFeedUpdate := IntValue('feedupdate',sFeedUpdate);
      sShowButtons := BoolValue('showbuttons',sShowButtons);
      sCustomIcon := BoolValue('customicon',sCustomIcon);
    end;
  XML.Free;
  if sFeedUpdate < 1 then
    sFeedUpdate := 1;
  if (sSwitchTime < 5) and (sSwitchTime <> 0) then
    sSwitchTime := 20;
  sSwitchTime := sSwitchTime * 1000;
  sFeedUpdate := sFeedUpdate * 1000 * 60;
  SwitchTimer.Enabled := (sSwitchTime > 0);
  UpdateTimer.Interval := sFeedUpdate;
  SwitchTimer.Interval := sSwitchTime;
  if UpdateTimer.Enabled then
  begin
    UpdateTimer.OnTimer(UpdateTimer);
  end;
end;

procedure TMainForm.MenuItemClick(Sender: TObject);
begin
  SharpExecute(TMenuItem(Sender).Hint);
end;

procedure TMainForm.OnFeedImageDownload(Sender: TObject);
begin
  FCustomIcon := True;
  RealignComponents(True);
end;

procedure TMainForm.OnFeedUpdateForm(Stream: TStream; isUTF8: boolean);
begin
  FeedValid := False;
  try
    Stream.Position := 0;

    if isUTF8 then
      FFeed.LoadFromStream(Stream,seUTF8)
    else FFeed.LoadFromStream(Stream,seAuto);

    FeedValid := True;
    FeedIndex := 0;
    UpdateDisplay;
    UpdateFeedIcon;
    SyncImagesWithFeed;
  except
    ErrorMsg := 'Invalid feed file';
  end;
end;

procedure TMainForm.OnThreadFinished(Sender: TObject);
begin
  if Sender <> nil then
  begin
    FThreadList.Remove(Sender);
    if Sender is TFeedDownloadThread then
      if CompareText(FErrorMsg,'Error downloading Feed') = 0 then
        RealignComponents(True);
  end;
end;

procedure TMainForm.OnThumbImageDownload(Sender: TObject);
var
  wasEnabled : boolean;
begin
  wasEnabled := False;
  if SwitchTimer.Enabled then
  begin
    wasEnabled := True;
    SwitchTimer.Enabled := False;
  end;

  if notifyItem <> nil then
  begin
    ClosePopupTimer.Enabled := False;
    FDeleteList.Add(notifyItem);
    notifyItem := nil;    
    ClearNotifyWindows.Enabled := True;
  end;

  if wasEnabled then
    SwitchTimer.Enabled := True;
end;

procedure TMainForm.PopupPopup(Sender: TObject);
begin
  FActivePopup := TPopupMenu(Sender);

  if notifyItem <> nil then
  begin
    ClosePopupTimer.Enabled := False;  
    SharpNotify.CloseNotifyWindow(notifyItem);
    notifyItem := nil;
  end;
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
  Thread : TImageDownloadThread;
  mitem : TMenuItem;
  mroot : TMenuItem;
begin
  SwitchTimer.Enabled := False;

  Popup.Items.Clear;
  mroot := Popup.Items;

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
              s := Item[i].Items.Value('Title','Error Loading Title');
              if (itemcount mod 20  = 0) and (itemcount > 0) then
              begin
                mitem := TMenuItem.Create(mroot);
                mitem.Caption := 'More...';
                mitem.ImageIndex := 1;
                mroot.Add(mitem);
                mroot := mitem;
              end;
              mitem := TMenuItem.Create(mroot);
              mitem.Caption := s;
              mitem.Hint := Item[i].Items.Value('link','no link');
              mitem.ImageIndex := 0;
              mitem.OnClick := MenuItemClick;
              mroot.Add(mitem);

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
                FFeedDesc := Value('description','');
                if length(trim(FFeedDesc)) = 0 then
                  FFeedDesc := s;
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
                    begin
                      Thread := TImageDownloadThread.Create(image,FImageList);
                      Thread.OnFinishedDownload := OnThumbImageDownload;
                      Thread.OnThreadFinished := OnThreadFinished;
                      FThreadList.Add(Thread);
                    end;
                end else FFeedImage := '';

              end;
              itemcount := itemcount + 1;
            end;

          break;
        end;
        channelcount := channelcount + 1;
      end;
  end;

  SwitchTimer.Enabled := True;
end;

procedure TMainForm.UpdateFeedIcon;
var
  n : integer;
  channelcount : integer;
  channel : integer;
  s : String;
  Thread : TImageDownloadThread;
begin
  SwitchTimer.Enabled := False;

  if (FFeedValid) and (sCustomIcon) then
  begin
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
            s := '';
            if ItemNamed['image'] <> nil then
              s := ItemNamed['image'].Items.Value('url','');
            if length(trim(s)) > 0 then
            begin
              Thread := TImageDownloadThread.Create(s,FChannelIcon);
              Thread.OnFinishedDownload := OnFeedImageDownload;
              Thread.OnThreadFinished := OnThreadFinished;
              FThreadList.Add(Thread);
            end
            else begin
              FCustomIcon := False;
              FChannelIcon.Assign(FIcon);
            end;
          end;

          break;
        end;
    end;
  end else
  begin
    FCustomIcon := False;
    FChannelIcon.Assign(FIcon);
  end;

  SwitchTimer.Enabled := True;
end;

procedure TMainForm.UpdateSize;
begin
  LoadIcons;
  RenderIcon;
  btnRight.Left := Width - 2 - btnRight.Width;
end;

procedure TMainForm.UpdateTimerTimer(Sender: TObject);
var
  Thread : TFeedDownloadThread;
  n : integer;
begin
  UpdateTimer.Enabled := False;

  // check for old and already dead threads
  for n := FThreadList.Count - 1 downto 0 do
    if (FThreadList.Items[n] = nil) then
      FThreadList.Delete(n);

  InitializeCriticalSection(CriticalFeedSection);
  Thread := TFeedDownloadThread.Create(sURL,self);
  Thread.OnFeedUpdateForm := OnFeedUpdateForm;
  Thread.OnThreadFinished := OnThreadFinished;
  FThreadList.Add(Thread);
end;

procedure TMainForm.ReAlignComponents(Broadcast : boolean = True);
var
  newWidth : integer;
  o1 : integer;
begin
  self.Caption := 'Rss Reader Module:' + sURL;

  if not FFeedValid then
  begin
    lb_top.Caption := FErrorMsg;
    lb_bottom.Caption := '';
  end;

  if not FIconsInitialized then
  begin
    LoadIcons;
    FCustomIcon := False;
    FChannelIcon.Assign(FIcon);
    FIconsInitialized := True;
  end;

  o1 := 4;
  if sShowIcon then
  begin
    RenderIcon;
    o1 := o1 + round(FChannelIcon.Width * (Height - 8) / FChannelIcon.Height) + 2;
  end;

  if sShowButtons then
  begin
    btnLeft.Left := o1 - 1;
    btnLeft.Visible := True;
    o1 := o1 + btnLeft.Width + 4;
  end else
  begin
    btnLeft.Visible := False;
  end;

  lb_top.Left := o1-5;
  lb_bottom.Left := lb_top.Left;

  // Handle adding the width of the right button after
  // we determine the placement for the labels.
  if sShowButtons then
  begin
    btnRight.Visible := True;
    o1 := o1 + btnRight.Width + 4;
  end else
  begin
    btnRight.Visible := False;
  end;
    
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

  if (FActivePopup <> nil) then
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
  if (FActivePopup <> nil) then
    exit;

  if notifyitem <> nil then
    exit;

  if (not FFeedValid) then
  begin
    UpdateTimerTimer(nil);
    exit;
  end;


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

procedure TMainForm.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  if Assigned(FActivePopup) then
    FActivePopup := nil;
end;

procedure TMainForm.btnLeftClick(Sender: TObject);
var
  wasEnabled : boolean;
begin
  wasEnabled := False;
  if SwitchTimer.Enabled then
  begin
    wasEnabled := True;
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
  wasEnabled := False;
  if SwitchTimer.Enabled then
  begin
    wasEnabled := True;
    SwitchTimer.Enabled := False;
  end;

  FFeedIndex := FFeedIndex + 1;
  UpdateDisplay;

  if wasEnabled then
    SwitchTimer.Enabled := True;

  if notifyItem <> nil then
  begin
    ClosePopupTimer.Enabled := False;  
    SharpNotify.CloseNotifyWindow(notifyItem);
    notifyItem := nil;
    ShowDescriptionNotification;
    ClosePopupTimer.Enabled := True;
  end;
end;

procedure TMainForm.ClearNotifyWindowsTimer(Sender: TObject);
var
  n : integer;
begin
  // delete all the possibly still existing notify windows
  for n := 0 to FDeleteList.Count - 1 do
    if (FDeleteList.Items[n] <> nil) then
      SharpNotify.CloseNotifyWindow(TNotifyItem(FDeleteList.Items[n]));

  FDeleteList.Clear();
  ClearNotifyWindows.Enabled := False;

  ShowDescriptionNotification;
  ClosePopupTimer.Enabled := True;
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

procedure TMainForm.DoubleClickTimerTimer(Sender: TObject);
begin
  btnRightClick(nil);
  DoubleClickTimer.Enabled := False;
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

procedure TMainForm.FormClick(Sender: TObject);
begin
  DoubleClickTimer.Enabled := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;

  sShowIcon := True;

  FChannelIcon := TBitmap32.Create;
  FCustomIcon := False;
  FIcon := TBitmap32.Create;

  FThreadList := TObjectList.Create(False);
  FDeleteList := TObjectList.Create(False);

  FFeedValid := False;
  FFeedIndex := 0;
  FFeedChannel := 0;
  FErrorMsg := 'Updating Feed...';
  FFeed := TJclSimpleXML.Create;

  FImageList := TObjectList.Create(True);
  FIconsInitialized := False;
end;

procedure TMainForm.FormDblClick(Sender: TObject);
var
  cursorPos : TPoint;
  clientPos : TPoint;
  R : TRect;
begin
  DoubleClickTimer.Enabled := False;

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
var
  n : integer;
begin
  SwitchTimer.Enabled := False;
  UpdateTimer.Enabled := False;
  ClearNotifyWindows.Enabled := False;
  PopupTimer.Enabled := False;
  ClosePopupTimer.Enabled := False;

  if notifyItem <> nil then
    FDeleteList.Add(notifyItem);

  // wait for all thread to finish
  for n := 0 to FThreadList.Count - 1 do
    if (FThreadList.Items[n] <> nil) then
      TThread(FThreadList.Items[n]).WaitFor();

  // delete all the possibly still existing notify windows
  for n := 0 to FDeleteList.Count - 1 do
    if (FDeleteList.Items[n] <> nil) then
      SharpNotify.CloseNotifyWindow(TNotifyItem(FDeleteList.Items[n]));  

  FThreadList.Free;
  FDeleteList.Free;
  
  FImageList.Clear;
  FImageList.Free;

  FreeAndNil(FIcon);
  FreeAndNil(FChannelIcon);

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
  R : TRect;
begin
  Bmp := TBitmap32.Create;
  Bmp.Assign(mInterface.Background);
  if sShowIcon then
  begin
//     FLastIcon.DrawTo(Canvas.Handle,Rect(2,2,Height-2,Height-2),FLastIcon.BoundsRect);
     if FChannelIcon.Resampler = nil then
       TKernelResampler.Create(FChannelIcon).Kernel := TLanczosKernel.Create;
     R := Rect(2,4,round(FChannelIcon.Width * (Height - 8) / FChannelIcon.Height)+2,Height-4);
     if FCustomIcon then
       Bmp.FillRect(R.Left - 1,R.Top - 1, R.Right + 1,R.Bottom + 1,color32(0,0,0,255));
     // FChannelIcon.CombineMode := cmMerge;
     // FChannelIcon.DrawMode := dmBlend;
     // FChannelIcon.MasterAlpha := 196;
     FChannelIcon.DrawTo(Bmp,R);
  end;
  Bmp.DrawTo(Canvas.Handle,0,0);
  Bmp.Free;
end;

procedure TMainForm.lb_bottomDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute(FFeedURL);
  DoubleClickTimer.Enabled := False;
end;

procedure TMainForm.lb_topDblClick(Sender: TObject);
begin
  DoubleClickTimer.Enabled := False;
  SharpApi.SharpExecute(FFeedURL);
end;

end.
