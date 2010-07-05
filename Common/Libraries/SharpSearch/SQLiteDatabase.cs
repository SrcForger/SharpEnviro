using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

using System.Data.SQLite;
using System.Reflection;

namespace SharpSearch
{
	/// <summary>
	/// A SQLite database for SharpSearch.
	/// </summary>
	public class SQLiteDatabase :
		IDisposable
	{
		#region Constructors

		/// <summary>
		/// Creates an instance of a SQLite datbase using the specified filename.
		/// </summary>
		/// <param name="databaseFilePath">The full path to the databse file.</param>
		public SQLiteDatabase(string databaseFilePath)
		{
			//if (!File.Exists(databaseFilePath))
			//    throw new FileNotFoundException("The database file could not be found.", databaseFilePath);

			_databaseFilePath = databaseFilePath;
			_connection = new SQLiteConnection(DatabaseConnectionString);
			_connection.Open();
		}

		#endregion Constructors

		#region publics

		/// <summary>
		/// The connection string used for the database.
		/// </summary>
		public string DatabaseConnectionString
		{
			get
			{
				return String.Format("Data Source={0};Pooling=true;FailIfMissing=false", _databaseFilePath);
			}
		}

		/// <summary>
		/// Creates a table if it does not exist.
		/// </summary>
		/// <param name="tableName">The name of the table to create.</param>
		/// <param name="fieldsAndTypes">The field names and their types (i.e. "myfield (STRING(256)").</param>
		/// <returns>The result from calling <see cref="SQLiteCommand.ExecuteNonQuery"/>.</returns>
		public int CreateTable(string tableName, params string[] fieldsAndTypes)
		{
			StringBuilder builder = new StringBuilder();
			
			builder.AppendFormat("CREATE TABLE IF NOT EXISTS [{0}] (", tableName);
			builder.Append(String.Join(",", fieldsAndTypes));
			builder.Append(");");

			using (SQLiteCommand command = _connection.CreateCommand())
			{
				command.CommandText = builder.ToString();
				int result = command.ExecuteNonQuery();
				return result;
			}
		}

		/// <summary>
		/// Creates a table if it does not exist wrapped in a <see cref="SQLiteTransaction"/>.
		/// </summary>
		/// <param name="tableName">The name of the table to create.</param>
		/// <param name="fieldsAndTypes">The field names and their types (i.e. "myfield (STRING(256)").</param>
		/// <returns>The result from calling <see cref="CreateTable"/>.</returns>
		public int TransactionalCreateTable(string tableName, params string[] fieldsAndTypes)
		{
			using (SQLiteTransaction transaction = _connection.BeginTransaction())
			{
				try
				{
					int result = CreateTable(tableName, fieldsAndTypes);
					transaction.Commit();
					return result;
				}
				catch
				{
					transaction.Rollback();
					throw;
				}
			}
		}

		/// <summary>
		/// Creates an index for a table on the fields specified.
		/// </summary>
		/// <param name="tableName">The table to create the index on.</param>
		/// <param name="indexName">The name of the index.</param>
		/// <param name="fields">The fields that will participate in the index.</param>
		/// <returns>The result from calling <see cref="SQLiteCommand.ExecuteNonQuery"/>.</returns>
		public int CreateIndex(string tableName, string indexName, params string[] fields)
		{
			StringBuilder builder = new StringBuilder();

			builder.AppendFormat("CREATE INDEX IF NOT EXISTS [{0}] ON [{1}] (", indexName, tableName);
			builder.Append(String.Join(",", fields));
			builder.Append(");");

			using (SQLiteCommand command = _connection.CreateCommand())
			{
				command.CommandText = builder.ToString();
				int result = command.ExecuteNonQuery();
				return result;
			}
		}

		/// <summary>
		/// Creates an index for a table on the fields specified wrapped in a <see cref="SQLiteTransaction"/>.
		/// </summary>
		/// <param name="tableName">The table to create the index on.</param>
		/// <param name="indexName">The name of the index.</param>
		/// <param name="fields">The fields that will participate in the index.</param>
		/// <returns>The result from <see cref="CreateIndex"/>.</returns>
		public int TransactionalCreateIndex(string tableName, string indexName, params string[] fields)
		{
			using (SQLiteTransaction transaction = _connection.BeginTransaction())
			{
				try
				{
					int result = CreateIndex(tableName, indexName, fields);
					transaction.Commit();
					return result;
				}
				catch
				{
					transaction.Rollback();
					throw;
				}
			}
		}

		/// <summary>
		/// Executes the sql command text using <see cref="SQLiteCommand.ExecuteReader"/>.
		/// </summary>
		/// <param name="commandText">The sql command text to execute.</param>
		/// <returns>A <see cref="SQLiteDataReader"/>.</returns>
		public SQLiteDataReader ExecuteReader(string commandText)
		{
			using (SQLiteCommand command = _connection.CreateCommand())
			{
				command.CommandText = commandText;
				return command.ExecuteReader();
			}
		}

		/// <summary>
		/// Executes the sql command text using <see cref="SQLiteCommand.ExecuteNonQuery"/>.
		/// </summary>
		/// <param name="commandText">The sql command text to execute.</param>
		/// <returns>The result from calling <see cref="SQLiteCommand.ExecuteNonQuery"/>.</returns>
		public int ExecuteNonQuery(string commandText)
		{
			int result = ExecuteNonQuery(commandText, new SQLiteParameter[] { });
			return result;
		}

		/// <summary>
		/// Executes the sql command text using <see cref="SQLiteCommand.ExecuteNonQuery"/>.
		/// </summary>
		/// <param name="commandText">The sql command text to execute.</param>
		/// <param name="parameters">Any prarameters needs for the query.</param>
		/// <returns>The result from calling <see cref="SQLiteCommand.ExecuteNonQuery"/>.</returns>
		public int ExecuteNonQuery(string commandText, params SQLiteParameter[] parameters)
		{
			using (SQLiteCommand command = _connection.CreateCommand())
			{
				foreach (SQLiteParameter parameter in parameters)
					command.Parameters.Add(parameter);

				command.CommandText = commandText;
				int result = command.ExecuteNonQuery();
				return result;
			}
		}

		/// <summary>
		/// Executes the sql command text wrapped in a <see cref="SQLiteTransaction"/>.
		/// </summary>
		/// <param name="commandText">The sql command text to execute.</param>
		/// <returns>The result from calling <see cref="ExecuteNonQuery"/>.</returns>
		public int TransactionalExecuteNonQuery(string commandText)
		{
			using (SQLiteTransaction transaction = _connection.BeginTransaction())
			{
				try
				{
					int result = ExecuteNonQuery(commandText);
					transaction.Commit();
					return result;
				}
				catch
				{
					transaction.Rollback();
					throw;
				}
			}
		}

		/// <summary>
		/// Executes the sql command text wrapped in a <see cref="SQLiteTransaction"/>.
		/// </summary>
		/// <param name="commandText">The sql command text to execute.</param>
		/// <param name="parameters">Any prarameters needs for the query.</param>
		/// <returns>The result from calling <see cref="ExecuteNonQuery"/>.</returns>
		public int TransactionalExecuteNonQuery(string commandText, params SQLiteParameter[] parameters)
		{
			using (SQLiteTransaction transaction = _connection.BeginTransaction())
			{
				try
				{
					int result = ExecuteNonQuery(commandText, parameters);
					transaction.Commit();
					return result;
				}
				catch
				{
					transaction.Rollback();
					throw;
				}
			}
		}

		public object ExecuteScalar(string commandText, params SQLiteParameter[] parameters)
		{
			using (SQLiteCommand command = _connection.CreateCommand())
			{
				foreach (SQLiteParameter parameter in parameters)
					command.Parameters.Add(parameter);

				command.CommandText = commandText;

				object result = command.ExecuteScalar();
				return result;
			}
		}

		/// <summary>
		/// Start a transaction with the current open connection.
		/// </summary>
		/// <returns>A <see cref="SQLiteTransaction"/> that will allow you to Commit or Rollback the transaction.</returns>
		public SQLiteTransaction BeginTransaction()
		{
			return _connection.BeginTransaction();
		}

		#endregion publics

		#region privates

		private string _databaseFilePath;
		private SQLiteConnection _connection;

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
			if (_connection != null) _connection.Dispose();
		}

		#endregion IDisposable Members
	}
}
