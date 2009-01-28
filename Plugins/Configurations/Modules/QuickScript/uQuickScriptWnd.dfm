object frmQuickScript: TfrmQuickScript
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmQuickScript'
  ClientHeight = 82
  ClientWidth = 449
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 449
    Height = 82
    ActivePage = pagQuickScript
    PropagateEnable = False
    Align = alClient
    ExplicitHeight = 161
    object pagQuickScript: TJvStandardPage
      Left = 0
      Top = 0
      Width = 449
      Height = 82
      ExplicitTop = -3
      ExplicitHeight = 161
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 47
        Width = 439
        Height = 21
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitTop = 33
        object cboDisplay: TComboBox
          Left = 0
          Top = 0
          Width = 250
          Height = 21
          Align = alLeft
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cboComboChange
          Items.Strings = (
            'Icon and Text'
            'Icon'
            'Text')
        end
      end
      object schDisplayOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 439
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Display Options'
        Description = 
          'Select how the button for opening the Quick Script window will d' +
          'isplay on the SharpBar.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitLeft = 3
        ExplicitTop = 3
        ExplicitWidth = 443
      end
    end
  end
end
