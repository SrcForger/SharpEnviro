object QuickHelpForm: TQuickHelpForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'SharpSkin: Quick Help'
  ClientHeight = 379
  ClientWidth = 538
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
  object help: TMemo
    Left = 0
    Top = 0
    Width = 538
    Height = 344
    Align = alClient
    Lines.Strings = (
      'SharpSkin - Quick Help'
      '~~~~~~~~~~~~~~~~~~~'
      
        'GUI application for creating SharpE Skins much easier and faster' +
        '.'
      ''
      ''
      'Notes'
      '~~~~'
      
        '- A basic understanding of how XML is working is necessary to us' +
        'e this application'
      '- Saving is only possible when the "Plain XML" tab is activated'
      
        '- Make sure all components got merged correctly in the "Plain XM' +
        'L" tab before saving!'
      
        '- Rendering the bar background sometimes doesn'#39't work (click the' +
        ' render button twice)'
      
        '- When using "Render" in another than the "Plain XML" tab this w' +
        'ill only update the current component!'
      
        '- The undo function sometimes might work a bit strange (there is' +
        ' no redo...)'
      
        '- Manually create backups of your XML files from time to time (y' +
        'ou never know what might happen ;) )'
      
        '- Nobody has to use this application! If you prefer hacking arou' +
        'nd in plain XML with notepad do this :)'
      
        '- As always: keep in mind that this is an alpha/beta/whatever te' +
        'st version :)'
      ''
      ''
      'Keys'
      '~~~'
      'Ctrl + J = Auto Completion'
      'Ctrl + Y = Delete whole line'
      ''
      'Special Component Properties and Notes'
      '~~~~~~~~~~~~~~~~~~~~~~~~'
      'Mini Throbber:'
      '~~~~~~~~~'
      
        '- AutoSize will always be turned on, this means that the skin ha' +
        's to specify '
      
        'the actual size of the throbber! So do not set dimension to w,h.' +
        '.. set it to'
      'the size you want the throbber to be! '
      
        '- The position of any Mini Throbber will be set by SharpBar. The' +
        ' top position'
      
        'always refers to the top point of the module area in SharpBar. I' +
        'f you want '
      
        'your Mini Throbbers to not start at the top most pixel then just' +
        ' leave'
      'some empty space at the top.'
      ''
      ''
      'SharpBar:'
      '~~~~~~'
      'For SharpBar there are some addiitonal property tags available:'
      ''
      
        '<enablevflip>0</enablevflip> Enabling this option will mirror th' +
        'e skin when'
      
        'the bar is displayed at the bottom of the screen. (0 = False, 1=' +
        'True)'
      ''
      
        '<paxoffsets>20,5</paxoffsets> Sets the left and right offset for' +
        ' the '
      
        'module area. Set these offsets to get some space for a Throbber ' +
        'or round'
      
        'edges. Use it to make sure that the modules don'#39't reach into ski' +
        'n pars where'
      'they are not supposed to be'
      ''
      
        '<payoffsets>3,3</payoffsets> Sets top and bottom offset for the ' +
        'module'
      
        'area. With these example values the module area will start 3px f' +
        'rom the top'
      'of your skin and reach until bottom - 3px.'
      ''
      '<sbmod>0,8</sbmod> Sets a top and bottom offset for a shadow '
      
        'cut off area. If you are using a drop shadow in your Bar then it' +
        ' could be'
      
        'usefull to cut this shadow off when the bar is displayed at the ' +
        'bottom of the'
      
        'screen. You can simply set the amount of pixels which will be re' +
        'moved at the'
      'top and the bottom...'
      ''
      
        '<fsmod>7,14</fsmod> Sets a left and right cut off in pixels if t' +
        'he bar is'
      
        'displayed in full screen mode. Use this option to cut off round ' +
        'edges or parts'
      
        'at the left/right border of the bar which are not supposed to be' +
        ' visible if'
      'the left or right bar border reaches a screen border.'
      ''
      ''
      'Progress Bar:'
      '~~~~~~~~'
      
        'In some situations there might be progress bars with a small hei' +
        'ght used somewhere.'
      
        'For some skins it could cause drawing problems when the bar heig' +
        'ht gets'
      
        'below a fixed value (for example when using big round edges). In' +
        ' this case '
      'the ProgressBar component supports the usage of a second skin.'
      
        'In addition to <background> and <progress> there are two more dr' +
        'awing parts'
      
        'supported : <smallbackground> and <smallprogress>. The skin part' +
        's specified'
      
        'in those two additional tags will be used when the bar height ge' +
        'ts below the'
      
        'value specified in another <smallmode> property at the top of th' +
        'e component.'
      
        'The <smallmode> property is a point value of x,y. The x value is' +
        ' not used at '
      
        'the moment and the y value simply sets the height of the compone' +
        'nt '
      
        'before the <smallbackground> and <smallprogress> parts will be u' +
        'sed.'
      
        'For example <smallmode>0,10</smallmode> will use <background> an' +
        'd <progress>'
      
        'skin parts as long as the bar height is larger than 10px. For a ' +
        'height of 10px'
      
        'or smaller the skin parts in <smallbackground> and <smallprogres' +
        's> will be'
      'used for drawing instead.'
      'If you don'#39't need this feature set <smallmode>0,0</smallmode> or'
      'simply remove the property'
      ''
      ''
      ''
      ''
      ''
      'Skin Part tag'
      '~~~~~~~~'
      'Quick description of all possible properties.'
      'If a property doesn'#39't exist default values will be used.'
      ''
      '<dimension>'
      'sets the dimension of the '#39'layer'#39' to >Width,Height<'
      'examples:'
      '<dimension>w,h</dimension>'
      '<dimension>w-16,h-32</dimension>'
      '<dimension>32,h</dimension>'
      ''
      '<location>'
      'sets the location of the '#39'layer'#39' to >Left,Top<'
      'examples:'
      '<location>0,0</location>'
      '<location>w-8,0</location>'
      '<location>w-16,h-32</location>'
      ''
      '<image>'
      
        'specifies path and filename to the image which will be loaded in' +
        'to the layer'
      'file path always is relative to the path of the xml file!'
      'examples'
      '<image>images/filename.png</image>'
      
        '<image>empty</image> can be used as empty rectangle filled with ' +
        'the'
      
        'color from the <color> property and set to the size of the <dime' +
        'nsion> '
      'property.'
      ''
      '<drawmode>'
      
        'sets how the image is painted when the dimension is larger or sm' +
        'aller'
      'than the original image size'
      'possible values: >stretch< and >tile<'
      'default value: >stretch<'
      'examples:'
      '<drawmode>stretch</drawmode>'
      '<drawmode>tile</drawmode>'
      ''
      '<color>'
      'sets the color the image will be blended to'
      
        'possible values: >$WorkAreaBack<,>$WorkAreaDark<,>$WorkAreaLight' +
        '<,'
      
        '>$WorkAreaText<,>$ThrobberDark<,>$ThrobberBack<,>$ThrobberLight<' +
        ','
      '>$ThrobberText<, or any other RGB color value!'
      'Default value: no color blending (if value doesn'#39't exist)'
      'examples'
      '<color>$WorkAreaBack</color>'
      ''
      '<alpha>'
      'sets the master alpha value for the '#39'layer'#39'.'
      'possible values are all integer numbers between 0 and 255 while'
      '0 = not visible and 255 = fully visible'
      'default value: >255<'
      'examples:'
      '<alpha>255</alpha>'
      '<alpha>128</alpha>')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 344
    Width = 538
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      538
      35)
    object Button1: TButton
      Left = 458
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
