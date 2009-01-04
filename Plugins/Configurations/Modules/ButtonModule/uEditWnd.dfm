object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Edit'
  ClientHeight = 280
  ClientWidth = 440
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
    Width = 440
    Height = 280
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object pnlSize: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 182
      Width = 430
      Height = 21
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      ExplicitTop = 149
      ExplicitWidth = 509
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
        Suffix = 'px width'
        Description = 'Adjust to set the size of the button'
        PopPosition = ppBottom
        PercentDisplay = False
        OnChangeValue = gbSizeChangeValue
        BackgroundColor = clWindow
      end
    end
    object pnlDisplay: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 45
      Width = 425
      Height = 19
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      ExplicitTop = 10
      ExplicitWidth = 504
      object chkDisplayIcon: TJvXPCheckbox
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 94
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 10
        Caption = 'Display Icon'
        TabOrder = 0
        OnClick = SettingsChange
      end
      object chkDisplayCaption: TJvXPCheckbox
        AlignWithMargins = True
        Left = 100
        Top = 0
        Width = 105
        Height = 17
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Caption = 'Display Caption'
        TabOrder = 1
        OnClick = SettingsChange
      end
    end
    object pnlAction: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 258
      Width = 425
      Height = 22
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      ExplicitTop = 227
      ExplicitWidth = 504
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
      Left = 5
      Top = 74
      Width = 425
      Height = 21
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 3
      ExplicitTop = 39
      ExplicitWidth = 504
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
      Left = 5
      Top = 105
      Width = 425
      Height = 22
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 4
      ExplicitTop = 70
      ExplicitWidth = 504
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
    object SharpECenterHeader2: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 213
      Width = 430
      Height = 35
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 0
      Title = 'Click Action'
      Description = 'Define what action to take when clicked'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      ExplicitTop = 180
      ExplicitWidth = 509
    end
    object SharpECenterHeader3: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 137
      Width = 430
      Height = 35
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 0
      Title = 'Button Size'
      Description = 'Define the width of the button'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      ExplicitTop = 102
      ExplicitWidth = 509
    end
    object SharpECenterHeader1: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 0
      Width = 430
      Height = 35
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Title = 'Display'
      Description = 'Define text and icon options'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      ExplicitWidth = 509
    end
  end
end