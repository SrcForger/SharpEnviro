unit uSharpEMenuIconThreads;

interface

uses
  Classes,Contnrs,uSharpEMenuIcons,uSharpEMenuIcon;

type
  TLoadIconCacheThread = class(TThread)
  private
    pMenuIcons : ^TSharpEMenuIcons;
    pIconCacheFile : string;
  protected
    procedure Execute; override;
  public
    constructor Create(createSuspended: boolean; var menuIcons : TSharpEMenuIcons; iconcachefile : string);
  end;

  TLoadGenericIconsThread = class(TThread)
  private
    pMenuIcons : ^TSharpEMenuIcons;
  protected
    procedure Execute; override;
  public
    constructor Create(createSuspended: boolean; var menuIcons : TSharpEMenuIcons);
  end;

  TLoadNotLoadedIconsThread = class(TThread)
  private
    FIcons : TObjectList;
  protected
    procedure Execute; override;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    property Icons : TObjectList read FIcons;
  end;

implementation

constructor TLoadIconCacheThread.Create(createSuspended: boolean; var menuIcons : TSharpEMenuIcons; IconCacheFile : string);
begin
  inherited Create(createSuspended);

  pMenuIcons := @menuIcons;
  pIconCacheFile := IconCacheFile;
end;

procedure TLoadIconCacheThread.Execute;
begin
  pMenuIcons.LoadIconCache(pIconCacheFile);
end;

constructor TLoadGenericIconsThread.Create(createSuspended: boolean; var menuIcons : TSharpEMenuIcons);
begin
  inherited Create(createSuspended);

  pMenuIcons := @menuIcons;
end;

procedure TLoadGenericIconsThread.Execute;
begin
  pMenuIcons.LoadGenericIcons;
end;


{ TLoadNotLoadedIconsThread }

constructor TLoadNotLoadedIconsThread.Create;
begin
  inherited Create(True);

  FIcons := TObjectList.Create;
  FIcons.OwnsObjects := False;
end;

destructor TLoadNotLoadedIconsThread.Destroy;
begin
  FIcons.Clear;
  FIcons.Free;

  inherited Destroy;
end;

procedure TLoadNotLoadedIconsThread.Execute;
var
  item : TSharpEMenuIcon;
  n : integer;
begin
  for n := 0 to FIcons.Count - 1 do
  begin
    item := TSharpEMenuIcon(FIcons.Items[n]);
    item.LoadFromFile;
  end;
end;

end.
