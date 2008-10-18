object frmEdit: TfrmEdit
  Left = 683
  Top = 363
  BorderStyle = bsNone
  Caption = 'Hotkey Configuration'
  ClientHeight = 38
  ClientWidth = 499
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  DesignSize = (
    499
    38)
  PixelsPerInch = 96
  TextHeight = 14
  object JvLabel1: TJvLabel
    Left = 280
    Top = 12
    Width = 48
    Height = 14
    Caption = 'Template:'
    Anchors = [akTop, akRight]
    Transparent = True
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'Tahoma'
    HotTrackFont.Style = []
  end
  object edName: TLabeledEdit
    Left = 56
    Top = 8
    Width = 201
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 30
    EditLabel.Height = 14
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 0
    OnChange = editStateEvent
  end
  object cbBasedOn: TComboBox
    Left = 341
    Top = 8
    Width = 150
    Height = 22
    Style = csDropDownList
    Anchors = [akTop, akRight]
    ItemHeight = 0
    TabOrder = 1
    OnChange = editStateEvent
  end
  object vals: TJvValidators
    ErrorIndicator = errorinc
    Left = 432
    Top = 44
    object valName: TJvRequiredFieldValidator
      Valid = True
      ControlToValidate = edName
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
  object pilError: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002AD4944415478DAA5935F48536114C08FD3FDBDA2D3C03F
          838CDC9C0327D1242171255692A13D64116925E5831609F522D1C3CC32A8A71E
          7CF0A52C1344AC3D0865A695A5A8889882E6726E13256F7F4CD331EFE69DF7FB
          3AFB0642992F75E070F9CE3DE777CE77BE732228A5F03F12F12740BA73594F28
          2DA5849C278424A102EA57D4274422ADDA7B2DEE6D01C1FA4B2594D086B50845
          B2426F80A89898B0DDBB0A82C3013261F50B215275C2FD76FB168078BB0A8349
          F37A420AA731A681C4CF01410D892C390564BA5DE09D7240C039B14624A97C67
          63877D13B05E57998A25F68B49293ACE680471A09B056A6C0FD9D767BB004028
          28AC05B03AF9117C8E315E22C46A68EAF2308060ABB0F923D575B1B9D67030DA
          428571379B18C07BA31C284133F6437DF0282CF47481B8C4D79A5ADEDC620074
          9891992D0679D00F1BB34E74A42C6374FD630658A9390754A24050E5FA7408CA
          95C0BF7BE1CA6CEB4B6380E59A3281CB2B506F7C18041A58C7AE539631F66E33
          032C5D2D6350A6910A50EDCF05F7D347FEBDF6410D037CBF765A88C92F540747
          07800444566A286374E575901BCDB078E50CCBCE2A932B408380E9F607FE7D1D
          2361005F7D6286B3E41AA2440144E7A74D67C59E6C90C52780AFAB239C1DED8A
          74136CA854E079F5CC95D33916BEC27CD5711BE5E2EB12F30E83AFA793398720
          898D6DEC0AFCC553D89230547BAC086611B8B2E0AE3DD03D116EA2BBA23015DF
          B63FDA64D1C59A32C0FBF23973566666018681303AC2CE7145C5B038390EF343
          AF797C766BFE5B87677390A6CEE69720A4599B91CDC599CC1098F540C0E586D0
          7FE5EE54A63F30786EA87B0D83CB0FF54EDBB78CF2F8C99C121C900655BC2E79
          87D9024A6D1C9B87C0CF65F836360CCB9F5D38CAA4FAC87BA7FDAFBB1092E1E2
          2C3D424A71717099A4DF978990D6823ED7F6CBF42FF20B25BFAEF0015EBF0E00
          00000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end>
    Left = 460
    Top = 44
    Bitmap = {}
  end
  object errorinc: TJvErrorIndicator
    BlinkRate = 200
    BlinkStyle = ebsNeverBlink
    Images = pilError
    ImageIndex = 0
    Left = 404
    Top = 44
  end
end
