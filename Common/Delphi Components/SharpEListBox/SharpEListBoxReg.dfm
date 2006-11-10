object frmEditColumn: TfrmEditColumn
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Edit Columns'
  ClientHeight = 223
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 460
    Height = 24
    AutoSize = True
    Caption = 'ToolBar1'
    Flat = True
    Images = PngImageList1
    TabOrder = 0
    object btnAdd: TToolButton
      Left = 0
      Top = 0
      Caption = 'btnAdd'
      ImageIndex = 0
      OnClick = btnAddClick
    end
    object btnDelete: TToolButton
      Left = 23
      Top = 0
      Caption = 'btnDelete'
      ImageIndex = 1
    end
  end
  object plMain: TJvPageList
    Left = 0
    Top = 23
    Width = 460
    Height = 200
    ActivePage = plAddColumns
    PropagateEnable = False
    Align = alBottom
    object plAddColumns: TJvStandardPage
      Left = 0
      Top = 0
      Width = 460
      Height = 200
      Caption = 'Click Add to Insert a new column'
    end
    object plConfig: TJvStandardPage
      Left = 0
      Top = 0
      Width = 460
      Height = 200
      Caption = 'plConfig'
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 27
        Height = 14
        Caption = 'Width'
      end
      object lbColumns: TListBox
        Left = 0
        Top = 0
        Width = 137
        Height = 200
        Align = alLeft
        ItemHeight = 14
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 137
        Top = 0
        Width = 323
        Height = 200
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 1
        object Label2: TLabel
          Left = 16
          Top = 16
          Width = 70
          Height = 13
          Caption = 'Column Width:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 16
          Top = 76
          Width = 50
          Height = 13
          Caption = 'Text Color'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 16
          Top = 108
          Width = 94
          Height = 14
          Caption = 'Selected Text Color'
        end
        object Label5: TLabel
          Left = 16
          Top = 40
          Width = 121
          Height = 13
          Caption = 'Text and Icon Alignment:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object JvColorComboBox1: TJvColorComboBox
          Left = 72
          Top = 68
          Width = 105
          Height = 21
          ColorNameMap.Strings = (
            'clBlack=Black'
            'clMaroon=Maroon'
            'clGreen=Green'
            'clOlive=Olive green'
            'clNavy=Navy blue'
            'clPurple=Purple'
            'clTeal=Teal'
            'clGray=Gray'
            'clSilver=Silver'
            'clRed=Red'
            'clLime=Lime'
            'clYellow=Yellow'
            'clBlue=Blue'
            'clFuchsia=Fuchsia'
            'clAqua=Aqua'
            'clWhite=White'
            'clMoneyGreen=Money green'
            'clSkyBlue=Sky blue'
            'clCream=Cream'
            'clMedGray=Medium gray'
            'clScrollBar=Scrollbar'
            'clBackground=Desktop background'
            'clActiveCaption=Active window title bar'
            'clInactiveCaption=Inactive window title bar'
            'clMenu=Menu background'
            'clWindow=Window background'
            'clWindowFrame=Window frame'
            'clMenuText=Menu text'
            'clWindowText=Window text'
            'clCaptionText=Active window title bar text'
            'clActiveBorder=Active window border'
            'clInactiveBorder=Inactive window border'
            'clAppWorkSpace=Application workspace'
            'clHighlight=Selection background'
            'clHighlightText=Selection text'
            'clBtnFace=Button face'
            'clBtnShadow=Button shadow'
            'clGrayText=Dimmed text'
            'clBtnText=Button text'
            'clInactiveCaptionText=Inactive window title bar text'
            'clBtnHighlight=Button highlight'
            'cl3DDkShadow=Dark shadow 3D elements'
            'cl3DLight=Highlight 3D elements'
            'clInfoText=Tooltip text'
            'clInfoBk=Tooltip background'
            'clGradientActiveCaption=Gradient Active Caption'
            'clGradientInactiveCaption=Gradient Inactive Caption'
            'clHotLight=Hot Light'
            'clMenuBar=Menu Bar'
            'clMenuHighlight=Menu Highlight')
          ColorDialogText = 'Custom...'
          DroppedDownWidth = 105
          NewColorText = 'Custom'
          Options = [coText, coSysColors, coCustomColors]
          TabOrder = 0
        end
        object JvColorComboBox2: TJvColorComboBox
          Left = 120
          Top = 100
          Width = 113
          Height = 21
          ColorNameMap.Strings = (
            'clBlack=Black'
            'clMaroon=Maroon'
            'clGreen=Green'
            'clOlive=Olive green'
            'clNavy=Navy blue'
            'clPurple=Purple'
            'clTeal=Teal'
            'clGray=Gray'
            'clSilver=Silver'
            'clRed=Red'
            'clLime=Lime'
            'clYellow=Yellow'
            'clBlue=Blue'
            'clFuchsia=Fuchsia'
            'clAqua=Aqua'
            'clWhite=White'
            'clMoneyGreen=Money green'
            'clSkyBlue=Sky blue'
            'clCream=Cream'
            'clMedGray=Medium gray'
            'clScrollBar=Scrollbar'
            'clBackground=Desktop background'
            'clActiveCaption=Active window title bar'
            'clInactiveCaption=Inactive window title bar'
            'clMenu=Menu background'
            'clWindow=Window background'
            'clWindowFrame=Window frame'
            'clMenuText=Menu text'
            'clWindowText=Window text'
            'clCaptionText=Active window title bar text'
            'clActiveBorder=Active window border'
            'clInactiveBorder=Inactive window border'
            'clAppWorkSpace=Application workspace'
            'clHighlight=Selection background'
            'clHighlightText=Selection text'
            'clBtnFace=Button face'
            'clBtnShadow=Button shadow'
            'clGrayText=Dimmed text'
            'clBtnText=Button text'
            'clInactiveCaptionText=Inactive window title bar text'
            'clBtnHighlight=Button highlight'
            'cl3DDkShadow=Dark shadow 3D elements'
            'cl3DLight=Highlight 3D elements'
            'clInfoText=Tooltip text'
            'clInfoBk=Tooltip background'
            'clGradientActiveCaption=Gradient Active Caption'
            'clGradientInactiveCaption=Gradient Inactive Caption'
            'clHotLight=Hot Light'
            'clMenuBar=Menu Bar'
            'clMenuHighlight=Menu Highlight')
          ColorDialogText = 'Custom...'
          DroppedDownWidth = 113
          NewColorText = 'Custom'
          TabOrder = 1
        end
        object ComboBox1: TComboBox
          Left = 144
          Top = 40
          Width = 89
          Height = 22
          ItemHeight = 0
          ItemIndex = 0
          TabOrder = 2
          Text = 'LeftJustify'
          Items.Strings = (
            'LeftJustify'
            'RightJustify'
            'Center')
        end
        object ComboBox2: TComboBox
          Left = 232
          Top = 40
          Width = 89
          Height = 22
          ItemHeight = 0
          ItemIndex = 0
          TabOrder = 3
          Text = 'AlignTop'
          Items.Strings = (
            'AlignTop'
            'AlignBottom'
            'VerticalCenter')
        end
      end
      object JvSpinEdit1: TJvSpinEdit
        Left = 232
        Top = 8
        Width = 105
        Height = 22
        ButtonKind = bkStandard
        TabOrder = 2
      end
    end
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E000000A549
          44415478DA6364A01030D2CC0093D42567809431947BF6CCEC1813520DF8DF9C
          E90466D74EDFC700348071901B80E667304036000DC0C304D980FF3D792E0CBF
          FFFD070BFEFEFB1F45C7FFFF100C92AB9B8970118A010DE98E0C0F5F7F032BFC
          0734088818BEFDFACFF01768D81F10FF1F0383920427C3D4E547B01A80E18520
          0F5330BD6EC769C25EC01588E7EF7F061B40762C506C00D1D188C500CA9232B1
          80620300486577112F125DDB0000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000007049
          44415478DA6364A010308E1A4045034C52979C0152C644EA3B7B66768C09BA01
          FF7BF25C187EFFFB0F16FCFDF73F8A8EFFFF2118245737731F03D000460C031A
          D21D191EBEFE0656F80F681010317CFBF59FE12FD0B03F20FE3F060625094E86
          A9CB8F603580322F0C7C2C8C6003004EB23711482851F60000000049454E44AE
          426082}
        Name = 'PngImage1'
        Background = clWindow
      end>
    Left = 48
    Top = 88
    Bitmap = {}
  end
end
