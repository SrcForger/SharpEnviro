using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using SharpSearchNET.Locations;
using System.Threading;
using System.Data.SQLite;

namespace SharpSearchNET
{
    public class SearchManager
    {
        public List<ISearchLocation> Locations;
        public SQLiteConnection SqlConnection;

        public static Object HoldForQueryUpdate = "";

        void LoadDatabase()
        {
            string databaseFile = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            databaseFile = databaseFile + "\\Settings\\User\\" + Environment.UserName + "\\Search\\Database.db3";

            string connectionString = "Data Source=" + databaseFile;
            connectionString = connectionString + ";Pooling=true;FailIfMissing=false";

            try
            {
                SqlConnection = new SQLiteConnection(connectionString);
                SqlConnection.Open();
            }
            catch
            {
                Environment.Exit((int)ExitCode.DatabaseConnectionFailed);
            }
        }
        
        void LoadLocations()
        {
            Locations.Clear();
            string settingsFile = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            settingsFile = settingsFile + "\\Settings\\User\\" + Environment.UserName + "\\Search\\Locations.xml";
            bool validSettingsFile = false;

            if (System.IO.File.Exists(settingsFile))
            {
				// load settings if file exists
                XmlDocument xml = new XmlDocument();
                try
                {
                    xml.Load(settingsFile);
                    XmlNodeList xmlLocations = xml.GetElementsByTagName("location");
                    foreach (XmlNode xmlNode in xmlLocations)
                    {
                        if ((xmlNode.Attributes["Name"] != null) && (xmlNode.Attributes["Description"] != null) && (xmlNode.Attributes["Type"] != null))
                        {
                            switch (xmlNode.Attributes["Type"].Value)
                            {
                                case "Directory":
                                    if (xmlNode.Attributes["Path"] != null)
                                    {             
                                        string tableID = "dir0";
                                        if (xmlNode.Attributes["TableID"] != null)
                                            tableID = xmlNode.Attributes["TableID"].Value;
                                        SearchDirectory item = new SearchDirectory(xmlNode.Attributes["Name"].Value,
                                                                                   xmlNode.Attributes["Description"].Value,
                                                                                   xmlNode.Attributes["Path"].Value,
                                                                                   tableID);
                                        Locations.Add(item);
                                    }
                                    break;
                            }
                        }
                    }
                    validSettingsFile = true;
                }
                catch
                {
                    
                }                
            } 

            if (!validSettingsFile) 
            {
				// settings file doesn't exist or there was an error reading it, use default values
                Locations.Clear();
                SearchDirectory item = new SearchDirectory("Start Menu",
                                                           "Windows Start Menu",
                                                           "{AllUsersStartMenu}",
                                                           "dir1");
                Locations.Add(item);
                item = new SearchDirectory("Start Menu",
                                           "Windows Start Menu",
                                           "{UserStartMenu}",
                                           "dir2");
                Locations.Add(item);
            }
        }

        // The reason why Database search and normal search are seperated is because the database search will in most cases be
        // significantly faster. For all search locations a quick database search will be done first. The normal search of each
        // search location will be started after all database searches are done
        public void DoDatabaseSearch(string query, List<SearchResult> list, ISearchCallback searchCallback)
        {
            // set the search query for all targets before starting the search (it might change while searching!)
            foreach (ISearchLocation searchLocation in Locations)
                searchLocation.SearchQuery = query;

            foreach (ISearchLocation searchLocation in Locations)
            {
                if (searchCallback != null)
                    searchCallback.StartLocation(searchLocation);
                searchLocation.DoDatabaseSearch(searchLocation.SearchQuery, list, searchCallback, SqlConnection);
                if (searchCallback != null)
                    searchCallback.FinishLocation(searchLocation);
            }

            if (searchCallback != null)
                searchCallback.FinishSearch();
        }

        public void DoSearch(string query, List<SearchResult> list, ISearchCallback searchCallback)
        {
            // set the search query for all targets before starting the search (it might change while searching!)
            foreach (ISearchLocation searchLocation in Locations)
                searchLocation.SearchQuery = query;

            foreach (ISearchLocation searchLocation in Locations)
            {
                if (searchCallback != null)
                    searchCallback.StartLocation(searchLocation);
                searchLocation.DoSearch(searchLocation.SearchQuery, list, searchCallback, SqlConnection);
                if (searchCallback != null)
                    searchCallback.FinishLocation(searchLocation);
            }

            if (searchCallback != null)
                searchCallback.FinishSearch();
        }

        public void UpdateSearch(string newQuery, List<SearchResult> list, ISearchCallback searchCallback)
        {
            EventWaitHandle ewh = new EventWaitHandle(false, EventResetMode.ManualReset);

            foreach (ISearchLocation searchLocation in Locations)
            {
                searchLocation.LockThread(ewh);
                searchLocation.SearchQuery = newQuery;
            }

            // wait for all possibly running search locations to stop
            foreach (ISearchLocation searchLocation in Locations)
            {
                if (!searchLocation.IsWaiting)
                    searchLocation.Waiting.WaitOne();
            }

            foreach (ISearchLocation searchLocation in Locations)
                searchLocation.FilterList(list, searchCallback);

            ewh.Set();
            foreach (ISearchLocation searchLocation in Locations)
            {
                searchLocation.UnlockThread();
            }
        }

        ~SearchManager()
        {
            if (SqlConnection != null)
                SqlConnection.Close();
        }

        public SearchManager()
        {
            Locations = new List<ISearchLocation>();
            LoadLocations();
            LoadDatabase();
        }
    }
}
