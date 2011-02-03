object frmSettingsWnd: TfrmSettingsWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettingsWnd'
  ClientHeight = 595
  ClientWidth = 434
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 30
    Width = 434
    Height = 0
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 1
  end
  object plMain: TJvPageList
    Left = 0
    Top = 30
    Width = 434
    Height = 565
    ActivePage = pagFontShadow
    PropagateEnable = False
    Align = alClient
    object pagFont: TJvStandardPage
      Left = 0
      Top = 0
      Width = 434
      Height = 565
      Caption = 'pagFont'
	  object pnlFont: TPanel
        Left = 1
        Top = 1
        Width = 566
        Height = 580
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
		  object uicFontSize: TSharpEUIC
			AlignWithMargins = True
			Left = 5
			Top = 127
			Width = 424
			Height = 22
			Margins.Left = 5
			Margins.Top = 10
			Margins.Right = 5
			Margins.Bottom = 10
			Align = alTop
			AutoSize = True
			BevelOuter = bvNone
			Caption = 'uicFontSize'
			Color = clWhite
			ParentBackground = False
			TabOrder = 1
			HasChanged = False
			AutoReset = True
			DefaultValue = '0'
			MonitorControl = sgbFontSize
			OnReset = UIC_Reset
			object sgbFontSize: TSharpeGaugeBox
			  Left = 0
			  Top = 0
			  Width = 250
			  Height = 22
			  Margins.Left = 0
			  Margins.Top = 0
			  Margins.Right = 0
			  Margins.Bottom = 5
			  Align = alLeft
			  ParentBackground = False
			  TabOrder = 0
			  Min = -8
			  Max = 8
			  Value = 0
			  Suffix = ' px'
			  Description = 'Change font size by'
			  PopPosition = ppBottom
			  PercentDisplay = False
			  Formatting = '%d'
			  OnChangeValue = SgbUicValueChanged
			  BackgroundColor = clWindow
			end
		  end
		  object uicFontType: TSharpEUIC
			AlignWithMargins = True
			Left = 5
			Top = 47
			Width = 424
			Height = 23
			Margins.Left = 5
			Margins.Top = 10
			Margins.Right = 5
			Margins.Bottom = 10
			Align = alTop
			AutoSize = True
			BevelOuter = bvNone
			Color = clWhite
			ParentBackground = False
			TabOrder = 0
			HasChanged = False
			AutoReset = False
			DefaultValue = '-1'
			MonitorControl = cboFontName
			OnReset = UIC_Reset
			object cboFontName: TComboBox
			  Left = 0
			  Top = 0
			  Width = 250
			  Height = 25
			  Margins.Left = 0
			  Margins.Top = 0
			  Margins.Right = 0
			  Margins.Bottom = 0
			  Align = alLeft
			  Style = csOwnerDrawVariable
			  DropDownCount = 20
			  Font.Charset = DEFAULT_CHARSET
			  Font.Color = clWindowText
			  Font.Height = -11
			  Font.Name = 'Tahoma'
			  Font.Style = []
			  ItemHeight = 19
			  ParentFont = False
			  TabOrder = 0
			  OnChange = controlUicValueChanged
			  OnDrawItem = cboFontNameDrawItem
			end
		  end
		  object uicAlpha: TSharpEUIC
			AlignWithMargins = True
			Left = 5
			Top = 206
			Width = 424
			Height = 22
			Margins.Left = 5
			Margins.Top = 10
			Margins.Right = 5
			Margins.Bottom = 10
			Align = alTop
			AutoSize = True
			BevelOuter = bvNone
			Caption = 'UIC_Size'
			Color = clWhite
			ParentBackground = False
			TabOrder = 2
			HasChanged = False
			AutoReset = True
			DefaultValue = '0'
			MonitorControl = sgbFontVisibility
			OnReset = UIC_Reset
			object sgbFontVisibility: TSharpeGaugeBox
			  Left = 0
			  Top = 0
			  Width = 250
			  Height = 22
			  Margins.Left = 0
			  Margins.Top = 0
			  Margins.Right = 0
			  Margins.Bottom = 5
			  Align = alLeft
			  ParentBackground = False
			  TabOrder = 0
			  Min = -255
			  Max = 255
			  Value = 0
			  Suffix = '% visible'
			  Description = 'Change font opacity'
			  PopPosition = ppBottom
			  PercentDisplay = True
			  Formatting = '%d'
			  OnChangeValue = SgbUicValueChanged
			  BackgroundColor = clWindow
			end
		  end
		  object uicBold: TSharpEUIC
			AlignWithMargins = True
			Left = 5
			Top = 417
			Width = 424
			Height = 22
			Margins.Left = 5
			Margins.Top = 5
			Margins.Right = 5
			Margins.Bottom = 0
			Align = alTop
			AutoSize = True
			BevelOuter = bvNone
			Color = clWhite
			ParentBackground = False
			TabOrder = 6
			HasChanged = False
			AutoReset = False
			DefaultValue = 'False'
			MonitorControl = chkBold
			OnReset = UIC_Reset
			object chkBold: TJvXPCheckbox
			  Left = 0
			  Top = 0
			  Width = 49
			  Height = 22
			  Margins.Left = 0
			  Margins.Top = 0
			  Margins.Right = 0
			  Margins.Bottom = 5
			  Caption = 'Bold'
			  TabOrder = 0
			  Align = alLeft
			  OnClick = controlUicValueChanged
			end
		  end
		  object uicItalic: TSharpEUIC
			AlignWithMargins = True
			Left = 5
			Top = 357
			Width = 424
			Height = 25
			Margins.Left = 5
			Margins.Top = 5
			Margins.Right = 5
			Margins.Bottom = 0
			Align = alTop
			AutoSize = True
			BevelOuter = bvNone
			Color = clWhite
			ParentBackground = False
			TabOrder = 4
			HasChanged = False
			AutoReset = False
			DefaultValue = 'False'
			MonitorControl = chkItalic
			OnReset = UIC_Reset
			object chkItalic: TJvXPCheckbox
			  Left = 0
			  Top = 0
			  Width = 53
			  Height = 25
			  Margins.Left = 0
			  Margins.Top = 0
			  Margins.Right = 0
			  Margins.Bottom = 5
			  Caption = 'Italic'
			  TabOrder = 0
			  Align = alLeft
			  OnClick = controlUicValueChanged
			end
		  end
		  object uicUnderline: TSharpEUIC
			AlignWithMargins = True
			Left = 5
			Top = 387
			Width = 424
			Height = 25
			Margins.Left = 5
			Margins.Top = 5
			Margins.Right = 5
			Margins.Bottom = 0
			Align = alTop
			AutoSize = True
			BevelOuter = bvNone
			Caption = 'UIC_Size'
			Color = clWhite
			ParentBackground = False
			TabOrder = 5
			HasChanged = False
			AutoReset = False
			DefaultValue = 'False'
			MonitorControl = chkUnderline
			OnReset = UIC_Reset
			object chkUnderline: TJvXPCheckbox
			  Left = 0
			  Top = 0
			  Width = 73
			  Height = 25
			  Margins.Left = 0
			  Margins.Top = 0
			  Margins.Right = 0
			  Margins.Bottom = 5
			  Caption = 'Underline'
			  TabOrder = 0
			  Align = alLeft
			  OnClick = controlUicValueChanged
			end
		  end
		  object uicCleartype: TSharpEUIC
			AlignWithMargins = True
			Left = 5
			Top = 280
			Width = 424
			Height = 25
			Margins.Left = 5
			Margins.Top = 5
			Margins.Right = 5
			Margins.Bottom = 10
			Align = alTop
			AutoSize = True
			BevelOuter = bvNone
			Color = clWhite
			ParentBackground = False
			TabOrder = 3
			HasChanged = False
			AutoReset = False
			DefaultValue = '0'
			MonitorControl = chkCleartype
			OnReset = UIC_Reset
			object chkCleartype: TJvXPCheckbox
			  Left = 0
			  Top = 0
			  Width = 141
			  Height = 25
			  Margins.Left = 0
			  Margins.Top = 0
			  Margins.Right = 0
			  Margins.Bottom = 5
			  Caption = 'Apply cleartype fonts'
			  TabOrder = 0
			  Align = alLeft
			  OnClick = controlUicValueChanged
			end
		  end
		  object SharpECenterHeader1: TSharpECenterHeader
			AlignWithMargins = True
			Left = 5
			Top = 0
			Width = 424
			Height = 37
			Margins.Left = 5
			Margins.Top = 0
			Margins.Right = 5
			Margins.Bottom = 0
			Title = 'Font Type'
			Description = 
			  'Define the font face that you would like to use for the current ' +
			  'skin'
			TitleColor = clWindowText
			DescriptionColor = clRed
			Align = alTop
		  end
		  object SharpECenterHeader11: TSharpECenterHeader
			AlignWithMargins = True
			Left = 5
			Top = 80
			Width = 424
			Height = 37
			Margins.Left = 5
			Margins.Top = 0
			Margins.Right = 5
			Margins.Bottom = 0
			Title = 'Font Size'
			Description = 'Define by how much you want to adjust the skins font size'
			TitleColor = clWindowText
			DescriptionColor = clRed
			Align = alTop
		  end
		  object SharpECenterHeader2: TSharpECenterHeader
			AlignWithMargins = True
			Left = 5
			Top = 159
			Width = 424
			Height = 37
			Margins.Left = 5
			Margins.Top = 0
			Margins.Right = 5
			Margins.Bottom = 0
			Title = 'Font Visibility'
			Description = 'Define how visible the font is when applied to the skin'
			TitleColor = clWindowText
			DescriptionColor = clRed
			Align = alTop
		  end
		  object SharpECenterHeader3: TSharpECenterHeader
			AlignWithMargins = True
			Left = 5
			Top = 238
			Width = 424
			Height = 37
			Margins.Left = 5
			Margins.Top = 0
			Margins.Right = 5
			Margins.Bottom = 0
			Title = 'Clear Font'
			Description = 'Define whether to use Cleartype for the current skins font'
			TitleColor = clWindowText
			DescriptionColor = clRed
			Align = alTop
		  end
		  object SharpECenterHeader13: TSharpECenterHeader
			AlignWithMargins = True
			Left = 5
			Top = 315
			Width = 424
			Height = 37
			Margins.Left = 5
			Margins.Top = 0
			Margins.Right = 5
			Margins.Bottom = 0
			Title = 'Font Style'
			Description = 'Define which styles are applied to the font'
			TitleColor = clWindowText
			DescriptionColor = clRed
			Align = alTop
		  end
	  end
    end
    object pagFontShadow: TJvStandardPage
      Left = 0
      Top = 0
      Width = 434
      Height = 565
      Caption = 'pagFontShadow'
	  object pnlFontShadow: TPanel
        Left = 1
        Top = 1
        Width = 566
        Height = 246
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
		  object uicShadow: TSharpEUIC
			AlignWithMargins = True
			Left = 5
			Top = 0
			Width = 424
			Height = 25
			Margins.Left = 5
			Margins.Top = 0
			Margins.Right = 5
			Margins.Bottom = 10
			Align = alTop
			AutoSize = True
			BevelOuter = bvNone
			Caption = 'UIC_Size'
			Color = clWhite
			ParentBackground = False
			TabOrder = 0
			HasChanged = False
			AutoReset = False
			DefaultValue = 'False'
			MonitorControl = chkShadow
			OnReset = UIC_Reset
			object chkShadow: TJvXPCheckbox
			  Left = 0
			  Top = 0
			  Width = 177
			  Height = 25
			  Margins.Left = 5
			  Margins.Top = 5
			  Margins.Right = 0
			  Margins.Bottom = 5
			  Caption = 'Override font shadow options'
			  TabOrder = 0
			  Align = alLeft
			  DragKind = dkDock
			  OnClick = controlUicValueChanged
			end
		  end
		  object textpanel: TPanel
			Left = 0
			Top = 35
			Width = 434
			Height = 530
			Align = alTop
			BevelOuter = bvNone
			ParentColor = True
			TabOrder = 1
			AutoSize = True
			object uicShadowType: TSharpEUIC
			  AlignWithMargins = True
			  Left = 5
			  Top = 47
			  Width = 424
			  Height = 25
			  Margins.Left = 5
			  Margins.Top = 10
			  Margins.Right = 5
			  Margins.Bottom = 10
			  Align = alTop
			  AutoSize = True
			  BevelOuter = bvNone
			  Color = clWhite
			  ParentBackground = False
			  TabOrder = 0
			  HasChanged = True
			  AutoReset = False
			  DefaultValue = '-1'
			  MonitorControl = cboShadowType
			  OnReset = UIC_Reset
			  object cboShadowType: TComboBox
				Left = 0
				Top = 0
				Width = 250
				Height = 23
				Margins.Left = 5
				Margins.Top = 5
				Margins.Right = 0
				Margins.Bottom = 5
				Align = alLeft
				Style = csOwnerDrawFixed
				DropDownCount = 12
				ItemHeight = 17
				ItemIndex = 0
				TabOrder = 0
				Text = 'Left'
				OnChange = controlUicValueChanged
				Items.Strings = (
				  'Left'
				  'Right'
				  'Outline')
			  end
			end
			object uicShadowAlpha: TSharpEUIC
			  AlignWithMargins = True
			  Left = 5
			  Top = 129
			  Width = 424
			  Height = 22
			  Margins.Left = 5
			  Margins.Top = 10
			  Margins.Right = 5
			  Margins.Bottom = 8
			  Align = alTop
			  AutoSize = True
			  BevelOuter = bvNone
			  Color = clWhite
			  ParentBackground = False
			  TabOrder = 1
			  HasChanged = False
			  AutoReset = True
			  DefaultValue = '0'
			  MonitorControl = sgbShadowAlpha
			  OnReset = UIC_Reset
			  object sgbShadowAlpha: TSharpeGaugeBox
				Left = 0
				Top = 0
				Width = 250
				Height = 22
				Margins.Left = 5
				Margins.Top = 5
				Margins.Right = 0
				Margins.Bottom = 5
				Align = alLeft
				ParentBackground = False
				TabOrder = 0
				Min = -255
				Max = 255
				Value = 0
				Suffix = '% visible'
				Description = 'Change shadow opacity'
				PopPosition = ppBottom
				PercentDisplay = True
				Formatting = '%d'
				OnChangeValue = SgbUicValueChanged
				BackgroundColor = clWindow
			  end
			end
			object SharpECenterHeader5: TSharpECenterHeader
			  AlignWithMargins = True
			  Left = 5
			  Top = 0
			  Width = 424
			  Height = 37
			  Margins.Left = 5
			  Margins.Top = 0
			  Margins.Right = 5
			  Margins.Bottom = 0
			  Title = 'Font shadow type'
			  Description = 'Define the type of shadow effect to apply to the skins font'
			  TitleColor = clWindowText
			  DescriptionColor = clRed
			  Align = alTop
			end
			object SharpECenterHeader6: TSharpECenterHeader
			  AlignWithMargins = True
			  Left = 5
			  Top = 82
			  Width = 424
			  Height = 37
			  Margins.Left = 5
			  Margins.Top = 0
			  Margins.Right = 5
			  Margins.Bottom = 0
			  Title = 'Font shadow visiblity'
			  Description = 'Define how visible the font shadow is when applied to the skin'
			  TitleColor = clWindowText
			  DescriptionColor = clRed
			  Align = alTop
			end
		  end
		end
	end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 4
    Top = 0
    Width = 425
    Height = 25
    Margins.Left = 4
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 0
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 20
      Height = 25
      Align = alLeft
      Center = True
      Picture.Data = {
        0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000001000
        00001008060000001FF3FF610000000467414D410000AFC837058AE900000019
        74455874536F6674776172650041646F626520496D616765526561647971C965
        3C000002DE4944415478DAA5936D48935114C7FF8FAFB939B569E566A66E0E09
        5F52D1FAB01484243045D028B050F04B5129FA21B21714853E242488A4465128
        BD510D47504465465343372A34CB395F524B4D5D6A5337F7BCDCEE1ECB0F995F
        EAC0E5C2BDF7FCCE39FF7B0E4308C1FF18F32720A7D1AC66052E8F7042FE8A93
        0DE6880002610A109A798EBF6338AB1DDA1090DDF029D7E964EB22FC89627758
        00FCBCDCC5F3053B0783E51B7A271627A94791B16A9F6E1D20ABBE2FD769679B
        D2351269CC7619BECE3A31B560072F10F84BDCA1F4DF04CBAC0D2DAD834BF040
        81B1365BB706C8ACEB55B12C67488F942AA31432740FCF83E358EC0ADB0CD0FB
        B7237360DC18442B7C313E6783FED9C004889062BC76785804ECAF7D571E2125
        9599F14A749AADE0594E8C5C752446CCEEFCEDF714047879B8212E4C8E27DD66
        987B662A4CB78E568980B41A93253F6E4BE4A29DC59875913A53E1E84A54CB5D
        7EE81A985C2D98BE5506FA41EEEF8D1BD73B068DF70B3522407BB163F9747AB8
        4FB7791676270796672980C795E35A1170A2DE200269C5F0F460901A1B8A4B35
        8FED26DD498908482E6F5B3E97A1F1793360C5927D913E26AE603875201AE1DB
        64286DA4007AE08279D28F494B52A1BAFA91DDA42FFE0D786139961A1E695D70
        627CE607789A8140231665C522225886E2BA57347D573F106C0D942124C40FCD
        575B078D2D25AB2524973D2DDFA9F0AECC4850A1FDC3172A228F6C6D38D21343
        E146D5EF199AC1E57B5D2E11A08D57A1B5D38C918FA315C696D25511934B5A54
        58E10C99691A65845C8AF6BE7170AE9FE07910BA935FD113A276609675E0F903
        C30403A418F56786D71A29A9F06E2EB1399A327262A5AA2019FA47A731F3DD06
        8113200F9040131A84CFF336BC7CD8B604C6B3803AEBD6B572D2A19BB920CE3A
        75B442B1774F24027DBDC4B4A7171C78DDD98FB13ECB24C3B81519F565BABFCE
        82CB920F36A809E1F3A868F9101CC12EF11886A1C3846606EC9D6EFD858D87E9
        5FEC27BCCF85F03B2A06720000000049454E44AE426082}
      ExplicitHeight = 41
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 22
      Top = 5
      Width = 258
      Height = 15
      Margins.Left = 2
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'The options below will override the default skin values'
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object btnRevert: TPngSpeedButton
      Left = 316
      Top = 2
      Width = 81
      Height = 22
      Caption = 'Revert All'
      Flat = True
      OnClick = btnRevertClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000002544944415478DA95924D68D36018C79F7C746D92A6B5DD
        86B2B5540FE2A111BC7A109908823741D4F939F5205E4451F4EC511041143C09
        DE446FE2555BBFE7C9EDD04EBC48B77569BA43ED47DABC5992373E6F628BA5DB
        612F24E125EFEFF73CF93FE17CDF87ED2C7BEEAA1C7DF1BCD7DF7343823BF772
        788FC3C307E54DE14B57F2BEEB1CA58EBB20BF7EF96958C06041A8B0BD6FDB1A
        FFF8D190C4BE78398FEF4B5C740C36EAEBAF50745F7DFBE66728F80743340A4C
        E7773A4009D1C4674F0309B93097E778BE242454109349B057AB400CE326759C
        27A1E0F6DD984F69172489E7541568BB0DB4D94489A561BBC0601EE148220964
        AD0A76CDF0109652C577CEE013E88D5B31DFF34C4E92041E0F7AAD26B87F1AE0
        A3404069249900525D63953D6C3F9E2ABE272321BAD7AEC7A8EB99BC2C0B626A
        078047D1CC2E0F2B33B81EC21F0A64F3298461A1C4ED4AB9DD3CAC2CA3C403C8
        4C4373619152D751D21F8BE4FFF323026BF63C06C69562D319804A25EC0005AD
        A525703AA63631FFA5BCA5C03A732E0F088BB28281A908FB41FB4C42EA75B00C
        03363A1D6DE7E28FF288A077FA6C5039841360D57406B1B4B9582ACD2B53BBA0
        5733A0A7EB2831B5A95F4BE581A0776A3698B328CB08C7C1D20D20EB0C76E318
        1AE0D394C6D3829ACD4057AF411703659D642ABFCB81C03C7172868F888588A2
        806B76C14218C7171FFFF63908CCD87F0047EC9ACAE4A4C0CE986C228DC691EC
        EA7271F009AD63C751122938ED16C58A0A863594B6BE775FF09F8CA9AAD08747
        426C1C3A3C83F0FCC4F7AF43707F55737B98E460B6BA52DC728CDB5D7F01E142
        7068B693C6920000000049454E44AE426082}
    end
  end
  object imlFontIcons: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002074944415478DA63FCFFFF3F03258091660638B4DF7460
          666170656366E2FFF5FBFFEFBFBFFF3332323070FD7CFFFBC38FF73F9BFFFCFC
          FBE5D252B3FF380DB06BBE11ACA7C2DDAD2ACAAEF8EFDF3F863F7F19189EBDFD
          FDE7E2AD2FBBDFDEFB1A727189C937BC2EB0AEBD2E232DC93E4F5698CD82E1FF
          3FE67F7F1898CE5EFEB4F0D38B1F0517169AFC20E8059BCAABE526BA7C0DD71F
          FDD8F6E7DB9FCFF6067CF13BF6BF9E756CB2413AC130B028BCA4A4ADC57BE0F7
          EF7F7FAF5FFE5C0A14D2717710AEDF77F8FDB26353F4A2F11A609A759199578C
          7DB9863C87EFA9E3EFF27F7FFFB3848585B9CECD55B4FCF4952F971F5F786372
          739BDD2F9C0698655D8831321698F5EADDEFDBF7AF7CACFDFBEBCF1D4E3EB632
          677B91F89B0FBE7FBE74E099F4ED5D8E9FB11A60947C5654C780FFAAB408BBE8
          C53BDFAE7C78FEFDFEFF7FFF997984D8956DF4F8D4AFDEFBF6EBECEE274A77F7
          3B3DC530C020F60C23BF38C72C5B53FE94DD7B5FCD3A39CB181E58E6C967373A
          D80AFB3D7EF99BE1C4D607CAF70EB9DE4331403FE634172333A395ABABD8EEC7
          2F7EBEBD72EC75E095755687410A545CF70B3333B3E4B8F849357CFDF99FE1E0
          8687A17F7FFE5CF7E884D73FB8011619E7D7A9AAF304303332327EF8FCE7DDED
          B36F16FCF8F4B3F9FFDFFF529C7CEC15E22A7C1EFCBC6CA27FFEFD677872F3C3
          BE374F3E943C3EEE759EB679816E0600004C431AF0FB9EBF8C0000000049454E
          44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000774494D45000000000000000973942E000000097048597300001EC1
          00001EC101C3695453000001E14944415478DA6364A010300E0D0322A63E4EFB
          F78F61263B2B23C3C76F7F953715C9DF23D9057E7D0FFFFFFBFFFFDE96620565
          AC2E00DA12FAE7EFFF8E7FFF1994B8399818DE7FF903B4ED5FE7E15AA50A9FDE
          07C65C6CCC67DE7FFDB3E7D79FFFEF81EA047FFFFD3FEB5493CA6AB00161931F
          2BB1B230DC053AEFDE9FBF0C26DF7FFD2B5797622F3F73F7FB9E73AD2AAEAE1D
          F7CBA584583BEE3CFFB907A8F1ACAC085BF99337BFC0DE61843A4F0968EACC1F
          BFFF831430FCFCFD2F544D8ADDF8CC9D6F9D377AD42BAC1BEFEE068ABBB03233
          3282E43F7DFB7B46949FD5F8F9EBAFAE60033CBA1E84026DEDE06667527AF1E1
          CF596B0D6EE373F7BE31BC78F3C5F5EE64FD3D667577FE7FFBF96FF5954EB530
          93DA3B099A321CF38181FAEBE4F5F7EC6003807EFCFFEAE39FF73F7FFD77FDF9
          E79F92830EEF2AA02DBF44F858B8F65FF91C2BC6CF3AFFF1EB9F9DB7FA342A34
          4A6E9E3155E136BEF7F2E79EA3F5CAAE8CB6CDF73AA48558CBAF3CFAFEFED7CF
          3F9D169A7CD5775FFCE405FA33ECCFBFFFAB2FDDFF365356943D0D6640ECCC27
          FF19FE3330DC7CF6230C1E884053EFFEFDF357E9EF9F5F67CD3485FF31333198
          1EBFFAF66C8C93A4C9B203AFEE82D4FCFFFF8FE1FFDF3F4ADACA221F5F7EFC9D
          0AD23C849232CD0C5048D92F0800DFD0061977BB0EC50000000049454E44AE42
          6082}
        Name = 'PngImage1'
        Background = clWindow
      end>
    Left = 368
    Top = 44
    Bitmap = {}
  end
end
