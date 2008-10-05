unit uSharpESkinInterface;

interface

uses
  uISharpESkin,
  SharpESkin,
  SharpTypes,
  Classes,
  SharpESkinManager;

type
  TSharpESkinInterface = class(TInterfacedObject, ISharpESkin)
    private
      FSkinManager : TSharpESkinManager;
    public
      constructor Create(AOwner: TComponent; Skins : TSharpESkinItems = ALL_SHARPE_SKINS); reintroduce;
      destructor Destroy; override;

      function GetSkinManager : TSharpESkinManager;
      property SkinManager : TSharpESkinManager read GetSkinManager;
  end;

implementation

{ TSharpESkinInterface }

constructor TSharpESkinInterface.Create(AOwner: TComponent; Skins : TSharpESkinItems = ALL_SHARPE_SKINS);
begin
  FSkinManager := TSharpESkinManager.Create(AOwner, Skins);
  FSkinManager.HandleUpdates := False;
  FSkinManager.SkinSource := ssSystem;
  FSkinManager.SchemeSource := ssSystem;
  FSkinManager.Skin.UpdateDynamicProperties(FSkinManager.Scheme);
end;

destructor TSharpESkinInterface.Destroy;
begin
  FSkinManager.Free;
  
  inherited;
end;

function TSharpESkinInterface.GetSkinManager: TSharpESkinManager;
begin
  result := FSkinManager;
end;

end.
