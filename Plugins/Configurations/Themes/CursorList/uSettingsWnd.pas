{
Source Name: uIconeListWnd.pas
Description: Icon List Window
Copyright (C) Martin KrÃ¤mer (MartinKraemer@gmx.net)

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

unit uSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JclSimpleXml, JclFileUtils,
  ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx,GR32, GR32_PNG, pngimage, PngFunctions, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpGraphicsUtils, SharpIconUtils,
  SharpEColorEditorEx, SharpESwatchManager,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TCursor = class(TObject)
  private
    FIsValid, FHasAlpha, FIsCursor, FReplaceColor : boolean;
    FWidth, FHeight: integer;
    FCurFrame, FNumFrames: integer;
    FBitmap, FCurBitmap: TBitmap32;

  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure ReplaceColors(ccolors : TSharpEColorEditorEx);
    procedure Load(path: string);

    function GetBitmap(): TBitmap32;

    // Properties
    property IsValid: boolean read FIsValid;
    property HasAlpha: boolean read FHasAlpha;
    property IsCursor: boolean read FIsCursor;

    property ReplaceColor: boolean read FReplaceColor write FReplaceColor;

    property Width: integer read FWidth write FWidth;
    property Height: integer read FHeight write FHeight;

    property NumFrames: integer read FNumFrames write FNumFrames;
    property CurFrame: integer read FCurFrame;

    property Bitmap: TBitmap32 read GetBitmap;
  end;

  TfrmSettingsWnd = class(TForm)
    lbCursorList: TSharpEListBoxEx;
    SharpESwatchManager1: TSharpESwatchManager;
    tmr: TTimer;
    PngImageList1: TPngImageList;
    ccolors: TSharpEColorEditorEx;

    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbCursorListClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbCursorListResize(Sender: TObject);
    procedure ccolorsUiChange(Sender: TObject);
    procedure tmrOnTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbCursorListGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbCursorListGetCellImageIndex(Sender: TObject;
      const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);

  private
    FPluginHost: ISharpCenterHost;
    FPreview: TBitmap32;
    FCursor: string;
    FNames: Array of string;

    AnimTimer: TTimer;

    procedure AnimOnTimer(Sender: TObject);
    procedure BuildCursorPreview;
  public
    procedure BuildCursorList;
    procedure SendUpdate;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;

    property Cursor: string read FCursor write FCursor;
    property Preview: TBitmap32 read FPreview write FPreview;
  end;

var
  frmSettingsWnd: TfrmSettingsWnd;

  CursorItemArray: array of TCursor;

implementation

uses SharpThemeApiEx,
     SharpCenterApi;

{$R *.dfm}

{ TCursor }
constructor TCursor.Create;
begin
  inherited;

  FIsValid := false;
  FHasAlpha := false;
  FIsCursor := false;
  FReplaceColor := false;

  FCurFrame := 0;
  FNumFrames := 0;
  FWidth := 0;
  FHeight := 0;

  FBitmap := TBitmap32.Create;
  FCurBitmap := TBitmap32.Create;
end;

destructor TCursor.Destroy;
begin
  FBitmap.Free;
  FCurBitmap.Free;

  inherited;
end;

procedure TCursor.ReplaceColors(ccolors : TSharpEColorEditorEx);
begin
  // Replace the colors
  if (FReplaceColor) and (not FIsCursor) then
  begin
    if FHasAlpha <> true then
      ReplaceColor32(FBitmap, color32(0,0,0,255), color32(0,0,0,0));
      
    ReplaceColor32(FBitmap, color32(255,0,0,255), color32(ccolors.Items.Item[0].ColorAsTColor));
    ReplaceColor32(FBitmap, color32(0,0,255,255), color32(ccolors.Items.Item[1].ColorAsTColor));
    ReplaceColor32(FBitmap, color32(0,255,0,255), color32(ccolors.Items.Item[2].ColorAsTColor));
    ReplaceColor32(FBitmap, color32(255,255,0,255), color32(ccolors.Items.Item[3].ColorAsTColor));
  end;
end;

procedure TCursor.Load(path: string);
var
  hCursor : HICON;
  HasAlpha : boolean;
begin
  FIsValid := false;
  FIsCursor := false;

  hCursor := LoadCursorFromFile(PAnsiChar(path));
  if hCursor <> 0 then
  begin
    try
      FIsValid := true;
      FIsCursor := true;

      IconToImage(FBitmap, hCursor);
      FWidth := FBitmap.Width;
      FHeight := FBitmap.Height;
    except
      FIsValid := false;
    end;
  end else
  begin
    FIsValid := true;

    try
      LoadBitmap32FromPng(FBitmap, path, HasAlpha);
      if (FHasAlpha <> true) and (HasAlpha = true) then
        FHasAlpha := true;
        
    except
      try
        FBitmap.LoadFromFile(path);
      except
        FIsValid := false;
      end;
    end;
  end;
end;

function TCursor.GetBitmap: TBitmap32;
var
  sRect: Windows.TRect;
begin
  if FIsValid then
  begin
    if FIsCursor then
    begin
      Result := FBitmap;
    end else
    begin
      FCurBitmap.DrawMode := dmTransparent;
      FCurBitmap.CombineMode := cmMerge;
      FCurBitmap.SetSize(FWidth, FHeight);
      FCurBitmap.Clear(color32(0,0,0,0));

      sRect := Rect(FWidth * FCurFrame, 0, FWidth + (FWidth * FCurFrame), FHeight);
      FBitmap.DrawTo(FCurBitmap, 0, 0, sRect);

      FCurFrame := FCurFrame + 1;
      if(FCurFrame >= FNumFrames) then
        FCurFrame := 0;
  
      Result := FCurBitmap;
    end;
  end else
    Result := nil;
    
end;


{ TfrmConfigListWnd }

procedure TfrmSettingsWnd.lbCursorListClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
begin
  BuildCursorPreview;
  SendUpdate;
end;

procedure TfrmSettingsWnd.lbCursorListGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
begin
  AImageIndex := 0;
end;

procedure TfrmSettingsWnd.lbCursorListGetCellText(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AColText: string);
var
  colitemTxt, colDescTxt, colBtnTxt: TColor;
  tmp: TStringObject;
begin
  tmp := TStringObject(AItem.Data);
  if tmp = nil then
    exit;

  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  if ACol = 0 then begin
    AColText := format('<font color="%s" />%s',[colorToString(colBtnTxt),tmp.Str]);
  end;
end;

procedure TfrmSettingsWnd.lbCursorListResize(Sender: TObject);
begin
  Self.Height := lbCursorList.Height+ccolors.Height;
end;

procedure TfrmSettingsWnd.SendUpdate;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;

procedure TfrmSettingsWnd.tmrOnTimer(Sender: TObject);
begin
  tmr.Enabled := false;
  BuildCursorList;
end;

procedure TfrmSettingsWnd.FormCreate(Sender: TObject);
begin
  FPreview := TBitmap32.Create;
  lbCursorList.DoubleBuffered := true;
end;

procedure TfrmSettingsWnd.AnimOnTimer(Sender: TObject);
var
  x, y, tX, tY : integer;
  sRect : TRect;
  n : integer;
begin
  LockWindowUpdate(self.Handle);
  try
    FPreview.Clear(color32(0,0,0,0));

    x := 0;
    y := 0;
    for n := 0 to High(CursorItemArray) do
    begin
      sRect := Rect(0, 0, CursorItemArray[n].Width, CursorItemArray[n].Height);

      // Align the cursor
      tX := x;
      if CursorItemArray[n].Width < 32 then
        tX := tX + ((32 div 2) - (CursorItemArray[n].Width div 2));

      tY := y;
      if CursorItemArray[n].Height < 32 then
        tY := tY + ((32 div 2) - (CursorItemArray[n].Height div 2));

      CursorItemArray[n].ReplaceColors(ccolors);
      CursorItemArray[n].Bitmap.DrawTo(FPreview, tX, tY, sRect);

      if CursorItemArray[n].Width < 32 then begin
        x := x + 32;
      end else
        x := x + CursorItemArray[n].Width;

      if x >= (16 * 32) then
      begin
        x := 0;
        y := y + CursorItemArray[n].Height + 3;
      end;
    end;
  finally
    LockWindowUpdate(0);
    PluginHost.Refresh(rtPreview);
  end;
end;


procedure TfrmSettingsWnd.BuildCursorPreview;
const
  IconSize = 32;
var
  x, y, tX, tY : integer;
  Dir : String;
  n : integer;
  PreBmp : TBitmap32;
  sRect : TRect;
  w, h, tW, tH : integer;
  IconCount : integer;

  XML : TJclSimpleXML;
  I, C : integer;
begin
  LockWindowUpdate(self.Handle);
  try
  if (lbCursorList.ItemIndex < 0) or (lbCursorList.Count = 0) then
  begin
    PluginHost.Refresh(rtPreview);
    exit;
  end;

  FCursor := FNames[lbCursorList.ItemIndex];
  Dir := SharpApi.GetSharpeDirectory + 'Cursors\' + FCursor + '\';

  
  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(Dir + 'Skin.xml');

    C := 0;
    with XML.Root.Items do
    begin
      if ItemNamed['SknDef'] <> nil then
      begin
        with ItemNamed['SknDef'].Items do
        begin
          // Set the timer interval
          AnimTimer.Interval := IntValue('AnimInterval', 1000);
          AnimTimer.Enabled := True;
        end;
      end;

      // Old way
      if ItemNamed['CursPoints'] <> nil then
      begin
        with ItemNamed['CursPoints'].Items do
        begin
          for I := 0 to Count - 1 do
          begin
            if FileExists(Dir + AnsiLowerCase(Item[I].Name) + '.bmp') then
            begin
              SetLength(CursorItemArray, C + 1);

              CursorItemArray[C] := TCursor.Create();
              CursorItemArray[C].ReplaceColor := true;
              CursorItemArray[C].Width := 32;
              CursorItemArray[C].Height := 32;
              CursorItemArray[C].NumFrames := 0;
              CursorItemArray[C].Load(Dir + AnsiLowerCase(Item[I].Name) + '.bmp');

              C := C + 1;
            end;
          end;
        end;
      // New way (with animations)
      end else
      begin  
        if ItemNamed['Cursors'] <> nil then
        begin
          with ItemNamed['Cursors'].Items do
          begin
            for I := 0 to Count - 1 do
            begin
              if Item[I] <> nil then
              begin
                with Item[I].Items do
                begin
                  if FileExists(Dir + Value('File', '')) then
                  begin
                    SetLength(CursorItemArray, C + 1);

                    CursorItemArray[C] := TCursor.Create();
                    CursorItemArray[C].ReplaceColor := BoolValue('ReplaceColor', True);
                    CursorItemArray[C].Width := IntValue('Width', 32);
                    CursorItemArray[C].Height := IntValue('Height', 32);
                    CursorItemArray[C].NumFrames := IntValue('NumFrames', 0);
                    CursorItemArray[C].Load(Dir + Value('File', ''));

                    C := C + 1;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    XML.Free;
  end;

  PreBmp := TBitmap32.Create;
  PreBmp.DrawMode := dmBlend;

  {IconCount := length(CursorItemArray);
  w := ((Width - 64) div IconSize) * IconSize;
  h := (IconCount div (w div IconSize) + 1) * IconSize;  }

  // Calculate the width and height of the preview list
  w := 0;
  h := 0;
  tW := 0;
  tH := 0;
  for n := 0 to High(CursorItemArray) do
  begin
    if CursorItemArray[n].Width <= 32 then begin
      tW := tW + 32;
    end else
      tW := tW + CursorItemArray[n].Width;

    if CursorItemArray[n].Height <= 32 then begin
      tH := 32;
    end else
      tH := CursorItemArray[n].Height;

    if (tW + CursorItemArray[n].Width) > (16 * 32) then
    begin
      if w < tW then
        w := tW;

      h := h + tH;

      tW := 0;
      tH := 0;
    end;
  end;

  w := w + tW;
  h := h + tH;

  PreBmp.DrawMode := dmTransparent;
  PreBmp.SetSize(w,h);
  PreBmp.Clear(color32(0,0,0,0));

  x := 0;
  y := 0;
  for n := 0 to High(CursorItemArray) do
  begin
    sRect := Rect(0, 0, CursorItemArray[n].Width, CursorItemArray[n].Height);

    // Align the cursor
    tX := x;
    if CursorItemArray[n].Width < 32 then
      tX := tX + ((32 div 2) - (CursorItemArray[n].Width div 2));

    tY := y;
    if CursorItemArray[n].Height < 32 then
      tY := tY + ((32 div 2) - (CursorItemArray[n].Height div 2));

    CursorItemArray[n].ReplaceColors(ccolors);
    CursorItemArray[n].Bitmap.DrawTo(PreBmp, tX, tY, sRect);

    if CursorItemArray[n].Width < 32 then begin
      x := x + 32;
    end else
      x := x + CursorItemArray[n].Width;

    if x >= (16 * 32) then
    begin
      x := 0;
      y := y + CursorItemArray[n].Height + 3;
    end;
  end;

  FPreview.Assign(PreBmp);

  PreBmp.Free;

  // Hide the colors for cursors that do not support replacing colors.
  ccolors.Visible := CursorItemArray[lbCursorList.ItemIndex].ReplaceColor;

  finally
    LockWindowUpdate(0);
    PluginHost.Refresh(rtPreview);
  end;
end;

procedure TfrmSettingsWnd.BuildCursorList;
var
  newItem:TSharpEListItem;
  sr : TSearchRec;
  Dir : String;
  XML : TJclSimpleXML;
  s, sName, sAuthor:String;
  obj: TStringObject;

  I : integer;
begin
  LockWindowUpdate(Application.Handle);
  lbCursorList.Clear;
  Try
    if Length(CursorItemArray) > 0 then
    begin
      for I := Low(CursorItemArray) to High(CursorItemArray) do
        CursorItemArray[I].Free;

      SetLength(CursorItemArray, 0);
    end;

    XML := TJclSimpleXML.Create;
    try
      if Length(FNames) > 0 then
        SetLength(FNames, 0);

      Dir := SharpApi.GetSharpeDirectory + 'Cursors\';
      I := 0;

      if FindFirst(Dir + '*',FADirectory,sr) = 0 then
      begin
        repeat
          if (CompareText(sr.Name, '.') <> 0) and (CompareText(sr.Name, '..') <> 0) then
          begin
            if FileExists(Dir + sr.Name + '\Skin.xml') then
            begin
              try
                SetLength(FNames, I + 1);
                FNames[I] := sr.Name;

                XML.LoadFromFile(Dir + sr.Name + '\Skin.xml');
                if XML.Root.Items.ItemNamed['SknDef'] <> nil then
                begin
                  with XML.Root.Items do
                  begin
                    obj := TStringObject.Create();

                    // Get the Name and Author
                    sName := ItemNamed['SknDef'].Items.Value('Title','Unknown');
                    sAuthor := ItemNamed['SknDef'].Items.Value('Author','Unknown');
                    s := Format('%s by %s', [sName, sAuthor]);

                    obj.Str := sName;

                    newItem := lbCursorList.AddItem(s);
                    newItem.Data := ( obj );

                    if CompareText(sr.Name,FCursor) = 0 then
                    begin
                      lbCursorList.ItemIndex := I;
                      BuildCursorPreview;
                    end;

                    I := I + 1;
                  end;
                end;
              except
              end;
            end;
          end;
        until FindNext(sr) <> 0;
        FindClose(sr);
      end;
    finally
      XML.Free;
    end;
  Finally
    LockWindowUpdate(0);
  End;

  //PluginHost.Refresh;
end;

procedure TfrmSettingsWnd.FormResize(Sender: TObject);
begin
  BuildCursorPreview;
end;

procedure TfrmSettingsWnd.FormShow(Sender: TObject);
begin
  AnimTimer := TTimer.Create(nil);
  AnimTimer.OnTimer := AnimOnTimer;
  AnimTimer.Enabled := false;

  tmr.Enabled := true;
end;

procedure TfrmSettingsWnd.ccolorsUiChange(Sender: TObject);
begin
  BuildCursorPreview;
  SendUpdate;
end;

procedure TfrmSettingsWnd.FormDestroy(Sender: TObject);
var
  i : integer;
begin
  AnimTimer.Free;
  FPreview.Free;
  SetLength(FNames, 0);

  for i := 0 to High(CursorItemArray) do
    CursorItemArray[i].Free;
  SetLength(CursorItemArray, 0);
end;

end.


