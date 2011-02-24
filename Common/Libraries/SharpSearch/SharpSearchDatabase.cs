using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Reflection;
using System.Data.SQLite;
using System.Diagnostics;

using SharpEnviro;
using SharpEnviro.Interop;
using System.ComponentModel;

namespace SharpSearch
{
	/// <summary>
	/// A database for storing indexed items for searching.
	/// </summary>
	public class SharpSearchDatabase 
		: IDisposable
	{
		#region Constructors

		/// <summary>
		/// Creates a new database using the <see cref="DefaultDatabaseDirectory"/> and <see cref="DefaultDatabaseFilename"/>.
		/// </summary>
		public SharpSearchDatabase()
			: this(Path.Combine(DefaultDatabaseDirectory, DefaultDatabaseFilename))
		{
		}

		/// <summary>
		/// Creates a new database instance using the supplied path.
		/// </summary>
		/// <param name="databaseFilePath">The full path to the database file.</param>
		public SharpSearchDatabase(string databaseFilePath)
		{
            SharpDebug.Info("SharpSearch", "Using database: " + databaseFilePath);
            try
            {
                Directory.CreateDirectory(Path.GetDirectoryName(databaseFilePath));
            }
            catch (Exception e)
            {
                SharpDebug.Exception("SharpSearch", "Could not create database directory", e);
            }

			_fullPath = databaseFilePath;

            try
            {
                _database = new SQLiteDatabase(databaseFilePath);
            }
            catch (Exception e)
            {
                SharpDebug.Exception("SharpSearch", "Exception in SQLiteDatabase constructor", e);
            }

			InitializeDatabase();
		}

		#endregion Constructors

		#region publics

		/// <summary>
		/// The default directory where the database should be created.
		/// </summary>
		public static string DefaultDatabaseDirectory
		{
			get
			{
				return Path.Combine(SharpSettings.UserSettingsPath, "Search");
			}
		}

		/// <summary>
		/// The default database filename to use when creating a new database.
		/// </summary>
		public static string DefaultDatabaseFilename = "SharpSearchDatabase.db3";

		public string FullPath
		{
			get { return _fullPath; }
		}

        /// <summary>
        /// Checks if the current search database is valid
        /// </summary>
        /// <returns>Database validity.</returns>
        public bool IsValid()
        {
            string query = String.Format("SELECT ROWID, * FROM [{0}] ORDER BY LaunchCount DESC;", _tableName);
            using (SQLiteDataReader reader = _database.ExecuteReader(query))
            {
                if (reader.Read())
                    return true;
            }

            return false;
        }

		/// <summary>
		/// Search the database for entries matching the specified pattern.
		/// </summary>
		/// <param name="searchPattern">The pattern to match against.</param>
		/// <returns>A collection of <see cref="ISearchData"/> items that matched the search pattern.</returns>
		public IEnumerable<ISearchData> Search(string searchPattern)
		{
			//List<ISearchData> results = new List<ISearchData>();
			string query = String.Format("SELECT ROWID, * FROM [{0}] WHERE Filename LIKE '%{1}%' OR Description LIKE '%{1}%' ORDER BY LaunchCount DESC;", _tableName, searchPattern);
			using (SQLiteDataReader reader = _database.ExecuteReader(query))
			{
				while(reader.Read())
				{
					Int64 rowID = (Int64)reader["ROWID"];
					string filename = reader["Filename"] != DBNull.Value ? (string)reader["Filename"] : null;
					string description = reader["Description"] != DBNull.Value ? (string)reader["Description"] : null;
					string location = reader["Location"] != DBNull.Value ? (string)reader["Location"] : null;
                    string shortcut = reader["Shortcut"] != DBNull.Value ? (string)reader["Shortcut"] : null; 
					Int64 launchCount = reader["LaunchCount"] != DBNull.Value ? (Int64)reader["LaunchCount"] : 0;

                    if ((File.Exists(location)) || (Directory.Exists(location)))
                    {
                        yield return new SearchData
                        {
                            RowID = rowID,
                            Filename = filename,
                            Description = description,
                            Location = location,
                            Shortcut = shortcut,
                            LaunchCount = launchCount
                        };
					}
				}
			}
		}

		/// <summary>
		/// Select the most launched items.
		/// </summary>
		/// <param name="numberOfItems">The number of items to be limited to, a negative number indicates unlimited.</param>
		/// <returns>A collection of <see cref="ISearchData"/> items listed descendingly with a max of <see cref="numberOfItems"/>.</returns>
		public IEnumerable<ISearchData> SelectMostLaunched(int numberOfItems)
		{
			//List<ISearchData> results = new List<ISearchData>();
			string query = String.Format("SELECT ROWID, * FROM [{0}] ORDER BY LaunchCount DESC LIMIT {1}", _tableName, numberOfItems);
			using (SQLiteDataReader reader = _database.ExecuteReader(query))
			{
				while (reader.Read())
				{
					Int64 rowID = (Int64)reader["ROWID"];
					string filename = reader["Filename"] != DBNull.Value ? (string)reader["Filename"] : null;
					string description = reader["Description"] != DBNull.Value ? (string)reader["Description"] : null;
					string location = reader["Location"] != DBNull.Value ? (string)reader["Location"] : null;
                    string shortcut = reader["Shortcut"] != DBNull.Value ? (string)reader["Shortcut"] : null;
					Int64 launchCount = reader["LaunchCount"] != DBNull.Value ? (Int64)reader["LaunchCount"] : 0;

					if ((File.Exists(location)) || (Directory.Exists(location)))
					{
						yield return new SearchData
						{
							RowID = rowID,
							Filename = filename,
							Description = description,
							Location = location,
                            Shortcut = shortcut,
							LaunchCount = launchCount
						};
					}
				}
			}
		}

		/// <summary>
		/// Indexes the locations by synchronizing the database with each location.
		/// </summary>
		/// <param name="locations"></param>
		public void IndexDirectories(params string[] directories)
		{
			ClearSychronizedFlags();

			foreach (string directory in directories)
				IndexDirectory(directory);

			DeleteUnsynchronizedEntries();
		}

		/// <summary>
		/// Indexes the locations by synchronizing the database with each location.
		/// </summary>
		/// <param name="locations"></param>
		public void IndexDirectories(params SearchLocation[] locations)
		{
			ClearSychronizedFlags();

			foreach (SearchLocation location in locations)
				IndexDirectory(location.SearchPath);

			DeleteUnsynchronizedEntries();
		}

		/// <summary>
		/// Increment the rows launch count.
		/// </summary>
		/// <param name="rowID">The ROWID for which to increment the LaunchCount.</param>
		public void IncrementLaunchCount(Int64 rowID)
		{
			_database.ExecuteNonQuery(String.Format("UPDATE [{0}] SET LaunchCount=LaunchCount+1 WHERE ROWID=@rowID;", _tableName), new SQLiteParameter("@rowID", rowID));
		}

        /// <summary>
        /// Recursive search a directory and add all files to a list of files.
        /// </summary>
        /// <param name="searchDir">The directory to search</param>
        /// <param name="searchPattern">Search pattern</param>
        /// <param name="dstFileArray">Array where to add the files to</param>
        private void DirSearch(string searchDir, string searchPattern, List<string> dstFileArray)
        {
            string[] dirList = System.IO.Directory.GetDirectories(searchDir);
            foreach (string iDir in dirList)
            {
                try
                {
                   string[] fileList = System.IO.Directory.GetFiles(iDir, searchPattern, SearchOption.TopDirectoryOnly);
                   dstFileArray.AddRange(fileList);
                   DirSearch(iDir, searchPattern, dstFileArray);
                }
                catch
                {
                    // catch UnauthorizedAccessException and continue with the next directory
                }                
            }
        }

		/// <summary>
		/// Indexes a directory by searching for *.exe and *.lnk and inserting or updating rows in the database.
		/// </summary>
		/// <param name="directory">The directory to be indexed.</param>
		private void IndexDirectory(string directory)
		{
			string expandedPath = Helpers.ParseEnvironmentVars(directory);

			if (!Directory.Exists(expandedPath))
				return;

			List<string> files = new List<string>();

            DirSearch(expandedPath, "*.exe", files);
            DirSearch(expandedPath, "*.lnk", files);            
   
			using (SQLiteTransaction transaction = _database.BeginTransaction())
			{
				try
				{
					foreach (string file in files)
					{
						FileInfo info = new FileInfo(file);

						if ((info.Attributes & FileAttributes.Hidden) == FileAttributes.Hidden)
							continue;

						FileVersionInfo versionInfo = FileVersionInfo.GetVersionInfo(file);

						string filename = Path.GetFileNameWithoutExtension(file);
						string description = !String.IsNullOrEmpty(versionInfo.Comments) ? versionInfo.Comments : versionInfo.FileDescription;

						string location = ResolvePath(file);
                        string shortcut = file;

						versionInfo = FileVersionInfo.GetVersionInfo(location);
						if (String.IsNullOrEmpty(description))
							description = !String.IsNullOrEmpty(versionInfo.Comments) ? versionInfo.Comments : versionInfo.FileDescription;

						Int64 rowID = GetRowID(location);

						if (rowID == Int64.MinValue)
							InsertLocation(filename, description, location, shortcut);
						else
							SetSynchronizedFlag(rowID);
					}

					transaction.Commit();
				}
				catch
				{
					transaction.Rollback();
				}
			}
		}

		/// <summary>
		/// Inserts the location into the database.
		/// </summary>
		/// <param name="filename"></param>
		/// <param name="description"></param>
		/// <param name="location"></param>
		private void InsertLocation(string filename, string description, string location, string shortcut)
		{
			_database.ExecuteNonQuery(String.Format("INSERT INTO [{0}] ([Filename], [Description], [Location], [Shortcut], [Flag], [LaunchCount]) VALUES (@filename, @description, @location, @shortcut, 1, 0);", _tableName),
					new SQLiteParameter("@filename", filename),
					new SQLiteParameter("@description", description),
					new SQLiteParameter("@location", location),
                    new SQLiteParameter("@shortcut", shortcut));
		}

		/// <summary>
		/// Gets the ROWID from the database for the file.
		/// </summary>
		/// <param name="file">The file to lookup its ROWID.</param>
		/// <returns>The ROWID if the file was found in the database otherwise <see cref="Int64.MinValue"/>.</returns>
		private Int64 GetRowID(string file)
		{
			object result = _database.ExecuteScalar(String.Format("SELECT ROWID FROM [{0}] WHERE location=@location;", _tableName), new SQLiteParameter("@location", file));

			if (result == null)
				return Int64.MinValue;
			else
				return (Int64)result;
		}

		/// <summary>
		/// Resolves the path from a shortcut (.lnk), if the path is not a shortcut then path is returned.
		/// </summary>
		/// <param name="path">The path to resolve.</param>
		/// <returns>The resolved path from the shortcut or the path passed in if it is not a shortcut or we could not resolve the path.</returns>
		private string ResolvePath(string path)
		{
			if (Path.GetExtension(path).ToLower() != ".lnk")
				return path;

			string resolvedPath = COM.ResolveShortcut(path);
			if (File.Exists(resolvedPath))
				return resolvedPath;
			else
				return path;
		}

		/// <summary>
		/// Set the sychronzied flag for the row so we don't delete it later.
		/// </summary>
		/// <param name="rowID"></param>
		private void SetSynchronizedFlag(Int64 rowID)
		{
			_database.TransactionalExecuteNonQuery(String.Format("UPDATE [{0}] SET Flag=1 WHERE ROWID=@rowID;", _tableName), new SQLiteParameter("@rowID", rowID));
		}

		/// <summary>
		/// Clear all the synchronized flags so we delete any that end up not being set later.
		/// </summary>
		private void ClearSychronizedFlags()
		{
			_database.TransactionalExecuteNonQuery(String.Format("UPDATE [{0}] SET Flag=0;", _tableName));
		}

		/// <summary>
		/// Delete any rows that have the synchronized flag unset which indicates it most likely does not exist.
		/// </summary>
		private void DeleteUnsynchronizedEntries()
		{
			_database.TransactionalExecuteNonQuery(String.Format("DELETE FROM [{0}] WHERE Flag=0;", _tableName));
		}

		#endregion publics

		#region privates

		/// <summary>
		/// Initializes the table(s) and index(es) if they do not exist.
		/// </summary>
		private void InitializeDatabase()
		{
			_database.CreateTable("SharpSearch", "Filename TEXT", "Description TEXT", "Location TEXT", "Shortcut TEXT", "Flag BOOLEAN", "LaunchCount INTEGER");
			//_database.CreateTable("SharpSearch", "Filename STRING(256)", "Description STRING(512)", "Location STRING(1024)", "Flag BOOLEAN");
			//_database.CreateIndex("SharpSearch", "IX_Filename_Description", "Filename", "Description");
		}

		private SQLiteDatabase _database;
		private string _tableName = "SharpSearch";
		private string _fullPath;

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
		/// <param name="disposing"></param>
		protected virtual void Dispose(bool disposing)
		{
			if (_database != null) _database.Dispose();
		}

		#endregion IDisposable Members
	}
}
