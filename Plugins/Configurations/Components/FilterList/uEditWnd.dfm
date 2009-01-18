object frmEdit: TfrmEdit
  Left = 683
  Top = 363
  BorderStyle = bsNone
  Caption = 'Hotkey Configuration'
  ClientHeight = 165
  ClientWidth = 552
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    552
    165)
  PixelsPerInch = 96
  TextHeight = 14
  object JvLabel1: TLabel
    Left = 333
    Top = 12
    Width = 42
    Height = 14
    Anchors = [akTop, akRight]
    Caption = 'Filter By:'
    Transparent = True
  end
  object edName: TLabeledEdit
    Left = 56
    Top = 8
    Width = 254
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 30
    EditLabel.Height = 14
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 0
    OnChange = UpdateEditState
  end
  object cbFilterBy: TComboBox
    Left = 394
    Top = 8
    Width = 150
    Height = 22
    Style = csDropDownList
    Anchors = [akTop, akRight]
    ItemHeight = 14
    TabOrder = 1
    OnSelect = cbFilterBySelect
    Items.Strings = (
      'SW Commands'
      'Window or Process'
      'System Options')
  end
  object pnlContainer: TSharpERoundPanel
    Left = 8
    Top = 39
    Width = 536
    Height = 119
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = 'pnlContainer'
    ParentBackground = False
    ParentColor = True
    TabOrder = 2
    DrawMode = srpNormal
    NoTopBorder = False
    RoundValue = 10
    BorderColor = clBtnFace
    Border = False
    BackgroundColor = clWindow
    object pcEdit: TPageControl
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 528
      Height = 111
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ActivePage = tabEditSearch
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 0
      object tabEditSearch: TTabSheet
        Caption = 'tabEditSearch'
        TabVisible = False
        DesignSize = (
          520
          101)
        object btnSubmenuTargetBrowse: TButton
          Left = 463
          Top = 0
          Width = 54
          Height = 22
          Anchors = [akTop, akRight]
          Caption = 'Browse'
          TabOrder = 0
          OnClick = btnSubmenuTargetBrowseClick
        end
        object edSubmenuTarget: TLabeledEdit
          Left = 52
          Top = 0
          Width = 400
          Height = 22
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Tag = -1
          EditLabel.Width = 34
          EditLabel.Height = 14
          EditLabel.Caption = 'Target:'
          LabelPosition = lpLeft
          LabelSpacing = 6
          TabOrder = 1
          OnChange = UpdateEditState
        end
        object rbProcess: TJvXPCheckbox
          Left = 52
          Top = 32
          Width = 93
          Height = 17
          Caption = 'Process'
          TabOrder = 2
          Checked = True
          State = cbChecked
          OnClick = rbProcessClick
        end
        object rbWindow: TJvXPCheckbox
          Left = 151
          Top = 32
          Width = 113
          Height = 17
          Caption = 'Window'
          TabOrder = 3
          TabStop = False
          OnClick = rbProcessClick
        end
      end
      object tabSelect: TTabSheet
        Caption = 'tabSelect'
        ImageIndex = 1
        TabVisible = False
        object rbMinimisedTasks: TJvXPCheckbox
          AlignWithMargins = True
          Left = 3
          Top = 46
          Width = 514
          Height = 17
          Caption = 'Minimised Tasks'
          TabOrder = 0
          TabStop = False
          Align = alTop
          OnClick = SystemOptionsClick
        end
        object rbCurrentMonitor: TJvXPCheckbox
          AlignWithMargins = True
          Left = 3
          Top = 23
          Width = 514
          Height = 17
          Caption = 'Current Monitor'
          TabOrder = 1
          TabStop = False
          Align = alTop
          OnClick = SystemOptionsClick
        end
        object rbCurrentVWM: TJvXPCheckbox
          AlignWithMargins = True
          Left = 3
          Top = 0
          Width = 514
          Height = 17
          Margins.Top = 0
          Caption = 'Current VWM'
          TabOrder = 2
          TabStop = False
          Align = alTop
          OnClick = SystemOptionsClick
        end
      end
      object tabWindowCommand: TTabSheet
        Caption = 'tabWindowCommand'
        ImageIndex = 2
        TabVisible = False
        object lbSwCommands: TSharpEListBoxEx
          Left = 0
          Top = 0
          Width = 520
          Height = 101
          Columns = <
            item
              Width = 20
              HAlign = taLeftJustify
              VAlign = taVerticalCenter
              ColumnAlign = calLeft
              StretchColumn = True
              ColumnType = ctCheck
              VisibleOnSelectOnly = False
            end>
          Colors.BorderColor = clBtnFace
          Colors.BorderColorSelected = clBtnShadow
          Colors.ItemColor = clWindow
          Colors.ItemColorSelected = clBtnFace
          Colors.CheckColorSelected = clBtnFace
          Colors.CheckColor = clWindow
          Colors.DisabledColor = clBlack
          DefaultColumn = 0
          ItemHeight = 20
          OnClickCheck = lbSwCommandsClickCheck
          OnGetCellCursor = lbSwCommandsGetCellCursor
          OnGetCellText = lbSwCommandsGetCellText
          AutosizeGrid = False
          Borderstyle = bsNone
          Align = alClient
        end
      end
    end
  end
  object mnuWndClass: TPopupMenu
    Images = ilWndClass
    Left = 416
    Top = 44
  end
  object ilWndClass: TImageList
    Left = 400
    Top = 44
  end
end
