#include "stdafx.h"

ExplorerDll explorerDll;
DWORD registerCookie;

DLLEXPORT void StartDesktop()
{
	explorerDll.Start();
}

ExplorerDll::ExplorerDll()
{
	CLSID CLSID_IShellDesktopTray;
	CLSIDFromString(L"{213E2DF9-9A14-4328-99B1-6961F9143CE9}", &CLSID_IShellDesktopTray);

	// Register the IShellDesktopTray COM Object
	TShellDesktopTray explorerFactory;
	HRESULT hr = CoRegisterClassObject(CLSID_IShellDesktopTray, reinterpret_cast<LPUNKNOWN>(&explorerFactory), CLSCTX_LOCAL_SERVER, REGCLS_MULTIPLEUSE, &registerCookie);

	// Load the shell32 dll
	HMODULE ShellDLL = LoadLibraryA("shell32.dll");

	// Create the ShellDesktopTray interface
	iTray = CreateInstance();
}

ExplorerDll::~ExplorerDll()
{
	if (m_hThread != NULL)
	{
		if (WaitForSingleObject(m_hThread, 1000) != WAIT_OBJECT_0)
			TerminateThread(m_hThread, 0);

		CloseHandle(m_hThread);
		m_hThread = 0;
	}

	if(ShellDLL != NULL)
		FreeLibrary(ShellDLL);

	delete iTray;

	CoRevokeClassObject(registerCookie);
}

void ExplorerDll::Start()
{
	m_hThread = CreateThread(NULL, 0, ThreadFunc, NULL, 0, NULL);
}

DWORD WINAPI ExplorerDll::ThreadFunc(LPVOID pvParam)
{
	// Initialize COM for this thread
	CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);

	if (explorerDll.ShellDLL == NULL)
		return 0;

	// Initialize various functions
	SHELLDDEINIT ShellDDEInit = (SHELLDDEINIT)GetProcAddress(explorerDll.ShellDLL, MAKEINTRESOURCEA(188));
	RUNINSTALLUNINSTALLSTUBS RunInstallUninstallStubs = (RUNINSTALLUNINSTALLSTUBS)GetProcAddress(explorerDll.ShellDLL, MAKEINTRESOURCEA(885));
	FILEICONINIT FileIconInit = (FILEICONINIT)GetProcAddress(explorerDll.ShellDLL, MAKEINTRESOURCEA(660));

	SHCREATEDESKTOP SHCreateDesktop = (SHCREATEDESKTOP)GetProcAddress(explorerDll.ShellDLL, MAKEINTRESOURCEA(200));
	SHDESKTOPMESSAGELOOP SHDesktopMessageLoop = (SHDESKTOPMESSAGELOOP)GetProcAddress(explorerDll.ShellDLL, MAKEINTRESOURCEA(201));


	// Create a mutex telling that this is the Explorer shell
	HANDLE hIsShell = CreateMutexA(NULL, false, "Local\\ExplorerIsShellMutex");
	WaitForSingleObject(hIsShell, INFINITE);

	// Initialize DDE
	ShellDDEInit(true);

	// Wait for Scm to be created
	HANDLE hGScmEvent = OpenEventA(SYNCHRONIZE, false, "Global\\ScmCreatedEvent");
	if (hGScmEvent != NULL)
	{
		WaitForSingleObject(hGScmEvent, 6000);
		CloseHandle(hGScmEvent);
	}

	// Initialize the file icon cache
	FileIconInit(true);

	// Event
	HANDLE CanRegisterEvent = CreateEventA(NULL, true, true, "Local\\_fCanRegisterWithShellService");
	RunInstallUninstallStubs(0);
	CloseHandle(CanRegisterEvent);

	try
	{
		if (SHCreateDesktop != NULL && SHDesktopMessageLoop != NULL)
		{
			HANDLE hDesktop = SHCreateDesktop(explorerDll.iTray);

			// Switching shell event
			HANDLE ShellDesktopEvent = CreateEventA(NULL, true, true, "ShellDesktopSwitchEvent");
			HANDLE ShellReadyEvent = OpenEventA(2, false, "msgina: ShellReadyEvent");
			SetEvent(ShellReadyEvent);
			CloseHandle(ShellReadyEvent);
			CloseHandle(ShellDesktopEvent);

			// Run the desktop message loop
			SHDesktopMessageLoop(hDesktop);
		}
	} catch (...)
	{
		
	}

	CoUninitialize();

	return 0;
}
