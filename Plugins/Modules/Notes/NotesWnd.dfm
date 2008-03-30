object NotesForm: TNotesForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Notes'
  ClientHeight = 379
  ClientWidth = 657
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000000000000000000000000000000000000000000000000
    0000858A88A3858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A
    88FF858A88FF858A88FF858A88FF858A88FF858A88A300000000000000000000
    0000858A88FFEEEEEEFFB2B2B2FFB2B2B2FFB2B2B2FFB2B2B2FFB2B2B2FFB2B2
    B2FFB2B2B2FFB1B1B1FFB2B2B2FFB2B2B2FF858A88FF00000000000000000000
    0000858A88FFFFFFFFFFECECECFFEBEBEBFFEAEAEAFFEAEAEAFFE9E9E9FFEBEB
    EBFFEAEAEAFFEBEBEBFFECECECFFB2B2B2FF858A88FF00000000000000000000
    0000858A88FFFFFFFFFFDBDBDBFFCBCBCBFFC4C4C4FF000000FF02598FFF6363
    63FF8C8C8CFFCACACAFFDADADAFFB2B2B2FF858A88FF00000002000000000000
    0000858A88FFFFFFFFFFECECECFFECECECFFE9E9E9FF02598FFF26424CFF3657
    6BFF02598FFF9D9D9DFFD6D6D6FFAEAEAEFF858A88FF00000000000000000000
    0000858A88FFFFFFFFFFDBDBDBFFCCCCCCFFCBCBCBFF757575FF395B70FF8AAB
    C2FF5585A3FF02598FFF8F8F8FFF868686FF858A88FF00000001000000000000
    0000858A88FFFFFFFFFFECECECFFECECECFFECECECFFEBEBEBFF02598FFFC4E5
    EDFF649FC8FF5787A4FF02598FFF717171FF858A88FF00000000000000010000
    0000858A88FFFFFFFFFFDBDBDBFFCCCCCCFFCCCCCCFFCCCCCCFFB7B7B7FF0259
    8FFFC5E6EDFF68A6CEFF5784A0FF02598FFF858A88FF00000000000000010000
    0000858A88FFFFFFFFFFECECECFFECECECFFECECECFFECECECFFECECECFFD3D3
    D3FF02598FFFC6EAEEFF69AACFFF5683A0FF02598FFF02598F33000000000000
    0000858A88FFFFFFFFFFDBDBDBFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCC
    CCFFB7B7B7FF02598FFFC7EBEFFF6AACD2FF5787A4FF02598FFF02598F330000
    0000858A88FFFFFFFFFFECECECFFECECECFFECECECFFECECECFFECECECFFECEC
    ECFFECECECFFD3D3D3FF02598FFFC7EBEFFF6AACD2FF5583A1FC02598FFF0000
    0000858A88FFEBEBEBFF00A0C4FFBCBCBCFF00A0C4FFB8B8B8FF00A0C4FFB8B8
    B8FF00A0C4FFB8B8B8FF00A0C4FF02598FFFC6EAEEFF71ADCFFF02598FFF0000
    0000858A88FF00A0C4FF3DB1EBFF00A0C4FF3DB1EBFF00A0C4FF3DB1EBFF00A0
    C4FF3DB1EBFF00A0C4FF3DB1EBFF00A0C4FF02598FFF02598FFF02598F5C0000
    0000858A886600A0C4FFC6E8F9FF00A0C4FFC6E8F9FF00A0C4FFC6E8F9FF00A0
    C4FFC6E8F9FF00A0C4FFC6E8F9FF00A0C4FF0000000000000000000000000000
    00000000000000A0C44400A0C4FF00A0C44400A0C4FF00A0C44400A0C4FF00A0
    C44400A0C4FF00A0C44400A0C4FF00A0C4440000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000C007
    0000800300008003000080030000800300008003000080030000800300008003
    000080010000800200008000000080010000C0070000EAAF0000FFFF0000}
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = NotesKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pcNotes: TSharpEPageControl
    AlignWithMargins = True
    Left = 4
    Top = 4
    Width = 649
    Height = 371
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Color = clWindow
    DoubleBuffered = False
    ExpandedHeight = 200
    TabItems = <
      item
        Caption = 'My Notes'
        ImageIndex = -1
        Visible = True
      end
      item
        ImageIndex = -1
        Visible = True
      end>
    Buttons = <
      item
        ImageIndex = 9
        Visible = True
      end
      item
        ImageIndex = 10
        Visible = True
      end
      item
        ImageIndex = 11
        Visible = True
      end>
    RoundValue = 10
    Border = True
    TextSpacingX = 4
    TextSpacingY = 4
    IconSpacingX = 4
    IconSpacingY = 3
    BtnWidth = 16
    TabIndex = 0
    TabAlignment = taLeftJustify
    AutoSizeTabs = True
    TabImageList = PngImageList1
    TabBackgroundColor = clWindow
    BackgroundColor = clWindow
    BorderColor = clSilver
    TabColor = 15724527
    TabSelColor = clWindow
    TabCaptionSelColor = clBlack
    TabStatusSelColor = clGreen
    TabCaptionColor = clBlack
    TabStatusColor = clGreen
    OnTabClick = pcNotesTabClick
    OnBtnClick = pcNotesBtnClick
    DesignSize = (
      649
      371)
    object Notes: TJvMemo
      AlignWithMargins = True
      Left = 8
      Top = 56
      Width = 633
      Height = 307
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 8
      AutoSize = False
      MaxLines = 0
      HideCaret = False
      Align = alClient
      BorderStyle = bsNone
      Flat = True
      Lines.Strings = (
        'Notes')
      ParentColor = True
      ParentFlat = False
      ScrollBars = ssBoth
      TabOrder = 2
      OnChange = NotesChange
      OnKeyPress = NotesKeyPress
      OnKeyUp = NotesKeyUp
    end
    object tbNotes: TToolBar
      AlignWithMargins = True
      Left = 4
      Top = 30
      Width = 641
      Height = 22
      Margins.Left = 4
      Margins.Top = 30
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = True
      ButtonWidth = 27
      Caption = 'tbNotes'
      EdgeInner = esNone
      EdgeOuter = esNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Images = PngImageList1
      List = True
      ParentFont = False
      TabOrder = 3
      Transparent = True
      Wrapable = False
      object tb_import: TToolButton
        Left = 0
        Top = 0
        Hint = 'Load From File'
        AutoSize = True
        Caption = 'Import'
        ImageIndex = 4
        ParentShowHint = False
        ShowHint = True
        OnClick = tb_importClick
      end
      object tb_export: TToolButton
        Left = 27
        Top = 0
        Hint = 'Save To File'
        AutoSize = True
        Caption = 'Export'
        ImageIndex = 5
        ParentShowHint = False
        ShowHint = True
        OnClick = tb_exportClick
      end
      object ToolButton7: TToolButton
        Left = 54
        Top = 0
        Width = 8
        Caption = 'ToolButton7'
        ImageIndex = 6
        Style = tbsSeparator
      end
      object tb_copy: TToolButton
        Left = 62
        Top = 0
        Hint = 'Copy Selected Text'
        AutoSize = True
        Caption = 'Copy'
        ImageIndex = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = tb_copyClick
      end
      object tb_paste: TToolButton
        Left = 89
        Top = 0
        Hint = 'Paste Selected Text'
        AutoSize = True
        Caption = 'Paste'
        ImageIndex = 0
        ParentShowHint = False
        ShowHint = True
        OnClick = tb_pasteClick
      end
      object ToolButton1: TToolButton
        Left = 116
        Top = 0
        Hint = 'Cut Selected Text'
        AutoSize = True
        Caption = 'ToolButton1'
        ImageIndex = 3
        ParentShowHint = False
        ShowHint = True
        OnClick = ToolButton1Click
      end
      object btn_selectall: TToolButton
        Left = 143
        Top = 0
        Hint = 'Select All'
        AutoSize = True
        Caption = 'Select All'
        ImageIndex = 1
        ParentShowHint = False
        ShowHint = True
        OnClick = btn_selectallClick
      end
      object btn_find: TToolButton
        Left = 170
        Top = 0
        Hint = 'Find Text'
        AutoSize = True
        Caption = 'btn_find'
        ImageIndex = 6
        ParentShowHint = False
        ShowHint = True
        OnClick = btn_findClick
      end
      object ToolButton2: TToolButton
        Left = 197
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 8
        Style = tbsSeparator
      end
      object btn_linewrap: TToolButton
        Left = 205
        Top = 0
        Hint = 'Enabled/Disable Line Wrap'
        AutoSize = True
        Caption = 'btn_linewrap'
        ImageIndex = 7
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = btn_linewrapClick
      end
      object btn_monofont: TToolButton
        Left = 232
        Top = 0
        Hint = 'Enable/Disable Monospaced Font'
        AutoSize = True
        Caption = 'btn_monofont'
        ImageIndex = 8
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = btn_monofontClick
      end
    end
  end
  object PngImageList1: TPngImageList
    BlendColor = 13565951
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002494944415478DA7D934F68134114C6BFDD9460B191600B
          A2422D34BD7812110F0942298A69D39418A5480D91544313E2C14B4128585173
          B0DED58B201E3CA9287AD08B16935C3C89E2411224693592522D3524D9BF337D
          BBD984FCD3C77ECC2C33EFB7DF7B332B70CE61C4834B238769F88AEED88E3DCC
          3BF18F10EECF1F3A4AE30D927F60EF3E5C585A4665F3A3B9B87BE8381E5FBF86
          5AE5AFF1FA84F49C60CF3A01F9938133C3FD030E41FDFE09C3C105948BABE6A2
          E3C0380A4FEF41DC3F0A72AABC79F14A2180A313C0FDA18B50CA1BD04A05889A
          02986571EBE150FB9DD83574106F5FBE0601846EC05C08F276095CD7C1748DF2
          595B9D4CAA42E873E2FDEABBDE80E9F37390B67E81A9B229588D6DDBF83F806F
          7616B53F4572405FD7543032F0E5F71E48BAAD5E0601B960C75AA18092387297
          D1069DDC92BE9980A9736751DDFC011080D182A289C8A9A3F0476F4351942E37
          06D066B3A9F1787CC5044C0603A86DAC910306A631C8BA809CE68237B28C4C26
          03DE525263EE76BBD54422510778037E544BEB6632D3C80101B2BA0BBECB3721
          49525B62636EB7DBD5582C56079C9EF1A15224071640D64564F918FC0BB7904E
          A79BC9AD10C341341AAD034EF92651F959B000F512B218C34C3CD9D381118683
          48246201BC5E94D7F3660F3839900C80E042E0CA1DA452A99E4DF4783C6A381C
          36011FC627264E5057C1191D171D91AC029FB706313DBFD474D0D944C3412814
          320153F49E241D696CD2D187B2F318AE261F4196E59E7FA1718CC1607045E03D
          6E1D5913E9922C9206AD0BD39471895A94DB01E2AE726CADF7CA7A0000000049
          454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37
          EA0000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C0000005B4944415478DA
          63FCCF801F30524741F9FF7F0C7FC0F03718FE02E35F0C7B198935A1E03F4C2F
          44270C9E21DA84D4FFC83623E02DA24D88FCFF0B4D2FC4BCE7449BE0FD1F5D3F
          047E26DA04DBFF3F916C064148B8FE21DA047C0000DE805E01BFEBC0BE000000
          0049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002604944415478DA85935D48935118C7FF67EF6699A82392
          6A52B458765110E4D64D19E1452054A0AB8BE84229BC88B0D475B1D84DF97193
          D54518F6E117215D4497051911F485B2694E05238746E8C0B51C6BCD6DEFDEB3
          737A36D9456BAB03870387E7FCCE737EFC0F3BEE1C7B5A566AB0E874304AC814
          C0C0A484CAE55A24A60E2643A1871F1E9C4AA0C060F62EB7F799CB56F23D2A14
          461B820E6B2901BD020C8F8731E9F6BF59595EBEFCBEEF442C2FE04CB767FE7E
          6BB5FE734040D14924B94024CE71ACAA18DE00C7D462042F5ECF3D7ED959733D
          2FE074B7C7D7DF56AD2CFC10E9EEA111E0573285DD4681B24D066C3430B4F5CF
          8847970E5A0A0206DAAB956F2101EA1E9A90886B025FFC3FCD2AE7E0044C8F79
          FF6A8C09C92209BEBCB4141F21373DE426CEEC04186AB72A4B619929E40450B5
          143C0B41F3C55A13825181026E9E939BB3ACA1CBE31B7458157F38FD024185EB
          9077732BE673874DF88F9B5E56DFE9F60D5FB5292B1140C7900108EAFAD5ACDF
          DC78C4847FB969BC3925597DC7846FC071400946F57F019A6A4CC87513274894
          E6A19D1BE0E89B91ACE1C6D4E2BDD65D88248C7F00460970BEA612B96E545A13
          04DABFBD08577AA98393AEF1D921A7B5848BF59B748C9248A027630173D3D14A
          E4BAD1A828A64AECDDAA47CBDD4F92D539C746E9484592A31C90F1CC8321515A
          AEEC2337C875439743A5C0575500176E4F488ABDCC9BF186CE498DDCE873DD64
          01962D1CCDB7A60B03EC1D5E99CF4D16B0C31846CB9DAF2808A8BB36BE3AE2B2
          6DCE7593892F4D85BE6F73CF64B220A0D6F1F1ADA2637BA8741B3959CBBA5907
          304A358F96971415FF069DF9921C980053860000000049454E44AE426082}
        Name = 'PngImage4'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002714944415478DA63FCFFFF3F032EA09A35534B5290AFE4
          F6B3D7E9CFE7E7FDC6A686119F0176D5CB323D8DD5AA7BD71F517DB3B8E03B4C
          5C3C6112D3CB0579FF081AE05CB7322FCA4EB7AB66E91E71A00B3E82C494D267
          E86AC989756CA90EF22668807BE3EA92740F93EEFCD9DBE41FCFC97E24913059
          BD3ACC7EEF95872F2FCDCC74F52268804FCBDAEA9240AB96B809EB55BF7EFFF9
          B32DD675FFBFFF0CAC75CBF69ABF5E94FF82A00101EDEB5BEA23ECAB03DB57A6
          E4FB5A6498A8481AC6F6AFB37F302BEB28518118D2B5A9B321D2A16CD7857BDF
          FDCDD538A37AD6E49EEC8A9B423016F86CE3983E1D5EF42FB27F5B776BB443C9
          B5276F19D61EBBB6707E8E7B02DE68147649939257359F28202AA2FEEAD5DB4B
          D6FA729A595EA6467D1B8E1EDB7CE8B4FDBBB5F57F701A20EC9C26A16FED7D58
          4E4747E50B10088A4AF198B0BF63F0345260289DBB75EFF60D2B5B3F1D5FB91F
          A701465973D6E8585B07EE5931D3F1DFBF7F821E49E51BAC057E3070090A331C
          7AC9C0F0EDFD4B86038B7B531F6F9F3507AB015E5DFB3E7DFFF2EAC8FEA6082F
          A3BC69D34D9C8232F83E3DFEFF995F9AF1D8DA758714F45584DE3DFEAE78F1C0
          2C912F17B6FFC030C0A569EB73312525C6E7F7AEDF5535B1B7BAB063D74DC67F
          ACC2529A121CEBB36D78D5C3CACA24951C3B2F1F982DF3F6C4BAA71806C80597
          8719BB044EE3E41714BA73ECECD9AB2757FB6A19879F54B2D092DCDC95AFA2E3
          E05BC7C9AD96707EDF4C914F67377FC01A0B22AEE9124CCCCC1CAF764C7B00E2
          EBC7CD3F6612E269F9E6C1F567C292F25217B61FB9796E5E9C06C1740003BC86
          5EEC2A066117F844C514BEBE7FF7F2E6D9E5269FCF6D7D83AC0600466F2EF023
          5B5F1B0000000049454E44AE426082}
        Name = 'PngImage5'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002B34944415478DA85924F48D44114C7BFB3EEAE9AB81624
          D64A85B92A581094EB258D888E22D42D0DD4444A4B3AD8A943B70A32A3D40C0F
          C26A7F400F1ECA2EAD056191FD31DD88D205B3745776D196DD55777F7F677ABF
          9F961D3207869937F3BE9F79EFCD634208FC6BF48C2C0859D3A069DCB4FDC19F
          09C6058B4B5A606E2EF94089445A5F755726D94680AE17F3A2F198130BCB1C8C
          6C4E7EAACE614D013CA3518CBD0B0E850281531B023ABC41517DD889AF618E14
          8B804291C4931A8E16A66322AC61FC5B1C4F87BF746E086827404D9913D38B94
          0285A0126049D1B1772B87638B0D6936869A1BE3E2BF80DA72277E44380C1795
          0B24558E2441966996EE4E45CBBD4F824D3D393491E6282E66CCF2975C6050BA
          663B539E8BB9E8EA031A016455874CAB44A0FD3BEDB8D84911F81FBB2557C568
          2A63CCD09962D0FECEB379D41EC945306A64C0A988AB1095C249C80245395634
          B77F24C06049D4553992A584BAA02B54628B83F499A8EEDB03CF253742713A62
          30019C1BA900B20E146603F56D1F08D0EF8EE79F18CE94027D10E4B532E3436C
          D287CD4676FD1B34DCF41160A044C9AB18B22DBEBE0E351204572564141C87B5
          B8098E8C142AA0E54F5D8C625AC89CBE5B0A478D17CDB766C0FC0F4B9582AA51
          1BB862B40B0C2F416B22F488FEDF90B1350833F7564719663D55D85EF7160DAD
          630AF37BDCB2EBF44BBB12EEC15A154D502C61A1E6A17C55A307744864242405
          DB765074DEF368FC7E3B9C95614F67FE6EB7945FF73C555DEC253D5F8D82ABF4
          2A29850CA14B64AF80EB71082D86B45D5730D37B0E0517DE1B1D4E297494245D
          67BD69CAC27D12D09342218E4C228920490224682ED31501F425A4E7B512A069
          1D30D57650CDAB1FB06A312F8975730A036444C10DA0B1527DB862DAF69C9398
          ED6F59074C5EDDE7A38F2E34D3679BFCDD6F1F2EFC45973F1F308E7E016C348F
          1C2C0961BB0000000049454E44AE426082}
        Name = 'PngImage10'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000030C4944415478DA5D935B4854411CC6BFD96DD7B3796157
          A4974C2212BB10A46EAE58AD89219A4A05F5622F1114456906590F46D045B4A2
          C02E20058191AED14B104429A9B44AEA6A45699AB7C25BB28BBAACBAB77399FE
          E7B4157660660E0CF3FBBEFFF79F61B997DA8F9AE284233A867400161A41309A
          394D5C81A4C863DE39FE96F9162A3AEA8AC3F8EF63F9D79DCEA765D6CD3A1D33
          730EFD9F0DFA576778964434B8BC989D08F9BFF60FC677D615875600F65577B8
          9BCE66C40FB8A127882A0A4955963802A2849CE468B48C05D03DE8C1CF897060
          F8DB90E5DD83A2BF105658D3E96F2CB59A46E7F59AA242CAB2A2204480605846
          76B280010FD7A0CD9F66D1EA1C75B456E794FC7350D31970945A8571154065AF
          004832369A15C49AF48832AC823F18C6913BBD52CB55BB6105A0F18C5598F4A9
          00064556D538445A431281C84598800A0DFB86281CBEED0A365FDE65FA0B28A8
          260039985D3440A112D4F0D4F5D18B21C44601FEB0044B8C1133EE00980E8859
          AD27970C0BBE005A3F4ED9583E011A08E059328047D297A98E5AC74714E6A4E0
          405A0C5E764DA138337145FBEADB3C68EBF90E96778D1C945B05F7B2E14FEF34
          50D5E31EE4666DC2B13D6694DDEBC3DDD2746D2F280154151EBE9AC6C0C824D8
          DE2B1DDC71CE0ACFB23172F437A7BADE85BDB61494D8E3285B061DFBBDAB903B
          8A0A379EFFC087410264573A038E0AAB50E6A43BC0D40CD45600F1239F61DDBA
          1ED3738BDA6149A62065255226D768D33333603B2FB6079A2ED8849BFD466C5F
          A383AC664007BA5FF62075CB3A0A4BD29C49D45245EB867A57D48B26626A8A00
          B6F2D6E5A64A9BA9E68BC064AE2A30AD0CAFF33D7277A4E090DD44EF417D023A
          4D953305C22A236E354EC0D53F0C9676B265FCF58DDD09CB228FE60AD7299194
          CFDFEF45816D1BF6DB453C729D404274929A046535891319B5D4A510DAFA7AC1
          D24F359F96447E9031964A09C46BAF919492936284E3455B90973A8FAE856730
          1BD76A26BC4137322D8751F544C69BAE3E301E69DDFF5FFAC9E6CEE444539639
          CA4296E3A80C118C32609CB2607E0C4D8CC1ED13F10BC71196A444311A580000
          000049454E44AE426082}
        Name = 'PngImage11'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000029C4944415478DABD935B48544118C7FFC775D71B89CA22
          7431D4F66C5E365359052B377DC8400DA482245FA214A2282B0A04ED21447C88
          3229E8265A4AA8ADF914AD0A126E9B17D6CC44EB210AD7CBBA9AAD7B3F7BF69C
          B3A7D9F3602F450F4503C3C0CCF7FDBEF9FEFF194A1445FCCDA0FE39A0B1A56D
          21252539C962B1A0BEF60C75F749BFE8726E607A72FCB3BEEBB1FA8F80BAC6DB
          0BF9797949DDCF3A4112A8B3571A4475BA065E8F67F9FAE5EA1DBF059C3E7F55
          4CD364C3ED72222A2A1AFDDD1D981C33524525E56246562E148A08985E0F86D6
          1EEBE27C8DCBE5F0D9D7BF05A90EFD40E4CC87A9A2B878A541260BC3FADA2A3E
          CD4E83E70208019D0E3B38851234AD02E3B663D66C8469D850CFF15C33EBF78B
          544BDBF37032BEC46E89D9699E18976E13BB2D0D5B13E3101004CEED66E5BC6F
          035FE797C0FBEC50AB55686EB86411787E17B9BD4035B5B6CB453118884F5062
          6E660A822090EA1C189F17E6312352E934A8766780E779693F1060D1F5A835D4
          77040170544D6D9DDCB6BCE859B3591509CA44ACAE2CC3CFF8E0723AAC8CCF53
          26574434916AA5D1D131F07A3D60FD0C3C6ED7064956921994442C3F7AF2CDBE
          A24307B439597038DDB02C59D1FBF4412F11B1924ED7F41CAFAA3EA1D5E642E0
          83585AB1E1C6B57326A24DE1A60B25E5C7F8744DB6ACACAC147D2FFA48153FDE
          9B473FCEBC9BC84C4EA5E72A2A4F6514EA0A31607885B030193A1FDE11488BE1
          9B80E2C347C4AC9C7C8400FA3EBD143432F432C0B2FE4886F17DAFB958179FBD
          778F0490C9C2D17EEF66480B6A13B0BFB844CC2B38089D4E87A1A14112248371
          D8402CB5C59137F1B6AAFA42264DD3183519A5B3FBB71A110C067F02B4053A31
          A43047BC0FA92CA9CDB26059663B17E046C8BE4A1078C92122A86435C9A37EF9
          94FFFB6FFC012DD473F0AA3A62EA0000000049454E44AE426082}
        Name = 'PngImage12'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000000C94944415478DA63FCFFFF3F03258091EA0684B76D4F03
          52F7565679EE21D70090C01EA001AE30B1C8C8C8FFBF7EFD62F8FDFB37038806
          E17DFBF631621800B5DD188841B42B31AE40376037C866207D17EA0DB02BBCBD
          BDFFC36C86E1B367CFA2BA00A8291448B9803402B112B1AE001B00D40CD2B00A
          88C3801AEE41F920579C05F24D6C6D6D315C70FBF66DCC30A0281A232222306C
          41C7B05800D12F5EBCA0B20BBCBCBCFE13B21D84FFFCF903A63F7FFE4C6517D8
          D8D8FCFFF9F32756FFC26C46C3547601B900003071F6E19F22FDD00000000049
          454E44AE426082}
        Name = 'PngImage13'
        Background = clMenu
      end
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
        Name = 'PngImage14'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002BD4944415478DAA5935D4893511CC61FA79B2E5147989B
          1F11393517A2859A14AD297993941012A951E285177D48924965305951525E04
          F346F1A29412224548574E45243315A4462853E647687EA492B8ED7DA77BCF79
          DF5E375C507A53FF73713817CFEFFCCFFF3C8F9F2008F89FF2FB1350D37D5B4D
          795A4828BD422851119E82A364493C37897BB331FFE5D4AE809AEEF23C42F9DA
          FD4A7564A22A05726908DCBC1B3F9CF318B4F562797565911052DA50D4D2FA17
          C02BA68D69F1BAE08488644CDA27B0E49A07C77308938521421E8D810933C626
          AD8CD859D1AB928E561FE0695779ACD876FF11F589A804650AFA16CD6019169C
          4010141408415C9BFC2634A149F834DE838999A9058E106DDB8D9E690FA0BAB3
          4CAF50EC33641DCAC5D0CA0738DD0C1886C19D0C83A7BB479FEFC1C5D8219106
          2043A545536F3D180757D571B3EF8107F0D0546A4BD5E8E236256E4CADDAC477
          737038ECA83E6DF400AEB55C4288420AC2132488B3D97430300DF74C9A6F7D8C
          F700F46FAFB29947CFC9271C635873AEA1F2D8E31DBFACACB300A1720592C2D3
          50F7AEC1D55B31B4C703A86C2B618FA764CBADF651B8E806AA526B760584C842
          91AC4C87B1BDCED57F77C40BA86829B6A90F6AE2F84001DFEDB360B90D30CB76
          345C78E3136E95C44F82F8F0C360D759B40C9A2607EF5BBC4F287B7D59BF2161
          0D67532F6260AE0B1B94838CF7C393EC173E004F05C82401C88CCBC1B30E23D6
          1DCEAA11FDA87788D79B0B62394AFB9511E151E9EA5318F8D6E91998F8B510E8
          16428054E20F9D3A07668B0943E35F1744CF682D06EBB4CF48C5CFCF8B46228D
          D12A65B036311B73EB33985F9B81C0F388D91B8B98D003786F69C7B0759411ED
          5D248A7F1B69BBF2EBCFE4897EAFA5FE2452A739096558E4D6E598FB390BF397
          5ED89DECA2282EDD16EF18A65C63965A841472BE3011314CD41326CA93668B61
          7CF730FD4BFD0276F996F0D72273FA0000000049454E44AE426082}
        Name = 'PngImage16'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002954944415478DAA593ED4B536118C6AF33DBD636734C13
          7599914E320B3243C9425351316C516964122E2A08C5FD0581627F4120414484
          1A884403732A4A6AA010256192F992DB7CD964BE8496DACE1967E7799E8E130D
          6B7EA9EBD3CD03D78FFBB9EFEBE61863F81F717F023C566B1223B44202A96462
          20968282316991803653465A4E3C6F75ED0998AFB1964A9434441C37C5E9D2D2
          C019F4805F4060D18BD5DE5E7C5F5D59208C584FBF68B3FD05D83413429A220B
          7275BAB45320AE3160C9038822B87003B8230958B177C133EBF4512259325ABB
          6D3B00774D4DA2DCF660544E96519B910ED2DF0E5EF0832301A8554A70948189
          7E20351DDFBADF607EC9ED254CCA3EFFF2ED74103057555DAB3546D5475EBB0A
          FABE0F84DF802008D82F0ABBE6437C02949979986C7C8A3525EA725E0D3C0C02
          66AAEF3B620A734C4AC90F7E6E0AD2A80BA1A48AD543119300DF9A80F12F03CE
          5CDBBBE420C059758F4FB852A2E1A646C0AFAF41FFE05148C0F24D33940603C2
          CE9CC5C7F64621FFF590360870DCB5F0878BF3359CE313A8DC85A6F6C99E00EE
          801EEACC7318EA782614B40D6F0126EFDC72C4A4269B344A02C93D03DEFB2374
          6A140AA8534E62DD2F6262A4C759D4F979EB0B63B7CB6BD5FC46FDA1EB3720F6
          74802A24043602BB07B8B96E850AFA8B660CDB1EE3A7C8D715778D6F0D71D452
          9648146CF0A036C21899970BC16E87BC6B304240C0C96E2A23F621E2D265B8FB
          BB30B73CEE251CCB2EE99C98DE09D27085B99432A9293A3C4A179D570871D605
          D1E5021529D4C74C50C51F85A7CF8E9995291FE5A84536FF0ED2B63E9417C969
          941AD4448C8B4FC992D7660CBEF35E379C6303E0897F41365BB7CD218F69B0EC
          42129302155218AD6494C4CA0705B95E94EB662A492D25DD5FF73EA67FD12FCA
          BE71F0E82977BB0000000049454E44AE426082}
        Name = 'PngImage17'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001804944415478DA63FCFFFF3F0325809158039EEED2E7FC
          FE41E1E1FB978CC2FFFEFE63E2E27DF880879DCD8A68036EAD08F8FFFFAF1483
          BC6D0203231313C3A58D650CDFDFBE5F4F940140DBFF0B485730B0F0CA013573
          80C5FEFDF8C07069CBA47F040D0069163199C2C0F0F529C3D3D34718C4952CC1
          E2CC3C120C57B64FFB81D700986616F60F0C3F9F6E65F8F78D9DE1EED9570CBC
          7C520C6F9EDD6130CBDFC888D30014CD2FD632FCFFF584814DC28BE1CDD1F30C
          9F6FDF63502B3CCA88331688D58CD580FD13D4FF5BC5CD214A3386013B3BD580
          9A673070F17D254A33DC8019C90A0A8A6A6CF7359DBB189EDFDDCEA06BF29328
          CD700326E7CAFD4F285DCDC0C1C6C9B06B6A12039FCC5F06296D1B86CF37EE32
          FC78FE8AC1A2F60C56CD2806A497AF63F87C6C2AC39F77F7196E9EBFCAF0E227
          2303979818834FD7159C9AE106443A09FFAF89F2625034F164F8CEC0CC7065F7
          7C86CFAF9F10D40C3720C241E43F1B1323839DBA0083042F3B039B28FF3AB7D2
          A3C18434E34C07A40000C231EE24169034A10000000049454E44AE426082}
        Name = 'PngImage18'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001FF4944415478DAC5933F68535114C6BFF782792FF0DA50
          6D536C535A948E458A9314AAAB83A891D28246D450B050852A2822E8D0C14570
          E8D0C1C12168A9B68B43405C3A28D841E9A08B50EC24B46913D360EE4BDE7DEF
          78EE6D84DC3A2AF8E072EE3DEF7CBF73CEFD631111FEE6B3FE1980360A24ABDB
          206A8064000A79046A5EE7791D087C84D2E7B5D0F3E485BC6500A2F5D7641F39
          FD4706F57B2FF2B70328BF9C40C7C4B209101FE729319C0345A2599B12472DCA
          3D6BD90ECACF3338982D9880DAEA1CB9C7CE42563F703975DD8AB691B25CBA1E
          02F1CE0C7E2CDD45E7B51513F0F3FD634A1CCF20A8BCE3D44153D42A56A306A7
          6B1CE585DBE8BABE6A022A6FEE91379A83ACACB464168858886676B576BA2FA1
          949F466AFAB309281766289E1E82AC7F0542259608FD5DB803299D59434201F7
          700E3BCF26D13DB36E02B6972FD381D420BCE1F3EA4C10353650FDB408A7BF83
          5BAAB1D8D715B83D53D87A7A053D77BE9B809DA52C91C541F62EDA4726615916
          2A6B8B48F47B4D714DB716EFBD89E2FC45F4DE2FEDABE05596DA4E8CA3F4F601
          625E02C99337505D7B01B7CFD362B589E09371D2B7B0353786F443B10FB03046
          EDA7AEC22F7E83F85240CC4D2276E828DA8646B9218EA190A3A4BE499B4FCEA1
          6F363201C5FC198A02DE7D755D03012936D96BC3E656940F8D863E117DB56588
          81476402FEDB6BFC05FCB743F0C5F3CBA60000000049454E44AE426082}
        Name = 'PngImage12'
        Background = clWindow
      end>
    Left = 144
    Top = 116
    Bitmap = {}
  end
  object ImportDialog: TOpenDialog
    Filter = 'Text File (*.txt)|*.txt|All Files (*.*)|*.*'
    Options = [ofEnableSizing, ofForceShowHidden]
    Left = 80
    Top = 108
  end
  object ExportDialog: TSaveDialog
    Filter = 'Text File (*.txt)|*.txt|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoReadOnlyReturn, ofEnableSizing, ofForceShowHidden]
    Left = 176
    Top = 120
  end
  object FindDialog: TJvFindReplace
    EditControl = Notes
    Options = [frDown, frFindNext]
    Left = 48
    Top = 108
  end
end
