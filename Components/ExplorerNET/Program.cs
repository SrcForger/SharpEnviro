using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Windows.Interop;
using System.Windows.Forms;
using Microsoft.Win32;

namespace SharpEnviro.Explorer
{
    class Explorer
    {
        static bool Is64Bit() 
	    {
            return (IntPtr.Size == 8);
	    }

        internal delegate void StartDesktopInvoker();

        [STAThread]
        static void Main(string[] args)
        {
            // Make sure SharpExplorer isn't running already
            IntPtr sharpMutex = CreateMutex(IntPtr.Zero, true, "SharpExplorer");
            if (sharpMutex != IntPtr.Zero)
            {
                if (Marshal.GetLastWin32Error() == ERROR_ALREADY_EXISTS)
                {
                    System.Diagnostics.Process p = new System.Diagnostics.Process();
                    p.StartInfo.FileName = Environment.ExpandEnvironmentVariables("%WinDir%") + "\\explorer.exe";

                    for (int i = 0; i < args.Length; i++ )
                    {
                        p.StartInfo.Arguments += "\"" + args[i] + "\"";
                        if (i < args.Length - 1)
                            p.StartInfo.Arguments += " ";
                    }

                    p.StartInfo.UseShellExecute = true;
                    p.Start();

                    return;
                }
            }

            CreateMutex(IntPtr.Zero, false, "started_SharpExplorer");

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
                if (hDll != IntPtr.Zero)
                {
                    IntPtr fptr = GetProcAddress(hDll, "StartDesktop");
                    if (fptr != IntPtr.Zero)
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

        #region Win32

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


        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern IntPtr CreateMutex(IntPtr lpMutexAttributes, bool bInitialOwner, string lpName);

        [DllImport("kernel32.dll")]
        public static extern bool ReleaseMutex(IntPtr hMutex);

        // Window Message declaration
        public const int WM_ENDSESSION = 0x0016;
        public const int WM_CLOSE = 0x0010;
        public const int WM_QUIT = 0x0012;

        // Error codes
        public const int ERROR_ALREADY_EXISTS = 0x00B7;

        #endregion
    }
}
