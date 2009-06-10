unit uSharpCenterPluginScheme;

interface

{$INCLUDE centerscheme.inc}

uses
  Classes,
  ComCtrls,
  Forms,
  ExtCtrls,
  Graphics,
  Types,
  StdCtrls,  

  {$IFDEF CENTER_SCHEME_JVPAGECONTROL}
  JvPageList,
  {$ENDIF}

  {$IFDEF CENTER_SCHEME_SHARPELISTBOXEX}
  SharpEListBoxEx,
  {$ENDIF}

  {$IFDEF CENTER_SCHEME_SHARPEPAGECONTROL}
  SharpEPageControl,
  {$ENDIF}

  {$IFDEF CENTER_SCHEME_SHARPESWATCHMANAGER}
  SharpESwatchManager,
  {$ENDIF}

  {$IFDEF CENTER_SCHEME_SHARPECOLOREDITORBOX}
  SharpEColorEditorEx,
  {$ENDIF}

  {$IFDEF CENTER_SCHEME_SHARPEHEADER}
  SharpECenterHeader,
  {$ENDIF}

  {$IFDEF CENTER_SCHEME_JVXPCHECKBOX}
  JvXPCheckCtrls,
  {$ENDIF}

  {$IFDEF CENTER_SCHEME_JVFILENAMEEDIT}
  JvToolEdit,
  {$ENDIF}

  {$IFDEF CENTER_SCHEME_SHARPEROUNDPANEL}
  SharpERoundPanel,
  {$ENDIF}

  {$IFDEF CENTER_SCHEME_SHARPEHOTKEYEDIT}
  SharpEHotkeyEdit,
  {$ENDIF}

  {$IFDEF CENTER_SCHEME_SHARPEGAUGEBOX}
  SharpEGaugeBoxEdit,
  {$ENDIF}

  SharpCenterApi;


procedure AssignThemeToForms(AForm, AEditForm: TForm; AEditing: Boolean; ATheme : TCenterThemeInfo);  
procedure AssignThemeToEditForm(AForm: TForm; AEditing: Boolean; ATheme : TCenterThemeInfo);
procedure AssignThemeToPluginForm(AForm: TForm; AEditing: Boolean; ATheme : TCenterThemeInfo);

implementation

procedure AssignThemeToForms(AForm, AEditForm: TForm; AEditing: Boolean; ATheme : TCenterThemeInfo);
begin
  AssignThemeToPluginForm(AForm, AEditing, ATheme);
  AssignThemeToEditForm(AEditForm, AEditing, ATheme);
end;

procedure AssignThemeToEditForm(AForm: TForm; AEditing: Boolean; ATheme : TCenterThemeInfo);
var
  i: integer;
  c: TComponent;
  theme: TCenterThemeInfo;
  colBackground: TColor;
begin
  theme := ATheme;

  colBackground := theme.EditBackground;

  If AEditing then begin
    theme.EditBackground := theme.EditBackgroundError;
  end;

  if AForm <> nil then begin
    with AForm do begin
      AForm.Color := theme.EditBackground;
      AForm.Font.Color := theme.EditBackgroundText;
      AForm.DoubleBuffered := True;

      for i := 0 to Pred(ComponentCount) do begin

        c := Components[i];

        {$IFDEF CENTER_SCHEME_SHARPELISTBOXEX}
        if c.ClassNameIs('TSharpEListBoxEx') then begin
          TSharpEListBoxEx(c).Color := theme.EditControlBackground;
          TSharpEListBoxEx(c).Colors.ItemColor := theme.EditControlBackground;
          TSharpEListBoxEx(c).Colors.ItemColorSelected := theme.EditControlBackground;
          TSharpEListBoxEx(c).Colors.CheckColor := theme.EditControlBackground;
          TSharpEListBoxEx(c).Colors.CheckColorSelected := theme.EditControlBackground;
          TSharpEListBoxEx(c).Colors.BorderColor := theme.EditControlBackground;
          TSharpEListBoxEx(c).DoubleBuffered := True;
        end;
        {$ENDIF}

        {$IFDEF CENTER_SCHEME_SHARPEROUNDPANEL}
        if c.ClassNameIs('TSharpERoundPanel') then begin
          TSharpERoundPanel(c).BackgroundColor := theme.EditBackground;
          TSharpERoundPanel(c).Color := theme.EditControlBackground;
        end;
        {$ENDIF}

        {$IFDEF CENTER_SCHEME_SHARPEHOTKEYEDIT}
        if c.ClassNameIs('TSharpEHotkeyEdit') then begin
          TSharpEHotkeyEdit(c).Color := theme.EditControlBackground;
          TSharpEHotkeyEdit(c).Font.Color := theme.EditControlText;
          TSharpEHotkeyEdit(c).DoubleBuffered := True;
        end;
        {$ENDIF}

        {$IFDEF CENTER_SCHEME_JVPAGECONTROL}
        if c.ClassNameIs('TJvStandardPage') then begin
          TJvStandardPage(c).Color := theme.EditBackground;
          TJvStandardPage(c).Font.Color := theme.EditBackgroundText;
          TJvStandardPage(c).ParentBackground := False;
        end;
        {$ENDIF}        

        {$IFDEF CENTER_SCHEME_JVXPCHECKBOX}
        if c.ClassNameIs('TJvXpCheckBox') then begin
          TJvXpCheckBox(c).ParentColor := true;
          TJvXpCheckBox(c).ParentFont := False;
          TJvXpCheckBox(c).Font.Color := theme.EditControlText;
          TJvXpCheckBox(c).Color := theme.EditBackground;
        end;
        {$ENDIF}                

        {$IFDEF CENTER_SCHEME_SHARPEGAUGEBOX}
        if c.ClassNameIs('TSharpEGaugeBox') then begin
          TSharpEGaugeBox(c).Color := theme.EditControlBackground;
          TSharpEGaugeBox(c).Font.Color := theme.EditControlText;
          TSharpeGaugeBox(c).BackgroundColor := theme.EditControlBackground;
          TSharpeGaugeBox(c).DoubleBuffered := True;
        end;
        {$ENDIF}

        if c.ClassNameIs('TLabeledEdit') then begin
          TLabeledEdit(c).Color := theme.EditControlBackground;
          TLabeledEdit(c).Font.Color := theme.EditControlText;

          if TLabeledEdit(c).EditLabel.Tag <> -1 then
          TLabeledEdit(c).EditLabel.Font.Color := theme.EditBackgroundText else
          TLabeledEdit(c).EditLabel.Font.Color := theme.EditControlText;

          TLabeledEdit(c).DoubleBuffered := True;
        end else
        if c.ClassNameIs('TLabel') then begin
          if TLabel(c).Tag <> -1 then begin
            TLabel(c).Color := theme.EditBackground;
            TLabel(c).Font.Color := theme.EditBackgroundText;
          end else begin
            TLabel(c).Color := theme.EditControlBackground;
            TLabel(c).Font.Color := theme.EditControlText;
          end;
        end else
        if c.ClassNameIs('TEdit') then begin
          TEdit(c).Color := theme.EditControlBackground;
          TEdit(c).Font.Color := theme.EditControlText;
          TEdit(c).DoubleBuffered := True;
        end else
        if c.ClassNameIs('TComboBox') then begin
          TComboBox(c).Color := theme.EditControlBackground;
          TComboBox(c).Font.Color := theme.EditControlText;
          TComboBox(c).DoubleBuffered := True;
        end else
        if c.ClassNameIs('TPngSpeedButton') then begin
          TButton(c).Font.Color := theme.EditBackgroundText;
          TButton(c).ParentFont := False;
          TButton(c).DoubleBuffered := True;
        end;
      end;
    end;
  end;

  theme.EditBackground := colBackground;
end;

procedure AssignThemeToPluginForm(AForm: TForm; AEditing: Boolean; ATheme : TCenterThemeInfo);
var
  i: integer;
  c: TComponent;
  theme: TCenterThemeInfo;
begin
  theme := ATheme;

  if AForm <> nil then begin
    with AForm do begin
      AForm.Color := theme.PluginBackground;
      AForm.Font.Color := theme.PluginBackgroundText;
      AForm.DoubleBuffered := True;

      for i := 0 to Pred(ComponentCount) do begin

        c := Components[i];

        {$IFDEF CENTER_SCHEME_SHARPEHEADER}
        if c.ClassNameIs('TSharpECenterHeader') then begin
          TSharpECenterHeader(c).TitleColor := theme.PluginSectionTitle;
          TSharpECenterHeader(c).DescriptionColor := theme.PluginSectionDescription;
          TSharpECenterHeader(c).DoubleBuffered := True;
          TSharpECenterHeader(c).ParentBackground := False;
          TSharpECenterHeader(c).Color := theme.PluginBackground;
        end;
        {$ENDIF CENTER_SCHEME_SHARPEHEADER}

        {$IFDEF CENTER_SCHEME_JVXPCHECKBOX}
        if c.ClassNameIs('TJvXpCheckBox') then begin
          TJvXPCheckbox(c).Color := theme.PluginBackground;
          TJvXpCheckBox(c).ParentColor := False;
          TJvXpCheckBox(c).ParentFont := False;
          TJvXpCheckBox(c).Font.Color := theme.PluginBackgroundText;
        end;
        {$ENDIF}

        {$IFDEF CENTER_SCHEME_SHARPELISTBOXEX}
        if c.ClassNameIs('TSharpEListBoxEx') then begin
          TSharpEListBoxEx(c).Color := theme.PluginBackground;
          TSharpEListBoxEx(c).Colors.ItemColor := theme.PluginItem;
          TSharpEListBoxEx(c).Colors.ItemColorSelected := theme.PluginSelectedItem;
          TSharpEListBoxEx(c).Colors.ItemColor := theme.PluginItem;
          TSharpEListBoxEx(c).Colors.ItemColorSelected := theme.PluginSelectedItem;
          TSharpEListBoxEx(c).Colors.CheckColor := theme.PluginItem;
          TSharpEListBoxEx(c).Colors.CheckColorSelected := theme.PluginSelectedItem;
          TSharpEListBoxEx(c).Colors.BorderColor := theme.PluginBackground;
          TSharpEListBoxEx(c).DoubleBuffered := True;
        end;
        {$ENDIF}

        {$IFDEF CENTER_SCHEME_SHARPEGAUGEBOX}
        if c.ClassNameIs('TSharpEGaugeBox') then begin
          TSharpEGaugeBox(c).Color := theme.PluginBackground;
          TSharpEGaugeBox(c).Font.Color := theme.PluginControlText;
          TSharpeGaugeBox(c).BackgroundColor := theme.PluginControlBackground;
          TSharpeGaugeBox(c).DoubleBuffered := True;
        end;
        {$ENDIF}

        {$IFDEF CENTER_SCHEME_JVFILENAMEEDIT}
        if c.ClassNameIs('TJvFilenameEdit') then begin
          TJvFilenameEdit(c).Color := theme.PluginControlBackground;
          TJvFilenameEdit(c).Font.Color := theme.PluginControlText;
          TJvFilenameEdit(c).DoubleBuffered := True;
        end;
        {$ENDIF}

        {$IFDEF CENTER_SCHEME_SHARPECOLOREDITORBOX}
        if c.ClassNameIs('TSharpEColorEditorEx') then begin
          TSharpEColorEditorEx(c).BackgroundColor := theme.PluginBackground;
          TSharpEColorEditorEx(c).BackgroundTextColor := theme.PluginBackgroundText;
          TSharpEColorEditorEx(c).BorderColor := theme.ContainerColor;
          TSharpEColorEditorEx(c).ContainerColor := theme.ContainerColor;
          TSharpEColorEditorEx(c).ContainerTextColor := theme.ContainerTextColor;
          TSharpEColorEditorEx(c).Color := theme.PluginBackground;
          TSharpEColorEditorEx(c).DoubleBuffered := True;
          TSharpEColorEditorEx(c).ParentBackground := False;
        end;
        {$ENDIF}

        {$IFDEF CENTER_SCHEME_SHARPESWATCHMANAGER}
        if c.ClassNameIs('TSharpESwatchManager') then begin
          TSharpESwatchManager(c).BackgroundColor := theme.ContainerColor;
          TSharpESwatchManager(c).BackgroundTextColor := theme.ContainerTextColor;
          TSharpESwatchManager(c).BorderColor := theme.ContainerColor;
        end;
        {$ENDIF}

        {$IFDEF CENTER_SCHEME_JVPAGECONTROL}
        if c.ClassNameIs('TJvStandardPage') then begin
          TJvStandardPage(c).Color := theme.PluginBackground;
          TJvStandardPage(c).Font.Color := theme.PluginBackgroundText;
        end;
        {$ENDIF}

        {$IFDEF CENTER_SCHEME_SHARPEPAGECONTROL}
        if c.ClassNameIs('TSharpEPageControl') then begin
          TSharpEPageControl(c).PageBackgroundColor := theme.PluginBackground;
          TSharpEPageControl(c).BackgroundColor := theme.Background;
          TSharpEPageControl(c).TabBackgroundColor := theme.Background;
          TSharpEPageControl(c).TabColor := theme.PluginTab;
          TSharpEPageControl(c).TabSelColor := theme.PluginSelectedTab;
          TSharpEPageControl(c).TabCaptionColor := theme.PluginTabText;
          TSharpEPageControl(c).TabCaptionSelColor := theme.PluginTabSelectedText;
          TSharpEPageControl(c).BorderColor := theme.Border;
          TSharpEPageControl(c).DoubleBuffered := True;
        end;
        {$ENDIF}       

        if c.ClassNameIs('TRadioButton') then begin
          TRadioButton(c).ParentColor := False;
          TRadioButton(c).ParentFont := False;
          TRadioButton(c).Font.Color := theme.PluginBackgroundText;
        end else        
        if c.ClassNameIs('TEdit') then begin
          TEdit(c).Color := theme.PluginControlBackground;
          TEdit(c).Font.Color := theme.PluginControlText;
        end else
        if c.ClassNameIs('TMemo') then begin
          TMemo(c).Color := theme.PluginControlBackground;
          TMemo(c).Font.Color := theme.PluginControlText;
        end else
        if c.ClassNameIs('TComboBox') then begin
          TComboBox(c).Color := theme.PluginControlBackground;
          TComboBox(c).Font.Color := theme.PluginControlText;
        end else
        if c.ClassNameIs('TLabel') then begin
          TLabel(c).Color := theme.PluginBackground;
          TLabel(c).Font.Color := theme.PluginBackgroundText;
          TLabel(c).ParentColor := False;
        end else
        if c.ClassNameIs('TTabSheet') then begin
          TTabSheet(c).Font.Color := theme.PluginBackgroundText;
        end else
        if c.ClassNameIs('TPanel') then begin
          TPanel(c).DoubleBuffered := True;
          TPanel(c).ParentBackground := False;
          TPanel(c).Color := theme.PluginBackground;
        end
      end;
    end;
  end;
end;

end.
