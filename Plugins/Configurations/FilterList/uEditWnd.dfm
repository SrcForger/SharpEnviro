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
  object JvLabel1: TJvLabel
    Left = 333
    Top = 12
    Width = 44
    Height = 14
    Caption = 'Filter By:'
    Anchors = [akTop, akRight]
    Transparent = True
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'Tahoma'
    HotTrackFont.Style = []
    ExplicitLeft = 280
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
    Color = clWhite
    ParentBackground = False
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
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
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
          EditLabel.Width = 34
          EditLabel.Height = 14
          EditLabel.Caption = 'Target:'
          LabelPosition = lpLeft
          LabelSpacing = 6
          TabOrder = 1
          OnChange = UpdateEditState
        end
        object rbProcess: TRadioButton
          Left = 52
          Top = 32
          Width = 74
          Height = 17
          Caption = 'Process'
          Checked = True
          TabOrder = 2
          TabStop = True
          OnClick = rbProcessClick
        end
        object rbWindow: TRadioButton
          Left = 132
          Top = 32
          Width = 113
          Height = 17
          Caption = 'Window'
          TabOrder = 3
          OnClick = rbProcessClick
        end
      end
      object tabSelect: TTabSheet
        Caption = 'tabSelect'
        ImageIndex = 1
        TabVisible = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object rbMinimisedTasks: TRadioButton
          AlignWithMargins = True
          Left = 3
          Top = 46
          Width = 514
          Height = 17
          Align = alTop
          Caption = 'Minimised Tasks'
          TabOrder = 0
          OnClick = UpdateEditState
        end
        object rbCurrentMonitor: TRadioButton
          AlignWithMargins = True
          Left = 3
          Top = 23
          Width = 514
          Height = 17
          Align = alTop
          Caption = 'Current Monitor'
          TabOrder = 1
          OnClick = UpdateEditState
        end
        object rbCurrentVWM: TRadioButton
          AlignWithMargins = True
          Left = 3
          Top = 0
          Width = 514
          Height = 17
          Margins.Top = 0
          Align = alTop
          Caption = 'Current VWM'
          TabOrder = 2
          OnClick = UpdateEditState
        end
      end
      object tabWindowCommand: TTabSheet
        Caption = 'tabWindowCommand'
        ImageIndex = 2
        TabVisible = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object lbSwCommands: TSharpEListBoxEx
          Left = 0
          Top = 0
          Width = 520
          Height = 101
          Columns = <
            item
              Width = 20
              HAlign = taCenter
              VAlign = taVerticalCenter
              ColumnAlign = calLeft
              StretchColumn = False
              ColumnType = ctCheck
              AutoSize = False
            end
            item
              Width = 150
              HAlign = taLeftJustify
              VAlign = taVerticalCenter
              ColumnAlign = calLeft
              StretchColumn = True
              CanSelect = False
              ColumnType = ctDefault
              AutoSize = True
            end>
          Colors.BorderColor = clBtnFace
          Colors.BorderColorSelected = clBtnShadow
          Colors.ItemColor = clWindow
          Colors.ItemColorSelected = clBtnFace
          Colors.CheckColorSelected = clBtnFace
          Colors.CheckColor = clWindow
          ItemHeight = 20
          OnClickCheck = lbSwCommandsClickCheck
          OnGetCellCursor = lbSwCommandsGetCellCursor
          AutosizeGrid = False
          Borderstyle = bsNone
          Align = alClient
        end
      end
    end
  end
  object vals: TJvValidators
    ErrorIndicator = errorinc
    Left = 480
    Top = 48
    object valName: TJvRequiredFieldValidator
      Valid = True
      ControlToValidate = edName
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'Required Field'
    end
    object valNameExists: TJvCustomValidator
      Valid = True
      ControlToValidate = edName
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'This name is already in use'
      OnValidate = valNameExistsValidate
    end
  end
  object pilError: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C08648800000009704859730000004E000000
          4E01B1CD1F330000001874455874536F6674776172650041646F626520466972
          65776F726B734FB31F4E00000016744558744372656174696F6E2054696D6500
          31322F30322F30377185ABFF0000041174455874584D4C3A636F6D2E61646F62
          652E786D70003C3F787061636B657420626567696E3D22202020222069643D22
          57354D304D7043656869487A7265537A4E54637A6B633964223F3E0A3C783A78
          6D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220
          783A786D70746B3D2241646F626520584D5020436F726520342E312D63303334
          2034362E3237323937362C20536174204A616E20323720323030372032323A33
          373A33372020202020202020223E0A2020203C7264663A52444620786D6C6E73
          3A7264663D22687474703A2F2F7777772E77332E6F72672F313939392F30322F
          32322D7264662D73796E7461782D6E7323223E0A2020202020203C7264663A44
          65736372697074696F6E207264663A61626F75743D22220A2020202020202020
          20202020786D6C6E733A7861703D22687474703A2F2F6E732E61646F62652E63
          6F6D2F7861702F312E302F223E0A2020202020202020203C7861703A43726561
          746F72546F6F6C3E41646F62652046697265776F726B73204353333C2F786170
          3A43726561746F72546F6F6C3E0A2020202020202020203C7861703A43726561
          7465446174653E323030372D31322D30325431363A32373A35335A3C2F786170
          3A437265617465446174653E0A2020202020202020203C7861703A4D6F646966
          79446174653E323030372D31322D30325431383A34303A33335A3C2F7861703A
          4D6F64696679446174653E0A2020202020203C2F7264663A4465736372697074
          696F6E3E0A2020202020203C7264663A4465736372697074696F6E207264663A
          61626F75743D22220A202020202020202020202020786D6C6E733A64633D2268
          7474703A2F2F7075726C2E6F72672F64632F656C656D656E74732F312E312F22
          3E0A2020202020202020203C64633A666F726D61743E696D6167652F706E673C
          2F64633A666F726D61743E0A2020202020203C2F7264663A4465736372697074
          696F6E3E0A2020203C2F7264663A5244463E0A3C2F783A786D706D6574613E0A
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          202020200A202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020200A20202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          2020202020202020202020202020202020202020202020202020202020202020
          202020202063EB2B910000025F4944415478DA8D936B4893511CC69FD74B44CD
          1166094134484B14FAD0B6C05218B8228CECB6951F2228220A44702DF08344D2
          FD6242F4A1BE2D5776F125344674596D525A6CAF2405156136ECEAB664AD4D9D
          93BD3DEFD4CA32DB81C373CE79CFF3FBFFCFFF3D4790651953359D4E574339C2
          9EC15E2D49D2C5A9F6095301682EA6B4793DEE1C65AE5F6108524A0879932AC0
          295E6FD46B16AF542B735FCFE3B0A972BF9D80AAFF0268D6523A25E9E90CC8C3
          1CA6419613F27816458404FE09A0398D724BBC76A65493A763F4896F029C77C4
          606DDDF906024E4C0728A2744BDE27191086E1767725D70D062DE2B1C868F1AA
          F50102164C07B08B574F5668F20C6A08839300800AB5D65D01A7FB45152137FE
          02D05C40E992BC9DB3200FF2E8E97038DA218A226CB66A209E83A1A83F566ADC
          FB89FB0A0819F913D024361FDDA0C92F5363F433902943A52A44341A65113D40
          F82DA0DE06D3E6B5DF7C7D5FB71270EF2780661DC7F7197D0E12DF81E02920D7
          0C41D027E17282007F0B30D702FF476FA47C4BFD332E9711129F00B48897EBD7
          6896327AB011083503F9B6DF4AC52C7B2D40F63E665101B36953E85DDF402501
          7705AD56AB8471499E47B3117DC0486781182F5C61EBAF0C642FF07223CDEB98
          591DFC1F3C9172F3F16E7E5AAD005CA2FDE072CD921235BE1C0606AED0C1FA2C
          734E063C37F255CC03E6F389646FC7819ADDFDAE8EDE3D0A20ECED685309233D
          024237B93B3E96F5C21DAC50E6F809B8F6BE2979A1909EC52CACF0BD6A0D9976
          5EB8A4005EBB1CC71665E51A6722D5260FC17DFB74BFF590A34101287FE09CF2
          E8C642A4D47851F090DDF20317131779A73784CD0000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end>
    Left = 508
    Top = 84
    Bitmap = {}
  end
  object errorinc: TJvErrorIndicator
    BlinkRate = 200
    BlinkStyle = ebsNeverBlink
    Images = pilError
    ImageIndex = 0
    Left = 452
    Top = 48
  end
  object mnuWndClass: TPopupMenu
    Images = ilWndClass
    Left = 416
    Top = 44
  end
  object ilWndClass: TImageList
    BkColor = clMenu
    Left = 384
    Top = 44
  end
end
