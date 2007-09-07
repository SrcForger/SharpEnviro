object frmLink: TfrmLink
  Left = 0
  Top = 0
  Caption = 'frmLink'
  ClientHeight = 400
  ClientWidth = 427
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
    Width = 427
    Height = 400
    ActivePage = pagLink
    PropagateEnable = False
    Align = alClient
    object pagLink: TJvStandardPage
      Left = 0
      Top = 0
      Width = 427
      Height = 400
      object Label9: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 411
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Link Target'
        ExplicitWidth = 53
      end
      object Label5: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 393
        Height = 20
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Select the target which will be opened when you click the link'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
        ExplicitTop = 116
        ExplicitWidth = 384
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 313
        Width = 411
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Icon'
        ExplicitWidth = 21
      end
      object Target: TJvFilenameEdit
        AlignWithMargins = True
        Left = 26
        Top = 49
        Width = 393
        Height = 21
        Margins.Left = 26
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 8
        OnBeforeDialog = TargetBeforeDialog
        OnButtonClick = TargetButtonClick
        Align = alTop
        TabOrder = 0
        OnChange = TargetChange
      end
      object pn_caption: TPanel
        Left = 0
        Top = 78
        Width = 427
        Height = 227
        Align = alTop
        BevelOuter = bvNone
        Ctl3D = True
        ParentColor = True
        ParentCtl3D = False
        TabOrder = 1
        object Label1: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 33
          Width = 393
          Height = 20
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Enable this option to display a caption along with the link icon'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          WordWrap = True
          ExplicitLeft = 8
        end
        object Label3: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 172
          Width = 393
          Height = 20
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Caption Align'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          WordWrap = True
          ExplicitTop = 225
        end
        object cb_caption: TCheckBox
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 411
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Display Caption'
          TabOrder = 0
          OnClick = cb_captionClick
        end
        object spc: TSharpEPageControl
          AlignWithMargins = True
          Left = 26
          Top = 56
          Width = 375
          Height = 105
          Margins.Left = 26
          Margins.Right = 26
          Align = alTop
          Color = clWindow
          ExpandedHeight = 200
          TabItems = <
            item
              Caption = 'Single Line'
              ImageIndex = 0
              Visible = True
            end
            item
              Caption = 'Multi Line'
              ImageIndex = 0
              Visible = True
            end>
          RoundValue = 10
          Border = True
          TabWidth = 62
          TabIndex = 0
          TabAlignment = taLeftJustify
          AutoSizeTabs = True
          TabBackgroundColor = clWindow
          BackgroundColor = clWindow
          BorderColor = clBlack
          TabColor = 15724527
          TabSelColor = clWhite
          TabCaptionSelColor = clBlack
          TabStatusSelColor = clGreen
          TabCaptionColor = clBlack
          TabStatusColor = clGreen
          OnTabChange = spcTabChange
          DesignSize = (
            375
            105)
          object pl: TJvPageList
            AlignWithMargins = True
            Left = 8
            Top = 34
            Width = 359
            Height = 63
            Margins.Left = 8
            Margins.Top = 34
            Margins.Right = 8
            Margins.Bottom = 8
            ActivePage = pagemulti
            PropagateEnable = False
            Align = alClient
            ParentBackground = True
            object pagesingle: TJvStandardPage
              Left = 0
              Top = 0
              Width = 359
              Height = 63
              Caption = 'pagesingle'
              object edit_caption: TEdit
                Left = 0
                Top = 0
                Width = 359
                Height = 21
                Align = alTop
                TabOrder = 0
                Text = 'Link'
                OnChange = edit_captionChange
              end
            end
            object pagemulti: TJvStandardPage
              Left = 0
              Top = 0
              Width = 359
              Height = 63
              Caption = 'pagemulti'
              ParentBackground = True
              object memo_caption: TMemo
                Left = 0
                Top = 0
                Width = 359
                Height = 63
                Align = alClient
                Lines.Strings = (
                  'Link')
                ScrollBars = ssBoth
                TabOrder = 0
                OnChange = memo_captionChange
              end
            end
          end
        end
        object Panel2: TPanel
          Left = 0
          Top = 192
          Width = 427
          Height = 25
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          object cb_calign: TComboBox
            Left = 42
            Top = 3
            Width = 145
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 2
            TabOrder = 0
            Text = 'Bottom'
            OnChange = cb_calignChange
            Items.Strings = (
              'Top'
              'Right'
              'Bottom'
              'Left'
              'Center')
          end
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 326
        Width = 427
        Height = 59
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel3'
        ParentColor = True
        TabOrder = 2
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 364
          Height = 59
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel4'
          ParentColor = True
          TabOrder = 0
          object Label4: TLabel
            AlignWithMargins = True
            Left = 26
            Top = 8
            Width = 330
            Height = 20
            Margins.Left = 26
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            AutoSize = False
            Caption = 'Select which icon to dispay with the link'
            EllipsisPosition = epEndEllipsis
            Transparent = False
            WordWrap = True
            ExplicitTop = 365
            ExplicitWidth = 393
          end
          object Icon: TJvFilenameEdit
            AlignWithMargins = True
            Left = 26
            Top = 28
            Width = 330
            Height = 21
            Margins.Left = 26
            Margins.Top = 0
            Margins.Right = 8
            Margins.Bottom = 8
            OnBeforeDialog = IconBeforeDialog
            OnButtonClick = IconButtonClick
            Align = alTop
            DirectInput = False
            TabOrder = 0
            OnChange = IconChange
          end
        end
        object SharpERoundPanel1: TSharpERoundPanel
          AlignWithMargins = True
          Left = 367
          Top = 3
          Width = 52
          Height = 52
          Margins.Right = 8
          Margins.Bottom = 4
          Align = alRight
          BevelOuter = bvNone
          Caption = 'SharpERoundPanel1'
          ParentBackground = False
          ParentColor = True
          TabOrder = 1
          DrawMode = srpNormal
          NoTopBorder = False
          RoundValue = 10
          BorderColor = clBtnFace
          Border = True
          BackgroundColor = clWindow
          object IconPreview: TImage32
            AlignWithMargins = True
            Left = 2
            Top = 2
            Width = 48
            Height = 48
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alClient
            Bitmap.ResamplerClassName = 'TNearestResampler'
            BitmapAlign = baCenter
            Scale = 1.000000000000000000
            ScaleMode = smNormal
            TabOrder = 0
          end
        end
      end
    end
  end
end
