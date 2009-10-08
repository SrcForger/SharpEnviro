using System;
using System.Collections.Generic;
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
        Thread searchThread;
        Thread updateThread;
        public List<SearchResult> searchResults;
        public List<SearchResultData> searchResultsData;
        string searchQuery;

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
                ApplyDataBinding(false);

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
                tbStatus.Text = "Searching... " + item.Name;
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
            searchQuery = App.InitialQuery;
            searchResults = new List<SearchResult>();
            searchResultsData = new List<SearchResultData>();

            searchCallback = new SearchCallback();
            searchCallback.OnNewResult += new ItemChangeHandler(NewResult);
            searchCallback.OnRemoveResult += new ItemChangeHandler(RemoveResult);
            searchCallback.OnFinishLocation += new LocationChangeHandler(FinishLocation);
            searchCallback.OnStartLocation += new LocationChangeHandler(StartLocation);
            searchCallback.OnFinishSearch += new SearchEventHandler(FinishSearch);

			if (!String.IsNullOrEmpty(searchQuery))
			{
				searchThread = new Thread(new ThreadStart(DoSearch));
				searchThread.Start();
			}

            Left = App.InitialPosition.X;
            Top = App.InitialPosition.Y;
            edtQuery.Text = App.InitialQuery;
			edtQuery.Focus();
         }

        private void DoSearch()
        {
            searchResults.Clear();
            searchMgr.DoDatabaseSearch(searchQuery, searchResults, searchCallback);
            searchMgr.DoSearch(searchQuery,searchResults,searchCallback);
        }

        private void DoUpdate()
        {
            searchMgr.UpdateSearch(searchQuery, searchResults, searchCallback);
        }

        private void edtQuery_TextChanged(object sender, TextChangedEventArgs e)
        {
			if (edtQuery.Text == searchQuery)
				return;

			if (String.IsNullOrEmpty(searchQuery) && searchThread == null)
			{
				searchQuery = edtQuery.Text;
				searchThread = new Thread(new ThreadStart(DoSearch));
				searchThread.Start();
			}
			else if (edtQuery.Text.Length > searchQuery.Length)
			{
				// a new character has been entered
                if (updateThread != null)
                {
                    updateThread.Abort();
                    updateThread = null;
                }                

                searchQuery = edtQuery.Text;
                updateThread = new Thread(new ThreadStart(DoUpdate));
                updateThread.Start();
			}
			else
			{
				// a character was removed, we aren't caching previous results - so start search again
				searchQuery = edtQuery.Text;
				if (searchThread != null)
				{
					searchThread.Abort();
					searchThread = null;
				}

				searchResults.Clear();
				ApplyDataBinding(true);

				searchThread = new Thread(new ThreadStart(DoSearch));
				searchThread.Start();
			}
        }

        public void ApplyDataBinding(bool reset)
        {
            lstResults.ItemsSource = null;
            if (reset)
            {
                searchResultsData.Clear();
                foreach (SearchResult searchResult in searchResults)
                    searchResultsData.Add(new SearchResultData(searchResult.Name, searchResult.Description, searchResult.Location));
            }
            lstResults.ItemsSource = searchResultsData;
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
