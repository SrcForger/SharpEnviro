{
Source Name: MainForm.pas
Description: SharpSkin Main Form
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
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

unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvComponent, JvEditorCommon, JvUnicodeEditor,
  JvUnicodeHLEditor, JvEditor, JvHLEditor, Menus, ExtCtrls, StdCtrls,
  JvExStdCtrls, JvListBox, JvSimpleXML, JvHLEditorPropertyForm, ToolWin,
  ComCtrls, ImgList, PngImageList, Tabs, JvTabBar, GR32_Image, uSharpeColorBox,
  SharpESkin, SharpEButton, SharpESkinManager, SharpEBaseControls, SharpEScheme,
  SharpECheckBox, SharpEProgressBar, SharpEBar, gr32,
  SharpEMiniThrobber, SharpERadioBox, SharpEPanel, SharpEEdit, SharpELabel,
  SharpETaskItem;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    NewSkin1: TMenuItem;
    OpenSkin1: TMenuItem;
    mn_save: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    previewpanel: TPanel;
    Panel2: TPanel;
    xmledit: TJvHLEditor;
    OpenSkinDialog: TOpenDialog;
    JvHLEdPropDlg1: TJvHLEdPropDlg;
    ToolBar1: TToolBar;
    PngImageList1: TPngImageList;
    btn_save: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    DefaultSkin: TMemo;
    ToolButton4: TToolButton;
    btn_addskinpart: TToolButton;
    btnUndo: TToolButton;
    ToolButton7: TToolButton;
    Panel3: TPanel;
    Errors: TListBox;
    btn_addtemplate: TToolButton;
    PopupMenu1: TPopupMenu;
    Button1: TMenuItem;
    tabs: TJvTabBar;
    JvModernTabBarPainter1: TJvModernTabBarPainter;
    CheckBox1: TMenuItem;
    Insert1: TMenuItem;
    SkinPart1: TMenuItem;
    emplates1: TMenuItem;
    Button2: TMenuItem;
    Checkbox2: TMenuItem;
    btn_Render: TToolButton;
    ToolButton8: TToolButton;
    Panel1: TPanel;
    Label1: TLabel;
    WAB: TSharpEColorBox;
    Label2: TLabel;
    WAD: TSharpEColorBox;
    Label3: TLabel;
    WAL: TSharpEColorBox;
    Label4: TLabel;
    WAT: TSharpEColorBox;
    Label5: TLabel;
    TRB: TSharpEColorBox;
    Label6: TLabel;
    Label7: TLabel;
    TRD: TSharpEColorBox;
    Label8: TLabel;
    TRL: TSharpEColorBox;
    Label9: TLabel;
    TRT: TSharpEColorBox;
    Label10: TLabel;
    Label11: TLabel;
    Skin: TSharpESkin;
    Scheme: TSharpEScheme;
    SkinButton1: TSharpEButton;
    SkinCheckBox1: TSharpECheckBox;
    SkinButton2: TSharpEButton;
    SkinButton3: TSharpEButton;
    SkinCheckBox2: TSharpECheckBox;
    SkinButton4: TSharpEButton;
    SkinCheckBox3: TSharpECheckBox;
    PBar1: TSharpEProgressBar;
    PBar2: TSharpEProgressBar;
    PBar3: TSharpEProgressBar;
    PBar4: TSharpEProgressBar;
    PBar5: TSharpEProgressBar;
    PBar6: TSharpEProgressBar;
    BarImage: TImage32;
    SaveSkinDialog: TSaveDialog;
    SharpBarxmlbasecode1: TMenuItem;
    PopupMenu2: TPopupMenu;
    Basic1: TMenuItem;
    Advanced1: TMenuItem;
    Basic2: TMenuItem;
    Advanced2: TMenuItem;
    Progressbar1: TMenuItem;
    SharpBarxmlbasecode2: TMenuItem;
    Progressbar2: TMenuItem;
    Help: TMenuItem;
    QuickHelp1: TMenuItem;
    Documentation1: TMenuItem;
    N2: TMenuItem;
    About1: TMenuItem;
    Panel4: TMenuItem;
    Panel5: TMenuItem;
    MiniThrobber1: TSharpEMiniThrobber;
    Label12: TLabel;
    MiniThrobber2: TMenuItem;
    MiniThrobber3: TMenuItem;
    Progressbarsmallmode1: TMenuItem;
    Progressbarsmallmode2: TMenuItem;
    Emptynoimage1: TMenuItem;
    Emptynoimage2: TMenuItem;
    Export1: TMenuItem;
    mn_export: TMenuItem;
    ExportDialog1: TSaveDialog;
    SkinRadioBox1: TSharpERadioBox;
    SkinRadioBox2: TSharpERadioBox;
    SkinRadioBox3: TSharpERadioBox;
    SkinRadioBox4: TSharpERadioBox;
    RadioBox1: TMenuItem;
    RadioBox2: TMenuItem;
    SkinPanel1: TSharpEPanel;
    SkinPanel2: TSharpEPanel;
    SkinPanel3: TSharpEPanel;
    SkinPanel4: TSharpEPanel;
    SharpELabel1: TSharpELabel;
    SharpELabel2: TSharpELabel;
    SharpELabel3: TSharpELabel;
    Font1: TMenuItem;
    Font2: TMenuItem;
    Edit1: TMenuItem;
    Edit2: TMenuItem;
    SharpEEdit1: TSharpEEdit;
    SharpETaskItem1: TSharpETaskItem;
    SharpETaskItem2: TSharpETaskItem;
    SharpETaskItem3: TSharpETaskItem;
    TaskItem1: TMenuItem;
    askItem2: TMenuItem;
    procedure TaskItem1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure RadioBox1Click(Sender: TObject);
    procedure mn_exportClick(Sender: TObject);
    procedure Emptynoimage1Click(Sender: TObject);
    procedure Progressbarsmallmode1Click(Sender: TObject);
    procedure MiniThrobber2Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure QuickHelp1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Progressbar1Click(Sender: TObject);
    procedure Advanced1Click(Sender: TObject);
    procedure Basic1Click(Sender: TObject);
    procedure SharpBarxmlbasecode1Click(Sender: TObject);
    procedure btn_saveClick(Sender: TObject);
    procedure tabsTabSelected(Sender: TObject; Item: TJvTabBarItem);
    procedure WABColorClick(Sender: TObject; Color: TColor;
      ColType: TClickedColorID);
    procedure FormShow(Sender: TObject);
    procedure btn_RenderClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure xmleditPaintGutter(Sender: TObject; Canvas: TCanvas);
    procedure tabsTabSelecting(Sender: TObject; Item: TJvTabBarItem;
      var AllowSelect: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure xmleditChange(Sender: TObject);
    procedure btnUndoClick(Sender: TObject);
    procedure btn_addskinpartClick(Sender: TObject);
    procedure NewSkin1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OpenSkin1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure OnXMLDecode(Sender: TObject; var Value: string);
    procedure OnXMLTagParsed(Sender: TObject; Name: string);
  private
    { Private-Deklarationen }
  public
    function UpdateSkinEdit(newTab : String) : boolean;
    procedure ParseAndInsertText(Text : String);
    procedure SetAllTabsError;
    procedure UpdateTabStatus(pXML : TJvSimpleXML);
    procedure CheckXML;
    procedure RepaintSkinDemo;
    procedure disabletab(name: string);
  end;

var
  Form1: TForm1;
  SkinManager : TSharpESkinManager;
  XML : TJvSimpleXML;
  PlainXML : String;
  LastValue : String;
  SkinFile  : String;

implementation

uses Defaults, JvJCLUtils, BarForm, AboutWnd, QuickHelpWnd;

{$R *.dfm}

procedure TForm1.OnXMLTagParsed(Sender: TObject; Name: string);
begin
  LastValue := Name;
end;

procedure TForm1.OnXMLDecode(Sender: TObject; var Value: string);
begin
  LastValue := Value;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.OpenSkin1Click(Sender: TObject);
var
  SList : TStringList;
begin
  if (Messagedlg('Do you really want to load another skin?'+#10#13+
                 'Not saved changes will be lost!',mtConfirmation,[mbYes,mbNo],0) = mrNo) then exit;
  if OpenSkinDialog.Execute then
  begin
    xmledit.Lines.Clear;
    xmledit.SetCaret(0,0);
    tabs.Tabs[0].Selected := True;
    SList := TStringList.Create;
    SList.Clear;
    SkinFile := OpenSkinDialog.FileName;
    try
      SList.LoadFromFile(OpenSkinDialog.FileName);
      PlainXML := SList.Text;
    except
      showmessage('Error loading Skin File!');
    end;
    SList.Free;
    UpdateSkinEdit('Plain XML');
    UpdateTabStatus(XML);
    btn_save.Enabled := true;
    mn_save.Enabled := true;
    btn_addskinpart.Enabled := true;
    btn_render.Enabled := true;
    btn_addtemplate.Enabled := true;
    Insert1.Enabled := true;
    xmledit.Enabled := true;
  end;
end;

procedure TForm1.SetAllTabsError;
var
  n : integer;
begin
  for n := 0 to Tabs.Tabs.Count - 1 do
      if Tabs.Tabs.Items[n].Caption <> tabs.SelectedTab.Caption then //'Plain XML' then
         Tabs.Tabs.Items[n].ImageIndex := 11;
end;

procedure TForm1.disabletab(name: string);
var
  n : integer;
begin
  for n := 0 to Tabs.Tabs.Count - 1 do
      if LOWERCASE(Tabs.Tabs.Items[n].Caption) = LOWERCASE(name) then
       begin
         Tabs.Tabs.Items[n].ImageIndex := 11;
         exit;
       end;
end;

procedure TForm1.UpdateTabStatus(pXML : TJvSimpleXML);
var
  n,i : integer;
begin
  SetAllTabsError;
  for n := 0 to pXML.Root.Items.Count - 1 do
      for i := 0 to Tabs.Tabs.Count - 1 do
        if (LOWERCASE(pXML.Root.Items.Item[n].Name)=LOWERCASE(Tabs.Tabs.Items[i].Caption))
           or (LOWERCASE(Tabs.Tabs.Items[i].Caption)='plain xml')  then
              Tabs.Tabs.Items[i].ImageIndex := 9;
end;

procedure TForm1.CheckXML;
var
  tempXML : TJvSimpleXML;
begin
  tempXML := TJvSimpleXML.Create(nil);
  errors.Items.Clear;
  try
    tempXML.LoadFromString(xmledit.lines.Text)
  except
    on E: EJvSimpleXMLError do
    begin
      Errors.Font.Color := clMaroon;
      errors.Items.Clear;
      errors.Items.Add('[Error] '+E.Message);
      SetAllTabsError;
      tempXML.Free;
      btn_render.Enabled := False;
      btn_save.Enabled := False;
      mn_export.Enabled := False;
      mn_save.Enabled := False;
      exit;
    end;
  end;
  Errors.Font.Color := clBlack;
  btn_save.Enabled := True;
  mn_export.Enabled := True;
  mn_save.Enabled := True;
  btn_render.Enabled := true;
  UpdateTabStatus(XML);
  tempXML.Free;
end;

function TForm1.UpdateSkinEdit(newTab : String) : boolean;
var
  n,i : integer;
  SList : TStringList;
begin
  if LOWERCASE(Tabs.SelectedTab.Caption) <> 'plain xml' then
  begin
    try
      XML.LoadFromString(PlainXML);
      for n := 0 to XML.Root.Items.Count - 1 do
          if LOWERCASE(XML.Root.Items.Item[n].Name)=LOWERCASE(Tabs.SelectedTab.Caption) then
          begin
            if ((xmledit.Lines.Count = 0)
               or (length(trim(xmledit.Lines.Text))=0)) then
            begin
              xml.Root.Items.Delete(n);
              disabletab(Tabs.SelectedTab.Caption);
            end else
            begin
              XMl.Root.Items.Item[n].Clear;
              XMl.Root.Items.Item[n].LoadFromString(xmledit.Lines.Text);
            end;
            break;
          end;
      PlainXML := XML.XMLData;
      UpdateTabStatus(XML);
    except
      on E: EJvSimpleXMLError do
      begin
        errors.Items.Clear;
        errors.Items.Add('[Error] '+E.Message);
        result := false;
        SetAllTabsError;
        exit;
      end
      else
      result := false;
      SetAllTabsError;
      exit;
    end;
  end;

  if newTab = 'Plain XML' then
  begin
    xmledit.Lines.Text := PlainXML;
    try
      XML.LoadFromString(PlainXML);
    except
    end;
    result := true;
    errors.Items.Clear;
    exit;
  end;

  newTab := LOWERCASE(newTab);
  try
    if LOWERCASE(tabs.SelectedTab.Caption) = 'plain xml' then
    begin
      XML.LoadFromString(xmledit.Lines.Text);
      PlainXML := XML.XMLData;
    end else XML.LoadFromString(PlainXML);
  except
    on E: EJvSimpleXMLError do
    begin
      errors.Items.Clear;
      errors.Items.Add('[Error] '+E.Message);
      result := false;
      SetAllTabsError;
      exit;
    end
    else
    result := false;
    SetAllTabsError;
    exit;
  end;

  for n := 0 to XML.Root.Items.Count - 1 do
      if LOWERCASE(XML.Root.Items.Item[n].Name)=newTab then
      begin
        xmledit.Lines.Clear;
        xmledit.SetCaret(0,0);
        xmledit.Lines.Text := XML.Root.Items.Item[n].SaveToString;
        if xmledit.Lines.Count = 0 then
        begin
          xmledit.Lines.Add('<'+XML.Root.Items.Item[n].Name+'>');
          xmledit.Lines.Add('</'+XML.Root.Items.Item[n].Name+'>');
        end;   
        result := true;
        errors.Items.Clear;
        UpdateTabStatus(XML);
        exit;
      end;

  if not xmledit.Enabled then
  begin
    result := False;
    exit;
  end;

  if MessageDlg('Skin component does not exist in this skin.'+#10#13+
                'Do you want to create it now?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
    xmledit.Lines.Clear;
    xmledit.SetCaret(0,0);
    if newtab = 'button' then ParseAndInsertText(DefaultButtonSkin)
       else if newtab = 'checkbox' then ParseAndInsertText(DefaultCheckBoxSkin)
       else if newtab = 'progressbar' then ParseAndInsertText(DefaultProgressbarSkin)
       else if newtab = 'panel' then ParseAndInsertText(DefaultPanelSkin)
       else if newtab = 'minithrobber' then ParseAndInsertText(DefaultMiniThrobberSkin)
       else if newtab = 'radiobox' then ParseAndInsertText(DefaultRadioBoxSkin)
       else if newtab = 'font' then ParseAndInsertText(DefaultFontTemplate)
       else if newtab = 'edit' then ParseAndInsertText(DefaultEditSkin)
       else if newtab = 'taskitem' then ParseAndInsertText(DefaultTaskItemSkin)
       else
       begin
         xmledit.Lines.Add('<'+newtab+'>');
         xmledit.Lines.Add('</'+newtab+'>');
       end;
    XML.LoadFromString(PlainXML);
    XML.Root.Items.Add(newtab);
    PlainXML := XML.SaveToString;
    result := true;
    xmledit.repaint;
    UpdateTabStatus(XML);
    exit;
  end;
  result := false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SkinManager := TSharpESkinManager.CreateRuntime(self,Skin,Scheme);
  SkinManager.SkinSource := ssComponent;
  SkinManager.SchemeSource := ssComponent;

  XML := TJvSimpleXMl.Create(nil);
  XMl.OnDecodeValue := OnXMLDecode;
  XMl.OnTagParsed := OnXMLTagParsed;
  PlainXML := '';
  BarWnd := TBarWnd.Create(nil);

  pbar1.SkinManager := SkinManager;
  pbar2.SkinManager := SkinManager;
  pbar3.SkinManager := SkinManager;
  pbar4.SkinManager := SkinManager;
  pbar5.SkinManager := SkinManager;
  pbar6.SkinManager := SkinManager;
  SkinPanel1.SkinManager := SkinManager;
  SkinPanel2.SkinManager := SkinManager;
  SkinPanel3.SkinManager := SkinManager;
  SkinPanel4.SkinManager := SkinManager;
  SkinCheckBox1.SkinManager := SkinManager;
  SkinCheckBox2.SkinManager := SkinManager;
  SkinCheckBox3.SkinManager := SkinManager;
  SkinRadioBox1.SkinManager := SkinManager;
  SkinRadioBox2.SkinManager := SkinManager;
  SkinRadioBox3.SkinManager := SkinManager;
  SkinRadioBox4.SkinManager := SkinManager;
  SkinButton1.SkinManager := SkinManager;
  SkinButton2.SkinManager := SkinManager;
  SkinButton3.SkinManager := SkinManager;
  SkinButton4.SkinManager := SkinManager;
  MiniThrobber1.SkinManager := SkinManager;
  SharpEEdit1.SkinManager := SkinManager;
  SharpELabel1.SkinManager := SkinManager;
  SharpELabel2.SkinManager := SkinManager;
  SharpELabel3.SkinManager := SkinManager;
  SharpETaskItem1.SkinManager := SkinManager;
  SharpETaskItem2.SkinManager := SkinManager;
  SharpETaskItem3.SkinManager := SkinManager;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SkinManager.Free;
  XML.Free;
  BarWnd.Free;
end;

procedure TForm1.NewSkin1Click(Sender: TObject);
begin
  if (Messagedlg('Do you really want to create a new skin?'+#10#13+
                 'Not saved changes will be lost!',mtConfirmation,[mbYes,mbNo],0) = mrNo) then exit;
  if SaveSkinDialog.Execute then
  begin
    SkinFile := SaveskinDialog.FileName;
    xmledit.Lines.Clear;
    xmledit.SetCaret(0,0);
    tabs.Tabs[0].Selected := True;
    PlainXML := DefaultSkin.Lines.Text;
    UpdateSkinEdit('Plain XML');
    UpdateTabStatus(XML);
    btn_save.Enabled := true;
    mn_save.Enabled := true;
    btn_addskinpart.Enabled := true;
    btn_render.Enabled := true;
    btn_addtemplate.Enabled := true;
    Insert1.Enabled := true;
    xmledit.Enabled := true;
  end;
end;

procedure TForm1.btn_addskinpartClick(Sender: TObject);
begin
  ParseAndInsertText(DefaultSkinPart);
end;

procedure TForm1.ParseAndInsertText(Text : String);
var
  SList : TStringList;
  n : integer;
  p : TPoint;
begin
  SList := TStringList.Create;
  SList.Delimiter := '§';
  SList.QuoteChar := '^';
  SList.DelimitedText := Text;
  p.X := xmledit.CaretX;
  p.Y := xmledit.CaretY;
  for n := 0 to SList.Count - 1 do
  begin
    if n = SList.Count - 1 then xmledit.InsertText(SList[n])
       else
       begin
         xmledit.InsertText(SList[n]+#10);
         xmledit.SetCaret(p.X,p.Y+1);
         p.Y := xmledit.CaretY;
       end;
  end;
  SList.Free;
  xmledit.Repaint;
end;

procedure TForm1.btnUndoClick(Sender: TObject);
begin
  xmledit.Undo;
end;

procedure TForm1.xmleditChange(Sender: TObject);
begin
  btnUndo.Enabled := xmledit.UndoBuffer.CanUndo;
  CheckXML;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultButtonSkin);
end;

procedure TForm1.tabsTabSelecting(Sender: TObject; Item: TJvTabBarItem;
  var AllowSelect: Boolean);
begin
  AllowSelect := UpdateSkinEdit(Item.Caption);
  if AllowSelect then
     xmledit.MakeRowVisible(0);
end;

procedure TForm1.xmleditPaintGutter(Sender: TObject; Canvas: TCanvas);
var
  i: Integer;
  R: TRect;
  oldFont: TFont;
begin
  oldFont := TFont.Create;
  try
    oldFont.Assign(Canvas.Font);
    Canvas.Font := xmledit.Font;
    with xmledit do
      for i := TopRow to TopRow + VisibleRowCount do
      begin
        R := Bounds(2, (i - TopRow) * CellRect.Height, GutterWidth - 2 - 5, CellRect.Height);
        Windows.DrawText(Canvas.Handle, PChar(IntToStr(i + 1)), -1, R, DT_RIGHT or DT_VCENTER or DT_SINGLELINE);
      end;
  finally
    Canvas.Font := oldFont;
    oldFont.Free;
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultCheckBoxSkin);
end;

procedure TForm1.btn_RenderClick(Sender: TObject);
var
  tempxml : TJvSimpleXML;
  n : integer;
begin
  CheckXML;
  tempxml := TJvSimpleXML.Create(nil);
  try
    if tabs.SelectedTab.Caption = 'Plain XML' then
    begin
      try
        tempxml.LoadFromString(xmledit.Lines.Text);
        Skin.ButtonSkin.Clear;
        Skin.PanelSkin.Clear;
        Skin.ProgressBarSkin.Clear;
        Skin.BarSkin.Clear;
        Skin.CheckBoxSkin.Clear;
        Skin.MiniThrobberSkin.Clear;
        Skin.RadioBoxSkin.Clear;
        Skin.SmallText.Clear;
        Skin.MediumText.Clear;
        Skin.BigText.Clear;
        Skin.TaskItemSkin.Clear;
        if tempxml.Root.Items.ItemNamed['font'] <> nil then
           with tempxml.Root.Items.ItemNamed['font'].Items do
           begin
             if ItemNamed['small'] <> nil then
                Skin.SmallText.LoadFromXML(ItemNamed['small']);
             if ItemNamed['medium'] <> nil then
                Skin.MediumText.LoadFromXML(ItemNamed['medium']);
             if ItemNamed['big'] <> nil then
                Skin.BigText.LoadFromXML(ItemNamed['big']);
           end;
        if tempxml.Root.Items.ItemNamed['button'] <> nil then
           Skin.ButtonSkin.LoadFromXML(tempxml.Root.Items.ItemNamed['button'], ExtractFilePath(SkinFile));
        if tempxml.Root.Items.ItemNamed['sharpbar'] <> nil then
        begin
          Skin.BarSkin.LoadFromXML(tempxml.Root.Items.ItemNamed['sharpbar'], ExtractFilePath(SkinFile));
          Skin.BarSkin.CheckValid;
        end;
        if tempxml.Root.Items.ItemNamed['progressbar'] <> nil then
           Skin.ProgressBarSkin.LoadFromXML(tempxml.Root.Items.ItemNamed['progressbar'], ExtractFilePath(SkinFile));
        if tempxml.Root.Items.ItemNamed['checkbox'] <> nil then
           Skin.CheckBoxSkin.LoadFromXML(tempxml.Root.Items.ItemNamed['checkbox'], ExtractFilePath(SkinFile));
        if tempxml.Root.Items.ItemNamed['panel'] <> nil then
           Skin.PanelSkin.LoadFromXML(tempxml.Root.Items.ItemNamed['panel'], ExtractFilePath(SkinFile));
        if tempxml.Root.Items.ItemNamed['minithrobber'] <> nil then
           Skin.MiniThrobberSkin.LoadFromXML(tempxml.Root.Items.ItemNamed['minithrobber'], ExtractFilePath(SkinFile));
        if tempxml.Root.Items.ItemNamed['radiobox'] <> nil then
           SKin.RadioBoxSkin.LoadFromXML(tempxml.Root.Items.ItemNamed['radiobox'], ExtractFilePath(SkinFile));
        if tempxml.Root.Items.ItemNamed['edit'] <> nil then
           Skin.EditSkin.LoadFromXML(tempxml.Root.Items.ItemNamed['edit'], ExtractFilePath(SkinFile));
        if tempxml.Root.Items.ItemNamed['taskitem'] <> nil then
           Skin.TaskItemSkin.LoadFromXML(tempxml.Root.Items.ItemNamed['taskitem'], ExtractFilePath(SkinFile));
      except
      end;
      RepaintSkinDemo;
    end;

    if tabs.SelectedTab.Caption = 'Button' then
    begin
      try
        tempxml.LoadFromString(xmledit.Lines.Text);
        Skin.ButtonSkin.Clear;
        Skin.ButtonSkin.LoadFromXML(tempxml.Root,ExtractFilePath(SkinFile));
      except
      end;
      RepaintSkinDemo;
    end;
    if tabs.SelectedTab.Caption = 'CheckBox' then
    begin
      try
        tempxml.LoadFromString(xmledit.Lines.Text);
        Skin.CheckBoxSkin.Clear;
        Skin.CheckBoxSkin.LoadFromXML(tempxml.Root,ExtractFilePath(SkinFile));
      except
      end;
      RepaintSkinDemo;
    end;
    if tabs.SelectedTab.Caption = 'Panel' then
    begin
      try
        tempxml.LoadFromString(xmledit.Lines.Text);
        Skin.PanelSkin.Clear;
        Skin.PanelSkin.LoadFromXML(tempxml.Root,ExtractFilePath(SkinFile));
      except
      end;
      RepaintSkinDemo;
    end;
    if tabs.SelectedTab.Caption = 'Progressbar' then
    begin
      try
        tempxml.LoadFromString(xmledit.Lines.Text);
        Skin.ProgressBarSkin.Clear;
        Skin.ProgressBarSkin.LoadFromXML(tempxml.Root,ExtractFilePath(SkinFile));
      except
      end;
      RepaintSkinDemo;
    end;
    if tabs.SelectedTab.Caption = 'SharpBar' then
    begin
      try
        tempxml.LoadFromString(xmledit.Lines.Text);
        Skin.BarSkin.Clear;
        Skin.BarSkin.LoadFromXML(tempxml.Root,ExtractFilePath(SkinFile));
        Skin.BarSkin.CheckValid;
      except
      end;
      RepaintSkinDemo;
    end;
    if tabs.SelectedTab.Caption = 'MiniThrobber' then
    begin
      try
        tempxml.LoadFromString(xmledit.Lines.Text);
        Skin.MiniThrobberSkin.Clear;
        Skin.MiniThrobberSkin.LoadFromXML(tempxml.Root,ExtractFilePath(SkinFile));
      except
      end;
      RepaintSkinDemo;
    end;
    if tabs.SelectedTab.Caption = 'Edit' then
    begin
      try
        tempxml.LoadFromString(xmledit.Lines.Text);
        Skin.EditSkin.Clear;
        Skin.EditSkin.LoadFromXML(tempxml.Root,ExtractFilePath(SkinFile));
      except
      end;
      RepaintSkinDemo;
    end;
    if tabs.SelectedTab.Caption = 'RadioBox' then
    begin
      try
        tempxml.LoadFromString(xmledit.Lines.Text);
        Skin.RadioBoxSkin.Clear;
        Skin.RadioBoxSkin.LoadFromXML(tempxml.Root,ExtractFilePath(SkinFile));
      except
      end;
      RepaintSkinDemo;
    end;
    if tabs.SelectedTab.Caption = 'Font' then
    begin
      try
        tempxml.LoadFromString(xmledit.Lines.Text);
        Skin.SmallText.Clear;
        Skin.MediumText.Clear;
        skin.BigText.Clear;
        with tempxml.Root.Items do
        begin
          if ItemNamed['small'] <> nil then
             Skin.SmallText.LoadFromXML(ItemNamed['small']);
          if ItemNamed['medium'] <> nil then
             Skin.MediumText.LoadFromXML(ItemNamed['medium']);
          if ItemNamed['big'] <> nil then
             Skin.BigText.LoadFromXML(ItemNamed['big']);
        end;
      except
      end;
      RepaintSkinDemo;
    end;
    if tabs.SelectedTab.Caption = 'TaskItem' then
    begin
      try
        tempxml.LoadFromString(xmledit.Lines.Text);
        Skin.TaskItemSkin.Clear;
        Skin.TaskItemSkin.LoadFromXML(tempxml.Root,ExtractFilePath(SkinFile));
      except
      end;
      RepaintSkinDemo;
    end;
  finally
    tempxml.free;
  end;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Barwnd.Parent := previewpanel;
  BarWnd.Width := previewpanel.Width - 32;
  BarWnd.Top := PBar6.Top + 64;
  btn_Render.OnClick(btn_Render);

  previewPanel.Color := WAB.Color;
  Scheme.WorkAreaback := WAB.Color;
  Scheme.WorkAreadark := WAD.Color;
  Scheme.WorkArealight := WAL.Color;
  Scheme.WorkAreatext  := WAT.Color;
  Scheme.Throbberback  := TRB.Color;
  Scheme.Throbberdark  := TRD.Color;
  Scheme.Throbberlight := TRL.Color;
  Scheme.Throbbertext  := TRT.Color;

  RepaintSkinDemo;
end;

procedure TForm1.RepaintSkinDemo;
begin
  pbar1.Repaint;
  pbar2.Repaint;
  pbar3.Repaint;
  pbar4.Repaint;
  pbar5.Repaint;
  pbar6.Repaint;
  SkinPanel1.Repaint;
  SkinPanel2.Repaint;
  SkinPanel3.Repaint;
  SkinPanel4.Repaint;
  SkinCheckBox1.Repaint;
  SkinCheckBox2.Repaint;
  SkinCheckBox3.Repaint;
  SkinRadioBox1.Repaint;
  SkinRadioBox2.Repaint;
  SkinRadioBox3.Repaint;
  SkinRadioBox4.Repaint;
  SkinButton1.Repaint;
  SkinButton2.Repaint;
  SkinButton3.Repaint;
  SkinButton4.Repaint;
  MiniThrobber1.Repaint;
  SharpEEdit1.Repaint;
  SharpELabel1.Repaint;
  SharpELabel2.Repaint;
  SharpELabel3.Repaint;
  SharpETaskItem1.Repaint;
  SharpETaskItem2.Repaint;
  SharpETaskItem3.Repaint;

  BarWnd.SharpEBar1.UpdateSkin;
  ShowWindow(BarWnd.SharpEBar1.abackground.handle,SW_HIDE);
  BarImage.Bitmap.SetSize(previewpanel.Width - 32,BarWnd.SharpEBar1.Skin.Height*2+16);
  BarImage.Bitmap.Clear(color32(previewpanel.Color));
  BarWnd.SharpEBar1.VertPos := vpTop;
  BarWnd.SharpEBar1.UpdateSkin;
  BarWnd.SharpEBar1.Skin.DrawTo(BarImage.Bitmap,0,0);
  BarWnd.SharpEBar1.VertPos := vpBottom;
  BarWnd.SharpEBar1.UpdateSkin;
  BarWnd.SharpEBar1.Skin.DrawTo(BarImage.Bitmap,0,BarWnd.SharpEBar1.Skin.Height+8);
  BarWnd.SharpEBar1.Throbber.Parent := BarImage;
end;

procedure TForm1.WABColorClick(Sender: TObject; Color: TColor;
  ColType: TClickedColorID);
begin
  previewPanel.Color := WAB.Color;
  Scheme.WorkAreaback := WAB.Color;
  Scheme.WorkAreadark := WAD.Color;
  Scheme.WorkArealight := WAL.Color;
  Scheme.WorkAreatext  := WAT.Color;
  Scheme.Throbberback  := TRB.Color;
  Scheme.Throbberdark  := TRD.Color;
  Scheme.Throbberlight := TRL.Color;
  Scheme.Throbbertext  := TRT.Color;

  RepaintSkinDemo;
end;

procedure TForm1.tabsTabSelected(Sender: TObject; Item: TJvTabBarItem);
begin
    btn_save.Enabled := True;
    mn_save.Enabled := True;
{  if Tabs.SelectedTab.Caption = 'Plain XML' then
  begin
    btn_save.Enabled := True;
    mn_save.Enabled := True;
  end else
  begin
    btn_save.Enabled := False;
    mn_save.Enabled := False;
  end;}
end;

procedure TForm1.btn_saveClick(Sender: TObject);
var
  tempxml : TJvSimpleXML;
  n : integer;
begin
  Errors.Clear;
  if Tabs.SelectedTab.Caption <> 'Plain XML' then
  begin
    Errors.Items.Add('Switching to Plain XML Tab');
    for n := 0 to Tabs.Tabs.Count - 1 do
        if Tabs.Tabs.Items[n].Caption = 'Plain XML' then
        begin
          Tabs.Tabs.Items[n].Selected := True;
          break;
        end;
    if Tabs.SelectedTab.Caption <> 'Plain XML' then
    begin
      Errors.Items.Add('Unable to switch to Plain XML tab');
      Errors.Items.Add('Correct Errors first!');
      exit;
    end;
//    UpdateSkinEdit('Plain XML');
  end;

  Errors.Items.Add('[Save Skin]');
  tempxml := TJvSimpleXML.Create(nil);
  try
    tempxml.LoadFromString(xmledit.Lines.Text);
  except
    on E: EJvSimpleXMLError do
    begin
      Errors.Font.Color := clMaroon;
      Errors.Items.Add('[XML Parsing Error]: xml data contains errors');
      Errors.Items.Add('[Error]: '+E.Message);
      Errors.Items.Add('[Aborting Save Process]');
      tempxml.Free;
      exit;
    end;
  end;
  Errors.Font.Color := clBlack;
  Errors.Items.Add('[XML Parsing]: no errors found');
  Errors.Items.Add('[Saving File]');
  tempxml.SaveToFile(SkinFile);
  Errors.Items.Add('[File Saved]: '+SkinFile);
  tempxml.free;
end;

procedure TForm1.SharpBarxmlbasecode1Click(Sender: TObject);
begin
  xmledit.InsertText(defaultskin.Lines.Text);
  xmledit.Repaint;
end;

procedure TForm1.Basic1Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultSkinPart);
end;

procedure TForm1.Advanced1Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultSkinPart2);
end;

procedure TForm1.Progressbar1Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultProgressbarSkin);
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TForm1.QuickHelp1Click(Sender: TObject);
begin
  QuickHelpForm.ShowModal;
end;

procedure TForm1.Panel4Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultPanelSkin);
end;

procedure TForm1.MiniThrobber2Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultMiniThrobberSkin);
end;

procedure TForm1.Progressbarsmallmode1Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultProgressbarSkin2);
end;

procedure TForm1.Emptynoimage1Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultSkinPart3);
end;

procedure TForm1.mn_exportClick(Sender: TObject);
begin
  if ExportDialog1.Execute then
  begin
    btn_Render.OnClick(btn_Render);
    SkinManager.Skin.SaveToSkin(ExportDialog1.FileName);
  end;
end;

procedure TForm1.RadioBox1Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultRadioBoxSkin);
end;

procedure TForm1.Font1Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultFontTemplate);
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultEditSkin);
end;

procedure TForm1.TaskItem1Click(Sender: TObject);
begin
  ParseAndInsertText(DefaultTaskItemSkin);
end;

end.
