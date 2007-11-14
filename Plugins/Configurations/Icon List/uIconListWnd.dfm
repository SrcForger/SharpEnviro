object frmIconList: TfrmIconList
  Left = 0
  Top = 0
  Caption = 'frmIconList'
  ClientHeight = 284
  ClientWidth = 418
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lb_iconlist: TSharpEListBoxEx
    Left = 0
    Top = 0
    Width = 418
    Height = 148
    Columns = <
      item
        Width = 256
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
      end
      item
        Width = 30
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        Images = Images
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = clWindow
    Colors.ItemColorSelected = clBtnFace
    OnResize = lb_iconlistResize
    ItemHeight = 30
    OnClickItem = lb_iconlistClickItem
    OnGetCellCursor = lb_iconlistGetCellCursor
    OnGetCellText = lb_iconlistGetCellText
    OnGetCellImageIndex = lb_iconlistGetCellImageIndex
    AutosizeGrid = True
    Borderstyle = bsNone
    Ctl3d = False
    Align = alTop
  end
  object Images: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C08648800000009704859730000004E000000
          4E01B1CD1F3300000016744558744372656174696F6E2054696D650030362F31
          342F3035BF6598320000002574455874536F667477617265004D6163726F6D65
          6469612046697265776F726B73204D5820323030348776ACCF0000029C494441
          5478DA7D935F48DA5114C78F9665344A9F5271814D5CCD977A4A906DD51808A2
          7BD804C5C564142C1187C4F2C13D07424452411B096385431C7B188D207C187B
          8814862F7BA851FE69E9A4745961B3B4DC399729256B170EBFDFEF72BE9FFBBD
          E79C1FA75C2E43EDE27038C2EEEEEE9742A1F0EED6D6D6CCF6F6F647CCFB05FF
          589C5A008A5B6432D9ACD96C7E64B55AF993939385D5D5D5EFD168D49B4EA7DF
          614AA67C4174098062B1542A9D1D1919D1389DCEA6BABA3AB6BFBFBF0F1E8FA7
          B0B4B4943D383898DFDCDCF4A2EEC725008A5B2512C95BAFD73BA0D168AED55A
          A5BC939313989898809595955832997C83AEFC0C8062A948247A3D353575C760
          3034E377555489F3F373383B3B63418EF020F0F97CDF2A8099F1F1F1A776BBBD
          89C495A885944A2528168B707C7C0CB1580CF47A7D9C01D0FAFB858585870281
          80D9ECE8E880868606E072B95548C501418E8E8E000FA3ABCC33406767673010
          08DC3B3C3C84C6C64626CA66B3A0502880CFE75F72924824A0BEBE1E1C0E470A
          BB739B7CB6A8D5EACFCBCBCB3D94707A7A0AD87726A2D3B075A0542A9988563C
          1E874C26032E976B6D636383016E188DC62F8B8B8B121254EE49A0542AC5ACE7
          7239C0AAB3677F7F3FCCCDCD81DFEF7FB6B7B7F78A0003369BEDC3F4F4742B25
          9398EE4A007AA7C0DEB3686F6F678E70C8E2EBEBEBE4384700B15C2EFF6AB158
          C4A3A3A3C0E3F1AA102A6805120C0641A55291F54C2412B1E00C7CAA0E12B6AC
          B9ABABCBDED6D636ACD56A65434343AC0BE482229FCFC3EEEE2E84C36170BBDD
          FE9D9D1DE355A37C1D2BFF041D3DC6BBDE1C1C1C64FB54F942A1006363639150
          28A445CDCF2B7FA6BFA05BBDBDBDCFD191AEAFAF4F8C534A7BBF4D26D30BCC9F
          FDEFDF5803EA41474E9D4EF7002BBF8657B98FF9A58B397F00E7B79F35C6BE52
          360000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
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
      end>
    Left = 360
    Top = 184
    Bitmap = {}
  end
end
