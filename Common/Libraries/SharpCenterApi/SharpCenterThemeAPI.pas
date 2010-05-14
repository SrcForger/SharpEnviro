unit SharpCenterThemeAPI;

interface

uses
  Graphics,
  SharpCenterApi,
  SharpEListBoxEx;

procedure AssignThemeToListBoxItemText( ATheme: TCenterThemeInfo; AItem: TSharpEListItem;
  var colItemTxt:tcolor; var colDescTxt:tcolor; var colBtnTxt: TColor); overload;
procedure AssignThemeToListBoxItemText( ATheme: TCenterThemeInfo; AItem: TSharpEListItem;
  var colItemTxt:tcolor; var colDescTxt:tcolor; var colBtnTxt: TColor; var colBtnDisabledTxt: TColor); overload;


implementation

procedure AssignThemeToListBoxItemText( ATheme: TCenterThemeInfo; AItem: TSharpEListItem;
  var colItemTxt:tcolor; var colDescTxt:tcolor; var colBtnTxt: TColor );
var
  colBtnDisabledTxt: TColor;
begin
  AssignThemeToListBoxItemText( ATheme, AItem, colItemTxt, colDescTxt, colBtnTxt, colBtnDisabledTxt );
end;

procedure AssignThemeToListBoxItemText( ATheme: TCenterThemeInfo; AItem: TSharpEListItem;
  var colItemTxt:tcolor; var colDescTxt:tcolor; var colBtnTxt: TColor; var colBtnDisabledTxt: TColor);
begin
  if AItem.Selected then
  begin
    colItemTxt := ATheme.PluginSelectedItemText;
    colDescTxt := ATheme.PluginSelectedItemDescriptionText;
    colBtnTxt := ATheme.PluginSelectedItemButtonText;
    colBtnDisabledTxt := ATheme.PluginSelectedItemButtonDisabledText;
  end
  else
  begin
    colItemTxt := ATheme.PluginItemText;
    colDescTxt := ATheme.PluginItemDescriptionText;
    colBtnTxt := ATheme.PluginItemButtonText;
    colBtnDisabledTxt := ATheme.PluginItemButtonDisabledText;
  end;
end;

end.
