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
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseLeave = FormMouseLeave
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SubMenuTimer: TTimer
    Enabled = False
    Interval = 250
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
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 176
    Top = 72
  end
  object SubMenuCloseTimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = SubMenuCloseTimerTimer
    Left = 112
    Top = 104
  end
  object HideTimer: TTimer
    Enabled = False
    Interval = 0
    OnTimer = HideTimerOnTimer
    Left = 144
    Top = 104
  end
end
