object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmDeskAreaSettings'
  ClientHeight = 292
  ClientWidth = 857
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 52
    Width = 847
    Height = 72
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    object chkUseProxy: TJvXPCheckbox
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 842
      Height = 28
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Caption = 'Use Proxy'
      TabOrder = 0
      Align = alTop
      OnClick = chkUseProxyClick
    end
    object pnlUseProxy: TPanel
      Left = 0
      Top = 28
      Width = 847
      Height = 44
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 0
        Top = 16
        Width = 48
        Height = 17
        Caption = 'Address'
      end
      object Port: TLabel
        Left = 255
        Top = 16
        Width = 26
        Height = 17
        Caption = 'Port'
      end
      object edAddress: TEdit
        Left = 64
        Top = 14
        Width = 153
        Height = 25
        TabOrder = 0
        OnChange = edAddressChange
      end
      object edPort: TEdit
        Left = 295
        Top = 14
        Width = 57
        Height = 25
        TabOrder = 1
        OnChange = edPortChange
      end
    end
  end
  object SharpECenterHeader1: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 0
    Width = 847
    Height = 42
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Proxy'
    Description = 
      'Define whether to use a proxy address to use some of the SharpEn' +
      'viro functions'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
end
