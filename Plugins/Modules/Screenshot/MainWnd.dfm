object MainForm: TMainForm
  Tag = 25
  Left = 0
  Top = 0
  Width = 261
  Height = 188
  Hint = '25'
  Caption = 'Menu'
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
  object btnSS: TSharpEButton
    Left = 0
    Top = 0
    Width = 25
    Height = 25
    SkinManager = SkinManager
    AutoSize = True
    OnMouseUp = btnSSMouseUp
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TNearestResampler'
    Glyph32.Data = {
      1900000019000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000001010101070908260D100F59040505460A0B0B3B0506050A
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0101010401020213030403640B0C0CC0363736EC787878FF9C9D9DFF616262FB
      141615CB07070729000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000001020116
      03040463070807C5373737FF838383FFD8D8D8FFFDFDFDFFFDFDFDFFF6F6F6FF
      EBEBEBFF9E9E9EFF0D0E0DB60101010200000000000000000000000000000000
      0000000000000000000000000000000000000000020202170305046B080908AA
      282928EA757675FFCACBCBFFF3F3F3FFFBFBFBFFF6F6F6FFEDEDEDFFE5E5E5FF
      E8E8E8FFF2F2F2FFE5E5E5FF1B1C1CF70101010B000000000000000000000000
      0000000000000000000000000304041303030352060706B1292929F1707070FF
      BABABAFFF1F1F1FFF9F9F9FFF5F5F5FFECECECFFE5E5E5FFE7E7E7FFF1F1F1FF
      FAFBFAFFF3FCF5FFE9FBF0FFE4E5E5FF191A1AFF0101010C0000000000000000
      000000000202020B050606540F1010A7323333F06E6E6EFFBBBBBBFFE9E9E9FF
      F5F5F5FFF4F4F4FFEDEDEDFFE4E4E4FFE5E5E5FFF0F0F0FFF9FAF8FFF8FBF3FF
      EBF8E3FFD7F3D1FFC8F2CAFFD4F6DCFFE2E3E2FF181918FF0101010C00000000
      0000000005070611151717BC757575FEBDBDBDFCE2E2E2FFF4F4F4FFF4F4F4FF
      EDEDEDFFE5E5E5FFE5E5E5FFEFEFEFFFF8F8F8FFFCFCF6FFF6F7DFFFEBF2C9FF
      DEEEBBFFD6EEBAFFD0EFBFFFCBF0C3FFD8F5D9FFE0E0E0FF171817FF0101010C
      0000000000000000070908696D6E6DFFDADADAFFF1F1F1FFF0F0F0FFE6E6E6FF
      E3E3E3FFECECECFFF8F7F7FFFDFBF3FFFEF6DEFFFAF0C0FFF3EAABFFEDEAA9FF
      E7EAADFFE2ECB1FFDCEDB6FFD6EEBAFFD1EFBFFFDCF4D5FFDADADAFF131413FF
      0101010C00000000000000000A0C0BC1AEAFAFFFEAEAEAFFE7E7E7FFE5E5E5FF
      F4F4F4FFFCFBF8FFFEF7E3FFFFEEC1FFFFE8A7FFFFE69BFFFCE69CFFF7E7A0FF
      F2E8A4FFEDE9A8FFE7EBADFFE2ECB1FFDCEDB6FFD6EEBAFFDCF2CDFFCBCCCBFF
      101111FF0101010C0000000000000000090A0AD3B0B1B1FFF4F4F4FFE3E3E3FF
      F9F9F7FFFFF0CEFFFFE4A7FFFFE19AFFFFE299FFFFE399FFFFE499FFFFE599FF
      FCE69CFFE9D79EFFE0D0A6FFE8DFA4FFE7EAADFFE1EBB0FFCFE59AFFCAE7A3FF
      C5C6C4FF101111FF0101010C0000000000000000080A09D3ADAEAEFFF2F2F2FF
      E1E1E1FFFAF9F5FFFFE3AAFFFDE6B5FFFFE19EFFFFE199FFFFE299FFFFE399FF
      FFE499FFC1A379FF5E5957FF949494FFD5BCAAFFEBE79EFFD7DC75FFC5D864FF
      D0E598FFC1C1C0FF0F100FFF0101010C00000000000000000A0B0AD3AAAAAAFF
      F1F1F1FFE1E1E1FFFAF8F5FFFFE2AAFFFCDD9EFFFFDE9AFFFFDF99FFFFE099FF
      FFE299FFF4D793FF544943FF030303FF303030FFCDC1A8FFE7D34EFFDBD350FF
      D0D559FFD8E392FFBCBDBBFF0F0F0FFF0101010C0000000000000000090A0AD3
      A7A8A8FFF0F0F0FFE1E1E1FFFAF8F5FFFFE1AAFFFFDC99FFFFDD99FFFFDE99FF
      FFDF99FFFFE099FFDEBA83FF181717FF050505FF5D5D5DFFC4A986FFF1CF3EFF
      E6D147FFDBD350FFDFE18BFFB8B8B7FF0E0F0FFF0101010C0000000000000000
      0A0A0AD3A5A5A5FFEEEEEEFFDCDCDCFFF8F6F3FFFFDDA2FFFDE1ADFFFFD98FFF
      FFD580FFFFD172FFFFCB5BFFE2A54AFF3F3D3DFF494949FF908A8AFFDDAD41FF
      FACD37FFF1C93DFFEBB73FFFE9D07FFFB4B4B2FF0E0F0EFF0202021000000000
      000000000A0B0AD3989898FFE0E0E0FFC2C2C2FFF3F0EAFFFFC159FFFCBA49FF
      FEB839FFFFBA35FFFFBB33FFFFBD33FFFBBA35FFBD9365FFAC987DFFDAAB4DFF
      FFBF31FFFFAE2CFFFCA335FFF6BB68FFEADCBBFFA2A2A1FF0D0E0EFC0608071D
      0000000000000000080A09D3797979FFD9D9D9FFC0C0C0FFF3EFE9FFFFBD55FF
      FFB233FFFFB433FFFFB733FFFFB933FFFFBB33FFFFBD33FFFFBE33FFFFB530FF
      FFA52DFFFC9F32FFFCBF6BFFEFDBB8FFC7C5BFFF8E8E8EFF2E2F2FFF06060694
      010101040000000000000000080909D3727272FFD7D7D7FFC0C0C0FFF3EFE9FF
      FFBB55FFFDBF5DFFFFB233FFFFB433FFFFB733FFFFB632FFFEAC2FFFFC9B2CFF
      F9A03AFFF8C276FFE9DBBFFFBFBEBBFF828282FF3A3A3AFF060707F00506058B
      01010101000000000000000000000000080A09D36D6D6DFFD5D5D5FFBFBFBFFF
      F2EEE9FFFFB955FFFFAD33FFFFB033FFFFAF32FFFCA32FFFF5942AFFF59E3AFF
      F8C680FFE8DAC3FFB9B7B5FF828282FF393939FF0A0A0AFB0405059B02020222
      0000000000000000000000000000000000000000090A0AD3646564FFCDCDCDFF
      BBBBBBFFEFEBE5FFFFB755FFFDA532FFF6982DFFF3902CFFF29F42FFF7CA8DFF
      E1D6C3FFADADACFF767676FF383838FF060606FA070807B20404042A00000000
      000000000000000000000000000000000000000000000000080908D35A5A5AFF
      C4C4C4FFB5B5B5FFEAE6E1FFF9AA52FFEF8B2DFFF09C44FFF6CB95FFDCD2C2FF
      9F9F9EFF6D6D6DFF343434FF0A0B0AFE070908CC080A09440102020700000000
      00000000000000000000000000000000000000000000000000000000080909D3
      4E4E4EFFB1B1B1FFAFAFAFFFE6E2DCFFFCBD72FFF8D0A0FFD4CBBFFF908F8FFF
      5E5E5EFF2E2E2EFF080908F9080A09B80A0E0D7D0102020B0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      05070678282828FF737373FFA3A3A3FFD9D8D7FFCBC6BFFF838383FF555555FF
      282828FF080808FD040706C40507075C01010102000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000003030312090A0AE8383838FF686868FF6F6F6FFF4A4A4AFF242424FF
      060707FF020604F40509077B0101010100000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000080A0A440B0D0CF1222222FF1A1A1AFF060707FF
      080B09CA0507065E0102021A0101010100000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000010202020F11103E0304044C03030347
      0B0E0D6003030311000000000000000000000000000000000000000000000000
      0000000001010101030504090000000000000000000000000000000000000000
      000000000000000000000000}
    Layout = blGlyphLeft
    Margin = -1
    DisabledAlpha = 100
    AutoPosition = True
    GlyphResize = True
    GlyphSpacing = 0
  end
  object MenuPopup: TPopupMenu
    Left = 144
    Top = 112
    object MenuSettingsItem: TMenuItem
      Caption = 'Settings'
      OnClick = MenuSettingsItemClick
    end
  end
  object SkinManager: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    ComponentSkins = [scButton, scBar]
    HandleUpdates = False
    Left = 176
    Top = 112
  end
  object svdSave: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'bitmap (*.bmp)|bmp'
    Left = 112
    Top = 112
  end
end
