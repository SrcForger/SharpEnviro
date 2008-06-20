object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsNone
  Caption = 'Edit'
  ClientHeight = 271
  ClientWidth = 519
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlOptions: TPanel
    Left = 0
    Top = 0
    Width = 519
    Height = 271
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Label3: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 136
      Width = 55
      Height = 13
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Display size'
    end
    object lblSizeDesc: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 157
      Width = 138
      Height = 13
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Define the size of the button'
      Transparent = False
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 72
      Height = 13
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Display options'
    end
    object Label4: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 207
      Width = 69
      Height = 13
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Click command'
    end
    object lblMenuDesc: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 228
      Width = 256
      Height = 13
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Define what action you want to execute when clicked'
      Transparent = False
    end
    object lblDisplayDesc: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 29
      Width = 135
      Height = 13
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Define icon and text options'
      Transparent = False
    end
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 26
      Top = 178
      Width = 485
      Height = 21
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object Label6: TLabel
        Left = 0
        Top = 4
        Width = 23
        Height = 13
        Caption = 'Size:'
      end
      object gbSize: TSharpeGaugeBox
        AlignWithMargins = True
        Left = 58
        Top = 0
        Width = 294
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 0
        Color = clWindow
        Constraints.MaxWidth = 300
        ParentBackground = False
        Min = 16
        Max = 200
        Value = 100
        Suffix = 'px'
        Description = 'Adjust to set the size of the button'
        PopPosition = ppBottom
        PercentDisplay = False
        OnChangeValue = gbSizeChangeValue
      end
    end
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 26
      Top = 50
      Width = 485
      Height = 19
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object chkDisplayIcon: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 0
        Width = 94
        Height = 17
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Caption = 'Display Icon'
        TabOrder = 0
        OnClick = SettingsChange
      end
      object chkDisplayCaption: TCheckBox
        AlignWithMargins = True
        Left = 100
        Top = 0
        Width = 105
        Height = 17
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Caption = 'Display Caption'
        TabOrder = 1
        OnClick = SettingsChange
      end
    end
    object Panel3: TPanel
      AlignWithMargins = True
      Left = 26
      Top = 249
      Width = 485
      Height = 22
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 2
      object Label2: TLabel
        Left = 0
        Top = 4
        Width = 34
        Height = 13
        Caption = 'Action:'
      end
      object edAction: TEdit
        AlignWithMargins = True
        Left = 52
        Top = 0
        Width = 300
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 0
        Constraints.MaxWidth = 300
        TabOrder = 0
        OnChange = SettingsChange
      end
      object btnAction: TButton
        Left = 356
        Top = 0
        Width = 37
        Height = 22
        Caption = '...'
        TabOrder = 1
        OnClick = btnActionClick
      end
    end
    object pnlCaption: TPanel
      AlignWithMargins = True
      Left = 26
      Top = 77
      Width = 485
      Height = 21
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 3
      object Label7: TLabel
        Left = 0
        Top = 4
        Width = 44
        Height = 13
        Caption = 'Caption: '
      end
      object edCaption: TEdit
        AlignWithMargins = True
        Left = 58
        Top = 0
        Width = 294
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 0
        Constraints.MaxWidth = 300
        TabOrder = 0
        Text = 'Default'
        OnChange = SettingsChange
      end
    end
    object pnlIcon: TPanel
      AlignWithMargins = True
      Left = 26
      Top = 106
      Width = 485
      Height = 22
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 4
      object Label8: TLabel
        Left = 0
        Top = 4
        Width = 25
        Height = 13
        Caption = 'Icon:'
      end
      object btnIconBrowse: TButton
        Left = 356
        Top = 0
        Width = 37
        Height = 22
        Caption = '...'
        TabOrder = 1
        OnClick = btnBrowseClick
      end
      object edIcon: TEdit
        AlignWithMargins = True
        Left = 58
        Top = 0
        Width = 294
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 0
        Constraints.MaxWidth = 300
        TabOrder = 0
        Text = 'Default'
        OnChange = SettingsChange
      end
    end
  end
end
