object frmWeatherOptions: TfrmWeatherOptions
  Left = 397
  Top = 461
  BorderStyle = bsToolWindow
  Caption = 'Weather Service Options'
  ClientHeight = 228
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    289
    228)
  PixelsPerInch = 96
  TextHeight = 14
  object btnCancel: TButton
    Left = 206
    Top = 193
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 126
    Top = 193
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 64
    Width = 273
    Height = 121
    Caption = 'Interval Configuration'
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 72
      Width = 103
      Height = 14
      Caption = 'Check Interval (secs)'
    end
    object Label3: TLabel
      Left = 144
      Top = 24
      Width = 76
      Height = 14
      Caption = 'Forecast (mins)'
    end
    object Label4: TLabel
      Left = 8
      Top = 24
      Width = 104
      Height = 14
      Caption = 'Cur. Conditons (mins)'
    end
    object edtCheck: TJvSpinEdit
      Left = 8
      Top = 88
      Width = 121
      Height = 22
      ButtonKind = bkClassic
      MaxValue = 999.000000000000000000
      MinValue = 30.000000000000000000
      Value = 30.000000000000000000
      TabOrder = 0
    end
    object edtForecast: TJvSpinEdit
      Left = 144
      Top = 40
      Width = 121
      Height = 22
      ButtonKind = bkClassic
      MaxValue = 999.000000000000000000
      MinValue = 120.000000000000000000
      Value = 120.000000000000000000
      TabOrder = 1
    end
    object edtCurConditions: TJvSpinEdit
      Left = 8
      Top = 40
      Width = 121
      Height = 22
      ButtonKind = bkClassic
      MaxValue = 999.000000000000000000
      MinValue = 30.000000000000000000
      Value = 30.000000000000000000
      TabOrder = 2
    end
  end
  object rgUnits: TRadioGroup
    Left = 8
    Top = 8
    Width = 273
    Height = 49
    Caption = 'Temperature Measurement'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Metric Units'
      'Imperial Units')
    TabOrder = 3
  end
end
