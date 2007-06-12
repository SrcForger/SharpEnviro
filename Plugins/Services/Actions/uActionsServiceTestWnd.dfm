object Form4: TForm4
  Left = 0
  Top = 0
  Width = 434
  Height = 320
  Caption = 'Form4'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 12
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 96
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 12
    Top = 48
    Width = 97
    Height = 25
    Caption = 'RegisterActions'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 12
    Top = 80
    Width = 97
    Height = 25
    Caption = 'UpdateActions'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Edit1: TEdit
    Left = 12
    Top = 116
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object Button5: TButton
    Left = 140
    Top = 116
    Width = 75
    Height = 25
    Caption = 'Execute'
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 116
    Top = 80
    Width = 97
    Height = 25
    Caption = 'DeleteAction'
    TabOrder = 6
    OnClick = Button6Click
  end
end
