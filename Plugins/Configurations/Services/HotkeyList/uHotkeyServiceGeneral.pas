{
Source Name: uHotkeyServiceGeneral
Description: General Library Methods
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

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

unit uHotkeyServiceGeneral;
interface
uses
  SharpApi;

procedure Debug(Text: string; DebugMessageType: Integer);

const
  cSettingsLocation = 'SharpCore\Services\Hotkeys\Hotkeys.xml';

var
  Started: Boolean;

implementation

procedure Debug(Text: string; DebugMessageType: Integer);
begin
  SendDebugMessageEx('Hotkeys Service', Pchar(Text), 0, DebugMessageType);
end;

end.

 