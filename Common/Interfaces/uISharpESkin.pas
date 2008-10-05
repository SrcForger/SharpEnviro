unit uISharpESkin;

interface

uses
  SharpESkinManager;

type
  ISharpESkin = interface(IInterface)
    ['{B018E16F-7177-4F7F-B53A-EF04D1B37EAA}']
    function GetSkinManager : TSharpESkinManager;
    property SkinManager : TSharpESkinManager read GetSkinManager;
  end;

implementation

end.
