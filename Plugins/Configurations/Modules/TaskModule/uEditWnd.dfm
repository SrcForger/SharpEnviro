object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  Caption = 'frmEdit'
  ClientHeight = 470
  ClientWidth = 503
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
  object lbItems: TSharpEListBoxEx
    AlignWithMargins = True
    Left = 5
    Top = 367
    Width = 493
    Height = 148
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 0
    Columns = <
      item
        Width = 256
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
        ColumnType = ctDefault
        VisibleOnSelectOnly = False
        Images = pilListBox
      end
      item
        Width = 90
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = False
        ColumnType = ctCheck
        VisibleOnSelectOnly = False
      end
      item
        Width = 90
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = False
        ColumnType = ctCheck
        VisibleOnSelectOnly = False
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = clWindow
    Colors.ItemColorSelected = clBtnFace
    Colors.CheckColorSelected = clBtnFace
    Colors.CheckColor = clWindow
    Colors.DisabledColor = clBlack
    DefaultColumn = 0
    OnResize = lbItemsResize
    ItemHeight = 30
    OnClickCheck = lbItemsClickCheck
    OnClickItem = lbItemsClickItem
    OnGetCellCursor = lbItemsGetCellCursor
    OnGetCellText = lbItemsGetCellText
    OnGetCellImageIndex = lbItemsGetCellImageIndex
    AutosizeGrid = True
    Borderstyle = bsNone
    Ctl3d = False
    Align = alTop
  end
  object pnlOptions: TPanel
    Left = 0
    Top = 0
    Width = 503
    Height = 362
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object pnlStyleAndSort: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 47
      Width = 493
      Height = 31
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      ExplicitTop = 45
      object lblSort: TLabel
        Left = 205
        Top = 4
        Width = 56
        Height = 13
        Caption = 'Sort Mode: '
      end
      object lblStyle: TLabel
        Left = 0
        Top = 4
        Width = 31
        Height = 13
        Caption = 'Style: '
      end
      object cbStyle: TComboBox
        AlignWithMargins = True
        Left = 36
        Top = 0
        Width = 150
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 0
        Style = csDropDownList
        Constraints.MaxWidth = 200
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Default'
        OnChange = SettingsChange
        Items.Strings = (
          'Default'
          'Compact'
          'Minimal')
      end
      object cbSortMode: TComboBox
        AlignWithMargins = True
        Left = 272
        Top = 0
        Width = 150
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 0
        Style = csDropDownList
        Constraints.MaxWidth = 200
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'None'
        OnChange = SettingsChange
        Items.Strings = (
          'None'
          'Caption'
          'Window Class Name'
          'Time Added'
          'Icon')
      end
    end
    object pnlButtons: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 181
      Width = 488
      Height = 19
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 3
      ExplicitTop = 177
      object chkMinimiseBtn: TJvXPCheckbox
        Left = 0
        Top = -1
        Width = 129
        Height = 17
        Caption = 'Minimise Tasks'
        TabOrder = 0
        OnClick = SettingsChange
      end
      object chkRestoreBtn: TJvXPCheckbox
        Left = 143
        Top = -1
        Width = 124
        Height = 17
        Caption = 'Restore Tasks'
        TabOrder = 1
        OnClick = SettingsChange
      end
      object chckToggleBtn: TJvXPCheckbox
        Left = 281
        Top = -1
        Width = 161
        Height = 17
        Caption = 'Toggle Tasks'
        TabOrder = 2
        OnClick = SettingsChange
      end
    end
    object schTaskOptions: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 0
      Width = 493
      Height = 37
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Task Options'
      Description = 'Define the type of task style you wish to use.'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      Color = clWindow
    end
    object schButtons: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 134
      Width = 493
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Buttons'
      Description = 'Define which buttons you want to enable.'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      Color = clWindow
    end
    object schFilters: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 296
      Width = 493
      Height = 37
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Filters'
      Description = 'Define the Filter conditions that apply to this task group.'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      Color = clWindow
      ExplicitTop = 294
    end
    object chkMiddleClose: TJvXPCheckbox
      AlignWithMargins = True
      Left = 5
      Top = 81
      Width = 493
      Height = 17
      Margins.Left = 5
      Margins.Right = 5
      Caption = 'Close tasks on middle click'
      TabOrder = 1
      Checked = True
      State = cbChecked
      Align = alTop
      OnClick = chkFilterTasksClick
    end
    object chkFilterTasks: TJvXPCheckbox
      AlignWithMargins = True
      Left = 5
      Top = 343
      Width = 493
      Height = 17
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Caption = 'Filter Tasks (When enabled only checked tasks will apply)'
      TabOrder = 5
      Align = alTop
      OnClick = chkFilterTasksClick
      ExplicitTop = 341
    end
    object SharpECenterHeader1: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 220
      Width = 493
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Application Bar Tasks'
      Description = 
        'Define if you want to show tasks which are part of any applicati' +
        'on bar module.'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      Color = clWindow
    end
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 267
      Width = 488
      Height = 19
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 4
      object chkAppBar: TJvXPCheckbox
        Left = 0
        Top = -1
        Width = 321
        Height = 17
        Caption = 'Show Application Bar Windows'
        TabOrder = 0
        OnClick = SettingsChange
      end
    end
    object chkTaskPreviews: TJvXPCheckbox
      AlignWithMargins = True
      Left = 5
      Top = 104
      Width = 493
      Height = 17
      Margins.Left = 5
      Margins.Right = 5
      Caption = 'Show task previews (Requires Vista/Win7 Home Premium or above)'
      TabOrder = 2
      Checked = True
      State = cbChecked
      Align = alTop
      OnClick = chkFilterTasksClick
    end
  end
  object pilListBox: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000025A4944415478DAA5935F4853511CC7BF3FB7B972D9B607
          D34D5D69413D64C5A2A71C0A415041588AF5D2A3045BC988A4DC102124D010B5
          28E88F651A6254B420A81EEAA13063646EA69B632A59E9D2C214EF8CB9DD7B3A
          F72A8BA01E56877BF87239E7F7F9FD7E87EF8F1863F89F4565CE1E4771E9AEC6
          D945A653589204C6B728895C1924C6FF45912B5354E4676BD397A2C1E0E49987
          2D472E53C3BD3131335397966AE6B1E088D4E62C5191AB7BF49F7AF8FAF913AE
          D59412D57685595D796ECA8013ADAFD15EBB87E86C678803F2B05C06533E10E1
          5D7FFF5F83775AADB0B7F6A2C3BD97036E8F30D72133AA5A3F242FDC706EC080
          CF079BCDF647802008B037BF4267FD3EA29A5BC3CC7D380FA464962B20AE80DF
          EFE78062BC1C9EC4CCFC0F08312DB41A35F41912761768E168F1E2CEB90344A7
          DB877805B972D5485A82965BF14DCC212AE9B0C5BC066A8D8A839630BB10435A
          5C40876710DD0D07894E5DF72B8064ECCA5304820144549B50B43E1342428538
          F7847C47BF4A85A1F017789E0EA0E77C1951F595B7CC5D9E8FEAABD3C91E2F1E
          CF4628144278C982926D39985E48702301B10483314383C0F837781EF7E1FE85
          0AA29397BCCC5591BF92FB9725C2E130266923B6171A3013654848CB67069D06
          FD831378F6DC8707CD95448EB6371C6051827F4710862371E80D4668B4E98889
          0CEA3442E47B1C53FE17187FEF4763531DC9B370373BDF5C29C97E17F90CC82A
          CF423C0E4DBA1A39EB8CB06EB5282DCC0B31883301D8B2A63037DA9BF838E23D
          46A94EE3A3FAFD5526534E5356C10E43D0FB64316580BCBAEC9B8F9A0A8B6E4A
          5262F54F48E51A8F8097AC900000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001E24944415478DA630C28581164E3609AF5F6EB7F0E867F
          FF18FE03F19F3F7F18FEFD07B2FFFE05D2FFC1F45FA0381FDBAF1FD7AF3F9DB6
          BE3F7C1D031430B6ACBE7B8897979B89814870F7FA8D7F130BECEDE006542DBB
          738458CD20F0FAC9638659A50E3670032A17DF3ED216A342B401C9ED7B19E656
          3A230CA85874F3487BAC1AC3CF3F7F19D6EDBE2EF9F20FB7FCABCFFF9889088F
          AFC0F02867AC5878E3487B9C3AC36FA044F78687D63C3CDC44BB06141E8CA5F3
          AF1EE94AD062F80334B57EE57D6B52C383B168F6C523BD297A0C7F81CEAB5D7A
          D79AD4F060CC9B76E6C8C44C63867F4081EAC5B7AC61E1F1FFDF7FA05F19C02E
          03F9F9EF9FFF100C0C8F5F7FFF33284AF03224B4EE6260CC9E78E2C8943C73B0
          89958B6E5AC3C203E820B0ABFEFD05D140FC0F1478C040041AFA0F6890B83027
          435CE3760646604A6C12979572FAF3EB3783908484352C3C807A8086FC67F803
          D40D320C8CFF31800D01B94298979D21A66E2B032348110C14CFB9F41F161E0C
          5003402C90F7188186FE031902E20305B8D9591822AA36A01A903FFDEC7F5878
          C0C4FF21C98300C870901C270B0B4348E91A540372269DFC0F0B0F624060D14A
          5403020B57AE04864718283CFE82521ED0ADBF7FFE84A4406020FE0786073855
          82BCF30FAC65158A01E40000E7BA450E87D3A7BC0000000049454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001D04944415478DA63FCFFFF3F032580B175F5DD43ECAC0C
          46EFBEFDE7069BF5EF1FC37F206600B2FFFEFF0B64FF67F8F71F28F6F72F90FE
          0FA6FF02E5F9D87E7DFDFEF3FF39C696D577FF7A198A305D7CF293E1D38F7F58
          6D311678CA70F683349CCE5B1DCDB03C6129C3893337FE31562DBBF3FFFF5FA0
          C920EB413601E97F401BC0B6425DF3EFEF3F841898FD0788817AFEFD6560AC5C
          7CFBFFF6DE5006464646AC988989098CD1F920ACE052C5C058B1E8E6FFDD13A3
          18DEBC7983A2089B0664BEA8A82883947D09D0808537FEEF9E140D3660C3860D
          0C376EDC60A8A9A921CA0009EB4206C6D2F957FF1F9E990C77C1CE9D3B19A64E
          9DCAB06DDB360C4DC8AE131313631034CE62602C997BE5FF89F919600356AE5C
          C970FBF66D86C6C64614C5D8C24144448481472F8581B168F6C5FFE7971530BC
          7DFB16230C403408A0BB0004405E60D38863602C9C79FEFFD5B5E5702FA03B15
          5BC08230C8058CCA110C8C79D3CEFCBFB3A58EA00B407C64B6909010C35F3960
          F4E74E3EF5FFC1AE6686F7EFDF43D2360E1B61186608C8809F92010C8CD9134F
          FC7F76A013A7627CE25F447D181873261C9AFDFB2F43CA3F50660126D3BF20FA
          1F34F3FC83256148B2052579581207E53786FFBFE630529A9D0139D0041C9AB9
          E6030000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002AB4944415478DA7D525F48536114FF7DBBD64037DD7457
          E7FEE814A230C4CC36B1C860F48F8AE8A1C79ECAE8D1B70814DF222D4A1F144A
          A795C52D6AD25434FF4453584146B6A92D11225F0AE9C1D43162BAEDEBDCCF26
          0AE97739DFB9DFBDDFF99DDF39E7C738E7D8694D4E4E3E8CC7E397565757D3C8
          636D6D4D189D55FF9C6D07100A85B228C06330182E6AB5E9885110924988DB14
          63341A30343488FF020483C1D36AB0C964B2666464E0FBFC0FCA16A7788E244F
          121087395FC6BBC03858381C8E251289DD645029AAA6D2DB4C7713652C2EFE26
          A0244E9E3A83F1B13760D3D3D3DC662BC0D2D2B2C8CED587AB2CB930F5403991
          6DCC425FAF0F8EA2BD481080D562C6E80895404DE246A309D73B3ED13506C668
          5FDF84572DB2B2823BD75C18F38F221A8D42657BF6DC050C0EF4824D4C4C7093
          9C871B9ECF3066E740A3D1806924E1D7DF35F836378BDB579D181919C0BE9203
          E0D4039BD50C9FCF0B160804B8D962475D57083926792368B39FFBFA058D3515
          22637EB58CBE791FEAF737C2FB4201F3FBFDDC6E77A0BE7B0672AE796BB05A02
          F9D99929DCBA520EDF2B2FDEDA5F231A89A3BDFA119E298FC18687877971F11E
          343C0D23D76C41516EBAA87F7D31FC5C8E233C15C4CDCBE522A3D375549D220A
          0B2C78D2DD05D6DFDFCF4B4A4A51DBFA7E474536D61CA2804E541D76130087A3
          D086AECEFB603D3D3DDCE9AC44241211E35105138DC6687A4968B5BBA80C2ED4
          A7D7E9E0F174E048F509A14887C38EF607AD608AA2DC25811C4B09857CB65EAF
          2F5285B4B0B010A37E68359224B461B158515676503032E7C96868A8DB2AE596
          96965A0239EFAAAC7267661AE17DA9FCA1992BA405177D2F4DA933A558FA37BB
          01D0DCDC2C4B92F4CBED3E0E9D5E4F1712489334047A2F4AC0BAED7AB301D0D4
          D42411FD0F94A122A5FF7F193FB6B5B5B9B603F80B10F37EDA972DDD14000000
          0049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end>
    Left = 460
    Top = 252
    Bitmap = {}
  end
end
