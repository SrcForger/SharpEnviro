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
    for n := 0 to High(CPUUsage) do
        CPUUsage[n] := adCpuUsage.GetCPUUsage(n);
  except
  end;
  for n := Forms.Count - 1 downto 0 do
  begin
    try
      if Forms.Items[n] <> nil then
         TMainForm(Forms.Items[n]).UpdateGraph;
    except
      Forms.Items[n] := nil;
    end;
  end;
end;

constructor TCPUUsage.Create;
begin
  inherited Create;
  try
    CollectCPUData;
    setlength(CPUUsage,GetCPUCount);
  except
    setlength(CPUUsage,1);
  end;
  Forms := TObjectList.Create(False);
  UpdateTimer := TTimer.Create(nil);
  UpdateTimer.Interval := 1001;
  UpdateTimer.OnTimer := OnUpdateTimer;
  UpdateTimer.Enabled := False;
end;

destructor TCPUUsage.Destroy;
begin
  setlength(CPUUsage,0);
  Forms.Clear;
  UpdateTimer.Free;
  inherited Destroy;
end;

function TCPUUsage.GetCPUUsage(ID : integer) : double;
begin
  try
    if ID > High(CPUUsage) then result := 0
       else result := CPUUsage[ID];
  except
    result := 0;
  end;
end;

end.
