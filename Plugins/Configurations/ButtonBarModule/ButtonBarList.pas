unit ButtonBarList;

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

  JvSimpleXml,JclSimpleXml,
  uSharpBarApi, SharpApi, SharpCenterApi;

Type
  TButtonBarItem = class(TPersistent)
  private
    FName: String;
    FShowIcon: Boolean;
    FShowCaption: Boolean;
    FIcon: String;
    FCommand: String;
    FId: Integer;
  published
  public
    constructor Create(name, command, icon: String);
    property Id: Integer read FId write FId;
    property Name: String read FName write FName;
    property Command: String read FCommand write FCommand;
    property Icon: String read FIcon write FIcon;

    property ShowCaption: Boolean read FShowCaption write FShowCaption;
    property ShowIcon: Boolean read FShowIcon write FShowIcon;
  end;

  TButtonBarList = class(TList)
  private
    function GetButtonItem(index: integer): TButtonBarItem;
  private
    FModuleId: integer;
    FBarId: integer;
    FShowIcons, FShowCaptions: Boolean;
    FWidth: Integer;
  public
    function AddButtonItem: TButtonBarItem; overload;
    function AddButtonItem( name, command, icon: String ): TButtonBarItem; overload;
    property ButtonItem[Index: integer]: TButtonBarItem read GetButtonItem; default;
    procedure Load;
    procedure Save;

    property BarId: integer read FBarId write FBarId;
    property ModuleId: integer read FModuleId write FModuleId;
  published
  published
  private
end;

implementation

{ TButtonBarList }

function TButtonBarList.AddButtonItem: TButtonBarItem;
begin
  Result := TButtonBarItem.Create( '','','');
  Result.Id := Count;
  Add(Result);
end;

function TButtonBarList.AddButtonItem(name, command,
  icon: String): TButtonBarItem;
begin
  Result := TButtonBarItem.Create( name, command, icon );
  Result.Id := Count;
  Add(Result);
end;

function TButtonBarList.GetButtonItem(Index: integer): TButtonBarItem;
begin
  Result := nil;
  if Self.Get(Index) <> nil then
    Result := TButtonBarItem(Self.Items[Index]);
end;

procedure TButtonBarList.Load;
var
  xml : TJvSimpleXML;
  fileloaded : boolean;
  i : integer;
begin
  Clear;

  xml := TJvSimpleXML.Create(nil);
  try

  try
    xml.LoadFromFile(GetModuleXMLFile(BarID, ModuleID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      FShowIcons := BoolValue('ShowIcon',True);
      FShowCaptions := BoolValue('ShowCaption',False);
      FWidth := IntValue('Width',25);

      if ItemNamed['Buttons'] <> nil then
      with ItemNamed['Buttons'].Items do
           for i := 0 to Pred(Count) do
               AddButtonItem( Item[i].Items.Value('Caption','C:\'),
                  Item[i].Items.Value('Target','C:\'), Item[i].Items.Value('Icon','shell:icon'));
    end;
  finally
    xml.Free;
  end;
end;

procedure TButtonBarList.Save;
var
  xml : TJvSimpleXML;
  i : integer;
  elemRoot, elemItem: TJclSimpleXMLElemClassic;
begin
  xml := TJvSimpleXMl.Create(nil);
  try

  xml.Root.Name := 'ButtonBarModuleSettings';
  xml.Root.Items.Add('ShowIcon',FShowIcons);
  xml.Root.Items.Add('ShowCaption',FShowCaptions);
  xml.Root.Items.Add('Width',FWidth);

  elemRoot := xml.Root.Items.Add('Buttons');

  for i := 0 to Pred(Count) do begin
    elemItem := elemRoot.Items.Add('Item');
    elemItem.Items.Add('Target',ButtonItem[i].Command);
    elemItem.Items.Add('Icon',ButtonItem[i].Icon);
    elemItem.Items.Add('Caption',ButtonItem[i].Name);
  end;

  xml.SaveToFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));

  finally
    xml.Free;
    BroadcastGlobalUpdateMessage(suModule, 0, True);
  end;
  
end;

{ TButtonBarItem }

constructor TButtonBarItem.Create(name, command, icon: String);
begin
  FName := Name;
  FCommand := command;
  FIcon := icon;
end;

end.
