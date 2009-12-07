{
Source Name: uDeskAreaSettingsWnd.pas
Description: DeskArea Settings Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit uHomeWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, SharpCenterApi, StdCtrls, SharpEListBoxEx,
 ImgList, PngImageList, SharpApi, ComCtrls, ISharpCenterHostUnit;

type
  TUser = Class
    Name: String;
    Handle: String;
    Email: String;
    Role: String;
    constructor Create(AName, AHandle, AEmail, ARole: String);
  End;

  TUrl = Class
    Name: String;
    Url: String;
    Description: String;
    SupportUrl: Boolean;
    constructor Create(AName, AUrl, ADescription: String; ASupportUrl:Boolean=False);
  End;

  TfrmHome = class(TForm)
    PngImageList1: TPngImageList;
    PageControl1: TPageControl;
    tabCredits: TTabSheet;
    tabUrls: TTabSheet;
    lbUsers: TSharpEListBoxEx;
    imgLogo: TImage;
    lblCredits: TLabel;
    lblUrls: TLabel;
    lbUrls: TSharpEListBoxEx;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbUsersGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbWebsiteLinksGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbWebsiteLinksClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbUsersGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbUsersClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure Label7Click(Sender: TObject);
    procedure lbUrlsGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbUrlsClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbUrlsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbUrlsGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbUsersGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
  private
    FUsers: TList;
    FUrls: TList;
    FPluginHost: ISharpCenterHost;
    procedure AddUsersToList;
  public
    procedure AddUrlsToList(ASupport: Boolean=False);
    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
  end;

var
  frmHome: TfrmHome;

const
  colName = 0;
  colEmail = 1;

implementation

{$R *.dfm}

procedure TfrmHome.FormCreate(Sender: TObject);
begin
  lbUsers.DoubleBuffered := true;
  FUsers := TList.Create;
  FUrls := TList.Create;

  AddUsersToList;
  AddUrlsToList;


End;

procedure TfrmHome.FormDestroy(Sender: TObject);
begin
  FUsers.Free;
  FUrls.Free;
end;

procedure TfrmHome.Label7Click(Sender: TObject);
begin

end;

{ TUser }

procedure TfrmHome.AddUrlsToList(ASupport: Boolean=False);
var
  i: Integer;
  tmpLi: TSharpEListItem;
  tmpUrl: TUrl;

  procedure AddUrl(AName, AUrl, ADescription: String; ASupport:Boolean=False);
  var
    tmp: TUrl;
  begin
    tmp := TUrl.Create(AName,AUrl,ADescription,ASupport);
    FUrls.Add(tmp);
  end;

begin
  FUrls.Clear;

  if Not(ASupport) then begin
    AddUrl('Graphics32','http://www.graphics32.org','Advanced Graphics Library');
    AddUrl('JediVcl','http://jvcl.sourceforge.net','Advanced Component Library');
    AddUrl('Thany','http://www.thany.org','PngComponents');
    AddUrl('Silk Icons','http://www.famfamfam.com/lab/icons/silk/','Icon Collection');
    AddUrl('Crystal Icons','http://everaldo.com/crystal/','Icon Collection');
    AddUrl('Tango','http://tango.freedesktop.org','Icon Collection');
  end else begin
    // Support Urls
    AddUrl('Trac','http://trac.sharpe-shell.org','Wiki, Tickets, Roadmap',true);
    AddUrl('Homepage','http://www.sharpe-shell.org','SharpE Homepage',true);
    AddUrl('Sourceforge','http://sourceforge.net/projects/sharpe/','SVN Repositry',true);
  end;

  lbUrls.Clear;
  for i := 0 to Pred(FUrls.Count) do begin
    tmpUrl := TUrl(FUrls[i]);
    tmpLi := lbUrls.AddItem(tmpUrl.Name,0);
    tmpLi.Data := tmpUrl;
  end;
end;

procedure TfrmHome.AddUsersToList;
var
  i: Integer;
  tmpLi: TSharpEListItem;
  tmpUser: TUser;

  procedure AddUser(AName, AHandle, AEmail, ARole: String);
  var
    tmp: TUser;
  begin
    tmp := TUser.Create(AName, AHandle, AEmail, ARole);
    FUsers.Add(tmp);
  end;

begin
  FUsers.Clear;
  //AddUser('Bruno', 'Skizo', 'bruno@sharpenviro.com', 'Graphics, New Guy.');
  AddUser('CoCo', 'Silentpyjamas', 'coco@sharpenviro.com', 'PR, Community + Support.');
  AddUser('David', 'Glacialfury', 'nathan@sharpenviro.com', 'Lead Tester + Support.');
  AddUser('Florian', 'Captain Herisson', 'florian@sharpenviro.com', 'Graphics + Design.');
  AddUser('James', 'brum74', 'james@sharpenviro.com', 'Module Developer.');
  AddUser('Lee', 'Pixol', 'lee@sharpenviro.com', 'Lead Developer of Components, SharpCenter, Configurations.');
  AddUser('Martin', 'Billiberserker', 'martin@sharpenviro.com', 'Lead Developer of SharpBar, SharpDesk, SharpMenu, Modules.');
  AddUser('Nathan', 'Mc', 'nathan@sharpenviro.com', 'Lead Developer of SharpCore, SharpCompile.');
  AddUser('David', 'Yay', 'davidw@sharpenviro.com', 'Content + Site Moderator.');

  lbUsers.Clear;
  for i := 0 to Pred(FUsers.Count) do begin
    tmpUser := TUser(FUsers[i]);
    tmpLi := lbUsers.AddItem(tmpUser.Name,0);
    tmpLi.Data := tmpUser;
  end;
end;

procedure TfrmHome.lbUrlsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp: TUrl;
begin
  tmp := TUrl(AItem.Data);
  if tmp = nil then exit;

  SharpExecute(tmp.Url);

end;

procedure TfrmHome.lbUrlsGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  ACursor := crHandPoint;
end;

procedure TfrmHome.lbUrlsGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
begin
  AImageIndex := 1;
end;

procedure TfrmHome.lbUrlsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TUrl;
  colItemTxt: TColor;
  colDescTxt: TColor;
  colBtnTxt: TColor;
begin
  tmp := TUrl(AItem.Data);
  if tmp = nil then exit;

  // Assign theme colours
  AssignThemeToListBoxItemText(PluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  case ACol of
    colName: begin
      AColText := format('<font color="%s">%s</font> <font color="%s">( %s ) - <u>%s</font>',
        [ColorToString(colItemTxt),tmp.Name,ColorToString(colDescTxt),tmp.Description,tmp.Url]);
    end;
  end;
end;

procedure TfrmHome.lbUsersClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
begin
  SharpExecute('mailto:staff@sharpenviro.com');
end;

procedure TfrmHome.lbUsersGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  Acursor := crHandPoint;
end;

procedure TfrmHome.lbUsersGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
var
  tmp: TUser;
begin
  tmp := TUser(AItem.Data);
  if tmp = nil then exit;

  if tmp.Name = 'CoCo' then
  AImageIndex := 2 else
  AImageIndex := 0;

end;

procedure TfrmHome.lbUsersGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TUser;
begin
  tmp := TUser(AItem.Data);
  if tmp = nil then exit;

  case ACol of
    colName: begin
      AColText := format('%s ( %s ) - <font color="%s"> %s',
        [tmp.Name,tmp.Handle,ColorToString(FPluginHost.Theme.PluginItemDescriptionText),tmp.Role]);
    end;
  end;

end;

procedure TfrmHome.lbWebsiteLinksClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  n:Integer;
  s:String;
begin
  n := Pos('http',AItem.Caption);
  s := Copy(AItem.Caption,n,length(AItem.Caption)-n+1);
  SharpExecute(s);
end;

procedure TfrmHome.lbWebsiteLinksGetCellCursor(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
begin
  ACursor := crHandPoint;
end;

{ TUser }

constructor TUser.Create(AName, AHandle, AEmail, ARole: String);
begin
  Name := AName;
  Handle := AHandle;
  Email := AEmail;
  Role := ARole;
end;

{ TUrl }

constructor TUrl.Create(AName, AUrl, ADescription: String; ASupportUrl:Boolean=False);
begin
  Name := AName;
  Url := AUrl;
  Description := ADescription;
  SupportUrl := ASupportUrl;


end;

end.

