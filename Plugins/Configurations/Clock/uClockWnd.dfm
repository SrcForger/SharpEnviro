object frmClock: TfrmClock
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmClock'
  ClientHeight = 339
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
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 447
    Height = 339
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 447
      Height = 339
      object Label3: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 67
        Width = 431
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Text Size'
        ExplicitTop = 70
        ExplicitWidth = 44
      end
      object lbSize: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 88
        Width = 413
        Height = 17
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Select how large you want the clock text to be displayed'
        Transparent = False
        WordWrap = True
        ExplicitTop = 96
        ExplicitWidth = 393
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 33
        Width = 413
        Height = 26
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 
          'Enable this option to use an alternative two line display with t' +
          'wo custom clock texts. (Note that you can'#39't change the text size' +
          ' if this option is enabled)'
        Transparent = False
        WordWrap = True
        ExplicitWidth = 406
      end
      object Label4: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 197
        Width = 431
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Text Format'
        ExplicitTop = 200
        ExplicitWidth = 59
      end
      object Label5: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 218
        Width = 413
        Height = 17
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Top/Primary Label'
        Transparent = False
        WordWrap = True
        ExplicitTop = 241
        ExplicitWidth = 397
      end
      object lbTwoLine: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 276
        Width = 413
        Height = 17
        Margins.Left = 26
        Margins.Top = 12
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Bottom Label'
        Transparent = False
        WordWrap = True
        ExplicitTop = 299
        ExplicitWidth = 397
      end
      object rbLarge: TRadioButton
        AlignWithMargins = True
        Left = 27
        Top = 113
        Width = 412
        Height = 17
        Margins.Left = 27
        Margins.Top = 8
        Margins.Right = 8
        Align = alTop
        Caption = 'Large'
        TabOrder = 0
        OnClick = rbLargeClick
      end
      object rbMedium: TRadioButton
        AlignWithMargins = True
        Left = 27
        Top = 141
        Width = 412
        Height = 17
        Margins.Left = 27
        Margins.Top = 8
        Margins.Right = 8
        Align = alTop
        Caption = 'Medium'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = rbLargeClick
      end
      object rbSmall: TRadioButton
        AlignWithMargins = True
        Left = 27
        Top = 169
        Width = 412
        Height = 17
        Margins.Left = 27
        Margins.Top = 8
        Margins.Right = 8
        Align = alTop
        Caption = 'Small'
        TabOrder = 2
        OnClick = rbLargeClick
      end
      object cbTwoLine: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 431
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Two Line Display'
        TabOrder = 3
        OnClick = cbTwoLineClick
      end
      object Panel1: TPanel
        Left = 0
        Top = 293
        Width = 447
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel1'
        ParentColor = True
        TabOrder = 4
        object EditTwoLine: TEdit
          AlignWithMargins = True
          Left = 24
          Top = 8
          Width = 372
          Height = 21
          Margins.Left = 24
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alClient
          TabOrder = 0
          Text = 'DD.MM.YYYY'
        end
        object btnTwoLine: TButton
          AlignWithMargins = True
          Left = 404
          Top = 6
          Width = 35
          Height = 23
          Margins.Left = 0
          Margins.Top = 6
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alRight
          Caption = '...'
          TabOrder = 1
          OnClick = btnTwoLineClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 235
        Width = 447
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel1'
        ParentColor = True
        TabOrder = 5
        object EditSingleLine: TEdit
          AlignWithMargins = True
          Left = 24
          Top = 8
          Width = 372
          Height = 21
          Margins.Left = 24
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alClient
          TabOrder = 0
          Text = 'HH:MM:SS'
        end
        object Button2: TButton
          AlignWithMargins = True
          Left = 404
          Top = 6
          Width = 35
          Height = 23
          Margins.Left = 0
          Margins.Top = 6
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alRight
          Caption = '...'
          TabOrder = 1
          OnClick = Button2Click
        end
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 392
    Top = 8
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
