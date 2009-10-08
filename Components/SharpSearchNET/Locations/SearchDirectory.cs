using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Text;
using System.Diagnostics;
using System.Runtime.InteropServices;
using SharpLinkLauncherNET.Interop;
using System.Threading;
using System.Data.SQLite;

namespace SharpSearchNET.Locations
{
    public class SearchDirectory : ISearchLocation
    {
        string name;
        string description;
        string path;
        string searchQuery;

        string tableID = "dir0";
        EventWaitHandle waitHandle = null;
        EventWaitHandle waiting = new EventWaitHandle(true, EventResetMode.ManualReset);
        bool isWaiting = true;

        public string Name
        {
            get { return name; }
        }

        public string Description
        {
            get { return description; }
        }

        public void DoDatabaseSearch(string query, List<SearchResult> list, ISearchCallback searchCallback, SQLiteConnection sqlConnection)
        {
            isWaiting = false;

            if (sqlConnection == null)
                return;

            using (SQLiteCommand sqlCommand = sqlConnection.CreateCommand())
            {
                sqlCommand.CommandText = "CREATE TABLE IF NOT EXISTS " + tableID + "(filename STRING(256), description STRING(512), location STRING(1024), flag BOOLEAN);";
                sqlCommand.ExecuteNonQuery();
 
                sqlCommand.CommandText = "SELECT ROWID, filename, description, location FROM " + tableID + " WHERE filename LIKE '%" + query + "%' OR description LIKE '%" + query + "%';";
                using (SQLiteDataReader sqlReader = sqlCommand.ExecuteReader())
                {
                    while (sqlReader.Read())
                    {
                        // Check if thread should wait
                        if (waitHandle != null)
                        {
                            isWaiting = true;
                            waiting.Set();
                            waitHandle.WaitOne();
                            waitHandle = null;
                            isWaiting = false;
                            sqlReader.Close();
                            DoDatabaseSearch(searchQuery, list, searchCallback, sqlConnection);
                            return;
                        }

                        Int64 rowID = sqlReader.GetInt64(0);
                        string fileName = sqlReader.GetString(1);
                        string fileDescription = sqlReader.GetString(2);
                        string fileLocation = sqlReader.GetString(3);
                        if (File.Exists(fileLocation))
                        {
                            SearchResult item = new SearchResult(Path.GetFileNameWithoutExtension(fileName), fileDescription, fileLocation);
                            list.Add(item);
                            if (searchCallback != null)
                                searchCallback.NewResult(item);
                        }
                        else
                        {
                            using (SQLiteCommand sqlCommand2 = sqlConnection.CreateCommand())
                            {
                                sqlCommand.CommandText = "DELETE FROM + " + tableID + " WHERE ROWID=" + rowID + ";";
                                sqlCommand.ExecuteNonQuery();
                            }
                        }
                    }
                    sqlReader.Close();
                }
            }

            isWaiting = true;
            waiting.Set();
        }

        public void DoSearch(string query, List<SearchResult> list, ISearchCallback searchCallback, SQLiteConnection sqlConnection)
        {
            isWaiting = false;

            searchQuery = query.ToLower();
            if (!Directory.Exists(path))
                return;

            SQLiteTransaction sqlTransaction = null;

            // set all flags to 0
            if (sqlConnection != null)
            {
                sqlTransaction = sqlConnection.BeginTransaction();

                using (SQLiteCommand sqlCommand = sqlConnection.CreateCommand())
                {
                    sqlCommand.CommandText = "UPDATE " + tableID + " SET flag=0;";
                    sqlCommand.ExecuteNonQuery();
                }
            }    

            Stack<string> stack = new Stack<string>();
            List<string> files = new List<string>();
            stack.Push(path);

            while (stack.Count > 0)
            {
                string currentDirectory = stack.Pop();

                try
                {
                    files.Clear();
                    files.AddRange(Directory.GetFiles(currentDirectory, "*.exe"));
                    files.AddRange(Directory.GetFiles(currentDirectory, "*.lnk"));
                    foreach (string file in files) 
                    {
                        try
                        {
                            // Check if thread should wait
                            if (waitHandle != null)
                            {
                                isWaiting = true;
                                waiting.Set();
                                waitHandle.WaitOne();
                                waitHandle = null;
                                isWaiting = false;
                            }

                            if ((File.GetAttributes(file) & FileAttributes.Hidden) != FileAttributes.Hidden)
                            {
                                string fileName = Path.GetFileName(file);
                                string filePath = file;

                                if (Path.GetExtension(filePath).CompareTo(".lnk") == 0) 
                                {   // Resolve if it's a shortcut
                                    string resolvedFilePath = COM.ResolveShortcut(filePath);
                                    if (File.Exists(resolvedFilePath))
                                    {   // Resolved Path seems valid, use it instead
                                        filePath = resolvedFilePath;
                                    }
                                }
                                FileVersionInfo info = FileVersionInfo.GetVersionInfo(filePath);

                                // update database
                                if (sqlConnection != null)
                                {
                                    using (SQLiteCommand sqlCommand = sqlConnection.CreateCommand())
                                    {
                                        sqlCommand.CommandText = "SELECT ROWID FROM " + tableID + " WHERE location='" + file + "';";
                                        using (SQLiteDataReader sqlReader = sqlCommand.ExecuteReader())
                                        {
                                            if (sqlReader.HasRows)
                                            {
                                                // set flag to 1
                                                sqlReader.Read();
                                                Int64 rowID = sqlReader.GetInt64(0);
                                                using (SQLiteCommand sqlCommand2 = sqlConnection.CreateCommand())
                                                {
                                                    sqlCommand2.CommandText = "UPDATE " + tableID + " SET flag=1 WHERE ROWID=" + rowID + ";";
                                                    sqlCommand2.ExecuteNonQuery();
                                                }
                                                sqlReader.Close();
                                            }
                                            else
                                            {
                                                using (SQLiteCommand sqlCommand2 = sqlConnection.CreateCommand())
                                                {
                                                    sqlCommand2.CommandText = "INSERT INTO " + tableID + " VALUES('" + Path.GetFileNameWithoutExtension(fileName) + "','" + info.FileDescription + "','" + file + "',1)";
                                                    sqlCommand2.ExecuteNonQuery();
                                                }
                                            }
                                        }
                                    }                                    
                                }

                                if ((fileName.ToLower().Contains(searchQuery)) || info.FileDescription.ToLower().Contains(searchQuery))
                                {   // Search if filename or filedescription contain the search query
                                    SearchResult item = new SearchResult(Path.GetFileNameWithoutExtension(fileName), info.FileDescription, file);
                                    bool found = false;
                                    foreach (SearchResult result in list)
                                    {
                                        if (result.Location.Equals(file))
                                        {
                                            found = true;
                                            break;
                                        }

                                    }
                                    if (!found)
                                    {
                                        list.Add(item);
                                        if (searchCallback != null)
                                            searchCallback.NewResult(item);
                                    }
                                }                           
                            }
                        }
                        catch
                        {
                            // Error opening file
                        }
                    }

                    foreach (string dir in Directory.GetDirectories(currentDirectory))
                    {
                        stack.Push(dir);
                    }
                }
                catch
                {
                    // Error when opening directory (acccess rights, etc.)
                }
            }

            // Delete all items from the database which still have a flag of 0 
            if (sqlConnection != null)
            {
                using (SQLiteCommand sqlCommand = sqlConnection.CreateCommand())
                {
                    sqlCommand.CommandText = "DELETE FROM " + tableID + " WHERE flag=0;";
                    sqlCommand.ExecuteNonQuery();
                }

                sqlTransaction.Commit();
            }

            isWaiting = true;
            waiting.Set();
        }

        [DllImport("shell32.dll")]
        static extern bool SHGetSpecialFolderPath(IntPtr hwndOwner, StringBuilder lpszPath, CSIDL nFolder, bool fCreate);

        enum CSIDL
        {
            COMMON_STARTMENU = 0x0016,
            COMMON_DESKTOPDIRECTORY = 0x0019
        }

        public static string ParseEnvironmentVars(string input)
        {
            StringBuilder allUsersStartMenu = new StringBuilder(255);
            StringBuilder allUsersDesktop = new StringBuilder(255);
            SHGetSpecialFolderPath(IntPtr.Zero, allUsersStartMenu, CSIDL.COMMON_STARTMENU, false);
            SHGetSpecialFolderPath(IntPtr.Zero, allUsersDesktop, CSIDL.COMMON_DESKTOPDIRECTORY, false);
         
            input = input.Replace("{UserStartMenu}",Environment.GetFolderPath(Environment.SpecialFolder.StartMenu));
            input = input.Replace("{UserDesktop}", Environment.GetFolderPath(Environment.SpecialFolder.Desktop));
            input = input.Replace("{AllUsersStartMenu}", allUsersStartMenu.ToString());
            input = input.Replace("{AllUsersDestop}", allUsersDesktop.ToString());
            

            return input;
        }

        public SearchDirectory(string name, string description, string path, string tableID)
        {
            this.name = name;
            this.description = description;
            this.path = ParseEnvironmentVars(path);
            this.tableID = tableID;
        }

        public string SearchQuery
        {
            get { return searchQuery; }
            set { searchQuery = value; }
        }

        public EventWaitHandle Waiting
        {
            get { return waiting; }
        }

        public bool IsWaiting
        {
            get { return isWaiting; }
        }

        public void FilterList(List<SearchResult> list, ISearchCallback searchCallback)
        {
            searchQuery = searchQuery.ToLower();
            List<SearchResult> remove = new List<SearchResult>();   
            foreach (SearchResult searchResult in list)
            {
                if ((!searchResult.Name.ToLower().Contains(searchQuery)) && (!searchResult.Description.ToLower().Contains(searchQuery)))
                    remove.Add(searchResult);
            }
            foreach (SearchResult searchResult in remove)
            {
                list.Remove(searchResult);
                if (searchCallback != null)
                    searchCallback.RemoveResult(searchResult);
            }
        }

        public void LockThread(EventWaitHandle ewh)
        {
            waiting.Reset();
            waitHandle = ewh;
        }

        public void UnlockThread()
        {
            waitHandle = null;
            waiting.Set();
        }
    }
}
