//***********************************************************************
//**
//** Program:		SharpConsole
//**
//** Description:       ConsoleApplication, take messages from
//**                    other Sharpe components. Can show bitmaps
//**                    Links, different colors and so on.
//**
//** Author:		Malx (Malx@techie.com)
//**
//** Created:		2000-06-12
//**
//** Modified:    *  2001-09-09 Now following pb2 style.
//**                            Improved sizing.(No more flickering)
//**
//***********************************************************************

unit Main;
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
  sharpapi,
  StdCtrls,
  Menus,
  ExtCtrls,
  fatthings,
  ToolWin,
  ComCtrls,
  ImgList,
  textconverterunit,
  jclstrings,
  uDebugList,
  CheckLst,
  Buttons,
  uDebugging,
  CoolTrayIcon, pngimage, XPMan, PngImageList, SharpERoundPanel, SharpETabList,
  JvExControls, JvPageList, clipbrd, JvExCheckLst, JvCheckListBox, JvgListBox;

type
  PConsoleMsg = ^TConsoleMsg;
  TConsoleMsg = record
    module: string[255];
    msg: string[255];
  end;

type
  TSharpConsoleWnd = class(TForm)
    bug: TImage;
    notSmile: TImage;
    blink: TImage;
    P: TImage;
    angry: TImage;
    mail: TImage;
    smilemore: TImage;
    smile: TImage;
    warning: TImage;
    Panel1: TPanel;
    imlTbNorm: TImageList;
    imgError: TImage;
    imgInfo: TImage;
    Panel2: TPanel;
    panMemo: TPanel;
    Timer1: TTimer;
    panMemoBody_: TPanel;
    Label1: TLabel;
    sbMain: TStatusBar;
    mnuSave: TPopupMenu;
    SaveAllHistory1: TMenuItem;
    SaveVisible1: TMenuItem;
    dlgSaveFile: TSaveDialog;
    mnuClear: TPopupMenu;
    DeleteAllHistory1: TMenuItem;
    tiMain: TCoolTrayIcon;
    mnuTi: TPopupMenu;
    Exit1: TMenuItem;
    imgDebugTrace: TImage;
    imgDebugInfo: TImage;
    imgDebugError: TImage;
    imgDebugStatus: TImage;
    imgDebugWarn: TImage;
    TrayMain: TImage;
    TrayFlash: TImage;
    tmrRevertNorm: TTimer;
    ToolBar1: TToolBar;
    tbPause: TToolButton;
    tbRefresh: TToolButton;
    tbCopy: TToolButton;
    XPManifest1: TXPManifest;
    SharpERoundPanel1: TSharpERoundPanel;
    SharpERoundPanel2: TSharpERoundPanel;
    Label2: TLabel;
    Panel3: TPanel;
    SharpERoundPanel3: TSharpERoundPanel;
    SharpERoundPanel4: TSharpERoundPanel;
    Label3: TLabel;
    Panel6: TPanel;
    Panel9: TPanel;
    clbModuleList_: TCheckListBox;
    chkRefreshModules: TCheckBox;
    tlLog: TSharpETabList;
    pnlTabBorder: TSharpERoundPanel;
    prgRefresh: TProgressBar;
    plMain: TJvPageList;
    pagTextLog: TJvStandardPage;
    pagRoLog: TJvStandardPage;
    mmoCopy: TMemo;
    sbClear: TToolButton;
    clbDebugLevel: TJvgCheckListBox;
    clbModuleList: TJvgCheckListBox;
    chkRefreshDebug: TCheckBox;
    procedure clbDebugLevelClick(Sender: TObject);
    procedure clbModuleListClick(Sender: TObject);
    procedure tlLogTabChange(ASender: TObject;
      const ATabIndex: Integer; var AChange: Boolean);
    procedure Close1Click(Sender: TObject);
    procedure Minimize1Click(Sender: TObject);
    procedure TextMemoLinkClick(Sender: TObject; Link: string);
    procedure TextMemoScrollVert(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ThrobberbuttonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SizeButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ThrobberMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Delete1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Infi1Click(Sender: TObject);
    procedure clbModuleList_ClickCheck(Sender: TObject);
    procedure clbDebugLevel_ClickCheck(Sender: TObject);
    procedure tbRefreshClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure chkRefreshListClick(Sender: TObject);
    procedure SaveAllHistory1Click(Sender: TObject);
    procedure SaveVisible1Click(Sender: TObject);
    procedure ClearAll1Click(Sender: TObject);

    procedure tbCopyTextClick(Sender: TObject);
    procedure tiMainDblClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure clbModuleList_Click(Sender: TObject);
    procedure clbDebugLevel_Click(Sender: TObject);

    procedure clbDebugLevel_MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure clbModuleList_MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure tbPauseClick(Sender: TObject);
    procedure tmrRevertNormTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FNotChecked: TStringList;
    procedure Restore(Sender: TObject);
    procedure GetCopyData(var Msg: TMessage); message wm_CopyData;
    procedure UpdateLog(Sender: TObject);
    procedure UpdateModulesList;

    procedure RemoveNotChecked(Module: string);
    procedure DeleteHistory;
    procedure RefreshDebugList;
    procedure ShowToolBarHint(Sender: TObject);

    { Private declarations }
  public
    TextMemo: TFatMemo;
    function IsModuleNotChecked(Module: string): Boolean;
    { Public declarations }
  end;

var
  SharpConsoleWnd: TSharpConsoleWnd;
  posY: integer;
  recieve: string;
  oldMousePoint: Tpoint;
  bMoveMouse, paused: boolean;
  bDragFullWindows: boolean;
  bHaveMoved: boolean;
  //ColorScheme: TColorscheme;
  IsModuleWndClicked: Boolean;
  Playing: Boolean;
  ConsoleFlashInc: Integer;

procedure DrawText(sMess: string; iColor: integer; MessageType: Integer; dt:
  TDateTime);

procedure SendConsoleErrorMessage(msg: string);
function ExtractModuleName(text: string): string;

implementation

uses uCopyText;

//uses Unit1;

{$R *.DFM}

procedure SendConsoleErrorMessage(msg: string);
begin
  msg := msg +
    ' <FONT COLOR=$000000><A HREF=mailto:Malx@techie.com?subject=SharpConsole bug: ' + msg
    + '&body=Describe what you did and on what system here...><U>£Click to report.</U></A></FONT>';
  sendDebugMessage('SharpConsole', msg, clERROR);
end;

procedure DrawText(sMess: string; iColor: integer; MessageType: Integer; dt:
  TDateTime);
//This is were all textdecoding (from htmlstyle into textmemo) takes
//part...
var
  i, j, k, l: Integer;
  style: TFontStyles;
  Color: Tcolor;
  sColor: Tcolor;
  WholeLine: TfatLine;
  AddString, Linkstring: string;
  endtag, link: boolean;
  temp, debugtext, hexcolor: string;

  procedure DrawPart;
  var
    part: Tfatpart;
  begin
    WholeLine.add.BackColor := clWhite;
    WholeLine.add.FontColor := color;
    WholeLine.add.Style := style;
    Part := WholeLine.add;
    part.Text := Addstring;
    if link then
      part.Link := LinkString;
    Addstring := '';
  end;

  procedure DrawPicture(bitmap: Tbitmap);
  var
    part: Tfatpart;
  begin
    DrawPart;
    part := WholeLine.add;
    part.Bitmap := bitmap;
    part.Link := LinkString;
  end;

begin
  try
    debugtext := sMess;

    case iColor of
      1: sColor := $B06C48;
      2: sColor := clRed;
    else
      sColor := clBlack;
    end;
    color := scolor;
    style := [];
    WholeLine := SharpConsoleWnd.textmemo.Lines.AddNew;
    WholeLine.Updating := True;

    Addstring := ' ';
    hexcolor := '$888888';
    if MessageType = DMT_ERROR then
      hexcolor := '$0000FF';

    sMess := ' ' + '<FONT COLOR=' + hexcolor + '>' +
      formatdatetime('hh:nn:ss | ', dt) + sMess;

    case MessageType of
      DMT_INFO: Drawpicture(SharpConsoleWnd.imgDebugInfo.Picture.Bitmap);
      DMT_STATUS: Drawpicture(SharpConsoleWnd.imgDebugStatus.Picture.Bitmap);
      DMT_WARN: Drawpicture(SharpConsoleWnd.imgDebugWarn.Picture.Bitmap);
      DMT_ERROR: Drawpicture(SharpConsoleWnd.imgDebugError.Picture.Bitmap);
      DMT_TRACE: Drawpicture(SharpConsoleWnd.imgDebugTrace.Picture.Bitmap);
      DMT_NONE: sMess := ' ' + '<FONT COLOR=' + hexcolor + '>' + debugtext;
    end;

    //Drawpart;

    j := 0;
    for i := 1 to length(sMess) do begin
      if j = 0 then begin
        case sMess[i] of
          '<': begin
              if sMess[i + 1] = '/' then begin
                endtag := true;
                j := 1;
              end
              else begin
                endtag := false;
                j := 0;
              end;
              if ((uppercase(sMess[i + j + 1]) = 'B') and (sMess[i + j + 2] =
                '>')) then begin
                DrawPart;
                inc(j, 2);
                if not (endtag) then
                  Style := Style + [fsBold]
                else
                  Style := Style - [fsBold];
              end
              else if ((uppercase(sMess[i + j + 1]) = 'U') and (sMess[i + j + 2]
                = '>')) then begin
                DrawPart;
                inc(j, 2);
                if not (endtag) then
                  Style := Style + [fsUnderline]
                else
                  Style := Style - [fsUnderline];
              end
              else if ((uppercase(sMess[i + j + 1]) = 'I') and (sMess[i + j + 2]
                = '>')) then begin
                DrawPart;
                inc(j, 2);
                if not (endtag) then
                  Style := Style + [fsItalic]
                else
                  Style := Style - [fsItalic];
              end
              else if ((uppercase(sMess[i + j + 1]) = 'F') and (uppercase(sMess[i
                + j + 2]) = 'O')
                  and (uppercase(sMess[i + j + 3]) = 'N') and (uppercase(sMess[i
                +
                  j + 4]) = 'T')) then begin
                inc(j, 4);
                if (uppercase(sMess[i + j + 1]) = '>') and endtag then begin
                  DrawPart;
                  inc(j, 1);
                  color := scolor;
                end
                else if ((uppercase(sMess[i + j + 2]) = 'C') and
                  (uppercase(sMess[i + j + 3]) = 'O')
                  and (uppercase(sMess[i + j + 4]) = 'L') and (uppercase(sMess[i
                  + j + 5]) = 'O')
                    and (uppercase(sMess[i + j + 6]) = 'R') and
                  (uppercase(sMess[i
                  + j + 7]) = '=')) then begin
                  DrawPart;
                  inc(j, 7);
                  temp := '';
                  k := 1;
                  while (sMess[i + j + k] <> '>') do begin
                    temp := temp + sMess[i + j + k];
                    inc(k);
                  end;
                  Color := stringtocolor(temp);
                  inc(j, k);
                end;
              end
              else if ((uppercase(sMess[i + j + 1]) = 'A')) then begin
                if (uppercase(sMess[i + j + 2]) = '>') and endtag then begin
                  DrawPart;
                  inc(j, 2);
                  link := false;
                end
                else if ((uppercase(sMess[i + j + 2]) = ' ') and
                  (uppercase(sMess[i + j + 3]) = 'H')
                  and (uppercase(sMess[i + j + 4]) = 'R') and (uppercase(sMess[i
                  + j + 5]) = 'E')
                    and (uppercase(sMess[i + j + 6]) = 'F') and
                  (uppercase(sMess[i
                  + j + 7]) = '=')) then begin
                  DrawPart;
                  inc(j, 7);
                  LinkString := '';
                  k := 0;
                  l := 0;
                  while ((sMess[i + j + k + 1] <> '>') or (l > 0)) do begin
                    if sMess[i + j + k + 1] = '<' then
                      inc(l);
                    if sMess[i + j + k + 1] = '>' then
                      dec(l);
                    LinkString := LinkString + sMess[i + j + k + 1];
                    inc(k, 1);
                  end;
                  inc(j, k + 1);
                  link := true;
                end
                else begin
                  AddString := AddString + sMess[i];
                  j := 0;
                end;
              end //if 'A'
              else begin
                Addstring := AddString + sMess[i];
                j := 0;
              end;
            end; // '<'
          ';': begin
              if sMess[i + 1] = '-' then
                j := 1
              else
                j := 0;
              if (sMess[i + j + 1] = ')') then begin
                Drawpicture(SharpConsoleWnd.blink.Picture.bitmap);
                inc(j, 1);
              end
              else begin
                Addstring := Addstring + sMess[i];
                j := 0;
              end;
            end;
          ':': begin
              if sMess[i + 1] = '-' then
                j := 1
              else
                j := 0;
              if (sMess[i + j + 1] = ')') then begin
                Drawpicture(SharpConsoleWnd.smile.Picture.bitmap);
                inc(j, 1);
              end
              else if (sMess[i + j + 1] = '(') then begin
                Drawpicture(SharpConsoleWnd.angry.Picture.bitmap);
                inc(j, 1);
              end
              else if (sMess[i + j + 1] = 'P') then begin
                Drawpicture(SharpConsoleWnd.P.Picture.bitmap);
                inc(j, 1);
              end
              else if (sMess[i + j + 1] = 'D') then begin
                Drawpicture(SharpConsoleWnd.P.Picture.bitmap);
                inc(j, 1);
              end
              else if (sMess[i + j + 1] = '|') then begin
                Drawpicture(SharpConsoleWnd.P.Picture.bitmap);
                inc(j, 1);
              end
              else begin
                AddString := Addstring + sMess[i];
                j := 0;
              end;
            end; // ':'
          '£': Drawpicture(SharpConsoleWnd.bug.Picture.bitmap);
          '@': Drawpicture(SharpConsoleWnd.mail.Picture.bitmap);
          '§': begin
              inc(j, 1);
              while ((smess[i + j + 1] <> '§') and (length(sMess) <= (i + j +
                1))) do begin
                AddString := Addstring + sMess[i + j + 1];
                inc(j, 1);
              end;
            end;
        else begin
            AddString := Addstring + sMess[i];
          end;
        end; //Case sMess of
      end //if j < 0
      else
        dec(j);
    end; //for i := ....
    DrawPart;
    Wholeline.Updating := False;
    SharpConsoleWnd.textmemo.TopIndex := SharpConsoleWnd.textmemo.BarVert.max;
    SharpConsoleWnd.textmemo.BarVert.Position := SharpConsoleWnd.textmemo.BarVert.max;

    //SharpConsoleWnd.textmemo.Paint;

  except
    SendConsoleErrorMessage('Problem drawing incoming message: §' + sMess +
      '§');
  end;
end;

procedure TSharpConsoleWnd.Close1Click(Sender: TObject);
begin
  SharpConsoleWnd.close;
end;

procedure TSharpConsoleWnd.Minimize1Click(Sender: TObject);
begin
  try
    SetWindowpos(SharpConsoleWnd.handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or
      SWP_NOMOVE or SWP_NOREDRAW);
    Application.Minimize;
  except
    SendConsoleErrorMessage('Problem minimizing Console.');
  end;
end;

procedure TSharpConsoleWnd.TextMemoLinkClick(Sender: TObject; Link: string);
begin
  SharpExecute(Link);
end;

procedure TSharpConsoleWnd.TextMemoScrollVert(Sender: TObject);
begin
  if Textmemo.BarVert.Position = Textmemo.BarVert.Min then begin
    textmemo.StickText := sttop;
  end
  else
    textmemo.StickText := stbottom;
end;

procedure TSharpConsoleWnd.FormCreate(Sender: TObject);
begin
  pagRoLog.Show;
  tlLog.TabIndex := 0;
  
  SystemParametersInfo(SPI_GETDRAGFULLWINDOWS, 0, @bDragFullWindows, 0);
  Playing := True;
  application.OnRestore := SharpConsoleWnd.Restore;
  TextMemo := TFatMemo.Create(pagRoLog);
  TextMemo.Font.name := 'segoe ui';
  TextMemo.Font.size := 8;
  TextMemo.Color := clWhite;
  TextMemo.BorderStyle := bsNone;
  //TextMemo.ParentFont := True;
  TextMemo.Width := SharpConsoleWnd.Width - 13;
  TextMemo.Height := SharpConsoleWnd.height - 66;
  TextMemo.Align := alClient;
  TextMemo.PopupMenu := PopupMenu;
  TextMemo.ScrollBarVert := true;
  TextMemo.ScrollBarHoriz := false;
  TextMemo.OnLinkClick := SharpConsoleWnd.TextMemoLinkClick;
  TextMemo.OnScrollVert := SharpConsoleWnd.TextMemoScrollVert;
  TextMemo.StickText := stTop;
  TextMemo.maxLines := 2000;
  TextMemo.Lines.Clear;
  Textmemo.ShowHint := true;
  Textmemo.LineHeight := 15;
  TextMemo.TopIndex := 0;
  DebugList.OnUpdate := UpdateLog;
  paused := false;
  bMoveMouse := false;
  FNotChecked := TStringList.Create;
  DeleteHistory;

  try

    DrawText('<b>SharpE Debug Console</b>', clMessage, DMT_NONE, 9);
    DrawText('Copyright © 2005 SharpE-Shell.org Team', clMessage, DMT_NONE, 0);

  except
    SendConsoleErrorMessage('Problem in start of program');
  end;

  Application.OnHint := ShowToolBarHint;
end;

procedure TSharpConsoleWnd.FormPaint(Sender: TObject);
begin
  textmemo.Paint;
end;

procedure TSharpConsoleWnd.ThrobberbuttonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  try
    popupmenu.Popup(SharpConsoleWnd.Left + 10, SharpConsoleWnd.top + 12);
  except
    SendConsoleErrorMessage('Problem showing popupmenu.');
  end;
end;

procedure TSharpConsoleWnd.SizeButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  try
    oldMousePoint := point(x, y);
    bMoveMouse := true;
    bHaveMoved := false;
    ReleaseCapture;
    SystemParametersInfo(SPI_GETDRAGFULLWINDOWS, 0, @bDragFullWindows, 0);
    SystemParametersInfo(SPI_SETDRAGFULLWINDOWS, 0, nil, 0);
    PostMessage(SharpConsoleWnd.Handle, wm_SysCommand, SC_SIZE, 0);
    PostMessage(SharpConsoleWnd.Handle, wm_KEYDOWN, vk_DOWN, 0);
    PostMessage(SharpConsoleWnd.Handle, wm_KEYDOWN, vk_RIGHT, 0);
  except
    SendConsoleErrorMessage('Problem rezizeButton.');
  end;
end;

procedure TSharpConsoleWnd.ThrobberMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(SharpConsoleWnd.Handle, wm_SysCommand, $F012, 0);
end;

procedure TSharpConsoleWnd.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  // non documented constant found with Winsight
  SC_DRAGMOVE = $F012;
begin
  if (Button = mbLeft) then begin
    ReleaseCapture;
    (Self as TControl).Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TSharpConsoleWnd.Delete1Click(Sender: TObject);
begin
  DeleteHistory;
end;

procedure TSharpConsoleWnd.GetCopyData(var Msg: TMessage);
var
  cmsg: TConsoleMsg;
  t2: string;
begin
  cmsg := PConsoleMsg(PCopyDataStruct(msg.lParam)^.lpData)^;

  // Extract the manager Cmd to use
  t2 := cmsg.msg;

  // Output text to file
  case msg.wParam of
    DMT_INFO: Debugging.INFO(removetags(t2));
    DMT_STATUS: Debugging.INFO(removetags(t2));
    DMT_WARN: Debugging.WARN(removetags(t2));
    DMT_ERROR: Debugging.ERROR(removetags(t2));
    DMT_TRACE: Debugging.INFO(removetags(t2));
  end;

  if msg.wParam <> DMT_ERROR then
    debuglist.Add(now, msg.wParam, ExtractModuleName(RemoveTags(t2)), t2)
  else
    debuglist.Add(now, msg.wParam, ExtractModuleName(RemoveTags(t2)), '<FONT COLOR=$0000FF>' +
      RemoveTags(t2));
end;

function ExtractModuleName(text: string): string;
var
  strl: TStringList;
begin
  Strl := TStringList.Create;
  StrTokenToStrings(text, ':', strl);
  if Strl.Count >= 1 then
    Result := strl.Strings[0]
  else
    Result := '';
end;

procedure TSharpConsoleWnd.UpdateLog(Sender: TObject);
var
  errorstr: string;
begin
  // Update the available modules
  UpdateModulesList;

  // Draw the text
  case TInfo(Sender).ErrorType of
    DMT_INFO: errorstr := 'INFO';
    DMT_STATUS: errorstr := 'STATUS';
    DMT_WARN: errorstr := 'WARN';
    DMT_ERROR: errorstr := 'ERROR';
    DMT_TRACE: errorstr := 'TRACE';
  end;

  if Playing then begin
    if not (IsModuleNotChecked(errorstr)) then begin
      if not (IsModuleNotChecked(TInfo(Sender).Module)) then begin

        DrawText(TInfo(Sender).MessageText, clnone, TInfo(Sender).ErrorType,
          TInfo(Sender).DTLogged);

        mmoCopy.Lines.Add(Format('%s : %s',
          [FormatDateTime('hh:nn:ss dd/mm/yy', TInfo(Sender).DTLogged),
          RemoveTags(TInfo(Sender).MessageText)]));

        // Update Icon
        ConsoleFlashInc := 0;
        tiMain.Icon := TrayFlash.Picture.Icon;

        tmrRevertNorm.Enabled := True;
      end;
    end;
  end;

end;

procedure TSharpConsoleWnd.SelectAll1Click(Sender: TObject);
var
  i, n: integer;
begin
  if IsModuleWndClicked then begin
    for i := 0 to clbModuleList.items.count - 1 do begin
      clbModuleList.Checked[i] := cbChecked;
      n := FNotChecked.IndexOf(clbModuleList.Items[i]);
      if n <> -1 then
        FNotChecked.Delete(n);
    end;
  end
  else if not (IsModuleWndClicked) then
    for i := 0 to clbDebugLevel.items.count - 1 do
      clbDebugLevel.Checked[i] := cbChecked;

  RefreshDebugList
end;

procedure TSharpConsoleWnd.UpdateModulesList;
var
  i: integer;
  strl: tstringlist;
begin
  // Update available modules
  strl := TStringList.Create;
  strl.Sorted := True;
  Strl.Duplicates := dupIgnore;

  for i := 0 to DebugList.Count - 1 do
    strl.Add(DebugList.Info[i].Module);

  clbModuleList.items.BeginUpdate;
  clbModuleList.Items.Clear;
  for i := 0 to strl.Count - 1 do begin
    clbModuleList.AddItem(strl.Strings[i], nil);

    clbModuleList.Checked[i] := cbChecked;
    if IsModuleNotChecked(strl.Strings[i]) then
      clbModuleList.Checked[i] := cbUnchecked;
  end;
  strl.Free;
  clbModuleList.Items.endupdate;
end;

procedure TSharpConsoleWnd.Infi1Click(Sender: TObject);
var
  i: integer;
begin
  if IsModuleWndClicked then begin
    FNotChecked.Clear;
    for i := 0 to clbModuleList.items.count - 1 do begin
      clbModuleList.Checked[i] := cbUnchecked;
      if FNotchecked.IndexOf(clbModuleList.Items.Strings[i]) = -1 then
        FNotChecked.Add(clbModuleList.Items.Strings[i])
    end;
  end
  else if not (IsModuleWndClicked) then
    for i := 0 to clbDebugLevel.items.count - 1 do
      clbDebugLevel.Checked[i] := cbUnchecked;
  RefreshDebugList;
end;

function TSharpConsoleWnd.IsModuleNotChecked(Module: string): Boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to Pred(FNotChecked.Count) do begin
    if lowercase(FNotChecked.Strings[i]) = lowercase(Module) then begin
      Result := True;
      Exit;
    end;
  end;

end;

procedure TSharpConsoleWnd.RemoveNotChecked(Module: string);
var
  i: integer;
begin
  for i := FNotChecked.Count - 1 downto 0 do begin
    if FNotChecked.Strings[i] = Module then
      FNotChecked.Delete(i);
  end;
end;

procedure TSharpConsoleWnd.clbModuleList_ClickCheck(Sender: TObject);
var
  index: integer;
begin
  index := clbModuleList.ItemIndex;
  if clbModuleList.Checked[index] = cbUnchecked then
    FNotChecked.Add(clbModuleList.Items.Strings[index])
  else
    RemoveNotChecked(clbModuleList.Items.Strings[index]);

  if chkRefreshModules.Checked then
    RefreshDebugList;
end;

procedure TSharpConsoleWnd.DeleteHistory;
var
  i: integer;
begin
  TextMemo.Lines.Clear;

  for i := DebugList.Count - 1 downto 0 do
    DebugList.Delete(i);

  clbDebugLevel.Clear;
  with clbDebugLevel do begin
    Items.Add('Error');
    Items.Add('Info');
    Items.Add('Trace');
    Items.Add('Warning');
    Items.Add('Status');

    for i := 0 to 4 do begin
      clbDebugLevel.Checked[i] := cbChecked;
      if IsModuleNotChecked(clbDebugLevel.items.Strings[i]) then
        clbDebugLevel.Checked[i] := cbUnchecked;
    end;
  end;

  FNotChecked.Clear;
  UpdateModulesList;

end;

procedure TSharpConsoleWnd.clbDebugLevel_ClickCheck(Sender: TObject);
var
  index: integer;
begin
  index := clbDebugLevel.ItemIndex;
  if Index = -1 then exit;

  if clbDebugLevel.Checked[index] = cbUnchecked then
    FNotChecked.Add(clbDebugLevel.Items.Strings[index])
  else
    RemoveNotChecked(clbDebugLevel.Items.Strings[index]);

  if chkRefreshDebug.Checked then
    RefreshDebugList;
end;

procedure TSharpConsoleWnd.tbRefreshClick(Sender: TObject);
begin
  RefreshDebugList;
end;

procedure TSharpConsoleWnd.Timer1Timer(Sender: TObject);
begin
  if TextMemo.Lines.Count = 0 then
    TextMemo.Visible := False
  else
    TextMemo.Visible := True;

  sbMain.Panels.Items[0].Text := Format('History %d', [DebugList.Count]);
  sbMain.Panels.Items[1].Text := Format('Visible %d', [TextMemo.Lines.Count]);

  if Playing then
    sbMain.Panels.Items[2].Text := 'Status: Active, automatic refresh'
  else
    sbMain.Panels.Items[2].Text := 'Status: Paused, manual refresh';
end;

procedure TSharpConsoleWnd.RefreshDebugList;
var
  i,nDiv,n : integer;
  errorstr: string;
begin
  prgRefresh.Show;
  prgRefresh.Position := 0;
  prgRefresh.Max := 100;

  TextMemo.Lines.Clear;
  mmoCopy.Lines.Clear;

  if tlLog.TabIndex = 0 then
    TextMemo.Hide;

  n := DebugList.Count div 10;
  nDiv := n;
  for i := 0 to DebugList.Count - 1 do begin

    if i = n then begin
      prgRefresh.Position := prgRefresh.Position + 10;
      n := n + nDiv;
    end;

    if i >= DebugList.Count-1 then
      prgRefresh.Position := 100;

    // Draw the text
    case DebugList.Info[i].ErrorType of
      DMT_INFO: errorstr := 'INFO';
      DMT_STATUS: errorstr := 'STATUS';
      DMT_WARN: errorstr := 'WARN';
      DMT_ERROR: errorstr := 'ERROR';
      DMT_TRACE: errorstr := 'TRACE';
    end;

    if not (IsModuleNotChecked(errorstr)) then begin
      if not (IsModuleNotChecked(DebugList.Info[i].Module)) then begin
        DrawText(DebugList.Info[i].MessageText, clnone,
          DebugList.Info[i].ErrorType, DebugList.Info[i].DTLogged);

        mmoCopy.Lines.Add(Format('%s : %s',
          [FormatDateTime('hh:nn:ss dd/mm/yy', DebugList.Info[i].DTLogged),
          RemoveTags(DebugList.Info[i].MessageText)]));
      end;
    end;
  end;

  if tlLog.TabIndex = 0 then
    TextMemo.Show;

  prgRefresh.Hide;
end;

procedure TSharpConsoleWnd.chkRefreshListClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    RefreshDebugList;
end;

procedure TSharpConsoleWnd.SaveAllHistory1Click(Sender: TObject);
var
  strl: tstringlist;
  i: integer;
begin
  strl := TStringList.Create;

  for i := 0 to DebugList.count - 1 do begin
    strl.Add(Format('%s : %s',
      [FormatDateTime('hh:nn:ss dd/mm/yy', DebugList.Info[i].DTLogged),
      RemoveTags(DebugList.Info[i].MessageText)]));
  end;

  if dlgSaveFile.Execute then
    strl.SaveToFile(dlgSaveFile.FileName);

  Strl.Free;

end;

procedure TSharpConsoleWnd.SaveVisible1Click(Sender: TObject);
var
  strl: tstringlist;
  i: integer;
  errorstr: string;
begin
  strl := TStringList.Create;

  for i := 0 to DebugList.count - 1 do begin
    // Draw the text
    case DebugList.Info[i].ErrorType of
      DMT_INFO: errorstr := 'INFO';
      DMT_STATUS: errorstr := 'STATUS';
      DMT_WARN: errorstr := 'WARN';
      DMT_ERROR: errorstr := 'ERROR';
      DMT_TRACE: errorstr := 'TRACE';
    end;

    if not (IsModuleNotChecked(errorstr)) then begin
      if not (IsModuleNotChecked(DebugList.Info[i].Module)) then begin
        strl.Add(Format('%s : %s',
          [FormatDateTime('hh:nn:ss dd/mm/yy', DebugList.Info[i].DTLogged),
          RemoveTags(DebugList.Info[i].MessageText)]));
      end;
    end;
  end;

  if dlgSaveFile.Execute then
    strl.SaveToFile(dlgSaveFile.FileName);

  Strl.Free;

end;

procedure TSharpConsoleWnd.ClearAll1Click(Sender: TObject);
begin
  TextMemo.Lines.Clear;
  mmoCopy.Lines.Clear;
end;
procedure TSharpConsoleWnd.tbCopyTextClick(Sender: TObject);
var
  strl: tstringlist;
  i: integer;
  errorstr: string;
begin
  strl := TStringList.Create;

  for i := 0 to DebugList.count - 1 do begin
    // Draw the text
    case DebugList.Info[i].ErrorType of
      DMT_INFO: errorstr := 'INFO';
      DMT_STATUS: errorstr := 'STATUS';
      DMT_WARN: errorstr := 'WARN';
      DMT_ERROR: errorstr := 'ERROR';
      DMT_TRACE: errorstr := 'TRACE';
    end;

    if not (IsModuleNotChecked(errorstr)) then begin
      if not (IsModuleNotChecked(DebugList.Info[i].Module)) then begin
        strl.Add(Format('%s : %s',
          [FormatDateTime('hh:nn:ss dd/mm/yy', DebugList.Info[i].DTLogged),
          RemoveTags(DebugList.Info[i].MessageText)]));
      end;
    end;
  end;

  Clipboard.AsText := strl.Text;
  Strl.Free;

end;

procedure TSharpConsoleWnd.tiMainDblClick(Sender: TObject);
begin
  Application.Restore;
  SharpConsoleWnd.Show;
end;

procedure TSharpConsoleWnd.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TSharpConsoleWnd.ShowToolBarHint(Sender: TObject);
begin
  sbMain.Panels.Items[2].Text := Application.Hint;
end;

procedure TSharpConsoleWnd.clbModuleList_Click(Sender: TObject);
begin
  IsModuleWndClicked := True;
end;

procedure TSharpConsoleWnd.clbDebugLevel_Click(Sender: TObject);
begin
  IsModuleWndClicked := False;
end;

procedure TSharpConsoleWnd.clbDebugLevel_MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  IsModuleWndClicked := False;
end;

procedure TSharpConsoleWnd.clbModuleList_MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  IsModuleWndClicked := True;
end;

procedure TSharpConsoleWnd.tbPauseClick(Sender: TObject);
begin
  if tbPause.ImageIndex = 9 then begin // pause
    tbPause.ImageIndex := 10;
    tbPause.Caption := 'Auto';
    SharpConsoleWnd.Caption := 'SharpConsole';
    Playing := True;
    exit;
  end
  else begin
    tbPause.ImageIndex := 9;
    tbPause.Caption := 'Manual';
    SharpConsoleWnd.Caption := 'SharpConsole (Paused)';
    Playing := False;
    exit;
  end;
end;

procedure TSharpConsoleWnd.tmrRevertNormTimer(Sender: TObject);
begin
  Inc(ConsoleFlashInc);
  If ConsoleFlashInc = 10 then begin
    tiMain.Icon := TrayMain.Picture.Icon;
    tmrRevertNorm.Enabled := False;
    ConsoleFlashInc := 0;
  end;
end;

procedure TSharpConsoleWnd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caNone;
  Hide;
end;

procedure TSharpConsoleWnd.tlLogTabChange(ASender: TObject;
  const ATabIndex: Integer; var AChange: Boolean);
begin
  if plMain <> nil then
    plMain.ActivePageIndex := ATabIndex;
end;

procedure TSharpConsoleWnd.Restore(Sender: TObject);
begin
  SetWindowpos(SharpConsoleWnd.handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or
      SWP_NOMOVE or SWP_NOREDRAW);
end;

procedure TSharpConsoleWnd.clbModuleListClick(Sender: TObject);
var
  index: integer;
begin
  index := clbModuleList.ItemIndex;
  if clbModuleList.Checked[index] = cbUnchecked then
    FNotChecked.Add(clbModuleList.Items.Strings[index])
  else
    RemoveNotChecked(clbModuleList.Items.Strings[index]);

  if chkRefreshModules.Checked then
    RefreshDebugList;
end;

procedure TSharpConsoleWnd.clbDebugLevelClick(Sender: TObject);
var
  index: integer;
begin
  index := clbDebugLevel.ItemIndex;
  if Index = -1 then exit;

  if clbDebugLevel.Checked[index] = cbUnchecked then
    FNotChecked.Add(clbDebugLevel.Items.Strings[index])
  else
    RemoveNotChecked(clbDebugLevel.Items.Strings[index]);

  if chkRefreshDebug.Checked then
    RefreshDebugList; 
end;

end.

