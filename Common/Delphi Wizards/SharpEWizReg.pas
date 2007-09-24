{
Source Name: SharpEWizReg.pas
Description: SharpE Wizards Registraton
Copyright (C) Aleksandar Milanovic (viking) <aleksandar.milanovic@hotmail.com>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit SharpEWizReg;

interface

procedure Register;

implementation

{$R SharpERes.dcr}

uses
  Classes, DesignIntf, DesignEditors, VCLEditors, SharpESrvWizard, ToolsApi;

procedure Register;
begin
  // repository wizards
  RegisterPackageWizard(TShESvrCreatorWizard.Create as IOTAWizard);
end;

end.
