object BarHideForm: TBarHideForm
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 1
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'BarHideForm'
  ClientHeight = 63
  ClientWidth = 568
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseUp = FormMouseUp
  PixelsPerInch = 120
  TextHeight = 17
  object curPosTimer: TTimer
    Interval = 1
    OnTimer = curPosTimerTimer
    Left = 400
    Top = 16
  end
end
