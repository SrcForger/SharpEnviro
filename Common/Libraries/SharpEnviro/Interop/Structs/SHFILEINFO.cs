using System;
using System.Runtime.InteropServices;

namespace SharpEnviro.Interop.Structs
{
	/// <summary>
	/// This structure contains information about a file object.
	/// </summary>
	[StructLayout(LayoutKind.Sequential)]
	public struct SHFILEINFO
	{
		/// <summary>
		/// Handle to the icon that represents the file.
		/// </summary>
		public IntPtr hIcon;

		/// <summary>
		/// Index of the icon image within the system image list.
		/// </summary>
		public IntPtr iIcon;

		/// <summary>
		/// Specifies the attributes of the file object.
		/// </summary>
		public uint dwAttributes;

		/// <summary>
		/// Null-terminated string that contains the name of the file as it appears in the Windows shell,
		/// or the path and name of the file that contains the icon representing the file.
		/// </summary>
		[MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)]
		public string szDisplayName;

		/// <summary>
		/// Null-terminated string that describes the type of file.
		/// </summary>
		[MarshalAs(UnmanagedType.ByValTStr, SizeConst = 80)]
		public string szTypeName;
	}
}
