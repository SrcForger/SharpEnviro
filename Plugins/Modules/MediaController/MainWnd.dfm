object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Media Controller'
  ClientHeight = 166
  ClientWidth = 285
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
  object btn_pselect: TSharpEButton
    Left = 82
    Top = 0
    Width = 16
    Height = 20
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnMouseUp = btn_pselectMouseUp
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TLinearResampler'
    Glyph32.Data = {
      1600000016000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      35332E5336342FBE3A3834E6484743EC5F5E5CF55A5A5A710000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000035332E8E3B3935B2494845D4514F4CED5A5A58F8A2A2A2FC
      DCDCDCFF6C6C6CFF191919FF3C3A35F900000000000000000000000000000000
      00000000000000000000000035332E8235342F983F3E3AC14F4E4ADD4D4C49F5
      6C6C6CF9D2D2D2FFD8D8D8FF1F1F1FFF090909FFC9C9C9FFD0D0D0FF111111FF
      191919FF42403BFB2E2E2E01000000000000000035332E50383732A5464440CC
      545450E5767676EF8A8A8AFAE5E5E5FF999999FF0A0A0AFF616161FFDADADAFF
      8D8D8DFF050505FF656565FFABAAA8FF888886FE474541FC454440F243423E9A
      000000000000000000000000474541EAD0D0D0FE737373FF5B5B5BFF020202FF
      9B9B9BFFE6E6E6FF2F2F2FFF0E0E0EFFC2C2C2FFA9A8A6FF52524EFD3F3D39FC
      3F3D38DC3B393595373631442E2E2E0600000000000000000000000000000000
      00000000484742EAC4C4C4FFB6B6B6FF9C9C9CFF333333FFE9E9E9FF9D9D9BFF
      595857FB484743F646443FC63E3D387B35342E622E2E2E020000000000000000
      000000000000000000000000000000000000000000000000000000003C3A35DA
      B7B7B7FFA7A7A7FFC4C4C4FF7A7A7AFB36342EFE36342EF935332DF535332DEA
      35332DEA35332DEA35332DEA35332DEA35332DEA35332DEA35332DEB35332DEB
      35332DEB35332DEB36342E7F000000000000000035332DEB585858F99C9C9CFF
      B1B1B1FFA5A5A5FF656565FE666666FC6F6F6FFCA1A1A1FAB4B4B4F9949494FB
      707070FD7F7F7FFCBABABAFAB3B3B3FA6D6D6DFE6B6B6BFEBABABAFBC1C1C1FA
      3B3934CF000000000000000035332DEDBABABAFF717171FF757575FF777777FF
      808080FF505050FF000000FF3E3E3EFFFCFCFCFFEDEDEDFF1A1A1AFF000000FF
      B7B7B7FFFDFDFDFF676767FF000000FF5E5E5EFFFDFDFDFF3D3C37E700000000
      0000000035332DEDCACACAFDA3A3A3FF3A3A3AFF4F4F4FFFC2C2C2FFE8E8E8FF
      666666FF434343FFAAAAAAFFF1F1F1FFBBBBBBFF434343FF585858FFE4E4E4FF
      E4E4E4FF616161FF4B4B4BFFBFBFBFFF3A3834E1000000000000000036342EB3
      36342EFF484744FF444440FF454441FF464543FF464543FF464441FF464441FF
      454441FF454441FF444440FF444340FF43423FFF44423FFF43423FFF42413EFF
      42413EFF3F3D39FD36342EFF00000000000000000000000036342EFF646260FF
      5B5B5BFF5C5C5CFF9D9D9DFF5C5C5CFFF6F6F6FF9C9C9CFF595959FF585858FF
      575757FF9F9F9FFF555555FF545454FF9F9F9FFF535353FF525252FF61615EFB
      36342EFF00000000000000000000000036342EFF6F6E6CFF5A5A5AFF676767FF
      FDFDFDFF9C9C9CFFF4F4F4FFBBBBBBFF797979FF585858FF575757FF9F9F9FFF
      585858FF555555FF9F9F9FFF525252FF515151FF6C6C6AFB36342EFF00000000
      000000000000000036342EFF757472FF5F5F5FFF9F9F9FFFC5C5C5FFF7F7F7FF
      C5C5C5FFDCDCDCFF9F9F9FFFC5C5C5FFC5C5C5FF9F9F9FFF9F9F9FFFC5C5C5FF
      9F9F9FFF595959FF515151FF6F6F6EFF36342EFF000000000000000000000000
      36342EFF7A7A78FF595959FF5B5B5BFFFDFDFDFF5C5C5CFF5B5B5BFFB1B1B1FF
      5B5B5BFF5C5C5CFFA5A5A5FF9A9A9AFFBABABAFFE4E4E4FF666666FF545454FF
      505050FF767676FB36342EFF00000000000000000000000036342EFF828281FF
      565656FF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF
      C5C5C5FFC5C5C5FF9F9F9FFFFDFDFDFF9F9F9FFF515151FF505050FF7D7D7DFB
      36342EFF00000000000000000000000036342EFF898989FF555555FF555555FF
      555555FF555555FF555555FF555555FF545454FF545454FF535353FF535353FF
      747474FF515151FF515151FF505050FF4F4F4FFF7B7B7BFB36342EFF00000000
      000000000000000036342EFF888888FF535353FF545454FF545454FF545454FF
      545454FF535353FF535353FF535353FF525252FF525252FF515151FF505050FF
      505050FF4F4F4FFF4E4E4EFF7A7A7AFB36342EFF000000000000000000000000
      36342EFF8A8A8AFF888888FF888888FF888888FF878787FF878787FF878787FF
      878787FF868686FF868686FF868686FF848484FF848484FF848484FF828282FF
      828282FF797979FA36342EFF00000000000000000000000036342EA736342EFF
      36342EFF36342EFF36342EFF36342EFF36342EFF36342EFF36342EFF36342EFF
      36342EFF36342EFF36342EFF36342EFF36342EFF36342EFF36342EFF36342EFF
      36342EA700000000000000000000000000000000000000050000001100000021
      00000032000000430000004B0000004D00000052000000550000005900000054
      0000004C00000042000000300000001C0000000A000000010000000000000000
      0000000000000000000000000000000000000003000000060000000E00000016
      0000001D0000001D000000200000002400000024000000230000001D00000017
      000000100000000600000001000000000000000000000000}
    Layout = blGlyphLeft
    Margin = -1
    DisabledAlpha = 100
    AutoPosition = True
    GlyphResize = True
    GlyphSpacing = 0
  end
  object btn_next: TSharpEButton
    Left = 66
    Top = 0
    Width = 16
    Height = 20
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnClick = btn_nextClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TLinearResampler'
    Glyph32.Data = {
      1600000016000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000100000002
      00000001FFFFFF00000000180000001C00000008FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00000000010000001D0000001D00000009FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00000000130C0C0C291111112D060606270000000D
      0E0F0F2D4C4F4DAD3D403E660000001800000004FFFFFF00FFFFFF0000000003
      1111112D4B4E4CA6373A37570000001900000004FFFFFF00FFFFFF00FFFFFF00
      000000031C1C1C36555A57F6585B5AFC565B57E2000000222223223A5C605EF6
      7F8381E84E5250C3303231480000001300000001000000032222223A5D605FF7
      757976EE4B4E4DA81D1D1D340000001300000001FFFFFF0000000006272B2B41
      707372F6F3F5F4FF555A57F8000000252223223A6D706FEFFEFEFEFFDFE1E0E7
      666867F14A4E4CA21E201F310000000F2222223A6E706FEFFCFCFCFFCACDCCE4
      565958EC40444273000000220000000D00000006272B2B416E7270F6EBEDECFF
      565A58F8000000252223223A6D706FEFFBFCFCFFEEF1F0FFFBFBFBFDC5C8C6E0
      545856ED454846832626263D6E706FEFFCFCFCFFF5F6F5FFF4F5F5F9909493E7
      4F5150C42C2C2C4500000020272B2B416E7170F6EDEFEEFF565A58F800000025
      2627273A6D706FEFFAFBFBFFE6EAE8FFE6EBE9FFF3F5F4FFF8F8F8F9A1A4A3E0
      505452DE6C716EF3FAFBFBFFE6EAE8FFEAEDECFFFBFBFBFFE0E3E2E9636766F1
      494D4B8F33363645696D6CF5E8EBE9FF565A58F813131324454746376F7270EF
      FBFCFBFFEBEEEDFFECEFEDFFECEFEDFFEEF0EFFFF9FAF9FFF0F1F0F1909290FD
      FBFCFBFFEAEEECFFE9EDEBFFE6EAE8FFF0F2F1FFFAFAFAFDB3B7B5E1525654E0
      5E6260F5DEE1DFFF565A58F84747472162636334707371EFFCFCFCFFF1F3F2FF
      F1F3F2FFF1F4F3FFF1F3F2FFF4F6F4FFFEFEFEFFDFE1E0FDFCFCFCFFE5E9E8FF
      E5E9E7FFE4E9E7FFF1F3F2FFFCFCFCFED0D2D1E0535756EE5F6261F6E3E6E4FF
      565A58F87A7A7A1E7B7D7C31717473EEFDFDFDFFEFF2F0FFF0F3F2FFF6F7F7FF
      FDFDFDFFF3F3F3F1868988EF707371FAFDFDFDFFF0F3F1FFF5F6F6FFFDFDFDFF
      F5F5F5EE777A79EC585C59AA6C7070475F6261F4E8EAE9FF575B59F8AEAEAE1B
      9294932F727574EEFDFDFDFFF6F7F7FFFDFDFDFFFAFAFAF49C9E9EE7575B59C3
      6F706F58727573EEFEFEFEFFFBFCFBFFFEFEFEFCBABCBADB545957DE71747155
      DFDFDF188A8F8F36606362F4EDEDEDFF575B59F8E2E2E218A2A5A42D727574EE
      FFFFFFFFFAFAFAF8AEB1AFE1565A58D772757459FFFFFF11A4A4A42D717574EE
      FEFEFEFFE8E9E8E2616463F160646291D4D4D41EFFFFFF0FFFFFFF0693989834
      606362F4EEEFEFFF575B59F8FFFFFF16A2A5A42D646866F3BCBFBEDD555957E6
      696C6A6FEFEFEF16FFFFFF07FFFFFF01A4A4A42D606463F58F9291DF575A59CD
      87878740FFFFFF14FFFFFF07FFFFFF00FFFFFF0493989834606362F4EDEDEDFF
      575B59F8FFFFFF16C2C3C222575B59CC62666485CBCCCC1EFFFFFF0BFFFFFF01
      FFFFFF00FFFFFF00C2C2C222565B59CB65696779F4F4F419FFFFFF0CFFFFFF01
      FFFFFF00FFFFFF00FFFFFF02B1B1B127565A58F4535755FF5D615EDDFFFFFF14
      FFFFFF16FFFFFF17FFFFFF0FFFFFFF02FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF16FFFFFF17FFFFFF12FFFFFF04FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF0CFFFFFF16FFFFFF17FFFFFF16FFFFFF08FFFFFF04FFFFFF05
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF07FFFFFF09
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF01FFFFFF02FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
    Layout = blGlyphLeft
    Margin = -1
    DisabledAlpha = 100
    AutoPosition = True
    GlyphResize = True
    GlyphSpacing = 0
  end
  object btn_prev: TSharpEButton
    Left = 50
    Top = 0
    Width = 16
    Height = 20
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnClick = btn_prevClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TLinearResampler'
    Glyph32.Data = {
      1600000016000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000010000000200000001
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF0000000010080808280E0F0F2D0808082800000010FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000B000000200000001A
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000A0000001E00000015
      08080827555957F0545856FC555957F00808082700000001FFFFFF00FFFFFF00
      FFFFFF00000000060000001B3B403D634A4D4BA100000026FFFFFF00FFFFFF00
      FFFFFF00000000060000001A414343724B4E4DA8000000240E0F0F2D545856FC
      E7EBE9FF545856FC0E0F0F2D00000002FFFFFF0000000002000000152323233A
      4D504EB5808682E8535755FF00000025FFFFFF00000000020000001534373752
      4F5351CE8B8F8EE5535755FF000000240E0F0F2D545856FCD6DDD9FF545856FC
      0E0F0F2D000000030000000F060606254448467F5B5E5DEDD5D8D7E4FDFDFDFF
      535755FF000000250000000F242824394C504DAE6D7170EFE6E8E7EAFEFEFEFF
      535755FF000000240E0F0F2D545856FCDBE1DEFF545856FC0E0F0F2D00000020
      3134314D4F5352D09FA3A2E3F6F8F7FBF2F4F3FFFFFFFFFF535755FF1111112D
      474B498E595D5CF1D0D3D2E1FBFCFBFEEDF0EFFFFFFFFFFF535755FF00000024
      1E1F1F2C545856FCE1E6E3FF545856FC292A29354B4E4D9C6C706DF0E7EAE8ED
      FAFBFAFFE8ECEAFFE6EAE8FFFFFFFFFF535755FF515553E4AFB2B1DFF9FAF9FB
      F1F3F2FFE6EAE9FFE6EAE8FFFFFFFFFF535755FF07070724494A4929555957FC
      E6EAE8FF555957FD535755E5C0C4C2E1FBFBFBFEF1F3F2FFEAEDECFFEAEEECFF
      EBEEECFFFFFFFFFF868A88FFF4F5F4F3F7F9F8FFECEFEEFFEBEEEDFFE9EDEBFF
      E7EBE9FFFFFFFFFF535755FF3B3B3B2171727226555957FCECEFEDFF555957FD
      585D5AF1D9DCDAE3FCFCFCFFF1F3F2FFECEFEDFFECEFEDFFEBEEEDFFFFFFFFFF
      E1E3E2FFFDFEFEFFEFF2F0FFE4E8E6FFE5E9E7FFE5EAE8FFE5E9E7FFFFFFFFFF
      535755FF6E6E6E1E999A9923555957FCF1F3F2FF555957FC7878783A575B58B8
      848784E8F7F8F7F3FBFCFCFFF4F6F5FFF2F4F3FFFFFFFFFF535755FF939694EB
      F6F6F6F4FCFDFCFFF5F7F6FFF1F3F2FFEFF2F0FFFFFFFFFF535755FFA2A2A21B
      BCBDBD1F555957FCF6F7F6FF555957FCBDBDBD20DFDFDF186A6F6D62545856E6
      C7C9C8DBFEFEFEFDFCFDFDFFFFFFFFFF535755FF73737352555A58CEAAADABE5
      FCFCFCF8FEFEFEFFF8F9F9FFFFFFFFFF535755FFD6D6D618D1D2D21E555957FC
      F8F9F9FF555957FCD1D2D21EFFFFFF04FFFFFF10BEBEBE245C615F9F696C6BEE
      EFF0EFE6FFFFFFFF535755FFFFFFFF16F0F0F0126C6F6F65555957DFBEC0BFE1
      FCFCFCFAFFFFFFFF535755FFFFFFFF16D1D2D21E555957FCF6F7F7FF555957FC
      D1D2D21EFFFFFF01FFFFFF00FFFFFF08FFFFFF157D7D7D4B555958D89FA2A0DA
      535755FFFFFFFF16FFFFFF00FFFFFF08DFDFDF196569677B5A5D5BEAC9CCCADE
      535755FFFFFFFF16E4E4E41A595D5BEC535755FF595D5BECE4E4E41AFFFFFF01
      FFFFFF00FFFFFF00FFFFFF01FFFFFF0EE3E3E31C62656487575C59C6FFFFFF15
      FFFFFF00FFFFFF00FFFFFF01FFFFFF0CB7B7B72460646291585B59C7FFFFFF16
      FFFFFF0AFFFFFF16FFFFFF17FFFFFF16FFFFFF0AFFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF05FFFFFF13FFFFFF17FFFFFF14FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF03FFFFFF10FFFFFF17FFFFFF15FFFFFF00FFFFFF01
      FFFFFF02FFFFFF01FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF09FFFFFF06FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF05FFFFFF04FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
    Layout = blGlyphLeft
    Margin = -1
    DisabledAlpha = 100
    AutoPosition = True
    GlyphResize = True
    GlyphSpacing = 0
  end
  object btn_pause: TSharpEButton
    Left = 18
    Top = 0
    Width = 16
    Height = 20
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnClick = btn_pauseClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TLinearResampler'
    Glyph32.Data = {
      1600000016000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000016000000260000002600000026
      00000026000000260000002600000017000000000000001B0000002600000026
      0000002600000026000000260000002600000015000000000000000000000000
      000000000000000002020223505452D6535755FF535755FF535755FF535755FF
      565A58F9080808250000000002020225525654F2535755FF535755FF535755FF
      535755FF5C615EEC010101210000000000000000000000000000000000000000
      0C0C0C22525654F1FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFF6B6F6DFE16161626
      000000000C0C0C24565A58FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF626665FD
      0B0B0B20000000000000000000000000000000000000000017171720525654F1
      FCFCFCFFDFE3E1FFDFE4E2FFF8F9F8FF6B6F6DFE1F2020250000000017171722
      565A58FFFEFEFEFFDFE4E2FFDFE4E2FFFBFBFBFF626665FD1616161F00000000
      000000000000000000000000000000002222221F525654F1FCFCFCFFDFE3E1FF
      DFE4E2FFF8F9F8FF6B6F6DFE292A29240000000022222221565A58FFFEFEFEFF
      DFE4E2FFDFE4E2FFFBFBFBFF636665FD2222221D000000000000000000000000
      00000000000000002F2F2F1D525654F1FCFCFCFFE0E4E2FFE0E4E2FFF8F9F8FF
      6B6F6DFE34353523000000003030301F565A58FFFEFEFEFFE0E4E2FFE0E4E2FF
      FBFBFBFF636665FD2E2E2E1C0000000000000000000000000000000000000000
      3E3E3E1C535755F1FCFDFDFFE3E7E5FFE3E6E5FFF8F9F9FF6B6F6DFE41424221
      000000003E3E3E1E565A58FFFEFEFEFFE3E7E5FFE2E6E4FFFBFCFBFF636665FD
      3C3C3C1B00000000000000000000000000000000000000004D4D4D1B535755F1
      FDFDFDFFE7EAE8FFE6E9E7FFF9FAFAFF6B6F6DFE4E4F4E20000000004E4E4E1C
      565A58FFFEFEFEFFD9DEDBFFD4DBD8FFFCFCFCFF636665FD4C4C4C1900000000
      000000000000000000000000000000005F5F5F19535755F1FDFDFDFFE2E5E4FF
      DCE1DFFFFAFBFAFF6B6F6DFE5D5E5D1F000000005F5F5F1B565A58FFFEFEFEFF
      DCE1DFFFDBE0DEFFFCFCFCFF636665FD5D5D5D18000000000000000000000000
      000000000000000071717118535755F1FDFDFDFFE3E7E6FFE1E5E3FFFBFBFBFF
      6B6F6DFE6C6C6C1D0000000071717119565A58FFFEFFFFFFE2E6E5FFE0E5E3FF
      FCFDFCFF636665FD717171170000000000000000000000000000000000000000
      87878717535755F1FDFEFDFFE9ECEBFFE6E9E8FFFBFCFCFF6B6F6DFE7D7E7E1C
      0000000088888818565A58FFFFFFFFFFE8EBEAFFE6E9E7FFFDFDFDFF636665FD
      8686861500000000000000000000000000000000000000009F9F9F15535755F0
      FEFEFEFFEEF0EFFFE9ECEBFFFCFCFCFF6B6F6DFE9091911B00000000A0A0A017
      565A58FFFFFFFFFFEDEEEEFFE9ECEBFFFDFDFDFF646765FD9F9F9F1400000000
      00000000000000000000000000000000BABABA14535755F0FEFEFEFFFFFFFFFF
      FFFFFFFFFFFFFFFF6B6F6DFEA4A5A51900000000BDBDBD15565A58FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFF646765FDBABABA13000000000000000000000000
      0000000000000000DBDBDB12555957D4545856FF545856FF545856FF545856FF
      595D5BFCCACBCA1500000000DCDCDC14545856F2545856FF545856FF545856FF
      545856FF656866F4D9D9D9110000000000000000000000000000000000000000
      FFFFFF0BF8F8F813F0F0F014F0F0F014F0F0F014F0F0F014F7F7F713FFFFFF0B
      00000000FFFFFF0BF7F7F713F0F0F014F0F0F014F0F0F014F0F0F014F8F8F813
      FFFFFF0A00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000}
    Layout = blGlyphLeft
    Margin = -1
    DisabledAlpha = 100
    AutoPosition = True
    GlyphResize = True
    GlyphSpacing = 0
  end
  object btn_stop: TSharpEButton
    Left = 34
    Top = 0
    Width = 16
    Height = 20
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnClick = btn_stopClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TLinearResampler'
    Glyph32.Data = {
      1600000016000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF0000000001000000010000000100000001000000010000000100000001
      000000010000000100000001000000010000000100000001FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000001700000026
      0000002600000026000000260000002600000026000000260000002600000026
      000000260000002600000026000000260000001BFFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF0008080820505553DE535755FF535755FF
      535755FF535755FF535755FF535755FF535755FF535755FF535755FF535755FF
      535755FF525554E40E0E0E25FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF002121211F535755F9FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF535755FF
      1D1D1D23FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      3333331E535755F9FAFAFAFFE0E4E3FFDEE2E0FFDEE2E0FFDEE3E1FFDEE3E1FF
      DEE3E1FFDEE3E1FFDFE3E1FFDFE3E1FFFFFFFFFF535755FF35353522FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004949491C535755F9
      FAFAFAFFE1E5E4FFDFE3E1FFDFE3E1FFDFE3E1FFDFE3E1FFDFE3E1FFDFE3E1FF
      DFE3E1FFDFE3E1FFFFFFFFFF535755FF48484820FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF005E5E5E1B535755F9FAFAFAFFE1E5E4FF
      DFE3E1FFDFE3E1FFDFE3E1FFDFE3E1FFDFE3E1FFDFE3E1FFDFE3E1FFDFE3E1FF
      FFFFFFFF535755FF5A5A5A1FFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF006C6C6C1A535755F9FAFBFBFFE5E8E7FFE2E6E4FFE2E6E4FF
      E2E6E4FFE2E6E4FFE1E5E4FFE1E5E3FFE1E5E3FFE0E5E3FFFFFFFFFF535755FF
      6F6F6F1EFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      7A7A7A19535755F9FBFCFBFFDFE3E1FFDBE0DDFFD9DFDCFFD8DEDBFFD6DDDAFF
      D6DCD9FFD5DBD8FFD3DAD7FFD1D8D5FFFFFFFFFF535755FF8080801CFFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009B9B9B17535755F9
      FCFCFCFFE1E5E3FFDDE2E0FFDDE1DFFFDCE1DFFFDBE0DEFFDAE0DDFFDADFDDFF
      D9DEDCFFD8DDDBFFFFFFFFFF535755FF8E8E8E1BFFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00AEAEAE16535755F9FCFDFCFFE7EAE9FF
      E4E8E6FFE4E7E6FFE3E6E5FFE2E6E4FFE1E5E3FFDFE4E2FFDEE3E1FFDDE2E0FF
      FFFFFFFF535755FFA3A3A319FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00B6B6B615535755F9FDFDFDFFEEF0EFFFEBEDECFFE9ECEBFF
      E8EBEAFFE7EAE8FFE5E9E7FFE4E7E6FFE3E6E5FFE1E5E3FFFFFFFFFF535755FF
      B5B5B518FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      D7D7D713535755F9FDFDFDFFF1F2F1FFEEEFEFFFECEEEDFFEBEDECFFE9ECEAFF
      E7EAE9FFE6E9E8FFE4E8E6FFE3E6E5FFFFFFFFFF535755FFD1D1D116FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E3E3E312535755F9
      FDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFF535755FFDBDBDB15FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00F0F0F011555A57DB535755FF535755FF
      535755FF535755FF535755FF535755FF535755FF535755FF535755FF535755FF
      535755FF555857E2F2F2F213FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF0BFFFFFF12FFFFFF12FFFFFF12FFFFFF12FFFFFF12
      FFFFFF12FFFFFF12FFFFFF12FFFFFF12FFFFFF12FFFFFF12FFFFFF12FFFFFF12
      FFFFFF0DFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
    Layout = blGlyphLeft
    Margin = -1
    DisabledAlpha = 100
    AutoPosition = True
    GlyphResize = True
    GlyphSpacing = 0
  end
  object btn_play: TSharpEButton
    Left = 2
    Top = 0
    Width = 16
    Height = 20
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnClick = btn_playClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TLinearResampler'
    Glyph32.Data = {
      1600000016000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF000000001A0000001F0000000CFFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF0000000026454947783232324C0000001C00000007FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000026
      555957F85B5F5DF8535654AE202020370000001800000004FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000026555A57F8F7F8F7FF
      B0B4B2FC585B59F4494C4A87060606270000001300000001FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF0000000026555A57F8FFFFFFFFFAFBFAFFF2F3F2FF
      909491F7585B5AE73B403D63000000220000000EFFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF0000000026555A57F8FFFFFFFFE6EAE8FFF0F2F1FFFCFCFCFFE3E6E5FF
      727673F6575A59CA2B2F2F460000001F0000000AFFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000026
      555A57F8FFFFFFFFE6EAE8FFE6EAE8FFE7EBE9FFF3F5F4FFFCFCFCFFCFD1CFFE
      5E6261F6515452A5191919330000001A00000006FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0008080825555A57F8FFFFFFFF
      E6EAE8FFE6EAE8FFE7EAE9FFE7EBE9FFEAEDEBFFF6F8F7FFFAFAFAFFB2B6B3FA
      585C59F2484C4A7E131313260D0D0D150F0F0F03FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF002A2A2A23565A58F8FFFFFFFFEAEDEBFFEAEDECFF
      EAEEECFFEAEEECFFEAEEECFFEAEEECFFEFF1F0FFFAFBFAFFF3F4F4FF919492F6
      595E5BE14A4A4A59303030213232320F33333301FFFFFF00FFFFFF00FFFFFF00
      FFFFFF004D4D4D21565A58F8FFFFFFFFEDF0EEFFEEF0EFFFEEF1EFFFEEF1EFFF
      EEF1EFFFEDF0EEFFEAEEECFFE7EBE9FFEEF0EFFFFBFCFBFFE3E5E4FF737775F5
      5B5E5DC05353533354545418FFFFFF00FFFFFF00FFFFFF00FFFFFF006F6F6F1F
      565B58F8FFFFFFFFE7ECE9FFE8ECEAFFE8ECEAFFE8ECEAFFE6EAE8FFE6EAE8FF
      E6EAE8FFE5E9E7FFE4E9E7FFF3F5F4FFFCFDFDFFBFC2C0FD555A58FA5D61614B
      76767617FFFFFF00FFFFFF00FFFFFF00FFFFFF009292921D565B59F8FFFFFFFF
      E9ECEBFFEBEEECFFECEFEEFFEDF0EFFFEEF1EFFFEEF1EFFFEDF0EFFFF3F5F4FF
      FDFDFDFFE3E4E3FF6E706FF65D625FB9707575369999990D99999901FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00B3B3B31B575B59F7FFFFFFFFEDF0EEFFEFF2F1FF
      F2F4F3FFF4F6F5FFF5F7F6FFF7F8F7FFFCFDFCFFF5F5F5FF909392F65C615FDC
      6D707050BABABA12BCBCBC03FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00D8D8D819575B59F7FFFFFFFFEEF1F0FFF1F4F3FFF5F6F5FFF8F9F8FF
      FDFDFDFFFDFDFDFFBABBBAF95B5E5CF067696771D1D1D115DBDBDB06FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F8F8F817
      575B59F7FFFFFFFFECEFEEFFEFF2F1FFF8F9F8FFFEFEFEFFD8D9D8FD626564F6
      65686799B8B8B821FFFFFF0AFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF17575B59F7FFFFFFFF
      EEF1F0FFFBFCFCFFECEDECFF7B7D7CF6606463C18F949437FFFFFF0EFFFFFF02
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF17575B59F7FFFFFFFFF7F7F7FF9FA1A0F6
      5D605EE174777755FFFFFF12FFFFFF05FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF17565B59F7BDC0BFFB5D605EF3686C6A7AE9E9E918FFFFFF09
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF17
      5E6260CC626664A2B6B6B626FFFFFF0EFFFFFF02FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF15FFFFFF17FFFFFF12
      FFFFFF04FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF06FFFFFF07FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
    Layout = blGlyphLeft
    Margin = -1
    DisabledAlpha = 100
    AutoPosition = True
    GlyphResize = True
    GlyphSpacing = 0
  end
  object MenuPopup: TPopupMenu
    Left = 168
    Top = 120
    object Settings1: TMenuItem
      Caption = 'Settings'
      OnClick = Settings1Click
    end
  end
  object SharpESkinManager1: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    ComponentSkins = [scButton, scBar, scMenu, scMenuItem]
    HandleUpdates = False
    Left = 192
    Top = 72
  end
end
