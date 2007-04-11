unit uSharpEColorPanelEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, SharpEColorPanel, SharpThemeApi;

Type
  TSharpEColorPanelExItem = Class(TCollectionItem)
  private
    FTitle: String;
    FColorCode: Integer;
    FColorAsTColor: TColor;
    FTag: Pointer;
    FName: string;
    FParent: Pointer;
    FExpanded: Boolean;
    FParseColor: String;

    procedure SetColorAsTColor(const Value: TColor);
    procedure SetColorCode(const Value: Integer);
    function GetExpanded: Boolean;
    procedure SetExpanded(const Value: Boolean);
    procedure SetTitle(const Value: String);
    procedure ColorChangeEvent(ASender: TObject; AColorCode: Integer);
    procedure TabclickEvent(Sender: TObject);
    function GetColorCode: Integer;
    function GetColorAsTColor: TColor;
    procedure SetParseColor(const Value: String);
  public
    //constructor Create(AOwner: Tcomponent); reintroduce;

    destructor Destroy; override;
    property Tag: Pointer read FTag write FTag;
    property Parent: Pointer read FParent write FParent;

  protected
    function GetDisplayName: string; override;
    function GetNamePath: string; reintroduce;

  published
    Property Title: String read FTitle write SetTitle;
    property ColorCode: Integer read GetColorCode write SetColorCode;
    property ColorAsTColor: TColor read GetColorAsTColor write SetColorAsTColor;
    property ParseColor: String read FParseColor write SetParseColor;
    property Expanded: Boolean read GetExpanded write SetExpanded;

end;

type
  TSharpEColorPanelExItems = Class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TSharpEColorPanelExItem;
    procedure SetItem(Index: Integer; const Value: TSharpEColorPanelExItem);
  protected
     procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);

    function Add(AOwner:TComponent):TSharpEColorPanelExItem;
    procedure Delete(AIndex: Integer); overload;
    procedure Delete(AItem: TSharpEColorPanelExItem); overload;
    property Item[Index: Integer]: TSharpEColorPanelExItem read GetItem write SetItem;
    function IndexOf(const Name: string): Integer;
  end;

Type
  TSharpEColorPanelEx = Class(TScrollBox)
  private
    FItems: TSharpEColorPanelExItems;
    FDesignLabel: TLabel;
    procedure SetItems(const Value: TSharpEColorPanelExItems);
  public
    constructor Create(Sender: TComponent); override;

    procedure PopulateItems;
  protected
    procedure SetName(const Value: TComponentName); override;

  published
    property Align;
    property Anchors;
    property Items: TSharpEColorPanelExItems read FItems write SetItems stored True;
end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SharpE', [TSharpEColorPanelEx]);
end;

{ TSharpEColorPanelExItem }

procedure TSharpEColorPanelExItem.SetColorCode(const Value: Integer);
begin
  //FColorCode := Value;

  if tag <> nil then begin
    TSharpEColorPanel(tag).OverrideSliderUpdateMode(sumAll);
    TSharpEColorPanel(tag).ColorCode := Value;
  end;
end;

procedure TSharpEColorPanelExItem.SetColorAsTColor(const Value: TColor);
begin
  if tag <> nil then
    TSharpEColorPanel(tag).ColorAsTColor := Value;
end;

function TSharpEColorPanelExItem.GetExpanded: Boolean;
begin
  if tag <> nil then
    Result := TSharpEColorPanel(tag).Expanded;
end;

procedure TSharpEColorPanelExItem.SetExpanded(const Value: Boolean);
begin
  FExpanded := Value;

  if FExpanded then begin
    TabclickEvent(Self);
  end;
end;

destructor TSharpEColorPanelExItem.Destroy;
begin

  inherited;
end;

procedure TSharpEColorPanelExItem.ColorChangeEvent(ASender: TObject;
  AColorCode: Integer);
begin
  FColorCode := TSharpEColorPanel(ASender).ColorCode;
  FColorAsTColor := TSharpEColorPanel(ASender).ColorAsTColor;
end;

procedure TSharpEColorPanelExItem.SetTitle(const Value: String);
begin
  FTitle := Value;

  if Tag <> nil then
    TSharpEColorPanel(tag).Caption := Value;
end;


function TSharpEColorPanelExItem.GetDisplayName: string;
begin
  Result := 'Item' + IntToStr(id);
end;

function TSharpEColorPanelExItem.GetNamePath: string;
begin
  Result := ClassName;
end;

procedure TSharpEColorPanelExItem.TabclickEvent(Sender: TObject);
var
  i:Integer;
begin
  if FTag = nil then exit;

  if FParent <> nil then begin
    TSharpEColorPanelEx(FParent).DisableAlign;
    TSharpEColorPanelEx(FParent).DisableAutoRange;
  end;

  // collapse all
  For i := 0 to Pred(Collection.Count) do begin
    TSharpEColorPanel(TSharpEColorPanelExItem(Collection.Items[i]).Tag).Collapse;
    TSharpEColorPanelExItem(Collection.Items[i]).Expanded := False;
  end;

  // Expand selected
  For i := 0 to Pred(Collection.Count) do begin
    if TSharpEColorPanelExItem(Collection.Items[i]) = Self then begin
      TSharpEColorPanel(Tag).Expanded := True;
      TSharpEColorPanel(Tag).SelectDefaultTab;
    end;
  end;

  if FParent <> nil then begin
    TSharpEColorPanelEx(FParent).EnableAlign;
    TSharpEColorPanelEx(FParent).EnableAutoRange;
  end;
end;

function TSharpEColorPanelExItem.GetColorCode: Integer;
begin
  if tag <> nil then
    Result := TSharpEColorPanel(tag).ColorCode;
end;

function TSharpEColorPanelExItem.GetColorAsTColor: TColor;
begin
  if tag <> nil then
    Result := TSharpEColorPanel(tag).ColorAsTColor;
end;

procedure TSharpEColorPanelExItem.SetParseColor(const Value: String);
var
  col: TColor;
begin

  try
  col := sharpthemeapi.parsecolor(PChar(Value));

  if tag <> nil then begin
    TSharpEColorPanel(tag).OverrideSliderUpdateMode(sumAll);
    TSharpEColorPanel(tag).ColorCode := col;
  end;
  except
  end;
end;

{ TSharpEColorPanelExItems }

function TSharpEColorPanelExItems.Add(
  AOwner: TComponent): TSharpEColorPanelExItem;
begin
  result := inherited Add as TSharpEColorPanelExItem;
end;

function TSharpEColorPanelExItems.GetItem(
  Index: Integer): TSharpEColorPanelExItem;
begin
  result := inherited Items[Index] as TSharpEColorPanelExItem;
end;

procedure TSharpEColorPanelExItems.SetItem(Index: Integer;
  const Value: TSharpEColorPanelExItem);
begin
  inherited Items[Index] := Value;
end;

procedure TSharpEColorPanelExItems.Delete(AItem: TSharpEColorPanelExItem);
begin

end;

procedure TSharpEColorPanelExItems.Delete(AIndex: Integer);
begin
  inherited Items[AIndex] as TSharpEColorPanelExItem;
end;

function TSharpEColorPanelExItems.IndexOf(const Name: string): Integer;
begin
  for Result := 0 to Count - 1 do
    if AnsiCompareText(Items[Result].DisplayName, Name) = 0 then
      Exit;
  Result := -1;
end;

constructor TSharpEColorPanelExItems.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TSharpEColorPanelExItem);
end;

procedure TSharpEColorPanelExItems.Update(Item: TCollectionItem);
begin
  inherited Update(Item);

  if Owner <> nil then
     TSharpEColorPanelEx(Owner).PopulateItems;
end;

{ TSharpEColorPanelEx }

constructor TSharpEColorPanelEx.Create(Sender: TComponent);
begin
  inherited;
  Self.ParentBackground := False;
  Self.DoubleBuffered := True;
  Self.ParentColor := False;
  Self.BevelInner := bvNone;
  Self.BevelOuter := bvNone;
  Self.BorderWidth := 4;
  Self.Color := clWindow;

  FItems := TSharpEColorPanelExItems.Create(Self);
end;

procedure TSharpEColorPanelEx.PopulateItems;
var
  tmp:TSharpEColorPanel;
  i:Integer;

  procedure InitTabs;
  var
    i:Integer;
  begin
    For i := 0 to Pred(FItems.Count) do begin

      if i = 0 then
        FItems.Item[i].Expanded := True else begin
        FItems.Item[i].Expanded := False;
      end;
    end;
  end;

begin

  Self.DisableAlign;
  Self.DisableAutoRange;
  Self.Updating;

  Try
  For i := Pred(ComponentCount) downto 0 do
    if Components[i] is TSharpEColorPanel then
      Components[i].Free;

  For i := 0 to Pred(FItems.Count) do begin
    tmp := TSharpEColorPanel.Create(Self);
    FItems.Item[i].Tag := tmp;
    FItems.Item[i].Parent := Self;

    tmp.Parent := self;
    tmp.Align := alTop;
    tmp.GroupIndex := 0;
    tmp.ColorCode := FItems.Item[i].ColorCode;
    tmp.ColorAsTColor := FItems.Item[i].FColorAsTColor;
    tmp.Caption := FItems.Item[i].Title;
    tmp.Expanded := FItems.Item[i].Expanded;
    tmp.Name := 'Item' + intToStr(i);

    tmp.OnColorChange := FItems.Item[i].ColorChangeEvent;
    tmp.OnTabClick := FItems.Item[i].TabclickEvent;

    tmp.Height := 24;
  end;

  Finally


    Self.EnableAlign;
    Self.EnableAutoRange;
    Self.Updated;
  End;
end;

procedure TSharpEColorPanelEx.SetItems(const Value: TSharpEColorPanelExItems);
begin
  FItems.Assign(Value);
end;

procedure TSharpEColorPanelEx.SetName(const Value: TComponentName);
begin
  inherited;

  if FDesignLabel <> nil then
    FDesignLabel.Caption := Value;
end;

end.
