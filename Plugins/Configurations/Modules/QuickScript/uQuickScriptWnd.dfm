object frmQuickScript: TfrmQuickScript
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmQuickScript'
  ClientHeight = 161
  ClientWidth = 449
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
    Width = 449
    Height = 161
    ActivePage = pagQuickScript
    PropagateEnable = False
    Align = alClient
    ExplicitWidth = 427
    ExplicitHeight = 400
    object pagQuickScript: TJvStandardPage
      Left = 0
      Top = 0
      Width = 449
      Height = 161
      ExplicitWidth = 435
      ExplicitHeight = 427
      object rb_icon: TRadioButton
        AlignWithMargins = True
        Left = 24
        Top = 74
        Width = 417
        Height = 17
        Margins.Left = 24
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        Caption = 'Icon'
        TabOrder = 0
        OnClick = rb_textClick
        ExplicitTop = 95
        ExplicitWidth = 395
      end
      object rb_text: TRadioButton
        AlignWithMargins = True
        Left = 24
        Top = 99
        Width = 417
        Height = 17
        Margins.Left = 24
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        Caption = 'Text'
        TabOrder = 1
        OnClick = rb_textClick
        ExplicitTop = 120
        ExplicitWidth = 395
      end
      object rb_icontext: TRadioButton
        AlignWithMargins = True
        Left = 24
        Top = 49
        Width = 417
        Height = 17
        Margins.Left = 24
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        Caption = 'Icon and Text'
        Checked = True
        TabOrder = 2
        TabStop = True
        OnClick = rb_textClick
        ExplicitTop = 70
        ExplicitWidth = 395
      end
      object schDisplayOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 443
        Height = 35
        Title = 'Display Options'
        Description = 
          'Select how the button for opening the Quick Script window will d' +
          'isplay on the SharpBar.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitLeft = 96
        ExplicitTop = 18
        ExplicitWidth = 185
      end
    end
  end
end
