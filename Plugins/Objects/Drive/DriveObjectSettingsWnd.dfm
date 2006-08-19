object SettingsWnd: TSettingsWnd
  Tag = 1
  Left = 456
  Top = 206
  BorderStyle = bsNone
  Caption = 'SettingsWnd'
  ClientHeight = 327
  ClientWidth = 322
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
    Height = 329
    BevelOuter = bvNone
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 321
      Height = 329
      ActivePage = tab_general
      MultiLine = True
      TabOrder = 0
      object tab_general: TTabSheet
        Caption = 'General'
        object Label1: TLabel
          Left = 10
          Top = 12
          Width = 25
          Height = 14
          Caption = 'Drive'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object GroupBox10: TGroupBox
          Left = 8
          Top = 72
          Width = 297
          Height = 105
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
            Top = 24
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
          object cb_Meter: TCheckBox
            Left = 16
            Top = 48
            Width = 97
            Height = 17
            Caption = 'Display Meter'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            State = cbChecked
            TabOrder = 1
            OnClick = cb_MeterClick
          end
          object cb_diskdata: TCheckBox
            Left = 16
            Top = 72
            Width = 105
            Height = 17
            Caption = 'Display Disk Data'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            State = cbChecked
            TabOrder = 2
            OnClick = cb_MeterClick
          end
        end
        object Panel3: TPanel
          Left = 8
          Top = 256
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
        object DriveBox: TComboBox
          Left = 8
          Top = 29
          Width = 289
          Height = 22
          BevelInner = bvNone
          BevelOuter = bvRaised
          Style = csDropDownList
          Ctl3D = False
          DropDownCount = 10
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Caption'
        ImageIndex = 6
        object Panel4: TPanel
          Left = 8
          Top = 256
          Width = 297
          Height = 20
          BevelOuter = bvLowered
          TabOrder = 0
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
        object GroupBox17: TGroupBox
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
          TabOrder = 1
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
        object GroupBox18: TGroupBox
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
          TabOrder = 2
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
        object GroupBox19: TGroupBox
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
          TabOrder = 3
          object btn_mline: TSpeedButton
            Left = 264
            Top = 38
            Width = 23
            Height = 22
            Hint = 'multi line caption'
            Enabled = False
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
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
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
            Text = 'Drive'
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
            Color = 11842740
            ColorCode = -4
            CustomScheme = False
            ClickedColorID = ccWorkAreaBack
          end
        end
        object GroupBox7: TGroupBox
          Left = 8
          Top = 8
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
          Top = 256
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
        object GroupBox9: TGroupBox
          Left = 8
          Top = 80
          Width = 297
          Height = 49
          Caption = 'Size'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
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
        object GroupBox11: TGroupBox
          Left = 8
          Top = 8
          Width = 297
          Height = 65
          Caption = 'Icon'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
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
        object GroupBox13: TGroupBox
          Left = 8
          Top = 136
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
          Top = 8
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
          Top = 50
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
              object Label21: TLabel
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
                Color = 11842740
                ColorCode = -4
                CustomScheme = False
                ClickedColorID = ccWorkAreaBack
                OnColorClick = scb_bgblendingColorClick
              end
              object cb_bgblending: TCheckBox
                Left = 216
                Top = 16
                Width = 81
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
                Position = 196
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
                Position = 1
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
                Checked = True
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                State = cbChecked
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
                Color = 5921370
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
                Color = 11842740
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
      object tab_meter: TTabSheet
        Caption = 'Meter'
        ImageIndex = 4
        OnShow = tab_meterShow
        object GroupBox8: TGroupBox
          Left = 8
          Top = 56
          Width = 297
          Height = 81
          Caption = 'Colors'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object Label5: TLabel
            Left = 46
            Top = 25
            Width = 41
            Height = 14
            Caption = 'BG Start'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Label6: TLabel
            Left = 149
            Top = 25
            Width = 40
            Height = 14
            Caption = 'FG Start'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Label8: TLabel
            Left = 253
            Top = 25
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
          object Label13: TLabel
            Left = 46
            Top = 49
            Width = 36
            Height = 14
            Caption = 'BG End'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Label14: TLabel
            Left = 149
            Top = 49
            Width = 35
            Height = 14
            Caption = 'FG End'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object scb_bgstart: TSharpEColorBox
            Left = 8
            Top = 25
            Width = 35
            Height = 14
            Cursor = 15
            BackgroundColor = clBtnFace
            Color = 11842740
            ColorCode = -4
            CustomScheme = False
            ClickedColorID = ccWorkAreaBack
            OnColorClick = scb_bgstartColorClick
          end
          object scb_fgstart: TSharpEColorBox
            Left = 112
            Top = 25
            Width = 35
            Height = 14
            Cursor = 15
            BackgroundColor = clBtnFace
            Color = 5717811
            ColorCode = -3
            CustomScheme = False
            ClickedColorID = ccThrobberLight
            OnColorClick = scb_fgstartColorClick
          end
          object scb_border: TSharpEColorBox
            Left = 216
            Top = 25
            Width = 35
            Height = 14
            Cursor = 15
            BackgroundColor = clBtnFace
            Color = clBlack
            ColorCode = 0
            CustomScheme = False
            ClickedColorID = ccCustom
            OnColorClick = scb_borderColorClick
          end
          object scb_bgend: TSharpEColorBox
            Left = 8
            Top = 49
            Width = 35
            Height = 14
            Cursor = 15
            BackgroundColor = clBtnFace
            Color = 13553358
            ColorCode = -6
            CustomScheme = False
            ClickedColorID = ccWorkAreaLight
            OnColorClick = scb_bgendColorClick
          end
          object scb_fgend: TSharpEColorBox
            Left = 112
            Top = 49
            Width = 35
            Height = 14
            Cursor = 15
            BackgroundColor = clBtnFace
            Color = 7496528
            ColorCode = -1
            CustomScheme = False
            ClickedColorID = ccThrobberBack
            OnColorClick = scb_fgendColorClick
          end
        end
        object rg_meteralign: TRadioGroup
          Left = 8
          Top = 8
          Width = 297
          Height = 41
          Caption = 'Align'
          Columns = 4
          ItemIndex = 0
          Items.Strings = (
            'Top'
            'Left'
            'Bottom'
            'Right')
          TabOrder = 1
          OnClick = rg_meteralignClick
        end
        object GroupBox12: TGroupBox
          Left = 8
          Top = 144
          Width = 297
          Height = 129
          Caption = 'Size'
          TabOrder = 2
          object Label9: TLabel
            Left = 8
            Top = 22
            Width = 22
            Height = 14
            Caption = 'Left:'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label10: TLabel
            Left = 8
            Top = 46
            Width = 21
            Height = 14
            Caption = 'Top:'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label11: TLabel
            Left = 8
            Top = 70
            Width = 27
            Height = 14
            Caption = 'Right:'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label12: TLabel
            Left = 8
            Top = 94
            Width = 36
            Height = 14
            Caption = 'Bottom:'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object lb_meterleft: TLabel
            Left = 180
            Top = 22
            Width = 6
            Height = 14
            Caption = '0'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object lb_metertop: TLabel
            Left = 180
            Top = 46
            Width = 6
            Height = 14
            Caption = '0'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object lb_meterright: TLabel
            Left = 180
            Top = 70
            Width = 6
            Height = 14
            Caption = '0'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object lb_meterbottom: TLabel
            Left = 180
            Top = 94
            Width = 6
            Height = 14
            Caption = '0'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object tb_leftoffset: TTrackBar
            Left = 56
            Top = 20
            Width = 121
            Height = 25
            Max = 20
            Min = -20
            Frequency = 255
            TabOrder = 0
            ThumbLength = 15
            OnChange = tb_leftoffsetChange
          end
          object tb_topoffset: TTrackBar
            Left = 56
            Top = 44
            Width = 121
            Height = 25
            Max = 20
            Min = -20
            Frequency = 255
            TabOrder = 1
            ThumbLength = 15
            OnChange = tb_topoffsetChange
          end
          object tb_rightoffset: TTrackBar
            Left = 56
            Top = 68
            Width = 121
            Height = 25
            Max = 20
            Min = -20
            Frequency = 255
            TabOrder = 2
            ThumbLength = 15
            OnChange = tb_rightoffsetChange
          end
          object tb_bottomoffset: TTrackBar
            Left = 56
            Top = 92
            Width = 121
            Height = 25
            Max = 20
            Min = -20
            Frequency = 255
            TabOrder = 3
            ThumbLength = 15
            OnChange = tb_bottomoffsetChange
          end
          object meterpreview: TImage32
            Left = 200
            Top = 24
            Width = 89
            Height = 89
            Bitmap.ResamplerClassName = 'TNearestResampler'
            BitmapAlign = baTopLeft
            Color = clBtnFace
            ParentColor = False
            Scale = 1.000000000000000000
            ScaleMode = smNormal
            TabOrder = 4
          end
        end
      end
      object tab_driveltter: TTabSheet
        Caption = 'Drive Letter'
        ImageIndex = 5
        OnShow = tab_driveltterShow
        object GroupBox14: TGroupBox
          Left = 8
          Top = 184
          Width = 297
          Height = 65
          Caption = 'Colors'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object Label15: TLabel
            Left = 44
            Top = 17
            Width = 67
            Height = 14
            Caption = 'Gradient Start'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Label16: TLabel
            Left = 44
            Top = 41
            Width = 62
            Height = 14
            Caption = 'Gradient End'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Label19: TLabel
            Left = 188
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
          object scb_lgstart: TSharpEColorBox
            Left = 8
            Top = 17
            Width = 35
            Height = 14
            Cursor = 15
            BackgroundColor = clBtnFace
            Color = 13553358
            ColorCode = -6
            CustomScheme = False
            ClickedColorID = ccWorkAreaLight
            OnColorClick = scb_lgstartColorClick
          end
          object scb_lgend: TSharpEColorBox
            Left = 8
            Top = 41
            Width = 35
            Height = 14
            Cursor = 15
            BackgroundColor = clBtnFace
            Color = 5921370
            ColorCode = -5
            CustomScheme = False
            ClickedColorID = ccWorkAreaDark
            OnColorClick = scb_lgendColorClick
          end
          object scb_lgborder: TSharpEColorBox
            Left = 152
            Top = 17
            Width = 35
            Height = 14
            Cursor = 15
            BackgroundColor = clBtnFace
            Color = clBlack
            ColorCode = 0
            CustomScheme = False
            ClickedColorID = ccCustom
            OnColorClick = scb_lgborderColorClick
          end
        end
        object GroupBox15: TGroupBox
          Left = 8
          Top = 8
          Width = 297
          Height = 41
          TabOrder = 1
          object cb_driveletter: TCheckBox
            Left = 8
            Top = 14
            Width = 113
            Height = 17
            Caption = 'Display Drive Letter'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            State = cbChecked
            TabOrder = 0
            OnClick = cb_driveletterClick
          end
        end
        object GroupBox16: TGroupBox
          Left = 8
          Top = 56
          Width = 297
          Height = 121
          Caption = 'Settings'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object Label17: TLabel
            Left = 12
            Top = 80
            Width = 30
            Height = 14
            Caption = 'Font : '
          end
          object Label18: TLabel
            Left = 54
            Top = 100
            Width = 80
            Height = 14
            Caption = '(click to change)'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label20: TLabel
            Left = 174
            Top = 75
            Width = 49
            Height = 14
            Caption = 'Preview : '
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Shape1: TShape
            Left = 231
            Top = 71
            Width = 42
            Height = 42
          end
          object cb_dltrans: TCheckBox
            Left = 10
            Top = 20
            Width = 145
            Height = 17
            Caption = 'Visbility: 0%'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = cb_dltransClick
          end
          object tb_dltrans: TTrackBar
            Left = 4
            Top = 40
            Width = 289
            Height = 25
            Max = 255
            Min = 12
            Frequency = 255
            Position = 196
            TabOrder = 1
            ThumbLength = 15
            OnChange = tb_dltransChange
          end
          object btn_font: TBitBtn
            Left = 56
            Top = 72
            Width = 75
            Height = 25
            Caption = 'Example'
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = btn_fontClick
          end
          object prev1: TImage32
            Left = 232
            Top = 72
            Width = 40
            Height = 40
            Bitmap.ResamplerClassName = 'TNearestResampler'
            BitmapAlign = baTopLeft
            Scale = 1.000000000000000000
            ScaleMode = smNormal
            TabOrder = 3
          end
        end
      end
    end
  end
  object OpenIconDialog: TOpenDialog
    Filter = 'Icons|*.ico;*.png;'
    Title = 'Select Icon'
    Left = 192
    Top = 56
  end
  object SelectColorDialog: TColorDialog
    Options = [cdAnyColor]
    Left = 160
    Top = 48
  end
  object ColorPopup: TPopupMenu
    OwnerDraw = True
    Left = 288
    Top = 56
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
    Left = 128
    Top = 56
  end
  object IconPopup: TPopupMenu
    AutoPopup = False
    Images = IconList
    Left = 256
    Top = 56
  end
  object OpenFileDialog: TOpenDialog
    Filter = 'Any File|*.*'
    Title = 'Select Icon'
    Left = 224
    Top = 56
  end
  object PopupMenu1: TPopupMenu
    Left = 288
    Top = 88
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
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 256
    Top = 80
  end
end
