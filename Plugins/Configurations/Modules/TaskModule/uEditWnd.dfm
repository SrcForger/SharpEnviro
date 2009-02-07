object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  Caption = 'frmEdit'
  ClientHeight = 470
  ClientWidth = 503
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbItems: TSharpEListBoxEx
    AlignWithMargins = True
    Left = 5
    Top = 352
    Width = 493
    Height = 148
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 0
    Columns = <
      item
        Width = 256
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
        ColumnType = ctDefault
        VisibleOnSelectOnly = False
        Images = pilListBox
      end
      item
        Width = 90
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = False
        ColumnType = ctCheck
        VisibleOnSelectOnly = False
      end
      item
        Width = 90
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = False
        ColumnType = ctCheck
        VisibleOnSelectOnly = False
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = clWindow
    Colors.ItemColorSelected = clBtnFace
    Colors.CheckColorSelected = clBtnFace
    Colors.CheckColor = clWindow
    Colors.DisabledColor = clBlack
    DefaultColumn = 0
    OnResize = lbItemsResize
    ItemHeight = 30
    OnClickCheck = lbItemsClickCheck
    OnClickItem = lbItemsClickItem
    OnGetCellCursor = lbItemsGetCellCursor
    OnGetCellText = lbItemsGetCellText
    OnGetCellImageIndex = lbItemsGetCellImageIndex
    AutosizeGrid = True
    Borderstyle = bsNone
    Ctl3d = False
    Align = alTop
  end
  object pnlOptions: TPanel
    Left = 0
    Top = 0
    Width = 503
    Height = 347
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object pnlStyleAndSort: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 47
      Width = 493
      Height = 31
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object lblSort: TLabel
        Left = 205
        Top = 4
        Width = 56
        Height = 13
        Caption = 'Sort Mode: '
      end
      object lblStyle: TLabel
        Left = 0
        Top = 4
        Width = 31
        Height = 13
        Caption = 'Style: '
      end
      object cbStyle: TComboBox
        AlignWithMargins = True
        Left = 36
        Top = 0
        Width = 150
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 0
        Style = csDropDownList
        Constraints.MaxWidth = 200
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Default'
        OnChange = SettingsChange
        Items.Strings = (
          'Default'
          'Compact'
          'Minimal')
      end
      object cbSortMode: TComboBox
        AlignWithMargins = True
        Left = 272
        Top = 0
        Width = 150
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 0
        Style = csDropDownList
        Constraints.MaxWidth = 200
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'None'
        OnChange = SettingsChange
        Items.Strings = (
          'None'
          'Caption'
          'Window Class Name'
          'Time Added'
          'Icon')
      end
    end
    object pnlButtons: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 158
      Width = 488
      Height = 19
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object chkMinimiseBtn: TJvXPCheckbox
        Left = 0
        Top = -1
        Width = 129
        Height = 17
        Caption = 'Minimise Tasks'
        TabOrder = 0
        OnClick = SettingsChange
      end
      object chkRestoreBtn: TJvXPCheckbox
        Left = 143
        Top = -1
        Width = 124
        Height = 17
        Caption = 'Restore Tasks'
        TabOrder = 1
        OnClick = SettingsChange
      end
    end
    object schTaskOptions: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 0
      Width = 493
      Height = 37
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Task Options'
      Description = 'Define the type of task style you wish to use.'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      Color = clWindow
    end
    object schButtons: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 111
      Width = 493
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Buttons'
      Description = 'Define which buttons you want to enable.'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      Color = clWindow
    end
    object schFilters: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 273
      Width = 493
      Height = 37
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Filters'
      Description = 'Define the Filter conditions that apply to this task group.'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      Color = clWindow
    end
    object chkMiddleClose: TJvXPCheckbox
      AlignWithMargins = True
      Left = 5
      Top = 81
      Width = 493
      Height = 17
      Margins.Left = 5
      Margins.Right = 5
      Caption = 'Close tasks on middle click'
      TabOrder = 5
      Checked = True
      State = cbChecked
      Align = alTop
      OnClick = chkFilterTasksClick
    end
    object chkFilterTasks: TJvXPCheckbox
      AlignWithMargins = True
      Left = 5
      Top = 320
      Width = 493
      Height = 17
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Caption = 'Filter Tasks (When enabled only checked tasks will apply)'
      TabOrder = 6
      Align = alTop
      OnClick = chkFilterTasksClick
    end
    object SharpECenterHeader1: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 197
      Width = 493
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Application Bar Tasks'
      Description = 
        'Define if you want to show tasks which are part of any applicati' +
        'on bar module.'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      Color = clWindow
    end
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 244
      Width = 488
      Height = 19
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 8
      object chkAppBar: TJvXPCheckbox
        Left = 0
        Top = -1
        Width = 321
        Height = 17
        Caption = 'Show Application Bar Windows'
        TabOrder = 0
        OnClick = SettingsChange
      end
    end
  end
  object pilListBox: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000025A4944415478DAA5935F4853511CC7BF3FB7B972D9B607
          D34D5D69413D64C5A2A71C0A415041588AF5D2A3045BC988A4DC102124D010B5
          28E88F651A6254B420A81EEAA13063646EA69B632A59E9D2C214EF8CB9DD7B3A
          F72A8BA01E56877BF87239E7F7F9FD7E87EF8F1863F89F4565CE1E4771E9AEC6
          D945A653589204C6B728895C1924C6FF45912B5354E4676BD397A2C1E0E49987
          2D472E53C3BD3131335397966AE6B1E088D4E62C5191AB7BF49F7AF8FAF913AE
          D59412D57685595D796ECA8013ADAFD15EBB87E86C678803F2B05C06533E10E1
          5D7FFF5F83775AADB0B7F6A2C3BD97036E8F30D72133AA5A3F242FDC706EC080
          CF079BCDF647802008B037BF4267FD3EA29A5BC3CC7D380FA464962B20AE80DF
          EFE78062BC1C9EC4CCFC0F08312DB41A35F41912761768E168F1E2CEB90344A7
          DB877805B972D5485A82965BF14DCC212AE9B0C5BC066A8D8A839630BB10435A
          5C40876710DD0D07894E5DF72B8064ECCA5304820144549B50B43E1342428538
          F7847C47BF4A85A1F017789E0EA0E77C1951F595B7CC5D9E8FEAABD3C91E2F1E
          CF4628144278C982926D39985E48702301B10483314383C0F837781EF7E1FE85
          0AA29397BCCC5591BF92FB9725C2E130266923B6171A3013654848CB67069D06
          FD831378F6DC8707CD95448EB6371C6051827F4710862371E80D4668B4E98889
          0CEA3442E47B1C53FE17187FEF4763531DC9B370373BDF5C29C97E17F90CC82A
          CF423C0E4DBA1A39EB8CB06EB5282DCC0B31883301D8B2A63037DA9BF838E23D
          46A94EE3A3FAFD5526534E5356C10E43D0FB64316580BCBAEC9B8F9A0A8B6E4A
          5262F54F48E51A8F8097AC900000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end>
    Left = 460
    Top = 252
    Bitmap = {}
  end
end
