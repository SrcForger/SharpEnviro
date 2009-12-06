object frmEditWnd: TfrmEditWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmEditWnd'
  ClientHeight = 95
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    490
    95)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TPngSpeedButton
    Left = 390
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Browse'
    OnClick = Button1Click
  end
  object edName: TLabeledEdit
    Left = 56
    Top = 8
    Width = 409
    Height = 21
    Hint = 
      'The Alias name for the command.  Type the Alias name in MiniScmd' +
      ' followed by a space and a comma delimited list of args.'
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 31
    EditLabel.Height = 13
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnChange = UpdateEditState
  end
  object edCommand: TLabeledEdit
    Left = 80
    Top = 40
    Width = 289
    Height = 21
    Hint = 
      'Replacement tokens can also be used %(0-9): http://www.google.co' +
      '.uk/search?hl=en&q=%1+%2&btnG=Search&meta='
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 51
    EditLabel.Height = 13
    EditLabel.Caption = 'Command:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnChange = UpdateEditState
  end
  object cbElevation: TJvXPCheckbox
    Left = 80
    Top = 71
    Width = 289
    Height = 17
    Caption = 'Elevate this process for admin functionality'
    TabOrder = 2
    OnClick = UpdateEditState
  end
end
