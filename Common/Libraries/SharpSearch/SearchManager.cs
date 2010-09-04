using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using System.Windows;
using System.IO;
using System.Xml.Serialization;
using System.ComponentModel;

namespace SharpSearch
{
	/// <summary>
	/// A search manager for query the <see cref="SharpSearchDatabase"/> and indexing <see cref="SearchLocation"/> items.
	/// </summary>
	public class SearchManager :
		IDisposable
	{
		#region Constructors

		/// <summary>
		/// Constructor.
		/// </summary>
		public SearchManager()
		{
			//TODO: Index periodically and not just the 1st time.  Maybe add a commandline option to force indexing also.
			bool needsIndexing = !File.Exists(Path.Combine(SharpSearchDatabase.DefaultDatabaseDirectory, SharpSearchDatabase.DefaultDatabaseFilename));

			_database = new SharpSearchDatabase();
			_searchResults = new ObservableCollection<ISearchData>();
			_searchLocations = new List<SearchLocation>();

			LoadLocations();

			if (needsIndexing)
				StartIndexing();
		}

		#endregion Constructors

		#region publics

		/// <summary>
		/// A collection of items that matched the pattern from the last search.
		/// </summary>
		public ObservableCollection<ISearchData> SearchResults
		{
			get { return _searchResults; }
			set { _searchResults = value; }
		}

		/// <summary>
		/// Query the databse for items matching the specified pattern.
		/// </summary>
		/// <param name="searchPattern">The pattern to use when searching for matches.</param>
		public void Search(string searchPattern)
		{
			IEnumerable<ISearchData> results = _database.Search(searchPattern);
			SearchResults.Clear();
			foreach (ISearchData item in results)
				SearchResults.Add(item);
		}

		/// <summary>
		/// Query the database for the most launched items.
		/// </summary>
		/// <param name="numberOfItems">The number of items to be limited to, a negative number indicates unlimited.</param>
		public void MostLaunched(int numberOfItems)
		{
			IEnumerable<ISearchData> results = _database.SelectMostLaunched(numberOfItems);
			SearchResults.Clear();
			foreach (ISearchData item in results)
				SearchResults.Add(item);
		}

		/// <summary>
		/// Start indexing the search locations.
		/// </summary>
		public void StartIndexing()
		{
			//using (BackgroundWorker worker = new BackgroundWorker())
			//{
			//    worker.DoWork += (sender, args) =>
			//        {
			//            _database.IndexDirectories(_searchLocations.ToArray());
			//        };
			//    worker.RunWorkerAsync();
			//}

			if (_indexWorker == null)
				_indexWorker = new BackgroundWorker();

			_indexWorker.DoWork += (sender, args) =>
			{
				_database.IndexDirectories(_searchLocations.ToArray());
			};
			_indexWorker.RunWorkerAsync();
		}

		/// <summary>
		/// Indicates whether or not the indexing thread is running.
		/// </summary>
		public bool IsIndexing
		{
			get
			{
				return _indexWorker.IsBusy;
			}
		}

		/// <summary>
		/// Increment the rows launch count.
		/// </summary>
		/// <param name="rowID">The ROWID for which to increment the LaunchCount.</param>
		public void IncrementLaunchCount(Int64 rowID)
		{
			_database.IncrementLaunchCount(rowID);
		}

		#endregion publics

		#region privates

		/// <summary>
		/// The full path to the locations file.
		/// </summary>
		private string LocationsFilePath
		{
			get
			{
				return Path.Combine(SharpSearchDatabase.DefaultDatabaseDirectory, "Locations.xml");
			}
		}

		/// <summary>
		/// Load the search locations from the settings xml file.
		/// </summary>
		private void LoadLocations()
		{
			bool validSettingsFile = false;

			if (File.Exists(LocationsFilePath))
			{
				try
				{
					XmlSerializer serializer = new XmlSerializer(typeof(List<SearchLocation>));
					using (FileStream stream = File.OpenRead(LocationsFilePath))
					{
						_searchLocations = (List<SearchLocation>)serializer.Deserialize(stream);
					}
					validSettingsFile = true;
				}
				catch { }
			}

			if (!validSettingsFile)
			{
				// settings file doesn't exist or there was an error reading it, use default values
				_searchLocations.Add(new SearchLocation("Start Menu", "Windows Start Menu", "{AllUsersStartMenu}"));
				_searchLocations.Add(new SearchLocation("Start Menu", "Windows Start Menu", "{UserStartMenu}"));

				XmlSerializer serializer = new XmlSerializer(typeof(List<SearchLocation>));
				using (FileStream stream = File.OpenWrite(LocationsFilePath))
				{
					serializer.Serialize(stream, _searchLocations);
				}
			}
		}

		private List<SearchLocation> _searchLocations;
		private ObservableCollection<ISearchData> _searchResults;
		private SharpSearchDatabase _database;
		private BackgroundWorker _indexWorker;

		#endregion privates

		#region IDisposable Members

		/// <summary>
		/// Disposes of the object.
		/// </summary>
		public void Dispose()
		{
			Dispose(true);
			GC.SuppressFinalize(this);
		}

		/// <summary>
		/// Disposes of the object.
		/// </summary>
		protected virtual void Dispose(bool disposing)
		{
			if (_indexWorker != null) _indexWorker.Dispose();
			if (_database != null) _database.Dispose();
		}

		#endregion IDisposable Members
	}
}
