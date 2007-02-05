object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Clock Module Settings'
  ClientHeight = 179
  ClientWidth = 244
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lb_textsize: TLabel
    Left = 8
    Top = 8
    Width = 48
    Height = 13
    Caption = 'Text Size:'
  end
  object Label1: TLabel
    Left = 8
    Top = 56
    Width = 69
    Height = 13
    Caption = 'Format String:'
  end
  object Label2: TLabel
    Left = 8
    Top = 104
    Width = 234
    Height = 13
    Caption = 'Bottom Label (leave empty to only use one label)'
  end
  object Button1: TButton
    Left = 88
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 168
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object edit_format: TEdit
    Left = 8
    Top = 72
    Width = 201
    Height = 21
    TabOrder = 2
    Text = 'hh:mm:ss'
  end
  object Button3: TButton
    Left = 216
    Top = 72
    Width = 25
    Height = 22
    Caption = '...'
    TabOrder = 3
    OnClick = Button3Click
  end
  object cb_large: TRadioButton
    Left = 8
    Top = 24
    Width = 49
    Height = 17
    Caption = 'Large'
    TabOrder = 4
  end
  object cb_medium: TRadioButton
    Left = 72
    Top = 24
    Width = 65
    Height = 17
    Caption = 'Medium'
    Checked = True
    TabOrder = 5
    TabStop = True
  end
  object cb_small: TRadioButton
    Left = 144
    Top = 24
    Width = 49
    Height = 17
    Caption = 'Small'
    TabOrder = 6
  end
  object edit_bottom: TEdit
    Left = 8
    Top = 120
    Width = 201
    Height = 21
    TabOrder = 7
    Text = 'DD.MM.YYYY'
    OnChange = edit_bottomChange
  end
  object Button4: TButton
    Left = 213
    Top = 120
    Width = 25
    Height = 22
    Caption = '...'
    TabOrder = 8
    OnClick = Button4Click
  end
  object OpenFile: TOpenDialog
    FileName = '*.*'
    Filter = 'All Files|*.*|Applications (*.exe)|*.exe'
    Options = [ofHideReadOnly, ofEnableSizing, ofForceShowHidden]
    Title = 'Select Target File'
    Left = 216
    Top = 32
  end
  object XPManifest1: TXPManifest
    Left = 216
    Top = 40
  end
  object PopupMenu1: TPopupMenu
    Left = 192
    Top = 40
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
