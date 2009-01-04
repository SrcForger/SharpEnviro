object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Edit'
  ClientHeight = 279
  ClientWidth = 420
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
    Width = 420
    Height = 279
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    ExplicitWidth = 412
    object pnlDisplaySize: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 133
      Width = 414
      Height = 71
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      ExplicitTop = 132
      object gbSize: TSharpeGaugeBox
        AlignWithMargins = True
        Left = 20
        Top = 44
        Width = 300
        Height = 21
        Margins.Left = 20
        Margins.Right = 10
        Color = clWindow
        Constraints.MaxWidth = 477
        ParentBackground = False
        Min = 16
        Max = 200
        Value = 100
        Description = 'Adjust to set the size of the button'
        PopPosition = ppBottom
        PercentDisplay = False
        OnChangeValue = gbSizeChangeValue
        BackgroundColor = clWindow
      end
      object schDisplaySize: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 408
        Height = 35
        Title = 'Display Size'
        Description = 'Define the size of the button.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitWidth = 501
      end
    end
    object pnlMenu: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 210
      Width = 414
      Height = 68
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      ExplicitTop = 201
      ExplicitWidth = 507
      object cbMenu: TComboBox
        AlignWithMargins = True
        Left = 20
        Top = 44
        Width = 300
        Height = 21
        Margins.Left = 20
        Margins.Right = 10
        Align = alTop
        Style = csDropDownList
        Constraints.MaxWidth = 300
        ItemHeight = 13
        TabOrder = 0
        OnChange = SettingsChange
      end
      object schMenu: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 408
        Height = 35
        Title = 'Menu'
        Description = 'Select which menu is displayed when the button is clicked.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitWidth = 501
      end
    end
    object pnlDisplayOptions: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 414
      Height = 124
      Align = alTop
      BevelOuter = bvNone
      Color = clWindow
      ParentBackground = False
      TabOrder = 2
      ExplicitWidth = 406
      object schDisplayOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 408
        Height = 35
        Title = 'Display Options'
        Description = 'Define icon and text options.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitWidth = 501
      end
      object Panel2: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 44
        Width = 408
        Height = 19
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        ExplicitWidth = 501
        object chkDisplayIcon: TCheckBox
          Left = 57
          Top = 0
          Width = 94
          Height = 17
          Caption = 'Display Icon'
          TabOrder = 0
          OnClick = SettingsChange
        end
        object chkDisplayCaption: TCheckBox
          Left = 157
          Top = 0
          Width = 105
          Height = 17
          Caption = 'Display Caption'
          TabOrder = 1
          OnClick = SettingsChange
        end
      end
      object pnlCaption: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 69
        Width = 408
        Height = 21
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        ExplicitWidth = 501
        object editCaption: TLabeledEdit
          Left = 56
          Top = 0
          Width = 261
          Height = 21
          EditLabel.AlignWithMargins = True
          EditLabel.Width = 41
          EditLabel.Height = 13
          EditLabel.Margins.Left = 20
          EditLabel.Caption = 'Caption:'
          LabelPosition = lpLeft
          TabOrder = 0
          OnChange = SettingsChange
        end
      end
      object pnlIcon: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 96
        Width = 408
        Height = 23
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        ExplicitWidth = 501
        object btnIconBrowse: TButton
          Left = 323
          Top = 0
          Width = 37
          Height = 22
          Caption = '...'
          TabOrder = 0
          OnClick = btnBrowseClick
        end
        object editIcon: TLabeledEdit
          Left = 56
          Top = 2
          Width = 261
          Height = 21
          EditLabel.AlignWithMargins = True
          EditLabel.Width = 25
          EditLabel.Height = 13
          EditLabel.Margins.Left = 20
          EditLabel.Caption = 'Icon:'
          LabelPosition = lpLeft
          TabOrder = 1
          OnChange = SettingsChange
        end
      end
    end
  end
end
