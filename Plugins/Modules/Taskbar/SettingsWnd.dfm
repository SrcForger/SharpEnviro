object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Task Module Settings'
  ClientHeight = 198
  ClientWidth = 630
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 49
    Height = 13
    Caption = 'Task Style'
  end
  object Button1: TButton
    Left = 472
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 552
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object cb_tsfull: TRadioButton
    Left = 8
    Top = 24
    Width = 113
    Height = 17
    Caption = 'Full'
    TabOrder = 2
  end
  object cb_tscompact: TRadioButton
    Left = 8
    Top = 40
    Width = 113
    Height = 17
    Caption = 'Compact'
    TabOrder = 3
  end
  object cb_tsminimal: TRadioButton
    Left = 8
    Top = 56
    Width = 113
    Height = 17
    Caption = 'Minimal'
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 96
    Top = 0
    Width = 145
    Height = 89
    BevelOuter = bvNone
    TabOrder = 5
    object cb_sort: TCheckBox
      Left = 8
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Sort Tasks'
      TabOrder = 0
      OnClick = cb_sortClick
    end
    object rb_caption: TRadioButton
      Left = 16
      Top = 24
      Width = 113
      Height = 17
      Caption = 'Caption'
      TabOrder = 1
    end
    object rb_wndclassname: TRadioButton
      Left = 16
      Top = 40
      Width = 113
      Height = 17
      Caption = 'Window Class Name'
      TabOrder = 2
    end
    object rb_timeadded: TRadioButton
      Left = 16
      Top = 56
      Width = 113
      Height = 17
      Caption = 'Time added'
      TabOrder = 3
    end
    object rb_icon: TRadioButton
      Left = 16
      Top = 72
      Width = 113
      Height = 17
      Caption = 'Icon'
      Checked = True
      TabOrder = 4
      TabStop = True
    end
  end
  object Button3: TButton
    Left = 544
    Top = 32
    Width = 81
    Height = 25
    Caption = 'Setup Filters'
    TabOrder = 6
    OnClick = Button3Click
  end
  object list_include: TCheckListBox
    Left = 288
    Top = 24
    Width = 121
    Height = 121
    OnClickCheck = list_includeClickCheck
    ItemHeight = 13
    TabOrder = 7
  end
  object rb_ifilter: TCheckBox
    Left = 288
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Include Filters'
    TabOrder = 8
    OnClick = rb_ifilterClick
  end
  object list_exclude: TCheckListBox
    Left = 416
    Top = 24
    Width = 121
    Height = 121
    OnClickCheck = list_excludeClickCheck
    ItemHeight = 13
    TabOrder = 9
  end
  object rb_efilter: TCheckBox
    Left = 416
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Exclude Filters'
    TabOrder = 10
    OnClick = rb_efilterClick
  end
  object XPManifest1: TXPManifest
    Left = 16
    Top = 88
  end
end
