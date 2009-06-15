object frmVolumeControl: TfrmVolumeControl
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmVolumeControl'
  ClientHeight = 306
  ClientWidth = 428
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object JvPageList1: TJvPageList
    Left = 0
    Top = 0
    Width = 428
    Height = 306
    ActivePage = JvSettingsPage
    PropagateEnable = False
    Align = alClient
    ExplicitHeight = 204
    object JvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 306
      ExplicitHeight = 204
      object lblMixerNote: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 42
        Width = 418
        Height = 36
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Note that some mixers won'#39't work and for some there might be dou' +
          'bled entries in the list. You will just have to try and test to ' +
          'find the one you need.'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
        ExplicitLeft = 18
        ExplicitTop = 45
        ExplicitWidth = 402
      end
      object pnlSize: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 166
        Width = 418
        Height = 31
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        object sgb_width: TSharpeGaugeBox
          Left = 0
          Top = 3
          Width = 200
          Height = 21
          ParentBackground = False
          Min = 25
          Max = 200
          Value = 50
          Prefix = 'Width: '
          Suffix = 'px'
          Description = 'Adjust Volume Bar Width'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgb_widthChangeValue
          BackgroundColor = clWindow
        end
      end
      object pnlMixer: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 78
        Width = 418
        Height = 31
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 1
        object cb_mlist: TComboBox
          Left = 0
          Top = 3
          Width = 200
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cb_mlistChange
        end
      end
      object schMixer: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 418
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 5
        Title = 'Mixer'
        Description = 'Select the sound mixer which you want to control.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
      end
      object schSize: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 119
        Width = 418
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Size'
        Description = 'Change how big the volume control will appear on the SharpBar.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
      end
      object pnButtonPos: TPanel
        Left = 0
        Top = 244
        Width = 428
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 4
        object Label1: TLabel
          Left = 8
          Top = 10
          Width = 106
          Height = 13
          Margins.Top = 10
          AutoSize = False
          Caption = 'Button Position'
          Color = clWindow
          ParentColor = False
          WordWrap = True
        end
        object cboButtonPos: TComboBox
          Left = 93
          Top = 7
          Width = 85
          Height = 21
          Style = csDropDownList
          Ctl3D = True
          ItemHeight = 13
          ItemIndex = 0
          ParentCtl3D = False
          TabOrder = 0
          Text = 'Left'
          OnChange = cboButtonPosChange
          Items.Strings = (
            'Left'
            'Right')
        end
      end
      object scmQuickSelect: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 205
        Width = 418
        Height = 37
        Margins.Left = 5
        Margins.Top = 8
        Margins.Right = 5
        Margins.Bottom = 2
        Title = 'Mute Button Options'
        Description = 'Configure the position of the mute button.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitTop = 271
      end
    end
  end
end
