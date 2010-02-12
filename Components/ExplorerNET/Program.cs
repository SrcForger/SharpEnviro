using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Windows.Interop;
using Microsoft.Win32;

namespace SharpEnviro.Explorer
{
    class Explorer
    {
        // Import GetMessage function from user32.dll
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool GetMessage(out MSG lpMsg, IntPtr hWnd, uint wMsgFilterMin, uint wMsgFilterMax);

        [DllImport("kernel32.dll")]
        public static extern IntPtr LoadLibrary(string dllToLoad);

        [DllImport("kernel32.dll")]
        public static extern IntPtr GetProcAddress(IntPtr hModule, string procedureName);

        [DllImport("kernel32.dll")]
        public static extern bool FreeLibrary(IntPtr hModule);

        // Window Message declaration
        public const int WM_ENDSESSION = 0x0016;
        public const int WM_CLOSE = 0x0010;
        public const int WM_QUIT = 0x0012;

        static bool Is64Bit() 
	    {
            return (IntPtr.Size == 8);
	    }

        internal delegate void StartDesktopInvoker();

        [STAThread]
        static void Main(string[] args)
        {
            // check Operating system version
            OperatingSystem osInfo = Environment.OSVersion;
            if (osInfo.Platform == System.PlatformID.Win32NT)
            {
                IntPtr hDll;

                if (Is64Bit())
                    hDll = LoadLibrary("Explorer64.dll");
                else
                    hDll = LoadLibrary("Explorer32.dll");

                // Run the StartDesktop function
                if (hDll != null)
                {
                    IntPtr fptr = GetProcAddress(hDll, "StartDesktop");
                    if (fptr != null)
                    {
                        StartDesktopInvoker sdi = (StartDesktopInvoker)Marshal.GetDelegateForFunctionPointer(fptr, typeof(StartDesktopInvoker));
                        sdi();
                    }
                }

                // Loop through message until a quit message is received
                MSG lpMsg;
                while (GetMessage(out lpMsg, IntPtr.Zero, 0, 0) == true)
                {
                    if ((lpMsg.message == WM_ENDSESSION) || (lpMsg.message == WM_CLOSE) || (lpMsg.message == WM_QUIT))
                    {
                        break;
                    }
                }

                FreeLibrary(hDll);
            }
        }        
    }
}
