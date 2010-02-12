#include "stdafx.h"

ExplorerDll explorerDll;
DWORD registerCookie;

DLLEXPORT void StartDesktop()
{
	explorerDll.Start();
}

ExplorerDll::ExplorerDll()
{
	
}

ExplorerDll::~ExplorerDll()
{
	// Terminate thread
	if (m_hThread != NULL)
	{
		if (WaitForSingleObject(m_hThread, 1000) != WAIT_OBJECT_0)
			TerminateThread(m_hThread, 0);

		CloseHandle(m_hThread);
		m_hThread = 0;
	}

	// Revoke the COM object
	CoRevokeClassObject(registerCookie);
}

void ExplorerDll::Start()
{
	CLSID CLSID_IShellDesktopTray;
	CLSIDFromString(L"{213E2DF9-9A14-4328-99B1-6961F9143CE9}", &CLSID_IShellDesktopTray);

	// Register the IShellDesktopTray COM Object
	TShellDesktopTray explorerFactory;
	HRESULT hr = CoRegisterClassObject(CLSID_IShellDesktopTray, reinterpret_cast<LPUNKNOWN>(&explorerFactory), CLSCTX_LOCAL_SERVER, REGCLS_MULTIPLEUSE, &registerCookie);

	// Create Desktop thread
	m_hThread = CreateThread(NULL, 0, ThreadFunc, NULL, 0, NULL);
}

DWORD WINAPI ExplorerDll::ThreadFunc(LPVOID pvParam)
{
	// Initialize COM for this thread
	CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);

	// Load the shell32 dll
	HMODULE ShellDLL = LoadLibrary(L"shell32.dll");
	if (ShellDLL == NULL)
		return 0;

	// Initialize various functions
	SHELLDDEINIT ShellDDEInit = (SHELLDDEINIT)GetProcAddress(ShellDLL, MAKEINTRESOURCEA(188));
	RUNINSTALLUNINSTALLSTUBS RunInstallUninstallStubs = (RUNINSTALLUNINSTALLSTUBS)GetProcAddress(ShellDLL, MAKEINTRESOURCEA(885));
	FILEICONINIT FileIconInit = (FILEICONINIT)GetProcAddress(ShellDLL, MAKEINTRESOURCEA(660));

	SHCREATEDESKTOP SHCreateDesktop = (SHCREATEDESKTOP)GetProcAddress(ShellDLL, MAKEINTRESOURCEA(200));
	SHDESKTOPMESSAGELOOP SHDesktopMessageLoop = (SHDESKTOPMESSAGELOOP)GetProcAddress(ShellDLL, MAKEINTRESOURCEA(201));


	// Create a mutex telling that this is the Explorer shell
	HANDLE hIsShell = CreateMutex(NULL, false, L"Local\\ExplorerIsShellMutex");
	WaitForSingleObject(hIsShell, INFINITE);

	// Initialize IShellWindows
	// Try 7 Dll
	HMODULE WinListDLL = LoadLibrary(L"ExplorerFrame.dll");
	if (WinListDLL == NULL || GetProcAddress(WinListDLL, MAKEINTRESOURCEA(110)) == NULL)
	{
		if (WinListDLL != NULL)
			FreeLibrary(WinListDLL);

		// Use Vista/XP dll
		WinListDLL = LoadLibrary(L"shdocvw.dll");
	}

	// Initialize WinList functions
	if (WinListDLL != NULL)
	{
		WINLIST_INIT WinList_Init = (WINLIST_INIT)GetProcAddress(WinListDLL, MAKEINTRESOURCEA(110));

		// Call WinList init
		if (WinList_Init != NULL)
			WinList_Init();
	}

	// Initialize DDE
	ShellDDEInit(true);

	// Wait for Scm to be created
	HANDLE hGScmEvent = OpenEvent(SYNCHRONIZE, false, L"Global\\ScmCreatedEvent");
	if (hGScmEvent != NULL)
	{
		WaitForSingleObject(hGScmEvent, 6000);
		CloseHandle(hGScmEvent);
	}

	// Initialize the file icon cache
	FileIconInit(true);

	// Event
	HANDLE CanRegisterEvent = CreateEvent(NULL, true, true, L"Local\\_fCanRegisterWithShellService");
	RunInstallUninstallStubs(0);
	CloseHandle(CanRegisterEvent);

	if (SHCreateDesktop != NULL && SHDesktopMessageLoop != NULL)
	{
		// Create the ShellDesktopTray interface
		IShellDesktopTray *iTray = CreateInstance();
		HANDLE hDesktop = SHCreateDesktop(iTray);

		// Switching shell event
		HANDLE ShellDesktopEvent = CreateEvent(NULL, true, true, L"ShellDesktopSwitchEvent");
		HANDLE ShellReadyEvent = OpenEvent(2, false, L"msgina: ShellReadyEvent");
		SetEvent(ShellReadyEvent);
		CloseHandle(ShellReadyEvent);
		CloseHandle(ShellDesktopEvent);

		// Run the desktop message loop
		SHDesktopMessageLoop(hDesktop);

		// Delete the ShellDesktopTray interface
		if (iTray != NULL)
			delete iTray;
	}

	if (WinListDLL != NULL)
	{
		WINLIST_TERMINATE WinList_Terminate = (WINLIST_TERMINATE)GetProcAddress(WinListDLL, MAKEINTRESOURCEA(111));

		// Terminate WinList
		if (WinList_Terminate != NULL)
			WinList_Terminate();

		// Free dll
		FreeLibrary(WinListDLL);
	}

	if (ShellDLL != NULL)
	{
		ShellDDEInit(false);
		FileIconInit(false);

		FreeLibrary(ShellDLL);
	}

	CoUninitialize();

	return 0;
}
