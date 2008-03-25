object frmDeskSettings: TfrmDeskSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmDeskSettings'
  ClientHeight = 318
  ClientWidth = 428
  Color = clWindow
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
  object pcOptions: TPageControl
    Left = 0
    Top = 0
    Width = 428
    Height = 317
    ActivePage = tabMenu
    Align = alTop
    Style = tsFlatButtons
    TabOrder = 0
    object tabDesktop: TTabSheet
      Caption = 'tabDesktop'
      ImageIndex = 1
      TabVisible = False
      ExplicitTop = 27
      ExplicitHeight = 221
      object Label5: TLabel
        Tag = 1
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 386
        Height = 32
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Disable this option if you have problems with games which are of' +
          'ten changing the screen resolution.'
        Color = clWindow
        EllipsisPosition = epEndEllipsis
        ParentColor = False
        Transparent = False
        WordWrap = True
        ExplicitWidth = 394
      end
      object Label6: TLabel
        Tag = 1
        AlignWithMargins = True
        Left = 26
        Top = 90
        Width = 386
        Height = 30
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enable this option to allow SharpDesk to rotate the desktop wall' +
          'paper, when the screen is rotated by 90'#176' (this will keep proper ' +
          'wallpaper dimensions)'
        Color = clWindow
        EllipsisPosition = epEndEllipsis
        ParentColor = False
        Transparent = False
        WordWrap = True
        ExplicitTop = 187
        ExplicitWidth = 394
      end
      object Label3: TLabel
        Tag = 1
        AlignWithMargins = True
        Left = 26
        Top = 211
        Width = 386
        Height = 34
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enabling this option will allow SharpDesk to monitor when anothe' +
          'r application changes the wallpaper, and then update automatical' +
          'ly.'
        Color = clWindow
        EllipsisPosition = epEndEllipsis
        ParentColor = False
        Transparent = False
        WordWrap = True
        ExplicitTop = 422
        ExplicitWidth = 394
      end
      object Label2: TLabel
        Tag = 1
        AlignWithMargins = True
        Left = 26
        Top = 149
        Width = 386
        Height = 33
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enable this option to reduce the memory usage of SharpDesk by mo' +
          'ving constantly unused data to the swap file.'
        Color = clWindow
        EllipsisPosition = epEndEllipsis
        ParentColor = False
        Transparent = False
        WordWrap = True
        ExplicitLeft = 30
        ExplicitTop = 137
      end
      object cb_adjustsize: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 404
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Adjust desktop size to resolution changes'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cb_ammClick
        ExplicitWidth = 412
      end
      object cb_autorotate: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 69
        Width = 404
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Auto rotate wallpaper (Advanced)'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = cb_ammClick
        ExplicitLeft = 4
        ExplicitTop = 51
      end
      object cb_amm: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 128
        Width = 404
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Memory management (Advanced)'
        TabOrder = 2
        OnClick = cb_ammClick
        ExplicitTop = 275
        ExplicitWidth = 412
      end
      object cb_wpwatch: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 190
        Width = 404
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Windows wallpaper monitoring (Advanced)'
        TabOrder = 3
        OnClick = cb_ammClick
        ExplicitTop = 506
        ExplicitWidth = 412
      end
    end
    object tabObjects: TTabSheet
      Caption = 'tabObjects'
      TabVisible = False
      ExplicitTop = 27
      ExplicitHeight = 162
      object JvLabel1: TLabel
        Tag = 1
        AlignWithMargins = True
        Left = 26
        Top = 126
        Width = 386
        Height = 21
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enable this option to enable drag and drop functionality within ' +
          'SharpDesk.'
        Color = clWindow
        EllipsisPosition = epEndEllipsis
        ParentColor = False
        Transparent = False
        WordWrap = True
        ExplicitTop = 246
        ExplicitWidth = 394
      end
      object Label1: TLabel
        Tag = 1
        AlignWithMargins = True
        Left = 26
        Top = 176
        Width = 386
        Height = 35
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enable this option to enable hyperlink click functionalty for ob' +
          'jects.  When disabled, all objects will require a double click t' +
          'o launch.'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
        ExplicitTop = 358
        ExplicitWidth = 394
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 420
        Height = 97
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 0
        ExplicitTop = 61
        ExplicitWidth = 428
        object Label4: TLabel
          Tag = 1
          AlignWithMargins = True
          Left = 26
          Top = 29
          Width = 386
          Height = 37
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 
            'Enable this option to enable snap to grid functionality for obje' +
            'cts. Disabled objects can be freely positioned.'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          WordWrap = True
          ExplicitWidth = 394
        end
        object cb_grid: TCheckBox
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 404
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Align objects to grid'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cb_gridClick
        end
        object sgb_gridy: TSharpeGaugeBox
          Left = 26
          Top = 69
          Width = 120
          Height = 21
          ParentBackground = False
          Min = 2
          Max = 128
          Value = 32
          Prefix = 'Height: '
          Suffix = 'px'
          Description = 'Grid Height'
          PopPosition = ppRight
          PercentDisplay = False
          OnChangeValue = sgb_gridyChangeValue
        end
        object sgb_gridx: TSharpeGaugeBox
          Left = 160
          Top = 69
          Width = 120
          Height = 21
          ParentBackground = False
          Min = 2
          Max = 128
          Value = 32
          Prefix = 'Width: '
          Suffix = 'px'
          Description = 'Grid Width'
          PopPosition = ppRight
          PercentDisplay = False
          OnChangeValue = sgb_gridyChangeValue
        end
      end
      object cb_dd: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 105
        Width = 404
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Enable drag && drop'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = cb_ddClick
        ExplicitTop = 225
        ExplicitWidth = 412
      end
      object cb_singleclick: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 155
        Width = 404
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Single click action'
        TabOrder = 2
        OnClick = cb_singleclickClick
        ExplicitLeft = 12
        ExplicitTop = 150
      end
    end
    object tabMenu: TTabSheet
      Caption = 'tbMenu'
      ImageIndex = 2
      TabVisible = False
      ExplicitTop = 27
      ExplicitHeight = 162
      object Label9: TLabel
        Tag = 1
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 386
        Height = 13
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        Caption = 
          'Change which menu will be displayed on right click of the deskto' +
          'p.'
        Color = clWindow
        ParentColor = False
        Transparent = False
        WordWrap = True
        ExplicitTop = 16
      end
      object Label7: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 404
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Right click menu'
        Color = clWindow
        ParentColor = False
        Transparent = False
        WordWrap = True
      end
      object Panel2: TPanel
        Left = 0
        Top = 50
        Width = 420
        Height = 54
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 0
        ExplicitTop = 38
        object Label8: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 36
          Width = 394
          Height = 16
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          AutoSize = False
          Caption = 'Shift + Right Click'
          Color = clWindow
          EllipsisPosition = epEndEllipsis
          ParentColor = False
          Transparent = False
          WordWrap = True
        end
        object Label10: TLabel
          Left = 26
          Top = 7
          Width = 394
          Height = 16
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          AutoSize = False
          Caption = 'Right Click'
          Color = clWindow
          EllipsisPosition = epEndEllipsis
          ParentColor = False
          Transparent = False
          WordWrap = True
        end
        object cbMenuList: TComboBox
          AlignWithMargins = True
          Left = 160
          Top = 4
          Width = 177
          Height = 21
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cbMenuListChange
        end
        object cbMenuShift: TComboBox
          AlignWithMargins = True
          Left = 160
          Top = 33
          Width = 177
          Height = 21
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          OnChange = cbMenuListChange
        end
      end
    end
  end
end
