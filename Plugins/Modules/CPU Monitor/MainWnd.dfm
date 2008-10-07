object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'CPU Monitor'
  ClientHeight = 115
  ClientWidth = 265
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
  object pbar: TSharpEProgressBar
    Left = 96
    Top = 4
    Width = 75
    Height = 9
    Min = 0
    Max = 100
    Value = 0
    AutoPos = apCenter
    AutoSize = False
  end
  object cpugraphcont: TImage32
    Left = 32
    Top = 32
    Width = 113
    Height = 64
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    OnDblClick = cpugraphcontDblClick
  end
end
