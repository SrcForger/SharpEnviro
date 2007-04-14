object SettingsWnd: TSettingsWnd
  Tag = 1
  Left = 433
  Top = 165
  BorderStyle = bsNone
  Caption = 'SettingsWnd'
  ClientHeight = 282
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 321
    Height = 297
    BevelOuter = bvNone
    TabOrder = 0
    object pagecontrol1: TPageControl
      Left = 0
      Top = 0
      Width = 321
      Height = 289
      ActivePage = TabSheet1
      TabOrder = 0
      object tab_general: TTabSheet
        Caption = 'General'
        object GroupBox10: TGroupBox
          Left = 8
          Top = 64
          Width = 297
          Height = 41
          Caption = 'Object Settings'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object cb_iconshadow: TCheckBox
            Left = 16
            Top = 16
            Width = 97
            Height = 17
            Caption = 'Icon Shadows'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            State = cbChecked
            TabOrder = 0
          end
        end
        object GroupBox15: TGroupBox
          Left = 8
          Top = 0
          Width = 297
          Height = 57
          Caption = 'Target'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
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
      end
      object tab_caption: TTabSheet
        Caption = 'Caption'
        ImageIndex = 4
        object GroupBox8: TGroupBox
          Left = 8
          Top = 48
          Width = 297
          Height = 73
          Caption = 'Caption'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
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
        end
        object GroupBox12: TGroupBox
          Left = 8
          Top = 128
          Width = 297
          Height = 97
          Caption = 'Font/Align'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object lb_calign: TLabel
            Left = 144
            Top = 26
            Width = 61
            Height = 14
            Caption = 'Caption align'
          end
          object cb_shadow: TCheckBox
            Left = 8
            Top = 24
            Width = 97
            Height = 17
            Caption = 'Text Shadow'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            State = cbChecked
            TabOrder = 0
          end
          object cb_cfont: TCheckBox
            Left = 8
            Top = 48
            Width = 113
            Height = 17
            Caption = 'Use Custom Font'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = cb_cfontClick
          end
          object customfont: TSharpEFontSelector
            Left = 8
            Top = 66
            Width = 145
            Height = 21
            FontBackground = sefbChecker
            ShadowEnabled = True
            AlphaEnabled = True
            BoldEnabled = True
            ItalicEnabled = True
            UnderlineEnabled = True
            Enabled = False
          end
          object dp_calign: TComboBox
            Left = 216
            Top = 24
            Width = 65
            Height = 22
            Style = csDropDownList
            ItemHeight = 14
            ItemIndex = 2
            TabOrder = 3
            Text = 'Bottom'
            Items.Strings = (
              'Top'
              'Right'
              'Bottom'
              'Left'
              'Center')
          end
        end
        object GroupBox14: TGroupBox
          Left = 8
          Top = 0
          Width = 297
          Height = 41
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object cb_caption: TCheckBox
            Left = 8
            Top = 16
            Width = 97
            Height = 17
            Caption = 'Display Caption'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            State = cbChecked
            TabOrder = 0
            OnClick = cb_captionClick
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Effects'
        ImageIndex = 2
        object GroupBox6: TGroupBox
          Left = 8
          Top = 152
          Width = 297
          Height = 41
          Caption = 'Colors'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object Label4: TLabel
            Left = 44
            Top = 17
            Width = 41
            Height = 14
            Caption = 'Blending'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object cp_cblend: TSharpEColorBox
            Left = 8
            Top = 17
            Width = 35
            Height = 14
            Cursor = 15
            BackgroundColor = clBtnFace
            Color = -1
            ColorCode = -1
          end
        end
        object GroupBox7: TGroupBox
          Left = 8
          Top = 0
          Width = 297
          Height = 137
          Caption = 'Object Effects'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object cb_blend: TCheckBox
            Left = 10
            Top = 20
            Width = 191
            Height = 17
            Caption = 'Color Blend Icon: 0%'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = cb_blendClick
          end
          object tb_blend: TTrackBar
            Left = 4
            Top = 40
            Width = 285
            Height = 25
            Max = 255
            Frequency = 255
            TabOrder = 1
            ThumbLength = 15
            OnChange = tb_blendChange
          end
          object cb_AlphaBlend: TCheckBox
            Left = 10
            Top = 76
            Width = 129
            Height = 17
            Caption = 'Visibility: 0%'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = cb_AlphaBlendClick
          end
          object tb_alpha: TTrackBar
            Left = 4
            Top = 97
            Width = 281
            Height = 25
            Enabled = False
            Max = 255
            Min = 32
            Frequency = 255
            Position = 32
            TabOrder = 3
            ThumbLength = 15
            OnChange = tb_alphaChange
          end
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'Icon'
        ImageIndex = 1
        object GroupBox11: TGroupBox
          Left = 8
          Top = 0
          Width = 297
          Height = 65
          Caption = 'Icon'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
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
            PopupMenu = PopupMenu1
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
        object GroupBox9: TGroupBox
          Left = 8
          Top = 72
          Width = 297
          Height = 49
          Caption = 'Size'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object cb_32: TRadioButton
            Left = 8
            Top = 20
            Width = 57
            Height = 17
            Caption = '32 x 32'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = cb_32Click
          end
          object cb_48: TRadioButton
            Left = 80
            Top = 20
            Width = 57
            Height = 17
            Caption = '48 x 48'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = cb_32Click
          end
          object cb_64: TRadioButton
            Left = 152
            Top = 20
            Width = 73
            Height = 17
            Caption = '64 x 64'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = cb_32Click
          end
          object cb_csize: TRadioButton
            Left = 216
            Top = 20
            Width = 73
            Height = 17
            Caption = '         x ###'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = cb_csizeClick
          end
          object edit_csize: TEdit
            Left = 232
            Top = 18
            Width = 25
            Height = 22
            Ctl3D = True
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 3
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            Text = '128'
            OnKeyUp = edit_csizeKeyUp
          end
        end
        object GroupBox13: TGroupBox
          Left = 8
          Top = 124
          Width = 297
          Height = 121
          Caption = 'Position'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object cb_iconspacing: TCheckBox
            Left = 10
            Top = 68
            Width = 191
            Height = 17
            Caption = 'Icon <=> Caption spacing: '
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = cb_iconspacingClick
          end
          object tb_iconspacing: TTrackBar
            Left = 4
            Top = 88
            Width = 285
            Height = 25
            Max = 16
            Min = -16
            Frequency = 255
            TabOrder = 1
            ThumbLength = 15
            OnChange = tb_iconspacingChange
          end
          object tb_iconoffset: TTrackBar
            Left = 4
            Top = 40
            Width = 285
            Height = 25
            Max = 16
            Min = -16
            Frequency = 255
            TabOrder = 2
            ThumbLength = 15
            OnChange = tb_iconoffsetChange
          end
          object cb_iconoffset: TCheckBox
            Left = 10
            Top = 20
            Width = 191
            Height = 17
            Caption = 'Horizontal(x) offset: '
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = cb_iconoffsetClick
          end
        end
      end
    end
  end
  object OpenIconDialog: TOpenDialog
    Filter = 'Icons|*.ico;*.png;'
    Title = 'Select Icon'
    Left = 192
    Top = 24
  end
  object SelectColorDialog: TColorDialog
    Options = [cdAnyColor]
    Left = 224
  end
  object ColorPopup: TPopupMenu
    OwnerDraw = True
    Left = 288
    Top = 24
    object hrobberBack1: TMenuItem
      Caption = 'Throbber-Back'
      Hint = 'Throbber-Back'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object hrobberBottom1: TMenuItem
      Caption = 'Throbber-Bottom'
      Hint = 'Throbber-Bottom'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object hrobberTop1: TMenuItem
      Caption = 'Throbber-Top'
      Hint = 'Throbber-Top'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object WorkAreaBack1: TMenuItem
      Caption = 'WorkArea-Back'
      Hint = 'WorkArea-Back'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object WorkAreaBottom1: TMenuItem
      Caption = 'WorkArea-Bottom'
      Hint = 'WorkArea-Bottom'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object WorkAreaTop1: TMenuItem
      Caption = 'WorkArea-Top'
      Hint = 'WorkArea-Top'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object N1: TMenuItem
      Caption = '-'
      OnAdvancedDrawItem = N1AdvancedDrawItem
    end
    object Customcolor1: TMenuItem
      Caption = 'Custom color ...'
      Hint = 'Custom color ...'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object Pickcolor1: TMenuItem
      Caption = 'Pick color...'
      Visible = False
    end
  end
  object IconList: TImageList
    Height = 32
    Width = 32
    Left = 256
  end
  object OpenFileDialog: TOpenDialog
    Filter = 'Any File|*.*'
    Title = 'Select Icon'
    Left = 224
    Top = 24
  end
  object PopupMenu1: TPopupMenu
    Left = 176
    Top = 112
    object SharpEIcon1: TMenuItem
      Caption = 'SharpE Icon'
    end
    object CustomIcon1: TMenuItem
      Caption = 'Custom Icon'
    end
    object ShellIcon1: TMenuItem
      Caption = 'Shell Icon'
    end
  end
end
