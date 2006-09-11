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
  DefaultSharpESkinTextRecord.FColor := '$WorkAreaText';

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
  DefaultSharpESkin := TSharpESkin.Create(nil);

//SharpESkinText
  DefaultSharpESkinText := TSkinText.Create;
  DefaultSharpESkinText.Assign(DefaultSharpESkinTextRecord);

finalization
  DefaultSharpESkinText.Free;
  DefaultSharpESkin.Free;
  DefaultSharpEScheme.Free;

end.
