using System;
using System.Collections.Generic;
using System.Diagnostics;
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
        static bool bShouldExit = false;

        static bool Is64Bit() 
	    {
            return (IntPtr.Size == 8);
	    }

        internal delegate void StartDesktopInvoker();

        static IntPtr SharpWindowProc(IntPtr hWnd, uint uMsgm, IntPtr wParam, IntPtr lParam)
        {
            if (uMsgm == WM_ENDSESSION || uMsgm == WM_CLOSE || uMsgm == WM_QUIT)
            {
                bShouldExit = true;
                return (IntPtr)1;
            }

            return PInvoke.DefWindowProc(hWnd, uMsgm, wParam, lParam);
        }

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
                        if (args[i].Contains(" "))
                            p.StartInfo.Arguments += "\"";

                        p.StartInfo.Arguments += args[i];
                        if (args[i].Contains(" "))
                            p.StartInfo.Arguments += "\"";

                        if (i < args.Length - 1)
                            p.StartInfo.Arguments += " ";
                    }

                    p.StartInfo.UseShellExecute = true;
                    p.Start();

                    return;
                }
            }

            // check Operating system version
            OperatingSystem osInfo = Environment.OSVersion;
            if (osInfo.Platform == System.PlatformID.Win32NT)
            {
                ClassParams classParams = new ClassParams();
                classParams.Name = "TSharpExplorerForm";
                classParams.WindowProc = SharpWindowProc;
                CreateParamsEx createParams = new CreateParamsEx();
                createParams.Caption = "SharpExplorerForm";
                createParams.ClassName = classParams.Name;
                createParams.ExStyle = PInvoke.WS_EX_TOOLWINDOW;

                NativeWindowEx explorerWindow = new NativeWindowEx(classParams, createParams);

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
                while (!bShouldExit)
                {
                    System.Windows.Forms.Application.DoEvents();
                    System.Threading.Thread.Sleep(16);
                }

                FreeLibrary(hDll);
            }

            // The process crashes/fails to shutdown if we don't use this
            Process.GetCurrentProcess().Kill();
        }

        #region Win32

        [StructLayout(LayoutKind.Sequential)]
        public struct NativeMessage
        {
            public IntPtr handle;
            public uint msg;
            public IntPtr wParam;
            public IntPtr lParam;
            public uint time;
            public System.Drawing.Point p;
        }

        // Import GetMessage function from user32.dll
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool GetMessage(out MSG lpMsg, IntPtr hWnd, uint wMsgFilterMin, uint wMsgFilterMax);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool PeekMessage(out NativeMessage lpMsg, IntPtr hWnd, uint wMsgFilterMin, uint wMsgFilterMax, uint wRemoveMsg);

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
