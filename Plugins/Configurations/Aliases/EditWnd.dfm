object frmEditWnd: TfrmEditWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmEditWnd'
  ClientHeight = 95
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    490
    95)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TPngSpeedButton
    Left = 390
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Browse'
    OnClick = Button1Click
  end
  object edName: TLabeledEdit
    Left = 56
    Top = 8
    Width = 409
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 31
    EditLabel.Height = 13
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 0
    OnChange = UpdateEditState
  end
  object edCommand: TLabeledEdit
    Left = 80
    Top = 40
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 51
    EditLabel.Height = 13
    EditLabel.Caption = 'Command:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 1
    OnChange = UpdateEditState
  end
  object cbElevation: TCheckBox
    Left = 80
    Top = 71
    Width = 117
    Height = 17
    Caption = 'Process Elevation'
    TabOrder = 2
    OnClick = UpdateEditState
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
      end>
    Left = 452
    Top = 60
    Bitmap = {}
  end
  object vals: TJvValidators
    ErrorIndicator = errorinc
    Left = 420
    Top = 60
    object valName: TJvRequiredFieldValidator
      Valid = True
      ControlToValidate = edName
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'Required Field'
    end
    object valCommand: TJvRequiredFieldValidator
      Valid = True
      ControlToValidate = edCommand
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'Required Field'
    end
    object valNameExists: TJvCustomValidator
      Valid = True
      ControlToValidate = edName
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'This name is already in use'
      OnValidate = valNameExistsValidate
    end
  end
  object errorinc: TJvErrorIndicator
    BlinkRate = 200
    BlinkStyle = ebsNeverBlink
    Images = pilError
    ImageIndex = 0
    Left = 388
    Top = 60
  end
end
