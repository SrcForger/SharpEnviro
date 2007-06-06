unit uCopyText;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList;

type
  TfrmCopyText = class(TForm)
    memoCopy: TMemo;
    imlTbDisabled: TImageList;
    imlTbHot: TImageList;
    imlTbNorm: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCopyText: TfrmCopyText;

implementation

{$R *.dfm}

end.
