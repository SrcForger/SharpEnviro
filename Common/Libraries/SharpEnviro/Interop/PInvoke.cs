using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Drawing;
using System.Windows;
using System.Windows.Media.Imaging;
using System.Windows.Interop;
using System.Text;

using SharpEnviro.Interop.Enums;
using SharpEnviro.Interop.Structs;

namespace SharpEnviro.Interop
{
	/// <summary>
	/// Helper class for Platform Invoke Windows API functions.
	/// </summary>
	public static class PInvoke
    {
        #region CreateWindowEx and Class Registration

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.U2)]
        public static extern UInt16 RegisterClassEx([In] ref WNDCLASSEX lpwcx);

        [DllImport("user32.dll")]
        public static extern bool UnregisterClass(string lpClassName, IntPtr hInstance);

        [DllImport("user32.dll")]
        public static extern IntPtr CreateWindowEx(
           uint dwExStyle,
           string lpClassName,
           string lpWindowName,
           uint dwStyle,
           int x,
           int y,
           int nWidth,
           int nHeight,
           IntPtr hWndParent,
           IntPtr hMenu,
           IntPtr hInstance,
           IntPtr lpParam);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool DestroyWindow(IntPtr hwnd);

        [DllImport("user32.dll")]
        public static extern IntPtr DefWindowProc(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);

        #endregion

        #region ShellHook

        [DllImport("shell32.dll", SetLastError = true, EntryPoint = "#181")]
        public static extern bool RegisterShellHook(IntPtr hwnd, uint param);

        #endregion

        [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern uint RegisterWindowMessage(string lpString);

        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, IntPtr pvParam, uint fWinIni);

        public const uint SPI_GETMINIMIZEDMETRICS = 0x002B;
        public const uint SPI_SETMINIMIZEDMETRICS = 0x002C;
        public const uint SPI_GETFOREGROUNDLOCKTIMEOUT = 0x2000;
        public const uint SPI_SETFOREGROUNDLOCKTIMEOUT = 0x2001;
        public const uint SPIF_UPDATEINIFILE = 0x01;
        public const uint SPIF_SENDCHANGE = 0x02;
        public const uint SPIF_SENDWININICHANGE = 0x02;

        // For SharpSearch.WPF
        [DllImport("user32.dll")]
        public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
        [DllImport("user32.dll", SetLastError = true)]
        public static extern uint GetWindowThreadProcessId(IntPtr hWnd, IntPtr lpdwProcessId);
        [DllImport("user32.dll")]
        public static extern IntPtr GetForegroundWindow();
        [DllImport("user32.dll")]
        public static extern bool AttachThreadInput(uint idAttach, uint idAttachTo, bool fAttach);
        [DllImport("user32.dll")]
        public static extern bool BringWindowToTop(IntPtr hWnd);
        [DllImport("user32.dll")]
        public static extern int GetWindowThreadProcessId(IntPtr hWnd, ref Int32 lpdwProcessId);

        // ShowWindow constants
        public const int SW_HIDE = 0;
        public const int SW_SHOWNORMAL = 1;
        public const int SW_NORMAL = 1;
        public const int SW_SHOWMINIMIZED = 2;
        public const int SW_SHOWMAXIMIZED = 3;
        public const int SW_MAXIMIZE = 3;
        public const int SW_SHOWNOACTIVATE = 4;
        public const int SW_SHOW = 5;
        public const int SW_MINIMIZE = 6;
        public const int SW_SHOWMINNOACTIVE = 7;
        public const int SW_SHOWNA = 8;
        public const int SW_RESTORE = 9;
        public const int SW_SHOWDEFAULT = 10;
        public const int SW_MAX = 10;

        [DllImport("user32.dll", CharSet = CharSet.Unicode)]
        private static extern int GetWindowTextW(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

        [DllImport("user32.dll", CharSet = CharSet.Unicode)]
        private static extern int GetWindowTextLengthW(IntPtr hWnd);

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        private static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);

        [DllImport("user32.dll", SetLastError = true)]
        private static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

        [DllImport("kernel32.dll")]
        private static extern IntPtr OpenProcess(ProcessAccess dwDesiredAccess, [MarshalAs(UnmanagedType.Bool)] bool bInheritHandle, int dwProcessId);

        [DllImport("Psapi.dll", CharSet = CharSet.Unicode, EntryPoint = "GetProcessImageFileNameW")]
        private static extern uint GetProcessImageFileNameWPsApi(IntPtr hProcess, StringBuilder lpImageFileName, int nMaxCount);

        [DllImport("Kernel32.dll", CharSet = CharSet.Unicode, EntryPoint = "GetProcessImageFileNameW")]
        private static extern uint GetProcessImageFileNameWKernel32(IntPtr hProcess, StringBuilder lpImageFileName, int nMaxCount);

        public static String GetWindowText(IntPtr hWnd)
        {
            int length = GetWindowTextLengthW(hWnd);
            StringBuilder windowText = new StringBuilder(length + 1);
            GetWindowTextW(hWnd, windowText, windowText.Capacity);
            return windowText.ToString();
        }

        public static String GetWindowClassName(IntPtr hWnd)
        {
            StringBuilder className = new StringBuilder(254);
            GetClassName(hWnd, className, className.Capacity);
            return className.ToString();
        }

        public static uint GetProcessID(IntPtr hWnd)
        {
            uint processID = 0;
            uint threadID = GetWindowThreadProcessId(hWnd, out processID);
            return processID;
        }

        public static String GetProcessExePath(IntPtr hWnd)
        {
            uint processID = GetProcessID(hWnd);
            IntPtr hProcess = OpenProcess(ProcessAccess.QueryInformation, true, (int)processID);
            StringBuilder processFile = new StringBuilder(2048);

            System.OperatingSystem osInfo = System.Environment.OSVersion;
            if ((osInfo.Platform == System.PlatformID.Win32NT && osInfo.Version.Major == 6 && osInfo.Version.Minor >= 1)
                || (osInfo.Platform == System.PlatformID.Win32NT && osInfo.Version.Major > 6))
                GetProcessImageFileNameWKernel32(hProcess, processFile, processFile.Capacity);
            else GetProcessImageFileNameWPsApi(hProcess, processFile, processFile.Capacity);

            CloseHandle(hProcess);
            return processFile.ToString();
        }

        [DllImport("user32.dll", ExactSpelling = true, CharSet = CharSet.Auto)]
        public static extern IntPtr GetParent(IntPtr hWnd);

        [DllImport("user32.dll", SetLastError = true)]
        public static extern IntPtr GetWindow(IntPtr hWnd, uint uCmd);

        [DllImport("kernel32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CloseHandle(IntPtr hObject);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool IsIconic(IntPtr hWnd);

        [DllImport("user32.dll")]
        public static extern bool IsZoomed(IntPtr hWnd);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool IsWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool IsWindowVisible(IntPtr hWnd);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool GetMessage(out MSG lpMsg, IntPtr hWnd, uint wMsgFilterMin, uint wMsgFilterMax);

        [DllImport("user32.dll", EntryPoint = "GetWindowLong", SetLastError = true)]
        private static extern IntPtr GetWindowLongPtr32(IntPtr hWnd, int nIndex);

        [DllImport("user32.dll", EntryPoint = "GetWindowLongPtr", SetLastError = true)]
        private static extern IntPtr GetWindowLongPtr64(IntPtr hWnd, int nIndex);

		/// <summary>
		/// The GetWindowLongPtr function retrieves information about the specified window.
		/// The function also retrieves the value at a specified offset into the extra window memory.
		/// If you are retrieving a pointer or a handle, this function supersedes the GetWindowLong function.
		/// (Pointers and handles are 32 bits on 32-bit Microsoft Windows and 64 bits on 64-bit Windows.)
		/// To write code that is compatible with both 32-bit and 64-bit versions of Windows, use GetWindowLongPtr.
		/// </summary>
		/// <param name="hWnd">
		/// Handle to the window and, indirectly, the class to which the window belongs.
		/// If you are retrieving a pointer or a handle, this function supersedes the GetWindowLong function.
		/// (Pointers and handles are 32 bits on 32-bit Windows and 64 bits on 64-bit Windows.)
		/// To write code that is compatible with both 32-bit and 64-bit versions of Windows, use GetWindowLongPtr. 
		/// </param>
		/// <param name="nIndex">
		/// Specifies the zero-based offset to the value to be retrieved.
		/// Valid values are in the range zero through the number of bytes of extra window memory, minus the size of an integer.
		/// To retrieve any other value, specify one of the following values.
		///     GWL_EXSTYLE
		///         Retrieves the extended window styles. For more information, see CreateWindowEx.
		///     GWL_STYLE
		///         Retrieves the window styles.
		///     GWLP_WNDPROC
		///         Retrieves the pointer to the window procedure, or a handle representing the pointer to the window procedure.
		///         You must use the CallWindowProc function to call the window procedure.
		///     GWLP_HINSTANCE
		///         Retrieves a handle to the application instance.
		///     GWLP_HWNDPARENT
		///         Retrieves a handle to the parent window, if there is one.
		///     GWLP_ID
		///         Retrieves the identifier of the window.
		///     GWLP_USERDATA
		///         Retrieves the user data associated with the window.
		///         This data is intended for use by the application that created the window. Its value is initially zero.
		/// 
		///     The following values are also available when the hWnd parameter identifies a dialog box.
		/// 
		///     DWLP_DLGPROC
		///         Retrieves the pointer to the dialog box procedure, or a handle representing the pointer to the dialog box procedure.
		///         You must use the CallWindowProc function to call the dialog box procedure.
		///     DWLP_MSGRESULT
		///         Retrieves the return value of a message processed in the dialog box procedure.
		///     DWLP_USER
		///         Retrieves extra information private to the application, such as handles or pointers.
		/// </param>
		/// <returns>
		/// If the function succeeds, the return value is the requested value.
		/// If the function fails, the return value is zero. To get extended error information, call GetLastError.
		/// If SetWindowLong or SetWindowLongPtr has not been called previously,
		/// GetWindowLongPtr returns zero for values in the extra window or class memory.
		/// </returns>
		public static IntPtr GetWindowLongPtr(IntPtr hWnd, int nIndex)
		{
			if (IntPtr.Size == 8)
				return GetWindowLongPtr64(hWnd, nIndex);
			else
				return GetWindowLongPtr32(hWnd, nIndex);
		}

		[DllImport("user32.dll", EntryPoint = "SetWindowLong", SetLastError = true)]
		private static extern IntPtr SetWindowLongPtr32(IntPtr hWnd, int nIndex, IntPtr dwNewLong);

		[DllImport("user32.dll", EntryPoint = "SetWindowLongPtr", SetLastError = true)]
		private static extern IntPtr SetWindowLongPtr64(IntPtr hWnd, int nIndex, IntPtr dwNewLong);

		/// <summary>
		/// The SetWindowLongPtr function changes an attribute of the specified window.
		/// The function also sets a value at the specified offset in the extra window memory.
		/// This function supersedes the SetWindowLong function.
		/// To write code that is compatible with both 32-bit and 64-bit versions of Microsoft Windows, use SetWindowLongPtr.
		/// </summary>
		/// <param name="hWnd">
		/// Handle to the window and, indirectly, the class to which the window belongs.
		/// The SetWindowLongPtr function fails if the process that owns the window specified by the hWnd parameter
		/// is at a higher process privilege in the User Interface Privilege Isolation (UIPI)
		/// hierarchy than the process the calling thread resides in.
		/// Microsoft Windows XP and earlier: The SetWindowLongPtr function fails if the window specified
		/// by the hWnd parameter does not belong to the same process as the calling thread.
		/// </param>
		/// <param name="nIndex">
		/// Specifies the zero-based offset to the value to be set.
		/// Valid values are in the range zero through the number of bytes of extra window memory, minus the size of an integer.
		/// To set any other value, specify one of the following values.
		///     GWL_EXSTYLE
		///         Sets a new extended window style. For more information, see CreateWindowEx. 
		///     GWL_STYLE
		///         Sets a new window style.
		///     GWLP_WNDPROC
		///         Sets a new address for the window procedure. 
		///     GWLP_HINSTANCE
		///         Sets a new application instance handle.
		///     GWLP_ID
		///         Sets a new identifier of the window.
		///     GWLP_USERDATA
		///         Sets the user data associated with the window.
		///         This data is intended for use by the application that created the window. Its value is initially zero.
		///
		///     The following values are also available when the hWnd parameter identifies a dialog box.
		///
		///     DWLP_DLGPROC
		///         Sets the new pointer to the dialog box procedure.
		///     DWLP_MSGRESULT
		///         Sets the return value of a message processed in the dialog box procedure.
		///     DWLP_USER
		///         Sets new extra information that is private to the application, such as handles or pointers.
		/// </param>
		/// <param name="dwNewLong">Specifies the replacement value</param>
		/// <returns>
		/// If the function succeeds, the return value is the previous value of the specified offset.
		/// If the function fails, the return value is zero. To get extended error information, call GetLastError.
		/// If the previous value is zero and the function succeeds, the return value is zero, but the function
		/// does not clear the last error information. To determine success or failure, clear the last error
		/// information by calling SetLastError(0), then call SetWindowLongPtr. Function failure will be indicated
		/// by a return value of zero and a GetLastError result that is nonzero.
		/// </returns>
		/// <remarks>
		/// Certain window data is cached, so changes you make using SetWindowLongPtr
		/// will not take effect until you call the SetWindowPos function.
		/// If you use SetWindowLongPtr with the GWLP_WNDPROC index to replace the window procedure, the window procedure
		/// must conform to the guidelines specified in the description of the WindowProc callback function.
		/// If you use SetWindowLongPtr with the DWLP_MSGRESULT index to set the return value for a message processed
		/// by a dialog box procedure, the dialog box procedure should return TRUE directly afterward.
		/// Otherwise, if you call any function that results in your dialog box procedure receiving a window message,
		/// the nested window message could overwrite the return value you set by using DWLP_MSGRESULT.
		/// Calling SetWindowLongPtr with the GWLP_WNDPROC index creates a subclass of the window class used to create the window.
		/// An application can subclass a system class, but should not subclass a window class created by another process.
		/// The SetWindowLongPtr function creates the window subclass by changing the window procedure associated with
		/// a particular window class, causing the system to call the new window procedure instead of the previous one.
		/// An application must pass any messages not processed by the new window procedure to the previous window procedure
		/// by calling CallWindowProc. This allows the application to create a chain of window procedures.
		/// Reserve extra window memory by specifying a nonzero value in the cbWndExtra member of the WNDCLASSEX structure
		/// used with the RegisterClassEx function.
		/// Do not call SetWindowLongPtr with the GWLP_HWNDPARENT index to change the parent of a child window.
		/// Instead, use the SetParent function.
		/// If the window has a class style of CS_CLASSDC or CS_PARENTDC, do not set the extended window styles
		/// WS_EX_COMPOSITED or WS_EX_LAYERED.
		/// Windows XP/Vista: Calling SetWindowLongPtr to set the style on a progressbar will reset its position.
		/// </remarks>
		public static IntPtr SetWindowLongPtr(IntPtr hWnd, int nIndex, IntPtr dwNewLong)
		{
			if (IntPtr.Size == 8)
				return SetWindowLongPtr64(hWnd, nIndex, dwNewLong);
			else
				return SetWindowLongPtr32(hWnd, nIndex, dwNewLong);
		}

		/// <summary>
		/// Changes the size, position, and Z order of a child, pop-up, or top-level window.
		/// These windows are ordered according to their appearance on the screen.
		/// The topmost window receives the highest rank and is the first window in the Z order.
		/// </summary>
		/// <param name="hWnd">A handle to the window.</param>
		/// <param name="hWndInsertAfter">
		/// A handle to the window to precede the positioned window in the Z order.
		/// This parameter must be a window handle or one of the following values.
		///     HWND_BOTTOM
		///         Places the window at the bottom of the Z order.
		///         If the hWnd parameter identifies a topmost window, the window loses its
		///         topmost status and is placed at the bottom of all other windows.
		///     HWND_NOTOPMOST
		///         Places the window above all non-topmost windows (that is, behind all topmost windows).
		///         This flag has no effect if the window is already a non-topmost window.
		///     HWND_TOP
		///         Places the window at the top of the Z order.
		///     HWND_TOPMOST
		///        Places the window above all non-topmost windows.
		///        The window maintains its topmost position even when it is deactivated.
		/// 
		/// For more information about how this parameter is used, see the following Remarks section.
		/// </param>
		/// <param name="X">Specifies the new position of the left side of the window, in client coordinates. </param>
		/// <param name="Y">Specifies the new position of the top of the window, in client coordinates. </param>
		/// <param name="cx">Specifies the new width of the window, in pixels. </param>
		/// <param name="cy">Specifies the new height of the window, in pixels. </param>
		/// <param name="uFlags">
		/// Specifies the window sizing and positioning flags. This parameter can be a combination of the following values.
		///     SWP_ASYNCWINDOWPOS
		///         If the calling thread and the thread that owns the window are attached to different input queues,
		///         the system posts the request to the thread that owns the window.
		///         This prevents the calling thread from blocking its execution while other threads process the request. 
		///     SWP_DEFERERASE
		///         Prevents generation of the WM_SYNCPAINT message.
		///     SWP_DRAWFRAME
		///         Draws a frame (defined in the window's class description) around the window.
		///     SWP_FRAMECHANGED
		///         Applies new frame styles set using the SetWindowLong function.
		///         Sends a WM_NCCALCSIZE message to the window, even if the window's size is not being changed.
		///         If this flag is not specified, WM_NCCALCSIZE is sent only when the window's size is being changed.
		///     SWP_HIDEWINDOW
		///         Hides the window.
		///     SWP_NOACTIVATE
		///         Does not activate the window. If this flag is not set, the window is activated and moved to the
		///         top of either the topmost or non-topmost group (depending on the setting of the hWndInsertAfter parameter).
		///     SWP_NOCOPYBITS
		///         Discards the entire contents of the client area.
		///         If this flag is not specified, the valid contents of the client area are saved and
		///         copied back into the client area after the window is sized or repositioned.
		///     SWP_NOMOVE
		///         Retains the current position (ignores X and Y parameters).
		///     SWP_NOOWNERZORDER
		///         Does not change the owner window's position in the Z order.
		///     SWP_NOREDRAW
		///         Does not redraw changes. If this flag is set, no repainting of any kind occurs.
		///         This applies to the client area, the nonclient area (including the title bar and scroll bars),
		///         and any part of the parent window uncovered as a result of the window being moved.
		///         When this flag is set, the application must explicitly invalidate or
		///         redraw any parts of the window and parent window that need redrawing.
		///     SWP_NOREPOSITION
		///         Same as the SWP_NOOWNERZORDER flag.
		///     SWP_NOSENDCHANGING
		///         Prevents the window from receiving the WM_WINDOWPOSCHANGING message.
		///     SWP_NOSIZE
		///         Retains the current size (ignores the cx and cy parameters).
		///     SWP_NOZORDER
		///         Retains the current Z order (ignores the hWndInsertAfter parameter).
		///     SWP_SHOWWINDOW
		///         Displays the window.
		/// </param>
		/// <returns>
		///     If the function succeeds, the return value is nonzero.
		///     If the function fails, the return value is zero. To get extended error information, call GetLastError. 
		/// </returns>
		/// <remarks>
		/// As part of the Vista re-architecture, all services were moved off the interactive desktop into Session 0.
		/// hwnd and window manager operations are only effective inside a session and cross-session attempts
		/// to manipulate the hwnd will fail. For more information, see Session 0 Isolation.
		/// If the SWP_SHOWWINDOW or SWP_HIDEWINDOW flag is set, the window cannot be moved or sized.
		/// If you have changed certain window data using SetWindowLong, you must call SetWindowPos
		/// for the changes to take effect.
		/// Use the following combination for uFlags: SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED.
		/// A window can be made a topmost window either by setting the hWndInsertAfter parameter to HWND_TOPMOST
		/// and ensuring that the SWP_NOZORDER flag is not set, or by setting a window's position in the Z order so
		/// that it is above any existing topmost windows. When a non-topmost window is made topmost, its owned
		/// windows are also made topmost. Its owners, however, are not changed.
		/// If neither the SWP_NOACTIVATE nor SWP_NOZORDER flag is specified (that is, when the application
		/// requests that a window be simultaneously activated and its position in the Z order changed),
		/// the value specified in hWndInsertAfter is used only in the following circumstances.
		///     * Neither the HWND_TOPMOST nor HWND_NOTOPMOST flag is specified in hWndInsertAfter.
		///     * The window identified by hWnd is not the active window.
		/// An application cannot activate an inactive window without also bringing it to the top of the Z order.
		/// Applications can change an activated window's position in the Z order without restrictions,
		/// or it can activate a window and then move it to the top of the topmost or non-topmost windows.
		/// If a topmost window is repositioned to the bottom (HWND_BOTTOM) of the Z order or after any non-topmost window,
		/// it is no longer topmost. When a topmost window is made non-topmost, its owners and its owned windows
		/// are also made non-topmost windows.
		/// A non-topmost window can own a topmost window, but the reverse cannot occur.
		/// Any window (for example, a dialog box) owned by a topmost window is itself made a topmost window,
		/// to ensure that all owned windows stay above their owner.
		/// If an application is not in the foreground, and should be in the foreground,
		/// it must call the SetForegroundWindow function.
		/// To use SetWindowPos to bring a window to the top, the process that owns the window must have
		/// SetForegroundWindow permission. 
		/// </remarks>
		[DllImport("user32.dll", SetLastError = true)]
		public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

		/// <summary>
		/// Sets the last-error code for the calling thread.
		/// </summary>
		/// <param name="dwErrCode">The last-error code for the thread.</param>
		/// <remarks>
		/// The last-error code is kept in thread local storage so that multiple threads do not overwrite each other's values.
		/// Most functions call SetLastError or SetLastErrorEx only when they fail.
		/// However, some system functions call SetLastError or SetLastErrorEx under conditions of success;
		/// those cases are noted in each function's documentation.
		/// Applications can optionally retrieve the value set by this function by using
		/// the GetLastError function immediately after a function fails.
		/// Error codes are 32-bit values (bit 31 is the most significant bit).
		/// Bit 29 is reserved for application-defined error codes; no system error code has this bit set.
		/// If you are defining an error code for your application, set this bit to indicate that the error code has been
		/// defined by your application and to ensure that your error code does not conflict with any system-defined error codes.
		/// </remarks>
		[DllImport("kernel32.dll")]
		public static extern void SetLastError(uint dwErrCode);

		/// <summary>
		/// Retrieves information about an object in the file system, such as a file, folder, directory, or drive root.
		/// </summary>
		/// <param name="pszPath">
		/// A pointer to a null-terminated string of maximum length MAX_PATH that contains the path and file name. Both absolute and relative paths are valid.
		/// If the uFlags parameter includes the SHGFI_PIDL flag, this parameter must be the address of an ITEMIDLIST (PIDL)
		/// structure that contains the list of item identifiers that uniquely identifies the file within the Shell's namespace.
		/// The pointer to an item identifier list (PIDL) must be a fully qualified PIDL. Relative PIDLs are not allowed.
		/// If the uFlags parameter includes the SHGFI_USEFILEATTRIBUTES flag, this parameter does not have to be a valid file name.
		/// The function will proceed as if the file exists with the specified name and with the file attributes passed in the dwFileAttributes parameter.
		/// This allows you to obtain information about a file type by passing just the extension for pszPath and passing FILE_ATTRIBUTE_NORMAL in dwFileAttributes.
		/// This string can use either short (the 8.3 form) or long file names.
		/// </param>
		/// <param name="dwFileAttributes">
		/// A combination of one or more file attribute flags (FILE_ATTRIBUTE_ values as defined in Winnt.h).
		/// If uFlags does not include the SHGFI_USEFILEATTRIBUTES flag, this parameter is ignored.
		/// </param>
		/// <param name="psfi">The address of a SHFILEINFO structure to receive the file information.</param>
		/// <param name="cbFileInfo">The size, in bytes, of the SHFILEINFO structure pointed to by the psfi parameter.</param>
		/// <param name="uFlags">
		/// The flags that specify the file information to retrieve. This parameter can be a combination of the following values.
		///     SHGFI_ADDOVERLAYS
		///         Version 5.0. Apply the appropriate overlays to the file's icon. The SHGFI_ICON flag must also be set.
		///     SHGFI_ATTR_SPECIFIED
		///         Modify SHGFI_ATTRIBUTES to indicate that the dwAttributes member of the SHFILEINFO structure at psfi contains
		///         the specific attributes that are desired. These attributes are passed to IShellFolder::GetAttributesOf.
		///         If this flag is not specified, 0xFFFFFFFF is passed to IShellFolder::GetAttributesOf, requesting all attributes.
		///         This flag cannot be specified with the SHGFI_ICON flag.
		///     SHGFI_ATTRIBUTES
		///         Retrieve the item attributes. The attributes are copied to the dwAttributes member of the structure specified in the psfi parameter.
		///         These are the same attributes that are obtained from IShellFolder::GetAttributesOf.
		///     SHGFI_DISPLAYNAME
		///         Retrieve the display name for the file. The name is copied to the szDisplayName member of the structure specified in psfi.
		///         The returned display name uses the long file name, if there is one, rather than the 8.3 form of the file name.
		///     SHGFI_EXETYPE
		///         Retrieve the type of the executable file if pszPath identifies an executable file.
		///         The information is packed into the return value.
		///         This flag cannot be specified with any other flags.
		///     SHGFI_ICON
		///         Retrieve the handle to the icon that represents the file and the index of the icon within the system image list.
		///         The handle is copied to the hIcon member of the structure specified by psfi, and the index is copied to the iIcon member.
		///     SHGFI_ICONLOCATION
		///         Retrieve the name of the file that contains the icon representing the file specified by pszPath,
		///         as returned by the IExtractIcon::GetIconLocation method of the file's icon handler.
		///         Also retrieve the icon index within that file.
		///         The name of the file containing the icon is copied to the szDisplayName member of the structure specified by psfi.
		///         The icon's index is copied to that structure's iIcon member.
		///     SHGFI_LARGEICON
		///         Modify SHGFI_ICON, causing the function to retrieve the file's large icon. The SHGFI_ICON flag must also be set.
		///     SHGFI_LINKOVERLAY
		///         Modify SHGFI_ICON, causing the function to add the link overlay to the file's icon. The SHGFI_ICON flag must also be set.
		///     SHGFI_OPENICON
		///         Modify SHGFI_ICON, causing the function to retrieve the file's open icon.
		///         Also used to modify SHGFI_SYSICONINDEX, causing the function to return the handle to the system image list
		///         that contains the file's small open icon. A container object displays an open icon to indicate that the container is open.
		///         The SHGFI_ICON and/or SHGFI_SYSICONINDEX flag must also be set.
		///     SHGFI_OVERLAYINDEX
		///         Version 5.0. Return the index of the overlay icon.
		///         The value of the overlay index is returned in the upper eight bits of the iIcon member of the structure specified by psfi.
		///         This flag requires that the SHGFI_ICON be set as well.
		///     SHGFI_PIDL
		///         Indicate that pszPath is the address of an ITEMIDLIST structure rather than a path name.
		///     SHGFI_SELECTED
		///         Modify SHGFI_ICON, causing the function to blend the file's icon with the system highlight color.
		///         The SHGFI_ICON flag must also be set.
		///     SHGFI_SHELLICONSIZE
		///         Modify SHGFI_ICON, causing the function to retrieve a Shell-sized icon.
		///         If this flag is not specified the function sizes the icon according to the system metric values.
		///         The SHGFI_ICON flag must also be set.
		///     SHGFI_SMALLICON
		///         Modify SHGFI_ICON, causing the function to retrieve the file's small icon.
		///         Also used to modify SHGFI_SYSICONINDEX, causing the function to return the handle to the system image list that contains small icon images.
		///         The SHGFI_ICON and/or SHGFI_SYSICONINDEX flag must also be set.
		///     SHGFI_SYSICONINDEX
		///         Retrieve the index of a system image list icon. If successful, the index is copied to the iIcon member of psfi.
		///         The return value is a handle to the system image list. Only those images whose indices are successfully copied to iIcon are valid.
		///         Attempting to access other images in the system image list will result in undefined behavior.
		///     SHGFI_TYPENAME
		///         Retrieve the string that describes the file's type. The string is copied to the szTypeName member of the structure specified in psfi.
		///     SHGFI_USEFILEATTRIBUTES
		///         Indicates that the function should not attempt to access the file specified by pszPath.
		///         Rather, it should act as if the file specified by pszPath exists with the file attributes passed in dwFileAttributes.
		///         This flag cannot be combined with the SHGFI_ATTRIBUTES, SHGFI_EXETYPE, or SHGFI_PIDL flags.
		/// </param>
		/// <returns>
		/// Returns a value whose meaning depends on the uFlags parameter.
		/// If uFlags does not contain SHGFI_EXETYPE or SHGFI_SYSICONINDEX, the return value is nonzero if successful, or zero otherwise.
		/// If uFlags contains the SHGFI_EXETYPE flag, the return value specifies the type of the executable file. It will be one of the following values.
		/// 0	Nonexecutable file or an error condition.
		/// LOWORD = NE or PE and HIWORD = Windows version	Microsoft Windows application.
		/// LOWORD = MZ and HIWORD = 0	Windows 95, Windows 98: Microsoft MS-DOS .exe, .com, or .bat file
		/// Microsoft Windows NT, Windows 2000, Windows XP: MS-DOS .exe or .com file
		/// LOWORD = PE and HIWORD = 0	Windows 95, Windows 98: Microsoft Win32 console application
		/// Windows NT, Windows 2000, Windows XP: Win32 console application or .bat file 
		/// </returns>
		/// <remarks>
		/// If SHGetFileInfo returns an icon handle in the hIcon member of the SHFILEINFO structure pointed to by psfi,
		/// you are responsible for freeing it with DestroyIcon when you no longer need it.
		/// Note  Once you have a handle to a system image list, you can use the Image List API to manipulate it like any other image list.
		/// Because system image lists are created on a per-process basis, you should treat them as read-only objects.
		/// Writing to a system image list may overwrite or delete one of the system images, making it unavailable or incorrect for the remainder of the process.
		/// You must initialize Component Object Model (COM) with CoInitialize or OleInitialize prior to calling SHGetFileInfo.
		/// When you use the SHGFI_EXETYPE flag with a Windows application, the Windows version of the executable is given in the HIWORD of the return value.
		/// This version is returned as a hexadecimal value. For details on equating this value with a specific Windows version, see Using the SDK Headers.
		/// Windows 95,Windows 98,Windows Millennium Edition (Windows Me): SHGetFileInfo is supported by the Microsoft Layer for Unicode (MSLU).
		/// To use this, you must add certain files to your application, as outlined in Microsoft Layer for Unicode on Windows Me/98/95 Systems.
		/// </remarks>
		[DllImport("shell32.dll")]
		private static extern IntPtr SHGetFileInfo(string pszPath, uint dwFileAttributes, ref SHFILEINFO psfi, uint cbFileInfo, uint uFlags);

		/// <summary>
		/// Destroys an icon and frees any memory the icon occupied.
		/// </summary>
		/// <param name="hIcon">Handle to the icon to be destroyed. The icon must not be in use. </param>
		/// <returns>
		/// If the function succeeds, the return value is nonzero.
		/// If the function fails, the return value is zero. To get extended error information, call GetLastError. 
		/// </returns>
		[DllImport("User32.dll")]
		private static extern int DestroyIcon(IntPtr hIcon);

		//TODO: This only works for SHGFI.SMALLICON and SHGFI.LARGEICON
		private static Icon GetIcon(string path, SHGFI flags)
		{
			const int FILE_ATTRIBUTE_DIRECTORY = 0x10;
			const int FILE_ATTRIBUTE_NORMAL = 0x80;
			int attr = 0;

			if (Directory.Exists(path))
				attr = FILE_ATTRIBUTE_DIRECTORY;

			if (File.Exists(path))
				attr = FILE_ATTRIBUTE_NORMAL;

			SHFILEINFO shinfo = new SHFILEINFO();
			IntPtr hImg = SHGetFileInfo(path, (uint)attr, ref shinfo, (uint)Marshal.SizeOf(shinfo), (uint)flags);

			Icon icon = (Icon)Icon.FromHandle(shinfo.hIcon).Clone();
			DestroyIcon(shinfo.hIcon);
			return icon;
		}

		public static Icon GetSmallIcon(string path)
		{
			return GetIcon(path, SHGFI.ICON | SHGFI.SMALLICON | SHGFI.USEFILEATTRIBUTES);
		}

		public static Icon GetLargeIcon(string path)
		{
			return GetIcon(path, SHGFI.ICON | SHGFI.LARGEICON | SHGFI.USEFILEATTRIBUTES);
		}

		public static Icon GetExtraLargeIcon(string path)
		{
			return GetIcon(path, SHGFI.SYSICONINDEX);
		}

		//TODO: implement like it is done in ImageListExtraLarge
		public static BitmapSource GetIcon(string path)
		{
			const int FILE_ATTRIBUTE_DIRECTORY = 0x10;
			const int FILE_ATTRIBUTE_NORMAL = 0x80;
			int attr = 0;

			if (Directory.Exists(path))
				attr = FILE_ATTRIBUTE_DIRECTORY;

			if (File.Exists(path))
				attr = FILE_ATTRIBUTE_NORMAL;

			SHFILEINFO shinfo = new SHFILEINFO();
			IntPtr hImg = SHGetFileInfo(path, (uint)attr, ref shinfo, (uint)Marshal.SizeOf(shinfo), (uint)(SHGFI.ICON | SHGFI.LARGEICON | SHGFI.USEFILEATTRIBUTES));

			BitmapSource bmpSource = Imaging.CreateBitmapSourceFromHIcon(
				shinfo.hIcon,
				Int32Rect.Empty,
				BitmapSizeOptions.FromWidthAndHeight(96, 96));
				//BitmapSizeOptions.FromEmptyOptions());

			DestroyIcon(shinfo.hIcon);

			return bmpSource;

		}

		//TODO: Find a better place for these HWND_*????

		/// <summary>
		/// Places the window above all non-topmost windows.
		/// The window maintains its topmost position even when it is deactivated.
		/// </summary>
		public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);

		/// <summary>
		/// Places the window above all non-topmost windows (that is, behind all topmost windows).
		/// This flag has no effect if the window is already a non-topmost window.
		/// </summary>
		public static readonly IntPtr HWND_NOTOPMOST = new IntPtr(-2);

		/// <summary>
		/// Places the window at the top of the Z order.
		/// </summary>
		public static readonly IntPtr HWND_TOP = new IntPtr(0);

		/// <summary>
		/// Places the window at the bottom of the Z order.
		/// If the hWnd parameter identifies a topmost window, the window loses its topmost status
		/// and is placed at the bottom of all other windows.
		/// </summary>
		public static readonly IntPtr HWND_BOTTOM = new IntPtr(1);
	}
}
