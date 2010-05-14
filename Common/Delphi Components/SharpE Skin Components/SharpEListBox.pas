unit SharpEListBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls;

type
TSharpEListBox = class(TListBox)
  procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
end;


implementation

{ TSharpEListBox }

procedure TSharpEListBox.CNDrawItem(var Message: TWMDrawItem); 
begin
  Exclude(TOwnerDrawState(LongRec(Message.DrawItemStruct^.itemState).Lo),
odFocused);
  inherited;
end;

end.
