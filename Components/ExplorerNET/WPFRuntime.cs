using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Windows;
using System.Windows.Forms.Integration;
using System.Windows.Threading;

namespace Explorer
{
	public class WPFRuntime
	{
		private WPFRuntime()
		{
			// Create a STA thread because WPF requires it.
			_thread = new Thread(Run);
			_thread.SetApartmentState(ApartmentState.STA);
		}

		private Window _window;
		private Application _application;
		private Thread _thread;
		private static WPFRuntime _runtime;

		public static WPFRuntime Instance
		{
			get
			{
				// Get the WPFRuntime singleton instance and create one if needed
				lock (typeof(WPFRuntime))
				{
					if (_runtime == null)
						_runtime = new WPFRuntime();
					return _runtime;
				}
			}
		}

		private void Run()
		{
			// Create the WPF application
			_application = new Application();
			// Create a new empty window
			_window = new Window();
			// Start the WPF message loop
			_application.Run();
		}

		public void Start()
		{
			// Start the WPFRuntime thread
			_thread.Start();
		}

		public void Stop()
		{
			// Ask the WPF thread to end itself
			_application.Dispatcher.Invoke(DispatcherPriority.Normal, new ShowDelegate(InternalShutDown));
		}

		private void InternalShutDown()
		{
			// End the WPF thread by closing the main (hidden) window
			_window.Close();
		}

		public void Show<T>() where T : Window
		{
			// Ask the WPF thread to create a new window of the provided type
			_application.Dispatcher.Invoke(DispatcherPriority.Normal, new ShowDelegate(InternalShow<T>));
		}

		private delegate void ShowDelegate();

		private void InternalShow<T>() where T : Window
		{
			// Create a new instance of the window
			Window w = Activator.CreateInstance<T>();
			ElementHost.EnableModelessKeyboardInterop(w);
			// show it...
			w.Show();
			w.Activate();
		}
	}
}
