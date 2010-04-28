{
Source Name: uKnownFolders.pas
Description: Getting the known/common/system folders on Vista and Later
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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


File based On: http://www.delphipraxis.net/post1047711.html
More Informations: http://msdn.microsoft.com/en-us/library/bb762188(v=VS.85).aspx
                   http://msdn.microsoft.com/en-us/library/dd378457(v=VS.85).aspx
Changes Done to Original File:
  * Added Windows 7 support
  * Code cleanup and simplification
}


unit uKnownFolders;

interface

uses
  Windows;

const
  FOLDERID_AddNewPrograms         : TGUID = '{de61d971-5ebc-4f02-a3a9-6c82895e5c04}';
  FOLDERID_AdminTools             : TGUID = '{724EF170-A42D-4FEF-9F26-B60E846FBA4F}';
  FOLDERID_AppUpdates             : TGUID = '{a305ce99-f527-492b-8b1a-7e76fa98d6e4}';
  FOLDERID_CDBurning              : TGUID = '{9E52AB10-F80D-49DF-ACB8-4330F5687855}';
  FOLDERID_ChangeRemovePrograms   : TGUID = '{df7266ac-9274-4867-8d55-3bd661de872d}';
  FOLDERID_CommonAdminTools       : TGUID = '{D0384E7D-BAC3-4797-8F14-CBA229B392B5}';
  FOLDERID_CommonOEMLinks         : TGUID = '{C1BAE2D0-10DF-4334-BEDD-7AA20B227A9D}';
  FOLDERID_CommonPrograms         : TGUID = '{0139D44E-6AFE-49F2-8690-3DAFCAE6FFB8}';
  FOLDERID_CommonStartMenu        : TGUID = '{A4115719-D62E-491D-AA7C-E74B8BE3B067}';
  FOLDERID_CommonStartup          : TGUID = '{82A5EA35-D9CD-47C5-9629-E15D2F714E6E}';
  FOLDERID_CommonTemplates        : TGUID = '{B94237E7-57AC-4347-9151-B08C6C32D1F7}';
  FOLDERID_ComputerFolder         : TGUID = '{0AC0837C-BBF8-452A-850D-79D08E667CA7}';
  FOLDERID_ConflictFolder         : TGUID = '{4bfefb45-347d-4006-a5be-ac0cb0567192}';
  FOLDERID_ConnectionsFolder      : TGUID = '{6F0CD92B-2E97-45D1-88FF-B0D186B8DEDD}';
  FOLDERID_Contacts               : TGUID = '{56784854-C6CB-462b-8169-88E350ACB882}';
  FOLDERID_ControlPanelFolder     : TGUID = '{82A74AEB-AEB4-465C-A014-D097EE346D63}';
  FOLDERID_Cookies                : TGUID = '{2B0F765D-C0E9-4171-908E-08A611B84FF6}';
  FOLDERID_Desktop                : TGUID = '{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}';
  FOLDERID_DeviceMetadataStore    : TGUID = '{5CE4A5E9-E4EB-479D-B89F-130C02886155}'; // Win 7
  FOLDERID_Documents              : TGUID = '{FDD39AD0-238F-46AF-ADB4-6C85480369C7}';
  FOLDERID_DocumentsLibrary       : TGUID = '{7B0DB17D-9CD2-4A93-9733-46CC89022E7C}'; // Win 7
  FOLDERID_Downloads              : TGUID = '{374DE290-123F-4565-9164-39C4925E467B}';
  FOLDERID_Favorites              : TGUID = '{1777F761-68AD-4D8A-87BD-30B759FA33DD}';
  FOLDERID_Fonts                  : TGUID = '{FD228CB7-AE11-4AE3-864C-16F3910AB8FE}';
  FOLDERID_Games                  : TGUID = '{CAC52C1A-B53D-4edc-92D7-6B2E8AC19434}';
  FOLDERID_GameTasks              : TGUID = '{054FAE61-4DD8-4787-80B6-090220C4B700}';
  FOLDERID_History                : TGUID = '{D9DC8A3B-B784-432E-A781-5A1130A75963}';
  FOLDERID_HomeGroup              : TGUID = '{52528A6B-B9E3-4ADD-B60D-588C2DBA842D}'; // Win 7
  FOLDERID_ImplicitAppShortcuts   : TGUID = '{BCB5256F-79F6-4CEE-B725-DC34E402FD46}'; // Win 7
  FOLDERID_InternetCache          : TGUID = '{352481E8-33BE-4251-BA85-6007CAEDCF9D}';
  FOLDERID_InternetFolder         : TGUID = '{4D9F7874-4E0C-4904-967B-40B0D20C3E4B}';
  FOLDERID_Libraries              : TGUID = '{1B3EA5DC-B587-4786-B4EF-BD1DC332AEAE}'; // Win 7
  FOLDERID_Links                  : TGUID = '{bfb9d5e0-c6a9-404c-b2b2-ae6db6af4968}';
  FOLDERID_LocalAppData           : TGUID = '{F1B32785-6FBA-4FCF-9D55-7B8E7F157091}';
  FOLDERID_LocalAppDataLow        : TGUID = '{A520A1A4-1780-4FF6-BD18-167343C5AF16}';
  FOLDERID_LocalizedResourcesDir  : TGUID = '{2A00375E-224C-49DE-B8D1-440DF7EF3DDC}';
  FOLDERID_Music                  : TGUID = '{4BD8D571-6D19-48D3-BE97-422220080E43}';
  FOLDERID_MusicLibrary           : TGUID = '{2112AB0A-C86A-4FFE-A368-0DE96E47012E}'; // Win 7
  FOLDERID_NetHood                : TGUID = '{C5ABBF53-E17F-4121-8900-86626FC2C973}';
  FOLDERID_NetworkFolder          : TGUID = '{D20BEEC4-5CA8-4905-AE3B-BF251EA09B53}';
  FOLDERID_OriginalImages         : TGUID = '{2C36C0AA-5812-4b87-BFD0-4CD0DFB19B39}';
  FOLDERID_PhotoAlbums            : TGUID = '{69D2CF90-FC33-4FB7-9A0C-EBB0F0FCB43C}';
  FOLDERID_Pictures               : TGUID = '{33E28130-4E1E-4676-835A-98395C3BC3BB}';
  FOLDERID_PicturesLibrary        : TGUID = '{A990AE9F-A03B-4E80-94BC-9912D7504104}'; // Win 7
  FOLDERID_Playlists              : TGUID = '{DE92C1C7-837F-4F69-A3BB-86E631204A23}';
  FOLDERID_PrintersFolder         : TGUID = '{76FC4E2D-D6AD-4519-A663-37BD56068185}';
  FOLDERID_PrintHood              : TGUID = '{9274BD8D-CFD1-41C3-B35E-B13F55A758F4}';
  FOLDERID_Profile                : TGUID = '{5E6C858F-0E22-4760-9AFE-EA3317B67173}';
  FOLDERID_ProgramData            : TGUID = '{62AB5D82-FDC1-4DC3-A9DD-070D1D495D97}';
  FOLDERID_ProgramFiles           : TGUID = '{905e63b6-c1bf-494e-b29c-65b732d3d21a}';
  FOLDERID_ProgramFilesX64        : TGUID = '{6D809377-6AF0-444b-8957-A3773F02200E}';
  FOLDERID_ProgramFilesX86        : TGUID = '{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}';
  FOLDERID_ProgramFilesCommon     : TGUID = '{F7F1ED05-9F6D-47A2-AAAE-29D317C6F066}';
  FOLDERID_ProgramFilesCommonX64  : TGUID = '{6365D5A7-0F0D-45E5-87F6-0DA56B6A4F7D}';
  FOLDERID_ProgramFilesCommonX86  : TGUID = '{DE974D24-D9C6-4D3E-BF91-F4455120B917}';
  FOLDERID_Programs               : TGUID = '{A77F5D77-2E2B-44C3-A6A2-ABA601054A51}';
  FOLDERID_Public                 : TGUID = '{DFDF76A2-C82A-4D63-906A-5644AC457385}';
  FOLDERID_PublicDesktop          : TGUID = '{C4AA340D-F20F-4863-AFEF-F87EF2E6BA25}';
  FOLDERID_PublicDocuments        : TGUID = '{ED4824AF-DCE4-45A8-81E2-FC7965083634}';
  FOLDERID_PublicDownloads        : TGUID = '{3D644C9B-1FB8-4f30-9B45-F670235F79C0}';
  FOLDERID_PublicGameTasks        : TGUID = '{DEBF2536-E1A8-4c59-B6A2-414586476AEA}';
  FOLDERID_PublicLibraries        : TGUID = '{48DAF80B-E6CF-4F4E-B800-0E69D84EE384}'; // Win 7
  FOLDERID_PublicMusic            : TGUID = '{3214FAB5-9757-4298-BB61-92A9DEAA44FF}';
  FOLDERID_PublicPictures         : TGUID = '{B6EBFB86-6907-413C-9AF7-4FC2ABF07CC5}';
  FOLDERID_PublicRingtones        : TGUID = '{E555AB60-153B-4D17-9F04-A5FE99FC15EC}'; // Win 7
  FOLDERID_PublicVideos           : TGUID = '{2400183A-6185-49FB-A2D8-4A392A602BA3}';
  FOLDERID_QuickLaunch            : TGUID = '{52a4f021-7b75-48a9-9f6b-4b87a210bc8f}';
  FOLDERID_Recent                 : TGUID = '{AE50C081-EBD2-438A-8655-8A092E34987A}';
  FOLDERID_RecordedTVLibrary      : TGUID = '{1A6FDBA2-F42D-4358-A798-B74D745926C5}'; // Win 7
  FOLDERID_RecycleBinFolder       : TGUID = '{B7534046-3ECB-4C18-BE4E-64CD4CB7D6AC}';
  FOLDERID_ResourceDir            : TGUID = '{8AD10C31-2ADB-4296-A8F7-E4701232C972}';
  FOLDERID_Ringtones              : TGUID = '{C870044B-F49E-4126-A9C3-B52A1FF411E8}'; // Win 7
  FOLDERID_RoamingAppData         : TGUID = '{3EB685DB-65F9-4CF6-A03A-E3EF65729F3D}';
  FOLDERID_SampleMusic            : TGUID = '{B250C668-F57D-4EE1-A63C-290EE7D1AA1F}';
  FOLDERID_SamplePictures         : TGUID = '{C4900540-2379-4C75-844B-64E6FAF8716B}';
  FOLDERID_SamplePlaylists        : TGUID = '{15CA69B3-30EE-49C1-ACE1-6B5EC372AFB5}';
  FOLDERID_SampleVideos           : TGUID = '{859EAD94-2E85-48AD-A71A-0969CB56A6CD}';
  FOLDERID_SavedGames             : TGUID = '{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}';
  FOLDERID_SavedSearches          : TGUID = '{7d1d3a04-debb-4115-95cf-2f29da2920da}';
  FOLDERID_SEARCH_CSC             : TGUID = '{ee32e446-31ca-4aba-814f-a5ebd2fd6d5e}';
  FOLDERID_SEARCH_MAPI            : TGUID = '{98ec0e18-2098-4d44-8644-66979315a281}';
  FOLDERID_SearchHome             : TGUID = '{190337d1-b8ca-4121-a639-6d472d16972a}';
  FOLDERID_SendTo                 : TGUID = '{8983036C-27C0-404B-8F08-102D10DCFD74}';
  FOLDERID_SidebarDefaultParts    : TGUID = '{7B396E54-9EC5-4300-BE0A-2482EBAE1A26}';
  FOLDERID_SidebarPart            : TGUID = '{A75D362E-50FC-4fb7-AC2C-A8BEAA314493}';
  FOLDERID_StartMenu              : TGUID = '{625B53C3-AB48-4EC1-BA1F-A1EF4146FC19}';
  FOLDERID_Startup                : TGUID = '{B97D20BB-F46A-4C97-BA10-5E3608430854}';
  FOLDERID_SyncManagerFolder      : TGUID = '{43668BF8-C14E-49B2-97C9-747784D784B7}';
  FOLDERID_SyncResultsFolder      : TGUID = '{289a9a43-be44-4057-a41b-587a76d7e7f9}';
  FOLDERID_SyncSetupFolder        : TGUID = '{0F214138-B1D3-4a90-BBA9-27CBC0C5389A}';
  FOLDERID_System                 : TGUID = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}';
  FOLDERID_SystemX86              : TGUID = '{D65231B0-B2F1-4857-A4CE-A8E7C6EA7D27}';
  FOLDERID_Templates              : TGUID = '{A63293E8-664E-48DB-A079-DF759E0509F7}';
  FOLDERID_UserPinned             : TGUID = '{9E3995AB-1F9C-4F13-B827-48B24B6C7174}'; // Win 7
  FOLDERID_UserProfiles           : TGUID = '{0762D272-C50A-4BB0-A382-697DCD729B80}';
  FOLDERID_UserProgramFiles       : TGUID = '{5CD7AEE2-2219-4A67-B85D-6C9CE15660CB}'; // Win 7
  FOLDERID_UserProgramFilesCommon : TGUID = '{BCBD3057-CA5C-4622-B42D-BC56DB0AE516}'; // Win 7
  FOLDERID_UsersFiles             : TGUID = '{f3ce0f7c-4901-4acc-8648-d5d44b04ef8f}';
  FOLDERID_UsersLibraries         : TGUID = '{A302545D-DEFF-464b-ABE8-61C8648D939B}'; // Win 7
  FOLDERID_Videos                 : TGUID = '{18989B1D-99B5-455B-841C-AB7C74E4DDFC}';
  FOLDERID_VideosLibrary          : TGUID = '{491E922F-5643-4AF4-A7EB-4E7A138D8174}'; // Win 7
  FOLDERID_Windows                : TGUID = '{F38BF404-1D43-42F2-9305-67DE0B28FC23}';  

const
  KF_FLAG_CREATE              = $00008000;
  KF_FLAG_DONT_VERIFY         = $00004000;
  KF_FLAG_DONT_UNEXPAND       = $00002000;
  KF_FLAG_NO_ALIAS            = $00001000;
  KF_FLAG_INIT                = $00000800;
  KF_FLAG_DEFAULT_PATH        = $00000400;
  KF_FLAG_NOT_PARENT_RELATIVE = $00000200;
  KF_FLAG_SIMPLE_IDLIST       = $00000100;
  KF_FLAG_ALIAS_ONLY          = $80000000;


function GetKnownFolderPath(const rfid: TGUID) : WideString;

implementation

uses
  SysUtils,
  uVistaFuncs;

const
  SHELL32_DLL : String = 'SHELL32.DLL';

type
  TShGetKnownFolderPath = function(const rfid : TGUID;
                                   dwFlags : DWord;
                                   hToken : THandle;
                                   out ppszPath : PWideChar): HResult; stdcall;

function ShGetKnownFolderPath(const rfid: TGUID;
                              dwFlags: DWord;
                              hToken: THandle;
                              out ppszPath: PWideChar): HResult;
var
  DLL_Handle : THandle;
  DLL_ShGetKnownFolderPath  : TShGetKnownFolderPath;
begin
  Result := 0;
  DLL_Handle := LoadLibrary(PChar(SHELL32_DLL));
  if DLL_Handle <> 0 then
  begin
    @DLL_ShGetKnownFolderPath := GetProcAddress(DLL_Handle, 'SHGetKnownFolderPath');
    if @DLL_ShGetKnownFolderPath <> nil then
      Result:= DLL_ShGetKnownFolderPath(rfid, dwFlags, hToken, ppszPath)
    else RaiseLastOSError;
    FreeLibrary(DLL_Handle);
  end else RaiseLastOSError;
end;


function GetKnownFolderPath(const rfid: TGUID) : WideString;
var
  OutPath : PWideChar;
begin
  if (not IsWindows7) and (not IsWindowsVista) then
  begin
    Result := #0;
    exit;
  end;
  
  if ShGetKnownFolderPath(rfid, 0, 0, OutPath) >= 0 then
    Result := OutPath
  else Result := #0;
end;

end.
