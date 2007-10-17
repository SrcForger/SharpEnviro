object frmMM: TfrmMM
  Left = 0
  Top = 0
  Caption = 'frmMM'
  ClientHeight = 460
  ClientWidth = 397
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
    Width = 397
    Height = 460
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    ExplicitWidth = 427
    ExplicitHeight = 534
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 397
      Height = 460
      ExplicitWidth = 427
      ExplicitHeight = 534
      object Label3: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 381
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Alignment'
        ExplicitWidth = 47
      end
      object Label1: TLabel
        AlignWithMargins = True
        Left = 24
        Top = 29
        Width = 365
        Height = 19
        Margins.Left = 24
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Change how you want the memory and swap file informations to be ' +
          'aligned.'
        Transparent = False
        WordWrap = True
        ExplicitLeft = 26
        ExplicitTop = 94
        ExplicitWidth = 393
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 81
        Width = 381
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Physical Memory'
        ExplicitTop = 84
      end
      object Label6: TLabel
        AlignWithMargins = True
        Left = 24
        Top = 102
        Width = 365
        Height = 19
        Margins.Left = 24
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Select how to display informations about the physical memory.'
        Transparent = False
        WordWrap = True
        ExplicitLeft = 26
        ExplicitTop = 156
        ExplicitWidth = 393
      end
      object Label4: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 209
        Width = 381
        Height = 13
        Margins.Left = 8
        Margins.Top = 16
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Swap File'
        ExplicitTop = 263
        ExplicitWidth = 45
      end
      object Label5: TLabel
        AlignWithMargins = True
        Left = 24
        Top = 230
        Width = 365
        Height = 19
        Margins.Left = 24
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Select how to display informations about the swap file.'
        Transparent = False
        WordWrap = True
        ExplicitTop = 284
        ExplicitWidth = 395
      end
      object Label7: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 337
        Width = 381
        Height = 13
        Margins.Left = 8
        Margins.Top = 16
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Status Bar Size'
        ExplicitTop = 391
        ExplicitWidth = 72
      end
      object Label9: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 398
        Width = 381
        Height = 13
        Margins.Left = 8
        Margins.Top = 16
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Value Text Format'
        ExplicitTop = 452
        ExplicitWidth = 88
      end
      object cbRamInfo: TCheckBox
        AlignWithMargins = True
        Left = 26
        Top = 177
        Width = 363
        Height = 16
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Information Label'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cbRamInfoClick
        ExplicitTop = 231
        ExplicitWidth = 393
      end
      object cbRamPC: TCheckBox
        AlignWithMargins = True
        Left = 26
        Top = 153
        Width = 363
        Height = 16
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Value as Text'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = cbRamInfoClick
        ExplicitTop = 207
        ExplicitWidth = 393
      end
      object cbRamBar: TCheckBox
        AlignWithMargins = True
        Left = 26
        Top = 129
        Width = 363
        Height = 16
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Status Bar'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = cbRamInfoClick
        ExplicitTop = 183
        ExplicitWidth = 393
      end
      object cbSwpBar: TCheckBox
        AlignWithMargins = True
        Left = 26
        Top = 257
        Width = 363
        Height = 16
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Status Bar'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = cbRamInfoClick
        ExplicitTop = 311
        ExplicitWidth = 393
      end
      object cbSwpPC: TCheckBox
        AlignWithMargins = True
        Left = 26
        Top = 281
        Width = 363
        Height = 16
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Value as Text'
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = cbRamInfoClick
        ExplicitTop = 335
        ExplicitWidth = 393
      end
      object cbSwpInfo: TCheckBox
        AlignWithMargins = True
        Left = 26
        Top = 305
        Width = 363
        Height = 16
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Information Label'
        Checked = True
        State = cbChecked
        TabOrder = 5
        OnClick = cbRamInfoClick
        ExplicitTop = 359
        ExplicitWidth = 393
      end
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 24
        Top = 358
        Width = 365
        Height = 21
        Margins.Left = 24
        Margins.Top = 8
        Margins.Right = 8
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 6
        ExplicitTop = 412
        ExplicitWidth = 395
        object sgbBarSize: TSharpeGaugeBox
          Left = 0
          Top = 0
          Width = 137
          Height = 21
          Margins.Left = 24
          Margins.Top = 4
          Align = alLeft
          ParentBackground = False
          Min = 25
          Max = 200
          Value = 100
          Prefix = 'Width: '
          Suffix = 'px'
          Description = 'Adjust Bar Width'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgbBarSizeChangeValue
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 411
        Width = 397
        Height = 58
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 7
        ExplicitTop = 465
        ExplicitWidth = 427
        object rbPTaken: TRadioButton
          AlignWithMargins = True
          Left = 24
          Top = 8
          Width = 365
          Height = 17
          Margins.Left = 24
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alTop
          Caption = 'Percent Taken (example: 61%)'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbVertClick
          ExplicitWidth = 395
        end
        object rbFreeMB: TRadioButton
          AlignWithMargins = True
          Left = 24
          Top = 33
          Width = 365
          Height = 17
          Margins.Left = 24
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alTop
          Caption = 'Free MB (example: 210 MB Free)'
          TabOrder = 1
          OnClick = rbVertClick
          ExplicitWidth = 395
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 48
        Width = 397
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 8
        object rbHoriz: TRadioButton
          AlignWithMargins = True
          Left = 26
          Top = 0
          Width = 73
          Height = 17
          Margins.Left = 24
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 8
          Caption = 'Horizontal'
          TabOrder = 0
          OnClick = rbVertClick
        end
        object rbHoriz2: TRadioButton
          AlignWithMargins = True
          Left = 123
          Top = 0
          Width = 136
          Height = 17
          Margins.Left = 24
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          Caption = 'Horizontal (Compact)'
          Checked = True
          TabOrder = 1
          TabStop = True
          OnClick = rbVertClick
        end
        object rbVert: TRadioButton
          AlignWithMargins = True
          Left = 275
          Top = 0
          Width = 105
          Height = 17
          Margins.Left = 24
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          Caption = 'Vertical (2 rows)'
          TabOrder = 2
          OnClick = rbVertClick
        end
      end
    end
  end
end
