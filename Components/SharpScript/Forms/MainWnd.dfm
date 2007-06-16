object MainForm: TMainForm
  Left = 0
  Top = 0
  Width = 434
  Height = 211
  Caption = 'SharpScript'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 32
    Width = 247
    Height = 13
    Caption = 'SharpSript is still in a very early development state!'
  end
  object Label2: TLabel
    Left = 32
    Top = 56
    Width = 109
    Height = 13
    Caption = 'Use at your own risk :)'
  end
  object MainMenu1: TMainMenu
    Left = 360
    Top = 16
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
        OnClick = Execute1Click
      end
      object Create1: TMenuItem
        Caption = 'Create'
        object Generic1: TMenuItem
          Caption = 'Generic Script'
          OnClick = Generic1Click
        end
        object Install1: TMenuItem
          Caption = 'Install'
          Enabled = False
          OnClick = Install1Click
        end
        object Skin1: TMenuItem
          Caption = 'Skin'
          Enabled = False
          Visible = False
        end
      end
      object Edit1: TMenuItem
        Caption = 'Edit...'
        Visible = False
      end
    end
  end
  object XPManifest1: TXPManifest
    Left = 328
    Top = 16
  end
  object OpenScript: TOpenDialog
    Filter = 'SharpE Script|*.sescript|SharpE Install Script|*.sip'
    Left = 296
    Top = 16
  end
  object JvInterpreter: TJvInterpreterProgram
    Left = 264
    Top = 16
  end
end
