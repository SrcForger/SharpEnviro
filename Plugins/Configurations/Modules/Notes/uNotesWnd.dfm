object frmNotes: TfrmNotes
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmNotes'
  ClientHeight = 317
  ClientWidth = 458
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
    Width = 458
    Height = 317
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 458
      Height = 317
      DesignSize = (
        458
        317)
      object rb_icon: TRadioButton
        AlignWithMargins = True
        Left = 6
        Top = 140
        Width = 446
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        Caption = 'Icon'
        TabOrder = 2
        TabStop = True
        OnClick = rb_textClick
      end
      object rb_text: TRadioButton
        AlignWithMargins = True
        Left = 6
        Top = 162
        Width = 446
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        Caption = 'Text'
        TabOrder = 3
        OnClick = rb_textClick
      end
      object rb_icontext: TRadioButton
        AlignWithMargins = True
        Left = 6
        Top = 118
        Width = 446
        Height = 17
        Margins.Left = 5
        Margins.Top = 8
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        Caption = 'Icon and Text'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = rb_textClick
      end
      object schWindowOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 1
        Width = 446
        Height = 35
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
      end
      object schDisplayOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 72
        Width = 446
        Height = 35
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Title = 'Display Options'
        Description = 'Select how you want the Notes module displayed on the SharpBar.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
      end
      object cbAlwaysOnTop: TJvXPCheckbox
        AlignWithMargins = True
        Left = 6
        Top = 42
        Width = 441
        Height = 17
        Margins.Left = 5
        Margins.Right = 10
        Caption = 'Enable windows on top'
        TabOrder = 0
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = cbAlwaysOnTopClick
      end
      object editCaptionText: TLabeledEdit
        AlignWithMargins = True
        Left = 90
        Top = 187
        Width = 187
        Height = 21
        EditLabel.Width = 79
        EditLabel.Height = 13
        EditLabel.Caption = 'Button Caption: '
        LabelPosition = lpLeft
        TabOrder = 4
        OnChange = editCaptionTextChange
      end
      object editDirectory: TLabeledEdit
        Left = 60
        Top = 270
        Width = 298
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 48
        EditLabel.Height = 13
        EditLabel.Caption = 'Directory:'
        LabelPosition = lpLeft
        ReadOnly = True
        TabOrder = 5
        OnChange = editDirectoryChange
      end
      object schDirectoryOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 224
        Width = 446
        Height = 35
        Margins.Left = 5
        Margins.Top = 40
        Margins.Right = 5
        Title = 'Directory Options'
        Description = 
          'Change the directory that Notes module uses for storing and disp' +
          'laying tabs.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
      end
      object btnBrowse: TButton
        Left = 368
        Top = 268
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Browse'
        TabOrder = 9
      end
    end
  end
end
