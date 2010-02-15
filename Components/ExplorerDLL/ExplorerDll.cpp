#include "stdafx.h"

ExplorerDll explorerDll;

extern "C" DLLEXPORT void StartDesktop()
{
	explorerDll.Start();
}

ExplorerDll::ExplorerDll()
{
	CoInitialize(NULL);

	hShellDLL = hWinListDLL = NULL;
	ShellDDEInit = NULL;
	FileIconInit = NULL;
	iTray = NULL;
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

	if (hWinListDLL)
	{
		WINLIST_TERMINATE WinList_Terminate = (WINLIST_TERMINATE)GetProcAddress(hWinListDLL, MAKEINTRESOURCEA(111));

		// Terminate WinList
		if (WinList_Terminate)
			WinList_Terminate();

		// Free dll
		FreeLibrary(hWinListDLL);
	}

	if(ShellDDEInit)
		ShellDDEInit(false);
	if(FileIconInit)
		FileIconInit(false);

	if (hShellDLL)
		FreeLibrary(hShellDLL);

	// Destroy the ShellDesktopTray interface
	if (iTray)
		delete iTray;

	// Revoke the COM object
	CoRevokeClassObject(registerCookie);

	CoUninitialize();
}

void ExplorerDll::Start()
{
	CLSID CLSID_IShellDesktopTray;
	CLSIDFromString(L"{213E2DF9-9A14-4328-99B1-6961F9143CE9}", &CLSID_IShellDesktopTray);

	// Register the IShellDesktopTray COM Object
	HRESULT hr = CoRegisterClassObject(CLSID_IShellDesktopTray, reinterpret_cast<LPUNKNOWN>(&explorerFactory), CLSCTX_LOCAL_SERVER, REGCLS_MULTIPLEUSE, &registerCookie);

	// Create the ShellDesktopTray interface
	iTray = CreateInstance();

	// Create Desktop thread
	m_hThread = CreateThread(NULL, 0, ThreadFunc, this, 0, NULL);
}

DWORD WINAPI ExplorerDll::ThreadFunc(LPVOID pvParam)
{
	// Initialize COM for this thread
	CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);

	ExplorerDll pThis = *static_cast<ExplorerDll*>(pvParam);

	// Load the shell32 dll
	pThis.hShellDLL = LoadLibrary(L"shell32.dll");
	if (!pThis.hShellDLL)
		return 0;

	// Initialize various functions
	pThis.ShellDDEInit = (SHELLDDEINIT)GetProcAddress(pThis.hShellDLL, MAKEINTRESOURCEA(188));
	RUNINSTALLUNINSTALLSTUBS RunInstallUninstallStubs = (RUNINSTALLUNINSTALLSTUBS)GetProcAddress(pThis.hShellDLL, MAKEINTRESOURCEA(885));
	pThis.FileIconInit = (FILEICONINIT)GetProcAddress(pThis.hShellDLL, MAKEINTRESOURCEA(660));

	SHCREATEDESKTOP SHCreateDesktop = (SHCREATEDESKTOP)GetProcAddress(pThis.hShellDLL, MAKEINTRESOURCEA(200));
	SHDESKTOPMESSAGELOOP SHDesktopMessageLoop = (SHDESKTOPMESSAGELOOP)GetProcAddress(pThis.hShellDLL, MAKEINTRESOURCEA(201));

	// Create a mutex telling that this is the Explorer shell
	HANDLE hIsShell = CreateMutex(NULL, false, L"Local\\ExplorerIsShellMutex");
	WaitForSingleObject(hIsShell, INFINITE);

	// Initialize IShellWindows
	// Try 7 Dll
	pThis.hWinListDLL = LoadLibrary(L"ExplorerFrame.dll");
	if (!pThis.hWinListDLL || GetProcAddress(pThis.hWinListDLL, MAKEINTRESOURCEA(110)) == NULL)
	{
		if (pThis.hWinListDLL)
			FreeLibrary(pThis.hWinListDLL);

		// Use Vista/XP dll
		pThis.hWinListDLL = LoadLibrary(L"shdocvw.dll");
		if (pThis.hWinListDLL && !RunInstallUninstallStubs)
			RunInstallUninstallStubs = (RUNINSTALLUNINSTALLSTUBS)GetProcAddress(pThis.hWinListDLL, MAKEINTRESOURCEA(130));
	}

	// Initialize WinList functions
	if (pThis.hWinListDLL)
	{
		WINLIST_INIT WinList_Init = (WINLIST_INIT)GetProcAddress(pThis.hWinListDLL, MAKEINTRESOURCEA(110));

		// Call WinList init
		if (WinList_Init)
			WinList_Init();
	}

	// Initialize DDE
	if (pThis.ShellDDEInit)
		pThis.ShellDDEInit(true);

	// Wait for Scm to be created
	HANDLE hGScmEvent = OpenEvent(SYNCHRONIZE, false, L"Global\\ScmCreatedEvent");
	if (hGScmEvent != NULL)
	{
		WaitForSingleObject(hGScmEvent, 6000);
		CloseHandle(hGScmEvent);
	}

	// Initialize the file icon cache
	if (pThis.FileIconInit)
		pThis.FileIconInit(true);

	// Event
	HANDLE CanRegisterEvent = CreateEvent(NULL, true, true, L"Local\\_fCanRegisterWithShellService");

	if (RunInstallUninstallStubs)
		RunInstallUninstallStubs(0);

	CloseHandle(CanRegisterEvent);

	if (SHCreateDesktop && SHDesktopMessageLoop)
	{
		// Create the desktop
		HANDLE hDesktop = SHCreateDesktop(pThis.iTray);

		// Switching shell event
		HANDLE ShellDesktopEvent = CreateEvent(NULL, true, true, L"ShellDesktopSwitchEvent");
		HANDLE ShellReadyEvent = OpenEvent(2, false, L"msgina: ShellReadyEvent");
		SetEvent(ShellReadyEvent);
		CloseHandle(ShellReadyEvent);
		CloseHandle(ShellDesktopEvent);

		// Run the desktop message loop
		SHDesktopMessageLoop(hDesktop);
	}

	CoUninitialize();

	return 0;
}
