using System;

namespace SharpEnviro.Interop.Enums
{
	/// <summary>
	/// Get Window Long value offsets.
	/// </summary>
	public enum GWL
	{
		/// <summary>
		/// Gets or Sets the address of the window procedure.
		/// Windows NT/2000/XP: You cannot change this attribute if the window does not belong to the same process as the calling thread.
		/// </summary>
		WNDPROC = -4,

		/// <summary>
		/// Gets or Sets the application instance handle.
		/// </summary>
		HINSTANCE = -6,

		/// <summary>
		/// Gets a handle to the parent window, if any.
		/// </summary>
		HWNDPARENT = -8,

		/// <summary>
		/// Gets or Sets the window style.
		/// </summary>
		STYLE = -16,

		/// <summary>
		/// Gets or Sets the extended window style. For more information, see CreateWindowEx.
		/// </summary>
		EXSTYLE = -20,

		/// <summary>
		/// Gets or Sets the user data associated with the window.
		/// This data is intended for use by the application that created the window.
		/// Its value is initially zero.
		/// </summary>
		USERDATA = -21,

		/// <summary>
		/// Gets or Sets the identifier of the window.
		/// </summary>
		ID = -12
	}
}
