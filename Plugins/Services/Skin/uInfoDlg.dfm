object InfoDlg: TInfoDlg
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'SkinServer Info'
  ClientHeight = 166
  ClientWidth = 249
  Color = 10011329
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object SharpELabel1: TSharpELabel
    Left = 8
    Top = 16
    Width = 55
    Height = 10
    Caption = 'Active SkinFile:'
    SkinManager = SharpESkinManager1
    LabelStyle = lsSmall
  end
  object SharpELabel2: TSharpELabel
    Left = 8
    Top = 64
    Width = 90
    Height = 10
    Caption = 'Number of Skins Loaded:'
    SkinManager = SharpESkinManager1
    LabelStyle = lsSmall
  end
  object lSkinFile: TSharpELabel
    Left = 88
    Top = 16
    Width = 0
    Height = 0
    SkinManager = SharpESkinManager1
    LabelStyle = lsSmall
  end
  object lnr: TSharpELabel
    Left = 112
    Top = 64
    Width = 0
    Height = 0
    SkinManager = SharpESkinManager1
    LabelStyle = lsSmall
  end
  object bClose: TSharpEButton
    Left = 80
    Top = 136
    Width = 75
    Height = 21
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnClick = bCloseClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TNearestResampler'
    Layout = blGlyphLeft
    Margin = -1
    DisabledAlpha = 100
    Caption = 'Close'
    AutoPosition = False
  end
  object SharpELabel3: TSharpELabel
    Left = 8
    Top = 88
    Width = 76
    Height = 10
    Caption = 'Number of Requests:'
    SkinManager = SharpESkinManager1
    LabelStyle = lsSmall
  end
  object lNrReq: TSharpELabel
    Left = 96
    Top = 88
    Width = 0
    Height = 0
    SkinManager = SharpESkinManager1
    LabelStyle = lsSmall
  end
  object SharpELabel4: TSharpELabel
    Left = 8
    Top = 112
    Width = 53
    Height = 10
    Caption = 'Last Hwnd req:'
    SkinManager = SharpESkinManager1
    LabelStyle = lsSmall
  end
  object lLastHwnd: TSharpELabel
    Left = 72
    Top = 112
    Width = 0
    Height = 0
    SkinManager = SharpESkinManager1
    LabelStyle = lsSmall
  end
  object SharpEForm1: TSharpEForm
    TitleBar = True
    SkinManager = SharpESkinManager1
    Left = 184
    Top = 128
  end
  object SharpESkinManager1: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    Left = 8
    Top = 128
  end
end
