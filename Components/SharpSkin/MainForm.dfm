object Form1: TForm1
  Left = 0
  Top = 0
  Width = 845
  Height = 755
  Caption = 'SharpSkin - Beta 0.7.0.4'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object previewpanel: TPanel
    Left = 576
    Top = 36
    Width = 261
    Height = 670
    Align = alRight
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object SkinButton1: TSharpEButton
      Left = 96
      Top = 8
      Width = 81
      Height = 41
      AutoSize = False
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Layout = blGlyphLeft
      Margin = -1
      DisabledAlpha = 100
      Caption = 'Button'
      AutoPosition = False
      GlyphResize = False
    end
    object SkinCheckBox1: TSharpECheckBox
      Left = 16
      Top = 52
      Width = 49
      Height = 25
      Checked = False
      Caption = 'Enabled'
      AutoSize = True
    end
    object SkinButton2: TSharpEButton
      Left = 32
      Top = 8
      Width = 57
      Height = 25
      AutoSize = False
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Layout = blGlyphLeft
      Margin = -1
      DisabledAlpha = 100
      Caption = 'Button'
      AutoPosition = False
      GlyphResize = False
    end
    object SkinButton3: TSharpEButton
      Left = 8
      Top = 8
      Width = 16
      Height = 16
      AutoSize = False
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Layout = blGlyphLeft
      Margin = -1
      DisabledAlpha = 100
      AutoPosition = False
      GlyphResize = False
    end
    object SkinCheckBox2: TSharpECheckBox
      Left = 72
      Top = 52
      Width = 57
      Height = 25
      Checked = True
      Caption = 'Disabled'
      Enabled = False
      AutoSize = True
    end
    object SkinButton4: TSharpEButton
      Left = 184
      Top = 8
      Width = 57
      Height = 25
      Enabled = False
      AutoSize = False
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Layout = blGlyphLeft
      Margin = -1
      DisabledAlpha = 100
      Caption = 'Disabled'
      AutoPosition = False
      GlyphResize = False
    end
    object SkinCheckBox3: TSharpECheckBox
      Left = 128
      Top = 52
      Width = 75
      Height = 25
      Checked = False
      Caption = 'Disabled'
      Enabled = False
      AutoSize = True
    end
    object PBar1: TSharpEProgressBar
      Left = 40
      Top = 136
      Width = 185
      Height = 9
      Min = 0
      Max = 100
      Value = 0
      AutoSize = False
    end
    object PBar2: TSharpEProgressBar
      Left = 40
      Top = 148
      Width = 185
      Height = 9
      Min = 0
      Max = 100
      Value = 50
      AutoSize = False
    end
    object PBar3: TSharpEProgressBar
      Left = 40
      Top = 160
      Width = 185
      Height = 9
      Min = 0
      Max = 100
      Value = 100
      AutoSize = False
    end
    object PBar4: TSharpEProgressBar
      Left = 40
      Top = 176
      Width = 185
      Height = 17
      Min = 0
      Max = 100
      Value = 0
      AutoSize = False
    end
    object PBar5: TSharpEProgressBar
      Left = 40
      Top = 200
      Width = 185
      Height = 17
      Min = 0
      Max = 100
      Value = 50
      AutoSize = False
    end
    object PBar6: TSharpEProgressBar
      Left = 40
      Top = 224
      Width = 185
      Height = 17
      Min = 0
      Max = 100
      Value = 100
      AutoSize = False
    end
    object MiniThrobber1: TSharpEMiniThrobber
      Left = 38
      Top = 248
      Width = 7
      Height = 9
      AutoSize = True
    end
    object Label12: TLabel
      Left = 64
      Top = 248
      Width = 64
      Height = 11
      Caption = '(Mini Throbber)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Small Fonts'
      Font.Style = []
      ParentFont = False
    end
    object SkinRadioBox1: TSharpERadioBox
      Left = 16
      Top = 76
      Width = 49
      Height = 25
      Checked = False
      GroupIndex = 0
      Caption = 'Enabled'
      AutoSize = True
    end
    object SkinRadioBox2: TSharpERadioBox
      Left = 128
      Top = 76
      Width = 57
      Height = 25
      Checked = True
      GroupIndex = 1
      Caption = 'Disabled'
      Enabled = False
      AutoSize = True
    end
    object SkinRadioBox3: TSharpERadioBox
      Left = 192
      Top = 76
      Width = 65
      Height = 25
      Checked = False
      GroupIndex = 1
      Caption = 'Disabled'
      Enabled = False
      AutoSize = True
    end
    object SkinRadioBox4: TSharpERadioBox
      Left = 72
      Top = 76
      Width = 49
      Height = 25
      Checked = False
      GroupIndex = 0
      Caption = 'Enabled'
      AutoSize = True
    end
    object SharpELabel1: TSharpELabel
      Left = 8
      Top = 272
      Width = 46
      Height = 13
      Caption = 'SmallFont'
      Transparent = True
      LabelStyle = lsSmall
    end
    object SharpELabel2: TSharpELabel
      Left = 72
      Top = 272
      Width = 58
      Height = 13
      Caption = 'MediumFont'
      Transparent = True
      LabelStyle = lsMedium
    end
    object SharpELabel3: TSharpELabel
      Left = 160
      Top = 272
      Width = 36
      Height = 13
      Caption = 'BigFont'
      Transparent = True
      LabelStyle = lsBig
    end
    object SharpETaskItem1: TSharpETaskItem
      Left = 160
      Top = 336
      Width = 89
      Height = 25
      AutoSize = True
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Glyph32.Data = {
        10000000100000009CA5A20E98A09D87949C99EE8D9592FB88908DFB838B88FB
        7E8683FB7A817EFB757D79FB707874FB6B736FFB666E6AFB616965FB5E6562EC
        575E5A835158540C9DA6A392B1B6B4FAD5D7D7FFDDDEDDFFDCDEDDFFDCDDDDFF
        DCDDDDFFDCDDDDFFDCDDDDFFDCDDDDFFDCDDDDFFD9DBDBFFCBCDCCFFB1B4B2FF
        727774F9525955889DA6A3F4D5D7D6FF333634FF070808FF070808FF070808FF
        070808FF070808FF070808FF070808FF070808FF060707FF060707FF2D312FFF
        969998FF525955F09CA5A2FCD7D8D7FF0D100FFF9BBFB1FF98BEAFFF97BDAEFF
        94BCACFF92BAAAFF90B9A9FF8EB8A8FF8DB6A5FF8AB5A4FF87B3A2FF000000FF
        979B9AFF515854FF9CA5A2FCD7D8D7FF0C0E0DFF749084FF719084FF708E82FF
        6D8D80FF6B8C7FFF698B7EFF67897CFF65887BFF648779FF608576FF000000FF
        939896FF515854FF9CA5A2FCD7D8D7FF0A0C0BFF81A697FF7FA495FF7DA294FF
        79A292FF76A090FF749F8EFF729D8CFF699885FF548975FF417C65FF000000FF
        909593FF515854FF9CA5A2FCD7D8D7FF090B0AFF59756AFFD4DED9FF6C847AFF
        527165FF517164FF4D6E61FF365E4EFF2B5646FF2B5646FF2C5746FF000000FF
        8D9291FF515854FF9CA5A2FCD7D8D7FF080909FF5F8273FF8AA399FFDBE3E0FF
        C6D2CDFF507869FF376553FF32614EFF32624FFF32624FFF32634FFF000000FF
        8A8F8DFF515854FF9CA5A2FCD7D8D7FF060807FF3D564CFF556A61FFCBD3CFFF
        CDD6D3FF254537FF234336FF234436FF234436FF234536FF234537FF000000FF
        878C8AFF515854FF9CA5A2FCD7D8D7FF060707FF3A5A4CFFC8D1CEFF647D73FF
        274A3BFF264A3BFF264A3BFF264A3BFF274B3CFF274B3CFF274C3CFF000000FF
        838987FF515854FF9CA5A2FCD7D8D7FF060707FF1D3329FF1A3127FF193027FF
        193127FFF1F3F2FFF1F3F2FFF1F3F2FFEAEDECFF1A3228FF1A3228FF000000FF
        818684FF515854FF9CA5A2FCD7D8D7FF060706FF1A3126FF1A3227FF1B3227FF
        1B3227FF1B3328FF1B3328FF1B3428FF1C3429FF1C3429FF1C3529FF000000FF
        7D8381FF515854FF9CA5A2FCD7D8D7FF060606FF111F18FF111F18FF111F18FF
        111F18FF111F18FF111F18FF111F18FF112018FF112019FF112019FF000000FF
        7A807EFF515854FF9DA6A3F6D6D8D7FF232423FF020302FF010201FF010201FF
        010201FF010201FF010201FF010201FF010201FF010201FF010201FF121413FF
        727976FF525955F39EA6A39AB4B9B7FBCCCECDFFBEC1C0FFAEB1B0FF9DA1A0FF
        959998FF909593FF8C918FFF878C8BFF828786FF7E8381FF797F7DFF737A77FF
        606663F9525955909CA5A21498A09D9A929A97F68D9592FC878F8CFC828A87FC
        7E8582FC79807DFC747C78FC707874FC6B736FFC666E6AFC606864FC5B625FF5
        575E5A9751585411}
      Layout = blGlyphLeft
      Margin = -1
      DisabledAlpha = 100
      Caption = 'Mini'
      AutoPosition = False
      Down = False
      State = tisMini
      Flashing = False
      FlashState = False
    end
    object SharpETaskItem2: TSharpETaskItem
      Left = 8
      Top = 336
      Width = 89
      Height = 25
      AutoSize = True
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Glyph32.Data = {
        10000000100000009CA5A20E98A09D87949C99EE8D9592FB88908DFB838B88FB
        7E8683FB7A817EFB757D79FB707874FB6B736FFB666E6AFB616965FB5E6562EC
        575E5A835158540C9DA6A392B1B6B4FAD5D7D7FFDDDEDDFFDCDEDDFFDCDDDDFF
        DCDDDDFFDCDDDDFFDCDDDDFFDCDDDDFFDCDDDDFFD9DBDBFFCBCDCCFFB1B4B2FF
        727774F9525955889DA6A3F4D5D7D6FF333634FF070808FF070808FF070808FF
        070808FF070808FF070808FF070808FF070808FF060707FF060707FF2D312FFF
        969998FF525955F09CA5A2FCD7D8D7FF0D100FFF9BBFB1FF98BEAFFF97BDAEFF
        94BCACFF92BAAAFF90B9A9FF8EB8A8FF8DB6A5FF8AB5A4FF87B3A2FF000000FF
        979B9AFF515854FF9CA5A2FCD7D8D7FF0C0E0DFF749084FF719084FF708E82FF
        6D8D80FF6B8C7FFF698B7EFF67897CFF65887BFF648779FF608576FF000000FF
        939896FF515854FF9CA5A2FCD7D8D7FF0A0C0BFF81A697FF7FA495FF7DA294FF
        79A292FF76A090FF749F8EFF729D8CFF699885FF548975FF417C65FF000000FF
        909593FF515854FF9CA5A2FCD7D8D7FF090B0AFF59756AFFD4DED9FF6C847AFF
        527165FF517164FF4D6E61FF365E4EFF2B5646FF2B5646FF2C5746FF000000FF
        8D9291FF515854FF9CA5A2FCD7D8D7FF080909FF5F8273FF8AA399FFDBE3E0FF
        C6D2CDFF507869FF376553FF32614EFF32624FFF32624FFF32634FFF000000FF
        8A8F8DFF515854FF9CA5A2FCD7D8D7FF060807FF3D564CFF556A61FFCBD3CFFF
        CDD6D3FF254537FF234336FF234436FF234436FF234536FF234537FF000000FF
        878C8AFF515854FF9CA5A2FCD7D8D7FF060707FF3A5A4CFFC8D1CEFF647D73FF
        274A3BFF264A3BFF264A3BFF264A3BFF274B3CFF274B3CFF274C3CFF000000FF
        838987FF515854FF9CA5A2FCD7D8D7FF060707FF1D3329FF1A3127FF193027FF
        193127FFF1F3F2FFF1F3F2FFF1F3F2FFEAEDECFF1A3228FF1A3228FF000000FF
        818684FF515854FF9CA5A2FCD7D8D7FF060706FF1A3126FF1A3227FF1B3227FF
        1B3227FF1B3328FF1B3328FF1B3428FF1C3429FF1C3429FF1C3529FF000000FF
        7D8381FF515854FF9CA5A2FCD7D8D7FF060606FF111F18FF111F18FF111F18FF
        111F18FF111F18FF111F18FF111F18FF112018FF112019FF112019FF000000FF
        7A807EFF515854FF9DA6A3F6D6D8D7FF232423FF020302FF010201FF010201FF
        010201FF010201FF010201FF010201FF010201FF010201FF010201FF121413FF
        727976FF525955F39EA6A39AB4B9B7FBCCCECDFFBEC1C0FFAEB1B0FF9DA1A0FF
        959998FF909593FF8C918FFF878C8BFF828786FF7E8381FF797F7DFF737A77FF
        606663F9525955909CA5A21498A09D9A929A97F68D9592FC878F8CFC828A87FC
        7E8582FC79807DFC747C78FC707874FC6B736FFC666E6AFC606864FC5B625FF5
        575E5A9751585411}
      Layout = blGlyphLeft
      Margin = -1
      DisabledAlpha = 100
      Caption = 'Compact'
      AutoPosition = False
      Down = False
      State = tisCompact
      Flashing = False
      FlashState = False
    end
    object SharpETaskItem3: TSharpETaskItem
      Left = 8
      Top = 368
      Width = 89
      Height = 25
      AutoSize = True
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Glyph32.Data = {
        10000000100000009CA5A20E98A09D87949C99EE8D9592FB88908DFB838B88FB
        7E8683FB7A817EFB757D79FB707874FB6B736FFB666E6AFB616965FB5E6562EC
        575E5A835158540C9DA6A392B1B6B4FAD5D7D7FFDDDEDDFFDCDEDDFFDCDDDDFF
        DCDDDDFFDCDDDDFFDCDDDDFFDCDDDDFFDCDDDDFFD9DBDBFFCBCDCCFFB1B4B2FF
        727774F9525955889DA6A3F4D5D7D6FF333634FF070808FF070808FF070808FF
        070808FF070808FF070808FF070808FF070808FF060707FF060707FF2D312FFF
        969998FF525955F09CA5A2FCD7D8D7FF0D100FFF9BBFB1FF98BEAFFF97BDAEFF
        94BCACFF92BAAAFF90B9A9FF8EB8A8FF8DB6A5FF8AB5A4FF87B3A2FF000000FF
        979B9AFF515854FF9CA5A2FCD7D8D7FF0C0E0DFF749084FF719084FF708E82FF
        6D8D80FF6B8C7FFF698B7EFF67897CFF65887BFF648779FF608576FF000000FF
        939896FF515854FF9CA5A2FCD7D8D7FF0A0C0BFF81A697FF7FA495FF7DA294FF
        79A292FF76A090FF749F8EFF729D8CFF699885FF548975FF417C65FF000000FF
        909593FF515854FF9CA5A2FCD7D8D7FF090B0AFF59756AFFD4DED9FF6C847AFF
        527165FF517164FF4D6E61FF365E4EFF2B5646FF2B5646FF2C5746FF000000FF
        8D9291FF515854FF9CA5A2FCD7D8D7FF080909FF5F8273FF8AA399FFDBE3E0FF
        C6D2CDFF507869FF376553FF32614EFF32624FFF32624FFF32634FFF000000FF
        8A8F8DFF515854FF9CA5A2FCD7D8D7FF060807FF3D564CFF556A61FFCBD3CFFF
        CDD6D3FF254537FF234336FF234436FF234436FF234536FF234537FF000000FF
        878C8AFF515854FF9CA5A2FCD7D8D7FF060707FF3A5A4CFFC8D1CEFF647D73FF
        274A3BFF264A3BFF264A3BFF264A3BFF274B3CFF274B3CFF274C3CFF000000FF
        838987FF515854FF9CA5A2FCD7D8D7FF060707FF1D3329FF1A3127FF193027FF
        193127FFF1F3F2FFF1F3F2FFF1F3F2FFEAEDECFF1A3228FF1A3228FF000000FF
        818684FF515854FF9CA5A2FCD7D8D7FF060706FF1A3126FF1A3227FF1B3227FF
        1B3227FF1B3328FF1B3328FF1B3428FF1C3429FF1C3429FF1C3529FF000000FF
        7D8381FF515854FF9CA5A2FCD7D8D7FF060606FF111F18FF111F18FF111F18FF
        111F18FF111F18FF111F18FF111F18FF112018FF112019FF112019FF000000FF
        7A807EFF515854FF9DA6A3F6D6D8D7FF232423FF020302FF010201FF010201FF
        010201FF010201FF010201FF010201FF010201FF010201FF010201FF121413FF
        727976FF525955F39EA6A39AB4B9B7FBCCCECDFFBEC1C0FFAEB1B0FF9DA1A0FF
        959998FF909593FF8C918FFF878C8BFF828786FF7E8381FF797F7DFF737A77FF
        606663F9525955909CA5A21498A09D9A929A97F68D9592FC878F8CFC828A87FC
        7E8582FC79807DFC747C78FC707874FC6B736FFC666E6AFC606864FC5B625FF5
        575E5A9751585411}
      Layout = blGlyphLeft
      Margin = -1
      DisabledAlpha = 100
      Caption = 'Full'
      AutoPosition = False
      Down = False
      State = tisFull
      Flashing = False
      FlashState = False
    end
    object BarImage: TImage32
      Left = 8
      Top = 408
      Width = 249
      Height = 113
      Bitmap.ResamplerClassName = 'TNearestResampler'
      BitmapAlign = baTopLeft
      Scale = 1.000000000000000000
      ScaleMode = smNormal
      TabOrder = 2
    end
    object DefaultSkin: TMemo
      Left = 168
      Top = 352
      Width = 185
      Height = 89
      Lines.Strings = (
        '<?xml version="1.0" encoding="iso-8859-1"?>'
        '<sharpESkin>'
        '   <sharpbar>'
        '       <dimension>w,31</dimension>'
        '       <fsmod>0,0</fsmod>'
        '       <sbmod>0,0</sbmod>'
        '       <paxoffsets>16,16</paxoffsets>'
        '       <payoffsets>2,2</payoffsets>'
        '       <enablevflip>0</enablevflip>'
        '       <bar>'
        '           <dimension>w,h</dimension>'
        '           <!-- SharpBar Background -->  '
        '       </bar>'
        '       <throbber>'
        '           <location>2,2</location>'
        '           <dimension>16,16</dimension>'
        '           <normal>'
        '              <!-- Normal Throbber State -->       '
        '           </normal>'
        '           <hover>'
        '              <!-- Mouse Hover State --> '
        '           </hover>'
        '           <down>'
        '              <!-- Throbber Down State --> '
        '           </down>'
        '       </throbber>'
        '   </sharpbar>'
        '</sharpESkin>')
      TabOrder = 0
      Visible = False
      WantReturns = False
      WordWrap = False
    end
    object SkinPanel1: TSharpEPanel
      Left = 8
      Top = 104
      Width = 41
      Height = 25
      UseDockManager = False
      TabOrder = 3
      State = pssRaised
      Selected = False
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Layout = blGlyphLeft
      Margin = -1
      HSpacing = 4
      VSpacing = 0
      DisabledAlpha = 100
      Caption = 'Raised'
    end
    object SkinPanel2: TSharpEPanel
      Left = 56
      Top = 104
      Width = 41
      Height = 25
      UseDockManager = False
      TabOrder = 4
      State = pssNormal
      Selected = False
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Layout = blGlyphLeft
      Margin = -1
      HSpacing = 4
      VSpacing = 0
      DisabledAlpha = 100
      Caption = 'Normal'
    end
    object SkinPanel3: TSharpEPanel
      Left = 104
      Top = 104
      Width = 41
      Height = 25
      UseDockManager = False
      TabOrder = 5
      State = pssLowered
      Selected = False
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Layout = blGlyphLeft
      Margin = -1
      HSpacing = 4
      VSpacing = 0
      DisabledAlpha = 100
      Caption = 'Lowered'
    end
    object SkinPanel4: TSharpEPanel
      Left = 152
      Top = 104
      Width = 41
      Height = 25
      UseDockManager = False
      TabOrder = 6
      State = pssNormal
      Selected = True
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Layout = blGlyphLeft
      Margin = -1
      HSpacing = 4
      VSpacing = 0
      DisabledAlpha = 100
      Caption = 'Selected'
    end
    object SharpEEdit1: TSharpEEdit
      Left = 8
      Top = 304
      Width = 100
      Height = 17
      AutoSize = False
      AutoPosition = False
    end
    object Panel1: TPanel
      Left = 5
      Top = 545
      Width = 251
      Height = 120
      Align = alBottom
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 74
        Height = 13
        Alignment = taCenter
        Caption = 'Scheme Colors:'
      end
      object Label2: TLabel
        Left = 48
        Top = 40
        Width = 22
        Height = 13
        Caption = 'Back'
      end
      object Label3: TLabel
        Left = 48
        Top = 56
        Width = 22
        Height = 13
        Caption = 'Dark'
      end
      object Label4: TLabel
        Left = 48
        Top = 72
        Width = 23
        Height = 13
        Caption = 'Light'
      end
      object Label5: TLabel
        Left = 48
        Top = 88
        Width = 22
        Height = 13
        Caption = 'Text'
      end
      object Label6: TLabel
        Left = 136
        Top = 40
        Width = 22
        Height = 13
        Caption = 'Back'
      end
      object Label7: TLabel
        Left = 136
        Top = 56
        Width = 22
        Height = 13
        Caption = 'Dark'
      end
      object Label8: TLabel
        Left = 136
        Top = 72
        Width = 23
        Height = 13
        Caption = 'Light'
      end
      object Label9: TLabel
        Left = 136
        Top = 88
        Width = 22
        Height = 13
        Caption = 'Text'
      end
      object Label10: TLabel
        Left = 16
        Top = 24
        Width = 47
        Height = 13
        Caption = 'Workarea'
      end
      object Label11: TLabel
        Left = 104
        Top = 24
        Width = 44
        Height = 13
        Caption = 'Throbber'
      end
      object WAB: TSharpEColorBox
        Left = 8
        Top = 40
        Width = 35
        Height = 15
        BackgroundColor = clBtnFace
        Color = 3618615
        ColorCode = -4
        CustomScheme = False
        ClickedColorID = ccWorkAreaBack
        OnColorClick = WABColorClick
      end
      object WAD: TSharpEColorBox
        Left = 8
        Top = 56
        Width = 35
        Height = 15
        BackgroundColor = clBtnFace
        Color = 6778222
        ColorCode = -5
        CustomScheme = False
        ClickedColorID = ccWorkAreaDark
        OnColorClick = WABColorClick
      end
      object WAL: TSharpEColorBox
        Left = 8
        Top = 72
        Width = 35
        Height = 15
        BackgroundColor = clBtnFace
        Color = 7368816
        ColorCode = -6
        CustomScheme = False
        ClickedColorID = ccWorkAreaLight
        OnColorClick = WABColorClick
      end
      object WAT: TSharpEColorBox
        Left = 8
        Top = 88
        Width = 35
        Height = 15
        BackgroundColor = clBtnFace
        Color = clBlack
        ColorCode = 0
        CustomScheme = False
        ClickedColorID = ccCustom
        OnColorClick = WABColorClick
      end
      object TRB: TSharpEColorBox
        Left = 96
        Top = 40
        Width = 35
        Height = 15
        BackgroundColor = clBtnFace
        Color = 1250659
        ColorCode = -1
        CustomScheme = False
        ClickedColorID = ccThrobberBack
        OnColorClick = WABColorClick
      end
      object TRD: TSharpEColorBox
        Left = 96
        Top = 56
        Width = 35
        Height = 15
        BackgroundColor = clBtnFace
        Color = 5328199
        ColorCode = -2
        CustomScheme = False
        ClickedColorID = ccThrobberDark
        OnColorClick = WABColorClick
      end
      object TRL: TSharpEColorBox
        Left = 96
        Top = 72
        Width = 35
        Height = 15
        BackgroundColor = clBtnFace
        Color = 13749703
        ColorCode = -3
        CustomScheme = False
        ClickedColorID = ccThrobberLight
        OnColorClick = WABColorClick
      end
      object TRT: TSharpEColorBox
        Left = 96
        Top = 88
        Width = 35
        Height = 15
        BackgroundColor = clBtnFace
        Color = clBlack
        ColorCode = 0
        CustomScheme = False
        ClickedColorID = ccCustom
        OnColorClick = WABColorClick
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 36
    Width = 576
    Height = 670
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
    object xmledit: TJvHLEditor
      Left = 5
      Top = 29
      Width = 566
      Height = 569
      Cursor = crIBeam
      GutterWidth = 30
      RightMarginColor = clSilver
      Completion.DropDownCount = 8
      Completion.Enabled = True
      Completion.ItemHeight = 13
      Completion.Interval = 800
      Completion.ListBoxStyle = lbStandard
      Completion.Templates.Strings = (
        '$WAB==$WorkAreaBack==$WorkAreaBack'
        '$WAD==$WorkAreaDark==$WorkAreaDark'
        '$WAL==$WorkAreaLight==$WorkAreaLight'
        '$WAT==$WorkAreaText==$WorkAreaText'
        '$TRB==$ThrobberBack==$ThrobberBack'
        '$TRD==$ThrobberDark==$ThrobberDark'
        '$TRL==$ThrobberLight==$ThrobberLight'
        '$TRT==$ThrobberText==$ThrobberText')
      Completion.CaretChar = '|'
      Completion.CRLF = '/n'
      Completion.Separator = '=='
      TabStops = '3 5'
      BackSpaceUnindents = False
      BracketHighlighting.Color = clWindow
      BracketHighlighting.FontColor = clGreen
      BracketHighlighting.CaseSensitiveWordPairs = False
      BracketHighlighting.WordPairs.Strings = (
        '$WorkAreaBack')
      BracketHighlighting.StringEscape = #39#39
      SelForeColor = clHighlightText
      SelBackColor = clHighlight
      OnChange = xmleditChange
      OnPaintGutter = xmleditPaintGutter
      Align = alClient
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabStop = True
      UseDockManager = False
      Highlighter = hlHtml
      Colors.Comment.Style = [fsItalic]
      Colors.Comment.ForeColor = clOlive
      Colors.Comment.BackColor = clWindow
      Colors.Number.ForeColor = clNavy
      Colors.Number.BackColor = clWindow
      Colors.Strings.ForeColor = clPurple
      Colors.Strings.BackColor = clWindow
      Colors.Symbol.ForeColor = clBlue
      Colors.Symbol.BackColor = clWindow
      Colors.Reserved.Style = [fsBold]
      Colors.Reserved.ForeColor = clWindowText
      Colors.Reserved.BackColor = clWindow
      Colors.Identifier.ForeColor = clWindowText
      Colors.Identifier.BackColor = clWindow
      Colors.Preproc.ForeColor = clGreen
      Colors.Preproc.BackColor = clWindow
      Colors.FunctionCall.ForeColor = clWindowText
      Colors.FunctionCall.BackColor = clWindow
      Colors.Declaration.ForeColor = clWindowText
      Colors.Declaration.BackColor = clWindow
      Colors.Statement.Style = [fsBold]
      Colors.Statement.ForeColor = clWindowText
      Colors.Statement.BackColor = clWindow
      Colors.PlainText.ForeColor = clWindowText
      Colors.PlainText.BackColor = clWindow
      LongTokens = False
    end
    object Panel3: TPanel
      Left = 5
      Top = 5
      Width = 566
      Height = 24
      Align = alTop
      BevelOuter = bvLowered
      Caption = 'Panel3'
      TabOrder = 1
      object tabs: TJvTabBar
        Left = 1
        Top = 1
        Width = 564
        CloseButton = False
        AutoFreeClosed = False
        Painter = JvModernTabBarPainter1
        Images = PngImageList1
        Tabs = <
          item
            Caption = 'Plain XML'
            Selected = True
            ImageIndex = 9
          end
          item
            Caption = 'Button'
            ImageIndex = 11
          end
          item
            Caption = 'CheckBox'
            ImageIndex = 11
          end
          item
            Caption = 'Edit'
            ImageIndex = 11
          end
          item
            Caption = 'Font'
            ImageIndex = 11
          end
          item
            Caption = 'MiniThrobber'
            ImageIndex = 11
          end
          item
            Caption = 'Panel'
            ImageIndex = 11
          end
          item
            Caption = 'Progressbar'
            ImageIndex = 11
          end
          item
            Caption = 'RadioBox'
            ImageIndex = 11
          end
          item
            Caption = 'SharpBar'
            ImageIndex = 11
          end
          item
            Caption = 'TaskItem'
            ImageIndex = 11
          end>
        OnTabSelecting = tabsTabSelecting
        OnTabSelected = tabsTabSelected
      end
    end
    object Errors: TListBox
      Left = 5
      Top = 598
      Width = 566
      Height = 67
      Align = alBottom
      ItemHeight = 13
      TabOrder = 2
    end
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 837
    Height = 36
    AutoSize = True
    ButtonHeight = 34
    ButtonWidth = 46
    Caption = 'ToolBar1'
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    Images = PngImageList1
    ParentFont = False
    ParentShowHint = False
    ShowCaptions = True
    ShowHint = True
    TabOrder = 2
    object ToolButton2: TToolButton
      Left = 0
      Top = 0
      Hint = 'Create New Skin...'
      Caption = 'New'
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
      OnClick = NewSkin1Click
    end
    object ToolButton3: TToolButton
      Left = 46
      Top = 0
      Hint = 'Open Skin...'
      Caption = 'Open'
      ImageIndex = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = OpenSkin1Click
    end
    object btn_save: TToolButton
      Left = 92
      Top = 0
      Hint = 'Save Skin...'
      Caption = 'Save'
      Enabled = False
      ImageIndex = 0
      ParentShowHint = False
      ShowHint = True
      OnClick = btn_saveClick
    end
    object ToolButton4: TToolButton
      Left = 138
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object btnUndo: TToolButton
      Left = 146
      Top = 0
      Hint = 'Undo'
      Caption = 'Undo'
      Enabled = False
      ImageIndex = 5
      OnClick = btnUndoClick
    end
    object ToolButton7: TToolButton
      Left = 192
      Top = 0
      Width = 8
      Caption = 'ToolButton7'
      ImageIndex = 6
      Style = tbsSeparator
    end
    object btn_addskinpart: TToolButton
      Left = 200
      Top = 0
      Hint = 'Insert Skinpart (to cursor position)'
      Caption = 'SkinPart'
      DropdownMenu = PopupMenu2
      Enabled = False
      ImageIndex = 14
      ParentShowHint = False
      ShowHint = True
      Style = tbsDropDown
      OnClick = btn_addskinpartClick
    end
    object btn_addtemplate: TToolButton
      Left = 261
      Top = 0
      Caption = 'Template'
      DropdownMenu = PopupMenu1
      Enabled = False
      ImageIndex = 7
      Style = tbsDropDown
    end
    object ToolButton8: TToolButton
      Left = 322
      Top = 0
      Width = 8
      Caption = 'ToolButton8'
      Enabled = False
      ImageIndex = 9
      Style = tbsSeparator
    end
    object btn_Render: TToolButton
      Left = 330
      Top = 0
      Caption = 'Render'
      Enabled = False
      ImageIndex = 16
      OnClick = btn_RenderClick
    end
    object btn_Refresh: TToolButton
      Left = 376
      Top = 0
      Caption = 'Refresh'
      ImageIndex = 29
      OnClick = btn_RefreshClick
    end
  end
  object MainMenu1: TMainMenu
    Images = PngImageList1
    Left = 392
    Top = 64
    object File1: TMenuItem
      Caption = 'File'
      object NewSkin1: TMenuItem
        Caption = 'New ...'
        ImageIndex = 1
        OnClick = NewSkin1Click
      end
      object OpenSkin1: TMenuItem
        Caption = 'Open ...'
        ImageIndex = 2
        OnClick = OpenSkin1Click
      end
      object mn_save: TMenuItem
        Caption = 'Save'
        ImageIndex = 0
        OnClick = btn_saveClick
      end
      object Export1: TMenuItem
        Caption = 'Export'
        ImageIndex = 23
        object mn_export: TMenuItem
          Caption = 'Packed SharpE Skin'
          ImageIndex = 22
          OnClick = mn_exportClick
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        ImageIndex = 13
        OnClick = Exit1Click
      end
    end
    object Insert1: TMenuItem
      Caption = 'Insert'
      Enabled = False
      object SkinPart1: TMenuItem
        Caption = 'Skin Part'
        ImageIndex = 14
        object Advanced2: TMenuItem
          Caption = 'Advanced'
          ImageIndex = 14
          OnClick = Advanced1Click
        end
        object Basic2: TMenuItem
          Caption = 'Basic'
          ImageIndex = 14
          OnClick = Basic1Click
        end
        object Emptynoimage1: TMenuItem
          Caption = 'Empty (no image)'
          ImageIndex = 14
          OnClick = Emptynoimage1Click
        end
      end
      object emplates1: TMenuItem
        Caption = 'Templates'
        ImageIndex = 7
        object Button2: TMenuItem
          Caption = 'Button'
          ImageIndex = 6
          OnClick = Button1Click
        end
        object Checkbox2: TMenuItem
          Caption = 'CheckBox'
          ImageIndex = 12
          OnClick = CheckBox1Click
        end
        object Edit1: TMenuItem
          Caption = 'Edit'
          ImageIndex = 26
          OnClick = Edit1Click
        end
        object Font1: TMenuItem
          Caption = 'Font'
          ImageIndex = 25
          OnClick = Font1Click
        end
        object MiniThrobber2: TMenuItem
          Caption = 'MiniThrobber'
          ImageIndex = 21
          OnClick = MiniThrobber2Click
        end
        object Panel5: TMenuItem
          Caption = 'Panel'
          ImageIndex = 20
          OnClick = Panel4Click
        end
        object Progressbar2: TMenuItem
          Caption = 'Progressbar'
          ImageIndex = 17
          OnClick = Progressbar1Click
        end
        object Progressbarsmallmode1: TMenuItem
          Caption = 'Progressbar (small mode)'
          ImageIndex = 17
          OnClick = Progressbarsmallmode1Click
        end
        object RadioBox1: TMenuItem
          Caption = 'RadioBox'
          ImageIndex = 24
          OnClick = RadioBox1Click
        end
        object SharpBarxmlbasecode2: TMenuItem
          Caption = 'SharpBar (xml base code)'
          ImageIndex = 15
          OnClick = SharpBarxmlbasecode1Click
        end
        object askItem2: TMenuItem
          Caption = 'TaskItem'
          ImageIndex = 27
          OnClick = TaskItem1Click
        end
      end
    end
    object Help: TMenuItem
      Caption = 'Help'
      object QuickHelp1: TMenuItem
        Caption = 'Quick Help...'
        ImageIndex = 18
        OnClick = QuickHelp1Click
      end
      object Documentation1: TMenuItem
        Caption = 'Documentation'
        Enabled = False
        ImageIndex = 18
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = 'About...'
        ImageIndex = 19
        OnClick = About1Click
      end
    end
  end
  object OpenSkinDialog: TOpenDialog
    Filter = 'SharpESkin (*.xml)|*.xml'
    Title = 'Select skin file to open'
    Left = 448
    Top = 64
  end
  object JvHLEdPropDlg1: TJvHLEdPropDlg
    JvHLEditor = xmledit
    ColorSamples.Strings = (
      '[Default]'
      'Plain text'
      'Selected text'
      ''
      '[Pascal]'
      '{ Syntax highlighting }'
      '{$DEFINE DELPHI}'
      'procedure TMain.JvHLEditorPreviewChangeStatus(Sender: TObject);'
      'const'
      '  Modi: array [Boolean] of string[10] = ('#39#39', '#39'Modified'#39');'
      
        '  Modes: array [Boolean] of string[10] = ('#39'Overwrite'#39', '#39'Insert'#39')' +
        ';'
      'begin'
      '  with StatusBar, JvHLEditorPreview do'
      '  begin'
      '    Panels[0].Text := IntToStr(CaretY) + '#39':'#39' + IntToStr(CaretX);'
      '    Panels[1].Text := Modi[Modified];'
      '    if ReadOnly then'
      '      Panels[2].Text := '#39'ReadOnly'#39'    else'
      '    if Recording then'
      '      Panels[2].Text := '#39'Recording'#39'    else'
      '      Panels[2].Text := Modes[InsertMode];'
      '    miFileSave.Enabled := Modified;'
      '  end;'
      'end;'
      '[]'
      ''
      '[CBuilder]'
      '/* Syntax highlighting */'
      '#include "zlib.h"'
      ''
      '#define local static'
      ''
      'local int crc_table_empty = 1;'
      ''
      'local void make_crc_table()'
      '{'
      '  uLong c;'
      '  int n, k;'
      '  uLong poly;            /* polynomial exclusive-or pattern */'
      '  /* terms of polynomial defining this crc (except x^32): */'
      '  static Byte p[] = {0,1,2,4,5,7,8,10,11,12,16,22,23,26};'
      ''
      '  /* make exclusive-or pattern from polynomial (0xedb88320L) */'
      '  poly = 0L;'
      '  for (n = 0; n < sizeof(p)/sizeof(Byte); n++)'
      '    poly |= 1L << (31 - p[n]);'
      ''
      '  for (n = 0; n < 256; n++)'
      '  {'
      '    c = (uLong)n;'
      '    for (k = 0; k < 8; k++)'
      '      c = c & 1 ? poly ^ (c >> 1) : c >> 1;'
      '    crc_table[n] = c;'
      '  }'
      '  crc_table_empty = 0;'
      '}'
      '[]'
      ''
      '[VB]'
      'Rem Syntax highlighting'
      'Sub Main()'
      '  Dim S as String'
      '  If S = "" Then'
      '   '#39' Do something'
      '   MsgBox "Hallo World"'
      '  End If'
      'End Sub'
      '[]'
      ''
      '[Sql]'
      '/* Syntax highlighting */'
      'declare external function Copy'
      '  cstring(255), integer, integer'
      '  returns cstring(255)'
      '  entry_point "Copy" module_name "nbsdblib";'
      '[]'
      ''
      '[Python]'
      '# Syntax highlighting'
      ''
      'from Tkinter import *'
      'from Tkinter import _cnfmerge'
      ''
      'class Dialog(Widget):'
      '  def __init__(self, master=None, cnf={}, **kw):'
      '    cnf = _cnfmerge((cnf, kw))'
      
        '    self.widgetName = '#39'__dialog__'#39'    Widget._setup(self, master' +
        ', cnf)'
      '    self.num = self.tk.getint('
      '      apply(self.tk.call,'
      '            ('#39'tk_dialog'#39', self._w,'
      '             cnf['#39'title'#39'], cnf['#39'text'#39'],'
      '             cnf['#39'bitmap'#39'], cnf['#39'default'#39'])'
      '            + cnf['#39'strings'#39']))'
      '    try: Widget.destroy(self)'
      '    except TclError: pass'
      '  def destroy(self): pass'
      '[]'
      ''
      '[Java]'
      '/* Syntax highlighting */'
      'public class utils {'
      
        '  public static String GetPropsFromTag(String str, String props)' +
        ' {'
      '    int bi;'
      '    String Res = "";'
      '    bi = str.indexOf(props);'
      '    if (bi > -1) {'
      '      str = str.substring(bi);'
      '      bi  = str.indexOf("\"");'
      '      if (bi > -1) {'
      '        str = str.substring(bi+1);'
      '        Res = str.substring(0, str.indexOf("\""));'
      '      } else Res = "true";'
      '    }'
      '    return Res;'
      '  }'
      '[]'
      ''
      '[Html]'
      '<html>'
      '<head>'
      '<meta name="GENERATOR" content="Microsoft FrontPage 3.0">'
      '<title>JVCLmp;A Library home page</title>'
      '</head>'
      ''
      
        '<body background="zertxtr.gif" bgcolor="#000000" text="#FFFFFF" ' +
        'link="#FF0000"'
      'alink="#FFFF00">'
      ''
      
        '<p align="left">Download last JVCLmp;A Library version now - <fo' +
        'nt face="Arial"'
      
        'color="#00FFFF"><a href="http://www.torry.ru/vcl/packs/ralib.zip' +
        '"><small>ralib110.zip</small></a>'
      
        '</font><font face="Arial" color="#008080"><small><small>(575 Kb)' +
        '</small></small></font>.</p>'
      ''
      '</body>'
      '</html>'
      '[]'
      ''
      '[Perl]'
      '#!/usr/bin/perl'
      '# Syntax highlighting'
      ''
      'require "webtester.pl";'
      ''
      '$InFile = "/usr/foo/scripts/index.shtml";'
      '$OutFile = "/usr/foo/scripts/sitecheck.html";'
      '$MapFile = "/usr/foo/scripts/sitemap.html";'
      ''
      'sub MainProg {'
      #9'require "find.pl";'
      #9'&Initialize;'
      #9'&SiteCheck;'
      #9'if ($MapFile) { &SiteMap; }'
      #9'exit;'
      '}'
      '[Ini]'
      ' ; Syntax highlighting'
      ' [drivers]'
      ' wave=mmdrv.dll'
      ' timer=timer.drv'
      ''
      ' plain text'
      '[Coco/R]'
      'TOKENS'
      '  NUMBER = digit { digit } .'
      '  EOL = eol .'
      ''
      'PRODUCTIONS'
      ''
      'ExprPostfix   ='
      '                       (. Output := '#39#39'; .)'
      '      Expression<Output>  EOL'
      '                       (. ShowOutput(Output); .)'
      '    .'
      '[]')
    Left = 472
    Top = 120
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000008C74
          455874436F6D6D656E74004D656E752D73697A65642069636F6E0A3D3D3D3D3D
          3D3D3D3D3D0A0A2863292032303033204A616B756220276A696D6D6163272053
          7465696E65722C200A687474703A2F2F6A696D6D61632E6D7573696368616C6C
          2E637A0A0A637265617465642077697468207468652047494D502C0A68747470
          3A2F2F7777772E67696D702E6F7267678AC7470000029F4944415478DA9D925B
          4853711CC7BFE76C6ED35DD84A5749E6CC28A62F1504929097878CA807835004
          CDCC9758794D2C372F7BB034CDCC48460476951EAC17237ACC0ABB500B241DDB
          32352F135DEA99BBB8CBE974CE311D0B7DE90B7FBEFFFFFFF0FDFCFEBF1F87B8
          D05C6B9870C793F30B010A4002BB8EB12B358A64FC7289F797421CB8FFB4E5AA
          1E9B88C8AEE82AD2ECD56A12B7A9C7F627C55524AAA20F7A4234461CCBF8F271
          E0B77D7216FB5443BBBA8DBDD31B02748D2DDD41D7FCF91043629656C2278E83
          401885829CC3488EDF82CE67EF404F99A1112D6C943712BACA32A6B6A61C093B
          76E3C74F0B9C1E319EBCB5E2937918D5A579703829BC19FC0063C971A468E2D7
          931E8F0775865A1055353AA6ADA50B1445816118B83C144C2F8730F0D58EACCC
          0CA865423C7FF51AE5B987907520957D331767201289A0375C065156A1633ADA
          6E61915AC2497D4FC4FB38C0D8FC32C687CD11F72F9ACF422C16435FFF17D07E
          FD261617973031634399E93D8AF373611D9F5C0F906CD9E49DDBF1B0AF1F85D9
          7B703A331D9268090C0D5756016DAD1D2008027373739870D8517DEF330FB18F
          4FF180346D226EF4F4A1202309A78EA441A95482A669D437D68501DC50643259
          04E452693E9C6E3F1EB195F3D213F8B05AAD86DBED86402008035AAFB5C3E974
          422A95F2104EDF6C66549A06E10FD228C9D1A2F8C45190240997CBC51793CBE5
          6868D2AF023A3B6EF32D6C262EC0C9E7F3F1BEB2B21209282E3A87603018110A
          8542100A85EBFB7FA552A960BA7B270CE0E8369B8D1F10479748243C8073ABD5
          0AAD560B8BC5C2BBC3E1E0018F7B1FAC02CE1496C0EBF5B21F661013238542A1
          E0FBE500DCB046BF8F429BC2024646584FC1CCF434B6C6C68601E517ABF8BF70
          4D7EBF9FF74020B0E95CB896D7004DECB911FF27E31FE2832F126DB0627E0000
          000049454E44AE426082}
        Name = 'PngImage0'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FC00E9004F34D7B10D000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000018249
          44415478DA9593BD4BC34014C0DF7DA4AD943462412CD87F417071F44F10DC9D
          3AD6C1D925A5DDA4E0E82405114450A858A9828E2E8AF5A39D3A38B45197B429
          5215DB26172F95C626A6D13E08EF7897DFEFDEBD1094CBE576154559019F0887
          7B108D7EC0A4F4098B0B37D929A9720ED0B946227B45E974DA9465D98F87766B
          1B047C0B043F8161747A865EBF08879E0F00DEF76D41B3D904C6581F4008D9B0
          80AF20488A20D07B40788E573030BDCC98513F0C5075D316A8AAEA800739808F
          20448F81D01820BAC42B04CC5E018CEE6959A06AD62170C35604499E3F052E98
          E58265BE49B920CF05271581A8B22D68341ABF606B4DD1E5F71548951F3E6F55
          C1D41FCC6EA77636117C591B2918648CDA20A022505CE2435478C5045D9F612D
          ADBA1E9B2E651D0237FCD3CD1B1FE61D1F5F8DAF43B0B3F708C9E4467FD3F115
          BC60F7952449824C2603A9546A3CC120FB0AAC97BCC0E12E229188B740D3B491
          E0701645F16F815F172305E38443F09FBFD11DF1787C2B9148ACF605631DED11
          5FE97CCC01A69112BD0000000049454E44AE426082}
        Name = 'PngImage1'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E000001B249
          44415478DA630C0D0FAE97909068604003BF7EFD82D03F7F65CC9FB77026030E
          C0989B9FFD3F313E19ABE48F1FDF19E6CE9FC3F0E9D3A7A8D52BD72EC76A4056
          4EC6FFB09070866BD7AF810558589919787979180881F71FDEB564A5E7D532A6
          67A6FE4F4A4861B87BF72EC444E67F0C1161D1040D58B16A294364780C236362
          72FCFFF8D804B80B0485F8C1067CFBF615A7662E2E6E8401B1F1D1FF73B2F230
          5C0032E03AD45064A0A9A985694072620AF92E888C0EFF5F905744D0053C3CBC
          0CB2B2B2980600D3C1FFECCC1C8685BB6E335C7ECD4530F090013FDB4F06B001
          2545650CD9736E334C2A7667F8F1EB2F519A39D89819F27A7732C05D50B2F429
          4355923DC3BD575F096AFEFBF71F83AC081743DFE223A82EA80419F0F20B0323
          2323C3FFFFFF819881E11F90F8FBEF3FC39FBFFF197E0335FEFAF30FCCD692E1
          6398B1EA38C20533B6DD6170767562B8FAF82303C37F46867F0C40DD100436E8
          3F08FE871A0C14D391E56358B0FE24C48090903086072C7A0C8FDE7C43D50472
          01582B2398031333571562D8B97D07C3A7378F1730DA25741EF8C62A6D4F52F0
          0301F7EF47270F2EA8B2602455233A0000D249ED056AC96CFB0000000049454E
          44AE426082}
        Name = 'PngImage2'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E000000A549
          44415478DA6364A01030D2CC0093D42567809431947BF6CCEC1813520DF8DF9C
          E90466D74EDFC700348071901B80E667304036000DC0C304D980FF3D792E0CBF
          FFFD070BFEFEFB1F45C7FFFF100C92AB9B8970118A010DE98E0C0F5F7F032BFC
          0734088818BEFDFACFF01768D81F10FF1F0383920427C3D4E547B01A80E18520
          0F5330BD6EC769C25EC01588E7EF7F061B40762C506C00D1D188C500CA9232B1
          80620300486577112F125DDB0000000049454E44AE426082}
        Name = 'PngImage3'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000021149
          44415478DA6364200254B431FC07D17CEC0C2E55C50C7B91E5188931A0AE8FE9
          BFB3BD14C3DE83CF187E7EFDEFD459FB7F3F4E03CAABD8B839057E4D63656230
          FBFC8B410326EEE92605A6B7EF7AC6F0FF2F23DC101403CA9B183DD9D8FEAFE0
          E36078A4A6CAC1A4A42CA8C5C6C6CAF0FFFF5F863F7FDE31DC7EF89F41484808
          C510B801E50D4CD1EC9CFF66EB6B30B36BEB88307DF8FC09C32B6FDFFE67F803
          0C0D01012186BD875E30FCFCF6CF066C40790B8335072BC34A0D3556691D4D16
          0646A0E897EFA89ABF7CFCCFF0F92703C35FA001ACCC0C0CD212620C6B363D82
          78A1B38FE114370793B0ABA7AAD2BFBF2F183E7EF985622B0CFCF8C7C0F01F88
          15A4219A1980DE001BD0DCCDF0C5D4DC825B49EE0750F37386771F3E30F0F330
          A1B840904F8AE1F2EDA770CD2861008AE7402F270616B6470CC74E3FFFFFEECD
          57C6EF3F51BD10E22707A69135C3630164406A4C20C39E235B185E3DFBFD4988
          93A949499869AF67C49F0B307990019B763DC19E0EC00AFCADFE6DDD718C8983
          89C1B3BC906107B6940804261D550C6731522248416CA8FDB71DBB0E731667FF
          43F53C01003660F20CE6B76A1A326C37EE3EE362FCFE27262FE7FF72920C983A
          8569EE2FC67FB1F6F65A8C678EDEB829C7CFE4EA11F1E739D10680C0F6152C06
          D7DFFC5F2B2DC4F2E0D78FDF1F45B8989A80922F091984921740865C79F1A7F3
          D71F0695DFFF18AE0A71312E27E41D00420AE781D889E76F0000000049454E44
          AE426082}
        Name = 'PngImage4'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E000001F349
          44415478DA95924D6B13511486DF3BC924696CD20F9B268A8A591441291444BB
          293542B43B972E8295EE04FF41170A7EA0BF4211DCF91334A0053735208234D4
          D61A2BC9644A6A46C7CC8CF375C7338319B409243D70B81FDCF7E1DC735E8603
          F1FA09A6C4085AFE7E61050C03E2BF077756C589A533767BFECA39ACBFDA381C
          2014176782F37A793B582D765476B92043886DAC7D6ADD7AF8C8D27A00FF8A6D
          77145141A15B079EABC3323D70DE512AEFC62451002B577F2E3D786CD7430089
          9324D6E68BB3B01D7A21444864202AC6E0D81654F53B01DB184930ECC9694FAE
          432A57D56B04791F00DE3E83D7150B24F6FE92397703806174C2723DB7891FED
          34A47AB4F266532910446777A9FCAB41F9B370B908C7B5F06D7733144D4E1E0B
          F786EE576263673B631A9AF5B1B8D2BAD0D3835AAD867C3E0FC7FCDAD371B925
          C2B45CD8BF53D8DF8B6B97971BA303A710C60843EEE4B81789701617756C5533
          66E18694E8EF0382F880AE0FA84F739A89D347E2583D7B7EECE2BE0A34BF2471
          69B9C9FA1AC56F6C3F27AE3DC5F1785A68644E4C7B8D2D932DDE54D840A71D8C
          CA8B344FE5388D33AB164A3B138702F85F498E4F57FC89EB9DD47D02DC1B1A40
          627F9ECFB333A70ACDDD5FCE62494984561E4298A5BCEDC5720B8C09802995A8
          3F1F8605CCD13245799DF233E5CBAED88F3F5CC3E91113A27E5E000000004945
          4E44AE426082}
        Name = 'PngImage5'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000002194944415478DA
          A593DD4E134114C7FF335349D394DABA6D21A954BD31BE855C192082297E217A
          A53E80496D111EC0886BEB1D2104C58FA8B8A5242A11109F402E30BD315EA0C4
          60EB0542B3AD7C74BBBBCE4C2DA4DA68137777724E76F6FCF67FE69C436CDBC6
          FF5C440086D59B9D8CB147A669FA1B09A294EADC5C8B456F4C4840E2AEFAA1AB
          B3EB584B4BABD804A34C5AB108A132C8B62D585665ADAF7F8736A5E9B1E8C07E
          09B8931C5EEBEFBFA46C160B1019114AF624FE72AB9912FEC2AF04313A368281
          D810D9055CE8BBA8FC28EAA04DFCEF84CA0F898C2648A849E47259A8C9DB30B6
          4A08045A31363E5A0B387FAE4F314A3B208EAA7422E59B6619CBCB9F100A85E0
          72B950DE29C1E3F1E2DEC4782DE0CCE9B38A833198FCA6F20C2A80B9D9796432
          192CBE5BE4793F875DB6E070ECC3C3C70FF6006AE2D65A24D2ABB85D6E1896B1
          7B802295572F67B0F47E09F3B36FF07A6E061EB70746D9C0D3674F6A01DDDD3D
          4A3010C4D6F62628635205E390C8A95E4C6A93E838D181E91769F87D0A36F279
          A4A6B4DF00277B94B68361E40B1BE03D512925B7292D8595CF2B703A9DB872F5
          320E7815E4BE7D457A3AFD2720DC7648E60EF990BA4D649A16B2B9D5FA0041A6
          8CFEB50B2D0E104AEB0256B35FF0AFD910E53D1C3E520BE065FCD87EBCFDA8D7
          E76B68800ABA8E85B70BC5F8F5C1E6EA304538F93EF79B1B9A4042B6F911C5E3
          D1C1115295CC2122F9A606A7D8E0F24DE1FC04095E11F05EC3BD1F0000000049
          454E44AE426082}
        Name = 'PngImage6'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000027249
          44415478DA95D35F4853511C07F0EFDD5DCDA6DB722E69B3D4DA20A50862216C
          6BA4A5D392D090CA0741A31E8A559011D5A8AD2DDD222A22186D14D2433DB43F
          8534505AA69BB944A197A807AB510B99B6B95A0915D15DD733AD862EF0C0E177
          EE9FDF87DF39BF7B29CC8E8ABAD3C7D970859D29FC1D644D51D4A4E1C0B8BC5E
          9B5C07702B0026C6CE67ECA31835F382D3E9F44C4C4C34BD7EF316633119CE9D
          6949A75369E282ED0EB6AE8F60FFBE7CAC2E5581B3B404D3537D4F0BF25E1C24
          80D96C4E198D46F8FD7E9CBDFA040D4DDB301EFF428CA242111E7AFB71DDB00A
          CA8D4250B90D2C9C836F5F47C1FB7ECD900178BD5E586F045159ABC1FBE82702
          94C8C4083E0AE162FB5A68554270F93B41D1B9487EF44140DF3F9201B85C2E58
          ED7DD0D6A8F16E3C4E76505AB402838F43686D546097AE10C5453CD0340FAF5E
          0650BE26A29A07D81C83A8D4A9D90AA69062F75F2A2B4080ADE0D4212D74D555
          A0A91804FC6974DDF6A06DF7D8B20CC0ED76E3D2AD5154EDD02042B69042B134
          1F033D2134D74AA156AB505E5606A1280F1D1D9D301ACF53F380CB5DCF09F061
          3249CEA078E572F4F70CA1BD6D136A6AAAC1E17020128960B1586032993281EE
          EE6E581DC304F8F1F3171826057ECE1202180E6F86764BD5FF81B93656D66930
          D03B442A98C1067A43E83CB11D4AA572E6A3CA0E0483419CB4F5A44B97B12DE3
          72108E7C26D7C75A3640A150A08C3D83ACC0C8C8088E9A1EA0758F06CD8D6A52
          AEC7378C9B77037058F7422E97134C28142E0C84C36144A351B6CF3466FF0112
          198681542A85582C26F70402C1C2402291F8933897FC6F9C5B670516333200BB
          DDEE8BC7E3F58B012412C93DBD5EDFFC1B750311BCA7A56AD50000000049454E
          44AE426082}
        Name = 'PngImage7'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000002304944415478DA
          95935F4853511CC73F67D7AC4D9A4CC17AEA49EA4190C082FC839BB57A30B07F
          8E6C8F417322CC89A0BDF42CFA30297A8881A10F356190939811D9C3D5218194
          10D5830F031F9415A384D461CA6EBF1D528AB4F4C0E59E7B38E7F3F99EF3BB47
          5996C56EEDBA52E5C5302CDDE21F70FB996565769BA7F602B429F5F424DC1088
          F1115EC62CEBF2BE0162AF3C04EFBBEC767B51490943D96C6E03EA25C5FCBE00
          628F9F83ABDEF6F622A3BA1AB3B3D332615A5278FE0B10FB29893D1F7238EC15
          A68972B958696E666861617D1D2E4A8AD97F02C43E5107CD1782C122773C8ED3
          E9E4457737A950C89A82B792E2EC9E00B157897DAEAB609F9EC6DBDAAA011389
          045FBD5EEEA7D36BDFE18AA478BD2B40EC930D70A92918341CBDBDB4B4B46840
          2C1663637C9C37E13093F0495254FD0510FBE9C330ABED3333D8CACAF0FBFD94
          9696128D46219F27EB76F3707171F51BF825C5F33F00627FD508E7DDC1A0ADA4
          AF0FA51481404003229108369B8DDCD818733D3D24202D3F57A5402C0D10FB99
          23608ADD51914A697B0190CBE5300C0319D6DF6C6DF1B9B696474B4BAB5FE08E
          00C63440ECA614B8A1B1A363C75E18F7783CB8A48CC964528F1552AC8D8EF24E
          CE270ECB92E284BA06B576980AFDB21BE5E57A72E1F1F97C7A0B2323237AB14E
          B1B9C9524D0DC399CCEA3284551BA49AA0AEDEEF5747FBFB77166F1B7F7F6FF7
          570606F83038C813C8AA9B90B905C78E73B026778307722ACA0777A50EF7F272
          6D0F0290CDE40D78FC13E989E375026CDE380000000049454E44AE426082}
        Name = 'PngImage8'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E000001CD49
          44415478DA6364A01030C218471630B800A9DD40EC4A88B64960D88362404757
          6B9A8D58F54C538F630CA777583110A2810630A21BF01F680083BAA02DC3CDF7
          8709D2A77732C1F4C7C20D484E4C63B8B95594E187CC1E068E272E0C5F247630
          F0BCF0C0A0419AE3271E6178787835C3813513112E282FAD6278FBF62DCEC07A
          FEFC39C39E367D86844947191E1F5CCC70FEFAEBBFEFAEAD654631E0CE9D3B0C
          1F3F7EC4D0FCFAF56B861B8BBCE19A2FDD7ECBF0FAD26A9094094117C06C063B
          FBC062868B37DF32BCBFB606ACB970F9BFB3785D00B339AEF73058F3A57BEF19
          DE5F5DCDF0D3B099A1A2AC1AA49711A70BFEFFFFCFB0244F9C21AEE710C3ED5D
          0B18EEBCF80C76F623897C06714911EC06C05C00D2BC6AD52A86DFCF8E300405
          04323CBC759AE1CD95B50C0C66BD0CDFBF7F676062F90F32001497FFB1BAE0EF
          DFBF0CCB0A2419F6BE54619017156050613AC3C0E7329BC1D2D292E1C68D1B0C
          B7EE5C87B98001C3051F3E7C60F8F9F327838D8D0D437F2413C315AE44064D4D
          4D063B3B3B06010101B001D76E5C0619C00CD4FA0FC30520E783302C1C989898
          C03423D0B7207CECD8319801A82E484BC9643872E408CE8404330404B019B018
          48C590908B97000D88053100A2EC33577643D79D0000000049454E44AE426082}
        Name = 'PngImage9'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000023A49
          44415478DA9D93CD4F134118C69FAD94859676EB4742C201296D93225962DA9A
          8227A21CE849C345A31E3CAE7F51397AF07FD08310AA51DA1A0AA4C42D4DD010
          0216C450AADB0FECCEF8CE765B0A9A1E9CCDECECC73CBF79DE77DE9170A9BD02
          E2343CA73E4BDD6F7FFE4A7D85FACB6740A67BBE74499CBCEAF16813AA8A81E1
          615C71BBC13947F3F414B55209455DC789612C12E4C55F0012BF8EA8EAFC8D68
          1467EBEB308F8F01D3B4008C66397CD7D0776B02275B5BD82C16DF1024D10188
          9549AC5D0F85D0C8663B42CE1938E3F633C01D80539D42797717F99D1DCB8924
          6226DBE93B0B0BA82F2D819BCD7381B83106269E61C3240903F138F2A914CAD5
          EAB40024EFCECC68FDD52ACCA32388D9ACBDBA0008291303B3C1F4CDE783E972
          23A77F5E1400FDDEC307E1DFD94FB43AC3CDD237F46ADB8A97BC38E09C9C4466
          F5634100EA734F9ECAF5E5B796C5B1C3C39E00DDE3B15CC8B118D2A954A30578
          F458AEAD2C5B00BF08A3176068C80A518E459179F7DE02E8B38944F82C97B313
          D84A1E6776CCE2B27742FCB4F2438994C36164D7D6AC1092F14844EBFB65C0FC
          F1DD16F37371FB9DB5DF29035E058C9C6CD2565ADBE873B9D2B7EFCFA1B6FA01
          BC6976B2DDDA095C1CC5EA540BDB1B1BA8341AD39D429A0A0635656404F57C9E
          42313B6188C6580B005148C1100CAA52FDE0A05548DDA5AC8E8FCF2B81001A85
          02CCF229019AB6752A59AF07FD637EFCDCDB13E28BA5DC7D9894C1412D303A0A
          A7A2409265CB85691868562AF8B2BF2F6CFFFB30FDEF71FE03EC896E7ADE393B
          FE0000000049454E44AE426082}
        Name = 'PngImage10'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000002C94944415478DA
          6D93ED4B145114C6EF9D999DDD715D59A89022F025A27C89D8483F24D67EED63
          916D2ABD5844E0070992A00822ACAD24A82F2A444948BA1951FF8144982561B1
          84A682EB2BE85286AECDCECEEBEDB9DBBA0DD1C061EFCE9CF33BCFB9F7B99431
          46DC4F3FA5214AC8598190C30E2115FC1DD61358BF43665F33635FDCF9741380
          42098537454569DF1D0E7BFDC120F58A22319349B29E4890F5951527A9AA0652
          1FA0E21640561EC08BD1E543712854551989283F4747C9523CAEAE2D2F8BCCB6
          89228A46916515160982B0609ABF34C71987A243803859C000A51D3B6A6BAF54
          37362A733D3D646A7ADA04BC05318C1011356870C34BE9AE325956E60C43D518
          BBDBC4D81DFA9C9090C7EF1F0947A3BE85AE2E22CCCF938461A40DC6DE40EAE9
          E6DC8C502960C44E1FA5ADA5804CE97A1A2A6A693F218FAA1B1ADA6449A263B1
          98892E66B92C17E420AF517DC60D8192F8768FA712DFD877CBBA4F63847CAE69
          6D0DCD0E0DA9C9C9C94BE87254A6F4980BF20AD5E75C90885F101E6F93A4A245
          C318E10AB423EDEDBEF7DDDD19339DDE8B9C0540FA00398E790B66FF405EA2FA
          3C8700500E15E37BBC5EDFA4AE6F6401752D2DBE8FB158C6CA64AA9094401205
          E41920275C9041402EA0410900DFF2008C3056595F7F60716262636D75F52200
          8339A91CD20BC84917E405204318A167AB2806964C333BC2C39DA5A56D82A691
          C564923B6E3F3F5F17E4292091B2BF7B22617FE4946D5B3F6CBB337B8CD8DB91
          8A40C0379B4A6919C6BAD1E5EA3F90271E4A4FF18D85894801CE02F233C83B98
          37125E5E2EF1780A2155D3199B41F56DD47F4270501DA217DFE520EC3DADEB2A
          1A4561A4A8DBCAC3304975892CFB538EE3ACD936B7ACCC55288260164B52001E
          21DC85681007B53E6F6597D3AE21AE6F91242F364A54B8783C69C8561DC75AC5
          DCF8DB818A7B9B23D2FF5CE72AFC34E1028491B12F779DBFDA84BCC5720085E3
          EEFCDF1DE68FFEAAFF46670000000049454E44AE426082}
        Name = 'PngImage11'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E000001CD49
          44415478DA6364A0103052D3003512F5DE06E2FF7003848484D49C5C1CAE3132
          323213D2B97BE75EF50F1F3EDC0132FFC10DD0D4D0503330D6BFBE6CC90A267C
          9AA36222FE9D3B7341F3E6CD9BA806D8D9D9ABC929485F5FBC7029D3DD073719
          D8D938C0988D9D1D42B3B23130313131C425C4FC7B70FFB1E6E14387500D080D
          0D53E3E261BFBE60DE22A6078FEF420D606760036256165686FF40C8C1CEC990
          981CFFEFCBA76F9A6BD6AC4135203B2747EDFB8F2FD7E7CE9ECFF4E8E9030656
          5656A046360616161660483332FCFBF7974150409821253DE91F3B0BA7E6B469
          D3500D686E6E567BF4E4C1F55933E6303D7C728F819999858185999981919189
          E1FFFFFF0C7F8106484BC8326464A5FE939290D5ACAFAF473560C6CC996A172F
          9DBD3E6DCA4CA67B0F6F03353232303142C2F3DFFF7F0C7FFFFE6550515467C8
          CECDFCA7ABA3AF999991896AC0FAF5EBD5F6EEDF757DF2C4694C37EF5C03FB19
          2409A2FFFDFB07C63A1A060C798539FF1CED9C35838282500D3876ECA8DACAD5
          CBAF4FE89B8C371A0B4BF2FF8506856B5A5B5BA326A4BB77EEA84D9D3199A884
          949196A3AEAAAA720B25297FFEFC199A94FF4384FF43D8FF19211E81F0612AFE
          33F0F3F1A31A402EA0D800001D3EB411A45BC17D0000000049454E44AE426082}
        Name = 'PngImage12'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000020749
          44415478DA9D934D6B13511486DFA186F463E45E68034EDC8A5F0B5745060437
          AE5BBA73E5C23F21FD07164B1B48218A5592DA3636BA89584B6923165108E22E
          A2620521264463639DD1C9243319C6736FCD3421AD8B1EB8CCCCE1BECF39733E
          14905D18BDE8E388A6B401D7AF5D45B1F815AEE3A2542EC1733DFCB12C98A649
          3E07F5BA8D72A5029B7C6D23DD3E209DBA8F8DEC1358BE4F97EB68369BF21886
          01D775D168D878F9EA35766BB5830137DEBE91CECAF4345D6E0447881DCA2014
          3A8674E6116AD5EAE1802B5353783E3989EF3333B06D3BC842405AAD160132BD
          80252028A0000813901FB1183CCFC3E933A7A04535DC49DCC5D3B53554A90E3D
          80B6509895CF6348D725A43A3B2BA35FBAAC2379EFC1FF01C6EA2A947018942B
          7C12B1F17109896EE5B0B8B00CCE199657320703F48909E9F895CDCA27A7EF3C
          BDFF8CC7512814A0691ACCDF26D28701DA8E737D7D606363526C2612B27042E8
          341D9A07437681B3E3D22F4CE523DD5DD0FF45B6E7E7650145FB3A018BE98718
          1EE64106FD43BC770EDC645246F069A004C0A2C913BFF0EEC37BA4520B38193D
          11003C25D40DA8CFCD21A4AA085331058431868FDB9FA8788F719E7F83B35BEC
          DA83CF4AC720C56EDD44B954462412C1E0E000D6377378B6BE2185ACB52754FB
          BB176973A703703B1E4383A62FF7626B4FA87EC159BE135C66034ACF2626B747
          F701475DE7BF6FD14290744ACE160000000049454E44AE426082}
        Name = 'PngImage13'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000002094944415478DA
          63FCFFFF3F032580911403F2ED38F8271EFAF1912C03726C388CF4E5F81DECD4
          58F770FCFD7E59BEF9ED7FA20DC8B0E2705610E36D8D7437BEC6F2F1C691FFDF
          BF5CFDFBEFFF4DA0211F081AD0509913CDF8FBF3220D11B6DF969C57CFB37FBA
          7B8E818DE7F6B3D7EFEFEFBDF5F30641037AFB3AAFC8C8C8693332FC6778F4F0
          1E83D3DFEDB764F819AFADDA7FF9C395273FEBF11AD0D1DB61CAC6CCBC372921
          95F7EFDFBF0C878F1C62B875F32A83C493F5EF2F5EBA36ADF7C0F71ABC06F4F4
          75AE31D0370A74B077643A7FFE3CC3DDBB77197EFDFEF1FFD9839B7F1FED9B2D
          396DFF9B37380D686B6B136761637C909196CDF1F5EB5786B367CF327CF9FA99
          E1C9D3475F7FFEFCEE555DD970086F2C7476B737EAEAE896BBB97AB01F3D7A94
          E1FE837B0C6FDEBEFAFAFBDF3FD7CA92CAE338D301232323AB949454A386867A
          B1B48C0C5B487008C3BB776F19DEBC7BF5E5DF9F3FCE6565D5A7702624A0664E
          6161E135A1A1A15E404318F6EEDDCBF0E8D123066F5FCF6FB2D252F640CD67D0
          5D8A6EC00A090989F0D2D2520639393986050B1630DCB97387E1C387F7F35EBC
          78998CCDAB7003809ACB405EE7E5E5655050506000BA84E1F3E7CF0CCF9E3D63
          78FEFC792A50DD1C9C060035BB03D95B81981924C8CDCD0DC6BF7FFF6678FFFE
          FD5BA0901650DD2BAC0600713410834CE740127F01C4F780F81228350335BFC4
          955600CA1E07C49A7B66A30000000049454E44AE426082}
        Name = 'PngImage14'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E000001B349
          44415478DA6364A0103092A2F8FF670E7B06460E13209399E1FFAFCB8CBCDFB6
          136DC0FFCFECE60C8CFC590C8C02CE0C0C6C8C0CFFDF9C64F8FFA9830403F8D2
          1998446A1958F3781918B899187ECFF8CCF0FF5E2FDC808EAED67E6666E65C10
          FBDFBF7F70EFFDFFFF1F2C6FAC7B86D1DCF829233B4F110323A300C3EFAF7DFF
          B838CE14304235CF525050480D0D8EC0ED84BFDB1918FFCC071ACB09E4B032BC
          7C71814154E89E1ECC80FFA5C5150C8F1EDD63F8F6ED1BCC05184048F03BD059
          1F19C4853633ACD9F89B818DED0B0B8A01376E5CC1A91919686AA833F44E9800
          F4DD7F56B8015919D90C8F1F3F04FA0F335C61E100034A4A6A0C93A6F4FF038A
          B3C30DC848CB6278F1E2295131222121CD306BCE0CA063FF71320235BB00C576
          A726A731BC79F38A2803C4C5A54006FC051A600932600927276770544434C7E7
          CF1FB17A011DF0F109322C5FB9F4FB972F5F96800CF8E7E4E8C2A8ACA4CCF0E9
          D37BA25C0032E0E9B3A70CDBB66F610019F03735399DE9C387B7386DC7262E28
          28C23063D634B0017F8001C8FCEBD72F06604AC450F8F7EF5F9C2E99B7600E03
          63776FC75360608813E57634C0C4C4F40E00CD76B228C562FC5F000000004945
          4E44AE426082}
        Name = 'PngImage15'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003574
          455874436F6D6D656E74002863292032303034204A616B756220537465696E65
          720A0A437265617465642077697468205468652047494D5090D98B6F000001CB
          4944415478DA63ECE86A9DCEC0C090C1401E98C10834E0BF87A70759BA776CDF
          C1003760DA946D0CC78E5E2742DB7F062B6B2D86AC1C2F540362227B197C7D1D
          18FEFE052AF9FF9FE1DFBFFF0CCCCC4C588DD8B6ED00C392E5C5980678793960
          D5F0F9F30F869F3FFF020DFFC7F0E6CD7786870FAFE137E0CB979F0CDFBFFF65
          F8FAF50FC3AF5F7F1918191981A28C0C4C4C10FAE6CDB3B80DF8F8F117C3BB77
          BF913431C0D930FAD2A5A3D80D3033B361F8FD1BA6019586D90E629F3CB90FD3
          00E2638181C1CD5D8F212EC115D5002E4E4E6004FD07C7000803990C3F7FFD04
          510CAC2CAC10710688384C0DCC00CA522294C109C47C651525C7ED6CEDB9EF3F
          B82BF2F3E74FA65FBF7E41920ED056212141062D4D9D9F1B366E78D1DF3BC117
          28FC11846106F001B1407C625CAB87BB7BA48EAE0EF3BB77EF183E7DFE048CC6
          9F0CFC7CFC0C22C2A20C5FBE7E65983265CAF115CB56E6430D780F33801B88F9
          C323C3FC3F7FF9ACA9A9A91124232D2BA4A4A4C8C1C7C7C778FBF6ED5FB76EDF
          FEFEE5F3972FCF9FBF58B071FDC6355003DE3022F9870B640810F3A6A6A714FF
          FDFB97FDFFBFFF12CCCCCC7C7FFEFE79C1C8C8F4E9C3FBF717D7AFDBB00B9438
          81F835107F6764A0100000FC59FFE4206AE8DF0000000049454E44AE426082}
        Name = 'PngImage16'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000024049
          44415478DAA5935D48145114C77FDBECCE26084685122986598A542C5192D0C7
          430F9659504B2B06BD143EF8183D4A625A6010084299F8D16AA459E6AA612E7D
          1142264664D2C64250CAEABA0BF666A4337367BAAEA04E2F89DDE170E70C9CDF
          F9CFFD9FEBA8ACACE8004A59C7B22CABD321015645C5352CF9C1ADBAFF558021
          8CE5FC46CD759601958DAFE90A8EAFA973C9897D949DDA4D7B9B7F0950555543
          56F12DD414509D52854BC5571005C706026399602EEA93610874C3602EF68B77
          2D17696C68B00392539364AD1BEFA169CA8B0F702F38C6C0F8CE44572121C294
          F23583D9899F0C3596D2DCD46407A4A46FC2B5D14DB56F9E02CF2546C6DBF832
          394B7F689714604A05269AAE130F477973D787BFB5D50ED89A9D8A377F8AE283
          D9CCCC1F267D4B32C1916606C3B9084B60EA02A11B443E4FF0B2FE1C0FDADBED
          80B292059C4E27A78F963335132063BB97171F5AC84B8B118AA5610A53FE86E0
          8EDFC160DD193A1F76D801A19EAB38E4F323D2CDABD03485F99789C67AF16C8B
          A3A45C913626CCC473BE8E67B78B78F2E8B11D507EC1405115A9C285E254D893
          B199BC2C1F814F118CB9E708E9C262D4B79AF4D616D2D3FDD40EC8D8BB035792
          8AEA5671C938991BE6ECFE4C7AC7225842C8B3C861FEB7C6B7E1AF74DF3C4E7F
          A0EF6F406602A0B85DD24E95A29C306F273D720C2C747978BA7440D334BE0F87
          E9AA3EC640FFC0CA24D6FA87B8DFF771CD937824DB6074647405204C13455164
          170D6D419313A727DE97F65521F3783C96008DBE5F02FCDF6D5C4FE1EAF50726
          623C529BF1DFD80000000049454E44AE426082}
        Name = 'PngImage17'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000003324944415478DA
          6D937B504C7114C7BFF7EEEB6EB556F4B045E9B1D918A965462A248F5079CC18
          0CC288FE104D1ED9D5CA8CED61BDA541934735D2187F1924794449E35529234A
          5B61840AA3AD76ADDAFCEE6553C36FE6CC997B7EBFF3B9E7777EDF43F5F7F763
          F0F288D029888B26164A6CE29FF00B62F7895D682E54BF1E7C9EB20248224D9C
          CACE46B8677DD4142640E142FBF9C8B8BDDA868FA8AE6FB5E45E7DF6A3ABC7AC
          25A18304641900FC492E0BF61FABD4C52F1057D4B4E0CEE346D435B57180F19E
          4E981B2847D02477A84F1419CBAB5BAA4878060BB10276CF9AE2959CBE75BE78
          FB91EBF8FABD079A4D61F093CBD06334A3B4AA190545CFE13C5282D4B879483C
          56687A50D5AC2580FDD4D885FB15125B51E5CD9331363B8E5EC7A3DA77889CE1
          8B8CC445A87FDB0E998304C32562943CD54373EA0E26FBBA42B36126C2379F31
          1ABACD4A169096B03A64373948A9328AB89227788F024D51F8D0D18571EE0E28
          485B81DE3E0B22B6E5A38FF89D6B82A17FDF61399C57AA63010F73B5CB832EDE
          A8C6ED476F2012F221140A881710CFC7E299BED8B5763A3E7FE9424CFA550E3C
          CD6F0C4203DC109D74A98205745616C44B166C398F6F062318911022D16F8052
          E18AC309E110F068A4E63C40ADBE1D344DC1C9DE0629B1A150AECC300C0022E2
          73D0D96D8698F90D604105A9CBE03CC20E79376A70EB490BF87C9A0068384AC5
          D0AC0B2680E386812B5CBE558B87A4812C804DB697DA40454A67FF9875A51A14
          4513000F3C1E85006F6704C81DB152955F616DA27A8CF3703A3DB79403881911
          24760CA6FBBB4320E0A3A6B19DEB8780CF27001ACB67F9E095FE9365DFE9629D
          F519AB8A4F6D14A79CBD87572D1D1C44E628C5394D14F72A099925E091642181
          C947DB63499007C262B38CDF0D26A55548EAD953BDF7B2423A90578E86F75F09
          6018B2D5911C2031AB8C94CF87C26D049686782229B3D854545EB74F7F4DA51B
          22E53981F2C96971E14C4D631B586B253A6048353E6E0EF0F37280A74C0A6DF6
          5D5361595DA5F967EF5F290F1EA661B64CF2D655218CFF3817CAC76D24691E85
          E6D66F78D9D46E399453F2A3B3CBA4EDB358860ED3FFC699342B94EC71E3CCE3
          F15EF4F6F6DD27DFFF8CF32F683B4F744CC79CF60000000049454E44AE426082}
        Name = 'PngImage18'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000011A49
          44415478DA639C3973E69A172F5E04339006C2EBEBEB5781188C8D8D8DFFEBEA
          EA48D2DDD4D4C400348011C580B76FDF32FCFBF70FAC80919111AE18C606D1CC
          CCCC0CFCFCFCD80D78FDFA35C3AD5BB750342003105F535313BF01D834238B31
          3131E136E0CD9B37282E4007045D003200DD4608F8C1F0FF3F3BD876822E68DF
          F2046FE8D7052AE23600140B6D9B1F339829FF6570D5E762B8FCF81DC3AD2722
          70CD379E7F27CE00F19FF740EE077BE1CFA7A760CDCC1C7C0C2FB9758933E0F7
          EDC30C10EF3332FCFFF787E1CFEFEFC030F8C7C0A5E3CD501FA4C4C0C7C787DD
          8077EFDE31B46E7A84370C1A829519787979711B000B7DF4984016C36900D979
          61EAD4A95B8051E84D8A012222222BB3B3B323202145210000AAE4C2117C1197
          580000000049454E44AE426082}
        Name = 'PngImage19'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E000001CD49
          44415478DA6364A0103052D3003512F5DE06E2FF7003848484D49C5C1CAE3132
          323213D2B97BE75EF50F1F3EDC0132FFC10DD0D4D0503330D6BFBE6CC90A267C
          9AA36222FE9D3B7341F3E6CD9BA806D8D9D9ABC929485F5FBC7029D3DD073719
          D8D938C0988D9D1D42B3B23130313131C425C4FC7B70FFB1E6E14387500D080D
          0D53E3E261BFBE60DE22A6078FEF420D606760036256165686FF40C8C1CEC990
          981CFFEFCBA76F9A6BD6AC4135203B2747EDFB8F2FD7E7CE9ECFF4E8E9030656
          5656A046360616161660483332FCFBF7974150409821253DE91F3B0BA7E6B469
          D3500D686E6E567BF4E4C1F55933E6303D7C728F819999858185999981919189
          E1FFFFFF0C7F8106484BC8326464A5FE939290D5ACAFAF473560C6CC996A172F
          9DBD3E6DCA4CA67B0F6F03353232303142C2F3DFFF7F0C7FFFFE6550515467C8
          CECDFCA7ABA3AF999991896AC0FAF5EBD5F6EEDF757DF2C4694C37EF5C03FB19
          2409A2FFFDFB07C63A1A060C798539FF1CED9C35838282500D3876ECA8DACAD5
          CBAF4FE89B8C371A0B4BF2FF8506856B5A5B5BA326A4BB77EEA84D9D3199A884
          949196A3AEAAAA720B25297FFEFC199A94FF4384FF43D8FF19211E81F0612AFE
          33F0F3F1A31A402EA0D800001D3EB411A45BC17D0000000049454E44AE426082}
        Name = 'PngImage20'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000021F49
          44415478DA6364A0103052D30035C2AA19E19AFEFFFF7F1B44C10D1011115173
          74B6BF816CE8817D87D4FFFFFBC7E4E8E2700D59FCD0FEC3EA2F5FBDBA0364FE
          830B6A6A6AAA1918E95D5FB6640513881F1513F1EFD2F9CB9A7F8106181AEB5F
          4516BF7CF1AAE6952B57500DB0B7B757939597BEBE60DE22A63BF76F32B434B7
          FE7BF2E899E69F3F7F981494E4AE82C46FDDBBC6D0D6D2F1EFE9E3E79AFBF7EF
          4735202424448D9B97F3FA94C953995EBD7EC1D0D4DCFCEFDBE79F9A7F7EFF66
          E213E4B93A75CA34A6A72F1E33B4B5B6FFFBF1E5A7E6CA55AB500DC8CCCC54FB
          F9FBFBF5AECE6EA62FDF3E31343535FFE364E3D20479FDFBCFAFD77B7B7A993E
          7DF9C4D0D8D8F88F8B9D4773CA9429A806D4D5D7A93D7FF1F47A436323D39FDF
          BF185A5A5AFF494BCA6A82E49EBD787CBDA3BD93E9F79FDF0C353535FF64A5E4
          34EBEAEB510D009AA876F5FAA5EBD5D5354085BF18802EF9A7A3A5A7095270F9
          DAC5EBED6D9D4C8C4C8C0C151565FFF4740C343333B3500D58B96AA5DAE12307
          AE57945732FDF8F58D6142FFA47FF6B68E4017FC67387878FFF5F6D62E261656
          1686D2B2A27F0E76CE9AC03043350018AA6A1B36AD05FA750213331333436149
          FEBF00DF204D50ECAFDFB006453CC82F58D3CEDE1E352101E3556DDE82D9D718
          1919996162D19151A6EC1C3C9FE6CE9B892A1E15656A646876062529BF7CF552
          0D641E28B582532C90FD9FF13F50012352A287F34029F716D53313590000203C
          FA1120BA3B180000000049454E44AE426082}
        Name = 'PngImage21'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E000001E649
          44415478DA6364A01030E2923817C32009A49E81D8CC4C0CA6FA8B18CE106D00
          4CB37AF3A1FFFF7E7D62BCDDECC3C0C6C220AFB380E1114103E09AEB77FCFF7C
          632DE3B7BB3B1904AD2B18EE4FCCC26A082336CDCA4573FF7DB9B69C89555089
          E1EBCD8D0C0CFFFF3208D93733DC9D9089610823A6E639FF3E1CAC62E290B664
          6013D767F8767D15C3BF9F1F19FEFFFFCFC06F5BCF70B71FD51046A866032075
          5EA568F6BF0F87EB988080814B2384E1EFDB1B0CBFDFDF626015D16660E65764
          F8FFE70703BB9227C3AD962078C0C20CF8AF5C3CEFDFA743D54C4CCC2C0CAC7C
          D20C9C6A810C7F5E5F666062E765601654035AC50476C5FFFFFF18D815DC19AE
          166933182D6160841BA0D5B4F7F3BB5D19BC2CDCA20C5CEAC10CBF9F1C006AE6
          676095B4007BF13F08FE87605661FD1FD76A1D38900D00FB5FB37AFDC7BF5F1F
          F0FFBEB78D8199958B8145548781895706AC096CC43F060626416DB066A08021
          D0800B1881A8DDB0F3D3B763157C4C40B3D935231918D9F9407AC186300968FE
          B8526D0FD22C05D4FC1C67346A952E7CFBF7CE226156050F06460E418801BCAA
          189AB12524E6C98E0C0AD6D20C77B44A17BC63FA72538859488DE19FB0C9EFCB
          45BAACE89A092665ADC6BD5F99989958AFD438B261D34C283381D306948B5533
          5E038805009CABC9112BBC73E10000000049454E44AE426082}
        Name = 'PngImage22'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000008C74
          455874436F6D6D656E74004D656E752D73697A65642069636F6E0A3D3D3D3D3D
          3D3D3D3D3D0A0A2863292032303033204A616B756220276A696D6D6163272053
          7465696E65722C200A687474703A2F2F6A696D6D61632E6D7573696368616C6C
          2E637A0A0A637265617465642077697468207468652047494D502C0A68747470
          3A2F2F7777772E67696D702E6F7267678AC7470000027C4944415478DA95935D
          48935118C7FFEF3BDD14B7D80457496B3357B1BCA9C89004BF2ED2A22E0C4211
          0A136F62B2B94C2C379D8BAC99A62922BB088CA2E8C2BA29CA6EC25558992D90
          2C74929AD644D7E63BB7C28FB7B7F7634D061AF98773385FFFDFF3F09C73888A
          C61ACB6430999CF32D5100546C2B605B5A2CC92CCAE27EFED82459BA75DF7EC5
          8C7544E455769CD6ECD269D49B95E37B53922AD58AF8FDA1151A9F3C0B78FFD6
          F9DB3D3583DD8AA1ED5DB67BDFD604E8ADF6AEE5C0DCD91586C40C2DC72F4912
          4431B128C93F84D4E444DC78F00AF4B40B1AB16F2DBF8DD09B0C4C4DB511AAAD
          3BF0E5EB67784312DC7D398201D730AACA8BE0F15278D1FF06B6B2A3D8A3498E
          3843A1106A2D3520CE55EB99667B07288A02C330088428389E0CC1F9C18DDC9C
          6C28A53178D8DB0763613A72F7A5B13973760662B11866CB0510864A3DD3DADC
          0E3F358FE3E6EEA8FC38C0F8DC0226865D51EB8F1BCF402291C05C1706B45C6B
          83DF3F8FC9EFA330385EA3B4B8102313531103C9864DDDB605B77B1EE1549E16
          27733211171F074BFD4501D0DCD40A8220303B3B8B498F1B55370779887B629A
          0764E8D4B8DEDD8392EC149CC8CA805C2E074DD3A8B3D6AE02B8A248A5D228C8
          F9F26278838BB8C3462ECA54F166A552896030089148B40A68BADA02AFD78B84
          84041EC2E9E3A80B26473F16976994E5EB507AEC304892442010E083C96432D4
          37980540FA81836C5DC305DE80DE0D0E0800438589BD19264C2020D0D88E21C2
          5301BF53ABC5D8989B9D11FCD18ECE360160B35E469FF3796483E147D1CAC9CA
          832251019FDFC783B97DEB258B00686FEB44EFB3A7FF4CB720FF087F53DC63FB
          2BA3A96215F03F5A0FD0C065B3C1FA453ED31F836D12127A8242580000000049
          454E44AE426082}
        Name = 'PngImage23'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000019D49
          44415478DA95934D2F034118C7FFB34A1D245444B35582487A92102FF101487C
          021FC045E222E2E2266E2E2412072E6E2EE2E086E8455321227D41F56DA3D56C
          D956B7F5D2C54AB5A62384B6BB612633C964E6F79B67E69921D02863536B3DD1
          60C4DD6EEBE8DD5C9EF068AD237AF0E2DC3866E6D7A127217A70404CC0E916E0
          77053525440B166E53207456BECF62FFF0126951AA282195E06832CD6042AB94
          7A80F35440757515E87C998494C2A27CCF4026A0DD594084B1C6805CEE1DFE88
          5426213F6129F3C8A0CF06641515A1AB04F8E67A3499EA70EC8E202E67BE2423
          54622783A3B385229C7A54BE772D56E545C56DF201AD7C236A8D06384F041A45
          1E1C47707D2733C9C9EE022946304C07FB2CFC6406F94201C9BB27A86F39A4D2
          5974DB5AF0AAE6108BCBE00887E0CDE731DABADAFAB656265D6577B073700114
          08DBC9CA9B60EB34C3EB13A13CABF046C55FB066161C476126E0E87186FA3B71
          EE8BC3E10B97C1BAEFC0E589A1856F80D562C2D2869DC19676F3C0F6EAF4E99F
          5F622890C09EE7B262FEFFF41728A40B6B0A4A242CDFFFFA8DFF291F89D71A20
          F74FC3FA0000000049454E44AE426082}
        Name = 'PngImage24'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000022449
          44415478DA6364A0103012ABD02865A13A3313F3D57FFFFE3383F8CC4C4CBF4E
          CD8A6627CA00BD8C45425C0C2CCFCB622DD9F49545185E7DF8C190D3B383E1EC
          9C58468206A8E44E6213FE29F820C1C74042474994B177E5E97F1981C64C5553
          76339C9B174FD800B3D485DB1D8C15DDC25DB4994A26EDFAF7FED377A6EC287B
          86A9CB0E325C589084DF00C3C479551AF2A2CD2531564CED0B8EFEBBF7E4ED92
          3F7FFFC679B99A316CDB7D8AE1D2E214DC06E8C6CC741711E0D9D694E9C2B46A
          EFF5FF87CFDC79C2CCF157E9E75786DF0EB6660C070E9F62B8B2341DBB013A91
          D3D4D9D958AFD667B8315FB8F38661CDF6D37F7E33314A5E5F92FE463B62DA7F
          330B338653274E315C5D918569805EE074A1FF1CFF9FE7443BB07DFBCDC0306F
          F5C17FBFFFFD33B9B122FB3C485E336CCA7F1D2353862BE74E335C5F95836A80
          8AE724360E7EE607812E8612D232E28C9BF65FF97FF7CE031435CCAC6CFF1434
          F499EE5E3ECD70736D3EAA015AA193B61BEB2ABA599A68325DB8F71198581819
          783959C1989F8B8541809B152CB6E4C013863B974E30DC5E5F84304035A0AF4A
          4E4AB8D9DBD58269FBE12BFFEFDDB98F357C402E50D63161BA75FE18C3DD4D25
          1003147C3BDDD959D9B6393A5A333D7BF18EE1EA952BBF187FFD92B8B3BDEA3D
          BA018A3E9DFF358C6D196E9C3DCC707F4B39C40065BFAE4B7FFFFCD505B11919
          99FE32FCFDA37D7F47F54D6C2E001AF0F3FFBF7F6C8CC0BC003480B8BC800F50
          6C0000BDE2CF1157FF07B60000000049454E44AE426082}
        Name = 'PngImage25'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FB00FB00FB55596D96000000097048597300000B1200
          000B1201D2DD7EFC0000000774494D45000000000000000973942E0000003E74
          455874436F6D6D656E7400437265617465642077697468205468652047494D50
          0A0A2863292032303033204A616B756220276A696D6D61632720537465696E65
          722733EF58000001BF4944415478DA9D933B6B02411485CFFA46C5C70FF00748
          8829AC6C2D6CC46A0941480A0B0906AD3791252C36491134040B5B098845BAF8
          1BB4D0C6DA0411DF9D200A3E37CE058D9B8D21C96D7667F69E6FCECCD9E14ECF
          F817003CFE57396E03902FA3B13F2B2D160BD28F0FD801EAF53A7DE038EE5700
          9FCFF709B815250C060395988DBF9BD3E974D06834787C4A83BBBFBF9305E11A
          ED765BE1605FFC15643299E07038204992127048B42FD66AB5301A8DB0D96CB8
          B9B9FE04743A1DE47239E4F3798C462304020164B359127BBD5EF47A3D349B4D
          58AD5682389D4E25A0DBED62B158C06030A0582C421445341A0D6A2E97CBE079
          9E5CB29559A91CB0155812914804C3E110894402C964929A6BB51A42A110B9B4
          DBEDE48AC5A8024C2613B25828142008025AAD1639AA56AB0806839494D96CA6
          3360F32A403C1E47A552C16C3643381C462A95825EAF87CBE582C7E341341A25
          276C7515A0DFEFEFF2DD66BD5EAFE90CB629B07736BFFDAE00CCE77312B05AAD
          56F45C2E97D4CCA0B22C2BE2645BDD0162B12B643219D53FF0D3D8ED766FB65B
          06B7D9A7ECF7FB311E8F0F36EF1773C38A1D64A9F44A77E1FCF8E8E4793A9DFC
          F946BE37DF2E3E007ABAD3749008957A0000000049454E44AE426082}
        Name = 'PngImage26'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000001D74
          455874436F6D6D656E7400437265617465642077697468205468652047494D50
          EF64256E0000014D4944415478DA9590CB4AC3401486FF6913B1AFE123140BB1
          6AB5B11595EEDD18F7BE80EFE00BB817DDB855A897D20BBD187AC10BA214C1B5
          E803A8689A717282756C86909C4DC2E4FC5FFEF9D865B5BC05E010D1C65A5DD9
          38920F9800F0A2B91E295DA99D4100580050C8AF61A6B4171A7E3EDD45B571A1
          06984B45183BC7A1007B7F13F566450D58CE15C05D4E07AF6F2F183E3D465402
          8B00B97913AEEBC24374EC06E23821C062368F91E310C0EEB510C709018CCC02
          1C01608CA17F6D238E130264D25938DF5FD4E0F67E00D98937DCFBC227084265
          B35DF301B369031FEF9FB4FA30BC83EC84717F199CE3F795F289045A57751F30
          E75DC11DD1724F5C4176F2D762CCA167524BA22D84B3F2F9C9B6A66B07723BD9
          896AB8A078806EBF83C0C6A413394440EE77D1A77412AE04C84EFCDEC116A9D4
          3406375D35407642D9F19FFFF3940D544E42C6FA015EADCDDB125F0E15000000
          0049454E44AE426082}
        Name = 'PngImage27'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000028E49
          44415478DA7D935F48537114C7BF37CD0A29D2A6D95B565458B4B94D33EAA117
          E945A3E8A11E6219156D3EE45BA252E41F14877F4AA9C99C510B074110414F2B
          4D9D646A9AD8CAF5105B111BA563FFAC76FFAEDFBD77DB5D50FEB88773EEBDE7
          7C7EE7777EE750F661DB1696E51A388EBB4AD3F4669665A1080796CB7C9785E7
          F8489CA62D0CC374528F1C437D795B55C6DDC57BD6E76CD80820213DFF5A82C0
          23128DC21FF063C235CE7CF9EAEB1501ABBAD28A5CC30503DC8B6EACB5120999
          BCBF641F4C461346C65E46287204AE4C7734ABA2A21CF6A73D1012BCE4286A41
          10882D0B2F2488E6A52C0CD50DB00E5AE01C71220D282F2F437D8B91F045A744
          122407A7400201F3020773D303DC1BE8C7E8D8A802D0EB75E8B2D6CBCE440470
          D26E421240B3BF118E2C231C0B62B0ED15FAEFDEC6B86B5C01E8745AD4D49E42
          9DA9090F1D03580EFA492DC98E3C8760F83BE2F19F7221280ACEC76EDCE9EB86
          EBF5A402D09696A2B6E12CF6161FC089E3A7110C2DC3E630E34730205D25894B
          02806743F3E8EE35636A7A4A0168346A549E3C8C025511AE99AE233B6B1D2ED7
          9D938E838C60D19C7EF119E6AE0ECCBC9DC900A809E08C1E2DF53D187E62C39B
          3917321B824AA540D4E4F34FE8E86CC5DCBBF9BF01BB0E6E970A07F1BE89E3EC
          84270D60181AC72A3592ED99F7A3ADBD190B8B0B0A404D003B4B54C9B352A97A
          65A4AE64B034FB0DCDAD37F0FE833B0370488DFC1DB9FF6F434A2945C017C2CD
          5B8DF8E85982D8CABFF4DA239BAAAAAAE1F57AD3EDBAD6CACFCFC3A52B35F0FA
          7CAB0470DFAADA5678B1B0A0283B168B221C0E1309917B8F4BD747A6145C6A12
          459B7C6358062B2B41261A8B5AC423A8C8D8B693D13C4F9C72885646590A9221
          A95196FE332C4D60766237FE010275B00A65A1185E0000000049454E44AE4260
          82}
        Name = 'PngImage28'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A0000030D4944415478DA
          6D934B48546114C7CF7D7CD33C737414664C534A7CF5D004B50229C2162184A6
          A0E8A2889A4C6D51BB422A6C910B575299BA48C4512BA26C1582154961339284
          3506A6A4A3E6736674661C67EEAB7327AFCCC20B87FBDD7BBEF3FBCEF99FF351
          922481F2E45B6DC92A9669020A4EF182686668DA43513011E6843674BF7574D4
          70517B6FE3AB8D520005565B29C3D0BDB999896C46AA8958E2F400E85BF16EC2
          A8733EF0EBCF2A32A55A84F4175CB359D1D58E61C60800695984A547CB8B8F68
          638D1A60F15893410D3A350B062D010DA161D91B8416DBC826021D06ADAA7023
          1022181A17019CACEBEFCCCDB05CD6A8096D1F774188E381B08C70709F31585C
          7040579865A6189A021AEDE58749F1F4B124FA56EB50184B8B8F004E5CEFF361
          B09EE3454914C5203AEE637A3D688759966ECE4A31653694E769138C5A60192A
          527245E30087FB622300AC5F2484118E66A4768F39A7CF61AD4558EB54946097
          B0AA67AD37CF8244D1901CAF85CABB3240DCD18037C7C73465A725BD9A59585D
          9C9A5DF22040DC0E665986FE58599C5D5075269DF8B7F88836158D6F7804EC55
          00060CF0C12E0FFABAF075D114A3091186FEDF32AC62712DA0C695460184F083
          6CC74851F61EED0A1AB70B9BC543E7764A18682E6364B4FCFDCE312B760E8CB9
          0441CCC54DDEE8A87B3667A23FB095F269746278670E7030107081995E0A00C1
          2CEB5B06E5D31B30F84954293A8AA2A60B73D27AFE2EBBF36716D68AF0B72A02
          385EDB2BBC7E5846A3FA806AC3D4FC3AB4F4D9E5A1F9C9F3A20CB223A04EAD22
          0F4CB186B815F7BA2488223FD256AD52E640E86A2CA187BEB9A492C2544AC07F
          1E7F1886BFCF4B438EE9E0923B80578462655DB025548C6E0FB83782CF3F3FAE
          AA523210D392E342932EF794D9A44FB596E6E91270A47D410EE4B679031CAAEE
          87709807BD86C08BC1F14DBC18F99899531151C2317DF4F569F50D5C57E02DEC
          D86F892139E916BD09A78F661858F76D816BD123387ECC8531FDABF6F61A5BA4
          A3DB806EB9D74894B605935B7A5E45987A51920E613762F16E2CA33E5F4261E1
          0EEEFBAD88FB0FBBD29CE1BBCCA7630000000049454E44AE426082}
        Name = 'PngImage29'
        Background = clWindow
      end>
    Left = 408
    Top = 120
    Bitmap = {}
  end
  object PopupMenu1: TPopupMenu
    Images = PngImageList1
    Left = 280
    Top = 184
    object Button1: TMenuItem
      Caption = 'Button'
      ImageIndex = 6
      OnClick = Button1Click
    end
    object CheckBox1: TMenuItem
      Caption = 'CheckBox'
      ImageIndex = 12
      OnClick = CheckBox1Click
    end
    object Edit2: TMenuItem
      Caption = 'Edit'
      ImageIndex = 26
    end
    object Font2: TMenuItem
      Caption = 'Font'
      ImageIndex = 25
      OnClick = Font1Click
    end
    object MiniThrobber3: TMenuItem
      Caption = 'MiniThrobber'
      ImageIndex = 21
      OnClick = MiniThrobber2Click
    end
    object Panel4: TMenuItem
      Caption = 'Panel'
      ImageIndex = 20
      OnClick = Panel4Click
    end
    object Progressbar1: TMenuItem
      Caption = 'Progressbar'
      ImageIndex = 17
      OnClick = Progressbar1Click
    end
    object Progressbarsmallmode2: TMenuItem
      Caption = 'Progressbar (small mode)'
      ImageIndex = 17
      OnClick = Progressbarsmallmode1Click
    end
    object RadioBox2: TMenuItem
      Caption = 'RadioBox'
      ImageIndex = 24
      OnClick = RadioBox1Click
    end
    object SharpBarxmlbasecode1: TMenuItem
      Caption = 'SharpBar (xml base code)'
      ImageIndex = 15
      OnClick = SharpBarxmlbasecode1Click
    end
    object TaskItem1: TMenuItem
      Caption = 'TaskItem'
      ImageIndex = 27
      OnClick = TaskItem1Click
    end
  end
  object JvModernTabBarPainter1: TJvModernTabBarPainter
    Color = 14869218
    BorderColor = 14869218
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    DisabledFont.Charset = DEFAULT_CHARSET
    DisabledFont.Color = clGrayText
    DisabledFont.Height = -11
    DisabledFont.Name = 'Tahoma'
    DisabledFont.Style = []
    SelectedFont.Charset = DEFAULT_CHARSET
    SelectedFont.Color = clWindowText
    SelectedFont.Height = -11
    SelectedFont.Name = 'Tahoma'
    SelectedFont.Style = []
    Left = 320
    Top = 88
  end
  object Skin: TSharpESkin
    Left = 400
    Top = 240
    FileData = {
      00000000000000400000000000000000000000000B000000536D616C6C20466F
      6E74730D00000024576F726B4172656154657874010000003001000000300100
      0000300700000000000000000000000B000000000000000000000B000000536D
      616C6C20466F6E74730D00000024576F726B4172656154657874010000003001
      00000030010000003001000000770700000000000000000000000B000000536D
      616C6C20466F6E74730D00000024576F726B4172656154657874010000003001
      00000030010000003001000000770700000000000000000000000B000000536D
      616C6C20466F6E74730D00000024576F726B4172656154657874010000003001
      000000300100000030010000007707000000010000000006000000427574746F
      6E08020000000000000100000030010000003001000000770100000068FFFFFF
      FFFF000000010007000000243030303030300100000030010000003001000000
      3001000000300000000000000000000000000000000000000000000000000B00
      0000536D616C6C20466F6E74730D00000024576F726B41726561546578740100
      0000300100000030010000003001000000770700000000000000FFFFFFFFFF00
      0000010007000000243030303030300100000030010000003001000000300100
      0000300000000000000000000000000000000000000000000000000B00000053
      6D616C6C20466F6E74730D00000024576F726B41726561546578740100000030
      0100000030010000003001000000770700000000000000FFFFFFFFFF00000001
      0007000000243030303030300100000030010000003001000000300100000030
      0000000000000000000000000000000000000000000000000B000000536D616C
      6C20466F6E74730D00000024576F726B41726561546578740100000030010000
      0030010000003001000000770700000000000000FFFFFFFFFF00000001000700
      0000243030303030300100000030010000003001000000300100000030000000
      0000000000000000000000000000000000000000000B000000536D616C6C2046
      6F6E74730D00000024576F726B41726561546578740100000030010000003001
      00000030010000007707000000000000000B00000050726F6772657373426172
      1002000000000000000000000000000001000000770100000068FFFFFFFFFF00
      0000010007000000243030303030300100000030010000003001000000300100
      0000300000000000000000000000000000000000000000000000000B00000053
      6D616C6C20466F6E74730D00000024576F726B41726561546578740100000030
      0100000030010000003001000000770700000000000000FFFFFFFFFF00000001
      0007000000243030303030300100000030010000003001000000300100000030
      0000000000000000000000000000000000000000000000000B000000536D616C
      6C20466F6E74730D00000024576F726B41726561546578740100000030010000
      0030010000003001000000770700000000000000FFFFFFFFFF00000001000700
      0000243030303030300100000030010000003001000000300100000030000000
      0000000000000000000000000000000000000000000B000000536D616C6C2046
      6F6E74730D00000024576F726B41726561546578740100000030010000003001
      0000003001000000770700000000000000FFFFFFFFFF00000001000700000024
      3030303030300100000030010000003001000000300100000030000000000000
      0000000000000000000000000000000000000B000000536D616C6C20466F6E74
      730D00000024576F726B41726561546578740100000030010000003001000000
      3001000000770700000000000000010000003001000000300800000043686563
      6B426F788302000000000000000000000000000001000000770100000068FFFF
      FFFFFF0000000100070000002430303030303001000000300100000030010000
      003001000000300000000000000000000000000000000000000000000000000B
      000000536D616C6C20466F6E74730D00000024576F726B417265615465787401
      000000300100000030010000003001000000770700000000000000FFFFFFFFFF
      0000000100070000002430303030303001000000300100000030010000003001
      000000300000000000000000000000000000000000000000000000000B000000
      536D616C6C20466F6E74730D00000024576F726B417265615465787401000000
      300100000030010000003001000000770700000000000000FFFFFFFFFF000000
      0100070000002430303030303001000000300100000030010000003001000000
      300000000000000000000000000000000000000000000000000B000000536D61
      6C6C20466F6E74730D00000024576F726B417265615465787401000000300100
      000030010000003001000000770700000000000000FFFFFFFFFF000000010007
      0000002430303030303001000000300100000030010000003001000000300000
      000000000000000000000000000000000000000000000B000000536D616C6C20
      466F6E74730D00000024576F726B417265615465787401000000300100000030
      010000003001000000770700000000000000FFFFFFFFFF000000010007000000
      2430303030303001000000300100000030010000003001000000300000000000
      000000000000000000000000000000000000000B000000536D616C6C20466F6E
      74730D00000024576F726B417265615465787401000000300100000030010000
      00300100000077070000000000000008000000526164696F426F788302000000
      000000000000000000000001000000770100000068FFFFFFFFFF000000010007
      0000002430303030303001000000300100000030010000003001000000300000
      000000000000000000000000000000000000000000000B000000536D616C6C20
      466F6E74730D00000024576F726B417265615465787401000000300100000030
      010000003001000000770700000000000000FFFFFFFFFF000000010007000000
      2430303030303001000000300100000030010000003001000000300000000000
      000000000000000000000000000000000000000B000000536D616C6C20466F6E
      74730D00000024576F726B417265615465787401000000300100000030010000
      003001000000770700000000000000FFFFFFFFFF000000010007000000243030
      3030303001000000300100000030010000003001000000300000000000000000
      000000000000000000000000000000000B000000536D616C6C20466F6E74730D
      00000024576F726B417265615465787401000000300100000030010000003001
      000000770700000000000000FFFFFFFFFF000000010007000000243030303030
      3001000000300100000030010000003001000000300000000000000000000000
      000000000000000000000000000B000000536D616C6C20466F6E74730D000000
      24576F726B417265615465787401000000300100000030010000003001000000
      770700000000000000FFFFFFFFFF000000010007000000243030303030300100
      0000300100000030010000003001000000300000000000000000000000000000
      000000000000000000000B000000536D616C6C20466F6E74730D00000024576F
      726B417265615465787401000000300100000030010000003001000000770700
      0000000000000300000042617208030000000000000000000000000000010000
      0077020000003333010000003401000000330200000031300200000031330100
      0000340100000034020000003130020000003133FFFFFFFFFF00000001000700
      0000243030303030300100000030010000003001000000300100000030000000
      0000000000000000000000000000000000000000000B000000536D616C6C2046
      6F6E74730D00000024576F726B41726561546578740100000030010000003001
      0000003001000000770700000000000000FFFFFFFFFF00000001000700000024
      3030303030300100000030010000003001000000300100000030000000000000
      0000000000000000000000000000000000000B000000536D616C6C20466F6E74
      730D00000024576F726B41726561546578740100000030010000003001000000
      3001000000770700000000000000FFFFFFFFFF00000001000700000024303030
      3030300100000030010000003001000000300100000030000000000000000000
      0000000000000000000000000000000B000000536D616C6C20466F6E74730D00
      000024576F726B41726561546578740100000030010000003001000000300100
      0000770700000000000000FFFFFFFFFF00000001010D00000024576F726B4172
      65614261636B0100000030010000003001000000300100000030000000000000
      00000100000077010000006800000000000000000B000000536D616C6C20466F
      6E74730D00000024576F726B4172656154657874010000003001000000300100
      00003001000000770700000000000000FFFFFFFFFF00000001010D0000002457
      6F726B417265614261636B010000003001000000300100000030010000003000
      000000000000000100000077010000006800000000000000000B000000536D61
      6C6C20466F6E74730D00000024576F726B417265615465787401000000300100
      0000300100000030010000007707000000000000000100000030010000003001
      0000003001000000300200000031340100000037010000003301000000340200
      0000313401000000370100000033010000003401000000300100000030050000
      0050616E656C0602000000000000000000000000000001000000770100000068
      FFFFFFFFFF000000010007000000243030303030300100000030010000003001
      0000003001000000300000000000000000000000000000000000000000000000
      000B000000536D616C6C20466F6E74730D00000024576F726B41726561546578
      7401000000300100000030010000003001000000770700000000000000FFFFFF
      FFFF000000010007000000243030303030300100000030010000003001000000
      3001000000300000000000000000000000000000000000000000000000000B00
      0000536D616C6C20466F6E74730D00000024576F726B41726561546578740100
      0000300100000030010000003001000000770700000000000000FFFFFFFFFF00
      0000010007000000243030303030300100000030010000003001000000300100
      0000300000000000000000000000000000000000000000000000000B00000053
      6D616C6C20466F6E74730D00000024576F726B41726561546578740100000030
      0100000030010000003001000000770700000000000000FFFFFFFFFF00000001
      0007000000243030303030300100000030010000003001000000300100000030
      0000000000000000000000000000000000000000000000000B000000536D616C
      6C20466F6E74730D00000024576F726B41726561546578740100000030010000
      00300100000030010000007707000000000000000C0000004D696E695468726F
      626265728901000000000000000000000000000001000000770100000068FFFF
      FFFFFF0000000100070000002430303030303001000000300100000030010000
      003001000000300000000000000000000000000000000000000000000000000B
      000000536D616C6C20466F6E74730D00000024576F726B417265615465787401
      000000300100000030010000003001000000770700000000000000FFFFFFFFFF
      0000000100070000002430303030303001000000300100000030010000003001
      000000300000000000000000000000000000000000000000000000000B000000
      536D616C6C20466F6E74730D00000024576F726B417265615465787401000000
      300100000030010000003001000000770700000000000000FFFFFFFFFF000000
      0100070000002430303030303001000000300100000030010000003001000000
      300000000000000000000000000000000000000000000000000B000000536D61
      6C6C20466F6E74730D00000024576F726B417265615465787401000000300100
      00003001000000300100000077070000000000000004000000456469741C0200
      00000000000100000030010000003001000000770100000068FFFFFFFFFF0000
      0001000700000024303030303030010000003001000000300100000030010000
      00300000000000000000000000000000000000000000000000000B000000536D
      616C6C20466F6E74730D00000024576F726B4172656154657874010000003001
      00000030010000003001000000770700000000000000FFFFFFFFFF0000000100
      0700000024303030303030010000003001000000300100000030010000003000
      00000000000000000000000000000000000000000000000B000000536D616C6C
      20466F6E74730D00000024576F726B4172656154657874010000003001000000
      30010000003001000000770700000000000000FFFFFFFFFF0000000100070000
      0024303030303030010000003001000000300100000030010000003000000000
      00000000000000000000000000000000000000000B000000536D616C6C20466F
      6E74730D00000024576F726B4172656154657874010000003001000000300100
      0000300100000077070000000000000001000000300100000030010000003001
      00000030FFFFFFFFFF0000000100070000002430303030303001000000300100
      0000300100000030010000003000000000000000000000000000000000000000
      00000000000B000000536D616C6C20466F6E74730D00000024576F726B417265
      6154657874010000003001000000300100000030010000007707000000000000
      0004000000466F726DBA00000000000000000000000000000001000000770100
      000068FFFFFFFFFF000000010007000000243030303030300100000030010000
      0030010000003001000000300000000000000000000000000000000000000000
      000000000B000000536D616C6C20466F6E74730D00000024576F726B41726561
      5465787401000000300100000030010000003001000000770700000000000000
      0100000035010000003501000000350100000035010000003501000000350400
      0000772D31300100000035080000005461736B4974656D070500000000000001
      00000030010000003001000000770100000068FFFFFFFFFF0000000100070000
      0024303030303030010000003001000000300100000030010000003000000000
      00000000000000000000000000000000000000000B000000536D616C6C20466F
      6E74730D00000024576F726B4172656154657874010000003001000000300100
      00003001000000770700000000000000FFFFFFFFFF0000000100070000002430
      3030303030010000003001000000300100000030010000003000000000000000
      00000000000000000000000000000000000B000000536D616C6C20466F6E7473
      0D00000024576F726B4172656154657874010000003001000000300100000030
      01000000770700000000000000FFFFFFFFFF0000000100070000002430303030
      3030010000003001000000300100000030010000003000000000000000000000
      00000000000000000000000000000B000000536D616C6C20466F6E74730D0000
      0024576F726B4172656154657874010000003001000000300100000030010000
      007707000000000000000600000063772D747768010000003001000000320200
      00003136020000002D31020000002D3101000000300100000030010000007701
      00000068FFFFFFFFFF0000000100070000002430303030303001000000300100
      0000300100000030010000003000000000000000000000000000000000000000
      00000000000B000000536D616C6C20466F6E74730D00000024576F726B417265
      6154657874010000003001000000300100000030010000007707000000000000
      00FFFFFFFFFF0000000100070000002430303030303001000000300100000030
      0100000030010000003000000000000000000000000000000000000000000000
      00000B000000536D616C6C20466F6E74730D00000024576F726B417265615465
      787401000000300100000030010000003001000000770700000000000000FFFF
      FFFFFF0000000100070000002430303030303001000000300100000030010000
      003001000000300000000000000000000000000000000000000000000000000B
      000000536D616C6C20466F6E74730D00000024576F726B417265615465787401
      0000003001000000300100000030010000007707000000000000000100000030
      010000003001000000320200000031360100000030020000002D310100000030
      010000003001000000770100000068FFFFFFFFFF000000010007000000243030
      3030303001000000300100000030010000003001000000300000000000000000
      000000000000000000000000000000000B000000536D616C6C20466F6E74730D
      00000024576F726B417265615465787401000000300100000030010000003001
      000000770700000000000000FFFFFFFFFF000000010007000000243030303030
      3001000000300100000030010000003001000000300000000000000000000000
      000000000000000000000000000B000000536D616C6C20466F6E74730D000000
      24576F726B417265615465787401000000300100000030010000003001000000
      770700000000000000FFFFFFFFFF000000010007000000243030303030300100
      0000300100000030010000003001000000300000000000000000000000000000
      000000000000000000000B000000536D616C6C20466F6E74730D00000024576F
      726B417265615465787401000000300100000030010000003001000000770700
      000000000000010000003001000000300100000032020000003136020000002D
      31010000003003000000456E64}
  end
  object Scheme: TSharpEScheme
    Throbberback = 11962738
    Throbberdark = 5981241
    Throbberlight = 12948877
    Throbbertext = clBlack
    WorkAreaback = 13290186
    WorkAreadark = 7697781
    WorkArealight = 16119285
    WorkAreatext = clBlack
    Left = 432
    Top = 280
  end
  object SaveSkinDialog: TSaveDialog
    DefaultExt = '*.xml'
    Filter = 'SharpESkin (*.xml)|*.xml'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Select new filename and location'
    Left = 336
    Top = 128
  end
  object PopupMenu2: TPopupMenu
    Images = PngImageList1
    Left = 352
    Top = 176
    object Advanced1: TMenuItem
      Caption = 'Advanced'
      ImageIndex = 14
      OnClick = Advanced1Click
    end
    object Basic1: TMenuItem
      Caption = 'Basic'
      ImageIndex = 14
      OnClick = Basic1Click
    end
    object Emptynoimage2: TMenuItem
      Caption = 'Empty (no image)'
      ImageIndex = 14
      OnClick = Emptynoimage1Click
    end
  end
  object ExportDialog1: TSaveDialog
    DefaultExt = '*.skin'
    Filter = 'SharpE Skin|*.skin'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofNoReadOnlyReturn, ofEnableSizing, ofForceShowHidden]
    Title = 'Select target file'
    Left = 408
    Top = 168
  end
end
