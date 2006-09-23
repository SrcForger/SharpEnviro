{
Source Name: SharpEMiniThrobber
Description: SharpE component for SharpE
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpe-shell.org

This component are using the GR32 library
http://sourceforge.net/projects/graphics32

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

unit SharpEEdit;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  gr32,
  SharpEBase,
  SharpEBaseControls,
  SharpEDefault,
  SharpEScheme,
  SharpESkinManager,
  ExtCtrls,
  math,
  StrTools,
  ShlIntf,
  ActiveX,
  ComObj,
  TranComp;

type
  TSearchListChangeEvent = procedure of object;
  TParentControl = class(TWinControl);

  TSharpEEditText = class(TZ9Edit)
  private
    FStringList: TStringList;
    FSearchListChange: TSearchListChangeEvent;
    FIncSystemFiles:Boolean;
    FIncMRU: Boolean;
    FIncHistory: Boolean;
    FIncCustomStrings: Boolean;
    FOptACOSuggest: Boolean;
    FOptACOAppend: Boolean;
    FOptUpDownKeyDropList: Boolean;
    FOptUseTab: Boolean;
    FOptFilterPrefixes: Boolean;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure SetFStringList(const Value: TStringlist);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure SetAutoComplete;
    property SearchList: TStringlist read FStringList write SetFStringList;

    procedure SearchListChange;
    property OnSearchListChange: TSearchListChangeEvent read FSearchListChange
      write FSearchListChange;

    property IncSystemFiles:Boolean read FIncSystemFiles write FIncSystemFiles;
    property IncMRU:Boolean read FIncMRU write FIncMRU;
    property IncHistory:Boolean read FIncHistory write FIncHistory;
    property IncCustomStrings:Boolean read FIncCustomStrings write FIncCustomStrings;
    property OptACOSuggest: Boolean read FOptACOSuggest write FOptACOSuggest;
    property OptACOAppend: Boolean read FOptACOAppend write FOptACOAppend;
    property OptUpDownKeyDropList: Boolean read FOptUpDownKeyDropList write FOptUpDownKeyDropList;
    property OptUseTab: Boolean read FOptUseTab write FOptUseTab;
    property OptFilterPrefixes: Boolean read FOptFilterPrefixes write FOptFilterPrefixes;
  End;


  TSharpEEdit = class(TCustomSharpEControl)
  private
    FCancel: Boolean;
    FAutoPosition : Boolean;
    FEdit  : TSharpEEditText;
    FMouseOver: Boolean;
    FText: String;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure SetText(Value:String);

    procedure KeyUpEvent(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditExitEvent(Sender:TObject);
    procedure EditEnterEvent(Sender:TObject);
    procedure EditChangeEvent(Sender:TObject);
    procedure SetAutoSize(const Value: Boolean);
  protected
    FAutoSize: boolean;
    procedure Paint; override;
    procedure DrawDefaultSkin(Scheme: TSharpEScheme);
    procedure DrawManagedSkin(Scheme: TSharpEScheme);
    procedure SetEnabled(Value: Boolean); override;
    procedure DoExit; override;
    procedure DoEnter; override;
  public
    procedure UpdateSkin; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetFocus; override;
  published
    property AutoSize: Boolean read FAutosize write SetAutoSize;
    property Anchors;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Constraints;
    property ParentShowHint;
    property ShowHint;
    property SkinManager;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Enabled;
    property Font;
    property Text: String read FText write SetText;
    property Edit: TSharpEEditText read FEdit write FEdit;
    property AutoPosition : Boolean read FAutoPosition write FAutoPosition;
    property OnKeyUp;
  end;

  procedure CopyParentImage(Control: TControl; Dest: TCanvas);

implementation

uses SharpESkinPart, SharpESkin;

procedure TSharpEEditText.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  OnEnter(Self);
end;

procedure TSharpEEditText.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  if not (csDesigning in ComponentState) then begin
    
    Windows.SetFocus(0);
    OnExit(Self);
  end;
end;

procedure TSharpEEditText.SetFStringList(const Value: TStringlist);
begin
  SearchList.Assign(Value);
  SetAutoComplete;
  SearchListChange;
end;

procedure TSharpEEditText.SetAutoComplete;
var
  FAutoComplete: IAutoComplete2;
  FStrings, FSF, FSHist, FSMru: IUnknown;
  om: IObjMgr;
  ACOOptions: Integer;
begin
  // THIS SHIT IS LEAKING! SOMEONE FIX IT! :)
  exit;
  CoInitialize(nil);
  FAutoComplete := CreateComObject(CLSID_AutoComplete) as IAutoComplete2;
  Try


    // creates a "multi-list" that combines several lists
    CoCreateInstance(CLSID_ACLMulti, nil, CLSCTX_INPROC_SERVER, IID_IObjMgr, om);
    FStrings := TEnumString.Create(FStringList) as IUnknown;

    // System Files
    if FIncSystemFiles then begin
      FSF := CreateComObject(CLSID_ACListISF) as IEnumString;
      om.Append(FSF);
    End;

    // MRU
    If FIncMRU then begin
      FSMru := CreateComObject(CLSID_ACLMRU) as IEnumString;
      om.Append(FSMru);
    End;

    // History
    if FIncHistory then begin
      FSHist := CreateComObject(CLSID_ACLHistory) as IEnumString;
      om.Append(FSHist);
    End;

    // Custom Strings
    IF FIncCustomStrings then
      om.Append(FStrings);

    // ACO AutoSuggest
    ACOOptions := 0;
    if FOptACOSuggest then
      ACOOptions := ACOOptions + ACO_AUTOSUGGEST;

    // ACO Append
    if FOptACOAppend then
      ACOOptions := ACOOptions + ACO_AUTOAPPEND;

    // ACO UPDOWNKEYDROPSLIST
    If FOptUpDownKeyDropList then
      ACOOptions := ACOOptions + ACO_UPDOWNKEYDROPSLIST;

    // ACO USE TAB
    If FOptUseTab then
      ACOOptions := ACOOptions + ACO_USETAB;

    // ACO FILTER PREFIXES
    If FOptFilterPrefixes then
      ACOOptions := ACOOptions + ACO_FILTERPREFIXES;

    OleCheck(FAutoComplete.SetOptions(ACOOptions));

    // Assign
    OleCheck(FAutoComplete.Init(Self.Handle, om, nil, nil));

    finally
    FAutoComplete := nil;
    FStrings := nil;
    FSF := nil;
    FSHist := nil;
    FSMru := nil;
    om := nil;
    end;
end;

procedure TSharpEEditText.SearchListChange;
begin
  if Assigned(FSearchListChange) then
    FSearchListChange;
end;

constructor TSharpEEditText.Create(AOwner: TComponent);
begin
  inherited;
  FStringList := TStringList.Create;

  FOptACOSuggest := True;
  FIncSystemFiles := True;
  FIncMRU := True;
  FIncHistory := True;
  FIncCustomStrings := True;

  SearchListChange;
  FStringList.Sorted := true;
  FStringList.Duplicates := dupIgnore;
end;

procedure TSharpEEditText.Loaded;
begin
  inherited;
  SetAutoComplete;
end;

destructor TSharpEEditText.Destroy;
begin
  FStringList.Free;
  inherited;
end;

procedure CopyParentImage(Control: TControl; Dest: TCanvas);
var
  I, Count, X, Y, SaveIndex: Integer;
  DC: HDC;
  R, SelfR, CtlR: TRect;
begin
  if (Control = nil) or (Control.Parent = nil) then Exit;
  Count := Control.Parent.ControlCount;
  DC := Dest.Handle;
{$IFDEF WIN32}
  with Control.Parent do ControlState := ControlState + [csPaintCopy];
  try
{$ENDIF}
    with Control do begin
      SelfR := Bounds(Left, Top, Width, Height);
      X := -Left; Y := -Top;
    end;
    { Copy parent control image }
    SaveIndex := SaveDC(DC);
    try
      SetViewportOrgEx(DC, X, Y, nil);
      IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth,
        Control.Parent.ClientHeight);
      with TParentControl(Control.Parent) do begin
        Perform(WM_ERASEBKGND, DC, 0);
        PaintWindow(DC);
      end;
    finally
      RestoreDC(DC, SaveIndex);
    end;
    { Copy images of graphic controls }
    for I := 0 to Count - 1 do begin
      if Control.Parent.Controls[I] = Control then Break
      else if (Control.Parent.Controls[I] <> nil) and
        (Control.Parent.Controls[I] is TGraphicControl) then
      begin
        with TGraphicControl(Control.Parent.Controls[I]) do begin
          CtlR := Bounds(Left, Top, Width, Height);
          if Bool(IntersectRect(R, SelfR, CtlR)) and Visible then begin
{$IFDEF WIN32}
            ControlState := ControlState + [csPaintCopy];
{$ENDIF}
            SaveIndex := SaveDC(DC);
            try
              SaveIndex := SaveDC(DC);
              SetViewportOrgEx(DC, Left + X, Top + Y, nil);
              IntersectClipRect(DC, 0, 0, Width, Height);
              Perform(WM_PAINT, DC, 0);
            finally
              RestoreDC(DC, SaveIndex);
{$IFDEF WIN32}
              ControlState := ControlState - [csPaintCopy];
{$ENDIF}
            end;
          end;
        end;
      end;
    end;
{$IFDEF WIN32}
  finally
    with Control.Parent do ControlState := ControlState - [csPaintCopy];
  end;
{$ENDIF}
end;

constructor TSharpEEdit.Create;
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csParentBackground];
  ControlStyle := ControlStyle + [csOpaque];

  Self.DoubleBuffered := True;
  Self.Width := 100;
  Self.Height := 17;

  FEdit := TSharpEEditText.Create(self);
  FEdit.Parent := self;
  FEdit.Transparent := True;
  FEdit.Left := 1;
  FEdit.Top := 1;
  FEdit.Width := Width -1;
  FEdit.Height := Height -1;
  FEdit.BorderStyle := bsNone;
  FEdit.Ctl3D := False;
  FEdit.OnEnter := EditEnterEvent;
  FEdit.OnExit := EditExitEvent;
  FEdit.OnChange := EditChangeEvent;


  FEdit.OnKeyUp := KeyUpEvent;
end;

procedure TSharpEEdit.CMFocusChanged(var Message: TCMFocusChanged);
begin
  //showmessage('change');
  {with Message do
    if Sender.Name = TsharpeButton.ClassName then
      FActive := Sender = Self
    else
      FActive := FDefault;
  //SetButtonStyle(FActive); }
  inherited;
end;

procedure TSharpEEdit.EditExitEvent(Sender:TObject);
begin
  DoExit;
end;

procedure TSharpEEdit.EditEnterEvent(Sender:TObject);
begin
  DoEnter;
end;

procedure TSharpEEdit.EditChangeEvent(Sender:TObject);
begin
  //folder completion
    with FEdit.SearchList do begin
      FEdit.SearchList.Clear;
      Duplicates := dupIgnore;
      CaseSensitive := False;
      Sorted := True
    end;

    FEdit.SetAutoComplete;
end;
procedure TSharpEEdit.KeyUpEvent(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Key = VK_RETURN then
    Text := '';

  if Assigned(OnKeyUp) then
    OnKeyUp(Sender,Key,Shift);
end;

destructor TSharpEEdit.Destroy;
begin
  FreeAndNil(FEdit);
  inherited Destroy;
end;

procedure TSharpEEdit.SetEnabled(Value: Boolean);
begin
  inherited;
  UpdateSkin;

  Invalidate;
end;

procedure TSharpEEdit.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  UpdateSkin;
  Invalidate;
end;

procedure TSharpEEdit.SetFocus;
begin
  inherited;

  FEdit.SetFocus;
  FEdit.SelStart := 0;
  FEdit.SelLength := Length(FEdit.Text);
  UpdateSkin;

end;

procedure TSharpEEdit.DoEnter;
begin
  inherited;
  UpdateSkin;
  Invalidate;
end;

procedure TSharpEEdit.DoExit;
begin
  inherited;
  UpdateSkin;
  Invalidate;
end;

procedure TSharpEEdit.SetText(Value:String);
begin
  If FText <> Value then begin
    FText := Value;
    FEdit.Text := Value;
  end;
end;

procedure TSharpEEdit.UpdateSkin;
begin
  paint;

  // Force Invalidate
 // Perform(CM_INVALIDATE, 0, 0);
end;

procedure TSharpEEdit.Paint;
begin
  try
    if Assigned(FManager) then
      DrawManagedSkin(FManager.Scheme)
    else
      DrawDefaultSkin(DefaultSharpEScheme);
  except
  end;

end;

procedure TSharpEEdit.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if (FMouseOver <> True) then
  begin
    FMouseOver := True;
    if not FEdit.Focused then
    begin
      UpdateSkin;
      Invalidate;
    end;
  end;
end;

procedure TSharpEEdit.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if (FMouseOver) then
  begin
    FMouseOver := False;
    if not FEdit.Focused then
    begin
      UpdateSkin;
      Invalidate;
    end;
  end;
end;

procedure TSharpEEdit.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then
    Click;
end;

procedure TSharpEEdit.CMDialogKey(var Message: TCMDialogKey);
begin
  inherited;
end;

procedure TSharpEEdit.CMDialogChar(var Message: TCMDialogChar);
begin
  inherited;
end;

procedure TSharpEEdit.DrawDefaultSkin(Scheme: TSharpEScheme);
var
  CompRect: TRect;
begin
 // with bmp do
  begin
    CompRect := Rect(0, 0, width, height);

    Canvas.Brush.Color := Scheme.GetColorByName('WorkArealight');
    Canvas.FillRect(CompRect);
    CopyParentImage(self,Canvas);
    Frame3D(Canvas, CompRect, Scheme.GetColorByName('WorkAreadark'), Scheme.GetColorByName('WorkArealight'), 1);


    DefaultSharpESkinText.AssignFontTo(FEdit.Font,Scheme);
    //FEdit.Font.Assign(bmp.Font);
    FEdit.Left := 2;
    FEdit.Top := 2;
    FEdit.Width := Width - 2;
    FEdit.Height := Height - 2;
//    DrawMode := dmBlend;
  end;
end;

procedure TSharpEEdit.DrawManagedSkin( Scheme: TSharpEScheme);
var
  CompRect,r : TRect;
  EditRect : TRect;
  bmp : TBitmap32;
begin
  if not Assigned(FManager) then exit;

  CompRect := Rect(0, 0, width, height);

  if FAutoPosition then
     Top := FManager.Skin.EditSkin.SkinDim.YAsInt;

  if FAutoSize then
    begin
      r := FManager.Skin.EditSkin.GetAutoDim(CompRect);
      if (r.Right <> width) or (r.Bottom <> height) then
      begin
        width := r.Right;
        height := r.Bottom;
        Exit;
      end;
    end;

  if FManager.Skin.EditSkin.Valid then
  begin
    try
      bmp := TBitmap32.Create;
      bmp.DrawMode := dmBlend;
      bmp.CombineMode := cmMerge;
      bmp.SetSize(Self.Width, Self.Height);

      bmp.Clear(Color32(0,0,0,0));
      CopyParentImage(self,bmp.Canvas);
      bmp.ResetAlpha(255);

      if Not(Enabled) and not (FManager.Skin.EditSkin.Disabled.Empty) then
      begin
        FManager.Skin.Editskin.Disabled.Draw(bmp,Scheme);
        FManager.Skin.EditSkin.Disabled.SkinText.AssignFontTo(bmp.Font,Scheme);
      end
      else
      if FEdit.Focused and not (FManager.Skin.EditSkin.Focus.Empty) then
      begin
        FManager.Skin.EditSkin.Focus.Draw(bmp, Scheme);
        FManager.Skin.EditSkin.Focus.SkinText.AssignFontTo(bmp.Font,Scheme);
      end
      else if FMouseOver and not (FManager.Skin.EditSkin.Hover.Empty) then
      begin
        FManager.Skin.EditSkin.Hover.Draw(bmp, Scheme);
        FManager.Skin.EditSkin.Hover.SkinText.AssignFontTo(bmp.Font,Scheme);
      end
      else
        begin
          FManager.Skin.Editskin.Normal.Draw(bmp, Scheme);
          FManager.Skin.EditSkin.Normal.SkinText.AssignFontTo(bmp.Font,Scheme);
        end;
     bmp.DrawTo(Canvas.Handle, bmp.BoundsRect, bmp.BoundsRect);

     FEdit.Font.Assign(bmp.Font);
     try
       EditRect.Left := StrToInt(FManager.Skin.EditSkin.EditXOffsets.X);
       EditRect.Top  := StrToInt(FManager.Skin.EditSkin.EditYOffsets.X);
       EditRect.Right := Width - EditRect.Left - StrToInt(FManager.Skin.EditSkin.EditXOffsets.Y);
       EditRect.Bottom := Height - EditRect.Top - StrToInt(FManager.Skin.EditSkin.EditYOffsets.Y);
       FEdit.Left := EditRect.Left;
       FEdit.Top  := EditRect.Top;
       FEdit.Width := EditRect.Right;
       FEdit.Height := EditRect.Bottom;
       FEdit.Color := WinColor(bmp.Pixel[FEdit.Left+1, FEdit.Top+1]);
     except
       FEdit.Left := 2;
       FEdit.Top := 2;
       FEdit.Width := Width - 2;
       FEdit.Height := Height - 2;
     end;
    finally
      FreeAndNil(bmp);
    end;
  end
  else DrawDefaultSkin(DefaultSharpEScheme);
end;

procedure TSharpEEdit.SetAutoSize(const Value: Boolean);
begin
  FAutosize := Value;
  UpdateSkin;
  Invalidate;
end;

end.
