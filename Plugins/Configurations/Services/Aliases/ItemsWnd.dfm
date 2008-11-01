object frmItemsWnd: TfrmItemsWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmItemsWnd'
  ClientHeight = 320
  ClientWidth = 434
  Color = clBtnFace
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
    Left = 0
    Top = 0
    Width = 434
    Height = 320
    Columns = <
      item
        Width = 30
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
        ColumnType = ctDefault
        AutoSize = False
      end
      item
        Width = 30
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        AutoSize = False
        Images = pilIcons
      end
      item
        Width = 30
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        CanSelect = False
        ColumnType = ctDefault
        AutoSize = False
        Images = pilIcons
      end
      item
        Width = 30
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        CanSelect = False
        ColumnType = ctDefault
        AutoSize = False
        Images = pilIcons
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = clWindow
    Colors.ItemColorSelected = clBtnFace
    Colors.CheckColorSelected = clBtnFace
    Colors.CheckColor = 15528425
    Colors.DisabledColor = clBlack
    OnResize = lbItemsResize
    ItemHeight = 25
    OnClickItem = lbItemsClickItem
    OnGetCellCursor = lbItemsGetCellCursor
    OnGetCellText = lbItemsGetCellText
    OnGetCellImageIndex = lbItemsGetCellImageIndex
    AutosizeGrid = True
    Borderstyle = bsNone
    Align = alTop
  end
  object pilIcons: TPngImageList
    PngImages = <
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
        Name = 'PngImage1'
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
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000003334944415478DA75D16B48537118C7F1DF39BBEA2EB672E9D6C53466
          697613222232CB1574252B0ABAA96817CD5C4BAD48123449A3ECE614C28A1083
          245F246945B3C839492BA27CD1CDB4D145DDE6656E6E9EED6CE7B4DE0C337B5E
          FEF9F3E1FBF0102CCB62E2AC4F2F5B141926DCAB0895C4FA181FFBCBE2E8FC39
          C4D43EBD99FF69E25F6222907CA4E470EA96C5950B544A8ED3E584D74B83CF13
          E0ED071355FFE27BC6C31B67EEFE17484A2B8B3EB8696EE7F2F86841CD03C387
          2F3FC71E323E1FAB94B15B0F2427C4BE7AF7D971DF685FF4B45A6B9A14D89959
          7CFABC6653E913E39BDE7AA37399E1CE89DE3FEFAB532ECA13637C9D1B129784
          5FAA7DA7A9D79DBE3E2990965776ED547A624EF5FD9696F2C25389E353538FE5
          1A3726CC5DD9D8315A5E73E964DEA4C03E6DE9D5FD1B23350D2DDDCFAB4A0A92
          C60329D9270CDB56CF5955D74E5FBC579E7BF21F60735AD1FA98E9F495156B96
          C67E7AF5DAEC76F3F55C2EC9631996F0521E2FC975AD8B8B9F2737B67475F5B8
          E55A1F5FDADA54996D0F0025C7B2F4FB16B2EA8F441866B9BF224221044B10F0
          8EBA40596CE8192661954462CED03734052D31B60FC98B1A2B729A03C0B99CCC
          E6BCDDF393BC440838220948011F3C5110189A06353408DA66836778182465C7
          ED1FD2B6D65E495193EEB83E009CCD3CA4D7EE88507B450A7042A683E007A3A7
          ED2558C683F0A8708C59AD7099CD2047AC68A0E7193B0626161CCDD0E7A7C6A9
          3DFC0870F93C74BF7F8BD7BA2A90C152AC2BC88790A54099FBC0B35B70CB3CB3
          D5D82FF317689E8D03D2F5C79367A95D4E0EF8521138B2503494EA10A68AC3DA
          F464384C5D18EBEF07C73E805BD6D9063F50FC683C507428557F249E50332172
          042B674010168E8AAC4244C545637B6E06464C2650FD7DFE152CA836CF36B4F9
          0B1E556A9E078082B403CD2931741231550E91520136488CCB070BA15445E1F0
          052D6C7EC0E52F20EC83B8E75219DA2DD38AFF5A213BE368DD9EF99E5D62D914
          88A7C9200A95C14D7321904C01E97360A4CF0CA7FF0A4E1785BA5FF2075F6CD2
          B2C7559A8E00B0214B3795C7381342043E9558088548C89589A5C1229665E070
          B8479D6E76C041A1D741F3BA6986D7CEE590838DBA2CE63780C897F062B00499
          0000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end>
    Left = 220
    Top = 164
    Bitmap = {}
  end
end
