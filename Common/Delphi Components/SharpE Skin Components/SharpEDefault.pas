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
  DefaultSharpEColorScheme: TColorSchemeEx;
  DefaultSharpEScheme: TSharpEScheme;
  DefaultSharpESkin: TSharpESkin;
  DefaultSharpESkinText: TSkinText;

implementation

initialization
  DefaultSharpESkinTextRecord.FName := 'Small Fonts';
  DefaultSharpESkinTextRecord.FSize := 7;
  DefaultSharpESkinTextRecord.FColor := '$WorkAreaText';

//SharpEColorScheme
  DefaultSharpEColorScheme.Throbberback := $B68972;
  DefaultSharpEColorScheme.Throbberdark := $5B4439;
  DefaultSharpEColorScheme.Throbberlight := $C5958D;
  DefaultSharpEColorScheme.ThrobberText := $000000;
  DefaultSharpEColorScheme.WorkAreaback := $CACACA;
  DefaultSharpEColorScheme.WorkAreadark := $757575;
  DefaultSharpEColorScheme.WorkArealight := $F5F5F5;
  DefaultSharpEColorScheme.WorkAreaText := $000000;

//SharpEScheme
  DefaultSharpEScheme := TSharpEScheme.Create(nil);
  DefaultSharpEScheme.AssignScheme(DefaultSharpEColorScheme);

//SharpESkin
  DefaultSharpESkin := TSharpESkin.Create(nil);

//SharpESkinText
  DefaultSharpESkinText := TSkinText.Create;
  DefaultSharpESkinText.Assign(DefaultSharpESkinTextRecord);

finalization
  DefaultSharpESkinText.Free;
  DefaultSharpESkin.Free;
  DefaultSharpEScheme.Free;

end.
