object TabOptionsForm: TTabOptionsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Tab Options'
  ClientHeight = 240
  ClientWidth = 282
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblIcon: TLabel
    Left = 20
    Top = 70
    Width = 25
    Height = 13
    Caption = 'Icon:'
  end
  object editName: TLabeledEdit
    Left = 48
    Top = 16
    Width = 217
    Height = 21
    EditLabel.Width = 31
    EditLabel.Height = 13
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    TabOrder = 0
    OnKeyPress = editNameKeyPress
  end
  object editTags: TLabeledEdit
    Left = 48
    Top = 43
    Width = 217
    Height = 21
    EditLabel.Width = 27
    EditLabel.Height = 13
    EditLabel.Caption = 'Tags:'
    LabelPosition = lpLeft
    TabOrder = 1
  end
  object btnOk: TJvXPButton
    Left = 64
    Top = 207
    Caption = 'Ok'
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TJvXPButton
    Left = 151
    Top = 207
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object ilvIcon: TJvImageListViewer
    Left = 48
    Top = 70
    Width = 217
    Height = 131
    HorzScrollBar.Range = 200
    HorzScrollBar.Tracking = True
    HorzScrollBar.Visible = False
    VertScrollBar.Range = 100
    VertScrollBar.Tracking = True
    Options.AutoCenter = True
    Options.SelectedStyle = dsNormal
    Options.FrameSize = 5
    Options.Height = 16
    Options.ShowCaptions = False
    Options.Width = 16
    SelectedIndex = -1
    TabOrder = 4
    TabStop = True
  end
end
