object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Edit'
  ClientHeight = 222
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
    Height = 222
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object pnlDisplay: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 47
      Width = 425
      Height = 19
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
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
      Top = 186
      Width = 425
      Height = 22
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object Label2: TLabel
        Left = 0
        Top = 4
        Width = 34
        Height = 13
        Caption = 'Action:'
      end
      object edAction: TEdit
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
      Top = 76
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
      TabOrder = 2
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
      Top = 107
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
      TabOrder = 3
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
      Top = 139
      Width = 430
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Action Options'
      Description = 'Define what action to take when clicked'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
    end
    object SharpECenterHeader1: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 0
      Width = 430
      Height = 37
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Display Options'
      Description = 'Define text and icon options'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
    end
  end
end
