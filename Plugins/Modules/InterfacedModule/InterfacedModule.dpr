library InterfacedModule;

uses
  ShareMem,
  SysUtils,
  Classes,
  Windows,
  Graphics,
  Forms,
  SharpApi,
  MouseTimer,
  GR32,
  uISharpESkin,
  uISharpBar,
  uISharpBarModule in '..\..\..\Common\Interfaces\uISharpBarModule.pas',
  MainWnd in 'MainWnd.pas' {MainForm},
  uInterfacedSharpBarModuleBase in '..\..\..\Components\SharpBar\uInterfacedSharpBarModuleBase.pas';

type
  TInterfacedSharpBarModule = class(TInterfacedSharpBarModuleBase)
    private
    public
      constructor Create(pID,pBarID : integer; pBarWnd : hwnd); override;

      function CloseModule : HRESULT; override;
      function SetTopHeight(Top,Height : integer) : HRESULT; override;
      function UpdateMessage(part : TSU_UPDATE_ENUM; param : integer) : HRESULT; override;

      procedure SetSkinInterface(Value : ISharpESkin); override;
  end;

{$R *.res}

{ TInterfacedSharpBarModule }

function TInterfacedSharpBarModule.CloseModule: HRESULT;
begin
  try
    Form.Free;
    Form := nil;
    result := S_OK;
  except
    on E:Exception do
    begin
      result := E_FAIL;
      SharpApi.SendDebugMessageEx(PChar(ModuleName),PChar('Error in CloseModule('
        + inttostr(ID) + '):' + E.Message),clred,DMT_ERROR);
    end;
  end;
end;

constructor TInterfacedSharpBarModule.Create(pID, pBarID: integer;
  pBarWnd: hwnd);
begin
  inherited Create(pID, pBarID, pBarWnd);

  try
    Form := TMainForm.CreateParented(BarWnd);
    Form.BorderStyle := bsNone;
    TMainForm(Form).mInterface := self;
    Form.ParentWindow := BarWnd;
    with Form as TMainForm do
    begin
      LoadSettings;
      RealignComponents;
    end;
  except
    on E:Exception do
    begin
      SharpApi.SendDebugMessageEx(PChar(ModuleName),PChar('Error in CreateModule('
        + inttostr(ID) + '):' + E.Message),clred,DMT_ERROR);
      exit;
    end;
  end;
end;

procedure TInterfacedSharpBarModule.SetSkinInterface(Value: ISharpESkin);
begin
  inherited SetSkinInterface(Value);

  if Form <> nil then
    TMainForm(Form).UpdateComponentSkins;
end;

function TInterfacedSharpBarModule.SetTopHeight(Top, Height: integer): HRESULT;
begin
  result := inherited SetTopHeight(Top, Height);

  if Form <> nil then
    TMainForm(Form).RealignComponents;
end;

function TInterfacedSharpBarModule.UpdateMessage(part: TSU_UPDATE_ENUM;
  param: integer): HRESULT;
const
  processed : TSU_UPDATES = [suSkinFileChanged,suBackground,suTheme,suSkin,
                             suScheme,suIconSet,suSkinFont,suModule];
begin
  result := inherited UpdateMessage(part,param);

  if not (part in processed) then
    exit;  
  
  if (part = suModule) and (ID  = param) then
  begin
    TMainForm(Form).LoadSettings;
    TMainForm(Form).ReAlignComponents;
  end;

  if [part] <= [suTheme,suSkinFileChanged] then
    TMainForm(Form).ReAlignComponents;

    // Step4: check if Icon changed
    //if [part] <= [suTheme,suIconSet] then
    //    TMainForm(Form).UpdateIcon;

    // Step5: Update if font changed
    //if [part] <= [suSkinFont] then
    //  TMainForm(Form).SharpESkinManager1.RefreshControls;

end;



// Library Source

function GetMetaData(Preview : TBitmap32) : TMetaData;
begin
  with result do
  begin
    Name := 'Interfaced Module';
    Author := 'Martin Krämer <Martin@SharpEnviro.com>';
    Description := 'Template Module with new Module Interface';
    Version := '0.7.6.0';
    ExtraData := 'preview: false';
    DataType := tteModule;
  end;
end;

function CreateModule(ID,BarID : integer; BarWnd : hwnd) : IInterface;
begin
  result := TInterfacedSharpBarModule.Create(ID,BarID,BarWnd);
end;


exports
  CreateModule,
  GetMetaData;

begin
end.
