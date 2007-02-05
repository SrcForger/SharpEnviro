{
Source Name: SettingsWnd
Description: Volume Control module settings window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
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

unit SettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, GR32_RangeBars, SharpApi, XPMan, Menus,
  MMSystem, SoundControls;

type
  TSettingsForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    XPManifest1: TXPManifest;
    Label1: TLabel;
    cb_mlist: TComboBox;
    Label4: TLabel;
    lb_barsize: TLabel;
    tb_size: TGaugeBar;
    Label2: TLabel;
    Label3: TLabel;
    procedure tb_sizeChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure BuildMixerList;
  public
    ActionStr : String;
    IDList : TStringList;
  end;


implementation

{$R *.dfm}

procedure TSettingsForm.BuildMixerList;
var
  Line  : TMixerLine;
  Mixer : hMixerObj;
  r     : MMResult;
  n     : integer;
begin
  cb_mlist.Clear;
  IDList.Clear;
  
  if (mixerGetNumDevs() < 1) then
  begin
    Exit;
  end;

  Mixer := InitMixer;
  for n := 0 to 8000 do
  begin
    ZeroMemory(@Line, SizeOf(Line));
    Line.cbStruct := SizeOf(Line);
    Line.dwComponentType :=  n;
    r := mixerGetLineInfo(Mixer, @Line, MIXER_GETLINEINFOF_COMPONENTTYPE);
    if r = MMSYSERR_NOERROR then
    begin
      IDList.Add(inttostr(n));
      cb_mlist.Items.Add(Line.szName + ' ('+inttostr(Line.dwDestination)+')');
    end;
  end;
   mixerclose(Mixer);
end;

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  if cb_mlist.ItemIndex <0 then
  begin
    showmessage('Please select a valid Mixer first');
    exit;
  end;
  self.ModalResult := mrOk;
end;

procedure TSettingsForm.Button2Click(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  IDList := TStringList.Create;
  BuildMixerList;
  if cb_mlist.Items.Count >0 then cb_mlist.ItemIndex := 0;
end;

procedure TSettingsForm.FormDestroy(Sender: TObject);
begin
  IDList.Free;
end;

procedure TSettingsForm.tb_sizeChange(Sender: TObject);
begin
  lb_barsize.Caption := inttostr(tb_size.Position) + 'px';
end;

end.
