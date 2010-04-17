object CreateInstallScriptForm: TCreateInstallScriptForm
  Left = 0
  Top = 0
  Caption = 'Create Install Script'
  ClientHeight = 582
  ClientWidth = 797
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ed_script: TJvHLEditor
    Left = 0
    Top = 36
    Width = 567
    Height = 449
    Cursor = crIBeam
    Lines.Strings = (
      'unit InstallScript;'
      ''
      'interface'
      ''
      'function BeforeInstall : boolean;'
      'function Install : boolean;'
      'function AfterInstall : boolean;'
      'function UnInstall : boolean;'
      ''
      'implementation'
      ''
      '// Code to be executed before install process starts'
      
        '// Can be used to Close/Terminate SharpE components and check if' +
        ' already installed'
      '// result = true -> start install'
      'function BeforeInstall : boolean;'
      'begin'
      '  result := True;'
      'end;'
      ''
      '// Install code'
      'function Install : boolean;'
      'begin'
      '  result := True;'
      'end;'
      ''
      '// Code to be executed after copying all files finished'
      '// Can be used to Start SharpE components'
      '// result = true -> install process 100% done'
      'function AfterInstall : boolean;'
      'begin'
      '  result := True;'
      'end;'
      ''
      '// Not used at the moment'
      'function UnInstall : boolean;'
      'begin'
      'end;'
      ''
      ''
      'end.')
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
    ExplicitHeight = 447
  end
  object ToolBar2: TToolBar
    Left = 0
    Top = 0
    Width = 797
    Height = 36
    AutoSize = True
    ButtonHeight = 36
    ButtonWidth = 74
    Caption = 'ToolBar2'
    Images = PngImageList1
    ShowCaptions = True
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Caption = 'Create'
      ImageIndex = 2
      OnClick = ToolButton1Click
    end
    object ToolButton3: TToolButton
      Left = 74
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 4
      Style = tbsSeparator
    end
    object ToolButton2: TToolButton
      Left = 82
      Top = 0
      Caption = 'Compile (test)'
      ImageIndex = 3
      OnClick = ToolButton2Click
    end
  end
  object Panel1: TPanel
    Left = 567
    Top = 36
    Width = 230
    Height = 449
    Align = alRight
    TabOrder = 2
    object Panel2: TPanel
      Left = 1
      Top = 257
      Width = 228
      Height = 191
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 0
      object Label1: TLabel
        Left = 5
        Top = 5
        Width = 25
        Height = 13
        Align = alTop
        Caption = 'Files:'
      end
      object lb_files: TListBox
        Left = 5
        Top = 18
        Width = 218
        Height = 146
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
      object ToolBar1: TToolBar
        Left = 5
        Top = 164
        Width = 218
        Height = 22
        Align = alBottom
        AutoSize = True
        Caption = 'ToolBar1'
        Images = PngImageList1
        TabOrder = 1
        ExplicitTop = 162
        object btn_addfile: TToolButton
          Left = 0
          Top = 0
          Caption = 'btn_addfile'
          ImageIndex = 1
          OnClick = btn_addfileClick
        end
        object btn_deletefile: TToolButton
          Left = 23
          Top = 0
          Caption = 'btn_deletefile'
          ImageIndex = 0
          OnClick = btn_deletefileClick
        end
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 129
      Width = 228
      Height = 128
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 1
      object Label2: TLabel
        Left = 5
        Top = 5
        Width = 55
        Height = 13
        Align = alTop
        Caption = 'Changelog:'
      end
      object ed_changelog: TMemo
        Left = 5
        Top = 18
        Width = 218
        Height = 105
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 228
      Height = 128
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 2
      object Label3: TLabel
        Left = 5
        Top = 5
        Width = 218
        Height = 13
        Align = alTop
        Caption = 'Release Notes:'
        ExplicitWidth = 73
      end
      object ed_rnotes: TMemo
        Left = 5
        Top = 18
        Width = 218
        Height = 105
        Align = alClient
        Lines.Strings = (
          'Release:'
          'Version:'
          'Author:'
          'Website:')
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object lb_errors: TListBox
    Left = 0
    Top = 485
    Width = 797
    Height = 97
    Align = alBottom
    ItemHeight = 13
    TabOrder = 3
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
      end>
    Left = 216
    Top = 184
    Bitmap = {}
  end
  object AddFileDialog: TOpenDialog
    Filter = 'Any File (*.*)|*.*'
    Options = [ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent, ofForceShowHidden]
    Left = 376
    Top = 256
  end
  object SavePackageDialog: TSaveDialog
    Filter = 'SharpE Install Package|*.sip'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoReadOnlyReturn, ofEnableSizing, ofForceShowHidden]
    Left = 320
    Top = 192
  end
  object XPManifest1: TXPManifest
    Left = 272
    Top = 240
  end
  object JvInterpreter: TJvInterpreterProgram
    Left = 240
    Top = 104
  end
end
