using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using System.Windows;
using System.IO;
using System.Xml.Serialization;
using System.ComponentModel;
using System.Reflection;

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
			: this(false)
		{
		}

		/// <summary>
		/// Constructor.
		/// </summary>
		public SearchManager(bool watchDirectories)
		{
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

			_database = new SharpSearchDatabase();
			_searchResults = new ObservableCollection<ISearchData>();
			_searchLocations = new List<SearchLocation>();
			_indexWorker = new BackgroundWorker();
			_watchers = new List<FileSystemWatcher>();

			LoadLocations();

			// Only setup the watchers when we need to.
			if (watchDirectories)
				SetupFileSystemWatchers();
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
			//IEnumerable<ISearchData> results = _database.Search(searchPattern);
			SearchResults.Clear();
			foreach (ISearchData item in _database.Search(searchPattern))
				SearchResults.Add(item);
		}

		/// <summary>
		/// Query the database for the most launched items.
		/// </summary>
		/// <param name="numberOfItems">The number of items to be limited to, a negative number indicates unlimited.</param>
		public void MostLaunched(int numberOfItems)
		{
			//IEnumerable<ISearchData> results = _database.SelectMostLaunched(numberOfItems);
			SearchResults.Clear();
			foreach (ISearchData item in _database.SelectMostLaunched(numberOfItems))
				SearchResults.Add(item);
		}

		/// <summary>
		/// Start indexing the search locations.
		/// </summary>
		public void StartIndexing()
		{
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

		/// <summary>
		/// Setup a <see cref="FileSystemWatcher"/> for each <see cref="SearchLocation"/> to
		/// watch for Created and Deleted change events on all files and start indexing.
		/// </summary>
		private void SetupFileSystemWatchers()
		{
			foreach (SearchLocation location in _searchLocations)
			{
				FileSystemWatcher watcher = new FileSystemWatcher();
				watcher.Path = Helpers.ParseEnvironmentVars(location.SearchPath);
				watcher.IncludeSubdirectories = true;
				watcher.NotifyFilter = NotifyFilters.FileName | NotifyFilters.DirectoryName;

				watcher.Created += (sender, args) =>
				{
					if (!IsIndexing)
						StartIndexing();
				};

				watcher.Deleted += (sender, args) =>
				{
					if (!IsIndexing)
						StartIndexing();
				};

				watcher.EnableRaisingEvents = true;

				_watchers.Add(watcher);
			}
		}

		private List<SearchLocation> _searchLocations;
		private ObservableCollection<ISearchData> _searchResults;
		private SharpSearchDatabase _database;
		private BackgroundWorker _indexWorker;
		private List<FileSystemWatcher> _watchers;

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
			foreach (FileSystemWatcher watcher in _watchers)
				watcher.Dispose();

			if (_indexWorker != null) _indexWorker.Dispose();
			if (_database != null) _database.Dispose();
		}

		#endregion IDisposable Members
	}
}
