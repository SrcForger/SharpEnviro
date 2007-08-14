object EditFilterForm: TEditFilterForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Edit Filter'
  ClientHeight = 433
  ClientWidth = 306
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 58
    Height = 13
    Caption = 'Filter Name:'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 43
    Height = 13
    Caption = 'Filter by:'
  end
  object rb_showstate: TRadioButton
    Left = 8
    Top = 56
    Width = 145
    Height = 17
    Caption = 'Window Show Command'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = rb_showstateClick
  end
  object edit_name: TEdit
    Left = 72
    Top = 8
    Width = 225
    Height = 21
    TabOrder = 1
    Text = 'My Task Filter'
  end
  object clb_showstates: TCheckListBox
    Left = 24
    Top = 72
    Width = 273
    Height = 169
    ItemHeight = 13
    Items.Strings = (
      'SW_HIDE'
      'SW_SHOWNORMAL, SW_NORMAL'
      'SW_SHOWMINIMIZED'
      'SW_SHOWMAXIMIZED, SW_MAXIMIZE'
      'SW_SHOWNOACTIVATE'
      'SW_SHOW'
      'SW_MINIMIZE'
      'SW_SHOWMINNOACTIVE'
      'SW_SHOWNA'
      'SW_RESTORE'
      'SW_SHOWDEFAULT, '
      'SW_FORCEMINIMIZE, SW_MAX')
    TabOrder = 2
  end
  object rb_classname: TRadioButton
    Left = 8
    Top = 256
    Width = 145
    Height = 17
    Caption = 'Window Class Name'
    TabOrder = 3
    OnClick = rb_classnameClick
  end
  object edit_classname: TEdit
    Left = 24
    Top = 272
    Width = 225
    Height = 21
    TabOrder = 4
  end
  object btn_find1: TButton
    Left = 256
    Top = 272
    Width = 41
    Height = 22
    Caption = 'Find'
    TabOrder = 5
    OnClick = btn_find1Click
  end
  object rb_filename: TRadioButton
    Left = 8
    Top = 304
    Width = 145
    Height = 17
    Caption = 'Filename'
    TabOrder = 6
    OnClick = rb_classnameClick
  end
  object edit_filename: TEdit
    Left = 24
    Top = 320
    Width = 225
    Height = 21
    TabOrder = 7
  end
  object btn_find2: TButton
    Tag = 1
    Left = 256
    Top = 320
    Width = 41
    Height = 22
    Caption = 'Find'
    TabOrder = 8
    OnClick = btn_find1Click
  end
  object btn_cancel: TButton
    Left = 223
    Top = 400
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 9
    OnClick = btn_cancelClick
  end
  object btn_ok: TButton
    Left = 143
    Top = 400
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 10
    OnClick = btn_okClick
  end
  object btn_examplefilters: TButton
    Left = 200
    Top = 40
    Width = 97
    Height = 22
    Caption = 'Example Filters ...'
    TabOrder = 11
    OnClick = btn_examplefiltersClick
  end
  object rb_monvwm: TRadioButton
    Left = 8
    Top = 352
    Width = 145
    Height = 17
    Caption = 'Current Monitor/VWM'
    TabOrder = 12
    OnClick = rb_classnameClick
  end
  object rb_notmonvwm: TRadioButton
    Left = 8
    Top = 376
    Width = 177
    Height = 17
    Caption = 'Not on Current Monitor/VWM'
    TabOrder = 13
    OnClick = rb_classnameClick
  end
  object wndclasspopup: TPopupMenu
    Images = wndcimages
    Left = 240
    Top = 240
  end
  object wndcimages: TImageList
    BkColor = clMenu
    Left = 216
    Top = 336
  end
  object examplefilterpopup: TPopupMenu
    Left = 120
    Top = 32
    object VisibleTasksonly1: TMenuItem
      Caption = 'Visible Tasks'
      OnClick = VisibleTasksonly1Click
    end
    object MinimizedTasjs1: TMenuItem
      Caption = 'Minimized Tasks'
      OnClick = MinimizedTasjs1Click
    end
    object ExplorerWindows1: TMenuItem
      Caption = 'Explorer Windows'
      OnClick = ExplorerWindows1Click
    end
  end
end
