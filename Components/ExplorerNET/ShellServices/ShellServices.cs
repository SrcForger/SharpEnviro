using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Win32;
using NLog;

namespace Explorer.ShellServices
{
	public static class ShellServices
	{
		private static Guid CGID_ShellServiceObject = new Guid("000214D2-0000-0000-C000-000000000046");
		private static List<IOleCommandTarget> _shellServiceObjects = new List<IOleCommandTarget>();
		private static bool _isRunning = false;
		private static Logger _logger = LogManager.GetCurrentClassLogger();

		private const string SSORegKey = "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellServiceObjects";
		private const string SSODelayLoadRegKey = "Software\\Microsoft\\Windows\\CurrentVersion\\ShellServiceObjectDelayLoad";

		public static void Start()
		{
			if (_isRunning)
				return;

			LoadShellServiceObjects();

			_isRunning = true;
		}

		public static void Stop()
		{
			if (!_isRunning)
				return;

			UnloadShellServiceObjects();

			_isRunning = false;
		}

		public static void Restart()
		{
			Stop();
			Start();
		}

		private static void LoadShellServiceObjects()
		{
			LoadShellServiceObjectsVista();
			LoadShellServiceObjectsXP();
		}

		/// <summary>
		/// Load shell service objects for Vista and above.
		/// </summary>
		private static void LoadShellServiceObjectsVista()
		{
			if (Environment.OSVersion.Version.Major < 6)
				return;

			ShellServiceObject sso = new ShellServiceObject();
			StartSSO((IOleCommandTarget)sso);
		}

		/// <summary>
		/// Load shell service objects for XP.
		/// </summary>
		private static void LoadShellServiceObjectsXP()
		{
			using (RegistryKey keyLM = Registry.LocalMachine)
			using (RegistryKey keySSO = keyLM.OpenSubKey(SSORegKey))
			using (RegistryKey keySSODelayLoad = keyLM.OpenSubKey(SSODelayLoadRegKey))
			{
				if (keySSODelayLoad == null)
					return;

				string[] vistaKeys = null;
				// Get a list of the GUIDs for Vista style SSOs.
				if (keySSO != null && Environment.OSVersion.Version.Major > 5)
					vistaKeys = keySSO.GetSubKeyNames();

				foreach (string valueName in keySSODelayLoad.GetValueNames())
				{
					string value = (string)keySSODelayLoad.GetValue(valueName);

					// If the XP style key is also listed as a Vista style key then we
					// will let the vista loading handle the key and continue.
					if (vistaKeys != null && vistaKeys.Contains<string>(value))
						continue;

					Guid ssoGuid = new Guid(value.Replace("{", "").Replace("}", ""));
					Type ssoType = Type.GetTypeFromCLSID(ssoGuid);

					// Only load COM objects.
					if (!ssoType.IsCOMObject)
						continue;

					try
					{
						StartSSO((IOleCommandTarget)Activator.CreateInstance(ssoType));
					}
					catch
					{
						// Squash any exceptions, as in the case when the type is not registered properly.
					}
				}
			}
		}

		private static void StartSSO(IOleCommandTarget cmdTarget)
		{
			object o = new object();
			cmdTarget.Exec(ref CGID_ShellServiceObject, (int)OleCommandID.New, (int)OleCommandExecOption.DoDefault, ref o, ref o);
			_shellServiceObjects.Add(cmdTarget);
		}

		private static void UnloadShellServiceObjects()
		{
			foreach (IOleCommandTarget cmdTarget in _shellServiceObjects)
			{
				try
				{
					object o = new object();
					cmdTarget.Exec(ref CGID_ShellServiceObject, (int)OleCommandID.Save, (int)OleCommandExecOption.DoDefault, ref o, ref o);
				}
				catch(Exception e)
				{
					_logger.LogException(LogLevel.Error, "Exception trying to unload the shell service objects.", e);
				}
			}
			_shellServiceObjects.Clear();
		}
	}
}
