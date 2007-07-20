object frmConfig: TfrmConfig
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
  OnResize = FormResize
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
        MaxWidth = 0
        MinWidth = 0
        TextColor = clBlack
        SelectedTextColor = clBlack
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        Autosize = False
        Images = imlList
      end
      item
        Width = 100
        MaxWidth = 0
        MinWidth = 0
        TextColor = clBlack
        SelectedTextColor = clBlack
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        Autosize = False
        Images = imlList
      end>
    ItemHeight = 24
    OnClickItem = lbHotkeysClickItem
    OnGetCellTextColor = lbHotkeysGetCellTextColor
    Borderstyle = bsNone
    Align = alClient
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
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000018849
          44415478DAB593DF4A024114C6BF9DD92B83BC3137BC0AAFC257280CB3C45EA4
          EE8308BA2F4C114322905EA3522AFAE3635457A5D8BA7B2989B033DB99D1D556
          BB49E8CC0C7376E0FB9D6FE6B046A178BC0BA086398231B66F10C03F3C389A47
          8FD3D209C68056ABF52771229140A95CF827806118E3059AF0D5A42155AEB3DF
          014AF0FAF6827EFF0BBD5E4FC3E2710BA9D51494B6D97CC4FA5A1A9248169D97
          2BC509A0DD6EE3A3F58EE44A120663787A7E183BB2AC65D8F6A7CE37D2194829
          108B2D85019D4E87DAC2C13953EDA165E0EEFE76E6EE9B992C84F0118D2EE2AC
          5A9E006CDB06E30460238002190CF5C67508B095CD410A89C84204D5F3CA04E0
          74BB43000F5C70DCD4AF661CE4B6F3E440E822B5CB8B1F00D7A1EA264C936B71
          BD312B5691CFED1040EAEE8400AEEBEAEA2637C14D46B9A9BFD55BF8D2879012
          C213B40B78C2D3AD9D72E09238000457192EA9C4420905DD9F76CFD36EC20E1C
          07CC1C0182C7540EE821250DE5220028D80C20389C0E553D88A0B28AC1603006
          CCFD3B53EC7D036587EE50ED5EC05B0000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000002194944415478DA
          A593DD4E134114C7FF335349D394DABA6D21A954BD31BE855C192082297E217A
          A53E80496D111EC0886BEB1D2104C58FA8B8A5242A11109F402E30BD315EA0C4
          60EB0542B3AD7C74BBBBCE4C2DA4DA68137777724E76F6FCF67FE69C436CDBC6
          FF5C440086D59B9D8CB147A669FA1B09A294EADC5C8B456F4C4840E2AEFAA1AB
          B3EB584B4BABD804A34C5AB108A132C8B62D585665ADAF7F8736A5E9B1E8C07E
          09B8931C5EEBEFBFA46C160B1019114AF624FE72AB9912FEC2AF04313A368281
          D810D9055CE8BBA8FC28EAA04DFCEF84CA0F898C2648A849E47259A8C9DB30B6
          4A08045A31363E5A0B387FAE4F314A3B208EAA7422E59B6619CBCB9F100A85E0
          72B950DE29C1E3F1E2DEC4782DE0CCE9B38A833198FCA6F20C2A80B9D9796432
          192CBE5BE4793F875DB6E070ECC3C3C70FF6006AE2D65A24D2ABB85D6E1896B1
          7B802295572F67B0F47E09F3B36FF07A6E061EB70746D9C0D3674F6A01DDDD3D
          4A3010C4D6F62628635205E390C8A95E4C6A93E838D181E91769F87D0A36F279
          A4A6B4DF00277B94B68361E40B1BE03D512925B7292D8595CF2B703A9DB872F5
          320E7815E4BE7D457A3AFD2720DC7648E60EF990BA4D649A16B2B9D5FA0041A6
          8CFEB50B2D0E104AEB0256B35FF0AFD910E53D1C3E520BE065FCD87EBCFDA8D7
          E76B68800ABA8E85B70BC5F8F5C1E6EA304538F93EF79B1B9A4042B6F911C5E3
          D1C1115295CC2122F9A606A7D8E0F24DE1FC04095E11F05EC3BD1F0000000049
          454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end>
    Left = 380
    Top = 36
  end
  object JvHint1: TJvHint
    Left = 284
    Top = 244
  end
end
