object frmMiniScmd: TfrmMiniScmd
  Left = 0
  Top = 0
  Caption = 'frmMiniScmd'
  ClientHeight = 400
  ClientWidth = 427
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
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 427
    Height = 400
    ActivePage = pagMiniScmd
    PropagateEnable = False
    Align = alClient
    object pagMiniScmd: TJvStandardPage
      Left = 0
      Top = 0
      Width = 427
      Height = 400
      object Label5: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 32
        Width = 393
        Height = 49
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
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
      end
      object Label3: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 89
        Width = 411
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        Caption = 'Command Box Size'
        ExplicitWidth = 90
      end
      object cb_quickselect: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 411
        Height = 16
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Display '#39'Quick Select'#39' Button'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cb_quickselectClick
      end
      object Panel1: TPanel
        Left = 0
        Top = 110
        Width = 427
        Height = 21
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
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
          Min = 25
          Max = 250
          Value = 100
          Prefix = 'Width: '
          Suffix = 'px'
          Description = 'Change the Command Box Width'
          PopPosition = ppRight
          PercentDisplay = False
          OnChangeValue = sgb_widthChangeValue
        end
      end
    end
  end
end
