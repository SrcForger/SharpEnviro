object SettingsWnd: TSettingsWnd
  Tag = 1
  Left = 303
  Top = 150
  BorderStyle = bsNone
  Caption = 'SettingsWnd'
  ClientHeight = 351
  ClientWidth = 378
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 378
    Height = 351
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 319
      Width = 378
      Height = 32
      Align = alBottom
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object cb_themesettings: TCheckBox
        Left = 16
        Top = 8
        Width = 193
        Height = 17
        Caption = 'Use default theme settings'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 0
        OnClick = cb_themesettingsClick
      end
    end
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 378
      Height = 319
      ActivePage = tab_weather
      Align = alClient
      MultiLine = True
      TabOrder = 1
      object tab_weather: TTabSheet
        Caption = 'Weather'
        TabVisible = False
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 345
          Height = 33
          AutoSize = False
          Caption = 
            'All weather data used by this desktop object is collected by the' +
            ' SharpE weather.service. Make sure that the weather.service is r' +
            'unning.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Label3: TLabel
          Left = 8
          Top = 56
          Width = 122
          Height = 14
          Caption = 'Weather.service status : '
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object lb_status: TLabel
          Left = 136
          Top = 56
          Width = 46
          Height = 14
          Caption = 'stopped'
          Font.Charset = ANSI_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label5: TLabel
          Left = 8
          Top = 80
          Width = 44
          Height = 14
          Caption = 'Location:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object GroupBox2: TGroupBox
          Left = 8
          Top = 128
          Width = 353
          Height = 145
          Caption = 'Weather Font'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object lb_spacing: TLabel
            Left = 14
            Top = 96
            Width = 110
            Height = 14
            Caption = 'Line spacing (in px) : 0'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object cb_textshadow: TCheckBox
            Left = 8
            Top = 72
            Width = 97
            Height = 17
            Caption = 'Text Shadow'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object tb_spacing: TTrackBar
            Left = 8
            Top = 112
            Width = 329
            Height = 25
            Max = 20
            Frequency = 100
            TabOrder = 1
            ThumbLength = 15
            OnChange = tb_spacingChange
          end
          object customfont: TSharpEFontSelector
            Left = 8
            Top = 40
            Width = 209
            Height = 21
            Flat = False
            FontBackground = sefbChecker
            ShadowEnabled = True
            AlphaEnabled = True
            BoldEnabled = True
            ItalicEnabled = True
            UnderlineEnabled = True
            CustomScheme = False
            Enabled = True
          end
          object cb_cfont: TCheckBox
            Left = 8
            Top = 16
            Width = 121
            Height = 17
            Caption = 'Use Custom Font'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = cb_cfontClick
          end
        end
        object dd_location: TComboBox
          Left = 56
          Top = 78
          Width = 169
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
        end
      end
      object Tab_Effects: TTabSheet
        Caption = 'Effects'
        ImageIndex = 1
        TabVisible = False
        object GroupBox7: TGroupBox
          Left = 8
          Top = 8
          Width = 353
          Height = 137
          Caption = 'Object Effects'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object cb_blend: TCheckBox
            Left = 10
            Top = 20
            Width = 191
            Height = 17
            Caption = 'Color Blend Icon: 0%'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = cb_blendClick
          end
          object tb_blend: TTrackBar
            Left = 4
            Top = 40
            Width = 325
            Height = 25
            Max = 255
            Frequency = 255
            TabOrder = 1
            ThumbLength = 15
            OnChange = tb_blendChange
          end
          object cb_AlphaBlend: TCheckBox
            Left = 10
            Top = 76
            Width = 129
            Height = 17
            Caption = 'Visibility: 0%'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = cb_AlphaBlendClick
          end
          object tb_alpha: TTrackBar
            Left = 4
            Top = 97
            Width = 325
            Height = 25
            Enabled = False
            Max = 255
            Min = 32
            Frequency = 255
            Position = 32
            TabOrder = 3
            ThumbLength = 15
            OnChange = tb_alphaChange
          end
        end
        object GroupBox6: TGroupBox
          Left = 8
          Top = 152
          Width = 353
          Height = 41
          Caption = 'Colors'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object Label4: TLabel
            Left = 44
            Top = 17
            Width = 41
            Height = 14
            Caption = 'Blending'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object cp_cblend: TSharpEColorBox
            Left = 8
            Top = 17
            Width = 35
            Height = 14
            Cursor = 15
            BackgroundColor = clBtnFace
            Color = 9145227
            ColorCode = -4
            CustomScheme = False
            ClickedColorID = ccWorkAreaBack
          end
        end
      end
      object tab_custom: TTabSheet
        Caption = 'Weather Format'
        ImageIndex = 2
        TabVisible = False
        object GroupBox1: TGroupBox
          Left = 8
          Top = 8
          Width = 353
          Height = 41
          Caption = 'Weather Format'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object rb_default: TRadioButton
            Left = 16
            Top = 16
            Width = 113
            Height = 17
            Caption = 'Default'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            TabStop = True
            OnClick = rb_defaultClick
          end
          object rb_custom: TRadioButton
            Left = 128
            Top = 16
            Width = 113
            Height = 17
            Caption = 'Custom'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = rb_customClick
          end
          object rb_wskin: TRadioButton
            Left = 232
            Top = 16
            Width = 113
            Height = 17
            Caption = 'Weather Skin'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = rb_wskinClick
          end
        end
        object Panel4: TPanel
          Left = 8
          Top = 56
          Width = 353
          Height = 233
          BevelInner = bvRaised
          BevelOuter = bvLowered
          Caption = 'Panel4'
          TabOrder = 1
          object PageControl2: TPageControl
            Left = 2
            Top = 2
            Width = 349
            Height = 229
            ActivePage = tab_wfCustom
            Align = alClient
            Style = tsFlatButtons
            TabOrder = 0
            object tab_wfCustom: TTabSheet
              Caption = 'tab_wfCustom'
              TabVisible = False
              OnShow = tab_wfCustomShow
              object Label2: TLabel
                Left = 8
                Top = 0
                Width = 345
                Height = 33
                AutoSize = False
                Caption = 
                  'Use the "add" button for a list of possible replacement tags.   ' +
                  '               For automatic text alignment use the {#} tag.'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                WordWrap = True
              end
              object Panel3: TPanel
                Left = 2
                Top = 38
                Width = 337
                Height = 179
                BevelOuter = bvNone
                TabOrder = 0
                object memo_custom: TMemo
                  Left = 0
                  Top = 21
                  Width = 337
                  Height = 158
                  Align = alClient
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Arial'
                  Font.Style = []
                  ParentFont = False
                  ScrollBars = ssBoth
                  TabOrder = 0
                  WordWrap = False
                end
                object toolbar_memo: TToolBar
                  Left = 0
                  Top = 0
                  Width = 337
                  Height = 21
                  ButtonWidth = 57
                  Caption = 'toolbar_memo'
                  EdgeBorders = []
                  Flat = True
                  Images = ImageList1
                  List = True
                  ShowCaptions = True
                  TabOrder = 1
                  object Action1: TToolButton
                    Left = 0
                    Top = 0
                    Caption = 'Add'
                    ImageIndex = 0
                    OnClick = Action1Execute
                  end
                  object FileOpen1: TToolButton
                    Left = 57
                    Top = 0
                    Caption = 'Import'
                    ImageIndex = 1
                    OnClick = FileOpen1Accept
                  end
                  object FileSaveAs1: TToolButton
                    Left = 114
                    Top = 0
                    Caption = 'Export'
                    ImageIndex = 2
                  end
                end
              end
            end
            object tab_wfDefault: TTabSheet
              Caption = 'tab_wfDefault'
              ImageIndex = 1
              TabVisible = False
              object cb_location: TCheckBox
                Left = 16
                Top = 16
                Width = 113
                Height = 17
                Caption = 'Location'
                Checked = True
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                State = cbChecked
                TabOrder = 0
                OnClick = cb_locationClick
              end
              object cb_detloc: TCheckBox
                Left = 16
                Top = 40
                Width = 113
                Height = 17
                Caption = 'Detailed Location'
                Checked = True
                Enabled = False
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                State = cbChecked
                TabOrder = 1
              end
              object cb_condition: TCheckBox
                Left = 16
                Top = 64
                Width = 113
                Height = 17
                Caption = 'Condition'
                Checked = True
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                State = cbChecked
                TabOrder = 2
              end
              object cb_temperature: TCheckBox
                Left = 16
                Top = 88
                Width = 113
                Height = 17
                Caption = 'Temperature'
                Checked = True
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                State = cbChecked
                TabOrder = 3
              end
              object cb_wind: TCheckBox
                Left = 16
                Top = 112
                Width = 113
                Height = 17
                Caption = 'Wind'
                Checked = True
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                State = cbChecked
                TabOrder = 4
              end
              object cb_icon: TCheckBox
                Left = 16
                Top = 160
                Width = 113
                Height = 17
                Caption = 'Display Icon'
                Checked = True
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                State = cbChecked
                TabOrder = 5
              end
            end
            object tab_wfwskin: TTabSheet
              Caption = 'tab_wfwskin'
              ImageIndex = 2
              TabVisible = False
              object lb_skinaut: TLabel
                Left = 136
                Top = 0
                Width = 74
                Height = 13
                Caption = 'Skin created by'
              end
              object lb_skinlist: TListBox
                Left = 8
                Top = 2
                Width = 121
                Height = 217
                ItemHeight = 13
                TabOrder = 0
                OnClick = lb_skinlistClick
              end
              object skinpreview: TImage32
                Left = 136
                Top = 16
                Width = 201
                Height = 201
                AutoSize = True
                Bitmap.ResamplerClassName = 'TNearestResampler'
                BitmapAlign = baCenter
                Scale = 1.000000000000000000
                ScaleMode = smNormal
                TabOrder = 1
              end
            end
          end
        end
      end
    end
  end
  object OpenIconDialog: TOpenDialog
    Filter = 'Images|*.ico;*.bmp;*.jpeg;*.jpg;*.png'
    Title = 'Select Icon'
    Left = 392
    Top = 32
  end
  object ColorPopup: TPopupMenu
    OwnerDraw = True
    Left = 272
    Top = 144
    object hrobberBack1: TMenuItem
      Caption = 'Throbber-Back'
      Hint = 'Throbber-Back'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object hrobberBottom1: TMenuItem
      Caption = 'Throbber-Bottom'
      Hint = 'Throbber-Bottom'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object hrobberTop1: TMenuItem
      Caption = 'Throbber-Top'
      Hint = 'Throbber-Top'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object WorkAreaBack1: TMenuItem
      Caption = 'WorkArea-Back'
      Hint = 'WorkArea-Back'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object WorkAreaBottom1: TMenuItem
      Caption = 'WorkArea-Bottom'
      Hint = 'WorkArea-Bottom'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object WorkAreaTop1: TMenuItem
      Caption = 'WorkArea-Top'
      Hint = 'WorkArea-Top'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object N1: TMenuItem
      Caption = '-'
      OnAdvancedDrawItem = N1AdvancedDrawItem
    end
    object Customcolor1: TMenuItem
      Caption = 'Custom color ...'
      Hint = 'Custom color ...'
      OnAdvancedDrawItem = hrobberBack1AdvancedDrawItem
    end
    object Pickcolor1: TMenuItem
      Caption = 'Pick color...'
      Visible = False
    end
  end
  object SelectColorDialog: TColorDialog
    Options = [cdAnyColor]
    Left = 328
    Top = 8
  end
  object pop_add: TPopupMenu
    Left = 288
    Top = 104
    object GlobalValues1: TMenuItem
      Caption = 'Global Values'
      object Location1: TMenuItem
        Caption = 'Location'
        object Name1: TMenuItem
          Caption = 'Name'
          Hint = '{#LOCATION#}'
          OnClick = Name1Click
        end
        object Long1: TMenuItem
          Caption = 'Longitude'
          Hint = '{#LONGITUDE#}'
          OnClick = Name1Click
        end
        object Latitute1: TMenuItem
          Caption = 'Latitute'
          Hint = '{#LATITUE#}'
          OnClick = Name1Click
        end
        object ObservationStation1: TMenuItem
          Caption = 'Observation Station'
          Hint = '{#OBSSTATION#}'
          OnClick = Name1Click
        end
        object imeZone1: TMenuItem
          Caption = 'Time Zone'
          Hint = '{#GMTOFFSET#}'
          OnClick = Name1Click
        end
      end
      object Moon1: TMenuItem
        Caption = 'Moon'
        object IconCode1: TMenuItem
          Caption = 'Icon (not implemented)'
          Hint = '{#MOONICON#}'
          OnClick = Name1Click
        end
        object MoonText1: TMenuItem
          Caption = 'Moon (Text)'
          Hint = '{#MOONTEXT#}'
          OnClick = Name1Click
        end
      end
      object Sundata1: TMenuItem
        Caption = 'Sun'
        object SunRise1: TMenuItem
          Caption = 'Sun Rise'
          Hint = '{#TIMESUNRISE#}'
          OnClick = Name1Click
        end
        object SunSet1: TMenuItem
          Caption = 'Sun Set'
          Hint = '{#TIMESUNSET#}'
          OnClick = Name1Click
        end
      end
      object Units1: TMenuItem
        Caption = 'Units'
        object Distance1: TMenuItem
          Caption = 'Distance'
          Hint = '{#UNITDIST#}'
          OnClick = Name1Click
        end
        object Pressure1: TMenuItem
          Caption = 'Pressure'
          Hint = '{#UNITPRESS#}'
          OnClick = Name1Click
        end
        object Speed1: TMenuItem
          Caption = 'Speed'
          Hint = '{#UNITSPEED#}'
          OnClick = Name1Click
        end
        object emperature1: TMenuItem
          Caption = 'Temperature'
          Hint = '{#UNITTEMP#}'
          OnClick = Name1Click
        end
        object UnitOfPrecip1: TMenuItem
          Caption = 'UnitOfPrecip'
          Hint = '{#UNITPRECIP#}'
          OnClick = Name1Click
        end
      end
    end
    object CurrentCondition1: TMenuItem
      Caption = 'Current Condition'
      object emperature2: TMenuItem
        Caption = 'Temperature'
        object FeelsLikeTemperature1: TMenuItem
          Caption = 'Feels Like Temperature'
          Hint = '{#TEMPFEELLIKE#}'
          OnClick = Name1Click
        end
        object Value1: TMenuItem
          Caption = 'Temperature'
          Hint = '{#TEMPERATURE#}'
          OnClick = Name1Click
        end
      end
      object Wind1: TMenuItem
        Caption = 'Wind'
        object DirectionDegr1: TMenuItem
          Caption = 'Direction (Degr.)'
          Hint = '{#WINDDIRDEGR#}'
          OnClick = Name1Click
        end
        object DirectionText1: TMenuItem
          Caption = 'Direction (Text)'
          Hint = '{#WINDDIRTEXT#}'
          OnClick = Name1Click
        end
        object MaxSpeed1: TMenuItem
          Caption = 'Max Speed'
          Hint = '{#MAXWINDSPEED#}'
          OnClick = Name1Click
        end
        object Speed2: TMenuItem
          Caption = 'Speed'
          Hint = '{#WINDSPEED#}'
          OnClick = Name1Click
        end
      end
      object BarometerPressure1: TMenuItem
        Caption = 'Barometer Pressure'
        object CurrentPressure1: TMenuItem
          Caption = 'Current Pressure'
          Hint = '{#BAROMPRESS#}'
          OnClick = Name1Click
        end
        object RaisorFallText1: TMenuItem
          Caption = 'Rais or Fall (Text)'
          Hint = '{#BAROMPRESSRF#}'
          OnClick = Name1Click
        end
      end
      object UV1: TMenuItem
        Caption = 'UV'
        object Value2: TMenuItem
          Caption = 'UV Value'
          Hint = '{#UV#}'
          OnClick = Name1Click
        end
        object UVValueText1: TMenuItem
          Caption = 'UV Value (Text)'
          Hint = '{#UVTEXT#}'
          OnClick = Name1Click
        end
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object ConditionText1: TMenuItem
        Caption = 'Condition'
        Hint = '{#CONDITION#}'
        OnClick = Name1Click
      end
      object Dewpoint1: TMenuItem
        Caption = 'Dewpoint'
        Hint = '{#DEWPOINT#}'
        OnClick = Name1Click
      end
      object Humidity1: TMenuItem
        Caption = 'Humidity'
        Hint = '{#HUMIDITY#}'
        OnClick = Name1Click
      end
      object Iconnotimplemented1: TMenuItem
        Caption = 'Icon (not implemented)'
        Hint = '{#ICON#}'
        OnClick = Name1Click
      end
      object LastUpdate1: TMenuItem
        Caption = 'Last Update'
        Hint = '{#LASTUPDATE#}'
        OnClick = Name1Click
      end
      object Visibility1: TMenuItem
        Caption = 'Visibility'
        Hint = '{#VISIBILITY#}'
        OnClick = Name1Click
      end
    end
    object Forecast1: TMenuItem
      Caption = 'Forecast'
      object Day11: TMenuItem
        Caption = 'Day 0'
        object Day1: TMenuItem
          Caption = 'Day'
          object Condition1: TMenuItem
            Caption = 'Condition'
            Hint = '{#FC_D0_DAY_CONDITION#}'
            OnClick = Name1Click
          end
          object DayIcon1: TMenuItem
            Caption = 'Icon'
            Hint = '{#FC_D0_DAY_DAYICON#}'
            OnClick = Name1Click
          end
          object Humidity2: TMenuItem
            Caption = 'Humidity'
            Hint = '{#FC_D0_DAY_HUMIDITY#}'
            OnClick = Name1Click
          end
          object precipitation1: TMenuItem
            Caption = 'Precipitation'
            Hint = '{#FC_D0_DAY_PRECIPITATION#}'
            OnClick = Name1Click
          end
          object WIND2: TMenuItem
            Caption = 'Wind'
            object DirectionDegr2: TMenuItem
              Caption = 'Direction (Degr.)'
              Hint = '{#FC_D0_DAY_WIND_DIRDEG#}'
              OnClick = Name1Click
            end
            object DirectionText2: TMenuItem
              Caption = 'Direction (Text)'
              Hint = '{#FC_D0_DAY_WIND_DIRTEXT#}'
              OnClick = Name1Click
            end
            object MaxSpeed2: TMenuItem
              Caption = 'Max Speed'
              Hint = '{#FC_D0_DAY_WIND_MAXSPEED#}'
              OnClick = Name1Click
            end
            object Speed3: TMenuItem
              Caption = 'Speed'
              Hint = '{#FC_D0_DAY_WIND_SPEED#}'
              OnClick = Name1Click
            end
          end
        end
        object Day2: TMenuItem
          Caption = 'Night'
          object Condition2: TMenuItem
            Caption = 'Condition'
            Hint = '{#FC_D0_NIGHT_CONDITION#}'
            OnClick = Name1Click
          end
          object Icon1: TMenuItem
            Caption = 'Icon'
            Hint = '{#FC_D0_NIGHT_DAYICON#}'
            OnClick = Name1Click
          end
          object Humidity3: TMenuItem
            Caption = 'Humidity'
            Hint = '{#FC_D0_NIGHT_HUMIDITY#}'
            OnClick = Name1Click
          end
          object Precipitation2: TMenuItem
            Caption = 'Precipitation'
            Hint = '{#FC_D0_NIGHT_PRECIPITATION#}'
            OnClick = Name1Click
          end
          object Wind4: TMenuItem
            Caption = 'Wind'
            object DirectionDegr3: TMenuItem
              Caption = 'Direction (Degr.)'
              Hint = '{#FC_D0_NIGHT_WIND_DIRDEG#}'
              OnClick = Name1Click
            end
            object DirectionText3: TMenuItem
              Caption = 'Direction (Text)'
              Hint = '{#FC_D0_NIGHT_WIND_DIRTEXT#}'
              OnClick = Name1Click
            end
            object MaxSpeed3: TMenuItem
              Caption = 'Max Speed'
              Hint = '{#FC_D0_NIGHT_WIND_MAXSPEED#}'
              OnClick = Name1Click
            end
            object Speed4: TMenuItem
              Caption = 'Speed'
              Hint = '{#FC_D0_NIGHT_WIND_SPEED#}'
              OnClick = Name1Click
            end
          end
        end
        object N4: TMenuItem
          Caption = '-'
        end
        object DayName1: TMenuItem
          Caption = 'Day Name'
          Hint = '{#FC_D0_DAYTEXT#}'
          OnClick = Name1Click
        end
        object Date1: TMenuItem
          Caption = 'Date'
          Hint = '{#FC_D0_DATE#}'
          OnClick = Name1Click
        end
        object HighestTemperature1: TMenuItem
          Caption = 'Highest Temperature'
          Hint = '{#FC_D0_HIGHTEMP#}'
          OnClick = Name1Click
        end
        object LowestTemperature1: TMenuItem
          Caption = 'Lowest Temperature'
          Hint = '{#FC_D0_LOWTEMP#}'
          OnClick = Name1Click
        end
        object imeSunset1: TMenuItem
          Caption = 'Sun Set'
          Hint = '{#FC_D0_TIMESUNSET#}'
          OnClick = Name1Click
        end
        object SunRise2: TMenuItem
          Caption = 'Sun Rise'
          Hint = '{#FC_D0_TIMESUNRISE#}'
          OnClick = Name1Click
        end
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object LastUpdate2: TMenuItem
        Caption = 'Last Update'
        Hint = '{#FC_LASTUPDATE#}'
        OnClick = Name1Click
      end
    end
  end
  object ImageList1: TImageList
    Left = 320
    Top = 128
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000402020000000000000000000000000000000000000000000000000004020
      2000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009F9F9F009F9F9F009F9F9F009F9F9F00000000000000
      0000000000000000000000000000000000000000000000000000404040008080
      600080808000C0DCC000A4A0A000A4A0A000A4A0A00080808000806060004040
      2000808080004040400000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F1F1F100C5C5C500C5C5C5009F9F9F00000000000000
      0000000000000000000000000000000000000000000000000000C0A0A000C0A0
      8000C0C0A000F0FBFF004040400080806000C0C0C000C0C0C000808080004040
      2000A4A0A000808060000000000000000000000000000000000071767600DAE9
      E700BDD3D1009DBFBB009DBFBB009DBFBB009DBFBB009DBFBB009DBFBB00809B
      98005C716E000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F1F1F100C5C5C500C5C5C5009F9F9F00000000000000
      0000000000000000000000000000000000000000000000000000F0FBFF00C0A0
      8000C0C0A000C0DCC0004040200080604000C0DCC000C0C0C000808080004040
      2000A4A0A00080606000000000000000000000000000000000008D999700E2EF
      ED00ACD2CD00ACD2CD00ACD2CD00ACD2CD00ACD2CD00ACD2CD00ACD2CD00ACD2
      CD0088A6A2000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F1F1F100C5C5C500C5C5C5009F9F9F00000000000000
      0000000000000000000000000000000000000000000000000000F0FBFF00C0A0
      8000C0A0A000C0C0C000A4A0A000A4A0A000F0FBFF00C0C0C000808060008060
      4000A4A0A00080606000000000000000000000000000000000007B8180008D96
      9600D1E5E300ACD2CD00ACD2CD00ACD2CD00ACD2CD00ACD2CD00ACD2CD00ACD2
      CD00ACD2CD006D86830000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F1F1F1009F9F
      9F009F9F9F009F9F9F00F1F1F100C5C5C500C5C5C5009F9F9F009F9F9F009F9F
      9F009F9F9F009F9F9F0000000000000000000000000000000000F0FBFF00C0A0
      8000C0A08000C0A08000C0A08000C0A08000C0A08000C0A08000C0808000C080
      8000C0A0800080606000000000000000000000000000000000009AA19F001F26
      2500E5F0EF00BBDAD600ACD2CD00ACD2CD00ACD2CD00ACD2CD00ACD2CD00ACD2
      CD00ACD2CD0084A29E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F1F1F100C5C5
      C500C5C5C500C5C5C500C5C5C500C5C5C500C5C5C500C5C5C500C5C5C500C5C5
      C500C5C5C5009F9F9F0000000000000000000000000000000000F0FBFF00C0A0
      A000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      A000C0A080008060600000000000000000000000000000000000BEC7C6005261
      5F0080898800C7E0DD00ACD2CD00ACD2CD00ACD2CD00ACD2CD00ACD2CD00ACD2
      CD00ACD2CD008CABA700708A8700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F1F1F100C5C5
      C500C5C5C500C5C5C500C5C5C500C5C5C500C5C5C500C5C5C500C5C5C500C5C5
      C500C5C5C5009F9F9F0000000000000000000000000000000000F0CAA600C0C0
      A000FFFFFF00FFFFFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00C0C0A0008060600000000000000000000000000000000000BEC6C6007286
      84001F262500E9F2F100C7E0DD00BBDAD600ACD2CD00ACD2CD00ACD2CD00ACD2
      CD00ACD2CD00A7CCC700809C9800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F1F1F100F1F1
      F100F1F1F100F1F1F100F1F1F100C5C5C500C5C5C500F1F1F100F1F1F100F1F1
      F100F1F1F1009F9F9F0000000000000000000000000000000000F0FBFF00C0C0
      A000C0DCC000C0DCC000C0DCC000C0DCC000C0C0C000C0C0C000C0C0C000F0FB
      FF00C0C0A0008060600000000000000000000000000000000000F7F7F700758A
      8700586866003F4D4B00404F4D00354140003743420037434200374443003642
      4000323D3C003C494800161A1A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F1F1F100C5C5C500C5C5C5009F9F9F00000000000000
      0000000000000000000000000000000000000000000000000000F0FBFF00C0C0
      A000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00C0C0A0008060600000000000000000000000000000000000DBECEA007D8C
      8A007B918E007F9491007A8E8B00879B990080949100869B980080949100A2B4
      B10094A3A2000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F1F1F100C5C5C500C5C5C5009F9F9F00000000000000
      0000000000000000000000000000000000000000000000000000F0CAA600C0C0
      A000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00FFFF
      FF00C0C0A0008060600000000000000000000000000000000000F0F6F5007B90
      8D007E9592007D939000849B97005F706D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F1F1F100C5C5C500C5C5C5009F9F9F00000000000000
      0000000000000000000000000000000000000000000000000000F0FBFF00A4A0
      A00080A0E00080A0E00080A0E00080A0E00080A0E00080A0E00080A0E00080A0
      E000C0A0A000806060000000000000000000000000000000000000000000DFE5
      E400CBD6D500CAD7D6009DA3A300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F1F1F100F1F1F100F1F1F100F1F1F100000000000000
      0000000000000000000000000000000000000000000000000000C0DCC000C0C0
      C0008080E00080A0E00080A0E00080A0E00080A0E00080A0E00080A0E0008080
      E000C0C0C000F0CAA60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000F81FC003FFFF0000
      F81F8001C0070000F81F800180030000F81F8001800300008001800180010000
      8001800180010000800180018000000080018001800000008001800180010000
      8001800180030000F81F800180070000F81F8001C0FF0000F81F8001E1FF0000
      F81FC003FFFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 336
    Top = 40
  end
  object OpenDialog1: TOpenDialog
    Filter = 'SharpE weather format|.sweather'
    Left = 272
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    Filter = 'SharpE weather format|.sweather'
    Left = 240
    Top = 8
  end
end
