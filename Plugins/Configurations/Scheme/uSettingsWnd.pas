{
Source Name: uSettingsWnd
Description: Configuration window for Scheme Settings
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005
 - OS : Windows 2000 or higher

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
unit uSettingsWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Spin,
  ComCtrls,
  pngimage,
  JvSimpleXML,
  JvPageList,
  JvExControls,
  JvComponent,
  Mask,
  JvExMask,
  JvSpin,
  uEditSchemeWnd,
  SharpApi, ImgList, uSharpeColorBox, SharpEListBox, PngImageList;

type
  TfrmSettingsWnd = class(TForm)
    Label3: TLabel;
    plConfig: TJvPageList;
    spGeneral: TJvStandardPage;
    JvStandardPage2: TJvStandardPage;
    schemelist: TSharpEListBox;
    schemeimages: TPngImageList;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure schemelistDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure chkCpuEnableClick(Sender: TObject);
  private
    { Private declarations }
    FInitialising: Boolean;
  public
    { Public declarations }
    procedure InitialiseSettings;
    procedure BuildSchemeList;
    procedure DeleteScheme;
    procedure AddScheme(pEditSchemeForm : TEditSchemeForm);
    procedure EditScheme;
  end;

var
  frmSettingsWnd: TfrmSettingsWnd;
  XMLList : TStringList;

implementation

uses
  uSEListboxPainter,
  JclStrings;


{$R *.dfm}

{ TfrmSettingsWnd }


procedure TfrmSettingsWnd.EditScheme;
var
  dir : String;
  fn  : String;
  EditSchemeForm: TEditSchemeForm;
  XML : TJvSimpleXML;
begin
  if schemelist.ItemIndex <0 then exit;
  dir := SharpApi.GetSharpeUserSettingsPath + 'Schemes\';
  fn := XMLList[schemelist.ItemIndex];
  if not FileExists(dir + fn) then exit;

  EditSchemeForm := TEditSchemeForm.Create(self);
  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(dir+fn);
    EditSchemeForm.edit_name.Text := XML.Root.Items.Value('Name','Error loading XML Data');
    if XML.Root.Items.ItemNamed['BaseColors'] <> nil then
       with XML.Root.Items.ItemNamed['BaseColors'].Items do
       begin
         EditSchemeForm.b1.Color := IntValue('1');
         EditSchemeForm.b2.Color := IntValue('2');
         EditSchemeForm.b3.Color := IntValue('3');
       end;

    if XML.Root.Items.ItemNamed['LightColors'] <> nil then
       with XML.Root.Items.ItemNamed['LightColors'].Items do
       begin
         EditSchemeForm.l1.Color := IntValue('1');
         EditSchemeForm.l2.Color := IntValue('2');
         EditSchemeForm.l3.Color := IntValue('3');
       end;

    if XML.Root.Items.ItemNamed['DarkColors'] <> nil then
       with XML.Root.Items.ItemNamed['DarkColors'].Items do
       begin
         EditSchemeForm.d1.Color := IntValue('1');
         EditSchemeForm.d2.Color := IntValue('2');
         EditSchemeForm.d3.Color := IntValue('3');
       end;

    if XML.Root.Items.ItemNamed['FontColors'] <> nil then
       with XML.Root.Items.ItemNamed['FontColors'].Items do
       begin
         EditSchemeForm.f1.Color := IntValue('1');
         EditSchemeForm.f2.Color := IntValue('2');
         EditSchemeForm.f3.Color := IntValue('3');
       end;

    if EditSchemeForm.ShowModal = mrOk then
    begin
      XML.Free;
      XML := nil;
      DeleteFile(dir + fn);
      AddScheme(EditSchemeForm);
      EditSchemeForm := nil;
      BuildSchemeList;
      exit;
    end;
  finally
    if EditSchemeForm <> nil then EditSchemeForm.Free;
    if XML <> nil then XML.Free;
  end;
  BuildSchemeList;
end;

procedure TfrmSettingsWnd.AddScheme(pEditSchemeForm : TEditSchemeForm);
var
  dir : String;
  fn : String;
  XML : TJvSimpleXML;
  wasnil : boolean;
  mr : integer;
begin
  if pEditSchemeForm = nil then
  begin
    pEditSchemeForm := TEditSchemeForm.Create(self);
    wasnil := True;
  end else wasnil := False;

  try
    XML := nil;
    if wasnil then mr := pEditSchemeForm.ShowModal;
    if (mr = mrOk) or (not wasnil) then
    begin
      XML := TJvSimpleXML.Create(nil);
      XML.Root.Name := 'SharpEScheme';
      XML.Root.Items.Add('Name',pEditSchemeForm.edit_name.Text);
      with XML.Root.Items.Add('BaseColors').Items do
      begin
        Add('1',pEditSchemeForm.b1.Color);
        Add('2',pEditSchemeForm.b2.Color);
        Add('3',pEditSchemeForm.b3.Color);
      end;
      with XML.Root.Items.Add('LightColors').Items do
      begin
        Add('1',pEditSchemeForm.l1.Color);
        Add('2',pEditSchemeForm.l2.Color);
        Add('3',pEditSchemeForm.l3.Color);
      end;
      with XML.Root.Items.Add('DarkColors').Items do
      begin
        Add('1',pEditSchemeForm.d1.Color);
        Add('2',pEditSchemeForm.d2.Color);
        Add('3',pEditSchemeForm.d3.Color);
      end;
      with XML.Root.Items.Add('FontColors').Items do
      begin
        Add('1',pEditSchemeForm.f1.Color);
        Add('2',pEditSchemeForm.f2.Color);
        Add('3',pEditSchemeForm.f3.Color);
      end;
      fn := StrRemoveChars(pEditSchemeForm.edit_name.Text,['"','<','>','|','/','\','*','?','.',':']);
      dir := SharpApi.GetSharpeUserSettingsPath + 'Schemes\';
      ForceDirectories(dir);
      XML.SaveToFile(dir+fn+'.xml');
    end;
  finally
    pEditSchemeForm.Free;
    pEditSchemeForm := nil;
    if XML <> nil then XML.Free;
  end;

  if wasnil then BuildSchemeList;
end;

procedure TfrmSettingsWnd.DeleteScheme;
var
  dir : String;
begin
  if schemelist.ItemIndex < 0 then exit;

  if MessageBox(Handle,PCHar('Do you really want to delete Scheme ' + schemelist.Items[schemelist.ItemIndex]),'Confirm',MB_YESNO) = mrYes then
  begin
    dir := SharpApi.GetSharpeUserSettingsPath + 'Schemes\';
    DeleteFile(dir+XMLList[schemelist.ItemIndex]);
  end;
  BuildSchemeList;
end;

procedure TfrmSettingsWnd.BuildSchemeList;
var
  sr : TSearchRec;
  dir : String;
  XML : TJvSimpleXML;
  Item : TListItem;
  Bmp  : Tbitmap;
  n : integer;
begin
  schemeimages.Clear;
  schemelist.Clear;
  dir := SharpApi.GetSharpeUserSettingsPath + 'Schemes\';
  XML := TJvSimpleXML.Create(nil);
  XMLList.Clear;
  Bmp := TBitmap.Create;
  try
    if FindFirst(dir+'*.xml', faAnyFile, sr) = 0 then
    begin
      repeat
        Item := nil;
        try
          XML.LoadFromFile(dir + sr.Name);
          // Paint Bitmap
          Bmp.Width := 151;
          Bmp.Height := 20;
          Bmp.Canvas.Brush.Color := clFuchsia;
          Bmp.Canvas.Pen.Color   := clBlack;
          Bmp.Canvas.FillRect(Rect(0,0,151,20));
          Bmp.Canvas.Brush.Color := clBlack;
          Bmp.Canvas.Pen.Color   := clBlack;
          Bmp.Canvas.FillRect(Rect(0,1,141,18));
          for n := 1 to 3 do
          begin
            Bmp.Canvas.Brush.Color := XML.Root.Items.ItemNamed['LightColors'].Items.IntValue(inttostr(n),0);
            Bmp.Canvas.FillRect(Rect(1+(n-1)*50,2,10+(n-1)*50,17));
            Bmp.Canvas.Brush.Color := XML.Root.Items.ItemNamed['BaseColors'].Items.IntValue(inttostr(n),0);
            Bmp.Canvas.FillRect(Rect(11+(n-1)*50,2,20+(n-1)*50,17));
            Bmp.Canvas.Brush.Color := XML.Root.Items.ItemNamed['DarkColors'].Items.IntValue(inttostr(n),0);
            Bmp.Canvas.FillRect(Rect(21+(n-1)*50,2,30+(n-1)*50,17));
            Bmp.Canvas.Brush.Color := XML.Root.Items.ItemNamed['FontColors'].Items.IntValue(inttostr(n),0);
            Bmp.Canvas.FillRect(Rect(31+(n-1)*50,2,40+(n-1)*50,17));
            Bmp.Canvas.Brush.Color := clFuchsia;
            Bmp.Canvas.FillRect(Rect(41+(n-1)*50,1,50+(n-1)*50,18));
          end;
{          Bmp.Canvas.Brush.Color := XML.Root.Items.IntValue('SecondaryLight',0);
          Bmp.Canvas.FillRect(Rect(51,2,60,17));
          Bmp.Canvas.Brush.Color := XML.Root.Items.IntValue('Secondary',0);
          Bmp.Canvas.FillRect(Rect(61,2,70,17));
          Bmp.Canvas.Brush.Color := XML.Root.Items.IntValue('SecondaryDark',0);
          Bmp.Canvas.FillRect(Rect(71,2,80,17));
          Bmp.Canvas.Brush.Color := XML.Root.Items.IntValue('SecondaryFont',0);
          Bmp.Canvas.FillRect(Rect(81,2,90,17));
          Bmp.Canvas.Brush.Color := clFuchsia;
          Bmp.Canvas.FillRect(Rect(91,1,101,18));}
//          schemeimages.ad.Add(Bmp,Bmp);
          schemeimages.AddMasked(Bmp,clFuchsia);
          XMLList.Add(sr.Name);
          schemelist.Items.Add(XML.Root.Items.Value('Name','Error Loading XML Setting'));
        except
          if Item <> nil then Item.Free;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  finally
    XML.Free;
    Bmp.Free;
  end;
end;

procedure TfrmSettingsWnd.InitialiseSettings;
begin
  FInitialising := True;
  BuildSchemeList;
end;

procedure TfrmSettingsWnd.chkCpuEnableClick(Sender: TObject);
begin
  //PrismSettings.EnableCpuOptim := chkCpuEnable.Checked;
  //InitialiseSettings;
end;

procedure TfrmSettingsWnd.schemelistDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  if Index = -1 then  exit;

  if TListBox(Control).Style = lbStandard then exit;

  PaintListbox(TListBox(Control), Rect, 0, State, schemelist.Items[Index], SchemeImages, Index, '', clWindowText);
end;

procedure TfrmSettingsWnd.FormCreate(Sender: TObject);
begin
  XMLList := TStringList.Create;
  XMLList.Clear;
end;

procedure TfrmSettingsWnd.FormDestroy(Sender: TObject);
begin
  XMLList.Free;
end;

end.

