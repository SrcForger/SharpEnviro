object TabOptionsForm: TTabOptionsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Tab Options'
  ClientHeight = 297
  ClientWidth = 314
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblIcon: TLabel
    Left = 19
    Top = 81
    Width = 25
    Height = 13
    Caption = 'Icon:'
  end
  object editName: TLabeledEdit
    Left = 48
    Top = 16
    Width = 253
    Height = 21
    Hint = 'The name for the tab.'
    EditLabel.Width = 31
    EditLabel.Height = 13
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnKeyPress = editNameKeyPress
  end
  object editTags: TLabeledEdit
    Left = 48
    Top = 47
    Width = 253
    Height = 21
    Hint = 'The tag(s) associated with the tab.'
    EditLabel.Width = 27
    EditLabel.Height = 13
    EditLabel.Caption = 'Tags:'
    LabelPosition = lpLeft
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object btnOk: TJvXPButton
    Left = 149
    Top = 263
    Caption = 'Ok'
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TJvXPButton
    Left = 228
    Top = 263
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object ilvIcon: TJvImageListViewer
    Left = 48
    Top = 81
    Width = 253
    Height = 144
    Cursor = crHandPoint
    Hint = 'The icon to display next to the tab name.'
    HorzScrollBar.Range = 240
    HorzScrollBar.Tracking = True
    HorzScrollBar.Visible = False
    VertScrollBar.Range = 132
    VertScrollBar.Tracking = True
    Images = SharpENotesForm.pilTabImages
    Options.AutoCenter = True
    Options.BrushPattern.EvenColor = 16772829
    Options.BrushPattern.OddColor = 16772829
    Options.DragAutoScroll = False
    Options.DrawingStyle = dsNormal
    Options.FillCaption = False
    Options.SelectedStyle = dsFocus
    Options.FrameSize = 8
    Options.Height = 18
    Options.Layout = tlCenter
    Options.ShowCaptions = False
    Options.Width = 20
    SelectedIndex = 5
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    TabStop = True
    OnDrawItem = ilvIconDrawItem
  end
  object chkReadOnly: TJvXPCheckbox
    Left = 48
    Top = 231
    Width = 81
    Height = 17
    Hint = 'When enabled you may make changes but they will not be saved.'
    Caption = 'Read-Only'
    TabOrder = 5
    ParentShowHint = False
    ShowHint = True
  end
end
