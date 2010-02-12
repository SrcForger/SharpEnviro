
#define DLLEXPORT __declspec(dllexport)

// Function definitions
typedef int (WINAPI *WINLIST_INIT)();
typedef int (WINAPI *WINLIST_TERMINATE)();

typedef void (WINAPI *SHELLDDEINIT)(BOOL init);
typedef void (WINAPI *RUNINSTALLUNINSTALLSTUBS)(int a);
typedef bool (WINAPI *FILEICONINIT)(BOOL init);

typedef void *(WINAPI *SHCREATEDESKTOP)(void *);
typedef bool (WINAPI *SHDESKTOPMESSAGELOOP)(void *);

class IShellDesktopTray;

class ExplorerDll
{
	public:
		ExplorerDll();
		~ExplorerDll();

		static DWORD WINAPI ThreadFunc(LPVOID pvParam);

		void Start();

	private:
		HANDLE m_hThread;
		DWORD m_dwThreadID;
};

extern "C" DLLEXPORT void StartDesktop();
