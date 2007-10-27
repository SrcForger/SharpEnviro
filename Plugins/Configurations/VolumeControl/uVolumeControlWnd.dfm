object frmVolumeControl: TfrmVolumeControl
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmVolumeControl'
  ClientHeight = 465
  ClientWidth = 428
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object JvPageList1: TJvPageList
    Left = 0
    Top = 0
    Width = 428
    Height = 465
    ActivePage = JvSettingsPage
    PropagateEnable = False
    Align = alClient
    object JvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 465
      object Label1: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 4
        Width = 412
        Height = 13
        Margins.Left = 8
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Select Mixer'
        Transparent = False
        WordWrap = True
        ExplicitLeft = 18
        ExplicitWidth = 56
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 101
        Width = 412
        Height = 13
        Margins.Left = 8
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Bar Size'
        Transparent = False
        WordWrap = True
        ExplicitLeft = 18
        ExplicitTop = 122
      end
      object Label3: TLabel
        AlignWithMargins = True
        Left = 18
        Top = 118
        Width = 402
        Height = 18
        Margins.Left = 18
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Change how big the volume control bar should be.'
        Transparent = False
        WordWrap = True
        ExplicitTop = 119
      end
      object Label4: TLabel
        AlignWithMargins = True
        Left = 18
        Top = 21
        Width = 402
        Height = 45
        Margins.Left = 18
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Select the sound mixer which you want to control. Note that some' +
          ' mixers won'#39't work and for some there might be doubled entries i' +
          'n the list. You will just have to try and test to find the one y' +
          'ou need.'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
        ExplicitTop = 70
      end
      object Panel1: TPanel
        Left = 0
        Top = 136
        Width = 428
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
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
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 66
        Width = 428
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 1
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
    end
  end
end
