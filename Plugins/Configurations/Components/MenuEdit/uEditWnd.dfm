object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmEdit'
  ClientHeight = 307
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object plMenuItems: TJvPageList
    Left = 0
    Top = 77
    Width = 500
    Height = 230
    ActivePage = pagLink
    PropagateEnable = False
    Align = alClient
    object pagLink: TJvStandardPage
      Left = 0
      Top = 0
      Width = 500
      Height = 230
      DesignSize = (
        500
        230)
      object edLinkName: TLabeledEdit
        Left = 60
        Top = 0
        Width = 153
        Height = 21
        EditLabel.Width = 41
        EditLabel.Height = 13
        EditLabel.Caption = 'Caption:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 0
        OnChange = edtChange
      end
      object edLinkIcon: TLabeledEdit
        Left = 268
        Top = 0
        Width = 169
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 25
        EditLabel.Height = 13
        EditLabel.Caption = 'Icon:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 1
        OnChange = edtChange
      end
      object btnLinkIconBrowse: TButton
        Left = 443
        Top = 0
        Width = 54
        Height = 23
        Anchors = [akTop, akRight]
        Caption = 'Browse'
        TabOrder = 2
        OnClick = btnLinkIconBrowseClick
      end
      object edLinkTarget: TLabeledEdit
        Left = 60
        Top = 29
        Width = 361
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 36
        EditLabel.Height = 13
        EditLabel.Caption = 'Target:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 3
        OnChange = edtChange
      end
      object btnLinkTargetBrowse: TButton
        Left = 443
        Top = 29
        Width = 54
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Browse'
        TabOrder = 4
        OnClick = btnLinkTargetBrowseClick
      end
    end
    object pagDriveList: TJvStandardPage
      Left = 0
      Top = 0
      Width = 500
      Height = 230
      object chkDriveNames: TJvXPCheckbox
        Left = 10
        Top = 0
        Width = 145
        Height = 17
        Caption = 'Show Drive Names'
        TabOrder = 0
        OnClick = ChkClick
      end
    end
    object pagLabel: TJvStandardPage
      Left = 0
      Top = 0
      Width = 500
      Height = 230
      Caption = 'pagLabel'
      DesignSize = (
        500
        230)
      object edLabelCaption: TLabeledEdit
        Left = 60
        Top = 0
        Width = 413
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 41
        EditLabel.Height = 13
        EditLabel.Caption = 'Caption:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 0
        OnChange = edtChange
      end
    end
    object pagSubMenu: TJvStandardPage
      Left = 0
      Top = 0
      Width = 500
      Height = 230
      Caption = 'pagSubMenu'
      DesignSize = (
        500
        230)
      object edSubmenuCaption: TLabeledEdit
        Left = 60
        Top = 0
        Width = 153
        Height = 21
        EditLabel.Width = 41
        EditLabel.Height = 13
        EditLabel.Caption = 'Caption:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 0
        OnChange = edtChange
      end
      object edSubmenuIcon: TLabeledEdit
        Left = 268
        Top = 0
        Width = 169
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 25
        EditLabel.Height = 13
        EditLabel.Caption = 'Icon:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 1
        OnChange = edtChange
      end
      object btnSubmenuIconBrowse: TButton
        Left = 443
        Top = 0
        Width = 54
        Height = 23
        Anchors = [akTop, akRight]
        Caption = 'Browse'
        TabOrder = 2
        OnClick = btnSubmenuIconBrowseClick
      end
      object edSubmenuTarget: TLabeledEdit
        Left = 60
        Top = 29
        Width = 357
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 36
        EditLabel.Height = 13
        EditLabel.Caption = 'Target:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 3
        OnChange = edtChange
      end
      object btnSubmenuTargetBrowse: TButton
        Left = 443
        Top = 29
        Width = 54
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Browse'
        TabOrder = 4
        OnClick = btnSubmenuTargetBrowseClick
      end
      object chkOverride: TJvXPCheckbox
        Left = 8
        Top = 65
        Width = 273
        Height = 17
        Caption = 'Override menu options'
        TabOrder = 5
        OnClick = ChkClick
      end
      object chkEnableIcons: TJvXPCheckbox
        Left = 8
        Top = 88
        Width = 101
        Height = 17
        Caption = 'Enable Icons'
        TabOrder = 6
        OnClick = ChkClick
      end
      object chkEnableGeneric: TJvXPCheckbox
        Left = 115
        Top = 88
        Width = 139
        Height = 17
        Caption = 'Enable generic Icons'
        TabOrder = 7
        OnClick = ChkClick
      end
      object chkDisplayExtensions: TJvXPCheckbox
        Left = 260
        Top = 88
        Width = 161
        Height = 17
        Caption = 'Display file extensions'
        TabOrder = 8
        OnClick = ChkClick
      end
    end
    object pagDynamicDir: TJvStandardPage
      Left = 0
      Top = 0
      Width = 500
      Height = 230
      Caption = 'pagDynamicDir'
      DesignSize = (
        500
        230)
      object Label1: TLabel
        Left = 10
        Top = 34
        Width = 54
        Height = 13
        Caption = 'Max Items:'
      end
      object Label2: TLabel
        Left = 186
        Top = 34
        Width = 24
        Height = 13
        Caption = 'Sort:'
      end
      object edDynamicDirTarget: TLabeledEdit
        Left = 52
        Top = 0
        Width = 369
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 36
        EditLabel.Height = 13
        EditLabel.Caption = 'Target:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 0
        OnChange = edtChange
      end
      object btnDynamicDirBrowse: TButton
        Left = 443
        Top = 0
        Width = 54
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Browse'
        TabOrder = 1
        OnClick = btnDynamicDirBrowseClick
      end
      object sgbDynamicDirMaxItems: TSharpeGaugeBox
        Left = 71
        Top = 29
        Width = 101
        Height = 22
        ParentBackground = False
        Min = -1
        Max = 1000
        Value = 0
        Description = 'Set the max number of items to display (-1 Unlimited)'
        PopPosition = ppBottom
        PercentDisplay = False
        OnChangeValue = sgbDynamicDirMaxItemsChangeValue
        BackgroundColor = clWindow
      end
      object cbDynamicDirSort: TComboBox
        Left = 217
        Top = 29
        Width = 105
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        OnChange = edtChange
        Items.Strings = (
          'Directory'
          'Creation Date'
          'Modified Date')
      end
      object edDynamicDirFilter: TLabeledEdit
        Left = 368
        Top = 28
        Width = 129
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 28
        EditLabel.Height = 13
        EditLabel.Caption = 'Filter:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 4
        OnChange = edtChange
      end
      object chkRecursive: TJvXPCheckbox
        Left = 10
        Top = 61
        Width = 142
        Height = 17
        Caption = 'Include Subdirectories'
        TabOrder = 5
      end
      object chkDescending: TJvXPCheckbox
        Left = 158
        Top = 61
        Width = 155
        Height = 17
        Caption = 'Sort Descending'
        TabOrder = 6
      end
    end
    object pagBlank: TJvStandardPage
      Left = 0
      Top = 0
      Width = 500
      Height = 230
      Caption = 'pagBlank'
      object Label4: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 0
        Width = 488
        Height = 13
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'There are no configuration options'
        Enabled = False
        ExplicitWidth = 166
      end
    end
    object pagMru: TJvStandardPage
      Left = 0
      Top = 0
      Width = 500
      Height = 230
      Caption = 'pagMru'
      object Label5: TLabel
        Left = 10
        Top = 34
        Width = 54
        Height = 13
        Caption = 'Max Items:'
      end
      object sgbMruListCount: TSharpeGaugeBox
        Left = 71
        Top = 29
        Width = 101
        Height = 22
        ParentBackground = False
        Min = 1
        Max = 25
        Value = 10
        Description = 'Set the max number of items to display (-1 Unlimited)'
        PopPosition = ppBottom
        PercentDisplay = False
        OnChangeValue = sgbDynamicDirMaxItemsChangeValue
        BackgroundColor = clWindow
      end
      object rbMruListRecentItems: TJvXPCheckbox
        Left = 8
        Top = 0
        Width = 113
        Height = 17
        Caption = 'Recent Items'
        TabOrder = 0
        Checked = True
        State = cbChecked
        OnClick = rbMruListMostUsedItemsClick
      end
      object rbMruListMostUsedItems: TJvXPCheckbox
        Left = 127
        Top = 0
        Width = 113
        Height = 17
        Caption = 'Most Used Items'
        TabOrder = 1
        TabStop = False
        OnClick = rbMruListMostUsedItemsClick
      end
    end
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 77
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    DesignSize = (
      500
      77)
    object lblDescription: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 40
      Width = 488
      Height = 33
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      AutoSize = False
      Caption = 'lblDescription'
      EllipsisPosition = epEndEllipsis
      WordWrap = True
    end
    object Label3: TLabel
      Left = 8
      Top = 12
      Width = 55
      Height = 13
      Caption = 'Menu Item:'
      Transparent = True
    end
    object JvLabel1: TLabel
      Left = 324
      Top = 12
      Width = 46
      Height = 13
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Position:'
      Transparent = True
    end
    object cbMenuItems: TComboBox
      Left = 80
      Top = 8
      Width = 225
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      Sorted = True
      TabOrder = 0
      OnChange = cbMenuItemsSelect
    end
    object cbItemPosition: TComboBox
      Left = 380
      Top = 8
      Width = 117
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'Insert Above'
      OnChange = cbItemPositionChange
      Items.Strings = (
        'Insert Above'
        'Insert Below'
        'Insert Top'
        'Insert Bottom')
    end
  end
  object tmr: TTimer
    Enabled = False
    Interval = 300
    Left = 464
    Top = 12
  end
end
