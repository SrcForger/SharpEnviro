object frmNotes: TfrmNotes
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmNotes'
  ClientHeight = 276
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
    Height = 276
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 435
      Height = 276
      ExplicitLeft = 3
      ExplicitTop = -8
      object rb_icon: TRadioButton
        AlignWithMargins = True
        Left = 5
        Top = 143
        Width = 425
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        Caption = 'Icon'
        TabOrder = 0
        OnClick = rb_textClick
        ExplicitLeft = 24
        ExplicitTop = 183
        ExplicitWidth = 403
      end
      object rb_text: TRadioButton
        AlignWithMargins = True
        Left = 5
        Top = 165
        Width = 425
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        Caption = 'Text'
        TabOrder = 1
        OnClick = rb_textClick
        ExplicitLeft = 24
        ExplicitTop = 208
        ExplicitWidth = 403
      end
      object rb_icontext: TRadioButton
        AlignWithMargins = True
        Left = 5
        Top = 121
        Width = 425
        Height = 17
        Margins.Left = 5
        Margins.Top = 8
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        Caption = 'Icon and Text'
        Checked = True
        TabOrder = 2
        TabStop = True
        OnClick = rb_textClick
        ExplicitLeft = 24
        ExplicitTop = 158
        ExplicitWidth = 403
      end
      object schWindowOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 425
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Title = 'Window Options'
        Description = 
          'Defines whether to make the notes window stay always on top of a' +
          'll other windows'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitLeft = 3
        ExplicitTop = 3
        ExplicitWidth = 429
      end
      object schDisplayOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 73
        Width = 425
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Title = 'Display Options'
        Description = 'Select how you want the Notes module displayed on the SharpBar.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitLeft = 3
        ExplicitTop = 110
        ExplicitWidth = 429
      end
      object cbAlwaysOnTop: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 43
        Width = 420
        Height = 17
        Margins.Left = 5
        Margins.Right = 10
        Caption = 'Enable windows on top'
        TabOrder = 5
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = cbAlwaysOnTopClick
        ExplicitLeft = 20
        ExplicitTop = 46
        ExplicitWidth = 405
      end
      object editName: TLabeledEdit
        AlignWithMargins = True
        Left = 90
        Top = 190
        Width = 187
        Height = 21
        EditLabel.Width = 79
        EditLabel.Height = 13
        EditLabel.Caption = 'Button Caption: '
        LabelPosition = lpLeft
        TabOrder = 6
        OnChange = editNameChange
      end
    end
  end
end
