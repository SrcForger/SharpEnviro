object CreateGenericScriptForm: TCreateGenericScriptForm
  Left = 0
  Top = 0
  Caption = 'Create SharpE Script'
  ClientHeight = 539
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ed_script: TJvHLEditor
    Left = 0
    Top = 36
    Width = 862
    Height = 388
    Cursor = crIBeam
    Lines.Strings = (
      'begin'
      ''
      'end;')
    GutterWidth = 32
    RightMarginColor = clSilver
    Completion.ItemHeight = 13
    Completion.Interval = 800
    Completion.ListBoxStyle = lbStandard
    Completion.CaretChar = '|'
    Completion.CRLF = '/n'
    Completion.Separator = '='
    TabStops = '3 5'
    BracketHighlighting.StringEscape = #39#39
    SelForeColor = clHighlightText
    SelBackColor = clHighlight
    OnPaintGutter = ed_scriptPaintGutter
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabStop = True
    UseDockManager = False
    Colors.Comment.Style = [fsItalic]
    Colors.Comment.ForeColor = clNavy
    Colors.Comment.BackColor = clWindow
    Colors.Number.ForeColor = clNavy
    Colors.Number.BackColor = clWindow
    Colors.Strings.ForeColor = clBlue
    Colors.Strings.BackColor = clWindow
    Colors.Symbol.ForeColor = clBlack
    Colors.Symbol.BackColor = clWindow
    Colors.Reserved.Style = [fsBold]
    Colors.Reserved.ForeColor = clBlack
    Colors.Reserved.BackColor = clWindow
    Colors.Identifier.ForeColor = clBlack
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
    ExplicitTop = 38
    ExplicitHeight = 404
  end
  object ToolBar2: TToolBar
    Left = 0
    Top = 0
    Width = 862
    Height = 36
    AutoSize = True
    ButtonHeight = 36
    ButtonWidth = 58
    Caption = 'ToolBar2'
    Images = PngImageList1
    ShowCaptions = True
    TabOrder = 1
    object ToolButton7: TToolButton
      Left = 0
      Top = 0
      Caption = 'New'
      ImageIndex = 7
      OnClick = ToolButton7Click
    end
    object ToolButton1: TToolButton
      Left = 58
      Top = 0
      Caption = 'Open'
      ImageIndex = 4
      OnClick = ToolButton1Click
    end
    object ToolButton6: TToolButton
      Left = 116
      Top = 0
      Caption = 'Save'
      ImageIndex = 6
      OnClick = ToolButton6Click
    end
    object tb_saveas: TToolButton
      Left = 174
      Top = 0
      Caption = 'Save As...'
      ImageIndex = 2
      OnClick = tb_saveasClick
    end
    object ToolButton3: TToolButton
      Left = 232
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 4
      Style = tbsSeparator
    end
    object ToolButton2: TToolButton
      Left = 240
      Top = 0
      Caption = 'Run'
      ImageIndex = 3
      OnClick = ToolButton2Click
    end
    object ToolButton5: TToolButton
      Left = 298
      Top = 0
      Width = 8
      Caption = 'ToolButton5'
      ImageIndex = 4
      Style = tbsSeparator
    end
    object btn_insert: TToolButton
      Left = 306
      Top = 0
      AutoSize = True
      Caption = 'Insert'
      DropdownMenu = FunctionDropDown
      ImageIndex = 5
      Style = tbsDropDown
      OnClick = btn_insertClick
    end
  end
  object lb_errors: TListBox
    Left = 0
    Top = 424
    Width = 862
    Height = 115
    Align = alBottom
    ItemHeight = 13
    TabOrder = 2
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000007049
          44415478DA6364A010308E1A4045034C52979C0152C644EA3B7B66768C09BA01
          FF7BF25C187EFFFB0F16FCFDF73F8A8EFFFF2118245737731F03D000460C031A
          D21D191EBEFE0656F80F681010317CFBF59FE12FD0B03F20FE3F060625094E86
          A9CB8F603580322F0C7C2C8C6003004EB23711482851F60000000049454E44AE
          426082}
        Name = 'PngImage0'
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
        Name = 'PngImage1'
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
        Name = 'PngImage2'
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
        Name = 'PngImage3'
        Background = clWindow
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
        Name = 'PngImage4'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000024349
          44415478DA9D934B6813511486FFC93C4D231D231629884D20AB340AD5A8A986
          DA9857B372A760E9C28DAF855B9FB8B1168B882B0511B5BAD28560153455688B
          6085DA8A4249DB34A525333658344913F29C4C9C9960143A41E8D9DCCBBDE77C
          F7FCFFBD97D819BC7E873090E7B1C120DA4203D5F17BBD884466B4058BC50241
          10502E9761B3D960B55AFF0FF0EDDD8642A1BCF10E0EEC73202626C192B26E92
          24139009B231E060E76E883FD690CD4BBA490C43419665180C067D4097BB0333
          8BABF0EED981F753715D08CB522049521FE039ECC4B7680213778FE916BBCE3E
          83A9896D0CF07BF7633AF21DCF2FBAF0796A12A363A30D4D93149BA4E6762489
          16E465AE0608055C988FC670BA7B33E46A15015F10344DD74FCC66B3902409E9
          741A994C06F1F83286DF8C20DDE20371E6DCA9AA9A64B7DB61366F85DF1700DF
          CC6B856AB2288A989D9B453299520029A41488EF8857816610FE92A801AE5EBE
          0603498363695014856A55636AF362B1A8BC918262228B4B572E80DB6444EBF6
          5678BA3D78F96EBC26A1C7B2845B83B791CBE5D6695621B1C5053C1A7A0C8EE3
          603236610B6F86DBEDC68387F76B80BEA31D58FDFA0203FD3735BDEA9DABC1F3
          3CA20BF378F274489367548A3986D3FC713A9D7F01BDC7FDF899580696C3B8D1
          3F0896A1411004263E7D4478E4ADE2C51A0E7576A1542AD53B73381CFF7470A2
          072BBF7260F2024A4B63A0888A721B84F2B1DAB0ABDD8157AF87E1F706353FFE
          84FAD1EA80937D21AC240BEBF44F4E47B5D1C97CD024C8954A7DCF6432411005
          FC06303FF1D9EB62ADE50000000049454E44AE426082}
        Name = 'PngImage5'
        Background = clMenu
      end
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
        Name = 'PngImage6'
        Background = clMenu
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
        Name = 'PngImage7'
        Background = clMenu
      end>
    Left = 384
    Top = 184
  end
  object JvInterpreter: TJvInterpreterProgram
    OnStatement = JvInterpreterStatement
    Left = 472
    Top = 152
  end
  object OpenScript: TOpenDialog
    Filter = 'SharpE Script|*.sescript'
    Left = 624
    Top = 336
  end
  object SaveScript: TSaveDialog
    Filter = 'SharpE Script|*.sescript'
    Left = 536
    Top = 304
  end
  object FunctionDropDown: TPopupMenu
    Left = 352
    Top = 88
    object N11: TMenuItem
      Caption = 'Functions'
      object Script1: TMenuItem
        Caption = 'Script'
        object Valueconvertion1: TMenuItem
          Caption = 'Value convertion'
          object functionIntToStrValueintegerString1: TMenuItem
            Caption = 'function IntToStr(Value : integer) : String;'
            Hint = 'IntToStr()'
            OnClick = GenericPopupClick
          end
          object functionStrToIntValueStringinteger1: TMenuItem
            Caption = 'function StrToInt(Value : String) : integer;'
            Hint = 'StrToInt('#39'String'#39')'
            OnClick = GenericPopupClick
          end
        end
        object imer1: TMenuItem
          Caption = 'Timer'
          object procedureSleepTimeInMs1: TMenuItem
            Caption = 'procedure Sleep(TimeInMs : integer)'
            Hint = 'Sleep();'
            OnClick = GenericPopupClick
          end
        end
      end
      object SharpApi1: TMenuItem
        Caption = 'SharpApi'
        object Applications1: TMenuItem
          Caption = 'Applications'
          object functionExecuteFilePathStringinteger1: TMenuItem
            Caption = 'function Execute(FilePath : String) : integer'
            Hint = 'Execute('#39'FilePath'#39')'
            OnClick = GenericPopupClick
          end
        end
        object ComponentControl1: TMenuItem
          Caption = 'Components'
          object functionCloseComponentNameStringboolean1: TMenuItem
            Caption = 'function CloseComponent(Name : String): boolean;'
            Hint = 'CloseComponent('#39'Name'#39')'
            OnClick = GenericPopupClick
          end
          object functionFindComponentNameStringinteger1: TMenuItem
            Caption = 'function FindComponent(Name : String) : Cardinal;'
            Hint = 'FindComponent('#39'Name'#39')'
            OnClick = GenericPopupClick
          end
          object functionIsComponentRunningNameStringboolean1: TMenuItem
            Caption = 'function IsComponentRunning(Name : String) : boolean;'
            Hint = 'IsComponentRunning('#39'Name'#39')'
            OnClick = GenericPopupClick
          end
          object procedureStartComponentNameString1: TMenuItem
            Caption = 'procedure StartComponent(Name : String);'
            Hint = 'StartComponent('#39'Name'#39')'
            OnClick = GenericPopupClick
          end
          object procedureTerminateComponentNameString1: TMenuItem
            Caption = 'procedure TerminateComponent(Name : String);'
            Hint = 'TerminateComponent('#39'Name'#39');'
            OnClick = GenericPopupClick
          end
        end
        object Directory1: TMenuItem
          Caption = 'Directory'
          object functionGetSharpEDirectoryString1: TMenuItem
            Caption = 'function GetSharpEDirectory : String;'
            Hint = 'GetSharpEDirectory'
            OnClick = GenericPopupClick
          end
          object functionGetSharpEGlobalSettingsPathString1: TMenuItem
            Caption = 'function GetSharpEGlobalSettingsPath : String;'
            Hint = 'GetSharpEGlobalSettingsPath'
            OnClick = GenericPopupClick
          end
          object functionGetSharpEUserSettingsPathString1: TMenuItem
            Caption = 'function GetSharpEUserSettingsPath : String;'
            Hint = 'GetSharpEUserSettingsPath'
            OnClick = GenericPopupClick
          end
        end
        object Services1: TMenuItem
          Caption = 'Services'
          object functionServiceStartServiceStringhresult1: TMenuItem
            Caption = 'function ServiceStart(Service : String) : hresult;'
            Hint = 'ServiceStart('#39'Service'#39')'
            OnClick = GenericPopupClick
          end
          object functionServiceStopServicePCharhresult1: TMenuItem
            Caption = 'function ServiceStop(Service : String) : hresult;'
            Hint = 'ServiceStop('#39'Service'#39')'
            OnClick = GenericPopupClick
          end
          object functionServiceMsgServiceMessageStringhresult1: TMenuItem
            Caption = 'function ServiceMsg(Service, Message : String) : hresult;'
            Hint = 'ServiceMsg('#39'Service'#39','#39'Message'#39');'
            OnClick = GenericPopupClick
          end
          object functionIsServicesStartedServicePCharhresult1: TMenuItem
            Caption = 'function IsServicesStarted(Service : String) : hresult;'
            Hint = 'IsServiceStarted('#39'Service'#39')'
            OnClick = GenericPopupClick
          end
        end
        object Messages1: TMenuItem
          Caption = 'Messages'
          object functionBroadCastMessagemsgintegerwparintegerlparintegerinteger1: TMenuItem
            Caption = 
              'function BroadCastMessage(msg : integer; wpar: integer; lpar: in' +
              'teger) : integer;'
            Hint = 'BroadCastMessage(WM_MyMessage,0,0);'
            OnClick = GenericPopupClick
          end
        end
      end
      object FileUtils1: TMenuItem
        Caption = 'FileUtils'
        object Directory2: TMenuItem
          Caption = 'Directory'
          object functionCreateDirectoryPathStringboolean1: TMenuItem
            Caption = 'function CreateDirectory(Path : String) : boolean;'
            Hint = 'CreateDirectory('#39'Path'#39')'
            OnClick = GenericPopupClick
          end
        end
        object Files1: TMenuItem
          Caption = 'Files'
          object functionCopyFileFromToStringOverwritebooleanboolean1: TMenuItem
            Caption = 
              'function CopyFile(Src, Dst : String; Overwrite : boolean) : bool' +
              'ean;'
            Hint = 'CopyFile('#39'Source'#39','#39'Destination'#39',True)'
            OnClick = GenericPopupClick
          end
          object functionDeleteFileFilePathStringboolean1: TMenuItem
            Caption = 'function DeleteFile(FilePath : String) : boolean;'
            Hint = 'DeleteFile('#39'FilePath'#39')'
            OnClick = GenericPopupClick
          end
          object functionFileExistsFilePathStringboolean1: TMenuItem
            Caption = 'function FileExists(FilePath : String) : boolean;'
            Hint = 'FileExists('#39'FilePath'#39')'
            OnClick = GenericPopupClick
          end
          object functionCopyFilesSrcDirDstDirSrcExtDestExtStringOverwritebooleanboolean2: TMenuItem
            Caption = 
              'function CopyFiles(SrcDir, DstDir, SrcExt, DestExt: String; Over' +
              'write : boolean) : boolean;'
            Hint = 
              'CopyFiles('#39'SourceDir'#39','#39'DestinationDir'#39','#39'SourceExtension'#39','#39'DestEx' +
              'tension'#39',True)'
            OnClick = GenericPopupClick
          end
        end
        object Version1: TMenuItem
          Caption = 'Version'
          object functionCompareVersionsFilePathStringinteger1: TMenuItem
            Caption = 'function CompareVersions(FilePath : String) : integer;'
            Hint = 'CompareVersions('#39'FilePath'#39')'
            OnClick = GenericPopupClick
          end
          object functionGetFileVersionFilePathStrhingString1: TMenuItem
            Caption = 'function GetFileVersion(FilePath : Strhing) : String;'
            Hint = 'GetFileVersion('#39'FilePath'#39')'
            OnClick = GenericPopupClick
          end
        end
      end
      object Windows2: TMenuItem
        Caption = 'Windows'
        object WindowHandling1: TMenuItem
          Caption = 'Window Handling'
          object functionFindWindowClassNameStringWindowNameStringhwnd1: TMenuItem
            Caption = 
              'function FindWindow(ClassName : String; WindowName : String) : h' +
              'wnd;'
            Hint = 'FindWindow('#39'MyWindowClass'#39','#39#39');'
            OnClick = GenericPopupClick
          end
        end
      end
    end
    object Constants1: TMenuItem
      Caption = 'Constants'
      object SharpApi2: TMenuItem
        Caption = 'SharpApi'
        object Directories1: TMenuItem
          Caption = 'Directories'
          object SHARPEDIR2: TMenuItem
            Caption = 'SHARPE_DIR'
            Hint = 'SHARPE_DIR'
            OnClick = GenericPopupClick
          end
          object SETTINGSGLOBALDIR1: TMenuItem
            Caption = 'SETTINGS_GLOBAL_DIR'
            Hint = 'SETTINGS_GLOBAL_DIR'
            OnClick = GenericPopupClick
          end
          object SETTINGSUSERDIR2: TMenuItem
            Caption = 'SETTINGS_USER_DIR'
            Hint = 'SETTINGS_USER_DIR'
            OnClick = GenericPopupClick
          end
        end
        object ServiceResults1: TMenuItem
          Caption = 'Service Results'
          object MRSTARTED1: TMenuItem
            Caption = 'MR_STARTED'
            Hint = 'MR_STARTED'
            OnClick = GenericPopupClick
          end
          object MRSTOPPED1: TMenuItem
            Caption = 'MR_STOPPED'
            Hint = 'MR_STOPPED'
            OnClick = GenericPopupClick
          end
          object MRERRORSTARTING1: TMenuItem
            Caption = 'MR_ERRORSTARTING'
            Hint = 'MR_ERRORSTARTING'
            OnClick = GenericPopupClick
          end
          object MROK1: TMenuItem
            Caption = 'MR_OK'
            Hint = 'MR_OK'
            OnClick = GenericPopupClick
          end
          object MRINCOMPATIBLE1: TMenuItem
            Caption = 'MR_INCOMPATIBLE'
            Hint = 'MR_INCOMPATIBLE'
            OnClick = GenericPopupClick
          end
          object MBERRORSTOPPING1: TMenuItem
            Caption = 'MR_ERRORSTOPPING'
            Hint = 'MR_ERRORSTOPPING'
            OnClick = GenericPopupClick
          end
          object MRSTARTED2: TMenuItem
            Caption = 'MR_STARTED'
            Hint = 'MR_STARTED'
            OnClick = GenericPopupClick
          end
          object MRFORCECONFIGDISABLE1: TMenuItem
            Caption = 'MR_FORCECONFIGDISABLE'
            Hint = 'MR_FORCECONFIGDISABLE'
            OnClick = GenericPopupClick
          end
        end
        object ApiMessages: TMenuItem
          Caption = 'Messages'
          object WMSHARPEUPDATESETTINGS1: TMenuItem
            Caption = 'WM_SHARPEUPDATESETTINGS'
            Hint = 'WM_SHARPEUPDATESETTINGS'
            OnClick = GenericPopupClick
          end
          object WMWEATHERUPDATE1: TMenuItem
            Caption = 'WM_WEATHERUPDATE'
            Hint = 'WM_WEATHERUPDATE'
            OnClick = GenericPopupClick
          end
          object WMDESKBACKGROUNDCHANGED1: TMenuItem
            Caption = 'WM_DESKBACKGROUNDCHANGED'
            Hint = 'WM_DESKBACKGROUNDCHANGED'
            OnClick = GenericPopupClick
          end
          object WMSHARPTERMINATE1: TMenuItem
            Caption = 'WM_SHARPTERMINATE'
            Hint = 'WM_SHARPTERMINATE'
            OnClick = GenericPopupClick
          end
        end
        object UpdateMessageParams1: TMenuItem
          Caption = 'Update Message Params'
          object SUSKIN1: TMenuItem
            Caption = 'SU_SKIN'
            Hint = 'SU_SKIN'
            OnClick = GenericPopupClick
          end
          object SUSKINFILECHANGED1: TMenuItem
            Caption = 'SU_SKINFILECHANGED'
            Hint = 'SU_SKINFILECHANGED'
            OnClick = GenericPopupClick
          end
          object SUSCHEME1: TMenuItem
            Caption = 'SU_SCHEME'
            Hint = 'SU_SCHEME'
            OnClick = GenericPopupClick
          end
          object SUTHEME1: TMenuItem
            Caption = 'SU_THEME'
            Hint = 'SU_THEME'
            OnClick = GenericPopupClick
          end
          object SUICONSET1: TMenuItem
            Caption = 'SU_ICONSET'
            Hint = 'SU_ICONSET'
            OnClick = GenericPopupClick
          end
          object SUBACKGROUND1: TMenuItem
            Caption = 'SU_BACKGROUND'
            Hint = 'SU_BACKGROUND'
            OnClick = GenericPopupClick
          end
          object SUSERVICE1: TMenuItem
            Caption = 'SU_SERVICE'
            Hint = 'SU_SERVICE'
            OnClick = GenericPopupClick
          end
          object SUDESKTOPICON1: TMenuItem
            Caption = 'SU_DESKTOPICON'
            Hint = 'SU_DESKTOPICON'
            OnClick = GenericPopupClick
          end
          object SUSHARPDESK1: TMenuItem
            Caption = 'SU_SHARPDESK'
            Hint = 'SU_SHARPDESK'
            OnClick = GenericPopupClick
          end
          object SUSHARPMENU1: TMenuItem
            Caption = 'SU_SHARPMENU'
            Hint = 'SU_SHARPMENU'
            OnClick = GenericPopupClick
          end
          object SUSHARPBAR1: TMenuItem
            Caption = 'SU_SHARPBAR'
            Hint = 'SU_SHARPBAR'
            OnClick = GenericPopupClick
          end
          object SUCURSOR1: TMenuItem
            Caption = 'SU_CURSOR'
            Hint = 'SU_CURSOR'
            OnClick = GenericPopupClick
          end
          object SUWALLPAPERP1: TMenuItem
            Caption = 'SU_WALLPAPER'
            Hint = 'SU_WALLPAPER'
            OnClick = GenericPopupClick
          end
        end
      end
      object Windows1: TMenuItem
        Caption = 'Windows'
        object Directrories1: TMenuItem
          Caption = 'Directrories'
          object WINDOWSDIR1: TMenuItem
            Caption = 'WINDOWS_DIR'
            Hint = 'WINDOWS_DIR'
            OnClick = GenericPopupClick
          end
          object WINDOWSSYSTEMDIR1: TMenuItem
            Caption = 'WINDOWS_SYSTEM_DIR'
            Hint = 'WINDOWS_SYSTEM_DIr'
            OnClick = GenericPopupClick
          end
          object WINDOWSTEMPDIR1: TMenuItem
            Caption = 'WINDOWS_TEMP_DIR'
            Hint = 'WINDOWS_TEMP_DIR'
            OnClick = GenericPopupClick
          end
          object DESKTOPDIR1: TMenuItem
            Caption = 'DESKTOP_DIR'
            Hint = 'DESKTOP_DIR'
            OnClick = GenericPopupClick
          end
          object STARTUPDIR1: TMenuItem
            Caption = 'STARTUP_DIR'
            Hint = 'STARTUP_DIR'
            OnClick = GenericPopupClick
          end
          object SHARPEDIR1: TMenuItem
            Caption = 'SHARPE_DIR'
            Hint = 'SHARPE_DIR'
            OnClick = GenericPopupClick
          end
          object COMMONSTARTUPDIR1: TMenuItem
            Caption = 'COMMON_STARTUP_DIR'
            Hint = 'COMMON_STARTUP_DIR'
            OnClick = GenericPopupClick
          end
        end
        object SystemInformations1: TMenuItem
          Caption = 'System Informations'
          object USERNAME1: TMenuItem
            Caption = 'USER_NAME'
            Hint = 'USER_NAME'
            OnClick = GenericPopupClick
          end
          object COMPUTERNAME1: TMenuItem
            Caption = 'COMPUTER_NAME'
            Hint = 'COMPUTER_NAME'
            OnClick = GenericPopupClick
          end
          object DOMAINNAME1: TMenuItem
            Caption = 'DOMAIN_NAME'
            Hint = 'DOMAIN_NAME'
            OnClick = GenericPopupClick
          end
        end
      end
    end
    object ScriptEngine1: TMenuItem
      Caption = 'Script Engine'
      object LOGWINDOWOFF1: TMenuItem
        Caption = '{$LOGWINDOW OFF}'
        Hint = '{$LOGWINDOW OFF}'
        OnClick = LOGWINDOWOFF1Click
      end
      object LOGWINDOWAUTOCLOSEON1: TMenuItem
        Caption = '{$LOGWINDOW AUTOCLOSE ON}'
        Hint = '{$LOGWINDOW AUTOCLOSE ON}'
        OnClick = LOGWINDOWOFF1Click
      end
    end
  end
end
