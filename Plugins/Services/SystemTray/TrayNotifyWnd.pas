unit TrayNotifyWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TTrayNWnd = class(TForm)
    procedure CreateParams(var Params: TCreateParams); override;
  private

  public
    { Public-Deklarationen }
  end;

var
  TrayNWnd: TTrayNWnd;

implementation

{$R *.dfm}

procedure TTrayNWnd.CreateParams(var Params: TCreateParams);
begin
  try
    inherited;// CreateParams(Params);
    
    with Params do
    begin
      Params.WinClassName := 'TrayNotifyWnd';
      ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
      Style := WS_POPUP or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
    end;
  except
  end;
end;

end.
