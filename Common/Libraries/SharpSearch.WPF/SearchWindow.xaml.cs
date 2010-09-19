using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Windows.Threading;

using SharpSearch;
using SharpEnviro.Interop;
using SharpEnviro.Interop.Enums;

namespace SharpSearch.WPF
{
	/// <summary>
	/// Interaction logic for SearchWindow.xaml
	/// </summary>
	public partial class SearchWindow : Window
	{
		public SearchWindow()
		{
			InitializeComponent();

			// To making debugging a little easier we show the window
			// in the taskbar which also causes it to show in Alt+Tab
			if (Debugger.IsAttached)
				ShowInTaskbar = true;

			_keyPressedTimer = new Timer(new TimerCallback(ProcessKeyPress), null, Timeout.Infinite, Timeout.Infinite);

			_searchManager = new SearchManager();
			ResultsListBox.DataContext = _searchManager.SearchResults;

			//// If both X and Y were set on the command line then override displaying the window
			//// in the center of the monitor (default).
			//if (App.InitialPosition.X != double.MinValue &&
			//    App.InitialPosition.Y != double.MinValue)
			//{
			//    WindowStartupLocation = System.Windows.WindowStartupLocation.Manual;
			//    Left = App.InitialPosition.X;
			//    Top = App.InitialPosition.Y;
			//}

			//if (!String.IsNullOrEmpty(App.InitialQuery))
			//    QueryTextBox.Text = App.InitialQuery;
			//else
				// Simulate the change event so that the MostLaunched will be displayed.
				_keyPressedTimer.Change(TimeSpan.FromMilliseconds(0), TimeSpan.FromMilliseconds(-1));

			QueryTextBox.Focus();
		}

		private void OnClose(object sender, CancelEventArgs e)
		{
			// Keep track that the user has closed the window so we don't
			// try and close again in the Deactivated event.
			_closing = true;

			if (_keyPressedTimer != null)
				_keyPressedTimer.Dispose();

			if (_searchManager != null)
				_searchManager.Dispose();
		}

		private void ProcessKeyPress(object state)
		{
			// Execute the search asynchronously on a thread associated with the Dispacther.
			// We do this because the SearchManager populates a ObservableCollection which
			// is bound to the ListBox.
			Dispatcher.BeginInvoke(DispatcherPriority.Normal, (ThreadStart)delegate
			{
				if (String.IsNullOrEmpty(QueryTextBox.Text))
					_searchManager.MostLaunched(20);
				else
					// For now we just query the database when the text changes every time.
					// If this becomes a problem then we'll look at running this an a background thread.
					_searchManager.Search(QueryTextBox.Text);

				if (ResultsListBox.Items.Count > 0)
					ResultsListBox.SelectedIndex = 0;
			});
		}

		/// <summary>
		/// The user changed the text so we cancel the existing search and wait
		/// for the timer to expire before starting the new search.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void QueryTextBox_TextChanged(object sender, TextChangedEventArgs e)
		{
			// We use a timer to throttle how many queries we perform against the database as for the
			// most part a user will type a few characters at a time.
			_keyPressedTimer.Change(TimeSpan.FromMilliseconds(250), TimeSpan.FromMilliseconds(-1));
		}

		/// <summary>
		/// Handle any special key press logic like Escape to close the window.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void SearchWindow_KeyUp(object sender, KeyEventArgs e)
		{
			e.Handled = true;

			switch (e.Key)
			{
				case Key.Escape:
					Hide();
					//Close();
					break;
				case Key.Enter:
					StartProcessAndExit();
					break;
				default:
					e.Handled = false;
					break;
			}
		}

		/// <summary>
		/// Handle any special key press logic like Up and Down arrow.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void SearchWindow_PreviewKeyDown(object sender, KeyEventArgs e)
		{
			e.Handled = true;

			// For the Up and Down arrows we change the SelectedItem of the ListBox and scroll it into view.
			// We also make it so that they continue from the top or bottom of the list depending on which was pressed.
			switch (e.Key)
			{
				case Key.Up:
					if (ResultsListBox.Items.Count == 0)
						break;

					if (ResultsListBox.SelectedIndex < 1)
					{
						ResultsListBox.SelectedIndex = ResultsListBox.Items.Count - 1;
						ResultsListBox.ScrollIntoView(ResultsListBox.SelectedItem);
						break;
					}

					ResultsListBox.SelectedIndex--;
					ResultsListBox.ScrollIntoView(ResultsListBox.SelectedItem);
					break;
				case Key.Down:
					if (ResultsListBox.Items.Count == 0)
						break;

					if (ResultsListBox.SelectedIndex == ResultsListBox.Items.Count - 1 || ResultsListBox.SelectedIndex == -1)
					{
						ResultsListBox.SelectedIndex = 0;
						ResultsListBox.ScrollIntoView(ResultsListBox.SelectedItem);
						break;
					}

					ResultsListBox.SelectedIndex++;
					ResultsListBox.ScrollIntoView(ResultsListBox.SelectedItem);
					break;
				default:
					e.Handled = false;
					break;
			}
		}

		private void ResultsListBox_MouseDoubleClick(object sender, MouseButtonEventArgs e)
		{
			StartProcessAndExit();
		}

		/// <summary>
		/// Start the selected item and exit, if no item is selected then this is a no op.
		/// </summary>
		/// <param name="elevate">Whether or not the item should be run as administrator.</param>
		private void StartProcessAndExit(bool elevate)
		{
			if (ResultsListBox.SelectedItem != null)
			{
				_searchManager.IncrementLaunchCount(((ISearchData)ResultsListBox.SelectedItem).RowID);

				try
				{
					ProcessStartInfo psi = new ProcessStartInfo();
					psi.FileName = ((ISearchData)ResultsListBox.SelectedItem).Location;

					if (elevate)
						psi.Verb = "runas";

					Process.Start(psi);
				}
				catch
				{
					// Squash all exceptions such as FileNotFoundException and
					// Win32Exception which occurs when user cancel elevation request.
				}

				Hide();
				//Close();
			}
		}

		/// <summary>
		/// Start the selected item and exit, if no item is selected then this is a no op.
		/// </summary>
		private void StartProcessAndExit()
		{
			StartProcessAndExit(false);
		}

		/// <summary>
		/// Close the window once it becomes deactivated.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void SearchWindow_Deactivated(object sender, EventArgs e)
		{
			if (!_closing && !Debugger.IsAttached)
				Hide();
				//Close();
		}

		/// <summary>
		/// Change the window style so that it will not show in Alt+Tab by add the WS_EX_TOOLWINDOW style.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void SearchWindow_Loaded(object sender, RoutedEventArgs e)
		{
            WindowInteropHelper windowHelper = new WindowInteropHelper(this);

            int style = (int)PInvoke.GetWindowLongPtr(windowHelper.Handle, (int)GWL.EXSTYLE);

            if (style == 0)
                throw new Win32Exception(Marshal.GetLastWin32Error());

            style |= (int)WindowStylesExtended.WS_EX_TOOLWINDOW;

            // Clear the last error before calling SetWindowLongPtr because it does not clear it.
            PInvoke.SetLastError(0);

            int result = (int)PInvoke.SetWindowLongPtr(windowHelper.Handle, (int)GWL.EXSTYLE, (IntPtr)style);

            if (result == 0)
                throw new Win32Exception(Marshal.GetLastWin32Error());
		}

		private void LaunchElevatedMenuItem_Click(object sender, RoutedEventArgs e)
		{
			StartProcessAndExit(true);
		}

		private void LaunchMenuItem_Click(object sender, RoutedEventArgs e)
		{
			StartProcessAndExit();
		}

		private SearchManager _searchManager;
		private Timer _keyPressedTimer;
		private bool _closing = false;


		private void SearchWindow_Activated(object sender, EventArgs e)
        {
            WindowInteropHelper windowHelper = new WindowInteropHelper(this);

            IntPtr hWnd = windowHelper.Handle;

            PInvoke.ShowWindowAsync(hWnd, PInvoke.SW_SHOW);
            PInvoke.SetForegroundWindow(hWnd);

            // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
            // Converted to Delphi by Ray Lischner
            // Published in The Delphi Magazine 55, page 16
            // Converted to C# by Kevin Gale
            IntPtr foregroundWindow = PInvoke.GetForegroundWindow();
            IntPtr Dummy = IntPtr.Zero;

            uint foregroundThreadId = PInvoke.GetWindowThreadProcessId(foregroundWindow, Dummy);
            uint thisThreadId = PInvoke.GetWindowThreadProcessId(hWnd, Dummy);

            if (PInvoke.AttachThreadInput(thisThreadId, foregroundThreadId, true))
            {
                PInvoke.BringWindowToTop(hWnd); // IE 5.5 related hack
                PInvoke.SetForegroundWindow(hWnd);
                PInvoke.AttachThreadInput(thisThreadId, foregroundThreadId, false);
            }

            if (PInvoke.GetForegroundWindow() != hWnd)
            {
                PInvoke.SystemParametersInfo(PInvoke.SPI_GETFOREGROUNDLOCKTIMEOUT, 0, IntPtr.Zero, 0);
                PInvoke.SystemParametersInfo(PInvoke.SPI_SETFOREGROUNDLOCKTIMEOUT, 0, IntPtr.Zero, PInvoke.SPIF_SENDCHANGE);
                PInvoke.BringWindowToTop(hWnd);
                PInvoke.SetForegroundWindow(hWnd);
            }

			hWnd = IntPtr.Zero;
        }
	}
}
