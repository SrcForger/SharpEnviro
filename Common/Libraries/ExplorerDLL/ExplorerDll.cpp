#include "stdafx.h"

ExplorerDll explorerDll;

extern "C" DLLEXPORT void StartDesktop()
{
	explorerDll.Start();
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
	CoInitialize(NULL);

	// Register the IShellDesktopTray COM Object
	CoRegisterClassObject(IID_IShellDesktopTray, LPUNKNOWN(&explorerFactory), CLSCTX_LOCAL_SERVER, REGCLS_MULTIPLEUSE, &registerCookie);

	// Create the ShellDesktopTray interface
	iTray = CreateInstance();

	// Create Desktop thread
	m_hThread = CreateThread(NULL, 0, ThreadFunc, this, 0, NULL);
}

void ExplorerDll::ShellReady()
{
	HANDLE hEv = OpenEvent(EVENT_MODIFY_STATE, false, L"SharpExplorer_ShellReady");
	if(!hEv)
		hEv = CreateEvent(NULL, true, false, L"SharpExplorer_ShellReady");

	if(hEv)
	{
		SetEvent(hEv);
		CloseHandle(hEv);
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

	SetProcessShutdownParameters(2, 0);

	// Wait for Scm to be created
	HANDLE hGScmEvent = OpenEvent(0x100002, false, L"Global\\ScmCreatedEvent");
	if (hGScmEvent == NULL)
		hGScmEvent = OpenEvent(0x100000, false, L"Global\\ScmCreatedEvent");
	if (hGScmEvent == NULL)
		hGScmEvent = CreateEvent(NULL, true, false, L"Global\\ScmCreatedEvent");

	hGScmEvent = OpenEvent(0x100000, false, L"Global\\ScmCreatedEvent");
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


	HANDLE hEv = OpenEvent(0x100000, false, L"SharpExplorer_ShellReady");
	if(!hEv)
		hEv = CreateEvent(NULL, true, false, L"SharpExplorer_ShellReady");

	if(!FindWindow(L"TSharpDeskMainForm", NULL))
		WaitForSingleObject(hEv, INFINITE);
	CloseHandle(hEv);

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
