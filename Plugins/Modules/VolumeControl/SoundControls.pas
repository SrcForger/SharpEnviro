unit SoundControls;

interface

uses Windows,MMSystem;

function InitMixer: HMixer;
function MuteMaster(mxct : integer) : boolean; 
function SetMasterVolume(Value: Cardinal; mxct : integer) : boolean; 
function GetMasterVolume(mxct : integer) : Cardinal;
function GetMaterMuteStatus(mxct : integer) : boolean;
function GetMasterMute(Mixer: hMixerObj; var Control: TMixerControl; mxct : integer): MMResult;
function GetMasterVolumeControl(Mixer: hMixerObj; var Control: TMixerControl; mxct : integer): MMResult;

implementation

function InitMixer: HMixer; 
var 
  Err: MMRESULT; 
begin 
  Err := mixerOpen(@Result, 0, 0, 0, 0); 
  if Err <> MMSYSERR_NOERROR then 
    Result := 0; 
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
begin 
  Mixer := InitMixer; 
  Result := false; 
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

function GetMasterVolume(mxct : integer): Cardinal;
var
  MasterVolume    : TMixerControl;
  Details         : TMixerControlDetails;
  UnsignedDetails : TMixerControlDetailsUnsigned;
  Code            : MMResult;
  Mixer           : hMixerObj;
begin
  Mixer := InitMixer;
  Result := 0;
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

function GetMasterMute(Mixer: hMixerObj; var Control: TMixerControl; mxct : integer): MMResult;
  // Returns True on success
var
  Line: TMixerLine;
  Controls: TMixerLineControls;
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

function MuteMaster(mxct : integer) : boolean; 
var 
  MasterMute: TMixerControl; 
  Details: TMixerControlDetails; 
  BoolDetails: TMixerControlDetailsBoolean; 
  Code: MMResult; 
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

function GetMaterMuteStatus(mxct : integer) : boolean;
var
  MasterMute: TMixerControl; 
  Details: TMixerControlDetails; 
  BoolDetails: TMixerControlDetailsBoolean; 
  Code: MMResult; 
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

    result := LongBool(BoolDetails.fValue);
  end; 
end;

end.
