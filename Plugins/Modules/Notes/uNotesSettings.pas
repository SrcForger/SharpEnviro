unit uNotesSettings;

interface

uses Classes, SysUtils;

type NotesTabSettings = class
  private
    FName: string;
    FIconIndex: Integer;
    FTags: string;
    FSelStart: Integer;
    FSelLength: Integer;
  public
    constructor Create(Name: string); overload;
    property Name: string read FName write FName;
    property IconIndex: Integer read FIconIndex write FIconIndex;
    property Tags: string read FTags write FTags;
    property SelStart: Integer read FSelStart write FSelStart;
    property SelLength: Integer read FSelLength write FSelLength;
end;

type NotesSettings = class
  private
    FShowCaption: Boolean;
    FShowIcon: Boolean;
    FAlwaysOnTop: Boolean;
    FLeft: Integer;
    FTop: Integer;
    FHeight: Integer;
    FWidth: Integer;
    FWordWrap: Boolean;
    FFilter: string;
    FFilterIndex: Integer;
    FLastTab: string;
    FTabs: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    property ShowCaption: Boolean read FShowCaption write FShowCaption;
    property ShowIcon: Boolean read FShowIcon write FShowIcon;
    property AlwaysOnTop: Boolean read FAlwaysOnTop write FAlwaysOnTop;
    property Left: Integer read FLeft write FLeft;
    property Top: Integer read FTop write FTop;
    property Height: Integer read FHeight write FHeight;
    property Width: Integer read FWidth write FWidth;
    property WordWrap: Boolean read FWordWrap write FWordWrap;
    property Filter: string read FFilter write FFilter;
    property FilterIndex: Integer read FFilterIndex write FFilterIndex;
    property LastTab: string read FLastTab write FLastTab;
    property Tabs: TStringList read FTabs write FTabs;

end;

  const DefaultIconIndex = 3;

implementation

constructor NotesSettings.Create;
begin
  // Set the default setting
  FShowCaption := True;
  FShowIcon := True;
  FAlwaysOnTop := True;
  FLeft := 100;
  FTop := 100;
  FHeight := 370;
  FWidth := 690;
  FWordWrap := False;
  FFilter := '';
  FFilterIndex := 0; // Filter on Names
  FTabs := TStringList.Create;
end;

destructor NotesSettings.Destroy;
var
  i: Integer;
begin
  // Clean up the objects in the list.
  for i := 0 to Pred(FTabs.Count) do
    FTabs.Objects[i].Free;
    
  FTabs.Free;
end;

constructor NotesTabSettings.Create(Name: string);
begin
  // Set the default settings.
  FName := Name;
  FIconIndex := DefaultIconIndex;
  FTags := '';
  FSelStart := 0;
  FSelLength := 0;
end;

end.
