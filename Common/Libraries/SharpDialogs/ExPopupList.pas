unit ExPopupList;

interface 

uses Controls, Menus;

var
  nrevent : boolean;
  lastmenu : Longword;
  lastmenuid : Longword;

implementation 

uses Messages, Forms, Windows,SysUtils;

Type 
  TExPopupList = class( TPopupList )
  protected 
    procedure WndProc(var Message: TMessage); override;
  end; 

{ TExPopupList }

procedure TExPopupList.WndProc(var Message: TMessage);
begin
  Case message.Msg Of 
    WM_ENTERMENULOOP: begin
                        nrevent := True;
                        lastmenuid := TWMMenuSelect(Message).IDItem;
                        lastmenu := TWMMenuSelect(Message).Menu;
                      end;
    WM_EXITMENULOOP : ;
    WM_MENUSELECT   : begin
                        if TWMMenuSelect(Message).Menu <> 0 then
                        begin
                          lastmenuid := TWMMenuSelect(Message).IDItem;
                          lastmenu := TWMMenuSelect(Message).Menu;
                        end else if GetSubMenu(lastmenu,lastmenuid) <> 0 then nrevent := False;
                      end;
  End; 
  inherited;
end; 

Initialization 
  Popuplist.Free;
  PopupList:= TExPopupList.Create; 
  // Note: will be freed by Finalization section of Menus unit. 
end.
