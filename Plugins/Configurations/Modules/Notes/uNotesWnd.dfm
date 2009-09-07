object frmNotes: TfrmNotes
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmNotes'
  ClientHeight = 317
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
    Height = 317
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 435
      Height = 317
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
      end
      object editCaptionText: TLabeledEdit
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
        OnChange = editCaptionTextChange
      end
      object editDirectory: TLabeledEdit
        Left = 60
        Top = 279
        Width = 275
        Height = 21
        EditLabel.Width = 48
        EditLabel.Height = 13
        EditLabel.Caption = 'Directory:'
        LabelPosition = lpLeft
        ReadOnly = True
        TabOrder = 7
        OnChange = editDirectoryChange
      end
      object schDirectoryOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 223
        Width = 429
        Height = 37
        Title = 'Directory Options'
        Description = 
          'Change the directory that Notes module uses for storing and disp' +
          'laying tabs.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Color = clWindow
      end
      object btnBrowse: TJvXPButton
        Left = 351
        Top = 279
        Caption = 'Browse'
        TabOrder = 9
        OnClick = btnBrowseClick
      end
    end
  end
  object JvBrowseForFolderDialog1: TJvBrowseForFolderDialog
    Left = 384
    Top = 248
  end
end
