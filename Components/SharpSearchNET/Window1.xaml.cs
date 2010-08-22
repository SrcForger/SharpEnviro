using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Threading;
using System.Collections.ObjectModel;
using System.Windows.Threading;
using System.Diagnostics;
using System.Windows.Interop;

using SharpSearch;
using SharpEnviro.Interop;
using SharpEnviro.Interop.Enums;
using System.Runtime.InteropServices;

namespace SharpSearchNET
{
	/// <summary>
	/// Interaction logic for ResultWindow.xaml
	/// </summary>
	public partial class Window1 : Window
	{
		public Window1()
		{
			InitializeComponent();

			// To making debugging a little easier we show the window
			// in the taskbar which also causing it to show in Alt+Tab
			if (Debugger.IsAttached)
				ShowInTaskbar = true;

			_keyPressedTimer = new Timer(new TimerCallback(ProcessKeyPress), null, Timeout.Infinite, Timeout.Infinite);

			_searchManager = new SearchManager();
			ResultsListBox.DataContext = _searchManager.SearchResults;

			// If both X and Y were set on the command line then override displaying the window
			// in the center of the monitor (default).
			if (App.InitialPosition.X != double.MinValue &&
				App.InitialPosition.Y != double.MinValue)
			{
				WindowStartupLocation = System.Windows.WindowStartupLocation.Manual;
				Left = App.InitialPosition.X;
				Top = App.InitialPosition.Y;
			}

			if (!String.IsNullOrEmpty(App.InitialQuery))
				QueryTextBox.Text = App.InitialQuery;

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
				{
					_searchManager.SearchResults.Clear();
					return;
				}

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
		private void ResultWindow_KeyUp(object sender, KeyEventArgs e)
		{
			e.Handled = true;

			switch (e.Key)
			{
				case Key.Escape:
					Close();
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
		private void ResultWindow_PreviewKeyDown(object sender, KeyEventArgs e)
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
		private void StartProcessAndExit()
		{
			if (ResultsListBox.SelectedItem != null)
			{
				_searchManager.IncrementLaunchCount(((ISearchData)ResultsListBox.SelectedItem).RowID);

                try
                {
                    Process.Start(((ISearchData)ResultsListBox.SelectedItem).Location);
                }
                catch(System.IO.FileNotFoundException)
                {
                }

				Close();
			}
		}

		/// <summary>
		/// Close the window once it becomes deactivated.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void ResultWindow_Deactivated(object sender, EventArgs e)
		{
			if (!_closing && !Debugger.IsAttached)
				Close();
		}

		/// <summary>
		/// Change the window style so that it will not show in Alt+Tab by add the WS_EX_TOOLWINDOW style.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void ResultWindow_Loaded(object sender, RoutedEventArgs e)
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

		private SearchManager _searchManager;
		private Timer _keyPressedTimer;
        private bool _closing = false;
	}
}
