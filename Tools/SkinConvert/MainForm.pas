unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JclSimpleXML;

type
  TForm31 = class(TForm)
    edtSrcFile: TEdit;
    Label1: TLabel;
    Button1: TButton;
    OpenXMLDialog: TOpenDialog;
    Label2: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form31: TForm31;
  ConvertList : TStringList;

implementation

{$R *.dfm}

procedure TForm31.Button1Click(Sender: TObject);
begin
  if OpenXMLDialog.Execute then
  begin
      edtSrcFile.Text := OpenXMLDialog.FileName;
  end;
end;

procedure ParseAndConvertXMLItem(XMLItem : TJclSimpleXMlElem);
var
  n : integer;
begin
  n := ConvertList.IndexOf(XMLItem.Name);
  if n = -2 then
    exit;
  if ConvertList.IndexOf(XMLItem.Name) <> -1 then
  begin
    for n := XMLItem.Items.Count - 1 downto 0 do
    begin
      if ConvertList.IndexOf(XMLItem.Items.Item[n].Name) <> -1 then
        ParseAndConvertXMLItem(XMLItem.Items.Item[n])
      else if XMLItem.Items.Item[n].Items.Count <> 0 then
        ParseAndConvertXMLItem(XMLItem.Items.Item[n])
      else begin
        XMLItem.Properties.Add(XMLItem.Items.Item[n].Name,XMLItem.Items.Item[n].Value);
        XMLItem.Items.Delete(n);
      end;
    end;
  end else
  begin
    for n := XMLItem.Items.Count - 1 downto 0 do
    begin
      if (ConvertList.IndexOf(XMLItem.Items.Item[n].Name) = -1)
        and (XMLItem.Items.Item[n].Items.Count = 0) then
      begin
        XMLItem.Properties.Add(XMLItem.Items.Item[n].Name,XMLItem.Items.Item[n].Value);
        XMLItem.Items.Delete(n);
      end else ParseAndConvertXMLItem(XMLItem.Items.Item[n]);
    end;
  end;
end;

procedure TForm31.Button2Click(Sender: TObject);
var
  XML : TJclSimpleXML;
  n : integer;
  s : string;
begin
  if not FileExists(edtSrcFile.Text) then
  begin
    ShowMessage('File does not exist!');
    exit;
  end;

  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(edtSrcFile.Text);
    for n := 0 to XML.Root.Items.Count - 1 do
      ParseAndConvertXMLItem(XML.Root.Items.Item[n]);

    s := edtSrcFile.Text;
    setlength(s,length(s) - length(ExtractFileExt(s)));
    s := s + '_converted.xml';
    XML.SaveToFile(s);
  except
    ShowMessage('Error while loading or parsing XML file!');
    exit;
  end;
  XML.Free;
end;

procedure TForm31.FormCreate(Sender: TObject);
begin
  ConvertList := TStringList.Create;
  ConvertList.Clear;
  ConvertList.CaseSensitive := False;
  ConvertList.Add('skinpart');
  ConvertList.Add('text');
  ConvertList.Add('icon');
  ConvertList.Add('overlaytext');
  ConvertList.Add('big');
  ConvertList.Add('medium');
  ConvertList.Add('small');
//  ConvertList.Add('');
end;

procedure TForm31.FormDestroy(Sender: TObject);
begin
  ConvertList.Free;
end;

end.
