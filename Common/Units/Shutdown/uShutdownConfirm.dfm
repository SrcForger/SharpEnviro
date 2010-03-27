object ShutdownConfirmForm: TShutdownConfirmForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  ClientHeight = 81
  ClientWidth = 406
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ConText: TLabel
    Left = 86
    Top = 10
    Width = 312
    Height = 13
    AutoSize = False
  end
  object TimeoutText: TLabel
    Left = 86
    Top = 26
    Width = 312
    Height = 13
    AutoSize = False
  end
  object btnYes: TButton
    Left = 216
    Top = 46
    Width = 78
    Height = 25
    Caption = 'Yes'
    Default = True
    ModalResult = 6
    TabOrder = 0
    OnClick = btnYesClick
  end
  object btnNo: TButton
    Left = 308
    Top = 46
    Width = 78
    Height = 25
    Cancel = True
    Caption = 'No'
    TabOrder = 1
    OnClick = btnNoClick
  end
  object IconImage: TImage32
    Left = 8
    Top = 8
    Width = 64
    Height = 64
    Bitmap.DrawMode = dmTransparent
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 2
  end
  object TimeoutTimer: TTimer
    Tag = 20
    Enabled = False
    OnTimer = TimeoutTimerTimer
    Left = 88
    Top = 48
  end
end
