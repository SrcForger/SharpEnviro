﻿using System;
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
        volatile static IntPtr hSharpDll;
        volatile static bool bShellLoaded = false;
        volatile static bool bShellReady = false;
        volatile static SearchManager searchManager;
        volatile static bool bEnableSearch = false;

        internal delegate void FunctionInvoker();

        static bool Is64Bit() 
	    {
            return (IntPtr.Size == 8);
	    }

        static void StartDesktop()
        {
            // Run the StartDesktop function
            if (hSharpDll != IntPtr.Zero)
            {
                IntPtr fptr = PInvoke.GetProcAddress(hSharpDll, "StartDesktop");
                if (fptr != IntPtr.Zero)
                {
                    _logger.Info("Invoking StartDesktop");
                    FunctionInvoker sdi = (FunctionInvoker)Marshal.GetDelegateForFunctionPointer(fptr, typeof(FunctionInvoker));
                    sdi();
                }
            }
        }

        static void StopDesktop()
        {
            // Run the StartDesktop function
            if (hSharpDll != IntPtr.Zero)
            {
                IntPtr fptr = PInvoke.GetProcAddress(hSharpDll, "StopDesktop");
                if (fptr != IntPtr.Zero)
                {
                    _logger.Info("Invoking StopDesktop");
                    FunctionInvoker sdi = (FunctionInvoker)Marshal.GetDelegateForFunctionPointer(fptr, typeof(FunctionInvoker));
                    sdi();
                }
            }
        }

        static void ShellReady()
        {
            if (bShellReady)
                return;

            // Run the ShellReady function
            if (hSharpDll != IntPtr.Zero)
            {
                IntPtr fptr = PInvoke.GetProcAddress(hSharpDll, "ShellReady");
                if (fptr != IntPtr.Zero)
                {
                    _logger.Info("Invoking ShellReady");
                    FunctionInvoker sdi = (FunctionInvoker)Marshal.GetDelegateForFunctionPointer(fptr, typeof(FunctionInvoker));
                    sdi();

                    bShellReady = true;
                }
            }
        }

        static IntPtr SharpWindowProc(IntPtr hWnd, uint uMsgm, IntPtr wParam, IntPtr lParam)
        {
            if (uMsgm == PInvoke.WM_SHARPSHELLREADY)
            {
                ShellReady();

                return (IntPtr)0;
            }

            if (uMsgm == PInvoke.WM_SHARPSHELLLOADED)
            {
                return (IntPtr)(bShellLoaded?1:0);
            }

            // Show the search window
            if (uMsgm == PInvoke.WM_SHARPSEARCH)
            {
                if (bEnableSearch)
                {
                    _logger.Info("SharpSearch message received.");
                    WPFRuntime.Instance.Show<SearchWindow>();
                    _logger.Info("SharpSearch message processed.");
                }

                return (IntPtr)0;
            }

            // Start indexing
            if (uMsgm == PInvoke.WM_SHARPSEARCH_INDEXING)
            {
                if (bEnableSearch)
                {
                    if (!searchManager.IsIndexing)
                        searchManager.StartIndexing();
                }

                return (IntPtr)0;
            }

            if (uMsgm == PInvoke.WM_SHARPTERMINATE)
            {
                PInvoke.PostQuitMessage(0);

                return (IntPtr)0;
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
					_logger.LogException(LogLevel.Error, "Encountered an unhandled exception", (Exception)a.ExceptionObject);
				};

            // Make sure SharpExplorer isn't running already
            IntPtr sharpMutex = PInvoke.CreateMutex(IntPtr.Zero, true, "SharpExplorer");
            if (sharpMutex != IntPtr.Zero && Marshal.GetLastWin32Error() == PInvoke.ERROR_ALREADY_EXISTS)
				return;

            // check Operating system version
            OperatingSystem osInfo = Environment.OSVersion;
            if (osInfo.Platform == System.PlatformID.Win32NT)
            {
                System.Threading.Thread wndThread = new System.Threading.Thread(new System.Threading.ThreadStart(WindowThread));
                wndThread.Start();

                // Wait for the native window to be created
                while (wndThread.IsAlive && PInvoke.FindWindow("TSharpExplorerForm", (string)null) == IntPtr.Zero)
                    System.Threading.Thread.Sleep(16);


                hSharpDll = PInvoke.LoadLibrary("Explorer.dll");

                // Run the StartDesktop function
                StartDesktop();

                // Signal that the shell is ready if the tray already exists
                if ((PInvoke.FindWindow("Shell_TrayWnd", (string)null) != IntPtr.Zero) || (PInvoke.OpenEvent(0, false, "Global\\SharpEnviroStarted") != IntPtr.Zero))
                    ShellReady();

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
                if (bEnableSearch)
                {
                    bool needsIndexing = !File.Exists(Path.Combine(SharpSearchDatabase.DefaultDatabaseDirectory, SharpSearchDatabase.DefaultDatabaseFilename));
                    searchManager = new SearchManager(true);

                    if (needsIndexing)
                        searchManager.StartIndexing();
                }

                while (wndThread.IsAlive)
                    System.Threading.Thread.Sleep(16);

                StopDesktop();

                if (bEnableSearch)
                {
                    searchManager.Dispose();
                }
				WPFRuntime.Instance.Stop();
				ShellServices.Stop();
                PInvoke.FreeLibrary(hSharpDll);
            }

            bShellLoaded = false;
        }

		private static Logger _logger = LogManager.GetCurrentClassLogger();

        #region Win32

        #endregion
    }
}
