object frmKLayout: TfrmKLayout
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmKLayout'
  ClientHeight = 191
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
    Height = 191
    ActivePage = pagKLayout
    PropagateEnable = False
    Align = alClient
    ExplicitWidth = 427
    ExplicitHeight = 400
    object pagKLayout: TJvStandardPage
      Left = 0
      Top = 0
      Width = 435
      Height = 191
      ExplicitWidth = 427
      ExplicitHeight = 400
      object lblIcon: TLabel
        AlignWithMargins = True
        Left = 40
        Top = 72
        Width = 385
        Height = 17
        Margins.Left = 40
        Margins.Top = 8
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Enable to display an icon in the selection button'
        Transparent = False
        WordWrap = True
        ExplicitLeft = 26
        ExplicitTop = 32
        ExplicitWidth = 393
      end
      object lblTLC: TLabel
        AlignWithMargins = True
        Left = 40
        Top = 120
        Width = 385
        Height = 32
        Margins.Left = 40
        Margins.Top = 8
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enable to display a three letter keyboard layout incode instead ' +
          'of the default two letter code.'
        Transparent = False
        WordWrap = True
        ExplicitLeft = 26
        ExplicitTop = 81
        ExplicitWidth = 393
      end
      object schDisplayOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 429
        Height = 35
        Title = 'Display Options'
        Description = 
          'Configure how you would like the keyboard layout module to displ' +
          'ay information.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
      end
      object chkIcon: TJvXPCheckbox
        AlignWithMargins = True
        Left = 20
        Top = 44
        Width = 405
        Height = 17
        Margins.Left = 20
        Margins.Right = 10
        Caption = 'Display Icon'
        TabOrder = 1
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = cbIconClick
        ExplicitLeft = 120
        ExplicitTop = 49
        ExplicitWidth = 161
      end
      object chkTLC: TJvXPCheckbox
        AlignWithMargins = True
        Left = 20
        Top = 92
        Width = 405
        Height = 17
        Margins.Left = 20
        Margins.Right = 10
        Caption = 'Three Letter Code'
        TabOrder = 2
        Align = alTop
        OnClick = cbIconClick
        ExplicitLeft = 168
        ExplicitTop = 120
        ExplicitWidth = 161
      end
    end
  end
end
