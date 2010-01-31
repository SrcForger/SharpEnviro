using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Windows.Interop;
using Microsoft.Win32;

namespace SharpEnviro.ShellServices
{
    // IOleCommandTarget definition
    // Declare IMediaControl as a COM interface which 
    // derives from the IDispatch interface. 
    [Guid("213E2DF9-9A14-4328-99B1-6961F9143CE9"),
        InterfaceType(ComInterfaceType.InterfaceIsDual)]
    public interface IShellDesktopTray
    {
        int GetState(IntPtr a);
        int GetTrayWindow(IntPtr a, out IntPtr o);
        int RegisterDesktopWindow(IntPtr a, IntPtr d);
        int Unknown(IntPtr a, int p1, int p2);
    }

    public class TShellDesktopTray : IShellDesktopTray
    {
        public int GetState(IntPtr a)
        {
            return 2;
        }

        public int GetTrayWindow(IntPtr a, out IntPtr o)
        {
            o = FindWindow("Shell_TrayWnd", "Shell_TrayWnd");
            return 0;
        }

        public int RegisterDesktopWindow(IntPtr a, IntPtr d)
        {
            return 0;
        }

        public int Unknown(IntPtr a, int p1, int p2)
        {
            return 0;
        }

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
    }

    class SharpDeskNET
    {
        // Import GetMessage function from user32.dll
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool GetMessage(out MSG lpMsg, IntPtr hWnd, uint wMsgFilterMin, uint wMsgFilterMax);

        [DllImport("kernel32.dll")]
        public static extern IntPtr LoadLibrary(string dllToLoad);

        [DllImport("kernel32.dll")]
        public static extern IntPtr GetProcAddress(IntPtr hModule, int procedureName);

        [DllImport("kernel32.dll")]
        public static extern bool FreeLibrary(IntPtr hModule);

        [DllImport("shell32.dll", EntryPoint = "#200")]
        public extern static void SHCreateDesktop(IShellDesktopTray a);

        // Window Message declaration
        public const int WM_ENDSESSION = 0x0016;
        public const int WM_CLOSE = 0x0010;
        public const int WM_QUIT = 0x0012;

        static void Main(string[] args)
        {
            // check Operating system version
            OperatingSystem osInfo = Environment.OSVersion;
            if (osInfo.Platform == System.PlatformID.Win32NT)
            {
                IShellDesktopTray tray = new TShellDesktopTray();
                SHCreateDesktop(tray);

                // Loop through message until a quit message is received
                MSG lpMsg;
                while (GetMessage(out lpMsg, IntPtr.Zero, 0, 0) == true)
                {
                    if ((lpMsg.message == WM_ENDSESSION) || (lpMsg.message == WM_CLOSE) || (lpMsg.message == WM_QUIT))
                    {
                        break;
                    }
                }
            }
        }        
    }
}
