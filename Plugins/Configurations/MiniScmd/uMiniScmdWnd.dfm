object frmMiniScmd: TfrmMiniScmd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmMiniScmd'
  ClientHeight = 197
  ClientWidth = 435
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
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 435
    Height = 197
    ActivePage = pagMiniScmd
    PropagateEnable = False
    Align = alClient
    object pagMiniScmd: TJvStandardPage
      Left = 0
      Top = 0
      Width = 435
      Height = 197
      object lblQuickSelect: TLabel
        AlignWithMargins = True
        Left = 20
        Top = 72
        Width = 405
        Height = 49
        Margins.Left = 20
        Margins.Top = 8
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enable this option to display a button next to the command box w' +
          'hich will open a target selection dialog when clicked. (When the' +
          ' button is right clicked the selected target will be copied into' +
          ' the command box)'
        Transparent = False
        WordWrap = True
        ExplicitLeft = 48
        ExplicitTop = 73
        ExplicitWidth = 379
      end
      object pnlSize: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 165
        Width = 429
        Height = 21
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        ExplicitTop = 166
        object sgb_width: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 24
          Top = 0
          Width = 144
          Height = 21
          Margins.Left = 24
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alLeft
          ParentBackground = False
          Min = 25
          Max = 250
          Value = 100
          Prefix = 'Width: '
          Suffix = 'px'
          Description = 'Change the Command Box Width'
          PopPosition = ppRight
          PercentDisplay = False
          OnChangeValue = sgb_widthChangeValue
          BackgroundColor = clWindow
        end
      end
      object scmQuickSelect: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 429
        Height = 35
        Title = 'Quick Select Options'
        Description = 
          'Configure whether or not you want a quick select button displaye' +
          'd.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
      end
      object scmSize: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 124
        Width = 429
        Height = 35
        Title = 'Command Box Size'
        Description = 'Configure how wide you want the command box to be.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitTop = 125
      end
      object cbQuickSelect: TJvXPCheckbox
        AlignWithMargins = True
        Left = 20
        Top = 44
        Width = 405
        Height = 17
        Margins.Left = 20
        Margins.Right = 10
        Caption = 'Display '#39'Quick Select'#39' Button'
        TabOrder = 3
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = cbQuickSelectClick
        ExplicitLeft = -3
        ExplicitTop = 45
        ExplicitWidth = 435
      end
    end
  end
end
