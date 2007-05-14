unit SharpEColorEditorEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, SharpEColorEditor, SharpThemeApi, SharpApi,
  SharpESwatchCollection, SharpESwatchManager;



Type
  TSharpEColorEditorExItem = Class(TCollectionItem)
  private
    FTitle: String;
    FColorCode: Integer;
    FColorAsTColor: TColor;

    FParent: Pointer;
    FExpanded: Boolean;
    FParseColor: String;
    FColorEditor: TSharpEColorEditor;
    FTag: Integer;
    FData: TObject;
    FValueMin: Integer;
    FValueText: string;
    FDescription: string;
    FValue: Integer;
    FValueMax: Integer;
    FColorEditorType: TColorEditorType;


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
    procedure SetColorEditorType(const Value: TColorEditorType);
    procedure SetDescription(const Value: string);
    procedure SetValue(const Value: Integer);
    procedure SetValueMax(const Value: Integer);
    procedure SetValueMin(const Value: Integer);
    procedure SetValueText(const Value: string);


  public

    destructor Destroy; override;
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

    property ColorEditorType: TColorEditorType read FColorEditorType write
      SetColorEditorType;

    property Description: string read FDescription write SetDescription;
    property ValueText: string read FValueText write SetValueText;
    property ValueMax: Integer read FValueMax write SetValueMax;
    property ValueMin: Integer read FValueMin write SetValueMin;
    property Value: Integer read FValue write SetValue;

    property ColorEditor: TSharpEColorEditor read FColorEditor write FColorEditor;

    property Tag: Integer read FTag write FTag;
    property Data: TObject read FData write FData;
end;

type
  TSharpEColorEditorExItems = Class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TSharpEColorEditorExItem;
    procedure SetItem(Index: Integer; const Value: TSharpEColorEditorExItem);
  protected
     procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);

    function Add(AOwner:TComponent):TSharpEColorEditorExItem;
    procedure Delete(AIndex: Integer); overload;
    procedure Delete(AItem: TSharpEColorEditorExItem); overload;
    property Item[Index: Integer]: TSharpEColorEditorExItem read GetItem write SetItem;
    function IndexOf(const Name: string): Integer;
  end;

Type
  TSharpEColorEditorEx = Class(TScrollBox)
  private
    FItems: TSharpEColorEditorExItems;
    FDesignLabel: TLabel;
    FSwatchManager: TSharpESwatchManager;
    FUpdate: Boolean;
    FOnChangeColor: TColorChangeEvent;
    FOnSliderChange: TNotifyEvent;

    procedure SetItems(const Value: TSharpEColorEditorExItems);
    procedure SetSwatchManager(const Value: TSharpESwatchManager);
    procedure ResizeEvent(Sender:TObject);
    procedure ChangeSliderEvent(Sender:TObject);
  public
    constructor Create(Sender: TComponent); override;

    procedure BeginUpdate;
    procedure EndUpdate;

    procedure PopulateItems;
    destructor Destroy; override;

  protected
    procedure SetName(const Value: TComponentName); override;
    procedure Loaded; override;
    
  published
    property Align;
    property Anchors;
    property Items: TSharpEColorEditorExItems read FItems write SetItems stored True;
    property SwatchManager: TSharpESwatchManager read FSwatchManager write SetSwatchManager;

    property OnChangeColor: TColorChangeEvent read FOnChangeColor write FOnChangeColor;
    property OnSliderChange: TNotifyEvent read FOnSliderChange write FOnSliderChange;
end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpEColorEditorEx]);
end;

{ TSharpEColorEditorExItem }

procedure TSharpEColorEditorExItem.SetColorCode(const Value: Integer);
begin
  FColorCode := Value;
  FColorAsTColor := Value;

  if FColorEditor <> nil then begin
    FColorEditor.OverrideSliderUpdateMode(sumAll);
    FColorEditor.ColorCode := Value;
  end;
end;

procedure TSharpEColorEditorExItem.SetColorAsTColor(const Value: TColor);
begin
  FColorAsTColor := Value;
  FColorCode := Value;

  if FColorEditor <> nil then
    FColorEditor.ColorAsTColor := Value;
end;

function TSharpEColorEditorExItem.GetExpanded: Boolean;
begin
  if FColorEditor <> nil then
    Result := FColorEditor.Expanded;
end;

procedure TSharpEColorEditorExItem.SetExpanded(const Value: Boolean);
begin
  FExpanded := Value;

  if FExpanded then begin
    TabclickEvent(Self);
  end;
end;

destructor TSharpEColorEditorExItem.Destroy;
begin

  inherited;
end;

procedure TSharpEColorEditorExItem.ColorChangeEvent(ASender: TObject;
  AColorCode: Integer);
begin
  FColorCode := TSharpEColorEditor(ASender).ColorCode;
  FColorAsTColor := TSharpEColorEditor(ASender).ColorAsTColor;
  FValue := TSharpEColorEditor(ASender).Value;

  if TSharpEColorEditorEx(FParent) <> nil then
    if Assigned(TSharpEColorEditorEx(FParent).FOnChangeColor) then begin

      if FColorEditorType = cetColor then
      TSharpEColorEditorEx(FParent).OnChangeColor(Self,FColorCode) else
      TSharpEColorEditorEx(FParent).OnChangeColor(Self,FValue);
    end;

  //TSharpEColorEditor(ASender).Update;
end;

procedure TSharpEColorEditorExItem.SetTitle(const Value: String);
begin
  FTitle := Value;

  if FColorEditor <> nil then
    FColorEditor.Caption := Value;
end;


function TSharpEColorEditorExItem.GetDisplayName: string;
begin
  Result := 'Item' + IntToStr(id);
end;

function TSharpEColorEditorExItem.GetNamePath: string;
begin
  Result := ClassName;
end;

procedure TSharpEColorEditorExItem.TabclickEvent(Sender: TObject);
var
  i:Integer;
begin
  if FColorEditor = nil then exit;

  if FParent <> nil then begin
    TSharpEColorEditorEx(FParent).DisableAlign;
    TSharpEColorEditorEx(FParent).DisableAutoRange;
  end;

  // collapse all
  For i := 0 to Pred(Collection.Count) do begin
    TSharpEColorEditor(TSharpEColorEditorExItem(Collection.Items[i]).ColorEditor).Collapse;
    TSharpEColorEditorExItem(Collection.Items[i]).Expanded := False;

  end;

  // Expand selected
  For i := 0 to Pred(Collection.Count) do begin
    if TSharpEColorEditorExItem(Collection.Items[i]) = Self then begin
      FColorEditor.Expanded := True;
      FColorEditor.SelectDefaultTab;

    end;
  end;

  if FParent <> nil then begin
    TSharpEColorEditorEx(FParent).EnableAlign;
    TSharpEColorEditorEx(FParent).EnableAutoRange;
  end;

  FColorEditor.SwatchManager :=
    TSharpEColorEditorEx(FParent).SwatchManager;

end;

function TSharpEColorEditorExItem.GetColorCode: Integer;
begin
  if FColorEditor <> nil then
    Result := FColorEditor.ColorCode;
end;

function TSharpEColorEditorExItem.GetColorAsTColor: TColor;
begin
  if FColorEditor <> nil then
    Result := FColorEditor.ColorAsTColor;
end;

procedure TSharpEColorEditorExItem.SetParseColor(const Value: String);
var
  col: TColor;
begin

  try
  col := sharpthemeapi.parsecolor(PChar(Value));

  if FColorEditor <> nil then begin
    FColorEditor.OverrideSliderUpdateMode(sumAll);
    FColorEditor.ColorCode := col;
  end;
  except
  end;
end;

procedure TSharpEColorEditorEx.EndUpdate;
begin
  FUpdate := True;
  PopulateItems;
end;

procedure TSharpEColorEditorEx.BeginUpdate;
begin
  FUpdate := False;
end;

procedure TSharpEColorEditorExItem.SetValueMin(const Value: Integer);
begin
  FValueMin := Value;

  if FColorEditor <> nil then begin
    FColorEditor.ValueMin := Value;
  end;
end;

procedure TSharpEColorEditorExItem.SetValueText(const Value: string);
begin
  FValueText := Value;

  if FColorEditor <> nil then begin
    FColorEditor.ValueText := Value;
  end;
end;

procedure TSharpEColorEditorExItem.SetDescription(const Value: string);
begin
  FDescription := Value;

  if FColorEditor <> nil then begin
    FColorEditor.Description := Value;
  end;
end;

procedure TSharpEColorEditorExItem.SetValue(const Value: Integer);
begin
  FValue := Value;

  if FColorEditor <> nil then begin
    FColorEditor.Value := Value;
  end;
end;

procedure TSharpEColorEditorExItem.SetValueMax(const Value: Integer);
begin
  FValueMax := Value;

  if FColorEditor <> nil then begin
    FColorEditor.ValueMax := Value;
  end;
end;

procedure TSharpEColorEditorExItem.SetColorEditorType(
  const Value: TColorEditorType);
begin
  FColorEditorType := Value;

  if FColorEditor <> nil then begin
    FColorEditor.ColorEditorType := Value;
  end;
end;

{ TSharpEColorEditorExItems }

function TSharpEColorEditorExItems.Add(
  AOwner: TComponent): TSharpEColorEditorExItem;
begin
  result := inherited Add as TSharpEColorEditorExItem;
end;

function TSharpEColorEditorExItems.GetItem(
  Index: Integer): TSharpEColorEditorExItem;
begin
  result := inherited Items[Index] as TSharpEColorEditorExItem;
end;

procedure TSharpEColorEditorExItems.SetItem(Index: Integer;
  const Value: TSharpEColorEditorExItem);
begin
  inherited Items[Index] := Value;
end;

procedure TSharpEColorEditorExItems.Delete(AItem: TSharpEColorEditorExItem);
begin

end;

procedure TSharpEColorEditorExItems.Delete(AIndex: Integer);
begin
  inherited Items[AIndex] as TSharpEColorEditorExItem;
end;

function TSharpEColorEditorExItems.IndexOf(const Name: string): Integer;
begin
  for Result := 0 to Count - 1 do
    if AnsiCompareText(Items[Result].DisplayName, Name) = 0 then
      Exit;
  Result := -1;
end;

constructor TSharpEColorEditorExItems.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TSharpEColorEditorExItem);
end;

procedure TSharpEColorEditorExItems.Update(Item: TCollectionItem);
begin
  inherited Update(Item);

  if Owner <> nil then
     TSharpEColorEditorEx(Owner).PopulateItems;
end;

{ TSharpEColorEditorEx }

constructor TSharpEColorEditorEx.Create(Sender: TComponent);
begin
  inherited Create(Sender);

  ParentBackground := False;
  DoubleBuffered := True;
  ParentColor := False;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BorderWidth := 4;
  Color := clWindow;
  BorderStyle := bsNone;
  OnResize := ResizeEvent;
  FUpdate := True;

  FItems := TSharpEColorEditorExItems.Create(Self);

end;

destructor TSharpEColorEditorEx.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TSharpEColorEditorEx.Loaded;
begin
  inherited;
end;

procedure TSharpEColorEditorEx.PopulateItems;
var
  tmp:TSharpEColorEditor;
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

  if Not(FUpdate) then begin
    exit;
  end;

  Self.DisableAlign;
  Self.DisableAutoRange;
  Self.Updating;
  Self.Visible := False;

  Try
  For i := Pred(ComponentCount) downto 0 do
    if Components[i] is TSharpEColorEditor then begin
      TSharpEColorEditor(Components[i]).Free;
    end;

  For i := 0 to Pred(FItems.Count) do begin
    tmp := TSharpEColorEditor.Create(Self);
    tmp.Parent := self;
    tmp.SwatchManager := FSwatchManager;

    FItems.Item[i].ColorEditor := tmp;
    FItems.Item[i].Parent := Self;


    tmp.Align := alTop;
    tmp.GroupIndex := 0;
    tmp.ColorCode := FItems.Item[i].FColorCode;
    tmp.ColorAsTColor := FItems.Item[i].FColorAsTColor;
    tmp.Caption := FItems.Item[i].Title;

    tmp.ColorEditorType := FItems.item[i].FColorEditorType;
    tmp.ValueText := FItems.Item[i].FValueText;
    tmp.Value := FItems.Item[i].Value;
    tmp.ValueMax := FItems.Item[i].ValueMax;
    tmp.ValueMin := FItems.Item[i].ValueMin;
    tmp.Description := FItems.Item[i].Description;

    tmp.Expanded := FItems.Item[i].Expanded;
    tmp.Name := 'Item' + intToStr(i);

    tmp.OnColorChange := FItems.Item[i].ColorChangeEvent;
    tmp.OnTabClick := FItems.Item[i].TabclickEvent;
    tmp.OnSliderChange := ChangeSliderEvent;

    tmp.Height := 24;
  end;

  Finally


    Self.EnableAlign;
    Self.EnableAutoRange;
    Self.Updated;
    self.Visible := True;
  End;
end;

procedure TSharpEColorEditorEx.ResizeEvent(Sender: TObject);
begin
  if ((FSwatchManager <> nil) and (FUpdate)) then
    FSwatchManager.Resize;
end;

procedure TSharpEColorEditorEx.SetItems(const Value: TSharpEColorEditorExItems);
begin
  FItems.Assign(Value);
end;

procedure TSharpEColorEditorEx.SetName(const Value: TComponentName);
begin
  inherited;

  if FDesignLabel <> nil then
    FDesignLabel.Caption := Value;
end;

procedure TSharpEColorEditorEx.SetSwatchManager(
  const Value: TSharpESwatchManager);
var
  i:Integer;
begin
  FSwatchManager := Value;

  For i := 0 to Pred(FItems.Count) do begin
    FItems.Item[i].ColorEditor.SwatchManager := FSwatchManager;
  end;
end;

procedure TSharpEColorEditorEx.ChangeSliderEvent(Sender: TObject);
begin
  if Assigned(FOnSliderChange) then
    FOnSliderChange(Sender);
end;

end.

