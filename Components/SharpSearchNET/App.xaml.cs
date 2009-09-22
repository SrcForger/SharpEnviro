﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Windows;
using System.IO;
using SharpSearchNET.Locations;

namespace SharpSearchNET
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        public static string InitialQuery = null;
        public static Point InitialPosition;

        private void Application_Startup(object sender, StartupEventArgs e)
        {
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

            if ((InitialPosition.X == -100000) || (InitialPosition.Y == -100000) || (InitialQuery == null) || (InitialQuery == String.Empty))
            {
                Environment.Exit(0);
            }
        }
    }
}
