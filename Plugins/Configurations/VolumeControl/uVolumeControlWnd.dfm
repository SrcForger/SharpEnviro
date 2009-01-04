object frmVolumeControl: TfrmVolumeControl
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmVolumeControl'
  ClientHeight = 204
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
    Height = 204
    ActivePage = JvSettingsPage
    PropagateEnable = False
    Align = alClient
    ExplicitHeight = 465
    object JvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 204
      ExplicitHeight = 465
      object lblMixerNote: TLabel
        AlignWithMargins = True
        Left = 18
        Top = 45
        Width = 402
        Height = 36
        Margins.Left = 18
        Margins.Top = 4
        Margins.Right = 8
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
      end
      object pnlSize: TPanel
        AlignWithMargins = True
        Left = 10
        Top = 162
        Width = 408
        Height = 31
        Margins.Left = 10
        Margins.Right = 10
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        ExplicitLeft = 0
        ExplicitTop = 136
        ExplicitWidth = 428
        object sgb_width: TSharpeGaugeBox
          Left = 18
          Top = 3
          Width = 120
          Height = 21
          ParentBackground = False
          Min = 25
          Max = 200
          Value = 75
          Prefix = 'Width: '
          Suffix = 'px'
          Description = 'Adjust Volume Bar Width'
          PopPosition = ppRight
          PercentDisplay = False
          OnChangeValue = sgb_widthChangeValue
          BackgroundColor = clWindow
        end
      end
      object pnlMixer: TPanel
        AlignWithMargins = True
        Left = 10
        Top = 84
        Width = 408
        Height = 31
        Margins.Left = 10
        Margins.Right = 10
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 1
        ExplicitLeft = 3
        ExplicitWidth = 422
        object cb_mlist: TComboBox
          Left = 18
          Top = 3
          Width = 167
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cb_mlistChange
        end
      end
      object schMixer: TSharpECenterHeader
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 408
        Height = 35
        Margins.Left = 10
        Margins.Right = 10
        Title = 'Mixer'
        Description = 'Select the sound mixer which you want to control.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitLeft = 96
        ExplicitTop = -7
        ExplicitWidth = 185
      end
      object schSize: TSharpECenterHeader
        AlignWithMargins = True
        Left = 10
        Top = 121
        Width = 408
        Height = 35
        Margins.Left = 10
        Margins.Right = 10
        Title = 'Size'
        Description = 'Change how big the volume control will appear on the SharpBar.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitLeft = 80
        ExplicitTop = 97
        ExplicitWidth = 185
      end
    end
  end
end
