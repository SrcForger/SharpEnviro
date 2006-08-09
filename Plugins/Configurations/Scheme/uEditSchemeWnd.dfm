object EditSchemeForm: TEditSchemeForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Create/Edit Color Scheme'
  ClientHeight = 195
  ClientWidth = 246
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 8
    Top = 8
    Width = 67
    Height = 13
    Caption = 'Scheme Name'
  end
  object Panel1: TPanel
    Left = 64
    Top = 40
    Width = 57
    Height = 105
    BevelOuter = bvLowered
    TabOrder = 0
    object b1: TSharpEColorBox
      Left = 14
      Top = 8
      Width = 35
      Height = 15
      BackgroundColor = clBtnFace
      Color = clWhite
      ColorCode = 16777215
      CustomScheme = False
      ClickedColorID = ccCustom
    end
    object l1: TSharpEColorBox
      Left = 14
      Top = 32
      Width = 35
      Height = 15
      BackgroundColor = clBtnFace
      Color = clWhite
      ColorCode = 16777215
      CustomScheme = False
      ClickedColorID = ccCustom
    end
    object d1: TSharpEColorBox
      Left = 14
      Top = 56
      Width = 35
      Height = 15
      BackgroundColor = clBtnFace
      Color = clWhite
      ColorCode = 16777215
      CustomScheme = False
      ClickedColorID = ccCustom
    end
    object f1: TSharpEColorBox
      Left = 14
      Top = 82
      Width = 35
      Height = 15
      BackgroundColor = clBtnFace
      Color = clWhite
      ColorCode = 16777215
      CustomScheme = False
      ClickedColorID = ccCustom
    end
  end
  object Panel2: TPanel
    Left = 122
    Top = 40
    Width = 57
    Height = 105
    BevelOuter = bvLowered
    TabOrder = 1
    object b2: TSharpEColorBox
      Left = 14
      Top = 8
      Width = 35
      Height = 15
      BackgroundColor = clBtnFace
      Color = clWhite
      ColorCode = 16777215
      CustomScheme = False
      ClickedColorID = ccCustom
    end
    object l2: TSharpEColorBox
      Left = 14
      Top = 32
      Width = 35
      Height = 15
      BackgroundColor = clBtnFace
      Color = clWhite
      ColorCode = 16777215
      CustomScheme = False
      ClickedColorID = ccCustom
    end
    object d2: TSharpEColorBox
      Left = 14
      Top = 56
      Width = 35
      Height = 15
      BackgroundColor = clBtnFace
      Color = clWhite
      ColorCode = 16777215
      CustomScheme = False
      ClickedColorID = ccCustom
    end
    object f2: TSharpEColorBox
      Left = 14
      Top = 82
      Width = 35
      Height = 15
      BackgroundColor = clBtnFace
      Color = clWhite
      ColorCode = 16777215
      CustomScheme = False
      ClickedColorID = ccCustom
    end
  end
  object Panel3: TPanel
    Left = 180
    Top = 40
    Width = 57
    Height = 105
    BevelOuter = bvLowered
    TabOrder = 2
    object b3: TSharpEColorBox
      Left = 14
      Top = 8
      Width = 35
      Height = 15
      BackgroundColor = clBtnFace
      Color = clWhite
      ColorCode = 16777215
      CustomScheme = False
      ClickedColorID = ccCustom
    end
    object l3: TSharpEColorBox
      Left = 14
      Top = 32
      Width = 35
      Height = 15
      BackgroundColor = clBtnFace
      Color = clWhite
      ColorCode = 16777215
      CustomScheme = False
      ClickedColorID = ccCustom
    end
    object d3: TSharpEColorBox
      Left = 14
      Top = 56
      Width = 35
      Height = 15
      BackgroundColor = clBtnFace
      Color = clWhite
      ColorCode = 16777215
      CustomScheme = False
      ClickedColorID = ccCustom
    end
    object f3: TSharpEColorBox
      Left = 14
      Top = 82
      Width = 35
      Height = 15
      BackgroundColor = clBtnFace
      Color = clWhite
      ColorCode = 16777215
      CustomScheme = False
      ClickedColorID = ccCustom
    end
  end
  object edit_name: TEdit
    Left = 88
    Top = 6
    Width = 149
    Height = 21
    TabOrder = 3
    Text = 'My Scheme'
  end
  object Panel4: TPanel
    Left = 16
    Top = 40
    Width = 47
    Height = 105
    BevelOuter = bvLowered
    TabOrder = 4
    object Label1: TLabel
      Left = 12
      Top = 8
      Width = 23
      Height = 13
      Caption = 'Base'
    end
    object Label2: TLabel
      Left = 12
      Top = 32
      Width = 23
      Height = 13
      Caption = 'Light'
    end
    object Label3: TLabel
      Left = 12
      Top = 56
      Width = 22
      Height = 13
      Caption = 'Dark'
    end
    object Label4: TLabel
      Left = 12
      Top = 80
      Width = 22
      Height = 13
      Caption = 'Font'
    end
  end
  object btn_cancel: TButton
    Left = 160
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = btn_cancelClick
  end
  object btn_ok: TButton
    Left = 72
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 6
    OnClick = btn_okClick
  end
end
