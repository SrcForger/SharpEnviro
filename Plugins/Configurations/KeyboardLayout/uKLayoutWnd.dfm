object frmKLayout: TfrmKLayout
  Left = 0
  Top = 0
  Caption = 'frmKLayout'
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
    ActivePage = pagKLayout
    PropagateEnable = False
    Align = alClient
    object pagKLayout: TJvStandardPage
      Left = 0
      Top = 0
      Width = 427
      Height = 400
      ExplicitTop = -3
      object Label5: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 32
        Width = 393
        Height = 17
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Enable to display an icon in the selection button'
        Transparent = False
        WordWrap = True
      end
      object Label1: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 81
        Width = 393
        Height = 32
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enable to display a three letter keyboard layout incode instead ' +
          'of the default two letter code.'
        Transparent = False
        WordWrap = True
      end
      object cbIcon: TCheckBox
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
        Caption = 'Display Icon'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cbIconClick
      end
      object cbTLC: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 57
        Width = 411
        Height = 16
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Three Letter Code'
        TabOrder = 1
        OnClick = cbIconClick
        ExplicitLeft = 16
        ExplicitTop = 104
      end
    end
  end
end
