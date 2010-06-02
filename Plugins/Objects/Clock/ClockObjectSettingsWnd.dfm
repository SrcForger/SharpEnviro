object SettingsWnd: TSettingsWnd
  Tag = 1
  Left = 277
  Top = 154
  BorderStyle = bsNone
  Caption = 'SettingsWnd'
  ClientHeight = 381
  ClientWidth = 515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 515
    Height = 381
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox3: TGroupBox
      Left = 200
      Top = 8
      Width = 313
      Height = 121
      Caption = 'Effects'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Small Fonts'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object Label6: TLabel
        Left = 16
        Top = 62
        Width = 31
        Height = 11
        Caption = 'Opacity'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Small Fonts'
        Font.Style = []
        ParentFont = False
      end
      object lb_alpha: TLabel
        Left = 256
        Top = 62
        Width = 25
        Height = 11
        Caption = '100%'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Small Fonts'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cb_shadow: TCheckBox
        Left = 16
        Top = 16
        Width = 169
        Height = 17
        Caption = 'Text Shadow (digital clock)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Small Fonts'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object cb_AlphaBlend: TCheckBox
        Left = 16
        Top = 40
        Width = 89
        Height = 17
        Caption = 'Alpha Blend'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Small Fonts'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = cb_AlphaBlendClick
      end
      object tb_alpha: TTrackBar
        Left = 12
        Top = 73
        Width = 277
        Height = 25
        Enabled = False
        Max = 255
        Min = 32
        Frequency = 10
        Position = 255
        TabOrder = 2
        ThumbLength = 15
        OnChange = tb_alphaChange
      end
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 8
      Width = 177
      Height = 121
      Caption = 'Digital'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Small Fonts'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object Label1: TLabel
        Left = 16
        Top = 60
        Width = 26
        Height = 11
        Caption = 'Font : '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Small Fonts'
        Font.Style = []
        ParentFont = False
      end
      object btnChooseFont: TButton
        Left = 56
        Top = 42
        Width = 105
        Height = 47
        Caption = 'Arial'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnChooseFontClick
      end
      object cb_dc: TRadioButton
        Left = 8
        Top = 16
        Width = 113
        Height = 17
        Caption = 'Digital Clock'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Small Fonts'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = True
        OnClick = cb_dcClick
      end
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 136
      Width = 505
      Height = 241
      Caption = 'Analog'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Small Fonts'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object lb_author: TLabel
        Left = 152
        Top = 16
        Width = 64
        Height = 14
        Caption = 'Skin Author : '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object SkinList: TListBox
        Left = 8
        Top = 40
        Width = 137
        Height = 193
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        OnClick = SkinListClick
      end
      object ImgView321: TImgView32
        Left = 152
        Top = 40
        Width = 193
        Height = 193
        Bitmap.ResamplerClassName = 'TNearestResampler'
        BitmapAlign = baCustom
        Color = clBlack
        ParentColor = False
        Scale = 1.000000000000000000
        ScaleMode = smScale
        ScrollBars.ShowHandleGrip = True
        ScrollBars.Style = rbsDefault
        OverSize = 0
        TabOrder = 1
      end
      object cb_special: TCheckBox
        Left = 352
        Top = 40
        Width = 145
        Height = 17
        Caption = 'Display special text'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = cb_glassClick
      end
      object cb_glass: TCheckBox
        Left = 352
        Top = 64
        Width = 81
        Height = 17
        Caption = 'Display glass'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = cb_glassClick
      end
      object cb_ac: TRadioButton
        Left = 8
        Top = 16
        Width = 113
        Height = 17
        Caption = 'Analog Clock'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = cb_acClick
      end
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 424
    Top = 8
  end
end
