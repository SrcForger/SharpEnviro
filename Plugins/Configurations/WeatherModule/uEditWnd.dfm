object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsNone
  Caption = 'Edit'
  ClientHeight = 273
  ClientWidth = 519
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
  object pnlOptions: TPanel
    Left = 0
    Top = 0
    Width = 519
    Height = 273
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object lblWeatherLocation: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 503
      Height = 13
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Weather Location'
      ExplicitWidth = 85
    end
    object lblWeatherLocationDesc: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 29
      Width = 485
      Height = 13
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Define which location you want to use for this module'
      Transparent = False
      ExplicitWidth = 256
    end
    object lblDisplayOptions: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 79
      Width = 503
      Height = 13
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Display Options'
      ExplicitWidth = 74
    end
    object lblLabels: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 148
      Width = 503
      Height = 13
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Labels'
      ExplicitWidth = 30
    end
    object lblLabelDesc: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 169
      Width = 485
      Height = 13
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Define the text that is displayed in the labels'
      Transparent = False
      ExplicitWidth = 214
    end
    object lblDisplayDesc: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 100
      Width = 485
      Height = 13
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Define icon and text options'
      Transparent = False
      ExplicitWidth = 135
    end
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 26
      Top = 50
      Width = 485
      Height = 21
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object lblLocation: TLabel
        Left = 0
        Top = 4
        Width = 47
        Height = 13
        Caption = 'Location: '
      end
      object cbLocation: TComboBox
        AlignWithMargins = True
        Left = 58
        Top = 0
        Width = 294
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 0
        Style = csDropDownList
        Constraints.MaxWidth = 300
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Default'
        OnChange = SettingsChange
        Items.Strings = (
          'Default'
          'Compact'
          'Minimal')
      end
    end
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 26
      Top = 121
      Width = 485
      Height = 19
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object chkDisplayIcon: TCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 94
        Height = 17
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Caption = 'Display Icon'
        TabOrder = 0
        OnClick = SettingsChange
      end
      object chkDisplayLabels: TCheckBox
        AlignWithMargins = True
        Left = 100
        Top = 0
        Width = 105
        Height = 17
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Caption = 'Display Labels'
        TabOrder = 1
        OnClick = SettingsChange
      end
    end
    object Panel3: TPanel
      AlignWithMargins = True
      Left = 26
      Top = 190
      Width = 485
      Height = 22
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 2
      object lblTop: TLabel
        Left = 0
        Top = 5
        Width = 22
        Height = 13
        Caption = 'Top:'
      end
      object edtTopLabel: TEdit
        AlignWithMargins = True
        Left = 52
        Top = 1
        Width = 300
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 0
        Constraints.MaxWidth = 300
        TabOrder = 0
        Text = 'Temperature: {#TEMPERATURE#}'#176'{#UNITTEMP#}'
        OnChange = SettingsChange
      end
      object btnBrowseTop: TButton
        Left = 356
        Top = 0
        Width = 37
        Height = 22
        Caption = '...'
        TabOrder = 1
        OnClick = btnBrowseClick
      end
    end
    object Panel4: TPanel
      AlignWithMargins = True
      Left = 26
      Top = 220
      Width = 485
      Height = 21
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 3
      object lblBottom: TLabel
        Left = 0
        Top = 4
        Width = 38
        Height = 13
        Caption = 'Bottom:'
      end
      object edtBottomLabel: TEdit
        AlignWithMargins = True
        Left = 52
        Top = 0
        Width = 300
        Height = 21
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 0
        Constraints.MaxWidth = 300
        TabOrder = 0
        Text = 'Condition: {#CONDITION#}'
        OnChange = SettingsChange
      end
      object btnBrowseBottom: TButton
        Left = 356
        Top = 0
        Width = 37
        Height = 21
        Caption = '...'
        TabOrder = 1
        OnClick = btnBrowseClick
      end
    end
  end
  object mnuTags: TPopupMenu
    Left = 296
    Top = 8
    object GlobalValues1: TMenuItem
      Caption = 'Global Values'
      object Location1: TMenuItem
        Caption = 'Location'
        object Name1: TMenuItem
          Caption = 'Name'
          Hint = '{#LOCATION#}'
          OnClick = miTagClick
        end
        object Long1: TMenuItem
          Caption = 'Longitude'
          Hint = '{#LONGITUDE#}'
          OnClick = miTagClick
        end
        object Latitute1: TMenuItem
          Caption = 'Latitute'
          Hint = '{#LATITUE#}'
          OnClick = miTagClick
        end
        object ObservationStation1: TMenuItem
          Caption = 'Observation Station'
          Hint = '{#OBSSTATION#}'
          OnClick = miTagClick
        end
        object imeZone1: TMenuItem
          Caption = 'Time Zone'
          Hint = '{#GMTOFFSET#}'
          OnClick = miTagClick
        end
      end
      object Moon1: TMenuItem
        Caption = 'Moon'
        object IconCode1: TMenuItem
          Caption = 'Icon (not implemented)'
          Hint = '{#MOONICON#}'
          Visible = False
          OnClick = miTagClick
        end
        object MoonText1: TMenuItem
          Caption = 'Moon (Text)'
          Hint = '{#MOONTEXT#}'
          OnClick = miTagClick
        end
      end
      object Sundata1: TMenuItem
        Caption = 'Sun'
        object SunRise1: TMenuItem
          Caption = 'Sun Rise'
          Hint = '{#TIMESUNRISE#}'
          OnClick = miTagClick
        end
        object SunSet1: TMenuItem
          Caption = 'Sun Set'
          Hint = '{#TIMESUNSET#}'
          OnClick = miTagClick
        end
      end
      object Units1: TMenuItem
        Caption = 'Units'
        object Distance1: TMenuItem
          Caption = 'Distance'
          Hint = '{#UNITDIST#}'
          OnClick = miTagClick
        end
        object Pressure1: TMenuItem
          Caption = 'Pressure'
          Hint = '{#UNITPRESS#}'
          OnClick = miTagClick
        end
        object Speed1: TMenuItem
          Caption = 'Speed'
          Hint = '{#UNITSPEED#}'
          OnClick = miTagClick
        end
        object emperature1: TMenuItem
          Caption = 'Temperature'
          Hint = '{#UNITTEMP#}'
          OnClick = miTagClick
        end
        object UnitOfPrecip1: TMenuItem
          Caption = 'UnitOfPrecip'
          Hint = '{#UNITPRECIP#}'
          OnClick = miTagClick
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
          OnClick = miTagClick
        end
        object Value1: TMenuItem
          Caption = 'Temperature'
          Hint = '{#TEMPERATURE#}'
          OnClick = miTagClick
        end
      end
      object Wind1: TMenuItem
        Caption = 'Wind'
        object DirectionDegr1: TMenuItem
          Caption = 'Direction (Degr.)'
          Hint = '{#WINDDIRDEGR#}'
          OnClick = miTagClick
        end
        object DirectionText1: TMenuItem
          Caption = 'Direction (Text)'
          Hint = '{#WINDDIRTEXT#}'
          OnClick = miTagClick
        end
        object MaxSpeed1: TMenuItem
          Caption = 'Max Speed'
          Hint = '{#MAXWINDSPEED#}'
          OnClick = miTagClick
        end
        object Speed2: TMenuItem
          Caption = 'Speed'
          Hint = '{#WINDSPEED#}'
          OnClick = miTagClick
        end
      end
      object BarometerPressure1: TMenuItem
        Caption = 'Barometer Pressure'
        object CurrentPressure1: TMenuItem
          Caption = 'Current Pressure'
          Hint = '{#BAROMPRESS#}'
          OnClick = miTagClick
        end
        object RaisorFallText1: TMenuItem
          Caption = 'Rais or Fall (Text)'
          Hint = '{#BAROMPRESSRF#}'
          OnClick = miTagClick
        end
      end
      object UV1: TMenuItem
        Caption = 'UV'
        object Value2: TMenuItem
          Caption = 'UV Value'
          Hint = '{#UV#}'
          OnClick = miTagClick
        end
        object UVValueText1: TMenuItem
          Caption = 'UV Value (Text)'
          Hint = '{#UVTEXT#}'
          OnClick = miTagClick
        end
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object ConditionText1: TMenuItem
        Caption = 'Condition'
        Hint = '{#CONDITION#}'
        OnClick = miTagClick
      end
      object Dewpoint1: TMenuItem
        Caption = 'Dewpoint'
        Hint = '{#DEWPOINT#}'
        OnClick = miTagClick
      end
      object Humidity1: TMenuItem
        Caption = 'Humidity'
        Hint = '{#HUMIDITY#}'
        OnClick = miTagClick
      end
      object LastUpdate1: TMenuItem
        Caption = 'Last Update'
        Hint = '{#LASTUPDATE#}'
        OnClick = miTagClick
      end
      object Visibility1: TMenuItem
        Caption = 'Visibility'
        Hint = '{#VISIBILITY#}'
        OnClick = miTagClick
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
            OnClick = miTagClick
          end
          object DayIcon1: TMenuItem
            Caption = 'Icon'
            Hint = '{#FC_D0_DAY_DAYICON#}'
            OnClick = miTagClick
          end
          object Humidity2: TMenuItem
            Caption = 'Humidity'
            Hint = '{#FC_D0_DAY_HUMIDITY#}'
            OnClick = miTagClick
          end
          object precipitation1: TMenuItem
            Caption = 'Precipitation'
            Hint = '{#FC_D0_DAY_PRECIPITATION#}'
            OnClick = miTagClick
          end
          object WIND2: TMenuItem
            Caption = 'Wind'
            object DirectionDegr2: TMenuItem
              Caption = 'Direction (Degr.)'
              Hint = '{#FC_D0_DAY_WIND_DIRDEG#}'
              OnClick = miTagClick
            end
            object DirectionText2: TMenuItem
              Caption = 'Direction (Text)'
              Hint = '{#FC_D0_DAY_WIND_DIRTEXT#}'
              OnClick = miTagClick
            end
            object MaxSpeed2: TMenuItem
              Caption = 'Max Speed'
              Hint = '{#FC_D0_DAY_WIND_MAXSPEED#}'
              OnClick = miTagClick
            end
            object Speed3: TMenuItem
              Caption = 'Speed'
              Hint = '{#FC_D0_DAY_WIND_SPEED#}'
              OnClick = miTagClick
            end
          end
        end
        object Day2: TMenuItem
          Caption = 'Night'
          object Condition2: TMenuItem
            Caption = 'Condition'
            Hint = '{#FC_D0_NIGHT_CONDITION#}'
            OnClick = miTagClick
          end
          object Icon1: TMenuItem
            Caption = 'Icon'
            Hint = '{#FC_D0_NIGHT_DAYICON#}'
            OnClick = miTagClick
          end
          object Humidity3: TMenuItem
            Caption = 'Humidity'
            Hint = '{#FC_D0_NIGHT_HUMIDITY#}'
            OnClick = miTagClick
          end
          object Precipitation2: TMenuItem
            Caption = 'Precipitation'
            Hint = '{#FC_D0_NIGHT_PRECIPITATION#}'
            OnClick = miTagClick
          end
          object Wind4: TMenuItem
            Caption = 'Wind'
            object DirectionDegr3: TMenuItem
              Caption = 'Direction (Degr.)'
              Hint = '{#FC_D0_NIGHT_WIND_DIRDEG#}'
              OnClick = miTagClick
            end
            object DirectionText3: TMenuItem
              Caption = 'Direction (Text)'
              Hint = '{#FC_D0_NIGHT_WIND_DIRTEXT#}'
              OnClick = miTagClick
            end
            object MaxSpeed3: TMenuItem
              Caption = 'Max Speed'
              Hint = '{#FC_D0_NIGHT_WIND_MAXSPEED#}'
              OnClick = miTagClick
            end
            object Speed4: TMenuItem
              Caption = 'Speed'
              Hint = '{#FC_D0_NIGHT_WIND_SPEED#}'
              OnClick = miTagClick
            end
          end
        end
        object N4: TMenuItem
          Caption = '-'
        end
        object DayName1: TMenuItem
          Caption = 'Day Name'
          Hint = '{#FC_D0_DAYTEXT#}'
          OnClick = miTagClick
        end
        object Date1: TMenuItem
          Caption = 'Date'
          Hint = '{#FC_D0_DATE#}'
          OnClick = miTagClick
        end
        object HighestTemperature1: TMenuItem
          Caption = 'Highest Temperature'
          Hint = '{#FC_D0_HIGHTEMP#}'
          OnClick = miTagClick
        end
        object LowestTemperature1: TMenuItem
          Caption = 'Lowest Temperature'
          Hint = '{#FC_D0_LOWTEMP#}'
          OnClick = miTagClick
        end
        object imeSunset1: TMenuItem
          Caption = 'Sun Set'
          Hint = '{#FC_D0_TIMESUNSET#}'
          OnClick = miTagClick
        end
        object SunRise2: TMenuItem
          Caption = 'Sun Rise'
          Hint = '{#FC_D0_TIMESUNRISE#}'
          OnClick = miTagClick
        end
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object LastUpdate2: TMenuItem
        Caption = 'Last Update'
        Hint = '{#FC_LASTUPDATE#}'
        OnClick = miTagClick
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Examples1: TMenuItem
      Caption = 'Examples'
      object Condition3: TMenuItem
        Caption = 'Condition: Light Rain'
        Hint = 'Condition: {#CONDITION#}'
        OnClick = miExampleClick
      end
      object emperature21C1: TMenuItem
        Caption = 'Temperature: 21'#176'C'
        Hint = 'Temperature: {#TEMPERATURE#}'#176'{#UNITTEMP#}'
        OnClick = miExampleClick
      end
      object WindSpeed1: TMenuItem
        Caption = 'Wind Speed: 10 km/h'
        Hint = 'Wind Speed: {#WINDSPEED#} {#UNITSPEED#}'
        OnClick = miExampleClick
      end
    end
  end
end
