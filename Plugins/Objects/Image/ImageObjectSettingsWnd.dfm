object SettingsWnd: TSettingsWnd
  Tag = 1
  Left = 423
  Top = 189
  BorderStyle = bsNone
  Caption = 'SettingsWnd'
  ClientHeight = 390
  ClientWidth = 376
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
    Width = 376
    Height = 390
    Align = alClient
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 8
      Top = 8
      Width = 361
      Height = 153
      Caption = 'Image'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 9
        Top = 16
        Width = 265
        Height = 25
        AutoSize = False
        Caption = 'Supported image types : *.bmp, *.ico, *.jpg, *.jpeg, *.png'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object lb_size: TLabel
        Left = 16
        Top = 104
        Width = 27
        Height = 14
        Caption = 'Size: '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label3: TLabel
        Left = 16
        Top = 38
        Width = 61
        Height = 14
        Caption = 'Icon Source:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Visible = False
      end
      object tb_size: TTrackBar
        Left = 8
        Top = 120
        Width = 345
        Height = 25
        Max = 400
        Min = 10
        Frequency = 400
        Position = 100
        TabOrder = 0
        ThumbLength = 15
        OnChange = tb_sizeChange
      end
      object rb_file: TRadioButton
        Left = 88
        Top = 38
        Width = 57
        Height = 17
        Caption = 'File'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = rb_fileClick
      end
      object rb_url: TRadioButton
        Left = 176
        Top = 38
        Width = 57
        Height = 17
        Caption = 'URL'
        TabOrder = 2
        OnClick = rb_urlClick
      end
      object pg_iconsource: TPageControl
        Left = 8
        Top = 56
        Width = 345
        Height = 49
        ActivePage = tab_url
        Style = tsButtons
        TabOrder = 3
        object tab_file: TTabSheet
          Caption = 'tab_file'
          TabVisible = False
          object lb_width: TLabel
            Left = 40
            Top = 22
            Width = 48
            Height = 14
            Caption = 'Width: n/a'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Label2: TLabel
            Left = 8
            Top = 2
            Width = 24
            Height = 14
            Caption = 'Path:'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object lb_height: TLabel
            Left = 144
            Top = 22
            Width = 51
            Height = 14
            Caption = 'Height: n/a'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Edit_IconPath: TEdit
            Left = 40
            Top = 0
            Width = 225
            Height = 22
            Ctl3D = True
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
          end
          object btn_loadIcon: TButton
            Left = 272
            Top = 0
            Width = 57
            Height = 22
            Caption = 'Select'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = btn_loadIconClick
          end
        end
        object tab_url: TTabSheet
          Caption = 'tab_url'
          ImageIndex = 1
          TabVisible = False
          object Label5: TLabel
            Left = 8
            Top = 2
            Width = 23
            Height = 14
            Caption = 'URL:'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Label6: TLabel
            Left = 242
            Top = 25
            Width = 95
            Height = 14
            Caption = 'refresh (in minutes)'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            WordWrap = True
          end
          object edit_url: TEdit
            Left = 40
            Top = 0
            Width = 161
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
          end
          object btn_testurl: TButton
            Left = 208
            Top = 0
            Width = 57
            Height = 22
            Caption = 'Test'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = btn_testurlClick
          end
          object ddb_refresh: TComboBox
            Left = 296
            Top = 0
            Width = 41
            Height = 22
            Style = csDropDownList
            ItemHeight = 14
            ItemIndex = 5
            TabOrder = 2
            Text = '30'
            Items.Strings = (
              '1'
              '2'
              '5'
              '10'
              '20'
              '30'
              '45'
              '60'
              '120')
          end
        end
      end
    end
    object GroupBox7: TGroupBox
      Left = 8
      Top = 168
      Width = 361
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
        Width = 341
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
        Width = 341
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
    object GroupBox6: TGroupBox
      Left = 8
      Top = 312
      Width = 361
      Height = 41
      Caption = 'Colors'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
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
    end
    object Panel3: TPanel
      Left = 8
      Top = 360
      Width = 361
      Height = 20
      BevelOuter = bvLowered
      TabOrder = 3
      object cb_themesettings: TCheckBox
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
        OnClick = cb_themesettingsClick
      end
    end
  end
  object OpenIconDialog: TOpenDialog
    Filter = 'Images|*.ico;*.bmp;*.jpeg;*.jpg;*.png'
    Title = 'Select Icon'
    Left = 392
    Top = 32
  end
  object ColorPopup: TPopupMenu
    OwnerDraw = True
    Left = 344
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
  object SelectColorDialog: TColorDialog
    Options = [cdAnyColor]
    Left = 320
  end
end
