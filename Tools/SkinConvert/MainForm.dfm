object Form31: TForm31
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'SharpEnviro Skin Converter'
  ClientHeight = 140
  ClientWidth = 563
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 70
    Width = 76
    Height = 17
    Caption = 'Old Skin File:'
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 547
    Height = 32
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alTop
    Caption = 
      'Convert old styled SharpEnviro skins which are only using xml it' +
      'ems for all skin part properties to properly formatted Skins whi' +
      'ch are only using xml properties for the skin parts.'
    WordWrap = True
    ExplicitWidth = 609
  end
  object edtSrcFile: TEdit
    Left = 98
    Top = 67
    Width = 391
    Height = 25
    TabOrder = 0
  end
  object Button1: TButton
    Left = 495
    Top = 67
    Width = 42
    Height = 26
    Caption = '...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 462
    Top = 99
    Width = 75
    Height = 25
    Caption = 'Convert'
    TabOrder = 2
    OnClick = Button2Click
  end
  object OpenXMLDialog: TOpenDialog
    Filter = 'XML Files (*.xml)|*.xml'
    Left = 376
    Top = 99
  end
end
