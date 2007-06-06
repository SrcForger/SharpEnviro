unit Global_Functions;

interface

Uses
  Graphics, SysUtils, Windows, Tlhelp32, psApi;

Function Makesize       (size: integer): string;                        // Autoformat byte numbers to kb/mb
function Darker         (Color:TColor; Percent:Byte):TColor;            // Take color and make % darker
function Lighter        (Color:TColor; Percent:Byte):TColor;            // Take color and make & lighter
Function GetMemUsage    (Executable: String):integer;                   // Get mem usage from .exe file

implementation

Function GetMemUsage(Executable: String) : integer;
var
  info                  : TProcessMemoryCounters;
  FProcessEntry32       : TProcessEntry32;
  ProcessHandle         : THandle;
  ContinueLoop          : BOOL;
begin
  result := 0; 

  ProcessHandle                 := CreateToolhelp32Snapshot (TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize        := Sizeof(FProcessEntry32);
  ContinueLoop                  := Process32First(ProcessHandle, FProcessEntry32);

  while integer(ContinueLoop) <> 0 do 
  begin 
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(Executable))
    or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(Executable))) then
    begin
      ProcessHandle     := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, false, FProcessEntry32.th32ProcessID);
      GetProcessMemoryInfo(ProcessHandle, @Info, SizeOf(Info));
      Result            := Info.WorkingSetSize;
      CloseHandle       (ProcessHandle);
      Exit;
    end;
    ContinueLoop := Process32Next(ProcessHandle, FProcessEntry32);
  end;    
end;

function makesize(size: integer): string;
var
  a   : real;
  sep : string;
begin
  a := size;
  if a>1024 then
  begin
    a := a/1024;
    sep := 'kb';
  end;
  if a>1024 then
  begin
    a := a/1024;
    sep := 'Mb';
  end;
  if a>1024 then
  begin
    a := a/1024;
    sep := 'Gb';
  end;
  if a>1024 then
  begin
    a := a/1024;
    sep := 'Tb';
  end;
  if int(a)>0 then
  begin
    result := floattostr(int(a));
    if Frac(a)>0 then result := result + copy(floattostr(frac(a)),2,3);
    result := result + ' ' + sep;
  end else
    result := '';
end;

function Darker(Color:TColor; Percent:Byte):TColor;
var
  r,g,b :Byte;
begin
  Color:=ColorToRGB(Color);
  r:=GetRValue(Color);
  g:=GetGValue(Color);
  b:=GetBValue(Color);
  r:=r-muldiv(r,Percent,100);
  g:=g-muldiv(g,Percent,100);
  b:=b-muldiv(b,Percent,100);
  result:=RGB(r,g,b);
end;

function Lighter(Color:TColor; Percent:Byte):TColor;
var
  r,g,b:Byte;
begin
  Color:=ColorToRGB(Color);
  r:=GetRValue(Color);
  g:=GetGValue(Color);
  b:=GetBValue(Color);
  r:=r+muldiv(255-r,Percent,100);
  g:=g+muldiv(255-g,Percent,100);
  b:=b+muldiv(255-b,Percent,100);
  result:=RGB(r,g,b);
end;

end.
 
