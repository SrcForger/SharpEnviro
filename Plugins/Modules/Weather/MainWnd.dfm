object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Weather'
  ClientHeight = 159
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDblClick = BackgroundDblClick
  OnDestroy = FormDestroy
  OnMouseEnter = MouseEnter
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object lb_bottom: TSharpESkinLabel
    Left = 50
    Top = 0
    Width = 12
    Height = 21
    AutoSize = True
    Visible = False
    OnDblClick = BackgroundDblClick
    Caption = '.'
    AutoPos = apTop
    LabelStyle = lsSmall
  end
  object lb_top: TSharpESkinLabel
    Left = 2
    Top = 0
    Width = 12
    Height = 21
    AutoSize = True
    Visible = False
    OnDblClick = BackgroundDblClick
    Caption = '.'
    AutoPos = apTop
    LabelStyle = lsSmall
  end
  object PopupTimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = PopupTimerTimer
    Left = 24
    Top = 32
  end
  object ClosePopupTimer: TTimer
    Enabled = False
    OnTimer = ClosePopupTimerTimer
    Left = 56
    Top = 32
  end
end
