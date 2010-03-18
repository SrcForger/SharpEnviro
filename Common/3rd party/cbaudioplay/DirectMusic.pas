(*==========================================================================;
 *
 *  Copyright (C) 1995-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  Files:      dls1.h dls2.h dmdls.h dmerror.h dmksctrl.h dmplugin.h
 *              DMusBuff.h dmusicc.h dmusici.h dmusicf.h dmusbuff.h
 *  Content:    DirectMusic
 *
 *  DirectX 7.0 Delphi adaptation by Erik Unger
 *  DirectX 8.0 Delphi adaptation by Ivo Steinmann
 *
 *  Modified: 26-Nov-2000
 *
 *  Download: http://www.delphi-jedi.org/DelphiGraphics/
 *  E-Mail: isteinmann@bluewin.ch
 *
 ***************************************************************************)

(*==========================================================================;
 * History :
 *
 * 26-Nov-2000 (Tim Baumgarten) : Returncodes are now typecasted with HResult
 *
 ***************************************************************************)

{$MINENUMSIZE 4}
{$ALIGN ON}

unit DirectMusic;

interface                                                 

uses
  Windows,
  MMSystem,
  DirectSound,
  ActiveX;

function MAKE_HRESULT(sev,fac,code: DWORD) : HResult;

type
  mmioFOURCC = array [0..3] of Char;


(*==========================================================================;
//
//  dls1.h
//
//
//  Description:
//
//  Interface defines and structures for the Instrument Collection Form
//  RIFF DLS.
//
//
//  Written by Sonic Foundry 1996.  Released for public use.
//
//=========================================================================*)

(*//////////////////////////////////////////////////////////////////////////
//
//
// Layout of an instrument collection:
//
//
// RIFF [] 'DLS ' [dlid,colh,INSTLIST,WAVEPOOL,INFOLIST]
//
// INSTLIST
// LIST [] 'lins'
//               LIST [] 'ins ' [dlid,insh,RGNLIST,ARTLIST,INFOLIST]
//               LIST [] 'ins ' [dlid,insh,RGNLIST,ARTLIST,INFOLIST]
//               LIST [] 'ins ' [dlid,insh,RGNLIST,ARTLIST,INFOLIST]
//
// RGNLIST
// LIST [] 'lrgn'
//               LIST [] 'rgn '  [rgnh,wsmp,wlnk,ARTLIST]
//               LIST [] 'rgn '  [rgnh,wsmp,wlnk,ARTLIST]
//               LIST [] 'rgn '  [rgnh,wsmp,wlnk,ARTLIST]
//
// ARTLIST
// LIST [] 'lart'
//         'art1' level 1 Articulation connection graph
//         'art2' level 2 Articulation connection graph
//         '3rd1' Possible 3rd party articulation structure 1
//         '3rd2' Possible 3rd party articulation structure 2 .... and so on
//
// WAVEPOOL
// ptbl [] [pool table]
// LIST [] 'wvpl'
//               [path],
//               [path],
//               LIST [] 'wave' [dlid,RIFFWAVE]
//               LIST [] 'wave' [dlid,RIFFWAVE]
//               LIST [] 'wave' [dlid,RIFFWAVE]
//               LIST [] 'wave' [dlid,RIFFWAVE]
//               LIST [] 'wave' [dlid,RIFFWAVE]
//
// INFOLIST
// LIST [] 'INFO'
//               'icmt' 'One of those crazy comments.'
//               'icop' 'Copyright (C) 1996 Sonic Foundry'
//
////////////////////////////////////////////////////////////////////////(*)

(*/////////////////////////////////////////////////////////////////////////
// FOURCC's used in the DLS file
////////////////////////////////////////////////////////////////////////(*)

const
  FOURCC_DLS   : mmioFOURCC = ('D','L','S',' ');
  FOURCC_DLID  : mmioFOURCC = ('d','l','i','d');
  FOURCC_COLH  : mmioFOURCC = ('c','o','l','h');
  FOURCC_WVPL  : mmioFOURCC = ('w','v','p','l');
  FOURCC_PTBL  : mmioFOURCC = ('p','t','b','l');
  FOURCC_PATH  : mmioFOURCC = ('p','a','t','h');
  FOURCC_wave  : mmioFOURCC = ('w','a','v','e');
  FOURCC_LINS  : mmioFOURCC = ('l','i','n','s');
  FOURCC_INS   : mmioFOURCC = ('i','n','s',' ');
  FOURCC_INSH  : mmioFOURCC = ('i','n','s','h');
  FOURCC_LRGN  : mmioFOURCC = ('l','r','g','n');
  FOURCC_RGN   : mmioFOURCC = ('r','g','n',' ');
  FOURCC_RGNH  : mmioFOURCC = ('r','g','n','h');
  FOURCC_LART  : mmioFOURCC = ('l','a','r','t');
  FOURCC_ART1  : mmioFOURCC = ('a','r','t','1');
  FOURCC_WLNK  : mmioFOURCC = ('w','l','n','k');
  FOURCC_WSMP  : mmioFOURCC = ('w','s','m','p');
  FOURCC_VERS  : mmioFOURCC = ('v','e','r','s');

(*/////////////////////////////////////////////////////////////////////////
// Articulation connection graph definitions
////////////////////////////////////////////////////////////////////////(*)

(* Generic Sources *)
  CONN_SRC_NONE              = $0000;
  CONN_SRC_LFO               = $0001;
  CONN_SRC_KEYONVELOCITY     = $0002;
  CONN_SRC_KEYNUMBER         = $0003;
  CONN_SRC_EG1               = $0004;
  CONN_SRC_EG2               = $0005;
  CONN_SRC_PITCHWHEEL        = $0006;

(* Midi Controllers 0-127 *)
  CONN_SRC_CC1               = $0081;
  CONN_SRC_CC7               = $0087;
  CONN_SRC_CC10              = $008a;
  CONN_SRC_CC11              = $008b;

(* Generic Destinations *)
  CONN_DST_NONE              = $0000;
  CONN_DST_ATTENUATION       = $0001;
  CONN_DST_PITCH             = $0003;
  CONN_DST_PAN               = $0004;

(* LFO Destinations *)
  CONN_DST_LFO_FREQUENCY     = $0104;
  CONN_DST_LFO_STARTDELAY    = $0105;

(* EG1 Destinations *)
  CONN_DST_EG1_ATTACKTIME    = $0206;
  CONN_DST_EG1_DECAYTIME     = $0207;
  CONN_DST_EG1_RELEASETIME   = $0209;
  CONN_DST_EG1_SUSTAINLEVEL  = $020a;

(* EG2 Destinations *)
  CONN_DST_EG2_ATTACKTIME    = $030a;
  CONN_DST_EG2_DECAYTIME     = $030b;
  CONN_DST_EG2_RELEASETIME   = $030d;
  CONN_DST_EG2_SUSTAINLEVEL  = $030e;

  CONN_TRN_NONE              = $0000;
  CONN_TRN_CONCAVE           = $0001;

type
  PDLSId = ^TDLSId;
  TDLSId = packed record
    ulData1 : ULONG;
    usData2 : Word;
    usData3 : Word;
    abData4 : array [0..7] of BYTE;
  end;

  PDLSVersion = ^TDLSVersion;
  TDLSVersion = packed record
    dwVersionMS : DWORD;
    dwVersionLS : DWORD;
  end;

  PConnection = ^TConnection;
  TConnection = packed record
    usSource      : Word;
    usControl     : Word;
    SuDestination : Word;
    usTransform   : Word;
    lScale        : LongInt;
  end;

(* Level 1 Articulation Data *)

  PConnectionList = ^TConnectionList;
  TConnectionList = packed record
    cbSize       : ULONG;      (* size of the connection list structure *)
    cConnections : ULONG;      (* count of connections in the list *)
  end;

(*/////////////////////////////////////////////////////////////////////////
// Generic type defines for regions and instruments
////////////////////////////////////////////////////////////////////////(*)

  PRGNRange = ^TRGNRange;
  TRGNRange = packed record
    usLow  : Word;
    usHigh : Word;
  end;

const
  F_INSTRUMENT_DRUMS      = $80000000;

type
  PMIDILocale = ^TMIDILocale;
  TMIDILocale = packed record
    ulBank       : ULONG;
    ulInstrument : ULONG;
  end;

(*/////////////////////////////////////////////////////////////////////////
// Header structures found in an DLS file for collection, instruments, and
// regions.
////////////////////////////////////////////////////////////////////////(*)

const
  F_RGN_OPTION_SELFNONEXCLUSIVE  = $0001;

type
  PRGNHeader = ^TRGNHeader;
  TRGNHeader = packed record
    RangeKey      : TRGNRange;     (* Key range  *)
    RangeVelocity : TRGNRange;     (* Velocity Range  *)
    fusOptions    : Word   ;       (* Synthesis options for this range *)
    usKeyGroup    : Word   ;       (* Key grouping for non simultaneous play *)
                                   (* 0 = no group, 1 up is group *)
                                   (* for Level 1 only groups 1-15 are allowed *)
  end;

  PInstHeader = ^TInstHeader;
  TInstHeader = packed record
    cRegions : ULONG;                (* Count of regions in this instrument *)
    Locale   : TMIDILocale;          (* Intended MIDI locale of this instrument *)
  end;

  PDLSHeader = ^TDLSHeader;
  TDLSHeader = packed record
    cInstruments : ULONG;
  end;

(*////////////////////////////////////////////////////////////////////////////
// definitions for the Wave link structure
///////////////////////////////////////////////////////////////////////////(*)

(* ****  For level 1 only WAVELINK_CHANNEL_MONO is valid  **** *)
(* ulChannel allows for up to 32 channels of audio with each bit position *)
(* specifiying a channel of playback *)

const
  WAVELINK_CHANNEL_LEFT    = $0001;
  WAVELINK_CHANNEL_RIGHT   = $0002;

  F_WAVELINK_PHASE_MASTER  = $0001;

type
  PWaveLink = ^TWaveLink;
  TWaveLink = packed record  (* any paths or links are stored right after struct *)
    fusOptions   : Word;     (* options flags for this wave *)
    usPhaseGroup : Word;     (* Phase grouping for locking channels *)
    ulChannel    : ULONG;    (* channel placement *)
    ulTableIndex : ULONG;    (* index into the wave pool table, 0 based *)
  end;

const
  POOL_CUE_NULL  = $ffffffff;

type
  PPoolCUE = ^TPoolCUE;
  TPoolCUE = packed record
    ulOffset : ULONG;
  end;

  PPoolTable = ^TPoolTable;
  TPoolTable = packed record
    cbSize : ULONG;             (* size of the pool table structure *)
    cCues  :  ULONG;            (* count of cues in the list *)
  end;

(*////////////////////////////////////////////////////////////////////////////
// Structures for the "wsmp" chunk
///////////////////////////////////////////////////////////////////////////(*)

const
  F_WSMP_NO_TRUNCATION     = $0001;
  F_WSMP_NO_COMPRESSION    = $0002;

type
  PWSMPL = ^TWSMPL;
  TWSMPL = packed record
    cbSize       : ULONG;
    usUnityNote  : Word;       (* MIDI Unity Playback Note *)
    sFineTune    : SmallInt;   (* Fine Tune in log tuning *)
    lAttenuation : Integer;    (* Overall Attenuation to be applied to data *)
    fulOptions   : ULONG;      (* Flag options  *)
    cSampleLoops : ULONG;      (* Count of Sample loops, 0 loops is one shot *)
  end;


(* This loop type is a normal forward playing loop which is continually *)
(* played until the envelope reaches an off threshold in the release *)
(* portion of the volume envelope *)

const
  WLOOP_TYPE_FORWARD  = 0;

type
  TWLoop = packed record
    cbSize   : ULONG;
    ulType   : ULONG;           (* Loop Type *)
    ulStart  : ULONG;           (* Start of loop in samples *)
    ulLength : ULONG;           (* Length of loop in samples *)
  end;

(*******************************************************************************

dls2.h

Description:

Interface defines and structures for the DLS2 extensions of DLS.


  Written by Microsoft 1998.  Released for public use.

*******************************************************************************)

(*
  FOURCC's used in the DLS2 file, in addition to DLS1 chunks
*)
const
  FOURCC_RGN2  : mmioFOURCC = ('r','g','n','2');
  FOURCC_LAR2  : mmioFOURCC = ('l','a','r','2');
  FOURCC_ART2  : mmioFOURCC = ('a','r','t','2');
  FOURCC_CDL   : mmioFOURCC = ('c','d','l',' ');
  //FOURCC_DLID  : mmioFOURCC = ('d','l','i','d');

(*
  Articulation connection graph definitions. These are in addition to
  the definitions in the DLS1 header.
*)

const
(* Generic Sources (in addition to DLS1 sources. *)
  CONN_SRC_POLYPRESSURE		    = $0007;	(* Polyphonic Pressure *)
  CONN_SRC_CHANNELPRESSURE	    = $0008;	(* Channel Pressure *)
  CONN_SRC_VIBRATO		    = $0009;	(* Vibrato LFO *)
  CONN_SRC_MONOPRESSURE             = $000a;      (* MIDI Mono pressure *)


(* Midi Controllers *)
  CONN_SRC_CC91			    = $00db;	(* Reverb Send *)
  CONN_SRC_CC93			    = $00dd;	(* Chorus Send *)


(* Generic Destinations *)
  CONN_DST_GAIN		    	    = $0001;	(* Same as CONN_DST_ ATTENUATION *)
  CONN_DST_KEYNUMBER 		    = $0005;	(* Key Number Generator *)

(* Audio Channel Output Destinations *)
  CONN_DST_LEFT			    = $0010;	(* Left Channel Send *)
  CONN_DST_RIGHT		    = $0011;	(* Right Channel Send *)
  CONN_DST_CENTER		    = $0012;	(* Center Channel Send *)
  CONN_DST_LEFTREAR		    = $0013;	(* Left Rear Channel Send *)
  CONN_DST_RIGHTREAR		    = $0014;	(* Right Rear Channel Send *)
  CONN_DST_LFE_CHANNEL	            = $0015;	(* LFE Channel Send *)
  CONN_DST_CHORUS		    = $0080;	(* Chorus Send *)
  CONN_DST_REVERB		    = $0081;	(* Reverb Send *)

(* Vibrato LFO Destinations *)
  CONN_DST_VIB_FREQUENCY	    = $0114;	(* Vibrato Frequency *)
  CONN_DST_VIB_STARTDELAY	    = $0115;	(* Vibrato Start Delay *)

(* EG1 Destinations *)
  CONN_DST_EG1_DELAYTIME	    = $020B;	(* EG1 Delay Time *)
  CONN_DST_EG1_HOLDTIME	  	    = $020C;	(* EG1 Hold Time *)


(*	EG2 Destinations *)
  CONN_DST_EG2_DELAYTIME	    = $030F;	(* EG2 Delay Time *)
  CONN_DST_EG2_HOLDTIME	  	    = $0310;	(* EG2 Hold Time *)


(* Filter Destinations *)
  CONN_DST_FILTER_CUTOFF	    = $0500;	(* Filter Cutoff Frequency *)
  CONN_DST_FILTER_Q		    = $0501;	(* Filter Resonance *)


(* Transforms *)
  CONN_TRN_CONVEX		    = $0002;	(* Convex Transform *)
  CONN_TRN_SWITCH		    = $0003;	(* Switch Transform *)


(*	Conditional chunk operators *)
  DLS_CDL_AND			    = $0001;	(* X = X & Y *)
  DLS_CDL_OR			    = $0002;	(* X = X | Y *)
  DLS_CDL_XOR			    = $0003;	(* X = X ^ Y *)
  DLS_CDL_ADD		   	    = $0004;	(* X = X + Y *)
  DLS_CDL_SUBTRACT   	            = $0005;	(* X = X - Y *)
  DLS_CDL_MULTIPLY	            = $0006;	(* X = X * Y *)
  DLS_CDL_DIVIDE		    = $0007;	(* X = X / Y *)
  DLS_CDL_LOGICAL_AND	            = $0008;	(* X = X && Y *)
  DLS_CDL_LOGICAL_OR	            = $0009;	(* X = X || Y *)
  DLS_CDL_LT			    = $000A;	(* X = (X < Y) *)
  DLS_CDL_LE			    = $000B;	(* X = (X <= Y) *)
  DLS_CDL_GT	    		    = $000C;	(* X = (X > Y) *)
  DLS_CDL_GE		    	    = $000D;	(* X = (X >= Y) *)
  DLS_CDL_EQ		    	    = $000E;	(* X = (X == Y) *)
  DLS_CDL_NOT	   		    = $000F;	(* X = !X *)
  DLS_CDL_CONST	    	            = $0010;	(* 32-bit constant *)
  DLS_CDL_QUERY	    	            = $0011;	(* 32-bit value returned from query *)
  DLS_CDL_QUERYSUPPORTED            = $0012;	(* Test to see if DLSID Query is supported *)

(*
Loop and release
*)

  WLOOP_TYPE_RELEASE  = 2;

(*
DLSID queries for <cdl-ck>
*)

  DLSID_GMInHardware       : TGUID = '{178f2f24-c364-11d1-a760-0000f875ac12}';
  DLSID_GSInHardware       : TGUID = '{178f2f25-c364-11d1-a760-0000f875ac12}';
  DLSID_XGInHardware       : TGUID = '{178f2f26-c364-11d1-a760-0000f875ac12}';
  DLSID_SupportsDLS1       : TGUID = '{178f2f27-c364-11d1-a760-0000f875ac12}';
  DLSID_SupportsDLS2       : TGUID = '{f14599e5-4689-11d2-afa6-00aa0024d8b6}';
  DLSID_SampleMemorySize   : TGUID = '{178f2f28-c364-11d1-a760-0000f875ac12}';
  DLSID_ManufacturersID    : TGUID = '{b03e1181-8095-11d2-a1ef-00600833dbd8}';
  DLSID_ProductID          : TGUID = '{b03e1182-8095-11d2-a1ef-00600833dbd8}';
  DLSID_SamplePlaybackRate : TGUID = '{2a91f713-a4bf-11d2-bbdf-00600833dbd8}';

(************************************************************************
*                                                                       *
*   dmdls.h -- DLS download definitions for DirectMusic API's           *
*                                                                       *
*   Copyright (c) 1998, Microsoft Corp. All rights reserved.            *
*                                                                       *
************************************************************************)

type
  TPCent   =   LongInt;  (* Pitch cents *)
  TGCent   =   LongInt;  (* Gain cents *)
  TTCent   =   LongInt;  (* Time cents *)
  TPercent =   LongInt;  (* Per.. cent! *)

  PReference_Time = ^TReference_Time;
  TReference_Time = LongLong;

  TFourCC = DWORD;   (* a four character code *)

function MAKEFOURCC (ch0, ch1, ch2, ch3: Char) : TFourCC;

type
  TDMus_DownloadInfor = packed record
    dwDLType                : DWORD;      (* Instrument or Wave *)
    dwDLId                  : DWORD;      (* Unique identifier to tag this download. *)
    dwNumOffsetTableEntries : DWORD;      (* Number of index in the offset address table. *)
    cbSize                  : DWORD;      (* Total size of this memory chunk. *)
  end;

const
  DMUS_DOWNLOADINFO_INSTRUMENT       = 1;
  DMUS_DOWNLOADINFO_WAVE             = 2;
  DMUS_DOWNLOADINFO_INSTRUMENT2      = 3;   (* New version for better DLS2 support. *)
(* Support for oneshot and streaming wave data *)
  DMUS_DOWNLOADINFO_WAVEARTICULATION = 4;   (* Wave articulation data *)
  DMUS_DOWNLOADINFO_STREAMINGWAVE    = 5;   (* One chunk of a streaming *)
  DMUS_DOWNLOADINFO_ONESHOTWAVE      = 6;

  DMUS_DEFAULT_SIZE_OFFSETTABLE      = 1;

(* Flags for DMUS_INSTRUMENT's ulFlags member *)

  DMUS_INSTRUMENT_GM_INSTRUMENT      = 1 shl 0;

type
  TDMus_OffsetTable = packed record
    ulOffsetTable : array [0..DMUS_DEFAULT_SIZE_OFFSETTABLE-1] of ULONG;
  end;

  TDMus_Instrument = packed record
    ulPatch          : ULONG;
    ulFirstRegionIdx : ULONG;
    ulGlobalArtIdx   : ULONG;                 (* If zero the instrument does not have an articulation *)
    ulFirstExtCkIdx  : ULONG;                 (* If zero no 3rd party entenstion chunks associated with the instrument *)
    ulCopyrightIdx   : ULONG;                 (* If zero no Copyright information associated with the instrument *)
    ulFlags          : ULONG;
  end;

  TDMus_Region = packed record
    RangeKey        : TRGNRange;
    RangeVelocity   : TRGNRange;
    fusOptions      : Word;
    usKeyGroup      : Word;
    ulRegionArtIdx  : ULONG;                 (* If zero the region does not have an articulation *)
    ulNextRegionIdx : ULONG;                 (* If zero no more regions *)
    ulFirstExtCkIdx : ULONG;                 (* If zero no 3rd party entenstion chunks associated with the region *)
    WaveLink        : TWaveLink;
    WSMP            : TWSMPL;                (*  If WSMP.cSampleLoops > 1 then a WLOOP is included *)
    WLOOP           : array [0..0] of TWLoop;
  end;

  TDMus_LFOParams = packed record
    pcFrequency   : TPCent;
    tcDelay       : TTCent;
    gcVolumeScale : TGCent;
    pcPitchScale  : TPCent;
    gcMWToVolume  : TGCent;
    pcMWToPitch   : TPCent;
  end;

  TDMus_VEGParams = packed record
    tcAttack     : TTCent;
    tcDecay      : TTCent;
    ptSustain    : TPercent;
    tcRelease    : TTCent;
    tcVel2Attack : TTCent;
    tcKey2Decay  : TTCent;
  end;

  TDMus_PEGParams = packed record
    tcAttack     : TTCent;
    tcDecay      : TTCent;
    ptSustain    : TPercent;
    tcRelease    : TTCent;
    tcVel2Attack : TTCent;
    tcKey2Decay  : TTCent;
    pcRange      : TPCent;
  end;

  TDMus_MSCParams = packed record
    ptDefaultPan : TPercent;
  end;

  TDMus_ArticParams = packed record
    LFO     : TDMus_LFOParams;
    VolEG   : TDMus_VEGParams;
    PitchEG : TDMus_PEGParams;
    Misc    : TDMus_MSCParams;
  end;

  TDMus_Articulation = packed record
    ulArt1Idx       : ULONG;                  (* If zero no DLS Level 1 articulation chunk *)
    ulFirstExtCkIdx : ULONG;                  (* If zero no 3rd party entenstion chunks associated with the articulation *)
  end;

const
  DMUS_MIN_DATA_SIZE = 4;

(*  The actual number is determined by cbSize of struct _DMUS_EXTENSIONCHUNK *)

type
  DMus_ExtensionChunk = packed record
    cbSize         : ULONG;                                    (*  Size of extension chunk  *)
    ulNextExtCkIdx : ULONG;                                    (*  If zero no more 3rd party entenstion chunks *)
    ExtCkID        : TFourCC;
    byExtCk        : array [0..DMUS_MIN_DATA_SIZE-1] of BYTE;  (*  The actual number that follows is determined by cbSize *)
  end;

(*  The actual number is determined by cbSize of struct _DMUS_COPYRIGHT *)

  TDmus_Copyright = packed record
    cbSize      : ULONG;                                                 (*  Size of copyright information *)
    byCopyright : array [0..DMUS_MIN_DATA_SIZE-1] of BYTE;               (*  The actual number that follows is determined by cbSize *)
  end;

  TDMus_WaveData = packed record
    cbSize : ULONG;
    byData : array [0..DMUS_MIN_DATA_SIZE-1] of BYTE;
  end;

  TDMus_Wave = packed record
    ulFirstExtCkIdx : ULONG;              (* If zero no 3rd party entenstion chunks associated with the wave *)
    ulCopyrightIdx  : ULONG;              (* If zero no Copyright information associated with the wave *)
    ulWaveDataIdx   : ULONG;              (* Location of actual wave data. *)
///    WaveformatEx:    TWaveFormatEx;
  end;

  PDMus_NoteRange = ^TDMus_NoteRange;
  TDMus_NoteRange = packed record
    dwLowNote  : DWORD;           (* Sets the low note for the range of MIDI note events to which the instrument responds.*)
    dwHighNote : DWORD;           (* Sets the high note for the range of MIDI note events to which the instrument responds.*)
  end;

  PDMUS_WaveDL = ^TDMUS_WaveDL;
  TDMUS_WaveDL = packed record
    cbWaveData : ULONG;
  end;

(************************************************************************
*                                                                       *
*   dmerror.h -- Error code returned by DirectMusic API's               *
*                                                                       *
*   Copyright (c) 1998, Microsoft Corp. All rights reserved.            *
*                                                                       *
************************************************************************)

const
  FACILITY_DIRECTMUSIC      = $878;       (* Shared with DirectSound *)
  DMUS_ERRBASE              = $1000;      (* Make error codes human readable in hex *)

  MAKE_DMHRESULTSUCCESS = (0 shl 31) or (FACILITY_DIRECTMUSIC shl 16) or DMUS_ERRBASE;
  MAKE_DMHRESULTERROR =   (1 shl 31) or (FACILITY_DIRECTMUSIC shl 16) or DMUS_ERRBASE;


(* DMUS_S_PARTIALLOAD
 *
 * The object could only load partially. This can happen if some components are
 * not registered properly, such as embedded tracks and tools.
 *)
  DMUS_S_PARTIALLOAD               = MAKE_DMHRESULTSUCCESS + $091;

(* DMUS_S_PARTIALDOWNLOAD
 *
 * This code indicates that a band download was only successful in reaching
 * some, but not all, of the referenced ports. Some samples may not play
 * correctly.
 *)
  DMUS_S_PARTIALDOWNLOAD          = MAKE_DMHRESULTSUCCESS + $092;

(* DMUS_S_REQUEUE
 *
 * Return value from IDirectMusicTool::ProcessPMsg() which indicates to the
 * performance that it should cue the PMsg again automatically.
 *)
  DMUS_S_REQUEUE                   = MAKE_DMHRESULTSUCCESS + $200;

(* DMUS_S_FREE
 *
 * Return value from IDirectMusicTool::ProcessPMsg() which indicates to the
 * performance that it should free the PMsg automatically.
 *)
  DMUS_S_FREE                      = MAKE_DMHRESULTSUCCESS + $201;

(* DMUS_S_END
 *
 * Return value from IDirectMusicTrack::Play() which indicates to the
 * segment that the track has no more data after mtEnd.
 *)
  DMUS_S_END                       = MAKE_DMHRESULTSUCCESS + $202;

(* DMUS_S_STRING_TRUNCATED
 *
 * Returned string has been truncated to fit the buffer size.
 *)
  DMUS_S_STRING_TRUNCATED          = MAKE_DMHRESULTSUCCESS + $210;

(* DMUS_S_LAST_TOOL
 *
 * Returned from IDirectMusicGraph::StampPMsg(), this indicates that the PMsg
 * is already stamped with the last tool in the graph. The returned PMsg's
 * tool pointer is now NULL.
 *)
  DMUS_S_LAST_TOOL                 = MAKE_DMHRESULTSUCCESS + $211;

(* DMUS_S_OVER_CHORD
 *
 * Returned from IDirectMusicPerformance::MusicToMIDI(), this indicates 
 * that no note has been calculated because the music value has the note 
 * at a position higher than the top note of the chord. This applies only
 * to DMUS_PLAYMODE_NORMALCHORD play mode. This success code indicates
 * that the caller should not do anything with the note. It is not meant
 * to be played against this chord.
 *)
  DMUS_S_OVER_CHORD                = MAKE_DMHRESULTSUCCESS + $212;

(* DMUS_S_UP_OCTAVE
 *
 * Returned from IDirectMusicPerformance::MIDIToMusic(),  and
 * IDirectMusicPerformance::MusicToMIDI(), this indicates 
 * that the note conversion generated a note value that is below 0, 
 * so it has been bumped up one or more octaves to be in the proper
 * MIDI range of 0 through 127. 
 * Note that this is valid for MIDIToMusic() when using play modes
 * DMUS_PLAYMODE_FIXEDTOCHORD and DMUS_PLAYMODE_FIXEDTOKEY, both of
 * which store MIDI values in wMusicValue. With MusicToMIDI(), it is
 * valid for all play modes.
 * Ofcourse, DMUS_PLAYMODE_FIXED will never return this success code.
 *)
  DMUS_S_UP_OCTAVE                 = MAKE_DMHRESULTSUCCESS + $213;

(* DMUS_S_DOWN_OCTAVE
 *
 * Returned from IDirectMusicPerformance::MIDIToMusic(),  and
 * IDirectMusicPerformance::MusicToMIDI(), this indicates
 * that the note conversion generated a note value that is above 127, 
 * so it has been bumped down one or more octaves to be in the proper
 * MIDI range of 0 through 127. 
 * Note that this is valid for MIDIToMusic() when using play modes
 * DMUS_PLAYMODE_FIXEDTOCHORD and DMUS_PLAYMODE_FIXEDTOKEY, both of
 * which store MIDI values in wMusicValue. With MusicToMIDI(), it is
 * valid for all play modes.
 * Ofcourse, DMUS_PLAYMODE_FIXED will never return this success code.
 *)
  DMUS_S_DOWN_OCTAVE               = MAKE_DMHRESULTSUCCESS + $214;

(* DMUS_S_NOBUFFERCONTROL
 *
 * Although the audio output from the port will be routed to the
 * same device as the given DirectSound buffer, buffer controls
 * such as pan and volume will not affect the output.
 *
 *)
  DMUS_S_NOBUFFERCONTROL          = MAKE_DMHRESULTSUCCESS + $215;

(* DMUS_S_GARBAGE_COLLECTED
 *
 * The requested operation was not performed because during CollectGarbage
 * the loader determined that the object had been released.
 *)
  DMUS_S_GARBAGE_COLLECTED        = MAKE_DMHRESULTSUCCESS + $216;

(* DMUS_E_DRIVER_FAILED
 *
 * An unexpected error was returned from a device driver, indicating
 * possible failure of the driver or hardware.
 *)
  DMUS_E_DRIVER_FAILED            = MAKE_DMHRESULTERROR + $0101;

(* DMUS_E_PORTS_OPEN
 *
 * The requested operation cannot be performed while there are 
 * instantiated ports in any process in the system.
 *)
  DMUS_E_PORTS_OPEN               = MAKE_DMHRESULTERROR + $0102;

(* DMUS_E_DEVICE_IN_USE
 *
 * The requested device is already in use (possibly by a non-DirectMusic
 * client) and cannot be opened again.
 *)
  DMUS_E_DEVICE_IN_USE            = MAKE_DMHRESULTERROR + $0103;

(* DMUS_E_INSUFFICIENTBUFFER
 *
 * Buffer is not large enough for requested operation.
 *)
  DMUS_E_INSUFFICIENTBUFFER       = MAKE_DMHRESULTERROR + $0104;

(* DMUS_E_BUFFERNOTSET
 *
 * No buffer was prepared for the download data.
 *)
  DMUS_E_BUFFERNOTSET             = MAKE_DMHRESULTERROR + $0105;

(* DMUS_E_BUFFERNOTAVAILABLE
 *
 * Download failed due to inability to access or create download buffer.
 *)
  DMUS_E_BUFFERNOTAVAILABLE       = MAKE_DMHRESULTERROR + $0106;

(* DMUS_E_NOTADLSCOL
 *
 * Error parsing DLS collection. File is corrupt.
 *)
  DMUS_E_NOTADLSCOL               = MAKE_DMHRESULTERROR + $0108;

(* DMUS_E_INVALIDOFFSET
 *
 * Wave chunks in DLS collection file are at incorrect offsets.
 *)
  DMUS_E_INVALIDOFFSET            = MAKE_DMHRESULTERROR + $0109;

(* DMUS_E_ALREADY_LOADED
 *
 * Second attempt to load a DLS collection that is currently open.
 *)
  DMUS_E_ALREADY_LOADED           = MAKE_DMHRESULTERROR + $0111;

(* DMUS_E_INVALIDPOS
 *
 * Error reading wave data from DLS collection. Indicates bad file.
 *)
  DMUS_E_INVALIDPOS               = MAKE_DMHRESULTERROR + $0113;

(* DMUS_E_INVALIDPATCH
 *
 * There is no instrument in the collection that matches patch number.
 *)
  DMUS_E_INVALIDPATCH             = MAKE_DMHRESULTERROR + $0114;

(* DMUS_E_CANNOTSEEK
 *
 * The IStream* doesn't support Seek().
 *)
  DMUS_E_CANNOTSEEK               = MAKE_DMHRESULTERROR + $0115;

(* DMUS_E_CANNOTWRITE
 *
 * The IStream* doesn't support Write().
 *)
  DMUS_E_CANNOTWRITE              = MAKE_DMHRESULTERROR + $0116;

(* DMUS_E_CHUNKNOTFOUND
 *
 * The RIFF parser doesn't contain a required chunk while parsing file.
 *)
  DMUS_E_CHUNKNOTFOUND            = MAKE_DMHRESULTERROR + $0117;

(* DMUS_E_INVALID_DOWNLOADID
 *
 * Invalid download id was used in the process of creating a download buffer.
 *)
  DMUS_E_INVALID_DOWNLOADID       = MAKE_DMHRESULTERROR + $0119;

(* DMUS_E_NOT_DOWNLOADED_TO_PORT
 *
 * Tried to unload an object that was not downloaded or previously unloaded.
 *)
  DMUS_E_NOT_DOWNLOADED_TO_PORT   = MAKE_DMHRESULTERROR + $0120;

(* DMUS_E_ALREADY_DOWNLOADED
 *
 * Buffer was already downloaded to synth.
 *)
  DMUS_E_ALREADY_DOWNLOADED       = MAKE_DMHRESULTERROR + $0121;

(* DMUS_E_UNKNOWN_PROPERTY
 *
 * The specified property item was not recognized by the target object.
 *)
  DMUS_E_UNKNOWN_PROPERTY         = MAKE_DMHRESULTERROR + $0122;

(* DMUS_E_SET_UNSUPPORTED
 *
 * The specified property item may not be set on the target object.
 *)
  DMUS_E_SET_UNSUPPORTED          = MAKE_DMHRESULTERROR + $0123;

(* DMUS_E_GET_UNSUPPORTED
 *
 * The specified property item may not be retrieved from the target object.
 *)
  DMUS_E_GET_UNSUPPORTED          = MAKE_DMHRESULTERROR + $0124;

(* DMUS_E_NOTMONO
 *
 * Wave chunk has more than one interleaved channel. DLS format requires MONO.
 *)
  DMUS_E_NOTMONO                  = MAKE_DMHRESULTERROR + $0125;

(* DMUS_E_BADARTICULATION
 *
 * Invalid articulation chunk in DLS collection.
 *)
  DMUS_E_BADARTICULATION          = MAKE_DMHRESULTERROR + $0126;

(* DMUS_E_BADINSTRUMENT
 *
 * Invalid instrument chunk in DLS collection.
 *)
  DMUS_E_BADINSTRUMENT            = MAKE_DMHRESULTERROR + $0127;

(* DMUS_E_BADWAVELINK
 *
 * Wavelink chunk in DLS collection points to invalid wave.
 *)
  DMUS_E_BADWAVELINK              = MAKE_DMHRESULTERROR + $0128;

(* DMUS_E_NOARTICULATION
 *
 * Articulation missing from instrument in DLS collection.
 *)
  DMUS_E_NOARTICULATION           = MAKE_DMHRESULTERROR + $0129;

(* DMUS_E_NOTPCM
 *
 * Downoaded DLS wave is not in PCM format.
*)
  DMUS_E_NOTPCM                   = MAKE_DMHRESULTERROR + $012A;

(* DMUS_E_BADWAVE
 *
 * Bad wave chunk in DLS collection
 *)
  DMUS_E_BADWAVE                  = MAKE_DMHRESULTERROR + $012B;

(* DMUS_E_BADOFFSETTABLE
 *
 * Offset Table for download buffer has errors. 
 *)
  DMUS_E_BADOFFSETTABLE           = MAKE_DMHRESULTERROR + $012C;

(* DMUS_E_UNKNOWNDOWNLOAD
 *
 * Attempted to download unknown data type.
 *)
  DMUS_E_UNKNOWNDOWNLOAD          = MAKE_DMHRESULTERROR + $012D;

(* DMUS_E_NOSYNTHSINK
 *
 * The operation could not be completed because no sink was connected to
 * the synthesizer.
 *)
  DMUS_E_NOSYNTHSINK              = MAKE_DMHRESULTERROR + $012E;

(* DMUS_E_ALREADYOPEN
 *
 * An attempt was made to open the software synthesizer while it was already
 * open.
 * ASSERT?
 *)
  DMUS_E_ALREADYOPEN              = MAKE_DMHRESULTERROR + $012F;

(* DMUS_E_ALREADYCLOSE
 *
 * An attempt was made to close the software synthesizer while it was already
 * open.
 * ASSERT?
 *)
  DMUS_E_ALREADYCLOSED            = MAKE_DMHRESULTERROR + $0130;

(* DMUS_E_SYNTHNOTCONFIGURED
 *
 * The operation could not be completed because the software synth has not
 * yet been fully configured.
 * ASSERT?
 *)
  DMUS_E_SYNTHNOTCONFIGURED       = MAKE_DMHRESULTERROR + $0131;

(* DMUS_E_SYNTHACTIVE
 *
 * The operation cannot be carried out while the synthesizer is active.
 *)
  DMUS_E_SYNTHACTIVE              = MAKE_DMHRESULTERROR + $0132;

(* DMUS_E_CANNOTREAD
 *
 * An error occurred while attempting to read from the IStream* object.
 *)
  DMUS_E_CANNOTREAD               = MAKE_DMHRESULTERROR + $0133;

(* DMUS_E_DMUSIC_RELEASED
 *
 * The operation cannot be performed because the final instance of the
 * DirectMusic object was released. Ports cannot be used after final 
 * release of the DirectMusic object.
 *)
  DMUS_E_DMUSIC_RELEASED          = MAKE_DMHRESULTERROR + $0134;

(* DMUS_E_BUFFER_EMPTY
 *
 * There was no data in the referenced buffer.
 *)
  DMUS_E_BUFFER_EMPTY             = MAKE_DMHRESULTERROR + $0135;

(* DMUS_E_BUFFER_FULL
 *
 * There is insufficient space to insert the given event into the buffer.
 *)
  DMUS_E_BUFFER_FULL              = MAKE_DMHRESULTERROR + $0136;

(* DMUS_E_PORT_NOT_CAPTURE
 *
 * The given operation could not be carried out because the port is a
 * capture port.
 *)
  DMUS_E_PORT_NOT_CAPTURE         = MAKE_DMHRESULTERROR + $0137;

(* DMUS_E_PORT_NOT_RENDER
 *
 * The given operation could not be carried out because the port is a
 * render port.
 *)
  DMUS_E_PORT_NOT_RENDER          = MAKE_DMHRESULTERROR + $0138;

(* DMUS_E_DSOUND_NOT_SET
 *
 * The port could not be created because no DirectSound has been specified.
 * Specify a DirectSound interface via the IDirectMusic::SetDirectSound
 * method; pass NULL to have DirectMusic manage usage of DirectSound.
 *)
  DMUS_E_DSOUND_NOT_SET           = MAKE_DMHRESULTERROR + $0139;

(* DMUS_E_ALREADY_ACTIVATED
 *
 * The operation cannot be carried out while the port is active.
 *)
  DMUS_E_ALREADY_ACTIVATED        = MAKE_DMHRESULTERROR + $013A;

(* DMUS_E_INVALIDBUFFER
 *
 * Invalid DirectSound buffer was handed to port.
 *)
  DMUS_E_INVALIDBUFFER            = MAKE_DMHRESULTERROR + $013B;

(* DMUS_E_WAVEFORMATNOTSUPPORTED
 *
 * Invalid buffer format was handed to the synth sink.
 *)
  DMUS_E_WAVEFORMATNOTSUPPORTED   = MAKE_DMHRESULTERROR + $013C;

(* DMUS_E_SYNTHINACTIVE
 *
 * The operation cannot be carried out while the synthesizer is inactive.
 *)
  DMUS_E_SYNTHINACTIVE            = MAKE_DMHRESULTERROR + $013D;

(* DMUS_E_DSOUND_ALREADY_SET
 *
 * IDirectMusic::SetDirectSound has already been called. It may not be
 * changed while in use.
 *)
  DMUS_E_DSOUND_ALREADY_SET       = MAKE_DMHRESULTERROR + $013E;

(* DMUS_E_INVALID_EVENT
 *
 * The given event is invalid (either it is not a valid MIDI message
 * or it makes use of running status). The event cannot be packed
 * into the buffer.
 *)
  DMUS_E_INVALID_EVENT            = MAKE_DMHRESULTERROR + $013F;

(* DMUS_E_UNSUPPORTED_STREAM
 *
 * The IStream* object does not contain data supported by the loading object.
 *)
  DMUS_E_UNSUPPORTED_STREAM       = MAKE_DMHRESULTERROR + $0150;

(* DMUS_E_ALREADY_INITED
 *
 * The object has already been initialized.
 *)
  DMUS_E_ALREADY_INITED           = MAKE_DMHRESULTERROR + $0151;

(* DMUS_E_INVALID_BAND
 *
 * The file does not contain a valid band.
 *)
  DMUS_E_INVALID_BAND             = MAKE_DMHRESULTERROR + $0152;

(* DMUS_E_TRACK_HDR_NOT_FIRST_CK
 *
 * The IStream* object's data does not have a track header as the first chunk,
 * and therefore can not be read by the segment object.
 *)
  DMUS_E_TRACK_HDR_NOT_FIRST_CK   = MAKE_DMHRESULTERROR + $0155;

(* DMUS_E_TOOL_HDR_NOT_FIRST_CK
 *
 * The IStream* object's data does not have a tool header as the first chunk,
 * and therefore can not be read by the graph object.
 *)
  DMUS_E_TOOL_HDR_NOT_FIRST_CK    = MAKE_DMHRESULTERROR + $0156;

(* DMUS_E_INVALID_TRACK_HDR
 *
 * The IStream* object's data contains an invalid track header (ckid is 0 and
 * fccType is NULL,) and therefore can not be read by the segment object.
 *)
  DMUS_E_INVALID_TRACK_HDR        = MAKE_DMHRESULTERROR + $0157;

(* DMUS_E_INVALID_TOOL_HDR
 *
 * The IStream* object's data contains an invalid tool header (ckid is 0 and
 * fccType is NULL,) and therefore can not be read by the graph object.
 *)
  DMUS_E_INVALID_TOOL_HDR         = MAKE_DMHRESULTERROR + $0158;

(* DMUS_E_ALL_TOOLS_FAILED
 *
 * The graph object was unable to load all tools from the IStream* object data.
 * This may be due to errors in the stream, or the tools being incorrectly
 * registered on the client.
 *)
  DMUS_E_ALL_TOOLS_FAILED         = MAKE_DMHRESULTERROR + $0159;

(* DMUS_E_ALL_TRACKS_FAILED
 *
 * The segment object was unable to load all tracks from the IStream* object data.
 * This may be due to errors in the stream, or the tracks being incorrectly
 * registered on the client.
 *)
  DMUS_E_ALL_TRACKS_FAILED        = MAKE_DMHRESULTERROR + $0160;

(* DMUS_E_NOT_FOUND
 *
 * The requested item was not contained by the object.
 *)
  DMUS_E_NOT_FOUND                = MAKE_DMHRESULTERROR + $0161;

(* DMUS_E_NOT_INIT
 *
 * A required object is not initialized or failed to initialize.
 *)
  DMUS_E_NOT_INIT                 = MAKE_DMHRESULTERROR + $0162;

(* DMUS_E_TYPE_DISABLED
 *
 * The requested parameter type is currently disabled. Parameter types may
 * be enabled and disabled by certain calls to SetParam().
 *)
  DMUS_E_TYPE_DISABLED            = MAKE_DMHRESULTERROR + $0163;

(* DMUS_E_TYPE_UNSUPPORTED
 *
 * The requested parameter type is not supported on the object.
 *)
  DMUS_E_TYPE_UNSUPPORTED         = MAKE_DMHRESULTERROR + $0164;

(* DMUS_E_TIME_PAST
 *
 * The time is in the past, and the operation can not succeed.
 *)
  DMUS_E_TIME_PAST                = MAKE_DMHRESULTERROR + $0165;

(* DMUS_E_TRACK_NOT_FOUND
 *
 * The requested track is not contained by the segment.
 *)
  DMUS_E_TRACK_NOT_FOUND        = MAKE_DMHRESULTERROR + $0166;

(* DMUS_E_TRACK_NO_CLOCKTIME_SUPPORT
 *
 * The track does not support clock time playback or getparam.
 *)
  DMUS_E_TRACK_NO_CLOCKTIME_SUPPORT = MAKE_DMHRESULTERROR + $0167;

(* DMUS_E_NO_MASTER_CLOCK
 *
 * There is no master clock in the performance. Be sure to call
 * IDirectMusicPerformance::Init().
 *)
  DMUS_E_NO_MASTER_CLOCK          = MAKE_DMHRESULTERROR + $0170;

(* DMUS_E_LOADER_NOCLASSID
 *
 * The class id field is required and missing in the DMUS_OBJECTDESC.
 *)
  DMUS_E_LOADER_NOCLASSID         = MAKE_DMHRESULTERROR + $0180;

(* DMUS_E_LOADER_BADPATH
 *
 * The requested file path is invalid.
 *)
  DMUS_E_LOADER_BADPATH           = MAKE_DMHRESULTERROR + $0181;

(* DMUS_E_LOADER_FAILEDOPEN
 *
 * File open failed - either file doesn't exist or is locked.
 *)
  DMUS_E_LOADER_FAILEDOPEN        = MAKE_DMHRESULTERROR + $0182;

(* DMUS_E_LOADER_FORMATNOTSUPPORTED
 *
 * Search data type is not supported.
 *)
  DMUS_E_LOADER_FORMATNOTSUPPORTED    = MAKE_DMHRESULTERROR + $0183;

(* DMUS_E_LOADER_FAILEDCREATE
 *
 * Unable to find or create object.
 *)
  DMUS_E_LOADER_FAILEDCREATE      = MAKE_DMHRESULTERROR + $0184;

(* DMUS_E_LOADER_OBJECTNOTFOUND
 *
 * Object was not found.
 *)
  DMUS_E_LOADER_OBJECTNOTFOUND    = MAKE_DMHRESULTERROR + $0185;

(* DMUS_E_LOADER_NOFILENAME
 *
 * The file name is missing from the DMUS_OBJECTDESC.
 *)
  DMUS_E_LOADER_NOFILENAME	    = MAKE_DMHRESULTERROR + $0186;

(* DMUS_E_INVALIDFILE
 *
 * The file requested is not a valid file.
 *)
  DMUS_E_INVALIDFILE              = MAKE_DMHRESULTERROR + $0200;

(* DMUS_E_ALREADY_EXISTS
 *
 * The tool is already contained in the graph. Create a new instance.
 *)
  DMUS_E_ALREADY_EXISTS           = MAKE_DMHRESULTERROR + $0201;

(* DMUS_E_OUT_OF_RANGE
 *
 * Value is out of range, for instance the requested length is longer than
 * the segment.
 *)
  DMUS_E_OUT_OF_RANGE             = MAKE_DMHRESULTERROR + $0202;

(* DMUS_E_SEGMENT_INIT_FAILED
 *
 * Segment initialization failed, most likely due to a critical memory situation.
 *)
  DMUS_E_SEGMENT_INIT_FAILED      = MAKE_DMHRESULTERROR + $0203;

(* DMUS_E_ALREADY_SENT
 *
 * The DMUS_PMSG has already been sent to the performance object via
 * IDirectMusicPerformance::SendPMsg().
 *)
  DMUS_E_ALREADY_SENT             = MAKE_DMHRESULTERROR + $0204;

(* DMUS_E_CANNOT_FREE
 *
 * The DMUS_PMSG was either not allocated by the performance via
 * IDirectMusicPerformance::AllocPMsg(), or it was already freed via
 * IDirectMusicPerformance::FreePMsg().
 *)
  DMUS_E_CANNOT_FREE              = MAKE_DMHRESULTERROR + $0205;

(* DMUS_E_CANNOT_OPEN_PORT
 *
 * The default system port could not be opened.
 *)
  DMUS_E_CANNOT_OPEN_PORT         = MAKE_DMHRESULTERROR + $0206;

(* DMUS_E_CONNOT_CONVERT
 *
 * A call to MIDIToMusic() or MusicToMIDI() resulted in an error because
 * the requested conversion could not happen. This usually occurs when the
 * provided DMUS_CHORD_KEY structure has an invalid chord or scale pattern.
 *)
  DMUS_E_CANNOT_CONVERT           = MAKE_DMHRESULTERROR + $0207;
  DMUS_E_CONNOT_CONVERT           = DMUS_E_CANNOT_CONVERT;

(* DMUS_E_DESCEND_CHUNK_FAIL
 *
 * DMUS_E_DESCEND_CHUNK_FAIL is returned when the end of the file
 * was reached before the desired chunk was found.
 *)
  DMUS_E_DESCEND_CHUNK_FAIL       = MAKE_DMHRESULTERROR + $0210;

(* DMUS_E_NOT_LOADED
 *
 * An attempt to use this object failed because it first needs to
 * be loaded.
 *)
  DMUS_E_NOT_LOADED               = MAKE_DMHRESULTERROR + $0211;

(* DMUS_E_SCRIPT_LANGUAGE_INCOMPATIBLE
 *
 * The activeX scripting engine for the script's language is not compatible with
 * DirectMusic.
 *
 *)
  DMUS_E_SCRIPT_LANGUAGE_INCOMPATIBLE = MAKE_DMHRESULTERROR + $0213;

(* DMUS_E_SCRIPT_UNSUPPORTED_VARTYPE
 *
 * A varient was used that had a type that is not supported by DirectMusic.
 *
 *)
  DMUS_E_SCRIPT_UNSUPPORTED_VARTYPE   = MAKE_DMHRESULTERROR + $0214;

(* DMUS_E_SCRIPT_ERROR_IN_SCRIPT
 *
 * An error was encountered while parsing or executing the script.
 * The pErrorInfo parameter (if supplied) was filled with information about the error.
 *)
  DMUS_E_SCRIPT_ERROR_IN_SCRIPT       = MAKE_DMHRESULTERROR + $0215;

(* DMUS_E_SCRIPT_CANTLOAD_OLEAUT32
 *
 * Loading of oleaut32.dll failed.  VBScript and other activeX scripting languages
 * require use of oleaut32.dll.  On platforms where oleaut32.dll is not present, only
 * the DirectMusicScript language, which doesn't require oleaut32.dll can be used.
 *)
  DMUS_E_SCRIPT_CANTLOAD_OLEAUT32     = MAKE_DMHRESULTERROR + $0216;

(* DMUS_E_SCRIPT_LOADSCRIPT_ERROR
 *
 * An error occured while parsing a script loaded using LoadScript.  The script that
 * was loaded contains an error.
 *)
  DMUS_E_SCRIPT_LOADSCRIPT_ERROR       = MAKE_DMHRESULTERROR + $0217;

(* DMUS_E_SCRIPT_INVALID_FILE
 *
 * The script file is invalid.
 *)
  DMUS_E_SCRIPT_INVALID_FILE           = MAKE_DMHRESULTERROR + $0218;

(* DMUS_E_INVALID_SCRIPTTRACK
 *
 * The file contains an invalid script track.
 *)
  DMUS_E_INVALID_SCRIPTTRACK           = MAKE_DMHRESULTERROR + $0219;

(* DMUS_E_SCRIPT_VARIABLE_NOT_FOUND
 *
 * The script does not contain a variable with the specified name.
 *)
  DMUS_E_SCRIPT_VARIABLE_NOT_FOUND     = MAKE_DMHRESULTERROR + $021A;

(* DMUS_E_SCRIPT_ROUTINE_NOT_FOUND
 *
 * The script does not contain a routine with the specified name.
 *)
  DMUS_E_SCRIPT_ROUTINE_NOT_FOUND      = MAKE_DMHRESULTERROR + $021B;

(* DMUS_E_SCRIPT_CONTENT_READONLY
 *
 * Scripts variables for content referenced or embedded in a script cannot be set.
 *)
  DMUS_E_SCRIPT_CONTENT_READONLY       = MAKE_DMHRESULTERROR + $021C;

(* DMUS_E_SCRIPT_NOT_A_REFERENCE
 *
 * Attempt was made to set a script's variable by reference to a value that was
 * not an object type.
 *)
  DMUS_E_SCRIPT_NOT_A_REFERENCE        = MAKE_DMHRESULTERROR + $021D;

(* DMUS_E_SCRIPT_VALUE_NOT_SUPPORTED
 *
 * Attempt was made to set a script's variable by value to an object that does
 * not support a default value property.
 *)
  DMUS_E_SCRIPT_VALUE_NOT_SUPPORTED    = MAKE_DMHRESULTERROR + $021E;

(* DMUS_E_INVALID_SEGMENTTRIGGERTRACK
 *
 * The file contains an invalid segment trigger track.
 *)
  DMUS_E_INVALID_SEGMENTTRIGGERTRACK   = MAKE_DMHRESULTERROR + $0220;

(* DMUS_E_INVALID_LYRICSTRACK
 *
 * The file contains an invalid lyrics track.
 *)
  DMUS_E_INVALID_LYRICSTRACK           = MAKE_DMHRESULTERROR + $0221;

(* DMUS_E_INVALID_PARAMCONTROLTRACK
 *
 * The file contains an invalid parameter control track.
 *)
  DMUS_E_INVALID_PARAMCONTROLTRACK     = MAKE_DMHRESULTERROR + $0222;

(* DMUS_E_AUDIOVBSCRIPT_SYNTAXERROR
 *
 * A script written in AudioVBScript could not be read because it contained a statement that
 * is not allowed by the AudioVBScript language.
 *)
  DMUS_E_AUDIOVBSCRIPT_SYNTAXERROR     = MAKE_DMHRESULTERROR + $0223;

(* DMUS_E_AUDIOVBSCRIPT_RUNTIMEERROR
 *
 * A script routine written in AudioVBScript failed because an invalid operation occurred.  For example,
 * adding the number 3 to a segment object would produce this error.  So would attempting to call a routine
 * that doesn't exist.
 *)
  DMUS_E_AUDIOVBSCRIPT_RUNTIMEERROR     = MAKE_DMHRESULTERROR + $0224;

(* DMUS_E_AUDIOVBSCRIPT_OPERATIONFAILURE
 *
 * A script routine written in AudioVBScript failed because a function outside of a script failed to complete.
 * For example, a call to PlaySegment that fails to play because of low memory would return this error.
 *)
  DMUS_E_AUDIOVBSCRIPT_OPERATIONFAILURE     = MAKE_DMHRESULTERROR + $0225;

(* DMUS_E_AUDIOPATHS_NOT_VALID
 *
 * The Performance has set up some PChannels using the AssignPChannel command, which
 * makes it not capable of supporting audio paths.
 *)
  DMUS_E_AUDIOPATHS_NOT_VALID     = MAKE_DMHRESULTERROR + $0226;

(* DMUS_E_AUDIOPATHS_IN_USE
 *
 * This is the inverse of the previous error.
 * The Performance has set up some audio paths, which makes is incompatible
 * with the calls to allocate pchannels, etc.
 *)
  DMUS_E_AUDIOPATHS_IN_USE     = MAKE_DMHRESULTERROR + $0227;

(* DMUS_E_NO_AUDIOPATH_CONFIG
 *
 * A segment or song was asked for its embedded audio path configuration,
 * but there isn't any.
 *)
  DMUS_E_NO_AUDIOPATH_CONFIG     = MAKE_DMHRESULTERROR + $0228;

(* DMUS_E_AUDIOPATH_INACTIVE
 *
 * An audiopath is inactive, perhaps because closedown was called.
 *)
  DMUS_E_AUDIOPATH_INACTIVE     = MAKE_DMHRESULTERROR + $0229;

(* DMUS_E_AUDIOPATH_NOBUFFER
 *
 * An audiopath failed to create because a requested buffer could not be created.
 *)
  DMUS_E_AUDIOPATH_NOBUFFER     = MAKE_DMHRESULTERROR + $022A;

(* DMUS_E_AUDIOPATH_NOPORT
 *
 * An audiopath could not be used for playback because it lacked port assignments.
 *)
  DMUS_E_AUDIOPATH_NOPORT     = MAKE_DMHRESULTERROR + $022B;

(* DMUS_E_NO_AUDIOPATH
 *
 * Attempt was made to play segment in audiopath mode and there was no audiopath.
 *)
  DMUS_E_NO_AUDIOPATH     = MAKE_DMHRESULTERROR + $022C;

(* DMUS_E_INVALIDCHUNK
 *
 * Invalid data was found in a RIFF file chunk.
 *)
  DMUS_E_INVALIDCHUNK     = MAKE_DMHRESULTERROR + $022D;

(* DMUS_E_AUDIOPATH_NOGLOBALFXBUFFER
 *
 * Attempt was made to create an audiopath that sends to a global effects buffer which did not exist.
 *)
  DMUS_E_AUDIOPATH_NOGLOBALFXBUFFER     = MAKE_DMHRESULTERROR + $022E;

(* DMUS_E_INVALID_CONTAINER_OBJECT
 *
 * The file does not contain a valid container object.
 *)
  DMUS_E_INVALID_CONTAINER_OBJECT    = MAKE_DMHRESULTERROR + $022F;


(************************************************************************
*                                                                       *
*   dmksctrl.h -- Definition of IKsControl                              *
*                                                                       *
*   Copyright (c) 1998, Microsoft Corp. All rights reserved.            *
*                                                                       *
*                                                                       *
*   This header file contains the definition of IKsControl, which       *
*   duplicates definitions from ks.h and ksproxy.h. Your code should    *
*   include ks.h and ksproxy.h directly if you have them (they are      *
*   provided in the Windows 98 DDK and will be in the Windows NT 5      *
*   SDK).                                                               *
*                                                                       *
************************************************************************)

(*
 * Warning: This will prevent the rest of ks.h from being pulled in if ks.h is
 * included after dmksctrl.h. Make sure you do not include both headers in
 * the same source file.
 *)

type
  PKsIdentifier = ^TKsIdentifier;
  TKsIdentifier = packed record
    case integer of
      1 : (
             Set_: TGUID;
             Id : ULONG;
             Flags: ULONG
          );
      2 : (Alignment: LONGLONG);
  end;

  PKsProperty = ^TKsProperty;
  TKsProperty = TKsIdentifier;

  PKsMethod = ^TKsMethod;
  TKsMethod = TKsIdentifier;

  PKsEvent = ^TKsEvent;
  TKsEvent = TKsIdentifier;

const
  KSMETHOD_TYPE_NONE                  = $00000000;
  KSMETHOD_TYPE_READ                  = $00000001;
  KSMETHOD_TYPE_WRITE                 = $00000002;
  KSMETHOD_TYPE_MODIFY                = $00000003;
  KSMETHOD_TYPE_SOURCE                = $00000004;

  KSMETHOD_TYPE_SEND                  = $00000001;
  KSMETHOD_TYPE_SETSUPPORT            = $00000100;
  KSMETHOD_TYPE_BASICSUPPORT          = $00000200;

  KSPROPERTY_TYPE_GET                 = $00000001;
  KSPROPERTY_TYPE_SET                 = $00000002;
  KSPROPERTY_TYPE_SETSUPPORT          = $00000100;
  KSPROPERTY_TYPE_BASICSUPPORT        = $00000200;
  KSPROPERTY_TYPE_RELATIONS           = $00000400;
  KSPROPERTY_TYPE_SERIALIZESET        = $00000800;
  KSPROPERTY_TYPE_UNSERIALIZESET      = $00001000;
  KSPROPERTY_TYPE_SERIALIZERAW        = $00002000;
  KSPROPERTY_TYPE_UNSERIALIZERAW      = $00004000;
  KSPROPERTY_TYPE_SERIALIZESIZE       = $00008000;
  KSPROPERTY_TYPE_DEFAULTVALUES       = $00010000;

  KSPROPERTY_TYPE_TOPOLOGY            = $10000000;

type
  IKsControl = interface (IUnknown)
    ['{28F54685-06FD-11D2-B27A-00A0C9223196}']
    function KsProperty (const pProperty: TKsProperty; PropertyLength: ULONG;
        var PropertyData; DataLength: ULONG; out BytesReturned: ULONG) : HResult; stdcall;
    function KsMethod(const Method: TKsMethod; MethodLength: ULONG;
        var MethodData; DataLength: ULONG; out BytesReturned: ULONG) : HResult; stdcall;
    function KsEvent (const Event: TKsEvent; EventLength: ULONG;
        var EventData; DataLength: ULONG; out BytesReturned: ULONG) : HResult; stdcall;
  end;

type
  IID_IKsControl        = IKsControl;
  STATIC_IID_IKsControl = IID_IKsControl;


const
(* These formats are in ksmedia.h
 *)
  KSDATAFORMAT_SUBTYPE_MIDI        : TGUID = '{1D262760-E957-11CF-A5D6-28DB04C10000}';
  KSDATAFORMAT_SUBTYPE_DIRECTMUSIC : TGUID = '{1a82f8bc-3f8b-11d2-b774-0060083316c1}';

(************************************************************************
*                                                                       *
*   dmusicc.h -- This module defines the DirectMusic core API's         *
*                                                                       *
*   Copyright (c) 1998, Microsoft Corp. All rights reserved.            *
*                                                                       *
************************************************************************)

const
  DMUS_MAX_DESCRIPTION = 128;
  DMUS_MAX_DRIVER      = 128;

type
  PDMus_BufferDesc = ^TDMus_BufferDesc;
  TDMus_BufferDesc = packed record
    dwSize           : DWORD;
    dwFlags          : DWORD;
    guidBufferFormat : TGUID;
    cbBuffer         : DWORD;
  end;

const
(* DMUS_EFFECT_ flags are used in the dwEffectFlags fields of both DMUS_PORTCAPS
 * and DMUS_PORTPARAMS.
 *)
  DMUS_EFFECT_NONE         = $00000000;
  DMUS_EFFECT_REVERB       = $00000001;
  DMUS_EFFECT_CHORUS       = $00000002;

(* For DMUS_PORTCAPS dwClass
 *)
  DMUS_PC_INPUTCLASS       = 0;
  DMUS_PC_OUTPUTCLASS      = 1;

(* For DMUS_PORTCAPS dwFlags
 *)
  DMUS_PC_DLS              = $00000001;
  DMUS_PC_EXTERNAL         = $00000002;
  DMUS_PC_SOFTWARESYNTH    = $00000004;
  DMUS_PC_MEMORYSIZEFIXED  = $00000008;
  DMUS_PC_GMINHARDWARE     = $00000010;
  DMUS_PC_GSINHARDWARE     = $00000020;
  DMUS_PC_XGINHARDWARE     = $00000040;
  DMUS_PC_DIRECTSOUND      = $00000080;
  DMUS_PC_SHAREABLE        = $00000100;
  DMUS_PC_DLS2             = $00000200;
  DMUS_PC_SYSTEMMEMORY     = $7FFFFFFF;

type
  PDMus_PortCaps = ^TDMus_PortCaps;
  TDMus_PortCaps = packed record
    dwSize             : DWORD;
    dwFlags            : DWORD;
    guidPort           : TGUID;
    dwClass            : DWORD;
    dwType             : DWORD;
    dwMemorySize       : DWORD;
    dwMaxChannelGroups : DWORD;
    dwMaxVoices        : DWORD;
    dwMaxAudioChannels : DWORD;
    dwEffectFlags      : DWORD;
    wszDescription     : array [0..DMUS_MAX_DESCRIPTION-1] of WideChar;
  end;

const
(* Values for DMUS_PORTCAPS dwType. This field indicates the underlying
 * driver type of the port.
 *)
  DMUS_PORT_WINMM_DRIVER      = 0;
  DMUS_PORT_USER_MODE_SYNTH   = 1;
  DMUS_PORT_KERNEL_MODE       = 2;

(* These flags (set in dwValidParams) indicate which other members of the *)
(* DMUS_PORTPARAMS are valid. *)
(* *)
  DMUS_PORTPARAMS_VOICES           = $00000001;
  DMUS_PORTPARAMS_CHANNELGROUPS    = $00000002;
  DMUS_PORTPARAMS_AUDIOCHANNELS    = $00000004;
  DMUS_PORTPARAMS_SAMPLERATE       = $00000008;
  DMUS_PORTPARAMS_EFFECTS          = $00000020;
  DMUS_PORTPARAMS_SHARE            = $00000040;
  DMUS_PORTPARAMS_FEATURES         = $00000080;     (* DirectX 8.0 and above *)

type
  PDMus_PortParams = ^TDMus_PortParams;
  TDMus_PortParams = packed record
    dwSize          : DWORD;
    dwValidParams   : DWORD;
    dwVoices        : DWORD;
    dwChannelGroups : DWORD;
    dwAudioChannels : DWORD;
    dwSampleRate    : DWORD;
    dwEffectFlags   : DWORD;
    fShare          : BOOL;
  end;
  PDMus_PortParams7 = ^TDMus_PortParams7;
  TDMus_PortParams7 = TDMus_PortParams;

  PDMus_PortParams8 = ^TDMus_PortParams8;
  TDMus_PortParams8 = packed record
    dwSize          : DWORD;
    dwValidParams   : DWORD;
    dwVoices        : DWORD;
    dwChannelGroups : DWORD;
    dwAudioChannels : DWORD;
    dwSampleRate    : DWORD;
    dwEffectFlags   : DWORD;
    fShare          : BOOL;
    dwFeatures      : DWORD;
  end;

const
  DMUS_PORT_FEATURE_AUDIOPATH      = $00000001;	     (* Supports audiopath connection to DSound buffers. *)
  DMUS_PORT_FEATURE_STREAMING      = $00000002;	     (* Supports streaming waves through the synth. *)

type
  PDMus_SynthStats = ^TDMus_SynthStats;
  TDMus_SynthStats = packed record
    dwSize        : DWORD;        (* Size in bytes of the structure *)
    dwValidStats  : DWORD;        (* Flags indicating which fields below are valid. *)
    dwVoices      : DWORD;        (* Average number of voices playing. *)
    dwTotalCPU    : DWORD;        (* Total CPU usage as percent * 100. *)
    dwCPUPerVoice : DWORD;        (* CPU per voice as percent * 100. *)
    dwLostNotes   : DWORD;        (* Number of notes lost in 1 second. *)
    dwFreeMemory  : DWORD;        (* Free memory in bytes *)
    lPeakVolume   : LongInt;      (* Decibel level * 100. *)
  end;

  PDMus_SynthStats8 = ^TDMus_SynthStats8;
  TDMus_SynthStats8 = packed record
    dwSize        : DWORD;        (* Size in bytes of the structure *)
    dwValidStats  : DWORD;        (* Flags indicating which fields below are valid. *)
    dwVoices      : DWORD;        (* Average number of voices playing. *)
    dwTotalCPU    : DWORD;        (* Total CPU usage as percent * 100. *)
    dwCPUPerVoice : DWORD;        (* CPU per voice as percent * 100. *)
    dwLostNotes   : DWORD;        (* Number of notes lost in 1 second. *)
    dwFreeMemory  : DWORD;        (* Free memory in bytes *)
    lPeakVolume   : Longint;      (* Decibel level * 100. *)
    dwSynthMemUse : DWORD;        (* Memory used by synth wave data *)
  end;

const
  DMUS_SYNTHSTATS_VOICES          = 1 shl 0;
  DMUS_SYNTHSTATS_TOTAL_CPU       = 1 shl 1;
  DMUS_SYNTHSTATS_CPU_PER_VOICE   = 1 shl 2;
  DMUS_SYNTHSTATS_LOST_NOTES      = 1 shl 3;
  DMUS_SYNTHSTATS_PEAK_VOLUME     = 1 shl 4;
  DMUS_SYNTHSTATS_FREE_MEMORY     = 1 shl 5;

  DMUS_SYNTHSTATS_SYSTEMMEMORY    = DMUS_PC_SYSTEMMEMORY;

type
  TDMus_Waves_Reverb_Params = packed record
    fInGain,        (* Input gain in dB (to avoid output overflows) *)
    fReverbMix,     (* Reverb mix in dB. 0dB means 100% wet reverb (no direct signal)
                    Negative values gives less wet signal.
                    The coeficients are calculated so that the overall output level stays
                    (approximately) constant regardless of the ammount of reverb mix. *)
    fReverbTime,    (* The reverb decay time, in milliseconds. *)
    fHighFreqRTRatio : Single; (* The ratio of the high frequencies to the global reverb time.
                    Unless very 'splashy-bright' reverbs are wanted, this should be set to
                    a value < 1.0.
                    For example if dRevTime==1000ms and dHighFreqRTRatio=0.1 than the
                    decay time for high frequencies will be 100ms.*)
  end;


(*  Note: Default values for Reverb are:
    fInGain             = 0.0dB   (no change in level)
    fReverbMix          = -10.0dB   (a reasonable reverb mix)
    fReverbTime         = 1000.0ms (one second global reverb time)
    fHighFreqRTRatio    = 0.001    (the ratio of the high frequencies to the global reverb time)
*)

  TDMus_ClockType = (
    DMUS_CLOCK_SYSTEM,
    DMUS_CLOCK_WAVE
  );

  PDMus_ClockInfo = ^TDMus_ClockInfo;
  TDMus_ClockInfo = packed record
    dwSize         : DWORD;
    ctType         : TDMus_ClockType;
    guidClock      : TGUID;          (* Identifies this time source *)
    wszDescription : array [0..DMUS_MAX_DESCRIPTION-1] of WideChar;
  end;
  PDMus_ClockInfo7 = ^TDMus_ClockInfo7;
  TDMus_ClockInfo7 = TDMus_ClockInfo;

  PDMus_ClockInfo8 = ^TDMus_ClockInfo8;
  TDMus_ClockInfo8 = packed record
    dwSize         : DWORD;
    ctType         : TDMus_ClockType;
    guidClock      : TGUID;          (* Identifies this time source *)
    wszDescription : array [0..DMUS_MAX_DESCRIPTION-1] of WideChar;
    dwFlags        : DWORD;
  end;

const
  DMUS_EVENT_STRUCTURED   = $00000001;  (* Unstructured data (SysEx, etc.) *)
  DMUS_CLOCKF_GLOBAL      = $00000001;

(* Default bus identifiers
 *
 * The first 17 are direct mappings to the destinations defined in both
 * the MMA DLS Level 2 specification and the Microsoft Multi-Channel audio
 * specification.
 *)
  DSBUSID_FIRST_SPKR_LOC              = 0;
  DSBUSID_FRONT_LEFT                  = 0;
  DSBUSID_LEFT                        = 0;   (* Front left is also just left *)
  DSBUSID_FRONT_RIGHT                 = 1;
  DSBUSID_RIGHT                       = 1;   (* Ditto front right *)
  DSBUSID_FRONT_CENTER                = 2;
  DSBUSID_LOW_FREQUENCY               = 3;
  DSBUSID_BACK_LEFT                   = 4;
  DSBUSID_BACK_RIGHT                  = 5;
  DSBUSID_FRONT_LEFT_OF_CENTER        = 6;
  DSBUSID_FRONT_RIGHT_OF_CENTER       = 7;
  DSBUSID_BACK_CENTER                 = 8;
  DSBUSID_SIDE_LEFT                   = 9;
  DSBUSID_SIDE_RIGHT                  = 10;
  DSBUSID_TOP_CENTER                  = 11;
  DSBUSID_TOP_FRONT_LEFT              = 12;
  DSBUSID_TOP_FRONT_CENTER            = 13;
  DSBUSID_TOP_FRONT_RIGHT             = 14;
  DSBUSID_TOP_BACK_LEFT               = 15;
  DSBUSID_TOP_BACK_CENTER             = 16;
  DSBUSID_TOP_BACK_RIGHT              = 17;
  DSBUSID_LAST_SPKR_LOC               = 17;

//  #define DSBUSID_IS_SPKR_LOC(id) ( ((id) >= DSBUSID_FIRST_SPKR_LOC) && ((id) <= DSBUSID_LAST_SPKR_LOC) )
function DSBUSID_IS_SPKR_LOC(id: integer) : boolean;

(* Standard values for voice priorities. Numerically higher priorities are higher in priority.
 * These priorities are used to set the voice priority for all voices on a channel. They are
 * used in the dwPriority parameter of IDirectMusicPort::GetPriority and returned in the
 * lpwPriority parameter of pdwPriority.
 *
 * These priorities are shared with DirectSound.
 *)

(* These bus identifiers are for the standard DLS effect sends
 *)
const
  DSBUSID_REVERB_SEND                = 64;
  DSBUSID_CHORUS_SEND                = 65;

(* Dynamic bus identifiers start here. See the documentation for how
 * synthesizers map the output of voices to static and dynamic
 * bus identifiers.
 *)
  DSBUSID_DYNAMIC_0                 = 512;

(* Null bus, used to identify busses that have no function mapping.
*)
  DSBUSID_NULL			  = $FFFFFFFF;

const
  DAUD_CRITICAL_VOICE_PRIORITY    = $F0000000;
  DAUD_HIGH_VOICE_PRIORITY        = $C0000000;
  DAUD_STANDARD_VOICE_PRIORITY    = $80000000;
  DAUD_LOW_VOICE_PRIORITY         = $40000000;
  DAUD_PERSIST_VOICE_PRIORITY     = $10000000;

(* These are the default priorities assigned if not overridden. By default priorities are
 * equal across channel groups (e.g. channel 5 on channel group 1 has the same priority as
 * channel 5 on channel group 2;.
 *
 * In accordance with DLS level 1, channel 10 has the highest priority, followed by 1 through 16
 * except for 10.
 *)
  DAUD_CHAN1_VOICE_PRIORITY_OFFSET    = $0000000E;
  DAUD_CHAN2_VOICE_PRIORITY_OFFSET    = $0000000D;
  DAUD_CHAN3_VOICE_PRIORITY_OFFSET    = $0000000C;
  DAUD_CHAN4_VOICE_PRIORITY_OFFSET    = $0000000B;
  DAUD_CHAN5_VOICE_PRIORITY_OFFSET    = $0000000A;
  DAUD_CHAN6_VOICE_PRIORITY_OFFSET    = $00000009;
  DAUD_CHAN7_VOICE_PRIORITY_OFFSET    = $00000008;
  DAUD_CHAN8_VOICE_PRIORITY_OFFSET    = $00000007;
  DAUD_CHAN9_VOICE_PRIORITY_OFFSET    = $00000006;
  DAUD_CHAN10_VOICE_PRIORITY_OFFSET   = $0000000F;
  DAUD_CHAN11_VOICE_PRIORITY_OFFSET   = $00000005;
  DAUD_CHAN12_VOICE_PRIORITY_OFFSET   = $00000004;
  DAUD_CHAN13_VOICE_PRIORITY_OFFSET   = $00000003;
  DAUD_CHAN14_VOICE_PRIORITY_OFFSET   = $00000002;
  DAUD_CHAN15_VOICE_PRIORITY_OFFSET   = $00000001;
  DAUD_CHAN16_VOICE_PRIORITY_OFFSET   = $00000000;


  DAUD_CHAN1_DEF_VOICE_PRIORITY   = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN1_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN2_DEF_VOICE_PRIORITY   = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN2_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN3_DEF_VOICE_PRIORITY   = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN3_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN4_DEF_VOICE_PRIORITY   = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN4_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN5_DEF_VOICE_PRIORITY   = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN5_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN6_DEF_VOICE_PRIORITY   = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN6_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN7_DEF_VOICE_PRIORITY   = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN7_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN8_DEF_VOICE_PRIORITY   = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN8_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN9_DEF_VOICE_PRIORITY   = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN9_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN10_DEF_VOICE_PRIORITY  = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN10_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN11_DEF_VOICE_PRIORITY  = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN11_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN12_DEF_VOICE_PRIORITY  = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN12_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN13_DEF_VOICE_PRIORITY  = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN13_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN14_DEF_VOICE_PRIORITY  = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN14_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN15_DEF_VOICE_PRIORITY  = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN15_VOICE_PRIORITY_OFFSET);
  DAUD_CHAN16_DEF_VOICE_PRIORITY  = (DAUD_STANDARD_VOICE_PRIORITY or DAUD_CHAN16_VOICE_PRIORITY_OFFSET);

type
  IDirectMusic       = interface;
  IDirectMusic8      = interface;
  IDirectMusicBuffer = interface;
  IDirectMusicPort   = interface;
  IDirectMusicThru   = interface;
  IReferenceClock    = interface;
  PIReferenceClock   = IReferenceClock;

  IDirectMusic = interface (IUnknown)
    ['{6536115a-7b2d-11d2-ba18-0000f875ac12}']
    function EnumPort (dwIndex: DWORD; var pPortCaps: TDMus_PortCaps) : HResult; stdcall;
    function CreateMusicBuffer (var pBufferDesc: TDMus_BufferDesc;
        out ppBuffer: IDirectMusicBuffer; pUnkOuter: IUnknown) : HResult; stdcall;
    function CreatePort (const rclsidPort: TGUID; const pPortParams: TDMus_PortParams;
        out ppPort: IDirectMusicPort; pUnkOuter: IUnknown) : HResult; stdcall;
    function EnumMasterClock (dwIndex: DWORD; var lpClockInfo: TDMus_ClockInfo) : HResult; stdcall;
    function GetMasterClock (pguidClock: PGUID; ppReferenceClock : PIReferenceClock) : HResult; stdcall;
    function SetMasterClock (const rguidClock: TGUID) : HResult; stdcall;
    function Activate (fEnable: BOOL) : HResult; stdcall;
    function GetDefaultPort (out pguidPort: TGUID) : HResult; stdcall;
    function SetDirectSound (pDirectSound: IDirectSound; hWnd: HWND) : HResult; stdcall;
  end;

  IDirectMusic8 = interface (IDirectMusic)
    ['{2d3629f7-813d-4939-8508-f05c6b75fd97}']
    function SetExternalMasterClock(pClock: IReferenceClock): HResult; stdcall;
  end;

  IDirectMusicBuffer = interface (IUnknown)
    ['{d2ac2878-b39b-11d1-8704-00600893b1bd}']
    function Flush : HResult; stdcall;
    function TotalTime (out prtTime: TReference_Time) : HResult; stdcall;
    function PackStructured (const rt: TReference_Time; dwChannelGroup: DWORD;
        dwChannelMessage: DWORD ) : HResult; stdcall;
    function PackUnstructured (const rt: TReference_Time; dwChannelGroup: DWORD;
        cb: DWORD; const lpb) : HResult; stdcall;
    function ResetReadPtr : HResult; stdcall;
    function GetNextEvent (out prt: TReference_Time; out pdwChannelGroup: DWORD;
        out pdwLength: DWORD; out ppData: Pointer) : HResult; stdcall;
    function GetRawBufferPtr (out ppData: Pointer) : HResult; stdcall;
    function GetStartTime (out prt: TReference_Time) : HResult; stdcall;
    function GetUsedBytes (out pcb: DWORD) : HResult; stdcall;
    function GetMaxBytes (out pcb: DWORD) : HResult; stdcall;
    function GetBufferFormat (out pGuidFormat: TGUID) : HResult; stdcall;
    function SetStartTime (const rt: TReference_Time) : HResult; stdcall;
    function SetUsedBytes (cb: DWORD) : HResult; stdcall;
  end;
  IDirectMusicBuffer8 = IDirectMusicBuffer;


(***************************************************************************
*                                                                          *
*   DMusBuff.h -- This module defines the buffer format for DirectMusic    *
*                 Shared file between user mode and kernel mode components *
*                                                                          *
*   Copyright (c) 1998, Microsoft Corp. All rights reserved.               *
*                                                                          *
***************************************************************************)

(* Format of DirectMusic events in a buffer
 *
 * A buffer contains 1 or more events, each with the following header.
 * Immediately following the header is the event data. The header+data
 * size is rounded to the nearest quadword (8 bytes).
 *)

  TDMus_EventHeader = packed record
    cbEvent        : DWORD;                   (* Unrounded bytes in event *)
    dwChannelGroup : DWORD;                   (* Channel group of event *)
    rtDelta        : TReference_Time;         (* Delta from start time of entire buffer *)
    dwFlags        : DWORD;                   (* Flags DMUS_EVENT_xxx *)
  end;

  IDirectMusicInstrument = interface (IUnknown)
    ['{d2ac287d-b39b-11d1-8704-00600893b1bd}']
    function GetPatch (out pdwPatch: DWORD ) : HResult; stdcall;
    function SetPatch (dwPatch: DWORD) : HResult; stdcall;
  end;
  IDirectMusicInstrument8 = IDirectMusicInstrument;

  IDirectMusicDownloadedInstrument = interface (IUnknown)
    ['{d2ac287e-b39b-11d1-8704-00600893b1bd}']
    (* None at this time *)
  end;
  IDirectMusicDownloadedInstrument8 = IDirectMusicDownloadedInstrument;

  IDirectMusicCollection = interface (IUnknown)
    ['{d2ac287c-b39b-11d1-8704-00600893b1bd}']
    function GetInstrument (dwPatch: DWORD; out ppInstrument: IDirectMusicInstrument) : HResult; stdcall;
    function EnumInstrument (dwIndex: DWORD; out pdwPatch: DWORD;
        pwszName: LPWSTR; dwNameLen: DWORD) : HResult; stdcall;
  end;
  IDirectMusicCollection8 = IDirectMusicCollection;


  IDirectMusicDownload = interface (IUnknown)
    ['{d2ac287b-b39b-11d1-8704-00600893b1bd}']
    function GetBuffer (out ppvBuffer: Pointer; out pdwSize: DWORD) : HResult; stdcall;
  end;
  IDirectMusicDownload8 = IDirectMusicDownload;

  IDirectMusicPortDownload = interface (IUnknown)
    ['{d2ac287a-b39b-11d1-8704-00600893b1bd}']
    function GetBuffer (dwDLId: DWORD; out ppIDMDownload: IDirectMusicDownload) : HResult; stdcall;
    function AllocateBuffer (dwSize: DWORD; out ppIDMDownload: IDirectMusicDownload) : HResult; stdcall;
    function GetDLId (out pdwStartDLId: DWORD; dwCount: DWORD) : HResult; stdcall;
    function GetAppend (out pdwAppend: DWORD) : HResult; stdcall;
    function Download (pIDMDownload: IDirectMusicDownload) : HResult; stdcall;
    function Unload(pIDMDownload: IDirectMusicDownload) : HResult; stdcall;
  end;
  IDirectMusicPortDownload8 = IDirectMusicPortDownload;

  IDirectMusicPort = interface (IUnknown)
    ['{08f2d8c9-37c2-11d2-b9f9-0000f875ac12}']
    function PlayBuffer (pBuffer: IDirectMusicBuffer) : HResult; stdcall;
    function SetReadNotificationHandle (hEvent: THANDLE) : HResult; stdcall;
    function Read (pBuffer: IDirectMusicBuffer) : HResult; stdcall;
    function DownloadInstrument (pInstrument: IDirectMusicInstrument;
        out ppDownloadedInstrument: IDirectMusicDownloadedInstrument;
        pNoteRanges: PDMus_NoteRange; dwNumNoteRanges: DWORD) : HResult; stdcall;
    function UnloadInstrument (pDownloadedInstrument: IDirectMusicDownloadedInstrument) : HResult; stdcall;
    function GetLatencyClock (out ppClock: IReferenceClock) : HResult; stdcall;
    function GetRunningStats (var pStats: TDMus_SynthStats) : HResult; stdcall;
    function Compact : HResult; stdcall;
    function GetCaps (var pPortCaps: TDMus_PortCaps) : HResult; stdcall;
    function DeviceIoControl (dwIoControlCode: DWORD; const lpInBuffer; nInBufferSize: DWORD;
        out lpOutBuffer; nOutBufferSize: DWORD; out lpBytesReturned: DWORD;
        var lpOverlapped: TOVERLAPPED) : HResult; stdcall;
    function SetNumChannelGroups (dwChannelGroups: DWORD) : HResult; stdcall;
    function GetNumChannelGroups (out pdwChannelGroups: DWORD) : HResult; stdcall;
    function Activate (fActive: BOOL) : HResult; stdcall;
    function SetChannelPriority (dwChannelGroup, dwChannel, dwPriority: DWORD) : HResult; stdcall;
    function GetChannelPriority (dwChannelGroup, dwChannel: DWORD; out pdwPriority: DWORD) : HResult; stdcall;
    function SetDirectSound (pDirectSound: IDirectSound; pDirectSoundBuffer: IDirectSoundBuffer) : HResult; stdcall;
    function GetFormat (pWaveFormatEx: PWaveFormatEx; var pdwWaveFormatExSize: DWORD;
        out pdwBufferSize: DWORD) : HResult; stdcall;
  end;
  IDirectMusicPort8 = IDirectMusicPort;

  IDirectMusicThru = interface (IUnknown)
    ['{ced153e7-3606-11d2-b9f9-0000f875ac12}']
    function ThruChannel (dwSourceChannelGroup, dwSourceChannel, dwDestinationChannelGroup,
      dwDestinationChannel: DWORD; pDestinationPort: IDirectMusicPort) : HResult; stdcall;
  end;
  IDirectMusicThru8 = IDirectMusicThru;


  IReferenceClock = interface (IUnknown)
    ['{56a86897-0ad4-11ce-b03a-0020af0ba770}']
    (*  get the time now *)
    function GetTime (out pTime: TReference_Time) : HResult; stdcall;

    (*  ask for an async notification that a time has elapsed *)
    function AdviseTime (const baseTime,                  (*  base time *)
                         streamTime: TReference_Time;     (*  stream offset time *)
                         hEvent: THANDLE;                 (*  advise via this event *)
                         var pdwAdviseCookie: DWORD) : HResult; stdcall;   (*  where your cookie goes *)

    (*  ask for an async periodic notification that a time has elapsed *)
    function AdvisePeriodic (const startTime,                  (*  starting at this time *)
                             periodTime: TReference_Time;      (*  time between notifications *)
                             hSemaphore: THANDLE;              (*  advise via a semaphore *)
                             var pdwAdviseCookie: DWORD) : HResult; stdcall;   (*  where your cookie goes *)

    (*  cancel a request for notification *)
    function Unadvise (dwAdviseCookie: DWORD) : HResult; stdcall;
  end;

type
  IID_IDirectMusic                     = IDirectMusic;
  IID_IDirectMusic8                    = IDirectMusic8;
  IID_IDirectMusicBuffer               = IDirectMusicBuffer;
  IID_IDirectMusicBuffer8              = IDirectMusicBuffer8;
  IID_IDirectMusicPort                 = IDirectMusicPort;
  IID_IDirectMusicPort8                = IDirectMusicPort8;
  IID_IDirectMusicThru                 = IDirectMusicThru;
  IID_IDirectMusicThru8                = IDirectMusicThru8;
  IID_IDirectMusicPortDownload         = IDirectMusicPortDownload;
  IID_IDirectMusicPortDownload8        = IDirectMusicPortDownload8;
  IID_IDirectMusicDownload             = IDirectMusicDownload;
  IID_IDirectMusicDownload8            = IDirectMusicDownload8;
  IID_IDirectMusicCollection           = IDirectMusicCollection;
  IID_IDirectMusicCollection8          = IDirectMusicCollection8;
  IID_IDirectMusicInstrument           = IDirectMusicInstrument;
  IID_IDirectMusicInstrument8          = IDirectMusicInstrument8;
  IID_IDirectMusicDownloadedInstrument = IDirectMusicDownloadedInstrument;
  IID_IDirectMusicDownloadedInstrument8= IDirectMusicDownloadedInstrument8;
  IID_IReferenceClock                  = IReferenceClock;

const
(* Alternate interface ID for IID_IDirectMusic, available in DX7 release and after. *)
  IID_IDirectMusic2                 : TGUID = '{6fc2cae1-bc78-11d2-afa6-00aa0024d8b6}';
  
  CLSID_DirectMusic                 : TGUID = '{636b9f10-0c7d-11d1-95b2-0020afdc7421}';
  CLSID_DirectMusicCollection       : TGUID = '{480ff4b0-28b2-11d1-bef7-00c04fbf8fef}';
  CLSID_DirectMusicSynth            : TGUID = '{58C2B4D0-46E7-11D1-89AC-00A0C9054129}';

(* Property Query GUID_DMUS_PROP_GM_Hardware - Local GM set, no need to download
 * Property Query GUID_DMUS_PROP_GS_Hardware - Local GS set, no need to download
 * Property Query GUID_DMUS_PROP_XG_Hardware - Local XG set, no need to download
 * Property Query GUID_DMUS_PROP_DLS1        - Support DLS level 1
 * Property Query GUID_DMUS_PROP_XG_Capable  - Support minimum requirements of XG
 * Property Query GUID_DMUS_PROP_GS_Capable  - Support minimum requirements of GS
 * Property Query GUID_DMUS_PROP_SynthSink_DSOUND - Synthsink talks to DSound
 * Property Query GUID_DMUS_PROP_SynthSink_WAVE - Synthsink talks to Wave device
 *
 * Item 0: Supported
 * Returns a DWORD which is non-zero if the feature is supported
 *)
  GUID_DMUS_PROP_GM_Hardware        : TGUID = '{178f2f24-c364-11d1-a760-0000f875ac12}';
  GUID_DMUS_PROP_GS_Hardware        : TGUID = '{178f2f25-c364-11d1-a760-0000f875ac12}';
  GUID_DMUS_PROP_XG_Hardware        : TGUID = '{178f2f26-c364-11d1-a760-0000f875ac12}';
  GUID_DMUS_PROP_XG_Capable         : TGUID = '{6496aba1-61b0-11d2-afa6-00aa0024d8b6}';
  GUID_DMUS_PROP_GS_Capable         : TGUID = '{6496aba2-61b0-11d2-afa6-00aa0024d8b6}';
  GUID_DMUS_PROP_DLS1               : TGUID = '{178f2f27-c364-11d1-a760-0000f875ac12}';
  GUID_DMUS_PROP_DLS2               : TGUID = '{f14599e5-4689-11d2-afa6-00aa0024d8b6}';
  GUID_DMUS_PROP_INSTRUMENT2        : TGUID = '{865fd372-9f67-11d2-872a-00600893b1bd}';
  GUID_DMUS_PROP_SynthSink_DSOUND   : TGUID = '{0aa97844-c877-11d1-870c-00600893b1bd}';
  GUID_DMUS_PROP_SynthSink_WAVE     : TGUID = '{0aa97845-c877-11d1-870c-00600893b1bd}';
  GUID_DMUS_PROP_SampleMemorySize   : TGUID = '{178f2f28-c364-11d1-a760-0000f875ac12}';
  GUID_DMUS_PROP_SamplePlaybackRate : TGUID = '{2a91f713-a4bf-11d2-bbdf-00600833dbd8}';

(* Property Get/Set GUID_DMUS_PROP_WriteLatency
 *
 * Item 0: Synth buffer write latency, in milliseconds
 * Get/Set SynthSink latency, the average time after the play head that the next buffer gets written.
 *)
  GUID_DMUS_PROP_WriteLatency       : TGUID = '{268a0fa0-60f2-11d2-afa6-00aa0024d8b6}';

(* Property Get/Set GUID_DMUS_PROP_WritePeriod
 *
 * Item 0: Synth buffer write period, in milliseconds
 * Get/Set SynthSink buffer write period, time span between successive writes.
 *)
  GUID_DMUS_PROP_WritePeriod        : TGUID = '{268a0fa1-60f2-11d2-afa6-00aa0024d8b6}';

(* Property Get GUID_DMUS_PROP_MemorySize
 *
 * Item 0: Memory size
 * Returns a DWORD containing the total number of bytes of sample RAM
 *)
  GUID_DMUS_PROP_MemorySize         : TGUID = '{178f2f28-c364-11d1-a760-0000f875ac12}';

(* Property Set GUID_DMUS_PROP_WavesReverb
 *
 * Item 0: DMUS_WAVES_REVERB structure
 * Sets reverb parameters
 *)
  GUID_DMUS_PROP_WavesReverb        : TGUID = '{04cb5622-32e5-11d2-afa6-00aa0024d8b6}';

(* Property Set GUID_DMUS_PROP_Effects
 *
 * Item 0: DWORD with effects flags.
 * Get/Set effects bits, same as dwEffectFlags in DMUS_PORTPARAMS and DMUS_PORTCAPS:
 * DMUS_EFFECT_NONE
 * DMUS_EFFECT_REVERB
 * DMUS_EFFECT_CHORUS
 *)
  GUID_DMUS_PROP_Effects            : TGUID = '{cda8d611-684a-11d2-871e-00600893b1bd}';

(* Property Set GUID_DMUS_PROP_LegacyCaps
 *
 * Item 0: The MIDINCAPS or MIDIOUTCAPS which describes the port's underlying WinMM device. This property is only supported
 * by ports which wrap WinMM devices.
 *)

  GUID_DMUS_PROP_LegacyCaps         : TGUID = '{cfa7cdc2-00a1-11d2-aad5-0000f875ac12}';

(* Property Set GUID_DMUS_Volume
 *
 * Item 0: A long which contains an offset, in 1/100 dB, to be added to the final volume
 *
 *)
  GUID_DMUS_PROP_Volume             : TGUID = '{fedfae25-e46e-11d1-aace-0000f875ac12}';

(* Min and Max values for setting volume with GUID_DMUS_PROP_Volume *)

  DMUS_VOLUME_MAX =    2000;        (* +20 dB *)
  DMUS_VOLUME_MIN =  -20000;        (* -200 dB *)

(************************************************************************
*                                                                       *
*   dmusici.h -- This module contains the API for the                   *
*                DirectMusic performance layer                          *
*                                                                       *
*   Copyright (c) 1998, Microsoft Corp. All rights reserved.            *
*                                                                       *
************************************************************************)
(************************************************************************
*                                                                       *
*   dmplugin.h -- This module contains the API for plugins for the      *
*                 DirectMusic performance layer                         *
*                                                                       *
*   Copyright (c) 1998-1999 Microsoft Corporation                       *
*                                                                       *
************************************************************************)

type
  TTransition_Type = WORD;

  PMusic_Time = ^TMusic_Time;
  TMusic_Time = LongInt;

  TSample_Time = int64;

  PSample_Position = ^TSample_Position;
  TSample_Position = int64;

const
  DMUS_PPQ       = 768;     (* parts per quarter note *)

type
  TDMUS_Stylet_Types = (
    DMUS_STYLET_PATTERN,
    DMUS_STYLET_MOTIF,
    DMUS_STYLET_FRAGMENT
  );

  TDMus_CommandT_Types = (
    DMUS_COMMANDT_GROOVE,
    DMUS_COMMANDT_FILL  ,
    DMUS_COMMANDT_INTRO ,
    DMUS_COMMANDT_BREAK ,
    DMUS_COMMANDT_END   ,
    DMUS_COMMANDT_ENDANDINTRO
  );

  TDMus_ShapeT_Types = (
    DMUS_SHAPET_FALLING ,
    DMUS_SHAPET_LEVEL   ,
    DMUS_SHAPET_LOOPABLE,
    DMUS_SHAPET_LOUD    ,
    DMUS_SHAPET_QUIET   ,
    DMUS_SHAPET_PEAKING ,
    DMUS_SHAPET_RANDOM  ,
    DMUS_SHAPET_RISING  ,
    DMUS_SHAPET_SONG
  );

type
  TDMus_ComposeF_Flags = DWORD;
const
  DMUS_COMPOSEF_NONE              = 0;
  DMUS_COMPOSEF_ALIGN             = $1;
  DMUS_COMPOSEF_OVERLAP           = $2;
  DMUS_COMPOSEF_IMMEDIATE         = $4;
  DMUS_COMPOSEF_GRID              = $8;
  DMUS_COMPOSEF_BEAT              = $10;
  DMUS_COMPOSEF_MEASURE           = $20;
  DMUS_COMPOSEF_AFTERPREPARETIME  = $40;
  DMUS_COMPOSEF_MODULATE          = $1000;
  DMUS_COMPOSEF_LONG              = $2000;
  DMUS_COMPOSEF_ENTIRE_TRANSITION = $4000;      (* play the entire transition pattern *)
  DMUS_COMPOSEF_1BAR_TRANSITION   = $8000;      (* play one bar of the transition pattern *)
  DMUS_COMPOSEF_ENTIRE_ADDITION   = $10000;     (* play the additional pattern in its entirety *)
  DMUS_COMPOSEF_1BAR_ADDITION     = $20000;     (* play one bar of the additional pattern *)
  DMUS_COMPOSEF_VALID_START_MEASURE = $40000;   (* In conjunction with DMUS_COMPOSEF_ALIGN, allows the switch to occur on any bar. *)
  DMUS_COMPOSEF_DEFAULT           = $80000;     (* Use segment's default boundary *)
  DMUS_COMPOSEF_NOINVALIDATE      = $100000;    (* Play without invalidating the currently playing segment(s) *)
  DMUS_COMPOSEF_USE_AUDIOPATH     = $200000;    (* Uses the audio paths that are embedded in the segments *)

  DMUS_PCHANNEL_BROADCAST_PERFORMANCE	= $FFFFFFFF;  (* PMsg is sent on all PChannels of the performance. *)
  DMUS_PCHANNEL_BROADCAST_AUDIOPATH     = $FFFFFFFE;  (* PMsg is sent on all PChannels of the audio path. *)
  DMUS_PCHANNEL_BROADCAST_SEGMENT	= $FFFFFFFD;  (* PMsg is sent on all PChannels of the segment. *)
  DMUS_PCHANNEL_BROADCAST_GROUPS  	= $FFFFFFFC;  (* A duplicate PMsg is for each Channels Groups in the performance. *)

(*  The DMUS_PATH constants are used in conjunction with GetObjectInPath to find a requested
    interface at a particular stage in the audio path.
*)
  DMUS_PATH_SEGMENT           = $1000;      (* Get the segment itself (from a segment state.) *)
  DMUS_PATH_SEGMENT_TRACK     = $1100;      (* Look in Track List of Segment. *)
  DMUS_PATH_SEGMENT_GRAPH     = $1200;      (* Get the segment's tool graph. *)
  DMUS_PATH_SEGMENT_TOOL      = $1300;      (* Look in Tool Graph of Segment. *)
  DMUS_PATH_AUDIOPATH         = $2000;      (* Get the audiopath itself (from a segment state.) *)
  DMUS_PATH_AUDIOPATH_GRAPH   = $2200;      (* Get the audiopath's tool graph. *)
  DMUS_PATH_AUDIOPATH_TOOL    = $2300;      (* Look in Tool Graph of Audio Path. *)
  DMUS_PATH_PERFORMANCE       = $3000;      (* Access the performance. *)
  DMUS_PATH_PERFORMANCE_GRAPH = $3200;      (* Get the performance's tool graph. *)
  DMUS_PATH_PERFORMANCE_TOOL  = $3300;      (* Look in Tool Graph of Performance. *)
  DMUS_PATH_PORT              = $4000;      (* Access the synth. *)
  DMUS_PATH_BUFFER            = $6000;      (* Look in DirectSoundBuffer. *)
  DMUS_PATH_BUFFER_DMO        = $6100;      (* Access a DMO in the buffer. *)
  DMUS_PATH_MIXIN_BUFFER      = $7000;      (* Look in a global mixin buffer. *)
  DMUS_PATH_MIXIN_BUFFER_DMO  = $7100;      (* Access a DMO in a global mixin buffer. *)
  DMUS_PATH_PRIMARY_BUFFER    = $8000;      (* Access the primary buffer. *)

(*  To ignore PChannels when calling GetObjectInPath(), use the DMUS_PCHANNEL_ALL constant. *)
  DMUS_PCHANNEL_ALL           = $FFFFFFFB;

(*  The DMUS_APATH types are used in conjunction with CreateStandardAudioPath to
    build default path types. _SHARED_ means the same buffer is shared across multiple
    instantiations of the audiopath type. _DYNAMIC_ means a unique buffer is created
    every time.
*)
  DMUS_APATH_SHARED_STEREOPLUSREVERB  = 1;       (* A standard music set up with stereo outs and reverb. *)
  DMUS_APATH_DYNAMIC_3D               = 6;       (* An audio path with one dynamic bus from the synth feeding to a dynamic 3d buffer. Does not send to env reverb. *)
  DMUS_APATH_DYNAMIC_MONO             = 7;       (* An audio path with one dynamic bus from the synth feeding to a dynamic mono buffer. *)
  DMUS_APATH_DYNAMIC_STEREO           = 8;       (* An audio path with two dynamic buses from the synth feeding to a dynamic stereo buffer. *)

type
  PDMUS_AudioParams = ^TDMUS_AudioParams;
  TDMUS_AudioParams = packed record
    dwSize            : DWORD;  (* Size of this structure. *)
    fInitNow          : BOOL;   (* If true, the sink and synth are created immediately and results returned in this structure. *)
    dwValidData       : DWORD;  (* Flags indicating which fields below are valid. *)
    dwFeatures        : DWORD;  (* Required DMUS_AUDIOF features. *)
    dwVoices          : DWORD;  (* Required number of voices. *)
    dwSampleRate      : DWORD;  (* Sample rate of synths and sink. *)
    clsidDefaultSynth : TGUID;  (* Class ID of default synthesizer. *)
  end;

const
  (* dwFeatures flags. These indicate which features are required for the audio environment. *)
  DMUS_AUDIOF_3D          = $1;   (* Require 3D buffers. *)
  DMUS_AUDIOF_ENVIRON     = $2;   (* Require environmental modeling. *)
  DMUS_AUDIOF_EAX         = $4;   (* Require use of EAX effects. *)
  DMUS_AUDIOF_DMOS        = $8;   (* Require use of additional DMOs. *)
  DMUS_AUDIOF_STREAMING   = $10;  (* Require support for streaming waves. *)
  DMUS_AUDIOF_BUFFERS     = $20;  (* Require support for multiple buffers (all above cases need this.) *)
  DMUS_AUDIOF_ALL         = $3F;  (* Requires everything. *)

  (* dwValidData flags. These indicate which fields in DMUS_AUDIOPARAMS have been filled in. If fInitNow is set, these also return what was allocated. *)
  DMUS_AUDIOPARAMS_FEATURES       = $00000001;
  DMUS_AUDIOPARAMS_VOICES         = $00000002;
  DMUS_AUDIOPARAMS_SAMPLERATE     = $00000004;
  DMUS_AUDIOPARAMS_DEFAULTSYNTH   = $00000008;

(* DMUS_PMsgF_FLAGS fill the TDMus_PMsg's dwFlags member *)
type
  TDMus_PMsgF_Flags = DWORD;
const
  DMUS_PMsgF_REFTIME          = 1;      (* if rtTime is valid *)
  DMUS_PMsgF_MUSICTIME        = 2;      (* if mtTime is valid *)
  DMUS_PMsgF_TOOL_IMMEDIATE   = 4;      (* if PMSG should be processed immediately *)
  DMUS_PMsgF_TOOL_QUEUE       = 8;      (* if PMSG should be processed a little early, at Queue time *)
  DMUS_PMsgF_TOOL_ATTIME      = 16;     (* if PMSG should be processed at the time stamp *)
  DMUS_PMsgF_TOOL_FLUSH       = 32;     (* if PMSG is being flushed *)
  DMUS_PMSGF_LOCKTOREFTIME    = $40;    (* if rtTime can not be overriden by a tempo change. *)
  DMUS_PMSGF_DX8              = $80;    (* if the message has DX8 or later extensions. *)
    (* The values of DMUS_TIME_RESOLVE_FLAGS may also be used inside the *)
    (* DMUS_PMSG's dwFlags member. *)

type
(* DMUS_PMsgT_TYPES fill the TDMus_PMsg's dwType member *)
  TDMus_PMsgT_Types = (
    DMUS_PMsgT_MIDI            ,      (* MIDI short message *)
    DMUS_PMsgT_NOTE            ,      (* Interactive Music Note *)
    DMUS_PMsgT_SYSEX           ,      (* MIDI long message (system exclusive message) *)
    DMUS_PMsgT_NOTIFICATION    ,      (* Notification message *)
    DMUS_PMsgT_TEMPO           ,      (* Tempo message *)
    DMUS_PMsgT_CURVE           ,      (* Control change / pitch bend, etc. curve *)
    DMUS_PMsgT_TIMESIG         ,      (* Time signature *)
    DMUS_PMsgT_PATCH           ,      (* Patch changes *)
    DMUS_PMsgT_TRANSPOSE       ,      (* Transposition messages *)
    DMUS_PMsgT_CHANNEL_PRIORITY,      (* Channel priority *)
    DMUS_PMsgT_STOP            ,      (* Stop message *)
    DMUS_PMsgT_DIRTY           ,      (* Tells Tools that cache GetParam() info to refresh *)
    DMUS_PMSGT_WAVE            ,      (* Carries control information for playing a wave. *)
    DMUS_PMSGT_LYRIC           ,      (* Lyric message from lyric track. *)
    DMUS_PMSGT_SCRIPTLYRIC            (* Lyric message sent by a script with the Trace function. *)
  );
const
  DMUS_PMsgT_USER             = TDMus_PMsgT_Types(255); (* User message *)

type
(* DMUS_SEGF_FLAGS correspond to IDirectMusicPerformance::PlaySegment, and other API *)
  TDMus_SegF_Flags = DWORD;
const
  DMUS_SEGF_REFTIME           = 64;     (* time parameter is in reference time  *)
  DMUS_SEGF_SECONDARY         = 128;    (* secondary segment *)
  DMUS_SEGF_QUEUE             = 256;    (* queue at the end of the primary segment queue (primary only) *)
  DMUS_SEGF_CONTROL           = 512;    (* play as a control track (secondary segments only) *)
  DMUS_SEGF_AFTERPREPARETIME  = 1 shl 10;  (* play after the prepare time (See IDirectMusicPerformance::GetPrepareTime) *)
  DMUS_SEGF_GRID              = 1 shl 11;  (* play on grid boundary *)
  DMUS_SEGF_BEAT              = 1 shl 12;  (* play on beat boundary *)
  DMUS_SEGF_MEASURE           = 1 shl 13;  (* play on measure boundary *)
  DMUS_SEGF_DEFAULT           = 1 shl 14;  (* use segment's default boundary *)
  DMUS_SEGF_NOINVALIDATE      = 1 shl 15;  (* play without invalidating the currently playing segment(s) *)
  DMUS_SEGF_ALIGN             = 1 shl 16;  (* 0x10000 Align segment with requested boundary, but switch at first valid point *)
  DMUS_SEGF_VALID_START_BEAT  = 1 shl 17;  (* 0x20000 In conjunction with DMUS_SEGF_ALIGN, allows the switch to occur on any beat. *)
  DMUS_SEGF_VALID_START_GRID  = 1 shl 18;  (* 0x40000 In conjunction with DMUS_SEGF_ALIGN, allows the switch to occur on any grid. *)
  DMUS_SEGF_VALID_START_TICK  = 1 shl 19;  (* 0x80000 In conjunction with DMUS_SEGF_ALIGN, allows the switch to occur any time. *)
  DMUS_SEGF_AUTOTRANSITION    = 1 shl 20;  (* 0x100000 Compose and play a transition segment, using either the transition template or transition embedded in song. *)
  DMUS_SEGF_AFTERQUEUETIME    = 1 shl 21;  (* 0x200000 Make sure to play after the queue time. This is default for primary segments *)
  DMUS_SEGF_AFTERLATENCYTIME  = 1 shl 22;  (* 0x400000 Make sure to play after the latency time. This is true for all segments, so this is a nop *)
  DMUS_SEGF_SEGMENTEND        = 1 shl 23;  (* 0x800000 Play at the next end of segment. *)
  DMUS_SEGF_MARKER            = 1 shl 24;  (* 0x1000000 Play at next marker in the primary segment. If there are no markers, default to any other resolution requests. *)
  DMUS_SEGF_TIMESIG_ALWAYS    = 1 shl 25;  (* 0x2000000 Even if there is no primary segment, align start time with current time signature. *)
  DMUS_SEGF_USE_AUDIOPATH     = 1 shl 26;  (* 0x4000000 Uses the audio path that is embedded in the segment or song. *)
  DMUS_SEGF_VALID_START_MEASURE = 1 shl 27; (* 0x8000000 In conjunction with DMUS_SEGF_ALIGN, allows the switch to occur on any bar. *)

  DMUS_SEG_REPEAT_INFINITE    = $FFFFFFFF;  (* For IDirectMusicSegment::SetRepeat*)
  DMUS_SEG_ALLTRACKS          = $80000000;  (* For IDirectMusicSegment::SetParam() and SetTrackConfig() - selects all tracks instead on nth index. *)
  DMUS_SEG_ANYTRACK           = $80000000;  (* For IDirectMusicSegment::GetParam() - checks each track until it finds one that returns data (not DMUS_E_NOT_FOUND.) *)

(* DMUS_TIME_RESOLVE_FLAGS correspond to IDirectMusicPerformance::GetResolvedTime, and can *)
(* also be used interchangeably with the corresponding DMUS_SEGF_FLAGS, since their values *)
(* are intentionally the same *)
type
  TDMus_Time_Resolve_Flags = DWORD;
const
  DMUS_TIME_RESOLVE_AFTERPREPARETIME  = DMUS_SEGF_AFTERPREPARETIME;
  DMUS_TIME_RESOLVE_AFTERQUEUETIME    = DMUS_SEGF_AFTERQUEUETIME;
  DMUS_TIME_RESOLVE_AFTERLATENCYTIME  = DMUS_SEGF_AFTERLATENCYTIME;
  DMUS_TIME_RESOLVE_GRID              = DMUS_SEGF_GRID;
  DMUS_TIME_RESOLVE_BEAT              = DMUS_SEGF_BEAT;
  DMUS_TIME_RESOLVE_MEASURE           = DMUS_SEGF_MEASURE;
  DMUS_TIME_RESOLVE_MARKER            = DMUS_SEGF_MARKER;
  DMUS_TIME_RESOLVE_SEGMENTEND        = DMUS_SEGF_SEGMENTEND;

(* The following flags are sent inside the DMUS_CHORD_KEY.dwFlags parameter *)
type
  DMUS_ChordKeyF_Flags = DWORD;
const
  DMUS_CHORDKEYF_SILENT = 1;   (* is the chord silent? *)

  DMUS_MAXSUBCHORD      = 8;

(* The following flags are sent in the IDirectMusicTrack::Play() method *)
(* inside the dwFlags parameter *)
type
  TDMus_TrackF_Flags = DWORD;
const
  DMUS_TRACKF_SEEK            = 1;     (* set on a seek *)
  DMUS_TRACKF_LOOP            = 2;     (* set on a loop (repeat) *)
  DMUS_TRACKF_START           = 4;     (* set on first call to Play *)
  DMUS_TRACKF_FLUSH           = 8;     (* set when this call is in response to a flush on the perfomance *)
  DMUS_TRACKF_DIRTY           = $10;   (* set when the track should consider any cached values from a previous call to GetParam to be invalidated *)
      (* The following flags are DX8 only. *)
  DMUS_TRACKF_NOTIFY_OFF      = $20;   (* tells track not to send notifications. *)
  DMUS_TRACKF_PLAY_OFF        = $40;   (* tells track not to play anything (but can still send notifications.) *)
  DMUS_TRACKF_LOOPEND         = $80;   (* set when the end of range is also a loop end. *)
  DMUS_TRACKF_STOP            = $100;  (* set when the end of range is also end of playing this segment. *)
  DMUS_TRACKF_RECOMPOSE       = $200;  (* set to indicate the track should compose. *)
  DMUS_TRACKF_CLOCK           = $400;  (* set when time parameters are in reference (clock) time. Only valid for PlayEx(). *)

(* The following flags are sent in the IDirectMusicTrack8::GetParamEx() and SetParamEx() methods *)
(* inside the dwFlags parameter *)
  DMUS_TRACK_PARAMF_CLOCK     = $01;       (* set when the time is measured is in reference (clock) time *)

  DMUS_REGSTR_PATH_TOOLS      = 'Software\Microsoft\DirectMusic\Tools';

  MT_MIN          = $80000000;  (* Minimum music time value. *)
  MT_MAX          = $7FFFFFFF;  (* Maximum music time value. *)

type
  IDirectMusicTrack         = interface;
  IDirectMusicTrack8        = interface;
  IDirectMusicPerformance   = interface;
  IDirectMusicPerformance8  = interface;
  IDirectMusicSegment       = interface;
  IDirectMusicSegment8      = interface;
  IDirectMusicSegmentState  = interface;
  IDirectMusicSegmentState8 = interface;
  IDirectMusicTool          = interface;
  IDirectMusicTool8         = interface;
  IDirectMusicGraph         = interface;
(*IDirectMusicGraph8        = interface;  *)
  IDirectMusicAudioPath     = interface;
(*IDirectMusicAudioPath8    = interface;  *)

  PIDirectMusicSegmentState = ^IDirectMusicSegmentState;

  TDMus_PMsg_Part = record
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
  end;

(* every TDMus_PMsg is based off of this structure. The Performance needs
   to access these members consistently in every PMSG that goes through it. *)

    (* begin DMUS_PMsg_PART *)
  PDMus_PMsg = ^TDMus_PMsg;
  TDMus_PMsg = TDMus_PMsg_Part;
    (* end DMUS_PMsg_PART *)

(* DMUS_NOTIFICATION_PMsg *)
  PDMus_Notification_PMsg = ^TDMus_Notification_PMsg;
  TDMus_Notification_PMsg = record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    guidNotificationType : TGUID;
    dwNotificationOption : DWORD;
    dwField1             : DWORD;
    dwField2             : DWORD;
  end;

  TDMus_SubChord = packed record
    dwChordPattern    : DWORD;    (* Notes in the subchord *)
    dwScalePattern    : DWORD;    (* Notes in the scale *)
    dwInversionPoints : DWORD;    (* Where inversions can occur *)
    dwLevels          : DWORD;    (* Which levels are supported by this subchord *)
    bChordRoot        : BYTE;     (* Root of the subchord *)
    bScaleRoot        : BYTE;     (* Root of the scale *)
  end;

  TDMus_Chord_Key_DX6 = packed record
    wszName        : array [0..15] of WideChar;  (* Name of the chord *)
    wMeasure       : WORD;                (* Measure this falls on *)
    bBeat          : BYTE;                (* Beat this falls on *)
    bSubChordCount : BYTE;                (* Number of chords in the list of subchords *)
    SubChordList   : array [0..DMUS_MAXSUBCHORD-1] of TDMus_SubChord; (* List of sub chords *)
    dwScale        : DWORD;               (* Scale underlying the entire chord *)
    bKey           : BYTE;                (* Key underlying the entire chord *)
  end;
  TDMus_Chord_Key_DX7 = TDMus_Chord_Key_DX6;

  TDMus_Chord_Key_DX8 = packed record
    wszName        : array [0..15] of WideChar;  (* Name of the chord *)
    wMeasure       : WORD;                (* Measure this falls on *)
    bBeat          : BYTE;                (* Beat this falls on *)
    bSubChordCount : BYTE;                (* Number of chords in the list of subchords *)
    SubChordList   : array [0..DMUS_MAXSUBCHORD-1] of TDMus_SubChord; (* List of sub chords *)
    dwScale        : DWORD;               (* Scale underlying the entire chord *)
    bKey           : BYTE;                (* Key underlying the entire chord *)
    bFlags         : BYTE;                (* Miscelaneous flags *)
  end;

{$IFDEF DIRECTX6}
  TDMus_Chord_Key = TDMus_Chord_Key_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_Chord_Key = TDMus_Chord_Key_DX7;
  {$ELSE}
    TDMus_Chord_Key = TDMus_Chord_Key_DX8;
  {$ENDIF}
{$ENDIF}

(* Time Signature structure, used by IDirectMusicStyle *)
(* Also used as a parameter for GetParam() and SetParam *)
  TDMus_TimeSignature = packed record
    mtTime           : TMusic_Time;
    bBeatsPerMeasure : BYTE;          (* beats per measure (top of time sig) *)
    bBeat            : BYTE;          (* what note receives the beat (bottom of time sig.) *)
                                      (* we can assume that 0 means 256th note *)
    wGridsPerBeat    : WORD;          (* grids per beat *)
  end;

  TDMUS_VALID_START_PARAM = packed record
    mtTime: TMusic_Time; (* Time of the first legal start point after (or including) the requested time.
                            This is a returned value. Time format is the relative offset from requested time. *)
  end;

  TDMUS_PLAY_MARKER_PARAM = packed record
    mtTime: TMusic_Time; (* Time of the first legal segment play marker before (or including) the requested time.
                            This is a returned value. Time format is the relative offset from requested time. *)
  end;
  
(*/////////////////////////////////////////////////////////////////////
// IDirectMusicSegmentState *)
  IDirectMusicSegmentState = interface (IUnknown)
    ['{a3afdcc7-d3ee-11d1-bc8d-00a0c922e6eb}']
    function GetRepeats (out pdwRepeats: DWORD) : HResult; stdcall;
    function GetSegment (out ppSegment: IDirectMusicSegment) : HResult; stdcall;
    function GetStartTime (out pmtStart: TMusic_Time) : HResult; stdcall;
    function GetSeek (out pmtSeek: TMusic_Time) : HResult; stdcall;
    function GetStartPoint (out pmtStart: TMusic_Time) : HResult; stdcall;
  end;

  IDirectMusicSegmentState8 = interface (IDirectMusicSegmentState)
    ['{a50e4730-0ae4-48a7-9839-bc04bfe07772}']
    function SetTrackConfig (const rguidTrackClassID: TGUID;
        dwGroupBits, dwIndex, dwFlagsOn, dwFlagsOff: DWORD) : HResult; stdcall;
    function GetObjectInPath (dwPChannel, dwStage, dwBuffer: DWORD;
        const guidObject: TGUID; dwIndex: DWORD; const iidInterface: TGUID;
        out ppObject) : HResult; stdcall;
  end;

(*////////////////////////////////////////////////////////////////////
// IDirectMusicAudioPath *)
  IDirectMusicAudioPath = interface (IUnknown)
    ['{c87631f5-23be-4986-8836-05832fcc48f9}']
    function GetObjectInPath (dwPChannel, dwStage, dwBuffer: DWORD;
        const guidObject: TGUID; dwIndex: DWORD;
        const iidInterface: TGUID; out ppObject) : HResult; stdcall;
    function Activate (fActivate: BOOL) : HResult; stdcall;
    function SetVolume (lVolume: Longint; dwDuration: DWORD) : HResult; stdcall;
    function ConvertPChannel (dwPChannelIn: DWORD; var pdwPChannelOut: DWORD) : HResult; stdcall;
  end;
  IDirectMusicAudioPath8 = IDirectMusicAudioPath;

(*////////////////////////////////////////////////////////////////////
// IDirectMusicSegment *)
  IDirectMusicSegment = interface (IUnknown)
    ['{f96029a2-4282-11d2-8717-00600893b1bd}']
    function GetLength (out pmtLength: TMusic_Time) : HResult; stdcall;
    function SetLength (mtLength: TMusic_Time) : HResult; stdcall;
    function GetRepeats (out pdwRepeats: DWORD) : HResult; stdcall;
    function SetRepeats (dwRepeats: DWORD) : HResult; stdcall;
    function GetDefaultResolution (out pdwResolution: DWORD) : HResult; stdcall;
    function SetDefaultResolution (dwResolution: DWORD) : HResult; stdcall;
    function GetTrack (const rguidType: TGUID; dwGroupBits, dwIndex: DWORD;
        out ppTrack: IDirectMusicTrack) : HResult; stdcall;
    function GetTrackGroup (pTrack: IDirectMusicTrack; out pdwGroupBits: DWORD) : HResult; stdcall;
    function InsertTrack (pTrack: IDirectMusicTrack; dwGroupBits: DWORD) : HResult; stdcall;
    function RemoveTrack (pTrack: IDirectMusicTrack) : HResult; stdcall;
    function InitPlay (out ppSegState: IDirectMusicSegmentState;
        pPerformance: IDirectMusicPerformance; dwFlags: DWORD) : HResult; stdcall;
    function GetGraph (out ppGraph: IDirectMusicGraph) : HResult; stdcall;
    function SetGraph (pGraph: IDirectMusicGraph) : HResult; stdcall;
    function AddNotificationType (const rguidNotificationType: TGUID) : HResult; stdcall;
    function RemoveNotificationType (const rguidNotificationType: TGUID) : HResult; stdcall;
    function GetParam (const rguidType: TGUID; dwGroupBits, dwIndex: DWORD;
        mtTime: TMusic_Time; out pmtNext: TMusic_Time; pParam: Pointer) : HResult; stdcall;
    function SetParam (const rguidType: TGUID; dwGroupBits, dwIndex: DWORD;
        mtTime: TMusic_Time; pParam: Pointer) : HResult; stdcall;
    function Clone (mtStart: TMusic_Time; mtEnd: TMusic_Time;
        out ppSegment: IDirectMusicSegment) : HResult; stdcall;
    function SetStartPoint (mtStart: TMusic_Time) : HResult; stdcall;
    function GetStartPoint (out pmtStart: TMusic_Time) : HResult; stdcall;
    function SetLoopPoints (mtStart: TMusic_Time; mtEnd: TMusic_Time) : HResult; stdcall;
    function GetLoopPoints (out pmtStart, pmtEnd: TMusic_Time) : HResult; stdcall;
    function SetPChannelsUsed (dwNumPChannels: DWORD; var paPChannels: DWORD) : HResult; stdcall;
  end;

  IDirectMusicSegment8 = interface (IDirectMusicSegment)
    ['{c6784488-41a3-418f-aa15-b35093ba42d4}']
    function SetTrackConfig ( const rguidTrackClassID: TGUID;
        dwGroupBits, dwIndex, dwFlagsOn, dwFlagsOff: DWORD) : HResult; stdcall;
    function GetAudioPathConfig (out ppAudioPathConfig: IUnknown) : HResult; stdcall;
    function Compose (mtTime: TMusic_Time; pFromSegment, pToSegment: IDirectMusicSegment;
        out ppComposedSegment: IDirectMusicSegment) : HResult; stdcall;
    function Download (pAudioPath: IUnknown) : HResult; stdcall;
    function Unload (pAudioPath: IUnknown) : HResult; stdcall;
  end;

(*////////////////////////////////////////////////////////////////////
// IDirectMusicTrack *)
  IDirectMusicTrack = interface (IUnknown)
    ['{f96029a1-4282-11d2-8717-00600893b1bd}']
    function Init (pSegment: IDirectMusicSegment) : HResult; stdcall;
    function InitPlay (pSegmentState: IDirectMusicSegmentState;
        pPerformance: IDirectMusicPerformance; out ppStateData: Pointer;
        dwVirtualTrackID, dwFlags: DWORD) : HResult; stdcall;
    function EndPlay (pStateData: Pointer) : HResult; stdcall;
    function Play (pStateData: Pointer; mtStart, mtEnd, mtOffset: TMusic_Time;
        dwFlags: DWORD; pPerf: IDirectMusicPerformance;
        pSegSt: IDirectMusicSegmentState; dwVirtualID: DWORD) : HResult; stdcall;
    function GetParam (const rguidType: TGUID; mtTime: TMusic_Time; out pmtNext: TMusic_Time;
        pParam: Pointer): HResult; stdcall;
    function SetParam (const rguidType: TGUID; mtTime: TMusic_Time; pParam: Pointer) : HResult; stdcall;
    function IsParamSupported  (const rguidType: TGUID) : HResult; stdcall;
    function AddNotificationType (const rguidNotificationType: TGUID) : HResult; stdcall;
    function RemoveNotificationType (const rguidNotificationType: TGUID) : HResult; stdcall;
    function Clone (mtStart: TMusic_Time; mtEnd: TMusic_Time; out ppTrack: IDirectMusicTrack) : HResult; stdcall;
  end;

(*////////////////////////////////////////////////////////////////////
// IDirectMusicTrack8 *)
  IDirectMusicTrack8 = interface (IDirectMusicTrack)
    ['{0e674304-3b05-11d3-9bd1-f9e7f0a01536}']
    function PlayEx (pStateData: Pointer; rtStart, rtEnd, rtOffset: TReference_Time;
         dwFlags: DWORD; pPerf: IDirectMusicPerformance;
         pSegSt: IDirectMusicSegmentState; dwVirtualID: DWORD): HResult; stdcall;
    function GetParamEx (const rguidType: TGUID; rtTime: TReference_Time;
         out prtNext: TReference_Time; pParam, pStateData: pointer; dwFlags: DWORD): HResult; stdcall;
    function SetParamEx (const rguidType: TGUID; rtTime: TReference_Time;
         pParam, pStateData: pointer; dwFlags: DWORD): HResult; stdcall;
    function Compose (pContext: IUnknown; dwTrackGroup: DWORD;
         out ppResultTrack: IDirectMusicTrack): HResult; stdcall;
    function Join (pNewTrack: IDirectMusicTrack; mtJoin: TMusic_Time;
         pContext: IUnknown; dwTrackGroup: DWORD;
         out ppResultTrack: IDirectMusicTrack): HResult; stdcall;
  end;

PIDirectMusic = ^IDirectMusic;

(*////////////////////////////////////////////////////////////////////
// IDirectMusicPerformance *)
  IDirectMusicPerformance = interface (IUnknown)
    ['{07d43d03-6523-11d2-871d-00600893b1bd}']
    function Init (var ppDirectMusic: IDirectMusic;
        pDirectSound: IDirectSound; hWnd: HWND ) : HResult; stdcall;
    function PlaySegment (pSegment: IDirectMusicSegment; dwFlags: DWORD;
        i64StartTime: LongLong; ppSegmentState: PIDirectMusicSegmentState) : HResult; stdcall;
    function Stop (pSegment: IDirectMusicSegment; pSegmentState: IDirectMusicSegmentState;
        mtTime: TMusic_Time; dwFlags: DWORD) : HResult; stdcall;
    function GetSegmentState (out ppSegmentState: IDirectMusicSegmentState;
        mtTime: TMusic_Time) : HResult; stdcall;
    function SetPrepareTime (dwMilliSeconds: DWORD) : HResult; stdcall;
    function GetPrepareTime (out pdwMilliSeconds: DWORD) : HResult; stdcall;
    function SetBumperLength (dwMilliSeconds: DWORD) : HResult; stdcall;
    function GetBumperLength (out pdwMilliSeconds: DWORD) : HResult; stdcall;
    function SendPMsg (pPMSG: PDMus_PMsg) : HResult; stdcall;
    function MusicToReferenceTime (mtTime: TMusic_Time; out prtTime: TReference_Time) : HResult; stdcall;
    function ReferenceToMusicTime (rtTime: TReference_Time; out pmtTime: TMusic_Time) : HResult; stdcall;
    function IsPlaying (pSegment: IDirectMusicSegment; pSegState: IDirectMusicSegmentState) : HResult; stdcall;
    function GetTime (prtNow: PReference_Time; pmtNow: PMusic_Time) : HResult; stdcall;
    function AllocPMsg (cb: ULONG; out ppPMSG: PDMus_PMsg) : HResult; stdcall;
    function FreePMsg (pPMSG: PDMus_PMsg) : HResult; stdcall;
    function GetGraph (out ppGraph: IDirectMusicGraph) : HResult; stdcall;
    function SetGraph (pGraph: IDirectMusicGraph) : HResult; stdcall;
    function SetNotificationHandle (hNotification: THANDLE; rtMinimum: TReference_Time) : HResult; stdcall;
    function GetNotificationPMsg (out ppNotificationPMsg: PDMus_Notification_PMsg) : HResult; stdcall;
    function AddNotificationType (const rguidNotificationType: TGUID) : HResult; stdcall;
    function RemoveNotificationType (const rguidNotificationType: TGUID) : HResult; stdcall;
    function AddPort (pPort: IDirectMusicPort) : HResult; stdcall;
    function RemovePort (pPort: IDirectMusicPort) : HResult; stdcall;
    function AssignPChannelBlock (dwBlockNum: DWORD; pPort: IDirectMusicPort;
        dwGroup: DWORD) : HResult; stdcall;
    function AssignPChannel (dwPChannel: DWORD; pPort: IDirectMusicPort;
        dwGroup, dwMChannel: DWORD) : HResult; stdcall;
    function PChannelInfo (dwPChannel: DWORD; out ppPort: IDirectMusicPort;
        out pdwGroup, pdwMChannel: DWORD ) : HResult; stdcall;
    function DownloadInstrument (pInst: IDirectMusicInstrument; dwPChannel: DWORD;
        out ppDownInst: IDirectMusicDownloadedInstrument; var pNoteRanges: TDMus_NoteRange;
        dwNumNoteRanges: DWORD; out ppPort: IDirectMusicPort;
        out pdwGroup, pdwMChannel: DWORD) : HResult; stdcall;
    function Invalidate (mtTime: TMusic_Time; dwFlags: DWORD) : HResult; stdcall;
    function GetParam (const rguidType: TGUID; dwGroupBits, dwIndex: DWORD;
        mtTime: TMusic_Time; out pmtNext: TMusic_Time; pParam: Pointer) : HResult; stdcall;
    function SetParam (const rguidType: TGUID; dwGroupBits, dwIndex: DWORD;
        mtTime: TMusic_Time; pParam: Pointer) : HResult; stdcall;
    function GetGlobalParam (const rguidType: TGUID; pParam: Pointer;
        dwSize: DWORD) : HResult; stdcall;
    function SetGlobalParam (const rguidType: TGUID; pParam: Pointer;
        dwSize: DWORD) : HResult; stdcall;
    function GetLatencyTime (out prtTime: TReference_Time) : HResult; stdcall;
    function GetQueueTime (out prtTime: TReference_Time) : HResult; stdcall;
    function AdjustTime (rtAmount: TReference_Time) : HResult; stdcall;
    function CloseDown : HResult; stdcall;
    function GetResolvedTime (rtTime: TReference_Time; out prtResolved: TReference_Time;
        dwTimeResolveFlags: DWORD) : HResult; stdcall;
    function MIDIToMusic (bMIDIValue: BYTE; const pChord: TDMus_Chord_Key;
        bPlayMode, bChordLevel: Byte; out pwMusicValue: WORD) : HResult; stdcall;
    function MusicToMIDI (wMusicValue: WORD; const pChord: TDMus_Chord_Key;
        bPlayMode, bChordLevel: BYTE; out pbMIDIValue: BYTE) : HResult; stdcall;
    function TimeToRhythm (mtTime: TMusic_Time; const pTimeSig: TDMus_TimeSignature;
        out pwMeasure: WORD; out pbBeat, pbGrid: BYTE;
        out pnOffset: SmallInt) : HResult; stdcall;
    function RhythmToTime (wMeasure: WORD; bBeat, bGrid: BYTE; nOffset: SmallInt;
        const pTimeSig: TDMus_TimeSignature; out pmtTime: TMusic_Time) : HResult; stdcall;
  end;

  IDirectMusicPerformance8 = interface (IDirectMusicPerformance)
    ['{679c4137-c62e-4147-b2b4-9d569acb254c}']
    function InitAudio (ppDirectMusic: PIDirectMusic; ppDirectSound: PIDirectSound;
        hWnd: hWnd; dwDefaultPathType, dwPChannelCount, dwFlags: DWORD;
        pParams: PDMUS_AudioParams) : HResult; stdcall;
    function PlaySegmentEx (pSource: IUnknown; pwzSegmentName: PWChar;
        pTransition: IUnknown; dwFlags: DWORD; i64StartTime: int64;
        out ppSegmentState: IDirectMusicSegmentState; pFrom, pAudioPath: IUnknown) : HResult; stdcall;
    function StopEx (pObjectToStop: IUnknown; i64StopTime: int64; dwFlags: DWORD) : HResult; stdcall;
    function ClonePMsg (pSourcePMSG: TDMUS_PMSG; var ppCopyPMSG: TDMUS_PMSG) : HResult; stdcall;
    function CreateAudioPath (pSourceConfig: IUnknown; fActivate: BOOL;
        out ppNewPath: IDirectMusicAudioPath) : HResult; stdcall;
    function CreateStandardAudioPath (dwType, dwPChannelCount: DWORD; fActivate: BOOL;
        out ppNewPath: IDirectMusicAudioPath) : HResult; stdcall;
    function SetDefaultAudioPath (pAudioPath: IDirectMusicAudioPath) : HResult; stdcall;
    function GetDefaultAudioPath (out ppAudioPath: IDirectMusicAudioPath) : HResult; stdcall;
    function GetParamEx (const rguidType: TGUID; dwTrackID, dwGroupBits, dwIndex: DWORD;
        mtTime, pmtNext: TMusic_Time; pParam: Pointer) : HResult; stdcall;
  end;

(*////////////////////////////////////////////////////////////////////
// IDirectMusicTool *)
  IDirectMusicTool = interface (IUnknown)
    ['{d2ac28ba-b39b-11d1-8704-00600893b1bd}']
    function Init (pGraph: IDirectMusicGraph) : HResult; stdcall;
    function GetMsgDeliveryType (out pdwDeliveryType: DWORD) : HResult; stdcall;
    function GetMediaTypeArraySize (out pdwNumElements: DWORD) : HResult; stdcall;
    function GetMediaTypes (out padwMediaTypes: PDWORD; dwNumElements: DWORD) : HResult; stdcall;
    function ProcessPMsg (pPerf: IDirectMusicPerformance; pPMSG: PDMus_PMsg) : HResult; stdcall;
    function Flush (pPerf: IDirectMusicPerformance; const pPMSG: TDMus_PMsg;
        rtTime: TReference_Time) : HResult; stdcall;
  end;

(*////////////////////////////////////////////////////////////////////
// IDirectMusicTool8 *)
  IDirectMusicTool8 = interface (IDirectMusicTool)
    ['{0e674303-3b05-11d3-9bd1-f9e7f0a01536}']
    function Clone (out ppTool: IDirectMusicTool) : HResult; stdcall;
  end;


(*////////////////////////////////////////////////////////////////////
// IDirectMusicGraph *)
  IDirectMusicGraph = interface (IUnknown)
    ['{2befc277-5497-11d2-bccb-00a0c922e6eb}']
    function StampPMsg (var pPMSG: TDMus_PMsg ) : HResult; stdcall;
    function InsertTool (pTool: IDirectMusicTool; var pdwPChannels: DWORD;
        cPChannels: DWORD; lIndex: LongInt) : HResult; stdcall;
    function GetTool (dwIndex: DWORD; out ppTool: IDirectMusicTool) : HResult; stdcall;
    function RemoveTool (pTool: IDirectMusicTool) : HResult; stdcall;
  end;
  IDirectMusicGraph8 = IDirectMusicGraph;


(* DMUS_NOTE_PMsg *)
  TDMus_Note_PMsg = packed record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    mtDuration       : TMusic_Time;          (* duration *)
    wMusicValue      : WORD;                 (* Description of note in chord and key. *)
    wMeasure         : WORD;                 (* Measure in which this note occurs *)
    nOffset          : SmallInt;             (* Offset from grid at which this note occurs *)
    bBeat            : BYTE;                 (* Beat (in measure) at which this note occurs *)
    bGrid            : BYTE;                 (* Grid offset from beat at which this note occurs *)
    bVelocity        : BYTE;                 (* Note velocity *)
    bFlags           : BYTE;                 (* see DMUS_NOTE_FLAGS *)
    bTimeRange       : BYTE;                 (* Range to randomize time. *)
    bDurRange        : BYTE;                 (* Range to randomize duration. *)
    bVelRange        : BYTE;                 (* Range to randomize velocity. *)
    bPlayModeFlags   : BYTE;                 (* Play mode *)
    bSubChordLevel   : BYTE;                 (* Which subchord level this note uses.  *)
    bMidiValue       : BYTE;                 (* The MIDI note value, converted from wMusicValue *)
    cTranspose       : char;                 (* Transposition to add to midi note value after converted from wMusicValue. *)
  end;

  TDMus_NoteF_Flags = DWORD;
const
  DMUS_NOTEF_NOTEON               = 1;     (* Set if this is a MIDI Note On. Otherwise, it is MIDI Note Off *)
      (* DX8 flags: *)
  DMUS_NOTEF_NOINVALIDATE         = 2;     (* Don't invalidate this note off. *)
  DMUS_NOTEF_NOINVALIDATE_INSCALE = 4;     (* Don't invalidate if still within the scale. *)
  DMUS_NOTEF_NOINVALIDATE_INCHORD = 8;     (* Don't invalidate if still within the chord. *)
  DMUS_NOTEF_REGENERATE           = $10;   (* Regenerate the note on an invalidate. *)

(* The DMUS_PLAYMODE_FLAGS are used to determine how to convert wMusicValue
   into the appropriate bMidiValue.
*)
type
  TDMus_PlayMode_Flags = DWORD;
const
   DMUS_PLAYMODE_KEY_ROOT          = 1;  (* Transpose on top of the key root. *)
   DMUS_PLAYMODE_CHORD_ROOT        = 2;  (* Transpose on top of the chord root. *)
   DMUS_PLAYMODE_SCALE_INTERVALS   = 4;  (* Use scale intervals from scale pattern. *)
   DMUS_PLAYMODE_CHORD_INTERVALS   = 8;  (* Use chord intervals from chord pattern. *)
   DMUS_PLAYMODE_NONE              = 16; (* No mode. Indicates the parent part's mode should be used. *)

(* The following are playback modes that can be created by combining the DMUS_PLAYMODE_FLAGS
   in various ways:
*)

(* Fixed. wMusicValue holds final MIDI note value. This is used for drums, sound effects, and sequenced
   notes that should not be transposed by the chord or scale.
*)
  DMUS_PLAYMODE_FIXED            = 0;
(* In fixed to key, the musicvalue is again a fixed MIDI value, but it
   is transposed on top of the key root.
*)
  DMUS_PLAYMODE_FIXEDTOKEY       = DMUS_PLAYMODE_KEY_ROOT;
(* In fixed to chord, the musicvalue is also a fixed MIDI value, but it
   is transposed on top of the chord root. 
*)
  DMUS_PLAYMODE_FIXEDTOCHORD     = DMUS_PLAYMODE_CHORD_ROOT;
(* In Pedalpoint, the key root is used and the notes only track the intervals in
   the scale. The chord root and intervals are completely ignored. This is useful
   for melodic lines that play relative to the key root.
*)
  DMUS_PLAYMODE_PEDALPOINT       = (DMUS_PLAYMODE_KEY_ROOT or DMUS_PLAYMODE_SCALE_INTERVALS);
(* In the Melodic mode, the chord root is used but the notes only track the intervals in
   the scale. The key root and chord intervals are completely ignored. This is useful
   for melodic lines that play relative to the chord root.
*)
  DMUS_PLAYMODE_MELODIC          = (DMUS_PLAYMODE_CHORD_ROOT or DMUS_PLAYMODE_SCALE_INTERVALS);
(* Normal chord mode is the prevalent playback mode. 
   The notes track the intervals in the chord, which is based on the chord root. 
   If there is a scale component to the MusicValue, the additional intervals 
   are pulled from the scale and added.
   If the chord does not have an interval to match the chord component of
   the MusicValue, the note is silent.
*)
  DMUS_PLAYMODE_NORMALCHORD      = (DMUS_PLAYMODE_CHORD_ROOT or DMUS_PLAYMODE_CHORD_INTERVALS);
(* If it is desirable to play a note that is above the top of the chord, the
   always play mode (known as "purpleized" in a former life) finds a position
   for the note by using intervals from the scale. Essentially, this mode is
   a combination of the Normal and Melodic playback modes, where a failure
   in Normal causes a second try in Melodic mode.
*)
  DMUS_PLAYMODE_ALWAYSPLAY       = (DMUS_PLAYMODE_MELODIC or DMUS_PLAYMODE_NORMALCHORD);

(* These playmodes are new for dx8. *)
(* In PedalpointChord, the key root is used and the notes only track the intervals in
   the chord. The chord root and scale intervals are completely ignored. This is useful
   for chordal lines that play relative to the key root.
*)
  DMUS_PLAYMODE_PEDALPOINTCHORD  = (DMUS_PLAYMODE_KEY_ROOT or DMUS_PLAYMODE_CHORD_INTERVALS);

(* For completeness, here's a mode that tries for pedalpointchord, but if it fails
   uses scale intervals
*)
  DMUS_PLAYMODE_PEDALPOINTALWAYS = (DMUS_PLAYMODE_PEDALPOINT or DMUS_PLAYMODE_PEDALPOINTCHORD);

(*  Legacy names for modes... *)
  DMUS_PLAYMODE_PURPLEIZED       = DMUS_PLAYMODE_ALWAYSPLAY;
  DMUS_PLAYMODE_SCALE_ROOT       = DMUS_PLAYMODE_KEY_ROOT;
  DMUS_PLAYMODE_FIXEDTOSCALE     = DMUS_PLAYMODE_FIXEDTOKEY;

type
(* DMUS_MIDI_PMsg *)
  TDMus_Midi_PMsg = record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    bStatus          : BYTE;
    bByte1           : BYTE;
    bByte2           : BYTE;
    bPad             : array [0..0] of BYTE;
  end;

(* DMUS_PATCH_PMsg *)
  TDMus_Patch_PMsg = packed record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    byInstrument     : BYTE;
    byMSB            : BYTE;
    byLSB            : BYTE;
    byPad            : array [0..0] of BYTE;
  end;

(* DMUS_TRANSPOSE_PMsg *)  // DirectX 6/7 Version
  TDMus_Transpose_PMsg_DX6 = packed record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    nTranspose       : SmallInt;
  end;
  TDMus_Transpose_PMsg_DX7 = TDMus_Transpose_PMsg_DX6;

(* DMUS_TRANSPOSE_PMsg *)  // DirectX 8 Version
  TDMus_Transpose_PMsg_DX8 = packed record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    nTranspose       : SmallInt;
    (* Following exists only under DX8 and on (check dwFlags for DMUS_PMSGF_DX8) *)
    wMergeIndex      : WORD;                 (* Allows multiple parameters to be merged (pitchbend, volume, and expression.)*)
  end;

{$IFDEF DIRECTX6}
  TDMus_Transpose_PMsg = TDMus_Transpose_PMsg_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_Transpose_PMsg = TDMus_Transpose_PMsg_DX7;
  {$ELSE}
    TDMus_Transpose_PMsg = TDMus_Transpose_PMsg_DX8;
  {$ENDIF}
{$ENDIF}

(* DMUS_CHANNEL_PRIORITY_PMsg *)
  TDMus_Channel_Priority_PMsg = packed record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    dwChannelPriority: DWORD;
  end;

(* DMUS_TEMPO_PMsg *)
  TDMus_Tempo_PMsg = packed record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    dblTempo         : double;               (* the tempo *)
  end;

const
  DMUS_TEMPO_MAX         = 1000;
  DMUS_TEMPO_MIN         = 1;

  DMUS_MASTERTEMPO_MAX   = 100.0;
  DMUS_MASTERTEMPO_MIN   = 0.01;

type
(* DMUS_SYSEX_PMsg *)
  TDMus_SysEx_PMsg = packed record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    dwLen            : DWORD;                (* length of the data *)
    abData           : array [0..0] of BYTE; (* array of data, length equal to dwLen *)
  end;

(* DMUS_CURVE_PMsg *) // DirectX 6/7 Version
  TDMus_Curve_PMsg_DX6 = packed record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    mtDuration      : TMusic_Time;     (* how long this curve lasts *)
    mtOriginalStart : TMusic_Time;     (* must be set to either zero when this PMSG is created or to the original mtTime of the curve *)
    mtResetDuration : TMusic_Time;     (* how long after the curve is finished to reset to the
                                        reset value, nResetValue *)
    nStartValue     : SmallInt;        (* curve's start value *)
    nEndValue       : SmallInt;        (* curve's end value *)
    nResetValue     : SmallInt;        (* curve's reset value, sent after mtResetDuration or
                                        upon a flush or invalidation *)
    wMeasure        : WORD;            (* Measure in which this curve occurs *)
    nOffset         : SmallInt;        (* Offset from grid at which this curve occurs *)
    bBeat           : BYTE;            (* Beat (in measure) at which this curve occurs *)
    bGrid           : BYTE;            (* Grid offset from beat at which this curve occurs *)
    bType           : BYTE;            (* type of curve *)
    bCurveShape     : BYTE;            (* shape of curve *)
    bCCData         : BYTE;            (* CC# if this is a control change type *)
    bFlags          : BYTE;            (* set to 1 if the nResetValue must be sent when the time is reached or an invalidate occurs because
                                        of a transition. If 0, the curve stays permanently stuck at the new value. All bits besides 1 are reserved. *)
  end;
  TDMus_Curve_PMsg_DX7 = TDMus_Curve_PMsg_DX6;

(* DMUS_CURVE_PMsg *) // DirectX 8 Version
  TDMus_Curve_PMsg_DX8 = packed record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    mtDuration      : TMusic_Time;     (* how long this curve lasts *)
    mtOriginalStart : TMusic_Time;     (* must be set to either zero when this PMSG is created or to the original mtTime of the curve *)
    mtResetDuration : TMusic_Time;     (* how long after the curve is finished to reset to the
                                        reset value, nResetValue *)
    nStartValue     : SmallInt;        (* curve's start value *)
    nEndValue       : SmallInt;        (* curve's end value *)
    nResetValue     : SmallInt;        (* curve's reset value, sent after mtResetDuration or
                                        upon a flush or invalidation *)
    wMeasure        : WORD;            (* Measure in which this curve occurs *)
    nOffset         : SmallInt;        (* Offset from grid at which this curve occurs *)
    bBeat           : BYTE;            (* Beat (in measure) at which this curve occurs *)
    bGrid           : BYTE;            (* Grid offset from beat at which this curve occurs *)
    bType           : BYTE;            (* type of curve *)
    bCurveShape     : BYTE;            (* shape of curve *)
    bCCData         : BYTE;            (* CC# if this is a control change type *)
    bFlags          : BYTE;            (* Curve reset and start from current value flags. *)
    (* Following exists only under DX8 and on (check dwFlags for DMUS_PMSGF_DX8) *)
    wParamType      : WORD;            (* RPN or NRPN parameter number. *)
    wMergeIndex     : WORD;            (* Allows multiple parameters to be merged (pitchbend, volume, and expression.)*)
  end;

{$IFDEF DIRECTX6}
  TDMus_Curve_PMsg = TDMus_Curve_PMsg_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_Curve_PMsg = TDMus_Curve_PMsg_DX7;
  {$ELSE}
    TDMus_Curve_PMsg = TDMus_Curve_PMsg_DX8;
  {$ENDIF}
{$ENDIF}


  TDMus_Curve_Flags = DWORD;
const
  DMUS_CURVE_RESET = 1;              (* When set, the nResetValue must be sent when the time is reached or an invalidate occurs because
                                        of a transition. If not set, the curve stays permanently stuck at the new value. *)
  DMUS_CURVE_START_FROM_CURRENT = 2; (* Ignore Start, start the curve at the current value.
                                        This only works for volume, expression, and pitchbend. *)

(* Curve shapes *)
type
  TDMus_Curve_Shapes = (
    DMUS_CURVES_LINEAR ,
    DMUS_CURVES_INSTANT,
    DMUS_CURVES_EXP    ,
    DMUS_CURVES_LOG    ,
    DMUS_CURVES_SINE   
  );

const
(* curve types *)
  DMUS_CURVET_PBCURVE      = $03;   (* Pitch bend curve. *)
  DMUS_CURVET_CCCURVE      = $04;   (* Control change curve. *)
  DMUS_CURVET_MATCURVE     = $05;   (* Mono aftertouch curve. *)
  DMUS_CURVET_PATCURVE     = $06;   (* Poly aftertouch curve. *)
  DMUS_CURVET_RPNCURVE     = $07;   (* RPN curve with curve type in wParamType. *)
  DMUS_CURVET_NRPNCURVE    = $08;   (* NRPN curve with curve type in wParamType. *)

type
(* DMUS_TIMESIG_PMsg *)
  TDMus_TimeSig_PMsg = packed record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    (* Time signatures define how many beats per measure, which note receives *)
    (* the beat, and the grid resolution. *)
    bBeatsPerMeasure : BYTE;          (* beats per measure (top of time sig) *)
    bBeat            : BYTE;          (* what note receives the beat (bottom of time sig.) *)
                                      (* we can assume that 0 means 256th note *)
    wGridsPerBeat    : WORD;          (* grids per beat *)
  end;

(* DMUS_WAVE_PMSG *)
  TDMUS_Wave_PMsg = packed record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    rtStartOffset : TReference_Time;         (* How far into the wave to start, in reference time units only. *)
    rtDuration    : TReference_Time;         (* Duration of the wave, in either reference time or music time. *)
    lOffset       : Longint;                 (* Offset from actual time to logical time, in music or ref time. *)
    lVolume       : Longint;		     (* Initial volume, in 100ths of a dB. *)
    lPitch        : Longint;		     (* Initial pitch, in 100ths of a semitone. *)
    bFlags        : BYTE;                    (* Flags, including DMUS_WAVEF_OFF... *)
  end;

const
  DMUS_WAVEF_OFF          = 1;       (* If wave is playing and this is the off message. *)
  DMUS_WAVEF_STREAMING    = 2;       (* If wave is streaming. *)
  DMUS_WAVEF_NOINVALIDATE = 4;       (* Don't invalidate this wave. *)

type
  (* DMUS_LYRIC_PMSG *)
  TDMUS_Lyric_PMsg = packed record
    (* begin DMUS_PMsg_PART *)
    dwSize           : DWORD;
    rtTime           : TReference_Time;      (* real time (in 100 nanosecond increments) *)
    mtTime           : TMusic_Time;          (* music time *)
    dwFlags          : DWORD;                (* various bits (see DMUS_PMsg_FLAGS enumeration) *)
    dwPChannel       : DWORD;                (* Performance Channel. The Performance can *)
                                             (* use this to determine the port/channel. *)
    dwVirtualTrackID : DWORD;                (* virtual track ID *)
    pTool            : IDirectMusicTool;     (* tool interface pointer *)
    pGraph           : IDirectMusicGraph;    (* tool graph interface pointer *)
    dwType           : DWORD;                (* PMSG type (see DMUS_PMsgT_TYPES defines) *)
    dwVoiceID        : DWORD;                (* unique voice id which allows synthesizers to *)
                                             (* identify a specific event. For DirectX 6.0, *)
                                             (* this field should always be 0. *)
    dwGroupID        : DWORD;                (* Track group id *)
    punkUser         : IUnknown;             (* user com pointer, auto released upon PMSG free *)
    (* end DMUS_PMsg_PART *)

    wszString        : array[0..0] of WChar; 
  end;

const
  DMUS_MAX_NAME          = 64;         (* Maximum object name length. *)
  DMUS_MAX_CATEGORY      = 64;         (* Maximum object category name length. *)
  DMUS_MAX_FILENAME      = MAX_PATH;
  
const
(* notification type values *)
(* The following correspond to GUID_NOTIFICATION_SEGMENT *)
  DMUS_NOTIFICATION_SEGSTART     = 0;
  DMUS_NOTIFICATION_SEGEND       = 1;
  DMUS_NOTIFICATION_SEGALMOSTEND = 2;
  DMUS_NOTIFICATION_SEGLOOP      = 3;
  DMUS_NOTIFICATION_SEGABORT     = 4;
(* The following correspond to GUID_NOTIFICATION_PERFORMANCE *)
  DMUS_NOTIFICATION_MUSICSTARTED = 0;
  DMUS_NOTIFICATION_MUSICSTOPPED = 1;
  DMUS_NOTIFICATION_MUSICALMOSTEND = 2;
(* The following corresponds to GUID_NOTIFICATION_MEASUREANDBEAT *)
  DMUS_NOTIFICATION_MEASUREBEAT  = 0;
(* The following corresponds to GUID_NOTIFICATION_CHORD *)
  DMUS_NOTIFICATION_CHORD        = 0;
(* The following correspond to GUID_NOTIFICATION_COMMAND *)
  DMUS_NOTIFICATION_GROOVE        = 0;
  DMUS_NOTIFICATION_EMBELLISHMENT = 1;
(* The following corresponds to GUID_NOTIFICATION_RECOMPOSE *)
  DMUS_NOTIFICATION_RECOMPOSE    = 0;

type
  PDMus_Version = ^TDMus_Version;
  TDMus_Version = packed record
    dwVersionMS : DWORD;
    dwVersionLS : DWORD;
  end;

(*      The DMUSOBJECTDESC structure is used to communicate everything you could *)
(*      possibly use to describe a DirectMusic object.  *)
  PDMus_ObjectDesc = ^TDMus_ObjectDesc;
  TDMus_ObjectDesc = packed record
    dwSize      : DWORD;                     (* Size of this structure. *)
    dwValidData : DWORD;                     (* Flags indicating which fields below are valid. *)
    guidObject  : TGUID;                     (* Unique ID for this object. *)
    guidClass   : TGUID;                     (* GUID for the class of object. *)
    ftDate      : TFileTime;                 (* Last edited date of object. *)
    vVersion    : TDMus_Version;              (* Version. *)
    wszName     : array [0..DMUS_MAX_NAME-1] of WCHAR; (* Name of object. *)
    wszCategory : array [0..DMUS_MAX_CATEGORY-1] of WCHAR; (* Category for object (optional). *)
    wszFileName : array [0..DMUS_MAX_FILENAME-1] of WCHAR; (* File path. *)
    llMemLength : LongLong;                     (* Size of Memory data. *)
    pbMemData   : Pointer;                   (* Memory pointer for data. *)
    pStream     : IStream;                   (* Stream with data. *)
  end;

(*      Flags for dwValidData. When set, a flag indicates that the  *)
(*      corresponding field in DMUSOBJECTDESC holds valid data. *)
const
  DMUS_OBJ_OBJECT         = (1 shl 0);     (* Object GUID is valid. *)
  DMUS_OBJ_CLASS          = (1 shl 1);     (* Class GUID is valid. *)
  DMUS_OBJ_NAME           = (1 shl 2);     (* Name is valid. *)
  DMUS_OBJ_CATEGORY       = (1 shl 3);     (* Category is valid. *)
  DMUS_OBJ_FILENAME       = (1 shl 4);     (* File path is valid. *)
  DMUS_OBJ_FULLPATH       = (1 shl 5);     (* Path is full path. *)
  DMUS_OBJ_URL            = (1 shl 6);     (* Path is URL. *)
  DMUS_OBJ_VERSION        = (1 shl 7);     (* Version is valid. *)
  DMUS_OBJ_DATE           = (1 shl 8);     (* Date is valid. *)
  DMUS_OBJ_LOADED         = (1 shl 9);     (* Object is currently loaded in memory. *)
  DMUS_OBJ_MEMORY         = (1 shl 10);    (* Object is pointed to by pbMemData. *)
  DMUS_OBJ_STREAM         = (1 shl 11);    (* Object is stored in pStream. *)

(*      The DMUS_SCRIPT_ERRORINFO structure describes an error that occurred in a script.
        It is returned by methods in IDirectMusicScript. *)
type
  PDMus_Script_ErrorInfo = ^TDMus_Script_ErrorInfo;
  TDMus_Script_ErrorInfo = packed record
    dwSize            : DWORD; (* Size of this structure. *)
    hr                : HResult;
    ulLineNumber      : ULONG;
    ichCharPosition   : Longint;
    wszSourceFile     : array[0..DMUS_MAX_FILENAME-1] of WCHAR;
    wszSourceComponent: array[0..DMUS_MAX_FILENAME-1] of WCHAR;
    wszDescription    : array[0..DMUS_MAX_FILENAME-1] of WCHAR;
    wszSourceLineText : array[0..DMUS_MAX_FILENAME-1] of WCHAR;
  end;

const
  DMUS_TRACKCONFIG_OVERRIDE_ALL          = 1;	   (* This track should get parameters from this segment before controlling and primary tracks. *)
  DMUS_TRACKCONFIG_OVERRIDE_PRIMARY      = 2;	   (* This track should get parameters from this segment before the primary segment tracks. *)
  DMUS_TRACKCONFIG_FALLBACK              = 4;  	   (* This track should get parameters from this segment if the primary and controlling segments don't succeed. *)
  DMUS_TRACKCONFIG_CONTROL_ENABLED       = 8;      (* GetParam() enabled for this track. *)
  DMUS_TRACKCONFIG_PLAY_ENABLED          = $10;    (* Play() enabled for this track. *)
  DMUS_TRACKCONFIG_NOTIFICATION_ENABLED  = $20;    (* Notifications enabled for this track. *)
  DMUS_TRACKCONFIG_PLAY_CLOCKTIME        = $40;    (* This track plays in clock time, not music time. *)
  DMUS_TRACKCONFIG_PLAY_COMPOSE 	 = $80;    (* This track should regenerate data each time it starts playing. *)
  DMUS_TRACKCONFIG_LOOP_COMPOSE          = $100;   (* This track should regenerate data each time it repeats. *)
  DMUS_TRACKCONFIG_COMPOSING             = $200;   (* This track is used to compose other tracks. *)
  DMUS_TRACKCONFIG_CONTROL_PLAY          = $10000; (* This track, when played in a controlling segment, overrides playback of primary segment tracks. *)
  DMUS_TRACKCONFIG_CONTROL_NOTIFICATION  = $20000; (* This track, when played in a controlling segment, overrides notification of primary segment tracks. *)
(* Additional track config flags for composing transitions *)
  DMUS_TRACKCONFIG_TRANS1_FROMSEGSTART   = $400;   (* Get track info from start of From segment *)
  DMUS_TRACKCONFIG_TRANS1_FROMSEGCURRENT = $800;   (* Get track info from current place in From segment *)
  DMUS_TRACKCONFIG_TRANS1_TOSEGSTART     = $1000;  (* Get track info from start of To segment *)
  DMUS_TRACKCONFIG_DEFAULT               = (DMUS_TRACKCONFIG_CONTROL_ENABLED or DMUS_TRACKCONFIG_PLAY_ENABLED or DMUS_TRACKCONFIG_NOTIFICATION_ENABLED);

(*  s for melody fragments *)
(* Note: Melody formulation is not supported in DX8. *)

  DMUS_MAX_FRAGMENTLABEL                 = 20;

  DMUS_FRAGMENTF_USE_REPEAT              = $1;
  DMUS_FRAGMENTF_REJECT_REPEAT           = ($1 shl 1);
  DMUS_FRAGMENTF_USE_LABEL               = ($1 shl 2);

  DMUS_CONNECTIONF_INTERVALS             = ($1 shl 1); (* Use transition intervals *)
  DMUS_CONNECTIONF_OVERLAP               = ($1 shl 2); (* Use overlapping notes for transitions *)

const
  DMUSB_LOADED    = (1 shl 0);        (* Set when band has been loaded *)
  DMUSB_DEFAULT   = (1 shl 1);        (* Set when band is default band for a style *)

type
  IDirectMusicBand           = interface;
(*IDirectMusicBand8          = interface   *)
  IDirectMusicChordMap       = interface;
(*IDirectMusicChordMap8      = interface;  *)
  IDirectMusicLoader         = interface;
  IDirectMusicLoader8        = interface;
  IDirectMusicObject         = interface;
(*IDirectMusicObject8        = interface;  *)
  IDirectMusicGetLoader      = interface;
(*IDirectMusicGetLoader8     = interface;  *)
  IDirectMusicStyle          = interface;
  IDirectMusicStyle8         = interface;
  IDirectMusicComposer       = interface;
(*IDirectMusicComposer8      = interface;  *)
  IDirectMusicPatternTrack   = interface;
(*IDirectMusicPatternTrack8  = interface;  *)
  IDirectMusicScript         = interface;
(*IDirectMusicScript8        = interface;  *)
  IDirectMusicContainer      = interface;
(*IDirectMusicContainer8     = interface;  *)
  IDirectMusicSong           = interface;
(*IDirectMusicSong8          = interface;  *)


  IDirectMusicBand = interface (IUnknown)
    ['{d2ac28c0-b39b-11d1-8704-00600893b1bd}']
    function CreateSegment (out ppSegment: IDirectMusicSegment) : HResult; stdcall;
    function Download (pPerformance: IDirectMusicPerformance) : HResult; stdcall;
    function Unload (pPerformance: IDirectMusicPerformance) : HResult; stdcall;
  end;
  IDirectMusicBand8 = IDirectMusicBand;

  IDirectMusicObject = interface (IUnknown)
    ['{d2ac28b5-b39b-11d1-8704-00600893b1bd}']
    function GetDescriptor (out pDesc: TDMus_ObjectDesc) : HResult; stdcall;
    function SetDescriptor (const pDesc: TDMus_ObjectDesc) : HResult; stdcall;
    function ParseDescriptor (var pStream; out pDesc: TDMus_ObjectDesc) : HResult; stdcall;
  end;
  IDirectMusicObject8 = IDirectMusicObject;

  IDirectMusicLoader = interface (IUnknown)
    ['{2ffaaca2-5dca-11d2-afa6-00aa0024d8b6}']
    function GetObject (const pDesc: TDMus_ObjectDesc; const riid : TGUID;
        out ppv) : HResult; stdcall;
    function SetObject (const pDesc: TDMus_ObjectDesc) : HResult; stdcall;
    function SetSearchDirectory (const rguidClass: TGUID; pwzPath: PWideChar;
        fClear:  BOOL) : HResult; stdcall;
    function ScanDirectory (const rguidClass: TGUID; pwzFileExtension,
        pwzScanFileName: PWideChar) : HResult; stdcall;
    function CacheObject (pObject: IDirectMusicObject) : HResult; stdcall;
    function ReleaseObject (pObject: IDirectMusicObject) : HResult; stdcall;
    function ClearCache (const rguidClass: TGUID) : HResult; stdcall;
    function EnableCache (const rguidClass: TGUID; fEnable: BOOL) : HResult; stdcall;
    function EnumObject (const rguidClass: TGUID; dwIndex: DWORD;
        const pDesc: TDMus_ObjectDesc) : HResult; stdcall;
  end;

  IDirectMusicLoader8 = interface (IDirectMusicLoader)
    ['{19e7c08c-0a44-4e6a-a116-595a7cd5de8c}']
    function CollectGarbage: HResult; stdcall;
    function ReleaseObjectByUnknown(pObject: IUnknown): HResult; stdcall;
    function LoadObjectFromFile(const rguidClassID: TGUID; const iidInterfaceID: TGUID;
        pwzFilePath: PWideChar; out ppObject): HResult; stdcall;
  end;

(*  Stream object supports IDirectMusicGetLoader interface to access loader while file parsing. *)

  IDirectMusicGetLoader = interface (IUnknown)
    ['{68a04844-d13d-11d1-afa6-00aa0024d8b6}']
    function GetLoader (out ppLoader: IDirectMusicLoader) : HResult; stdcall;
  end;
  IDirectMusicGetLoader8 = IDirectMusicGetLoader;

(*/////////////////////////////////////////////////////////////////////
// IDirectMusicStyle *)
  IDirectMusicStyle = interface (IUnknown)
    ['{d2ac28bd-b39b-11d1-8704-00600893b1bd}']
    function GetBand (pwszName: PWideChar; out ppBand: IDirectMusicBand) : HResult; stdcall;
    function EnumBand (dwIndex: DWORD; pwszName: PWideChar) : HResult; stdcall;
    function GetDefaultBand (out ppBand: IDirectMusicBand) : HResult; stdcall;
    function EnumMotif (dwIndex: DWORD; pwszName: PWideChar) : HResult; stdcall;
    function GetMotif (pwszName: PWideChar; out ppSegment: IDirectMusicSegment) : HResult; stdcall;
    function GetDefaultChordMap (out ppChordMap: IDirectMusicChordMap) : HResult; stdcall;
    function EnumChordMap (dwIndex: DWORD; pwszName: PWideChar) : HResult; stdcall;
    function GetChordMap (pwszName: PWideChar; out ppChordMap: IDirectMusicChordMap) : HResult; stdcall;
    function GetTimeSignature (out pTimeSig: TDMus_TimeSignature) : HResult; stdcall;
    function GetEmbellishmentLength (dwType, dwLevel: DWORD; out pdwMin, pdwMax: DWORD) : HResult; stdcall;
    function GetTempo (out pTempo: double) : HResult; stdcall;
  end;

  IDirectMusicStyle8 = interface (IDirectMusicStyle)
    ['{fd24ad8a-a260-453d-bf50-6f9384f70985}']
    function EnumPattern (dwIndex, dwPatternType: DWORD; pwszName: PWChar) : HResult; stdcall;
  end;

(*/////////////////////////////////////////////////////////////////////
// IDirectMusicChordMap *)
  IDirectMusicChordMap = interface (IUnknown)
    ['{d2ac28be-b39b-11d1-8704-00600893b1bd}']
    function GetScale (out pdwScale: DWORD) : HResult; stdcall;
  end;
  IDirectMusicChordMap8 = IDirectMusicChordMap;

(*/////////////////////////////////////////////////////////////////////
// IDirectMusicComposer *)
  IDirectMusicComposer = interface (IUnknown)
    ['{d2ac28bf-b39b-11d1-8704-00600893b1bd}']
    function ComposeSegmentFromTemplate (pStyle: IDirectMusicStyle;
        pTempSeg: IDirectMusicSegment; wActivity: WORD;
        pChordMap: IDirectMusicChordMap; out ppSectionSeg: IDirectMusicSegment) : HResult; stdcall;
    function ComposeSegmentFromShape (pStyle: IDirectMusicStyle; wNumMeasures,
        wShape, wActivity: WORD; fIntro: BOOL; fEnd: BOOL;
        pChordMap: IDirectMusicChordMap; out ppSectionSeg: IDirectMusicSegment) : HResult; stdcall;
    function ComposeTransition (pFromSeg: IDirectMusicSegment; pToSeg: IDirectMusicSegment;
        mtTime: TMusic_Time; wCommand: WORD; dwFlags: DWORD; pChordMap:IDirectMusicChordMap;
        out ppSectionSeg: IDirectMusicSegment) : HResult; stdcall;
    function AutoTransition (pPerformance: IDirectMusicPerformance;
        pToSeg: IDirectMusicSegment; wCommand: WORD; dwFlags: DWORD;
        pChordMap: IDirectMusicChordMap; out ppTransSeg: IDirectMusicSegment;
        out ppToSegState: IDirectMusicSegmentState; out ppTransSegState: IDirectMusicSegmentState) : HResult; stdcall;
    function ComposeTemplateFromShape (wNumMeasures: WORD; wShape: WORD; fIntro: BOOL;
        fEnd: BOOL; wEndLength: WORD; out ppTempSeg:IDirectMusicSegment) : HResult; stdcall;
    function ChangeChordMap (pSectionSeg: IDirectMusicSegment;
        fTrackScale: BOOL; pChordMap: IDirectMusicChordMap) : HResult; stdcall;
  end;
  IDirectMusicComposer8 = IDirectMusicComposer;

  IDirectMusicPatternTrack = interface (IUnknown)
    ['{51c22e10-b49f-46fc-bec2-e6288fb9ede6}']
    function CreateSegment (pStyle: IDirectMusicStyle;
        out ppSegment: IDirectMusicSegment) : HResult; stdcall;
    function SetVariation (pSegState: IDirectMusicSegmentState;
        dwVariationFlags, dwPart: DWORD) : HResult; stdcall;
    function SetPatternByName (pSegState: IDirectMusicSegmentState;
        wszName: PWChar; pStyle: IDirectMusicStyle; dwPatternType: DWORD;
        var pdwLength: DWORD) : HResult; stdcall;
  end;
  IDirectMusicPatternTrack8 = IDirectMusicPatternTrack;

  IDirectMusicScript = interface (IUnknown)
    ['{2252373A-5814-489b-8209-31FEDEBAF137}']
    function Init (pPerformance: IDirectMusicPerformance;
        pErrorInfo: PDMus_Script_ErrorInfo) : HResult; stdcall;
    function CallRoutine (pwszRoutineName: PWChar;
        pErrorInfo: PDMus_Script_ErrorInfo) : HResult; stdcall;
    function SetVariableVariant (pwszVariableName: PWChar; varValue: Variant;
        fSetRef: BOOL; pErrorInfo: PDMus_Script_ErrorInfo) : HResult; stdcall;
    function GetVariableVariant (pwszVariableName: PWChar; var pvarValue: Variant;
        pErrorInfo: PDMus_Script_ErrorInfo) : HResult; stdcall;
    function SetVariableNumber (pwszVariableName: PWChar; lValue: Longint;
        pErrorInfo: PDMus_Script_ErrorInfo) : HResult; stdcall;
    function GetVariableNumber (pwszVariableName: PWChar; var plValue: Longint;
        pErrorInfo: PDMus_Script_ErrorInfo) : HResult; stdcall;
    function SetVariableObject (pwszVariableName: PWChar; punkValue: IUnknown;
        pErrorInfo: PDMus_Script_ErrorInfo) : HResult; stdcall;
    function GetVariableObject (pwszVariableName: PWChar; const riid: TGUID;
        out ppv; pErrorInfo: PDMus_Script_ErrorInfo) : HResult; stdcall;
    function EnumRoutine (dwIndex: DWORD; pwszName: PWChar) : HResult; stdcall;
    function EnumVariable (dwIndex: DWORD; pwszName: PWChar) : HResult; stdcall;
  end;
  IDirectMusicScript8 = IDirectMusicScript;

  IDirectMusicContainer = interface (IUnknown)
    ['{9301e386-1f22-11d3-8226-d2fa76255d47}']
    function EnumObject(const rguidClass: TGUID; dwIndex: DWORD;
        pDesc: PDMus_ObjectDesc; pwszAlias: PWChar): HResult; stdcall;
  end;
  IDirectMusicContainer8 = IDirectMusicContainer;

  IDirectMusicSong = interface (IUnknown)
    ['{a862b2ec-3676-4982-850a-7842775e1d86}']
    function Compose : HResult; stdcall;
    function GetParam (const rguidType: TGUID; dwGroupBits, dwIndex: DWORD;
        mtTime: TMusic_Time; pmtNext: PMusic_Time; pParam: Pointer): HResult; stdcall;
    function GetSegment (pwzName: PWChar; out ppSegment: IDirectMusicSegment): HResult; stdcall;
    function GetAudioPathConfig (out ppAudioPathConfig: IUnknown): HResult; stdcall;
    function Download (pAudioPath: IUnknown): HResult; stdcall;
    function Unload (pAudioPath: IUnknown): HResult; stdcall;
    function EnumSegment (dwIndex: DWORD; out ppSegment: IDirectMusicSegment): HResult; stdcall;
  end;
  IDirectMusicSong8 = IDirectMusicSong;

const  
(* CLSID's *)
  CLSID_DirectMusicPerformance    : TGUID = '{d2ac2881-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicSegment        : TGUID = '{d2ac2882-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicSegmentState   : TGUID = '{d2ac2883-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicGraph          : TGUID = '{d2ac2884-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicTempoTrack     : TGUID = '{d2ac2885-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicSeqTrack       : TGUID = '{d2ac2886-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicSysExTrack     : TGUID = '{d2ac2887-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicTimeSigTrack   : TGUID = '{d2ac2888-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicStyle          : TGUID = '{d2ac288a-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicChordTrack     : TGUID = '{d2ac288b-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicCommandTrack   : TGUID = '{d2ac288c-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicStyleTrack     : TGUID = '{d2ac288d-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicMotifTrack     : TGUID = '{d2ac288e-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicChordMap       : TGUID = '{d2ac288f-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicComposer       : TGUID = '{d2ac2890-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicSignPostTrack  : TGUID = '{f17e8672-c3b4-11d1-870b-00600893b1bd}';
  CLSID_DirectMusicLoader         : TGUID = '{d2ac2892-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicBandTrack      : TGUID = '{d2ac2894-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicBand           : TGUID = '{79ba9e00-b6ee-11d1-86be-00c04fbf8fef}';
  CLSID_DirectMusicChordMapTrack  : TGUID = '{d2ac2896-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicMuteTrack      : TGUID = '{d2ac2898-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicPatternTrack   : TGUID = '{d2ac2897-b39b-11d1-8704-00600893b1bd}';
  CLSID_DirectMusicScript         : TGUID = '{810B5013-E88D-11d2-8BC1-00600893B1B6}';
  CLSID_DirectMusicContainer      : TGUID = '{9301e380-1f22-11d3-8226-d2fa76255d47}';
  CLSID_DirectSoundWave           : TGUID = '{8a667154-f9cb-11d2-ad8a-0060b0575abc}';
  CLSID_DirectMusicSong           : TGUID = '{aed5f0a5-d972-483d-a384-649dfeb9c181}';
  CLSID_DirectMusicAudioPathConfig: TGUID = '{ee0b9ca0-a81e-11d3-9bd1-0080c7150a74}';

(* New CLSID's for DX8 *)
  CLSID_DirectMusicScriptTrack            : TGUID = '{4108FA85-3586-11d3-8BD7-00600893B1B6}';
  CLSID_DirectMusicMarkerTrack            : TGUID = '{55a8fd00-4288-11d3-9bd1-8a0d61c88835}';
  CLSID_DirectMusicSegmentTriggerTrack    : TGUID = '{BAE4D665-4EA1-11d3-8BDA-00600893B1B6}';
  CLSID_DirectMusicLyricsTrack            : TGUID = '{995C1CF5-54FF-11d3-8BDA-00600893B1B6}';
  CLSID_DirectMusicParamControlTrack      : TGUID = '{4BE0537B-5C19-11d3-8BDC-00600893B1B6}';
  CLSID_DirectMusicMelodyFormulationTrack : TGUID = '{b0684266-b57f-11d2-97f9-00c04fa36e58}';
  CLSID_DirectMusicWaveTrack              : TGUID = '{eed36461-9ea5-11d3-9bd1-0080c7150a74}';

(* Special GUID for all object types. This is used by the loader. *)
  GUID_DirectMusicAllTypes        : TGUID = '{d2ac2893-b39b-11d1-8704-00600893b1bd}';

(* Notification guids *)
  GUID_NOTIFICATION_SEGMENT       : TGUID = '{d2ac2899-b39b-11d1-8704-00600893b1bd}';
  GUID_NOTIFICATION_PERFORMANCE   : TGUID = '{81f75bc5-4e5d-11d2-bcc7-00a0c922e6eb}';
  GUID_NOTIFICATION_MEASUREANDBEAT: TGUID = '{d2ac289a-b39b-11d1-8704-00600893b1bd}';
  GUID_NOTIFICATION_CHORD         : TGUID = '{d2ac289b-b39b-11d1-8704-00600893b1bd}';
  GUID_NOTIFICATION_COMMAND       : TGUID = '{d2ac289c-b39b-11d1-8704-00600893b1bd}';
  GUID_NOTIFICATION_RECOMPOSE     : TGUID = '{d348372b-945b-45ae-a522-450f125b84a5}';

(* Track param type guids *)
(* Use to get/set a DMUS_COMMAND_PARAM param in the Command track *)
  GUID_CommandParam               : TGUID = '{d2ac289d-b39b-11d1-8704-00600893b1bd}';

(* Use to get a DMUS_COMMAND_PARAM_2 param in the Command track *)
  GUID_CommandParam2              : TGUID = '{28f97ef7-9538-11d2-97a9-00c04fa36e58}';

(* Use to get/set a DMUS_COMMAND_PARAM_2 param to be used as the command following all commands in
the Command track (this information can't be saved) *)
  GUID_CommandParamNext           : TGUID = '{472afe7a-281b-11d3-817d-00c04fa36e58}';

(* Use to get/set a DMUS_CHORD_PARAM param in the Chord track *)
  GUID_ChordParam                 : TGUID = '{d2ac289e-b39b-11d1-8704-00600893b1bd}';

(* Use to get a DMUS_RHYTHM_PARAM param in the Chord track *)
  GUID_RhythmParam                : TGUID = '{d2ac289f-b39b-11d1-8704-00600893b1bd}';

(* Use to get/set an IDirectMusicStyle param in the Style track *)
  GUID_IDirectMusicStyle          : TGUID = '{d2ac28a1-b39b-11d1-8704-00600893b1bd}';

(* Use to get a DMUS_TIMESIGNATURE param in the Style and TimeSig tracks *)
  GUID_TimeSignature              : TGUID = '{d2ac28a4-b39b-11d1-8704-00600893b1bd}';

(* Use to get/set a DMUS_TEMPO_PARAM param in the Tempo track *)
  GUID_TempoParam                 : TGUID = '{d2ac28a5-b39b-11d1-8704-00600893b1bd}';

(* Use to get the next valid point in a segment at which it may start *)
  GUID_Valid_Start_Time           : TGUID = '{7f6b1760-1fdb-11d3-8226-444553540000}';

(* Use to get the next point in the currently playing primary segment at which a new segment may start *)
  GUID_Play_Marker                : TGUID = '{d8761a41-801a-11d3-9bd1-daf7e1c3d834}';

(* Use to get (GetParam) or add (SetParam) bands in the Band track *)
  GUID_BandParam                  : TGUID = '{02bb1938-cb8b-11d2-8bb9-00600893b1b6}';

type
  TDMUS_BAND_PARAM = packed record
    mtTimePhysical : TMusic_Time;
    pBand          : IDirectMusicBand;
  end;

const
(* Use to set an IDirectMusicBand param in the Band track *)
  GUID_IDirectMusicBand           : TGUID = '{d2ac28ac-b39b-11d1-8704-00600893b1bd}';

(* Use to get/set an IDirectMusicChordMap param in the ChordMap track *)
  GUID_IDirectMusicChordMap       : TGUID = '{d2ac28ad-b39b-11d1-8704-00600893b1bd}';

(* Use to get/set a DMUS_MUTE_PARAM param in the Mute track *)
  GUID_MuteParam                  : TGUID = '{d2ac28af-b39b-11d1-8704-00600893b1bd}';

(* These guids are used in IDirectMusicSegment::SetParam to tell the band track to perform various actions.
 *)
(* Download bands for the IDirectMusicSegment *)
  GUID_Download                   : TGUID = '{d2ac28a7-b39b-11d1-8704-00600893b1bd}';

(* Unload bands for the IDirectMusicSegment *)
  GUID_Unload                     : TGUID = '{d2ac28a8-b39b-11d1-8704-00600893b1bd}';

(* Connect segment's bands to an IDirectMusicCollection *)
  GUID_ConnectToDLSCollection     : TGUID = '{1db1ae6b-e92e-11d1-a8c5-00c04fa3726e}';

(* Enable/disable autodownloading of bands *)
  GUID_Enable_Auto_Download       : TGUID = '{d2ac28a9-b39b-11d1-8704-00600893b1bd}';
  GUID_Disable_Auto_Download      : TGUID = '{d2ac28aa-b39b-11d1-8704-00600893b1bd}';

(* Clear all bands *)
  GUID_Clear_All_Bands            : TGUID = '{d2ac28ab-b39b-11d1-8704-00600893b1bd}';

(* Set segment to manage all program changes, bank selects, etc. for simple playback of a standard MIDI file *)
  _GUID_StandardMIDIFile                  = '{06621075-e92e-11d1-a8c5-00c04fa3726e}';
  GUID_StandardMIDIFile           : TGUID = _GUID_StandardMIDIFile;
(* For compatibility with beta releases... *)
  GUID_IgnoreBankSelectForGM      : TGUID = _GUID_StandardMIDIFile;

(* Disable/enable param guids. Use these in SetParam calls to disable or enable sending
 * specific PMsg types.
 *)
  GUID_DisableTimeSig             : TGUID = '{45fc707b-1db4-11d2-bcac-00a0c922e6eb}';
  GUID_EnableTimeSig              : TGUID = '{45fc707c-1db4-11d2-bcac-00a0c922e6eb}';
  GUID_DisableTempo               : TGUID = '{45fc707d-1db4-11d2-bcac-00a0c922e6eb}';
  GUID_EnableTempo                : TGUID = '{45fc707e-1db4-11d2-bcac-00a0c922e6eb}';

(* Used in SetParam calls for pattern-based tracks.  A nonzero value seeds the random number
generator for variation selection; a value of zero reverts to the default behavior of
getting the seed from the system clock.
*)
  GUID_SeedVariations             : TGUID = '{65b76fa5-ff37-11d2-814e-00c04fa36e58}';

(* Used to get/set melody fragments (pParam points to a DMUS_MELODY_FRAGMENT) *)
(* Note: Melody formulation is not supported in DX8. *)
  GUID_MelodyFragment             : TGUID = '{b291c7f2-b616-11d2-97fa-00c04fa36e58}';

(* Used to clear all melody fragments *)
(* Note: Melody formulation is not supported in DX8. *)
  GUID_Clear_All_MelodyFragments  : TGUID = '{8509fee6-b617-11d2-97fa-00c04fa36e58}';

(* Used to get the variations currently in effect across PChannels *)
  GUID_Variations                 : TGUID = '{11f72cce-26e6-4ecd-af2e-d668e66707d8}';

type
  TDMUS_VARIATIONS_PARAM = packed record
    dwPChannelsUsed : DWORD;   (* number of PChannels in use *)
    padwPChannels   : PDWORD;  (* array of PChannels in use *)
    padwVariations  : PDWORD;  (* array of variations in effect for each PChannel *)
  end;

const
(* Download bands/waves for the IDirectMusicSegment, passed an IDirectMusicAudioPath instead of an IDirectMusicPerformance *)
  GUID_DownloadToAudioPath        : TGUID = '{9f2c0341-c5c4-11d3-9bd1-444553540000}';

(* Unload bands/waves for the IDirectMusicSegment, passed an IDirectMusicAudioPath instead of an IDirectMusicPerformance *)
  GUID_UnloadFromAudioPath        : TGUID = '{9f2c0342-c5c4-11d3-9bd1-444553540000}';

(* Global data guids *)
  GUID_PerfMasterTempo            : TGUID = '{d2ac28b0-b39b-11d1-8704-00600893b1bd}';
  GUID_PerfMasterVolume           : TGUID = '{d2ac28b1-b39b-11d1-8704-00600893b1bd}';
  GUID_PerfMasterGrooveLevel      : TGUID = '{d2ac28b2-b39b-11d1-8704-00600893b1bd}';
  GUID_PerfAutoDownload           : TGUID = '{fb09565b-3631-11d2-bcb8-00a0c922e6eb}';

(* GUID for default GM/GS dls collection. *)
  GUID_DefaultGMCollection        : TGUID = '{f17e8673-c3b4-11d1-870b-00600893b1bd}';

(* GUID to define default synth, placed in AudioPath configuration file. *)
  GUID_Synth_Default              : TGUID = '{26bb9432-45fe-48d3-a375-2472c5e3e786}';

(* GUIDs to define default buffer configurations to place in AudioPath configuration file. *)
  GUID_Buffer_Reverb              : TGUID = '{186cc541-db29-11d3-9bd1-0080c7150a74}';
  GUID_Buffer_EnvReverb           : TGUID = '{186cc542-db29-11d3-9bd1-0080c7150a74}';
  GUID_Buffer_Stereo              : TGUID = '{186cc545-db29-11d3-9bd1-0080c7150a74}';
  GUID_Buffer_3D_Dry              : TGUID = '{186cc546-db29-11d3-9bd1-0080c7150a74}';
  GUID_Buffer_Mono                : TGUID = '{186cc547-db29-11d3-9bd1-0080c7150a74}';

type
(* IID's *)
  IID_IDirectMusicLoader        = IDirectMusicLoader;
  IID_IDirectMusicLoader8       = IDirectMusicLoader8;
  IID_IDirectMusicGetLoader     = IDirectMusicGetLoader;
  IID_IDirectMusicGetLoader8    = IDirectMusicGetLoader8;
  IID_IDirectMusicObject        = IDirectMusicObject;
  IID_IDirectMusicObject8       = IDirectMusicObject8;
  IID_IDirectMusicSegment       = IDirectMusicSegment;
  IID_IDirectMusicSegment8      = IDirectMusicSegment8;
  IID_IDirectMusicSegmentState  = IDirectMusicSegmentState;
  IID_IDirectMusicSegmentState8 = IDirectMusicSegmentState8;
  IID_IDirectMusicTrack         = IDirectMusicTrack;
  IID_IDirectMusicTrack8        = IDirectMusicTrack8;
  IID_IDirectMusicPerformance   = IDirectMusicPerformance;
  IID_IDirectMusicPerformance8  = IDirectMusicPerformance8;
  IID_IDirectMusicTool          = IDirectMusicTool;
  IID_IDirectMusicTool8         = IDirectMusicTool8;
  IID_IDirectMusicGraph         = IDirectMusicGraph;
  IID_IDirectMusicGraph8        = IDirectMusicGraph8;
  IID_IDirectMusicStyle         = IDirectMusicStyle;
  IID_IDirectMusicStyle8        = IDirectMusicStyle8;
  IID_IDirectMusicChordMap      = IDirectMusicChordMap;
  IID_IDirectMusicChordMap8     = IDirectMusicChordMap8;
  IID_IDirectMusicComposer      = IDirectMusicComposer;
  IID_IDirectMusicComposer8     = IDirectMusicComposer8;
  IID_IDirectMusicBand          = IDirectMusicBand;
  IID_IDirectMusicBand8         = IDirectMusicBand8;
  IID_IDirectMusicAudioPath     = IDirectMusicAudioPath;
  IID_IDirectMusicAudioPath8    = IDirectMusicAudioPath8;
  IID_IDirectMusicScript        = IDirectMusicScript;
  IID_IDirectMusicScript8       = IDirectMusicScript8;
  IID_IDirectMusicPatternTrack  = IDirectMusicPatternTrack;
  IID_IDirectMusicPatternTrack8 = IDirectMusicPatternTrack8;
  IID_IDirectMusicContainer     = IDirectMusicContainer;
  IID_IDirectMusicContainer8    = IDirectMusicContainer8;
  IID_IDirectMusicSong          = IDirectMusicSong;
  IID_IDirectMusicSong8         = IDirectMusicSong8;

const
(* Alternate interface IDs, available in DX7 release and after. *)
  IID_IDirectMusicPerformance2 : TGUID = '{6fc2cae0-bc78-11d2-afa6-00aa0024d8b6}';
  IID_IDirectMusicSegment2     : TGUID = '{d38894d1-c052-11d2-872f-00600893b1bd}';

(************************************************************************
*                                                                       *
*   dmusics.h -- Definitions for created a DirectMusic software synth   *
*                                                                       *
*   Copyright (c) 1998-1999 Microsoft Corporation                       *
*                                                                       *
************************************************************************)

const
  REGSTR_PATH_SOFTWARESYNTHS  = 'Software\Microsoft\DirectMusic\SoftwareSynths';

(* IDirectMusicSynth::Refresh
 *
 * This is the last buffer of the stream. It may be a partial block.
 *)
  REFRESH_F_LASTBUFFER        = $00000001;

type
  IDirectMusicSynth     = interface;
  IDirectMusicSynth8    = interface;
  IDirectMusicSynthSink = interface;

  PDMus_Voice_State = ^TDMus_Voice_State;
  TDMus_Voice_State = packed record
    bExists    : BOOL;
    spPosition : TSample_Position;
  end;

  TFreeHandle = function (hHandle1, hHandle2: THandle) : HResult; stdcall; // ?????????????????????????

  IDirectMusicSynth = interface (IUnknown)
    ['{09823661-5c85-11d2-afa6-00aa0024d8b6}']
    function Open (pPortParams: PDMus_PortParams): HResult; stdcall;
    function Close : HResult; stdcall;
    function SetNumChannelGroups (dwGroups: DWORD): HResult; stdcall;
    function Download (phDownload: PHandle; pvData: Pointer; pbFree: PBOOL): HResult; stdcall;
    function Unload (hDownload: THandle; lpFreeHandle: TFreeHandle;  // HRESULT ( CALLBACK *lpFreeHandle)(HANDLE,HANDLE)
        hUserData: THandle): HResult; stdcall;
    function PlayBuffer (rt: TReference_Time; pbBuffer: PByte; cbBuffer: DWORD): HResult; stdcall;
    function GetRunningStats (var pStats: TDMus_SynthStats): HResult; stdcall;
    function GetPortCaps (var pCaps: TDMus_PortCaps): HResult; stdcall;
    function SetMasterClock (pClock: IReferenceClock): HResult; stdcall;
    function GetLatencyClock (out ppClock: IReferenceClock): HResult; stdcall;
    function Activate (fEnable: BOOL): HResult; stdcall;
    function SetSynthSink (pSynthSink: IDirectMusicSynthSink): HResult; stdcall;
    function Render (pBuffer: PSmallint; dwLength: DWORD; llPosition: LongLong): HResult; stdcall;
    function SetChannelPriority (dwChannelGroup, dwChannel, dwPriority: DWORD): HResult; stdcall;
    function GetChannelPriority (dwChannelGroup, dwChannel: DWORD; var pdwPriority: DWORD): HResult; stdcall;
    function GetFormat (pWaveFormatEx: PWaveFormatEx; var pdwWaveFormatExSize: DWORD): HResult; stdcall;
    function GetAppend (var pdwAppend: DWORD): HResult; stdcall;
  end;

  IDirectMusicSynth8 = interface (IDirectMusicSynth)
    ['{53cab625-2711-4c9f-9de7-1b7f925f6fc8}']
    function PlayVoice (rt: TReference_Time; dwVoiceId, dwChannelGroup: DWORD;
        dwChannel, dwDLId: DWORD; prPitch, vrVolume: Longint;
        stVoiceStart, stLoopStart, stLoopEnd: TSample_Time): HResult; stdcall;
    function StopVoice (rt: TReference_Time; dwVoiceId: DWORD): HResult; stdcall;
    function GetVoiceState( dwVoice: PWORD; cbVoice: DWORD; dwVoiceState: PDMus_Voice_State): HResult; stdcall;    // ????
    function Refresh (dwDownloadID, dwFlags: DWORD): HResult; stdcall;
    function AssignChannelToBuses (dwChannelGroup, dwChannel: DWORD;
        pdwBuses: PDWORD; cBuses: DWORD): HResult; stdcall;
  end;

  IDirectMusicSynthSink = interface (IUnknown)
    ['{09823663-5c85-11d2-afa6-00aa0024d8b6}']
    function Init (pSynth: IDirectMusicSynthSink): HResult; stdcall;
    function SetMasterClock (pClock: IReferenceClock): HResult; stdcall;
    function GetLatencyClock (out ppClock: IReferenceClock): HResult; stdcall;
    function Activate (fEnable: BOOL): HResult; stdcall;
    function SampleToRefTime (llSampleTime: LongLong; var prfTime: TReference_Time): HResult; stdcall;
    function RefTimeToSample (rfTime: TReference_Time; var pllSampleTime: LongLong): HResult; stdcall;
    function SetDirectSound (pDirectSound: IDirectSound; pDirectSoundBuffer: IDirectSoundBuffer): HResult; stdcall;
    function GetDesiredBufferSize (var pdwBufferSizeInSamples: DWORD): HResult; stdcall;
  end;

  IID_IDirectMusicSynth     = IDirectMusicSynth;
  IID_IDirectMusicSynth8    = IDirectMusicSynth8;
  IID_IDirectMusicSynthSink = IDirectMusicSynthSink;

const
(* Property Set GUID_DMUS_PROP_SetSynthSink
 *
 * Item 0: An IUnknown on which the port can QueryInterface for a user-mode synth sink.
 *)
  GUID_DMUS_PROP_SetSynthSink   : TGUID = '{0a3a5ba5-37b6-11d2-b9f9-0000f875ac12}';

(* Property Set GUID_DMUS_PROP_SinkUsesDSound
 *
 * Item 0: A DWORD boolean indicating whether or not the sink requires an IDirectSound interface. The
 * default is FALSE if this property item is not implemented by the sink.
 *)
  GUID_DMUS_PROP_SinkUsesDSound : TGUID = '{be208857-8952-11d2-ba1c-0000f875ac12}';

(************************************************************************
*                                                                       *
*   dmusicf.h -- This module defines the DirectMusic file formats       *
*                                                                       *
*   Copyright (c) 1998, Microsoft Corp. All rights reserved.            *
*                                                                       *
************************************************************************)

//type IDirectMusicCollection = interface;

const
(* Common chunks *)

  DMUS_FOURCC_GUID_CHUNK        : mmioFOURCC = ('g','u','i','d');
  DMUS_FOURCC_INFO_LIST         : mmioFOURCC = ('I','N','F','O');
  DMUS_FOURCC_UNFO_LIST         : mmioFOURCC = ('U','N','F','O');
  DMUS_FOURCC_UNAM_CHUNK        : mmioFOURCC = ('U','N','A','M');
  DMUS_FOURCC_UART_CHUNK        : mmioFOURCC = ('U','A','R','T');
  DMUS_FOURCC_UCOP_CHUNK        : mmioFOURCC = ('U','C','O','P');
  DMUS_FOURCC_USBJ_CHUNK        : mmioFOURCC = ('U','S','B','J');
  DMUS_FOURCC_UCMT_CHUNK        : mmioFOURCC = ('U','C','M','T');
  DMUS_FOURCC_CATEGORY_CHUNK    : mmioFOURCC = ('c','a','t','g');
  DMUS_FOURCC_VERSION_CHUNK     : mmioFOURCC = ('v','e','r','s');

(* The following structures are used by the Tracks, and are the packed structures *)
(* that are passed to the Tracks inside the IStream. *)

type
  TDMus_IO_Seq_Item = packed record
    mtTime     : TMusic_Time;
    mtDuration : TMusic_Time;
    dwPChannel : DWORD;
    nOffset    : SmallInt;
    bStatus    : BYTE;
    bByte1     : BYTE;
    bByte2     : BYTE;
  end;

  TDMus_IO_Curve_Item_DX6 = packed record
    mtStart         : TMusic_Time;
    mtDuration      : TMusic_Time;
    mtResetDuration : TMusic_Time;
    dwPChannel      : DWORD;
    nOffset         : SmallInt;
    nStartValue     : SmallInt;
    nEndValue       : SmallInt;
    nResetValue     : SmallInt;
    bType           : BYTE;
    bCurveShape     : BYTE;
    bCCData         : BYTE;
    bFlags          : BYTE;
  end;
  TDMus_IO_Curve_Item_DX7 = TDMus_IO_Curve_Item_DX6;

  TDMus_IO_Curve_Item_DX8 = packed record
    mtStart         : TMusic_Time;
    mtDuration      : TMusic_Time;
    mtResetDuration : TMusic_Time;
    dwPChannel      : DWORD;
    nOffset         : SmallInt;
    nStartValue     : SmallInt;
    nEndValue       : SmallInt;
    nResetValue     : SmallInt;
    bType           : BYTE;
    bCurveShape     : BYTE;
    bCCData         : BYTE;
    bFlags          : BYTE;
    wParamType      : WORD;   (* RPN or NRPN parameter number. *)
    wMergeIndex     : WORD;   (* Allows multiple parameters to be merged (pitchbend, volume, and expression.) *)
  end;

{$IFDEF DIRECTX6}
  TDMus_IO_Curve_Item = TDMus_IO_Curve_Item_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_IO_Curve_Item = TDMus_IO_Curve_Item_DX7;
  {$ELSE}
    TDMus_IO_Curve_Item = TDMus_IO_Curve_Item_DX8;
  {$ENDIF}
{$ENDIF}

  TDMus_IO_Tempo_Item = packed record
    lTime    : TMusic_Time;
    dblTempo : double;
  end;

  TDMus_IO_SysEx_Item = packed record
    mtTime        : TMusic_Time;
    dwPChannel    : DWORD;
    dwSysExLength : DWORD;
  end;

(* PARAM structures, used by GetParam() and SetParam() *)
  TDMus_Command_Param_DX6 = packed record
    bCommand     : BYTE;
    bGrooveLevel : BYTE;
    bGrooveRange : BYTE;
  end;
  TDMus_Command_Param_DX7 = TDMus_Command_Param_DX6;

  TDMus_Command_Param_DX8 = packed record
    bCommand     : BYTE;
    bGrooveLevel : BYTE;
    bGrooveRange : BYTE;
    bRepeatMode  : BYTE;
  end;

{$IFDEF DIRECTX6}
  TDMus_Command_Param = TDMus_Command_Param_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_Command_Param = TDMus_Command_Param_DX7;
  {$ELSE}
    TDMus_Command_Param = TDMus_Command_Param_DX8;
  {$ENDIF}
{$ENDIF}

  TDMus_Command_Param_2_DX6 = packed record
    mtTime       : TMusic_Time;
    bCommand     : BYTE;
    bGrooveLevel : BYTE;
    bGrooveRange : BYTE;
  end;
  TDMus_Command_Param_2_DX7 = TDMus_Command_Param_2_DX6;

  TDMus_Command_Param_2_DX8 = packed record
    mtTime       : TMusic_Time;
    bCommand     : BYTE;
    bGrooveLevel : BYTE;
    bGrooveRange : BYTE;
    bRepeatMode  : BYTE;
  end;

{$IFDEF DIRECTX6}
  TDMus_Command_Param_2 = TDMus_Command_Param_2_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_Command_Param_2 = TDMus_Command_Param_2_DX7;
  {$ELSE}
    TDMus_Command_Param_2 = TDMus_Command_Param_2_DX8;
  {$ENDIF}
{$ENDIF}

(* Get/SetParam structs for melody fragments *)
(* Note: Melody formulation is not supported in DX8. *)
  TDMUS_Connection_Rule = packed record
    dwFlags     : DWORD;  (* DMUS_CONNECTIONF_ flags *)
    dwIntervals : DWORD;  (* Legal transition intervals (first 24 bits; two-octave range) *)
  end;

  TDMUS_Melody_Fragment = packed record
    mtTime            : TMusic_Time;
    dwID              : DWORD;                                         (* This fragment's ID *)
    wszVariationLabel : array[0..DMUS_MAX_FRAGMENTLABEL-1] of WCHAR;   (* Each style translates this into a set of variations (held in part ref) *)
    dwVariationFlags  : DWORD;                                         (* A set of variations *)
    dwRepeatFragmentID: DWORD;                                         (* ID of a fragment to repeat *)
    dwFragmentFlags   : DWORD;                                         (* DMUS_FRAGMENTF_ flags *)
    dwPlayModeFlags   : DWORD;                                         (* NOT CURRENTLY USED - MUST BE 0 *)
    dwTransposeIntervals: DWORD;                                       (* Legal transposition intervals (first 24 bits; two-octave range) *)
    Command           : TDMUS_COMMAND_PARAM;
    ConnectionArc     : TDMUS_CONNECTION_RULE;
  end;

  TDMus_Chord_Param = TDMus_Chord_Key; (* DMUS_CHORD_KEY defined in dmusici.h *)

  TDMus_Rhythm_Param = packed record
    TimeSig         : TDMus_TimeSignature;
    dwRhythmPattern : DWORD;
  end;

  TDMus_Tempo_Param = packed record
    mtTime   : TMusic_Time;
    dblTempo : double;
  end;

  TDMus_Mute_Param = packed record
    dwPChannel    : DWORD;
    dwPChannelMap : DWORD;
    fMute         : BOOL;
  end;

const
(* Style chunks *)

  DMUS_FOURCC_STYLE_FORM          : mmioFOURCC = ('D','M','S','T');
  DMUS_FOURCC_STYLE_CHUNK         : mmioFOURCC = ('s','t','y','h');
  DMUS_FOURCC_PART_LIST           : mmioFOURCC = ('p','a','r','t');
  DMUS_FOURCC_PART_CHUNK          : mmioFOURCC = ('p','r','t','h');
  DMUS_FOURCC_NOTE_CHUNK          : mmioFOURCC = ('n','o','t','e');
  DMUS_FOURCC_CURVE_CHUNK         : mmioFOURCC = ('c','r','v','e');
  DMUS_FOURCC_MARKER_CHUNK        : mmioFOURCC = ('m','r','k','r');
  DMUS_FOURCC_RESOLUTION_CHUNK    : mmioFOURCC = ('r','s','l','n');
  DMUS_FOURCC_ANTICIPATION_CHUNK  : mmioFOURCC = ('a','n','p','n');
  DMUS_FOURCC_PATTERN_LIST        : mmioFOURCC = ('p','t','t','n');
  DMUS_FOURCC_PATTERN_CHUNK       : mmioFOURCC = ('p','t','n','h');
  DMUS_FOURCC_RHYTHM_CHUNK        : mmioFOURCC = ('r','h','t','m');
  DMUS_FOURCC_PARTREF_LIST        : mmioFOURCC = ('p','r','e','f');
  DMUS_FOURCC_PARTREF_CHUNK       : mmioFOURCC = ('p','r','f','c');
  DMUS_FOURCC_STYLE_PERS_REF_LIST : mmioFOURCC = ('p', 'r', 'r', 'f');
  DMUS_FOURCC_MOTIFSETTINGS_CHUNK : mmioFOURCC = ('m', 't', 'f', 's');

(* Flags used by variations: these make up the DWORDs in dwVariationChoices.               *)

(* These flags determine the types of chords supported by a given variation in DirectMusic *)
(* mode.  The first seven flags (bits 1-7) are set if the variation supports major chords  *)
(* rooted in scale positions, so, e.g., if bits 1, 2, and 4 are set, the variation         *)
(* supports major chords rooted in the tonic, second, and fourth scale positions.  The     *)
(* next seven flags serve the same purpose, but for minor chords, and the following seven  *)
(* flags serve the same purpose for chords that are not major or minor (e.g., SUS 4        *)
(* chords).  Bits 22, 23, and 24 are set if the variation supports chords rooted in the    *)
(* scale, chords rooted sharp of scale tones, and chords rooted flat of scale tones,       *)
(* respectively.  For example, to support a C# minor chord in the scale of C Major,        *)
(* bits 8 (for tonic minor) and 24 (for sharp) need to be set.  Bits 25, 26, an 27 handle  *)
(* chords that are triads, 6th or 7th chords, and chords with extensions, respectively.    *)
(* bits 28 and 29 handle chords that are followed by tonic and dominant chords,            *)
(* respectively.                                                                           *)
  DMUS_VARIATIONF_MAJOR        = $0000007F; (* Seven positions in the scale - major chords. *)
  DMUS_VARIATIONF_MINOR        = $00003F80; (* Seven positions in the scale - minor chords. *)
  DMUS_VARIATIONF_OTHER        = $001FC000; (* Seven positions in the scale - other chords. *)
  DMUS_VARIATIONF_ROOT_SCALE   = $00200000; (* Handles chord roots in the scale. *)
  DMUS_VARIATIONF_ROOT_FLAT    = $00400000; (* Handles flat chord roots (based on scale notes). *)
  DMUS_VARIATIONF_ROOT_SHARP   = $00800000; (* Handles sharp chord roots (based on scale notes). *)
  DMUS_VARIATIONF_TYPE_TRIAD   = $01000000; (* Handles simple chords - triads. *)
  DMUS_VARIATIONF_TYPE_6AND7   = $02000000; (* Handles simple chords - 6 and 7. *)
  DMUS_VARIATIONF_TYPE_COMPLEX = $04000000; (* Handles complex chords. *)
  DMUS_VARIATIONF_DEST_TO1     = $08000000; (* Handles transitions to 1 chord. *)
  DMUS_VARIATIONF_DEST_TO5     = $10000000; (* Handles transitions to 5 chord. *)
  DMUS_VARIATIONF_DEST_OTHER   = $40000000; (* Handles transitions to chords other than 1 . *)

(* legacy mask for variation modes *)
  DMUS_VARIATIONF_MODES        = $E0000000;
(* Bits 29 and 31 of the variation flags are the Mode bits.  If both are 0, it's IMA. *)
(* If bit 29 is 1, it's Direct Music. *)
  DMUS_VARIATIONF_MODES_EX     = $20000000 or $80000000;
  DMUS_VARIATIONF_IMA25_MODE   = $00000000;
  DMUS_VARIATIONF_DMUS_MODE    = $20000000;

(* Set this if the part uses marker events */
#define DMUS_PARTF_USE_MARKERS       0x1
(* Set this if the part is allowed to switch only on chord-aligned markers *)
  DMUS_PARTF_ALIGN_CHORDS      = $2;

(* These specify if the marker event signals whether to stop a variation or start a
pattern/variation (or both), and whether new variations must align with a chord *)
  DMUS_MARKERF_START           = $1;
  DMUS_MARKERF_STOP            = $2;
  DMUS_MARKERF_CHORD_ALIGN     = $4;

(* if this flag is set, variation settings in a playing pattern-based track's state data will
persist in the track after it stops playing *)
  DMUS_PATTERNF_PERSIST_CONTROL = $1;

(* These specify possible values for DMUS_IO_PARTREF.bRandomVariation
   all but DMUS_VARIATIONT_SEQUENTIAL and DMUS_VARIATIONT_RANDOM are dx8. *)
type
{$MINENUMSIZE 2}
  TDMUS_Variationt_Types = (
    DMUS_VARIATIONT_SEQUENTIAL,    (* Play sequential starting with variation 1. *)
    DMUS_VARIATIONT_RANDOM,        (* Play randomly. *)
    DMUS_VARIATIONT_RANDOM_START,  (* Play sequential starting with a random variation. *)
    DMUS_VARIATIONT_NO_REPEAT,     (* Play randomly, but don't play the same variation twice. *)
    DMUS_VARIATIONT_RANDOM_ROW     (* Play randomly as a row: don't repeat any variation until all have played. *)
  );
{$MINENUMSIZE 4}


//#pragma pack(2)

type BYTE2 = Word;

type
  TDMus_IO_TimeSig = packed record
    (* Time signatures define how many beats per measure, which note receives *)
    (* the beat, and the grid resolution. *)
    bBeatsPerMeasure : BYTE2;      (* beats per measure (top of time sig) *)
    bBeat            : BYTE2;      (* what note receives the beat (bottom of time sig.) *)
                                   (* we can assume that 0 means 256th note *)
    wGridsPerBeat    : WORD;       (* grids per beat *)
  end;

  TDMus_IO_Style = packed record
    timeSig  : TDMus_IO_TimeSig;           (* Styles have a default Time Signature *)
    dblTempo : double;
  end;

  TDMus_IO_Version = packed record
    dwVersionMS : DWORD;                      (* Version # high-order 32 bits *)
    dwVersionLS : DWORD;                      (* Version # low-order 32 bits  *)
  end;

  TDMus_IO_Pattern_DX6 = packed record
    timeSig        : TDMus_IO_TimeSig;    (* Patterns can override the Style's Time sig. *)
    bGrooveBottom  : BYTE2;               (* bottom of groove range *)
    bGrooveTop     : BYTE2;               (* top of groove range *)
    wEmbellishment : WORD;                (* Fill, Break, Intro, End, Normal, Motif *)
    wNbrMeasures   : WORD;                (* length in measures *)
  end;
  TDMus_IO_Pattern_DX7 = TDMus_IO_Pattern_DX6;

  TDMus_IO_Pattern_DX8 = packed record
    timeSig           : TDMus_IO_TimeSig; (* Patterns can override the Style's Time sig. *)
    bGrooveBottom     : BYTE2;            (* bottom of groove range *)
    bGrooveTop        : BYTE2;            (* top of groove range *)
    wEmbellishment    : WORD;             (* Fill, Break, Intro, End, Normal, Motif *)
    wNbrMeasures      : WORD;             (* length in measures *)
    bDestGrooveBottom : BYTE2;            (* bottom of groove range for next pattern *)
    bDestGrooveTop    : BYTE2;            (* top of groove range for next pattern *)
    dwFlags           : DWORD;            (* various flags *)
  end;

{$IFDEF DIRECTX6}
  TDMus_IO_Pattern = TDMus_IO_Pattern_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_IO_Pattern = TDMus_IO_Pattern_DX7;
  {$ELSE}
    TDMus_IO_Pattern = TDMus_IO_Pattern_DX8;
  {$ENDIF}
{$ENDIF}

  TDMus_IO_StylePart_DX6 = packed record
    timeSig            : TDMus_IO_TimeSig;       (* can override pattern's *)
    dwVariationChoices : array [0..31] of DWORD; (* MOAW choice bitfield *)
    guidPartID         : TGUID;                  (* identifies the part *)
    wNbrMeasures       : WORD;                   (* length of the Part *)
    bPlayModeFlags     : BYTE2;                  (* see PLAYMODE flags *)
    bInvertUpper       : BYTE2;                  (* inversion upper limit *)
    bInvertLower       : BYTE2;                  (* inversion lower limit *)
  end;
  TDMus_IO_StylePart_DX7 = TDMus_IO_StylePart_DX6;

  TDMus_IO_StylePart_DX8 = packed record
    timeSig            : TDMus_IO_TimeSig;       (* can override pattern's *)
    dwVariationChoices : array [0..31] of DWORD; (* MOAW choice bitfield *)
    guidPartID         : TGUID;                  (* identifies the part *)
    wNbrMeasures       : WORD;                   (* length of the Part *)
    bPlayModeFlags     : BYTE2;                  (* see PLAYMODE flags *)
    bInvertUpper       : BYTE2;                  (* inversion upper limit *)
    bInvertLower       : BYTE2;                  (* inversion lower limit *)
    bPad               : array[0..2] of BYTE2;   (* for DWORD alignment *)
    dwFlags            : DWORD;                  (* various flags *)
  end;

{$IFDEF DIRECTX6}
  TDMus_IO_StylePart = TDMus_IO_StylePart_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_IO_StylePart = TDMus_IO_StylePart_DX7;
  {$ELSE}
    TDMus_IO_StylePart = TDMus_IO_StylePart_DX8;
  {$ENDIF}
{$ENDIF}

  TDMus_IO_PartRef_DX6 = packed record
    guidPartID       : TGUID;                  (* unique ID for matching up with parts *)
    wLogicalPartID   : WORD;                   (* corresponds to port/device/midi channel *)
    bVariationLockID : BYTE2;                  (* parts with the same ID lock variations. *)
                                               (* high bit is used to identify master Part *)
    bSubChordLevel   : BYTE2;                  (* tells which sub chord level this part wants *)
    bPriority        : BYTE2;                  (* 256 priority levels. Parts with lower priority *)
                                               (* aren't played first when a device runs out of *)
                                               (* notes *)
    bRandomVariation : TDMUS_Variationt_Types; (* when set, matching variations play in random order *)
                                               (* when clear, matching variations play sequentially *)
  end;
  TDMus_IO_PartRef_DX7 = TDMus_IO_PartRef_DX6;

  TDMus_IO_PartRef_DX8 = packed record
    guidPartID       : TGUID;                  (* unique ID for matching up with parts *)
    wLogicalPartID   : WORD;                   (* corresponds to port/device/midi channel *)
    bVariationLockID : BYTE2;                  (* parts with the same ID lock variations. *)
                                               (* high bit is used to identify master Part *)
    bSubChordLevel   : BYTE2;                  (* tells which sub chord level this part wants *)
    bPriority        : BYTE2;                  (* 256 priority levels. Parts with lower priority *)
                                               (* aren't played first when a device runs out of *)
                                               (* notes *)
    bRandomVariation : TDMUS_Variationt_Types; (* when set, matching variations play in random order *)
                                               (* when clear, matching variations play sequentially *)
    wPad             : WORD;                   (* not used *)
    dwPChannel       : DWORD;                  (* replaces wLogicalPartID *)
  end;

{$IFDEF DIRECTX6}
  TDMus_IO_PartRef = TDMus_IO_PartRef_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_IO_PartRef = TDMus_IO_PartRef_DX7;
  {$ELSE}
    TDMus_IO_PartRef = TDMus_IO_PartRef_DX8;
  {$ENDIF}
{$ENDIF}

  TDMus_IO_StyleNote_DX6 = packed record
    mtGridStart    : TMusic_Time;  (* when this note occurs *)
    dwVariation    : DWORD;        (* variation bits *)
    mtDuration     : TMusic_Time;  (* how long this note lasts *)
    nTimeOffset    : SmallInt;     (* offset from mtGridStart *)
    wMusicValue    : WORD;         (* Position in scale. *)
    bVelocity      : BYTE2;        (* Note velocity. *)
    bTimeRange     : BYTE2;        (* Range to randomize start time. *)
    bDurRange      : BYTE2;        (* Range to randomize duration. *)
    bVelRange      : BYTE2;        (* Range to randomize velocity. *)
    bInversionID   : BYTE2;        (* Identifies inversion group to which this note belongs *)
    bPlayModeFlags : BYTE2;        (* Can override part *)
  end;
  TDMus_IO_StyleNote_DX7 = TDMus_IO_StyleNote_DX6;

  TDMus_IO_StyleNote_DX8 = packed record
    mtGridStart    : TMusic_Time;  (* when this note occurs *)
    dwVariation    : DWORD;        (* variation bits *)
    mtDuration     : TMusic_Time;  (* how long this note lasts *)
    nTimeOffset    : SmallInt;     (* offset from mtGridStart *)
    wMusicValue    : WORD;         (* Position in scale. *)
    bVelocity      : BYTE2;        (* Note velocity. *)
    bTimeRange     : BYTE2;        (* Range to randomize start time. *)
    bDurRange      : BYTE2;        (* Range to randomize duration. *)
    bVelRange      : BYTE2;        (* Range to randomize velocity. *)
    bInversionID   : BYTE2;        (* Identifies inversion group to which this note belongs *)
    bPlayModeFlags : BYTE2;        (* Can override part *)
    bNoteFlags     : BYTE2;        (* values from DMUS_NOTEF_FLAGS *)
  end;

{$IFDEF DIRECTX6}
  TDMus_IO_StyleNote = TDMus_IO_StyleNote_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_IO_StyleNote = TDMus_IO_StyleNote_DX7;
  {$ELSE}
    TDMus_IO_StyleNote = TDMus_IO_StyleNote_DX8;
  {$ENDIF}
{$ENDIF}

  TDMus_IO_StyleCurve_DX6 = packed record
    mtGridStart     : TMusic_Time; (* when this curve occurs *)
    dwVariation     : DWORD;       (* variation bits *)
    mtDuration      : TMusic_Time; (* how long this curve lasts *)
    mtResetDuration : TMusic_Time; (* how long after the end of the curve to reset the curve *)
    nTimeOffset     : SmallInt;    (* offset from mtGridStart *)
    nStartValue     : SmallInt;    (* curve's start value *)
    nEndValue       : SmallInt;    (* curve's end value *)
    nResetValue     : SmallInt;    (* the value to which to reset the curve *)
    bEventType      : BYTE2;       (* type of curve *)
    bCurveShape     : BYTE2;       (* shape of curve *)
    bCCData         : BYTE2;       (* CC# *)
    bFlags          : BYTE2;       (* Bit 1=TRUE means to send nResetValue. Otherwise, don't.
                                    Other bits are reserved. *)
  end;
  TDMus_IO_StyleCurve_DX7 = TDMus_IO_StyleCurve_DX6;

  TDMus_IO_StyleCurve_DX8 = packed record
    mtGridStart     : TMusic_Time; (* when this curve occurs *)
    dwVariation     : DWORD;       (* variation bits *)
    mtDuration      : TMusic_Time; (* how long this curve lasts *)
    mtResetDuration : TMusic_Time; (* how long after the end of the curve to reset the curve *)
    nTimeOffset     : SmallInt;    (* offset from mtGridStart *)
    nStartValue     : SmallInt;    (* curve's start value *)
    nEndValue       : SmallInt;    (* curve's end value *)
    nResetValue     : SmallInt;    (* the value to which to reset the curve *)
    bEventType      : BYTE2;       (* type of curve *)
    bCurveShape     : BYTE2;       (* shape of curve *)
    bCCData         : BYTE2;       (* CC# *)
    bFlags          : BYTE2;       (* Bit 1=TRUE means to send nResetValue. Otherwise, don't.
                                    Other bits are reserved. *)
    wParamType      : WORD;        (* RPN or NRPN parameter number. *)
    wMergeIndex     : WORD;        (* Allows multiple parameters to be merged (pitchbend, volume, and expression.) *)
  end;

{$IFDEF DIRECTX6}
  TDMus_IO_StyleCurve = TDMus_IO_StyleCurve_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_IO_StyleCurve = TDMus_IO_StyleCurve_DX7;
  {$ELSE}
    TDMus_IO_StyleCurve = TDMus_IO_StyleCurve_DX8;
  {$ENDIF}
{$ENDIF}

  TDMUS_IO_StyleMaker = packed record
    mtGridStart  : TMusic_Time;    (* when this marker occurs *)
    dwVariation  : DWORD;          (* variation bits *)
    wMarkerFlags : WORD;           (* how the marker is used *)
  end;

  TDMUS_IO_StyleResolution = packed record
    dwVariation    : DWORD;       (* variation bits *)
    wMusicValue    : WORD;        (* Position in scale. *)
    bInversionID   : BYTE2;       (* Identifies inversion group to which this note belongs *)
    bPlayModeFlags : BYTE2;       (* Can override part *)
  end;

  TDMUS_IO_Style_Anticiaption = packed record
    mtGridStart : TMusic_Time;   (* when this anticipation occurs *)
    dwVariation : DWORD;         (* variation bits *)
    nTimeOffset : Short;         (* offset from mtGridStart *)
    bTimeRange  : BYTE2;         (* Range to randomize start time. *)
  end;

  TDMus_IO_MotifSettings = packed record
    dwRepeats    : DWORD;          (* Number of repeats. By default, 0. *)
    mtPlayStart  : TMusic_Time;    (* Start of playback. By default, 0. *)
    mtLoopStart  : TMusic_Time;    (* Start of looping portion. By default, 0. *)
    mtLoopEnd    : TMusic_Time;    (* End of loop. Must be greater than mtLoopStart. By default equal to length of motif. *)
    dwResolution : DWORD;          (* Default resolution. *)
  end;

//#pragma pack()

(*
RIFF
(
    'DMST'          // Style
    <styh-ck>       // Style header chunk
    <guid-ck>       // Every Style has a GUID
    [<UNFO-list>]   // Name, author, copyright info., comments
    [<vers-ck>]     // version chunk
    <part-list>...  // List of parts in the Style, used by patterns
    <pttn-list>...  // List of patterns in the Style
    <DMBD-form>...  // List of bands in the Style
    [<motf-list>]   // List of motifs in the Style
    [<prrf-list>]   // List of chord map references in the Style
)

    // <styh-ck>
    styh
    (
        <DMUS_IO_STYLE>
    )

    // <guid-ck>
    guid
    (
        <GUID>
    )

    // <vers-ck>
    vers
    (
        <DMUS_IO_VERSION>
    )

    // <part-list>
    LIST
    (
        'part'
        <prth-ck>       // Part header chunk
        [<UNFO-list>]
        [<note-ck>]     // List of notes in Part
        [<crve-ck>]     // List of curves in Part
    )

        // <orth-ck>
        prth
        (
            <DMUS_IO_STYLEPART>
        )

        // <note-ck>
        'note'
        (
            // sizeof DMUS_IO_STYLENOTE:DWORD
            <DMUS_IO_STYLENOTE>...
        )

        // <crve-ck>
        'crve'
        (
            // sizeof DMUS_IO_STYLECURVE:DWORD
            <DMUS_IO_STYLECURVE>...
        )

    // <pttn-list>
    LIST
    (
        'pttn'
        <ptnh-ck>       // Pattern header chunk
        <rhtm-ck>       // List of rhythms for chord matching
        [<UNFO-list>]
        [<mtfs-ck>]     // Motif settings chunk
        <pref-list>...  // List of part reference id's
    )

        // <ptnh-ck>
        ptnh
        (
            <DMUS_IO_PATTERN>
        )

        // <rhtm-ck>
        'rhtm'
        (
            // DWORD's representing rhythms for chord matching based on number
            // of measures in the pattern
        )

        // pref-list
        LIST
        (
            'pref'
            <prfc-ck>   // part ref chunk
        )

        // <prfc-ck>
        prfc
        (
            <DMUS_IO_PARTREF>
        )

        // <mtfs-ck>
        mtfs
        (
            <DMUS_IO_MOTIFSETTINGS>
        )

    // <prrf-list>
    LIST
    (
        'prrf'
        // some number of <DMRF>
    )
*)

const
(* Pattern chunk, for use in Pattern tracks *)
  DMUS_FOURCC_PATTERN_FORM            : mmioFOURCC = ('D','M','P','T');

(*
RIFF
(
    'DMPT'          // Pattern
    <styh-ck>       // Style header chunk
    <pttn-list>     // The pattern, in single pattern format (includes DMUS_FOURCC_PART_LIST chunks)
)
*)

(* Chord and command file formats *)
type
  (* These specify possible values for DMUS_IO_COMMAND.bRepeatMode (dx8) *)
  {$MINENUMSIZE 1}
  TDMUS_Pattern_Types = (
    DMUS_PATTERNT_RANDOM,            (* Play randomly. (dx7 behavior) *)
    DMUS_PATTERNT_REPEAT,            (* Repeat last pattern. *)
    DMUS_PATTERNT_SEQUENTIAL,        (* Play sequential starting with first matching pattern. *)
    DMUS_PATTERNT_RANDOM_START,      (* Play sequential starting with a random pattern. *)
    DMUS_PATTERNT_NO_REPEAT,         (* Play randomly, but don't play the same pattern twice. *)
    DMUS_PATTERNT_RANDOM_ROW         (* Play randomly as a row: don't repeat any pattern until all have played. *)
  );
  {$MINENUMSIZE 4}

const
  DMUS_FOURCC_CHORDTRACK_LIST         : mmioFOURCC = ('c','o','r','d');
  DMUS_FOURCC_CHORDTRACKHEADER_CHUNK  : mmioFOURCC = ('c','r','d','h');
  DMUS_FOURCC_CHORDTRACKBODY_CHUNK    : mmioFOURCC = ('c','r','d','b');

  DMUS_FOURCC_COMMANDTRACK_CHUNK      : mmioFOURCC = ('c','m','n','d');

type
  TDMus_IO_Chord_DX6 = packed record
    wszName  : array [0..15] of WCHAR;  (* Name of the chord *)
    mtTime   : TMusic_Time;             (* Time of this chord *)
    wMeasure : WORD;                    (* Measure this falls on *)
    bBeat    : BYTE;                    (* Beat this falls on *)
  end;
  TDMus_IO_Chord_DX7 = TDMus_IO_Chord_DX6;

  TDMus_IO_Chord_DX8 = packed record
    wszName  : array [0..15] of WCHAR;  (* Name of the chord *)
    mtTime   : TMusic_Time;             (* Time of this chord *)
    wMeasure : WORD;                    (* Measure this falls on *)
    bBeat    : BYTE;                    (* Beat this falls on *)
    bFlags   : BYTE;                    (* Various flags *)
  end;

{$IFDEF DIRECTX6}
  TDMus_IO_Chord = TDMus_IO_Chord_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_IO_Chord = TDMus_IO_Chord_DX7;
  {$ELSE}
    TDMus_IO_Chord = TDMus_IO_Chord_DX8;
  {$ENDIF}
{$ENDIF}

  TDMus_IO_SubChord = packed record
    dwChordPattern    : DWORD;    (* Notes in the subchord *)
    dwScalePattern    : DWORD;    (* Notes in the scale *)
    dwInversionPoints : DWORD;    (* Where inversions can occur *)
    dwLevels          : DWORD;    (* Which levels are supported by this subchord *)
    bChordRoot        : BYTE;     (* Root of the subchord *)
    bScaleRoot        : BYTE;     (* Root of the scale *)
  end;

  TDMus_IO_Command_DX6 = packed record
    mtTime       : TMusic_Time;   (* Time of this command *)
    wMeasure     : WORD;          (* Measure this falls on *)
    bBeat        : BYTE;          (* Beat this falls on *)
    bCommand     : BYTE;          (* Command type (see #defines below) *)
    bGrooveLevel : BYTE;          (* Groove level (0 if command is not a groove) *)
    bGrooveRange : BYTE;          (* Groove range  *)
  end;
  TDMus_IO_Command_DX7 = TDMus_IO_Command_DX6;

  TDMus_IO_Command_DX8 = packed record
    mtTime       : TMusic_Time;   (* Time of this command *)
    wMeasure     : WORD;          (* Measure this falls on *)
    bBeat        : BYTE;          (* Beat this falls on *)
    bCommand     : BYTE;          (* Command type (see #defines below) *)
    bGrooveLevel : BYTE;          (* Groove level (0 if command is not a groove) *)
    bGrooveRange : BYTE;          (* Groove range  *)
    bRepeatMode  : TDMUS_Pattern_Types (* Used to control selection of patterns with same groove level  *)
  end;

{$IFDEF DIRECTX6}
  TDMus_IO_Command = TDMus_IO_Command_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_IO_Command = TDMus_IO_Command_DX7;
  {$ELSE}
    TDMus_IO_Command = TDMus_IO_Command_DX8;
  {$ENDIF}
{$ENDIF}

(*

    // <cord-list>
    LIST
    (
        'cord'
        <crdh-ck>
        <crdb-ck>       // Chord body chunk
    )

        // <crdh-ck>
        crdh
        (
            // Scale: dword (upper 8 bits for root, lower 24 for scale)
        )

        // <crdb-ck>
        crdb
        (
            // sizeof DMUS_IO_CHORD:dword
            <DMUS_IO_CHORD>
            // # of DMUS_IO_SUBCHORDS:dword
            // sizeof DMUS_IO_SUBCHORDS:dword
            // a number of <DMUS_IO_SUBCHORD>
        )


    // <cmnd-list>
    'cmnd'
    (
        //sizeof DMUS_IO_COMMAND: DWORD
        <DMUS_IO_COMMAND>...
    )

*)

(*  File io for DirectMusic Tool and ToolGraph objects
*)

(* RIFF ids: *)
const
  DMUS_FOURCC_TOOLGRAPH_FORM  : mmioFOURCC = ('D','M','T','G');
  DMUS_FOURCC_TOOL_LIST       : mmioFOURCC = ('t','o','l','l');
  DMUS_FOURCC_TOOL_FORM       : mmioFOURCC = ('D','M','T','L');
  DMUS_FOURCC_TOOL_CHUNK      : mmioFOURCC = ('t','o','l','h');

(* io structures: *)
type
  TDMus_IO_Tool_Header = packed record
    guidClassID : TGUID;                 (* Class id of tool. *)
    lIndex      : LongInt;               (* Position in graph. *)
    cPChannels  : DWORD;                 (* Number of items in channels array. *)
    ckid        : TFourCC;               (* chunk ID of tool's data chunk if 0 fccType valid. *)
    fccType     : TFourCC;               (* list type if NULL ckid valid. *)
    dwPChannels : array [0..0] of DWORD; (* Array of PChannels, size determined by cPChannels. *)
  end;

(*
RIFF
(
    'DMTG'          // DirectMusic ToolGraph chunk
    [<guid-ck>]     // GUID for ToolGraph
    [<vers-ck>]     // Optional version info
    [<UNFO-list>]   // Name, author, copyright info., comments
    <toll-list>     // List of Tools
)

    // <guid-ck>
    'guid'
    (
        <GUID>
    )

    // <vers-ck>
    vers
    (
        <DMUS_IO_VERSION>
    )

    // <toll-list>
    LIST
    (
        'toll'          // Array of tools
        <DMTL-form>...  // Each tool is encapsulated in a RIFF chunk
    )

// <DMTL-form>      Tools are embedded in a graph. Theoretically, they can be saved as individual files too.
RIFF
(
    'DMTL'
    <tolh-ck>
    [<data>]        // Tool data. Must be a RIFF readable chunk.
)

    // <tolh-ck>            // Tool header chunk
    (
        'tolh'
        <DMUS_IO_TOOL_HEADER>   // Tool header
    )
*)

(*  The AudioPath file carries everything for describing a specific audio path,
    including Tool Graph and Buffer Descriptor.
    This can even be used for configuring a complete performance.
*)

const
  DMUS_FOURCC_AUDIOPATH_FORM : mmioFOURCC = ('D','M','A','P');

(*
RIFF
(
    'DMAP'          // DirectMusic AudioPath chunk
    [<guid-ck>]     // GUID for this Audio Path configuration
    [<vers-ck>]     // Optional version info
    [<UNFO-list>]   // Name, author, copyright info., comments
    [<DMTG-form>]   // Optional ToolGraph
    [<pcsl-list>]   // Optional list of port configurations
    [<dbfl-list>]...// Optional array of Dsound buffer descriptors
)
*)

  DMUS_FOURCC_PORTCONFIGS_LIST   : mmioFOURCC = ('p','c','s','l');
  DMUS_FOURCC_PORTCONFIG_LIST    : mmioFOURCC = ('p','c','f','l');
  DMUS_FOURCC_PORTCONFIG_ITEM    : mmioFOURCC = ('p','c','f','h');
  DMUS_FOURCC_PORTPARAMS_ITEM    : mmioFOURCC = ('p','p','r','h');
  DMUS_FOURCC_DSBUFFER_LIST      : mmioFOURCC = ('d','b','f','l');
  DMUS_FOURCC_DSBUFFATTR_ITEM    : mmioFOURCC = ('d','d','a','h');
  DMUS_FOURCC_PCHANNELS_LIST     : mmioFOURCC = ('p','c','h','l');
  DMUS_FOURCC_PCHANNELS_ITEM     : mmioFOURCC = ('p','c','h','h');

type
  DMUS_IO_PortConfigHeader = packed record
    guidPort        : TGUID;    (* GUID of requested port. *)
    dwPChannelBase  : DWORD;    (* PChannel that this should start on. *)
    dwPChannelCount : DWORD;    (* How many channels. *)
    dwFlags         : DWORD;    (* Various flags. *)
  end;

const
  DMUS_PORTCONFIGF_DRUMSON10  = 1;   (* This port configured for drums on channel 10. *)
  DMUS_PORTCONFIGF_USEDEFAULT = 2;   (* Use the default port. *)

(* Each portconfig has one or more pchannel to buffer mappings. Each buffer
   is identified by a guid. Each pchannel can map to one or more buffers.
   This is defined with one or more DMUS_IO_PCHANNELTOBUFFER_HEADER
   structures. Each defines a range of PChannels and the set of buffers
   that they connect to.
*)
type
  TDMUS_IO_PChannelToBuffer_Header = packed record
    dwPChannelBase  : DWORD; (* PChannel that this should start on. *)
    dwPChannelCount : DWORD; (* How many PChannels. *)
    dwBufferCount   : DWORD; (* How many buffers do these connect to. *)
    dwFlags         : DWORD; (* Various flags. Currently reserved for future use. Must be 0. *)
  end;

(* Each buffer is represented by an DSBC form. This is wrapped by the
   DMUS_IO_BUFFER_ATTRIBUTES_HEADER which identifies how to use the
   buffer. In particular, it indicates whether this gets dynamically duplicated
   or all references to this should share the same instance. 
   To resolve references, the unique GUID of the buffer is also stored
   in this structure.
*)

  TDMUS_IO_Buffer_Attributes_Header = packed record
    guidBufferID : TGUID;       (* Each buffer config has a unique ID. *)
    dwFlags      : DWORD;       (* Various flags. *)
  end;

const
  (* DMUS_IO_BUFFER_ATTRIBUTES_HEADER.dwFlags: *)
  DMUS_BUFFERF_SHARED     = 1;   (* Share this with other audio paths, instead of creating unique copies. *)
  DMUS_BUFFERF_DEFINED    = 2;   (* Use one of the standard predefined buffers (see GUID_Buffer... in dmusici.h.) *)
  DMUS_BUFFERF_MIXIN      = 8;   (* This is a mixin buffer. *)

(*

LIST
(
    'pcsl'          // Array of port configurations
    <pcfl-list>...  // One or more port configurations, each in a list chunk
)

LIST
(
    'pcfl'          // List container for one port configuration.
    <pcfh-ck>       // Portconfig header chunk.
    <pprh-ck>       // Port params, to be used to create the port.
    [<dbfl-list>]...// Optional array of Dsound buffer descriptors
    [<pchl-list>]   // Optional list of pchannel to buffer assignments

)

    // <pcfh-ck>            // Port config header chunk
    (
        'pcfh'
        <DMUS_IO_PORTCONFIG_HEADER>   // Port config header
    )

    // <pprh-ck>            // Port params header chunk
    (
        'pprh'
        <DMUS_PORTPARAMS8>   // Port params header
    )

LIST
(
    'pchl'          // List container for one or more pchannel to buffer assignments.
    <pchh-ck>...    // One or more pchannel to buffer assignment headers and data.

    // <pchh-ck>
    (
        'pchh'
        <DMUS_IO_PCHANNELTOBUFFER_HEADER>   // Description of PChannels
        <GUID>...                           // Array of GUIDs defining the buffers they all connect to.
    )
)

LIST
(
    'dbfl'          // List container for one buffer and buffer attributes header.
    <ddah-ck>       // Buffer attributes header. 
    [<DSBC-form>]   // Buffer configuration. Not required when header uses a predefined buffer type.

    // <ddah-ck>
    (
        'ddah'
        <DMUS_IO_BUFFER_ATTRIBUTES_HEADER>   // Buffer attributes.
    )
)
*)

(*  File io for DirectMusic Band Track object *)

(* RIFF ids: *)
const
  DMUS_FOURCC_BANDTRACK_FORM  : mmioFOURCC = ('D','M','B','T');
  DMUS_FOURCC_BANDTRACK_CHUNK : mmioFOURCC = ('b','d','t','h');
  DMUS_FOURCC_BANDS_LIST      : mmioFOURCC = ('l','b','d','l');
  DMUS_FOURCC_BAND_LIST       : mmioFOURCC = ('l','b','n','d');
  DMUS_FOURCC_BANDITEM_CHUNK  : mmioFOURCC = ('b','d','i','h');
  DMUS_FOURCC_BANDITEM_CHUNK2 : mmioFOURCC = ('b','d','2','h');

type
(*  io structures *)
  TDMus_IO_Band_Track_Header = packed record
    bAutoDownload : BOOL;    (* Determines if Auto-Download is enabled. *)
  end;

  TDMus_IO_Band_Item_Header = packed record
    lBandTime : TMusic_Time;   (* Position in track list. *)
  end;

  TDMus_IO_Band_Item_Header2 = packed record
    lBandTimeLogical  : TMusic_Time;  (* Position in track list. Time in the music with which band change is associated. *)
    lBandTimePhysical : TMusic_Time;  (* Precise time band change will take effect. Should be close to logical time. *)
  end;

(*
RIFF
(
    'DMBT'          // DirectMusic Band Track form-type
    [<bdth-ck>]     // Band track header
    [<guid-ck>]     // GUID for band track
    [<vers-ck>]     // Optional version info
    [<UNFO-list>]   // Name, author, copyright info., comments
    <lbdl-list>     // List of Band Lists
)

    // <bnth-ck>
    'bdth'
    (
        <DMUS_IO_BAND_TRACK_HEADER>
    )

    // <guid-ck>
    'guid'
    (
        <GUID>
    )

    // <vers-ck>
    vers
    (
        <DMUS_IO_VERSION>
    )

    // <lbdl-list>
    LIST
    (
        'lbdl'          // List of bands
        <lbnd-list>     // Each band is encapsulated in a list
    )

        // <lbnd-list>
        LIST
        (
            'lbnd'
            <bdih-ck>
            <DMBD-form> // Band
        )

            // <bdih-ck>            // band item header
            (
                <DMUS_IO_BAND_ITEM_HEADER>  // Band item header
            )
*)      


(*  File io for DirectMusic Band object
*)

(* RIFF ids: *)
const
  DMUS_FOURCC_BAND_FORM           : mmioFOURCC = ('D','M','B','D');
  DMUS_FOURCC_INSTRUMENTS_LIST    : mmioFOURCC = ('l','b','i','l');
  DMUS_FOURCC_INSTRUMENT_LIST     : mmioFOURCC = ('l','b','i','n');
  DMUS_FOURCC_INSTRUMENT_CHUNK    : mmioFOURCC = ('b','i','n','s');

(* Flags for DMUS_IO_INSTRUMENT
 *)
  DMUS_IO_INST_PATCH              = (1 shl 0);        (* dwPatch is valid. *)
  DMUS_IO_INST_BANKSELECT         = (1 shl 1);        (* dwPatch contains a valid Bank Select MSB and LSB part *)
  DMUS_IO_INST_ASSIGN_PATCH       = (1 shl 3);        (* dwAssignPatch is valid *)
  DMUS_IO_INST_NOTERANGES         = (1 shl 4);        (* dwNoteRanges is valid *)
  DMUS_IO_INST_PAN                = (1 shl 5);        (* bPan is valid *)
  DMUS_IO_INST_VOLUME             = (1 shl 6);        (* bVolume is valid *)
  DMUS_IO_INST_TRANSPOSE          = (1 shl 7);        (* nTranspose is valid *)
  DMUS_IO_INST_GM                 = (1 shl 8);        (* Instrument is from GM collection *)
  DMUS_IO_INST_GS                 = (1 shl 9);        (* Instrument is from GS collection *)
  DMUS_IO_INST_XG                 = (1 shl 10);       (* Instrument is from XG collection *)
  DMUS_IO_INST_CHANNEL_PRIORITY   = (1 shl 11);       (* dwChannelPriority is valid *)
  DMUS_IO_INST_USE_DEFAULT_GM_SET = (1 shl 12);       (* Always use the default GM set for this patch,  *)
                                                      (* don't rely on the synth caps stating GM or GS in hardware. *)
  DMUS_IO_INST_PITCHBENDRANGE     = (1 shl 13);       (* nPitchBendRange is valid *)
type
(*  io structures *)
  TDMus_IO_Instruments_DX6 = packed record
    dwPatch           : DWORD;                     (* MSB, LSB and Program change to define instrument *)
    dwAssignPatch     : DWORD;                     (* MSB, LSB and Program change to assign to instrument when downloading *)
    dwNoteRanges      : array [0..3] of DWORD;     (* 128 bits: one for each MIDI note instrument needs to able to play *)
    dwPChannel        : DWORD;                     (* PChannel instrument plays on *)
    dwFlags           : DWORD;                     (* DMUS_IO_INST_ flags *)
    bPan              : BYTE;                      (* Pan for instrument *)
    bVolume           : BYTE;                      (* Volume for instrument *)
    nTranspose        : SmallInt;                  (* Number of semitones to transpose notes *)
    dwChannelPriority : DWORD;                     (* Channel priority *)
  end;
  TDMus_IO_Instruments_DX7 = TDMus_IO_Instruments_DX6;

  TDMus_IO_Instruments_DX8 = packed record
    dwPatch           : DWORD;                     (* MSB, LSB and Program change to define instrument *)
    dwAssignPatch     : DWORD;                     (* MSB, LSB and Program change to assign to instrument when downloading *)
    dwNoteRanges      : array [0..3] of DWORD;     (* 128 bits: one for each MIDI note instrument needs to able to play *)
    dwPChannel        : DWORD;                     (* PChannel instrument plays on *)
    dwFlags           : DWORD;                     (* DMUS_IO_INST_ flags *)
    bPan              : BYTE;                      (* Pan for instrument *)
    bVolume           : BYTE;                      (* Volume for instrument *)
    nTranspose        : SmallInt;                  (* Number of semitones to transpose notes *)
    dwChannelPriority : DWORD;                     (* Channel priority *)
    nPitchBendRange   : SmallInt;                  (* Number of semitones shifted by pitch bend *)
  end;

{$IFDEF DIRECTX6}
  TDMus_IO_Instruments = TDMus_IO_Instruments_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_IO_Instruments = TDMus_IO_Instruments_DX7;
  {$ELSE}
    TDMus_IO_Instruments = TDMus_IO_Instruments_DX8;
  {$ENDIF}
{$ENDIF}

(*
// <DMBD-form> bands can be embedded in other forms
RIFF
(
    'DMBD'          // DirectMusic Band chunk
    [<guid-ck>]     // GUID for band
    [<vers-ck>]     // Optional version info
    [<UNFO-list>]   // Name, author, copyright info., comments
    <lbil-list>     // List of Instruments
)

    // <guid-ck>
    'guid'
    (
        <GUID>
    )

    // <vers-ck>
    vers
    (
        <DMUS_IO_VERSION>
    )

    // <lbil-list>
    LIST
    (
        'lbil'          // Array of instruments
        <lbin-list>...  // Each instrument is encapsulated in a list
    )

        // <lbin-list>
        LIST
        (
            'lbin'
            <bins-ck>
            [<DMRF-list>]       // Optional reference to DLS Collection file.
        )

            // <bins-ck>            // Instrument chunk
            (
                'bins'
                <DMUS_IO_INSTRUMENT>    // Instrument header
            )
*)

(* This RIFF id and io struct have been added to allow wave files (and the wave object) to
   differentiate between streaming and one-shot waves, and to give a prefetch for streaming
   waves  *)

const
  DMUS_FOURCC_WAVEHEADER_CHUNK : mmioFOURCC = ('w','a','v','h');

type
  TDMUS_IO_Wave_Header = packed record
    rtReadAhead : TReference_Time;    (* How far ahead in the stream wave data will be read (in REFERENCE_TIME).  Ignored for one-shot waves.  *)
    dwFlags     : DWORD;              (* Various flags, including whether this is a streaming wave and whether it can be invalidated. *)
  end;


(*  File io for Wave track *)

(* RIFF ids: *)
const
  DMUS_FOURCC_WAVETRACK_LIST     : mmioFOURCC = ('w','a','v','t');
  DMUS_FOURCC_WAVETRACK_CHUNK    : mmioFOURCC = ('w','a','t','h');
  DMUS_FOURCC_WAVEPART_LIST      : mmioFOURCC = ('w','a','v','p');
  DMUS_FOURCC_WAVEPART_CHUNK     : mmioFOURCC = ('w','a','p','h');
  DMUS_FOURCC_WAVEITEM_LIST      : mmioFOURCC = ('w','a','v','i');
  DMUS_FOURCC_WAVE_LIST          : mmioFOURCC = ('w','a','v','e');
  DMUS_FOURCC_WAVEITEM_CHUNK     : mmioFOURCC = ('w','a','i','h');

(* This flag is included in DMUS_IO_WAVE_TRACK_HEADER.dwFlags.  If set, the track will get its
   variations from a pattern track, via GetParam(GUID_Variations). *)
  DMUS_WAVETRACKF_SYNC_VAR       = $1;
(* This is also included in DMUS_IO_WAVE_TRACK_HEADER.dwFlags.  If set, variation control
   information will persist from one playback instance to the next.*)
  DMUS_WAVETRACKF_PERSIST_CONTROL = $2;

type
  TDMUS_IO_Wave_Track_Header = packed record
    lVolume : Longint;      (* Gain, in 1/100th of dB, to be applied to all waves.  Note:  All gain values should be negative. *)
    dwFlags : DWORD;        (* Flags, including whether this track syncs to a pattern track for its variations. *)
  end;

  TDMUS_IO_Wave_Part_Header = packed record
    lVolume      : Longint; (* Gain, in 1/100th of dB, to be applied to all waves in wave part.  Note:  All gain values should be negative. *)
    dwVariations : DWORD;   (* Variation mask for which of 32 variations *)
    dwPChannel   : DWORD;   (* PChannel *)
    dwLockToPart : DWORD;   (* Part ID to lock to. *)
    dwFlags      : DWORD;   (* Flags, including stuff for managing how variations are chosen (in low-order nibble) *)
    dwIndex      : DWORD;   (* Index for distinguishing multiple parts on the same PChannel*)
  end;

  DMUS_IO_Wave_Item_Header = packed record
    lVolume      : Longint;          (* Gain, in 1/100th of dB.  Note:  All gain values should be negative. *)
    lPitch       : Longint;          (* Pitch offset in 1/100th of a semitone. *)
    dwVariations : DWORD;            (* Variation flags for which of 32 variations this wave belongs to. *)
    rtTime       : TReference_Time;  (* Start time, in REFERENCE_TIME, if clock time track, or MUSIC_TIME for music time track. *)
    rtStartOffset: TReference_Time;  (* Distance into wave to start playback, in reference time units. *)
    rtReserved   : TReference_Time;  (* Reserved field. *)
    rtDuration   : TReference_Time;  (* Duration, in REFERENCE_TIME or MUSIC_TIME, depending on track timing format. *)
    mtLogicalTime: TMusic_Time;      (* If in music track format, this indicates the musical boundary where this belongs. Otherwise, ignored. *)
    dwLoopStart  : DWORD;            (* Start point for a looping wave. *)
    dwLoopEnd    : DWORD;            (* End point for a looping wave. *)
    dwFlags      : DWORD;            (* Various flags, including whether this is a streaming wave and whether it can be invalidated. *)
  end;


(*
LIST
{
    'wavt'          // Wave track chunk
    <wath-ck>       // Wave track header
    <wavp-list>...  // Array of Wave Parts
}
    // <wath-ck>
    'wath'
    {
        <DMUS_IO_WAVE_TRACK_HEADER>
    }

    //  <wavp-list>
    LIST
    {
        'wavp'
        <waph-ck>       //  Wave Part Header
        <wavi-list>     //  List of wave items
    }

        //  <waph-ck>
        'waph'
        {
            <DMUS_IO_WAVE_PART_HEADER>
        }

        //  <wavi-list>
        LIST
        {
            'wavi'
            <wave-list>...  //  Array of waves; each wave is encapsulated in a list
        }

            //  <wave-list>
            LIST
            {
                'wave'
                <waih-ck>       //  Wave item header
                <DMRF-list>     //  Reference to wave object
            }

                //  <waih-ck>
                'waih'
                {
                    <DMUS_IO_WAVE_ITEM_HEADER>
                }

*)

(*  File io for DirectMusic Container file. This embeds a set of related files. And,
    in turn, it can be embedded within a segment or script file.
*)

const
  DMUS_FOURCC_CONTAINER_FORM         : mmioFOURCC = ('D','M','C','N');
  DMUS_FOURCC_CONTAINER_CHUNK        : mmioFOURCC = ('c','o','n','h');
  DMUS_FOURCC_CONTAINED_ALIAS_CHUNK  : mmioFOURCC = ('c','o','b','a');
  DMUS_FOURCC_CONTAINED_OBJECT_CHUNK : mmioFOURCC = ('c','o','b','h');
  DMUS_FOURCC_CONTAINED_OBJECTS_LIST : mmioFOURCC = ('c','o','s','l');
  DMUS_FOURCC_CONTAINED_OBJECT_LIST  : mmioFOURCC = ('c','o','b','l');

type
  TDMUS_IO_CONTAINER_HEADER = packed record
    dwFlags: DWORD;        (* Flags. *)
  end;

const
  DMUS_CONTAINER_NOLOADS = (1 shl 1);      (* Contained items are not loaded when the container is loaded.
                                              Entries will be created in the loader (via SetObject) but
                                              the actual objects will not be created until they are
                                              specifically loaded at a later time. *)

type
  TDMUS_IO_CONTAINED_OBJECT_HEADER = packed record
    guidClassID : TGUID;        (* Class id of object. *)
    dwFlags     : DWORD;        (* Flags, for example DMUS_CONTAINED_OBJF_KEEP. *)
    ckid        : TFourCC;      (* chunk ID of track's data chunk if 0 fccType valid. *)
    fccType     : TFourCC;      (* list type if NULL ckid valid *)
        (* Note that LIST:DMRF may be used for ckid and fccType in order to reference an
           object instead of embedding it within the container. *)
  end;

const
  DMUS_CONTAINED_OBJF_KEEP = 1;

(*
RIFF
(
    'DMCN'          // DirectMusic Container chunk
    <conh-ck>       // Container header chunk
    [<guid-ck>]     // GUID for container
    [<vers-ck>]     // Optional version info
    [<UNFO-list>]   // Name, author, copyright info., comments
    <cosl-list>     // List of objects.
)

    // <conh-ck>        
    'conh'
    (
        <DMUS_IO_CONTAINER_HEADER>
    )
    
    // <guid-ck>
    'guid'
    (
        <GUID>
    )

    // <vers-ck>
    vers
    (
        <DMUS_IO_VERSION>
    )

    LIST
    (
        'cosl'          // Array of embedded objects.
        <cobl-list>...  // Each object is encapsulated in a LIST chunk
    )

    // <cobl-list>      // Encapsulates one object
    LIST
    (
        'cobl'
        [<coba-ck>]         // Alias.  An alternative name by which this object is known
                            // within the container.
        <cobh-ck>           // Required header, includes CLASS ID for object.
        [<data>] or <DMRF>  // Object data of the type specified in <cobh-ck>.
                            // If DMRF, it is a reference of where to find the object.
                            // Otherwise, it could be any RIFF readable chunk in the
                            //    exact same format as a file.  The object will load
                            //    itself from this data.
    )

    // <coba-ck>
    'coba'
    (
        // Alias, stored as NULL terminated string of WCHARs
    )

    // <cobh-ck>
    'cobh'
    (
        <DMUS_IO_CONTAINED_OBJECT_HEADER>
    )
*)

(*  File io for DirectMusic Segment object *)

(* RIFF ids: *)
const
  DMUS_FOURCC_SEGMENT_FORM       : mmioFOURCC = ('D','M','S','G');
  DMUS_FOURCC_SEGMENT_CHUNK      : mmioFOURCC = ('s','e','g','h');
  DMUS_FOURCC_TRACK_LIST         : mmioFOURCC = ('t','r','k','l');
  DMUS_FOURCC_TRACK_FORM         : mmioFOURCC = ('D','M','T','K');
  DMUS_FOURCC_TRACK_CHUNK        : mmioFOURCC = ('t','r','k','h');
  DMUS_FOURCC_TRACK_EXTRAS_CHUNK : mmioFOURCC = ('t','r','k','x');

(*  io structures:*)
type
  TDMus_IO_Segment_Header_DX6 = packed record
    dwRepeats    : DWORD;         (* Number of repeats. By default, 0. *)
    mtLength     : TMusic_Time;   (* Length, in music time. *)
    mtPlayStart  : TMusic_Time;   (* Start of playback. By default, 0. *)
    mtLoopStart  : TMusic_Time;   (* Start of looping portion. By default, 0. *)
    mtLoopEnd    : TMusic_Time;   (* End of loop. Must be greater than dwPlayStart. By default equal to length. *)
    dwResolution : DWORD;         (* Default resolution. *)
  end;
  TDMus_IO_Segment_Header_DX7 = TDMus_IO_Segment_Header_DX6;

  TDMus_IO_Segment_Header_DX8 = packed record
    dwRepeats    : DWORD;          (* Number of repeats. By default, 0. *)
    mtLength     : TMusic_Time;    (* Length, in music time. *)
    mtPlayStart  : TMusic_Time;    (* Start of playback. By default, 0. *)
    mtLoopStart  : TMusic_Time;    (* Start of looping portion. By default, 0. *)
    mtLoopEnd    : TMusic_Time;    (* End of loop. Must be greater than dwPlayStart. By default equal to length. *)
    dwResolution : DWORD;          (* Default resolution. *)
    rtLength     : TReference_Time;(* Length, in reference time (overrides music time length.) *)
    dwFlags      : DWORD;
    dwReserved   : DWORD;          (* Reserved. *)
  end;

{$IFDEF DIRECTX6}
  TDMus_IO_Segment_Header = TDMus_IO_Segment_Header_DX6;
{$ELSE}
  {$IFDEF DIRECTX7}
    TDMus_IO_Segment_Header = TDMus_IO_Segment_Header_DX7;
  {$ELSE}
    TDMus_IO_Segment_Header = TDMus_IO_Segment_Header_DX8;
  {$ENDIF}
{$ENDIF}

const
  DMUS_SEGIOF_REFLENGTH  = 1;  (* Use the time in rtLength for the segment length. *)

type
  TDMus_IO_Track_Header = packed record
    guidClassID : TGUID;          (* Class id of track. *)
    dwPosition  : DWORD;          (* Position in track list. *)
    dwGroup     : DWORD;          (* Group bits for track. *)
    ckid        : TFourCC;        (* chunk ID of track's data chunk if 0 fccType valid. *)
    fccType     : TFourCC;        (* list type if NULL ckid valid *)
  end;

(*  Additional parameters for the track header chunk, introduced in DX8 and
    on, are stored in a separate chunk. *)
  TDMUS_IO_TRACK_EXTRAS_HEADER = packed record
    dwFlags    : DWORD;        (* DX8 Added flags for control tracks. *)
    dwPriority : DWORD;        (* Priority for composition. *)
  end;

(*
RIFF
(
    'DMSG'          // DirectMusic Segment chunk
    <segh-ck>       // Segment header chunk
    [<guid-ck>]     // GUID for segment
    [<vers-ck>]     // Optional version info
    [<UNFO-list>]   // Name, author, copyright info., comments
    [<DMCN-form>]   // Optional container of objects embedded in file. Must precede tracklist.
    <trkl-list>     // List of Tracks
    [<DMTG-form>]   // Optional ToolGraph
    [<DMAP-form>]   // Optional Audio Path
)

    // <segh-ck>        
    'segh'
    (
        <DMUS_IO_SEGMENT_HEADER>
    )
    
    // <guid-ck>
    'guid'
    (
        <GUID>
    )

    // <vers-ck>
    vers
    (
        <DMUS_IO_VERSION>
    )

    // <trkl-list>
    LIST
    (
        'trkl'          // Array of tracks
        <DMTK-form>...  // Each track is encapsulated in a RIFF chunk
    )

    // <DMTK-form>      // Tracks can be embedded in a segment or stored as separate files.
    RIFF
    (
        'DMTK'
        <trkh-ck>
        [<trkx-ck>]     // Optional track flags. 
        [<guid-ck>]     // Optional GUID for track object instance (not to be confused with Class id in track header)
        [<vers-ck>]     // Optional version info
        [<UNFO-list>]   // Optional name, author, copyright info., comments
        [<data>]        // Track data. Must be a RIFF readable chunk.
    )

    // <trkh-ck>            // Track header chunk
    (
        'trkh'
        <DMUS_IO_TRACK_HEADER>  // Track header
    )

    // <trkx-ck>            // Track flags chunk
    (
        'trkx'
        <DMUS_IO_TRACK_EXTRAS_HEADER>  // DX8 Track flags header
    )
*)

(*  File io for DirectMusic Song object *)
(*  Note: Song file format is not supported in DX8. *)

(* RIFF ids: *)
const
  DMUS_FOURCC_SONG_FORM          : mmioFOURCC = ('D','M','S','O'); (* Entire song. *)
  DMUS_FOURCC_SONG_CHUNK         : mmioFOURCC = ('s','n','g','h'); (* Song header info. *)
  DMUS_FOURCC_SONGSEGMENTS_LIST  : mmioFOURCC = ('s','e','g','l'); (* List of embedded segments. *)
  DMUS_FOURCC_SONGSEGMENT_LIST   : mmioFOURCC = ('s','s','g','l'); (* Container for a segment or segment reference. *)
  DMUS_FOURCC_TOOLGRAPHS_LIST    : mmioFOURCC = ('t','l','g','l'); (* List of embedded tool graphs. *)
  DMUS_FOURCC_SEGREFS_LIST       : mmioFOURCC = ('s','r','s','l'); (* List of segment references. *)
  DMUS_FOURCC_SEGREF_LIST        : mmioFOURCC = ('s','g','r','l'); (* Container for a segment reference. *)
  DMUS_FOURCC_SEGREF_CHUNK       : mmioFOURCC = ('s','g','r','h'); (* Segment reference header. *)
  DMUS_FOURCC_SEGTRANS_CHUNK     : mmioFOURCC = ('s','t','r','h'); (* Set of transitions to this segment. *)
  DMUS_FOURCC_TRACKREFS_LIST     : mmioFOURCC = ('t','r','s','l'); (* Set of track references within the segment reference. *)
  DMUS_FOURCC_TRACKREF_LIST      : mmioFOURCC = ('t','k','r','l'); (* Container for a track reference. *)
  DMUS_FOURCC_TRACKREF_CHUNK     : mmioFOURCC = ('t','k','r','h'); (* Track reference header. *)

(* io structures:*)
type
  TDMUS_IO_SONG_HEADER = packed record
    dwFlags      : DWORD;
    dwStartSegID : DWORD;   (* Id of the segment that starts playback. *)
  end;

  TDMUS_IO_SEGREF_HEADER = packed record
    dwID          : DWORD;  (* Each has a unique ID. Must be less than DMUS_SONG_MAXSEGID. *)
    dwSegmentID   : DWORD;  (* Optional segment to link to. *)
    dwToolGraphID : DWORD;  (* Optional tool graph to use for processing. *)
    dwFlags       : DWORD;  (* Various control flags. Currently reserved for future use. Must be 0. *)
    dwNextPlayID  : DWORD;  (* ID of next segment, to chain segments into a song. *)
  end;

  TDMUS_IO_TRACKREF_HEADER = packed record
    dwSegmentID : DWORD;    (* Which segment to find this in. *)
    dwFlags     : DWORD;    (* Reference control flags. *)
  end;

(*  Transition definition chunk defines a transition, using an optional transition template
    segment.
*)
  TDMUS_IO_TRANSITION_DEF = packed record
    dwSegmentID    : DWORD;     (* Segment the transition goes to. *)
    dwTransitionID : DWORD;     (* Template segment to use for the transition. *)
    dwPlayFlags    : DWORD;     (* Flags to use for transition. *)
  end;

const
  DMUS_SONG_MAXSEGID      = $7FFFFFFF;  (* Segment ids can not go higher than this. *)
  DMUS_SONG_ANYSEG        = $80000000;  (* Special ID to indicate any segment. *)
  DMUS_SONG_NOSEG         = $FFFFFFFF;  (* Special ID to indicate no segment. *)
  DMUS_SONG_NOFROMSEG     = $80000001;  (* Special ID for dwSegmentID to indicate transition from nothing (or outside the song) into this segment. *)

(*
RIFF
(
    'DMSO'          // DirectMusic Song chunk
    <sngh-ck>       // Song header chunk
    [<guid-ck>]     // GUID for song
    [<vers-ck>]     // Optional version info
    [<UNFO-list>]   // Name, author, copyright info., comments
    [<DMCN-form>]   // Optional container of objects embedded in file. Must precede segment list.
    <segl-list>     // List of Segments
    [<tlgl-list>]   // Optional list of ToolGraphs
    [<DMAP-form>]   // Optional Audio Path - to be shared by all segments in song.
    <srsl-list>     // List of segment references.
)

    // <sngh-ck>        
    'sngh'
    (
        <DMUS_IO_SONG_HEADER>
    )
    
    // <segl-list>
    LIST
    (
        'segl'          // Array of segments
        <ssgl-list>...  // Each segment is wrapped in this.
    )

    // <ssgl-list>
    LIST
    (
        'ssgl'          // Segment container.
        [DMSG-form]     // Each segment is either a full embedded segment RIFF form.
        [DMRF-list]     // Or a reference to an external segment.
    )

    // <tlgl-list>
    LIST
    (
        'tlgl'          // Array of toolgraphs
        <DMTG-form>...  // Each toolgraph is a full RIFF form.
    )

    // <srsl-list>
    LIST
    (
        'srsl'          // Array of segment references
        <sgrl-list>...  // Each segment reference is contained in a RIFF list.
    )

    // <sgrl-list>      // Segment reference container.
    LIST
    (
        'sgrl'
        <sgrh-ck>       // Segment reference header chunk.
        <segh-ck>       // Segment header chunk. Defines the segment. 
        <UNFO-list>     // Name, author, etc. Primarily for name, though, which is required for Song->GetSegment().
        [<strh-ck>]     // Segment transition chunk. Defines how to do transitions from other segments.
        [<trsl-list>]   // List of track references, to create a segment from tracks in multiple segments.
    )

    // <sgrh-ck>        // Segment reference header chunk
    (
        'sgrh'
        <DMUS_IO_SEGREF_HEADER>  // Segment reference header
    )

    // <strh-ck>        // Segment transition chunk. 
    (
        'strh'
        <DMUS_IO_TRANSITION_DEF>    // Default transition.
        <DMUS_IO_TRANSITION_DEF>... // Additional transitions.
    )

    // <trsl-list>      // Array of track references
    (
        'trsl'
        <tkrl-list>...  // Each track reference is multiple chunks in a tkrl list.
    )

    // <tkrl-list>      // Track reference container
    (
        'tkrl'
        <tkrh-ck>       // Track reference header chunk.
        <trkh-ck>       // Normal track header chunk.
        [<trkx-ck>]     // Optional track flags. 
    )

    // <tkrh-ck>        // Track reference header chunk
    (
        'tkrh'
        <DMUS_IO_TRACKREF_HEADER>  // Track reference header
    )
*)

(*  File io for DirectMusic reference chunk.
    This is used to embed a reference to an object.
*)

(*  RIFF ids: *)
const
  DMUS_FOURCC_REF_LIST        : mmioFOURCC = ('D','M','R','F');
  DMUS_FOURCC_REF_CHUNK       : mmioFOURCC = ('r','e','f','h');
  DMUS_FOURCC_DATE_CHUNK      : mmioFOURCC = ('d','a','t','e');
  DMUS_FOURCC_NAME_CHUNK      : mmioFOURCC = ('n','a','m','e');
  DMUS_FOURCC_FILE_CHUNK      : mmioFOURCC = ('f','i','l','e');

type
  TDMus_IO_Reference = packed record
    guidClassID: TGUID;      (* Class id is always required. *)
    dwValidData: DWORD;      (* Flags. *)
  end;

(*
LIST
(
    'DMRF'          // DirectMusic Reference chunk
    <refh-ck>       // Reference header chunk
    [<guid-ck>]     // Optional object GUID.
    [<date-ck>]     // Optional file date.
    [<name-ck>]     // Optional name.
    [<file-ck>]     // Optional file name.
    [<catg-ck>]     // Optional category name.
    [<vers-ck>]     // Optional version info.
)

    // <refh-ck>
    'refh'
    (
        <DMUS_IO_REFERENCE>
    )

    // <guid-ck>
    'guid'
    (
        <GUID>
    )

    // <date-ck>
    date
    (
        <FILETIME>
    )

    // <name-ck>
    name
    (
        // Name, stored as NULL terminated string of WCHARs
    )

    // <file-ck>
    file
    (
        // File name, stored as NULL terminated string of WCHARs
    )

    // <catg-ck>
    catg
    (
        // Category name, stored as NULL terminated string of WCHARs
    )

    // <vers-ck>
    vers
    (
        <DMUS_IO_VERSION>
    )
*)

(* Chord Maps *)
const
(* runtime chunks *)
  DMUS_FOURCC_CHORDMAP_FORM       : mmioFOURCC = ('D','M','P','R');
  DMUS_FOURCC_IOCHORDMAP_CHUNK    : mmioFOURCC = ('p','e','r','h');
  DMUS_FOURCC_SUBCHORD_CHUNK      : mmioFOURCC = ('c','h','d','t');
  DMUS_FOURCC_CHORDENTRY_CHUNK    : mmioFOURCC = ('c','h','e','h');
  DMUS_FOURCC_SUBCHORDID_CHUNK    : mmioFOURCC = ('s','b','c','n');
  DMUS_FOURCC_IONEXTCHORD_CHUNK   : mmioFOURCC = ('n','c','r','d');
  DMUS_FOURCC_NEXTCHORDSEQ_CHUNK  : mmioFOURCC = ('n','c','s','q');
  DMUS_FOURCC_IOSIGNPOST_CHUNK    : mmioFOURCC = ('s','p','s','h');
  DMUS_FOURCC_CHORDNAME_CHUNK     : mmioFOURCC = ('I','N','A','M');

(* runtime list chunks *)
  DMUS_FOURCC_CHORDENTRY_LIST     : mmioFOURCC = ('c','h','o','e');
  DMUS_FOURCC_CHORDMAP_LIST       : mmioFOURCC = ('c','m','a','p');
  DMUS_FOURCC_CHORD_LIST          : mmioFOURCC = ('c','h','r','d');
  DMUS_FOURCC_CHORDPALETTE_LIST   : mmioFOURCC = ('c','h','p','l');
  DMUS_FOURCC_CADENCE_LIST        : mmioFOURCC = ('c','a','d','e');
  DMUS_FOURCC_SIGNPOSTITEM_LIST   : mmioFOURCC = ('s','p','s','t');

  DMUS_FOURCC_SIGNPOST_LIST       : mmioFOURCC = ('s','p','s','q');

(* values for dwChord field of DMUS_IO_PERS_SIGNPOST *)
(* DMUS_SIGNPOSTF_ flags are also used in templates (DMUS_IO_SIGNPOST) *)
  DMUS_SIGNPOSTF_A       = 1;
  DMUS_SIGNPOSTF_B       = 2;
  DMUS_SIGNPOSTF_C       = 4;
  DMUS_SIGNPOSTF_D       = 8;
  DMUS_SIGNPOSTF_E       = $10;
  DMUS_SIGNPOSTF_F       = $20;
  DMUS_SIGNPOSTF_LETTER  = (DMUS_SIGNPOSTF_A or DMUS_SIGNPOSTF_B or DMUS_SIGNPOSTF_C or DMUS_SIGNPOSTF_D or DMUS_SIGNPOSTF_E or DMUS_SIGNPOSTF_F);
  DMUS_SIGNPOSTF_1       = $100;
  DMUS_SIGNPOSTF_2       = $200;
  DMUS_SIGNPOSTF_3       = $400;
  DMUS_SIGNPOSTF_4       = $800;
  DMUS_SIGNPOSTF_5       = $1000;
  DMUS_SIGNPOSTF_6       = $2000;
  DMUS_SIGNPOSTF_7       = $4000;
  DMUS_SIGNPOSTF_ROOT    = (DMUS_SIGNPOSTF_1 or DMUS_SIGNPOSTF_2 or DMUS_SIGNPOSTF_3 or DMUS_SIGNPOSTF_4 or DMUS_SIGNPOSTF_5 or DMUS_SIGNPOSTF_6 or DMUS_SIGNPOSTF_7);
  DMUS_SIGNPOSTF_CADENCE = $8000;

(* values for dwFlags field of DMUS_IO_CHORDMAP *)
  DMUS_CHORDMAPF_VERSION8 = 1;   (* Chordmap is version 8 or above. *)

(* values for dwChord field of DMUS_IO_PERS_SIGNPOST *)
  DMUS_SPOSTCADENCEF_1 = 2;   (* Use the first cadence chord. *)
  DMUS_SPOSTCADENCEF_2 = 4;   (* Use the second cadence chord. *)

type
(* run time data structs *)
  TDMus_IO_ChordMap = packed record
    wszLoadName: array [0..19] of WCHAR;
    dwScalePattern: DWORD;
    dwFlags:        DWORD;
  end;

  TDMus_IO_ChordMap_SubChord = packed record
    dwChordPattern:  DWORD;
    dwScalePattern:  DWORD;
    dwInvertPattern: DWORD;
    bChordRoot:      BYTE;
    bScaleRoot:      BYTE;
    wCFlags:         WORD;
    dwLevels:        DWORD;    (* parts or which subchord levels this chord supports *)
  end;

(* Legacy name... *)
  TDMus_IO_Pers_SubChord = TDMus_IO_ChordMap_SubChord;

  TDMus_IO_ChordEntry = packed record
    dwFlags:       DWORD;
    wConnectionID: WORD;     (* replaces runtime "pointer to this" *)
  end;

  TDMus_IO_NextChord = packed record
    dwFlags:       DWORD;
    nWeight:       WORD;
    wMinBeats:     WORD;
    wMaxBeats:     WORD;
    wConnectionID: WORD;     (* points to an ioChordEntry *)
  end;

  TDMus_IO_ChordMap_SignPost = packed record
    dwChords: DWORD;     (* 1bit per group *)
    dwFlags:  DWORD;
  end;

(* Legacy name... *)
  TDMus_IO_Pers_SignPost = TDMus_IO_ChordMap_SignPost;

(*
RIFF
(
    'DMPR'
    <perh-ck>           // Chord map header chunk
    [<guid-ck>]         // guid chunk
    [<vers-ck>]         // version chunk (two DWORDS)
    [<UNFO-list>]       // Unfo chunk
    <chdt-ck>           // subchord database
    <chpl-list>         // chord palette
    <cmap-list>         // chord map
    <spsq-list>         // signpost list
 )

<cmap-list> ::= LIST('cmap' <choe-list> )

<choe-list> ::= LIST('choe'
                                <cheh-ck>   // chord entry data
                                <chrd-list> // chord definition
                                <ncsq-ck>   // connecting(next) chords
                     )

<chrd-list> ::= LIST('chrd' 
                                <INAM-ck>   // name of chord in wide char format
                                <sbcn-ck>   // list of subchords composing chord
                    )

<chpl-list> ::= LIST('chpl' 
                                <chrd-list> ... // chord definition
                    )

<spsq-list> ::== LIST('spsq' <spst-list> ... )

<spst-list> ::= LIST('spst'
                             <spsh-ck>
                             <chrd-list>
                             [<cade-list>]
                    )

<cade-list> ::= LIST('cade' <chrd-list> ...)

<perh-ck> ::= perh(<DMUS_IO_CHORDMAP>)

<chdt-ck> ::= chdt(<cbChordSize::WORD>
                   <DMUS_IO_PERS_SUBCHORD> ... )

<cheh-ck> ::= cheh(<DMUS_IO_CHORDENTRY>)

<sbcn-ck> ::= sbcn(<cSubChordID:WORD> ...)

<ncsq-ck> ::= ncsq(<wNextChordSize:WORD> 
                   <DMUS_IO_NEXTCHORD>...)

<spsh-ck> ::= spsh(<DMUS_IO_PERS_SIGNPOST>)

*)

(*  File io for DirectMusic Script object *)

(* RIFF ids: *)
const
  DMUS_FOURCC_SCRIPT_FORM            : mmioFOURCC = ('D','M','S','C');
  DMUS_FOURCC_SCRIPT_CHUNK           : mmioFOURCC = ('s','c','h','d');
  DMUS_FOURCC_SCRIPTVERSION_CHUNK    : mmioFOURCC = ('s','c','v','e');
  DMUS_FOURCC_SCRIPTLANGUAGE_CHUNK   : mmioFOURCC = ('s','c','l','a');
  DMUS_FOURCC_SCRIPTSOURCE_CHUNK     : mmioFOURCC = ('s','c','s','r');

(* io structures:*)
type
  TDMUS_IO_SCRIPT_HEADER = packed record
    dwFlags : DWORD; (* DMUS_SCRIPTIOF_ flags *)
  end;

const
  DMUS_SCRIPTIOF_LOAD_ALL_CONTENT      = (1 shl 0);
    (* If set, when the script loads it will also load all the content in its container. *)
  DMUS_SCRIPTIOF_DOWNLOAD_ALL_SEGMENTS = (1 shl 1);
    (* If set and LOAD_ALL_CONTENT is also set, when the script initializes it will also download all the segments in its container.
       If set and LOAD_ALL_CONTENT is not set, when the script calls segment.Load on a segment then the segment will also be downloaded.
       If not set, the script must manually download and unload by calling segment.DownloadSoundData and segment.UnloadSoundData. *)


(*
RIFF
(
    'DMSC'              // DirectMusic Script chunk
    <schd-ck>           // Script header chunk
    [<guid-ck>]         // GUID for script
    [<vers-ck>]         // Optional version info
    [<UNFO-list>]       // Name, author, copyright info., comments
    <scve-ck>           // Version of DirectMusic this script was authored to run against
    <DMCN-form>         // Container of content referenced by the script.
    <scla-ck>           // ActiveX scripting language in which the script is written
    <scsr-ck> or <DMRF> // The script's source code.
                        // If scsr-ck, the source is embedding in the chunk.
                        // If DMRF, it is a reference of where to find a text file with the source.
                        //    Class id (guidClassID in DMUS_IO_REFERENCE) must be GUID_NULL because
                        //    this text file is not a DirectMusic object in its own right.
)

    // <schd-ck>
    'schd'
    (
        <DMUS_FOURCC_SCRIPT_CHUNK>
    )
    
    // <guid-ck>
    'guid'
    (
        <GUID>
    )

    // <vers-ck>
    vers
    (
        <DMUS_IO_VERSION>
    )

    // <scve-ck>
    scve
    (
        <DMUS_IO_VERSION>
    )

    'scla'
    (
        // Language name, stored as NULL terminated string of WCHARs
    )

    'scsr'
    (
        // Source code, stored as NULL terminated string of WCHARs
    )
*)

(* Signpost tracks *)
const
  DMUS_FOURCC_SIGNPOST_TRACK_CHUNK    : mmioFOURCC = ( 's', 'g', 'n', 'p' );

type
  TDMus_IO_SignPost = packed record
    mtTime   : TMusic_Time;
    dwChords : DWORD;
    wMeasure : WORD;
  end;

(*

    // <sgnp-list>
    'sgnp'
    (
        //sizeof DMUS_IO_SIGNPOST: DWORD
        <DMUS_IO_SIGNPOST>...
    )

*)

const
  DMUS_FOURCC_MUTE_CHUNK  : mmioFOURCC = ('m','u','t','e');

type
  TDMus_IO_Mute = packed record
    mtTime: TMusic_Time;
    dwPChannel:    DWORD;
    dwPChannelMap: DWORD;
  end;

(*

    // <mute-list>
    'mute'
    (
        //sizeof DMUS_IO_MUTE:DWORD
        <DMUS_IO_MUTE>...
    )


*)

const
(* Used for both style and chord map tracks *)

  DMUS_FOURCC_TIME_STAMP_CHUNK   : mmioFOURCC = ('s', 't', 'm', 'p');

(* Style tracks *)

  DMUS_FOURCC_STYLE_TRACK_LIST   : mmioFOURCC = ('s', 't', 't', 'r');
  DMUS_FOURCC_STYLE_REF_LIST     : mmioFOURCC = ('s', 't', 'r', 'f');

(*

    // <sttr-list>
    LIST('sttr'
    (
        // some number of <strf-list>
    )

    // <strf-list>
    LIST('strf'
    (
        <stmp-ck>
        <DMRF>
    )

    // <stmp-ck> defined in ..\dmcompos\dmcompp.h

*)

(* Chord map tracks *)

  DMUS_FOURCC_PERS_TRACK_LIST : mmioFOURCC = ('p', 'f', 't', 'r');
  DMUS_FOURCC_PERS_REF_LIST   : mmioFOURCC = ('p', 'f', 'r', 'f');

(*

    // <pftr-list>
    LIST('pftr'
    (
        // some number of <pfrf-list>
    )

    // <pfrf-list>
    LIST('pfrf'
    (
        <stmp-ck>
        <DMRF>
    )

  // <stmp-ck>
  'stmp'
  (
    // time:DWORD
  )



*)

  DMUS_FOURCC_TEMPO_TRACK    : mmioFOURCC = ('t','e','t','r');

(*
    // tempo list
    'tetr'
    (
        // sizeof DMUS_IO_TEMPO_ITEM: DWORD
        <DMUS_IO_TEMPO_ITEM>...
    )
  *)

  DMUS_FOURCC_SEQ_TRACK      : mmioFOURCC = ('s','e','q','t');
  DMUS_FOURCC_SEQ_LIST       : mmioFOURCC = ('e','v','t','l');
  DMUS_FOURCC_CURVE_LIST     : mmioFOURCC = ('c','u','r','l');

(*
    // sequence track
    'seqt'
    (
        // sequence list
        'evtl'
        (
            // sizeof DMUS_IO_SEQ_ITEM: DWORD
            <DMUS_IO_SEQ_ITEM>...
        )
        // curve list
        'curl'
        (
            // sizeof DMUS_IO_CURVE_ITEM: DWORD
            <DMUS_IO_CURVE_ITEM>...
        )
    )
*)

  DMUS_FOURCC_SYSEX_TRACK    : mmioFOURCC = ('s','y','e','x');

(*
    // sysex track
    'syex'
    (
        // list of:
        // {
        //      <DMUS_IO_SYSEX_ITEM>
        //      sys-ex: data
        // }...
    )
*)

  DMUS_FOURCC_TIMESIGNATURE_TRACK : mmioFOURCC = ('t','i','m','s');

(*
    // time signature track
    'tims'
    (
        // size of DMUS_IO_TIMESIGNATURE_ITEM : DWORD
        <DMUS_IO_TIMESIGNATURE_ITEM>...
    )
*)

type
  TDMUS_IO_TIMESIGNATURE_ITEM = packed record
    lTime            : TMusic_Time;
    bBeatsPerMeasure : BYTE;   (* beats per measure (top of time sig) *)
    bBeat            : BYTE;   (* what note receives the beat (bottom of time sig.) *)
                               (* we can assume that 0 means 256th note *)
    wGridsPerBeat    : WORD;   (* grids per beat *)
  end;

(*  DX6 time signature track
    
    'tims'
    (
        // size of DMUS_IO_TIMESIGNATURE_ITEM : DWORD
        <DMUS_IO_TIMESIGNATURE_ITEM>...
    )
*)

(*  DX8 Time signature track. The track has been updated from DX7 to support a list of
    RIFF chunks. This will allow the time signature track to expand in the future.
*)

const
 DMUS_FOURCC_TIMESIGTRACK_LIST   : mmioFOURCC = ('T','I','M','S');
 DMUS_FOURCC_TIMESIG_CHUNK       : mmioFOURCC = ('t','i','m','s'); // = DMUS_FOURCC_TIMESIGNATURE_TRACK;

(*
LIST
(
    'TIMS'          // Time Signature Track list-type
    <tims-ck>       // Chunk containing an array of time signatures
)

    'tims'
    (
        // size of DMUS_IO_TIMESIGNATURE_ITEM : DWORD
        <DMUS_IO_TIMESIGNATURE_ITEM>...
    )
 
*)

(*  DX8 Marker track. This is used to store valid start points and other
    flow control parameters that may come later. For example, if we want
    to implement more sophisticated looping and branching constructs, they
    would live in this track.
*)
const
  DMUS_FOURCC_MARKERTRACK_LIST   : mmioFOURCC = ('M','A','R','K');
  DMUS_FOURCC_VALIDSTART_CHUNK   : mmioFOURCC = ('v','a','l','s');
  DMUS_FOURCC_PLAYMARKER_CHUNK   : mmioFOURCC = ('p','l','a','y');

(* io structures *)
type
  TDMUS_IO_VALID_START = packed record
    mtTime : TMusic_Time;      (* Time of a legal start. *)
  end;

  TDMUS_IO_PLAY_MARKER = packed record
    mtTime : TMusic_Time;      (* Time of a next legal play point marker. *)
  end;

(*
LIST
(
    'MARK'          // Marker Track list-type
    [<vals-ck>]     // Chunk containing an array of start points
    [<play-ck>]     // Chunk containing an array of play start markers
)

    'vals'
    (
        // size of DMUS_IO_VALID_START : DWORD
        <DMUS_IO_VALID_START>...
    )

    'play'
    (
        // size of DMUS_IO_PLAY_MARKER : DWORD
        <DMUS_IO_PLAY_MARKER>...
    )
  
*)

(* segment trigger tracks *)

(* RIFF ids: *)
const
  DMUS_FOURCC_SEGTRACK_LIST                  : mmioFOURCC = ('s','e','g','t');
  DMUS_FOURCC_SEGTRACK_CHUNK                 : mmioFOURCC = ('s','g','t','h');
  DMUS_FOURCC_SEGMENTS_LIST                  : mmioFOURCC = ('l','s','g','l');
  DMUS_FOURCC_SEGMENT_LIST                   : mmioFOURCC = ('l','s','e','g');
  DMUS_FOURCC_SEGMENTITEM_CHUNK              : mmioFOURCC = ('s','g','i','h');
  DMUS_FOURCC_SEGMENTITEMNAME_CHUNK          : mmioFOURCC = ('s','n','a','m');

(* io structures *)
type
  TDMUS_IO_SEGMENT_TRACK_HEADER = packed record
    dwFlags : DWORD; (* Reserved leave as 0. *)
  end;

  TDMUS_IO_SEGMENT_ITEM_HEADER = packed record
    lTimeLogical  : TMusic_Time;    (* Position in track list. Time in the music with which the event is associated. *)
    lTimePhysical : TMusic_Time;    (* Precise time event will be triggered. Should be close to logical time. *)
    dwPlayFlags   : DWORD;          (* Flags for PlaySegment(). *)
    dwFlags       : DWORD;          (* Flags. *)
  end;

(* values for dwflags field of DMUS_IO_SEGMENT_ITEM_HEADER *)
const
 DMUS_SEGMENTTRACKF_MOTIF       = 1;  (* interpret DMRF as link to style, and use snam as the name of a motif within the style *)

(*
LIST
(
    'segt'          // DirectMusic Segment Trigger Track form-type
    [<sgth-ck>]     // Segment track header
    <lsgl-list>     // List of Segment Lists
)

    // <sgth-ck>
    'sgth'
    (
        <DMUS_IO_SEGMENT_TRACK_HEADER>
    )

    // <lsgl-list>
    LIST
    (
        'lsgl'          // Array of segments
        <lseg-list>...  // Each segment is encapsulated in a list (that way it can still be riff parsed.)
    )

        // <lseg-list>
        LIST
        (
            'lseg'
            <sgih-ck>
            <DMRF-list>    // Link to a segment or style file.
            [<snam-ck>]    // Name field.  Used with DMUS_SEGMENTTRACKF_MOTIF flag.
        )

            // <sgih-ck>            // segment item header
            (
                <DMUS_IO_SEGMENT_ITEM_HEADER>  // Segment item header
            )

            // <snam-ck>
            (
                // Name, stored as NULL terminated string of WCHARs
            )
*)

(* Script track. *)

(* RIFF ids: *)
  DMUS_FOURCC_SCRIPTTRACK_LIST               : mmioFOURCC = ('s','c','r','t');
  DMUS_FOURCC_SCRIPTTRACKEVENTS_LIST         : mmioFOURCC = ('s','c','r','l');
  DMUS_FOURCC_SCRIPTTRACKEVENT_LIST          : mmioFOURCC = ('s','c','r','e');
  DMUS_FOURCC_SCRIPTTRACKEVENTHEADER_CHUNK   : mmioFOURCC = ('s','c','r','h');
  DMUS_FOURCC_SCRIPTTRACKEVENTNAME_CHUNK     : mmioFOURCC = ('s','c','r','n');

(* Flags for DMUS_IO_SCRIPTTRACK_TIMING
 *)
  DMUS_IO_SCRIPTTRACKF_PREPARE = (1 shl 0);        (* Fire event in advance of time stamp, at Prepare time.  This is the default because it leaves the script time to change the music happening at the target time. *)
  DMUS_IO_SCRIPTTRACKF_QUEUE   = (1 shl 1);        (* Fire event just before time stamp, at Queue time. *)
  DMUS_IO_SCRIPTTRACKF_ATTIME  = (1 shl 2);        (* Fire event right at the time stamp. *)

type
  TDMUS_IO_SCRIPTTRACK_EVENTHEADER = packed record
    dwFlags       : DWORD;         (* various bits (see DMUS_IO_SCRIPTTRACKF_*)
    lTimeLogical  : TMusic_Time;   (* Position in track list. Time in the music with which the event is associated. *)
    lTimePhysical : TMusic_Time;   (* Precise time event will be triggered. Should be close to logical time. *)
  end;

(*
    // Script Track

    // <scrt-list>
    LIST
    (
        <scrl-list>       // List of script events
    )

        // <scrl-list>
        LIST
        (
            <scre-list>...    // Array of event descriptions
        )

            // <scre-list>
            LIST
            (
                <scrh-ck>         // Event header chunk
                <DMRF>
                <scrn-ck>         // Routine name
            )

                'scrh'
                (
                    <DMUS_IO_SCRIPTTRACK_EVENTHEADER>
                )

                'scrn'
                (
                    // Name, stored as NULL terminated string of WCHARs
                )
*)

(* Lyrics/Notification track. *)

(* RIFF ids: *)
const
  DMUS_FOURCC_LYRICSTRACK_LIST               : mmioFOURCC = ('l','y','r','t');
  DMUS_FOURCC_LYRICSTRACKEVENTS_LIST         : mmioFOURCC = ('l','y','r','l');
  DMUS_FOURCC_LYRICSTRACKEVENT_LIST          : mmioFOURCC = ('l','y','r','e');
  DMUS_FOURCC_LYRICSTRACKEVENTHEADER_CHUNK   : mmioFOURCC = ('l','y','r','h');
  DMUS_FOURCC_LYRICSTRACKEVENTTEXT_CHUNK     : mmioFOURCC = ('l','y','r','n');

type
  TDMUS_IO_LYRICSTRACK_EVENTHEADER = packed record
    dwFlags       : DWORD;        (* Reserved leave as 0. *)
    dwTimingFlags : DWORD;        (* Combination DMUS_PMSGF_TOOL_* flags.  Determines the precise timing of when the notification happens. Invalid with the flag DMUS_PMSGF_REFTIME, DMUS_PMSGF_MUSICTIME, DMUS_PMSGF_TOOL_FLUSH, or DMUS_PMSGF_LOCKTOREFTIME. *)
    lTimeLogical  : TMusic_Time;  (* Position in track list. Time in the music with which the event is associated. *)
    lTimePhysical : TMusic_Time;  (* Precise time event will be triggered. Should be close to logical time. *)
  end;

(*
    // Lyrics/Notification Track

    // <lyrt-list>
    LIST
    (
        <lyrl-list>       // List of notification events
    )

        // <lyrl-list>
        LIST
        (
            <lyre-list>...    // Array of event descriptions
        )

            // <lyre-list>
            LIST
            (
                <lyrh-ck>         // Event header chunk
                <lyrn-ck>         // Notification text
            )

                'lyrh'
                (
                    <DMUS_IO_LYRICSTRACK_EVENTHEADER>
                )

                'lyrn'
                (
                    // Name, stored as NULL terminated string of WCHARs
                )
*)

(* Parameter control track *)

(* RIFF ids: *)
const
  DMUS_FOURCC_PARAMCONTROLTRACK_TRACK_LIST           : mmioFOURCC = ('p','r','m','t');
  DMUS_FOURCC_PARAMCONTROLTRACK_OBJECT_LIST          : mmioFOURCC = ('p','r','o','l');
  DMUS_FOURCC_PARAMCONTROLTRACK_OBJECT_CHUNK         : mmioFOURCC = ('p','r','o','h');
  DMUS_FOURCC_PARAMCONTROLTRACK_PARAM_LIST           : mmioFOURCC = ('p','r','p','l');
  DMUS_FOURCC_PARAMCONTROLTRACK_PARAM_CHUNK          : mmioFOURCC = ('p','r','p','h');
  DMUS_FOURCC_PARAMCONTROLTRACK_CURVES_CHUNK         : mmioFOURCC = ('p','r','c','c');

type
  TDMUS_IO_PARAMCONTROLTRACK_OBJECTHEADER = packed record
    dwFlags        : DWORD;        (* Reserved.  Must be zero. *)
    guidTimeFormat : TGUID;        (* Time format to set the object to.  Must be GUID_TIME_REFERNCE or GUID_TIME_MUSIC from medparam.h. *)
    (* Path for finding the object. These fields correspond to the first five parameters of IDirectMusicSegmentState::GetObjectInPath. *)
    dwPChannel     : DWORD;
    dwStage        : DWORD;
    dwBuffer       : DWORD;
    guidObject     : TGUID;
    dwIndex        : DWORD;
  end;

  TDMUS_IO_PARAMCONTROLTRACK_PARAMHEADER = packed record
    dwFlags : DWORD;              (* Reserved.  Must be zero. *)
    dwIndex : DWORD;              (* Index number of the parameter on the object *)
  end;

  TDMUS_IO_PARAMCONTROLTRACK_CURVEINFO = packed record
    mtStartTime   : TMusic_Time;
    mtEndTime     : TMusic_Time;
    fltStartValue : Single;
    fltEndValue   : Single;
    dwCurveType   : DWORD;   (* One of the items from the MP_CURVE_TYPE enum in medparam.h *)
    dwFlags       : DWORD;   (* A combination of the MPF_ENVLP_* constants in medparam.h *)
  end;

(*
    // <prmt-list>
    LIST
    (
        <prol-list>...   // one for each object
    )

        // <prol-list>
        LIST
        (
            <proh-ck>       // object header chunk
            <prpl-list>...  // one for each parameter
        )

            // <proh-ck>
            proh
            (
                <DMUS_IO_PARAMCONTROLTRACK_OBJECTHEADER>
            )

            // <prpl-list>
            LIST
            (
                <prph-ck>       // parameter header chunk
                <prcc-ck>       // chunk containing an array of curves
            )

                // <prph-ck>
                prph
                (
                    <DMUS_IO_PARAMCONTROLTRACK_PARAMHEADER>
                )

                // <prcc-ck>
                prcc
                (
                    // sizeof DMUS_IO_PARAMCONTROLTRACK_CURVEINFO:DWORD
                    <DMUS_IO_PARAMCONTROLTRACK_CURVEINFO>... // curves, sorted in order of mtTime
                )
*)

(* Melody formulation track *)
(* Note: Melody formulation file format is not supported in DX8. *)
const
  DMUS_FOURCC_MELODYFORM_TRACK_LIST    : mmioFOURCC = ( 'm', 'f', 'r', 'm' );
  DMUS_FOURCC_MELODYFORM_HEADER_CHUNK  : mmioFOURCC = ( 'm', 'l', 'f', 'h' );
  DMUS_FOURCC_MELODYFORM_BODY_CHUNK    : mmioFOURCC = ( 'm', 'l', 'f', 'b' );

type
  TDMUS_IO_MELFORM = packed record
    dwPlaymode : DWORD;       (* NOT CURRENTLY USED - MUST BE 0 *)   
  end;

(*
    // <mfrm-list>
    LIST
    (
        'mfrm'
        <mlfh-ck>       // Melody formulation header chunk
        <mlfb-ck>       // Melody formulation body chunk
    )

    // <mlfb-ck>
    'mlfb'
    (
        <DMUS_IO_MELFORM>
    )

  // <mlfb-ck>
    'mlfb'
    (
        //sizeof DMUS_IO_MELODY_FRAGMENT: DWORD
        <DMUS_IO_MELODY_FRAGMENT>...
    )

*)

(* DirectSoundBufferConfig FX Map *)

(* RIFF ids: *)
const
  DMUS_FOURCC_DSBC_FORM      : mmioFOURCC = ('D','S','B','C');
  DMUS_FOURCC_DSBD_CHUNK     : mmioFOURCC = ('d','s','b','d');
  DMUS_FOURCC_BSID_CHUNK     : mmioFOURCC = ('b','s','i','d');
  DMUS_FOURCC_DS3D_CHUNK     : mmioFOURCC = ('d','s','3','d');
  DMUS_FOURCC_DSBC_LIST      : mmioFOURCC = ('f','x','l','s');
  DMUS_FOURCC_DSFX_FORM      : mmioFOURCC = ('D','S','F','X');
  DMUS_FOURCC_DSFX_CHUNK     : mmioFOURCC = ('f','x','h','r');
  DMUS_FOURCC_DSFX_DATA      : mmioFOURCC = ('d','a','t','a');

(* io structures *)
type
  TDSOUND_IO_DSBUFFERDESC = packed record
    dwFlags   : DWORD;     (* DirectSound buffer creation flags *)
    nChannels : WORD;      (* No. of channels (rest of buffer format is determined by owning sink) *)
    lVolume   : Longint;   (* Initial pan; only used if CTRLVOLUME is specified *)
    lPan      : Longint;   (* Initial pan; only used if CTRLPAN is specified *)
    dwReserved: DWORD;     (* Reserved - must be 0 *)
  end;

  TDSOUND_IO_DSBUSID = packed record
    busid : array[0..0] of DWORD;       (* Array size determined from chunk size *)
  end;

  TDSOUND_IO_3D = packed record
    guid3DAlgorithm : TGUID;       (* GUID identifying the 3D algorithm to use (defined in dsound.h) *)
    ds3d            : TDS3DBuffer; (* Initial 3D parameters *)
  end;

  TDSOUND_IO_DXDMO_HEADER = packed record
    dwEffectFlags  : DWORD;  (* Effect creation flags - equivalent to DSEFFECTDESC::dwFlags *)
    guidDSFXClass  : TGUID;  (* GUID identifying the effect to use - corresponds to a COM CLSID *)
    guidReserved   : TGUID;  (* Reserved - must be the null GUID *)
    guidSendBuffer : TGUID;  (* GUID identifying the buffer to send to if this is a send effect *)
    dwReserved     : DWORD;  (* Reserved - must be 0 *)
  end;

  TDSOUND_IO_DXDMO_DATA = packed record
    data : array[0..0] of DWORD;      (* Array size determined by the DMO involved *)
  end;

(*
RIFF
(
    'DSBC'          // DirectSoundBufferConfig chunk
    [<guid-ck>]     // GUID identifier for this DirectSoundBufferConfig
    [<vers-ck>]     // Optional version info
    [<UNFO-list>]   // Name, author, copyright info., comments
    <dsbd-ck>       // DirectSound Buffer descriptor chunk
    [<bsid-ck>]     // Optional bus id array
    [<ds3d-ck>]     // Optional 3d Parameters
    [<fxls-list>]   // Optional list of FX descriptors
)

    // <guid-ck>
    'guid'
    (
        <GUID>
    )

    // <vers-ck>
    'vers'
    (
        <DMUS_IO_VERSION>
    )

    // <dsbd-ck>
    'dsbd'
    (
        <DSOUND_IO_DSBUFFERDESC>  // Creation parameters and initial settings for the buffer
    )

    // <bsid-ck>
    'bsid'
    (
        <DSOUND_IO_DSBUSID>  // The size of DSOUND_IO_DSBUSID is determined by the chunk size 
    )

    // <ds3d-ck>
    'ds3d'
    (
        <DSOUND_IO_3D>  // Initial 3D buffer parameters: position, etc.
    )

    // <fx-list>
    LIST
    (
        'fxls'          // Array of DMO creation parameter blocks
        <DSFX-form>...  // Each DMO is encapsulated in a RIFF chunk
    )

// <DSFX-form>          // DMOs can be embedded in a buffer configuration or stored as separate files
RIFF
(
    'DSFX'
    <fxhr-ck>           // FX header chunk
    [<data-ck>]         // FX initial settings chunk
)

    // <fxhr-ck>
    'fxhr'
    (
        <DSOUND_IO_DXDMO_HEADER>
    )

    // <data-ck>
    'data'
    (
        <DSOUND_IO_DXDMO_DATA>  // Opaque data block used by the DMO to load itself.
        // For our standard included DMOs, this is simply the structure accepted by
        // the DMO's SetAllParameters() method - e.g. struct DSFXChorus for Chorus.
    )
*)


(***************************************************************************
*                                                                          *
*   DMusBuff.h -- This module defines the buffer format for DirectMusic    *
*                 Shared file between user mode and kernel mode components *
*                                                                          *
*   Copyright (c) 1998, Microsoft Corp. All rights reserved.               *
*                                                                          *
***************************************************************************)

(* The number of bytes to allocate for an event with 'cb' data bytes.
 *)
function QWORD_ALIGN(x: DWORD) : DWORD;

function DMUS_EVENT_SIZE(cb: DWORD) : DWORD;

function DMErrorString(Value: HResult): string;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
implementation
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

uses DXCommon;

function DSBUSID_IS_SPKR_LOC(id: integer) : boolean;
begin
  Result := (id >= DSBUSID_FIRST_SPKR_LOC) and (id <= DSBUSID_LAST_SPKR_LOC);
end;

function MAKE_HRESULT(sev,fac,code: DWORD) : HResult;
begin
  Result := (sev shl 31) or (fac shl 16) or code;
end;

function MAKEFOURCC (ch0, ch1, ch2, ch3: Char) : TFourCC;
type
  tfcc = array [0..3] of Char;
begin
  tfcc(Result)[0] := ch0;
  tfcc(Result)[1] := ch1;
  tfcc(Result)[2] := ch2;
  tfcc(Result)[3] := ch3;
end;

function QWORD_ALIGN(x: DWORD) : DWORD;
begin
  Result := (x + 7) and (not 7); //  (((x) + 7) & ~7)
end;

function DMUS_EVENT_SIZE(cb: DWORD) : DWORD;
begin
  Result := QWORD_ALIGN(SizeOf(TDMus_EventHeader) + cb); // QWORD_ALIGN(sizeof(DMUS_EVENTHEADER) + cb)
end;

function DMErrorString(Value: HResult): string;
begin
  case Value of
    HResult(DMUS_S_PARTIALLOAD)                    : Result := 'The object could only load partially. This can happen if some components, such as embedded tracks and tools, '+'are not registered properly. It can also happen if some content is missing; for example, if a segment uses a DLS collection that is not in the loader''s current search directory.';
    HResult(DMUS_S_PARTIALDOWNLOAD)                : Result := 'Return value from IDirectMusicBand::Download() which indicates that some of the instruments safely downloaded, but others failed. This usually occurs when some instruments are on PChannels not supported by the performance or port.';
    HResult(DMUS_S_REQUEUE)                        : Result := 'Return value from IDirectMusicTool::ProcessPMsg() which indicates to the performance that it should cue the PMsg again automatically.';
    HResult(DMUS_S_FREE)                           : Result := 'Return value from IDirectMusicTool::ProcessPMsg() which indicates to the performance that it should free the PMsg automatically.';
    HResult(DMUS_S_END)                            : Result := 'Return value from IDirectMusicTrack::Play() which indicates to the segment that the track has no more data after mtEnd.';
    HResult(DMUS_S_STRING_TRUNCATED)               : Result := 'Returned string has been truncated to fit the buffer size.';
    HResult(DMUS_S_LAST_TOOL)                      : Result := 'Returned from IDirectMusicGraph::StampPMsg(), this indicates that the PMsg is already stamped with the last tool in the graph. The returned PMsg''s tool pointer is now NULL.';
    HResult(DMUS_S_OVER_CHORD)                     : Result := 'Returned from IDirectMusicPerformance::MusicToMIDI(), this indicates that no note has been calculated because the music value has the note at a position higher than the top note of the chord. '+'This applies only to DMUS_PLAYMODE_NORMALCHORD play mode. This success code indicates that the caller should not do anything with the note. It is not meant to be played against this chord.';
    HResult(DMUS_S_UP_OCTAVE)                      : Result := 'Returned from IDirectMusicPerformance::MIDIToMusic(),  and IDirectMusicPerformance::MusicToMIDI(), this indicates that the note conversion generated a note value that is below 0, '+'so it has been bumped up one or more octaves to be in the proper MIDI range of 0 through 127. Note that this is valid for MIDIToMusic() '+'when using play modes DMUS_PLAYMODE_FIXEDTOCHORD and DMUS_PLAYMODE_FIXEDTOKEY, both of which store MIDI values in wMusicValue. With MusicToMIDI(), it is valid for all play modes. Ofcourse, DMUS_PLAYMODE_FIXED will never return this success code.';
    HResult(DMUS_S_DOWN_OCTAVE)                    : Result := 'Returned from IDirectMusicPerformance::MIDIToMusic(),  and IDirectMusicPerformance::MusicToMIDI(), this indicates that the note conversion generated a note value that is above 127, '+'so it has been bumped down one or more octaves to be in the proper MIDI range of 0 through 127. Note that this is valid for MIDIToMusic() '+'when using play modes DMUS_PLAYMODE_FIXEDTOCHORD and DMUS_PLAYMODE_FIXEDTOKEY, both of which store MIDI values in wMusicValue. With MusicToMIDI(), it is valid for all play modes. Ofcourse, DMUS_PLAYMODE_FIXED will never return this success code.';
    HResult(DMUS_S_NOBUFFERCONTROL)                : Result := 'Although the audio output from the port will be routed to the same device as the given DirectSound buffer, buffer controls such as pan and volume will not affect the output.';
    HResult(DMUS_S_GARBAGE_COLLECTED)              : Result := 'The requested operation was not performed because during CollectGarbage the loader determined that the object had been released.';
    HResult(DMUS_E_DRIVER_FAILED)                  : Result := 'An unexpected error was returned from a device driver, indicating possible failure of the driver or hardware.';
    HResult(DMUS_E_PORTS_OPEN)                     : Result := 'The requested operation cannot be performed while there are instantiated ports in any process in the system.';
    HResult(DMUS_E_DEVICE_IN_USE)                  : Result := 'The requested device is already in use (possibly by a non-DirectMusic client) and cannot be opened again.';
    HResult(DMUS_E_INSUFFICIENTBUFFER)             : Result := 'Buffer is not large enough for requested operation.';
    HResult(DMUS_E_BUFFERNOTSET)                   : Result := 'No buffer was prepared for the download data.';
    HResult(DMUS_E_BUFFERNOTAVAILABLE)             : Result := 'Download failed due to inability to access or create download buffer.';
    HResult(DMUS_E_NOTADLSCOL)                     : Result := 'Error parsing DLS collection. File is corrupt.';
    HResult(DMUS_E_INVALIDOFFSET)                  : Result := 'Wave chunks in DLS collection file are at incorrect offsets.';
    HResult(DMUS_E_ALREADY_LOADED)                 : Result := 'Second attempt to load a DLS collection that is currently open. ';
    HResult(DMUS_E_INVALIDPOS)                     : Result := 'Error reading wave data from DLS collection. Indicates bad file.';
    HResult(DMUS_E_INVALIDPATCH)                   : Result := 'There is no instrument in the collection that matches patch number.';
    HResult(DMUS_E_CANNOTSEEK)                     : Result := 'The IStream* doesn''t support Seek().';
    HResult(DMUS_E_CANNOTWRITE)                    : Result := 'The IStream* doesn''t support Write().';
    HResult(DMUS_E_CHUNKNOTFOUND)                  : Result := 'The RIFF parser doesn''t contain a required chunk while parsing file.';
    HResult(DMUS_E_INVALID_DOWNLOADID)             : Result := 'Invalid download id was used in the process of creating a download buffer.';
    HResult(DMUS_E_NOT_DOWNLOADED_TO_PORT)         : Result := 'Tried to unload an object that was not downloaded or previously unloaded.';
    HResult(DMUS_E_ALREADY_DOWNLOADED)             : Result := 'Buffer was already downloaded to synth.';
    HResult(DMUS_E_UNKNOWN_PROPERTY)               : Result := 'The specified property item was not recognized by the target object.';
    HResult(DMUS_E_SET_UNSUPPORTED)                : Result := 'The specified property item may not be set on the target object.';
    HResult(DMUS_E_GET_UNSUPPORTED)                : Result := 'The specified property item may not be retrieved from the target object.';
    HResult(DMUS_E_NOTMONO)                        : Result := 'Wave chunk has more than one interleaved channel. DLS format requires MONO.';
    HResult(DMUS_E_BADARTICULATION)                : Result := 'Invalid articulation chunk in DLS collection.';
    HResult(DMUS_E_BADINSTRUMENT)                  : Result := 'Invalid instrument chunk in DLS collection.';
    HResult(DMUS_E_BADWAVELINK)                    : Result := 'Wavelink chunk in DLS collection points to invalid wave.';
    HResult(DMUS_E_NOARTICULATION)                 : Result := 'Articulation missing from instrument in DLS collection.';
    HResult(DMUS_E_NOTPCM)                         : Result := 'Downoaded DLS wave is not in PCM format. ';
    HResult(DMUS_E_BADWAVE)                        : Result := 'Bad wave chunk in DLS collection';
    HResult(DMUS_E_BADOFFSETTABLE)                 : Result := 'Offset Table for download buffer has errors. ';
    HResult(DMUS_E_UNKNOWNDOWNLOAD)                : Result := 'Attempted to download unknown data type.';
    HResult(DMUS_E_NOSYNTHSINK)                    : Result := 'The operation could not be completed because no sink was connected to the synthesizer.';
    HResult(DMUS_E_ALREADYOPEN)                    : Result := 'An attempt was made to open the software synthesizer while it was already open. ASSERT?';
    HResult(DMUS_E_ALREADYCLOSED)                  : Result := 'An attempt was made to close the software synthesizer while it was already open. ASSERT?';
    HResult(DMUS_E_SYNTHNOTCONFIGURED)             : Result := 'The operation could not be completed because the software synth has not yet been fully configured. ASSERT?';
    HResult(DMUS_E_SYNTHACTIVE)                    : Result := 'The operation cannot be carried out while the synthesizer is active.';
    HResult(DMUS_E_CANNOTREAD)                     : Result := 'An error occurred while attempting to read from the IStream* object.';
    HResult(DMUS_E_DMUSIC_RELEASED)                : Result := 'The operation cannot be performed because the final instance of the DirectMusic object was released. Ports cannot be used after final release of the DirectMusic object.';
    HResult(DMUS_E_BUFFER_EMPTY)                   : Result := 'There was no data in the referenced buffer.';
    HResult(DMUS_E_BUFFER_FULL)                    : Result := 'There is insufficient space to insert the given event into the buffer.';
    HResult(DMUS_E_PORT_NOT_CAPTURE)               : Result := 'The given operation could not be carried out because the port is a capture port.';
    HResult(DMUS_E_PORT_NOT_RENDER)                : Result := 'The given operation could not be carried out because the port is a render port.';
    HResult(DMUS_E_DSOUND_NOT_SET)                 : Result := 'The port could not be created because no DirectSound has been specified. Specify a DirectSound interface via the IDirectMusic::SetDirectSound method; pass NULL to have DirectMusic manage usage of DirectSound.';
    HResult(DMUS_E_ALREADY_ACTIVATED)              : Result := 'The operation cannot be carried out while the port is active.';
    HResult(DMUS_E_INVALIDBUFFER)                  : Result := 'Invalid DirectSound buffer was handed to port. ';
    HResult(DMUS_E_WAVEFORMATNOTSUPPORTED)         : Result := 'Invalid buffer format was handed to the synth sink.';
    HResult(DMUS_E_SYNTHINACTIVE)                  : Result := 'The operation cannot be carried out while the synthesizer is inactive.';
    HResult(DMUS_E_DSOUND_ALREADY_SET)             : Result := 'IDirectMusic::SetDirectSound has already been called. It may not be changed while in use.';
    HResult(DMUS_E_INVALID_EVENT)                  : Result := 'The given event is invalid (either it is not a valid MIDI message or it makes use of running status). The event cannot be packed into the buffer.';
    HResult(DMUS_E_UNSUPPORTED_STREAM)             : Result := 'The IStream* object does not contain data supported by the loading object.';
    HResult(DMUS_E_ALREADY_INITED)                 : Result := 'The object has already been initialized.';
    HResult(DMUS_E_INVALID_BAND)                   : Result := 'The file does not contain a valid band.';
    HResult(DMUS_E_TRACK_HDR_NOT_FIRST_CK)         : Result := 'The IStream* object''s data does not have a track header as the first chunk, and therefore can not be read by the segment object.';
    HResult(DMUS_E_TOOL_HDR_NOT_FIRST_CK)          : Result := 'The IStream* object''s data does not have a tool header as the first chunk, and therefore can not be read by the graph object.';
    HResult(DMUS_E_INVALID_TRACK_HDR)              : Result := 'The IStream* object''s data contains an invalid track header (ckid is 0 and fccType is NULL,) and therefore can not be read by the segment object.';
    HResult(DMUS_E_INVALID_TOOL_HDR)               : Result := 'The IStream* object''s data contains an invalid tool header (ckid is 0 and fccType is NULL,) and therefore can not be read by the graph object.';
    HResult(DMUS_E_ALL_TOOLS_FAILED)               : Result := 'The graph object was unable to load all tools from the IStream* object data. This may be due to errors in the stream, or the tools being incorrectly registered on the client.';
    HResult(DMUS_E_ALL_TRACKS_FAILED)              : Result := 'The segment object was unable to load all tracks from the IStream* object data. This may be due to errors in the stream, or the tracks being incorrectly registered on the client.';
    HResult(DMUS_E_NOT_FOUND)                      : Result := 'The requested item was not contained by the object.';
    HResult(DMUS_E_NOT_INIT)                       : Result := 'A required object is not initialized or failed to initialize.';
    HResult(DMUS_E_TYPE_DISABLED)                  : Result := 'The requested parameter type is currently disabled. Parameter types may be enabled and disabled by certain calls to SetParam().';
    HResult(DMUS_E_TYPE_UNSUPPORTED)               : Result := 'The requested parameter type is not supported on the object.';
    HResult(DMUS_E_TIME_PAST)                      : Result := 'The time is in the past, and the operation can not succeed.';
    HResult(DMUS_E_TRACK_NOT_FOUND)                : Result := 'The requested track is not contained by the segment.';
    HResult(DMUS_E_TRACK_NO_CLOCKTIME_SUPPORT)     : Result := 'The track does not support clock time playback or getparam.';
    HResult(DMUS_E_NO_MASTER_CLOCK)                : Result := 'There is no master clock in the performance. Be sure to call IDirectMusicPerformance::Init().';
    HResult(DMUS_E_LOADER_NOCLASSID)               : Result := 'The class id field is required and missing in the DMUS_OBJECTDESC.';
    HResult(DMUS_E_LOADER_BADPATH)                 : Result := 'The requested file path is invalid.';
    HResult(DMUS_E_LOADER_FAILEDOPEN)              : Result := 'File open failed - either file doesn''t exist or is locked.';
    HResult(DMUS_E_LOADER_FORMATNOTSUPPORTED)      : Result := 'Search data type is not supported.';
    HResult(DMUS_E_LOADER_FAILEDCREATE)            : Result := 'Unable to find or create object.';
    HResult(DMUS_E_LOADER_OBJECTNOTFOUND)          : Result := 'Object was not found.';
    HResult(DMUS_E_LOADER_NOFILENAME)              : Result := 'The file name is missing from the DMUS_OBJECTDESC.';
    HResult(DMUS_E_INVALIDFILE)                    : Result := 'The file requested is not a valid file.';
    HResult(DMUS_E_ALREADY_EXISTS)                 : Result := 'The tool is already contained in the graph. Create a new instance.';
    HResult(DMUS_E_OUT_OF_RANGE)                   : Result := 'Value is out of range, for instance the requested length is longer than the segment.';
    HResult(DMUS_E_SEGMENT_INIT_FAILED)            : Result := 'Segment initialization failed, most likely due to a critical memory situation.';
    HResult(DMUS_E_ALREADY_SENT)                   : Result := 'The DMUS_PMSG has already been sent to the performance object via IDirectMusicPerformance::SendPMsg().';
    HResult(DMUS_E_CANNOT_FREE)                    : Result := 'The DMUS_PMSG was either not allocated by the performance via IDirectMusicPerformance::AllocPMsg(), or it was already freed via IDirectMusicPerformance::FreePMsg().';
    HResult(DMUS_E_CANNOT_OPEN_PORT)               : Result := 'The default system port could not be opened.';
    HResult(DMUS_E_CANNOT_CONVERT)                 : Result := 'A call to MIDIToMusic() or MusicToMIDI() resulted in an error because the requested conversion could not happen. This usually occurs when the provided DMUS_CHORD_KEY structure has an invalid chord or scale pattern.';
    HResult(DMUS_E_DESCEND_CHUNK_FAIL)             : Result := 'The end of the file was reached before the desired chunk was found.';
    HResult(DMUS_E_NOT_LOADED)                     : Result := 'An attempt to use this object failed because it first needs to be loaded.';
    HResult(DMUS_E_SCRIPT_LANGUAGE_INCOMPATIBLE)   : Result := 'The activeX scripting engine for the script''s language is not compatible with DirectMusic.';
    HResult(DMUS_E_SCRIPT_UNSUPPORTED_VARTYPE)     : Result := 'A varient was used that had a type that is not supported by DirectMusic.';
    HResult(DMUS_E_SCRIPT_ERROR_IN_SCRIPT)         : Result := 'An error was encountered while parsing or executing the script. The pErrorInfo parameter (if supplied) was filled with information about the error.';
    HResult(DMUS_E_SCRIPT_CANTLOAD_OLEAUT32)       : Result := 'Loading of oleaut32.dll failed.  VBScript and other activeX scripting languages require use of oleaut32.dll.  On platforms where oleaut32.dll is not present, only the DirectMusicScript language, which doesn''t require oleaut32.dll can be used.';
    HResult(DMUS_E_SCRIPT_LOADSCRIPT_ERROR)        : Result := 'An error occured while parsing a script loaded using LoadScript.  The script that was loaded contains an error.';
    HResult(DMUS_E_SCRIPT_INVALID_FILE)            : Result := 'The script file is invalid.';
    HResult(DMUS_E_INVALID_SCRIPTTRACK)            : Result := 'The file contains an invalid script track.';
    HResult(DMUS_E_SCRIPT_VARIABLE_NOT_FOUND)      : Result := 'The script does not contain a variable with the specified name.';
    HResult(DMUS_E_SCRIPT_ROUTINE_NOT_FOUND)       : Result := 'The script does not contain a routine with the specified name.';
    HResult(DMUS_E_SCRIPT_CONTENT_READONLY)        : Result := 'Scripts variables for content referenced or embedded in a script cannot be set.';
    HResult(DMUS_E_SCRIPT_NOT_A_REFERENCE)         : Result := 'Attempt was made to set a script''s variable by reference to a value that was not an object type.';
    HResult(DMUS_E_SCRIPT_VALUE_NOT_SUPPORTED)     : Result := 'Attempt was made to set a script''s variable by value to an object that does not support a default value property.';
    HResult(DMUS_E_INVALID_SEGMENTTRIGGERTRACK)    : Result := 'The file contains an invalid segment trigger track.';
    HResult(DMUS_E_INVALID_LYRICSTRACK)            : Result := 'The file contains an invalid lyrics track.';
    HResult(DMUS_E_INVALID_PARAMCONTROLTRACK)      : Result := 'The file contains an invalid parameter control track.';
    HResult(DMUS_E_AUDIOVBSCRIPT_SYNTAXERROR)      : Result := 'A script written in AudioVBScript could not be read because it contained a statement that is not allowed by the AudioVBScript language.';
    HResult(DMUS_E_AUDIOVBSCRIPT_RUNTIMEERROR)     : Result := 'A script routine written in AudioVBScript failed because an invalid operation occurred.  For example, adding the number 3 to a segment object would produce this error.  So would attempting to call a routine that doesn''t exist.';
    HResult(DMUS_E_AUDIOVBSCRIPT_OPERATIONFAILURE) : Result := 'A script routine written in AudioVBScript failed because a function outside of a script failed to complete. For example, a call to PlaySegment that fails to play because of low memory would return this error.';
    HResult(DMUS_E_AUDIOPATHS_NOT_VALID)           : Result := 'The Performance has set up some PChannels using the AssignPChannel command, which makes it not capable of supporting audio paths.';
    HResult(DMUS_E_AUDIOPATHS_IN_USE)              : Result := 'This is the inverse of the previous error. The Performance has set up some audio paths, which makes is incompatible with the calls to allocate pchannels, etc. ';
    HResult(DMUS_E_NO_AUDIOPATH_CONFIG)            : Result := 'A segment or song was asked for its embedded audio path configuration, but there isn''t any.';
    HResult(DMUS_E_AUDIOPATH_INACTIVE)             : Result := 'An audiopath is inactive, perhaps because closedown was called.';
    HResult(DMUS_E_AUDIOPATH_NOBUFFER)             : Result := 'An audiopath failed to create because a requested buffer could not be created.';
    HResult(DMUS_E_AUDIOPATH_NOPORT)               : Result := 'An audiopath could not be used for playback because it lacked port assignments.';
    HResult(DMUS_E_NO_AUDIOPATH)                   : Result := 'Attempt was made to play segment in audiopath mode and there was no audiopath.';
    HResult(DMUS_E_INVALIDCHUNK)                   : Result := 'Invalid data was found in a RIFF file chunk.';
    HResult(DMUS_E_AUDIOPATH_NOGLOBALFXBUFFER)     : Result := 'Attempt was made to create an audiopath that sends to a global effects buffer which did not exist.';
    HResult(DMUS_E_INVALID_CONTAINER_OBJECT)       : Result := 'The file does not contain a valid container object.';
    else Result := UnrecognizedError;
  end;
end;

end.

