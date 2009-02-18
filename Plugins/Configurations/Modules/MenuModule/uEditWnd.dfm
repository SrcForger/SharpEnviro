object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Edit'
  ClientHeight = 407
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
    Height = 407
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object pnlMenu: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 283
      Width = 410
      Height = 21
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object cbMenu: TComboBox
        Left = 0
        Top = 0
        Width = 250
        Height = 21
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Style = csDropDownList
        Constraints.MaxWidth = 300
        ItemHeight = 13
        TabOrder = 0
        OnChange = SettingsChange
      end
    end
    object pnlDisplayOptions: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 123
      Width = 410
      Height = 21
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Color = clWindow
      ParentBackground = False
      TabOrder = 1
      object editCaption: TEdit
        Left = 0
        Top = 0
        Width = 252
        Height = 21
        TabOrder = 0
        OnChange = SettingsChange
      end
    end
    object SharpECenterHeader1: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 0
      Width = 410
      Height = 37
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Visibility'
      Description = 'Define icon and text visiblity'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      Color = clWindow
    end
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 47
      Width = 410
      Height = 19
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 3
      object chkDisplayIcon: TCheckBox
        Left = 0
        Top = 0
        Width = 94
        Height = 19
        Align = alLeft
        Caption = 'Display Icon'
        TabOrder = 0
        OnClick = SettingsChange
      end
      object chkDisplayCaption: TCheckBox
        Left = 94
        Top = 0
        Width = 105
        Height = 19
        Align = alLeft
        Caption = 'Display Caption'
        TabOrder = 1
        OnClick = SettingsChange
      end
    end
    object schDisplayOptions: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 76
      Width = 410
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Text'
      Description = 'Define the display text for the menu button'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      Color = clWindow
    end
    object SharpECenterHeader2: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 154
      Width = 410
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Icon'
      Description = 'Define the icon to display this the menu button'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      Color = clWindow
    end
    object pnlIcon: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 201
      Width = 410
      Height = 25
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 6
      object btnIconBrowse: TButton
        Left = 258
        Top = 0
        Width = 37
        Height = 22
        Caption = '...'
        TabOrder = 0
        OnClick = btnBrowseClick
      end
      object editIcon: TEdit
        Left = 0
        Top = 0
        Width = 252
        Height = 25
        Align = alLeft
        TabOrder = 1
        OnChange = SettingsChange
        ExplicitHeight = 21
      end
    end
    object schMenu: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 236
      Width = 410
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Menu'
      Description = 'Select which menu is displayed when the button is clicked.'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      Color = clWindow
    end
  end
end
