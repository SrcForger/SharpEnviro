{
Source Name: uCompServiceAppStore
Description: Item storage settings class
Copyright (C)
              Zack Cerza - zcerza@coe.neu.edu (original dev)
              Pixol (Pixol@sharpe-shell.org)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uCompServiceList;
interface
uses
  // Standard
  Classes,
  ContNrs,
  SysUtils,
  SharpApi,
  dialogs,
  Forms,

  // JVCL
  JvSimpleXml;

type
  // "Private" Object, TComponentsList needs it...
  TComponentItem = class(TObject)
  private
    FID: Integer;
    FName: string;
    FDescription: string;
    FCommand: string;

    FAutoStart: Boolean;
    FRestartNotResponding: Boolean;
    FRestartCrash: Boolean;
    FProcessHandle: Integer;
  public
    property Name: string read FName write FName;
    property Description: string read FDescription write FDescription;
    property Command: string read FCommand write FCommand;

    property RestartNotResponding: Boolean read FRestartNotResponding write
      FRestartNotResponding;
    property RestartCrash: Boolean read FRestartCrash write FRestartCrash;
    property AutoStart: Boolean read FAutoStart write FAutoStart;

    property ProcessHandle: Integer read FProcessHandle write FProcessHandle;
    property ID: Integer read FID write FID;
  end;

  TComponentsList = class(TObject)
  private
    FItems: TObjectList;
    FParent: tcomponent;
    FFileName: string;
    function GetCount: integer;
    function GeTComponentItem(Index: integer): TComponentItem;
    procedure SetParent(const Value: tcomponent);
  public
    constructor Create;
    destructor Destroy; override;

    function Add(Name, Description, Command: string;
      AutoStart, RestartNotResp, RestartCrash: Boolean; ProcessHandle: Integer):
      TComponentItem;

    procedure Delete(AInfo: TComponentItem);

    property Count: integer read GetCount;
    property Items: TObjectList read FItems write FItems;
    property Info[Index: integer]: TComponentItem read GeTComponentItem;

    procedure SetProcessHandle(Index, Value: Integer);

    procedure Load(xmlfile: TFilename); overload;
    procedure Save(xmlfile: TFilename); overload;
    procedure Load; overload;
    procedure Save; overload;
    procedure New;

    procedure Clear;
    property Parent: tcomponent read FParent write SetParent;
    property FileName: string read FFileName write FFileName;
  end;

function GetListFileName: string;
procedure Debug(Text: string; DebugType: Integer);

var
  ItemStorage: TComponentsList;

implementation

{ TComponentsList }

procedure Debug(Text: string; DebugType: Integer);
begin
  SendDebugMessageEx('Components Service', Pchar(Text), 0, DebugType);
end;

function GetListFileName: string;
begin
  Result := GetSharpeUserSettingsPath +
    'SharpCore\Services\Components\list.xml';

  ForceDirectories(ExtractFilePath(Result));
end;

procedure TComponentsList.New;
var
  ExePath: string;
begin
  ForceDirectories(ExtractFilePath(GetListFileName));
  ExePath := GetSharpeDirectory;

  with ItemStorage do
  begin
    Add('SharpBar', 'Bar Component', 'SharpBar.exe', True,
      False, False, -1);
    Add('SharpDesk', 'Desktop Component', 'SharpDesk.exe',
      True, False, False, -1);
    Add('SharpTray', 'Tray Icons Component', 'SharpTray.exe',
      True, False, False, -1);
    Add('SharpTask', 'Task Management Component', 'SharpTask.exe',
      True, False, False, -1);
    Add('SharpVWM', 'VWM Component', 'SharpVWM.exe', True,
      False, False, -1);
    Save;
  end;
end;

function TComponentsList.Add(Name, Description, Command: string;
  AutoStart, RestartNotResp, RestartCrash: Boolean; ProcessHandle: Integer):
  TComponentItem;
begin
  Result := TComponentItem.Create;
  Result.ID := Count;
  Result.FName := Name;
  Result.FDescription := Description;
  Result.FCommand := Command;

  Result.FAutoStart := AutoStart;
  Result.FRestartNotResponding := RestartNotResp;
  Result.FRestartCrash := RestartCrash;
  Result.FProcessHandle := ProcessHandle;

  FItems.Add(Result);
end;

constructor TComponentsList.Create;
begin
  inherited Create;
  FItems := TObjectList.Create;
end;

destructor TComponentsList.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TComponentsList.GetCount: integer;
begin
  Result := FItems.Count;
end;

function TComponentsList.GeTComponentItem(Index: integer): TComponentItem;
begin
  Result := (FItems[Index] as TComponentItem);
end;

procedure TComponentsList.Load(xmlfile: TFilename);
var
  ItemCount,
    Loop: Integer;
  xml: TjvSimpleXml;
  prop: string;

begin

  xml := TJvSimpleXml.Create(nil);
  try
    try
      xml.LoadFromFile(xmlfile);

      Itemcount := xml.Root.Properties.Item[0].IntValue;
      for Loop := 0 to itemcount - 1 do
      begin
        prop := 'Comp' + inttostr(loop);

        with xml.Root.Items do
        begin

          self.Add(
            ItemNamed['Comp' + inttostr(loop)].Items.Value('Name', ''),
            ItemNamed['Comp' + inttostr(loop)].Items.Value('Description', ''),
            ItemNamed['Comp' + inttostr(loop)].Items.Value('Command', ''),

            ItemNamed['Comp' + inttostr(loop)].Items.BoolValue('AutoStart', true),
            ItemNamed['Comp' + inttostr(loop)].Items.BoolValue('RestartCrash',
            False),
            ItemNamed['Comp' +
            inttostr(loop)].Items.BoolValue('RestartNotResponding', False),
              ItemNamed['Comp' +
            inttostr(loop)].Items.IntValue('ActiveHandle', -1));
        end;
      end;

    except
      on E: Exception do begin
        Debug('Error While Loading Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);
      end;
    end;

  finally
    xml.Free;
  end;
end;

procedure TComponentsList.Save(xmlfile: TFilename);
var
  Loop: Integer;
  xml: TjvSimpleXml;
begin
  xml := TJvSimpleXml.Create(nil);
  try
    try
      xml.Root.Name := 'Comps';
      xml.Root.Properties.Add('ItemCount', self.count);

      for loop := 0 to self.Count - 1 do
      begin
        xml.Root.Items.Add('Comp' + IntToStr(Loop));
        xml.Root.Items.Item[loop].Items.Add('Name', Self.Info[loop].FName);
        xml.Root.Items.Item[loop].Items.Add('Description',
          Self.Info[loop].FDescription);

        xml.Root.Items.Item[loop].Items.Add('Command', Self.Info[loop].FCommand);

        xml.Root.Items.Item[loop].Items.Add('AutoStart',
          Self.Info[loop].FAutoStart);
        xml.Root.Items.Item[loop].Items.Add('RestartCrash',
          Self.Info[loop].FRestartCrash);
        xml.Root.Items.Item[loop].Items.Add('RestartNotResponding',
          Self.Info[loop].FRestartNotResponding);
        xml.Root.Items.Item[loop].Items.Add('ActiveHandle',
          Self.Info[loop].FProcessHandle);
      end;

      xml.SaveToFile(xmlfile);
    except
      on E: Exception do begin
        Debug('Error While Saving Xml File', DMT_ERROR);
        Debug(E.Message, DMT_TRACE);
      end;
    end;


  finally
    xml.Free;
  end;
end;

procedure TComponentsList.SetParent(const Value: tcomponent);
begin
  FParent := Value;
end;

procedure TComponentsList.Clear;
begin
  FItems.Clear;
end;

procedure TComponentsList.Load;
begin
  Load(FFileName);
end;

procedure TComponentsList.Save;
begin
  Save(FFileName);
end;

procedure TComponentsList.SetProcessHandle(Index, Value: Integer);
begin
  Info[Index].FProcessHandle := Value;
end;

procedure TComponentsList.Delete(AInfo: TComponentItem);
var
  Index: Integer;
begin
  Index := FItems.IndexOf(AInfo);
  FItems.Delete(Index);
end;

{ TComponentItem }

end.



