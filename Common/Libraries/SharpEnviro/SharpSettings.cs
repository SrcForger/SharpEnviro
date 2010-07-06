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
                string result = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
                return result;
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
                string result;

				if (UseAppData)
					result = Path.Combine(AppDataPath, @"Settings\User");
				else
					result = Path.Combine(Path.Combine(ProgramDirectory, @"Settings\User"), Environment.UserName);

                return result;
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
                string result;

				if (UseAppData)
                    result = Path.Combine(CommonAppDataPath, @"Settings\Global");
				else
					result =  Path.Combine(ProgramDirectory, @"Settings\Global");

                return result;
			}
		}

		/// <summary>
		/// The location of the Default User settings.  Currently this is always under <see cref="ProgramDirectory"/>.
		/// </summary>
		public static string DefaultUserSettingsPath
		{
			get
			{
                string result = Path.Combine(ProgramDirectory, @"Settings\#Default#");
                return result;
			}
		}

		/// <summary>
		/// The location of the Default Global settings.  Currently this is always under <see cref="ProgramDirectory"/>.
		/// </summary>
		public static string DefaultGlobalSettingsPath
		{
			get
			{
                string result = Path.Combine(ProgramDirectory, @"Settings\#DefaultGlobal#");
                return result;
			}
		}

		/// <summary>
		/// The location of the SharpEnviro directory in <see cref="Environment.SpecialFolder.ApplicationData"/>.
		/// </summary>
		public static string AppDataPath
		{
			get
			{
                string result = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "SharpEnviro");
                return result;
			}
		}

		/// <summary>
		/// The location of the SharpEnviro directory in <see cref="Environment.SpecialFolder.CommonApplicationData"/>.
		/// </summary>
		public static string CommonAppDataPath
		{
			get
			{
                string result = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData), "SharpEnviro");
                return result;
			}
		}

		/// <summary>
		/// Whether or not to use <see cref="AppDataPath"/> and <see cref="CommonAppDataPath"/> for storing settings.
		/// </summary>
		public static bool UseAppData
		{
			get
			{
                object result = null;

                // The installer is 32-bit and on a 64-bit OS it write entries in the Wow6432Node section due to Registry Redirection.
                // Until we can find a better way accessing the Wow6432Node directly will have to do.
                if (IntPtr.Size == 8)
                    result = Registry.GetValue(@"HKEY_LOCAL_MACHINE\Software\Wow6432Node\SharpEnviro", "UseAppData", false);
                else
                    result = Registry.GetValue(@"HKEY_LOCAL_MACHINE\Software\SharpEnviro", "UseAppData", false);

				if (result == null)
					return false;
				else
					return Convert.ToBoolean(result);
			}
		}
	}
}
