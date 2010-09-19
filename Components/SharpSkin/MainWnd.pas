{
Source Name: MainWnd.pas
Description: SharpSkin Main Form
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SharpEListBoxEx, JvExStdCtrls, JvMemo, SharpEPageControl,
  ComCtrls, ToolWin, CheckLst, JvExCheckLst, JvCheckListBox, SharpERoundPanel,
  ExtCtrls, ImgList, PngImageList;

type
  TMainForm = class(TForm)
    panMain: TPanel;
    splMain: TSplitter;
    panLeft: TPanel;
    sepProjects: TSharpERoundPanel;
    sepProjLbl: TSharpERoundPanel;
    lblProjects: TLabel;
    panRight: TPanel;
    tbMain: TToolBar;
    tbClear: TToolButton;
    Label1: TLabel;
    Panel1: TPanel;
    edSkinPath: TEdit;
    Button1: TButton;
    OpenSkinDialog: TOpenDialog;
    sepLog: TSharpEPageControl;
    lbSummary: TSharpEListBoxEx;
    pilStatus: TPngImageList;
    ToolButton1: TToolButton;
    SharpEPageControl1: TSharpEPageControl;
    lbSchemeItems: TSharpEListBoxEx;
    procedure Button1Click(Sender: TObject);
    procedure lbSummaryGetCellColor(Sender: TObject;
      const AItem: TSharpEListItem; var AColor: TColor);
    procedure tbClearClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure lbSchemeItemsGetCellColor(Sender: TObject;
      const AItem: TSharpEListItem; var AColor: TColor);
    procedure lbSchemeItemsGetCellClickable(Sender: TObject;
      const ACol: Integer; AItem: TSharpEListItem; var AClickable: Boolean);
    procedure lbSummaryGetCellClickable(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AClickable: Boolean);
  private
    function IsXMLValid(pFile : String; pMustExist : boolean = True) : boolean;
  public
    procedure LoadSkin;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  JclSimpleXML,SharpApi;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  if length(trim(OpenSkinDialog.InitialDir)) = 0 then
    OpenSkinDialog.InitialDir := SharpApi.GetSharpeDirectory + 'Skins';

  if OpenSkinDialog.Execute then
    if FileExists(OpenSkinDialog.FileName) then
    begin
      edSkinPath.Text := OpenSkinDialog.FileName;
      LoadSkin;
    end;
end;

procedure TMainForm.lbSchemeItemsGetCellClickable(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AClickable: Boolean);
begin
  AClickable := False;
end;

procedure TMainForm.lbSchemeItemsGetCellColor(Sender: TObject;
  const AItem: TSharpEListItem; var AColor: TColor);
begin
  if AItem.ImageIndex = 0 then
    AColor := $00BEF8F2
  else if AItem.ImageIndex = 1 then
    AColor := $00DCDCEE
  else AColor := $00E2FCFA;
end;

procedure TMainForm.lbSummaryGetCellClickable(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AClickable: Boolean);
begin
  AClickable := False;
end;

procedure TMainForm.lbSummaryGetCellColor(Sender: TObject;
  const AItem: TSharpEListItem; var AColor: TColor);
begin
  if AItem.ImageIndex = 0 then
    AColor := $00ECECFF
  else if AItem.ImageIndex = -1 then
    AColor := $00FBEFE3
  else if AItem.ImageIndex = 1 then
    AColor := $00ECFFEC
  else if AItem.ImageIndex = 2 then
    AColor := $00ECECEC
  else if AItem.ImageIndex = 3 then
    AColor := $00BEF8F2;
end;

function ReplaceXMLTags(pSrc : String) : String;
begin
  result := StringReplace(pSrc,'<','[',[rfReplaceAll]);
  result := StringReplace(result,'>',']',[rfReplaceAll]);  
end;

function TMainForm.IsXMLValid(pFile : String; pMustExist : boolean = True) : boolean;
var
  XML : TJclSimpleXML;
begin
  result := False;

  if (not FileExists(pFile)) then
  begin
    if (not pMustExist) then
    begin
      result := True;
      lbSummary.AddItem('File not found (' + ExtractFileName(pFile) + ')... Warning',3);
    end else lbSummary.AddItem('File not found (' + ExtractFileName(pFile) + ')... Warning',0);
    exit;
  end;

  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(pFile);
    result := True;
    lbSummary.AddItem('Checking for valid XML (' + ExtractFileName(pFile) + ')... Success',1);
  except
    on E:Exception do
    begin
      lbSummary.AddItem('Checking for valid XML (' + ExtractFileName(pFile) + ')... Failed',0);
      lbSummary.AddItem('Error: ' + ReplaceXMLTags(E.Message),0);
    end;
  end;
  XML.Free;
end;

procedure TMainForm.LoadSkin;

procedure AddError(pError : String; var pBool1,pBool2 : boolean);
begin
  lbSummary.AddItem(pError,0);
  pBool1 := False;
  pBool2 := False;
end;

var
  CustomFile,SkinFile,SchemeFile,InfoFile : String;
  Dir : String;
  b,partValid : boolean;
  XML : TJclSimpleXML;
  s : String;
  i,n : integer;

  sName,sType,sInfo,sDefault,sTag : String;
  lItem : TSharpEListItem;
  sCount : integer;
  SList : TStringList;
begin
  lbSchemeItems.Clear;
  lbSummary.Clear;

  SkinFile := edSkinPath.Text;
  {$WARNINGS OFF}Dir := IncludeTrailingBackSlash(ExtractFileDir(SkinFile));{$WARNINGS ON}
  SchemeFile := Dir + 'Scheme.xml';
  InfoFile := Dir + 'Info.xml';
  CustomFile := Dir + 'Custom.xml';
  lbSummary.AddItem('Loading Skin ' + Dir + '...',2);
  lbSummary.AddItem('Step 1: Checking XML files',2);
  b := True;
  b := IsXMLValid(InfoFile) and b;
  b := IsXMLValid(SchemeFile) and b;
  b := IsXMLValid(SkinFile) and b;
  b := IsXMLValid(CustomFile, False) and b;
  if not b then
  begin
    lbSummary.AddItem('There have been errors...',0);
    exit;
  end;

  b := True;
  lbSummary.AddItem('Step 2: Skin Header Analysis (Info.xml)',2);
  XML := TJclSimpleXML.Create;
  XML.LoadFromFile(InfoFile);
  if XML.Root.Items.ItemNamed['header'] = nil then
  begin
    lbSummary.AddItem('Invalid Skin Header (can not read [header] xml item)',0);
    b := False;
  end else with XML.Root.Items.ItemNamed['header'].Items do
  begin
    s := Value('name','### tag not found ###');
    if (CompareText(s,'### tag not found ###') = 0) or (length(trim(s)) = 0) then
    begin
      i := 0;
      b := False;
    end else i := 1;
    lbSummary.AddItem('Name = ' + s,i);

    s := Value('Author','### tag not found ###');
    if (CompareText(s,'### tag not found ###') = 0) or (length(trim(s)) = 0) then
      i := 3
    else i := 1;
    lbSummary.AddItem('Author = ' + s,i);

    s := Value('Url','### tag not found ###');
    if (CompareText(s,'### tag not found ###') = 0) or (length(trim(s)) = 0) then
      i := 3
    else i := 1;
    lbSummary.AddItem('Url = ' + s,i);

    s := Value('Info','### tag not found ###');
    if (CompareText(s,'### tag not found ###') = 0) or (length(trim(s)) = 0) then
      i := 3
    else i := 1;
    lbSummary.AddItem('Info = ' + s,i);

    s := Value('Version','### tag not found ###');
    if (CompareText(s,'### tag not found ###') = 0) or (length(trim(s)) = 0) then
      i := 3
    else i := 1;
    lbSummary.AddItem('Version = ' + s,i);       
  end;
  XML.Free;

  if not b then
  begin
    lbSummary.AddItem('There have been errors...',0);
    exit;
  end;

  b := True;
  lbSummary.AddItem('Step 3: Scheme Items Analysis (Scheme.xml)',2);
  XML := TJclSimpleXML.Create;
  XML.LoadFromFile(SchemeFile);
  lbSchemeItems.Clear;
  lItem := lbSchemeItems.AddItem('Tag',0);
  lItem.AddSubItem('Type',0);
  lItem.AddSubItem('#Used',0);
  sCount := 0;
  for n := 0 to XML.Root.Items.Count - 1 do
    with XML.Root.Items[n].Items do
    begin
      sName    := Value('Name','### tag not found ###');
      sTag     := Value('Tag','### tag not found ###');
      sInfo    := Value('Info','### tag not found ###');
      sDefault := Value('Default','### tag not found ###');
      sType    := Value('Type','Color');

      lItem := lbSchemeItems.AddItem(sTag,-1);
      lItem.AddSubItem(sType,-1);

      b := not ((CompareText(sTag,'### tag not found ###') = 0) or (length(trim(sTag)) = 0)) and b;
      if (CompareText(sTag,'### tag not found ###') = 0) or (length(trim(sTag)) = 0) then
        lbSummary.AddItem('Scheme item: [Tag] property not set for item number ' + inttostr(n+1),0);

      b := not ((CompareText(sName,'### tag not found ###') = 0) or (length(trim(sName)) = 0)) and b;
      if (CompareText(sName,'### tag not found ###') = 0) or (length(trim(sName)) = 0) then
        lbSummary.AddItem('Scheme item: [Name] property not set for item number ' + inttostr(n+1) + ' (Tag=' + sTag +')',0);

      b := not ((CompareText(sDefault,'### tag not found ###') = 0) or (length(trim(sDefault)) = 0)) and b;
      if (CompareText(sDefault,'### tag not found ###') = 0) or (length(trim(sDefault)) = 0) then
        lbSummary.AddItem('Scheme item: [Default] property not set for item number ' + inttostr(n+1) + ' (Tag=' + sTag +')',0);

      if (CompareText(sType,'Color') <> 0)
        and (CompareText(sType,'Integer') <> 0)
        and (CompareText(sType,'Dynamic') <> 0)
        and (CompareText(sType,'Boolean') <> 0) then
      begin
        b := False;
        lbSummary.AddItem('Scheme item: invalid [Type] property (' + sType + ')',0);
      end;

      if (CompareText(sInfo,'### tag not found ###') = 0) or (length(trim(sInfo)) = 0) then
        lbSummary.AddItem('Scheme item: [Info] property not set for Tag=' + sTag,3);

      sCount := sCount + 1;
    end;
    
  XML.Free;
  if b then
    lbSummary.AddItem('Found ' + inttostr(sCount) + ' Scheme Items without errors',1)
  else begin
    lbSummary.AddItem('Found ' + inttostr(sCount) + ' Scheme Items but there have been errors...',0);
    exit;
  end;

  SList := TStringList.Create;
  SList.LoadFromFile(SkinFile);
  for i := 1 to lbSchemeItems.Count - 1 do
  begin
    sCount := 0;
    for n := 0 to SList.Count - 1 do
    begin
      if Pos(UPPERCASE(lbSchemeItems.Item[i].Caption),UPPERCASE(SList[n])) <> 0 then
        sCount := sCount + 1;
    end;
    lbSchemeItems.Item[i].AddSubItem(inttostr(sCount),-1);
    if sCount = 0 then
    begin
      lbSchemeItems.Item[i].ImageIndex := 1; 
      lbSummary.AddItem('Scheme Item ' + lbSchemeItems.Item[i].Caption + ' is never used',3);
    end;
  end;
  SList.Free;

  b := True;
  lbSummary.AddItem('Step 4: Skin Analysis (Skin.xml)',2);
  XML := TJclSimpleXML.Create;
  XML.LoadFromFile(SkinFile);

  // SharpBar
  partValid := True;
  if (XML.Root.Items.ItemNamed['sharpbar'] <> nil) then
    with XML.Root.Items.ItemNamed['sharpbar'].Items do
    begin
      if ItemNamed['bar'] = nil then
        AddError('Component Skin [SharpBar]: required skin state [bar] not found',b,partValid);
      if ItemNamed['throbber'] = nil then
        AddError('Component Skin [SharpBar]: required skin state [throbber] not found',b,partValid);
      if ItemNamed['dimension'] = nil then
        AddError('Component Skin [SharpBar]: required property [dimension] not defined',b,partValid);
    end else AddError('Component Skin [SharpBar]: tag does not exist',b,partValid);
  if partValid then
    lbSummary.AddItem('Component Skin [SharpBar]... Found',1);

  XML.Free;
end;

procedure TMainForm.tbClearClick(Sender: TObject);
begin
  lbSummary.Clear;
end;

procedure TMainForm.ToolButton1Click(Sender: TObject);
begin
  LoadSkin;
end;

end.
