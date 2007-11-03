unit uComponentMan;

interface
uses
  SharpAPI,
  Classes,
  SysUtils;

type
  TComponentList = Class(TList) //this is our list of components and services
  public
    function Add(Item: Pointer): Integer;
    function BuildList(strExtension: String): Integer;
  End;

  TComponentData = record //record to store needed data
    MetaData: TMetaData;
    Priority: Integer;
    Delay: Integer;
    ID: Integer;
    FileName: String;
  end;

implementation

function CheckLocation(Item1, Item2: Pointer): Integer; //function to sort by priority
var
  itm1Data: ^TComponentData;
  itm2Data: ^TComponentData;
  pri1: integer;
begin
  result := 0;
  itm1Data := Item1;
  itm2Data := Item2;
  pri1 := itm1Data^.Priority;
  if itm1Data^.Priority < itm2Data^.Priority then
    result := -1
  else if itm1Data^.Priority = itm2Data^.Priority then
    result := 0
  else if itm1Data^.Priority > itm2Data^.Priority then
    result := 1;
end;

function TComponentList.Add(Item: Pointer): Integer;
begin
  result := 0;
  inherited Add(Item); //add item
  inherited Sort(@CheckLocation); //sort the list
end;

function TComponentList.BuildList(strExtension: String): Integer;
var
  intFound: Integer;
  srFile: TSearchRec;
  cdComponent: ^TComponentData;
  sPath: String;
  iPriority: Integer;
  iDelay: Integer;
begin
  sPath := GetSharpeDirectory + 'Services\';
  intFound := FindFirst(sPath + '*' + strExtension, faAnyFile, srFile); //first we loop through the services
  while intFound = 0 do
  begin
    new(cdComponent);
    cdComponent^.FileName := sPath + srFile.Name;
    GetServiceMetaData(sPath + srFile.Name, cdComponent^.MetaData, cdComponent^.Priority, cdComponent^.Delay);
    cdComponent^.ID := Count + 50; //add 50 to ID to make sure it's unique
    Add(cdComponent);
    intFound := FindNext(srFile);
  end;
  FindClose(srFile);

  sPath := GetSharpeDirectory;
  intFound := FindFirst(sPath + '*.exe', faAnyFile, srFile); //then we loop through components
  while intFound = 0 do
  begin
    new(cdComponent);
    cdComponent^.FileName := sPath + srFile.Name;
    //wrap in an if statement so we don't get blank entries for non-sharpe executables that might be in the folder
    if GetComponentMetaData(sPath + srFile.Name, cdComponent^.MetaData, cdComponent^.Priority, cdComponent^.Delay) = 0 then
    begin
      cdComponent^.ID := Count + 50;
      Add(cdComponent);
    end;
    intFound := FindNext(srFile);
  end;
  FindClose(srFile);
  result := Count;
end;

end.
