using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SharpLinkLauncherNET
{
	/// <summary>
	/// Exit codes for the sharpe link launcher.
	/// </summary>
	enum ExitCode : int
	{
		/// <summary>
		/// We were able to successfully execute the link.
		/// </summary>
		Success = 0,

		/// <summary>
		/// The was too few/many arguments on the command line.
		/// </summary>
		InvalidNumberArguments = -1,

		/// <summary>
		/// The -l argument was not a valid file path.
		/// </summary>
		InvalidLinkPath = -2,

		/// <summary>
		/// The -t argument was not a valid integer.
		/// </summary>
		InvalidTimeout = -3,

		/// <summary>
		/// The timeout period expired waiting for the WM_SHARPELINKLAUNCH message.
		/// </summary>
		Timeout = -4,

		/// <summary>
		/// The process received a quit message before it could execute the link
		/// </summary>
	    QuitMessage = -5,

		/// <summary>
		/// The -e argument was not a valid boolean.
		/// </summary>
		InvalidElevate = -6,

		/// <summary>
		/// Calling Process.Start failed for some reason.
		/// </summary>
		ProcessStartFailed = -7
	}
}
