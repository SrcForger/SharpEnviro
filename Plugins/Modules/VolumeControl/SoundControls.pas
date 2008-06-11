unit SoundControls;

interface

uses Windows,MMSystem,uVistaFuncs,MMDevApi_tlb,ComObj,ActiveX;

function InitMixer: HMixer;
function MuteMaster(mxct : integer) : boolean; 
function SetMasterVolume(Value: Cardinal; mxct : integer) : boolean; 
function GetMasterVolume(mxct : integer) : Cardinal;
function GetMasterMuteStatus(mxct : integer) : boolean;
function GetMasterMute(Mixer: hMixerObj; var Control: TMixerControl; mxct : integer): MMResult;
function GetMasterVolumeControl(Mixer: hMixerObj; var Control: TMixerControl; mxct : integer): MMResult;

var
  MMDev: IMMDevice;
  MMDevEnum: IMMDeviceEnumerator;
  MMEndpoint: IMMAudioEndpointVolume;

implementation

function InitMixer: HMixer;
var 
  Err: MMRESULT;
begin
  if IsWindowsVista then
  begin
    CoCreateInstance(CLSID_MMDeviceEnumerator, nil, CLSCTX_ALL, IID_IMMDeviceEnumerator, MMDevEnum);
    MMDevEnum.GetDefaultAudioEndpoint(eRender, eMultimedia, MMDev);
    MMDev.Activate(IID_IAudioEndpointVolume, CLSCTX_ALL, nil, MMEndPoint);
    Result := 0;
  end
  else
  begin
    Err := mixerOpen(@Result, 0, 0, 0, 0);
    if Err <> MMSYSERR_NOERROR then
      Result := 0;
  end;
end;

function GetMasterVolumeControl(Mixer: hMixerObj; var Control: TMixerControl; mxct : integer): MMResult;
var 
  Line     : TMixerLine; 
  Controls : TMixerLineControls; 
begin
  ZeroMemory(@Line, SizeOf(Line));
  Line.cbStruct := SizeOf(Line);
  Line.dwComponentType := mxct; 
  Result := mixerGetLineInfo(Mixer, 
                             @Line, 
                             MIXER_GETLINEINFOF_COMPONENTTYPE); 
  if Result = MMSYSERR_NOERROR then begin 
    ZeroMemory(@Controls, SizeOf(Controls)); 
    Controls.cbStruct := SizeOf(Controls); 
    Controls.dwLineID := Line.dwLineID; 
    Controls.cControls := 1; 
    Controls.dwControlType := MIXERCONTROL_CONTROLTYPE_VOLUME; 
    Controls.cbmxctrl := SizeOf(Control); 
    Controls.pamxctrl := @Control; 
    Result := mixerGetLineControls(Mixer, 
                                   @Controls, 
                                   MIXER_GETLINECONTROLSF_ONEBYTYPE); 
  end; 
end; 

function SetMasterVolume(Value: Cardinal; mxct : integer) : boolean;
var 
  MasterVolume    : TMixerControl; 
  Details         : TMixerControlDetails;
  UnsignedDetails : TMixerControlDetailsUnsigned; 
  Code            : MMResult; 
  Mixer           : hMixerObj;
  fValue          : Single;
begin
  Mixer := InitMixer;
  Result := false;
  if IsWindowsVista then
  begin
    fValue := Value / 65535;
    MMEndPoint.SetMasterVolumeLevelScalar(fValue, nil);
    Result := true;
  end
  else
  begin
    Code := GetMasterVolumeControl(Mixer, MasterVolume, mxct);
    if(Code = MMSYSERR_NOERROR)then begin
      with Details do begin
        cbStruct := SizeOf(Details);
        dwControlID := MasterVolume.dwControlID;
        cChannels := 1;  // set all channels
        cMultipleItems := 0;
        cbDetails := SizeOf(UnsignedDetails);
        paDetails := @UnsignedDetails;
      end;
      UnsignedDetails.dwValue := Value;
      if(mixerSetControlDetails(Mixer,
                                @Details,
                                MIXER_SETCONTROLDETAILSF_VALUE) = MMSYSERR_NOERROR)then
        Result := true;
    end;
    mixerClose(Mixer);
  end;
end;

function GetMasterVolume(mxct : integer): Cardinal;
var
  MasterVolume    : TMixerControl;
  Details         : TMixerControlDetails;
  UnsignedDetails : TMixerControlDetailsUnsigned;
  Code            : MMResult;
  Mixer           : hMixerObj;
  VolLevel        : Single;
begin
  Mixer := InitMixer;
  Result := 0;
  if IsWindowsVista then
  begin
    MMEndPoint.GetMasterVolumeLevelScalar(VolLevel);
    result := Round(VolLevel * 65535);
  end
  else
  begin
    Code := GetMasterVolumeControl(Mixer, MasterVolume, mxct);
    if(Code = MMSYSERR_NOERROR)then begin
      with Details do begin
        cbStruct := SizeOf(Details);
        dwControlID := MasterVolume.dwControlID;
        cChannels := 1;  // set all channels
        cMultipleItems := 0;
        cbDetails := SizeOf(UnsignedDetails);
        paDetails := @UnsignedDetails;
      end;
      if(mixerGetControlDetails(Mixer,
                                @Details,
                                MIXER_GETCONTROLDETAILSF_VALUE) = MMSYSERR_NOERROR)then
        result := UnsignedDetails.dwValue;
    end;
    mixerClose(Mixer);
  end;
end;

function GetMasterMute(Mixer: hMixerObj; var Control: TMixerControl; mxct : integer): MMResult;
  // Returns True on success
var
  Line: TMixerLine;
  Controls: TMixerLineControls;
begin
  if IsWindowsVista then
  begin
    Result := 0;
  end
  else
  begin
    ZeroMemory(@Line, SizeOf(Line));
    Line.cbStruct := SizeOf(Line);
    Line.dwComponentType := mxct;
    Result := mixerGetLineInfo(Mixer, @Line,
      MIXER_GETLINEINFOF_COMPONENTTYPE);
    if Result = MMSYSERR_NOERROR then
    begin
      ZeroMemory(@Controls, SizeOf(Controls));
      Controls.cbStruct := SizeOf(Controls);
      Controls.dwLineID := Line.dwLineID;
      Controls.cControls := 1;
      Controls.dwControlType := MIXERCONTROL_CONTROLTYPE_MUTE;
      Controls.cbmxctrl := SizeOf(Control);
      Controls.pamxctrl := @Control;
      Result := mixerGetLineControls(Mixer, @Controls, MIXER_GETLINECONTROLSF_ONEBYTYPE);
    end;
  end;
end; 

function MuteMaster(mxct : integer) : boolean; 
var 
  MasterMute: TMixerControl; 
  Details: TMixerControlDetails; 
  BoolDetails: TMixerControlDetailsBoolean; 
  Code: MMResult;
  ret: Integer;
begin
  if IsWindowsVista then
  begin
    MMEndPoint.SetMute((not GetMasterMuteStatus(0)), nil);
    result := True;
  end
  else
  begin
    result := false;
    Code := GetMasterMute(0, MasterMute, mxct);
    if(Code = MMSYSERR_NOERROR)then
    begin
      with Details do
      begin
        cbStruct := SizeOf(Details);
        dwControlID := MasterMute.dwControlID;
        cChannels := 1;
        cMultipleItems := 0;
        cbDetails := SizeOf(BoolDetails);
        paDetails := @BoolDetails;
      end;
      mixerGetControlDetails(0, @Details, MIXER_GETCONTROLDETAILSF_VALUE);
  
      LongBool(BoolDetails.fValue) := not LongBool(BoolDetails.fValue);
  
      if(mixerSetControlDetails(0, @Details, MIXER_SETCONTROLDETAILSF_VALUE) = MMSYSERR_NOERROR)then
        result := true;
    end;
  end;
end;

function GetMasterMuteStatus(mxct : integer) : boolean;
var
  MasterMute: TMixerControl; 
  Details: TMixerControlDetails; 
  BoolDetails: TMixerControlDetailsBoolean; 
  Code: MMResult;
  bMuted: Boolean;
begin 
  result := false; 
  Code := GetMasterMute(0, MasterMute, mxct);
  if IsWindowsVista then
  begin
    MMEndPoint.GetMute(bMuted);
    Result := bMuted;
  end
  else
  begin
    if(Code = MMSYSERR_NOERROR)then
    begin
      with Details do
      begin
        cbStruct := SizeOf(Details);
        dwControlID := MasterMute.dwControlID;
        cChannels := 1;
        cMultipleItems := 0;
        cbDetails := SizeOf(BoolDetails);
        paDetails := @BoolDetails;
      end;
      mixerGetControlDetails(0, @Details, MIXER_GETCONTROLDETAILSF_VALUE);

      result := LongBool(BoolDetails.fValue);
    end;
  end;
end;


end.
