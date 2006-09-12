object MainForm: TMainForm
  Left = 0
  Top = 0
  Width = 434
  Height = 131
  Caption = 'SharpScript'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 32
    Width = 118
    Height = 13
    Caption = 'Welcome to SharpScript.'
  end
  object Label2: TLabel
    Left = 32
    Top = 56
    Width = 225
    Height = 13
    Caption = 'Use the menu to select what you want to do...'
  end
  object MainMenu1: TMainMenu
    Left = 240
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Script1: TMenuItem
      Caption = 'Script'
      object Execute1: TMenuItem
        Caption = 'Execute...'
      end
      object Create1: TMenuItem
        Caption = 'Create'
        object Generic1: TMenuItem
          Caption = 'Generic'
        end
        object Install1: TMenuItem
          Caption = 'Install'
          OnClick = Install1Click
        end
        object Skin1: TMenuItem
          Caption = 'Skin'
        end
      end
      object Edit1: TMenuItem
        Caption = 'Edit...'
      end
    end
  end
end
