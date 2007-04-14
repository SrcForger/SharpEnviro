object SettingsWnd: TSettingsWnd
  Tag = 1
  Left = 433
  Top = 165
  BorderStyle = bsNone
  Caption = 'SettingsWnd'
  ClientHeight = 263
  ClientWidth = 315
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 313
    Height = 257
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox15: TGroupBox
      Left = 8
      Top = 8
      Width = 297
      Height = 57
      Caption = 'Target'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object btn_targetselect: TSpeedButton
        Left = 232
        Top = 20
        Width = 57
        Height = 22
        Caption = 'Select'
        Flat = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Glyph.Data = {
          76010000424D760100000000000036000000280000000A0000000A0000000100
          18000000000040010000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FF000000000000000000FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FF000000000000000000000000FF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FF000000000000000000000000FF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FF000000000000000000FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000}
        ParentFont = False
        OnClick = btn_targetselectClick
      end
      object edit_target: TEdit
        Left = 8
        Top = 20
        Width = 225
        Height = 22
        Ctl3D = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        Text = 'C:\'
      end
    end
    object GroupBox8: TGroupBox
      Left = 8
      Top = 72
      Width = 297
      Height = 105
      Caption = 'Caption'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object btn_mline: TSpeedButton
        Left = 264
        Top = 38
        Width = 23
        Height = 22
        Hint = 'multi line caption'
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          0000000000000000000000000000000000000000000000000000000000000000
          00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000
          0000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          0000000000000000000000000000000000000000000000000000000000000000
          00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000
          0000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        ParentShowHint = False
        ShowHint = True
        OnClick = btn_mlineClick
      end
      object lb_calign: TLabel
        Left = 8
        Top = 74
        Width = 61
        Height = 14
        Caption = 'Caption align'
      end
      object cb_mline: TCheckBox
        Left = 8
        Top = 16
        Width = 97
        Height = 17
        Caption = 'Multi Line'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 0
        OnClick = cb_mlineClick
      end
      object edit_caption: TEdit
        Left = 8
        Top = 38
        Width = 249
        Height = 22
        Ctl3D = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        Text = 'Link'
      end
      object dp_calign: TComboBox
        Left = 80
        Top = 72
        Width = 65
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 2
        TabOrder = 2
        Text = 'Bottom'
        Items.Strings = (
          'Top'
          'Right'
          'Bottom'
          'Left'
          'Center')
      end
    end
    object GroupBox11: TGroupBox
      Left = 8
      Top = 184
      Width = 297
      Height = 65
      Caption = 'Icon'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object Label2: TLabel
        Left = 60
        Top = 16
        Width = 41
        Height = 14
        Caption = 'Location'
      end
      object btn_selecticon: TSpeedButton
        Left = 232
        Top = 32
        Width = 57
        Height = 22
        Caption = 'Select'
        Flat = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Glyph.Data = {
          76010000424D760100000000000036000000280000000A0000000A0000000100
          18000000000040010000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FF000000000000000000FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FF000000000000000000000000FF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FF000000000000000000000000FF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FF000000000000000000FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000}
        ParentFont = False
        OnClick = btn_selecticonClick
      end
      object edit_icon: TEdit
        Left = 56
        Top = 32
        Width = 169
        Height = 22
        ReadOnly = True
        TabOrder = 0
      end
      object img_icon: TImage32
        Left = 8
        Top = 16
        Width = 41
        Height = 41
        Bitmap.ResamplerClassName = 'TNearestResampler'
        BitmapAlign = baCenter
        Scale = 1.000000000000000000
        ScaleMode = smNormal
        TabOrder = 1
      end
    end
  end
end
