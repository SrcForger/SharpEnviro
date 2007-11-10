unit uComponentMan;

interface
uses
  SharpAPI,
  Classes,
  SysUtils;

type

  TComponentData = Class(TObject) //record to store needed data
  public
    MetaData: TMetaData;
    Priority: Integer;
    Delay: Integer;
    ID: Integer;
    FileName: String;
    FileHandle: THandle;
    Running: Boolean;
  end;

  TComponentList = Class(TList) //this is our list of components and services
  public
    function Add(Item: TComponentData): Integer;
    function BuildList(strExtension: String): Integer;
    function FindByName(Name: String): Integer;
    function FindByID(ID: Integer): Integer;
  End;

implementation

function RemoveSpaces(Input: String): String;
const Remove = [' ', #13, #10];
var
  i: integer;
begin
  result := '';
  for i := 1 to Length(Input) do begin
    if not (Input[i] in Remove) then
      result := result + Input[i];
  end;
end;

function CheckLocation(Item1, Item2: TComponentData): Integer; //function to sort by priority
begin
  result := 0;
  if Item1.Priority < Item2.Priority then
    result := -1
  else if Item1.Priority = Item2.Priority then
    result := 0
  else if Item1.Priority > Item2.Priority then
    result := 1;
end;

function TComponentList.FindByName(Name: String): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
  begin
    if LowerCase(TComponentData(Items[i]).MetaData.Name) = LowerCase(Name) then
      result := i;
  end;
  if result = -1 then  // if it didn't find it, let's check for it with spaces removed
    for i := 0 to Count - 1 do  // for the sake of backwards compatibility
    begin
      if LowerCase(RemoveSpaces(TComponentData(Items[i]).MetaData.Name)) = LowerCase(Name) then
        result := i;
    end;
end;

function TComponentList.FindByID(ID: Integer): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
  begin
    if TComponentData(Items[i]).ID = ID then
      result := i;
  end;
end;

function TComponentList.Add(Item: TComponentData): Integer;
begin
  result := 0;
  inherited Add(Item); //add item
  inherited Sort(@CheckLocation); //sort the list
end;

function TComponentList.BuildList(strExtension: String): Integer;
var
  intFound: Integer;
  srFile: TSearchRec;
  cdComponent: TComponentData;
  sPath: String;
begin
  sPath := GetSharpeDirectory + 'Services\';
  intFound := FindFirst(sPath + '*' + strExtension, faAnyFile, srFile); //first we loop through the services
  while intFound = 0 do
  begin
    cdComponent := TComponentData.Create;
    cdComponent.FileName := sPath + srFile.Name;
    GetServiceMetaData(sPath + srFile.Name, cdComponent.MetaData, cdComponent.Priority, cdComponent.Delay);
    cdComponent.ID := Count + 50; //add 50 to ID to make sure it's unique
    Add(cdComponent);
    //cdComponent.Free;
    intFound := FindNext(srFile);
  end;
  FindClose(srFile);

  sPath := GetSharpeDirectory;
  intFound := FindFirst(sPath + '*.exe', faAnyFile, srFile); //then we loop through components
  while intFound = 0 do
  begin
    cdComponent := TComponentData.Create;
    cdComponent.FileName := sPath + srFile.Name;
    //wrap in an if statement so we don't get blank entries for non-sharpe executables that might be in the folder
    if GetComponentMetaData(sPath + srFile.Name, cdComponent.MetaData, cdComponent.Priority, cdComponent.Delay) = 0 then
    begin
      cdComponent.ID := Count + 50;
      Add(cdComponent);
    end;
    //cdComponent.Free;
    intFound := FindNext(srFile);
  end;
  FindClose(srFile);
  result := Count;
end;

end.
