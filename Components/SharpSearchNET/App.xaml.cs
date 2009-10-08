using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Windows;
using System.IO;
using System.Threading;
using SharpSearchNET.Locations;

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
                Environment.Exit((int)ExitCode.AlreadyRunning);

            InitialPosition.X = -100000;
            InitialPosition.Y = -100000;
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

            if ((InitialPosition.X == -100000) || (InitialPosition.Y == -100000))
            {
                Environment.Exit((int)ExitCode.InvalidPosition);
            }
        }
    }
}
