{
Source Name: SharpEDefault.pas
Description: Default classes
Copyright (C) Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

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

unit SharpEDefault;
interface
uses Graphics,
  SharpEBase,
  SharpEScheme,
  SharpESkin,
  Messages,
  SharpESkinPart,
  SharpApi,
  SharpThemeApi,
  SharpTypes;

var
  DefaultSharpESkinTextRecord: TSkinTextRecord;
  DefaultSharpEScheme: TSharpEScheme;
  DefaultSharpESkin: TSharpESkin;
  DefaultSharpESkinText: TSkinText;

implementation

initialization
  DefaultSharpESkinTextRecord.FName := 'Small Fonts';
  DefaultSharpESkinTextRecord.FSize := 7;
  DefaultSharpESkinTextRecord.FColor := '0';

//SharpEScheme
  DefaultSharpEScheme := TSharpEScheme.Create(nil);
  DefaultSharpEScheme.AddColor('Throbberback','$Throbberback','Throbberback',$B68972,stColor);
  DefaultSharpEScheme.AddColor('Throbberdark','$Throbberdark','Throbberdark',$5B4439,stColor);
  DefaultSharpEScheme.AddColor('Throbberlight','$Throbberlight','Throbberlight',$C5958D,stColor);
  DefaultSharpEScheme.AddColor('ThrobberText','$ThrobberText','ThrobberText',$000000,stColor);
  DefaultSharpEScheme.AddColor('WorkAreaback','$WorkAreaback','WorkAreaback',$CACACA,stColor);
  DefaultSharpEScheme.AddColor('WorkAreadark','$WorkAreadark','WorkAreadark',$757575,stColor);
  DefaultSharpEScheme.AddColor('WorkArealight','$WorkArealight','WorkArealight',$F5F5F5,stColor);
  DefaultSharpEScheme.AddColor('WorkAreaText','$WorkAreaText','WorkAreaText',$000000,stColor);

//SharpESkin
  DefaultSharpESkin := TSharpESkin.Create(nil,ALL_SHARPE_SKINS);

//SharpESkinText
  DefaultSharpESkinText := TSkinText.Create;
  DefaultSharpESkinText.Assign(DefaultSharpESkinTextRecord);

finalization
  DefaultSharpESkinText.Free;
  DefaultSharpESkin.Free;
  DefaultSharpEScheme.Free;

end.
