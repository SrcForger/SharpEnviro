object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Taskbar'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ses_maxall: TSharpEButton
    Left = 24
    Top = 0
    Width = 24
    Height = 20
    SkinManager = SystemSkinManager
    AutoSize = True
    OnClick = ses_maxallClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TLinearResampler'
    Glyph32.Data = {
      100000001000000004733AFF04733AFF04733AFF04733AFF04733AFF04733AFF
      04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF
      04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF
      04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF
      04733AFF04733AFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733A2D
      0F7941F689CCA9FF7FC8A2FF0E7941F604733A2DFFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733A0C04743AE1
      73BD97FE74C69CFF6CC396FF5CB386FE04743AE104733A0CFFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004743BAC4FA679FA
      93D3B2FF4BB67FFF42B279FF6BC296FF3B9C6AF904743AABFFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733A65298B58F6A2D8BCFF
      62BE8FFF4FB782FF45B37BFF1AA25CFF71C49AFF1D844FF504733A65FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733A2D0D7840F69ED4B8FF7CCAA2FF
      5CBD8BFF53BB85FF37B173FF08A153FF2CAF6CFF6EC397FF0A773EF604733A2D
      FFFFFF00FFFFFF00FFFFFF0004733A0C04743AE183C5A3FE99D5B6FF69C395FF
      5FC18FFF56C18AFF1CAE63FF0AAA58FF0BAB59FF4DC286FF55B584FE04753BE1
      04733A0CFFFFFF00FFFFFF0004743BAC57A97FF9B0DFC7FF75C79DFF6AC697FF
      60C692FF41BE7EFF0CB05CFF0DB35EFF0DB45FFF0FB460FF6ACF9BFF359D68F8
      04753BABFFFFFF0004733A65288B58F6B3DFC9FFB9E2CDFFB5E2CBFFB1E2C9FF
      5FC992FF18B665FF0EB861FF0FBB64FF83DCAFFF83DCAFFF82DBAEFF7CD5A8FF
      19844DF504733A6504753BC504733AFF04733AFF04733AFF04773CF7AFE3C8FF
      47C384FF0EB861FF10BE66FF11C369FF84E1B2FF057A3EF704733AFF04733AFF
      04733AFF04763BC5FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733AFFADE2C7FF
      2EBD74FF0FBA63FF11C168FF13C86CFF85E6B5FF04733AFFFFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733AFFA9E1C5FF
      1BB668FF0EB962FF10C067FF12C66BFF84E3B3FF04733AFFFFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733AFFA5DEC1FF
      14B161FF0DB560FF0FBB63FF10BF66FF83DEB0FF04733AFFFFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733AFFA1DCBEFF
      81D3A9FF81D5AAFF81D7ACFF82D9ADFF82DAADFF04733AFFFFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004743AE804733AFF
      04733AFF04733AFF04733AFF04733AFF04733AFF04753BE8FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00}
    Layout = blGlyphLeft
    Margin = -1
    DisabledAlpha = 100
    AutoPosition = True
    GlyphResize = True
    GlyphSpacing = 0
  end
  object ses_minall: TSharpEButton
    Left = 0
    Top = 0
    Width = 24
    Height = 20
    SkinManager = SystemSkinManager
    AutoSize = True
    OnClick = ses_minallClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TLinearResampler'
    Glyph32.Data = {
      1000000010000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0004743AE804733AFF
      04733AFF04733AFF04733AFF04733AFF04733AFF04743AE8FFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733AFFAEDEC6FF
      AADCC2FFA4DABEFF9FD8BBFF9AD6B7FF93D3B2FF04733AFFFFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733AFFB0DFC7FF
      5DBD8CFF54B985FF49B57DFF3EB076FF8FD1AFFF04733AFFFFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733AFFB1DFC7FF
      5EBE8DFF55BA86FF4AB57EFF3FB176FF8ACFACFF04733AFFFFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733AFFB0DFC7FF
      5EBE8DFF54B985FF49B57DFF3EB076FF85CDA9FF04733AFFFFFFFF00FFFFFF00
      FFFFFF00FFFFFF0004753BC504733AFF04733AFF04733AFF04763BF7AFDEC6FF
      5BBC8BFF52B884FF47B47CFF35AD70FF7FCBA4FF04763BF704733AFF04733AFF
      04733AFF04753BC504733A65278956F6ACDCC4FFB2DFC8FFB0DEC7FFACDDC4FF
      58BD89FF4EBB84FF43B87CFF0FA458FF7FCEA5FF7ECDA4FF7ECCA4FF78C79FFF
      18824BF504733A65FFFFFF0004743BAC4DA478F89ED7BAFF61C090FF5BC18DFF
      55C18AFF3AB978FF11AD5EFF0BAB59FF0AAA59FF0CA958FF68C797FF349A65F8
      04743BABFFFFFF00FFFFFF0004733A0C04743AE173BF98FE87D2ACFF56C38CFF
      30BA74FF0CB15DFF0DB45FFF0DB45FFF0DB35EFF4EC589FF55B784FE04753BE1
      04733A0CFFFFFF00FFFFFF00FFFFFF0004733A2D0B773EF68FD3B0FF5BC891FF
      0DB45FFF0FB962FF0FBC65FF10BD65FF32C57BFF71CE9FFF0A783FF604733A2D
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733A65238A56F578D2A5FF
      1CBD6BFF11C067FF12C56AFF1FC973FF78DBA8FF1E8952F504733A65FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004753BAC3DA36FF9
      69D59EFF12C469FF14CB6EFF6CE0A5FF3FA872F904763CABFFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733A0C04763BE1
      5DBF8DFE4CD18DFF4ED590FF5FC592FE04763CE104733A0CFFFFFF00FFFFFF00
      FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0004733A2D
      0E7A42F674D1A2FF75D3A3FF0E7B42F604733A2DFFFFFF00FFFFFF00FFFFFF00
      FFFFFF00FFFFFF0004733AFF04733AFF04733AFF04733AFF04733AFF04733AFF
      04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF
      04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF
      04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF04733AFF
      04733AFF04733AFF}
    Layout = blGlyphLeft
    Margin = -1
    DisabledAlpha = 100
    AutoPosition = True
    GlyphResize = True
    GlyphSpacing = 0
  end
  object MenuPopup: TPopupMenu
    Left = 168
    Top = 96
    object Settings1: TMenuItem
      Caption = 'Settings'
      OnClick = Settings1Click
    end
  end
  object SystemSkinManager: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    ComponentSkins = [scButton, scTaskItem]
    HandleUpdates = False
    Left = 176
    Top = 56
  end
  object DDHandler: TJvDragDrop
    DropTarget = Owner
    Left = 144
    Top = 56
  end
  object DropTarget: TJvDropTarget
    OnDragOver = DropTargetDragOver
    Left = 112
    Top = 56
  end
end
