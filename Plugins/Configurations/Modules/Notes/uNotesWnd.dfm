object frmNotes: TfrmNotes
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmNotes'
  ClientHeight = 253
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
    Height = 253
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    ExplicitWidth = 427
    ExplicitHeight = 226
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 435
      Height = 253
      ExplicitWidth = 427
      ExplicitHeight = 226
      object lblAlwaysOnTop: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 72
        Width = 397
        Height = 33
        Margins.Left = 30
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enable this option to make the notes window stay always on top o' +
          'f all other windows'
        Transparent = False
        WordWrap = True
        ExplicitLeft = 26
        ExplicitTop = 32
        ExplicitWidth = 393
      end
      object rb_icon: TRadioButton
        AlignWithMargins = True
        Left = 24
        Top = 179
        Width = 403
        Height = 17
        Margins.Left = 24
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        Caption = 'Icon'
        TabOrder = 0
        OnClick = rb_textClick
        ExplicitTop = 160
        ExplicitWidth = 395
      end
      object rb_text: TRadioButton
        AlignWithMargins = True
        Left = 24
        Top = 204
        Width = 403
        Height = 17
        Margins.Left = 24
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        Caption = 'Text'
        TabOrder = 1
        OnClick = rb_textClick
        ExplicitTop = 185
        ExplicitWidth = 395
      end
      object rb_icontext: TRadioButton
        AlignWithMargins = True
        Left = 24
        Top = 154
        Width = 403
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
        ExplicitTop = 135
        ExplicitWidth = 395
      end
      object schWindowOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 429
        Height = 35
        Title = 'Window Options'
        Description = 'Configure options for the notes window.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitTop = -3
      end
      object schDisplayOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 108
        Width = 429
        Height = 35
        Title = 'Display Options'
        Description = 'Select how you want the Notes module displayed on the SharpBar.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitTop = 109
      end
      object cbAlwaysOnTop: TJvXPCheckbox
        AlignWithMargins = True
        Left = 20
        Top = 44
        Width = 405
        Height = 17
        Margins.Left = 20
        Margins.Right = 10
        Caption = 'Always On Top'
        TabOrder = 5
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = cbAlwaysOnTopClick
        ExplicitLeft = 30
        ExplicitWidth = 161
      end
    end
  end
end
