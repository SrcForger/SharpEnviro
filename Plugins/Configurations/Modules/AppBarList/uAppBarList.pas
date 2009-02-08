unit uAppBarList;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Forms,
  Variants,
  Classes,
  ImgList,
  Controls,
  Graphics,

  JvSimpleXml, JclSimpleXml,
  SharpApi, SharpCenterApi,
  ISharpCenterHostUnit,

  IXmlBaseUnit;

type
  TAppBarItem = class(TPersistent)
  private
    FName: string;
    FIcon: string;
    FCommand: string;
    FId: Integer;
  published
  public
    constructor Create(name, command, icon: string);
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property Command: string read FCommand write FCommand;
    property Icon: string read FIcon write FIcon;
  end;

  TAppBarList = class(TInterfacedXmlBaseList)
  private
    FFilename: string;
    function GetButtonItem(index: integer): TAppBarItem;
  public
    function AddButtonItem: TAppBarItem; overload;
    function AddButtonItem(name, command, icon: string): TAppBarItem; overload;
    function IndexOfName(name: string): integer;
    property ButtonItem[Index: integer]: TAppBarItem read GetButtonItem; default;
    procedure Load;
    procedure Save;

    property Filename: string read FFilename write FFilename;
  end;

implementation

{ TAppBarList }

function TAppBarList.AddButtonItem: TAppBarItem;
begin
  Result := TAppBarItem.Create('', '', '');
  Result.Id := Count;
  Add(Result);
end;

function TAppBarList.AddButtonItem(name, command, icon: string): TAppBarItem;
begin
  Result := TAppBarItem.Create(name, command, icon);
  Result.Id := Count;
  Add(Result);
end;

function TAppBarList.GetButtonItem(Index: integer): TAppBarItem;
begin
  Result := nil;
  if Self.Get(Index) <> nil then
    Result := TAppBarItem(Self.Items[Index]);
end;

function TAppBarList.IndexOfName(name: string): integer;
var
  i:integer;
begin
  result := -1;
  for i := 0 to Pred(Self.Count) do begin
    if CompareText( name, Self[i].Name ) <> -1 then
      result := i;
  end;
end;

procedure TAppBarList.Load;
var
  i: integer;
  elemRoot, elemItem: TJclSimpleXMLElem;
begin
  Clear;

  Xml.XmlFilename := FFilename;
  if Xml.Load then begin
    with Xml.XmlRoot do begin

      elemRoot := Items.ItemNamed['Apps'];

      if elemRoot <> nil then
        with elemRoot.Items do
          for i := 0 to Pred(elemRoot.Items.Count) do begin
            elemItem := elemRoot.Items.Item[i];

            AddButtonItem(elemItem.Items.Value('Caption', 'Unknown'),
              elemItem.Items.Value('Target', 'Unknown'),
                elemItem.Items.Value('Icon', ''));
          end;
    end;
  end;
end;

procedure TAppBarList.Save;
var
  i: integer;
  elemRoot, elemItem: TJclSimpleXMLElem;
begin
  Xml.XmlRoot.Clear;
  Xml.XmlRoot.Name := 'ApplicationBarModuleSettings';
  Xml.Load;

  with Xml.XmlRoot do begin

    if Items.ItemNamed['Apps'] = nil then
      elemRoot := Items.Add('Apps') else
      elemRoot := Items.ItemNamed['Apps'];

    elemRoot.Clear;
    
    for i := 0 to Pred(Self.Count) do begin
      elemItem := elemRoot.Items.Add('Item');
      elemItem.Items.Add('Target', ButtonItem[i].Command);
      elemItem.Items.Add('Icon', ButtonItem[i].Icon);
      elemItem.Items.Add('Caption', ButtonItem[i].Name);
    end;
  end;

  Xml.XmlFilename := FFilename;
  Xml.Save;
end;

{ TButtonBarItem }

constructor TAppBarItem.Create(name, command, icon: string);
begin
  FName := Name;
  FCommand := command;
  FIcon := icon;
end;

end.

