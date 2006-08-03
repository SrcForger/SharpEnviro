object AlignSettingsForm: TAlignSettingsForm
  Left = 346
  Top = 159
  BorderStyle = bsToolWindow
  Caption = 'Create new align  set'
  ClientHeight = 420
  ClientWidth = 349
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 382
    Width = 349
    Height = 2
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
  end
  object bottompanel: TPanel
    Left = 0
    Top = 384
    Width = 349
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      349
      36)
    object btn_ok: TButton
      Left = 178
      Top = 8
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Ok'
      TabOrder = 0
      OnClick = btn_okClick
    end
    object btn_cancel: TButton
      Left = 266
      Top = 8
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btn_cancelClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 88
    Width = 329
    Height = 121
    Caption = 'Spacing'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 19
      Width = 54
      Height = 14
      Caption = 'Horizontal :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 67
      Width = 43
      Height = 14
      Caption = 'Vertical :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lb_y: TLabel
      Left = 280
      Top = 73
      Width = 25
      Height = 11
      Alignment = taRightJustify
      AutoSize = False
      Caption = '64'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lb_x: TLabel
      Left = 280
      Top = 25
      Width = 25
      Height = 11
      Alignment = taRightJustify
      AutoSize = False
      Caption = '64'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object tb_y: TTrackBar
      Left = 8
      Top = 84
      Width = 305
      Height = 22
      Max = 256
      Min = 2
      Orientation = trHorizontal
      Frequency = 8
      Position = 64
      SelEnd = 0
      SelStart = 0
      TabOrder = 0
      ThumbLength = 15
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tb_yChange
    end
    object tb_x: TTrackBar
      Left = 8
      Top = 36
      Width = 305
      Height = 22
      Max = 256
      Min = 2
      Orientation = trHorizontal
      Frequency = 8
      Position = 64
      SelEnd = 0
      SelStart = 0
      TabOrder = 1
      ThumbLength = 15
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tb_xChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 224
    Width = 329
    Height = 73
    Caption = 'Wrap'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object lb_wrap: TLabel
      Left = 280
      Top = 25
      Width = 25
      Height = 11
      Alignment = taRightJustify
      AutoSize = False
      Caption = '8'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 19
      Width = 132
      Height = 14
      Caption = 'Object count for line wrap :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object tb_wrap: TTrackBar
      Left = 8
      Top = 36
      Width = 305
      Height = 22
      Max = 64
      Min = 1
      Orientation = trHorizontal
      Frequency = 1
      Position = 8
      SelEnd = 0
      SelStart = 0
      TabOrder = 0
      ThumbLength = 15
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tb_wrapChange
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 312
    Width = 329
    Height = 57
    Caption = 'Align by'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    object cb_left: TRadioButton
      Left = 56
      Top = 24
      Width = 113
      Height = 17
      Caption = 'Left'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object cb_center: TRadioButton
      Left = 184
      Top = 24
      Width = 113
      Height = 17
      Caption = 'Center'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TabStop = True
    end
    object cb_right: TRadioButton
      Left = 216
      Top = 24
      Width = 105
      Height = 17
      Caption = 'Right'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 8
    Width = 329
    Height = 65
    Caption = 'General'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 36
      Height = 14
      Caption = 'Name : '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edit_name: TEdit
      Left = 16
      Top = 32
      Width = 297
      Height = 22
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
end
