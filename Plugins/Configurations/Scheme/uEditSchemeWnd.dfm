object frmEditScheme: TfrmEditScheme
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Create/Edit Color Scheme'
  ClientHeight = 206
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pnlContainer: TPanel
    Left = 0
    Top = 0
    Width = 498
    Height = 206
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      498
      206)
    object edName: TLabeledEdit
      Left = 42
      Top = 8
      Width = 183
      Height = 22
      EditLabel.Width = 30
      EditLabel.Height = 14
      EditLabel.Caption = 'Name:'
      LabelPosition = lpLeft
      LabelSpacing = 6
      TabOrder = 0
      OnKeyDown = edNameKeyDown
    end
    object edAuthor: TLabeledEdit
      Left = 276
      Top = 8
      Width = 217
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 16
      EditLabel.Height = 14
      EditLabel.Caption = 'By:'
      LabelPosition = lpLeft
      LabelSpacing = 6
      TabOrder = 1
      OnKeyDown = edNameKeyDown
    end
    object SharpERoundPanel1: TSharpERoundPanel
      Left = 4
      Top = 36
      Width = 490
      Height = 166
      Align = alBottom
      BevelOuter = bvNone
      BorderWidth = 4
      Caption = 'SharpERoundPanel1'
      Color = clWindow
      ParentBackground = False
      TabOrder = 2
      DrawMode = srpNormal
      NoTopBorder = False
      RoundValue = 10
      BorderColor = clBtnShadow
      Border = False
      BackgroundColor = clBtnFace
      object secEx: TSharpEColorEditorEx
        Left = 4
        Top = 4
        Width = 482
        Height = 158
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        Items = <>
        SwatchManager = SharpESwatchManager1
        OnChangeColor = secExChangeValue
        OnUiChange = secExUiChange
      end
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    Width = 100
    ShowCaptions = True
    SwatchHeight = 16
    SwatchWidth = 16
    SwatchSpacing = 4
    SwatchFont.Charset = DEFAULT_CHARSET
    SwatchFont.Color = clWindowText
    SwatchFont.Height = -11
    SwatchFont.Name = 'Tahoma'
    SwatchFont.Style = []
    SwatchTextBorderColor = 16709617
    SortMode = sortName
    Left = 196
    Top = 136
  end
  object SharpECenterScheme1: TSharpECenterScheme
    SidePanelCol = clWindow
    SidePanelBordCol = clWindow
    SidePanelItemCol = clWindow
    SidePanelItemSelCol = 14088190
    SidePanelItemSelBordCol = 14088190
    SidePanelItemTextCol = clWindowText
    SidePanelTabCol = clWindow
    SidePanelTabBordCol = 14088190
    SidePanelTabSelCol = 14088190
    SidePanelTabTextCol = clWindowText
    SidePanelTabTextDisCol = clWindowText
    EditCol = 16709617
    EditBordCol = 16709617
    EditErrCol = 15395324
    EditTabCol = 16250871
    EditTabBordCol = 16709617
    EditTabSelCol = 16709617
    EditTabErrCol = 15395324
    EditTabTextCol = clWindowText
    EditTabTextDisCol = clWindowText
    MainTabCol = 16250871
    MainTabSelCol = clWindow
    MainTabTextCol = clWindow
    MainTabTextDisCol = clWindow
    MainTabTextStatCol = clGreen
    MainTabBordCol = 16709617
    MainListCol = clWindow
    MainListItemCol = clWindow
    MainListItemBordCol = 16250871
    MainListItemSelCol = 16250871
    MainListItemDisCol = 12303291
    Left = 156
    Top = 136
  end
end
