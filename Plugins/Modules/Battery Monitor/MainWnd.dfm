object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Battery Monitor'
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
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object lb_pc: TSharpESkinLabel
    Left = 106
    Top = 0
    Width = 12
    Height = 21
    AutoSize = True
    Caption = '.'
    AutoPos = apTop
    LabelStyle = lsMedium
  end
  object pbar: TSharpEProgressBar
    Left = 24
    Top = 16
    Width = 75
    Height = 9
    Min = 0
    Max = 100
    Value = 0
    AutoPos = apBottom
    AutoSize = True
  end
  object lb_info: TSharpESkinLabel
    Left = 2
    Top = 0
    Width = 12
    Height = 21
    AutoSize = True
    Caption = '.'
    AutoPos = apTop
    LabelStyle = lsMedium
  end
  object UpdateTimer: TTimer
    Enabled = False
    OnTimer = UpdateTimerTimer
    Left = 224
    Top = 16
  end
end
