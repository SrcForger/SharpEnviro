object SharpEMenuWnd: TSharpEMenuWnd
  Left = 468
  Top = 173
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Menu'
  ClientHeight = 265
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClick = FormClick
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 13
  object SubMenuTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = SubMenuTimerTimer
    Left = 112
    Top = 72
  end
  object offsettimer: TTimer
    Enabled = False
    Interval = 25
    OnTimer = offsettimerTimer
    Left = 144
    Top = 72
  end
end
