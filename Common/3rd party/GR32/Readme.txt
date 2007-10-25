In this GR32.inc function inlining and XPThemes support is disabled.

Function inlining must be disabled to make GR32 compile with Delphi 2005 Personal Edition.
XPThemes support MUST be disabled for all SharpE components, otherwise it will cause access violations in uxtheme.dll!



Make sure to either use this GR32.inc or disable the XPThemes setting in your GR32.inc!

GR32.pas has been modified to allow Cleartype font rendering. To use it, set the font quality to -2 in the RenderText function.