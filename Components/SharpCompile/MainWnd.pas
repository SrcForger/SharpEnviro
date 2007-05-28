{
Source Name: MainWnd.pas
Description: SharpCompile Main window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, StdCtrls, DelphiCompiler, CheckLst, ExtCtrls, ComCtrls,
  ImgList, Contnrs, JvSimpleXML, Menus, ToolWin, PngImageList, DosCommand,
  Math, XPMan;

type

  TMainForm = class(TForm)
    Panel1: TPanel;
    clb_groups: TCheckListBox;
    Label1: TLabel;
    Panel2: TPanel;
    lb_output: TListBox;
    lv_projects: TListView;
    ImageList1: TImageList;
    ODFDialog: TOpenDialog;
    PngImageList1: TPngImageList;
    ToolBar1: TToolBar;
    btn_open: TToolButton;
    btn_compile: TToolButton;
    ToolButton3: TToolButton;
    pb_projects: TProgressBar;
    XPManifest1: TXPManifest;
    ToolButton1: TToolButton;
    btn_changeversion: TToolButton;
    procedure btn_changeversionClick(Sender: TObject);
    procedure lv_projectsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lv_projectsDblClick(Sender: TObject);
    procedure btn_compileClick(Sender: TObject);
    procedure clb_groupsClick(Sender: TObject);
    procedure OpenDataFile1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    RootDir : String;
    procedure CompilerNewLine(Sender: TObject; CmdOutput: string);
    procedure LoadCompileSettings(pXMLFile : String);
    procedure ClearPackageList;
    procedure BuildProjectList;
    procedure CompileProjects;
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;
  Compiler : TDelphiCompiler;

implementation

uses VersChangeWnd;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Compiler := TDelphiCompiler.Create;
  Compiler.OnCompilerCmdOutput := CompilerNewLine;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  ClearPackageList;
  Compiler.Free;
end;

procedure TMainForm.CompilerNewLine(Sender: TObject; CmdOutput: string);
begin
  if lb_output.Count > 0 then
  begin
    if CompareText(lb_output.Items[lb_output.Count-1],CmdOutput) <> 0 then
       lb_output.Items.Add(CmdOutput);
  end else lb_output.Items.Add(CmdOutput);
  lb_output.ItemIndex := lb_output.Items.Count - 1;
end;

procedure TMainForm.LoadCompileSettings(pXMLFile : String);
var
  XML : TJvSimpleXML;
  n,i : integer;
  list : TObjectList;
  pitem : TDelphiProject;
  pName,pType,pRequ,pPath : String;
begin
  ClearPackageList;
  lv_projects.Clear;

  XML := TJvSimpleXML.Create(nil);
  try
    if FileExists(pXMLFile) then
    begin
      XML.LoadFromFile(pXMLFile);
      for n := 0 to XML.Root.Items.Count - 1 do
          with XML.Root.Items.Item[n] do
          begin
            list := TObjectList.Create(True);
            clb_groups.AddItem(Properties.Value('Name','error'),list);
            clb_groups.Checked[clb_groups.Count - 1] := True;
            for i := 0 to Items.Count - 1 do
                with Items.Item[i] do
                begin
                  pName  := Properties.Value('Name','error');
                  pType  := Properties.Value('Type','Application');
                  pRequ  := Properties.Value('Requ','Delphi 2005 Personal');
                  pPath  := Value;
                  pitem  := TDelphiProject.Create(RootDir + pPath,pName,pType,pRequ);
                  List.Add(pitem);
                end;
          end;
      end;
  finally
    XML.Free;
  end;
  BuildProjectList;
end;

procedure TMainForm.BuildProjectList;
var
  n : integer;
  i : integer;
  lvitem : TListItem;
  list : TObjectList;
begin
  btn_changeversion.Enabled := False;
  if lv_projects.Tag = 1 then exit;
  
  lv_projects.Clear;
  for n := 0 to clb_groups.Count - 1 do
  begin
    if clb_groups.Checked[n] then
    begin
      list := TObjectList(clb_groups.Items.Objects[n]);
      
      lvitem := TListItem.Create(lv_projects.Items);
      lvitem.ImageIndex := 3;
      lvitem.Data := nil;
      lvitem.Caption := '';
      lvitem.SubItems.Add('[' + clb_groups.Items[n] + ']');
      lv_projects.Items.AddItem(lvitem);

      for i := 0 to list.Count - 1 do
      begin
        lvitem := TListItem.Create(lv_projects.Items);
        lvitem.Data := list.Items[i];
        lvitem.Caption := '';
        lvitem.ImageIndex := -1;
        lvitem.SubItems.Add(TDelphiProject(list.Items[i]).Name);
        lvitem.SubItems.Add(TDelphiProject(list.Items[i]).Dir);
        lvitem.SubItems.Add(TDelphiProject(list.Items[i]).aType);
        if TDelphiProject(list.Items[i]).UsePackages then
           lvitem.SubItems.Add(TDelphiProject(list.Items[i]).Packages)
           else lvitem.SubItems.Add('');
        lvitem.SubItems.Add(TDelphiProject(list.Items[i]).Version);
        lvitem.SubItems.Add(TDelphiProject(list.Items[i]).Requires);
        lv_projects.Items.AddItem(lvitem);
      end;

      lvitem := TListItem.Create(lv_projects.Items);
      lvitem.Caption := '';
      lvitem.ImageIndex := -1;
      lv_projects.Items.AddItem(lvitem);
    end;
  end;
end;

procedure TMainForm.ClearPackageList;
var
  n : integer;
begin
  for n := 0 to clb_groups.Count - 1 do
      if clb_groups.Items.Objects[n] <> nil then
      begin
        TObjectList(clb_groups.Items.Objects[n]).Free;
        clb_groups.Items.Objects[n] := nil;
      end;
  clb_groups.Clear;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.OpenDataFile1Click(Sender: TObject);
begin
  if ODFDialog.Execute then
  begin
    lb_output.Clear;
    RootDir := IncludeTrailingBackSlash(ExtractFileDir(ODFDialog.FileName));
    btn_compile.Enabled := True;
    LoadCompileSettings(ODFDialog.FileName);
  end;
end;

procedure TMainForm.clb_groupsClick(Sender: TObject);
begin
  BuildProjectList;
end;

procedure TMainForm.CompileProjects;
var
  n,i : integer;
  pItem : TDelphiProject;
  lvitem : TListItem;
  DS : TDosCommand;
  b : boolean;
  fcount : integer;
  ccount : integer;
begin
  lv_projects.Tag := 1;
  btn_changeversion.Enabled := False;
  clb_groups.Enabled := False;
  btn_open.Enabled := False;
  btn_compile.Enabled := False;

  lb_output.Clear;
  Compiler.UpdateBDSData;

  lb_output.Items.Add('----------------------------------------------');
  lb_output.Items.Add('Cleanup...');
  lb_output.Items.Add('----------------------------------------------');
  lb_output.Items.Add('');
  lb_output.Items.Add('');

  DS := TDosCommand.Create(nil);
  SetCurrentDirectory(PChar(RootDir));
  DS.CommandLine := 'clean.bat';
  DS.Execute2;
  DS.Free;

  // reset icons and compiler result
  for n := 0 to lv_projects.Items.Count - 1 do
  begin
    lvitem := lv_projects.Items.Item[n];
    if lvitem.ImageIndex <> 3 then
       lvitem.ImageIndex := -1;
    if lvitem.SubItems.Count = 7 then
       lvitem.SubItems[6] := '';
  end;

  i := 0;
  for n := 0 to clb_groups.Count - 1 do
      if clb_groups.Checked[n] then
         i := i + 1;

  if lv_projects.SelCount > 0 then
     pb_projects.Max := lv_projects.SelCount + 1
     else pb_projects.Max := lv_projects.Items.Count - 2 * i + 1;


  fcount := 0 ;
  ccount := 0;
  for n := 0 to lv_projects.Items.Count - 1 do
  begin
    lvitem := lv_projects.Items.Item[n];
    lvitem.MakeVisible(False);
    b := (lvitem.Selected) or (lv_projects.SelCount = 0);
    if (lvitem.data <> nil) and b then
    begin
      pb_projects.Position := pb_projects.Position + 1;
      pItem := TDelphiProject(lvitem.data);
      lb_output.Items.Add('----------------------------------------------');
      lb_output.Items.Add('Compiling: ' + pItem.Path);
      lb_output.Items.Add('----------------------------------------------');
      if FileExists(pItem.Path) then
      begin
        if Compiler.CompileProject(pItem.Path) then
        begin
          lvitem.ImageIndex := 1;
          ccount := ccount + 1;
        end else
        begin
          fcount := fcount + 1;
          lvitem.ImageIndex := 2;
          lvitem.SubItems.Add(lb_output.Items[lb_output.Items.Count - 1]);
        end;
      end else
      begin
        lvitem.ImageIndex := 2;
        fcount := fcount + 1;
        lb_output.Items.Add('File does not exist: ' + pItem.Path);
        lvitem.SubItems.Add(lb_output.Items[lb_output.Items.Count - 1]);
      end;
      lb_output.Items.Add('');
      lb_output.Items.Add('');
      Application.ProcessMessages;
    end;
  end;

  lb_output.Items.Add('----------------------------------------------');
  lb_output.Items.Add('All Projects Compiled');
  lb_output.Items.Add('----------------------------------------------');
  lb_output.Items.Add('Compiled Without Errors: ' + inttostr(ccount));
  lb_output.Items.Add('Failed to Compile: ' + inttostr(fcount));
  lb_output.ItemIndex := lb_output.Items.Count - 1;
  lb_output.ItemIndex := -1;

  pb_projects.Position := 0;

  lv_projects.Tag := 0;
  clb_groups.Enabled := True;
  btn_open.Enabled := True;
  btn_compile.Enabled := True;

  if lv_projects.SelCount > 0 then
     for n := 0 to lv_projects.Items.Count - 1 do
         if lv_projects.Items[n].Selected then
         begin
           lv_projects.Items[n].MakeVisible(False);
           break;
         end;
end;

procedure TMainForm.btn_compileClick(Sender: TObject);
begin
  CompileProjects;
end;

procedure TMainForm.lv_projectsDblClick(Sender: TObject);
var
  pItem : TDelphiProject;
  lvitem : TListItem;
  index : integer;
begin
  if (lv_projects.ItemIndex < 0) or (lv_projects.Items.Count = 0) then exit;

  if lv_projects.Items.Item[lv_projects.ItemIndex].data = nil then
     exit;

  if lv_projects.ItemIndex = lv_projects.Items.Count - 2 then
  begin
    lb_output.ItemIndex := lb_output.Count - 6;
    exit;
  end;

  index := Min(lv_projects.ItemIndex + 1,lv_projects.Items.Count-1);
  if lv_projects.Items.Item[index].data = nil then
     index := Min(lv_projects.ItemIndex + 2,lv_projects.Items.Count-1);
  if lv_projects.Items.Item[index].data = nil then
     index := Min(lv_projects.ItemIndex + 3,lv_projects.Items.Count-1);
  lvitem := lv_projects.Items.Item[index];
  if lvitem.data <> nil then
  begin
    pItem := TDelphiProject(lvitem.data);
    lb_output.ItemIndex := 0;
    lb_output.ItemIndex := lb_output.Items.IndexOf('Compiling: ' + pItem.Path) - 4;
  end;
end;

procedure TMainForm.lv_projectsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if lv_projects.Tag =  1 then
  begin
    Item.Selected := False;
    exit;
  end;

  btn_changeversion.Enabled := (Item <> nil);
  if Item <> nil then
  begin
    if ((Item.ImageIndex = 3) or ((Item.ImageIndex < 0) and (Item.SubItems.Count = 0))) then
       Item.Selected := False;
    if (lv_projects.SelCount = 0) then
       btn_changeversion.Enabled := False;
  end;
end;

procedure TMainForm.btn_changeversionClick(Sender: TObject);
var
  n,i : integer;
  XML : TJvSimpleXML;
  pItem : TDelphiProject;
  s : String;
begin
  with VersChangeForm  do
  begin
    lb_plist.Clear;

    for n := 0 to lv_projects.Items.Count - 1 do
        if lv_projects.Items[n].Selected then
           lb_plist.Items.Add(lv_projects.Items[n].SubItems[0] + ' (' +
                              lv_projects.Items[n].SubItems[1] + ')');
                              
    if lb_plist.Items.Count > 0 then
       if ShowModal = mrOk then
       begin
         for n := 0 to lv_projects.Items.Count - 1 do
             if lv_projects.Items[n].Selected then
             begin
               pItem := TDelphiProject(lv_projects.Items[n].Data);
               if pItem <> nil then
               begin
                 XML := TJvSimpleXML.Create(nil);
                 try
                   if FileExists(pItem.Path) then
                   begin
                     XML.LoadFromFile(pItem.Path);
                     pItem.Version :=   inttostr(round(se_v1.Value)) + '.'
                                      + inttostr(round(se_v2.Value)) + '.'
                                      + inttostr(round(se_v3.Value)) + '.'
                                      + inttostr(round(se_v4.Value));
                     if XML.Root.Items.ItemNamed['Delphi.Personality'] <> nil then
                        with XML.Root.Items.ItemNamed['Delphi.Personality'].Items do
                        begin
                          if ItemNamed['VersionInfoKeys'] <> nil then
                             with ItemNamed['VersionInfoKeys'].Items do
                                  for i := 0 to Count - 1 do
                                  begin
                                    s := Item[i].Properties.Value('Name','-1');
                                    if    (CompareText('FileVersion',s) = 0)
                                       or (CompareText('ProductVersion',s) = 0) then
                                          Item[i].Value := pItem.Version;
                                  end;
                                  
                          if ItemNamed['VersionInfo'] <> nil then
                             with ItemNamed['VersionInfo'].Items do
                                  for i := 0 to Count - 1 do
                                  begin
                                    s := Item[i].Properties.Value('Name','-1');
                                    if (CompareText('MajorVer',s) = 0) then
                                          Item[i].Value := inttostr(round(se_v1.Value))
                                    else if (CompareText('MinorVer',s) = 0) then
                                            Item[i].Value := inttostr(round(se_v2.Value))
                                    else if (CompareText('Release',s) = 0) then
                                            Item[i].Value := inttostr(round(se_v3.Value))
                                    else if (CompareText('Build',s) = 0) then
                                            Item[i].Value := inttostr(round(se_v4.Value))
                                    else if (CompareText('IncludeVerInfo',s) = 0) then
                                            Item[i].Value := 'True';
                                  end;
                        end;
                     XML.SaveToFile(pItem.Path + '~');
                     if FileExists(pItem.Path) then
                        DeleteFile(pItem.Path);
                     RenameFile(pItem.Path + '~',pItem.Path);
                   end;
                 finally
                   XML.Free;
                   BuildProjectList;
                 end;
               end;
             end;
       end;
  end;
end;

end.
