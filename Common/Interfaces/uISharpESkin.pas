unit uISharpESkin;

interface

uses
  ISharpESkinComponents;

type
  ISharpESkinInterface = interface(IInterface)
    ['{B018E16F-7177-4F7F-B53A-EF04D1B37EAA}']
    function GetSkinManager : ISharpESkinManager; stdcall;
    property SkinManager : ISharpESkinManager read GetSkinManager;
  end;

implementation

end.
