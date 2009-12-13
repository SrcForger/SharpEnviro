{
Source Name: SharpEEdit.pas
Description: SharpE component for SharpE
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit SharpEEdit;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  Forms,
  StdCtrls,
  gr32,
  Graphics,
  SharpEBase,
  SharpEBaseControls,
  SharpEDefault,
  ISharpESkinComponents,
  ExtCtrls,
  math,
  StrTools,
  ShlIntf,
  ActiveX, ShlObj, ComObj,
  TranComp;

const
  IID_IAutoComplete: TGUID = '{00bb2762-6a77-11d0-a535-00c04fd7d062}';
  IID_IAutoComplete2: TGUID = '{EAC04BC0-3791-11d2-BB95-0060977B464C}';
  CLSID_IAutoComplete: TGUID = '{00BB2763-6A77-11D0-A535-00C04FD7D062}';
  IID_IACList: TGUID = '{77A130B0-94FD-11D0-A544-00C04FD7d062}';
  IID_IACList2: TGUID = '{470141a0-5186-11d2-bbb6-0060977b464c}';
  CLSID_ACLHistory: TGUID = '{00BB2764-6A77-11D0-A535-00C04FD7D062}';
  CLSID_ACListISF: TGUID = '{03C036F1-A186-11D0-824A-00AA005B4383}';
  CLSID_ACLMRU: TGUID = '{6756a641-de71-11d0-831b-00aa005b4383}';

const
  {Options for IAutoComplete2}
  ACO_NONE = 0;
  ACO_AUTOSUGGEST = $1;
  ACO_AUTOAPPEND = $2;
  ACO_SEARCH = $4;
  ACO_FILTERPREFIXES = $8;
  ACO_USETAB = $10;
  ACO_UPDOWNKEYDROPSLIST = $20;
  ACO_RTLREADING = $40;

type
  IAutoComplete2 = interface(IAutoComplete)
    ['{EAC04BC0-3791-11d2-BB95-0060977B464C}']
    function SetOptions(dwFlag: DWORD): HResult; stdcall;
    function GetOptions(out pdwFlag: DWORD): HResult; stdcall;
  end;

  TEnumString = class(TInterfacedObject, IEnumString)
  private
    FStrings: TStringList;
    FCurrIndex: integer;
  public
    {IEnumString}
    function Next(celt: Longint; out elt; pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumString): HResult; stdcall;
    {VCL}
    constructor Create;
    destructor Destroy; override;

    property Strings: TStringList read FStrings write FStrings;
  end;

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

  TACOption = (acAutoAppend, acAutoSuggest, acUseArrowKey);
  TACOptions = set of TACOption;
  TACSource = (acsList, acsHistory, acsMRU, acsShell);

  TSharpEEdit = class(TCustomSharpEControl)
  private
    FCancel: Boolean;
    FAutoPosition : Boolean;
    FEdit  : TSharpEEditText;
    FMouseOver: Boolean;
    FText: String;

    // Auto-Complete
    FACList: TEnumString;
    FAutoComplete: IAutoComplete;
    FACEnabled: boolean;
    FACOptions: TACOptions;
    FACSource: TACSource;

    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure SetText(Value:String);

    procedure KeyUpEvent(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure KeyDownEvent(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditExitEvent(Sender:TObject);
    procedure EditEnterEvent(Sender:TObject);
    procedure EditChangeEvent(Sender:TObject);
    procedure SetAutoSizeProperty(const Value: Boolean);

    // Auto-Complete
    function GetACStrings: TStringList;
    procedure SetACStrings(const Value: TStringList);
    procedure SetACEnabled(const Value: boolean);
    procedure SetACOptions(const Value: TACOptions);
    procedure SetACSource(const Value: TACSource);
    
  protected
    FAutoSize: boolean;
    procedure Paint; override;
    procedure DrawDefaultSkin(Scheme: ISharpEScheme);
    procedure DrawManagedSkin(Scheme: ISharpEScheme);
    procedure SetEnabled(Value: Boolean); override;
    procedure DoExit; override;
    procedure DoEnter; override;

    procedure CreateWnd; override;
    procedure DestroyWnd; override;
  public
    procedure UpdateSkin; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetFocus; override;
    
    property ACItems: TStringList read GetACStrings write SetACStrings;
  published
    property AutoSize: Boolean read FAutosize write SetAutoSizeProperty;
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
    property OnKeyDown;

    property ACEnabled: boolean read FACEnabled write SetACEnabled;
    property ACOptions: TACOptions read FACOptions write SetACOptions;
    property ACSource: TACSource read FACSource write SetACSource;
  end;

procedure CopyParentImage(Control: TControl; Dest: TCanvas);

implementation

{ TEnumString }
constructor TEnumString.Create;
begin
  inherited Create;
  FStrings := TStringList.Create;
  FCurrIndex := 0;
end;

function TEnumString.Clone(out enm: IEnumString): HResult;
begin
  Result := E_NOTIMPL;
  pointer(enm) := nil;
end;

destructor TEnumString.Destroy;
begin
  FStrings.Free;
  inherited;
end;

function TEnumString.Next(celt: Integer; out elt; pceltFetched: PLongint): HResult;
var
  I: Integer;
  wStr: WideString;
begin
  I := 0;
  while (I < celt) and (FCurrIndex < FStrings.Count) do
  begin
    wStr := FStrings[FCurrIndex];
    TPointerList(elt)[I] := CoTaskMemAlloc(2 * (Length(wStr) + 1));
    StringToWideChar(wStr, TPointerList(elt)[I], 2 * (Length(wStr) + 1));
    Inc(I);
    Inc(FCurrIndex);
  end;
  if pceltFetched <> nil then
    pceltFetched^ := I;
  if I = celt then
    Result := S_OK
  else
    Result := S_FALSE;
end;

function TEnumString.Reset: HResult;
begin
  FCurrIndex := 0;
  Result := S_OK;
end;

function TEnumString.Skip(celt: Integer): HResult;
begin
  if (FCurrIndex + celt) <= FStrings.Count then
  begin
    Inc(FCurrIndex, celt);
    Result := S_OK;
  end
  else
  begin
    FCurrIndex := FStrings.Count;
    Result := S_FALSE;
  end;
end;

{ TSharpEEditText }
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
  SearchListChange;
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

{ TSharpEEdit }
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
  FEdit.OnKeyDown := KeyDownEvent;

  FACList := TEnumString.Create;
  FACEnabled := true;
  FACOptions := [acAutoAppend, acAutoSuggest, acUseArrowKey];
end;

destructor TSharpEEdit.Destroy;
begin
  FreeAndNil(FEdit);
  FACList := nil;
  inherited Destroy;
end;

procedure TSharpEEdit.CreateWnd;
var
  Dummy: IUnknown;
  Strings: IEnumString;
begin
  inherited;

  if HandleAllocated then
  begin
    try
      Dummy := CreateComObject(CLSID_IAutoComplete);
      if (Dummy <> nil) and (Dummy.QueryInterface(IID_IAutoComplete, FAutoComplete) =
        S_OK) then
      begin
        case FACSource of
          acsHistory:
            Strings := CreateComObject(CLSID_ACLHistory) as IEnumString;
          acsMRU:
            Strings := CreateComObject(CLSID_ACLMRU) as IEnumString;
          acsShell:
            Strings := CreateComObject(CLSID_ACListISF) as IEnumString;
        else
          Strings := FACList as IEnumString;
        end;
        if S_OK = FAutoComplete.Init(edit.Handle, Strings, nil, nil) then
        begin
          SetACEnabled(FACEnabled);
          SetACOptions(FACOptions);
        end;
      end;
    except
      {CLSID_IAutoComplete is not available}
    end;
  end;
end;

procedure TSharpEEdit.DestroyWnd;
begin
  if (FAutoComplete <> nil) then
  begin
    FAutoComplete.Enable(false);
    FAutoComplete := nil;
  end;

  inherited;
end;

procedure TSharpEEdit.CMFocusChanged(var Message: TCMFocusChanged);
begin
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
end;

procedure TSharpEEdit.KeyDownEvent(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Assigned(OnKeyDown) then
     OnKeyDown(Sender,Key,Shift);
end;

procedure TSharpEEdit.KeyUpEvent(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if CompareStr(Text,FEdit.Text) <> 0 then FEdit.Text := Text;
  end else if CompareStr(Text,FEdit.Text) <> 0 then Text := FEdit.Text;

  if Assigned(OnKeyUp) then
    OnKeyUp(Sender,Key,Shift);

  if Key = VK_RETURN then
     Text := '';
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
//  If FText <> Value then begin
    FText := Value;
    FEdit.Text := Value;
//  end;
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

procedure TSharpEEdit.DrawDefaultSkin(Scheme: ISharpEScheme);
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


    SharpEDefault.AssignDefaultFontTo(FEdit.Font);
    //FEdit.Font.Assign(bmp.Font);
    FEdit.Left := 2;
    FEdit.Top := 2;
    FEdit.Width := Width - 2;
    FEdit.Height := Height - 2;
//    DrawMode := dmBlend;
  end;
end;

procedure TSharpEEdit.DrawManagedSkin(Scheme: ISharpEScheme);
var
  CompRect,r : TRect;
  EditRect : TRect;
  bmp : TBitmap32;
  SkinText : ISharpESkinText;
begin
  if (not Assigned(FManager)) or (Width = 0) or (Height = 0) then exit;

  CompRect := Rect(0, 0, width, height);

  if FAutoPosition then
     if Top <> FManager.Skin.Edit.Dimension.Y then
        Top := FManager.Skin.Edit.Dimension.Y;

  if FAutoSize then
    begin
      r := FManager.Skin.Edit.GetAutoDim(CompRect);
      if (r.Right <> width) or (r.Bottom <> height) then
      begin
        width := r.Right;
        height := r.Bottom;
        Exit;
      end;
    end;

  if FManager.Skin.Edit.Valid then
  begin
    try
      bmp := TBitmap32.Create;
      bmp.DrawMode := dmBlend;
      bmp.CombineMode := cmMerge;
      bmp.SetSize(Self.Width, Self.Height);

      bmp.Clear(Color32(0,0,0,0));
      CopyParentImage(self,bmp.Canvas);
      bmp.ResetAlpha(255);

      if FEdit.Focused and not (FManager.Skin.Edit.Focus.Empty) then
      begin
        FManager.Skin.Edit.Focus.DrawTo(bmp, Scheme);
        SkinText := FManager.Skin.Edit.Focus.CreateThemedSkinText;
        SkinText.AssignFontTo(bmp.Font,Scheme);
      end
      else if FMouseOver and not (FManager.Skin.Edit.Hover.Empty) then
      begin
        FManager.Skin.Edit.Hover.DrawTo(bmp, Scheme);
        SkinText := FManager.Skin.Edit.Hover.CreateThemedSkinText;
        SkinText.AssignFontTo(bmp.Font,Scheme);        
      end
      else
        begin
          FManager.Skin.Edit.Normal.DrawTo(bmp, Scheme);
          SkinText := FManager.Skin.Edit.Normal.CreateThemedSkinText;
          SkinText.AssignFontTo(bmp.Font,Scheme);
        end;
     bmp.DrawTo(Canvas.Handle, bmp.BoundsRect, bmp.BoundsRect);

     FEdit.Font.Assign(bmp.Font);
     try
       EditRect.Left := FManager.Skin.Edit.EditXOffsets.X;
       EditRect.Top  := FManager.Skin.Edit.EditYOffsets.X;
       EditRect.Right := Width - EditRect.Left - FManager.Skin.Edit.EditXOffsets.Y;
       EditRect.Bottom := Height - EditRect.Top - FManager.Skin.Edit.EditYOffsets.Y;
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
      SkinText := nil;
      FreeAndNil(bmp);
    end;
  end
  else DrawDefaultSkin(DefaultSharpEScheme);
end;

procedure TSharpEEdit.SetAutoSizeProperty(const Value: Boolean);
begin
  FAutosize := Value;
  UpdateSkin;
  Invalidate;
end;

function TSharpEEdit.GetACStrings: TStringList;
begin
  Result := FACList.Strings;
end;

procedure TSharpEEdit.SetACStrings(const Value: TStringList);
begin
  FACList.Strings := Value;
end;

procedure TSharpEEdit.SetACEnabled(const Value: boolean);
begin
  if (FAutoComplete <> nil) then
  begin
    FAutoComplete.Enable(FACEnabled);
  end;
  FACEnabled := Value;
end;

procedure TSharpEEdit.SetACOptions(const Value: TACOptions);
const
  Options: array[TACOption] of integer = (ACO_AUTOAPPEND, ACO_AUTOSUGGEST,
    ACO_UPDOWNKEYDROPSLIST);
var
  Option: TACOption;
  Opt: DWORD;
  AC2: IAutoComplete2;
begin
  if (FAutoComplete <> nil) then
  begin
    if S_OK = FAutoComplete.QueryInterface(IID_IAutoComplete2, AC2) then
    begin
      Opt := ACO_NONE;
      for Option := Low(Options) to High(Options) do
      begin
        if (Option in FACOptions) then
          Opt := Opt or DWORD(Options[Option]);
      end;
      AC2.SetOptions(Opt);
    end;
  end;
  FACOptions := Value;
end;

procedure TSharpEEdit.SetACSource(const Value: TACSource);
begin
  if FACSource <> Value then
  begin
    FACSource := Value;
    RecreateWnd;
  end;
end;

end.
