object frmEditItem: TfrmEditItem
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmEditItem'
  ClientHeight = 69
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object plEdit: TJvPageList
    Left = 0
    Top = 0
    Width = 483
    Height = 69
    ActivePage = pagAdd
    PropagateEnable = False
    Align = alTop
    object pagAdd: TJvStandardPage
      Left = 0
      Top = 0
      Width = 483
      Height = 69
      DesignSize = (
        483
        69)
      object Label3: TJvLabel
        Left = 18
        Top = 44
        Width = 50
        Height = 13
        Caption = 'Template:'
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
      end
      object edName: TLabeledEdit
        Left = 56
        Top = 8
        Width = 157
        Height = 21
        EditLabel.Width = 31
        EditLabel.Height = 13
        EditLabel.Caption = 'Name:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 0
        OnKeyPress = edThemeNameKeyPress
      end
      object edAuthor: TLabeledEdit
        Left = 264
        Top = 8
        Width = 196
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 16
        EditLabel.Height = 13
        EditLabel.Caption = 'By:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 1
        OnKeyPress = edThemeNameKeyPress
      end
      object edWebsite: TLabeledEdit
        Left = 288
        Top = 40
        Width = 172
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 43
        EditLabel.Height = 13
        EditLabel.Caption = 'Website:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 2
        OnKeyPress = edThemeNameKeyPress
      end
      object cbBasedOn: TComboBox
        Left = 76
        Top = 40
        Width = 137
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        OnSelect = cbBasedOnSelect
      end
    end
    object pagDelete: TJvStandardPage
      Left = 0
      Top = 0
      Width = 483
      Height = 69
      BorderWidth = 8
      object Label2: TLabel
        Left = 0
        Top = 13
        Width = 304
        Height = 13
        Align = alTop
        Caption = 'Are you sure you want to delete the currently selected Theme?'
      end
      object Label1: TJvLabel
        Left = 0
        Top = 0
        Width = 67
        Height = 13
        Align = alTop
        Caption = 'Confirmation:'
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
        Images = pilError
      end
    end
  end
  object vals: TJvValidators
    ErrorIndicator = errorinc
    Left = 292
    Top = 40
    object valThemeName: TJvRequiredFieldValidator
      Valid = True
      ControlToValidate = edName
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'Required Field'
    end
    object valThemeAuthor: TJvRequiredFieldValidator
      Valid = True
      ControlToValidate = edAuthor
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'Required Field'
    end
    object valThemeDirNotExists: TJvCustomValidator
      Valid = True
      ControlToValidate = edName
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'Unique Field Required'
      OnValidate = valThemeDirNotExistsValidate
    end
  end
  object errorinc: TJvErrorIndicator
    BlinkRate = 200
    BlinkStyle = ebsNeverBlink
    Images = pilError
    ImageIndex = 0
    Left = 292
    Top = 8
  end
  object pilError: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002A744558744372656174696F6E2054696D65004D692035204D727A20
          323030332030313A31363A3336202B303130302D49F2060000000774494D4500
          0000000000000973942E000000097048597300000AF000000AF00142AC349800
          0002564944415478DAA5D35D4893511807F0FFBBBDEF9C4BA732537A474E215C
          D95DC22C8AA5284178679A4111751154170979652F8CCAF0030283A246102548
          D942E8630515097E93294936C7A08D9ACDD636DC74DFDBFBD161441FD0CAF081
          73F1F03CE777CE79E050586750D90AB357A18FD33A0B64794558B69DD8D381E7
          FF05CCDFCA1FD1353E30D254126F9F747C61A30B95156D88AC0970DD410BA36F
          B3149455037C08D1B0070B8F7ABBEA3970FF049C2FA05C59D2D9B7EE33953BA7
          AF811762D8BEB316EF8627E3E2E27C95E11C3EFE15B099C169765FBC94CB8FA1
          A866066A350BDBD30454253B307B77C8D2C089AD5981C5FB6043F26AC7E69AE3
          798AE000D8DAAF28D9580AEB3D2FB46C053E4CBAA465FB27631D87F13F027366
          F46BEBBA8F52F208347933D8DBE4449CD7627AC285B04F0D3A3706EB0DF79B16
          4EA8211BA5DF00C74D1824EDFEA9D22AA34C487BA05205601E18C5E740252E9B
          96108DAF80C98DC0FD3E8EE9C7E2B1233DE8FF15A066AF6F98D8D2D8BB2B9D74
          93CC0F9A0922AD706335560CB6700E922C04794E0A0A1560ED81271D86BEA90B
          D10C30DC89C3BADA53031A6D3999BA071415404E8E0FA30F5F43A662D0702806
          414A8051125B0E043DC02087CED3FD3065805757CA1C86D6EECA54C4411EE627
          4D0114324ED437079060F4981A1B87C0C721A37F5EF9591F561BCFA220938F98
          ABBD8603EDA5A9988B7478C9F291D37CA0150E088A222895767C9FD98F18BA00
          6FF3796CCA0083ED3858ACDBD627A7A97C498C419278B212A492842825040969
          9213428448122912803FE4C59993B7F132EB5F586BAC1BF8061506EE110DE119
          B00000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000032149
          44415478DAA593494C53511486FFD7D779A02D0261105AC0010165505B277024
          B1C401351216262E4C08312E8C31A038C5854374818961E142DDA86163AC1AE6
          A0629568834A44299432B43688166C2DA5E37BAF3E9E95188D2B6FF2E7DEDC73
          F2DD7BEEFD0F81FF1CC49F1BDAF24B6922227A19246908D38C9A6053847CC24D
          509439C010D5E3ADF5CE7F02320D176A081EEF7AF6622D3F2D3D050A858C4B08
          068398704E6278688C42247C69A8E5F4D9BF005AC3C5434AA5ECC68692623257
          9B888CD42424C9A248514BE0F187F1F4AD1D7D3617DEBD1D8094C75CEDB97BB4
          761ED070C7A46B6C7AF9AC6257A9E4D8BE02CC0642104A154855F241B2190E97
          0F8FBA2DE8EA1D83223E1E3DA6DE28685A3BDA76DAC101CA8FDC6CA2F8D2CAD2
          955944C5FA6C2C4850832D058802229241EF8013A68F5FE1F17C075F2040BF75
          028E21DB93A1D6335B39C0B28A2B767DC9EA8CE43801F69415233D5E82E900C0
          6719DF3C33B876AB1D5E7F083C3E8959B69CAC451ABC7A6EF60D3EAC5510B197
          0F55EC2D13E6A7ABB0A96821A6FC8050C0473842A3C3F41E2FCC166E1D8A5010
          8844282CCAC563632733D67C92E40099E517BDFBF76F579CAACC83CBEDC7E084
          0F84480E8AA63162FF828EEE770804230884C288500C4A4A57E3D1834E66BC25
          06607FA06747F97ADD89AA62522D17E1FE9301986DDF909FA3654FA5D9EB0761
          B17EC2A0D5CEBDFB8A821C98BA7AA6465AEA137F95703E2F4773BC6AA75EEA74
          4C60D8318D940405C4EA040458C06C200C920E8308F92196CBF1E6E3A7A8CD62
          BB676B3B73E017208D47C0B2718B5E3EE30B10F65127942A0536AFCB657F8B06
          4347B15CA38441AF45DBEB31DC6E7AEA2245629DB1E1E0F8BC9132CACE1D9629
          558DFAB5859872B9410A85E091245B338D249504BBD76642B7340993935391BE
          FEC1E6A6DB0D75EDEDEDD6DFADAC4A5E537D5CACD6D42D5E9AC559392E4ECE05
          66BE7B4179BE304B1205DE2519F2E1996967474D4D4D2345519FFF6CA6646972
          FEBAD4BC6DD5A464812E44F394739B4C78D6CBF89C1F566988376A19CF6A341A
          9BDD6EB7830D45FFEAC698BDE3582963B3885568EE22AC3CACBCE03CFA73FC00
          3E874620306956960000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end>
    Left = 292
    Top = 28
  end
end
