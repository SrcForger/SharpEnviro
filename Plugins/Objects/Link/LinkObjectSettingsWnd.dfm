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
      ActivePage = tab_general
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
        object Panel3: TPanel
          Left = 8
          Top = 232
          Width = 297
          Height = 20
          BevelOuter = bvLowered
          TabOrder = 1
          object cb_themesettingsA: TCheckBox
            Left = 16
            Top = 1
            Width = 193
            Height = 17
            Caption = 'Use Theme Settings'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            State = cbChecked
            TabOrder = 0
            OnClick = cb_themesettingsAClick
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
          TabOrder = 2
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
            PopupMenu = targetpopup
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
            Flat = False
            FontBackground = sefbChecker
            ShadowEnabled = True
            AlphaEnabled = True
            BoldEnabled = True
            ItalicEnabled = True
            UnderlineEnabled = True
            CustomScheme = False
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
        object Panel4: TPanel
          Left = 8
          Top = 232
          Width = 297
          Height = 20
          BevelOuter = bvLowered
          TabOrder = 3
          object cb_themesettingsC: TCheckBox
            Left = 16
            Top = 1
            Width = 193
            Height = 17
            Caption = 'Use Theme Settings'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            State = cbChecked
            TabOrder = 0
            OnClick = cb_themesettingsAClick
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
            Color = 9145227
            ColorCode = -4
            CustomScheme = False
            ClickedColorID = ccWorkAreaBack
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
        object Panel2: TPanel
          Left = 8
          Top = 232
          Width = 297
          Height = 20
          BevelOuter = bvLowered
          TabOrder = 2
          object cb_themesettingsB: TCheckBox
            Left = 16
            Top = 1
            Width = 193
            Height = 17
            Caption = 'Use Theme Settings'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            State = cbChecked
            TabOrder = 0
            OnClick = cb_themesettingsAClick
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
            Enabled = False
            TabOrder = 0
          end
          object Icon: TImage32
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
      object tab_background: TTabSheet
        Caption = 'Background'
        ImageIndex = 3
        OnShow = tab_backgroundShow
        object GroupBox1: TGroupBox
          Left = 8
          Top = 0
          Width = 297
          Height = 41
          Caption = 'Type'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object rb_bg1: TRadioButton
            Left = 8
            Top = 16
            Width = 97
            Height = 17
            Caption = 'None'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            TabStop = True
            OnClick = rb_bg1Click
          end
          object rb_bg2: TRadioButton
            Left = 104
            Top = 16
            Width = 105
            Height = 17
            Caption = 'Themed'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = rb_bg2Click
          end
          object rb_bg3: TRadioButton
            Left = 208
            Top = 16
            Width = 73
            Height = 17
            Caption = 'Skinned'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = rb_bg3Click
          end
        end
        object pc_bg: TPageControl
          Left = 4
          Top = 42
          Width = 305
          Height = 207
          ActivePage = ts_bgskin
          MultiLine = True
          Style = tsFlatButtons
          TabOrder = 1
          object ts_bgskin: TTabSheet
            Caption = 'ts_bgskin'
            TabVisible = False
            object GroupBox3: TGroupBox
              Left = 0
              Top = 80
              Width = 297
              Height = 105
              Caption = 'Skins'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              object Label5: TLabel
                Left = 252
                Top = 40
                Width = 25
                Height = 14
                Caption = 'Color'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                Transparent = True
              end
              object bglist: TImgView32
                Left = 12
                Top = 16
                Width = 197
                Height = 81
                Bitmap.ResamplerClassName = 'TNearestResampler'
                Centered = False
                Scale = 1.000000000000000000
                ScrollBars.ShowHandleGrip = True
                ScrollBars.Style = rbsMac
                SizeGrip = sgNone
                OverSize = 1
                TabOrder = 0
                OnClick = bglistClick
              end
              object scb_bgblending: TSharpEColorBox
                Left = 216
                Top = 41
                Width = 35
                Height = 14
                Cursor = 15
                BackgroundColor = clBtnFace
                Color = 9145227
                ColorCode = -4
                CustomScheme = False
                ClickedColorID = ccWorkAreaBack
                OnColorClick = scb_bgblendingColorClick
              end
              object cb_bgblending: TCheckBox
                Left = 216
                Top = 16
                Width = 73
                Height = 17
                Caption = 'Blending'
                TabOrder = 2
                OnClick = cb_bgblendingClick
              end
            end
            object GroupBox2: TGroupBox
              Left = 0
              Top = 0
              Width = 297
              Height = 73
              Caption = 'Border'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              object cb_bgtransB: TCheckBox
                Left = 10
                Top = 20
                Width = 145
                Height = 17
                Caption = 'Visibility: 0%'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
                OnClick = cb_bgtransBClick
              end
              object tb_bgtransB: TTrackBar
                Left = 4
                Top = 40
                Width = 289
                Height = 25
                Max = 255
                Min = 12
                Frequency = 255
                Position = 12
                TabOrder = 1
                ThumbLength = 15
                OnChange = tb_bgtransBChange
              end
            end
          end
          object ts_themed: TTabSheet
            Caption = 'ts_themed'
            ImageIndex = 1
            TabVisible = False
            object GroupBox4: TGroupBox
              Left = 0
              Top = 0
              Width = 297
              Height = 121
              Caption = 'Settings'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              object cb_bgtransA: TCheckBox
                Left = 10
                Top = 20
                Width = 145
                Height = 17
                Caption = 'Visibility: 0%'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
                OnClick = cb_bgtransAClick
              end
              object tb_bgtransA: TTrackBar
                Left = 4
                Top = 40
                Width = 289
                Height = 25
                Max = 255
                Min = 12
                Frequency = 255
                Position = 12
                TabOrder = 1
                ThumbLength = 15
                OnChange = tb_bgtransAChange
              end
              object tb_bgthickness: TTrackBar
                Left = 4
                Top = 88
                Width = 289
                Height = 25
                Ctl3D = True
                Max = 5
                ParentCtl3D = False
                Frequency = 255
                Position = 5
                TabOrder = 2
                ThumbLength = 15
                OnChange = tb_bgthicknessChange
              end
              object cb_bgthickness: TCheckBox
                Left = 10
                Top = 68
                Width = 145
                Height = 17
                Caption = 'Border Thickness: 1'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                TabOrder = 3
                OnClick = cb_bgthicknessClick
              end
            end
            object GroupBox5: TGroupBox
              Left = 0
              Top = 128
              Width = 297
              Height = 41
              Caption = 'Colors'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              object lb_bgcolor: TLabel
                Left = 44
                Top = 17
                Width = 58
                Height = 14
                Caption = 'Background'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                Transparent = True
              end
              object lb_bgbordercolor: TLabel
                Left = 164
                Top = 17
                Width = 33
                Height = 14
                Caption = 'Border'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                Transparent = True
              end
              object cp_bgborder: TSharpEColorBox
                Left = 128
                Top = 17
                Width = 35
                Height = 14
                Cursor = 15
                BackgroundColor = clBtnFace
                Color = 4539717
                ColorCode = -5
                CustomScheme = False
                ClickedColorID = ccWorkAreaDark
              end
              object cp_bgcolor: TSharpEColorBox
                Left = 8
                Top = 17
                Width = 35
                Height = 14
                Cursor = 15
                BackgroundColor = clBtnFace
                Color = 9145227
                ColorCode = -4
                CustomScheme = False
                ClickedColorID = ccWorkAreaBack
              end
            end
          end
          object ts_bgnone: TTabSheet
            Caption = 'ts_bgnone'
            ImageIndex = 2
            TabVisible = False
            object Label7: TLabel
              Left = 4
              Top = 0
              Width = 87
              Height = 14
              Caption = 'No Config Options'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
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
  object IconPopup: TPopupMenu
    AutoPopup = False
    Images = IconList
    Left = 256
    Top = 24
  end
  object OpenFileDialog: TOpenDialog
    Filter = 'Any File|*.*'
    Title = 'Select Icon'
    Left = 224
    Top = 24
  end
  object targetpopup: TPopupMenu
    AutoHotkeys = maManual
    Images = popupiconlist
    Left = 280
    Top = 64
    object File1: TMenuItem
      Caption = 'File'
      ImageIndex = 0
      OnClick = File1Click
    end
    object Folder1: TMenuItem
      Caption = 'Folder'
      ImageIndex = 1
      OnClick = Folder1Click
    end
    object S1: TMenuItem
      Caption = 'Shell folder'
      ImageIndex = 2
      object shellAdministrativeTools1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Administrative Tools'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellAppData1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:AppData'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellCommonAdministrativeTools1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Common Administrative Tools'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellCommonAppData1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Common AppData'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellCommonDesktop1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Common Desktop'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellCommonDocuments1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Common Documents'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellCommonFavorites1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Common Favorites'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellCommonMenu1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Common Menu'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellCommonProgramFiles1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:CommonProgramFiles'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellCommonPrograms1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Common Programs'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellCommonStartup1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Common Startup'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellCommonTemplates1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Common Templates'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellConnectionsFolder1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:ConnectionsFolder'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellControlPanelFolder1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:ControlPanelFolder'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellCookies1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Cookies'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellDesktop1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Desktop'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellDriveFolder1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:DriveFolder'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellFavorites1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Favorites'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellFonts1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Fonts'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellHistory1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:History'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellInternetFolder1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:InternetFolder'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellLocalAppData1: TMenuItem
        AutoHotkeys = maManual
        Break = mbBarBreak
        Caption = 'shell:Local AppData'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellMenu1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Menu'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellMyMusic1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:My Music'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellMyPictures2: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:My Pictures'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellNetHood1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:NetHood'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellNetworkFolder1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:NetworkFolder'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellRecent1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Recent'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellPersonal1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Personal'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellPrintHood1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:PrintHood'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellProfile1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Profile'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellProgramFiles1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:ProgramFiles'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellPrograms1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Programs'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellPrintersFolder1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:PrintersFolder'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellRecycleBinFolder1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:RecycleBinFolder'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellSendTo1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:SendTo'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellStartup1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Startup'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellSystemX861: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:SystemX86'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellSystem1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:System'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellTemplates1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Templates'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
      object shellWindows1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'shell:Windows'
        ImageIndex = 3
        OnClick = shellAdministrativeTools1Click
      end
    end
  end
  object popupiconlist: TImageList
    Left = 288
    Bitmap = {
      494C010104000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B5848400B584
      8400B5848400B5848400B5848400B5848400B5848400B5848400B5848400B584
      8400B5848400B5848400B5848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6A59C00FFEF
      D600F7E7C600F7DEBD00F7DEB500F7D6AD00F7D6A500EFCE9C00EFCE9400EFCE
      9400EFCE9400F7D69C00B5848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6A59C00FFEF
      D600F7E7CE00F7DEC600F7DEBD00F7D6B500F7D6A500EFCE9C00EFCE9C00EFCE
      9400EFCE9400EFCE9C00B5848400000000000000000029ADD60031B5DE0021AD
      D600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6ADA500FFEF
      E700F7E7D600F7E7CE00F7DEC600F7DEBD00F7D6B500F7D6AD00EFCE9C00EFCE
      9C00EFCE9400EFCE9C00B5848400000000000000000029ADD6009CDEEF0084EF
      FF004AC6E70021ADD60018A5C60018A5C60018A5C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6ADA500FFF7
      E700F7E7D600F7E7CE00F7E7C600F7DEC600F7DEB500F7D6B500F7D6AD00EFCE
      9C00EFCE9C00EFCE9400B5848400000000000000000029ADD60052BDE7009CFF
      FF0094FFFF0073DEF70073DEF70073DEF70073DEF7004AC6E70021ADD60018A5
      C600000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A4866900694827006948270069482700694827006948
      2700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CEB5AD00FFFF
      F700FFEFE700F7E7D600F7E7D600F7E7CE00F7DEC600F7DEBD00F7D6B500F7D6
      AD00EFCE9C00EFCE9C00B5848400000000000000000029ADD60052BDE700ADFF
      FF008CF7FF008CEFFF008CEFFF008CEFFF0073DEF70073DEF70073DEF7004AC6
      EF0021ADD6000000000000000000000000000000000000000000000000000000
      00000000000000000000A4866900845F3C00845F3C00845F3C00845F3C006948
      2700000000000000000000000000000000000000000000000000000000000000
      000000000000A486690069482700694827006948270069482700694827000000
      0000000000000000000000000000000000000000000000000000D6B5AD00FFFF
      FF00FFF7EF00FFEFE700F7E7D600F7E7CE00F7E7C600F7DEC600F7DEBD00F7D6
      AD00F7D6A500F7D6A500B5848400000000000000000029ADD60029ADD600ADDE
      EF0094F7FF0094F7FF008CEFFF008CEFFF008CEFFF008CEFFF0073DEF70073DE
      F7004AC6EF000000000000000000000000000000000000000000000000000000
      0000A486690069482700A4866900845F3C00845F3C00845F3C00845F3C006948
      2700000000000000000000000000000000000000000000000000000000000000
      000000000000A4866900845F3C00845F3C00845F3C00845F3C00694827000000
      0000000000000000000000000000000000000000000000000000D6BDB500FFFF
      FF00FFF7F700FFF7EF00FFEFDE00F7E7D600F7E7CE00F7E7C600F7DEC600F7DE
      BD00F7D6B500F7D6AD00B5848400000000000000000029ADD60073DEF70029AD
      D6009CFFFF008CF7FF008CF7FF008CF7FF008CEFFF008CEFFF008CEFFF0073DE
      F70073DEF70018A5C60000000000000000000000000000000000000000000000
      0000A486690069482700A4866900845F3C00845F3C00845F3C00845F3C006948
      2700000000000000000000000000000000000000000000000000000000000000
      000000000000A4866900845F3C00845F3C00845F3C00845F3C00694827000000
      0000000000000000000000000000000000000000000000000000D6BDB500FFFF
      FF00FFFFFF00FFF7F700FFF7EF00FFEFE700F7E7D600F7E7CE00F7DEC600F7DE
      BD00F7DEB500F7DEB500B5848400000000000000000029ADD60094F7FF0029AD
      D600ADDEEF00A5EFF700A5EFF700A5F7FF008CEFFF008CEFFF008CEFFF0073DE
      F70073DEF70039BDE70000000000000000000000000000000000A48669006948
      2700A486690069482700A4866900845F3C00845F3C00845F3C00845F3C006948
      2700000000000000000000000000000000000000000000000000000000000000
      000000000000A4866900845F3C00845F3C00845F3C00845F3C00694827000000
      0000000000000000000000000000000000000000000000000000DEBDB500FFFF
      FF00FFFFFF00FFFFFF00FFF7F700FFEFE700FFEFDE00F7E7D600F7E7CE00F7DE
      C600F7DEC600F7D6B500B5848400000000000000000029ADD6009CFFFF0073DE
      F70029ADD60018A5C60018A5C60018A5C600ADDEEF008CF7FF0084EFFF0084EF
      FF0073DEF70073DEF70018A5C600000000000000000000000000A48669006948
      2700A486690069482700A4866900A4866900A4866900A4866900A48669006948
      2700000000000000000000000000000000000000000000000000000000000000
      000000000000A4866900845F3C00845F3C00845F3C00845F3C00694827000000
      0000000000000000000000000000000000000000000000000000DEC6B500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFF7F700FFEFE700FFEFDE00FFEFDE00FFEF
      D600E7DEC600C6BDAD00B5848400000000000000000029ADD6009CFFFF0094F7
      FF0073DEF70073DEF70073DEF7006BDEF70029ADD600ADDEEF0084EFFF0084EF
      FF0084EFFF0094EFFF0031A5D600000000000000000000000000A48669006948
      2700A48669006948270069482700694827006948270069482700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A4866900A4866900A4866900A4866900A4866900694827000000
      0000000000000000000000000000000000000000000000000000E7C6B500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7EF00FFF7EF00F7E7D600C6A5
      9400B5948C00B58C8400B5848400000000000000000029ADD6009CFFFF0094F7
      FF0094F7FF0094F7FF0094F7FF0073DEF70073DEF70029ADD60018A5C60029A5
      D60029A5D60029A5D60018A5C600000000000000000000000000A48669006948
      2700A4866900A4866900A4866900A4866900A486690069482700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7C6B500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700E7CECE00BD8C
      7300EFB57300EFA54A00C6846B00000000000000000029ADD600C6FFFF0094FF
      FF009CFFFF00D6FFFF00D6FFFF008CEFFF0094EFFF0073DEF70073DEF70018AD
      DE00000000000000000000000000000000000000000000000000A48669006948
      2700694827006948270069482700694827000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFCEBD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E7D6CE00C694
      7B00FFC67300CE94730000000000000000000000000021ADD6009CDEEF00C6FF
      FF00C6FFFF009CDEEF0018ADD60018A5C60018A5C60018A5C60018A5C60018A5
      CE00000000000000000000000000000000000000000000000000A4866900A486
      6900A4866900A4866900A4866900694827000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7C6B500FFF7
      F700FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00E7CECE00C694
      7B00CE9C8400000000000000000000000000000000000000000031B5DE0029AD
      D60018A5C60018A5C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7C6B500EFCE
      B500EFCEB500EFCEB500EFCEB500E7C6B500E7C6B500EFCEB500D6BDB500BD84
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000C001FFFFFFFFFFFFC001FFFFFFFFFFFF
      C0018FFFFFFFFFFFC001807FF807FFFFC001800FF807F00FC0018007E007F00F
      C0018007E007F00FC00180038007F00FC00180038007F00FC00180018007F00F
      C00180018007F00FC0018001801FF00FC001800F801FFFFFC003800F807FFFFF
      C007C3FF807FFFFFC00FFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupMenu1: TPopupMenu
    Left = 248
    Top = 64
    object SharpEIcon1: TMenuItem
      Caption = 'SharpE Icon'
      OnClick = SharpEIcon1Click
    end
    object CustomIcon1: TMenuItem
      Caption = 'Custom Icon'
      OnClick = CustomIcon1Click
    end
    object ShellIcon1: TMenuItem
      Caption = 'Shell Icon'
      OnClick = ShellIcon1Click
    end
  end
end
