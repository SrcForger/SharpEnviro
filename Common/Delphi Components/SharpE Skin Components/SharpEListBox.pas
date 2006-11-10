unit SharpEListBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, CategoryButtons, Menus, StdCtrls, ShellApi;

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
