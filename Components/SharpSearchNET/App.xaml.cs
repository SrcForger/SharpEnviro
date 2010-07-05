using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Windows;
using System.IO;
using System.Threading;
using System.Reflection;

namespace SharpSearchNET
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        public Mutex LockMuteX; 

        public static string InitialQuery = null;
        public static Point InitialPosition;

        private void Application_Startup(object sender, StartupEventArgs e)
        {
            bool createdNew = false;
            LockMuteX = new Mutex(true, "SharpSearch", out createdNew);

			if (!createdNew)
				//TODO: Close or activate the existing window?
				App.Current.Shutdown((int)ExitCode.AlreadyRunning);

            InitialPosition.X = double.MinValue;
            InitialPosition.Y = double.MinValue;

            foreach (string arg in e.Args)
            {
                if (arg.ToLower().StartsWith("-q:"))
                {
                    InitialQuery = arg.Substring(3).Trim('\"');
                }
                else if (arg.ToLower().StartsWith("-x:"))
                {
                    InitialPosition.X = Convert.ToInt32(arg.Substring(3));
                }
                else if (arg.ToLower().StartsWith("-y:"))
                {
                    InitialPosition.Y = Convert.ToInt32(arg.Substring(3));
                }
            }

			// We need to hook into the AssemblyResolve event to load the appropriate version (x86 or x64).
			// We set the properties on the reference to NOT copy local to avoid running against a local copy.
			// The 2 dlls are expected to be in a subfolder structure of SQLite\x86 and SQLite\x86 which is
			// handled by having them included in the SharpSearch.dll with the same folder structure.
			AppDomain.CurrentDomain.AssemblyResolve += (s, args) =>
			{
				if (!args.Name.StartsWith("System.Data.SQLite,"))
					return null;

				if (IntPtr.Size == 8)
					return Assembly.LoadFrom(@"SQLite\x64\System.Data.SQLite.DLL");
				else
					return Assembly.LoadFrom(@"SQLite\x86\System.Data.SQLite.DLL");
			};
        }
    }
}
