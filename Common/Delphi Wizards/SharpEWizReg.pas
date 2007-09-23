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
