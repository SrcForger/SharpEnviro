unit VKToString;

interface

uses
  Classes,
  SysUtils,
  Windows,
  Forms,
  inifiles,
  jclinifiles,
  sharpapi;

var
  VKeyArray: array[0..255] of string = ('VK_NONE', 'VK_LBUTTON', 'VK_RBUTTON', 'VK_CANCEL',
    'VK_MBUTTON', 'VK_UNUSED5', 'VK_UNUSED6', 'VK_UNUSED7', 'VK_BACK', 'VK_TAB', 'VK_UNUSED10',
    'VK_UNUSED11', 'VK_CLEAR', 'VK_RETURN', 'VK_UNUSED14',
    'VK_UNUSED15', 'VK_SHIFT', 'VK_CONTROL',
    'VK_MENU', 'VK_PAUSE', 'VK_CAPITAL', 'VK_KANA', 'VK_HANGUL', 'VK_JUNJA', 'VK_FINAL',
      'VK_HANJA',
    'VK_KANJI', 'VK_ESCAPE', 'VK_CONVERT',
    'VK_NONCONVERT', 'VK_ACCEPT', 'VK_MODECHANGE', 'VK_SPACE', 'VK_PRIOR', 'VK_NEXT', 'VK_END',
    'VK_HOME', 'VK_LEFT',
    'VK_UP', 'VK_RIGHT', 'VK_DOWN', 'VK_SELECT', 'VK_PRINT', 'VK_EXECUTE', 'VK_SNAPSHOT',
    'VK_INSERT', 'VK_DELETE', 'VK_HELP',
    'VK_0', 'VK_1', 'VK_2', 'VK_3', 'VK_4', 'VK_5', 'VK_6', 'VK_7', 'VK_8', 'VK_9',
    'VK_UNUSED58', 'VK_UNUSED59', 'VK_UNUSED60', 'VK_UNUSED61', 'VK_UNUSED62', 'VK_UNUSED63',
    'VK_UNUSED64',
    'VK_A', 'VK_B', 'VK_C', 'VK_D', 'VK_E', 'VK_F', 'VK_G', 'VK_H', 'VK_I', 'VK_J', 'VK_K', 'VK_L',
    'VK_M',
    'VK_N', 'VK_O', 'VK_P', 'VK_Q', 'VK_R', 'VK_S', 'VK_T', 'VK_U', 'VK_V', 'VK_W', 'VK_X', 'VK_Y',
    'VK_Z',
    'VK_LWIN', 'VK_RWIN', 'VK_APPS', 'VK_UNUSED94', 'VK_UNUSED95', 'VK_NUMPAD0', 'VK_NUMPAD1',
    'VK_NUMPAD2', 'VK_NUMPAD3', 'VK_NUMPAD4', 'VK_NUMPAD5',
    'VK_NUMPAD6', 'VK_NUMPAD7', 'VK_NUMPAD8', 'VK_NUMPAD9', 'VK_MULTIPLY', 'VK_ADD',
      'VK_SEPARATOR',
    'VK_SUBTRACT',
    'VK_DECIMAL', 'VK_DIVIDE', 'VK_F1', 'VK_F2', 'VK_F3', 'VK_F4', 'VK_F5', 'VK_F6', 'VK_F7',
    'VK_F8',
    'VK_F9', 'VK_F10', 'VK_F11', 'VK_F12', 'VK_F13', 'VK_F14', 'VK_F15', 'VK_F16', 'VK_F17',
    'VK_F18',
    'VK_F19', 'VK_F20', 'VK_F21', 'VK_F22', 'VK_F23', 'VK_F24',
    'VK_UNUSED136', 'VK_UNUSED137', 'VK_UNUSED138', 'VK_UNUSED139', 'VK_UNUSED140', 'VK_UNUSED141',
    'VK_UNUSED142', 'VK_UNUSED143',
    'VK_NUMLOCK', 'VK_SCROLL',
    'VK_UNUSED146', 'VK_UNUSED147', 'VK_UNUSED148', 'VK_UNUSED149',
    'VK_UNUSED150', 'VK_UNUSED151', 'VK_UNUSED152', 'VK_UNUSED153', 'VK_UNUSED154', 'VK_UNUSED155',
    'VK_UNUSED156', 'VK_UNUSED157', 'VK_UNUSED158', 'VK_UNUSED159',
    'VK_LSHIFT', 'VK_RSHIFT', 'VK_LCONTROL', 'VK_RCONTROL', 'VK_LMENU', 'VK_RMENU', 'VK_UNUSED166',
    'VK_UNUSED167', 'VK_UNUSED168', 'VK_UNUSED169',
    'VK_UNUSED170', 'VK_UNUSED171', 'VK_UNUSED172', 'VK_UNUSED173', 'VK_UNUSED174', 'VK_UNUSED175',
    'VK_UNUSED176', 'VK_UNUSED177', 'VK_UNUSED178', 'VK_UNUSED179',
    'VK_UNUSED180', 'VK_UNUSED181', 'VK_UNUSED182', 'VK_UNUSED183', 'VK_UNUSED184', 'VK_UNUSED185',
    'VK_UNUSED186', 'VK_UNUSED187', 'VK_UNUSED188', 'VK_UNUSED189',
    'VK_UNUSED190', 'VK_UNUSED191', 'VK_UNUSED192', 'VK_UNUSED193', 'VK_UNUSED194', 'VK_UNUSED195',
    'VK_UNUSED196', 'VK_UNUSED197', 'VK_UNUSED198', 'VK_UNUSED199',
    'VK_UNUSED200', 'VK_UNUSED201', 'VK_UNUSED202', 'VK_UNUSED203', 'VK_UNUSED204', 'VK_UNUSED205',
    'VK_UNUSED206', 'VK_UNUSED207', 'VK_UNUSED208', 'VK_UNUSED209',
    'VK_UNUSED210', 'VK_UNUSED211', 'VK_UNUSED212', 'VK_UNUSED213', 'VK_UNUSED214', 'VK_UNUSED215',
    'VK_UNUSED216', 'VK_UNUSED217', 'VK_UNUSED218', 'VK_UNUSED219',
    'VK_UNUSED220', 'VK_UNUSED221', 'VK_UNUSED222', 'VK_UNUSED223', 'VK_UNUSED224', 'VK_UNUSED225',
    'VK_UNUSED226', 'VK_UNUSED227', 'VK_UNUSED228', 'VK_PROCESSKEY',
    'VK_UNUSED230', 'VK_UNUSED231', 'VK_UNUSED232', 'VK_UNUSED233', 'VK_UNUSED234', 'VK_UNUSED235',
    'VK_UNUSED236', 'VK_UNUSED237', 'VK_UNUSED238', 'VK_UNUSED239',
    'VK_UNUSED240', 'VK_UNUSED241', 'VK_UNUSED242', 'VK_UNUSED243', 'VK_UNUSED244', 'VK_UNUSED245',
    'VK_ATTN', 'VK_CRSEL', 'VK_EXSEL', 'VK_EREOF',
    'VK_PLAY', 'VK_ZOOM', 'VK_NONAME', 'VK_PA1', 'VK_OEM_CLEAR', 'VK_UNUSED255');

type
  TVKToString = class(TPersistent)
  private
    FVKey: string;
  public
    function AsText: string;
    function AsAscii: Cardinal;
    constructor Create; virtual;
    procedure UpdateCustomCodes;

    procedure AddCustomKeyCode(Code:Integer; Alias:String);
  published
    property VKey: string read FVKey write FVKey;
  end;

implementation

uses
  TypInfo;

{ TVKToString }

procedure TVKToString.AddCustomKeyCode(Code: Integer; Alias: String);
var
  fn: string;
  ini: Tinifile;
begin
  // Load custom array
  fn := GetSharpeGlobalSettingsPath + 'SharpCore\Services\Hotkeys\CCP';
  ini := TIniFile.Create(fn);
  ini.WriteString('CP',IntToStr(Code),Format('CCK_%s',[Alias]));
  ini.Free;

  // Refresh
  UpdateCustomCodes;

end;

function TVKToString.AsAscii: Cardinal;
var
  i: integer;
  s: string;
begin
  result := 0;
  if IsPublishedProp(self, 'VKey') then begin
    for i := low(VKeyArray) to high(VKeyArray) do begin
      s := uppercase(VKeyArray[i]);
      if (s = uppercase(FVKey)) then begin
        result := i;
        exit;
      end;
    end;
  end;
end;

function TVKToString.AsText: string;
var
  i: integer;
  s: string;
begin
  if IsPublishedProp(self, 'VKey') then begin
    for i := low(VKeyArray) to high(VKeyArray) do begin
      s := uppercase(VKeyArray[i]);
      if (s = uppercase(FVKey)) or (i = strtoint(FVkey)) then begin
        result := s;
        exit;
      end;
    end;
  end;
end;

constructor TVKToString.Create;

begin
  FVKey := 'VK_NONE';

  // Load custom keys
  UpdateCustomCodes;

end;

procedure TVKToString.UpdateCustomCodes;
var
  fn: string;
  ini: Tinifile;
  id: string;
  alias: string;
  CP: TStringList;
  i: integer;
begin
  if (not (csDesigning in Application.ComponentState)) or
    (not(csLoading in Application.ComponentState)) then begin

    CP := TStringList.Create;
    try

      // Load custom array
      fn := GetSharpeGlobalSettingsPath + 'SharpCore\Services\Hotkeys\CCP';
      ini := TIniFile.Create(fn);
      ini.ReadSection('CP', CP);

      for i := 0 to CP.Count - 1 do begin
        id := CP[i];
        alias := ini.ReadString('CP', id, '');
        VKeyArray[strtoint(id)] := uppercase(alias);
      end;

    finally
      CP.Free;
    end;
  end;
end;

end.

