object frmListWnd: TfrmListWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Skin List'
  ClientHeight = 320
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbSkinList: TSharpEListBoxEx
    Left = 0
    Top = 0
    Width = 434
    Height = 284
    Columns = <
      item
        Width = 0
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
        ColumnType = ctDefault
        VisibleOnSelectOnly = False
        Images = pilNormal
        SelectedImages = pilSelected
      end
      item
        Width = 35
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = PngImageList1
      end
      item
        Width = 35
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = PngImageList1
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = clWindow
    Colors.ItemColorSelected = clBtnFace
    Colors.CheckColorSelected = clBtnFace
    Colors.CheckColor = 15528425
    Colors.DisabledColor = clBlack
    DefaultColumn = 0
    OnResize = lbSkinListResize
    ItemHeight = 40
    OnClickItem = lbSkinListClickItem
    OnGetCellCursor = lbSkinListGetCellCursor
    OnGetCellText = lbSkinListGetCellText
    OnGetCellImageIndex = lbSkinListGetCellImageIndex
    AutosizeGrid = True
    BevelOuter = bvNone
    Borderstyle = bsNone
    Align = alTop
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000032149
          44415478DAA593494C53511486FFD7D779A02D0261105AC0010165505B277024
          B1C401351216262E4C08312E8C31A038C5854374818961E142DDA86163AC1AE6
          A0629568834A44299432B43688166C2DA5E37BAF3E9E95188D2B6FF2E7DEDC73
          F2DD7BEEFD0F81FF1CC49F1BDAF24B6922227A19246908D38C9A6053847CC24D
          509439C010D5E3ADF5CE7F02320D176A081EEF7AF6622D3F2D3D050A858C4B08
          068398704E6278688C42247C69A8E5F4D9BF005AC3C5434AA5ECC68692623257
          9B888CD42424C9A248514BE0F187F1F4AD1D7D3617DEBD1D8094C75CEDB97BB4
          761ED070C7A46B6C7AF9AC6257A9E4D8BE02CC0642104A154855F241B2190E97
          0F8FBA2DE8EA1D83223E1E3DA6DE28685A3BDA76DAC101CA8FDC6CA2F8D2CAD2
          955944C5FA6C2C4850832D058802229241EF8013A68F5FE1F17C075F2040BF75
          028E21DB93A1D6335B39C0B28A2B767DC9EA8CE43801F69415233D5E82E900C0
          6719DF3C33B876AB1D5E7F083C3E8959B69CAC451ABC7A6EF60D3EAC5510B197
          0F55EC2D13E6A7ABB0A96821A6FC8050C0473842A3C3F41E2FCC166E1D8A5010
          8844282CCAC563632733D67C92E40099E517BDFBF76F579CAACC83CBEDC7E084
          0F84480E8AA63162FF828EEE770804230884C288500C4A4A57E3D1834E66BC25
          06607FA06747F97ADD89AA62522D17E1FE9301986DDF909FA3654FA5D9EB0761
          B17EC2A0D5CEBDFB8A821C98BA7AA6465AEA137F95703E2F4773BC6AA75EEA74
          4C60D8318D940405C4EA040458C06C200C920E8308F92196CBF1E6E3A7A8CD62
          BB676B3B73E017208D47C0B2718B5E3EE30B10F65127942A0536AFCB657F8B06
          4347B15CA38441AF45DBEB31DC6E7AEA2245629DB1E1E0F8BC9132CACE1D9629
          558DFAB5859872B9410A85E091245B338D249504BBD76642B7340993935391BE
          FEC1E6A6DB0D75EDEDEDD6DFADAC4A5E537D5CACD6D42D5E9AC559392E4ECE05
          66BE7B4179BE304B1205DE2519F2E1996967474D4D4D2345519FFF6CA6646972
          FEBAD4BC6DD5A464812E44F394739B4C78D6CBF89C1F566988376A19CF6A341A
          9BDD6EB7830D45FFEAC698BDE3582963B3885568EE22AC3CACBCE03CFA73FC00
          3E874620306956960000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000000E84944415478DA
          A593DD0A82401085675DAC4CB3AC573349A877284B821E2030FB7B05D36EF2F5
          B20CFFCA44285857AD81C3CEC59E6FE65C0C4A9204F647F31204C1106A14CBB2
          AE36D51594020C739D2CF5551D3F6CF7062CB425FA023C1E7E2573A3D184DD61
          4306D8B643354F26633A208A222A00634C07FC1DC1B24EA5115A2DAEFE06E9BF
          5C1CD7AE0EF8346602E079FEF708AA3A0241E81403C2302C989C89613088A248
          06F8FE9DB872DEBFBAF7DBEDF6C880DBCD03C7395323C8B20C922491019E777D
          47204DCF853103FDFE800CC8D62C2F84D0F731A5E71CC771AD73468871E7335D
          7902BCE632F0257905EE0000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end>
    Left = 128
    Top = 160
    Bitmap = {}
  end
  object tmrRefreshItems: TTimer
    Interval = 1
    OnTimer = tmrRefreshItemsTimer
    Left = 244
    Top = 232
  end
  object pilSelected: TPngImageList
    DrawingStyle = dsTransparent
    PngImages = <>
    Left = 36
    Top = 280
  end
  object pilNormal: TPngImageList
    DrawingStyle = dsTransparent
    PngImages = <>
    Left = 72
    Top = 280
  end
  object tmrSetSkin: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tmrSetSkinTimer
    Left = 244
    Top = 268
  end
end
