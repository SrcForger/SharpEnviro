object frmConfig: TfrmConfig
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmConfig'
  ClientHeight = 442
  ClientWidth = 551
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object SharpECenterHeader1: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 0
    Width = 541
    Height = 42
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Settings'
    Description = 'Change how big the spacer is'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 52
    Width = 541
    Height = 25
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 0
    object Label1: TLabel
      Left = 0
      Top = 3
      Width = 23
      Height = 17
      Caption = 'Size'
    end
    object Panel1: TPanel
      Left = 90
      Top = 0
      Width = 183
      Height = 25
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        183
        25)
      object gbSize: TSharpeGaugeBox
        AlignWithMargins = True
        Left = 0
        Top = 1
        Width = 80
        Height = 24
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Anchors = [akLeft, akTop, akBottom]
        ParentBackground = False
        TabOrder = 0
        Min = 0
        Max = 100
        Value = 100
        Description = 'Size'
        PopPosition = ppBottom
        PercentDisplay = False
        MaxPercent = 100
        Formatting = '%d'
        OnChangeValue = gbSizeChangeValue
        BackgroundColor = clWindow
      end
      object cbSizePref: TComboBox
        Left = 86
        Top = 0
        Width = 97
        Height = 25
        AutoComplete = False
        Style = csDropDownList
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 17
        ItemIndex = 0
        TabOrder = 1
        Text = 'Pixels'
        OnChange = cbSizePrefChange
        Items.Strings = (
          'Pixels'
          'Percent')
      end
    end
  end
end
