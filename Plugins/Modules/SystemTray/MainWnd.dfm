object MainForm: TMainForm
  Left = 0
  Top = 0
  Width = 293
  Height = 195
  Caption = 'Memory Monitor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Background: TImage32
    Left = 0
    Top = 0
    Width = 277
    Height = 159
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    PopupMenu = MenuPopup
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    OnMouseDown = BackgroundMouseDown
    OnMouseMove = BackgroundMouseMove
    OnMouseUp = BackgroundMouseUp
    OnMouseLeave = BackgroundMouseLeave
    object lb_servicenotrunning: TLabel
      Left = 0
      Top = 0
      Width = 277
      Height = 159
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      BiDiMode = bdLeftToRight
      Caption = 'SystemTray.service not running!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsUnderline]
      ParentBiDiMode = False
      ParentFont = False
      Transparent = True
      Visible = False
    end
    object sb_left: TSharpEButton
      Left = 0
      Top = 0
      Width = 22
      Height = 16
      SkinManager = SkinManager
      AutoSize = False
      Visible = False
      OnClick = sb_leftClick
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Glyph32.Data = {
        1000000010000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000020000000900000000000000000000000000000000
        000000020000000E000000000000000000000000000000000000000000000000
        000000020000000D000000180000001000000000000000000000000700000017
        000000190000001900000000000000000000000000000000000000010D0E0E08
        0D0E0E161C1C1C40404141920D0D0C100C0C0C080707071B0505052F1B1B1B3F
        404141920A0B0B1900000000000000000000000026262606252525161A1A1A33
        3B3F3D90474A49F6474A49F11B1B1B1F1212122D141414323B3D3D8C474A49F7
        484B4AF423222319000000003E3E3E023E3D3D101E1D1D2F3D3D3E714C4F4EE8
        717574F1FCFCFCFF4C504EF61D1D1D2F373A3A684A4C4CE4686C69F3F8F9F9FF
        4B4E4DF73B3B3A19565556112929292F454845555A5E5BCC6C6F6EEDEEEFEEFE
        FCFDFCFFFBFBFBFF575A59FA565A59C2626664F3EAEBEBFEFCFDFCFFFBFBFBFF
        555857F7515151196D6E6D19676B6AAD747876F0EAECEBFBFAFAFAFFF1F4F2FF
        F0F1F1FFFBFBFBFF636766FDE6E7E6FBF9FAFAFFF1F4F2FFF0F1F1FFFBFBFBFF
        606462F769696A19858585196F7573BD7C8180F5D3D6D4FAF0F2F1FFE4E9E7FF
        DDE2DFFFFBFCFCFF707473FBCED1CFFAF0F3F2FFE6EAE8FFDDE2E0FFFBFCFCFF
        6A6E6DF7818181199D9D9D029C9D9C127276756E7F8382D9A8AEABF1EFF1F0FF
        F9FAF9FFFEFEFEFF757B79FA7C817FD6919796F6EDEFEEFFF9FAFAFFFEFEFEFF
        737976F7989898190000000000000000B3B4B308B4B3B416818583888C9291EF
        C6CBC9F6F9FAF9FF808583F7B1B2B2199CA19E6589908DEEACB0AFF8F9FAF9FF
        7D8381F7B0B0B019000000000000000000000000CBCBCB01CACBCB0CC1C1C120
        8C9390A4979E9CF9979D9AF4C9C9CA17C9C9C919BDC5BE20AAAFAD8C979E9CF9
        7C817FF8C7C7C8190000000000000000000000000000000000000000E2E2E202
        E1E1E211C2C7C2317E8382BDE1E1E111E1E1E003E0E1E10EE0DFE018C1C6C630
        7E8382BDDFE0DF19000000000000000000000000000000000000000000000000
        00000000F9F9F806F8F9F916F8F9F9110000000000000000F8F7F703F8F7F70F
        F7F7F719F7F7F719000000000000000000000000000000000000000000000000
        000000000000000000000000FFFFFF0700000000000000000000000000000000
        FFFFFF01FFFFFF0D000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000}
      Layout = blGlyphLeft
      Margin = 0
      DisabledAlpha = 100
      AutoPosition = False
      GlyphResize = False
      GlyphSpacing = 0
    end
    object sb_right: TSharpEButton
      Left = 256
      Top = 0
      Width = 22
      Height = 16
      SkinManager = SkinManager
      AutoSize = False
      Visible = False
      OnClick = sb_rightClick
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Glyph32.Data = {
        1000000010000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000E0000000200000000000000000000000000000000
        0000000900000002000000000000000000000000000000000000000000000000
        0000000000000000000000190000001900000017000000070000000000000000
        00000010000000180000000D0000000200000000000000000000000000000000
        00000000000000000A0B0B19404141921B1B1B3F0505052F0707071B0C0C0C08
        0D0D0C10404141921C1C1C400D0E0E160D0E0E08000000010000000000000000
        000000000000000023222319484B4AF4474A49F73B3D3D8C141414321212122D
        1B1B1B1F474A49F1474A49F63B3F3D901A1A1A33252525162626260600000000
        00000000000000003B3B3A194B4E4DF7F8F9F9FF686C69F34A4C4CE4373A3A68
        1D1D1D2F4C504EF6FCFCFCFF717574F14C4F4EE83D3D3E711E1D1D2F3E3D3D10
        3E3E3E020000000051515119555857F7FBFBFBFFFCFDFCFFEAEBEBFE626664F3
        565A59C2575A59FAFBFBFBFFFCFDFCFFEEEFEEFE6C6F6EED5A5E5BCC45484555
        2929292F5655561169696A19606462F7FBFBFBFFF0F1F1FFF1F4F2FFF9FAFAFF
        E6E7E6FB636766FDFBFBFBFFF0F1F1FFF1F4F2FFFAFAFAFFEAECEBFB747876F0
        676B6AAD6D6E6D19818181196A6E6DF7FBFCFCFFDDE2E0FFE6EAE8FFF0F3F2FF
        CED1CFFA707473FBFBFCFCFFDDE2DFFFE4E9E7FFF0F2F1FFD3D6D4FA7C8180F5
        6F7573BD8585851998989819737976F7FEFEFEFFF9FAFAFFEDEFEEFF919796F6
        7C817FD6757B79FAFEFEFEFFF9FAF9FFEFF1F0FFA8AEABF17F8382D97276756E
        9C9D9C129D9D9D02B0B0B0197D8381F7F9FAF9FFACB0AFF889908DEE9CA19E65
        B1B2B219808583F7F9FAF9FFC6CBC9F68C9291EF81858388B4B3B416B3B4B308
        0000000000000000C7C7C8197C817FF8979E9CF9AAAFAD8CBDC5BE20C9C9C919
        C9C9CA17979D9AF4979E9CF98C9390A4C1C1C120CACBCB0CCBCBCB0100000000
        0000000000000000DFE0DF197E8382BDC1C6C630E0DFE018E0E1E10EE1E1E003
        E1E1E1117E8382BDC2C7C231E1E1E211E2E2E202000000000000000000000000
        0000000000000000F7F7F719F7F7F719F8F7F70FF8F7F7030000000000000000
        F8F9F911F8F9F916F9F9F8060000000000000000000000000000000000000000
        0000000000000000FFFFFF0DFFFFFF0100000000000000000000000000000000
        FFFFFF0700000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000}
      Layout = blGlyphLeft
      Margin = -3
      DisabledAlpha = 100
      AutoPosition = False
      GlyphResize = False
      GlyphSpacing = 0
    end
  end
  object MenuPopup: TPopupMenu
    AutoPopup = False
    Left = 168
    Top = 120
    object Settings1: TMenuItem
      Caption = 'Settings'
      OnClick = Settings1Click
    end
  end
  object SkinManager: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    ComponentSkins = []
    HandleUpdates = False
    Left = 112
    Top = 80
  end
end
