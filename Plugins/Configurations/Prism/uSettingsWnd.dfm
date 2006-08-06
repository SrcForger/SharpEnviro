object frmSettingsWnd: TfrmSettingsWnd
  Left = 501
  Top = 245
  BorderStyle = bsNone
  Caption = 'frmSettingsWnd'
  ClientHeight = 400
  ClientWidth = 380
  Color = clWindow
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label3: TLabel
    Left = 72
    Top = 528
    Width = 95
    Height = 14
    Caption = 'Memory Settings'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object plConfig: TJvPageList
    Left = 0
    Top = 0
    Width = 380
    Height = 400
    ActivePage = spGeneral
    PropagateEnable = False
    Align = alClient
    object spGeneral: TJvStandardPage
      Left = 0
      Top = 0
      Width = 380
      Height = 400
      object Label5: TLabel
        Left = 8
        Top = 8
        Width = 92
        Height = 14
        Caption = 'General Settings'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 8
        Top = 64
        Width = 153
        Height = 14
        Caption = 'Memory Optimiser Settings'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl2: TLabel
        Left = 8
        Top = 88
        Width = 108
        Height = 14
        Caption = 'Event Interval (msecs)'
        Transparent = True
      end
      object lbl11: TLabel
        Left = 152
        Top = 88
        Width = 135
        Height = 14
        Caption = 'Memory Low Threshold (%)'
        Transparent = True
      end
      object chkMemOptimer: TCheckBox
        Left = 8
        Top = 32
        Width = 167
        Height = 17
        Caption = 'Enable Memory Optimiser'
        TabOrder = 0
        OnClick = chkMemOptimerClick
      end
      object spnedtMemEvtInt: TJvSpinEdit
        Left = 8
        Top = 104
        Width = 129
        Height = 22
        ButtonKind = bkClassic
        MaxValue = 99999.000000000000000000
        Value = 400.000000000000000000
        TabOrder = 1
        OnChange = spnedtMemEvtIntChange
        BevelInner = bvNone
      end
      object spnedtMemLowThres: TJvSpinEdit
        Left = 152
        Top = 104
        Width = 129
        Height = 22
        ButtonKind = bkClassic
        MaxValue = 100.000000000000000000
        TabOrder = 2
        OnChange = spnedtMemLowThresChange
      end
    end
    object JvStandardPage2: TJvStandardPage
      Left = 0
      Top = 0
      Width = 380
      Height = 400
      Caption = 'JvStandardPage2'
    end
  end
  object coldlg: TColorDialog
    Options = [cdAnyColor]
    Left = 288
    Top = 208
  end
end
