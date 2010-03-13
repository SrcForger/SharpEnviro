object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Edit'
  ClientHeight = 270
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
    Height = 270
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object pnlDisplay: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 45
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
        OnClick = chkDisplayIconClick
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
      Top = 239
      Width = 425
      Height = 27
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 3
      object chkAllMonitors: TJvXPCheckbox
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 217
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 10
        Caption = 'Include all Monitors'
        TabOrder = 0
        OnClick = SettingsChange
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
      TabOrder = 1
      object Label7: TLabel
        Left = 0
        Top = 4
        Width = 44
        Height = 13
        Caption = 'Caption: '
      end
      object edCaption: TEdit
        AlignWithMargins = True
        Left = 72
        Top = 0
        Width = 280
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
    object pnlIconShow: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 130
      Width = 425
      Height = 22
      Margins.Left = 5
      Margins.Top = 4
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      object Label8: TLabel
        Left = 0
        Top = 4
        Width = 54
        Height = 13
        Caption = 'Show Icon:'
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
      object edIconShow: TEdit
        AlignWithMargins = True
        Left = 72
        Top = 0
        Width = 280
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 0
        Constraints.MaxWidth = 300
        TabOrder = 0
        Text = 'icon.mycomputer'
        OnChange = SettingsChange
      end
    end
    object SharpECenterHeader2: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 194
      Width = 430
      Height = 35
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Additional Options'
      Description = 'Define additional options'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
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
      Margins.Bottom = 10
      Title = 'Display Options'
      Description = 'Define text and icon options'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
    end
    object pnlActionR: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 276
      Width = 425
      Height = 13
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 4
    end
    object pnlIconRestore: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 162
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
      TabOrder = 7
      object Label3: TLabel
        Left = 0
        Top = 4
        Width = 62
        Height = 13
        Caption = 'Restore Icon'
      end
      object btnIconBrowse2: TButton
        Left = 356
        Top = 0
        Width = 37
        Height = 22
        Caption = '...'
        TabOrder = 1
        OnClick = btnIconBrowse2Click
      end
      object edIconRestore: TEdit
        AlignWithMargins = True
        Left = 72
        Top = 0
        Width = 280
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 0
        Constraints.MaxWidth = 300
        TabOrder = 0
        Text = 'icon.folder'
        OnChange = SettingsChange
      end
    end
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 107
      Width = 425
      Height = 19
      Margins.Left = 5
      Margins.Top = 12
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 8
      object chkCustomIcon: TJvXPCheckbox
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 94
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 10
        Caption = 'Custom Icon'
        TabOrder = 0
        OnClick = chkCustomIconClick
      end
    end
  end
end
