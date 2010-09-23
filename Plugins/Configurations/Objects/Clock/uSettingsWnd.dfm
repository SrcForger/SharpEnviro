object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 446
  ClientWidth = 445
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object plMain: TJvPageList
    Left = 0
    Top = 30
    Width = 445
    Height = 416
    ActivePage = pagDigital
    PropagateEnable = False
    Align = alClient
    object pagAnalog: TJvStandardPage
      Left = 0
      Top = 0
      Width = 445
      Height = 416
      object pnlAnalog: TPanel
        Left = 0
        Top = 0
        Width = 445
        Height = 414
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object Panel69: TPanel
          Left = 0
          Top = 0
          Width = 445
          Height = 44
          Align = alTop
          BevelOuter = bvNone
          Ctl3D = True
          ParentColor = True
          ParentCtl3D = False
          TabOrder = 0
          object SharpECenterHeader2: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 0
            Width = 435
            Height = 37
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 10
            Title = 'Analog Skin'
            Description = 'Select the analog clock skin which you want to use'
            TitleColor = clWindowText
            DescriptionColor = clRed
            Align = alTop
          end
        end
        object pnlAnalogSkin: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 44
          Width = 435
          Height = 365
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          BevelOuter = bvNone
          Caption = 'pnlAnalogSkin'
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 1
          object lbAnalogSkins: TSharpEListBoxEx
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 435
            Height = 365
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Columns = <
              item
                Width = 256
                HAlign = taLeftJustify
                VAlign = taVerticalCenter
                ColumnAlign = calLeft
                StretchColumn = False
                ColumnType = ctDefault
                VisibleOnSelectOnly = False
                Images = imlFontIcons
              end
              item
                Width = 30
                HAlign = taLeftJustify
                VAlign = taVerticalCenter
                ColumnAlign = calRight
                StretchColumn = False
                ColumnType = ctDefault
                VisibleOnSelectOnly = False
                Images = imlFontIcons
              end>
            Colors.BorderColor = clBtnFace
            Colors.BorderColorSelected = clBtnShadow
            Colors.ItemColor = clWindow
            Colors.ItemColorSelected = clBtnFace
            Colors.CheckColorSelected = clBtnFace
            Colors.CheckColor = 15528425
            Colors.DisabledColor = clBlack
            DefaultColumn = 0
            ItemHeight = 30
            OnClickItem = lbAnalogSkinsClickItem
            OnGetCellCursor = lbAnalogSkinsGetCellCursor
            OnGetCellText = lbAnalogSkinsGetCellText
            OnGetCellImageIndex = lbAnalogSkinsGetCellImageIndex
            AutosizeGrid = True
            BevelInner = bvNone
            BevelOuter = bvNone
            Borderstyle = bsNone
            Align = alClient
          end
        end
      end
    end
    object pagDigital: TJvStandardPage
      Left = 0
      Top = 0
      Width = 445
      Height = 416
      object pnlDigital: TPanel
        Left = 0
        Top = 0
        Width = 445
        Height = 414
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 445
          Height = 44
          Align = alTop
          BevelOuter = bvNone
          Ctl3D = True
          ParentColor = True
          ParentCtl3D = False
          TabOrder = 0
          object SharpECenterHeader1: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 0
            Width = 435
            Height = 37
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 10
            Title = 'Skin'
            Description = 'Select the digital clock skin which you want to use'
            TitleColor = clWindowText
            DescriptionColor = clRed
            Align = alTop
          end
        end
        object pnlDigitalSkin: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 44
          Width = 435
          Height = 365
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          BevelOuter = bvNone
          Caption = 'pnlSkin'
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 1
          object lbDigitalSkins: TSharpEListBoxEx
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 435
            Height = 365
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Columns = <
              item
                Width = 256
                HAlign = taLeftJustify
                VAlign = taVerticalCenter
                ColumnAlign = calLeft
                StretchColumn = False
                ColumnType = ctDefault
                VisibleOnSelectOnly = False
                Images = imlFontIcons
              end
              item
                Width = 30
                HAlign = taLeftJustify
                VAlign = taVerticalCenter
                ColumnAlign = calRight
                StretchColumn = False
                ColumnType = ctDefault
                VisibleOnSelectOnly = False
                Images = imlFontIcons
              end>
            Colors.BorderColor = clBtnFace
            Colors.BorderColorSelected = clBtnShadow
            Colors.ItemColor = clWindow
            Colors.ItemColorSelected = clBtnFace
            Colors.CheckColorSelected = clBtnFace
            Colors.CheckColor = 15528425
            Colors.DisabledColor = clBlack
            DefaultColumn = 0
            ItemHeight = 30
            OnClickItem = lbAnalogSkinsClickItem
            OnGetCellCursor = lbAnalogSkinsGetCellCursor
            OnGetCellText = lbAnalogSkinsGetCellText
            OnGetCellImageIndex = lbAnalogSkinsGetCellImageIndex
            AutosizeGrid = True
            BevelInner = bvNone
            BevelOuter = bvNone
            Borderstyle = bsNone
            Align = alClient
          end
        end
      end
    end
  end
  object pnlOverride: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 440
    Height = 25
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
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
    object Label6: TLabel
      AlignWithMargins = True
      Left = 22
      Top = 5
      Width = 277
      Height = 15
      Margins.Left = 2
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'The options below will override the default theme settings'
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object btnRevert: TPngSpeedButton
      Left = 339
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
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 368
    ShowCaptions = True
    SwatchHeight = 16
    SwatchWidth = 16
    SwatchSpacing = 4
    SwatchFont.Charset = DEFAULT_CHARSET
    SwatchFont.Color = clWindowText
    SwatchFont.Height = -11
    SwatchFont.Name = 'Tahoma'
    SwatchFont.Style = []
    SwatchTextBorderColor = 16709617
    SortMode = sortName
    BorderColor = clBlack
    BackgroundColor = clBlack
    BackgroundTextColor = clBlack
    Left = 328
    Top = 360
  end
  object imlFontIcons: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C08648800000009704859730000004E000000
          4E01B1CD1F3300000016744558744372656174696F6E2054696D650030362F31
          342F3035BF6598320000002574455874536F667477617265004D6163726F6D65
          6469612046697265776F726B73204D5820323030348776ACCF0000029C494441
          5478DA7D935F48DA5114C78F9665344A9F5271814D5CCD977A4A906DD51808A2
          7BD804C5C564142C1187C4F2C13D07424452411B096385431C7B188D207C187B
          8814862F7BA851FE69E9A4745961B3B4DC399729256B170EBFDFEF72BE9FFBBD
          E79C1FA75C2E43EDE27038C2EEEEEE9742A1F0EED6D6D6CCF6F6F647CCFB05FF
          589C5A008A5B6432D9ACD96C7E64B55AF993939385D5D5D5EFD168D49B4EA7DF
          614AA67C4174098062B1542A9D1D1919D1389DCEA6BABA3AB6BFBFBF0F1E8FA7
          B0B4B4943D383898DFDCDCF4A2EEC725008A5B2512C95BAFD73BA0D168AED55A
          A5BC939313989898809595955832997C83AEFC0C8062A948247A3D353575C760
          3034E377555489F3F373383B3B63418EF020F0F97CDF2A8099F1F1F1A776BBBD
          89C495A885944A2528168B707C7C0CB1580CF47A7D9C01D0FAFB858585870281
          80D9ECE8E880868606E072B95548C501418E8E8E000FA3ABCC33406767673010
          08DC3B3C3C84C6C64626CA66B3A0502880CFE75F72924824A0BEBE1E1C0E470A
          BB739B7CB6A8D5EACFCBCBCB3D94707A7A0AD87726A2D3B075A0542A9988563C
          1E874C26032E976B6D636383016E188DC62F8B8B8B121254EE49A0542AC5ACE7
          7239C0AAB3677F7F3FCCCDCD81DFEF7FB6B7B7F78A0003369BEDC3F4F4742B25
          9398EE4A007AA7C0DEB3686F6F678E70C8E2EBEBEBE4384700B15C2EFF6AB158
          C4A3A3A3C0E3F1AA102A6805120C0641A55291F54C2412B1E00C7CAA0E12B6AC
          B9ABABCBDED6D636ACD56A65434343AC0BE482229FCFC3EEEE2E84C36170BBDD
          FE9D9D1DE355A37C1D2BFF041D3DC6BBDE1C1C1C64FB54F942A1006363639150
          28A445CDCF2B7FA6BFA05BBDBDBDCFD191AEAFAF4F8C534A7BBF4D26D30BCC9F
          FDEFDF5803EA41474E9D4EF7002BBF8657B98FF9A58B397F00E7B79F35C6BE52
          360000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000036A4944415478DA55536D6C5355187ECE6DBBDEDDF58BA6
          DD474A270B66E2E68C56443EC6CC102910019D0A621CA086458D683421FE31D1
          4463E20F7F49D098E0468220444C068E211F73A164421CC32222B1E8A0D2B5DD
          E8CAEED6BBDB7BCFB9C753E2C83CC9937372F2BCCF79DFF7BC0FE19C63F67AEB
          ECCBCBC5B643E05181A0805D6042E03CB7F8EECF5BBA8ECFE693190111582276
          093CB7AE76A5D35F1EC4845601CD0028D34191C5E9915ECA283B4929DBF8F5DA
          8353770544B0439C7F5A186C5C160DAF80AA3B518481844A50C69DC869163835
          508E02D2C51806538397A8495B0E6CEC9E9811F82612A87FF1F1D012E890C199
          078661E28AEA80C3E6442ACF619A14365D455D701249F534CE247EED3DDC7E6C
          2DD911DBD62C5EEFDBF9D056479C16A013A082B9002D8054C181A24970F5C624
          6019A8AAC9A132308C8572081F1CFD82892C9E2D091C8E861E6BAB7687F1A79D
          42E235A8A33262293B2C6A47223305228F4309FD0D49CEC0B27444A6AA40F469
          740EF49C280924B7DFDF16BEA86530264B68B02DC61C46B17F8843D719BC351C
          AAFF1046ACDB220B0E1F75A22EEDC4CABA08DEFF6E57BA245078BBA95DD99F89
          61D4A6A149590DB7E1C1B17316BCC169DC53ABE1776B1CC3C5389C7C12CA581E
          73F30A5E5DBA016FECF9689ABC7966ABF64ED396F2CE640FF20823E27D00FD03
          A207E52E14B22A42F30157651693A2A16ACA144D1E84CF18C66BAD9BD0F1D587
          3A79BDAFFD6647635BA87FEC37187233F4BC1D97AF2828737BC021E1F6580EFA
          AD82485F87B75282AFE22F04C845441F598E9D7B3FCB92ED3F6E3EB2A676F13A
          87D38353E99B82702FAE5D0EC3945CE0361F4CF1FF4535073635019F97C163FF
          058DF374B8B88CDDA7BEEF27DB8E3EBF8A9AACE7BDE657EC5DF11FC08803B4F8
          34C673A20CB9128C59D046FF8152750D1E3901924A6273F429BCBBE7D3D208BF
          746790367DBBBE7B51F582F5F5D5F37121731D96F4046EA51570D90F4A398AE3
          29B8FCFB608D16F170C302243323E88D9FEB1FFA24DE7A47A06DEF1AB769B0B3
          4BE6363CB822D282ABA37EDCB82E3221656202258826205CFF33EEF3CC43DF85
          011CBF743E215E6F110299BB668AEE6A758BC93A28CA7972CB32612C560DCE15
          108920E05391CD0DE1CB13DD4C5063022F88E0ECFFDC38B3967EBCE819E1B80E
          517B93C5AC39FF5D97ECFC8740A708DC379BFF2FA0E2A2600875B4EC00000000
          49454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002784944415478DAA5534B68135114BD2F4D6263328DA999
          993409585283D44541ECA25D28683FF8C1AA95BA0908A228512A64E9AACDC2B5
          A220410A52228528A8A1B468136B51C145C16E4A211A28A2533BF9D0E6D76932
          9319EF0C243428BAE883CBB9EFBE7BCE3BEFCD1BA2280AEC66909D02C27B87CB
          74629D53F3D23BF6B9B98FBFACE6F9186B6E19E04BFF1528CD3B2E80A24C61A9
          03638D1AE0496E8E55AC833CF9A703DCED10CA7CB4F4F14C21C6AA2545DFD64F
          2A6BF16F38F1DA4EA548769689617DD07E36A5FCD501DACC60BADFD0D60F46E6
          3828620E40B707724BF7D258A731A69973A9A13F1CE4E6986BB83881F1B8F9E0
          D55B3A430BC85B3F01E46D207A0BE84C4ED8E21741E03E5CC79E658CAFCE8BE9
          8D06071B6F18160CD6754BE71DA8E65700AA028052C5EB908018CC00A60390FD
          F2B08ABD57DCC399A906079919FA3C6A3C35B55FB2192817C8852492258D5C10
          1D90D9F6424A708350DC94245198C997A9073E9F6FA12E909AA65B51A00BD55F
          B51EBDBB4F4607B2588482C4C26ABE07D8F65EA0280A54A7D96C163E7F9A5F11
          2A70DBEFF72FD48FF02B4A8F218C1BDC43506A3E09E94D0B14CB4DD0E1EDD2C8
          922469027ABD1E388E83783CFE241008DCAC0B702FE947AEE1F4E8F2DB5165AF
          370056AB1508211AA946D69AB166341A21140AC9954A258C11AA7FC6EF2FECA7
          7FD8EECF761E39A3116459D6A2366A7D3A9D4E1349269310894426EB02AB117B
          6FC2FA6CA2BBBBFBB03A57C9EA8EB57CA7905A578F130C06730D4F391A8D8E7B
          3C9E31866134927A692AD234ADADF33CAF39703A9D904824201C0E4F3608A025
          279EEB46B95C1E4104C445C426C463EA5C14C5254413620FC66BBC9F10D9EDEF
          FC1BA00A7508772B68BB0000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end>
    Left = 376
    Top = 372
    Bitmap = {}
  end
end
