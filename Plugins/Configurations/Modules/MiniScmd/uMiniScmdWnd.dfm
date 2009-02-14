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
      object pnlSize: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 121
        Width = 425
        Height = 21
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        ExplicitLeft = 3
        ExplicitTop = 165
        ExplicitWidth = 429
        object sgb_width: TSharpeGaugeBox
          Left = 0
          Top = 0
          Width = 200
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
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgb_widthChangeValue
          BackgroundColor = clWindow
        end
      end
      object scmQuickSelect: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 425
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Quick Select Options'
        Description = 
          'Configure whether or not you want a quick select button displaye' +
          'd.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitLeft = 3
        ExplicitTop = 3
        ExplicitWidth = 429
      end
      object scmSize: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 74
        Width = 425
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Command Box Size'
        Description = 'Configure how wide you want the command box to be.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitLeft = 3
        ExplicitTop = 126
        ExplicitWidth = 429
      end
      object cbQuickSelect: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 47
        Width = 425
        Height = 17
        Hint = 
          'Enable this option to display a button next to the command box w' +
          'hich will open a target selection dialog when clicked. (When the' +
          ' button is right clicked the selected target will be copied into' +
          ' the command box)'
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Display '#39'Quick Select'#39' Button'
        TabOrder = 3
        Checked = True
        State = cbChecked
        Align = alTop
        ParentShowHint = False
        ShowHint = True
        OnClick = cbQuickSelectClick
        ExplicitLeft = 20
        ExplicitTop = 46
        ExplicitWidth = 405
      end
    end
  end
end
