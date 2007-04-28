{
Source Name: SharpEDefault.pas
Description: Default classes
Copyright (C) Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

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

unit SharpEDefault;
interface
uses Graphics,
  SharpEBase,
  SharpEScheme,
  SharpESkin,
  Messages,
  SharpESkinPart,
  SharpApi;

const
  SharpERegPath: string = 'Software\ldi\sharpe\';

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
  DefaultSharpEScheme.AddColor('Throbberback','$Throbberback','Throbberback',$B68972);
  DefaultSharpEScheme.AddColor('Throbberdark','$Throbberdark','Throbberdark',$5B4439);
  DefaultSharpEScheme.AddColor('Throbberlight','$Throbberlight','Throbberlight',$C5958D);
  DefaultSharpEScheme.AddColor('ThrobberText','$ThrobberText','ThrobberText',$000000);
  DefaultSharpEScheme.AddColor('WorkAreaback','$WorkAreaback','WorkAreaback',$CACACA);
  DefaultSharpEScheme.AddColor('WorkAreadark','$WorkAreadark','WorkAreadark',$757575);
  DefaultSharpEScheme.AddColor('WorkArealight','$WorkArealight','WorkArealight',$F5F5F5);
  DefaultSharpEScheme.AddColor('WorkAreaText','$WorkAreaText','WorkAreaText',$000000);

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
