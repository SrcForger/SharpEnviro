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
  JvLabel, ImgList, PngImageList, SharpApi, JvExControls;

type
  TUser = Class
    Name: String;
    Handle: String;
    Email: String;
    Role: String;
    constructor Create(AName, AHandle, AEmail, ARole: String);

  End;

  TfrmHome = class(TForm)
    lblSharpETeam: TLabel;
    lbUsers: TSharpEListBoxEx;
    PngImageList1: TPngImageList;
    lbWebsiteLinks: TSharpEListBoxEx;
    Label1: TLabel;
    imgLogo: TImage;
    Label3: TLabel;
    Label2: TJvLabel;
    Label4: TJvLabel;
    Label5: TJvLabel;
    Label6: TJvLabel;
    Label7: TJvLabel;
    JvLabel1: TJvLabel;
    procedure FormCreate(Sender: TObject);
    procedure lbUsersResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbUsersGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure Label1Click(Sender: TObject);
    procedure lbWebsiteLinksGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbWebsiteLinksClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbUsersGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbUsersClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure Label2Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure JvLabel1Click(Sender: TObject);
  private
    FUsers: TList;
    procedure AddUsersToList;
    procedure AddItems;
  public
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
  FUsers := TList.Create;

  AddUsersToList;
  AddItems;

  lbWebsiteLinks.AddItem('Trac - <u>http://trac.sharpe-shell.org',1);
  lbWebsiteLinks.AddItem('Website - <u>http://www.sharpe-shell.org',1);
  lbWebsiteLinks.AddItem('Sourceforge - <u>http://sourceforge.net/projects/sharpe/',1);
End;

procedure TfrmHome.FormDestroy(Sender: TObject);
begin
  FUsers.Free;
end;

procedure TfrmHome.JvLabel1Click(Sender: TObject);
begin
  SharpExecute('http://everaldo.com/crystal/');
end;

procedure TfrmHome.Label1Click(Sender: TObject);
begin
  SharpExecute('http://www.famfamfam.com/lab/icons/silk/');
end;

procedure TfrmHome.Label2Click(Sender: TObject);
begin
  SharpExecute('http://www.famfamfam.com/lab/icons/silk/');
end;

procedure TfrmHome.Label4Click(Sender: TObject);
begin
   SharpExecute('http://www.thany.org');
end;

procedure TfrmHome.Label5Click(Sender: TObject);
begin
  SharpExecute('http://jvcl.sourceforge.net');
end;

procedure TfrmHome.Label6Click(Sender: TObject);
begin
  SharpExecute('http://www.graphics32.org');
end;

procedure TfrmHome.Label7Click(Sender: TObject);
begin
  SharpExecute('http://tango.freedesktop.org');
end;

{ TUser }


procedure TfrmHome.AddItems;
var
  i: Integer;
  tmpLi: TSharpEListItem;
  tmpUser: TUser;
begin
  lbUsers.Clear;
  for i := 0 to Pred(FUsers.Count) do begin
    tmpUser := TUser(FUsers[i]);
    tmpLi := lbUsers.AddItem(tmpUser.Name,0);
    tmpLi.Data := tmpUser;

  end;

end;

procedure TfrmHome.AddUsersToList;
var
  tmp: TUser;
begin
  // Main dev team
  tmp := TUser.Create('CoCo', 'Silentpyjamas', 'coco@sharpenviro.com', 'PR, Community + Support.');
  FUsers.Add(tmp);
  tmp := TUser.Create('David', 'Glacialfury', 'nathan@sharpenviro.com', 'Lead Tester + Support.');
  FUsers.Add(tmp);
  tmp := TUser.Create('Florian', 'Captain Herisson', 'florian@sharpenviro.com', 'Graphics + Design.');
  FUsers.Add(tmp);
  tmp := TUser.Create('Lee', 'Pixol', 'lee@sharpenviro.com', 'Lead Developer of Components, SharpCenter, Configurations.');
  FUsers.Add(tmp);
  tmp := TUser.Create('Martin', 'Billiberserker', 'martin@sharpenviro.com', 'Lead Developer of SharpBar, SharpDesk, SharpMenu, Modules.');
  FUsers.Add(tmp);
  tmp := TUser.Create('Nathan', 'Mc', 'nathan@sharpenviro.com', 'Lead Developer of SharpCore, SharpCompile.');
  FUsers.Add(tmp);

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

procedure TfrmHome.lbUsersGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TUser;
begin
  tmp := TUser(AItem.Data);
  if tmp = nil then exit;

  case ACol of
    colName: begin
      AColText := tmp.Name + ' (' + tmp.Handle + ')' + ' - <font color="clGray">' + tmp.Role;
    end;
    colEmail : AColText := '<u><font color="clNavy">Email</u>';
  end;

end;

procedure TfrmHome.lbUsersResize(Sender: TObject);
begin
  Self.Height := imgLogo.Height + lbUsers.Height + lbWebsiteLinks.Height +
    (lblSharpETeam.Height*2) + 200;
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

end.

