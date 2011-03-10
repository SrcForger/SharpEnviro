unit uISharpESkin;

interface

uses
  GR32,
  ISharpESkinComponents;

type
  ISharpESkinInterface = interface(IInterface)
    ['{B018E16F-7177-4F7F-B53A-EF04D1B37EAA}']
    function GetSkinManager : ISharpESkinManager; stdcall;
    property SkinManager : ISharpESkinManager read GetSkinManager;

    function GetBackground : TBitmap32; stdcall;
    property Background : TBitmap32 read GetBackground;
  end;

implementation

end.
