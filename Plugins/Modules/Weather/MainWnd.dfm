object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Weather'
  ClientHeight = 159
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDblClick = BackgroundDblClick
  OnDestroy = FormDestroy
  OnMouseEnter = MouseEnter
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object lb_bottom: TSharpESkinLabel
    Left = 50
    Top = 0
    Width = 12
    Height = 21
    AutoSize = True
    Visible = False
    OnDblClick = BackgroundDblClick
    OnMouseUp = FormMouseUp
    Caption = '.'
    AutoPos = apTop
    LabelStyle = lsSmall
  end
  object lb_top: TSharpESkinLabel
    Left = 2
    Top = 0
    Width = 12
    Height = 21
    AutoSize = True
    Visible = False
    OnDblClick = BackgroundDblClick
    OnMouseUp = FormMouseUp
    Caption = '.'
    AutoPos = apTop
    LabelStyle = lsSmall
  end
  object PopupTimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = PopupTimerTimer
    Left = 24
    Top = 32
  end
  object ClosePopupTimer: TTimer
    Enabled = False
    OnTimer = ClosePopupTimerTimer
    Left = 56
    Top = 32
  end
  object mnuRight: TPopupMenu
    Images = PngImageList1
    Left = 96
    Top = 32
    object mnuRightUpdate: TMenuItem
      Caption = 'Refresh'
      ImageIndex = 0
      OnClick = mnuRightUpdateClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuRightConfigure: TMenuItem
      Caption = 'Configure'
      ImageIndex = 1
      OnClick = mnuRightConfigureClick
    end
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001F14944415478DAA5935F48936114879F77D350885D14D9
          422C232A08BADAA28B0D14C915B6FE5C142C4348108242292C68BB7077D3B061
          D120EA42A1814476D12E56B80D82985D8446444954B326429375D14D19D5F676
          3ECBB1358752075E3E78CF390FEFF9FDCEA7B4D6FC4FA8258052AA62913B4824
          A739FCF00285A242DF6A00AECBE8D0C93067C21D24BCBF2115016D83BC90ABDD
          4B93E5F2E0D8058D75B07D4300FF986F11B22CE0E810DAB9071A36C266737BE1
          056FBE8EF2230726136CAAE9E47A648468AF562580434175D7B197E30BDF203D
          2B0929FE380F79493B04DAB845C0162703C349E25EECD2375502381652BAA11E
          5EBDE479BC8FAE620DF60F30D97DCACAB5E10C711F76B99A2A1BE1C890D29F66
          083C0971FBC020AFCD26EE447B3961E45AFD8C57AFC5F5E0227671C46652DC8C
          9CFF6B04D1C0269F744B3FD9B1D3613CB73A885F2AD8B655CE3A11F8EACE3A9C
          B39FE15E4F39807DFDE81B5D01926F7DA4B330310D356B60BDC5B04D2856A8AD
          82C4531231BF6E2D011C0C2A7DD6DDC9FCCF11F2625DB51976D4B6174BC1C4DC
          28C96770FF1CDBA46FA66C049788E57139A9B224497D80D47B102DC8648DBCBC
          22C7BB711F9E6545FCB3483643F1B6662BD1471962DE45C58B6341CEF44AAB6C
          735F61F2FB171EC7FC34555AEF95FE05C311D19AD4AA01FF1ABF002863E6E161
          2AEF9B0000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000018E4944415478DA95D14F2883711CC7F1CF4F8CE30E9625
          17AC1C6CB499C3B4935D8868E4E0428A8938286AC9A2A90DC961B683C681DD94
          E224292BF32769988B705062B57F1EC66ACD9F9F87F2F8BB3D8F5F3D87E7DBF3
          7AFF7A7E3F827FACD3090F4DBC24A030EAC8DB3BA51444281EB65A6997AA0DC1
          4804E43A00C54025111C18B44CD3BEEE563866ECA8CED4E1868922E7E51E4AB3
          9EF006F64C2A5A6CB0627CE10475353AAC6DACA2E44A0E69FC12E58ECED4811D
          93866AF4122074850B513B5CFB14257219DCBB6ED846C7D4EC2F78494ADC2005
          826180619FFB008EC5BD983F2498B28CA8D94FBC49CFE0134758CC000F77EC34
          0ED7511E5AEC07EF38E92DFCC651803C62D657880E9B87C37F069261A74F0683
          6DF31BFE15D86671C53FF0B780C7A8A6DAA65C20CC42E65610E602A1957A9AAD
          D40067EBECEE7E201603D29E783117082ED65289B611895802A2AD49E0390AE7
          71112FE60273E6562A2DC84795528C34FF219CCBE730387678311718EA69A659
          4F77689267201E4F4769FF9220FCF510CB7ECC05E18FC02B208EE4E13C22EE77
          0000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end>
    Left = 128
    Top = 32
    Bitmap = {}
  end
end
