object Form1: TForm1
  Left = 8
  Top = 8
  Caption = 'Form1'
  ClientHeight = 319
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PngSpeedButton1: TPngSpeedButton
    Left = 36
    Top = 60
    Width = 23
    Height = 22
  end
  object SharpEListBoxEx1: TSharpEListBoxEx
    Left = 0
    Top = 0
    Width = 564
    Height = 319
    Columns = <
      item
        Width = 30
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
        ColumnType = ctDefault
        VisibleOnSelectOnly = False
        Images = col1
      end
      item
        Width = 75
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = col1
      end
      item
        Width = 75
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = col1
      end
      item
        Width = 40
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctCheck
        VisibleOnSelectOnly = True
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnFace
    Colors.ItemColor = clWindow
    Colors.ItemColorSelected = clBtnFace
    Colors.CheckColorSelected = 33023
    Colors.CheckColor = 15528425
    Colors.DisabledColor = clBlack
    ItemHeight = 25
    OnDblClickItem = SharpEListBoxEx1DblClickItem
    OnGetCellCursor = SharpEListBoxEx1GetCellCursor
    OnGetCellColor = SharpEListBoxEx1GetCellColor
    OnGetCellText = SharpEListBoxEx1GetCellText
    OnGetCellImageIndex = SharpEListBoxEx1GetCellImageIndex
    OnDragOver = SharpEListBoxEx1DragOver
    AutosizeGrid = False
    Align = alClient
    DragMode = dmAutomatic
    DragCursor = crDefault
  end
  object Button1: TButton
    Left = 16
    Top = 276
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Add Col'
    TabOrder = 2
    OnClick = Button2Click
  end
  object col1: TPngImageList
    BlendColor = clBlack
    BkColor = clBlack
    AllocBy = 0
    DrawingStyle = dsFocus
    Height = 0
    Masked = False
    Width = 0
    EnabledImages = False
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1100
          000B11017F645F910000000774494D45000000000000000973942E000001AC49
          44415478DA6364A01030227356AD5ED908A4EA88D0D714161A5E8FCD80FFFE7E
          01282AFB27F63014E697C0F9FFFFFF67D8B4792303D000469C069C3E7D1ACC3F
          72EC205CCEC6CA1E4C9B98981036E0C78F1F0CD3674EC1707776661E030B0B0B
          C3E62D9B701BE0EBE3C770F6EC59309F898989E1D091FD0C76368E0C8C8C10A5
          868686F85D0032E0E5CB9760CD204D4B972F62888D4E00B34158404000BF0B7C
          BC7DC101852DB2408E00198261406D5D0D38FA38383818D454D519FEFDFB0776
          013A0089830CB87DE716389C40D10933E07F7D5D03C3DFBF7F197EFFFE4D3011
          7CFAF4096CC1D46953E02EF8DF50DFC870FDFA75064949498683070F32B8BABA
          32BC79F3061CEA309B41F49F3F7F180E1F3ECCA0A7ABC3B061D3468401C54525
          0C776EDF6610141282FA9711C3E9200032603350A3A59535C38E9DDB11069496
          94319C397386E1C4F1630C5FBE7C812B6602DBFC97E10FD07B4C4CCC0C2CCCCC
          0C5636B60CC2C2C298069C3C79126C1B2CC942132F50EC3F387C40FE86452F3F
          3F3FC3B6ED5B1106E4E71530BC7EFD1AEE54CCA86480C70E480EC45EB96A05DC
          80E5402A8260F06382150015BEDDEBD999F0E50000000049454E44AE426082}
        Name = 'PngImage0'
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
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000002984944415478DA
          95D35F4853711407F0EFBDDBD4BB2DF6478B34746866338358E5A2C44C8AC802
          85A2C0227CA89E7A88A087FE82115190201208459641428115E5430809999850
          68BA5CA97369EA485D4EE7B6EBDDEEBFCE7C10FC83E081DFCB3DE77C7E7F2F73
          F5080AB41A3C535570B282F3F73EA8CD584330378EC29767D3A7E9B40CBABD11
          9E9032423EAE0598DA63375A4D062DC60331B886788FC906BB350B9594AF3977
          459D5A15B856824BEB38CD5DA7DD68D06918B4B983A10DBBD44136010ECA6F23
          E0D7AA009D01AB61F190B650B1D3AE374C5B79A4E738D4D0AC3FECF78F1E23A0
          6D5540A5D38BC7FD0BCCEDF5D9B8E5C82F6632329D687F502FCC744E4CA19C09
          C8B2DA40654F09F3AF08D45531A7599679B2AFA0944B4949C560CD378CBE19C0
          F6DA9348CE3363E44F8FF0F3C7175556845784DD24C8B714A8605954A56FCC35
          A041E5E44004FBEB0F21D1CA520507682C102503DCBD2DA2ABE7930C556C9465
          D451FFE7852D1092A87B846E6346F296D29797352CFB971A53017982860F8A34
          0B41C98410B3626CCCA50E795D91E9806F6E0198472A998A6CC78EDAC2A2337A
          886E9A9D56A0040998041F09204C23C20B4832EE85C266A0A5F9F1E462A08A49
          E3388BF754F9F524467807551521C60408D130E6F820787E06F17A63CA090C0F
          7BA5FEBECED78B80783CAF667B0B8BCFE6990DE388F12E486214D1280F4591E6
          F37A4B096DC388B6D6C6882C4BF66500ADE2A0C99CD65458749C0BFB5F409143
          F3DF59AD1506CB614C0745F56BC7DB902489A5741BADCB8078D45733ED395B9D
          F9599B7375C26C0712F476B03A1B7E7BDAA5FEFE2EBFA2E000350F2C7A484B56
          914CD7FA7DB7B36C93C96C647D236ED1E3E993145968A29FED2235FF5BF61257
          406C0C832E1AF182F734EB1D6A1C5A5AF71F27384C69BE17878F000000004945
          4E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end>
    PngOptions = []
    Left = 440
    Top = 232
  end
  object PngImageList1: TPngImageList
    BlendColor = clBlack
    BkColor = clBlack
    AllocBy = 0
    DrawingStyle = dsFocus
    Height = 0
    Masked = False
    Width = 0
    EnabledImages = False
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1100
          000B11017F645F910000000774494D45000000000000000973942E000001AC49
          44415478DA6364A01030227356AD5ED908A4EA88D0D714161A5E8FCD80FFFE7E
          01282AFB27F63014E697C0F9FFFFFF67D8B4792303D000469C069C3E7D1ACC3F
          72EC205CCEC6CA1E4C9B98981036E0C78F1F0CD3674EC1707776661E030B0B0B
          C3E62D9B701BE0EBE3C770F6EC59309F898989E1D091FD0C76368E0C8C8C10A5
          868686F85D0032E0E5CB9760CD204D4B972F62888D4E00B34158404000BF0B7C
          BC7DC101852DB2408E00198261406D5D0D38FA38383818D454D519FEFDFB0776
          013A0089830CB87DE716389C40D10933E07F7D5D03C3DFBF7F197EFFFE4D3011
          7CFAF4096CC1D46953E02EF8DF50DFC870FDFA75064949498683070F32B8BABA
          32BC79F3061CEA309B41F49F3F7F180E1F3ECCA0A7ABC3B061D3468401C54525
          0C776EDF6610141282FA9711C3E9200032603350A3A59535C38E9DDB11069496
          94319C397386E1C4F1630C5FBE7C812B6602DBFC97E10FD07B4C4CCC0C2CCCCC
          0C5636B60CC2C2C298069C3C79126C1B2CC942132F50EC3F387C40FE86452F3F
          3F3FC3B6ED5B1106E4E71530BC7EFD1AEE54CCA86480C70E480EC45EB96A05DC
          80E5402A8260F06382150015BEDDEBD999F0E50000000049454E44AE426082}
        Name = 'PngImage0'
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
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000002984944415478DA
          95D35F4853711407F0EFBDDBD4BB2DF6478B34746866338358E5A2C44C8AC802
          85A2C0227CA89E7A88A087FE82115190201208459641428115E5430809999850
          68BA5CA97369EA485D4EE7B6EBDDEEBFCE7C10FC83E081DFCB3DE77C7E7F2F73
          F5080AB41A3C535570B282F3F73EA8CD584330378EC29767D3A7E9B40CBABD11
          9E9032423EAE0598DA63375A4D062DC60331B886788FC906BB350B9594AF3977
          459D5A15B856824BEB38CD5DA7DD68D06918B4B983A10DBBD44136010ECA6F23
          E0D7AA009D01AB61F190B650B1D3AE374C5B79A4E738D4D0AC3FECF78F1E23A0
          6D5540A5D38BC7FD0BCCEDF5D9B8E5C82F6632329D687F502FCC744E4CA19C09
          C8B2DA40654F09F3AF08D45531A7599679B2AFA0944B4949C560CD378CBE19C0
          F6DA9348CE3363E44F8FF0F3C7175556845784DD24C8B714A8605954A56FCC35
          A041E5E44004FBEB0F21D1CA520507682C102503DCBD2DA2ABE7930C556C9465
          D451FFE7852D1092A87B846E6346F296D29797352CFB971A53017982860F8A34
          0B41C98410B3626CCCA50E795D91E9806F6E0198472A998A6CC78EDAC2A2337A
          886E9A9D56A0040998041F09204C23C20B4832EE85C266A0A5F9F1E462A08A49
          E3388BF754F9F524467807551521C60408D130E6F820787E06F17A63CA090C0F
          7BA5FEBECED78B80783CAF667B0B8BCFE6990DE388F12E486214D1280F4591E6
          F37A4B096DC388B6D6C6882C4BF66500ADE2A0C99CD65458749C0BFB5F409143
          F3DF59AD1506CB614C0745F56BC7DB902489A5741BADCB8078D45733ED395B9D
          F9599B7375C26C0712F476B03A1B7E7BDAA5FEFE2EBFA2E000350F2C7A484B56
          914CD7FA7DB7B36C93C96C647D236ED1E3E993145968A29FED2235FF5BF61257
          406C0C832E1AF182F734EB1D6A1C5A5AF71F27384C69BE17878F000000004945
          4E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end>
    PngOptions = []
    Left = 488
    Top = 224
  end
end
