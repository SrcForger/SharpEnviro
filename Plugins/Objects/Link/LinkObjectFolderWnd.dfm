object SelectFolderForm: TSelectFolderForm
  Left = 360
  Top = 162
  BorderStyle = bsSingle
  Caption = 'Select Folder'
  ClientHeight = 374
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object TreeView: TShellTreeView
    Left = 8
    Top = 8
    Width = 329
    Height = 273
    ObjectTypes = [otFolders, otHidden]
    Root = 'rfMyComputer'
    UseShellImages = True
    AutoRefresh = True
    Ctl3D = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    Indent = 19
    ParentColor = False
    ParentCtl3D = False
    ParentFont = False
    ParentShowHint = False
    RightClickSelect = True
    ShowHint = False
    ShowRoot = False
    TabOrder = 0
  end
  object cb_shellfolder: TCheckBox
    Left = 8
    Top = 292
    Width = 97
    Height = 17
    Caption = 'Shell Folder'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = cb_shellfolderClick
  end
  object cb_folder: TComboBox
    Left = 8
    Top = 312
    Width = 257
    Height = 19
    BevelInner = bvNone
    Ctl3D = True
    DropDownCount = 16
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    ItemHeight = 11
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    Text = 'shell:ControlPanelFolder'
    Items.Strings = (
      'shell:ConnectionsFolder'
      'shell:RecycleBinFolder'
      'shell:PrintersFolder'
      'shell:ControlPanelFolder'
      'shell:InternetFolder'
      'shell:DriveFolder'
      'shell:NetworkFolder'
      'shell:Common Administrative Tools'
      'shell:Administrative Tools'
      'shell:SystemX86'
      'shell:My Pictures'
      'shell:My Music'
      'shell:Profile'
      'shell:CommonProgramFiles'
      'shell:ProgramFiles'
      'shell:System'
      'shell:Windows'
      'shell:History'
      'shell:Cookies'
      'shell:Local AppData'
      'shell:AppData'
      'shell:Common Documents'
      'shell:Common Templates'
      'shell:Common AppData'
      'shell:Common Favorites'
      'shell:Common Desktop'
      'shell:Common Menu'
      'shell:Common Programs'
      'shell:Common Startup'
      'shell:Templates'
      'shell:PrintHood'
      'shell:NetHood'
      'shell:Favorites'
      'shell:Personal'
      'shell:SendTo'
      'shell:Recent'
      'shell:Menu'
      'shell:Programs'
      'shell:Startup'
      'shell:Desktop'
      'shell:Fonts')
  end
  object bottompanel: TPanel
    Left = 0
    Top = 346
    Width = 347
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      347
      28)
    object btn_ok: TButton
      Left = 178
      Top = 4
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Ok'
      TabOrder = 0
      OnClick = btn_okClick
    end
    object btn_cancel: TButton
      Left = 266
      Top = 4
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btn_cancelClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 344
    Width = 347
    Height = 2
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 4
  end
  object btn_test: TButton
    Left = 272
    Top = 310
    Width = 65
    Height = 22
    Caption = 'Test'
    TabOrder = 5
    OnClick = btn_testClick
  end
end
