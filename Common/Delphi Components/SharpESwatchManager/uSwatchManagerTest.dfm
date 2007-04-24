object Form3: TForm3
  Left = 0
  Top = 0
  Width = 434
  Height = 320
  Caption = 'Form3'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    418
    284)
  PixelsPerInch = 96
  TextHeight = 13
  object img: TImage32
    Left = 0
    Top = 0
    Width = 418
    Height = 284
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    OnMouseDown = imgMouseDown
  end
  object Button2: TButton
    Left = 328
    Top = 248
    Width = 75
    Height = 25
    Anchors = []
    Caption = 'Add Random'
    TabOrder = 1
    OnClick = Button2Click
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = 16744448
      end
      item
        Color = clRed
      end
      item
        Color = 65408
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end
      item
        ColorName = 'Blue'
        Color = clBlue
      end
      item
        ColorName = 'Green'
        Color = 65408
      end>
    Width = 200
    ShowCaptions = True
    SwatchHeight = 16
    SwatchWidth = 16
    SwatchSpacing = 4
    SwatchFont.Charset = DEFAULT_CHARSET
    SwatchFont.Color = clWindowText
    SwatchFont.Height = -11
    SwatchFont.Name = 'Tahoma'
    SwatchFont.Style = []
    SwatchTextBorderColor = clBtnFace
    SortMode = sortName
    OnGetWidth = SharpESwatchManager1GetWidth
    OnUpdateSwatchBitmap = SharpESwatchManager1UpdateSwatchBitmap
    Left = 16
    Top = 216
  end
end
