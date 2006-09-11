object SchemeEditForm: TSchemeEditForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Create/Edit color scheme'
  ClientHeight = 304
  ClientWidth = 468
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 468
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 64
      Width = 27
      Height = 13
      Caption = 'Name'
    end
    object Label2: TLabel
      Left = 160
      Top = 64
      Width = 18
      Height = 13
      Caption = 'Tag'
    end
    object Label3: TLabel
      Left = 296
      Top = 64
      Width = 20
      Height = 13
      Caption = 'Info'
    end
    object Label4: TLabel
      Left = 392
      Top = 64
      Width = 63
      Height = 13
      Caption = 'Default Color'
    end
    object Label5: TLabel
      Left = 5
      Top = 5
      Width = 458
      Height = 13
      Align = alTop
      Caption = 
        'Note: To delete colors just leave <tag> or <name> empty and clic' +
        'k '#39'ok'#39
    end
    object Button3: TButton
      Left = 384
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Add Color'
      TabOrder = 0
      OnClick = Button3Click
    end
  end
  object cpanel: TPanel
    Left = 0
    Top = 89
    Width = 468
    Height = 174
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
  end
  object Panel3: TPanel
    Left = 0
    Top = 263
    Width = 468
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object Button1: TButton
      Left = 384
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 296
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Ok'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
end
