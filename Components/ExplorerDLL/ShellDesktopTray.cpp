#include "stdafx.h"

IShellDesktopTray *CreateInstance()
{
	return new TShellDesktopTray;
}

HRESULT TShellDesktopTray::QueryInterface(IShellDesktopTray * p, REFIID riid, LPVOID * ppvObj)
{
	if(!ppvObj)
		return E_POINTER;

	if(riid == IID_IUnknown || riid == IID_IClassFactory)
		*ppvObj = this;
	else
	{
		*ppvObj = 0;
		return E_NOINTERFACE;
	}

	AddRef(this);
	return S_OK;
}

ULONG TShellDesktopTray::AddRef(IShellDesktopTray * p)
{
	return 2;
}

ULONG TShellDesktopTray::Release(IShellDesktopTray * p)
{
	return 1;
}

int TShellDesktopTray::GetState()
{
	return 2;
}

int TShellDesktopTray::GetTrayWindow(HWND *o)
{
	// Prevent Explorer from closing the tray window (and SharpCore) when shutting down
	*o = 0;
	//*o = FindWindow(L"Shell_TrayWnd", NULL);

	return 0;
}

int TShellDesktopTray::RegisterDesktopWindow(HWND d)
{
	return 0;
}

int TShellDesktopTray::SetVar(int p1, ULONG p2)
{
	return 0;
}