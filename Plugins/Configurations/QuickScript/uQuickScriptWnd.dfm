object frmQuickScript: TfrmQuickScript
  Left = 0
  Top = 0
  Caption = 'frmQuickScript'
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
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 427
      Height = 400
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
        Height = 33
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Select how you want to display the button for opening the Notes ' +
          'window in the SharpBar. You can have it display as icon, text or' +
          ' both icon and text.'
        Transparent = False
        WordWrap = True
        ExplicitLeft = 34
        ExplicitTop = 143
      end
      object rb_icon: TRadioButton
        AlignWithMargins = True
        Left = 24
        Top = 95
        Width = 395
        Height = 17
        Margins.Left = 24
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        Caption = 'Icon'
        TabOrder = 0
        OnClick = rb_textClick
        ExplicitTop = 87
      end
      object rb_text: TRadioButton
        AlignWithMargins = True
        Left = 24
        Top = 120
        Width = 395
        Height = 17
        Margins.Left = 24
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        Caption = 'Text'
        TabOrder = 1
        OnClick = rb_textClick
        ExplicitTop = 112
      end
      object rb_icontext: TRadioButton
        AlignWithMargins = True
        Left = 24
        Top = 70
        Width = 395
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
        ExplicitTop = 62
      end
    end
  end
end
