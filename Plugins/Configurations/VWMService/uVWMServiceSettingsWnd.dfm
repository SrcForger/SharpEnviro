object frmVWMSettings: TfrmVWMSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmVWMSettings'
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
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 428
        Height = 81
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        object Label4: TLabel
          AlignWithMargins = True
          Left = 18
          Top = 4
          Width = 402
          Height = 45
          Margins.Left = 18
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 
            'Select how many virtual monitors you want to use. The Maximum am' +
            'ount of virtual monitors is limited to 12 (while the minimum is ' +
            '2). Disable the VWM.service if you don'#39't want to use virtual mon' +
            'itors.'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          WordWrap = True
        end
        object sgb_vwmcount: TSharpeGaugeBox
          Left = 18
          Top = 52
          Width = 120
          Height = 21
          ParentBackground = False
          Min = 2
          Max = 12
          Value = 4
          Prefix = 'VWMs: '
          Description = 'VWM Count'
          PopPosition = ppRight
          PercentDisplay = False
          OnChangeValue = sgb_vwmcountChangeValue
        end
      end
    end
  end
end
