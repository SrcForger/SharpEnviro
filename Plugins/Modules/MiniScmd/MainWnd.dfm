object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Sharp Menu'
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
  object btn_select: TSharpEButton
    Left = 104
    Top = 0
    Width = 25
    Height = 25
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnClick = btn_selectClick
    OnMouseDown = btn_selectMouseDown
    OnMouseUp = btn_selectMouseUp
    Glyph32FileName = 'application_osx_terminal.png'
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TLinearResampler'
    Glyph32.Data = {
      1000000010000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00A9A29D99C2BEBAFAC8C3BEFFC8C1BDFFC4BFB9FFC0B9B4FF
      BCB5B0FFB8B1AAFFB4ABA4FFAFA69EFFAA9F97FFA59A91FFA0948AFF9B8E84FF
      93867BFA7D726A6EC2BEBAFE494ED3FF16ACE2FF3DAF41FFE1DBD6FFE1DBD6FF
      E1DBD6FFE1DBD6FFE1DBD6FFE1DBD6FFE1DBD6FFE1DBD6FFE1DBD6FFE1DCD7FF
      EDEAE7FF8A7A6D93C9C2BEFFB7BAF1FF93E4F6FFB1E5B3FFEDE9E6FFEDE9E6FF
      EDE9E6FFEDE9E6FFEDE9E6FFEDE9E6FFEDE9E6FFEDE9E6FFEDE9E6FFEDE9E6FF
      F5F4F2FF85766894C4BFB9FF303030FF313131FF323232FF333333FF343434FF
      353535FF363636FF383838FF3A3A3AFF3B3B3BFF3C3C3CFF3E3E3EFF404040FF
      424242FF7E6F6394C2BDB8FF333333FF1F1F1FFF202020FF212121FF232323FF
      242424FF252525FF272727FF292929FF2B2B2BFF2C2C2CFF2E2E2EFF303030FF
      454545FF8E7E7294C0B9B4FF333333FF1F1F1FFFCFCFCFFFA7A7A7FF232323FF
      242424FF252525FF272727FF292929FF2B2B2BFF2C2C2CFF2E2E2EFF303030FF
      454545FF8A7A6D94BDB6B1FF383838FF242424FF252525FFDEDEDEFF737373FF
      292929FF2B2B2BFF2C2C2CFF2E2E2EFF303030FF313131FF333333FF343434FF
      4A4A4AFF84756794B9B1ABFF3C3C3CFF282828FFD1D1D1FFACACACFF2D2D2DFF
      2E2E2EFF303030FF313131FF333333FF353535FF363636FF373737FF393939FF
      4D4D4DFF7D6E6294B5ADA6FF414141FF2E2E2EFF2F2F2FFF303030FF323232FF
      333333FF353535FF353535FF373737FF393939FF3A3A3AFF3C3C3CFF3C3C3CFF
      515151FF776A5E94B1A8A0FF464646FF323232FF333333FF353535FF363636FF
      383838FF393939FF3A3A3AFF3B3B3BFF3D3D3DFF3E3E3EFF3F3F3FFF404040FF
      545454FF72655A94ADA39BFF4A4A4AFF373737FF383838FF393939FF3B3B3BFF
      3C3C3CFF3E3E3EFF3E3E3EFF404040FF414141FF414141FF434343FF444444FF
      565656FF6D605594A89E95FF4D4D4DFF3C3C3CFF3C3C3CFF3D3D3DFF3E3E3EFF
      404040FF414141FF424242FF434343FF444444FF454545FF454545FF474747FF
      595959FF685C52949C9289F2515151FF525252FF535353FF545454FF555555FF
      565656FF565656FF575757FF585858FF595959FF5A5A5AFF5B5B5BFF5B5B5BFF
      5C5C5CFF60554B8C81776E6F90847BD292847BDF8E8175DF8B7D71DF87786CDF
      837468DF7E6F64DF796C60DF75685CDF706359DF6D6055DF685C52DF655950DF
      60544BD2544B4340FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00}
    Layout = blGlyphLeft
    AutoPosition = True
  end
  object edit: TSharpEEdit
    Left = 3
    Top = 0
    Width = 95
    Height = 25
    AutoSize = True
    SkinManager = SharpESkinManager1
    AutoPosition = True
    OnKeyUp = editKeyUp
    OnKeyDown = editKeyDown
  end
  object SharpESkinManager1: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    ComponentSkins = [scButton, scEdit]
    HandleUpdates = False
    Left = 192
    Top = 72
  end
end
