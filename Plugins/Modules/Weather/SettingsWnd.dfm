object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Weather Settings'
  ClientHeight = 231
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 40
    Height = 13
    Caption = 'Location'
  end
  object lb_top: TLabel
    Left = 8
    Top = 104
    Width = 46
    Height = 13
    Caption = 'Top Label'
  end
  object lb_bottom: TLabel
    Left = 8
    Top = 152
    Width = 232
    Height = 13
    Caption = 'Bottom Label (leave empty to only use top label)'
  end
  object Button1: TButton
    Left = 176
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 256
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object cb_showicon: TCheckBox
    Left = 8
    Top = 56
    Width = 97
    Height = 17
    Caption = 'Display Icon'
    TabOrder = 2
  end
  object cb_info: TCheckBox
    Left = 8
    Top = 80
    Width = 113
    Height = 17
    Caption = 'Display Info Label'
    TabOrder = 3
    OnClick = cb_infoClick
  end
  object dd_location: TComboBox
    Left = 8
    Top = 24
    Width = 217
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
  object edit_top: TEdit
    Left = 8
    Top = 120
    Width = 289
    Height = 21
    TabOrder = 5
    Text = 'Temperature: {#TEMPERATURE#}'#176'{#UNITTEMP#}'
  end
  object edit_bottom: TEdit
    Left = 8
    Top = 168
    Width = 289
    Height = 21
    TabOrder = 6
    Text = 'Condition: {#CONDITION#}'
  end
  object btn_addtop: TButton
    Left = 304
    Top = 120
    Width = 25
    Height = 21
    Caption = '...'
    TabOrder = 7
    OnClick = btn_addtopClick
  end
  object btn_addbottom: TButton
    Left = 304
    Top = 168
    Width = 25
    Height = 21
    Caption = '...'
    TabOrder = 8
    OnClick = btn_addbottomClick
  end
  object OpenFile: TOpenDialog
    FileName = '*.*'
    Filter = 'All Files|*.*|Applications (*.exe)|*.exe'
    Options = [ofHideReadOnly, ofEnableSizing, ofForceShowHidden]
    Title = 'Select Target File'
    Left = 264
    Top = 8
  end
  object pop_add: TPopupMenu
    Left = 296
    Top = 8
    object GlobalValues1: TMenuItem
      Caption = 'Global Values'
      object Location1: TMenuItem
        Caption = 'Location'
        object Name1: TMenuItem
          Caption = 'Name'
          Hint = '{#LOCATION#}'
          OnClick = Condition3Click
        end
        object Long1: TMenuItem
          Caption = 'Longitude'
          Hint = '{#LONGITUDE#}'
          OnClick = Condition3Click
        end
        object Latitute1: TMenuItem
          Caption = 'Latitute'
          Hint = '{#LATITUE#}'
          OnClick = Condition3Click
        end
        object ObservationStation1: TMenuItem
          Caption = 'Observation Station'
          Hint = '{#OBSSTATION#}'
          OnClick = Condition3Click
        end
        object imeZone1: TMenuItem
          Caption = 'Time Zone'
          Hint = '{#GMTOFFSET#}'
          OnClick = Condition3Click
        end
      end
      object Moon1: TMenuItem
        Caption = 'Moon'
        object IconCode1: TMenuItem
          Caption = 'Icon (not implemented)'
          Hint = '{#MOONICON#}'
          OnClick = Condition3Click
        end
        object MoonText1: TMenuItem
          Caption = 'Moon (Text)'
          Hint = '{#MOONTEXT#}'
          OnClick = Condition3Click
        end
      end
      object Sundata1: TMenuItem
        Caption = 'Sun'
        object SunRise1: TMenuItem
          Caption = 'Sun Rise'
          Hint = '{#TIMESUNRISE#}'
          OnClick = Condition3Click
        end
        object SunSet1: TMenuItem
          Caption = 'Sun Set'
          Hint = '{#TIMESUNSET#}'
          OnClick = Condition3Click
        end
      end
      object Units1: TMenuItem
        Caption = 'Units'
        object Distance1: TMenuItem
          Caption = 'Distance'
          Hint = '{#UNITDIST#}'
          OnClick = Condition3Click
        end
        object Pressure1: TMenuItem
          Caption = 'Pressure'
          Hint = '{#UNITPRESS#}'
          OnClick = Condition3Click
        end
        object Speed1: TMenuItem
          Caption = 'Speed'
          Hint = '{#UNITSPEED#}'
          OnClick = Condition3Click
        end
        object emperature1: TMenuItem
          Caption = 'Temperature'
          Hint = '{#UNITTEMP#}'
          OnClick = Condition3Click
        end
        object UnitOfPrecip1: TMenuItem
          Caption = 'UnitOfPrecip'
          Hint = '{#UNITPRECIP#}'
          OnClick = Condition3Click
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
          OnClick = Condition3Click
        end
        object Value1: TMenuItem
          Caption = 'Temperature'
          Hint = '{#TEMPERATURE#}'
          OnClick = Condition3Click
        end
      end
      object Wind1: TMenuItem
        Caption = 'Wind'
        object DirectionDegr1: TMenuItem
          Caption = 'Direction (Degr.)'
          Hint = '{#WINDDIRDEGR#}'
          OnClick = Condition3Click
        end
        object DirectionText1: TMenuItem
          Caption = 'Direction (Text)'
          Hint = '{#WINDDIRTEXT#}'
          OnClick = Condition3Click
        end
        object MaxSpeed1: TMenuItem
          Caption = 'Max Speed'
          Hint = '{#MAXWINDSPEED#}'
          OnClick = Condition3Click
        end
        object Speed2: TMenuItem
          Caption = 'Speed'
          Hint = '{#WINDSPEED#}'
          OnClick = Condition3Click
        end
      end
      object BarometerPressure1: TMenuItem
        Caption = 'Barometer Pressure'
        object CurrentPressure1: TMenuItem
          Caption = 'Current Pressure'
          Hint = '{#BAROMPRESS#}'
          OnClick = Condition3Click
        end
        object RaisorFallText1: TMenuItem
          Caption = 'Rais or Fall (Text)'
          Hint = '{#BAROMPRESSRF#}'
          OnClick = Condition3Click
        end
      end
      object UV1: TMenuItem
        Caption = 'UV'
        object Value2: TMenuItem
          Caption = 'UV Value'
          Hint = '{#UV#}'
          OnClick = Condition3Click
        end
        object UVValueText1: TMenuItem
          Caption = 'UV Value (Text)'
          Hint = '{#UVTEXT#}'
          OnClick = Condition3Click
        end
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object ConditionText1: TMenuItem
        Caption = 'Condition'
        Hint = '{#CONDITION#}'
        OnClick = Condition3Click
      end
      object Dewpoint1: TMenuItem
        Caption = 'Dewpoint'
        Hint = '{#DEWPOINT#}'
        OnClick = Condition3Click
      end
      object Humidity1: TMenuItem
        Caption = 'Humidity'
        Hint = '{#HUMIDITY#}'
        OnClick = Condition3Click
      end
      object LastUpdate1: TMenuItem
        Caption = 'Last Update'
        Hint = '{#LASTUPDATE#}'
        OnClick = Condition3Click
      end
      object Visibility1: TMenuItem
        Caption = 'Visibility'
        Hint = '{#VISIBILITY#}'
        OnClick = Condition3Click
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
            OnClick = Condition3Click
          end
          object DayIcon1: TMenuItem
            Caption = 'Icon'
            Hint = '{#FC_D0_DAY_DAYICON#}'
            OnClick = Condition3Click
          end
          object Humidity2: TMenuItem
            Caption = 'Humidity'
            Hint = '{#FC_D0_DAY_HUMIDITY#}'
            OnClick = Condition3Click
          end
          object precipitation1: TMenuItem
            Caption = 'Precipitation'
            Hint = '{#FC_D0_DAY_PRECIPITATION#}'
            OnClick = Condition3Click
          end
          object WIND2: TMenuItem
            Caption = 'Wind'
            object DirectionDegr2: TMenuItem
              Caption = 'Direction (Degr.)'
              Hint = '{#FC_D0_DAY_WIND_DIRDEG#}'
              OnClick = Condition3Click
            end
            object DirectionText2: TMenuItem
              Caption = 'Direction (Text)'
              Hint = '{#FC_D0_DAY_WIND_DIRTEXT#}'
              OnClick = Condition3Click
            end
            object MaxSpeed2: TMenuItem
              Caption = 'Max Speed'
              Hint = '{#FC_D0_DAY_WIND_MAXSPEED#}'
              OnClick = Condition3Click
            end
            object Speed3: TMenuItem
              Caption = 'Speed'
              Hint = '{#FC_D0_DAY_WIND_SPEED#}'
              OnClick = Condition3Click
            end
          end
        end
        object Day2: TMenuItem
          Caption = 'Night'
          object Condition2: TMenuItem
            Caption = 'Condition'
            Hint = '{#FC_D0_NIGHT_CONDITION#}'
            OnClick = Condition3Click
          end
          object Icon1: TMenuItem
            Caption = 'Icon'
            Hint = '{#FC_D0_NIGHT_DAYICON#}'
            OnClick = Condition3Click
          end
          object Humidity3: TMenuItem
            Caption = 'Humidity'
            Hint = '{#FC_D0_NIGHT_HUMIDITY#}'
            OnClick = Condition3Click
          end
          object Precipitation2: TMenuItem
            Caption = 'Precipitation'
            Hint = '{#FC_D0_NIGHT_PRECIPITATION#}'
            OnClick = Condition3Click
          end
          object Wind4: TMenuItem
            Caption = 'Wind'
            object DirectionDegr3: TMenuItem
              Caption = 'Direction (Degr.)'
              Hint = '{#FC_D0_NIGHT_WIND_DIRDEG#}'
              OnClick = Condition3Click
            end
            object DirectionText3: TMenuItem
              Caption = 'Direction (Text)'
              Hint = '{#FC_D0_NIGHT_WIND_DIRTEXT#}'
              OnClick = Condition3Click
            end
            object MaxSpeed3: TMenuItem
              Caption = 'Max Speed'
              Hint = '{#FC_D0_NIGHT_WIND_MAXSPEED#}'
              OnClick = Condition3Click
            end
            object Speed4: TMenuItem
              Caption = 'Speed'
              Hint = '{#FC_D0_NIGHT_WIND_SPEED#}'
              OnClick = Condition3Click
            end
          end
        end
        object N4: TMenuItem
          Caption = '-'
        end
        object DayName1: TMenuItem
          Caption = 'Day Name'
          Hint = '{#FC_D0_DAYTEXT#}'
          OnClick = Condition3Click
        end
        object Date1: TMenuItem
          Caption = 'Date'
          Hint = '{#FC_D0_DATE#}'
          OnClick = Condition3Click
        end
        object HighestTemperature1: TMenuItem
          Caption = 'Highest Temperature'
          Hint = '{#FC_D0_HIGHTEMP#}'
          OnClick = Condition3Click
        end
        object LowestTemperature1: TMenuItem
          Caption = 'Lowest Temperature'
          Hint = '{#FC_D0_LOWTEMP#}'
          OnClick = Condition3Click
        end
        object imeSunset1: TMenuItem
          Caption = 'Sun Set'
          Hint = '{#FC_D0_TIMESUNSET#}'
          OnClick = Condition3Click
        end
        object SunRise2: TMenuItem
          Caption = 'Sun Rise'
          Hint = '{#FC_D0_TIMESUNRISE#}'
          OnClick = Condition3Click
        end
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object LastUpdate2: TMenuItem
        Caption = 'Last Update'
        Hint = '{#FC_LASTUPDATE#}'
        OnClick = Condition3Click
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
        OnClick = WindSpeed1Click
      end
      object emperature21C1: TMenuItem
        Caption = 'Temperature: 21'#176'C'
        Hint = 'Temperature: {#TEMPERATURE#}'#176'{#UNITTEMP#}'
        OnClick = WindSpeed1Click
      end
      object WindSpeed1: TMenuItem
        Caption = 'Wind Speed: 10 km/h'
        Hint = 'Wind Speed: {#WINDSPEED#} {#UNITSPEED#}'
        OnClick = WindSpeed1Click
      end
    end
  end
end
