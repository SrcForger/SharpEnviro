unit uSharpDeskDesktopPanelList;

interface

uses
  SysUtils,
  Contnrs,
  uSharpDeskDesktopPanel;

type
  TDesktopPanelList = class (TObjectList)
                      private
                        FWidth  : integer;
                        FHeight : integer;
                      public
                        procedure LoadFromDirectory(pDirectory : String);
                        procedure SetSize(pWidth,pHeight : integer);
                        constructor create(pWidth,pHeight : integer);
                      published
                        property Width : integer read FWidth;
                        property Heigh : integer read FHeight;
                      end;
 

implementation

constructor TDesktopPanelList.create(pWidth,pHeight : integer);
begin
  Inherited Create;
  SetSize(pWidth,pHeight);  
end;

procedure TDesktopPanelList.SetSize(pWidth,pHeight : integer);
var
  n : integer;
begin
  FWidth := pWidth;
  FHeight := pHeight;
  if FWidth<1 then FWidth := 8;
  if FHeight<1 then FHeight := 8;

  for n := 0 to Count - 1 do
      TDesktopPanel(Items[n]).SetSize(FWidth,FHeight);
end;

procedure TDesktopPanelList.LoadFromDirectory(pDirectory : String);
var
  sr : TSearchRec;
  tempItem : TDesktopPanel;
begin
  {$WARNINGS OFF}
  pDirectory := IncludeTrailingBackslash(pDirectory);
  {$WARNINGS ON}
  if FindFirst(pDirectory+'*.*',faDirectory,sr) = 0 then
  repeat
    if (sr.Name = '.') or (sr.Name = '..') then continue;
    tempItem := TDesktopPanel.Create;
    tempItem.SetSize(FWidth,FHeight);
    tempItem.LoadPanel(sr.Name);
    tempItem.Paint;
    Add(tempItem);
  until FindNext(sr) <> 0;
  FindClose(sr);
end;

end.
