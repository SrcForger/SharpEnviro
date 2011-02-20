//#define SEARCH_ENABLED
//#define PEEK_ENABLED

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
using System.ComponentModel;

using Explorer;
using Explorer.ShellServices;
using SharpEnviro.Interop;
using SharpEnviro.Interop.Enums;
#if SEARCH_ENABLED
using SharpSearch;
using SharpSearch.WPF;
#endif

namespace SharpEnviro.Explorer
{
    class Explorer
    {
        // Aero Peek
#if PEEK_ENABLED
        enum DWM_PEEK
        {
            DWM_PEEK_DESKTOP = 1,
            DWM_PEEK_WINDOW = 3
        }
        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        private delegate int DwmAeroPeek(int Show, IntPtr ownerWnd, IntPtr Wnd, DWM_PEEK peekType);  // Entrypoint #113
#endif

        // Imports from Explorer.dll
        [DllImport("Explorer.dll")]
        public static extern void StartDesktop();

        [DllImport("Explorer.dll")]
        public static extern void StopDesktop();

        [DllImport("Explorer.dll")]
        public static extern void ShellReady();

        // Global vars
        volatile static bool bShellLoaded = false;
        volatile static bool bShellReady = false;

#if PEEK_ENABLED
        volatile static IntPtr hDwmApi = IntPtr.Zero;
        volatile static DwmAeroPeek pDwmAeroPeek = null;
#endif

#if SEARCH_ENABLED
        volatile static SearchManager searchManager;
#endif

        static void InvokeShellReady()
        {
            if (bShellReady)
                return;

            ShellReady();
            bShellReady = true;
        }

        static IntPtr SharpWindowProc(IntPtr hWnd, uint uMsgm, IntPtr wParam, IntPtr lParam)
        {
            switch (uMsgm)
            {
                case PInvoke.WM_SHARPSHELLREADY:
                {
                    InvokeShellReady();
                    return (IntPtr)0;
                }
                case PInvoke.WM_SHARPSHELLLOADED:
                {
                    return (IntPtr)(bShellLoaded?1:0);
                }

                // Aero Peek
#if PEEK_ENABLED
                case PInvoke.WM_AEROPEEKDESKTOP:      // lParam = owner window
                {
                    if (pDwmAeroPeek != null)
                        pDwmAeroPeek(1, lParam, IntPtr.Zero, DWM_PEEK.DWM_PEEK_DESKTOP);

                    return (IntPtr)0;
                }
                case PInvoke.WM_AEROPEEKSTOPDESKTOP:
                {
                    if (pDwmAeroPeek != null)
                        pDwmAeroPeek(0, IntPtr.Zero, IntPtr.Zero, DWM_PEEK.DWM_PEEK_DESKTOP);

                    return (IntPtr)0;
                }
                case PInvoke.WM_AEROPEEKWINDOW:      // lParam = owner window, wParam = peek window
                {
                    if (pDwmAeroPeek != null)
                        pDwmAeroPeek(1, lParam, wParam, DWM_PEEK.DWM_PEEK_WINDOW);

                    return (IntPtr)0;
                }
                case PInvoke.WM_AEROPEEKSTOPWINDOW:
                {
                    if (pDwmAeroPeek != null)
                        pDwmAeroPeek(0, IntPtr.Zero, IntPtr.Zero, DWM_PEEK.DWM_PEEK_WINDOW);

                    return (IntPtr)0;
                }
#endif

                // Show the search window
#if SEARCH_ENABLED
                case PInvoke.WM_SHARPSEARCH:
                {
                    SharpDebug.Info("Explorer", "SharpSearch message received.");
                    WPFRuntime.Instance.Show<SearchWindow>();
                    SharpDebug.Info("Explorer", "SharpSearch message processed.");

                    return (IntPtr)0;
                }

                // Start indexing
                case PInvoke.WM_SHARPSEARCH_INDEXING:
                {
                    if (!searchManager.IsIndexing)
                        searchManager.StartIndexing();

                    return (IntPtr)0;
                }
#endif

                case PInvoke.WM_SHARPTERMINATE:
                {
                    PInvoke.PostQuitMessage(0);

                    return (IntPtr)0;
                }
            }

            return PInvoke.DefWindowProc(hWnd, uMsgm, wParam, lParam);
        }

        static void WindowThread()
        {
            ClassParams classParams = new ClassParams();
            classParams.Name = "TSharpExplorerForm";
            classParams.WindowProc = SharpWindowProc;
            CreateParamsEx createParams = new CreateParamsEx();
            createParams.Caption = "SharpExplorerForm";
            createParams.ClassName = classParams.Name;
            createParams.ExStyle = (int)WindowStylesExtended.WS_EX_TOOLWINDOW;

            NativeWindowEx explorerWindow = new NativeWindowEx(classParams, createParams);

            // Start message pump
            System.Windows.Threading.Dispatcher.Run();
        }

        [STAThread]
        static void Main(string[] args)
        {
			AppDomain.CurrentDomain.UnhandledException +=
				(s, a) =>
				{
					SharpDebug.Exception("Explorer", "Encountered an unhandled exception", (Exception)a.ExceptionObject);
				};

            // Send parameters to real explorer
            if (args.Length > 0)
            {
                string cmdArgs = "";
                foreach (string arg in args)
                {
                    if (arg.Contains(' '))
                        cmdArgs += "\"" + arg + "\" ";
                    else
                        cmdArgs += arg + " ";
                }

                Process.Start(Environment.ExpandEnvironmentVariables("%WinDir%") + "\\explorer.exe", cmdArgs);
                return;
            }

            // Make sure SharpExplorer isn't running already
            IntPtr sharpMutex = PInvoke.CreateMutex(IntPtr.Zero, true, "SharpExplorer");
            if (sharpMutex != IntPtr.Zero && Marshal.GetLastWin32Error() == PInvoke.ERROR_ALREADY_EXISTS)
				return;

            // check Operating system version
            OperatingSystem osInfo = Environment.OSVersion;
            if (osInfo.Platform == System.PlatformID.Win32NT)
            {
#if PEEK_ENABLED
                hDwmApi = PInvoke.LoadLibrary("dwmapi.dll");
                if (hDwmApi != IntPtr.Zero)
                {
                    IntPtr pAddress = PInvoke.GetProcAddress(hDwmApi, (IntPtr)113);
                    if (pAddress != IntPtr.Zero)
                        pDwmAeroPeek = (DwmAeroPeek)Marshal.GetDelegateForFunctionPointer(pAddress, typeof(DwmAeroPeek));
                }
#endif
                // Create main window thread
                System.Threading.Thread wndThread = new System.Threading.Thread(new System.Threading.ThreadStart(WindowThread));
                wndThread.Start();

                // Wait for the native window to be created
                while (wndThread.IsAlive && PInvoke.FindWindow("TSharpExplorerForm", (string)null) == IntPtr.Zero)
                    System.Threading.Thread.Sleep(16);

                // Run the StartDesktop function
                StartDesktop();

                // Signal that the shell is ready if the tray already exists
                if ((PInvoke.FindWindow("Shell_TrayWnd", (string)null) != IntPtr.Zero) || (PInvoke.OpenEvent(0, false, "Global\\SharpEnviroStarted") != IntPtr.Zero))
                    InvokeShellReady();

                bShellLoaded = true;

                // Wait for the tray to show
                while (PInvoke.FindWindow("Shell_TrayWnd", (string)null) == IntPtr.Zero)
                {
                    System.Threading.Thread.Sleep(16);
                }

                // Start shell services (tray icons etc)
                ShellServices.Start();
                WPFRuntime.Instance.Start();

				// Check if the database file exists before creating the SearchManager as it automatically creates the file.
#if SEARCH_ENABLED
                bool needsIndexing = !File.Exists(Path.Combine(SharpSearchDatabase.DefaultDatabaseDirectory, SharpSearchDatabase.DefaultDatabaseFilename));
                searchManager = new SearchManager(true);

                if (needsIndexing)
                    searchManager.StartIndexing();
#endif

                while (wndThread.IsAlive)
                    System.Threading.Thread.Sleep(1000);

                StopDesktop();

#if PEEK_ENABLED
                if (hDwmApi != IntPtr.Zero)
                    PInvoke.FreeLibrary(hDwmApi);
#endif

#if SEARCH_ENABLED
                searchManager.Dispose();
#endif

				WPFRuntime.Instance.Stop();
				ShellServices.Stop();
            }

            bShellLoaded = false;
        }
    }
}
