object SharpDeskMainWnd: TSharpDeskMainWnd
  Left = 0
  Top = 0
  Width = 752
  Height = 446
  Caption = 'SharpDesk'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Background: TImage32
    Left = 0
    Top = 0
    Width = 744
    Height = 417
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    RepaintMode = rmOptimizer
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    OnMouseDown = BackgroundMouseDown
    OnMouseMove = BackgroundMouseMove
    OnMouseUp = BackgroundMouseUp
  end
end
