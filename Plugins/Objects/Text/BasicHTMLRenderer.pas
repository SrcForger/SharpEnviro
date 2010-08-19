{
Source Name: BasicHTMLRenderer
Description: BasicHTMLRenderer class
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

unit BasicHTMLRenderer;

interface

uses Types,
     Classes,
     Dialogs,
     Graphics,
     Math,
     SysUtils,
     StrUtils,
     GR32;

type

  TIntArray = array of integer;
  TStringArray = array of String;
  TColorArray = array of TColor;

  TNameValueArray = array of record
                              Name : String;
                              Value : String;
                             end;

  TElemStatus = record
                  Bold      : integer;
                  Italic    : integer;
                  Underline : integer;
                  FontName  : TStringArray;
                  FontSize  : TIntArray;
                  FontColor : TColorArray;
                end;

  TTextElement = record
                   ePos        : integer;
                   eSPos       : integer;
                   Text        : String;
                   isBold      : integer;
                   isItalic    : integer;
                   isUnderline : integer;
                   FontName    : TStringArray;
                   FontSize    : TIntArray;
                   FontColor   : TColorArray;
                 end;
  TElementList = array of TTextElement;

  TLineStatus = record
                  isBold       : integer;
                  isItalic     : integer;
                  isUnderline  : integer;
                  Width        : integer;
                  Height       : integer;
                  Overhead     : String;
                  TextElements : TElementList;
                  FontName     : TStringArray;
                  FontSize     : TIntArray;
                  FontColor    : TColorArray;
                end;

  TLineList    = array of TLineStatus;

  TSimpleTag = record
                 Tag : String;
                 Pos : integer;
                 Special : String;
                 isSpecial : boolean;
                 TagProperties : TNameValueArray;
               end;

  TBasicHTMLRenderer = class
                       private
                         FWordWrap     : Boolean;
                         FMaxWidth     : integer;
                         FDrawHeight   : integer;
                         FDrawWidth    : integer;                         
                         FDrawPos      : TPoint;
                         FTarget       : TBitmap32;
                         FLines        : TStringList;
                         FLinesData    : TLineList;

                         function ParseElement(Text : String; EStatus : TElemStatus; var EList : TElementList) : TElemStatus;
                         function ParseLine(pWidth : integer; pText : String; LineStatus : TLineStatus) : TLineStatus;
                         procedure ClearLinesData;
                         function UpdateElementStatus(EStatus : TElemStatus; Tag : String; var TagProps : TNameValueArray) : TElemStatus; overload;
                         function UpdateElementStatus(EStatus : TElemStatus; Tag : String) : TElemStatus; overload;                                                  
                       public
                         SelStart : TPoint;
                         SelEnd   : TPoint;
                         procedure ParseText;
                         procedure RenderText;
                         procedure LoadFromCommaText(pText : String);
                         procedure LoadFromStringList(pSlist : TStringList);
                         procedure LoadFromStrings(pStrings : TStrings);
                         constructor Create(pTarget : TBitmap32); reintroduce;
                         destructor Destroy; override;

                         property WordWrap   : boolean     read FWordWrap write FWordWrap;
                         property MaxWidth   : integer     read FMaxWidth write FMaxWidth;
                         property DrawPos    : TPoint      read FDrawPos  write FDrawPos;
                         property DrawHeight : integer     read FDrawHeight;
                         property DrawWidth  : integer     read FDrawWidth;                         
                         property Target     : TBitmap32   read FTarget   write FTarget;
                         property Lines      : TStringList read FLines;
                       end;

var
  TagList     : array[0..2] of String = ('<b>','<i>','<u>');
  TagListEnds : array[0..2] of String = ('</b>','</i>','</u>');

implementation

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure AssignDynArray(var A,B : TColorArray); overload
var
  n : integer;
begin
  setlength(A,0);
  setlength(A,length(B));
  for n := 0 to High(B) do
      A[n] := B[n];
end;

procedure AssignDynArray(var A,B : TStringArray); overload
var
  n : integer;
begin
  setlength(A,0);
  setlength(A,length(B));
  for n := 0 to High(B) do
      A[n] := B[n];
end;

procedure AssignDynArray(var A,B : TIntArray); overload
var
  n : integer;
begin
  setlength(A,0);
  setlength(A,length(B));
  for n := 0 to High(B) do
      A[n] := B[n];
end;

function ElementStatus(Bold,Italic,Underline : integer; var FontName : TStringArray; FontSize : TIntArray; FontColor : TColorArray) : TElemStatus;
begin
  result.Bold := Bold;
  result.Italic := Italic;
  result.Underline := Underline;
  AssignDynArray(result.FontName,FontName);
  AssignDynArray(result.FontSize,FontSize);
  AssignDynArray(result.FontColor,FontColor);    
end;

function LineStatus(isBold,isItalic,isUnderline,Width,Height : integer; FontName : String; FontSize : integer; FontColor : TColor) : TLineStatus;
begin
  result.isBold      := isBold;
  result.isItalic    := isItalic;
  result.isUnderline := isUnderline;
  result.Width       := Width;
  result.Height      := Height;
  setlength(result.TextElements,0);
  setlength(result.FontName,1);
  setlength(result.FontSize,1);
  setlength(result.FontColor,1);
  result.FontName[0] := FontName;
  result.FontSize[0] := FontSize;
  result.FontColor[0] := FontColor;    
end;

function CompineElements(var A,B : TElemStatus) : TElemStatus;
begin
  A.Bold      := A.Bold      + B.Bold;
  A.Italic    := A.Italic    + B.Italic;
  A.Underline := A.Underline + B.Underline;
  result := A;
end;

function HexToColor(p_strhex: String): TColor;
var
  p_strHTML : String;
begin
  if p_strhex[1] = '#' then
     p_strhex := Copy(p_strhex, 2, length(p_strhex));

  p_strHTML := Copy(p_strhex, 5, 2) +
  Copy(p_strhex, 3, 2) +
  Copy(p_strhex, 1, 2);
  result := StrToInt('$' + p_strHTML);
end;

function TBasicHTMLRenderer.UpdateElementStatus(EStatus : TElemStatus; Tag : String; var TagProps : TNameValueArray) : TElemStatus;
var
 n : integer;
 fname : String;
 fsize : integer;
 fcolor : TColor;
begin
  fname := FTarget.Font.Name;
  fcolor := FTarget.Font.Color;
  fsize := FTarget.Font.Size;

  if tag = '/font' then
  begin
    if length(EStatus.FontName )> 1 then
    begin
      setlength(EStatus.FontName,length(EStatus.FontName)-1);
      setlength(EStatus.FontSize,length(EStatus.FontSize)-1);
      setlength(EStatus.FontColor,length(EStatus.FontColor)-1);
    end;
  end
  else
  if tag = 'font' then
  begin
    for n := 0 to High(TagProps) do
    begin
      if TagProps[n].Name = 'color' then
      begin
        try
          fcolor := HexToColor(TagProps[n].Value);
        except
          fcolor := FTarget.Font.Color;
        end;
      end else
      if TagProps[n].Name = 'face' then
      begin
        fname := TagProps[n].Value
      end
      else if TagProps[n].Name = 'size' then
      begin
        try
          fsize := strtoint(TagProps[n].Value);
        except
          fsize := FTarget.Font.Size;
        end;      
      end;
    end;
    setlength(EStatus.FontName,length(EStatus.FontName)+1);
    setlength(EStatus.FontSize,length(EStatus.FontSize)+1);
    setlength(EStatus.FontColor,length(EStatus.FontColor)+1);

    EStatus.FontSize[High(EStatus.FontSize)] := fsize;
    EStatus.FontColor[High(EStatus.FontColor)] := fcolor;
    EStatus.FontName[High(EStatus.FontName)] := fname;
    
  end;
  result := EStatus;
end;

function TBasicHTMLRenderer.UpdateElementStatus(EStatus : TElemStatus; Tag : String) : TElemStatus;
begin
  if Tag = '<b>' then
     EStatus.Bold := EStatus.Bold+1
  else if Tag = '</b>' then
       EStatus.Bold := EStatus.Bold-1
  else if Tag = '<i>' then
       EStatus.Italic := EStatus.Italic+1
  else if Tag = '</i>' then
       EStatus.Italic := EStatus.Italic-1
  else if Tag = '<u>' then
       EStatus.Underline := EStatus.Underline+1
  else if Tag = '</u>' then
       EStatus.Underline := EStatus.Underline-1;
  if EStatus.Bold<0 then EStatus.Bold := 0;
  if EStatus.Italic<0 then EStatus.Italic := 0;
  if EStatus.Underline<0 then EStatus.Underline := 0;
  result := EStatus;
end;

function GetTagProperties(Text : String) : TNameValueArray;
var
  k,i : integer;
  s : String;
begin
  setlength(result,0);
  Text := ' '+Text+' ';
  while (Pos(' ',Text)>0) and (length(Text)>4)do
  begin
    k := Pos(' ',Text);
    s := Copy(Text,0,k);
    i := Pos('=',s);
    if (i>0) then
    begin
      setlength(result,length(result)+1);
      result[High(result)].Name := Copy(s,0,i-1);
      result[High(result)].Value := Copy(s,i+2,length(s)-i-3);
    end;

    Text := Copy(Text,k+1,length(Text));
  end;
end;

function GetNextTag(Start : integer; Text : String) : TSimpleTag;
var
  n : integer;
  i : integer;
  k : integer;
  Tag : TSimpleTag;
  s : String;
begin
  Tag.Pos := length(Text)+1;
  Tag.Tag := '';

  i := length(Text)+1;
  for n := 0 to High(TagList) do
  begin
    k := Pos(TagList[n],Text);
    if (k<=i) and (k>0) then
    begin
      i := k;
      Tag.Pos := k;
      Tag.Tag := TagList[n];
    end;
  end;
  for n := 0 to High(TagListEnds) do
  begin
    k := Pos(TagListEnds[n],Text);
    if (k<=i) and (k>0) then
    begin
      i := k;
      Tag.Pos := k;
      Tag.Tag := TagListEnds[n];
    end;
  end;

  Tag.isSpecial := False;
  // Special Tags!
  k := (Pos('<font ',Text));
  if (k<>0) and (k<=i) then
  begin
    if Pos('>',Text) = 0 then Text := Text+'>';
    i := k;
    Tag.isSpecial := True;
    Tag.Pos := k;
    Tag.Tag := Copy(Text,k,Pos('>',Text)-k+1);
    Tag.Special := 'font';
    s := Copy(Text,k+length('<font '),Pos('>',Text)-k-length('<font '));
    Tag.TagProperties := GetTagProperties(s);
  end;

  k := (Pos('</font>',Text));
  if (k <> 0) and (k <= i) then
  begin
    Tag.isSpecial := True;
    Tag.Pos := k;
    Tag.Tag := '</font>';
    Tag.Special := '/font';
  end;
  result := Tag;
end;



function TBasicHTMLRenderer.ParseElement(Text : String; EStatus : TElemStatus;var EList : TElementList) : TElemStatus;
var
  Tag   : TSimpleTag;
  newText : String;
begin
  if length(Text)=0 then
  begin
    setlength(EList,length(EList)+1);
    if length(EList) > 1 then
       EList[High(EList)].eSPos := EList[High(EList)-1].ePos
    else
      EList[High(EList)].eSPos := 0;
      
    EList[High(EList)].Text        := '';
    EList[High(EList)].isBold      := EStatus.Bold;
    EList[High(EList)].isItalic    := EStatus.Italic;
    EList[High(EList)].isUnderline := EStatus.Underline;
    AssignDynArray(EList[High(EList)].FontName,EStatus.FontName);
    AssignDynArray(EList[High(EList)].FontSize,EStatus.FontSize);
    AssignDynArray(EList[High(EList)].FontColor,EStatus.FontColor);
    EList[High(EList)].ePos := EList[High(EList)].eSPos + Tag.Pos-1+length(Tag.Tag);
    exit;
  end;
  Tag := GetNextTag(0,Text);

  begin
    setlength(EList,length(EList)+1);
    if length(EList)>1 then
       EList[High(EList)].eSPos := EList[High(EList)-1].ePos
       else EList[High(EList)].eSPos := 0;
    EList[High(EList)].Text := Copy(Text,0,Tag.Pos-1);
    EList[High(EList)].isBold      := EStatus.Bold;
    EList[High(EList)].isItalic    := EStatus.Italic;
    EList[High(EList)].isUnderline := EStatus.Underline;
    AssignDynArray(EList[High(EList)].FontName,EStatus.FontName);
    AssignDynArray(EList[High(EList)].FontSize,EStatus.FontSize);
    AssignDynArray(EList[High(EList)].FontColor,EStatus.FontColor);
    EList[High(EList)].ePos := EList[High(EList)].eSPos + Tag.Pos-1+length(Tag.Tag);
  end;

  if (length(Tag.Tag)>0) then
  begin
    if Tag.isSpecial then EStatus := UpdateElementStatus(EStatus,Tag.Special,Tag.TagProperties)
       else EStatus := UpdateElementStatus(EStatus,Tag.Tag);
    setlength(Tag.TagProperties,0);
  end;

  newText := Copy(Text,Tag.Pos+length(Tag.Tag),length(Text));
  ParseElement(newText,EStatus,EList);
end;

constructor TBasicHTMLRenderer.Create(pTarget : TBitmap32);
begin
  FTarget := pTarget;
  FLines  := TStringList.Create;
  FLines.Clear;
  setlength(FLinesData,0);
end;

destructor TBasicHTMLRenderer.Destroy;
begin
  ClearLinesData;
  FLines.Clear;
  FLines.Free;
  FLines := nil;
end;

procedure TBasicHTMLRenderer.LoadFromCommaText(pText : String);
var
  i, ai : integer;
  tmp : string;
begin
  FLines.Clear;

  i := 1;
  ai := 0;

  while i < Length(pText) do
  begin
    ai := PosEx('<br>', pText, i);
    if ai <= 0 then
      break;

    // Add newline
    if ai = i then
    begin
      FLines.Add(sLineBreak);

      i := i + Length('<br>');

      continue;
    end;

    // Add text between <br>'s
    if (ai - i) > 0 then
    begin
      tmp := Copy(pText, i, (ai - i));
      Flines.Add(tmp);
    end;

    i := ai + Length('<br>');
  end;

  // Add any remaining text
  if ((Length(pText) - ai) - i) > 0 then
  begin
    tmp := Copy(pText, i, (Length(pText) - ai) - i + 1);
    Flines.Add(tmp);
  end;
end;

procedure TBasicHTMLRenderer.LoadFromStringList(pSlist : TStringList);
begin
  FLines.Clear;
  FLines.AddStrings(pSList);
end;

procedure TBasicHTMLRenderer.LoadFromStrings(pStrings : TStrings);
begin
  FLines.Clear;
  FLines.AddStrings(pStrings);
end;

function TBasicHTMLRenderer.ParseLine(pWidth : integer; pText : String; LineStatus : TLineStatus) : TLineStatus;
var
  n,i : integer;
  exitafter : boolean;
  s,s2 : String;
begin
  if length(pText) = 0 then
  begin
    result := LineStatus;
    exit;
  end;

  setlength(LineStatus.TextElements,0);
  ParseElement(pText,ElementStatus(LineStatus.isBold,LineStatus.isItalic,LineStatus.isUnderline,LineStatus.FontName,LineStatus.FontSize,LineStatus.FontColor),LineStatus.TextElements);

  LineStatus.Height   := 0;
  LineStatus.Width    := 0;
  LineStatus.Overhead := '';
  exitafter := false;
  if length(LineStatus.TextElements)>0 then
  begin
    for n := 0 to High(LineStatus.TextElements) do
    begin
      FTarget.Font.Style := [];
      with LineStatus.TextElements[n] do
      begin
        LineStatus.isBold := isBold;
        LineStatus.isItalic := isItalic;
        LineStatus.isUnderline := isUnderline;

        AssignDynArray(LineStatus.FontName,FontName);
        AssignDynArray(LineStatus.FontSize,FontSize);
        AssignDynArray(LineStatus.FontColor,FontColor);

        if isBold > 0 then
          FTarget.Font.Style := FTarget.Font.Style + [fsBold];
        if isItalic > 0 then
          FTarget.Font.Style := FTarget.Font.Style + [fsItalic];
        if isUnderline > 0 then
          FTarget.Font.Style := FTarget.Font.Style + [fsUnderline];
          
        FTarget.Font.Name  := FontName[High(FontName)];
        FTarget.Font.Color := FontColor[High(FontColor)];
        FTarget.Font.Size  := FontSize[High(FontSize)];
        if ((LineStatus.Width + FTarget.TextWidth(Text)) > (pWidth)) then
        begin
          if FWordWrap then
          begin
            s := Text;
            s2 := Text;
            while Pos(' ',s)>0 do
            begin
              if ((LineStatus.Width + FTarget.TextWidth(Copy(s,0,Pos(' ',s)))<(pWidth))) then
                 Text := Copy(s2,0,Pos(' ',s));
              s := stringreplace(s,' ','#',[]);
            end;
            if (length(Text)<length(s2)) and (length(Text)>0)  then LineStatus.Overhead := Copy(pText,eSpos+length(Text)+1,length(ptext));
            if ((LineStatus.Width + FTarget.TextWidth(Text)) > (pWidth)) then
            begin
              for i := 0 to length(Text) do
              begin
                if ((LineStatus.Width + FTarget.TextWidth(Copy(s2,0,i))) > (pWidth)) then
                begin
                  LineStatus.Overhead := Copy(pText,eSpos+i,length(pText));
                  break;
                end else Text := Copy(s2,0,i);
              end;
            end;
          exitafter := True;
          end;
        end;
        LineStatus.Width := LineStatus.Width + FTarget.TextWidth(Text);
        LineStatus.Height := Max(LineStatus.Height,FTarget.TextHeight(Text));
        if exitafter then
        begin
          for i := n+1 to High(LineStatus.TextElements) do
          begin
            setlength(LineStatus.TextElements[i].FontName,0);
            setlength(LineStatus.TextElements[i].FontSize,0);
            setlength(LineStatus.TextElements[i].FontColor,0);
          end;
          setlength(LineStatus.TextElements,n+1);
          break;          
        end;
      end;
    end;
  end;
  result := LineStatus;
end;

procedure TBasicHTMLRenderer.ParseText;
var
  n : integer;
  y,x : integer;
  Font : TFont;
  s : String;
begin
  ClearLinesData;
  if FLines.Count = 0 then exit;

  Font := TFont.Create;
  Font.Assign(FTarget.Font);

  s := FLines.CommaText;

  y := 0;
  x := 0;
  n := 0;
  while n < FLines.Count do
  begin
    setlength(FLinesData,length(FLinesData)+1);
    if length(FLinesData) = 1 then
      FLinesData[High(FLinesData)] := ParseLine(FMaxWidth,Lines[n],LineStatus(0,0,0,0,0,Font.Name,Font.Size,Font.Color))
    else
      FLinesData[High(FLinesData)] := ParseLine(FMaxWidth,Lines[n],FLinesData[High(FLinesData)-1]);

    y := y + FLinesData[High(FLinesData)].Height;

    if FLinesData[High(FLinesData)].Width > x then
       x := FLinesData[High(FLinesData)].Width;
    if length(FLinesData[High(FLinesData)].Overhead) <> 0 then
       Lines.Insert(n+1,FLinesData[High(FLinesData)].Overhead);
       
    n := n + 1;
  end;
  FDrawHeight := y;
  FDrawWidth := x;

  FTarget.Font.Assign(Font);
  FreeAndNil(Font);

  FLines.CommaText := s;
end;

procedure TBasicHTMLRenderer.RenderText;
var
  n : integer;
  i : integer;
  Font : TFont;
  y,x : integer;
begin
  Font := TFont.Create;
  Font.Assign(FTarget.Font);

  y := 0;
  for n := 0 to High(FLinesData) do
  begin
    x := 0;
    for i := 0 to High(FLinesData[n].TextElements) do
    begin
      FTarget.Font.Style := [];
      with FLinesData[n].TextElements[i] do
      begin

        if isBold > 0 then
          FTarget.Font.Style := FTarget.Font.Style + [fsBold];
        if isItalic > 0 then
          FTarget.Font.Style := FTarget.Font.Style + [fsItalic];
        if isUnderline > 0 then
          FTarget.Font.Style := FTarget.Font.Style + [fsUnderline];

        FTarget.Font.Name  := FontName[High(FontName)];
        FTarget.Font.Color := FontColor[High(FontColor)];
        FTarget.Font.Size  := FontSize[High(FontSize)];

        FTarget.RenderText(FDrawPos.X+x,round(FDrawPos.Y+y+FLinesData[n].Height-FTarget.TextHeight(Text)),Text,0,color32(FTarget.Font.Color));

        x := x + FTarget.TextWidth(Text);
      end;
    end;
    y := y + FLinesData[n].Height;
  end;
  
  FTarget.Font.Assign(Font);
  FreeAndNil(Font);
end;

procedure TBasicHTMLRenderer.ClearLinesData;
var
  n : integer;
begin
  for n := 0 to High(FLinesData) do
      setlength(FLinesData[n].TextElements,0);
  setlength(FLinesData,0);
  FLinesData := nil;  
end;

end.
