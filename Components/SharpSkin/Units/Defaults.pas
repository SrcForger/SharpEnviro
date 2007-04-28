{
Source Name: Defaults.pas
Description: Default Templates
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
 - OS : Windows 2000 or higher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit Defaults;

interface

const
      DefaultSkinPart = '<skinpart>'+
                        '§^  <location>0,0</location>^'+
                        '§^  <dimension>6,6</dimension>^'+
                        '§^  <image>images/filename.png</image>^'+
                        '§^  <color>$WorkAreaBack</color>^'+
                        '§</skinpart>';
      DefaultSkinPart2 = '<skinpart>'+
                        '§^  <alpha>255</alpha>^'+
                        '§^  <location>0,0</location>^'+
                        '§^  <dimension>6,6</dimension>^'+
                        '§^  <drawmode>stretch</drawmode>^'+
                        '§^  <image>images/filename.png</image>^'+
                        '§^  <color>$WorkAreaBack</color>^'+
                        '§</skinpart>';

      DefaultSkinPart3 = '<skinpart>'+
                        '§^  <alpha>255</alpha>^'+
                        '§^  <location>0,0</location>^'+
                        '§^  <dimension>6,6</dimension>^'+
                        '§^  <image>empty</image>^'+
                        '§^  <color>$WorkAreaBack</color>^'+
                        '§</skinpart>';

      DefaultButtonSkin = '<button>'+
                          '§^  <text>^'+
                          '§^    <location>cw,ch-1</location>^'+
                          '§^    <name>Small Fonts</name>^'+
                          '§^    <size>7</size>^'+
                          '§^    <color>$WorkAreaText</color>^'+
                          '§^  </text>^'+
                          '§^  <dimension>w,20</dimension>^'+
                          '§^  <normal>^'+
                          '§^    <!-- Normal State Skin Parts -->^'+
                          '§^  </normal>^'+
                          '§^  <hover>^'+
                          '§^    <!-- Hover State Skin Parts -->^'+
                          '§^  </hover>^'+
                          '§^  <down>^'+
                          '§^    <text>^'+
                          '§^      <location>cw,ch</location>^'+
                          '§^    </text>^'+
                          '§^    <!-- Down State Skin Parts -->^'+
                          '§^  </down>^'+
                          '§^  <disabled>^'+
                          '§^    <text>^'+
                          '§^      <color>$WorkAreaBack</color>^'+
                          '§^    </text>^'+
                          '§^    <!-- Disabled State Skin Parts -->^'+
                          '§^  </disabled>^'+
                          '§^</button>^';

  DefaultButtonSkinAnim = '<button>'+
                          '§^  <text>^'+
                          '§^    <location>cw,ch-1</location>^'+
                          '§^    <name>Small Fonts</name>^'+
                          '§^    <size>7</size>^'+
                          '§^    <color>$WorkAreaText</color>^'+
                          '§^  </text>^'+
                          '§^  <dimension>w,20</dimension>^'+
                          '§^    <OnNormalMouseEnter></OnNormalMouseEnter>^'+
                          '§^    <OnNormalMouseLeave></OnNormalMouseLeave>^'+
                          '§^  <normal>^'+
                          '§^    <!-- Normal State Skin Parts -->^'+
                          '§^  </normal>^'+
                          '§^  <hover>^'+
                          '§^    <!-- Hover State Skin Parts -->^'+
                          '§^  </hover>^'+
                          '§^  <down>^'+
                          '§^    <text>^'+
                          '§^      <location>cw,ch</location>^'+
                          '§^    </text>^'+
                          '§^    <!-- Down State Skin Parts -->^'+
                          '§^  </down>^'+
                          '§^  <disabled>^'+
                          '§^    <text>^'+
                          '§^      <color>$WorkAreaBack</color>^'+
                          '§^    </text>^'+
                          '§^    <!-- Disabled State Skin Parts -->^'+
                          '§^  </disabled>^'+
                          '§^</button>^';

      DefaultProgressbarSkin = '<progressbar>'+
                               '§^  <dimension>w,h</dimension>^'+
                               '§^  <background>^'+
                               '§^    <!-- Brackground Skin Parts -->^'+
                               '§^  </background>^'+
                               '§^  <progress>^'+
                               '§^    <location>0,0</location>^'+
                               '§^    <dimension>w,h</dimension>^'+
                               '§^    <!-- Progress Bar Skin Parts -->^'+
                               '§^  </progress>^'+
                               '§^</progressbar>  ^';

      DefaultProgressbarSkin2 = '<progressbar>'+
                                '§^  <dimension>w,h</dimension>^'+
                                '§^  <smallmode>0,10</smallmode>^'+
                                '§^    <!-- Read the Quick Help for details about the Small Mode -->^'+
                                '§^  <background>^'+
                                '§^    <!-- Brackground Skin Parts -->^'+
                                '§^  </background>^'+
                                '§^  <progress>^'+
                                '§^    <location>0,0</location>^'+
                                '§^    <dimension>w,h</dimension>^'+
                                '§^    <!-- Progress Bar Skin Parts -->^'+
                                '§^  </progress>^'+
                                '§^  <smallbackground>^'+
                                '§^    <!-- Small Brackground Skin Parts -->^'+
                                '§^  </smallbackground>^'+
                                '§^  <smallprogress>^'+
                                '§^    <location>0,0</location>^'+
                                '§^    <dimension>w,h</dimension>^'+
                                '§^    <!-- Small Progress Bar Skin Parts -->^'+
                                '§^  </smallprogress>^'+
                                '§^</progressbar>  ^';

      DefaultCheckboxSkin = '<checkbox>'+
                            '§^  <text>^'+
                            '§^    <location>16,ch</location>^'+
                            '§^    <name>Small Fonts</name>^'+
                            '§^    <size>7</size>^'+
                            '§^    <color>$WorkAreaText</color>^'+
                            '§^  </text>^'+
                            '§^  <dimension>w,14</dimension>^'+
                            '§^  <normal>^'+
                            '§^    <!-- Normal State Skin Parts -->^'+
                            '§^  </normal>^'+
                            '§^  <hover>^'+
                            '§^    <!-- Hover State Skin Parts -->^'+
                            '§^  </hover>^'+
                            '§^  <down>^'+
                            '§^    <!-- Down State Skin Parts -->^'+
                            '§^  </down>^'+
                            '§^  <disabled>^'+
                            '§^    <text>^'+
                            '§^      <color>$WorkAreaBack</color>^'+
                            '§^    </text>^'+
                            '§^    <!-- Disabled State Skin Parts -->^'+
                            '§^  </disabled>^'+
                            '§^  <checked>^'+
                            '§^    <!-- Checked State Skin Parts -->^'+
                            '§^  </checked>^'+
                            '§^</checkbox> ^';

      DefaultPanelSkin = '<panel>'+
                        '§^  <dimension>w,h</dimension>^'+
                        '§^  <normal>^'+
                        '§^    <!-- Normal State Skin Parts -->^'+
                        '§^  </normal>^'+
                        '§^  <raised>^'+
                        '§^    <!-- Raised State Skin Parts -->^'+
                        '§^  </raised>^'+
                        '§^  <lowered>^'+
                        '§^    <!-- Lowered State Skin Parts -->^'+
                        '§^  </lowered>^'+
                        '§^  <selected>^'+
                        '§^    <!-- Selected State Skin Parts -->^'+
                        '§^  </selected>^'+
                        '§^</panel>^';

 DefaultMiniThrobberSkin = '<minithrobber>'+
                          '§^  <dimension>8,12</dimension>^'+
                          '§^  <normal>^'+
                          '§^    <!-- Normal State Skin Parts -->^'+
                          '§^  </normal>^'+
                          '§^  <hover>^'+
                          '§^    <!-- Hover State Skin Parts -->^'+
                          '§^  </hover>^'+
                          '§^  <down>^'+
                          '§^    <!-- Down State Skin Parts -->^'+
                          '§^  </down>^'+
                          '§^</minithrobber>^';

      DefaultRadioBoxSkin = '<radiobox>'+
                            '§^  <text>^'+
                            '§^    <location>16,ch</location>^'+
                            '§^    <name>Small Fonts</name>^'+
                            '§^    <size>7</size>^'+
                            '§^    <color>$WorkAreaText</color>^'+
                            '§^  </text>^'+
                            '§^  <dimension>w,14</dimension>^'+
                            '§^  <normal>^'+
                            '§^    <!-- Normal State Skin Parts -->^'+
                            '§^  </normal>^'+
                            '§^  <hover>^'+
                            '§^    <!-- Hover State Skin Parts -->^'+
                            '§^  </hover>^'+
                            '§^  <down>^'+
                            '§^    <!-- Down State Skin Parts -->^'+
                            '§^  </down>^'+
                            '§^  <disabled>^'+
                            '§^    <text>^'+
                            '§^      <color>$WorkAreaBack</color>^'+
                            '§^    </text>^'+
                            '§^    <!-- Disabled State Skin Parts -->^'+
                            '§^  </disabled>^'+
                            '§^  <checked>^'+
                            '§^    <!-- Checked State Skin Parts -->^'+
                            '§^  </checked>^'+
                            '§^</radiobox> ^';

      DefaultFontTemplate = '<font>'+
                            '§^  <small>^'+
                            '§^    <size>6</size>^'+
                            '§^  </small>^'+
                            '§^  <medium>^'+
                            '§^    <name>Verdana</name>^'+
                            '§^    <size>8</size>^'+
                            '§^  </medium>^'+
                            '§^  <big>^'+
                            '§^    <name>Verdana</name>^'+
                            '§^    <size>10</size>^'+
                            '§^    <bold>1</bold>^'+
                            '§^  </big>^'+
                            '§</font>';

          DefaultEditSkin = '<edit>'+
                            '§^  <dimension>w,20</dimension>^'+
                            '§^  <editxoffsets>5,5</editxoffsets>^'+
                            '§^  <edityoffsets>5,5</edityoffsets>^'+
                            '§^  <normal>^'+
                            '§^    <!-- Normal State Skin Parts -->^'+
                            '§^  </normal>^'+
                            '§^  <focus>^'+
                            '§^    <!-- Focused State Skin Parts -->^'+
                            '§^  </focus>^'+
                            '§^  <hover>^'+
                            '§^    <!-- Hover State Skin Parts -->^'+
                            '§^  </hover>^'+
                            '§^  <disabled>^'+
                            '§^    <!-- Disabled State Skin Parts -->^'+
                            '§^  </disabled>^'+
                            '§</edit>';

      DefaultTaskItemSkinAnim = '<taskitem>'+
                                '§^  <full>^'+
                                '§^    <text>^'+
                                '§^      <draw>1</draw>^'+
                                '§^      <maxwidth>w-22</maxwidth>^'+
                                '§^    </text>^'+
                                '§^    <icon>^'+
                                '§^      <draw>1</draw>^'+
                                '§^      <size>12</size>^'+
                                '§^      <location>cw+8-twh,2</location>^'+
                                '§^    </icon>^'+
                                '§^    <spacing>2</spacing>^'+
                                '§^    <location>0,0</location>^'+
                                '§^    <dimension>128,17</dimension>^'+
                                '§^    <OnNormalMouseEnter></OnNormalMouseEnter>^'+
                                '§^    <OnNormalMouseLeave></OnNormalMouseLeave>^'+
                                '§^    <OnDownMouseEnter></OnDownMouseEnter>^'+
                                '§^    <OnDownMouseLeave></OnDownMouseLeave>^'+
                                '§^    <OnHighlightStepStart></OnHighlightStepStart>^'+
                                '§^    <OnHighlightStepEnd></OnHighlightStepEnd>^'+
                                '§^    <normal>^'+
                                '§^      <!-- Normal State Skin Parts -->^'+
                                '§^    </normal>^'+
                                '§^    <hover>^'+
                                '§^      <!-- Hover State Skin Parts -->^'+
                                '§^    </hover>^'+
                                '§^    <down>^'+
                                '§^      <!-- Down State Skin Parts -->^'+
                                '§^    </down>^'+
                                '§^  </full>^'+
                                '§^  <compact>^'+
                                '§^    <text>^'+
                                '§^      <draw>1</draw>^'+
                                '§^      <maxwidth>w-6</maxwidth>^'+
                                '§^    </text>^'+
                                '§^    <icon>^'+
                                '§^      <draw>0</draw>^'+
                                '§^    </icon>^'+
                                '§^    <spacing>1</spacing>^'+
                                '§^    <location>0,0</location>^'+
                                '§^    <dimension>96,17</dimension>^'+
                                '§^    <OnNormalMouseEnter></OnNormalMouseEnter>^'+
                                '§^    <OnNormalMouseLeave></OnNormalMouseLeave>^'+
                                '§^    <OnDownMouseEnter></OnDownMouseEnter>^'+
                                '§^    <OnDownMouseLeave></OnDownMouseLeave>^'+
                                '§^    <OnHighlightStepStart></OnHighlightStepStart>^'+
                                '§^    <OnHighlightStepEnd></OnHighlightStepEnd>^'+
                                '§^    <normal>^'+
                                '§^      <!-- Normal State Skin Parts -->^'+
                                '§^    </normal>^'+
                                '§^    <hover>^'+
                                '§^      <!-- Hover State Skin Parts -->^'+
                                '§^    </hover>^'+
                                '§^    <down>^'+
                                '§^      <!-- Down State Skin Parts -->^'+
                                '§^    </down>^'+
                                '§^  </compact>^'+
                                '§^  <mini>^'+
                                '§^    <text>^'+
                                '§^      <draw>0</draw>^'+
                                '§^    </text>^'+
                                '§^    <icon>^'+
                                '§^      <draw>1</draw>^'+
                                '§^      <size>12</size>^'+
                                '§^      <location>4,2</location>^'+
                                '§^    </icon>^'+
                                '§^    <spacing>1</spacing>^'+
                                '§^    <location>0,0</location>^'+
                                '§^    <dimension>19,17</dimension>^'+
                                '§^    <OnNormalMouseEnter></OnNormalMouseEnter>^'+
                                '§^    <OnNormalMouseLeave></OnNormalMouseLeave>^'+
                                '§^    <OnDownMouseEnter></OnDownMouseEnter>^'+
                                '§^    <OnDownMouseLeave></OnDownMouseLeave>^'+
                                '§^    <OnHighlightStepStart></OnHighlightStepStart>^'+
                                '§^    <OnHighlightStepEnd></OnHighlightStepEnd>^'+
                                '§^    <normal>^'+
                                '§^      <!-- Normal State Skin Parts -->^'+
                                '§^    </normal>^'+
                                '§^    <hover>^'+
                                '§^      <!-- Hover State Skin Parts -->^'+
                                '§^    </hover>^'+
                                '§^    <down>^'+
                                '§^      <!-- Down State Skin Parts -->^'+
                                '§^    </down>^'+
                                '§^  </mini>^'+
                                '§</taskitem>';

          DefaultTaskItemSkin = '<taskitem>'+
                                '§^  <full>^'+
                                '§^    <text>^'+
                                '§^      <draw>1</draw>^'+
                                '§^      <maxwidth>w-22</maxwidth>^'+
                                '§^    </text>^'+
                                '§^    <icon>^'+
                                '§^      <draw>1</draw>^'+
                                '§^      <size>12</size>^'+
                                '§^      <location>cw+8-twh,2</location>^'+
                                '§^    </icon>^'+
                                '§^    <spacing>2</spacing>^'+
                                '§^    <location>0,0</location>^'+
                                '§^    <dimension>128,17</dimension>^'+
                                '§^    <normal>^'+
                                '§^      <!-- Normal State Skin Parts -->^'+
                                '§^    </normal>^'+
                                '§^    <hover>^'+
                                '§^      <!-- Hover State Skin Parts -->^'+
                                '§^    </hover>^'+
                                '§^    <down>^'+
                                '§^      <!-- Down State Skin Parts -->^'+
                                '§^    </down>^'+
                                '§^  </full>^'+
                                '§^  <compact>^'+
                                '§^    <text>^'+
                                '§^      <draw>1</draw>^'+
                                '§^      <maxwidth>w-6</maxwidth>^'+
                                '§^    </text>^'+
                                '§^    <icon>^'+
                                '§^      <draw>0</draw>^'+
                                '§^    </icon>^'+
                                '§^    <spacing>1</spacing>^'+
                                '§^    <location>0,0</location>^'+
                                '§^    <dimension>96,17</dimension>^'+
                                '§^    <normal>^'+
                                '§^      <!-- Normal State Skin Parts -->^'+
                                '§^    </normal>^'+
                                '§^    <hover>^'+
                                '§^      <!-- Hover State Skin Parts -->^'+
                                '§^    </hover>^'+
                                '§^    <down>^'+
                                '§^      <!-- Down State Skin Parts -->^'+
                                '§^    </down>^'+
                                '§^  </compact>^'+
                                '§^  <mini>^'+
                                '§^    <text>^'+
                                '§^      <draw>0</draw>^'+
                                '§^    </text>^'+
                                '§^    <icon>^'+
                                '§^      <draw>1</draw>^'+
                                '§^      <size>12</size>^'+
                                '§^      <location>4,2</location>^'+
                                '§^    </icon>^'+
                                '§^    <spacing>1</spacing>^'+
                                '§^    <location>0,0</location>^'+
                                '§^    <dimension>19,17</dimension>^'+
                                '§^    <normal>^'+
                                '§^      <!-- Normal State Skin Parts -->^'+
                                '§^    </normal>^'+
                                '§^    <hover>^'+
                                '§^      <!-- Hover State Skin Parts -->^'+
                                '§^    </hover>^'+
                                '§^    <down>^'+
                                '§^      <!-- Down State Skin Parts -->^'+
                                '§^    </down>^'+
                                '§^  </mini>^'+
                                '§</taskitem>';


implementation

end.
