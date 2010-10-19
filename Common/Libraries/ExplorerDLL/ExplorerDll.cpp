#include "stdafx.h"

ExplorerDll explorerDll;

extern "C" DLLEXPORT void StartDesktop()
{
	explorerDll.Start();
}

extern "C" DLLEXPORT void StopDesktop()
{
	explorerDll.Stop();
}

extern "C" DLLEXPORT void ShellReady()
{
	explorerDll.ShellReady();
}

ExplorerDll::ExplorerDll()
{
	hShellDLL = hWinListDLL = NULL;
	ShellDDEInit = NULL;
	FileIconInit = NULL;
	iTray = NULL;
	m_hThread = NULL;
}

void ExplorerDll::Start()
{
	if(m_hThread)
		return;

	CoInitialize(NULL);

	// Register the IShellDesktopTray COM Object
	CoRegisterClassObject(IID_IShellDesktopTray, LPUNKNOWN(&explorerFactory), CLSCTX_LOCAL_SERVER, REGCLS_MULTIPLEUSE, &registerCookie);

	// Create the ShellDesktopTray interface
	iTray = CreateInstance();

	hReadyEvent = CreateEvent(NULL, false, false, L"SharpExplorer_ShellReady");

	// Create Desktop thread
	m_hThread = CreateThread(NULL, 0, ThreadFunc, this, 0, &m_dwThreadID);
}

void ExplorerDll::Stop()
{
	// Send quit message to SHDesktopMessageLoop
	if(m_dwThreadID)
		PostThreadMessage(m_dwThreadID, WM_QUIT, 0, 0);

	// Terminate thread
	if (m_hThread)
	{
		if (WaitForSingleObject(m_hThread, INFINITE) != WAIT_OBJECT_0)
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

void ExplorerDll::ShellReady()
{
	if(hReadyEvent)
	{
		SetEvent(hReadyEvent);
		CloseHandle(hReadyEvent);
	}
}

DWORD WINAPI ExplorerDll::ThreadFunc(LPVOID pvParam)
{
	// Initialize COM for this thread
	CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);

	ExplorerDll pThis = *static_cast<ExplorerDll*>(pvParam);

	SetPriorityClass(GetCurrentProcess(), HIGH_PRIORITY_CLASS);

	// Load the shell32 dll
	pThis.hShellDLL = LoadLibrary(L"shell32.dll");
	if (!pThis.hShellDLL)
		return 0;

	// Initialize various functions
	pThis.ShellDDEInit = (SHELLDDEINIT)GetProcAddress(pThis.hShellDLL, MAKEINTRESOURCEA(188));
	RUNINSTALLUNINSTALLSTUBS RunInstallUninstallStubs = (RUNINSTALLUNINSTALLSTUBS)GetProcAddress(pThis.hShellDLL, MAKEINTRESOURCEA(885));
	pThis.FileIconInit = (FILEICONINIT)GetProcAddress(pThis.hShellDLL, MAKEINTRESOURCEA(660));

	// Load RunInstallUninstallStubs function
	// Try 7 Dll
	pThis.hWinListDLL = LoadLibrary(L"ExplorerFrame.dll");
	if (pThis.hWinListDLL || GetProcAddress(pThis.hWinListDLL, MAKEINTRESOURCEA(110)))
	{
		if (pThis.hWinListDLL)
			FreeLibrary(pThis.hWinListDLL);

		// Use Vista/XP dll
		pThis.hWinListDLL = LoadLibrary(L"shdocvw.dll");
		if (pThis.hWinListDLL && !RunInstallUninstallStubs)
			RunInstallUninstallStubs = (RUNINSTALLUNINSTALLSTUBS)GetProcAddress(pThis.hWinListDLL, MAKEINTRESOURCEA(130));
	}

	// Create a mutex telling that this is the Explorer shell
	HANDLE hIsShell = CreateMutex(NULL, false, L"Local\\ExplorerIsShellMutex");
	WaitForSingleObject(hIsShell, INFINITE);

	// Initialize DDE
	if (pThis.ShellDDEInit)
		pThis.ShellDDEInit(true);

	SetProcessShutdownParameters(3, 0);

	MSG msg;
	PeekMessageW(&msg, 0, WM_QUIT, WM_QUIT, false);

	// Wait for Scm to be created
	HANDLE hGScmEvent = OpenEvent(0x100002, false, L"Global\\ScmCreatedEvent");
	if (hGScmEvent == NULL)
		hGScmEvent = OpenEvent(0x100000, false, L"Global\\ScmCreatedEvent");
	if (hGScmEvent == NULL)
		hGScmEvent = CreateEvent(NULL, true, false, L"Global\\ScmCreatedEvent");

	if (hGScmEvent)
	{
		WaitForSingleObject(hGScmEvent, 6000);
		CloseHandle(hGScmEvent);
	}

	// Initialize the file icon cache
	if (pThis.FileIconInit)
		pThis.FileIconInit(true);

	// Initialize WinList functions
	if (pThis.hWinListDLL)
	{
		WINLIST_INIT WinList_Init = (WINLIST_INIT)GetProcAddress(pThis.hWinListDLL, MAKEINTRESOURCEA(110));

		// Call WinList init
		if (WinList_Init)
			WinList_Init();
	}

	// Event
	HANDLE CanRegisterEvent = CreateEvent(NULL, true, true, L"Local\\_fCanRegisterWithShellService");

	if (RunInstallUninstallStubs)
		RunInstallUninstallStubs(0);

	CloseHandle(CanRegisterEvent);

	// Wait for SharpE to be loaded
	if(pThis.hReadyEvent)
	{
		WaitForSingleObject(pThis.hReadyEvent, INFINITE);
		CloseHandle(pThis.hReadyEvent);
	}

	SHCREATEDESKTOP SHCreateDesktop = (SHCREATEDESKTOP)GetProcAddress(pThis.hShellDLL, MAKEINTRESOURCEA(200));
	SHDESKTOPMESSAGELOOP SHDesktopMessageLoop = (SHDESKTOPMESSAGELOOP)GetProcAddress(pThis.hShellDLL, MAKEINTRESOURCEA(201));

	if (SHCreateDesktop && SHDesktopMessageLoop)
	{
		// Create the desktop
		HANDLE hDesktop = SHCreateDesktop(pThis.iTray);

		SendMessage(GetDesktopWindow(), 0x400, 0, 0);

		// Switching shell event
		HANDLE hEv = OpenEvent(EVENT_MODIFY_STATE, false, L"Global\\msgina: ShellReadyEvent");
		if(hEv)
		{
			SetEvent(hEv);
			CloseHandle(hEv);
		}
		hEv = OpenEvent(EVENT_MODIFY_STATE, false, L"msgina: ShellReadyEvent");
		if(hEv)
		{
			SetEvent(hEv);
			CloseHandle(hEv);
		}
		hEv = OpenEvent(EVENT_MODIFY_STATE, false, L"ShellDesktopSwitchEvent");
		if(hEv)
		{
			SetEvent(hEv);
			CloseHandle(hEv);
		}


		// Run the desktop message loop
		SHDesktopMessageLoop(hDesktop);
	}

	CoUninitialize();

	return 0;
}
