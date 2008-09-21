object frmClock: TfrmClock
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsNone
  Caption = 'frmClock'
  ClientHeight = 184
  ClientWidth = 447
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
    Width = 437
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
    Top = 73
    Width = 437
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
    ExplicitTop = 140
  end
  object pnlTop: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 120
    Width = 432
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
    ExplicitTop = 187
    object lblTop: TLabel
      Left = 0
      Top = 4
      Width = 62
      Height = 13
      Caption = 'Top/Primary:'
    end
    object edTop: TEdit
      AlignWithMargins = True
      Left = 76
      Top = 0
      Width = 276
      Height = 21
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 12
      Margins.Bottom = 0
      Constraints.MaxWidth = 300
      TabOrder = 0
      Text = 'HH:MM:SS'
      OnChange = UpdateSettingsEvent
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
  end
  object pnlBottom: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 152
    Width = 432
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
    TabOrder = 3
    ExplicitTop = 219
    object lblBottom: TLabel
      Left = 0
      Top = 4
      Width = 38
      Height = 13
      Caption = 'Bottom:'
    end
    object edBottom: TEdit
      AlignWithMargins = True
      Left = 76
      Top = 0
      Width = 276
      Height = 21
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 12
      Margins.Bottom = 0
      Constraints.MaxWidth = 300
      TabOrder = 0
      Text = 'DD.MM.YYYY'
      OnChange = UpdateSettingsEvent
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
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 47
    Width = 432
    Height = 21
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 4
    object cboSize: TComboBox
      Left = 0
      Top = 0
      Width = 250
      Height = 21
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 5
      ItemHeight = 13
      TabOrder = 0
      Text = 'Large'
      OnChange = UpdateSettingsEvent
      Items.Strings = (
        'Small'
        'Medium'
        'Large'
        'Automatic (two line display)')
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 408
    Top = 548
    object N213046HHMMSS3: TMenuItem
      Caption = '21:30:46 (HH:MM:SS)'
      Hint = 'HH:MM:SS'
      OnClick = N213046HHMMSS3Click
    end
    object N213046HHMMSS1: TMenuItem
      Caption = '09:30:46 pm (HH:MM:SS AM/PM)'
      Hint = 'HH:MM:SS AM/PM'
      OnClick = N213046HHMMSS3Click
    end
    object N213046HHMMSS2: TMenuItem
      Caption = '21:30:46 - 19.06.2006 (HH:MM:SS - DD.MM.YYYY)'
      Hint = 'HH:MM:SS - DD.MM.YYYY'
      OnClick = N213046HHMMSS3Click
    end
    object N21304619062006HHMMSSDDMMYYYY1: TMenuItem
      Caption = '09:30:46 pm - 19.06.2006 (HH:MM:SS AM/PM - DD.MM.YYYY)'
      Hint = 'HH:MM:SS AM/PM - DD.MM.YYYY'
      OnClick = N213046HHMMSS3Click
    end
  end
end
