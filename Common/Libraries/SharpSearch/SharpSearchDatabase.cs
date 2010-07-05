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
			_fullPath = databaseFilePath;
			_database = new SQLiteDatabase(databaseFilePath);

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
		/// Search the database for entries matching the specified pattern.
		/// </summary>
		/// <param name="searchPattern">The pattern to match against.</param>
		/// <returns>A collection of <see cref="ISearchData"/> items that matched the search pattern.</returns>
		public IEnumerable<ISearchData> Search(string searchPattern)
		{
			List<ISearchData> results = new List<ISearchData>();
			string query = String.Format("SELECT Filename, Description, Location FROM [{0}] WHERE Filename LIKE '%{1}%' OR Description LIKE '%{1}%';", _tableName, searchPattern);
			using (SQLiteDataReader reader = _database.ExecuteReader(query))
			{
				while(reader.Read())
				{
					string filename = reader["Filename"] != DBNull.Value ? (string)reader["Filename"] : null;
					string description = reader["Description"] != DBNull.Value ? (string)reader["Description"] : null;
					string location = reader["Location"] != DBNull.Value ? (string)reader["Location"] : null;

					yield return new SearchData(filename, description, location);
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
		/// Indexes a directory by searching for *.exe and *.lnk and inserting or updating rows in the database.
		/// </summary>
		/// <param name="directory">The directory to be indexed.</param>
		private void IndexDirectory(string directory)
		{
			string expandedPath = Helpers.ParseEnvironmentVars(directory);

			if (!Directory.Exists(expandedPath))
				return;

			List<string> files = new List<string>();

			files.AddRange(Directory.GetFiles(expandedPath, "*.exe", SearchOption.AllDirectories));
			files.AddRange(Directory.GetFiles(expandedPath, "*.lnk", SearchOption.AllDirectories));

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

						versionInfo = FileVersionInfo.GetVersionInfo(location);
						if (String.IsNullOrEmpty(description))
							description = !String.IsNullOrEmpty(versionInfo.Comments) ? versionInfo.Comments : versionInfo.FileDescription;

						Int64 rowID = GetRowID(location);

						if (rowID == Int64.MinValue)
							InsertLocation(filename, description, location);
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
		private void InsertLocation(string filename, string description, string location)
		{
			_database.ExecuteNonQuery(String.Format("INSERT INTO [{0}] ([Filename], [Description], [Location], [Flag]) VALUES (@filename, @description, @location, 1);", _tableName),
					new SQLiteParameter("@filename", filename),
					new SQLiteParameter("@description", description),
					new SQLiteParameter("@location", location));
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
			_database.CreateTable("SharpSearch", "Filename TEXT", "Description TEXT", "Location TEXT", "Flag BOOLEAN");
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
