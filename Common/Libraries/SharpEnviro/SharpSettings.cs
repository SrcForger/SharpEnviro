using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Reflection;
using Microsoft.Win32;

namespace SharpEnviro
{
	/// <summary>
	/// SharpEnviro settings
	/// </summary>
	public static class SharpSettings
	{
		/// <summary>
		/// The directory from which SharpE is running.
		/// </summary>
		public static string ProgramDirectory
		{
			get
			{
				return Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
			}
		}

		/// <summary>
		/// The location of the User settings.  If <see cref="UseAppData"/> is true then this will return
		/// a path under <see cref="AppDataPath"/> otherwise it will be under <see cref="ProgramDirectory"/>.
		/// </summary>
		public static string UserSettingsPath
		{
			get
			{
				if (UseAppData)
					return Path.Combine(AppDataPath, @"Settings\User");
				else
					return Path.Combine(Path.Combine(ProgramDirectory, @"Settings\User"), Environment.UserName);
			}
		}

		/// <summary>
		/// The location of the Global settings.  If <see cref="UseAppData"/> is true then this will return
		/// a path under <see cref="CommonAppDataPath"/> otherwise it will be under <see cref="ProgramDirectory"/>.
		/// </summary>
		public static string GlobalSettingsPath
		{
			get
			{
				if (UseAppData)
					return Path.Combine(CommonAppDataPath, @"Settings\Global");
				else
					return Path.Combine(ProgramDirectory, @"Settings\Global");
			}
		}

		/// <summary>
		/// The location of the Default User settings.  Currently this is always under <see cref="ProgramDirectory"/>.
		/// </summary>
		public static string DefaultUserSettingsPath
		{
			get
			{
				return Path.Combine(ProgramDirectory, @"Settings\#Default#");
			}
		}

		/// <summary>
		/// The location of the Default Global settings.  Currently this is always under <see cref="ProgramDirectory"/>.
		/// </summary>
		public static string DefaultGlobalSettingsPath
		{
			get
			{
				return Path.Combine(ProgramDirectory, @"Settings\#DefaultGlobal#");
			}
		}

		/// <summary>
		/// The location of the SharpEnviro directory in <see cref="Environment.SpecialFolder.ApplicationData"/>.
		/// </summary>
		public static string AppDataPath
		{
			get
			{
				return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "SharpEnviro");
			}
		}

		/// <summary>
		/// The location of the SharpEnviro directory in <see cref="Environment.SpecialFolder.CommonApplicationData"/>.
		/// </summary>
		public static string CommonAppDataPath
		{
			get
			{
				return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData), "SharpEnviro");
			}
		}

		/// <summary>
		/// Whether or not to use <see cref="AppDataPath"/> and <see cref="CommonAppDataPath"/> for storing settings.
		/// </summary>
		public static bool UseAppData
		{
			get
			{
				object result = Registry.GetValue(@"HKEY_LOCAL_MACHINE\Software\SharpEnviro", "UseAppData", false);

				if (result == null)
					return false;
				else
					return Convert.ToBoolean(result);
			}
		}
	}
}
