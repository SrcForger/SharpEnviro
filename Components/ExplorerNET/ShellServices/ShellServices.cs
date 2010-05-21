using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Win32;
//using NLog;

namespace Explorer.ShellServices
{
	public static class ShellServices
	{
		private static Guid CGID_ShellServiceObject = new Guid("000214D2-0000-0000-C000-000000000046");
		private static List<IOleCommandTarget> _shellServiceObjects = new List<IOleCommandTarget>();
		private static bool _isRunning = false;
		//private static Logger _logger = LogManager.GetCurrentClassLogger();

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
			using (RegistryKey key = keyLM.OpenSubKey("Software\\Microsoft\\Windows\\CurrentVersion\\ShellServiceObjectDelayLoad"))
			{
				if (key == null)
					return;

				foreach (string valueName in key.GetValueNames())
				{
					string value = (string)key.GetValue(valueName);
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
					//_logger.LogException(LogLevel.Error, "Exception trying to unload the shell service objects.", e);
				}
			}
			_shellServiceObjects.Clear();
		}
	}
}
