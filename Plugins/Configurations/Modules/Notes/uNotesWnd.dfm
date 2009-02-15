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
    ExplicitHeight = 253
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 435
      Height = 276
      ExplicitHeight = 253
      object lblAlwaysOnTop: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 74
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
        Top = 183
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
        ExplicitTop = 208
      end
      object rb_text: TRadioButton
        AlignWithMargins = True
        Left = 24
        Top = 208
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
        ExplicitTop = 233
      end
      object rb_icontext: TRadioButton
        AlignWithMargins = True
        Left = 24
        Top = 158
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
        ExplicitTop = 174
      end
      object schWindowOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 429
        Height = 37
        Title = 'Window Options'
        Description = 'Configure options for the notes window.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
      end
      object schDisplayOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 110
        Width = 429
        Height = 37
        Title = 'Display Options'
        Description = 'Select how you want the Notes module displayed on the SharpBar.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
      end
      object cbAlwaysOnTop: TJvXPCheckbox
        AlignWithMargins = True
        Left = 20
        Top = 46
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
      end
      object editName: TLabeledEdit
        AlignWithMargins = True
        Left = 54
        Top = 236
        Width = 187
        Height = 21
        EditLabel.Width = 31
        EditLabel.Height = 13
        EditLabel.Caption = 'Name:'
        LabelPosition = lpLeft
        TabOrder = 6
        OnChange = editNameChange
      end
    end
  end
end
