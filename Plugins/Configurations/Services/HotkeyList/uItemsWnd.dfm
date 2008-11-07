object frmItemsWnd: TfrmItemsWnd
  Left = 578
  Top = 261
  BorderStyle = bsSingle
  Caption = 'Hotkey Service'
  ClientHeight = 367
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object lbHotkeys: TSharpEListBoxEx
    Left = 0
    Top = 0
    Width = 424
    Height = 367
    Columns = <
      item
        Width = 200
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
        ColumnType = ctDefault
        AutoSize = False
        Images = imlList
      end
      item
        Width = 30
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        CanSelect = False
        ColumnType = ctDefault
        AutoSize = False
        Images = imlList
      end
      item
        Width = 30
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        CanSelect = False
        ColumnType = ctDefault
        AutoSize = False
        Images = imlList
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = clWindow
    Colors.ItemColorSelected = clBtnFace
    Colors.CheckColorSelected = clBtnFace
    Colors.CheckColor = 15528425
    Colors.DisabledColor = clBlack
    OnResize = lbHotkeysResize
    ItemHeight = 25
    OnClickItem = lbHotkeysClickItem
    OnGetCellCursor = lbHotkeysGetCellCursor
    OnGetCellText = lbHotkeysGetCellText
    OnGetCellImageIndex = lbHotkeysGetCellImageIndex
    AutosizeGrid = True
    Borderstyle = bsNone
    Align = alTop
  end
  object dlgImport: TOpenDialog
    DefaultExt = 'xml'
    Filter = 'XML (*.xml)|*.xml'
    Left = 362
    Top = 90
  end
  object dlgExport: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'Xml (*.xml)|*.xml'
    Left = 362
    Top = 124
  end
  object PopupMenu1: TPopupMenu
    Left = 360
    Top = 150
    object Load1: TMenuItem
      Caption = 'Load Hotkeys'
    end
    object Append1: TMenuItem
      Caption = 'Save Hotkeys'
    end
    object Append2: TMenuItem
      Caption = 'Append Hotkeys'
    end
  end
  object imlList: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002954944415478DAA593ED4B536118C6AF33DBD636734C13
          7599914E320B3243C9425351316C516964122E2A08C5FD0581627F4120414484
          1A884403732A4A6AA010256192F992DB7CD964BE8496DACE1967E7799E8E130D
          6B7EA9EBD3CD03D78FFBB9EFEBE61863F81F717F023C566B1223B44202A96462
          20968282316991803653465A4E3C6F75ED0998AFB1964A9434441C37C5E9D2D2
          C019F4805F4060D18BD5DE5E7C5F5D59208C584FBF68B3FD05D83413429A220B
          7275BAB45320AE3160C9038822B87003B8230958B177C133EBF4512259325ABB
          6D3B00774D4DA2DCF660544E96519B910ED2DF0E5EF0832301A8554A70948189
          7E20351DDFBADF607EC9ED254CCA3EFFF2ED74103057555DAB3546D5475EBB0A
          FABE0F84DF802008D82F0ABBE6437C02949979986C7C8A3525EA725E0D3C0C02
          66AAEF3B620A734C4AC90F7E6E0AD2A80BA1A48AD543119300DF9A80F12F03CE
          5CDBBBE420C059758F4FB852A2E1A646C0AFAF41FFE05148C0F24D33940603C2
          CE9CC5C7F64621FFF590360870DCB5F0878BF3359CE313A8DC85A6F6C99E00EE
          801EEACC7318EA782614B40D6F0126EFDC72C4A4269B344A02C93D03DEFB2374
          6A140AA8534E62DD2F6262A4C759D4F979EB0B63B7CB6BD5FC46FDA1EB3720F6
          74802A24043602BB07B8B96E850AFA8B660CDB1EE3A7C8D715778D6F0D71D452
          9648146CF0A036C21899970BC16E87BC6B304240C0C96E2A23F621E2D265B8FB
          BB30B73CEE251CCB2EE99C98DE09D27085B99432A9293A3C4A179D570871D605
          D1E5021529D4C74C50C51F85A7CF8E9995291FE5A84536FF0ED2B63E9417C969
          941AD4448C8B4FC992D7660CBEF35E379C6303E0897F41365BB7CD218F69B0EC
          42129302155218AD6494C4CA0705B95E94EB662A492D25DD5FF73EA67FD12FCA
          BE71F0E82977BB0000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37
          EA0000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000000E84944415478DA
          6DD0BD6EC2301486E1D71150962295816E5567F690C0D46B61EAD07B4162AE3A
          702D1DA074EE0A6242CC2C1027E6D8899D04D551941F3F3EE7D351BCF08CC2AF
          130753D0588AF8FA1DF5CA0FCDE7F263D1268A89DE64B2A5C9187265B57C5F98
          FD1DD014022E3CC90F4337652B0F8C09C090BB6BC79101D3397F1694791CB0E7
          72A9F2C38C88769E0A94C482FB3C0120604B4A330F749206280424F83C99DCC3
          1A18D7E497093E4F2E751EDB152C88ABB7C2A1BE03AF8CC24CC6FACBB7B3A86B
          8141A90062BDF6D56CD3A80461A8165479FC897F41BDF2F3C35B0308A9F3F8D1
          9C6E761E81F8329010F90000000049454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end>
    Left = 380
    Top = 36
    Bitmap = {}
  end
end
