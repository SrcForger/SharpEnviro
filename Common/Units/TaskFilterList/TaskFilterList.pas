unit TaskFilterList;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Contnrs,
  Forms,
  Dialogs,

  JclSimpleXml,

  SWCmdList, SharpApi;

type
  TFilterItemType = (fteSWCmd, fteWindow, fteProcess, fteCurrentMonitor,
    fteCurrentVWM, fteMinimised);

  TFilterItem = class(TPersistent)
  public
    Id: Integer;
      Name: string;
    FileName: string;
    WndClassName: string;
    FilterType: TFilterItemType;
    SWCmds: TSWCmdEnums;
    CurrentMonitor: Boolean;
    CurrentVWM: Boolean;
    Minimised: Boolean;

    procedure Assign(AFilterItem: TPersistent); override;
    constructor Create;
  end;

  TFilterItemList = class(TObjectList)
  private
    function GetItem(Index: Integer): TFilterItem;
    procedure SetItem(Index: Integer; const Value: TFilterItem);
  public
    procedure Load;
    procedure Save;
    procedure Delete(AFilterItem: TFilterItem);

    function AddFilename(AName, AFileName: string): TFilterItem;
    function AddWndClass(AName, AWndClass: string): TFilterItem;
    function AddMinimised(AName: string; AMinimised: Boolean): TFilterItem;
    function AddCurrentVWM(AName: string; ACurrentVWM: Boolean): TFilterItem;
    function AddCurrentMonitor(AName: string; ACurrentMonitor: Boolean): TFilterItem;
    function AddSWCommands(AName: string; ASWCommands: TSWCmdEnums): TFilterItem;
    function AddItem(AItem: TFilterItem): TFilterItem;

    property Item[Index: Integer]: TFilterItem
    read GetItem write SetItem; default;

  end;

  function CustomSort(AItem1, AItem2:Pointer):Integer;

implementation

{ TFilterItemList }

function CustomSort(AItem1, AItem2:Pointer):Integer;
var
  tmp1,tmp2: TFilterItem;
begin
  tmp1 := TFilterItem(AItem1);
  tmp2 := TFilterItem(AItem2);
  Result := CompareText(tmp1.Name,tmp2.Name);
end;

function TFilterItemList.AddItem(AItem: TFilterItem): TFilterItem;
begin
  Add(AItem);
  AItem.Id := Self.Count;
  result := AItem;
end;

function TFilterItemList.AddCurrentMonitor(AName: string;
  ACurrentMonitor: Boolean): TFilterItem;
begin
  Result := TFilterItem.Create;
  Result.Name := AName;
  Result.CurrentMonitor := ACurrentMonitor;
  Result.FilterType := fteCurrentMonitor;

  Add(Result);
  Result.Id := Self.Count;
end;

function TFilterItemList.AddCurrentVWM(AName: string;
  ACurrentVWM: Boolean): TFilterItem;
begin
  Result := TFilterItem.Create;
  Result.Name := AName;
  Result.CurrentVWM := ACurrentVWM;
  Result.FilterType := fteCurrentVWM;

  Add(Result);
  Result.Id := Self.Count;
end;

function TFilterItemList.AddFilename(AName, AFileName: string): TFilterItem;
begin
  Result := TFilterItem.Create;
  Result.Name := AName;
  Result.FileName := AFileName;
  Result.FilterType := fteProcess;

  Add(Result);
  Result.Id := Self.Count;
end;

function TFilterItemList.AddMinimised(AName: string; AMinimised: Boolean): TFilterItem;
begin
  Result := TFilterItem.Create;
  Result.Name := AName;
  Result.Minimised := AMinimised;
  Result.FilterType := fteMinimised;

  Add(Result);
  Result.Id := Self.Count;
end;

function TFilterItemList.AddSWCommands(AName: string;
  ASWCommands: TSWCmdEnums): TFilterItem;
begin
  Result := TFilterItem.Create;
  Result.Name := AName;
  Result.SWCmds := ASWCommands;
  Result.FilterType := fteSWCmd;

  Add(Result);
  Result.Id := Self.Count;
end;

function TFilterItemList.AddWndClass(AName, AWndClass: string): TFilterItem;
begin
  Result := TFilterItem.Create;
  Result.Name := AName;
  Result.WndClassName := AWndClass;
  Result.FilterType := fteWindow;

  Add(Result);
  Result.Id := Self.Count;
end;

procedure TFilterItemList.Delete(AFilterItem: TFilterItem);
var
  n:Integer;
begin
  n := IndexOf(AFilterItem);
  if n <> -1 then Remove(AFilterItem);
end;

function TFilterItemList.GetItem(Index: Integer): TFilterItem;
begin
  Result := nil;

  if Index < Count then
    Result := TFilterItem(Items[index]);
end;

procedure TFilterItemList.Load;
var
  xml: TJclSimpleXML;
  sFile, sName: string;
  i, j: Integer;
  elems: TJclSimpleXMLElems;
  tmpCmds: TSWCmdEnums;
  sList: TStringList;
  showCmdsList: TWindowShowCommandList;
begin
  showCmdsList := TWindowShowCommandList.Create;
  showCmdsList.AddItems;

  Clear;
  sFile := GetSharpeUserSettingsPath + 'SharpCore\Services\Shell\TaskFilters.xml';
  if not (FileExists(sFile)) then exit;

  sList := TStringList.Create;
  xml := TJclSimpleXML.Create;
  try
    xml.LoadFromFile(sFile);
    if xml.Root.Name = 'TaskFilters' then begin

      for i := 0 to Pred(xml.Root.Items.Count) do begin

        elems := xml.Root.Items.Item[i].Items;
        sName := xml.Root.Items.Item[i].Properties.Value('Name');
        case TFilterItemType(xml.Root.Items.Item[i].Properties.IntValue('Type')) of
          fteSWCmd: begin
              tmpCmds := [];
              sList.CommaText := elems.Value('SW');

              for j := 0 to Pred(showCmdsList.Count) do begin

                if sList.IndexOf(showCmdsList[j].XmlText) <> -1 then
                  Include(tmpCmds, showCmdsList[j].SWCmd);
              end;

              AddSWCommands(sName, tmpCmds);
            end;
          fteWindow: AddWndClass(sName, elems.Value('WndClassName'));
          fteProcess: AddFilename(sName, elems.Value('FileName'));
          fteCurrentMonitor: AddCurrentMonitor(sName, elems.BoolValue('CurrentMonitor', False));
          fteCurrentVWM: AddCurrentVWM(sName, elems.BoolValue('CurrentVWM', False));
          fteMinimised: AddMinimised(sName, elems.BoolValue('Minimised', False));
        end;

      end;
    end;

  finally
    xml.Free;
    showCmdsList.Free;
    sList.Free;

    Self.Sort(CustomSort);
  end;
end;

procedure TFilterItemList.Save;
var
  sFile: string;
  xml: TJclSimpleXML;
  tmpFilter: TFilterItem;
  i, iItem: Integer;
  sList: TStringList;
  showCmds: TWindowShowCommandList;
begin
  showCmds := TWindowShowCommandList.Create;
  showCmds.AddItems;
  sFile := GetSharpeUserSettingsPath + 'SharpCore\Services\Shell\TaskFilters.xml';
  forceDirectories(ExtractFilePath(sFile));

  sList := TStringList.Create;
  xml := TJclSimpleXML.Create;
  xml.Root.Name := 'TaskFilters';
  try

    for iItem := 0 to Pred(Count) do begin
      tmpFilter := Item[iItem];
      xml.Root.Items.Add('TaskFilter');
      sList.Clear;

      xml.Root.Items[iItem].Properties.Add('Name', tmpFilter.Name);
      xml.Root.Items[iItem].Properties.Add('Type', Integer(tmpFilter.FilterType));

      with xml.Root.Items[iItem].items do begin

        case tmpFilter.FilterType of
          fteSWCmd: begin
              for i := 0 to Pred(showCmds.Count) do begin
                if showCmds[i].SWCmd in tmpFilter.SWCmds then
                  sList.Add(showCmds[i].XmlText);
              end;
              Add('SW', sList.CommaText);
            end;
          fteWindow: Add('WndClassName', tmpFilter.WndClassName);
          fteProcess: Add('FileName', tmpFilter.FileName);
          fteCurrentMonitor: Add('CurrentMonitor', tmpFilter.CurrentMonitor);
          fteCurrentVWM: Add('CurrentVWM', tmpFilter.CurrentVWM);
          fteMinimised: Add('Minimised', tmpFilter.Minimised);
        end;
      end;

    end;

  finally
    xml.SaveToFile(sFile);
    xml.Free;
    showCmds.Free;
    sList.Free;
  end;
end;

procedure TFilterItemList.SetItem(Index: Integer; const Value: TFilterItem);
begin
  if Index < Count then
    Item[Index] := Value;
end;

{ TFilterItem }

procedure TFilterItem.Assign(AFilterItem: TPersistent);
begin
  if AFilterItem is TFilterItem then
  begin
    Name := TFilterItem(AFilterItem).Name;
    FileName := TFilterItem(AFilterItem).FileName;
    WndClassName := TFilterItem(AFilterItem).WndClassName;
    FilterType := TFilterItem(AFilterItem).FilterType;

    SWCmds := TFilterItem(AFilterItem).SWCmds;
    CurrentMonitor := TFilterItem(AFilterItem).CurrentMonitor;
    CurrentVWM := TFilterItem(AFilterItem).CurrentVWM;
    Minimised := TFilterItem(AFilterItem).Minimised;
  end
  else
    inherited Assign(AFilterItem);

end;

constructor TFilterItem.Create;
begin
  Name := '';
  FileName := '';
  WndClassName := '';
  FilterType := fteSWCmd;
  SWCmds := [];
  CurrentMonitor := False;
  CurrentVWM := False;
  Minimised := False;
end;

end.

