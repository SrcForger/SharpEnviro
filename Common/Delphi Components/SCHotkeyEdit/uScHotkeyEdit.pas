unit uScHotkeyEdit;

interface

uses
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Contnrs,
  Windows,
  VKToString,
  uScHotkeyMgr,
  inifiles,
  jclinifiles;

type
  TCustomScHotkeyEdit = class(TCustomEdit)
  private
    FKey: string;
    FModifier: TScModifier;
    procedure SetKey(const Value: string);
    procedure SetModifier(const Value: TScModifier);
    function GetKeyCode: Integer;
  public
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure SetHotkeyText(Key: string; Modifiers: TScModifier);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    constructor Create(Owner:TComponent); override;
  published
    property Modifier: TScModifier read FModifier write SetModifier;
    property Key: string read FKey write SetKey;
    property Keycode: Integer read GetKeyCode;
  end;

type
  TScHotkeyEdit = class(TCustomScHotkeyEdit)
  private
  public
  published
    property Modifier;
    property Key;
    property OnChange;
    property OnKeyUp;
    //property Text;
  end;

procedure Register;

implementation

{ TCustomScHotkeyEdit }

procedure Register;
begin
  RegisterComponents('SharpE', [TScHotkeyEdit]);
end;

constructor TCustomScHotkeyEdit.Create(Owner:TComponent);
begin
  inherited;
  Self.DoubleBuffered := True;
  Self.Font.Color := clDkGray;
end;

function TCustomScHotkeyEdit.GetKeyCode: Integer;
var
  vkc: TVKToString;
begin
  vkc := TVKToString.Create;
  vkc.VKey := Key;
  Result := vkc.AsAscii;
end;

procedure TCustomScHotkeyEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  vkc: TVKToString;
  skey: string;
  modf: TScModifier;
begin
  vkc := TVKToString.Create;
  vkc.VKey := InttoStr(Key);
  Self.Font.Color := clHighlight;
  modf := [];
  HideCaret(Self.Handle);
  try
    Tlabel(self).Caption := '';
    if ssCtrl in Shift then begin
      Tlabel(self).Caption := Tlabel(self).Caption + 'CTRL + ';
      modf := modf + [scmCtrl];
    end;

    if ssAlt in Shift then begin
      Tlabel(self).Caption := Tlabel(self).Caption + 'ALT + ';
      modf := modf + [scmAlt];
    end;

    if ssShift in Shift then begin
      Tlabel(self).Caption := Tlabel(self).Caption + 'SHIFT + ';
      modf := modf + [scmShift];
    end;

    if (HI(GetKeyState(Windows.VK_LWIN)) > 0) or (HI(GetKeyState(Windows.VK_RWIN)) > 0) then begin
      Tlabel(self).Caption := Tlabel(self).Caption + 'WIN + ';
      modf := modf + [scmWin];
    end;
    Self.Modifier := modf;

    // check for VK_UNUSED
    {if (pos('VK_UNUSED', vkc.AsText) <> 0) then begin
      str := InputBox('Key Alias','Enter Name for Key','');
      if  str <> '' then begin
        vkc.AddCustomKeyCode(Key,str);
      end;
    end; }

    if ((key > 18) or (key < 16)) and (Tlabel(self).Caption <> '') and (ord(key)
      <> Windows.VK_LWIN) and (ord(key) <> Windows.VK_RWIN)
        then begin

      skey := vkc.AsText;
      Tlabel(self).Caption := Tlabel(self).Caption + skey;
      Self.Key := vkc.AsText;

      SelStart := Length(Self.Caption);
      SelLength := 0;
    end;

  finally
    vkc.Free;
    //HideCaret(self.Handle);
  end;

end;

procedure TCustomScHotkeyEdit.KeyPress(var Key: Char);
begin
  inherited;
  Key := #0;
end;

procedure TCustomScHotkeyEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  Key := Word(#0);
  Self.Font.Color := clDkGray;

  SelStart := Length(Self.Caption);
  SelLength := 0;
  ShowCaret(Self.Handle);

end;

procedure TCustomScHotkeyEdit.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  //ShowCARET(self.Handle);
end;

procedure TCustomScHotkeyEdit.SetHotkeyText(Key: string;
  Modifiers: TScModifier);
var
  vkc: TVKToString;
  skey: string;
begin
  vkc := TVKToString.Create;
  vkc.VKey := key;
  try

    FModifier := Modifiers;
    FKey := Key;

    Tlabel(self).Caption := '';
    if scmCtrl in Modifiers then
      Tlabel(self).Caption := Tlabel(self).Caption + 'CTRL + ';
    if scmAlt in Modifiers then
      Tlabel(self).Caption := Tlabel(self).Caption + 'ALT + ';
    if scmShift in Modifiers then
      Tlabel(self).Caption := Tlabel(self).Caption + 'SHIFT + ';
    if scmWin in Modifiers then
      Tlabel(self).Caption := Tlabel(self).Caption + 'WIN + ';

    skey := key;
    Tlabel(self).Caption := Tlabel(self).Caption + skey;

  finally
    vkc.Free;
  end;
end;

procedure TCustomScHotkeyEdit.SetKey(const Value: string);
var
  i: integer;
begin
  // Check if key exists
  Fkey := '';
  for i := low(VKeyArray) to high(VKeyArray) do begin
    if Value = VKeyArray[i] then begin
      FKey := Value;

      SetHotkeyText(FKey, FModifier);
      exit;
    end;
  end;
  SetHotkeyText(FKey, FModifier);
end;

procedure TCustomScHotkeyEdit.SetModifier(const Value: TScModifier);
begin
  FModifier := Value;
  SetHotkeyText(FKey, FModifier);
end;

end.

