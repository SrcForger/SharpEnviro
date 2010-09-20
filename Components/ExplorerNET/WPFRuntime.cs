﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Windows;
using System.Windows.Forms.Integration;
using System.Windows.Threading;
using NLog;

namespace Explorer
{
	public class WPFRuntime
	{
		private WPFRuntime()
		{
			// Create a STA thread because WPF requires it.
			_thread = new Thread(Run);
			_thread.SetApartmentState(ApartmentState.STA);

			_logger.Info("WPFRuntime created.");
		}

		private Window _window;
		private Application _application;
		private Thread _thread;
		private Window _windowInstance;
		private static WPFRuntime _runtime;
		private static object _sync = new object();

		public static WPFRuntime Instance
		{
			get
			{
				// Get the WPFRuntime singleton instance and create one if needed
				lock (_sync)
				{
					if (_runtime == null)
						_runtime = new WPFRuntime();
					return _runtime;
				}
			}
		}

		private void Run()
		{
			_logger.Info("WPFRuntime.Run enter.");
			// Create the WPF application
			_application = new Application();
			// Create a new empty window
			_window = new Window();
			// Start the WPF message loop
			_application.Run();
			_logger.Info("WPFRuntime.Run exit.");
		}

		public void Start()
		{
			// Start the WPFRuntime thread
			_thread.Start();
			_logger.Info("WPFRuntime thread started.");
		}

		public void Stop()
		{
			// Ask the WPF thread to end itself
			_application.Dispatcher.Invoke(DispatcherPriority.Normal, new ShowDelegate(InternalShutDown));
		}

		private void InternalShutDown()
		{
			if(_windowInstance != null)
				_windowInstance.Close();
			// End the WPF thread by closing the main (hidden) window
			_window.Close();
			_logger.Info("WPFRuntime window closed.");
		}

		public void Show<T>() where T : Window
		{
			// Ask the WPF thread to create a new window of the provided type
			_application.Dispatcher.Invoke(DispatcherPriority.Normal, new ShowDelegate(InternalShow<T>));
		}

		private delegate void ShowDelegate();

		private void InternalShow<T>() where T : Window
		{
			if (_windowInstance == null)
			{
				// Create a new instance of the window
				_windowInstance = Activator.CreateInstance<T>();
				_logger.Info("WPFRuntime window created.");
			}

			_windowInstance.WindowStartupLocation = WindowStartupLocation.CenterScreen;

			if (_windowInstance.IsVisible)
				_windowInstance.Hide();
			else
			{
				//ElementHost.EnableModelessKeyboardInterop(w);
				// show it...
				_windowInstance.Show();
				_windowInstance.Activate();
			}

			_logger.Info("WPFRuntime.InternalShow exit.");
		}

		private static Logger _logger = LogManager.GetCurrentClassLogger();
	}
}
