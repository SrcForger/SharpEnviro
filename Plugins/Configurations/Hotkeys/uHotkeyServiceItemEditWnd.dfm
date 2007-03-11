object FrmHotkeyEdit: TFrmHotkeyEdit
  Left = 683
  Top = 363
  BorderStyle = bsNone
  Caption = 'Hotkey Configuration'
  ClientHeight = 75
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 505
    Height = 75
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 284
      Top = 140
      Width = 575
      Height = 365
      BevelOuter = bvNone
      TabOrder = 0
    end
    object pMain: TJvPageList
      Left = 0
      Top = 0
      Width = 505
      Height = 75
      ActivePage = spDelete
      PropagateEnable = False
      Align = alClient
      ParentBackground = True
      object spEdit: TJvStandardPage
        Left = 0
        Top = 0
        Width = 505
        Height = 75
        ParentBackground = True
        object cmdBrowse: TPngBitBtn
          Left = 243
          Top = 147
          Width = 77
          Height = 22
          Caption = 'Browse'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = False
          OnClick = cmdbrowseclick
          PngImage.Data = {
            89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
            6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
            000DD70142289B780000000774494D45000000000000000973942E0000018849
            44415478DAB593DF4A024114C6BF9DD92B83BC3137BC0AAFC257280CB3C45EA4
            EE8308BA2F4C114322905EA3522AFAE3635457A5D8BA7B2989B033DB99D1D556
            BB49E8CC0C7376E0FB9D6FE6B046A178BC0BA086398231B66F10C03F3C389A47
            8FD3D209C68056ABF52771229140A95CF827806118E3059AF0D5A42155AEB3DF
            014AF0FAF6827EFF0BBD5E4FC3E2710BA9D51494B6D97CC4FA5A1A9248169D97
            2BC509A0DD6EE3A3F58EE44A120663787A7E183BB2AC65D8F6A7CE37D2194829
            108B2D85019D4E87DAC2C13953EDA165E0EEFE76E6EE9B992C84F0118D2EE2AC
            5A9E006CDB06E30460238002190CF5C67508B095CD410A89C84204D5F3CA04E0
            74BB43000F5C70DCD4AF661CE4B6F3E440E822B5CB8B1F00D7A1EA264C936B71
            BD312B5691CFED1040EAEE8400AEEBEAEA2637C14D46B9A9BFD55BF8D2879012
            C213B40B78C2D3AD9D72E09238000457192EA9C4420905DD9F76CFD36EC20E1C
            07CC1C0182C7540EE821250DE5220028D80C20389C0E553D88A0B28AC1603006
            CCFD3B53EC7D036587EE50ED5EC05B0000000049454E44AE426082}
        end
      end
      object spDelete: TJvStandardPage
        Left = 0
        Top = 0
        Width = 505
        Height = 75
        Caption = 'spDelete'
        ParentBackground = True
        DesignSize = (
          505
          75)
        object Label3: TJvLabel
          Left = 278
          Top = 12
          Width = 38
          Height = 14
          Caption = 'Hotkey:'
          Anchors = [akTop, akRight]
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object edName: TLabeledEdit
          Left = 56
          Top = 8
          Width = 197
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 30
          EditLabel.Height = 14
          EditLabel.Caption = 'Name:'
          LabelPosition = lpLeft
          LabelSpacing = 6
          TabOrder = 0
        end
        object edCommand: TLabeledEdit
          Left = 84
          Top = 40
          Width = 313
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 50
          EditLabel.Height = 14
          EditLabel.Caption = 'Command:'
          LabelPosition = lpLeft
          LabelSpacing = 6
          TabOrder = 1
        end
        object edHotkey: TScHotkeyEdit
          Left = 324
          Top = 8
          Width = 157
          Height = 22
          Modifier = []
          Anchors = [akTop, akRight]
        end
        object Button1: TButton
          Left = 408
          Top = 40
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Browse'
          TabOrder = 3
          OnClick = cmdbrowseclick
        end
      end
    end
  end
end
