unit uTaskswitchUtility;

interface
uses
  Classes,
  ContNrs,
  SysUtils,
  Forms,
  windows,
  JclFileUtils,
  JclStrings,
  SharpThemeApi,
  JclSimpleXml,
  SharpApi,
  graphics,

  IXmlBaseUnit;

type

  TTaskSwitchItem = class
  private
    FName: string;
    FPreview: boolean;
    FGui: boolean;
    FExcludeFilters: string;
    FCycleForward: boolean;
    FIncludeFilters: string;
    FAction: string;

  public
    property Name: string read FName write FName;
    property Action: string read FAction write FAction;
    property CycleForward: boolean read FCycleForward write FCycleForward;
    property Gui: boolean read FGui write FGui;
    property Preview: boolean read FPreview write FPreview;
    property IncludeFilters: string read FIncludeFilters write FIncludeFilters;
    property ExcludeFilters: string read FExcludeFilters write FExcludeFilters;

  end;

  TTaskSwitchItemList = class(TInterfacedXmlBaseList)
  private
    FFilename: string;

  public
    function AddItem: TTaskSwitchItem;
    property FileName: string read FFilename write FFilename;
    procedure Load;
    procedure Save;
    function IndexOfName(AName: string): integer;
    function IndexOfAction(AAction: string): integer;


    constructor Create; reintroduce;
  end;

implementation

{ TTaskSwitchItemList }

function TTaskSwitchItemList.AddItem: TTaskSwitchItem;
begin
  Result := TTaskSwitchItem.Create;
  Add(Result);
end;

constructor TTaskSwitchItemList.Create;
begin
  inherited Create;

  FFilename := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\TaskSwitch\';
  FFilename := FFilename + 'actions.xml';
end;

function TTaskSwitchItemList.IndexOfAction(AAction: string): integer;
var
  i: Integer;
  tmp: TTaskSwitchItem;
begin
  result := -1;
  for i := 0 to Pred(Self.Count) do begin
    tmp := TTaskSwitchItem(Self.Get(i));
    if CompareText(tmp.Action,AAction) = 0 then begin
      result := i;
      break;
    end;
  end;
end;

function TTaskSwitchItemList.IndexOfName(AName: string): Integer;
var
  i: Integer;
  tmp: TTaskSwitchItem;
begin
  result := -1;
  for i := 0 to Pred(Self.Count) do begin
    tmp := TTaskSwitchItem(Self.Get(i));
    if CompareText(tmp.Name,AName) = 0 then begin
      result := i;
      break;
    end;
  end;
end;

procedure TTaskSwitchItemList.Load;
var
  iTaskSwitch: integer;
  i: integer;
  taskSwitchElem: TJclSimpleXMLElem;
  tmp: TTaskSwitchItem;
  sl: TStringList;
begin
  Self.Clear;

  Xml.XmlFilename := FFilename;
  if Xml.Load then begin

    with Xml do begin

      for iTaskSwitch := 0 to Pred(XmlRoot.Items.Count) do
      begin
        taskSwitchElem := XmlRoot.Items.Item[iTaskSwitch];

        with taskSwitchElem.Items do begin

          tmp := AddItem;
          tmp.Name := Value('Name', '');
          tmp.Action := Value('Action', '');
          tmp.Gui := BoolValue('UseGui', False);
          tmp.CycleForward := BoolValue('CForward', True);
          tmp.Preview := BoolValue('Preview', True);

          sl := TStringList.Create;
          try

            // Include
            sl.Clear;
            sl.StrictDelimiter := true;
            if ItemNamed['IFilters'] <> nil then begin
              for i := 0 to Pred(ItemNamed['IFilters'].Items.Count) do

                if ItemNamed['IFilters'].Items.Item[i].Value <> '' then
                  sl.Add(ItemNamed['IFilters'].Items.Item[i].Value);

              if sl.Count <> 0 then
                tmp.IncludeFilters := sl.CommaText;
            end;

            // Exclude
            sl.Clear;
            sl.StrictDelimiter := true;
            if ItemNamed['EFilters'] <> nil then begin
              for i := 0 to Pred(ItemNamed['EFilters'].Items.Count) do

                if ItemNamed['EFilters'].Items.Item[i].Value <> '' then
                  sl.Add(ItemNamed['EFilters'].Items.Item[i].Value);

              if sl.Count <> 0 then
                tmp.ExcludeFilters := sl.CommaText;
            end;

          finally
            sl.Free;
          end;
        end;

      end;
    end;
  end;
end;

procedure TTaskSwitchItemList.Save;
var
  iTaskSwitch: integer;
  i: integer;
  taskSwitchElem: TJclSimpleXMLElem;
  tmp: TTaskSwitchItem;
begin

  with Xml do begin
    XmlRoot.Clear;
    XmlRoot.Name := 'TaskSwitchList';

    for iTaskSwitch := 0 to Pred(self.Count) do
    begin
      tmp := TTaskSwitchItem(Items[iTaskSwitch]);
      taskSwitchElem := Xml.XmlRoot.Items.Add('Action');

      with taskSwitchElem.Items do begin

        Add('Name',tmp.Name);
        Add('Action',tmp.Action);
        Add('UseGui',tmp.Gui);
        Add('CForward',tmp.CycleForward);
        Add('Preview',tmp.Preview);

        with taskSwitchElem.Items.Add('IFilters') do begin
          Items.Add('Filter',StrRemoveChars(tmp.FIncludeFilters,['"']));
        end;

        with taskSwitchElem.Items.Add('EFilters') do begin
          Items.Add('Filter',StrRemoveChars(tmp.ExcludeFilters,['"']));
        end;

      end;

    end;
  end;

  Xml.XmlFilename := FFilename;
  Xml.Save;
end;

{ TTaskSwitchItem }

end.

