object frmMiniScmd: TfrmMiniScmd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmMiniScmd'
  ClientHeight = 286
  ClientWidth = 435
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
    Width = 435
    Height = 286
    ActivePage = pagMiniScmd
    PropagateEnable = False
    Align = alClient
    ExplicitHeight = 197
    object pagMiniScmd: TJvStandardPage
      Left = 0
      Top = 0
      Width = 435
      Height = 286
      ExplicitHeight = 197
      object pnlSize: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 149
        Width = 423
        Height = 21
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        ExplicitTop = 153
        object sgb_width: TSharpeGaugeBox
          Left = 0
          Top = 0
          Width = 200
          Height = 21
          Margins.Left = 24
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alLeft
          ParentBackground = False
          Min = 25
          Max = 250
          Value = 100
          Prefix = 'Width: '
          Suffix = 'px'
          Description = 'Change the Command Box Width'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgb_widthChangeValue
          BackgroundColor = clWindow
          ExplicitTop = -10
        end
      end
      object scmQuickSelect: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 1
        Width = 423
        Height = 35
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Quick Select Options'
        Description = 
          'Configure whether or not you want a quick select button displaye' +
          'd.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
      end
      object scmSize: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 104
        Width = 423
        Height = 35
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Command Box Size'
        Description = 'Configure how wide you want the command box to be.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
      end
      object cbQuickSelect: TJvXPCheckbox
        AlignWithMargins = True
        Left = 6
        Top = 46
        Width = 423
        Height = 17
        Hint = 
          'Enable this option to display a button next to the command box w' +
          'hich will open a target selection dialog when clicked. (When the' +
          ' button is right clicked the selected target will be copied into' +
          ' the command box)'
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Display '#39'Quick Select'#39' Button'
        TabOrder = 3
        Checked = True
        State = cbChecked
        Align = alTop
        ParentShowHint = False
        ShowHint = True
        OnClick = cbQuickSelectClick
      end
      object pnButtonPos: TPanel
        Left = 1
        Top = 63
        Width = 433
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 4
        object lbButtonPos: TLabel
          Left = 8
          Top = 10
          Width = 79
          Height = 13
          Margins.Top = 10
          AutoSize = False
          Caption = 'Button Position'
          Color = clWindow
          ParentColor = False
          WordWrap = True
        end
        object cboButtonPos: TComboBox
          Left = 93
          Top = 7
          Width = 85
          Height = 21
          Style = csDropDownList
          Ctl3D = True
          ItemHeight = 13
          ItemIndex = 1
          ParentCtl3D = False
          TabOrder = 0
          Text = 'Right'
          OnChange = cboButtonPosChange
          Items.Strings = (
            'Left'
            'Right')
        end
      end
      object SharpECenterHeader1: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 180
        Width = 423
        Height = 35
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Auto-Complete'
        Description = 'Configure the auto-complete'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitTop = 225
      end
      object cbEnableAutoCom: TJvXPCheckbox
        Left = 6
        Top = 225
        Width = 161
        Height = 17
        Caption = 'Enable Auto-Complete'
        TabOrder = 6
        Checked = True
        State = cbChecked
        OnClick = cbEnableAutoComClick
      end
      object btnACClearList: TButton
        Left = 6
        Top = 248
        Width = 82
        Height = 25
        Caption = 'Clear List'
        TabOrder = 7
        OnClick = btnACClearListClick
      end
    end
  end
end
