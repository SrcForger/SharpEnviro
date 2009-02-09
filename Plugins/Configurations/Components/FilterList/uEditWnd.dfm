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
  object ilWndClass: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001CE4944415478DAA5534B28FC51143EC74CC4F4B3B12065
          A1445136928DA2949212919190B09147C2E419112684C66B41F24C9E919252F6
          928DFAFF1BC20A2B65C762C6BDC7B9F737BFD4ECC6DC3A9D73EEE3BBDF3DF73B
          484410CEC0D28EBD96DCFCECC98F2F72682C2981D88414EC0924712E047BD25E
          F05A6CA4EFD3EB7DEB3999732EE1D8E1B3300C4744A8373F7BEFA5A723CF86FD
          BB4F7F7AC3FBEB0BACB8F211FBB61F69A22625648046F715ACF51520F66E3D90
          BB36157CDFFC665E50EF16924BC199D431D7E39B4CE37AF80441728201F5E397
          B03150C8009BF7E4AE4B033F6F0455284611CA9B29C7A00B2AA4392719283E2E
          1AEA462E606BB808D1B5FE9FA6EAD3F54D9A813252D507CD40816893A041148B
          38230A6A86CE6167B418B17BED1F4D376498B7B2610044068088299831685095
          183176A81E3C83DDB112C4CED53B9A69CAD400D6B0C4650121B3538703320147
          941DAAFA4F616FA214B17DF9963CCD5920D4C6A0C3C12AB55846DBED50E13A82
          A3E90AC4B6851B9A6FCDFE3D6452806071488B1D5388B4D9A0BCEB008E672A11
          5B3CD7B4D89E13B20ECA3AF7E164D689AA17F6E393122BA5D23B0B4028AFFEDE
          EFD75EF780EA0B11E80B3567D239E05E7062D8DD182EC00FFD5A32F08EC9B5CE
          0000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clMenu
      end>
    Left = 400
    Top = 72
    Bitmap = {}
  end
end
