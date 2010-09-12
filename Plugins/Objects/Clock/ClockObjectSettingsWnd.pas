{
Source Name: ClockObjectSettingsWnd.pas
Description: Clock object settings window
Copyright (C) Delusional <Delusional@Lowdimension.net>
              Martin Krämer <MartinKraemer@gmx.net>

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

unit ClockObjectSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SharpApi, ComCtrls, DateUtils, JvSimpleXML,
  GR32_Image, pngimage, ExtCtrls, GR32,
  GR32_PNG,
  GR32_Transforms,
  GR32_Resamplers,
  uSharpDeskTDeskSettings;

type
  TSettingsWnd = class(TForm)
    FontDialog1: TFontDialog;
    Panel2: TPanel;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    lb_alpha: TLabel;
    cb_shadow: TCheckBox;
    cb_AlphaBlend: TCheckBox;
    tb_alpha: TTrackBar;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    btnChooseFont: TButton;
    cb_dc: TRadioButton;
    GroupBox1: TGroupBox;
    lb_author: TLabel;
    SkinList: TListBox;
    ImgView321: TImgView32;
    cb_special: TCheckBox;
    cb_glass: TCheckBox;
    cb_ac: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure btnChooseFontClick(Sender: TObject);
    procedure cb_AlphaBlendClick(Sender: TObject);
    procedure tb_alphaChange(Sender: TObject);
    procedure SkinListClick(Sender: TObject);
    procedure cb_glassClick(Sender: TObject);
    procedure cb_acClick(Sender: TObject);
    procedure cb_dcClick(Sender: TObject);
  private
  public
    DeskSettings   : TDeskSettings;
    ObjectID : integer;
    StartX : Integer;
    function GetSettingsFile : String;
    procedure SaveSettings;
    procedure LoadSettings;
  end;

var
  FontName : String;
  FontColor : TColor;
  FontSize : integer;

implementation

{$R *.dfm}

function TSettingsWnd.GetSettingsFile : string;
var
  UserDir,Dir : String;
begin
  UserDir := SharpApi.GetSharpeUserSettingsPath;
  Dir := UserDir + 'SharpDesk\Objects\Clock\';
  result := Dir + inttostr(ObjectID) + '.xml';
end;

procedure TSettingsWnd.LoadSettings();
var
  XML : TJvSimpleXML;
  sfile : String;
begin
  if ObjectID=0 then
  begin
    cb_ac.Checked := True;
    cb_ac.OnClick(cb_ac);
    cb_alphablend.OnClick(cb_alphablend);
    exit;
  end;

  sfile := GetSettingsFile;
  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(sFile);
    with XML.Root.Items do
    begin
      cb_ac.Checked := BoolValue('ClockType',False);
      cb_dc.Checked := not cb_ac.Checked;
      if cb_ac.Checked then cb_ac.OnClick(cb_ac)
         else cb_dc.OnClick(cb_dc);
      if (cb_ac.Checked) and (SkinList.Items.Count>0) then
      begin
        if SkinList.Items.IndexOf(Value('AnalogSkin',''))<>-1
           then SKinList.ItemIndex := SKinList.Items.IndexOf(Value('AnalogSkin',''));
      end;
      FontName  := Value('FontName','Arial');
      FontSize  := IntValue('FontSize',32);
      FontColor := IntValue('FontColor',0);
      cb_AlphaBlend.Checked  := BoolValue('AlphaBlend',false);
      cb_AlphaBlend.OnClick(cb_AlphaBlend);
      cb_shadow.Checked      := BoolValue('DrawShadow',false);
      tb_alpha.Position      := IntValue('AlphaValue',255);
      btnChooseFont.Font.Name := FontName;
      btnChooseFont.Caption := FontName;
      btnChooseFont.Font.Size := FontSize;
      cb_special.checked := BoolValue('DrawSpecial',True);
      cb_glass.checked := BoolValue('DrawGlass',True);
      cb_alphablend.OnClick(cb_alphablend);
      SkinList.OnClick(SkinList);
   end;
 finally
   XML.Free;
 end;
end;


procedure TSettingsWnd.SaveSettings();
var
  XML : TJvSimpleXML;
  sfile : String;
begin
  if ObjectID = 0 then exit;

  sfile := GetSettingsFile;
  ForceDirectories(ExtractFileDir(sfile));
  XML := TJvSimpleXML.Create(nil);
  try
    XML.Root.Name := 'ClockObjectSettings';
    XML.Root.Clear;
    with XML.Root.Items do
    begin
      Add('DrawSpecial',cb_special.checked).Properties.Add('CopyValue',True);
      Add('DrawGlass',cb_glass.checked).Properties.Add('CopyValue',True);
      Add('ClockType',cb_ac.Checked).Properties.Add('CopyValue',True);
      Add('AlphaBlend',cb_AlphaBlend.Checked).Properties.Add('CopyValue',True);
      Add('AlphaValue',tb_alpha.Position).Properties.Add('CopyValue',True);
      Add('DrawShadow',cb_shadow.checked).Properties.Add('CopyValue',True);
      Add('FontColor',FontColor).Properties.Add('CopyValue',True);
      Add('FontName',FontName).Properties.Add('CopyValue',True);
      Add('FontSize',FontSize).Properties.Add('CopyValue',True);
      if (cb_ac.Checked) and (SkinList.ItemIndex<>-1) then
         Add('AnalogSkin',SkinList.Items[SkinList.Itemindex]).Properties.Add('CopyValue',True);
    end;
    if FileExists(sfile) then Deletefile(sfile);
    XML.SaveToFile(sfile);
  finally
    XML.Free;
  end;
end;

procedure TSettingsWnd.FormCreate(Sender: TObject);
var
   sr : TSearchRec;
begin
     ImgView321.Bitmap := TBitmap32.Create;

     FontName := 'Arial';
     FontColor := clBlack;
     FontSize := 16;
//     btnChooseFont.Font.Name := FontDialog1.Font.Name;
//     btnChooseFont.Caption := FontDialog1.Font.Name;
//     btnChooseFont.Font.Size := FontDialog1.Font.Size;

     SkinList.Clear;
     if FindFirst(ExtractFileDir(Application.ExeName)+'\Objects\Clock\watchfaces\*.*', faDirectory , sr) = 0 then
     begin
          repeat
                if (sr.Name<>'.') and (sr.Name<>'..') then
                   SkinList.Items.Add(sr.Name);
          until FindNext(sr) <> 0;
     end;
     FindClose(sr);
     if SkinList.Items.Count>0 then
     begin
          SkinList.ItemIndex := 0;
          SkinList.OnClick(SkinList);
     end;
end;

procedure TSettingsWnd.btnChooseFontClick(Sender: TObject);
begin
     Self.FontDialog1.Font.Name := FontName;
     Self.FontDialog1.Font.Size := FontSize;
     Self.FontDialog1.Font.Color := FontColor;
    if (Self.FontDialog1.Execute) then
    begin
         FontName := FontDialog1.Font.Name;
         FontSize := FontDialog1.Font.Size;
         FontColor := FontDialog1.Font.Color;
         btnChooseFont.Font.Name := FontDialog1.Font.Name;
         btnChooseFont.Caption := FontDialog1.Font.Name;
         btnChooseFont.Font.Size := FontDialog1.Font.Size;
    end;
end;

procedure TSettingsWnd.cb_AlphaBlendClick(Sender: TObject);
begin
     tb_alpha.Enabled := cb_AlphaBlend.Checked;
     label6.Enabled := cb_AlphaBlend.Checked;
     lb_alpha.Enabled := cb_AlphaBlend.Checked;
//     if not cb_AlphaBlend.Checked then tb_alpha.Position:=255;
end;

procedure TSettingsWnd.tb_alphaChange(Sender: TObject);
begin
     lb_alpha.Caption := inttostr(round((tb_alpha.Position*100) / tb_alpha.Max))+'%';
     if cb_ac.Checked then SkinList.OnClick(SkinList);
end;

procedure RotateBitmap(Src,Dst : TBitmap32; Alpha: Single);
var
  SrcR: Integer;
  SrcB: Integer;
  T: TAffineTransformation;
  {Sx, Sy, }Scale: Single;
begin
  SrcR := Src.Width - 1;
  SrcB := Src.Height - 1;
  TKernelResampler.Create(Src).Kernel := TMitchellKernel.Create;
  T := TAffineTransformation.Create;
  T.SrcRect := FloatRect(0, 0, SrcR + 1, SrcB + 1);
  try
    T.Clear;

    T.Translate(-SrcR / 2, -SrcB / 2);
    T.Rotate(0, 0, Alpha);
    //Alpha := Alpha * 3.14159265358979 / 180;

    //Sx := Abs(SrcR * Cos(Alpha)) + Abs(SrcB * Sin(Alpha));
    //Sy := Abs(SrcR * Sin(Alpha)) + Abs(SrcB * Cos(Alpha));

    scale := 1;

    T.Scale(Scale, Scale);

    T.Translate(SrcR / 2, SrcB / 2);

    Dst.BeginUpdate;
    Transform(Dst, Src, T);
    Dst.EndUpdate;
  finally
    T.Free;
  end;
end;

procedure TSettingsWnd.SkinListClick(Sender: TObject);
var
  Dir : String;
  FCaption : String;
  XMod,YMod : integer;
  AALevel : integer;
  FAlpha : integer;
  FClockBack : TBitmap32;
  FClockGlas : TBitmap32;
  FHArrow : TBitmap32;
  FMArrow : TBitmap32;
//  FSArrow : TBitmap32;
  FPicture : TBitmap32;
  TempBmp : TBitmap32;
  //SrcR: Integer;
  //SrcB: Integer;
  //T: TAffineTransformation;
  //Sx, Sy, Scale: Single;
  b : boolean;
  XML : TJvSimpleXML;
  n : integer;
  FColor : TColor;
  Day,Month,Year : String;
begin
     if SkinList.Items.Count = 0 then exit;
     dir := ExtractFileDir(Application.ExeName)+'\Objects\Clock\watchfaces\'+SkinList.Items[SkinList.ItemIndex]+'\';
     XML := TJvSimpleXML.Create(nil);
     XML.LoadFromFile(dir+'skin.xml');
     lb_author.Caption := 'Skin Author : ' + XML.Root.Items.Value('Author','none');

     FClockBack := TBitmap32.Create;
     FClockGlas := TBitmap32.Create;
     FHArrow := TBitmap32.Create;
     FMArrow := TBitmap32.Create;
//     FSArrow := TBitmap32.Create;

     FClockBack.DrawMode := dmBlend;
     FClockGlas.DrawMode := dmBlend;
     FHArrow.DrawMode := dmBlend;
     FMArrow.DrawMode := dmBlend;
//     FSArrow.DrawMode := dmBlend;

     LoadBitmap32FromPNG(FClockBack,dir+'watch_face.png',b);
     LoadBitmap32FromPNG(FClockGlas,dir+'watch_glass.png',b);
     LoadBitmap32FromPNG(FHArrow,dir+'hand_hour.png',b);
     LoadBitmap32FromPNG(FMArrow,dir+'hand_minute.png',b);
//     LoadBitmap32FromPNG(FSArrow,dir+'hand_second.png',b);

     ImgView321.Bitmap.SetSize(FClockBack.Width,FClockBack.Height);
     ImgView321.Bitmap.Clear;

     FPicture := TBitmap32.Create;
     FPicture.SetSize(FClockBack.Width,FClockBack.Height);
     FPicture.Clear(color32(0,0,0,0));

     FClockBack.DrawTo(FPicture);

     if cb_special.Checked then
     begin
          Day := inttostr(DayOf(Now));
          if length(Day) = 1 then Day := '0'+Day;
          Month := inttostr(MonthOf(Now));
          if length(Month) = 1 then Month := '0'+Month;
          Year := inttostr(YearOf(Now));
          for n:=0 to XML.Root.Items.ItemNamed['text'].Items.Count -1 do
              with XML.Root.Items.ItemNamed['text'].Items.Item[n].Items do
              begin
                   FPicture.Font.Name := Value('FontName','Arial');
                   FPicture.Font.Size := IntValue('FontSize',8);
                   FColor := IntValue('FontColor',0);
                   FAlpha := IntValue('FontAlpha',0);
                   if BoolValue('FontBold',False) then FPicture.Font.Style := [fsBold]
                      else FPicture.Font.Style := [];
                   XMod := IntValue('XMod',0);
                   YMod := IntValue('YMod',0);
                   FCaption := Value('Caption','none');
                   AALevel := IntValue('FontAALevel',0);
                   FCaption := StringReplace(FCaption,'{Day}',Day,[rfReplaceAll, rfIgnoreCase]);
                   FCaption := StringReplace(FCaption,'{Month}',Month,[rfReplaceAll, rfIgnoreCase]);
                   FCaption := StringReplace(FCaption,'{Year}',Year,[rfReplaceAll, rfIgnoreCase]);
                   FCaption := StringReplace(FCaption,'{Month2}',FormatDateTime('mmm',now),[rfReplaceAll, rfIgnoreCase]);
                   FPicture.RenderText(XMod,YMod,FCaption,AALevel,color32(GetRValue(FColor),GetGValue(FColor),GetBValue(FColor),FAlpha));
              end;
     end;

     TempBmp := TBitmap32.Create;
     TempBmp.DrawMode := dmBlend;
     TempBmp.SetSize(FClockBack.Width,FClockBack.Height);

     TempBmp.Clear(color32(0,0,0,0));
     RotateBitmap(FHArrow,TempBmp,-HourOf(Now)*30);
     TempBmp.DrawTo(FPicture);

     TempBmp.Clear(color32(0,0,0,0));
     RotateBitmap(FMArrow,TempBmp,-MinuteOf(Now)*6);
     TempBmp.DrawTo(FPicture);

//     TempBmp.Clear(color32(0,0,0,0));
//     RotateBitmap(FSArrow,TempBmp,-SecondOf(Now)*6);
//     TempBmp.DrawTo(FPicture);

     if cb_glass.checked then FClockGlas.DrawTo(FPicture);

     FPicture.DrawMode := dmBlend;
     //FPicture.MasterAlpha := tb_alpha.Position;
     FPicture.DrawTo(ImgView321.Bitmap);

     XML.Free;     
     FPicture.Free;
     TempBmp.Free;
     FClockBack.Free;
     FClockGlas.Free;
     FHArrow.Free;
     FMArrow.Free;     
end;

procedure TSettingsWnd.cb_glassClick(Sender: TObject);
begin
     SkinList.OnClick(SkinList);
end;

procedure TSettingsWnd.cb_acClick(Sender: TObject);
var
   b : boolean;
begin
     cb_dc.Checked := not cb_ac.Checked;
     b := not cb_ac.checked;
     Label1.Enabled := b;
     btnChooseFont.Enabled := b;
     cb_shadow.Enabled := b;
     cb_glass.Enabled := not b;
     cb_special.Enabled := not b;
     ImgView321.Enabled := not b;
     lb_author.Enabled := not b;
     SkinList.Enabled := not b;
end;

procedure TSettingsWnd.cb_dcClick(Sender: TObject);
var
   b : boolean;
begin
     cb_ac.Checked := not cb_dc.Checked;
     b := cb_dc.checked;
     Label1.Enabled := b;
     btnChooseFont.Enabled := b;
     cb_shadow.Enabled := b;
     cb_glass.Enabled := not b;
     cb_special.Enabled := not b;
     ImgView321.Enabled := not b;
     lb_author.Enabled := not b;
     SkinList.Enabled := not b;
end;

end.
