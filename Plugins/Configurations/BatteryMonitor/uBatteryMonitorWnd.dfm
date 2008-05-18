object frmBMon: TfrmBMon
  Left = 0
  Top = 0
  Caption = 'frmBMon'
  ClientHeight = 93
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
    Height = 93
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 427
      Height = 93
      object Label3: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 411
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Display Options'
        ExplicitWidth = 74
      end
      object Label1: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 393
        Height = 13
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Select the checkbox if you want to display the power status icon' +
          '.'
        Transparent = False
        WordWrap = True
        ExplicitWidth = 309
      end
      object cb_icon: TCheckBox
        AlignWithMargins = True
        Left = 24
        Top = 50
        Width = 395
        Height = 17
        Margins.Left = 24
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        Caption = 'Display Icon'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cb_iconClick
      end
    end
  end
end
