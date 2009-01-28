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
    object JvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 204
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
        ExplicitLeft = 10
        ExplicitTop = 162
        ExplicitWidth = 408
        object sgb_width: TSharpeGaugeBox
          Left = 0
          Top = 3
          Width = 200
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
        ExplicitLeft = 10
        ExplicitTop = 84
        ExplicitWidth = 408
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
        ExplicitLeft = 10
        ExplicitTop = 3
        ExplicitWidth = 408
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
        ExplicitLeft = 10
        ExplicitTop = 123
        ExplicitWidth = 408
      end
    end
  end
end
