using System;
using System.Runtime.InteropServices;

namespace SharpEnviro.Interop.Structs
{
	/// <summary>
	/// The WINDOWPOS structure contains information about the size and position of a window.
	/// </summary>
	[StructLayout(LayoutKind.Sequential)]
	public struct WindowPos
	{
		/// <summary>
		/// Handle to the window.
		/// </summary>
		public IntPtr hWnd;

		/// <summary>
		/// Specifies the position of the window in Z order (front-to-back position).
		/// This member can be a handle to the window behind which this window is placed,
		/// or can be one of the special values listed with the SetWindowPos function. 
		/// </summary>
		public IntPtr hWndInsertAfter;

		/// <summary>
		/// Specifies the position of the left edge of the window.
		/// </summary>
		public int x;

		/// <summary>
		/// Specifies the position of the top edge of the window.
		/// </summary>
		public int y;

		/// <summary>
		/// Specifies the window width, in pixels.
		/// </summary>
		public int cx;

		/// <summary>
		/// Specifies the window height, in pixels.
		/// </summary>
		public int cy;

		/// <summary>
		/// Specifies the window position. This member can be one or more of the following values.
		///     SWP_DRAWFRAME
		///         Draws a frame (defined in the window's class description) around the window.
		///     SWP_FRAMECHANGED
		///         Sends a WM_NCCALCSIZE message to the window, even if the window's size is not being changed.
		///         If this flag is not specified, WM_NCCALCSIZE is sent only when the window's size is being changed.
		///     SWP_HIDEWINDOW
		///         Hides the window.
		///     SWP_NOACTIVATE
		///         Does not activate the window.
		///         If this flag is not set, the window is activated and moved to the top of either the topmost or non-topmost group
		///         (depending on the setting of the hwndInsertAfter member).
		///     SWP_NOCOPYBITS
		///         Discards the entire contents of the client area.
		///         If this flag is not specified, the valid contents of the client area are saved and
		///         copied back into the client area after the window is sized or repositioned.
		///     SWP_NOMOVE
		///         Retains the current position (ignores the x and y parameters).
		///     SWP_ NOOWNERZORDER
		///         Does not change the owner window's position in the Z order.
		///     SWP_NOREDRAW
		///         Does not redraw changes. If this flag is set, no repainting of any kind occurs.
		///         This applies to the client area, the nonclient area (including the title bar and scroll bars),
		///         and any part of the parent window uncovered as a result of the window being moved.
		///         When this flag is set, the application must explicitly invalidate or redraw any parts of the window and parent window that need redrawing.
		///     SWP_NOREPOSITION
		///         Same as the SWP_NOOWNERZORDER flag.
		///     SWP_NOSENDCHANGING
		///         Prevents the window from receiving the WM_WINDOWPOSCHANGING message.
		///     SWP_NOSIZE
		///         Retains the current size (ignores the cx and cy parameters).
		///     SWP_NOZORDER
		///         Retains the current Z order (ignores the hwndInsertAfter parameter).
		///     SWP_SHOWWINDOW
		///         Displays the window.
		/// </summary>
		public uint Flags;
	}
}
