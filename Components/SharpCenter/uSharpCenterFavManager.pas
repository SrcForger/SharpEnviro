unit uSharpCenterFavManager;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ExtCtrls,
  JvSimpleXml;

Type
  TSharpCenterFavManagerItem = class
  private
    FName: String;
    FCommand: String;
    FParameter: String;
    FIconFileName: String;
    FPluginID: String;
  public
    property Name: String read FName write FName;
    Property Command: String read FCommand write FCommand;
    property Parameter: String read FParameter write FParameter;
    property PluginID: String read FPluginID write FPluginID;
    property IconFileName: String read FIconFileName write FIconFileName;
end;

Type
  TSharpCenterFavManager = class
end;

implementation

end.
