unit cpuUsage;

interface

uses Contnrs,ExtCtrls,Forms, Dialogs, adCpuUsage, SysUtils ;

type
    TCPUUsage = class
              public
                CpuUsage : array of double;
                UpdateTimer : TTimer;
                Forms : TObjectList;
                procedure OnUpdateTimer(Sender : TObject);
                function GetCPUUsage(ID : integer) : double;
                constructor Create; reintroduce;
                destructor Destroy; override;
              end;

implementation

uses MainWnd;

procedure TCPUUsage.OnUpdateTimer(Sender : TObject);
var
  n : integer;
begin
  try
    CollectCPUData;
    //showmessage(floattostr(GetCPUUsage(0)));
    for n := 0 to High(CPUUsage) do
        CPUUsage[n] := adCpuUsage.GetCPUUsage(n);
  except
  end;
  for n := 0 to Forms.Count - 1 do
  begin
    if Forms <> nil then
       TMainForm(Forms.Items[n]).UpdateGraph;
  end;
end;

constructor TCPUUsage.Create;
begin
  inherited Create;
  CollectCPUData;
  setlength(CPUUsage,GetCPUCount);
  Forms := TObjectList.Create(False);
  UpdateTimer := TTimer.Create(nil);
  UpdateTimer.Interval := 1001;
  UpdateTimer.OnTimer := OnUpdateTimer;
end;

destructor TCPUUsage.Destroy;
begin
  setlength(CPUUsage,0);
  Forms.Clear;
  UpdateTimer.Free;
  inherited Destroy;
end;

function TCPUUsage.GetCPUUsage(ID : integer) : double;
var
  n : integer;
begin
  try
    if ID > High(CPUUsage) then result := 0
       else result := CPUUsage[ID];
  except
    result := 0;
  end;
end;

end.
