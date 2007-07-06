object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'ScreenShot Settings'
  ClientHeight = 341
  ClientWidth = 251
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
  object Button1: TButton
    Left = 94
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 174
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object JvgPageControl1: TJvgPageControl
    Left = 2
    Top = 2
    Width = 247
    Height = 307
    ActivePage = TabSheet1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    TabOrder = 2
    TabStop = False
    TabStyle.Borders = [fsdLeft, fsdTop, fsdRight, fsdBottom]
    TabStyle.BevelInner = bvNone
    TabStyle.BevelOuter = bvNone
    TabStyle.Bold = False
    TabStyle.BackgrColor = clBtnShadow
    TabStyle.Font.Charset = DEFAULT_CHARSET
    TabStyle.Font.Color = clBtnHighlight
    TabStyle.Font.Height = -11
    TabStyle.Font.Name = 'Arial'
    TabStyle.Font.Style = []
    TabStyle.CaptionHAlign = fhaCenter
    TabStyle.Gradient.Active = False
    TabStyle.Gradient.Orientation = fgdHorizontal
    TabSelectedStyle.Borders = [fsdLeft, fsdTop, fsdRight, fsdBottom]
    TabSelectedStyle.BevelInner = bvNone
    TabSelectedStyle.BevelOuter = bvNone
    TabSelectedStyle.Bold = False
    TabSelectedStyle.BackgrColor = clBtnFace
    TabSelectedStyle.Font.Charset = DEFAULT_CHARSET
    TabSelectedStyle.Font.Color = clBtnText
    TabSelectedStyle.Font.Height = -11
    TabSelectedStyle.Font.Name = 'Arial'
    TabSelectedStyle.Font.Style = []
    TabSelectedStyle.CaptionHAlign = fhaCenter
    TabSelectedStyle.Gradient.Active = False
    TabSelectedStyle.Gradient.Orientation = fgdHorizontal
    Options = [ftoAutoFontDirection, ftoExcludeGlyphs]
    object TabSheet1: TTabSheet
      Caption = 'General'
      object GroupBox3: TGroupBox
        Left = 0
        Top = 96
        Width = 241
        Height = 183
        Caption = 'Save to AutoGenerated File'
        TabOrder = 0
        object GroupBox5: TGroupBox
          Left = 6
          Top = 98
          Width = 225
          Height = 83
          Caption = 'Date/Time Filename'
          TabOrder = 0
          object cbxDateTime: TCheckBox
            Left = 8
            Top = 16
            Width = 81
            Height = 17
            Caption = 'Date/Time'
            TabOrder = 0
            OnClick = cbxDateTimeClick
          end
          object cbxDateTimeFormat: TComboBox
            Left = 24
            Top = 40
            Width = 193
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            Sorted = True
            TabOrder = 1
            Items.Strings = (
              'DDMMYYYYHHMMSS'
              'MMDDYYYYHHMMSS')
          end
        end
        object GroupBox4: TGroupBox
          Left = 6
          Top = 16
          Width = 225
          Height = 83
          Caption = 'Incremented Filename'
          TabOrder = 1
          object Label2: TLabel
            Left = 8
            Top = 24
            Width = 47
            Height = 13
            Caption = 'FileName:'
          end
          object tbxFilename: TEdit
            Left = 64
            Top = 20
            Width = 153
            Height = 21
            TabOrder = 0
            Text = 'Screenshot'
          end
          object tbxNum: TEdit
            Left = 176
            Top = 50
            Width = 41
            Height = 21
            TabOrder = 1
            Text = '0'
          end
          object cbxNum: TCheckBox
            Left = 8
            Top = 52
            Width = 161
            Height = 17
            Caption = 'Number to Start appending:'
            TabOrder = 2
            OnClick = cbxNumClick
          end
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 241
        Height = 95
        Caption = 'Save Method'
        TabOrder = 1
        object Label1: TLabel
          Left = 12
          Top = 68
          Width = 41
          Height = 13
          AutoSize = False
          Caption = 'Format:'
        end
        object cbxClipboard: TCheckBox
          Left = 10
          Top = 14
          Width = 73
          Height = 17
          Caption = 'Clipboard'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbxSaveAs: TCheckBox
          Left = 10
          Top = 32
          Width = 121
          Height = 17
          Caption = 'SaveAs Dialogbox'
          TabOrder = 1
        end
        object cbxSaveToFile: TCheckBox
          Left = 118
          Top = 14
          Width = 113
          Height = 17
          Caption = 'Save to File'
          TabOrder = 2
          OnClick = cbxSaveToFileClick
        end
        object cbxActive: TCheckBox
          Left = 118
          Top = 32
          Width = 97
          Height = 17
          Caption = 'Active Window'
          TabOrder = 3
        end
        object cbxFormat: TComboBox
          Left = 60
          Top = 64
          Width = 167
          Height = 21
          ItemHeight = 13
          Sorted = True
          TabOrder = 4
          OnChange = cbxFormatChange
          Items.Strings = (
            'Bmp'
            'Jpg'
            'Png')
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'File Location'
      ImageIndex = 1
      object GroupBox2: TGroupBox
        Left = 2
        Top = 0
        Width = 237
        Height = 277
        Caption = 'Location'
        TabOrder = 0
        object DlbFolders: TJvDirectoryListBox
          Left = 4
          Top = 40
          Width = 227
          Height = 231
          Directory = 'c:\program files\borland\bds\3.0\bin'
          DriveCombo = JvDriveCombo1
          ItemHeight = 17
          ScrollBars = ssBoth
          TabOrder = 0
        end
        object JvDriveCombo1: TJvDriveCombo
          Left = 4
          Top = 16
          Width = 229
          Height = 22
          DriveTypes = [dtFixed, dtRemote, dtCDROM]
          Offset = 4
          ItemHeight = 16
          TabOrder = 1
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Options'
      ImageIndex = 2
      object GroupBox6: TGroupBox
        Left = 0
        Top = 0
        Width = 233
        Height = 51
        Caption = 'Jpeg Options'
        TabOrder = 0
        object Label3: TLabel
          Left = 6
          Top = 22
          Width = 71
          Height = 13
          AutoSize = False
          Caption = 'Compression:'
        end
        object chkJpgGrayscale: TCheckBox
          Left = 142
          Top = 20
          Width = 77
          Height = 17
          Caption = 'Grayscale'
          TabOrder = 0
        end
        object speJpgCompression: TSpinEdit
          Left = 74
          Top = 17
          Width = 51
          Height = 22
          MaxValue = 100
          MinValue = 1
          TabOrder = 1
          Value = 1
        end
      end
      object GroupBox7: TGroupBox
        Left = 0
        Top = 52
        Width = 233
        Height = 53
        Caption = 'Png Options'
        TabOrder = 1
        object Label4: TLabel
          Left = 6
          Top = 22
          Width = 71
          Height = 13
          AutoSize = False
          Caption = 'Compression:'
        end
        object spePngCompression: TSpinEdit
          Left = 74
          Top = 17
          Width = 51
          Height = 22
          MaxValue = 9
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
      end
      object GroupBox8: TGroupBox
        Left = 0
        Top = 106
        Width = 233
        Height = 167
        Caption = 'Hotkeys'
        TabOrder = 2
        object Memo1: TMemo
          Left = 8
          Top = 20
          Width = 215
          Height = 137
          BorderStyle = bsNone
          Color = clMenu
          Lines.Strings = (
            '    You can now set hotkeys to take your '
            'screenshots.  The hotkeys are set in '
            'Sharpcenter. Choose Hotkeys then add.'
            ''
            'The Action is either: '
            '      !PrintScreen'
            '           to do the whole screen.'
            '      !PrintWindow'
            '           to do the active window.'
            '   All other settings remain the same.')
          TabOrder = 0
        end
      end
    end
  end
end
