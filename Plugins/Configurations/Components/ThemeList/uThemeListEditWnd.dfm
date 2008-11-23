object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmEdit'
  ClientHeight = 69
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object plEdit: TJvPageList
    Left = 0
    Top = 0
    Width = 483
    Height = 69
    ActivePage = pagAdd
    PropagateEnable = False
    Align = alTop
    object pagAdd: TJvStandardPage
      Left = 0
      Top = 0
      Width = 483
      Height = 69
      DesignSize = (
        483
        69)
      object Label3: TLabel
        Left = 18
        Top = 44
        Width = 48
        Height = 13
        Caption = 'Template:'
        Transparent = True
      end
      object edName: TLabeledEdit
        Left = 56
        Top = 8
        Width = 157
        Height = 21
        EditLabel.Width = 31
        EditLabel.Height = 13
        EditLabel.Caption = 'Name:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 0
        OnKeyPress = edThemeNameKeyPress
      end
      object edAuthor: TLabeledEdit
        Left = 264
        Top = 8
        Width = 196
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 16
        EditLabel.Height = 13
        EditLabel.Caption = 'By:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 1
        OnKeyPress = edThemeNameKeyPress
      end
      object edWebsite: TLabeledEdit
        Left = 288
        Top = 40
        Width = 172
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 43
        EditLabel.Height = 13
        EditLabel.Caption = 'Website:'
        LabelPosition = lpLeft
        LabelSpacing = 6
        TabOrder = 2
        OnKeyPress = edThemeNameKeyPress
      end
      object cbBasedOn: TComboBox
        Left = 76
        Top = 40
        Width = 137
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        OnSelect = cbBasedOnSelect
      end
    end
  end
end
