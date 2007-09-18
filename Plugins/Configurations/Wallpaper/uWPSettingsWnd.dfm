object frmWPSettings: TfrmWPSettings
  Left = 0
  Top = 0
  Caption = 'frmWPSettings'
  ClientHeight = 615
  ClientWidth = 429
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblMonitor: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 413
    Height = 17
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 'Monitor'
    ExplicitLeft = -134
    ExplicitWidth = 579
  end
  object Label5: TLabel
    AlignWithMargins = True
    Left = 26
    Top = 29
    Width = 395
    Height = 15
    Margins.Left = 26
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 'Please select the monitor from the list below'
    EllipsisPosition = epEndEllipsis
    Transparent = False
    ExplicitTop = 20
    ExplicitWidth = 411
  end
  object Bevel1: TShape
    AlignWithMargins = True
    Left = 0
    Top = 83
    Width = 429
    Height = 1
    Margins.Left = 0
    Margins.Top = 8
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Pen.Color = clBtnFace
  end
  object spcOptions: TSharpEPageControl
    Left = 8
    Top = 320
    Width = 445
    Height = 400
    Visible = False
    ExpandedHeight = 200
    TabItems = <
      item
        Caption = 'Wallpaper'
        ImageIndex = 0
        Visible = True
      end
      item
        Caption = 'Color'
        ImageIndex = 0
        Visible = True
      end
      item
        Caption = 'Gradient'
        ImageIndex = 0
        Visible = True
      end>
    RoundValue = 10
    Border = True
    TabWidth = 80
    TabIndex = 0
    TabAlignment = taLeftJustify
    AutoSizeTabs = False
    TabBackgroundColor = clWindow
    BackgroundColor = clWindow
    BorderColor = clBtnFace
    TabColor = 15724527
    TabSelColor = clWhite
    TabCaptionSelColor = clBlack
    TabStatusSelColor = clGreen
    TabCaptionColor = clBlack
    TabStatusColor = clGreen
    DesignSize = (
      445
      400)
    object JvPageList1: TJvPageList
      AlignWithMargins = True
      Left = 3
      Top = 26
      Width = 439
      Height = 371
      Margins.Top = 26
      ActivePage = JvWPPage
      PropagateEnable = False
      Align = alClient
      Visible = False
      ParentBackground = True
      ExplicitHeight = 527
      object JvWPPage: TJvStandardPage
        Left = 0
        Top = 0
        Width = 439
        Height = 371
        Caption = 'JvWPPage'
        ExplicitHeight = 527
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 8
          Height = 371
          Align = alLeft
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          ExplicitTop = 217
          ExplicitHeight = 310
        end
        object Panel3: TPanel
          Left = 431
          Top = 0
          Width = 8
          Height = 371
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          ExplicitTop = 217
          ExplicitHeight = 310
        end
      end
      object JvCCPage: TJvStandardPage
        Left = 0
        Top = 0
        Width = 439
        Height = 371
        Caption = 'JvCCPage'
        ExplicitHeight = 527
        object pn_cchange: TPanel
          Left = 0
          Top = 0
          Width = 439
          Height = 193
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object cb_colorchange: TCheckBox
            Left = 8
            Top = 8
            Width = 97
            Height = 17
            Caption = 'Change Color'
            TabOrder = 0
            OnClick = cb_colorchangeClick
          end
          object sgb_cchue: TSharpeGaugeBox
            Left = 216
            Top = 40
            Width = 193
            Height = 21
            ParentBackground = False
            Min = -128
            Max = 128
            Value = 0
            Prefix = 'Hue: '
            Description = 'Adjust to set the Hue modification amount'
            PopPosition = ppBottom
            PercentDisplay = False
            OnChangeValue = sgb_cchueChangeValue
          end
          object sgb_ccsat: TSharpeGaugeBox
            Left = 216
            Top = 72
            Width = 193
            Height = 21
            ParentBackground = False
            Min = -255
            Max = 255
            Value = 0
            Prefix = 'Saturation: '
            Description = 'Adjust to set the Saturation modification amount'
            PopPosition = ppBottom
            PercentDisplay = False
            OnChangeValue = sgb_cchueChangeValue
          end
          object sgb_cclight: TSharpeGaugeBox
            Left = 216
            Top = 104
            Width = 193
            Height = 21
            ParentBackground = False
            Min = -255
            Max = 255
            Value = 0
            Prefix = 'Lightness: '
            Description = 'Adjust to set the lightness modification amount '
            PopPosition = ppBottom
            PercentDisplay = False
            OnChangeValue = sgb_cchueChangeValue
          end
          object ccimage: TImage32
            Left = 16
            Top = 36
            Width = 187
            Height = 144
            Bitmap.ResamplerClassName = 'TNearestResampler'
            BitmapAlign = baTopLeft
            Scale = 1.000000000000000000
            ScaleMode = smNormal
            TabOrder = 4
          end
        end
      end
      object JvGDPage: TJvStandardPage
        Left = 0
        Top = 0
        Width = 439
        Height = 371
        Caption = 'JvGDPage'
        ExplicitHeight = 527
        object pn_gradient: TPanel
          Left = 0
          Top = 0
          Width = 439
          Height = 145
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object Label2: TLabel
            Left = 233
            Top = 32
            Width = 28
            Height = 13
            Caption = 'Type:'
          end
          object cb_gradient: TCheckBox
            Left = 8
            Top = 8
            Width = 97
            Height = 17
            Caption = 'Gradient Effect'
            TabOrder = 0
            OnClick = cb_gradientClick
          end
          object sgb_gstartalpha: TSharpeGaugeBox
            Left = 232
            Top = 64
            Width = 193
            Height = 21
            ParentBackground = False
            Min = 0
            Max = 255
            Value = 0
            Prefix = 'Start Transparency: '
            Suffix = '%'
            Description = 'Adjust to set the Hue modification amount'
            PopPosition = ppBottom
            PercentDisplay = True
            OnChangeValue = sgb_gstartalphaChangeValue
          end
          object sgb_gendalpha: TSharpeGaugeBox
            Left = 232
            Top = 96
            Width = 193
            Height = 21
            ParentBackground = False
            Min = 0
            Max = 255
            Value = 255
            Prefix = 'End Transparency: '
            Suffix = '%'
            Description = 'Adjust to set the Saturation modification amount'
            PopPosition = ppBottom
            PercentDisplay = True
            OnChangeValue = sgb_gstartalphaChangeValue
          end
          object cb_gtype: TComboBox
            Left = 281
            Top = 32
            Width = 145
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 3
            OnChange = cb_gtypeChange
            Items.Strings = (
              'Horizontal'
              'Vertical'
              'Left/Right Horizontal'
              'Top/Bottom Vertical')
          end
          object pgradient: TImage32
            Left = 16
            Top = 36
            Width = 193
            Height = 88
            Bitmap.ResamplerClassName = 'TNearestResampler'
            BitmapAlign = baCenter
            Scale = 1.000000000000000000
            ScaleMode = smNormal
            TabOrder = 4
          end
        end
        object gdcolors: TSharpEColorEditorEx
          Left = 8
          Top = 145
          Width = 423
          Height = 226
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alClient
          AutoSize = True
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clWindow
          ParentColor = False
          TabOrder = 1
          Items = <
            item
              Title = 'Gradient Start'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 0
              Visible = True
              ColorEditor = gdcolors.Item0
              Tag = 0
            end
            item
              Title = 'Gradient End'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 0
              Visible = True
              ColorEditor = gdcolors.Item1
              Tag = 0
            end>
          SwatchManager = SharpESwatchManager1
          OnUiChange = wpcolorsUiChange
          ExplicitHeight = 382
        end
        object Panel4: TPanel
          Left = 431
          Top = 145
          Width = 8
          Height = 226
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          ExplicitHeight = 382
        end
        object Panel5: TPanel
          Left = 0
          Top = 145
          Width = 8
          Height = 226
          Align = alLeft
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 3
          ExplicitHeight = 382
        end
      end
    end
  end
  object pnlMonitor: TPanel
    AlignWithMargins = True
    Left = 28
    Top = 52
    Width = 393
    Height = 23
    Margins.Left = 28
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    ExplicitTop = 33
    ExplicitWidth = 409
    object cboMonitor: TComboBox
      Left = 0
      Top = 0
      Width = 250
      Height = 23
      Margins.Left = 28
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alLeft
      Style = csOwnerDrawVariable
      Constraints.MaxWidth = 250
      DropDownCount = 12
      ItemHeight = 17
      TabOrder = 0
    end
  end
  object JvPageList2: TJvPageList
    AlignWithMargins = True
    Left = 0
    Top = 84
    Width = 429
    Height = 500
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ActivePage = pagWallpaper
    PropagateEnable = False
    Align = alTop
    ExplicitTop = 75
    ExplicitWidth = 445
    object pagWallpaper: TJvStandardPage
      Left = 0
      Top = 0
      Width = 429
      Height = 500
      Caption = 'pagWallpaper'
      ExplicitTop = -5
      object lblWpFile: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 413
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Wallpaper Filename'
        ExplicitLeft = 12
        ExplicitTop = 12
        ExplicitWidth = 429
      end
      object lblWpFileDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 395
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Please select the wallpaper filename for this monitor'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        ExplicitLeft = 30
        ExplicitTop = 33
        ExplicitWidth = 411
      end
      object lblWpAlign: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 82
        Width = 413
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Wallpaper Alignment'
        ExplicitLeft = 36
        ExplicitTop = 124
        ExplicitWidth = 429
      end
      object lblWpAlignDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 103
        Width = 395
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Please select the wallpaper desired alignment '
        EllipsisPosition = epEndEllipsis
        Transparent = False
        ExplicitTop = 122
        ExplicitWidth = 411
      end
      object lblWpMirror: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 157
        Width = 413
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Wallpaper Mirror'
        ExplicitLeft = 13
        ExplicitTop = 201
        ExplicitWidth = 429
      end
      object lblWpMirrorDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 178
        Width = 395
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Please select the wallpaper mirror options '
        EllipsisPosition = epEndEllipsis
        Transparent = False
        ExplicitLeft = 31
        ExplicitTop = 197
        ExplicitWidth = 411
      end
      object lblWpTrans: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 232
        Width = 413
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Wallpaper Transparency'
        ExplicitLeft = 44
        ExplicitTop = 301
        ExplicitWidth = 429
      end
      object lblWpTransDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 253
        Width = 395
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Changing this value will make the wallpaper more or less transpa' +
          'rent'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        ExplicitLeft = 62
        ExplicitTop = 297
        ExplicitWidth = 411
      end
      object lblFontColor: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 306
        Width = 413
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Wallpaper Color Options'
        ExplicitLeft = -8
        ExplicitTop = 471
        ExplicitWidth = 562
      end
      object lblFontColorDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 327
        Width = 395
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Define wallpaper color options below.'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        ExplicitTop = 367
        ExplicitWidth = 494
      end
      object Panel6: TPanel
        AlignWithMargins = True
        Left = 28
        Top = 52
        Width = 393
        Height = 22
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 0
        ExplicitLeft = -114
        ExplicitTop = 127
        ExplicitWidth = 559
        object edtWpFile: TEdit
          Left = 0
          Top = 0
          Width = 315
          Height = 22
          Margins.Left = 28
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alClient
          TabOrder = 0
          Text = 'edtWpFile'
          OnChange = edtWallpaperChange
          ExplicitWidth = 331
          ExplicitHeight = 21
        end
        object btnWpBrowse: TButton
          AlignWithMargins = True
          Left = 318
          Top = 0
          Width = 75
          Height = 22
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alRight
          Caption = 'Browse'
          TabOrder = 1
          OnClick = btnWpBrowseClick
          ExplicitLeft = 334
        end
      end
      object Panel7: TPanel
        AlignWithMargins = True
        Left = 28
        Top = 126
        Width = 393
        Height = 23
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 1
        ExplicitLeft = 8
        ExplicitTop = 157
        ExplicitWidth = 409
        object rdoWpAlignStretch: TRadioButton
          Left = 138
          Top = 0
          Width = 69
          Height = 23
          Align = alLeft
          Caption = 'Stretch'
          TabOrder = 0
          ExplicitLeft = 0
        end
        object rdoWpAlignScale: TRadioButton
          Left = 69
          Top = 0
          Width = 69
          Height = 23
          Align = alLeft
          Caption = 'Scale'
          TabOrder = 1
          ExplicitLeft = 0
        end
        object rdoWpAlignCenter: TRadioButton
          Left = 0
          Top = 0
          Width = 69
          Height = 23
          Align = alLeft
          Caption = 'Center'
          Checked = True
          TabOrder = 2
          TabStop = True
        end
        object rdoWpAlignTile: TRadioButton
          Left = 207
          Top = 0
          Width = 69
          Height = 23
          Align = alLeft
          Caption = 'Tile'
          TabOrder = 3
          ExplicitLeft = 272
        end
      end
      object Panel8: TPanel
        AlignWithMargins = True
        Left = 28
        Top = 201
        Width = 393
        Height = 23
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 2
        ExplicitLeft = 19
        ExplicitTop = 226
        ExplicitWidth = 409
        object chkWpMirrorVert: TCheckBox
          Left = 81
          Top = 0
          Width = 97
          Height = 23
          Align = alLeft
          Caption = 'Vertical'
          TabOrder = 0
          ExplicitLeft = 84
          ExplicitTop = 12
          ExplicitHeight = 17
        end
        object chkWpMirrorHoriz: TCheckBox
          Left = 0
          Top = 0
          Width = 81
          Height = 23
          Align = alLeft
          Caption = 'Horizontal'
          TabOrder = 1
        end
      end
      object wpimage: TImage32
        Left = 309
        Top = 99
        Width = 128
        Height = 128
        Bitmap.ResamplerClassName = 'TNearestResampler'
        BitmapAlign = baTopLeft
        Scale = 1.000000000000000000
        ScaleMode = smNormal
        TabOrder = 3
        Visible = False
      end
      object Panel9: TPanel
        AlignWithMargins = True
        Left = 28
        Top = 276
        Width = 393
        Height = 22
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 4
        ExplicitLeft = 19
        ExplicitTop = 312
        ExplicitWidth = 409
        object sgbWpTrans: TSharpeGaugeBox
          Left = 0
          Top = 0
          Width = 250
          Height = 22
          Margins.Left = 28
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
          ParentBackground = False
          Min = -255
          Max = 255
          Value = 0
          Prefix = 'Transparency: '
          Suffix = '%'
          Description = 'Change font opacity'
          PopPosition = ppRight
          PercentDisplay = True
          ExplicitLeft = -2
          ExplicitTop = -9
        end
      end
      object wpcolors: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 20
        Top = 350
        Width = 401
        Height = 32
        Margins.Left = 20
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alTop
        AutoSize = True
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWindow
        ParentColor = False
        TabOrder = 5
        Items = <
          item
            Title = 'Background'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ValueEditorType = vetColor
            Value = 0
            Visible = True
            ColorEditor = wpcolors.Item0
            Tag = 0
          end>
        SwatchManager = SharpESwatchManager1
        OnUiChange = wpcolorsUiChange
        ExplicitWidth = 417
      end
    end
    object JvStandardPage2: TJvStandardPage
      Left = 0
      Top = 0
      Width = 429
      Height = 500
      Caption = 'JvStandardPage2'
      ExplicitWidth = 445
      ExplicitHeight = 200
    end
    object JvStandardPage3: TJvStandardPage
      Left = 0
      Top = 0
      Width = 429
      Height = 500
      Caption = 'JvStandardPage3'
      ExplicitWidth = 445
      ExplicitHeight = 200
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    Width = 391
    ShowCaptions = True
    SwatchHeight = 16
    SwatchWidth = 16
    SwatchSpacing = 4
    SwatchFont.Charset = DEFAULT_CHARSET
    SwatchFont.Color = clWindowText
    SwatchFont.Height = -11
    SwatchFont.Name = 'Tahoma'
    SwatchFont.Style = []
    SwatchTextBorderColor = 16709617
    SortMode = sortName
    Left = 380
    Top = 76
  end
  object dlgOpen: TOpenDialog
    Filter = 
      'All Image Files (*.jpg;*.jpeg;*.png;*.bmp)|*.jpg;*.jpeg;*.png;*.' +
      'bmp'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 412
    Top = 72
  end
end
