object frmClock: TfrmClock
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmClock'
  ClientHeight = 288
  ClientWidth = 441
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
  object SharpECenterHeader1: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 0
    Width = 431
    Height = 37
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Clock Size'
    Description = 'Define the size of the clock text'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object SharpECenterHeader2: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 83
    Width = 431
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Clock Format'
    Description = 'Define the format used for the displayed clock text'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object pnlTop: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 130
    Width = 426
    Height = 22
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 22
      Height = 22
      Align = alLeft
      Caption = 'Top:'
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object btnTop: TButton
      Left = 356
      Top = 0
      Width = 37
      Height = 22
      Caption = '...'
      TabOrder = 1
      OnClick = btnTopClick
    end
    object editTop: TEdit
      Left = 64
      Top = 0
      Width = 286
      Height = 21
      TabOrder = 0
      OnChange = UpdateSettingsEvent
    end
  end
  object pnlBottom: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 162
    Width = 426
    Height = 22
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 2
    object Label2: TLabel
      Left = 0
      Top = 0
      Width = 38
      Height = 22
      Align = alLeft
      Caption = 'Bottom:'
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object btnBottom: TButton
      Left = 356
      Top = 0
      Width = 37
      Height = 22
      Caption = '...'
      TabOrder = 1
      OnClick = btnBottomClick
    end
    object editBottom: TEdit
      Left = 64
      Top = 0
      Width = 286
      Height = 21
      TabOrder = 0
      OnChange = UpdateSettingsEvent
    end
  end
  object pnlSize: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 47
    Width = 426
    Height = 21
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object cboSize: TComboBox
      Left = 0
      Top = 0
      Width = 250
      Height = 21
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 5
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = 'Small'
      OnChange = UpdateSettingsEvent
      Items.Strings = (
        'Small'
        'Medium'
        'Large'
        'Automatic (two line display)')
    end
  end
  object SharpECenterHeader3: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 199
    Width = 431
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Tooltip Format'
    Description = 
      'Define the format used for the tooltip when you mouse over the c' +
      'lock module.'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object pnlTooltip: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 246
    Width = 431
    Height = 23
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 3
    ExplicitTop = 241
    object editTooltip: TEdit
      Left = 0
      Top = 2
      Width = 350
      Height = 21
      TabOrder = 0
      OnChange = UpdateSettingsEvent
    end
    object btnTooltip: TButton
      Left = 356
      Top = 0
      Width = 37
      Height = 22
      Caption = '...'
      TabOrder = 1
      OnClick = btnTooltipClick
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 408
    Top = 548
    object TimeColon: TMenuItem
      Caption = 'HH:MM:SS'
      Hint = 'HH:MM:SS'
      OnClick = MenuItemClick
    end
    object TimeColonAMPM: TMenuItem
      Caption = 'HH:MM:SS AM/PM'
      Hint = 'HH:MM:SS AM/PM'
      OnClick = MenuItemClick
    end
    object TimeColonDashDatePeriod: TMenuItem
      Caption = 'HH:MM:SS - DD.MM.YYYY'
      Hint = 'HH:MM:SS - DD.MM.YYYY'
      OnClick = MenuItemClick
    end
    object TimeColonAMPMDashDatePeriod: TMenuItem
      Caption = 'HH:MM:SS AM/PM - DD.MM.YYYY'
      Hint = 'HH:MM:SS AM/PM - DD.MM.YYYY'
      OnClick = MenuItemClick
    end
    object DatePeriod: TMenuItem
      Caption = 'DD.MM.YYYY'
      Hint = 'DD.MM.YYYY'
      OnClick = MenuItemClick
    end
    object DatePeriodTimeColon: TMenuItem
      Caption = 'DD.MM.YYYY HH:MM:SS'
      Hint = 'DD.MM.YYYY HH:MM:SS'
      OnClick = MenuItemClick
    end
    object DatePeriodTimeColonAMPM: TMenuItem
      Caption = 'DD.MM.YYYY HH:MM:SS AM/PM'
      Hint = 'DD.MM.YYYY HH:MM:SS AM/PM'
      OnClick = MenuItemClick
    end
    object DateSlash: TMenuItem
      Caption = 'MM/DD/YYYY'
      Hint = 'MM/DD/YYYY'
      OnClick = MenuItemClick
    end
    object DateSlashTimeColon: TMenuItem
      Caption = 'MM/DD/YYYY HH:MM:SS'
      Hint = 'MM/DD/YYYY HH:MM:SS'
      OnClick = MenuItemClick
    end
    object DateSlashTimeColonAMPM: TMenuItem
      Caption = 'MM/DD/YYYY HH:MM:SS AM/PM'
      Hint = 'MM/DD/YYYY HH:MM:SS AM/PM'
      OnClick = MenuItemClick
    end
    object LongDateSpaceComma: TMenuItem
      Caption = 'DDDD - MMMM D, YYYY'
      Hint = 'DDDD - MMMM D, YYYY'
      OnClick = MenuItemClick
    end
    object LongDatePeriod: TMenuItem
      Caption = 'DDDD - DD.MM.YYYY'
      Hint = 'DDDD - DD.MM.YYYY'
      OnClick = MenuItemClick
    end
  end
end
