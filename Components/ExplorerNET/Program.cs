//#define SEARCH_ENABLED
//#define PEEK_ENABLED

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Timers;
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
        private static extern void StartDesktop();

        [DllImport("Explorer.dll")]
        private static extern void StopDesktop();

        [DllImport("Explorer.dll")]
        private static extern void ShellReady();

        [DllImport("Explorer.dll")]
        private static extern void RegisterTray();

        // Global vars
        private static bool bShellLoaded = false;
        private static bool bShellReady = false;
        private static uint uTaskbarMsg = 0;

#if PEEK_ENABLED
        private static IntPtr hDwmApi = IntPtr.Zero;
        private static DwmAeroPeek pDwmAeroPeek = null;
#endif

#if SEARCH_ENABLED
        private static SearchManager searchManager;
#endif

        private static void InvokeShellReady()
        {
            if (bShellReady)
                return;

            ShellReady();
            bShellReady = true;
        }

        private static IntPtr SharpWindowProc(IntPtr hWnd, uint uMsgm, IntPtr wParam, IntPtr lParam)
        {
            /*if (uMsgm == uTaskbarMsg)
            {
                ShellServices.Restart();

                return IntPtr.Zero;
            }*/

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

                case PInvoke.WM_SHARPREGISTERTRAY:
                {
                    RegisterTray();

                    return (IntPtr)0;
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
                    WPFRuntime.Instance.Show();
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

            uTaskbarMsg = PInvoke.RegisterWindowMessage("TaskbarCreated");

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
                ClassParams classParams = new ClassParams();
                classParams.Name = "TSharpExplorerForm";
                classParams.WindowProc = SharpWindowProc;
                CreateParamsEx createParams = new CreateParamsEx();
                createParams.Caption = "SharpExplorerForm";
                createParams.ClassName = classParams.Name;
                createParams.ExStyle = (int)WindowStylesExtended.WS_EX_TOOLWINDOW;

                NativeWindowEx explorerWindow = new NativeWindowEx(classParams, createParams);

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

#if SEARCH_ENABLED
                searchManager = new SearchManager(true);
                WPFRuntime.Instance.Start<SearchWindow>();
#endif

                // Check if the shell service is running
                System.Timers.Timer shellTimer = new System.Timers.Timer();
                shellTimer.Elapsed += new System.Timers.ElapsedEventHandler(( object source, ElapsedEventArgs e ) =>
                {
                    if(PInvoke.FindWindow("Shell_TrayWnd", null) == IntPtr.Zero)
                    {
                        // Tell the explorer window to quit
                        PInvoke.SendMessage(explorerWindow.Handle, PInvoke.WM_SHARPTERMINATE, IntPtr.Zero, IntPtr.Zero);
                        shellTimer.Enabled = false;
                    }
                });

                shellTimer.Interval = 100;
                shellTimer.Start();

                Application.Run();

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
