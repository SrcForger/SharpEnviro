object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'RSS Reader'
  ClientHeight = 159
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = Popup
  OnClick = FormClick
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnDestroy = FormDestroy
  OnMouseEnter = FormMouseEnter
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object lb_bottom: TSharpESkinLabel
    Left = 6
    Top = 18
    Width = 12
    Height = 21
    AutoSize = True
    OnClick = FormClick
    OnDblClick = lb_bottomDblClick
    OnMouseEnter = FormMouseEnter
    Caption = '.'
    AutoPos = apBottom
    LabelStyle = lsSmall
  end
  object lb_top: TSharpESkinLabel
    Left = 6
    Top = 0
    Width = 12
    Height = 21
    AutoSize = True
    OnClick = FormClick
    OnDblClick = lb_topDblClick
    OnMouseEnter = FormMouseEnter
    Caption = '.'
    AutoPos = apTop
    LabelStyle = lsSmall
  end
  object btnRight: TSharpEButton
    Left = 61
    Top = 0
    Width = 23
    Height = 25
    AutoSize = True
    OnClick = btnRightClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TNearestResampler'
    Glyph32.Data = {
      2000000020000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000008B8F8DD9858A88FF858A88FF
      858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF
      858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF
      858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF898D8BE5AAAAAA03
      0000000000000000000000000000000000000000858A88FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF898E8CF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFFFFFFFFF888E8CF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFF5F6F6FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FF999999FF999999FF999999FF999999FF999999FF
      999999FF999999FF999999FF999999FFF4F5F5FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F6F7F7FFF5F6F6FFF5F5F5FFF4F5F5FFF3F4F4FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFF6F6F6FF
      F5F6F6FFF4F5F5FFF4F4F4FFF3F4F4FFF2F3F3FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FF999999FF999999FF999999FF999999FF999999FF
      999999FF999999FF999999FF999999FFF1F2F2FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFF5F6F6FFF5F6F6FFF4F5F5FFF4F4F4FF
      F3F4F4FFF2F3F3FFF2F2F2FFF1F2F2FFF0F1F1FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF6F7F7FFF6F7F7FFF5F6F6FFF4F5F5FFF4F5F5FFF3F4F4FFF3F3F3FF
      F2F3F3FFF1F2F2FFF1F1F1FFF0F1F1FFEFF0F0FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F6F7F7FFF5F6F6FFF5F6F6FF999999FF999999FF999999FF999999FF999999FF
      999999FF999999FF999999FFEFEFEFFFEEEFEFFFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFF6F7F7FF
      F5F6F6FFF4F5F5FFF4F5F5FFF3F4F4FFF2F3F3FFF2F3F3FFF1F2F2FFF1F1F1FF
      F0F0F0FFEFF0F0FFEFEFEFFFEEEEEEFFEDEEEEFFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFF5F6F6FFF5F6F6FF
      F4F5F5FFF3F4F4FFF3F3F3FFF2F3F3FFF1F2F2FFF1F1F1FFF0F1F1FFF0F0F0FF
      EFEFEFFFEEEFEFFFEEEEEEFFEDEDEDFFECEDEDFFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFF6F7F7FFF5F6F6FFF4F5F5FFF4F4F4FF
      F3F4F4FF9A9D9CFFEEEEEEFFF1F2F2FFF0F1F1FFF0F0F0FFEFF0F0FFEFEFEFFF
      EEEEEEFFEDEEEEFFEDEDEDFFECECECFFEBECECFFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF6F7F7FFF5F6F6FFF5F5F5FFF4F5F5FFF3F4F4FFF3F3F3FF
      F2F3F3FF5C605EFF7A7E7CFFE5E6E6FFEFF0F0FFEFEFEFFFEEEFEFFFEEEEEEFF
      EDEDEDFFECEDEDFFECECECFFEBEBEBFFEAEBEBFFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F6F7F7FFF6F6F6FFF5F6F6FFF4F5F5FFF4F4F4FFF3F4F4FFF2F3F3FFF2F2F2FF
      F1F2F2FF5E6260FF535755FF6A6D6CFFD6D8D7FFEEEEEEFFEDEEEEFFEDEDEDFF
      ECECECFFEBECECFFEBEBEBFFEAEAEAFFE9E9E9FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF6F7F7FF
      F5F6F6FFF5F5F5FFF2F3F3FFEFF0F0FFEEEEEEFFECEDEDFFE8EAEAFFE7E8E7FF
      E6E7E7FF646766FF535755FF535755FF5D615FFFC5C6C5FFECEDEDFFECECECFF
      EBEBEBFFEAEAEAFFEAEAEAFFE9E9E9FFE8E8E8FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF5F6F6FF
      F4F5F5FFEFEFEFFFD6D8D7FFBCBEBEFFA3A5A4FF8B8D8CFF727573FF595D5BFF
      535755FF535755FF535755FF535755FF535755FF565A58FFAEB0AFFFEBEBEBFF
      EAEAEAFFE9E9E9FFE9E9E9FFE8E8E8FFE7E7E7FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF4F5F5FF
      F3F4F4FFEEEEEEFFD5D7D6FFBCBDBDFFA3A5A4FF8B8D8CFF727573FF595D5BFF
      535755FF535755FF535755FF535755FF535755FF535755FF535755FF969897FF
      E7E7E7FFE8E8E8FFE8E8E8FFE7E7E7FFE6E7E7FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF3F4F4FF
      F2F3F3FFEDEDEDFFD5D6D5FFBBBDBDFFA2A4A3FF8A8C8BFF727573FF595D5BFF
      535755FF535755FF535755FF535755FF535755FF535755FF535755FF535755FF
      7F8281FFDFDFDFFFE7E7E7FFE6E7E7FFE5E6E6FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF2F3F3FF
      F1F2F2FFECECECFFD4D5D4FFBABCBCFFA2A4A3FF8A8C8BFF717573FF595D5BFF
      535755FF535755FF535755FF535755FF535755FF535755FF535755FF535755FF
      535755FF7F8281FFE6E6E6FFE5E6E6FFE4E6E6FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF1F1F1FF
      F0F1F1FFEBEBEBFFD3D4D3FFBABBBBFFA1A3A2FF8A8C8BFF717472FF595D5BFF
      535755FF535755FF535755FF535755FF535755FF535755FF535755FF535755FF
      757876FFD8DAD9FFE5E6E6FFE4E5E5FFE3E5E5FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF0F0F0FF
      EFF0F0FFEAEAEAFFD2D3D2FFB9BBBBFFA1A3A2FF898B8AFF717472FF595D5BFF
      535755FF535755FF535755FF535755FF535755FF535755FF535755FF8A8D8BFF
      E1E2E2FFE4E6E6FFE4E5E5FFE3E5E5FFE2E4E4FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFEFEFEFFF
      EEEFEFFFE9E9E9FFD1D2D1FFB8BABAFFA0A2A1FF898B8AFF717472FF595D5BFF
      535755FF535755FF535755FF535755FF535755FF545856FFA1A4A3FFE5E6E6FF
      E4E5E5FFE3E5E5FFE3E5E5FFE2E4E4FFE1E4E4FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFEEEEEEFF
      EDEEEEFFEDEDEDFFECECECFFEBECECFFEBEBEBFFEAEAEAFFE9E9E9FFE9E9E9FF
      E8E8E8FF5C605EFF535755FF535755FF5B5F5DFFB9BBBBFFE4E6E6FFE4E5E5FF
      E3E5E5FFE2E4E4FFE2E4E4FFE1E4E4FFE0E3E3FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFEDEDEDFF
      ECEDEDFFECECECFFEBEBEBFFEAEAEAFFEAEAEAFFE9E9E9FFE8E8E8FFE8E8E8FF
      E7E7E7FF5C605EFF535755FF666A68FFCBCCCCFFE4E5E5FFE3E5E5FFE3E5E5FF
      E2E4E4FFE1E4E4FFE1E3E3FFE0E3E3FFDFE3E3FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFECECECFF
      EBEBEBFFEBEBEBFFEAEAEAFFE9E9E9FFE9E9E9FFE8E8E8FFE7E7E7FFE7E7E7FF
      E6E7E7FF5B605EFF757977FFD8D9D9FFE3E5E5FFE3E5E5FFE2E4E4FFE2E4E4FF
      E1E4E4FFE0E3E3FFE0E3E3FFDFE2E2FFDEE2E2FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFEBEBEBFF
      EAEAEAFFEAEAEAFFE9E9E9FFE8E8E8FFE8E8E8FFE7E7E7FFE6E7E7FFE6E6E6FF
      E5E6E6FF939695FFE1E2E2FFE3E5E5FFE3E5E5FFE2E4E4FFE1E4E4FFE1E3E3FF
      E0E3E3FFDFE3E3FFDFE2E2FFDEE2E2FFDEE2E2FFFFFFFFFF888D8BF961616115
      000000000000000000000000000000090000001B858A88FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF888D8BFA24242438
      0000001B00000008000000000000000F00000023858A87E0858A88FF858A88FF
      858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF
      858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF
      858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858987EC09090939
      000000230000000800000000000000000000000700000015000000220000002B
      0000002F0000002F0000002F0000002F0000002F0000002F0000002F0000002F
      0000002F0000002F0000002F0000002F0000002F0000002F0000002F0000002F
      0000002F0000002F0000002F0000002F0000002A000000270000001D0000000E
      0000000200000000}
    Layout = blGlyphLeft
    AutoPosition = True
    ForceDown = False
    ForceHover = False
  end
  object btnLeft: TSharpEButton
    Left = 61
    Top = 24
    Width = 23
    Height = 25
    AutoSize = True
    OnClick = btnLeftClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TNearestResampler'
    Glyph32.Data = {
      2000000020000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000008B8F8DD9858A88FF858A88FF
      858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF
      858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF
      858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF898D8BE5AAAAAA03
      0000000000000000000000000000000000000000858A88FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF898E8CF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFFFFFFFFF888E8CF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFF5F6F6FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF
      999999FF999999FF999999FF999999FF999999FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF6F7F7FFF6F7F7FFF5F6F6FFF4F5F5FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F6F7F7FFF5F6F6FFF5F5F5FFF4F5F5FFF3F4F4FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFF6F6F6FF
      F5F6F6FFF4F5F5FFF4F4F4FFF3F4F4FFF2F3F3FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF
      999999FF999999FF999999FF999999FFF6F7F7FFF6F7F7FFF5F6F6FFF5F5F5FF
      F4F5F5FFF3F4F4FFF3F3F3FFF2F3F3FFF1F2F2FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFF5F6F6FFF5F6F6FFF4F5F5FFF4F4F4FF
      F3F4F4FFF2F3F3FFF2F2F2FFF1F2F2FFF0F1F1FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FF
      F7F8F8FFF6F7F7FFF6F7F7FFF5F6F6FFF4F5F5FFF4F5F5FFF3F4F4FFF3F3F3FF
      F2F3F3FFF1F2F2FFF1F1F1FFF0F1F1FFEFF0F0FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF
      999999FF999999FF999999FFF4F5F5FFF3F4F4FFF3F4F4FFF2F3F3FFF2F2F2FF
      F1F2F2FFF0F1F1FFF0F0F0FFEFEFEFFFEEEFEFFFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFF6F7F7FF
      F5F6F6FFF4F5F5FFF4F5F5FFF3F4F4FFF2F3F3FFF2F3F3FFF1F2F2FFF1F1F1FF
      F0F0F0FFEFF0F0FFEFEFEFFFEEEEEEFFEDEEEEFFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFF5F6F6FFF5F6F6FF
      F4F5F5FFF3F4F4FFF3F3F3FFF2F3F3FFF1F2F2FFF1F1F1FFF0F1F1FFF0F0F0FF
      EFEFEFFFEEEFEFFFEEEEEEFFEDEDEDFFECEDEDFFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF7F8F8FFF6F7F7FFF6F7F7FFF5F6F6FFF4F5F5FFF2F2F2FF
      9A9C9BFFE9EAEAFFF2F2F2FFF1F2F2FFF0F1F1FFF0F0F0FFEFF0F0FFEFEFEFFF
      EEEEEEFFEDEEEEFFEDEDEDFFECECECFFEBECECFFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F7F8F8FFF7F8F8FFF6F7F7FFF5F6F6FFF5F5F5FFF4F5F5FFEAEBEBFF818382FF
      535755FFE8E9E9FFF1F1F1FFF0F1F1FFEFF0F0FFEFEFEFFFEEEFEFFFEEEEEEFF
      EDEDEDFFECEDEDFFECECECFFEBEBEBFFEAEBEBFFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF7F8F8FF
      F6F7F7FFF6F6F6FFF5F6F6FFF4F5F5FFF4F4F4FFDDDFDFFF6D716FFF535755FF
      535755FFE7E8E8FFF0F0F0FFEFF0F0FFEEEFEFFFEEEEEEFFEDEEEEFFEDEDEDFF
      ECECECFFEBECECFFEBEBEBFFEAEAEAFFE9E9E9FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF6F7F7FF
      F5F6F6FFF5F5F5FFF4F5F5FFF3F4F4FFCBCCCBFF5F6361FF535755FF535755FF
      535755FFE6E7E7FFEFEFEFFFEEEFEFFFEDEEEEFFEDEDEDFFECEDEDFFECECECFF
      EBEBEBFFEAEAEAFFEAEAEAFFE9E9E9FFE8E8E8FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF5F6F6FF
      F4F5F5FFF4F4F4FFF3F4F4FFB2B5B4FF565A58FF535755FF535755FF535755FF
      535755FF535755FF535755FF585C5AFF6F7371FF888A89FF9EA09FFFB6B7B7FF
      CDCECDFFE6E6E6FFE9E9E9FFE8E8E8FFE7E7E7FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF4F5F5FF
      F3F4F4FFF1F1F1FF979A99FF535755FF535755FF535755FF535755FF535755FF
      535755FF535755FF535755FF575B59FF6F7270FF878988FF9EA09FFFB5B6B6FF
      CCCDCCFFE5E5E5FFE8E8E8FFE7E7E7FFE6E7E7FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF3F4F4FF
      E8E9E9FF7E8180FF535755FF535755FF535755FF535755FF535755FF535755FF
      535755FF535755FF535755FF575B59FF6F7270FF878988FF9D9F9EFFB5B6B6FF
      CBCCCBFFE4E4E4FFE7E7E7FFE6E7E7FFE5E6E6FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF2F3F3FF
      8F9190FF535755FF535755FF535755FF535755FF535755FF535755FF535755FF
      535755FF535755FF535755FF575B59FF6F7270FF868887FF9D9F9EFFB4B5B5FF
      CBCCCBFFE3E4E4FFE6E6E6FFE5E6E6FFE4E6E6FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF1F1F1FF
      EBECECFF898C8BFF535755FF535755FF535755FF535755FF535755FF535755FF
      535755FF535755FF535755FF575B59FF6F7270FF868887FF9C9E9DFFB3B4B4FF
      CACCCBFFE3E3E3FFE5E6E6FFE4E5E5FFE3E5E5FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFF0F0F0FF
      EFF0F0FFEEEEEEFFA1A3A2FF545856FF535755FF535755FF535755FF535755FF
      535755FF535755FF535755FF575B59FF6F7270FF868887FF9C9E9DFFB3B4B4FF
      C9CBCAFFE2E3E3FFE4E5E5FFE3E5E5FFE2E4E4FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFEFEFEFFF
      EEEFEFFFEEEEEEFFEDEDEDFFB8B9B8FF575B59FF535755FF535755FF535755FF
      535755FF535755FF535755FF575B59FF6E7270FF858786FF9B9E9DFFB2B4B4FF
      C8CAC9FFE1E3E3FFE3E5E5FFE2E4E4FFE1E4E4FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFEEEEEEFF
      EDEEEEFFEDEDEDFFECECECFFEBECECFFCACBCAFF616563FF535755FF535755FF
      565A58FFDEDEDEFFDEDEDEFFDCDEDEFFDDDEDEFFDFE0E0FFDFE1E1FFE1E2E2FF
      E1E3E3FFE2E4E4FFE2E4E4FFE1E4E4FFE0E3E3FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFEDEDEDFF
      ECEDEDFFECECECFFEBEBEBFFEAEAEAFFEAEAEAFFD8D8D8FF6D716FFF535755FF
      535755FFE6E7E7FFE6E6E6FFE5E6E6FFE4E6E6FFE4E5E5FFE3E5E5FFE3E5E5FF
      E2E4E4FFE1E4E4FFE1E3E3FFE0E3E3FFDFE3E3FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFECECECFF
      EBEBEBFFEBEBEBFFEAEAEAFFE9E9E9FFE9E9E9FFE8E8E8FFE0E0E0FF808381FF
      535755FFE5E6E6FFE5E6E6FFE4E5E5FFE3E5E5FFE3E5E5FFE2E4E4FFE2E4E4FF
      E1E4E4FFE0E3E3FFE0E3E3FFDFE2E2FFDEE2E2FFFFFFFFFF888D8BF98888880F
      0000000000000000000000000000000000000000858A88FFFFFFFFFFEBEBEBFF
      EAEAEAFFEAEAEAFFE9E9E9FFE8E8E8FFE8E8E8FFE7E7E7FFE6E7E7FFE4E4E4FF
      939695FFE4E6E6FFE4E5E5FFE3E5E5FFE3E5E5FFE2E4E4FFE1E4E4FFE1E3E3FF
      E0E3E3FFDFE3E3FFDFE2E2FFDEE2E2FFDEE2E2FFFFFFFFFF888D8BF961616115
      000000000000000000000000000000090000001B858A88FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF888D8BFA24242438
      0000001B00000008000000000000000F00000023858A87E0858A88FF858A88FF
      858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF
      858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF
      858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858987EC09090939
      000000230000000800000000000000000000000700000015000000220000002B
      0000002F0000002F0000002F0000002F0000002F0000002F0000002F0000002F
      0000002F0000002F0000002F0000002F0000002F0000002F0000002F0000002F
      0000002F0000002F0000002F0000002F0000002A000000270000001D0000000E
      0000000200000000}
    Layout = blGlyphLeft
    AutoPosition = True
    ForceDown = False
    ForceHover = False
  end
  object UpdateTimer: TTimer
    Enabled = False
    Interval = 600000
    OnTimer = UpdateTimerTimer
    Left = 224
    Top = 16
  end
  object SwitchTimer: TTimer
    Enabled = False
    Interval = 20000
    OnTimer = SwitchTimerTimer
    Left = 256
    Top = 16
  end
  object ClosePopupTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = ClosePopupTimerTimer
    Left = 224
    Top = 48
  end
  object PopupTimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = PopupTimerTimer
    Left = 256
    Top = 48
  end
  object DoubleClickTimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = DoubleClickTimerTimer
    Left = 224
    Top = 80
  end
  object ClearNotifyWindows: TTimer
    Enabled = False
    Interval = 10
    OnTimer = ClearNotifyWindowsTimer
    Left = 256
    Top = 80
  end
  object Popup: TPopupMenu
    Images = PngImageList1
    OnPopup = PopupPopup
    Left = 80
    Top = 64
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000000970485973000001BB000001
          BB013AECE3E20000001974455874536F667477617265007777772E696E6B7363
          6170652E6F72679BEE3C1A0000030B4944415478DA75934F685C5514C67FE7BD
          372F3393649C71266982893151134C8442D5D024DD480A85BAD14D624BC152C1
          EE745115A46295125B5B17D28D453745ADDA22168AD988D2D22E145A1B414C6B
          4A12A419329924267432999937EFDDEB7D135A89E8E51EBEC3E37DDFF9778F68
          ADB9B1BF65A431933E56DF90E8B42C11B1402C412444089DDA3783CA10561756
          66EF2E2EBFB5ED4CEEBCFCF2D29691B6EEEE73D5950296A5B02216B62358FF61
          621BB443311BCFAF63EAE7DF4765EA50EF745CDC2EB7B99DD8D69D04B94954FE
          16E2AFFD0F7903FD0ACC4DAFCE48F6C87625A5758976F7937AF953368E46ADCC
          519DF89260F28221F32FB22230562C395AE6DF1BD0E29570B774D0B0FB0D9CD6
          5E249EE2DE5173D7F0AF8CC17A7E1339442F7091DCD1016DFBE54DE9DAA956DC
          279F23F2CC01133A02D522C1D531AA5397EE9343AC4A1DB23036A81D55C6EDD8
          4A6CE721D4E22DD4FC046AE647ECA6C7883CFB0E927EDC889458FF622FD5C5B9
          FB22DA8D21F9F70775442AB89D4F131F3DFD4FEAD9EBB5A852F90B6BF769ACA6
          27F0EFDCE0EE99570C394055353A1647168F0F6AD7F6B0E3F5388FEEC06EE9C3
          E97B019C28786B54BED98F0A1C627B3F03DBA5307E82E215D35C23200DA1C007
          433AEA7A9B466525DB71868F9AD47B08B213AC9D3D48E4A97DC4875F45159698
          3F324CE0299C643DB2747248C7A2D51AD9E9D985D5DC8B9EFCDA4410DC91B348
          2446F1E2BB947EBB4CE6F0E55A79D9B7874D2F1688641A90E50F779852AAD80F
          B4E0EEF9B6F676839B17297F3F86D37F90BA8103947F1D67F5ABC364DEFC0E27
          DD46FEE3D758BBFE036E73A329E1E4906A4C04226E14F7C50B104DE25D3D45E9
          A7CFB1DA0768DC730A3F3FCBC2F1E749ED3B417CDB2E56C73F61E9FC47D43D94
          D072FBF5DEE9877B525D96ADF155141D6DC5CBFE511B55A0A3441EE937E50414
          272E6167BA70321D784B392A7FDE443FA8666ACBD4BDBDEF9C43D990FC4D2F2D
          1C55D8EDB061A1AFFC0D339D26DE962477E7F6A8DC5BE74453FA58229DEC1433
          1D15989F94B9C6B40A7D33731DFAC6045DAE14660BCB1BEBFC372B93740B9F98
          4C370000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000026B4944415478DA9D93DF4B935118C7BFCFFBEE75BA74EE
          261776A75231E826A290409390685B458508051285DD84825A506E36560A5DF5
          0718A3125BBF2842DDAC6E6A416474D1953FA88C2E4450A2B5D96C3FDFD373DE
          B6854EBAE81C0ECFCBF37ECFE79CF3FCA00ACFC498D56C3AAC0B013909FF1E82
          17F15488104F65C7A9E6EA3371FDC85E64723943200144852F468A52801C9AAA
          E2D2D83B90CD1716C18E66F85F2D16376B0AC1A428C8EA3A32BAF8BB2B0F90CB
          B7BF16274722208B372412D79C2557DD3410C646FEF51A2AF784C4AF41276667
          662048E193816DDB77A0C21B86F47FFDB4C87E137491412E9744962D840E87C3
          61688A80F9F92F207ED7BDE0283CFD9E2260D700A1A50150D556F4B63C413213
          3740F5F57505C004035C58585800292A4CAA02BBDDCE3F4390FE463F61F8742F
          46DEDC80464E5C3CF014A96C145B6A6BD602969796F806268CDEB9859EBE0B06
          608FD98D342727D0E9C3B7C40CC63F3C82196EF41F1C83C54679403F03865C88
          46A39C02151A07A1B2B212159E103EF64D21967D0F4DB8F0F27337766E3D8507
          537761A5560CB6BF80C53B09323320C980C4CF15809F703B10C0F9AE2E706C10
          E91EC2F4F25B64537FA2CE99452CDA80F8F73AF8DB9EAF05A4D3ACE22C949954
          C34A4063B91B394EFA99361876761EA84A1F87EFC46303683CA100281469E0E6
          30CE769E3300D2BF8F83D8D9014CCF01D5C976788FDD2FD681D410F782581D74
          9514091718A47FB797D0D40C6C5E6DC3E5A30F4B3464BD121631FFA11240B56F
          121BF9D76BA8BC271829ABB23565723A64D9731B187DA0A9C4BD006319AD90EF
          56C1566A34AE97F4CA8FD7B27F1A240CFF3762BF0192C3100CD81F136E000000
          0049454E44AE426082}
        Name = 'PngImage1'
        Background = clMenu
      end>
    Left = 80
    Top = 96
    Bitmap = {}
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 80
    Top = 128
  end
end
