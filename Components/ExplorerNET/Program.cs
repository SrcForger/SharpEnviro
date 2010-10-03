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
                IntPtr fptr = PInvoke.GetProcAddress(hSharpDll, "ShellReady");
                if (fptr != IntPtr.Zero)
                {
                    StartDesktopInvoker sdi = (StartDesktopInvoker)Marshal.GetDelegateForFunctionPointer(fptr, typeof(StartDesktopInvoker));
                    sdi();
                }
            }
        }

        static IntPtr SharpWindowProc(IntPtr hWnd, uint uMsgm, IntPtr wParam, IntPtr lParam)
        {
            if (uMsgm == PInvoke.WM_SHARPSHELLREADY)
                ShellReady();

            if (uMsgm == PInvoke.WM_ENDSESSION || uMsgm == PInvoke.WM_CLOSE || uMsgm == PInvoke.WM_QUIT || uMsgm == PInvoke.WM_SHARPTERMINATE)
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
            IntPtr sharpMutex = PInvoke.CreateMutex(IntPtr.Zero, true, "SharpExplorer");
            if (sharpMutex != IntPtr.Zero && Marshal.GetLastWin32Error() == PInvoke.ERROR_ALREADY_EXISTS)
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
                    hSharpDll = PInvoke.LoadLibrary("Explorer64.dll");
                else
                    hSharpDll = PInvoke.LoadLibrary("Explorer32.dll");

                // Run the StartDesktop function
                if (hSharpDll != IntPtr.Zero)
                {
                    IntPtr fptr = PInvoke.GetProcAddress(hSharpDll, "StartDesktop");
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

                while (!bShouldExit)
                {
                    PInvoke.NativeMessage mMsg;

                    if (PInvoke.PeekMessage(out mMsg, IntPtr.Zero, 0, 0, 1))
                    {
                        if ((mMsg.msg == PInvoke.WM_ENDSESSION) || (mMsg.msg == PInvoke.WM_CLOSE) || (mMsg.msg == PInvoke.WM_QUIT))
                            break;

                        if (mMsg.msg == PInvoke.WM_SHARPSEARCH)
						{
							_logger.Info("SharpSearch message received.");
							WPFRuntime.Instance.Show<SearchWindow>();
							_logger.Info("SharpSearch message processed.");
						}

                        if (mMsg.msg == PInvoke.WM_SHARPSEARCH_INDEXING)
							if (!manager.IsIndexing) manager.StartIndexing();
                    }

                    System.Threading.Thread.Sleep(16);
                }

				manager.Dispose();
				WPFRuntime.Instance.Stop();
				ShellServices.Stop();
                PInvoke.FreeLibrary(hSharpDll);
            }

            bCanExit = true;
        }

		private static Logger _logger = LogManager.GetCurrentClassLogger();

        #region Win32

        #endregion
    }
}
