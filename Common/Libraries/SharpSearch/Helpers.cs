using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SQLite;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;

namespace SharpSearch
{
	/// <summary>
	/// Helper methods.
	/// </summary>
	public static class Helpers
	{
		/// <summary>
		/// Performs the replacement of specific variables with it's associtated path.
		/// </summary>
		/// <param name="input">The string to be replaced.</param>
		/// <returns>The expanded replacement value for the variables.</returns>
		public static string ParseEnvironmentVars(string input)
		{
			StringBuilder allUsersStartMenu = new StringBuilder(255);
			StringBuilder allUsersDesktop = new StringBuilder(255);
			SHGetSpecialFolderPath(IntPtr.Zero, allUsersStartMenu, CSIDL.COMMON_STARTMENU, false);
			SHGetSpecialFolderPath(IntPtr.Zero, allUsersDesktop, CSIDL.COMMON_DESKTOPDIRECTORY, false);

			input = input.Replace("{UserStartMenu}", Environment.GetFolderPath(Environment.SpecialFolder.StartMenu));
			input = input.Replace("{UserDesktop}", Environment.GetFolderPath(Environment.SpecialFolder.Desktop));
			input = input.Replace("{AllUsersStartMenu}", allUsersStartMenu.ToString());
			input = input.Replace("{AllUsersDestop}", allUsersDesktop.ToString());

			return input;
		}

		[DllImport("shell32.dll")]
		static extern bool SHGetSpecialFolderPath(IntPtr hwndOwner, StringBuilder lpszPath, CSIDL nFolder, bool fCreate);

		enum CSIDL
		{
			COMMON_STARTMENU = 0x0016,
			COMMON_DESKTOPDIRECTORY = 0x0019
		}
	}
}
