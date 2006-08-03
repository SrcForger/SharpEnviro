object CreateForm: TCreateForm
  Left = 369
  Top = 236
  BorderStyle = bsToolWindow
  Caption = 'Add Desktop Object'
  ClientHeight = 262
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object edit_filter: TEdit
    Left = 8
    Top = 230
    Width = 233
    Height = 21
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    OnChange = edit_filterChange
    OnKeyPress = edit_filterKeyPress
  end
  object objects: TListView
    Left = 2
    Top = 2
    Width = 423
    Height = 215
    Columns = <
      item
        Caption = 'Name'
        MaxWidth = 128
        MinWidth = 128
        Width = 128
      end
      item
        Caption = 'Description'
        MaxWidth = 225
        MinWidth = 225
        Width = 225
      end
      item
        Caption = 'Version'
        MaxWidth = 52
        MinWidth = 52
        Width = 52
      end>
    ColumnClick = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    HideSelection = False
    IconOptions.Arrangement = iaLeft
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    StateImages = IconList
    TabOrder = 3
    ViewStyle = vsReport
    OnDblClick = objectsDblClick
    OnKeyPress = objectsKeyPress
  end
  object btn_add: TButton
    Left = 254
    Top = 230
    Width = 77
    Height = 22
    Caption = 'Add'
    TabOrder = 1
    OnClick = btn_addClick
  end
  object btn_cancel: TButton
    Left = 342
    Top = 230
    Width = 75
    Height = 22
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btn_cancelClick
  end
  object IconList: TImageList
    BkColor = 16776959
    Height = 32
    Width = 32
    Left = 392
    Top = 160
  end
end
