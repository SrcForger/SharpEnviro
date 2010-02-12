
#define DLLEXPORT __declspec(dllexport)

// Function definitions
typedef void (*SHELLDDEINIT)(bool init);
typedef void (*RUNINSTALLUNINSTALLSTUBS)(int a);
typedef bool (*FILEICONINIT)(bool init);

typedef void *(*SHCREATEDESKTOP)(void *);
typedef bool (*SHDESKTOPMESSAGELOOP)(void *);

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

		HMODULE ShellDLL;
		IShellDesktopTray *iTray;
};

extern "C"
{
	DLLEXPORT void StartDesktop();
}
