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
    'VK_MBUTTON', 'VK_UNKNOWN5', 'VK_UNKNOWN6', 'VK_UNKNOWN7', 'VK_BACK', 'VK_TAB', 'VK_UNKNOWN10',
    'VK_UNKNOWN11', 'VK_CLEAR', 'VK_RETURN', 'VK_UNKNOWN14',
    'VK_UNKNOWN15', 'VK_SHIFT', 'VK_CONTROL',
    'VK_MENU', 'VK_PAUSE', 'VK_CAPITAL', 'VK_KANA', 'VK_HANGUL', 'VK_JUNJA', 'VK_FINAL',
      'VK_HANJA',
    'VK_KANJI', 'VK_ESCAPE', 'VK_CONVERT',
    'VK_NONCONVERT', 'VK_ACCEPT', 'VK_MODECHANGE', 'VK_SPACE', 'VK_PRIOR', 'VK_NEXT', 'VK_END',
    'VK_HOME', 'VK_LEFT',
    'VK_UP', 'VK_RIGHT', 'VK_DOWN', 'VK_SELECT', 'VK_PRINT', 'VK_EXECUTE', 'VK_SNAPSHOT',
    'VK_INSERT', 'VK_DELETE', 'VK_HELP',
    'VK_0', 'VK_1', 'VK_2', 'VK_3', 'VK_4', 'VK_5', 'VK_6', 'VK_7', 'VK_8', 'VK_9',
    'VK_UNKNOWN58', 'VK_UNKNOWN59', 'VK_UNKNOWN60', 'VK_UNKNOWN61', 'VK_UNKNOWN62', 'VK_UNKNOWN63',
    'VK_UNKNOWN64',
    'VK_A', 'VK_B', 'VK_C', 'VK_D', 'VK_E', 'VK_F', 'VK_G', 'VK_H', 'VK_I', 'VK_J', 'VK_K', 'VK_L',
    'VK_M',
    'VK_N', 'VK_O', 'VK_P', 'VK_Q', 'VK_R', 'VK_S', 'VK_T', 'VK_U', 'VK_V', 'VK_W', 'VK_X', 'VK_Y',
    'VK_Z',
    'VK_LWIN', 'VK_RWIN', 'VK_APPS', 'VK_UNKNOWN94', 'VK_UNKNOWN95', 'VK_NUMPAD0', 'VK_NUMPAD1',
    'VK_NUMPAD2', 'VK_NUMPAD3', 'VK_NUMPAD4', 'VK_NUMPAD5',
    'VK_NUMPAD6', 'VK_NUMPAD7', 'VK_NUMPAD8', 'VK_NUMPAD9', 'VK_MULTIPLY', 'VK_ADD',
      'VK_SEPARATOR',
    'VK_SUBTRACT',
    'VK_DECIMAL', 'VK_DIVIDE', 'VK_F1', 'VK_F2', 'VK_F3', 'VK_F4', 'VK_F5', 'VK_F6', 'VK_F7',
    'VK_F8',
    'VK_F9', 'VK_F10', 'VK_F11', 'VK_F12', 'VK_F13', 'VK_F14', 'VK_F15', 'VK_F16', 'VK_F17',
    'VK_F18',
    'VK_F19', 'VK_F20', 'VK_F21', 'VK_F22', 'VK_F23', 'VK_F24',
    'VK_UNKNOWN136', 'VK_UNKNOWN137', 'VK_UNKNOWN138', 'VK_UNKNOWN139', 'VK_UNKNOWN140', 'VK_UNKNOWN141',
    'VK_UNKNOWN142', 'VK_UNKNOWN143',
    'VK_NUMLOCK', 'VK_SCROLL',
    'VK_UNKNOWN146', 'VK_UNKNOWN147', 'VK_UNKNOWN148', 'VK_UNKNOWN149',
    'VK_UNKNOWN150', 'VK_UNKNOWN151', 'VK_UNKNOWN152', 'VK_UNKNOWN153', 'VK_UNKNOWN154', 'VK_UNKNOWN155',
    'VK_UNKNOWN156', 'VK_UNKNOWN157', 'VK_UNKNOWN158', 'VK_UNKNOWN159',
    'VK_LSHIFT', 'VK_RSHIFT', 'VK_LCONTROL', 'VK_RCONTROL', 'VK_LMENU', 'VK_RMENU', 'VK_UNKNOWN166',
    'VK_UNKNOWN167', 'VK_UNKNOWN168', 'VK_UNKNOWN169',
    'VK_UNKNOWN170', 'VK_UNKNOWN171', 'VK_UNKNOWN172', 'VK_UNKNOWN173', 'VK_UNKNOWN174', 'VK_UNKNOWN175',
    'VK_UNKNOWN176', 'VK_UNKNOWN177', 'VK_UNKNOWN178', 'VK_UNKNOWN179',
    'VK_UNKNOWN180', 'VK_UNKNOWN181', 'VK_UNKNOWN182', 'VK_UNKNOWN183', 'VK_UNKNOWN184', 'VK_UNKNOWN185',
    'VK_UNKNOWN186', 'VK_UNKNOWN187', 'VK_UNKNOWN188', 'VK_UNKNOWN189',
    'VK_UNKNOWN190', 'VK_UNKNOWN191', 'VK_UNKNOWN192', 'VK_UNKNOWN193', 'VK_UNKNOWN194', 'VK_UNKNOWN195',
    'VK_UNKNOWN196', 'VK_UNKNOWN197', 'VK_UNKNOWN198', 'VK_UNKNOWN199',
    'VK_UNKNOWN200', 'VK_UNKNOWN201', 'VK_UNKNOWN202', 'VK_UNKNOWN203', 'VK_UNKNOWN204', 'VK_UNKNOWN205',
    'VK_UNKNOWN206', 'VK_UNKNOWN207', 'VK_UNKNOWN208', 'VK_UNKNOWN209',
    'VK_UNKNOWN210', 'VK_UNKNOWN211', 'VK_UNKNOWN212', 'VK_UNKNOWN213', 'VK_UNKNOWN214', 'VK_UNKNOWN215',
    'VK_UNKNOWN216', 'VK_UNKNOWN217', 'VK_UNKNOWN218', 'VK_UNKNOWN219',
    'VK_UNKNOWN220', 'VK_UNKNOWN221', 'VK_UNKNOWN222', 'VK_UNKNOWN223', 'VK_UNKNOWN224', 'VK_UNKNOWN225',
    'VK_UNKNOWN226', 'VK_UNKNOWN227', 'VK_UNKNOWN228', 'VK_PROCESSKEY',
    'VK_UNKNOWN230', 'VK_UNKNOWN231', 'VK_UNKNOWN232', 'VK_UNKNOWN233', 'VK_UNKNOWN234', 'VK_UNKNOWN235',
    'VK_UNKNOWN236', 'VK_UNKNOWN237', 'VK_UNKNOWN238', 'VK_UNKNOWN239',
    'VK_UNKNOWN240', 'VK_UNKNOWN241', 'VK_UNKNOWN242', 'VK_UNKNOWN243', 'VK_UNKNOWN244', 'VK_UNKNOWN245',
    'VK_ATTN', 'VK_CRSEL', 'VK_EXSEL', 'VK_EREOF',
    'VK_PLAY', 'VK_ZOOM', 'VK_NONAME', 'VK_PA1', 'VK_OEM_CLEAR', 'VK_UNKNOWN255');

type
  TVKToString = class(TPersistent)
  private
    FVKey: string;
  public
    function AsText: string;
    function AsAscii: Cardinal;
    constructor Create; virtual;
    //procedure UpdateCustomCodes;

    //procedure AddCustomKeyCode(Code:Integer; Alias:String);
  published
    property VKey: string read FVKey write FVKey;
  end;

implementation

uses
  TypInfo;

{ TVKToString }

{procedure TVKToString.AddCustomKeyCode(Code: Integer; Alias: String);
var
  fn: string;
  ini: Tinifile;
begin
  // Load custom array
  Try
    fn := GetSharpeGlobalSettingsPath + 'SharpCore\Services\Hotkeys\CCP.dat';
  Except
    Exit;
  End;

  if Not(Fileexists(fn)) then exit;
  ini := TIniFile.Create(fn);
  ini.WriteString('CP',IntToStr(Code),Format('CCK_%s',[Alias]));
  ini.Free;

  // Refresh
  UpdateCustomCodes;

end;      }

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
  // UpdateCustomCodes;

end;

{procedure TVKToString.UpdateCustomCodes;
var
  fn: string;
  ini: Tinifile;
  id: string;
  alias: string;
  CP: TStringList;
  i: integer;
  s: String;
begin
  if (not (csDesigning in Application.ComponentState)) then begin

    CP := TStringList.Create;
    try

      // Load custom array
      s := GetSharpeGlobalSettingsPath;
      forcedirectories(GetSharpeGlobalSettingsPath + 'SharpCore\Services\Hotkeys\');
      fn := GetSharpeGlobalSettingsPath + 'SharpCore\Services\Hotkeys\CCP.Dat';
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
end;   }

end.


