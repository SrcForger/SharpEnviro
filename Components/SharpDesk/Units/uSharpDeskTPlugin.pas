unit uSharpDeskTPlugin;

interface

uses ExtCtrls,Windows;

type
    pPlugin = ^plugin;
    plugin = record
              PackageIndex : integer;
              Width,Height : integer;
              PosX,PosY  : integer;
              next : pPlugin;
              ObjectID : integer;
              Locked,ClickTopMost : boolean;
              Selected : boolean;
             end;

implementation

end.
