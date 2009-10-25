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

namespace SharpSearchNET
{
    /// <summary>
    /// Interaction logic for ResultWindow.xaml
    /// </summary>
    public partial class Window1 : Window
    {
        SearchManager searchMgr;
        SearchCallback searchCallback;
        public List<SearchResult> searchResults;
        public List<SearchResultData> searchResultsData;

        BackgroundWorker SearchBw = new BackgroundWorker();
        volatile bool searchUpdate = false, searchCancel = false, searchClose = false;

        string searchQuery, pendingSearchQuery;

        private void RemoveResult(SearchResult item)
        {
            Dispatcher.Invoke(DispatcherPriority.Normal, (ThreadStart)delegate
            {
                foreach (SearchResultData searchResultData in searchResultsData)
                {
                    //if ((searchResultData.Name.Equals(item.Name)) && (searchResultData.Description.Equals(item.Description)) && (searchResultData.Location.Equals(item.Location)))
                    if (searchResultData.Location.Equals(item.Location))
                    {
                        searchResultsData.Remove(searchResultData);
                        break;
                    }
                }
                ApplyDataBinding(true);

				if (lstResults.Items.Count > 0)
					lstResults.SelectedIndex = 0;
            });
        }
        
        private void NewResult(SearchResult item)
        {
            Dispatcher.Invoke(DispatcherPriority.Normal, (ThreadStart)delegate
            {
                searchResultsData.Add(new SearchResultData(item.Name, item.Description, item.Location));
                ApplyDataBinding(false);
            });
        }

        private void StartLocation(ISearchLocation item)
        {
            Dispatcher.Invoke(DispatcherPriority.Normal, (ThreadStart)delegate
            {
                tbStatus.Text = "Searching for " + searchQuery + "... " + item.Name;
            });
        }

        private void FinishLocation(ISearchLocation item)
        {

        }

        private void FinishSearch()
        {
            Dispatcher.Invoke(DispatcherPriority.Normal, (ThreadStart)delegate
            {
                tbStatus.Text = "Finished Searching!";

				if (lstResults.Items.Count > 0)
					lstResults.SelectedIndex = 0;
            });
        }

        public Window1()
        {
            InitializeComponent();

            searchMgr = new SearchManager();
            searchQuery = "";
            pendingSearchQuery = App.InitialQuery;
            searchResults = new List<SearchResult>();
            searchResultsData = new List<SearchResultData>();

            SearchBw.WorkerSupportsCancellation = true;
            SearchBw.DoWork += new DoWorkEventHandler(RunWorker);
            SearchBw.RunWorkerCompleted += new RunWorkerCompletedEventHandler(RunWorkerComplete);

            searchCallback = new SearchCallback();
            searchCallback.OnNewResult += new ItemChangeHandler(NewResult);
            searchCallback.OnRemoveResult += new ItemChangeHandler(RemoveResult);
            searchCallback.OnFinishLocation += new LocationChangeHandler(FinishLocation);
            searchCallback.OnStartLocation += new LocationChangeHandler(StartLocation);
            searchCallback.OnFinishSearch += new SearchEventHandler(FinishSearch);

            Left = App.InitialPosition.X;
            Top = App.InitialPosition.Y;
            edtQuery.Text = App.InitialQuery;
			edtQuery.Focus();
         }

        private void OnClose(object sender, CancelEventArgs e) 
        {
            if (SearchBw.IsBusy)
            {
                SearchBw.CancelAsync();
                searchClose = true;
                e.Cancel = true;
            }
        }

        private void DoSearch(BackgroundWorker bw)
        {
            if (searchQuery != null)
            {
                if (!searchUpdate)
                {
                    searchResults.Clear();
                    searchCancel = !searchMgr.DoSearch(searchQuery, searchResults, searchCallback, bw);
                }
                else
                    searchCancel = !searchMgr.UpdateSearch(searchQuery, searchResults, searchCallback, bw);
            }
        }

        private void SetSearchQuery(bool Restart)
        {
            Dispatcher.Invoke(DispatcherPriority.Normal, (ThreadStart)delegate
            {
                if (pendingSearchQuery.Length <= 0 || pendingSearchQuery == searchQuery)
                    return;

                if (!searchCancel && pendingSearchQuery.Length > searchQuery.Length && searchQuery != "")
                    searchUpdate = true;
                else
                {
                    searchResults.Clear();
                    ApplyDataBinding(true);
                    searchUpdate = false;
                }

                searchQuery = pendingSearchQuery;

                pendingSearchQuery = "";

                if (Restart)
                    SearchBw.RunWorkerAsync();
            });
        }

        private void RunWorker(object sender, DoWorkEventArgs e)
        {
            BackgroundWorker bw = sender as BackgroundWorker;
            DoSearch(bw);
        }

        private void RunWorkerComplete(object sender, RunWorkerCompletedEventArgs e)
        {
            if (searchClose)
                Close();
            else
            {
                SetSearchQuery(searchCancel);
                searchCancel = false;
            }
        }

        private void edtQuery_TextChanged(object sender, TextChangedEventArgs e)
        {
            Dispatcher.Invoke(DispatcherPriority.Normal, (ThreadStart)delegate
            {
                pendingSearchQuery = edtQuery.Text;

                if (SearchBw.IsBusy)
                    SearchBw.CancelAsync();
                else
                    SetSearchQuery(true);
            });
        }

        public void ApplyDataBinding(bool reset)
        {
            this.lstResults.ItemsSource = null;
            if (reset)
            {
                searchResultsData.Clear();
                foreach (SearchResult searchResult in searchResults)
                    searchResultsData.Add(new SearchResultData(searchResult.Name, searchResult.Description, searchResult.Location));
            }
            this.lstResults.ItemsSource = searchResultsData;
        }

		private void ResultWindow_KeyUp(object sender, KeyEventArgs e)
		{
			e.Handled = true;

			switch (e.Key)
			{
				case Key.Escape:
					Environment.Exit(0);
					break;
				case Key.Tab:
					break;
				case Key.Up:
					if (lstResults.Items.Count > 0 && lstResults.SelectedIndex > 0)
						lstResults.SelectedIndex--;
					break;
				case Key.Down:
					if (lstResults.Items.Count > 0)
						lstResults.SelectedIndex++;
					break;
				case Key.Enter:
					StartProcessAndExit();
					break;
				default:
					e.Handled = false;
					break;
			}
		}

		private void lstResults_MouseDoubleClick(object sender, MouseButtonEventArgs e)
		{
			StartProcessAndExit();
		}

		/// <summary>
		/// Start the selected item and exit, if no item is selected then this is a no op.
		/// </summary>
		private void StartProcessAndExit()
		{
			if (lstResults.SelectedItem != null)
			{
				Process.Start(((SearchResultData)lstResults.SelectedItem).Location);
				Environment.Exit(0);
			}
		}
    }
}
