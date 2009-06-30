object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'ApplicationBar'
  ClientHeight = 159
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object sb_config: TSharpEButton
    Left = 2
    Top = 0
    Width = 127
    Height = 25
    AutoSize = True
    OnClick = sb_configClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TNearestResampler'
    Glyph32.Data = {
      1000000010000000FFFFFF00FFFFFF00FFFFFF003838380139393904454545FF
      636363FF4E4E4EFF4C4C4CFF262626FF3C3C3C103939390837373703FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF003A3A3A023B3B3B08606060FF
      FCFCFCFFF9F9F9FFFBFBFBFF505050FF3E3E3E1E3B3B3B0F3838380636363601
      FFFFFF00FFFFFF00FFFFFF00FFFFFF003A3A3A013C3C3C033E3E3E0B4E4E4EFF
      F8F8F8FFF1F1F1FFF8F8F8FF505050FF4141412B3C3C3C163939390937373703
      FFFFFF00FFFFFF0037373701393939023C3C3C033E3E3E06404040104E4E4EFF
      F6F6F6FFEEEEEEFFF6F6F6FF505050FF444444343E3E3E1D3A3A3A0D38383806
      3636360338383801383838033B3B3B063D3D3D0A3F3F3F0F424242184E4E4EFF
      F5F5F5FFEBEBEBFFF5F5F5FF505050FF4747473C404040263C3C3C163939390E
      36363609393939051E1E1EFF303030FF303030FF303030FF303030FF5A5A5AFF
      F3F3F3FFE8E8E8FFF4F4F4FF595959FF303030FF303030FF2F2F2FFF303030FF
      232323FF3A3A3A0D414141FFF4F4F4F7F3F3F3FBF3F3F3FCF3F3F3FCF4F4F4FC
      F1F1F1FFEFEFEFFFF7F7F7FFF5F5F5FDF5F5F5FDF3F3F3FCEEEEEEFBEDEDEDFA
      595959FF3C3C3C19474747FFF1F1F1FAF0F0F0FEF0F0F0FEF2F2F2FFF1F1F1FE
      E8E8E8FEDADADAFECDCDCDFDBDBDBDFDAEAEAEFCAAAAAAFCAAAAAAFCCBCBCBFD
      5C5C5CFF3E3E3E22474747FFF5F5F5FAE9E9E9FEE2E2E2FDDBDBDBFDD4D4D4FD
      BEBEBEFBB3B3B3FBC6C6C6FCD1D1D1FDD1D1D1FCD2D2D2FCD2D2D2FCDFDFDFFD
      5D5D5DFF3F3F3F262B2B2BFF5D5D5DFF5D5D5DFF5D5D5DFF5D5D5DFF737373FF
      DEDEDEFCBDBDBDFADDDDDDFC696969FF5B5B5BFF5B5B5BFF5B5B5BFF5B5B5BFF
      3A3A3AFF3E3E3E223B3B3B103E3E3E1E4141412D4444443848484841505050FF
      E3E3E3FCC6C6C6F8E2E2E2FC4E4E4EFF4E4E4E54494949474545453D41414134
      3D3D3D273C3C3C18393939083C3C3C103E3E3E194040402043434329505050FF
      E7E7E7FACECECEF7E6E6E6FB4E4E4EFF49494946434343333F3F3F263C3C3C1D
      393939163B3B3B0D373737033A3A3A063D3D3D0A3F3F3F0F41414118505050FF
      ECECECF9D6D6D6F5EAEAEAFA4E4E4EFF4646463B404040253C3C3C153939390D
      363636093939390536363601383838023D3D3D033D3D3D064040400F505050FF
      F1F1F1F9E7E7E7F5F1F1F1F94E4E4EFF434343323E3E3E1C3A3A3A0D37373705
      3636360338383801FFFFFF00FFFFFF00FFFFFF003C3C3C033D3D3D0A454545FF
      757575FF757575FF747474FF3A3A3AFF3F3F3F273B3B3B153838380836363602
      FFFFFF003838380035353500363636003C3C3C00393939023A3A3A063C3C3C10
      3E3E3E1D404040284040402C3E3E3E263C3C3C1A3939390D3636360535353501
      3535350037373700}
    Layout = blGlyphLeft
    Caption = 'Click to Add Buttons'
    AutoPosition = True
  end
  object ButtonPopup: TPopupMenu
    Images = PngImageList1
    Left = 208
    Top = 8
    object Delete1: TMenuItem
      Caption = 'Remove from Application Bar'
      ImageIndex = 1
      OnClick = Delete1Click
    end
    object mnPopupSep1: TMenuItem
      Caption = '-'
    end
    object mnPopupCloseAll: TMenuItem
      Caption = 'Close all windows'
      ImageIndex = 0
      OnClick = mnPopupCloseAllClick
    end
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000774494D45000000000000000973942E000000097048597300001EC1
          00001EC101C3695453000001D04944415478DA9D925F2864511CC7BF07973163
          87642CB53CA94D9EF65D4AE14129A2A9B5D12C45A23CE045ED9384B6FC4F1935
          CA3C91C4D63E189B19CDEC16F2E4C10B61289E103377EECCBDF71CE76ECD98B9
          3C98F9D5B99D73EEEF7CCEF99CDF210EE7DA62C9A7E2EF198220509541A12A44
          51C2DDC31302C110644541381C414892E4CBF333BBD33ED587B8203B6E2F2D9A
          1E23B9ED47B0A57FC67C8513FA2004C833E76078647273796EB429E19FDBBBCF
          CA0F3D30D4F8309BF6052D599D282F2B4D009C9CFA51906FC6E08F89AD9585F1
          C60480CBF397592C85B8F25F21DB2080AB201915B2BDEB6575D595F8E3F181AB
          205915F2DBB5C7EA6BABE0F11D201515B2FECBC59A1B6AB1B3F70F49AA80AB1C
          9385E555D663B3C2E5F62105951BF273DEC1FA3ABF62D77B8014546EC9F8CC12
          3319B351FCB110F12AF1A11D5B14C308476428AA0A45514129C5FAC6D62D8926
          E955DE136DDD438F31805E450C49B144A679C7F5B58FC968C0B7AE8117805E25
          C8018C2732C612B7E5636DC69C6384B5A39F11FDB1A22A0151FABFD55B106D9C
          FBC184A6D6AED780A8CAFD63102ABFB097D291D8628D67E155B0DA7A5F03A22A
          92A420A2CA5015CAFB12C460805721C21F97CC1B4556A6800BFF357D06DBC24E
          12F520560C0000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000774494D45000000000000000973942E000000097048597300001EC1
          00001EC101C3695453000002424944415478DAA5536B489351187ECE2E6C637D
          6E544A83740845883FA2FB9F288C4C0B168D628992289344A124AC9020888222
          7F445414DA8D3088C5186DA0C359BAD8BE1FB546973FFE718A33A34C2A267397
          EF723A9FA39560DAE53D3C3CCFB9BCEF79CFCB7B08FED3C8BD9EC75DC5AB2D8D
          1AAD564B65409425085911A22822AB80E9AC20209311729C65CC904AA785F1B1
          583719180AC9ABAE5E22A6FA281AD4EB70A3BC67E95B09602E58863317AE3C21
          43A117B42C12847E7718D7541B7048E744D99A9245030C8FC4B17279014E9EBD
          EC2581204F0B0B8B163C288AEC39027B8EC4986965AE6885655986DBE3F592FE
          C110DD53B1FD9F0A78A4F9144F7A03CFE9BECA1DAC2899BF7236E875A83BDACE
          139F7F90DAAA2B584A74DE014A690E6C287B8A9658DA8CE6346734A0A6E9044F
          DCBE003D68ABCC0758CAF1074C9C118EC6E33C79E4E9A335F6BD90247951C7A9
          BE6E862ECC4E8C405D6481757F2B4EFBE33C79E0F2D17A878D5559FCED8D53FE
          DB48BD7263ED4E3B74A5E548BD0B60987F86FE09FD28B9F3D0439D7576A433D9
          055355EC4DCB7A6CAD6D8521160426C380C98C698D15A1A7D134B979DF455B1A
          1C48A6D2F39C7FB5C801337675BA4036DAF36BDFCE59100D4D83745EBF9B38D6
          54CB7D4D24E79A231700F9200AC7DAB7605B55158CF15E64521F31CBD667126A
          BC1ED567485BC7F9368E333901159795C49FDDC76A22B2CF234A02362522E6CD
          DA7153C90A816854EF31F359C4D8270D7D2B95BE247FDA38E1C3C51DC92F1F9A
          D512B14A6A3AC9F2BB553D205DFC0E99467FF805A63BEE0000000049454E44AE
          426082}
        Name = 'PngImage2'
        Background = clMenu
      end>
    Left = 240
    Top = 8
    Bitmap = {}
  end
  object CheckTimer: TTimer
    Interval = 5000
    OnTimer = CheckTimerTimer
    Left = 176
    Top = 8
  end
  object PreviewCheckTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = PreviewCheckTimerTimer
    Left = 272
    Top = 8
  end
end