using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Interop;
using System.Windows.Forms;
using Microsoft.Win32;

using Explorer;
using Explorer.ShellServices;
using SharpEnviro.Interop;
using SharpEnviro.Interop.Enums;
using SharpSearch;
using SharpSearch.WPF;
using NLog;

namespace SharpEnviro.Explorer
{
    class Explorer
    {
        static IntPtr hSharpDll;
        static bool bShouldExit = false;
        static bool bCanExit = false;

        static bool Is64Bit() 
	    {
            return (IntPtr.Size == 8);
	    }

        static void ShellReady()
        {
            // Run the StartDesktop function
            if (hSharpDll != IntPtr.Zero)
            {
                IntPtr fptr = GetProcAddress(hSharpDll, "ShellReady");
                if (fptr != IntPtr.Zero)
                {
                    StartDesktopInvoker sdi = (StartDesktopInvoker)Marshal.GetDelegateForFunctionPointer(fptr, typeof(StartDesktopInvoker));
                    sdi();
                }
            }
        }

        static IntPtr SharpWindowProc(IntPtr hWnd, uint uMsgm, IntPtr wParam, IntPtr lParam)
        {
            if (uMsgm == WM_SHARPSHELLREADY)
                ShellReady();

            if (uMsgm == WM_ENDSESSION || uMsgm == WM_CLOSE || uMsgm == WM_QUIT || uMsgm == WM_SHARPTERMINATE)
            {
                bShouldExit = true;
                while (!bCanExit)
                    System.Threading.Thread.Sleep(16);

                return (IntPtr)1;
            }

            return PInvoke.DefWindowProc(hWnd, uMsgm, wParam, lParam);
        }

        internal delegate void StartDesktopInvoker();

        [STAThread]
        static void Main(string[] args)
        {
			AppDomain.CurrentDomain.UnhandledException +=
				(s, a) =>
				{
					_logger.LogException(LogLevel.Error, "Explorer encountered and unhandled exception.", (Exception)a.ExceptionObject);
				};

            // Make sure SharpExplorer isn't running already
            IntPtr sharpMutex = CreateMutex(IntPtr.Zero, true, "SharpExplorer");
            if (sharpMutex != IntPtr.Zero && Marshal.GetLastWin32Error() == ERROR_ALREADY_EXISTS)
				return;

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
				createParams.ExStyle = (int)WindowStylesExtended.WS_EX_TOOLWINDOW;

                NativeWindowEx explorerWindow = new NativeWindowEx(classParams, createParams);

                if (Is64Bit())
                    hSharpDll = LoadLibrary("Explorer64.dll");
                else
                    hSharpDll = LoadLibrary("Explorer32.dll");

                // Run the StartDesktop function
                if (hSharpDll != IntPtr.Zero)
                {
                    IntPtr fptr = GetProcAddress(hSharpDll, "StartDesktop");
                    if (fptr != IntPtr.Zero)
                    {
                        StartDesktopInvoker sdi = (StartDesktopInvoker)Marshal.GetDelegateForFunctionPointer(fptr, typeof(StartDesktopInvoker));
                        sdi();
                    }
                }

				ShellServices.Start();
				WPFRuntime.Instance.Start();

                if (PInvoke.FindWindow("Shell_TrayWnd", (string)null) != IntPtr.Zero)
                {
                    if (PInvoke.SendMessage(PInvoke.FindWindow("Shell_TrayWnd", (string)null), 33430, IntPtr.Zero, IntPtr.Zero) == new IntPtr(1))
                        ShellReady();
                }

				// Check if the database file exists before creating the SearchManager as it automatically creates the file.
				bool needsIndexing = !File.Exists(Path.Combine(SharpSearchDatabase.DefaultDatabaseDirectory, SharpSearchDatabase.DefaultDatabaseFilename));
				SearchManager manager = new SearchManager(true);

				if (needsIndexing)
					manager.StartIndexing();

                NativeMessage mMsg = new NativeMessage();
                HandleRef uTmp = new HandleRef(null, IntPtr.Zero);
                while (!bShouldExit)
                {
                    if (PeekMessage(out mMsg, uTmp, 0, 0, 1))
                    {
                        if ((mMsg.msg == WM_ENDSESSION) || (mMsg.msg == WM_CLOSE) || (mMsg.msg == WM_QUIT))
                            break;

						if (mMsg.msg == WM_SHARPSEARCH)
						{
							_logger.Info("SharpSearch message received.");
							WPFRuntime.Instance.Show<SearchWindow>();
							_logger.Info("SharpSearch message processed.");
						}

						if (mMsg.msg == WM_SHARPSEARCH_INDEXING)
							if (!manager.IsIndexing) manager.StartIndexing();
                    }

                    System.Threading.Thread.Sleep(16);
                }

				manager.Dispose();
				WPFRuntime.Instance.Stop();
				ShellServices.Stop();
                FreeLibrary(hSharpDll);
            }

            bCanExit = true;
        }

		private static Logger _logger = LogManager.GetCurrentClassLogger();

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
        static extern bool PeekMessage(out NativeMessage lpMsg, HandleRef hWnd, uint wMsgFilterMin, uint wMsgFilterMax, uint wRemoveMsg);

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
        public const int WM_SHARPTERMINATE = 0x8226;
        public const int WM_SHARPSHELLREADY = 0x8296;
		public const int WM_SHARPSEARCH = 0x8297;
		public const int WM_SHARPSEARCH_INDEXING = 0x8298;

        // Error codes
        public const int ERROR_ALREADY_EXISTS = 0x00B7;

        #endregion
    }
}
