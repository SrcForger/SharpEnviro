unit uButtonBarList;

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
  TButtonBarItem = class(TPersistent)
  private
    FName: string;
    FShowIcon: Boolean;
    FShowCaption: Boolean;
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

    property ShowCaption: Boolean read FShowCaption write FShowCaption;
    property ShowIcon: Boolean read FShowIcon write FShowIcon;
  end;

  TButtonBarList = class(TInterfacedXmlBaseList)
  private
    FShowIcons, FShowCaptions: Boolean;
    FWidth: Integer;
    FFilename: string;
    function GetButtonItem(index: integer): TButtonBarItem;
  public
    function AddButtonItem: TButtonBarItem; overload;
    function AddButtonItem(name, command, icon: string): TButtonBarItem; overload;
    function IndexOfName(name: string): integer;
    property ButtonItem[Index: integer]: TButtonBarItem read GetButtonItem; default;
    procedure Load;
    procedure Save;

    property Filename: string read FFilename write FFilename;
  end;

implementation

{ TButtonBarList }

function TButtonBarList.AddButtonItem: TButtonBarItem;
begin
  Result := TButtonBarItem.Create('', '', '');
  Result.Id := Count;
  Add(Result);
end;

function TButtonBarList.AddButtonItem(name, command,
  icon: string): TButtonBarItem;
begin
  Result := TButtonBarItem.Create(name, command, icon);
  Result.Id := Count;
  Add(Result);
end;

function TButtonBarList.GetButtonItem(Index: integer): TButtonBarItem;
begin
  Result := nil;
  if Self.Get(Index) <> nil then
    Result := TButtonBarItem(Self.Items[Index]);
end;

function TButtonBarList.IndexOfName(name: string): integer;
var
  i:integer;
begin
  result := -1;
  for i := 0 to Pred(Self.Count) do begin
    if CompareText( name, Self[i].Name ) <> -1 then
      result := i;
  end;
end;

procedure TButtonBarList.Load;
var
  i: integer;
  elemRoot, elemItem: TJclSimpleXMLElem;
begin
  Clear;

  Xml.XmlFilename := FFilename;
  if Xml.Load then begin
    with Xml.XmlRoot do begin

      elemRoot := Items.ItemNamed['Buttons'];

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

procedure TButtonBarList.Save;
var
  i: integer;
  elemRoot, elemItem: TJclSimpleXMLElem;
begin
  Xml.XmlRoot.Clear;
  Xml.XmlRoot.Name := 'ButtonBarModuleSettings';
  Xml.Load;

  with Xml.XmlRoot do begin

    if Items.ItemNamed['Buttons'] = nil then
      elemRoot := Items.Add('Buttons') else
      elemRoot := Items.ItemNamed['Buttons'];

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

constructor TButtonBarItem.Create(name, command, icon: string);
begin
  FName := Name;
  FCommand := command;
  FIcon := icon;
end;

end.

