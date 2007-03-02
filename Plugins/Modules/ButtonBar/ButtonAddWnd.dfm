object ButtonAddForm: TButtonAddForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Add Button to ButtonBar Module'
  ClientHeight = 184
  ClientWidth = 235
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
  object Label1: TLabel
    Left = 8
    Top = 96
    Width = 54
    Height = 13
    Caption = 'Click Action'
  end
  object lb_icon: TLabel
    Left = 48
    Top = 56
    Width = 64
    Height = 13
    Caption = 'Icon Location'
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 37
    Height = 13
    Caption = 'Caption'
  end
  object edit_action: TEdit
    Left = 8
    Top = 120
    Width = 185
    Height = 21
    TabOrder = 0
    Text = 'C:\'
  end
  object btn_open: TButton
    Left = 204
    Top = 120
    Width = 22
    Height = 22
    Caption = '...'
    TabOrder = 1
    OnClick = btn_openClick
  end
  object img_icon: TImage32
    Left = 8
    Top = 58
    Width = 32
    Height = 32
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 2
  end
  object edit_icon: TEdit
    Left = 48
    Top = 72
    Width = 145
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = 'shell:icon'
  end
  object btn_selecticon: TButton
    Left = 200
    Top = 70
    Width = 25
    Height = 22
    Caption = '...'
    TabOrder = 4
    OnClick = btn_selecticonClick
  end
  object Edit_caption: TEdit
    Left = 8
    Top = 24
    Width = 201
    Height = 21
    TabOrder = 5
  end
  object Button1: TButton
    Left = 72
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 152
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 7
    OnClick = Button2Click
  end
end
