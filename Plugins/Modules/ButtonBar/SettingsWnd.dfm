object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'ButtonBar Module Settings'
  ClientHeight = 376
  ClientWidth = 275
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
  object Label4: TLabel
    Left = 8
    Top = 64
    Width = 58
    Height = 13
    Caption = 'Button Size:'
  end
  object lb_barsize: TLabel
    Left = 72
    Top = 64
    Width = 33
    Height = 14
    AutoSize = False
    Caption = '100px'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 8
    Top = 112
    Width = 41
    Height = 13
    Caption = 'Buttons:'
  end
  object Button1: TButton
    Left = 112
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 192
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object tb_size: TGaugeBar
    Left = 8
    Top = 80
    Width = 257
    Height = 13
    Color = clWindow
    Backgnd = bgSolid
    BorderStyle = bsNone
    HandleColor = clBtnFace
    BorderColor = clBtnShadow
    Max = 200
    Min = 20
    ShowArrows = False
    ShowHandleGrip = True
    Style = rbsMac
    Position = 100
    OnChange = tb_sizeChange
  end
  object cb_labels: TCheckBox
    Left = 8
    Top = 16
    Width = 97
    Height = 17
    Caption = 'Show Captions'
    TabOrder = 3
  end
  object cb_icon: TCheckBox
    Left = 8
    Top = 40
    Width = 97
    Height = 17
    Caption = 'Show Icons'
    TabOrder = 4
  end
  object buttons: TListView
    Left = 8
    Top = 128
    Width = 177
    Height = 209
    Columns = <
      item
        AutoSize = True
      end>
    HideSelection = False
    LargeImages = iml
    RowSelect = True
    ShowColumnHeaders = False
    SmallImages = iml
    TabOrder = 5
    ViewStyle = vsReport
  end
  object btn_new: TButton
    Left = 192
    Top = 126
    Width = 73
    Height = 25
    Caption = 'New...'
    TabOrder = 6
    OnClick = btn_newClick
  end
  object btn_edit: TButton
    Left = 192
    Top = 158
    Width = 73
    Height = 25
    Caption = 'Edit...'
    TabOrder = 7
    OnClick = btn_editClick
  end
  object btn_delete: TButton
    Left = 192
    Top = 190
    Width = 73
    Height = 25
    Caption = 'Delete'
    TabOrder = 8
    OnClick = btn_deleteClick
  end
  object btn_up: TButton
    Left = 192
    Top = 262
    Width = 73
    Height = 25
    Caption = 'Move Up'
    TabOrder = 9
    OnClick = btn_upClick
  end
  object btn_down: TButton
    Left = 192
    Top = 294
    Width = 73
    Height = 25
    Caption = 'Move Down'
    TabOrder = 10
    OnClick = btn_downClick
  end
  object iml: TImageList
    BkColor = clWhite
    Height = 32
    Width = 32
    Left = 176
    Top = 40
  end
end
