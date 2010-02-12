
class IShellDesktopTray
{
	public:
		virtual HRESULT QueryInterface(IShellDesktopTray * p, REFIID riid, LPVOID * ppvObj)=0;
		virtual ULONG AddRef(IShellDesktopTray * p)=0;
		virtual ULONG Release(IShellDesktopTray * p)=0;

		virtual int __stdcall GetState()=0;
		virtual int __stdcall GetTrayWindow(HWND *o)=0;
		virtual int __stdcall RegisterDesktopWindow(HWND d)=0;
		virtual int __stdcall SetVar(int p1, ULONG p2)=0;
};

class TShellDesktopTray : public IShellDesktopTray
{
	public:
		HRESULT QueryInterface(IShellDesktopTray * p, REFIID riid, LPVOID * ppvObj);
		ULONG AddRef(IShellDesktopTray * p);
		ULONG Release(IShellDesktopTray * p);

		int __stdcall GetState();
		int __stdcall GetTrayWindow(HWND *o);
		int __stdcall RegisterDesktopWindow(HWND d);
		int __stdcall SetVar(int p1, ULONG p2);
};

IShellDesktopTray *CreateInstance();