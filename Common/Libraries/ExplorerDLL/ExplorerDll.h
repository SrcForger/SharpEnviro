
#define DLLEXPORT __declspec(dllexport)

// Function definitions
typedef int (WINAPI *WINLIST_INIT)();
typedef int (WINAPI *WINLIST_TERMINATE)();

typedef void (WINAPI *SHELLDDEINIT)(BOOL init);
typedef void (WINAPI *RUNINSTALLUNINSTALLSTUBS)(int a);
typedef bool (WINAPI *FILEICONINIT)(BOOL init);

typedef void *(WINAPI *SHCREATEDESKTOP)(void *);
typedef bool (WINAPI *SHDESKTOPMESSAGELOOP)(void *);

// ExplorerDll (main) Class
class ExplorerDll
{
	public:
		ExplorerDll();
		~ExplorerDll();

		static DWORD WINAPI ThreadFunc(LPVOID pvParam);

		void Start();

		void ShellReady();

	private:
		DWORD registerCookie;
		TShellDesktopTrayFactory explorerFactory;

		HANDLE m_hThread;
		DWORD m_dwThreadID;

		HMODULE hShellDLL, hWinListDLL;
		IShellDesktopTray *iTray;

		SHELLDDEINIT ShellDDEInit;
		FILEICONINIT FileIconInit;
};

extern "C" DLLEXPORT void StartDesktop();
extern "C" DLLEXPORT void ShellReady();
