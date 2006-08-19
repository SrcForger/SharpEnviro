object SettingsWnd: TSettingsWnd
  Tag = 1
  Left = 404
  Top = 176
  BorderStyle = bsNone
  Caption = 'SettingsWnd'
  ClientHeight = 329
  ClientWidth = 321
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
    Height = 345
    BevelOuter = bvNone
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 321
      Height = 329
      ActivePage = tab_general
      TabOrder = 0
      object tab_general: TTabSheet
        Caption = 'General'
        object GroupBox10: TGroupBox
          Left = 8
          Top = 224
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
          object cb_shadow: TCheckBox
            Left = 8
            Top = 16
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
        end
        object Panel3: TPanel
          Left = 8
          Top = 272
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
        object GroupBox8: TGroupBox
          Left = 8
          Top = 8
          Width = 297
          Height = 209
          Caption = 'Text'
          TabOrder = 2
          object Label1: TLabel
            Left = 8
            Top = 160
            Width = 281
            Height = 41
            AutoSize = False
            Caption = 
              'The text renderer supports the usage of the following simple htm' +
              'l tags : <b></b>,<i></i>,<u></u>,                  <font name=" ' +
              '"  color=" " size = " "></font>'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
            WordWrap = True
          end
          object text: TMemo
            Left = 8
            Top = 16
            Width = 281
            Height = 137
            Lines.Strings = (
              '<font size="16">Text.object</font>')
            ScrollBars = ssBoth
            TabOrder = 0
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
          Top = 272
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
              object cb_bgblending: TCheckBox
                Left = 216
                Top = 16
                Width = 81
                Height = 17
                Caption = 'Blending'
                TabOrder = 1
                OnClick = cb_bgblendingClick
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
                Caption = 'Transparency: 0%'
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
                Caption = 'Transparency: 0%'
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
    Left = 160
    Top = 24
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
    Left = 128
    Top = 24
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
    Images = popupiconlist
    Left = 288
    Top = 88
    object File1: TMenuItem
      Caption = 'File'
      ImageIndex = 0
    end
    object Folder1: TMenuItem
      Caption = 'Folder'
      ImageIndex = 1
    end
  end
  object popupiconlist: TImageList
    Left = 96
    Top = 24
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CEB5AD00FFFF
      F700FFEFE700F7E7D600F7E7D600F7E7CE00F7DEC600F7DEBD00F7D6B500F7D6
      AD00EFCE9C00EFCE9C00B5848400000000000000000029ADD60052BDE700ADFF
      FF008CF7FF008CEFFF008CEFFF008CEFFF0073DEF70073DEF70073DEF7004AC6
      EF0021ADD6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6B5AD00FFFF
      FF00FFF7EF00FFEFE700F7E7D600F7E7CE00F7E7C600F7DEC600F7DEBD00F7D6
      AD00F7D6A500F7D6A500B5848400000000000000000029ADD60029ADD600ADDE
      EF0094F7FF0094F7FF008CEFFF008CEFFF008CEFFF008CEFFF0073DEF70073DE
      F7004AC6EF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6BDB500FFFF
      FF00FFF7F700FFF7EF00FFEFDE00F7E7D600F7E7CE00F7E7C600F7DEC600F7DE
      BD00F7D6B500F7D6AD00B5848400000000000000000029ADD60073DEF70029AD
      D6009CFFFF008CF7FF008CF7FF008CF7FF008CEFFF008CEFFF008CEFFF0073DE
      F70073DEF70018A5C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6BDB500FFFF
      FF00FFFFFF00FFF7F700FFF7EF00FFEFE700F7E7D600F7E7CE00F7DEC600F7DE
      BD00F7DEB500F7DEB500B5848400000000000000000029ADD60094F7FF0029AD
      D600ADDEEF00A5EFF700A5EFF700A5F7FF008CEFFF008CEFFF008CEFFF0073DE
      F70073DEF70039BDE70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DEBDB500FFFF
      FF00FFFFFF00FFFFFF00FFF7F700FFEFE700FFEFDE00F7E7D600F7E7CE00F7DE
      C600F7DEC600F7D6B500B5848400000000000000000029ADD6009CFFFF0073DE
      F70029ADD60018A5C60018A5C60018A5C600ADDEEF008CF7FF0084EFFF0084EF
      FF0073DEF70073DEF70018A5C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DEC6B500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFF7F700FFEFE700FFEFDE00FFEFDE00FFEF
      D600E7DEC600C6BDAD00B5848400000000000000000029ADD6009CFFFF0094F7
      FF0073DEF70073DEF70073DEF7006BDEF70029ADD600ADDEEF0084EFFF0084EF
      FF0084EFFF0094EFFF0031A5D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7C6B500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7EF00FFF7EF00F7E7D600C6A5
      9400B5948C00B58C8400B5848400000000000000000029ADD6009CFFFF0094F7
      FF0094F7FF0094F7FF0094F7FF0073DEF70073DEF70029ADD60018A5C60029A5
      D60029A5D60029A5D60018A5C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7C6B500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700E7CECE00BD8C
      7300EFB57300EFA54A00C6846B00000000000000000029ADD600C6FFFF0094FF
      FF009CFFFF00D6FFFF00D6FFFF008CEFFF0094EFFF0073DEF70073DEF70018AD
      DE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFCEBD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E7D6CE00C694
      7B00FFC67300CE94730000000000000000000000000021ADD6009CDEEF00C6FF
      FF00C6FFFF009CDEEF0018ADD60018A5C60018A5C60018A5C60018A5C60018A5
      CE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00C001FFFF00000000C001FFFF00000000
      C0018FFF00000000C001807F00000000C001800F00000000C001800700000000
      C001800700000000C001800300000000C001800300000000C001800100000000
      C001800100000000C001800100000000C001800F00000000C003800F00000000
      C007C3FF00000000C00FFFFF0000000000000000000000000000000000000000
      000000000000}
  end
  object PopupMenu1: TPopupMenu
    Left = 264
    Top = 96
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
