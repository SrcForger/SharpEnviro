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
      Caption = 'Delete'
      ImageIndex = 0
      OnClick = Delete1Click
    end
  end
  object PngImageList1: TPngImageList
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
        Name = 'PngImage0'
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
end
