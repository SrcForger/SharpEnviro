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
    object pagKLayout: TJvStandardPage
      Left = 0
      Top = 0
      Width = 435
      Height = 191
      object schDisplayOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 425
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Icon Options'
        Description = 'Enable to display an icon in the selection button'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
      end
      object chkIcon: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 47
        Width = 425
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Display Icon'
        TabOrder = 1
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = cbIconClick
      end
      object chkTLC: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 121
        Width = 420
        Height = 17
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Caption = 'Three Letter Code'
        TabOrder = 2
        Align = alTop
        OnClick = cbIconClick
        ExplicitTop = 96
      end
      object SharpECenterHeader1: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 74
        Width = 425
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Text Options'
        Description = 
          'Enable to display a three letter keyboard layout incode instead ' +
          'of the default two letter code.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitTop = 123
      end
    end
  end
end
