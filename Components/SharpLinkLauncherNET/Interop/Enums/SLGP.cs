using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SharpLinkLauncherNET.Interop.Enums
{
	/// <summary>
	/// 
	/// </summary>
	[Flags]
	enum SLGP_FLAGS
	{
		/// <summary>
		/// Retrieves the standard short (8.3 format) file name.
		/// </summary>
		ShortPath = 0x1,

		/// <summary>
		/// Retrieves the Universal Naming Convention (UNC) path name of the file,
		/// </summary>
		UNCPriority = 0x2,

		/// <summary>
		/// Retrieves the raw path name. A raw path is something that might not exist and may include environment variables that need to be expanded.
		/// </summary>
		RawPath = 0x4
	}
}
